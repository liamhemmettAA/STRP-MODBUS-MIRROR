# SRTP PLC Communication Client

A C# .NET 8 application for communicating with PLCs using the SRTP (Schneider Electric Real-Time Protocol).

## Features

- Connect to a PLC via TCP/IP
- Read multiple registers (%R) from the PLC
- Write values to multiple registers
- Asynchronous operations for non-blocking UI

## Prerequisites

- [.NET 8.0 SDK](https://dotnet.microsoft.com/download/dotnet/8.0) or later
- A Schneider Electric PLC with SRTP protocol support
- Network access to the PLC

## Installation

1. Clone this repository
2. Navigate to the project directory:
   ```bash
   cd CS_GESRTP
   ```
3. Restore dependencies:
   ```bash
   dotnet restore
   ```

## Configuration

Edit the `Program.cs` file to set your PLC's IP address:

```csharp
using (var plc = new PlcClient("127.1.0.1"))  // Replace with your PLC's IP address
{
    // ...
}
```

## Usage

### Basic Example

```csharp
using (var plc = new PlcClient("192.168.1.100"))
{
    if (await plc.ConnectAsync())
    {
        // Read a single register
        ushort[] value = await plc.ReadRegistersAsync(1, 1);
        Console.WriteLine($"Value of %R1: {value[0]}");
        
        // Write to a register
        ushort[] valuesToWrite = { 123 };
        bool success = await plc.WriteRegistersAsync(1, valuesToWrite);
    }
}
```

### Reading Multiple Registers

```csharp
// Read 10 registers starting at %R1
ushort[] values = await plc.ReadRegistersAsync(1, 10);
for (int i = 0; i < values.Length; i++)
{
    Console.WriteLine($"%R{i+1}: {values[i]}");
}
```

### Writing Multiple Registers

```csharp
// Write values to registers starting at %R10
ushort[] valuesToWrite = { 100, 200, 300 };
bool success = await plc.WriteRegistersAsync(10, valuesToWrite);
```

## Error Handling

All methods throw exceptions for network-related errors. Check the `bool` return value for write operations:

```csharp
if (!await plc.WriteRegistersAsync(1, new ushort[] { 42 }))
{
    Console.WriteLine("Failed to write to PLC");
}
```

## Building and Running

```bash
dotnet build
dotnet run
```

## Troubleshooting

- **Connection Issues**:
  - Verify the PLC's IP address and network connectivity
  - Check if the PLC's SRTP port (default: 18245) is open
  - Ensure no firewall is blocking the connection

- **Permission Issues**:
  - Verify the PLC is configured to allow SRTP connections
  - Check if any authentication is required

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
