(* AUTOGEN MAPPINGS *)
ICH01_POS := R01001; (* CH01 Chute deployed position *)
IRL_BIN_LVL := R01002; (* Bin level *)
V_PR_AI0003 := R01003; (*  *)
ITLO_IN_RADAR := R01004; (* TLO Inbound Radar *)
ILT002 := R01005; (*  *)
ILT003 := R01006; (*  *)
V_PR_AI0007 := R01007; (*  *)
V_PR_AI0008 := R01008; (*  *)
IJOY_POSN := R01009; (*  *)
V_PR_AI0010 := R01010; (*  *)
V_PR_AI0011 := R01011; (*  *)
V_PR_AI0012 := R01012; (*  *)
V_PR_AI0013 := R01013; (*  *)
V_PR_AI0014 := R01014; (*  *)
V_PR_AI0015 := R01015; (*  *)
V_PR_AI0016 := R01016; (*  *)
R01017 := OGT01_OPN_SPD1; (* GT01 Gate Open Solenoid 1 Speed Ref. *)
R01018 := OGT01_OPN_SPD2; (* GT01 Gate Open Solenoid 2 Speed Ref. *)
IRL_24V_HLTY := R01019 <> 0; (* Control Voltage OK *)
IRL_WG_REAR3_1 := R01020 <> 0; (*  *)
IRL_DRIVE_CTRL_HLTY := R01021 <> 0; (* Drive Voltage OK *)
IRL_LC_ENTRY1 := R01022 <> 0; (* RL Locomotive PE 1 -Entry Clear *)
IRL_LC_EXIT1 := R01023 <> 0; (* RL Locomotive detected PE 1- Exit *)
IRL_WG_FRONT1 := R01024 <> 0; (* RL Wagon front detected No. 1 *)
IRL_WG_FRONT2 := R01025 <> 0; (* RL Wagon front detected No. 2 *)
IRL_WG_FRONT3 := R01026 <> 0; (* RL Wagon front detected No. 3 *)
IRL_WG_REAR1 := R01027 <> 0; (* RL Wagon rear detected No. 1 *)
IRL_WG_REAR2 := R01028 <> 0; (* RL Wagon rear detected No. 2 *)
IRL_WG_REAR3 := R01029 <> 0; (* RL Wagon rear detected No. 3 *)
IRL_LC_EXIT3 := R01030 <> 0; (* RL Locomotive detected PE 3- Exit *)
IRL_WG_OPN := R01031 <> 0; (* RL Wagon door open *)
IRL_SPILL := R01032 <> 0; (* Spillage detected No.1 and No. 2 *)
IGT01_CLSD1 := R01033 <> 0; (* GT01 Gate leaf closed detected no. 1 *)
IGT01_OPND1 := R01034 <> 0; (* GT01 Gate leaf open detected no. 1 *)
IGT01_CLSD2 := R01035 <> 0; (* GT01 Gate leaf closed detected no. 2 *)
IGT01_OPND2 := R01036 <> 0; (* GT01 Gate leaf open detected no. 2 *)
ICH01_LKD := R01037 <> 0; (* CH01 Chute lock engaged *)
IRL_LC_ENTRY3 := R01038 <> 0; (* RL Locomotive PE 3 -Entry Clear (PN) *)
IPK03_OIL_LVL_LOW := R01039 <> 0; (* RL Hyd Power pack low oil level detected *)
IPK03_PR_HLTY := R01040 <> 0; (* RL Hyd Power pack oil press healthy *)
IPK03_ACC1_PR_HLTHY := R01041 <> 0; (* RL Hyd Accumulator pressure healthy no.1 *)
IPK03_ACC2_PR_HLTHY := R01042 <> 0; (* RL Hyd Accumulator pressure healthy no.2 *)
IRL_LCU_ESP := R01043 <> 0; (* Manual pendant emergency stop *)
IGT01_LCU_OPN := R01044 <> 0; (* GT01 Manual pendant gate open *)
ICH01_LCU_RSE := R01045 <> 0; (* CH01 Manual pendant chute lower *)
ICH01_LCU_LWR := R01046 <> 0; (* CH01 Manual pendant chute lock release *)
ICH01_LCU_UNLK := R01047 <> 0; (* CH01 Manual pendant Chute unlock *)
IORD_LC_ENTRY1 := R01048 <> 0; (* ORD Locomotive detected PE 1 - Entry *)
IORD_LC_EXIT1 := R01049 <> 0; (* ORD Locomotive detected PE 1 -Exit *)
IORD_WG_FRONT := R01050 <> 0; (* ORD Wagon front detected *)
IPL01_LWR1 := R01051 <> 0; (* PL01 Plough lower position 1 *)
IPL01_LWR2 := R01052 <> 0; (* PL01 Plough lower position 2 *)
IPL01_LWR3 := R01053 <> 0; (* PL01 Plough lower position 3 *)
IPL01_LKD := R01054 <> 0; (* PL01 Plough lock engaged *)
ICH02_EXTD1 := R01055 <> 0; (* CH02 Chute extend position 1 *)
ICH02_EXTD2 := R01056 <> 0; (* CH02 Chute extend position 2 *)
ICH02_EXTD3 := R01057 <> 0; (* CH02 Chute extend position 3 *)
ICH02_RETD := R01058 <> 0; (* CH02 Chute retracted detected *)
IPK04_OIL_LVL_LOW := R01059 <> 0; (* ORD Hyd Power pack low oil level detected *)
IPK04_PR_HLTY := R01060 <> 0; (* ORD Hyd Power pack oil press healthy *)
IPK04_ACC_PR_HLTHY := R01061 <> 0; (* ORD Hyd Accumulator pressure healthy *)
IPK03_RDY := R01062 <> 0; (* RL Hyd Pump Ready *)
IPK03_LCU_STR := R01063 <> 0; (* RL Hyd Pump Local Start *)
IPK03_HLTY := R01064 <> 0; (* RL Hyd Pump MCC Healthy *)
IPK03_CONT_CLD := R01065 <> 0; (* RL Hyd Pump Contactor Closed *)
IPK04_RDY := R01066 <> 0; (* ORD Hyd Pump Ready *)
IPK04_LCU_STR := R01067 <> 0; (* ORD Hyd Pump Local Start *)
IPK04_HLTY := R01068 <> 0; (* ORD Hyd Pump MCC Healthy *)
IPK04_CONT_CLD := R01069 <> 0; (* ORD Hyd Pump Contactor Closed *)
ITSI_PLC_HLTY := R01070 <> 0; (* Momentum PLC Healthy *)
IRL_DERAIL_DECT1 := R01071 <> 0; (* Derailment detected No.1 *)
IRL_DERAIL_DECT2 := R01072 <> 0; (* Derailment detected No.2 *)
IRL_LC_ENTRY2 := R01073 <> 0; (* RL Locomotive PE 2 -Entry Clear *)
IRL_LC_EXIT2 := R01074 <> 0; (* RL Locomotive detected PE 2- Exit *)
IORD_LC_ENTRY2 := R01075 <> 0; (* ORD Locomotive detected PE 2 - Entry *)
IORD_LC_EXIT2 := R01076 <> 0; (* ORD Locomotive detected PE 2 -Exit *)
IPL01_RSE := R01077 <> 0; (*  *)
ITLA_OL := R01078 <> 0; (*  *)
IRL_UPS_HLTY := R01079 <> 0; (* UPS Healthy *)
IRL_UPS_FLT := R01080 <> 0; (* UPS Healthy *)
IRL_UPS_BAT_FLT := R01081 <> 0; (* UPS Healthy *)
IRL_UPS_BYPASS := R01082 <> 0; (* UPS Healthy *)
V_PR_I00129 := R01083 <> 0; (*  *)
V_PR_I00130 := R01084 <> 0; (*  *)
V_PR_I00138 := R01085 <> 0; (*  *)
V_PR_I00139 := R01086 <> 0; (*  *)
V_PR_I00140 := R01087 <> 0; (*  *)
V_PR_I00142 := R01088 <> 0; (*  *)
V_PR_I00144 := R01089 <> 0; (*  *)
V_PR_I00145 := R01090 <> 0; (*  *)
V_PR_I00146 := R01091 <> 0; (*  *)
V_PR_I00153 := R01092 <> 0; (* Analog Output Ch1 Wire Broken *)
V_PR_I00154 := R01093 <> 0; (*  *)
V_PR_I00155 := R01094 <> 0; (*  *)
V_PR_I00156 := R01095 <> 0; (*  *)
V_PR_I00161 := R01096 <> 0; (*  *)
V_PR_I00162 := R01097 <> 0; (*  *)
V_PR_I00163 := R01098 <> 0; (*  *)
V_PR_I00164 := R01099 <> 0; (*  *)
V_PR_I00165 := R01100 <> 0; (*  *)
V_PR_I00168 := R01101 <> 0; (*  *)
V_PR_I00173 := R01102 <> 0; (*  *)
V_PR_I00176 := R01103 <> 0; (*  *)
IRL_TILT_SWITCH := R01104 <> 0; (* CH01 Tilt switch, Input *)
IRL_FAULT2_VNR := R01105 <> 0; (* Train Wagon Veneering Fault *)
RL_SUB_FIREPANEL_INPUT := R01106 <> 0; (* RL Sub Fire Panel Alarm Input *)
IGT01_LCU_JOY_CLS := R01107 <> 0; (* GT01 Manual Joystick Gate Close *)
IGT01_LCU_JOY_OPN := R01108 <> 0; (* GT01 Manual Joystick Gate Open *)
IPK03_ACC3_PR_HLTHY := R01109 <> 0; (* RL Hyd Accumulator pressure healthy no.3 *)
RL_FIRE_SUPPRESSION_DEPLETED := R01110 <> 0; (* RL PK03 Hyd Pack Fire Suppression Depleted Input *)
IRL_LC_PANTOGRAPH := R01111 <> 0; (* Loco Pantograph Detect PE (1=CLEAR) *)
IXS052 := R01112 <> 0; (* Wagon Near Chute 2 *)
IXS054 := R01113 <> 0; (* Derailment Switch *)
IXS050 := R01114 <> 0; (* Wagon Past Gate Close *)
IRL_FAULT_VNR := R01115 <> 0; (* Train Wagon Veneering Fault *)
IXS051 := R01116 <> 0; (* Wagon Near Chute 1 *)
IXS053 := R01117 <> 0; (* Wagon Clear Chute *)
IXS056 := R01118 <> 0; (* Chute Breakaway Switch *)
V_PR_I01025 := R01119 <> 0; (*  *)
V_PR_I01026 := R01120 <> 0; (*  *)
V_PR_I01037 := R01121 <> 0; (*  *)
V_PR_I01040 := R01122 <> 0; (*  *)
IF OPK03_STRT_RLY THEN
   R01123 := 1;
