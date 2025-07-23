# SRTP to Modbus Gateway - Implementation Plan

## 1. Project Structure
```
CS_GESRTP/
├── CS_GESRTP.Core/           # Core logic and models
│   ├── PlcClient.cs         # SRTP client implementation
│   ├── ModbusServer.cs      # Modbus TCP server wrapper
│   ├── MappingService.cs    # Register mapping logic
│   └── Models/
│       ├── Mapping.cs       # Mapping configuration
│       └── PlcRegister.cs   # PLC register model
├── CS_GESRTP.GUI/           # WPF Application
│   ├── ViewModels/          # MVVM ViewModels
│   ├── Views/               # XAML views
│   └── Converters/          # Value converters
└── CS_GESRTP.sln            # Solution file
```

## 2. Implementation Phases

### Phase 1: Core Components
- [ ] Create solution and project structure
- [ ] Implement `PlcClient` for SRTP communication
- [ ] Set up `ModbusServer` using EasyModbusTCP
- [ ] Create data models for mappings and registers

### Phase 2: WPF GUI (MVVM)
- [ ] Set up WPF project with MVVM pattern
- [ ] Install required NuGet packages:
  ```
  Install-Package CommunityToolkit.Mvvm
  Install-Package MaterialDesignThemes
  Install-Package PropertyChanged.Fody
  ```
- [ ] Create main window with navigation
- [ ] Design mapping configuration view
- [ ] Add real-time monitoring view
- [ ] Implement settings and connection management

### Phase 3: Mapping Service
- [ ] Create `MappingService` class
- [ ] Implement bidirectional register mapping
- [ ] Add data type conversion support
- [ ] Implement polling mechanism
- [ ] Add error handling and logging

### Phase 4: Integration & Testing
- [ ] Connect all components
- [ ] Implement unit tests
- [ ] Add integration tests
- [ ] Performance testing
- [ ] UI/UX refinement

## 3. Key Components

### 3.1 Modbus Server Configuration
```csharp
public class ModbusServer : IDisposable
{
    private ModbusTcpServer _server;
    
    public ModbusServer(int port = 502)
    {
        _server = new ModbusTcpServer();
        _server.Port = port;
        _server.ListenAsync();
    }
    
    public ushort[] HoldingRegisters => _server.HoldingRegisters;
    
    public void Dispose()
    {
        _server?.Dispose();
    }
}
```

### 3.2 Register Mapping
```csharp
public class RegisterMapping
{
    public string Name { get; set; }
    public string Description { get; set; }
    
    // PLC Connection
    public string PlcAddress { get; set; }  // e.g., "%R1"
    public int PlcRegister { get; set; }
    
    // Modbus Connection
    public int ModbusAddress { get; set; }  // 0-based
    public ModbusRegisterType RegisterType { get; set; }
    
    // Data Type
    public DataType DataType { get; set; }
    public double ScaleFactor { get; set; } = 1.0;
    public double Offset { get; set; } = 0.0;
    
    // Status
    public DateTime LastUpdated { get; set; }
    public string LastError { get; set; }
}
```

### 3.3 Mapping Service
```csharp
public class MappingService
{
    private readonly PlcClient _plcClient;
    private readonly ModbusServer _modbusServer;
    private readonly List<RegisterMapping> _mappings;
    private Timer _pollingTimer;
    
    public MappingService(PlcClient plcClient, ModbusServer modbusServer)
    {
        _plcClient = plcClient;
        _modbusServer = modbusServer;
        _mappings = new List<RegisterMapping>();
        
        // Configure polling (e.g., every 100ms)
        _pollingTimer = new Timer(PollRegisters, null, 1000, 100);
    }
    
    private async void PollRegisters(object state)
    {
        foreach (var mapping in _mappings)
        {
            try
            {
                // Read from PLC and update Modbus
                var value = await _plcClient.ReadRegisterAsync(mapping.PlcRegister);
                _modbusServer.HoldingRegisters[mapping.ModbusAddress] = value;
                
                // Handle write-back if needed
                // ...
                
                mapping.LastUpdated = DateTime.Now;
            }
            catch (Exception ex)
            {
                mapping.LastError = ex.Message;
                // Log error
            }
        }
    }
    
    public void AddMapping(RegisterMapping mapping)
    {
        _mappings.Add(mapping);
    }
    
    public void RemoveMapping(RegisterMapping mapping)
    {
        _mappings.Remove(mapping);
    }
}
```

## 4. Next Steps

1. Set up the solution structure
2. Implement core components (PlcClient, ModbusServer)
3. Create basic WPF shell with MVVM
4. Implement mapping configuration UI
5. Add real-time monitoring
6. Test with actual PLC and Modbus clients

## 5. Dependencies

- .NET 8.0
- CommunityToolkit.Mvvm
- EasyModbusTCP
- MaterialDesignThemes (for UI)
- PropertyChanged.Fody (for MVVM)
