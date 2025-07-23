(* AUTOGEN MAPPINGS *)
ICH01_POS := R01001; (* CH01 Chute deployed position *)
ILT002 := R01002; (* TLO Inbound Radar *)
ILT003 := R01003; (* TLO Outbound Radar *)
IJOY_POSN := R01004; (*  *)
R01005 := OGT01_OPN_SPD1; (* GT01 Gate Open Solenoid 1 Speed Ref. *)
R01006 := OGT01_OPN_SPD2; (* GT01 Gate Open Solenoid 2 Speed Ref. *)
IRL_24V_HLTY := R01007 <> 0; (* Control Voltage OK *)
IRL_WG_REAR3_1 := R01008 <> 0; (*  *)
IRL_DRIVE_CTRL_HLTY := R01009 <> 0; (* Drive Voltage OK *)
IRL_LC_ENTRY1 := R01010 <> 0; (* RL Locomotive PE 1 -Entry Clear *)
IRL_LC_EXIT1 := R01011 <> 0; (* RL Locomotive detected PE 1- Exit *)
IRL_WG_FRONT1 := R01012 <> 0; (* RL Wagon front detected No. 1 *)
IRL_WG_FRONT2 := R01013 <> 0; (* RL Wagon front detected No. 2 *)
IRL_WG_FRONT3 := R01014 <> 0; (* RL Wagon front detected No. 3 *)
IXS006 := R01015 <> 0; (* RL Wagon rear detected No. 1 *)
IXS007 := R01016 <> 0; (* RL Wagon rear detected No. 2 *)
IXS008 := R01017 <> 0; (* RL Wagon rear detected No. 3 *)
IRL_LC_EXIT3 := R01018 <> 0; (* RL Locomotive detected PE 3- Exit *)
IXS010 := R01019 <> 0; (* Wagon Door Open Switch *)
IXS011_XS012 := R01020 <> 0; (*  *)
IGT01_CLSD1 := R01021 <> 0; (* GT01 Gate leaf closed detected no. 1 *)
IGT01_OPND1 := R01022 <> 0; (* GT01 Gate leaf open detected no. 1 *)
IGT01_CLSD2 := R01023 <> 0; (* GT01 Gate leaf closed detected no. 2 *)
IGT01_OPND2 := R01024 <> 0; (* GT01 Gate leaf open detected no. 2 *)
ICH01_LKD := R01025 <> 0; (* CH01 Chute lock engaged *)
IRL_LC_ENTRY3 := R01026 <> 0; (* RL Locomotive PE 3 -Entry Clear (PN) *)
IPK03_OIL_LVL_LOW := R01027 <> 0; (* RL Hyd Power pack low oil level detected *)
IPK03_PR_HLTY := R01028 <> 0; (* RL Hyd Power pack oil press healthy *)
IPK03_ACC1_PR_HLTHY := R01029 <> 0; (* RL Hyd Accumulator pressure healthy no.1 *)
IPK03_ACC2_PR_HLTHY := R01030 <> 0; (* RL Hyd Accumulator pressure healthy no.2 *)
IRL_LCU_ESP := R01031 <> 0; (* Manual pendant emergency stop *)
IGT01_LCU_OPN := R01032 <> 0; (* GT01 LCU gate open *)
ICH01_LCU_RSE := R01033 <> 0; (* CH01 Manual pendant chute raise *)
ICH01_LCU_LWR := R01034 <> 0; (* CH01 Manual pendant chute lower *)
ICH01_LCU_UNLK := R01035 <> 0; (* CH01 Manual pendant Chute unlock *)
IORD_LC_ENTRY1 := R01036 <> 0; (* ORD Locomotive detected PE 1 - Entry *)
IORD_LC_EXIT1 := R01037 <> 0; (* ORD Locomotive detected PE 1 -Exit *)
IORD_WG_FRONT := R01038 <> 0; (* ORD Wagon front detected *)
IPL01_LWR1 := R01039 <> 0; (* PL01 Plough lower position 1 *)
IPL01_LWR2 := R01040 <> 0; (* PL01 Plough lower position 2 *)
IPL01_LWR3 := R01041 <> 0; (* PL01 Plough lower position 3 *)
IPL01_LKD := R01042 <> 0; (* PL01 Plough lock engaged *)
ICH02_EXTD1 := R01043 <> 0; (* CH02 Chute extend position 1 *)
ICH02_EXTD2 := R01044 <> 0; (* CH02 Chute extend position 2 *)
ICH02_EXTD3 := R01045 <> 0; (* CH02 Chute extend position 3 *)
ICH02_RETD := R01046 <> 0; (* CH02 Chute retracted detected *)
IPK04_OIL_LVL_LOW := R01047 <> 0; (* ORD Hyd Power pack low oil level detected *)
IPK04_PR_HLTY := R01048 <> 0; (* ORD Hyd Power pack oil press healthy *)
IPK04_ACC_PR_HLTHY := R01049 <> 0; (* ORD Hyd Accumulator pressure healthy *)
IPK03_RDY := R01050 <> 0; (* RL Hyd Pump Ready *)
IPK03_LCU_STR := R01051 <> 0; (* RL Hyd Pump Local Start *)
IPK03_HLTY := R01052 <> 0; (* RL Hyd Pump MCC Healthy *)
IPK03_CONT_CLD := R01053 <> 0; (* RL Hyd Pump Contactor Closed *)
IPK04_RDY := R01054 <> 0; (* ORD Hyd Pump Ready *)
IPK04_LCU_STR := R01055 <> 0; (* ORD Hyd Pump Local Start *)
IPK04_HLTY := R01056 <> 0; (* ORD Hyd Pump MCC Healthy *)
IPK04_CONT_CLD := R01057 <> 0; (* ORD Hyd Pump Contactor Closed *)
ITSI_PLC_HLTY := R01058 <> 0; (* Momentum PLC Healthy *)
IRL_DERAIL_DECT1 := R01059 <> 0; (* Derailment detected No.1 *)
IRL_DERAIL_DECT2 := R01060 <> 0; (* Derailment detected No.2 *)
IRL_LC_ENTRY2 := R01061 <> 0; (* RL Locomotive PE 2 -Entry Clear *)
IRL_LC_EXIT2 := R01062 <> 0; (* RL Locomotive detected PE 2- Exit *)
IORD_LC_ENTRY2 := R01063 <> 0; (* ORD Locomotive detected PE 2 - Entry *)
IORD_LC_EXIT2 := R01064 <> 0; (* ORD Locomotive detected PE 2 -Exit *)
IPL01_RSE := R01065 <> 0; (*  *)
IRL_UPS_HLTY2 := R01066 <> 0; (* UPS Healthy (Not certain this I/P works) *)
IRL_UPS_HLTY := R01067 <> 0; (* UPS Healthy *)
IRL_UPS_BAT_FLT := R01068 <> 0; (* UPS Battery Fault *)
IRL_UPS_BYPASS := R01069 <> 0; (* UPS Bypass Mode *)
IRL_TILT_SWITCH := R01070 <> 0; (* CH01 Tilt switch, Input *)
IVNR_FLT := R01071 <> 0; (* Train Wagon Veneering Fault *)
IRL_SUB_FIREPANEL_INPUT := R01072 <> 0; (* RL Sub Fire Panel Alarm Input *)
IGT01_LCU_JOY_CLS := R01073 <> 0; (* GT01 Manual Joystick Gate Close *)
IGT01_LCU_JOY_OPN := R01074 <> 0; (* GT01 Manual Joystick Gate Open *)
IPK03_ACC3_PR_HLTHY := R01075 <> 0; (* RL Hyd Accumulator pressure healthy no.3 *)
IRL_FIRE_SUPPRESSION_DEPLETED := R01076 <> 0; (* RL PK03 Hyd Pack Fire Suppression Depleted Input *)
IXS055 := R01077 <> 0; (* Pantograph Raised PE *)
IXS052 := R01078 <> 0; (* Wagon Near Chute PE2 *)
IXS054 := R01079 <> 0; (* Derailment Detection Switch *)
IXS050 := R01080 <> 0; (* Wagon Past Close Gate *)
IXS051 := R01081 <> 0; (* Wagon Near Chute PE1 *)
IXS053 := R01082 <> 0; (* Wagon Clear of Chute PE *)
IXS056 := R01083 <> 0; (* CH01 Breakaway Switch *)
IF PK03_RUN_OUTPUT THEN
   R01084 := 1;