ELSE
   R01123 := 0;
END_IF; (* RL Hyd Pump Start Relay *)
IF OPK04_STRT_RLY THEN
   R01124 := 1;
ELSE
   R01124 := 0;
END_IF; (* ORD Hyd Pump Start Relay *)
IF ORL_AMB_IND THEN
   R01125 := 1;
ELSE
   R01125 := 0;
END_IF; (* Signal lights -  Amber (RL) *)
IF ORL_RED_IND THEN
   R01126 := 1;
ELSE
   R01126 := 0;
END_IF; (* Signal lights -  Red (RL) *)
IF OORD_AMB_IND THEN
   R01127 := 1;
ELSE
   R01127 := 0;
END_IF; (* ORD Signal light Amber (ORD) *)
IF OORD_RED_IND THEN
   R01128 := 1;
ELSE
   R01128 := 0;
END_IF; (* ORD Signal light Red (ORD) *)
IF OGT01_LCU_OPND_IND THEN
   R01129 := 1;
ELSE
   R01129 := 0;
END_IF; (* GT01 Manual pendant gate open indicator *)
IF ORL_LC_PANTOGRAPH THEN
   R01130 := 1;
ELSE
   R01130 := 0;
END_IF; (* Loco Pantograph PE Clear *)
IF OSPARE_Q009 THEN
   R01131 := 1;