ELSE
   R01084 := 0;
END_IF; (* RL Hyd Pump Start Output *)
IF PK04_RUN_OUTPUT THEN
   R01085 := 1;
ELSE
   R01085 := 0;
END_IF; (* ORD Hyd Pump Start Output *)
IF TLO_AMB_IND_OUTPUT THEN
   R01086 := 1;
ELSE
   R01086 := 0;
END_IF; (* Signal lights -  Amber (RL) *)
IF TLO_RED_IND_OUTPUT THEN
   R01087 := 1;
ELSE
   R01087 := 0;
END_IF; (* Signal lights -  Red (RL) *)
IF ORD_AMB_IND_OUTPUT THEN
   R01088 := 1;
ELSE
   R01088 := 0;
END_IF; (* ORD Signal light Amber (ORD) *)
IF ORD_RED_IND_OUTPUT THEN
   R01089 := 1;
ELSE
   R01089 := 0;
END_IF; (* ORD Signal light Red (ORD) *)
IF GT01_OPN_SOL1_OUTPUT THEN
   R01090 := 1;
ELSE
   R01090 := 0;
END_IF; (*  *)
IF GT01_OPN_SOL2_OUTPUT THEN
   R01091 := 1;
ELSE
   R01091 := 0;
END_IF; (*  *)
IF CH01_RSE_SOL_OUTPUT THEN
   R01092 := 1;