ELSE
   R01131 := 0;
END_IF; (*  *)
IF OSPARE_Q010 THEN
   R01132 := 1;
ELSE
   R01132 := 0;
END_IF; (*  *)
IF OSPARE_Q011 THEN
   R01133 := 1;
ELSE
   R01133 := 0;
END_IF; (*  *)
IF OSPARE_Q012 THEN
   R01134 := 1;
ELSE
   R01134 := 0;
END_IF; (*  *)
IF OSPARE_Q013 THEN
   R01135 := 1;
ELSE
   R01135 := 0;
END_IF; (*  *)
IF OSPARE_Q014 THEN
   R01136 := 1;
ELSE
   R01136 := 0;
END_IF; (*  *)
IF OSPARE_Q015 THEN
   R01137 := 1;
ELSE
   R01137 := 0;
END_IF; (*  *)
IF OSPARE_Q016 THEN
   R01138 := 1;
ELSE
   R01138 := 0;
END_IF; (*  *)
IF OGT01_OPN_SOL1 THEN
   R01139 := 1;
ELSE
   R01139 := 0;
END_IF; (* GT01 Gate open no. 1 *)
IF OGT01_OPN_SOL2 THEN
   R01140 := 1;
ELSE
   R01140 := 0;
END_IF; (* GT01 Gate open no. 2 *)
IF OCH01_RSE_SOL THEN
   R01141 := 1;
ELSE
   R01141 := 0;
END_IF; (* CH01 Chute raise Sol *)
IF OCH01_LWR_SOL THEN
   R01142 := 1;
ELSE
   R01142 := 0;
END_IF; (* CH01 Chute lower Sol *)
IF OCH01_ACC_ISOL_SOL THEN
   R01143 := 1;
ELSE
   R01143 := 0;
END_IF; (* CH01 Chute raise accumulator isolation Sol *)
IF OCH01_UNLK_SOL THEN
   R01144 := 1;
ELSE
   R01144 := 0;
END_IF; (* CH01 Chute lock release Sol *)
IF OPK03_ACC_DMP_SOL THEN
   R01145 := 1;
ELSE
   R01145 := 0;
END_IF; (* RL Hyd Pump Accumulator dump Sol *)
IF OPK03_UNLOAD_SOL THEN
   R01146 := 1;
ELSE
   R01146 := 0;
END_IF; (* RL Hyd Pump unloader Sol *)
IF OPL01_RSE_SOL THEN
   R01147 := 1;
ELSE
   R01147 := 0;
END_IF; (* PL01 Plough raise Sol *)
IF OPL01_LWR_SOL THEN
   R01148 := 1;
ELSE
   R01148 := 0;
END_IF; (* pl01 Plough lower Sol *)
IF OPL01_ACC_ISOL_SOL THEN
   R01149 := 1;
ELSE
   R01149 := 0;
END_IF; (* PL01 Plough Lower accumulator Isolation Sol *)
IF OCH02_RET_SOL THEN
   R01150 := 1;
ELSE
   R01150 := 0;
END_IF; (* CH02 Chute retract Sol *)
IF OCH02_EXT_SOL THEN
   R01151 := 1;
ELSE
   R01151 := 0;
END_IF; (* CH02 Chute extend Sol *)
IF OCH02_ACC_ISOL_SOL THEN
   R01152 := 1;
ELSE
   R01152 := 0;
END_IF; (* CH02 Chute extend accumulator isolation Sol *)
IF OPL01_UNLK_SOL THEN
   R01153 := 1;
ELSE
   R01153 := 0;
END_IF; (* PL01 Plough lock release Sol *)
IF OPK04_ACC_DMP_SOL THEN
   R01154 := 1;
ELSE
   R01154 := 0;
END_IF; (* ORD Hyd Pump Accumulator dump Sol *)
IF OPK04_UNLOAD_SOL THEN
   R01155 := 1;
ELSE
   R01155 := 0;
END_IF; (* ORD Hyd Pump unloader Sol *)
IF ORL_SYS_ON_VNR THEN
   R01156 := 1;
ELSE
   R01156 := 0;
END_IF; (* System on - When hydrolic pump is on *)
IF ORL_GATE_OPEN_VNR THEN
   R01157 := 1;
ELSE
   R01157 := 0;
END_IF; (* Gate open *)
IF ORL_TRN_COMPLT_VNR THEN
   R01158 := 1;
ELSE
   R01158 := 0;
END_IF; (* End of train signal - Tain is completed *)
IF OSPARE_Q046 THEN
   R01159 := 1;
ELSE
   R01159 := 0;
END_IF; (* Conveyor 4 Drive a Current *)
IF OSPARE_Q047 THEN
   R01160 := 1;
ELSE
   R01160 := 0;
END_IF; (* Conveyor 4 Drive b Current *)
IF OSPARE_Q048 THEN
   R01161 := 1;
ELSE
   R01161 := 0;
END_IF; (* Coal Valve 1 Control Gate Position *)
TSI_COMMAND := R01162; (* TSI Command to Red Lion Unit *)
TSI_TARGET_SPD := R01163; (* TSI Target Speed to Red Lion Unit *)
RFID1_RD := R01164; (* Read Data *)
RFID1_SN := R01165; (* Serial number *)
RFID2_RD := R01166; (* Read Data *)
RFID2_SN := R01167; (* Serial Number *)