ELSE
   R01092 := 0;
END_IF; (* CH01 Chute raise Sol *)
IF CH01_LWR_SOL_OUTPUT THEN
   R01093 := 1;
ELSE
   R01093 := 0;
END_IF; (* CH01 Chute lower Sol *)
IF CH01_ACC_ISOL_SOL_OUTPUT THEN
   R01094 := 1;
ELSE
   R01094 := 0;
END_IF; (* CH01 Chute raise accumulator isolation Sol *)
IF CH01_UNLK_SOL_OUTPUT THEN
   R01095 := 1;
ELSE
   R01095 := 0;
END_IF; (* CH01 Chute lock release Sol *)
IF PK03_ACC_DMP_SOL_OUTPUT THEN
   R01096 := 1;
ELSE
   R01096 := 0;
END_IF; (* RL Hyd Pump Accumulator dump Sol *)
IF PK03_UNLOAD_SOL_OUTPUT THEN
   R01097 := 1;
ELSE
   R01097 := 0;
END_IF; (* RL Hyd Pump unloader Sol *)
IF PL01_RSE_SOL_OUTPUT THEN
   R01098 := 1;
ELSE
   R01098 := 0;
END_IF; (* PL01 Plough raise Sol *)
IF PL01_LWR_SOL_OUTPUT THEN
   R01099 := 1;
ELSE
   R01099 := 0;
END_IF; (* PL01 Plough lower Sol *)
IF PL01_ACC_ISOL_SOL_OUTPUT THEN
   R01100 := 1;
ELSE
   R01100 := 0;
END_IF; (* PL01 Plough Lower accumulator Isolation Sol *)
IF CH02_RET_SOL_OUTPUT THEN
   R01101 := 1;
ELSE
   R01101 := 0;
END_IF; (* CH02 Chute retract Sol *)
IF CH02_EXT_SOL_OUTPUT THEN
   R01102 := 1;
ELSE
   R01102 := 0;
END_IF; (* CH02 Chute extend Sol *)
IF CH02_ACC_ISOL_SOL_OUTPUT THEN
   R01103 := 1;
ELSE
   R01103 := 0;
END_IF; (* CH02 Chute extend accumulator isolation Sol *)
IF PL01_UNLK_SOL_OUTPUT THEN
   R01104 := 1;
ELSE
   R01104 := 0;
END_IF; (* PL01 Plough lock release Sol *)
IF PK04_ACC_DMP_SOL_OUTPUT THEN
   R01105 := 1;
ELSE
   R01105 := 0;
END_IF; (* ORD Hyd Pump Accumulator dump Sol *)
IF PK04_UNLOAD_SOL_OUTPUT THEN
   R01106 := 1;
ELSE
   R01106 := 0;
END_IF; (* ORD Hyd Pump unloader Sol *)
IF RL_SYS_ON_VNR_OUTPUT THEN
   R01107 := 1;
ELSE
   R01107 := 0;
END_IF; (* System on - When hydrolic pump is on *)
IF RL_GATE_OPEN_VNR_OUTPUT THEN
   R01108 := 1;
ELSE
   R01108 := 0;
END_IF; (* Gate open to Veneering System *)
IF RL_TRN_COMPLT_VNR_OUTPUT THEN
   R01109 := 1;
ELSE
   R01109 := 0;
END_IF; (* End of train signal - Tain is completed *)
TSI_COMMAND := R01110; (* TSI Command to Red Lion Unit *)
TSI_TARGET_SPD := R01111; (* TSI Target Speed to Red Lion Unit *)
RFID1_READDATA := R01112; (*  *)
RFID1_CLASSCODE := R01113; (*  *)
RFID1_READDATALEN := R01114; (*  *)
RFID1_EQGRPCODE := R01115; (*  *)
RFID1_CARNO := R01116; (*  *)
RFID1_SERIALNO := R01117; (*  *)
RFID2_READDATA := R01118; (*  *)
RFID2_CLASSCODE := R01119; (*  *)
RFID2_READDATALEN := R01120; (*  *)
RFID2_EQGRPCODE := R01121; (*  *)
RFID2_CARNO := R01122; (*  *)
RFID2_SERIALNO := R01123; (*  *)
IWB01_STATE := R01124; (* Weighbridge State from WB01 *)
IWB01_ALMSTATUS := R01125; (* Alarm Status from WB01 *)
IWB01_CARNO := R01126; (* Car Number at WB01 *)
IWB01_CARTYPE := R01127; (* Car Type at WB01 *)
IWB01_WGNNO := R01128; (* Wagon Number at WB01 *)
IWB01_CARWT := R01129; (* Car Weight from WB01 *)
IWB01_BOGIE1 := R01130; (* Bogie 1 Weight from WB01 *)
IWB01_BOGIE2 := R01131; (* Bogie 2 Weight from WB01 *)