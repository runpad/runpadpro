unit Office_TLB;

// ************************************************************************ //
// WARNING                                                                    
// -------                                                                    
// The types declared in this file were generated from data read from a       
// Type Library. If this type library is explicitly or indirectly (via        
// another type library referring to this type library) re-imported, or the   
// 'Refresh' command of the Type Library Editor activated while editing the   
// Type Library, the contents of this file will be regenerated and all        
// manual modifications will be lost.                                         
// ************************************************************************ //

// PASTLWTR : 1.2
// File generated on 17.08.2006 20:04:22 from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\Program Files\Microsoft Office\Office\MSO9.DLL (2)
// LIBID: {2DF8D04C-5BFA-101B-BDE5-00AA0044DE52}
// LCID: 0
// Helpfile: C:\Program Files\Microsoft Office\Office\vbaoff9.chm
// HelpString: Microsoft Office 9.0 Object Library
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINDOWS\system32\stdole2.tlb)
// Parent TypeLibrary:
//   (0) v8.1 Word, (MSWORD9.OLB)
// Errors:
//   Hint: Parameter 'Type' of _CommandBars.FindControl changed to 'Type_'
//   Hint: Parameter 'Type' of _CommandBars.FindControls changed to 'Type_'
//   Hint: Parameter 'Type' of CommandBar.FindControl changed to 'Type_'
//   Hint: Symbol 'Type' renamed to 'type_'
//   Hint: Parameter 'Type' of CommandBarControls.Add changed to 'Type_'
//   Hint: Symbol 'Type' renamed to 'type_'
//   Hint: Symbol 'Type' renamed to 'type_'
//   Hint: Parameter 'Type' of CalloutFormat.Type changed to 'Type_'
//   Hint: Symbol 'Type' renamed to 'type_'
//   Hint: Parameter 'Type' of CalloutFormat.Type changed to 'Type_'
//   Hint: Symbol 'Type' renamed to 'type_'
//   Hint: Parameter 'Type' of ColorFormat.Type changed to 'Type_'
//   Hint: Symbol 'Type' renamed to 'type_'
//   Hint: Parameter 'Type' of ConnectorFormat.Type changed to 'Type_'
//   Hint: Symbol 'Type' renamed to 'type_'
//   Hint: Parameter 'Type' of ConnectorFormat.Type changed to 'Type_'
//   Hint: Symbol 'Type' renamed to 'type_'
//   Hint: Parameter 'Type' of FillFormat.Type changed to 'Type_'
//   Hint: Symbol 'Type' renamed to 'type_'
//   Hint: Parameter 'Type' of ShadowFormat.Type changed to 'Type_'
//   Hint: Symbol 'Type' renamed to 'type_'
//   Hint: Parameter 'Type' of ShadowFormat.Type changed to 'Type_'
//   Hint: Parameter 'Object' of Script.Shape changed to 'Object_'
//   Hint: Symbol 'Type' renamed to 'type_'
//   Hint: Parameter 'Type' of Shape.Type changed to 'Type_'
//   Hint: Symbol 'Type' renamed to 'type_'
//   Hint: Parameter 'Type' of ShapeRange.Type changed to 'Type_'
//   Hint: Parameter 'Type' of Shapes.AddCallout changed to 'Type_'
//   Hint: Parameter 'Type' of Shapes.AddConnector changed to 'Type_'
//   Hint: Parameter 'Label' of Shapes.AddLabel changed to 'Label_'
//   Hint: Parameter 'Type' of Shapes.AddShape changed to 'Type_'
//   Hint: Member 'Private' of 'Balloon' changed to 'Private_'
//   Hint: Parameter 'On' of Assistant.StartWizard changed to 'On_'
//   Hint: Member 'On' of 'Assistant' changed to 'On_'
//   Hint: Symbol 'Type' renamed to 'type_'
//   Hint: Symbol 'Type' renamed to 'type_'
//   Hint: Parameter 'Type' of DocumentProperties.Add changed to 'Type_'
//   Hint: Member 'Object' of 'COMAddIn' changed to 'Object_'
// ************************************************************************ //
// *************************************************************************//
// NOTE:                                                                      
// Items guarded by $IFDEF_LIVE_SERVER_AT_DESIGN_TIME are used by properties  
// which return objects that may need to be explicitly created via a function 
// call prior to any access via the property. These items have been disabled  
// in order to prevent accidental use from within the object inspector. You   
// may enable them by defining LIVE_SERVER_AT_DESIGN_TIME or by selectively   
// removing them from the $IFDEF blocks. However, such items must still be    
// programmatically created via a method of the appropriate CoClass before    
// they can be used.                                                          
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
interface

uses Windows, ActiveX, Classes, Graphics, OleServer, StdVCL, Variants;
  

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  OfficeMajorVersion = 2;
  OfficeMinorVersion = 1;

  LIBID_Office: TGUID = '{2DF8D04C-5BFA-101B-BDE5-00AA0044DE52}';

  IID_IAccessible: TGUID = '{618736E0-3C3D-11CF-810C-00AA00389B71}';
  IID__IMsoDispObj: TGUID = '{000C0300-0000-0000-C000-000000000046}';
  IID__IMsoOleAccDispObj: TGUID = '{000C0301-0000-0000-C000-000000000046}';
  IID__CommandBars: TGUID = '{000C0302-0000-0000-C000-000000000046}';
  IID_CommandBar: TGUID = '{000C0304-0000-0000-C000-000000000046}';
  IID_CommandBarControls: TGUID = '{000C0306-0000-0000-C000-000000000046}';
  IID_CommandBarControl: TGUID = '{000C0308-0000-0000-C000-000000000046}';
  IID__CommandBarButton: TGUID = '{000C030E-0000-0000-C000-000000000046}';
  IID_CommandBarPopup: TGUID = '{000C030A-0000-0000-C000-000000000046}';
  IID__CommandBarComboBox: TGUID = '{000C030C-0000-0000-C000-000000000046}';
  IID__CommandBarActiveX: TGUID = '{000C030D-0000-0000-C000-000000000046}';
  IID_Adjustments: TGUID = '{000C0310-0000-0000-C000-000000000046}';
  IID_CalloutFormat: TGUID = '{000C0311-0000-0000-C000-000000000046}';
  IID_ColorFormat: TGUID = '{000C0312-0000-0000-C000-000000000046}';
  IID_ConnectorFormat: TGUID = '{000C0313-0000-0000-C000-000000000046}';
  IID_FillFormat: TGUID = '{000C0314-0000-0000-C000-000000000046}';
  IID_FreeformBuilder: TGUID = '{000C0315-0000-0000-C000-000000000046}';
  IID_GroupShapes: TGUID = '{000C0316-0000-0000-C000-000000000046}';
  IID_LineFormat: TGUID = '{000C0317-0000-0000-C000-000000000046}';
  IID_ShapeNode: TGUID = '{000C0318-0000-0000-C000-000000000046}';
  IID_ShapeNodes: TGUID = '{000C0319-0000-0000-C000-000000000046}';
  IID_PictureFormat: TGUID = '{000C031A-0000-0000-C000-000000000046}';
  IID_ShadowFormat: TGUID = '{000C031B-0000-0000-C000-000000000046}';
  IID_Script: TGUID = '{000C0341-0000-0000-C000-000000000046}';
  IID_Scripts: TGUID = '{000C0340-0000-0000-C000-000000000046}';
  IID_Shape: TGUID = '{000C031C-0000-0000-C000-000000000046}';
  IID_ShapeRange: TGUID = '{000C031D-0000-0000-C000-000000000046}';
  IID_Shapes: TGUID = '{000C031E-0000-0000-C000-000000000046}';
  IID_TextEffectFormat: TGUID = '{000C031F-0000-0000-C000-000000000046}';
  IID_TextFrame: TGUID = '{000C0320-0000-0000-C000-000000000046}';
  IID_ThreeDFormat: TGUID = '{000C0321-0000-0000-C000-000000000046}';
  IID_IMsoDispCagNotifySink: TGUID = '{000C0359-0000-0000-C000-000000000046}';
  IID_Balloon: TGUID = '{000C0324-0000-0000-C000-000000000046}';
  IID_BalloonCheckboxes: TGUID = '{000C0326-0000-0000-C000-000000000046}';
  IID_BalloonCheckbox: TGUID = '{000C0328-0000-0000-C000-000000000046}';
  IID_BalloonLabels: TGUID = '{000C032E-0000-0000-C000-000000000046}';
  IID_BalloonLabel: TGUID = '{000C0330-0000-0000-C000-000000000046}';
  IID_AnswerWizardFiles: TGUID = '{000C0361-0000-0000-C000-000000000046}';
  IID_AnswerWizard: TGUID = '{000C0360-0000-0000-C000-000000000046}';
  IID_Assistant: TGUID = '{000C0322-0000-0000-C000-000000000046}';
  IID_DocumentProperty: TGUID = '{2DF8D04E-5BFA-101B-BDE5-00AA0044DE52}';
  IID_DocumentProperties: TGUID = '{2DF8D04D-5BFA-101B-BDE5-00AA0044DE52}';
  IID_IFoundFiles: TGUID = '{000C0338-0000-0000-C000-000000000046}';
  IID_IFind: TGUID = '{000C0337-0000-0000-C000-000000000046}';
  IID_FoundFiles: TGUID = '{000C0331-0000-0000-C000-000000000046}';
  IID_PropertyTest: TGUID = '{000C0333-0000-0000-C000-000000000046}';
  IID_PropertyTests: TGUID = '{000C0334-0000-0000-C000-000000000046}';
  IID_FileSearch: TGUID = '{000C0332-0000-0000-C000-000000000046}';
  IID_COMAddIn: TGUID = '{000C033A-0000-0000-C000-000000000046}';
  IID_COMAddIns: TGUID = '{000C0339-0000-0000-C000-000000000046}';
  IID_LanguageSettings: TGUID = '{000C0353-0000-0000-C000-000000000046}';
  IID_ICommandBarsEvents: TGUID = '{55F88892-7708-11D1-ACEB-006008961DA5}';
  DIID__CommandBarsEvents: TGUID = '{000C0352-0000-0000-C000-000000000046}';
  CLASS_CommandBars: TGUID = '{55F88893-7708-11D1-ACEB-006008961DA5}';
  IID_ICommandBarComboBoxEvents: TGUID = '{55F88896-7708-11D1-ACEB-006008961DA5}';
  DIID__CommandBarComboBoxEvents: TGUID = '{000C0354-0000-0000-C000-000000000046}';
  CLASS_CommandBarComboBox: TGUID = '{55F88897-7708-11D1-ACEB-006008961DA5}';
  IID_ICommandBarButtonEvents: TGUID = '{55F88890-7708-11D1-ACEB-006008961DA5}';
  DIID__CommandBarButtonEvents: TGUID = '{000C0351-0000-0000-C000-000000000046}';
  CLASS_CommandBarButton: TGUID = '{55F88891-7708-11D1-ACEB-006008961DA5}';
  IID_WebPageFont: TGUID = '{000C0913-0000-0000-C000-000000000046}';
  IID_WebPageFonts: TGUID = '{000C0914-0000-0000-C000-000000000046}';
  IID_HTMLProjectItem: TGUID = '{000C0358-0000-0000-C000-000000000046}';
  IID_HTMLProjectItems: TGUID = '{000C0357-0000-0000-C000-000000000046}';
  IID_HTMLProject: TGUID = '{000C0356-0000-0000-C000-000000000046}';
  IID_MsoDebugOptions: TGUID = '{000C035A-0000-0000-C000-000000000046}';

// *********************************************************************//
// Declaration of Enumerations defined in Type Library                    
// *********************************************************************//
// Constants for enum MsoLineDashStyle
type
  MsoLineDashStyle = TOleEnum;
const
  msoLineDashStyleMixed = $FFFFFFFE;
  msoLineSolid = $00000001;
  msoLineSquareDot = $00000002;
  msoLineRoundDot = $00000003;
  msoLineDash = $00000004;
  msoLineDashDot = $00000005;
  msoLineDashDotDot = $00000006;
  msoLineLongDash = $00000007;
  msoLineLongDashDot = $00000008;

// Constants for enum MsoLineStyle
type
  MsoLineStyle = TOleEnum;
const
  msoLineStyleMixed = $FFFFFFFE;
  msoLineSingle = $00000001;
  msoLineThinThin = $00000002;
  msoLineThinThick = $00000003;
  msoLineThickThin = $00000004;
  msoLineThickBetweenThin = $00000005;

// Constants for enum MsoArrowheadStyle
type
  MsoArrowheadStyle = TOleEnum;
const
  msoArrowheadStyleMixed = $FFFFFFFE;
  msoArrowheadNone = $00000001;
  msoArrowheadTriangle = $00000002;
  msoArrowheadOpen = $00000003;
  msoArrowheadStealth = $00000004;
  msoArrowheadDiamond = $00000005;
  msoArrowheadOval = $00000006;

// Constants for enum MsoArrowheadWidth
type
  MsoArrowheadWidth = TOleEnum;
const
  msoArrowheadWidthMixed = $FFFFFFFE;
  msoArrowheadNarrow = $00000001;
  msoArrowheadWidthMedium = $00000002;
  msoArrowheadWide = $00000003;

// Constants for enum MsoArrowheadLength
type
  MsoArrowheadLength = TOleEnum;
const
  msoArrowheadLengthMixed = $FFFFFFFE;
  msoArrowheadShort = $00000001;
  msoArrowheadLengthMedium = $00000002;
  msoArrowheadLong = $00000003;

// Constants for enum MsoFillType
type
  MsoFillType = TOleEnum;
const
  msoFillMixed = $FFFFFFFE;
  msoFillSolid = $00000001;
  msoFillPatterned = $00000002;
  msoFillGradient = $00000003;
  msoFillTextured = $00000004;
  msoFillBackground = $00000005;
  msoFillPicture = $00000006;

// Constants for enum MsoGradientStyle
type
  MsoGradientStyle = TOleEnum;
const
  msoGradientMixed = $FFFFFFFE;
  msoGradientHorizontal = $00000001;
  msoGradientVertical = $00000002;
  msoGradientDiagonalUp = $00000003;
  msoGradientDiagonalDown = $00000004;
  msoGradientFromCorner = $00000005;
  msoGradientFromTitle = $00000006;
  msoGradientFromCenter = $00000007;

// Constants for enum MsoGradientColorType
type
  MsoGradientColorType = TOleEnum;
const
  msoGradientColorMixed = $FFFFFFFE;
  msoGradientOneColor = $00000001;
  msoGradientTwoColors = $00000002;
  msoGradientPresetColors = $00000003;

// Constants for enum MsoTextureType
type
  MsoTextureType = TOleEnum;
const
  msoTextureTypeMixed = $FFFFFFFE;
  msoTexturePreset = $00000001;
  msoTextureUserDefined = $00000002;

// Constants for enum MsoPresetTexture
type
  MsoPresetTexture = TOleEnum;
const
  msoPresetTextureMixed = $FFFFFFFE;
  msoTexturePapyrus = $00000001;
  msoTextureCanvas = $00000002;
  msoTextureDenim = $00000003;
  msoTextureWovenMat = $00000004;
  msoTextureWaterDroplets = $00000005;
  msoTexturePaperBag = $00000006;
  msoTextureFishFossil = $00000007;
  msoTextureSand = $00000008;
  msoTextureGreenMarble = $00000009;
  msoTextureWhiteMarble = $0000000A;
  msoTextureBrownMarble = $0000000B;
  msoTextureGranite = $0000000C;
  msoTextureNewsprint = $0000000D;
  msoTextureRecycledPaper = $0000000E;
  msoTextureParchment = $0000000F;
  msoTextureStationery = $00000010;
  msoTextureBlueTissuePaper = $00000011;
  msoTexturePinkTissuePaper = $00000012;
  msoTexturePurpleMesh = $00000013;
  msoTextureBouquet = $00000014;
  msoTextureCork = $00000015;
  msoTextureWalnut = $00000016;
  msoTextureOak = $00000017;
  msoTextureMediumWood = $00000018;

// Constants for enum MsoPatternType
type
  MsoPatternType = TOleEnum;
const
  msoPatternMixed = $FFFFFFFE;
  msoPattern5Percent = $00000001;
  msoPattern10Percent = $00000002;
  msoPattern20Percent = $00000003;
  msoPattern25Percent = $00000004;
  msoPattern30Percent = $00000005;
  msoPattern40Percent = $00000006;
  msoPattern50Percent = $00000007;
  msoPattern60Percent = $00000008;
  msoPattern70Percent = $00000009;
  msoPattern75Percent = $0000000A;
  msoPattern80Percent = $0000000B;
  msoPattern90Percent = $0000000C;
  msoPatternDarkHorizontal = $0000000D;
  msoPatternDarkVertical = $0000000E;
  msoPatternDarkDownwardDiagonal = $0000000F;
  msoPatternDarkUpwardDiagonal = $00000010;
  msoPatternSmallCheckerBoard = $00000011;
  msoPatternTrellis = $00000012;
  msoPatternLightHorizontal = $00000013;
  msoPatternLightVertical = $00000014;
  msoPatternLightDownwardDiagonal = $00000015;
  msoPatternLightUpwardDiagonal = $00000016;
  msoPatternSmallGrid = $00000017;
  msoPatternDottedDiamond = $00000018;
  msoPatternWideDownwardDiagonal = $00000019;
  msoPatternWideUpwardDiagonal = $0000001A;
  msoPatternDashedUpwardDiagonal = $0000001B;
  msoPatternDashedDownwardDiagonal = $0000001C;
  msoPatternNarrowVertical = $0000001D;
  msoPatternNarrowHorizontal = $0000001E;
  msoPatternDashedVertical = $0000001F;
  msoPatternDashedHorizontal = $00000020;
  msoPatternLargeConfetti = $00000021;
  msoPatternLargeGrid = $00000022;
  msoPatternHorizontalBrick = $00000023;
  msoPatternLargeCheckerBoard = $00000024;
  msoPatternSmallConfetti = $00000025;
  msoPatternZigZag = $00000026;
  msoPatternSolidDiamond = $00000027;
  msoPatternDiagonalBrick = $00000028;
  msoPatternOutlinedDiamond = $00000029;
  msoPatternPlaid = $0000002A;
  msoPatternSphere = $0000002B;
  msoPatternWeave = $0000002C;
  msoPatternDottedGrid = $0000002D;
  msoPatternDivot = $0000002E;
  msoPatternShingle = $0000002F;
  msoPatternWave = $00000030;

// Constants for enum MsoPresetGradientType
type
  MsoPresetGradientType = TOleEnum;
const
  msoPresetGradientMixed = $FFFFFFFE;
  msoGradientEarlySunset = $00000001;
  msoGradientLateSunset = $00000002;
  msoGradientNightfall = $00000003;
  msoGradientDaybreak = $00000004;
  msoGradientHorizon = $00000005;
  msoGradientDesert = $00000006;
  msoGradientOcean = $00000007;
  msoGradientCalmWater = $00000008;
  msoGradientFire = $00000009;
  msoGradientFog = $0000000A;
  msoGradientMoss = $0000000B;
  msoGradientPeacock = $0000000C;
  msoGradientWheat = $0000000D;
  msoGradientParchment = $0000000E;
  msoGradientMahogany = $0000000F;
  msoGradientRainbow = $00000010;
  msoGradientRainbowII = $00000011;
  msoGradientGold = $00000012;
  msoGradientGoldII = $00000013;
  msoGradientBrass = $00000014;
  msoGradientChrome = $00000015;
  msoGradientChromeII = $00000016;
  msoGradientSilver = $00000017;
  msoGradientSapphire = $00000018;

// Constants for enum MsoShadowType
type
  MsoShadowType = TOleEnum;
const
  msoShadowMixed = $FFFFFFFE;
  msoShadow1 = $00000001;
  msoShadow2 = $00000002;
  msoShadow3 = $00000003;
  msoShadow4 = $00000004;
  msoShadow5 = $00000005;
  msoShadow6 = $00000006;
  msoShadow7 = $00000007;
  msoShadow8 = $00000008;
  msoShadow9 = $00000009;
  msoShadow10 = $0000000A;
  msoShadow11 = $0000000B;
  msoShadow12 = $0000000C;
  msoShadow13 = $0000000D;
  msoShadow14 = $0000000E;
  msoShadow15 = $0000000F;
  msoShadow16 = $00000010;
  msoShadow17 = $00000011;
  msoShadow18 = $00000012;
  msoShadow19 = $00000013;
  msoShadow20 = $00000014;

// Constants for enum MsoPresetTextEffect
type
  MsoPresetTextEffect = TOleEnum;
const
  msoTextEffectMixed = $FFFFFFFE;
  msoTextEffect1 = $00000000;
  msoTextEffect2 = $00000001;
  msoTextEffect3 = $00000002;
  msoTextEffect4 = $00000003;
  msoTextEffect5 = $00000004;
  msoTextEffect6 = $00000005;
  msoTextEffect7 = $00000006;
  msoTextEffect8 = $00000007;
  msoTextEffect9 = $00000008;
  msoTextEffect10 = $00000009;
  msoTextEffect11 = $0000000A;
  msoTextEffect12 = $0000000B;
  msoTextEffect13 = $0000000C;
  msoTextEffect14 = $0000000D;
  msoTextEffect15 = $0000000E;
  msoTextEffect16 = $0000000F;
  msoTextEffect17 = $00000010;
  msoTextEffect18 = $00000011;
  msoTextEffect19 = $00000012;
  msoTextEffect20 = $00000013;
  msoTextEffect21 = $00000014;
  msoTextEffect22 = $00000015;
  msoTextEffect23 = $00000016;
  msoTextEffect24 = $00000017;
  msoTextEffect25 = $00000018;
  msoTextEffect26 = $00000019;
  msoTextEffect27 = $0000001A;
  msoTextEffect28 = $0000001B;
  msoTextEffect29 = $0000001C;
  msoTextEffect30 = $0000001D;

// Constants for enum MsoPresetTextEffectShape
type
  MsoPresetTextEffectShape = TOleEnum;
const
  msoTextEffectShapeMixed = $FFFFFFFE;
  msoTextEffectShapePlainText = $00000001;
  msoTextEffectShapeStop = $00000002;
  msoTextEffectShapeTriangleUp = $00000003;
  msoTextEffectShapeTriangleDown = $00000004;
  msoTextEffectShapeChevronUp = $00000005;
  msoTextEffectShapeChevronDown = $00000006;
  msoTextEffectShapeRingInside = $00000007;
  msoTextEffectShapeRingOutside = $00000008;
  msoTextEffectShapeArchUpCurve = $00000009;
  msoTextEffectShapeArchDownCurve = $0000000A;
  msoTextEffectShapeCircleCurve = $0000000B;
  msoTextEffectShapeButtonCurve = $0000000C;
  msoTextEffectShapeArchUpPour = $0000000D;
  msoTextEffectShapeArchDownPour = $0000000E;
  msoTextEffectShapeCirclePour = $0000000F;
  msoTextEffectShapeButtonPour = $00000010;
  msoTextEffectShapeCurveUp = $00000011;
  msoTextEffectShapeCurveDown = $00000012;
  msoTextEffectShapeCanUp = $00000013;
  msoTextEffectShapeCanDown = $00000014;
  msoTextEffectShapeWave1 = $00000015;
  msoTextEffectShapeWave2 = $00000016;
  msoTextEffectShapeDoubleWave1 = $00000017;
  msoTextEffectShapeDoubleWave2 = $00000018;
  msoTextEffectShapeInflate = $00000019;
  msoTextEffectShapeDeflate = $0000001A;
  msoTextEffectShapeInflateBottom = $0000001B;
  msoTextEffectShapeDeflateBottom = $0000001C;
  msoTextEffectShapeInflateTop = $0000001D;
  msoTextEffectShapeDeflateTop = $0000001E;
  msoTextEffectShapeDeflateInflate = $0000001F;
  msoTextEffectShapeDeflateInflateDeflate = $00000020;
  msoTextEffectShapeFadeRight = $00000021;
  msoTextEffectShapeFadeLeft = $00000022;
  msoTextEffectShapeFadeUp = $00000023;
  msoTextEffectShapeFadeDown = $00000024;
  msoTextEffectShapeSlantUp = $00000025;
  msoTextEffectShapeSlantDown = $00000026;
  msoTextEffectShapeCascadeUp = $00000027;
  msoTextEffectShapeCascadeDown = $00000028;

// Constants for enum MsoTextEffectAlignment
type
  MsoTextEffectAlignment = TOleEnum;
const
  msoTextEffectAlignmentMixed = $FFFFFFFE;
  msoTextEffectAlignmentLeft = $00000001;
  msoTextEffectAlignmentCentered = $00000002;
  msoTextEffectAlignmentRight = $00000003;
  msoTextEffectAlignmentLetterJustify = $00000004;
  msoTextEffectAlignmentWordJustify = $00000005;
  msoTextEffectAlignmentStretchJustify = $00000006;

// Constants for enum MsoPresetLightingDirection
type
  MsoPresetLightingDirection = TOleEnum;
const
  msoPresetLightingDirectionMixed = $FFFFFFFE;
  msoLightingTopLeft = $00000001;
  msoLightingTop = $00000002;
  msoLightingTopRight = $00000003;
  msoLightingLeft = $00000004;
  msoLightingNone = $00000005;
  msoLightingRight = $00000006;
  msoLightingBottomLeft = $00000007;
  msoLightingBottom = $00000008;
  msoLightingBottomRight = $00000009;

// Constants for enum MsoPresetLightingSoftness
type
  MsoPresetLightingSoftness = TOleEnum;
const
  msoPresetLightingSoftnessMixed = $FFFFFFFE;
  msoLightingDim = $00000001;
  msoLightingNormal = $00000002;
  msoLightingBright = $00000003;

// Constants for enum MsoPresetMaterial
type
  MsoPresetMaterial = TOleEnum;
const
  msoPresetMaterialMixed = $FFFFFFFE;
  msoMaterialMatte = $00000001;
  msoMaterialPlastic = $00000002;
  msoMaterialMetal = $00000003;
  msoMaterialWireFrame = $00000004;

// Constants for enum MsoPresetExtrusionDirection
type
  MsoPresetExtrusionDirection = TOleEnum;
const
  msoPresetExtrusionDirectionMixed = $FFFFFFFE;
  msoExtrusionBottomRight = $00000001;
  msoExtrusionBottom = $00000002;
  msoExtrusionBottomLeft = $00000003;
  msoExtrusionRight = $00000004;
  msoExtrusionNone = $00000005;
  msoExtrusionLeft = $00000006;
  msoExtrusionTopRight = $00000007;
  msoExtrusionTop = $00000008;
  msoExtrusionTopLeft = $00000009;

// Constants for enum MsoPresetThreeDFormat
type
  MsoPresetThreeDFormat = TOleEnum;
const
  msoPresetThreeDFormatMixed = $FFFFFFFE;
  msoThreeD1 = $00000001;
  msoThreeD2 = $00000002;
  msoThreeD3 = $00000003;
  msoThreeD4 = $00000004;
  msoThreeD5 = $00000005;
  msoThreeD6 = $00000006;
  msoThreeD7 = $00000007;
  msoThreeD8 = $00000008;
  msoThreeD9 = $00000009;
  msoThreeD10 = $0000000A;
  msoThreeD11 = $0000000B;
  msoThreeD12 = $0000000C;
  msoThreeD13 = $0000000D;
  msoThreeD14 = $0000000E;
  msoThreeD15 = $0000000F;
  msoThreeD16 = $00000010;
  msoThreeD17 = $00000011;
  msoThreeD18 = $00000012;
  msoThreeD19 = $00000013;
  msoThreeD20 = $00000014;

// Constants for enum MsoExtrusionColorType
type
  MsoExtrusionColorType = TOleEnum;
const
  msoExtrusionColorTypeMixed = $FFFFFFFE;
  msoExtrusionColorAutomatic = $00000001;
  msoExtrusionColorCustom = $00000002;

// Constants for enum MsoAlignCmd
type
  MsoAlignCmd = TOleEnum;
const
  msoAlignLefts = $00000000;
  msoAlignCenters = $00000001;
  msoAlignRights = $00000002;
  msoAlignTops = $00000003;
  msoAlignMiddles = $00000004;
  msoAlignBottoms = $00000005;

// Constants for enum MsoDistributeCmd
type
  MsoDistributeCmd = TOleEnum;
const
  msoDistributeHorizontally = $00000000;
  msoDistributeVertically = $00000001;

// Constants for enum MsoConnectorType
type
  MsoConnectorType = TOleEnum;
const
  msoConnectorTypeMixed = $FFFFFFFE;
  msoConnectorStraight = $00000001;
  msoConnectorElbow = $00000002;
  msoConnectorCurve = $00000003;

// Constants for enum MsoHorizontalAnchor
type
  MsoHorizontalAnchor = TOleEnum;
const
  msoHorizontalAnchorMixed = $FFFFFFFE;
  msoAnchorNone = $00000001;
  msoAnchorCenter = $00000002;

// Constants for enum MsoVerticalAnchor
type
  MsoVerticalAnchor = TOleEnum;
const
  msoVerticalAnchorMixed = $FFFFFFFE;
  msoAnchorTop = $00000001;
  msoAnchorTopBaseline = $00000002;
  msoAnchorMiddle = $00000003;
  msoAnchorBottom = $00000004;
  msoAnchorBottomBaseLine = $00000005;

// Constants for enum MsoOrientation
type
  MsoOrientation = TOleEnum;
const
  msoOrientationMixed = $FFFFFFFE;
  msoOrientationHorizontal = $00000001;
  msoOrientationVertical = $00000002;

// Constants for enum MsoZOrderCmd
type
  MsoZOrderCmd = TOleEnum;
const
  msoBringToFront = $00000000;
  msoSendToBack = $00000001;
  msoBringForward = $00000002;
  msoSendBackward = $00000003;
  msoBringInFrontOfText = $00000004;
  msoSendBehindText = $00000005;

// Constants for enum MsoSegmentType
type
  MsoSegmentType = TOleEnum;
const
  msoSegmentLine = $00000000;
  msoSegmentCurve = $00000001;

// Constants for enum MsoEditingType
type
  MsoEditingType = TOleEnum;
const
  msoEditingAuto = $00000000;
  msoEditingCorner = $00000001;
  msoEditingSmooth = $00000002;
  msoEditingSymmetric = $00000003;

// Constants for enum MsoAutoShapeType
type
  MsoAutoShapeType = TOleEnum;
const
  msoShapeMixed = $FFFFFFFE;
  msoShapeRectangle = $00000001;
  msoShapeParallelogram = $00000002;
  msoShapeTrapezoid = $00000003;
  msoShapeDiamond = $00000004;
  msoShapeRoundedRectangle = $00000005;
  msoShapeOctagon = $00000006;
  msoShapeIsoscelesTriangle = $00000007;
  msoShapeRightTriangle = $00000008;
  msoShapeOval = $00000009;
  msoShapeHexagon = $0000000A;
  msoShapeCross = $0000000B;
  msoShapeRegularPentagon = $0000000C;
  msoShapeCan = $0000000D;
  msoShapeCube = $0000000E;
  msoShapeBevel = $0000000F;
  msoShapeFoldedCorner = $00000010;
  msoShapeSmileyFace = $00000011;
  msoShapeDonut = $00000012;
  msoShapeNoSymbol = $00000013;
  msoShapeBlockArc = $00000014;
  msoShapeHeart = $00000015;
  msoShapeLightningBolt = $00000016;
  msoShapeSun = $00000017;
  msoShapeMoon = $00000018;
  msoShapeArc = $00000019;
  msoShapeDoubleBracket = $0000001A;
  msoShapeDoubleBrace = $0000001B;
  msoShapePlaque = $0000001C;
  msoShapeLeftBracket = $0000001D;
  msoShapeRightBracket = $0000001E;
  msoShapeLeftBrace = $0000001F;
  msoShapeRightBrace = $00000020;
  msoShapeRightArrow = $00000021;
  msoShapeLeftArrow = $00000022;
  msoShapeUpArrow = $00000023;
  msoShapeDownArrow = $00000024;
  msoShapeLeftRightArrow = $00000025;
  msoShapeUpDownArrow = $00000026;
  msoShapeQuadArrow = $00000027;
  msoShapeLeftRightUpArrow = $00000028;
  msoShapeBentArrow = $00000029;
  msoShapeUTurnArrow = $0000002A;
  msoShapeLeftUpArrow = $0000002B;
  msoShapeBentUpArrow = $0000002C;
  msoShapeCurvedRightArrow = $0000002D;
  msoShapeCurvedLeftArrow = $0000002E;
  msoShapeCurvedUpArrow = $0000002F;
  msoShapeCurvedDownArrow = $00000030;
  msoShapeStripedRightArrow = $00000031;
  msoShapeNotchedRightArrow = $00000032;
  msoShapePentagon = $00000033;
  msoShapeChevron = $00000034;
  msoShapeRightArrowCallout = $00000035;
  msoShapeLeftArrowCallout = $00000036;
  msoShapeUpArrowCallout = $00000037;
  msoShapeDownArrowCallout = $00000038;
  msoShapeLeftRightArrowCallout = $00000039;
  msoShapeUpDownArrowCallout = $0000003A;
  msoShapeQuadArrowCallout = $0000003B;
  msoShapeCircularArrow = $0000003C;
  msoShapeFlowchartProcess = $0000003D;
  msoShapeFlowchartAlternateProcess = $0000003E;
  msoShapeFlowchartDecision = $0000003F;
  msoShapeFlowchartData = $00000040;
  msoShapeFlowchartPredefinedProcess = $00000041;
  msoShapeFlowchartInternalStorage = $00000042;
  msoShapeFlowchartDocument = $00000043;
  msoShapeFlowchartMultidocument = $00000044;
  msoShapeFlowchartTerminator = $00000045;
  msoShapeFlowchartPreparation = $00000046;
  msoShapeFlowchartManualInput = $00000047;
  msoShapeFlowchartManualOperation = $00000048;
  msoShapeFlowchartConnector = $00000049;
  msoShapeFlowchartOffpageConnector = $0000004A;
  msoShapeFlowchartCard = $0000004B;
  msoShapeFlowchartPunchedTape = $0000004C;
  msoShapeFlowchartSummingJunction = $0000004D;
  msoShapeFlowchartOr = $0000004E;
  msoShapeFlowchartCollate = $0000004F;
  msoShapeFlowchartSort = $00000050;
  msoShapeFlowchartExtract = $00000051;
  msoShapeFlowchartMerge = $00000052;
  msoShapeFlowchartStoredData = $00000053;
  msoShapeFlowchartDelay = $00000054;
  msoShapeFlowchartSequentialAccessStorage = $00000055;
  msoShapeFlowchartMagneticDisk = $00000056;
  msoShapeFlowchartDirectAccessStorage = $00000057;
  msoShapeFlowchartDisplay = $00000058;
  msoShapeExplosion1 = $00000059;
  msoShapeExplosion2 = $0000005A;
  msoShape4pointStar = $0000005B;
  msoShape5pointStar = $0000005C;
  msoShape8pointStar = $0000005D;
  msoShape16pointStar = $0000005E;
  msoShape24pointStar = $0000005F;
  msoShape32pointStar = $00000060;
  msoShapeUpRibbon = $00000061;
  msoShapeDownRibbon = $00000062;
  msoShapeCurvedUpRibbon = $00000063;
  msoShapeCurvedDownRibbon = $00000064;
  msoShapeVerticalScroll = $00000065;
  msoShapeHorizontalScroll = $00000066;
  msoShapeWave = $00000067;
  msoShapeDoubleWave = $00000068;
  msoShapeRectangularCallout = $00000069;
  msoShapeRoundedRectangularCallout = $0000006A;
  msoShapeOvalCallout = $0000006B;
  msoShapeCloudCallout = $0000006C;
  msoShapeLineCallout1 = $0000006D;
  msoShapeLineCallout2 = $0000006E;
  msoShapeLineCallout3 = $0000006F;
  msoShapeLineCallout4 = $00000070;
  msoShapeLineCallout1AccentBar = $00000071;
  msoShapeLineCallout2AccentBar = $00000072;
  msoShapeLineCallout3AccentBar = $00000073;
  msoShapeLineCallout4AccentBar = $00000074;
  msoShapeLineCallout1NoBorder = $00000075;
  msoShapeLineCallout2NoBorder = $00000076;
  msoShapeLineCallout3NoBorder = $00000077;
  msoShapeLineCallout4NoBorder = $00000078;
  msoShapeLineCallout1BorderandAccentBar = $00000079;
  msoShapeLineCallout2BorderandAccentBar = $0000007A;
  msoShapeLineCallout3BorderandAccentBar = $0000007B;
  msoShapeLineCallout4BorderandAccentBar = $0000007C;
  msoShapeActionButtonCustom = $0000007D;
  msoShapeActionButtonHome = $0000007E;
  msoShapeActionButtonHelp = $0000007F;
  msoShapeActionButtonInformation = $00000080;
  msoShapeActionButtonBackorPrevious = $00000081;
  msoShapeActionButtonForwardorNext = $00000082;
  msoShapeActionButtonBeginning = $00000083;
  msoShapeActionButtonEnd = $00000084;
  msoShapeActionButtonReturn = $00000085;
  msoShapeActionButtonDocument = $00000086;
  msoShapeActionButtonSound = $00000087;
  msoShapeActionButtonMovie = $00000088;
  msoShapeBalloon = $00000089;
  msoShapeNotPrimitive = $0000008A;

// Constants for enum MsoShapeType
type
  MsoShapeType = TOleEnum;
const
  msoShapeTypeMixed = $FFFFFFFE;
  msoAutoShape = $00000001;
  msoCallout = $00000002;
  msoChart = $00000003;
  msoComment = $00000004;
  msoFreeform = $00000005;
  msoGroup = $00000006;
  msoEmbeddedOLEObject = $00000007;
  msoFormControl = $00000008;
  msoLine = $00000009;
  msoLinkedOLEObject = $0000000A;
  msoLinkedPicture = $0000000B;
  msoOLEControlObject = $0000000C;
  msoPicture = $0000000D;
  msoPlaceholder = $0000000E;
  msoTextEffect = $0000000F;
  msoMedia = $00000010;
  msoTextBox = $00000011;
  msoScriptAnchor = $00000012;
  msoTable = $00000013;

// Constants for enum MsoFlipCmd
type
  MsoFlipCmd = TOleEnum;
const
  msoFlipHorizontal = $00000000;
  msoFlipVertical = $00000001;

// Constants for enum MsoTriState
type
  MsoTriState = TOleEnum;
const
  msoTrue = $FFFFFFFF;
  msoFalse = $00000000;
  msoCTrue = $00000001;
  msoTriStateToggle = $FFFFFFFD;
  msoTriStateMixed = $FFFFFFFE;

// Constants for enum MsoColorType
type
  MsoColorType = TOleEnum;
const
  msoColorTypeMixed = $FFFFFFFE;
  msoColorTypeRGB = $00000001;
  msoColorTypeScheme = $00000002;

// Constants for enum MsoPictureColorType
type
  MsoPictureColorType = TOleEnum;
const
  msoPictureMixed = $FFFFFFFE;
  msoPictureAutomatic = $00000001;
  msoPictureGrayscale = $00000002;
  msoPictureBlackAndWhite = $00000003;
  msoPictureWatermark = $00000004;

// Constants for enum MsoCalloutAngleType
type
  MsoCalloutAngleType = TOleEnum;
const
  msoCalloutAngleMixed = $FFFFFFFE;
  msoCalloutAngleAutomatic = $00000001;
  msoCalloutAngle30 = $00000002;
  msoCalloutAngle45 = $00000003;
  msoCalloutAngle60 = $00000004;
  msoCalloutAngle90 = $00000005;

// Constants for enum MsoCalloutDropType
type
  MsoCalloutDropType = TOleEnum;
const
  msoCalloutDropMixed = $FFFFFFFE;
  msoCalloutDropCustom = $00000001;
  msoCalloutDropTop = $00000002;
  msoCalloutDropCenter = $00000003;
  msoCalloutDropBottom = $00000004;

// Constants for enum MsoCalloutType
type
  MsoCalloutType = TOleEnum;
const
  msoCalloutMixed = $FFFFFFFE;
  msoCalloutOne = $00000001;
  msoCalloutTwo = $00000002;
  msoCalloutThree = $00000003;
  msoCalloutFour = $00000004;

// Constants for enum MsoBlackWhiteMode
type
  MsoBlackWhiteMode = TOleEnum;
const
  msoBlackWhiteMixed = $FFFFFFFE;
  msoBlackWhiteAutomatic = $00000001;
  msoBlackWhiteGrayScale = $00000002;
  msoBlackWhiteLightGrayScale = $00000003;
  msoBlackWhiteInverseGrayScale = $00000004;
  msoBlackWhiteGrayOutline = $00000005;
  msoBlackWhiteBlackTextAndLine = $00000006;
  msoBlackWhiteHighContrast = $00000007;
  msoBlackWhiteBlack = $00000008;
  msoBlackWhiteWhite = $00000009;
  msoBlackWhiteDontShow = $0000000A;

// Constants for enum MsoMixedType
type
  MsoMixedType = TOleEnum;
const
  msoIntegerMixed = $00008000;
  msoSingleMixed = $80000000;

// Constants for enum MsoTextOrientation
type
  MsoTextOrientation = TOleEnum;
const
  msoTextOrientationMixed = $FFFFFFFE;
  msoTextOrientationHorizontal = $00000001;
  msoTextOrientationUpward = $00000002;
  msoTextOrientationDownward = $00000003;
  msoTextOrientationVerticalFarEast = $00000004;
  msoTextOrientationVertical = $00000005;
  msoTextOrientationHorizontalRotatedFarEast = $00000006;

// Constants for enum MsoScaleFrom
type
  MsoScaleFrom = TOleEnum;
const
  msoScaleFromTopLeft = $00000000;
  msoScaleFromMiddle = $00000001;
  msoScaleFromBottomRight = $00000002;

// Constants for enum MsoBarPosition
type
  MsoBarPosition = TOleEnum;
const
  msoBarLeft = $00000000;
  msoBarTop = $00000001;
  msoBarRight = $00000002;
  msoBarBottom = $00000003;
  msoBarFloating = $00000004;
  msoBarPopup = $00000005;
  msoBarMenuBar = $00000006;

// Constants for enum MsoBarProtection
type
  MsoBarProtection = TOleEnum;
const
  msoBarNoProtection = $00000000;
  msoBarNoCustomize = $00000001;
  msoBarNoResize = $00000002;
  msoBarNoMove = $00000004;
  msoBarNoChangeVisible = $00000008;
  msoBarNoChangeDock = $00000010;
  msoBarNoVerticalDock = $00000020;
  msoBarNoHorizontalDock = $00000040;

// Constants for enum MsoBarType
type
  MsoBarType = TOleEnum;
const
  msoBarTypeNormal = $00000000;
  msoBarTypeMenuBar = $00000001;
  msoBarTypePopup = $00000002;

// Constants for enum MsoControlType
type
  MsoControlType = TOleEnum;
const
  msoControlCustom = $00000000;
  msoControlButton = $00000001;
  msoControlEdit = $00000002;
  msoControlDropdown = $00000003;
  msoControlComboBox = $00000004;
  msoControlButtonDropdown = $00000005;
  msoControlSplitDropdown = $00000006;
  msoControlOCXDropdown = $00000007;
  msoControlGenericDropdown = $00000008;
  msoControlGraphicDropdown = $00000009;
  msoControlPopup = $0000000A;
  msoControlGraphicPopup = $0000000B;
  msoControlButtonPopup = $0000000C;
  msoControlSplitButtonPopup = $0000000D;
  msoControlSplitButtonMRUPopup = $0000000E;
  msoControlLabel = $0000000F;
  msoControlExpandingGrid = $00000010;
  msoControlSplitExpandingGrid = $00000011;
  msoControlGrid = $00000012;
  msoControlGauge = $00000013;
  msoControlGraphicCombo = $00000014;
  msoControlPane = $00000015;
  msoControlActiveX = $00000016;

// Constants for enum MsoButtonState
type
  MsoButtonState = TOleEnum;
const
  msoButtonUp = $00000000;
  msoButtonDown = $FFFFFFFF;
  msoButtonMixed = $00000002;

// Constants for enum MsoControlOLEUsage
type
  MsoControlOLEUsage = TOleEnum;
const
  msoControlOLEUsageNeither = $00000000;
  msoControlOLEUsageServer = $00000001;
  msoControlOLEUsageClient = $00000002;
  msoControlOLEUsageBoth = $00000003;

// Constants for enum MsoButtonStyleHidden
type
  MsoButtonStyleHidden = TOleEnum;
const
  msoButtonWrapText = $00000004;
  msoButtonTextBelow = $00000008;

// Constants for enum MsoButtonStyle
type
  MsoButtonStyle = TOleEnum;
const
  msoButtonAutomatic = $00000000;
  msoButtonIcon = $00000001;
  msoButtonCaption = $00000002;
  msoButtonIconAndCaption = $00000003;
  msoButtonIconAndWrapCaption = $00000007;
  msoButtonIconAndCaptionBelow = $0000000B;
  msoButtonWrapCaption = $0000000E;
  msoButtonIconAndWrapCaptionBelow = $0000000F;

// Constants for enum MsoComboStyle
type
  MsoComboStyle = TOleEnum;
const
  msoComboNormal = $00000000;
  msoComboLabel = $00000001;

// Constants for enum MsoOLEMenuGroup
type
  MsoOLEMenuGroup = TOleEnum;
const
  msoOLEMenuGroupNone = $FFFFFFFF;
  msoOLEMenuGroupFile = $00000000;
  msoOLEMenuGroupEdit = $00000001;
  msoOLEMenuGroupContainer = $00000002;
  msoOLEMenuGroupObject = $00000003;
  msoOLEMenuGroupWindow = $00000004;
  msoOLEMenuGroupHelp = $00000005;

// Constants for enum MsoMenuAnimation
type
  MsoMenuAnimation = TOleEnum;
const
  msoMenuAnimationNone = $00000000;
  msoMenuAnimationRandom = $00000001;
  msoMenuAnimationUnfold = $00000002;
  msoMenuAnimationSlide = $00000003;

// Constants for enum MsoBarRow
type
  MsoBarRow = TOleEnum;
const
  msoBarRowFirst = $00000000;
  msoBarRowLast = $FFFFFFFF;

// Constants for enum MsoCommandBarButtonHyperlinkType
type
  MsoCommandBarButtonHyperlinkType = TOleEnum;
const
  msoCommandBarButtonHyperlinkNone = $00000000;
  msoCommandBarButtonHyperlinkOpen = $00000001;
  msoCommandBarButtonHyperlinkInsertPicture = $00000002;

// Constants for enum MsoHyperlinkType
type
  MsoHyperlinkType = TOleEnum;
const
  msoHyperlinkRange = $00000000;
  msoHyperlinkShape = $00000001;
  msoHyperlinkInlineShape = $00000002;

// Constants for enum MsoExtraInfoMethod
type
  MsoExtraInfoMethod = TOleEnum;
const
  msoMethodGet = $00000000;
  msoMethodPost = $00000001;

// Constants for enum MsoAnimationType
type
  MsoAnimationType = TOleEnum;
const
  msoAnimationIdle = $00000001;
  msoAnimationGreeting = $00000002;
  msoAnimationGoodbye = $00000003;
  msoAnimationBeginSpeaking = $00000004;
  msoAnimationRestPose = $00000005;
  msoAnimationCharacterSuccessMajor = $00000006;
  msoAnimationGetAttentionMajor = $0000000B;
  msoAnimationGetAttentionMinor = $0000000C;
  msoAnimationSearching = $0000000D;
  msoAnimationPrinting = $00000012;
  msoAnimationGestureRight = $00000013;
  msoAnimationWritingNotingSomething = $00000016;
  msoAnimationWorkingAtSomething = $00000017;
  msoAnimationThinking = $00000018;
  msoAnimationSendingMail = $00000019;
  msoAnimationListensToComputer = $0000001A;
  msoAnimationDisappear = $0000001F;
  msoAnimationAppear = $00000020;
  msoAnimationGetArtsy = $00000064;
  msoAnimationGetTechy = $00000065;
  msoAnimationGetWizardy = $00000066;
  msoAnimationCheckingSomething = $00000067;
  msoAnimationLookDown = $00000068;
  msoAnimationLookDownLeft = $00000069;
  msoAnimationLookDownRight = $0000006A;
  msoAnimationLookLeft = $0000006B;
  msoAnimationLookRight = $0000006C;
  msoAnimationLookUp = $0000006D;
  msoAnimationLookUpLeft = $0000006E;
  msoAnimationLookUpRight = $0000006F;
  msoAnimationSaving = $00000070;
  msoAnimationGestureDown = $00000071;
  msoAnimationGestureLeft = $00000072;
  msoAnimationGestureUp = $00000073;
  msoAnimationEmptyTrash = $00000074;

// Constants for enum MsoButtonSetType
type
  MsoButtonSetType = TOleEnum;
const
  msoButtonSetNone = $00000000;
  msoButtonSetOK = $00000001;
  msoButtonSetCancel = $00000002;
  msoButtonSetOkCancel = $00000003;
  msoButtonSetYesNo = $00000004;
  msoButtonSetYesNoCancel = $00000005;
  msoButtonSetBackClose = $00000006;
  msoButtonSetNextClose = $00000007;
  msoButtonSetBackNextClose = $00000008;
  msoButtonSetRetryCancel = $00000009;
  msoButtonSetAbortRetryIgnore = $0000000A;
  msoButtonSetSearchClose = $0000000B;
  msoButtonSetBackNextSnooze = $0000000C;
  msoButtonSetTipsOptionsClose = $0000000D;
  msoButtonSetYesAllNoCancel = $0000000E;

// Constants for enum MsoIconType
type
  MsoIconType = TOleEnum;
const
  msoIconNone = $00000000;
  msoIconAlert = $00000002;
  msoIconTip = $00000003;
  msoIconAlertInfo = $00000004;
  msoIconAlertWarning = $00000005;
  msoIconAlertQuery = $00000006;
  msoIconAlertCritical = $00000007;

// Constants for enum MsoBalloonType
type
  MsoBalloonType = TOleEnum;
const
  msoBalloonTypeButtons = $00000000;
  msoBalloonTypeBullets = $00000001;
  msoBalloonTypeNumbers = $00000002;

// Constants for enum MsoModeType
type
  MsoModeType = TOleEnum;
const
  msoModeModal = $00000000;
  msoModeAutoDown = $00000001;
  msoModeModeless = $00000002;

// Constants for enum MsoBalloonErrorType
type
  MsoBalloonErrorType = TOleEnum;
const
  msoBalloonErrorNone = $00000000;
  msoBalloonErrorOther = $00000001;
  msoBalloonErrorTooBig = $00000002;
  msoBalloonErrorOutOfMemory = $00000003;
  msoBalloonErrorBadPictureRef = $00000004;
  msoBalloonErrorBadReference = $00000005;
  msoBalloonErrorButtonlessModal = $00000006;
  msoBalloonErrorButtonModeless = $00000007;
  msoBalloonErrorBadCharacter = $00000008;
  msoBalloonErrorCOMFailure = $00000009;
  msoBalloonErrorCharNotTopmostForModal = $0000000A;
  msoBalloonErrorTooManyControls = $0000000B;

// Constants for enum MsoWizardActType
type
  MsoWizardActType = TOleEnum;
const
  msoWizardActInactive = $00000000;
  msoWizardActActive = $00000001;
  msoWizardActSuspend = $00000002;
  msoWizardActResume = $00000003;

// Constants for enum MsoWizardMsgType
type
  MsoWizardMsgType = TOleEnum;
const
  msoWizardMsgLocalStateOn = $00000001;
  msoWizardMsgLocalStateOff = $00000002;
  msoWizardMsgShowHelp = $00000003;
  msoWizardMsgSuspending = $00000004;
  msoWizardMsgResuming = $00000005;

// Constants for enum MsoBalloonButtonType
type
  MsoBalloonButtonType = TOleEnum;
const
  msoBalloonButtonYesToAll = $FFFFFFF1;
  msoBalloonButtonOptions = $FFFFFFF2;
  msoBalloonButtonTips = $FFFFFFF3;
  msoBalloonButtonClose = $FFFFFFF4;
  msoBalloonButtonSnooze = $FFFFFFF5;
  msoBalloonButtonSearch = $FFFFFFF6;
  msoBalloonButtonIgnore = $FFFFFFF7;
  msoBalloonButtonAbort = $FFFFFFF8;
  msoBalloonButtonRetry = $FFFFFFF9;
  msoBalloonButtonNext = $FFFFFFFA;
  msoBalloonButtonBack = $FFFFFFFB;
  msoBalloonButtonNo = $FFFFFFFC;
  msoBalloonButtonYes = $FFFFFFFD;
  msoBalloonButtonCancel = $FFFFFFFE;
  msoBalloonButtonOK = $FFFFFFFF;
  msoBalloonButtonNull = $00000000;

// Constants for enum DocProperties
type
  DocProperties = TOleEnum;
const
  offPropertyTypeNumber = $00000001;
  offPropertyTypeBoolean = $00000002;
  offPropertyTypeDate = $00000003;
  offPropertyTypeString = $00000004;
  offPropertyTypeFloat = $00000005;

// Constants for enum MsoDocProperties
type
  MsoDocProperties = TOleEnum;
const
  msoPropertyTypeNumber = $00000001;
  msoPropertyTypeBoolean = $00000002;
  msoPropertyTypeDate = $00000003;
  msoPropertyTypeString = $00000004;
  msoPropertyTypeFloat = $00000005;

// Constants for enum MsoAppLanguageID
type
  MsoAppLanguageID = TOleEnum;
const
  msoLanguageIDInstall = $00000001;
  msoLanguageIDUI = $00000002;
  msoLanguageIDHelp = $00000003;
  msoLanguageIDExeMode = $00000004;
  msoLanguageIDUIPrevious = $00000005;

// Constants for enum MsoFarEastLineBreakLanguageID
type
  MsoFarEastLineBreakLanguageID = TOleEnum;
const
  MsoFarEastLineBreakLanguageJapanese = $00000411;
  MsoFarEastLineBreakLanguageKorean = $00000412;
  MsoFarEastLineBreakLanguageSimplifiedChinese = $00000804;
  MsoFarEastLineBreakLanguageTraditionalChinese = $00000404;

// Constants for enum MsoFeatureInstall
type
  MsoFeatureInstall = TOleEnum;
const
  msoFeatureInstallNone = $00000000;
  msoFeatureInstallOnDemand = $00000001;
  msoFeatureInstallOnDemandWithUI = $00000002;

// Constants for enum MsoScriptLanguage
type
  MsoScriptLanguage = TOleEnum;
const
  msoScriptLanguageJava = $00000001;
  msoScriptLanguageVisualBasic = $00000002;
  msoScriptLanguageASP = $00000003;
  msoScriptLanguageOther = $00000004;

// Constants for enum MsoScriptLocation
type
  MsoScriptLocation = TOleEnum;
const
  msoScriptLocationInHead = $00000001;
  msoScriptLocationInBody = $00000002;

// Constants for enum MsoFileFindOptions
type
  MsoFileFindOptions = TOleEnum;
const
  msoOptionsNew = $00000001;
  msoOptionsAdd = $00000002;
  msoOptionsWithin = $00000003;

// Constants for enum MsoFileFindView
type
  MsoFileFindView = TOleEnum;
const
  msoViewFileInfo = $00000001;
  msoViewPreview = $00000002;
  msoViewSummaryInfo = $00000003;

// Constants for enum MsoFileFindSortBy
type
  MsoFileFindSortBy = TOleEnum;
const
  msoFileFindSortbyAuthor = $00000001;
  msoFileFindSortbyDateCreated = $00000002;
  msoFileFindSortbyLastSavedBy = $00000003;
  msoFileFindSortbyDateSaved = $00000004;
  msoFileFindSortbyFileName = $00000005;
  msoFileFindSortbySize = $00000006;
  msoFileFindSortbyTitle = $00000007;

// Constants for enum MsoFileFindListBy
type
  MsoFileFindListBy = TOleEnum;
const
  msoListbyName = $00000001;
  msoListbyTitle = $00000002;

// Constants for enum MsoLastModified
type
  MsoLastModified = TOleEnum;
const
  msoLastModifiedYesterday = $00000001;
  msoLastModifiedToday = $00000002;
  msoLastModifiedLastWeek = $00000003;
  msoLastModifiedThisWeek = $00000004;
  msoLastModifiedLastMonth = $00000005;
  msoLastModifiedThisMonth = $00000006;
  msoLastModifiedAnyTime = $00000007;

// Constants for enum MsoSortBy
type
  MsoSortBy = TOleEnum;
const
  msoSortByFileName = $00000001;
  msoSortBySize = $00000002;
  msoSortByFileType = $00000003;
  msoSortByLastModified = $00000004;

// Constants for enum MsoSortOrder
type
  MsoSortOrder = TOleEnum;
const
  msoSortOrderAscending = $00000001;
  msoSortOrderDescending = $00000002;

// Constants for enum MsoConnector
type
  MsoConnector = TOleEnum;
const
  msoConnectorAnd = $00000001;
  msoConnectorOr = $00000002;

// Constants for enum MsoCondition
type
  MsoCondition = TOleEnum;
const
  msoConditionFileTypeAllFiles = $00000001;
  msoConditionFileTypeOfficeFiles = $00000002;
  msoConditionFileTypeWordDocuments = $00000003;
  msoConditionFileTypeExcelWorkbooks = $00000004;
  msoConditionFileTypePowerPointPresentations = $00000005;
  msoConditionFileTypeBinders = $00000006;
  msoConditionFileTypeDatabases = $00000007;
  msoConditionFileTypeTemplates = $00000008;
  msoConditionIncludes = $00000009;
  msoConditionIncludesPhrase = $0000000A;
  msoConditionBeginsWith = $0000000B;
  msoConditionEndsWith = $0000000C;
  msoConditionIncludesNearEachOther = $0000000D;
  msoConditionIsExactly = $0000000E;
  msoConditionIsNot = $0000000F;
  msoConditionYesterday = $00000010;
  msoConditionToday = $00000011;
  msoConditionTomorrow = $00000012;
  msoConditionLastWeek = $00000013;
  msoConditionThisWeek = $00000014;
  msoConditionNextWeek = $00000015;
  msoConditionLastMonth = $00000016;
  msoConditionThisMonth = $00000017;
  msoConditionNextMonth = $00000018;
  msoConditionAnytime = $00000019;
  msoConditionAnytimeBetween = $0000001A;
  msoConditionOn = $0000001B;
  msoConditionOnOrAfter = $0000001C;
  msoConditionOnOrBefore = $0000001D;
  msoConditionInTheNext = $0000001E;
  msoConditionInTheLast = $0000001F;
  msoConditionEquals = $00000020;
  msoConditionDoesNotEqual = $00000021;
  msoConditionAnyNumberBetween = $00000022;
  msoConditionAtMost = $00000023;
  msoConditionAtLeast = $00000024;
  msoConditionMoreThan = $00000025;
  msoConditionLessThan = $00000026;
  msoConditionIsYes = $00000027;
  msoConditionIsNo = $00000028;

// Constants for enum MsoFileType
type
  MsoFileType = TOleEnum;
const
  msoFileTypeAllFiles = $00000001;
  msoFileTypeOfficeFiles = $00000002;
  msoFileTypeWordDocuments = $00000003;
  msoFileTypeExcelWorkbooks = $00000004;
  msoFileTypePowerPointPresentations = $00000005;
  msoFileTypeBinders = $00000006;
  msoFileTypeDatabases = $00000007;
  msoFileTypeTemplates = $00000008;

// Constants for enum MsoLanguageID
type
  MsoLanguageID = TOleEnum;
const
  msoLanguageIDMixed = $FFFFFFFE;
  msoLanguageIDNone = $00000000;
  msoLanguageIDNoProofing = $00000400;
  msoLanguageIDAfrikaans = $00000436;
  msoLanguageIDAlbanian = $0000041C;
  msoLanguageIDArabicAlgeria = $00001401;
  msoLanguageIDArabicBahrain = $00003C01;
  msoLanguageIDArabicEgypt = $00000C01;
  msoLanguageIDArabicIraq = $00000801;
  msoLanguageIDArabicJordan = $00002C01;
  msoLanguageIDArabicKuwait = $00003401;
  msoLanguageIDArabicLebanon = $00003001;
  msoLanguageIDArabicLibya = $00001001;
  msoLanguageIDArabicMorocco = $00001801;
  msoLanguageIDArabicOman = $00002001;
  msoLanguageIDArabicQatar = $00004001;
  msoLanguageIDArabic = $00000401;
  msoLanguageIDArabicSyria = $00002801;
  msoLanguageIDArabicTunisia = $00001C01;
  msoLanguageIDArabicUAE = $00003801;
  msoLanguageIDArabicYemen = $00002401;
  msoLanguageIDArmenian = $0000042B;
  msoLanguageIDAssamese = $0000044D;
  msoLanguageIDAzeriCyrillic = $0000082C;
  msoLanguageIDAzeriLatin = $0000042C;
  msoLanguageIDBasque = $0000042D;
  msoLanguageIDByelorussian = $00000423;
  msoLanguageIDBengali = $00000445;
  msoLanguageIDBulgarian = $00000402;
  msoLanguageIDBurmese = $00000455;
  msoLanguageIDCatalan = $00000403;
  msoLanguageIDChineseHongKong = $00000C04;
  msoLanguageIDChineseMacao = $00001404;
  msoLanguageIDSimplifiedChinese = $00000804;
  msoLanguageIDChineseSingapore = $00001004;
  msoLanguageIDTraditionalChinese = $00000404;
  msoLanguageIDCroatian = $0000041A;
  msoLanguageIDCzech = $00000405;
  msoLanguageIDDanish = $00000406;
  msoLanguageIDBelgianDutch = $00000813;
  msoLanguageIDDutch = $00000413;
  msoLanguageIDEnglishAUS = $00000C09;
  msoLanguageIDEnglishBelize = $00002809;
  msoLanguageIDEnglishCanadian = $00001009;
  msoLanguageIDEnglishCaribbean = $00002409;
  msoLanguageIDEnglishIreland = $00001809;
  msoLanguageIDEnglishJamaica = $00002009;
  msoLanguageIDEnglishNewZealand = $00001409;
  msoLanguageIDEnglishPhilippines = $00003409;
  msoLanguageIDEnglishSouthAfrica = $00001C09;
  msoLanguageIDEnglishTrinidad = $00002C09;
  msoLanguageIDEnglishUK = $00000809;
  msoLanguageIDEnglishUS = $00000409;
  msoLanguageIDEnglishZimbabwe = $00003009;
  msoLanguageIDEstonian = $00000425;
  msoLanguageIDFaeroese = $00000438;
  msoLanguageIDFarsi = $00000429;
  msoLanguageIDFinnish = $0000040B;
  msoLanguageIDBelgianFrench = $0000080C;
  msoLanguageIDFrenchCameroon = $00002C0C;
  msoLanguageIDFrenchCanadian = $00000C0C;
  msoLanguageIDFrenchCotedIvoire = $0000300C;
  msoLanguageIDFrench = $0000040C;
  msoLanguageIDFrenchLuxembourg = $0000140C;
  msoLanguageIDFrenchMali = $0000340C;
  msoLanguageIDFrenchMonaco = $0000180C;
  msoLanguageIDFrenchReunion = $0000200C;
  msoLanguageIDFrenchSenegal = $0000280C;
  msoLanguageIDSwissFrench = $0000100C;
  msoLanguageIDFrenchWestIndies = $00001C0C;
  msoLanguageIDFrenchZaire = $0000240C;
  msoLanguageIDFrisianNetherlands = $00000462;
  msoLanguageIDGaelicIreland = $0000083C;
  msoLanguageIDGaelicScotland = $0000043C;
  msoLanguageIDGalician = $00000456;
  msoLanguageIDGeorgian = $00000437;
  msoLanguageIDGermanAustria = $00000C07;
  msoLanguageIDGerman = $00000407;
  msoLanguageIDGermanLiechtenstein = $00001407;
  msoLanguageIDGermanLuxembourg = $00001007;
  msoLanguageIDSwissGerman = $00000807;
  msoLanguageIDGreek = $00000408;
  msoLanguageIDGujarati = $00000447;
  msoLanguageIDHebrew = $0000040D;
  msoLanguageIDHindi = $00000439;
  msoLanguageIDHungarian = $0000040E;
  msoLanguageIDIcelandic = $0000040F;
  msoLanguageIDIndonesian = $00000421;
  msoLanguageIDItalian = $00000410;
  msoLanguageIDSwissItalian = $00000810;
  msoLanguageIDJapanese = $00000411;
  msoLanguageIDKannada = $0000044B;
  msoLanguageIDKashmiri = $00000460;
  msoLanguageIDKazakh = $0000043F;
  msoLanguageIDKhmer = $00000453;
  msoLanguageIDKirghiz = $00000440;
  msoLanguageIDKonkani = $00000457;
  msoLanguageIDKorean = $00000412;
  msoLanguageIDLao = $00000454;
  msoLanguageIDLatvian = $00000426;
  msoLanguageIDLithuanian = $00000427;
  msoLanguageIDMacedonian = $0000042F;
  msoLanguageIDMalaysian = $0000043E;
  msoLanguageIDMalayBruneiDarussalam = $0000083E;
  msoLanguageIDMalayalam = $0000044C;
  msoLanguageIDMaltese = $0000043A;
  msoLanguageIDManipuri = $00000458;
  msoLanguageIDMarathi = $0000044E;
  msoLanguageIDMongolian = $00000450;
  msoLanguageIDNepali = $00000461;
  msoLanguageIDNorwegianBokmol = $00000414;
  msoLanguageIDNorwegianNynorsk = $00000814;
  msoLanguageIDOriya = $00000448;
  msoLanguageIDPolish = $00000415;
  msoLanguageIDBrazilianPortuguese = $00000416;
  msoLanguageIDPortuguese = $00000816;
  msoLanguageIDPunjabi = $00000446;
  msoLanguageIDRhaetoRomanic = $00000417;
  msoLanguageIDRomanianMoldova = $00000818;
  msoLanguageIDRomanian = $00000418;
  msoLanguageIDRussianMoldova = $00000819;
  msoLanguageIDRussian = $00000419;
  msoLanguageIDSamiLappish = $0000043B;
  msoLanguageIDSanskrit = $0000044F;
  msoLanguageIDSerbianCyrillic = $00000C1A;
  msoLanguageIDSerbianLatin = $0000081A;
  msoLanguageIDSesotho = $00000430;
  msoLanguageIDSindhi = $00000459;
  msoLanguageIDSlovak = $0000041B;
  msoLanguageIDSlovenian = $00000424;
  msoLanguageIDSorbian = $0000042E;
  msoLanguageIDSpanishArgentina = $00002C0A;
  msoLanguageIDSpanishBolivia = $0000400A;
  msoLanguageIDSpanishChile = $0000340A;
  msoLanguageIDSpanishColombia = $0000240A;
  msoLanguageIDSpanishCostaRica = $0000140A;
  msoLanguageIDSpanishDominicanRepublic = $00001C0A;
  msoLanguageIDSpanishEcuador = $0000300A;
  msoLanguageIDSpanishElSalvador = $0000440A;
  msoLanguageIDSpanishGuatemala = $0000100A;
  msoLanguageIDSpanishHonduras = $0000480A;
  msoLanguageIDMexicanSpanish = $0000080A;
  msoLanguageIDSpanishNicaragua = $00004C0A;
  msoLanguageIDSpanishPanama = $0000180A;
  msoLanguageIDSpanishParaguay = $00003C0A;
  msoLanguageIDSpanishPeru = $0000280A;
  msoLanguageIDSpanishPuertoRico = $0000500A;
  msoLanguageIDSpanishModernSort = $00000C0A;
  msoLanguageIDSpanish = $0000040A;
  msoLanguageIDSpanishUruguay = $0000380A;
  msoLanguageIDSpanishVenezuela = $0000200A;
  msoLanguageIDSutu = $00000430;
  msoLanguageIDSwahili = $00000441;
  msoLanguageIDSwedishFinland = $0000081D;
  msoLanguageIDSwedish = $0000041D;
  msoLanguageIDTajik = $00000428;
  msoLanguageIDTamil = $00000449;
  msoLanguageIDTatar = $00000444;
  msoLanguageIDTelugu = $0000044A;
  msoLanguageIDThai = $0000041E;
  msoLanguageIDTibetan = $00000451;
  msoLanguageIDTsonga = $00000431;
  msoLanguageIDTswana = $00000432;
  msoLanguageIDTurkish = $0000041F;
  msoLanguageIDTurkmen = $00000442;
  msoLanguageIDUkrainian = $00000422;
  msoLanguageIDUrdu = $00000420;
  msoLanguageIDUzbekCyrillic = $00000843;
  msoLanguageIDUzbekLatin = $00000443;
  msoLanguageIDVenda = $00000433;
  msoLanguageIDVietnamese = $0000042A;
  msoLanguageIDWelsh = $00000452;
  msoLanguageIDXhosa = $00000434;
  msoLanguageIDZulu = $00000435;

// Constants for enum MsoScreenSize
type
  MsoScreenSize = TOleEnum;
const
  msoScreenSize544x376 = $00000000;
  msoScreenSize640x480 = $00000001;
  msoScreenSize720x512 = $00000002;
  msoScreenSize800x600 = $00000003;
  msoScreenSize1024x768 = $00000004;
  msoScreenSize1152x882 = $00000005;
  msoScreenSize1152x900 = $00000006;
  msoScreenSize1280x1024 = $00000007;
  msoScreenSize1600x1200 = $00000008;
  msoScreenSize1800x1440 = $00000009;
  msoScreenSize1920x1200 = $0000000A;

// Constants for enum MsoCharacterSet
type
  MsoCharacterSet = TOleEnum;
const
  msoCharacterSetArabic = $00000001;
  msoCharacterSetCyrillic = $00000002;
  msoCharacterSetEnglishWesternEuropeanOtherLatinScript = $00000003;
  msoCharacterSetGreek = $00000004;
  msoCharacterSetHebrew = $00000005;
  msoCharacterSetJapanese = $00000006;
  msoCharacterSetKorean = $00000007;
  msoCharacterSetMultilingualUnicode = $00000008;
  msoCharacterSetSimplifiedChinese = $00000009;
  msoCharacterSetThai = $0000000A;
  msoCharacterSetTraditionalChinese = $0000000B;
  msoCharacterSetVietnamese = $0000000C;

// Constants for enum MsoEncoding
type
  MsoEncoding = TOleEnum;
const
  msoEncodingThai = $0000036A;
  msoEncodingJapaneseShiftJIS = $000003A4;
  msoEncodingSimplifiedChineseGBK = $000003A8;
  msoEncodingKorean = $000003B5;
  msoEncodingTraditionalChineseBig5 = $000003B6;
  msoEncodingUnicodeLittleEndian = $000004B0;
  msoEncodingUnicodeBigEndian = $000004B1;
  msoEncodingCentralEuropean = $000004E2;
  msoEncodingCyrillic = $000004E3;
  msoEncodingWestern = $000004E4;
  msoEncodingGreek = $000004E5;
  msoEncodingTurkish = $000004E6;
  msoEncodingHebrew = $000004E7;
  msoEncodingArabic = $000004E8;
  msoEncodingBaltic = $000004E9;
  msoEncodingVietnamese = $000004EA;
  msoEncodingAutoDetect = $0000C351;
  msoEncodingJapaneseAutoDetect = $0000C6F4;
  msoEncodingSimplifiedChineseAutoDetect = $0000C6F8;
  msoEncodingKoreanAutoDetect = $0000C705;
  msoEncodingTraditionalChineseAutoDetect = $0000C706;
  msoEncodingCyrillicAutoDetect = $0000C833;
  msoEncodingGreekAutoDetect = $0000C835;
  msoEncodingArabicAutoDetect = $0000C838;
  msoEncodingISO88591Latin1 = $00006FAF;
  msoEncodingISO88592CentralEurope = $00006FB0;
  msoEncodingISO88593Latin3 = $00006FB1;
  msoEncodingISO88594Baltic = $00006FB2;
  msoEncodingISO88595Cyrillic = $00006FB3;
  msoEncodingISO88596Arabic = $00006FB4;
  msoEncodingISO88597Greek = $00006FB5;
  msoEncodingISO88598Hebrew = $00006FB6;
  msoEncodingISO88599Turkish = $00006FB7;
  msoEncodingISO885915Latin9 = $00006FBD;
  msoEncodingISO2022JPNoHalfwidthKatakana = $0000C42C;
  msoEncodingISO2022JPJISX02021984 = $0000C42D;
  msoEncodingISO2022JPJISX02011989 = $0000C42E;
  msoEncodingISO2022KR = $0000C431;
  msoEncodingISO2022CNTraditionalChinese = $0000C433;
  msoEncodingISO2022CNSimplifiedChinese = $0000C435;
  msoEncodingMacRoman = $00002710;
  msoEncodingMacJapanese = $00002711;
  msoEncodingMacTraditionalChineseBig5 = $00002712;
  msoEncodingMacKorean = $00002713;
  msoEncodingMacArabic = $00002714;
  msoEncodingMacHebrew = $00002715;
  msoEncodingMacGreek1 = $00002716;
  msoEncodingMacCyrillic = $00002717;
  msoEncodingMacSimplifiedChineseGB2312 = $00002718;
  msoEncodingMacRomania = $0000271A;
  msoEncodingMacUkraine = $00002721;
  msoEncodingMacLatin2 = $0000272D;
  msoEncodingMacIcelandic = $0000275F;
  msoEncodingMacTurkish = $00002761;
  msoEncodingMacCroatia = $00002762;
  msoEncodingEBCDICUSCanada = $00000025;
  msoEncodingEBCDICInternational = $000001F4;
  msoEncodingEBCDICMultilingualROECELatin2 = $00000366;
  msoEncodingEBCDICGreekModern = $0000036B;
  msoEncodingEBCDICTurkishLatin5 = $00000402;
  msoEncodingEBCDICGermany = $00004F31;
  msoEncodingEBCDICDenmarkNorway = $00004F35;
  msoEncodingEBCDICFinlandSweden = $00004F36;
  msoEncodingEBCDICItaly = $00004F38;
  msoEncodingEBCDICLatinAmericaSpain = $00004F3C;
  msoEncodingEBCDICUnitedKingdom = $00004F3D;
  msoEncodingEBCDICJapaneseKatakanaExtended = $00004F42;
  msoEncodingEBCDICFrance = $00004F49;
  msoEncodingEBCDICArabic = $00004FC4;
  msoEncodingEBCDICGreek = $00004FC7;
  msoEncodingEBCDICHebrew = $00004FC8;
  msoEncodingEBCDICKoreanExtended = $00005161;
  msoEncodingEBCDICThai = $00005166;
  msoEncodingEBCDICIcelandic = $00005187;
  msoEncodingEBCDICTurkish = $000051A9;
  msoEncodingEBCDICRussian = $00005190;
  msoEncodingEBCDICSerbianBulgarian = $00005221;
  msoEncodingEBCDICJapaneseKatakanaExtendedAndJapanese = $0000C6F2;
  msoEncodingEBCDICUSCanadaandJapanese = $0000C6F3;
  msoEncodingEBCDICKoreanExtendedAndKorean = $0000C6F5;
  msoEncodingEBCDICSimplifiedChineseExtendedAndSimplifiedChinese = $0000C6F7;
  msoEncodingEBCDICUSCanadaAndTraditionalChinese = $0000C6F9;
  msoEncodingEBCDICJapaneseLatinExtendedAndJapanese = $0000C6FB;
  msoEncodingOEMUnitedStates = $000001B5;
  msoEncodingOEMGreek437G = $000002E1;
  msoEncodingOEMBaltic = $00000307;
  msoEncodingOEMMultilingualLatinI = $00000352;
  msoEncodingOEMMultilingualLatinII = $00000354;
  msoEncodingOEMCyrillic = $00000357;
  msoEncodingOEMTurkish = $00000359;
  msoEncodingOEMPortuguese = $0000035C;
  msoEncodingOEMIcelandic = $0000035D;
  msoEncodingOEMHebrew = $0000035E;
  msoEncodingOEMCanadianFrench = $0000035F;
  msoEncodingOEMArabic = $00000360;
  msoEncodingOEMNordic = $00000361;
  msoEncodingOEMCyrillicII = $00000362;
  msoEncodingOEMModernGreek = $00000365;
  msoEncodingEUCJapanese = $0000CADC;
  msoEncodingEUCChineseSimplifiedChinese = $0000CAE0;
  msoEncodingEUCKorean = $0000CAED;
  msoEncodingEUCTaiwaneseTraditionalChinese = $0000CAEE;
  msoEncodingArabicASMO = $000002C4;
  msoEncodingArabicTransparentASMO = $000002D0;
  msoEncodingKoreanJohab = $00000551;
  msoEncodingTaiwanCNS = $00004E20;
  msoEncodingTaiwanTCA = $00004E21;
  msoEncodingTaiwanEten = $00004E22;
  msoEncodingTaiwanIBM5550 = $00004E23;
  msoEncodingTaiwanTeleText = $00004E24;
  msoEncodingTaiwanWang = $00004E25;
  msoEncodingIA5IRV = $00004E89;
  msoEncodingIA5German = $00004E8A;
  msoEncodingIA5Swedish = $00004E8B;
  msoEncodingIA5Norwegian = $00004E8C;
  msoEncodingUSASCII = $00004E9F;
  msoEncodingT61 = $00004F25;
  msoEncodingISO6937NonSpacingAccent = $00004F2D;
  msoEncodingKOI8R = $00005182;
  msoEncodingExtAlphaLowercase = $00005223;
  msoEncodingKOI8U = $0000556A;
  msoEncodingEuropa3 = $00007149;
  msoEncodingHZGBSimplifiedChinese = $0000CEC8;
  msoEncodingUTF7 = $0000FDE8;
  msoEncodingUTF8 = $0000FDE9;

// Constants for enum MsoHTMLProjectOpen
type
  MsoHTMLProjectOpen = TOleEnum;
const
  msoHTMLProjectOpenSourceView = $00000001;
  msoHTMLProjectOpenTextView = $00000002;

// Constants for enum MsoHTMLProjectState
type
  MsoHTMLProjectState = TOleEnum;
const
  msoHTMLProjectStateDocumentLocked = $00000001;
  msoHTMLProjectStateProjectLocked = $00000002;
  msoHTMLProjectStateDocumentProjectUnlocked = $00000003;

type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IAccessible = interface;
  IAccessibleDisp = dispinterface;
  _IMsoDispObj = interface;
  _IMsoDispObjDisp = dispinterface;
  _IMsoOleAccDispObj = interface;
  _IMsoOleAccDispObjDisp = dispinterface;
  _CommandBars = interface;
  _CommandBarsDisp = dispinterface;
  CommandBar = interface;
  CommandBarDisp = dispinterface;
  CommandBarControls = interface;
  CommandBarControlsDisp = dispinterface;
  CommandBarControl = interface;
  CommandBarControlDisp = dispinterface;
  _CommandBarButton = interface;
  _CommandBarButtonDisp = dispinterface;
  CommandBarPopup = interface;
  CommandBarPopupDisp = dispinterface;
  _CommandBarComboBox = interface;
  _CommandBarComboBoxDisp = dispinterface;
  _CommandBarActiveX = interface;
  _CommandBarActiveXDisp = dispinterface;
  Adjustments = interface;
  AdjustmentsDisp = dispinterface;
  CalloutFormat = interface;
  CalloutFormatDisp = dispinterface;
  ColorFormat = interface;
  ColorFormatDisp = dispinterface;
  ConnectorFormat = interface;
  ConnectorFormatDisp = dispinterface;
  FillFormat = interface;
  FillFormatDisp = dispinterface;
  FreeformBuilder = interface;
  FreeformBuilderDisp = dispinterface;
  GroupShapes = interface;
  GroupShapesDisp = dispinterface;
  LineFormat = interface;
  LineFormatDisp = dispinterface;
  ShapeNode = interface;
  ShapeNodeDisp = dispinterface;
  ShapeNodes = interface;
  ShapeNodesDisp = dispinterface;
  PictureFormat = interface;
  PictureFormatDisp = dispinterface;
  ShadowFormat = interface;
  ShadowFormatDisp = dispinterface;
  Script = interface;
  ScriptDisp = dispinterface;
  Scripts = interface;
  ScriptsDisp = dispinterface;
  Shape = interface;
  ShapeDisp = dispinterface;
  ShapeRange = interface;
  ShapeRangeDisp = dispinterface;
  Shapes = interface;
  ShapesDisp = dispinterface;
  TextEffectFormat = interface;
  TextEffectFormatDisp = dispinterface;
  TextFrame = interface;
  TextFrameDisp = dispinterface;
  ThreeDFormat = interface;
  ThreeDFormatDisp = dispinterface;
  IMsoDispCagNotifySink = interface;
  IMsoDispCagNotifySinkDisp = dispinterface;
  Balloon = interface;
  BalloonDisp = dispinterface;
  BalloonCheckboxes = interface;
  BalloonCheckboxesDisp = dispinterface;
  BalloonCheckbox = interface;
  BalloonCheckboxDisp = dispinterface;
  BalloonLabels = interface;
  BalloonLabelsDisp = dispinterface;
  BalloonLabel = interface;
  BalloonLabelDisp = dispinterface;
  AnswerWizardFiles = interface;
  AnswerWizardFilesDisp = dispinterface;
  AnswerWizard = interface;
  AnswerWizardDisp = dispinterface;
  Assistant = interface;
  AssistantDisp = dispinterface;
  DocumentProperty = interface;
  DocumentProperties = interface;
  IFoundFiles = interface;
  IFoundFilesDisp = dispinterface;
  IFind = interface;
  IFindDisp = dispinterface;
  FoundFiles = interface;
  FoundFilesDisp = dispinterface;
  PropertyTest = interface;
  PropertyTestDisp = dispinterface;
  PropertyTests = interface;
  PropertyTestsDisp = dispinterface;
  FileSearch = interface;
  FileSearchDisp = dispinterface;
  COMAddIn = interface;
  COMAddInDisp = dispinterface;
  COMAddIns = interface;
  COMAddInsDisp = dispinterface;
  LanguageSettings = interface;
  LanguageSettingsDisp = dispinterface;
  ICommandBarsEvents = interface;
  ICommandBarsEventsDisp = dispinterface;
  _CommandBarsEvents = dispinterface;
  ICommandBarComboBoxEvents = interface;
  ICommandBarComboBoxEventsDisp = dispinterface;
  _CommandBarComboBoxEvents = dispinterface;
  ICommandBarButtonEvents = interface;
  ICommandBarButtonEventsDisp = dispinterface;
  _CommandBarButtonEvents = dispinterface;
  WebPageFont = interface;
  WebPageFontDisp = dispinterface;
  WebPageFonts = interface;
  WebPageFontsDisp = dispinterface;
  HTMLProjectItem = interface;
  HTMLProjectItemDisp = dispinterface;
  HTMLProjectItems = interface;
  HTMLProjectItemsDisp = dispinterface;
  HTMLProject = interface;
  HTMLProjectDisp = dispinterface;
  MsoDebugOptions = interface;
  MsoDebugOptionsDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  CommandBars = _CommandBars;
  CommandBarComboBox = _CommandBarComboBox;
  CommandBarButton = _CommandBarButton;


// *********************************************************************//
// Declaration of structures, unions and aliases.                         
// *********************************************************************//
  POleVariant1 = ^OleVariant; {*}
  PUserType1 = ^TGUID; {*}
  PShortint1 = ^Shortint; {*}
  PPShortint1 = ^PShortint1; {*}
  PUserType2 = ^DISPPARAMS; {*}

  MsoRGBType = Integer; 

// *********************************************************************//
// Interface: IAccessible
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {618736E0-3C3D-11CF-810C-00AA00389B71}
// *********************************************************************//
  IAccessible = interface(IDispatch)
    ['{618736E0-3C3D-11CF-810C-00AA00389B71}']
    function Get_accParent: IDispatch; safecall;
    function Get_accChildCount: Integer; safecall;
    function Get_accChild(varChild: OleVariant): IDispatch; safecall;
    function Get_accName(varChild: OleVariant): WideString; safecall;
    function Get_accValue(varChild: OleVariant): WideString; safecall;
    function Get_accDescription(varChild: OleVariant): WideString; safecall;
    function Get_accRole(varChild: OleVariant): OleVariant; safecall;
    function Get_accState(varChild: OleVariant): OleVariant; safecall;
    function Get_accHelp(varChild: OleVariant): WideString; safecall;
    function Get_accHelpTopic(out pszHelpFile: WideString; varChild: OleVariant): Integer; safecall;
    function Get_accKeyboardShortcut(varChild: OleVariant): WideString; safecall;
    function Get_accFocus: OleVariant; safecall;
    function Get_accSelection: OleVariant; safecall;
    function Get_accDefaultAction(varChild: OleVariant): WideString; safecall;
    procedure accSelect(flagsSelect: Integer; varChild: OleVariant); safecall;
    procedure accLocation(out pxLeft: Integer; out pyTop: Integer; out pcxWidth: Integer; 
                          out pcyHeight: Integer; varChild: OleVariant); safecall;
    function accNavigate(navDir: Integer; varStart: OleVariant): OleVariant; safecall;
    function accHitTest(xLeft: Integer; yTop: Integer): OleVariant; safecall;
    procedure accDoDefaultAction(varChild: OleVariant); safecall;
    procedure Set_accName(varChild: OleVariant; const pszName: WideString); safecall;
    procedure Set_accValue(varChild: OleVariant; const pszValue: WideString); safecall;
    property accParent: IDispatch read Get_accParent;
    property accChildCount: Integer read Get_accChildCount;
    property accChild[varChild: OleVariant]: IDispatch read Get_accChild;
    property accName[varChild: OleVariant]: WideString read Get_accName write Set_accName;
    property accValue[varChild: OleVariant]: WideString read Get_accValue write Set_accValue;
    property accDescription[varChild: OleVariant]: WideString read Get_accDescription;
    property accRole[varChild: OleVariant]: OleVariant read Get_accRole;
    property accState[varChild: OleVariant]: OleVariant read Get_accState;
    property accHelp[varChild: OleVariant]: WideString read Get_accHelp;
    property accHelpTopic[out pszHelpFile: WideString; varChild: OleVariant]: Integer read Get_accHelpTopic;
    property accKeyboardShortcut[varChild: OleVariant]: WideString read Get_accKeyboardShortcut;
    property accFocus: OleVariant read Get_accFocus;
    property accSelection: OleVariant read Get_accSelection;
    property accDefaultAction[varChild: OleVariant]: WideString read Get_accDefaultAction;
  end;

// *********************************************************************//
// DispIntf:  IAccessibleDisp
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {618736E0-3C3D-11CF-810C-00AA00389B71}
// *********************************************************************//
  IAccessibleDisp = dispinterface
    ['{618736E0-3C3D-11CF-810C-00AA00389B71}']
    property accParent: IDispatch readonly dispid -5000;
    property accChildCount: Integer readonly dispid -5001;
    property accChild[varChild: OleVariant]: IDispatch readonly dispid -5002;
    property accName[varChild: OleVariant]: WideString dispid -5003;
    property accValue[varChild: OleVariant]: WideString dispid -5004;
    property accDescription[varChild: OleVariant]: WideString readonly dispid -5005;
    property accRole[varChild: OleVariant]: OleVariant readonly dispid -5006;
    property accState[varChild: OleVariant]: OleVariant readonly dispid -5007;
    property accHelp[varChild: OleVariant]: WideString readonly dispid -5008;
    property accHelpTopic[out pszHelpFile: WideString; varChild: OleVariant]: Integer readonly dispid -5009;
    property accKeyboardShortcut[varChild: OleVariant]: WideString readonly dispid -5010;
    property accFocus: OleVariant readonly dispid -5011;
    property accSelection: OleVariant readonly dispid -5012;
    property accDefaultAction[varChild: OleVariant]: WideString readonly dispid -5013;
    procedure accSelect(flagsSelect: Integer; varChild: OleVariant); dispid -5014;
    procedure accLocation(out pxLeft: Integer; out pyTop: Integer; out pcxWidth: Integer; 
                          out pcyHeight: Integer; varChild: OleVariant); dispid -5015;
    function accNavigate(navDir: Integer; varStart: OleVariant): OleVariant; dispid -5016;
    function accHitTest(xLeft: Integer; yTop: Integer): OleVariant; dispid -5017;
    procedure accDoDefaultAction(varChild: OleVariant); dispid -5018;
  end;

// *********************************************************************//
// Interface: _IMsoDispObj
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C0300-0000-0000-C000-000000000046}
// *********************************************************************//
  _IMsoDispObj = interface(IDispatch)
    ['{000C0300-0000-0000-C000-000000000046}']
    function Get_Application: IDispatch; safecall;
    function Get_Creator: Integer; safecall;
    property Application: IDispatch read Get_Application;
    property Creator: Integer read Get_Creator;
  end;

// *********************************************************************//
// DispIntf:  _IMsoDispObjDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C0300-0000-0000-C000-000000000046}
// *********************************************************************//
  _IMsoDispObjDisp = dispinterface
    ['{000C0300-0000-0000-C000-000000000046}']
    property Application: IDispatch readonly dispid 1610743808;
    property Creator: Integer readonly dispid 1610743809;
  end;

// *********************************************************************//
// Interface: _IMsoOleAccDispObj
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C0301-0000-0000-C000-000000000046}
// *********************************************************************//
  _IMsoOleAccDispObj = interface(IAccessible)
    ['{000C0301-0000-0000-C000-000000000046}']
    function Get_Application: IDispatch; safecall;
    function Get_Creator: Integer; safecall;
    property Application: IDispatch read Get_Application;
    property Creator: Integer read Get_Creator;
  end;

// *********************************************************************//
// DispIntf:  _IMsoOleAccDispObjDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C0301-0000-0000-C000-000000000046}
// *********************************************************************//
  _IMsoOleAccDispObjDisp = dispinterface
    ['{000C0301-0000-0000-C000-000000000046}']
    property Application: IDispatch readonly dispid 1610809344;
    property Creator: Integer readonly dispid 1610809345;
    property accParent: IDispatch readonly dispid -5000;
    property accChildCount: Integer readonly dispid -5001;
    property accChild[varChild: OleVariant]: IDispatch readonly dispid -5002;
    property accName[varChild: OleVariant]: WideString dispid -5003;
    property accValue[varChild: OleVariant]: WideString dispid -5004;
    property accDescription[varChild: OleVariant]: WideString readonly dispid -5005;
    property accRole[varChild: OleVariant]: OleVariant readonly dispid -5006;
    property accState[varChild: OleVariant]: OleVariant readonly dispid -5007;
    property accHelp[varChild: OleVariant]: WideString readonly dispid -5008;
    property accHelpTopic[out pszHelpFile: WideString; varChild: OleVariant]: Integer readonly dispid -5009;
    property accKeyboardShortcut[varChild: OleVariant]: WideString readonly dispid -5010;
    property accFocus: OleVariant readonly dispid -5011;
    property accSelection: OleVariant readonly dispid -5012;
    property accDefaultAction[varChild: OleVariant]: WideString readonly dispid -5013;
    procedure accSelect(flagsSelect: Integer; varChild: OleVariant); dispid -5014;
    procedure accLocation(out pxLeft: Integer; out pyTop: Integer; out pcxWidth: Integer; 
                          out pcyHeight: Integer; varChild: OleVariant); dispid -5015;
    function accNavigate(navDir: Integer; varStart: OleVariant): OleVariant; dispid -5016;
    function accHitTest(xLeft: Integer; yTop: Integer): OleVariant; dispid -5017;
    procedure accDoDefaultAction(varChild: OleVariant); dispid -5018;
  end;

// *********************************************************************//
// Interface: _CommandBars
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C0302-0000-0000-C000-000000000046}
// *********************************************************************//
  _CommandBars = interface(_IMsoDispObj)
    ['{000C0302-0000-0000-C000-000000000046}']
    function Get_ActionControl: CommandBarControl; safecall;
    function Get_ActiveMenuBar: CommandBar; safecall;
    function Add(Name: OleVariant; Position: OleVariant; MenuBar: OleVariant; Temporary: OleVariant): CommandBar; safecall;
    function Get_Count: SYSINT; safecall;
    function Get_DisplayTooltips: WordBool; safecall;
    procedure Set_DisplayTooltips(pvarfDisplayTooltips: WordBool); safecall;
    function Get_DisplayKeysInTooltips: WordBool; safecall;
    procedure Set_DisplayKeysInTooltips(pvarfDisplayKeys: WordBool); safecall;
    function FindControl(Type_: OleVariant; Id: OleVariant; Tag: OleVariant; Visible: OleVariant): CommandBarControl; safecall;
    function Get_Item(Index: OleVariant): CommandBar; safecall;
    function Get_LargeButtons: WordBool; safecall;
    procedure Set_LargeButtons(pvarfLargeButtons: WordBool); safecall;
    function Get_MenuAnimationStyle: MsoMenuAnimation; safecall;
    procedure Set_MenuAnimationStyle(pma: MsoMenuAnimation); safecall;
    function Get__NewEnum: IUnknown; safecall;
    function Get_Parent: IDispatch; safecall;
    procedure ReleaseFocus; safecall;
    function Get_IdsString(ids: SYSINT; out pbstrName: WideString): SYSINT; safecall;
    function Get_TmcGetName(tmc: SYSINT; out pbstrName: WideString): SYSINT; safecall;
    function Get_AdaptiveMenus: WordBool; safecall;
    procedure Set_AdaptiveMenus(pvarfAdaptiveMenus: WordBool); safecall;
    function FindControls(Type_: OleVariant; Id: OleVariant; Tag: OleVariant; Visible: OleVariant): CommandBarControls; safecall;
    function AddEx(TbidOrName: OleVariant; Position: OleVariant; MenuBar: OleVariant; 
                   Temporary: OleVariant; TbtrProtection: OleVariant): CommandBar; safecall;
    function Get_DisplayFonts: WordBool; safecall;
    procedure Set_DisplayFonts(pvarfDisplayFonts: WordBool); safecall;
    property ActionControl: CommandBarControl read Get_ActionControl;
    property ActiveMenuBar: CommandBar read Get_ActiveMenuBar;
    property Count: SYSINT read Get_Count;
    property DisplayTooltips: WordBool read Get_DisplayTooltips write Set_DisplayTooltips;
    property DisplayKeysInTooltips: WordBool read Get_DisplayKeysInTooltips write Set_DisplayKeysInTooltips;
    property Item[Index: OleVariant]: CommandBar read Get_Item; default;
    property LargeButtons: WordBool read Get_LargeButtons write Set_LargeButtons;
    property MenuAnimationStyle: MsoMenuAnimation read Get_MenuAnimationStyle write Set_MenuAnimationStyle;
    property _NewEnum: IUnknown read Get__NewEnum;
    property Parent: IDispatch read Get_Parent;
    property IdsString[ids: SYSINT; out pbstrName: WideString]: SYSINT read Get_IdsString;
    property TmcGetName[tmc: SYSINT; out pbstrName: WideString]: SYSINT read Get_TmcGetName;
    property AdaptiveMenus: WordBool read Get_AdaptiveMenus write Set_AdaptiveMenus;
    property DisplayFonts: WordBool read Get_DisplayFonts write Set_DisplayFonts;
  end;

// *********************************************************************//
// DispIntf:  _CommandBarsDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C0302-0000-0000-C000-000000000046}
// *********************************************************************//
  _CommandBarsDisp = dispinterface
    ['{000C0302-0000-0000-C000-000000000046}']
    property ActionControl: CommandBarControl readonly dispid 1610809344;
    property ActiveMenuBar: CommandBar readonly dispid 1610809345;
    function Add(Name: OleVariant; Position: OleVariant; MenuBar: OleVariant; Temporary: OleVariant): CommandBar; dispid 1610809346;
    property Count: SYSINT readonly dispid 1610809347;
    property DisplayTooltips: WordBool dispid 1610809348;
    property DisplayKeysInTooltips: WordBool dispid 1610809350;
    function FindControl(Type_: OleVariant; Id: OleVariant; Tag: OleVariant; Visible: OleVariant): CommandBarControl; dispid 1610809352;
    property Item[Index: OleVariant]: CommandBar readonly dispid 0; default;
    property LargeButtons: WordBool dispid 1610809354;
    property MenuAnimationStyle: MsoMenuAnimation dispid 1610809356;
    property _NewEnum: IUnknown readonly dispid -4;
    property Parent: IDispatch readonly dispid 1610809359;
    procedure ReleaseFocus; dispid 1610809360;
    property IdsString[ids: SYSINT; out pbstrName: WideString]: SYSINT readonly dispid 1610809361;
    property TmcGetName[tmc: SYSINT; out pbstrName: WideString]: SYSINT readonly dispid 1610809362;
    property AdaptiveMenus: WordBool dispid 1610809363;
    function FindControls(Type_: OleVariant; Id: OleVariant; Tag: OleVariant; Visible: OleVariant): CommandBarControls; dispid 1610809365;
    function AddEx(TbidOrName: OleVariant; Position: OleVariant; MenuBar: OleVariant; 
                   Temporary: OleVariant; TbtrProtection: OleVariant): CommandBar; dispid 1610809366;
    property DisplayFonts: WordBool dispid 1610809367;
    property Application: IDispatch readonly dispid 1610743808;
    property Creator: Integer readonly dispid 1610743809;
  end;

// *********************************************************************//
// Interface: CommandBar
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C0304-0000-0000-C000-000000000046}
// *********************************************************************//
  CommandBar = interface(_IMsoOleAccDispObj)
    ['{000C0304-0000-0000-C000-000000000046}']
    function Get_BuiltIn: WordBool; safecall;
    function Get_Context: WideString; safecall;
    procedure Set_Context(const pbstrContext: WideString); safecall;
    function Get_Controls: CommandBarControls; safecall;
    procedure Delete; safecall;
    function Get_Enabled: WordBool; safecall;
    procedure Set_Enabled(pvarfEnabled: WordBool); safecall;
    function FindControl(Type_: OleVariant; Id: OleVariant; Tag: OleVariant; Visible: OleVariant; 
                         Recursive: OleVariant): CommandBarControl; safecall;
    function Get_Height: SYSINT; safecall;
    procedure Set_Height(pdy: SYSINT); safecall;
    function Get_Index: SYSINT; safecall;
    function Get_InstanceId: Integer; safecall;
    function Get_Left: SYSINT; safecall;
    procedure Set_Left(pxpLeft: SYSINT); safecall;
    function Get_Name: WideString; safecall;
    procedure Set_Name(const pbstrName: WideString); safecall;
    function Get_NameLocal: WideString; safecall;
    procedure Set_NameLocal(const pbstrNameLocal: WideString); safecall;
    function Get_Parent: IDispatch; safecall;
    function Get_Position: MsoBarPosition; safecall;
    procedure Set_Position(ppos: MsoBarPosition); safecall;
    function Get_RowIndex: SYSINT; safecall;
    procedure Set_RowIndex(piRow: SYSINT); safecall;
    function Get_Protection: MsoBarProtection; safecall;
    procedure Set_Protection(pprot: MsoBarProtection); safecall;
    procedure Reset; safecall;
    procedure ShowPopup(x: OleVariant; y: OleVariant); safecall;
    function Get_Top: SYSINT; safecall;
    procedure Set_Top(pypTop: SYSINT); safecall;
    function Get_type_: MsoBarType; safecall;
    function Get_Visible: WordBool; safecall;
    procedure Set_Visible(pvarfVisible: WordBool); safecall;
    function Get_Width: SYSINT; safecall;
    procedure Set_Width(pdx: SYSINT); safecall;
    function Get_AdaptiveMenu: WordBool; safecall;
    procedure Set_AdaptiveMenu(pvarfAdaptiveMenu: WordBool); safecall;
    property BuiltIn: WordBool read Get_BuiltIn;
    property Context: WideString read Get_Context write Set_Context;
    property Controls: CommandBarControls read Get_Controls;
    property Enabled: WordBool read Get_Enabled write Set_Enabled;
    property Height: SYSINT read Get_Height write Set_Height;
    property Index: SYSINT read Get_Index;
    property InstanceId: Integer read Get_InstanceId;
    property Left: SYSINT read Get_Left write Set_Left;
    property Name: WideString read Get_Name write Set_Name;
    property NameLocal: WideString read Get_NameLocal write Set_NameLocal;
    property Parent: IDispatch read Get_Parent;
    property Position: MsoBarPosition read Get_Position write Set_Position;
    property RowIndex: SYSINT read Get_RowIndex write Set_RowIndex;
    property Protection: MsoBarProtection read Get_Protection write Set_Protection;
    property Top: SYSINT read Get_Top write Set_Top;
    property type_: MsoBarType read Get_type_;
    property Visible: WordBool read Get_Visible write Set_Visible;
    property Width: SYSINT read Get_Width write Set_Width;
    property AdaptiveMenu: WordBool read Get_AdaptiveMenu write Set_AdaptiveMenu;
  end;

// *********************************************************************//
// DispIntf:  CommandBarDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C0304-0000-0000-C000-000000000046}
// *********************************************************************//
  CommandBarDisp = dispinterface
    ['{000C0304-0000-0000-C000-000000000046}']
    property BuiltIn: WordBool readonly dispid 1610874880;
    property Context: WideString dispid 1610874881;
    property Controls: CommandBarControls readonly dispid 1610874883;
    procedure Delete; dispid 1610874884;
    property Enabled: WordBool dispid 1610874885;
    function FindControl(Type_: OleVariant; Id: OleVariant; Tag: OleVariant; Visible: OleVariant; 
                         Recursive: OleVariant): CommandBarControl; dispid 1610874887;
    property Height: SYSINT dispid 1610874888;
    property Index: SYSINT readonly dispid 1610874890;
    property InstanceId: Integer readonly dispid 1610874891;
    property Left: SYSINT dispid 1610874892;
    property Name: WideString dispid 1610874894;
    property NameLocal: WideString dispid 1610874896;
    property Parent: IDispatch readonly dispid 1610874898;
    property Position: MsoBarPosition dispid 1610874899;
    property RowIndex: SYSINT dispid 1610874901;
    property Protection: MsoBarProtection dispid 1610874903;
    procedure Reset; dispid 1610874905;
    procedure ShowPopup(x: OleVariant; y: OleVariant); dispid 1610874906;
    property Top: SYSINT dispid 1610874907;
    property type_: MsoBarType readonly dispid 1610874909;
    property Visible: WordBool dispid 1610874910;
    property Width: SYSINT dispid 1610874912;
    property AdaptiveMenu: WordBool dispid 1610874914;
    property Application: IDispatch readonly dispid 1610809344;
    property Creator: Integer readonly dispid 1610809345;
    property accParent: IDispatch readonly dispid -5000;
    property accChildCount: Integer readonly dispid -5001;
    property accChild[varChild: OleVariant]: IDispatch readonly dispid -5002;
    property accName[varChild: OleVariant]: WideString dispid -5003;
    property accValue[varChild: OleVariant]: WideString dispid -5004;
    property accDescription[varChild: OleVariant]: WideString readonly dispid -5005;
    property accRole[varChild: OleVariant]: OleVariant readonly dispid -5006;
    property accState[varChild: OleVariant]: OleVariant readonly dispid -5007;
    property accHelp[varChild: OleVariant]: WideString readonly dispid -5008;
    property accHelpTopic[out pszHelpFile: WideString; varChild: OleVariant]: Integer readonly dispid -5009;
    property accKeyboardShortcut[varChild: OleVariant]: WideString readonly dispid -5010;
    property accFocus: OleVariant readonly dispid -5011;
    property accSelection: OleVariant readonly dispid -5012;
    property accDefaultAction[varChild: OleVariant]: WideString readonly dispid -5013;
    procedure accSelect(flagsSelect: Integer; varChild: OleVariant); dispid -5014;
    procedure accLocation(out pxLeft: Integer; out pyTop: Integer; out pcxWidth: Integer; 
                          out pcyHeight: Integer; varChild: OleVariant); dispid -5015;
    function accNavigate(navDir: Integer; varStart: OleVariant): OleVariant; dispid -5016;
    function accHitTest(xLeft: Integer; yTop: Integer): OleVariant; dispid -5017;
    procedure accDoDefaultAction(varChild: OleVariant); dispid -5018;
  end;

// *********************************************************************//
// Interface: CommandBarControls
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C0306-0000-0000-C000-000000000046}
// *********************************************************************//
  CommandBarControls = interface(_IMsoDispObj)
    ['{000C0306-0000-0000-C000-000000000046}']
    function Add(Type_: OleVariant; Id: OleVariant; Parameter: OleVariant; Before: OleVariant; 
                 Temporary: OleVariant): CommandBarControl; safecall;
    function Get_Count: SYSINT; safecall;
    function Get_Item(Index: OleVariant): CommandBarControl; safecall;
    function Get__NewEnum: IUnknown; safecall;
    function Get_Parent: CommandBar; safecall;
    property Count: SYSINT read Get_Count;
    property Item[Index: OleVariant]: CommandBarControl read Get_Item; default;
    property _NewEnum: IUnknown read Get__NewEnum;
    property Parent: CommandBar read Get_Parent;
  end;

// *********************************************************************//
// DispIntf:  CommandBarControlsDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C0306-0000-0000-C000-000000000046}
// *********************************************************************//
  CommandBarControlsDisp = dispinterface
    ['{000C0306-0000-0000-C000-000000000046}']
    function Add(Type_: OleVariant; Id: OleVariant; Parameter: OleVariant; Before: OleVariant; 
                 Temporary: OleVariant): CommandBarControl; dispid 1610809344;
    property Count: SYSINT readonly dispid 1610809345;
    property Item[Index: OleVariant]: CommandBarControl readonly dispid 0; default;
    property _NewEnum: IUnknown readonly dispid -4;
    property Parent: CommandBar readonly dispid 1610809348;
    property Application: IDispatch readonly dispid 1610743808;
    property Creator: Integer readonly dispid 1610743809;
  end;

// *********************************************************************//
// Interface: CommandBarControl
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {000C0308-0000-0000-C000-000000000046}
// *********************************************************************//
  CommandBarControl = interface(_IMsoOleAccDispObj)
    ['{000C0308-0000-0000-C000-000000000046}']
    function Get_BeginGroup: WordBool; safecall;
    procedure Set_BeginGroup(pvarfBeginGroup: WordBool); safecall;
    function Get_BuiltIn: WordBool; safecall;
    function Get_Caption: WideString; safecall;
    procedure Set_Caption(const pbstrCaption: WideString); safecall;
    function Get_Control: IDispatch; safecall;
    function Copy(Bar: OleVariant; Before: OleVariant): CommandBarControl; safecall;
    procedure Delete(Temporary: OleVariant); safecall;
    function Get_DescriptionText: WideString; safecall;
    procedure Set_DescriptionText(const pbstrText: WideString); safecall;
    function Get_Enabled: WordBool; safecall;
    procedure Set_Enabled(pvarfEnabled: WordBool); safecall;
    procedure Execute; safecall;
    function Get_Height: SYSINT; safecall;
    procedure Set_Height(pdy: SYSINT); safecall;
    function Get_HelpContextId: SYSINT; safecall;
    procedure Set_HelpContextId(pid: SYSINT); safecall;
    function Get_HelpFile: WideString; safecall;
    procedure Set_HelpFile(const pbstrFilename: WideString); safecall;
    function Get_Id: SYSINT; safecall;
    function Get_Index: SYSINT; safecall;
    function Get_InstanceId: Integer; safecall;
    function Move(Bar: OleVariant; Before: OleVariant): CommandBarControl; safecall;
    function Get_Left: SYSINT; safecall;
    function Get_OLEUsage: MsoControlOLEUsage; safecall;
    procedure Set_OLEUsage(pcou: MsoControlOLEUsage); safecall;
    function Get_OnAction: WideString; safecall;
    procedure Set_OnAction(const pbstrOnAction: WideString); safecall;
    function Get_Parent: CommandBar; safecall;
    function Get_Parameter: WideString; safecall;
    procedure Set_Parameter(const pbstrParam: WideString); safecall;
    function Get_Priority: SYSINT; safecall;
    procedure Set_Priority(pnPri: SYSINT); safecall;
    procedure Reset; safecall;
    procedure SetFocus; safecall;
    function Get_Tag: WideString; safecall;
    procedure Set_Tag(const pbstrTag: WideString); safecall;
    function Get_TooltipText: WideString; safecall;
    procedure Set_TooltipText(const pbstrTooltip: WideString); safecall;
    function Get_Top: SYSINT; safecall;
    function Get_type_: MsoControlType; safecall;
    function Get_Visible: WordBool; safecall;
    procedure Set_Visible(pvarfVisible: WordBool); safecall;
    function Get_Width: SYSINT; safecall;
    procedure Set_Width(pdx: SYSINT); safecall;
    function Get_IsPriorityDropped: WordBool; safecall;
    procedure Reserved1; safecall;
    procedure Reserved2; safecall;
    procedure Reserved3; safecall;
    procedure Reserved4; safecall;
    procedure Reserved5; safecall;
    procedure Reserved6; safecall;
    procedure Reserved7; safecall;
    property BeginGroup: WordBool read Get_BeginGroup write Set_BeginGroup;
    property BuiltIn: WordBool read Get_BuiltIn;
    property Caption: WideString read Get_Caption write Set_Caption;
    property Control: IDispatch read Get_Control;
    property DescriptionText: WideString read Get_DescriptionText write Set_DescriptionText;
    property Enabled: WordBool read Get_Enabled write Set_Enabled;
    property Height: SYSINT read Get_Height write Set_Height;
    property HelpContextId: SYSINT read Get_HelpContextId write Set_HelpContextId;
    property HelpFile: WideString read Get_HelpFile write Set_HelpFile;
    property Id: SYSINT read Get_Id;
    property Index: SYSINT read Get_Index;
    property InstanceId: Integer read Get_InstanceId;
    property Left: SYSINT read Get_Left;
    property OLEUsage: MsoControlOLEUsage read Get_OLEUsage write Set_OLEUsage;
    property OnAction: WideString read Get_OnAction write Set_OnAction;
    property Parent: CommandBar read Get_Parent;
    property Parameter: WideString read Get_Parameter write Set_Parameter;
    property Priority: SYSINT read Get_Priority write Set_Priority;
    property Tag: WideString read Get_Tag write Set_Tag;
    property TooltipText: WideString read Get_TooltipText write Set_TooltipText;
    property Top: SYSINT read Get_Top;
    property type_: MsoControlType read Get_type_;
    property Visible: WordBool read Get_Visible write Set_Visible;
    property Width: SYSINT read Get_Width write Set_Width;
    property IsPriorityDropped: WordBool read Get_IsPriorityDropped;
  end;

// *********************************************************************//
// DispIntf:  CommandBarControlDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {000C0308-0000-0000-C000-000000000046}
// *********************************************************************//
  CommandBarControlDisp = dispinterface
    ['{000C0308-0000-0000-C000-000000000046}']
    property BeginGroup: WordBool dispid 1610874880;
    property BuiltIn: WordBool readonly dispid 1610874882;
    property Caption: WideString dispid 1610874883;
    property Control: IDispatch readonly dispid 1610874885;
    function Copy(Bar: OleVariant; Before: OleVariant): CommandBarControl; dispid 1610874886;
    procedure Delete(Temporary: OleVariant); dispid 1610874887;
    property DescriptionText: WideString dispid 1610874888;
    property Enabled: WordBool dispid 1610874890;
    procedure Execute; dispid 1610874892;
    property Height: SYSINT dispid 1610874893;
    property HelpContextId: SYSINT dispid 1610874895;
    property HelpFile: WideString dispid 1610874897;
    property Id: SYSINT readonly dispid 1610874899;
    property Index: SYSINT readonly dispid 1610874900;
    property InstanceId: Integer readonly dispid 1610874901;
    function Move(Bar: OleVariant; Before: OleVariant): CommandBarControl; dispid 1610874902;
    property Left: SYSINT readonly dispid 1610874903;
    property OLEUsage: MsoControlOLEUsage dispid 1610874904;
    property OnAction: WideString dispid 1610874906;
    property Parent: CommandBar readonly dispid 1610874908;
    property Parameter: WideString dispid 1610874909;
    property Priority: SYSINT dispid 1610874911;
    procedure Reset; dispid 1610874913;
    procedure SetFocus; dispid 1610874914;
    property Tag: WideString dispid 1610874915;
    property TooltipText: WideString dispid 1610874917;
    property Top: SYSINT readonly dispid 1610874919;
    property type_: MsoControlType readonly dispid 1610874920;
    property Visible: WordBool dispid 1610874921;
    property Width: SYSINT dispid 1610874923;
    property IsPriorityDropped: WordBool readonly dispid 1610874925;
    procedure Reserved1; dispid 1610874926;
    procedure Reserved2; dispid 1610874927;
    procedure Reserved3; dispid 1610874928;
    procedure Reserved4; dispid 1610874929;
    procedure Reserved5; dispid 1610874930;
    procedure Reserved6; dispid 1610874931;
    procedure Reserved7; dispid 1610874932;
    property Application: IDispatch readonly dispid 1610809344;
    property Creator: Integer readonly dispid 1610809345;
    property accParent: IDispatch readonly dispid -5000;
    property accChildCount: Integer readonly dispid -5001;
    property accChild[varChild: OleVariant]: IDispatch readonly dispid -5002;
    property accName[varChild: OleVariant]: WideString dispid -5003;
    property accValue[varChild: OleVariant]: WideString dispid -5004;
    property accDescription[varChild: OleVariant]: WideString readonly dispid -5005;
    property accRole[varChild: OleVariant]: OleVariant readonly dispid -5006;
    property accState[varChild: OleVariant]: OleVariant readonly dispid -5007;
    property accHelp[varChild: OleVariant]: WideString readonly dispid -5008;
    property accHelpTopic[out pszHelpFile: WideString; varChild: OleVariant]: Integer readonly dispid -5009;
    property accKeyboardShortcut[varChild: OleVariant]: WideString readonly dispid -5010;
    property accFocus: OleVariant readonly dispid -5011;
    property accSelection: OleVariant readonly dispid -5012;
    property accDefaultAction[varChild: OleVariant]: WideString readonly dispid -5013;
    procedure accSelect(flagsSelect: Integer; varChild: OleVariant); dispid -5014;
    procedure accLocation(out pxLeft: Integer; out pyTop: Integer; out pcxWidth: Integer; 
                          out pcyHeight: Integer; varChild: OleVariant); dispid -5015;
    function accNavigate(navDir: Integer; varStart: OleVariant): OleVariant; dispid -5016;
    function accHitTest(xLeft: Integer; yTop: Integer): OleVariant; dispid -5017;
    procedure accDoDefaultAction(varChild: OleVariant); dispid -5018;
  end;

// *********************************************************************//
// Interface: _CommandBarButton
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C030E-0000-0000-C000-000000000046}
// *********************************************************************//
  _CommandBarButton = interface(CommandBarControl)
    ['{000C030E-0000-0000-C000-000000000046}']
    function Get_BuiltInFace: WordBool; safecall;
    procedure Set_BuiltInFace(pvarfBuiltIn: WordBool); safecall;
    procedure CopyFace; safecall;
    function Get_FaceId: SYSINT; safecall;
    procedure Set_FaceId(pid: SYSINT); safecall;
    procedure PasteFace; safecall;
    function Get_ShortcutText: WideString; safecall;
    procedure Set_ShortcutText(const pbstrText: WideString); safecall;
    function Get_State: MsoButtonState; safecall;
    procedure Set_State(pstate: MsoButtonState); safecall;
    function Get_Style: MsoButtonStyle; safecall;
    procedure Set_Style(pstyle: MsoButtonStyle); safecall;
    function Get_HyperlinkType: MsoCommandBarButtonHyperlinkType; safecall;
    procedure Set_HyperlinkType(phlType: MsoCommandBarButtonHyperlinkType); safecall;
    property BuiltInFace: WordBool read Get_BuiltInFace write Set_BuiltInFace;
    property FaceId: SYSINT read Get_FaceId write Set_FaceId;
    property ShortcutText: WideString read Get_ShortcutText write Set_ShortcutText;
    property State: MsoButtonState read Get_State write Set_State;
    property Style: MsoButtonStyle read Get_Style write Set_Style;
    property HyperlinkType: MsoCommandBarButtonHyperlinkType read Get_HyperlinkType write Set_HyperlinkType;
  end;

// *********************************************************************//
// DispIntf:  _CommandBarButtonDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C030E-0000-0000-C000-000000000046}
// *********************************************************************//
  _CommandBarButtonDisp = dispinterface
    ['{000C030E-0000-0000-C000-000000000046}']
    property BuiltInFace: WordBool dispid 1610940416;
    procedure CopyFace; dispid 1610940418;
    property FaceId: SYSINT dispid 1610940419;
    procedure PasteFace; dispid 1610940421;
    property ShortcutText: WideString dispid 1610940422;
    property State: MsoButtonState dispid 1610940424;
    property Style: MsoButtonStyle dispid 1610940426;
    property HyperlinkType: MsoCommandBarButtonHyperlinkType dispid 1610940428;
    property BeginGroup: WordBool dispid 1610874880;
    property BuiltIn: WordBool readonly dispid 1610874882;
    property Caption: WideString dispid 1610874883;
    property Control: IDispatch readonly dispid 1610874885;
    function Copy(Bar: OleVariant; Before: OleVariant): CommandBarControl; dispid 1610874886;
    procedure Delete(Temporary: OleVariant); dispid 1610874887;
    property DescriptionText: WideString dispid 1610874888;
    property Enabled: WordBool dispid 1610874890;
    procedure Execute; dispid 1610874892;
    property Height: SYSINT dispid 1610874893;
    property HelpContextId: SYSINT dispid 1610874895;
    property HelpFile: WideString dispid 1610874897;
    property Id: SYSINT readonly dispid 1610874899;
    property Index: SYSINT readonly dispid 1610874900;
    property InstanceId: Integer readonly dispid 1610874901;
    function Move(Bar: OleVariant; Before: OleVariant): CommandBarControl; dispid 1610874902;
    property Left: SYSINT readonly dispid 1610874903;
    property OLEUsage: MsoControlOLEUsage dispid 1610874904;
    property OnAction: WideString dispid 1610874906;
    property Parent: CommandBar readonly dispid 1610874908;
    property Parameter: WideString dispid 1610874909;
    property Priority: SYSINT dispid 1610874911;
    procedure Reset; dispid 1610874913;
    procedure SetFocus; dispid 1610874914;
    property Tag: WideString dispid 1610874915;
    property TooltipText: WideString dispid 1610874917;
    property Top: SYSINT readonly dispid 1610874919;
    property type_: MsoControlType readonly dispid 1610874920;
    property Visible: WordBool dispid 1610874921;
    property Width: SYSINT dispid 1610874923;
    property IsPriorityDropped: WordBool readonly dispid 1610874925;
    procedure Reserved1; dispid 1610874926;
    procedure Reserved2; dispid 1610874927;
    procedure Reserved3; dispid 1610874928;
    procedure Reserved4; dispid 1610874929;
    procedure Reserved5; dispid 1610874930;
    procedure Reserved6; dispid 1610874931;
    procedure Reserved7; dispid 1610874932;
    property Application: IDispatch readonly dispid 1610809344;
    property Creator: Integer readonly dispid 1610809345;
    property accParent: IDispatch readonly dispid -5000;
    property accChildCount: Integer readonly dispid -5001;
    property accChild[varChild: OleVariant]: IDispatch readonly dispid -5002;
    property accName[varChild: OleVariant]: WideString dispid -5003;
    property accValue[varChild: OleVariant]: WideString dispid -5004;
    property accDescription[varChild: OleVariant]: WideString readonly dispid -5005;
    property accRole[varChild: OleVariant]: OleVariant readonly dispid -5006;
    property accState[varChild: OleVariant]: OleVariant readonly dispid -5007;
    property accHelp[varChild: OleVariant]: WideString readonly dispid -5008;
    property accHelpTopic[out pszHelpFile: WideString; varChild: OleVariant]: Integer readonly dispid -5009;
    property accKeyboardShortcut[varChild: OleVariant]: WideString readonly dispid -5010;
    property accFocus: OleVariant readonly dispid -5011;
    property accSelection: OleVariant readonly dispid -5012;
    property accDefaultAction[varChild: OleVariant]: WideString readonly dispid -5013;
    procedure accSelect(flagsSelect: Integer; varChild: OleVariant); dispid -5014;
    procedure accLocation(out pxLeft: Integer; out pyTop: Integer; out pcxWidth: Integer; 
                          out pcyHeight: Integer; varChild: OleVariant); dispid -5015;
    function accNavigate(navDir: Integer; varStart: OleVariant): OleVariant; dispid -5016;
    function accHitTest(xLeft: Integer; yTop: Integer): OleVariant; dispid -5017;
    procedure accDoDefaultAction(varChild: OleVariant); dispid -5018;
  end;

// *********************************************************************//
// Interface: CommandBarPopup
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C030A-0000-0000-C000-000000000046}
// *********************************************************************//
  CommandBarPopup = interface(CommandBarControl)
    ['{000C030A-0000-0000-C000-000000000046}']
    function Get_CommandBar: CommandBar; safecall;
    function Get_Controls: CommandBarControls; safecall;
    function Get_OLEMenuGroup: MsoOLEMenuGroup; safecall;
    procedure Set_OLEMenuGroup(pomg: MsoOLEMenuGroup); safecall;
    property CommandBar: CommandBar read Get_CommandBar;
    property Controls: CommandBarControls read Get_Controls;
    property OLEMenuGroup: MsoOLEMenuGroup read Get_OLEMenuGroup write Set_OLEMenuGroup;
  end;

// *********************************************************************//
// DispIntf:  CommandBarPopupDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C030A-0000-0000-C000-000000000046}
// *********************************************************************//
  CommandBarPopupDisp = dispinterface
    ['{000C030A-0000-0000-C000-000000000046}']
    property CommandBar: CommandBar readonly dispid 1610940416;
    property Controls: CommandBarControls readonly dispid 1610940417;
    property OLEMenuGroup: MsoOLEMenuGroup dispid 1610940418;
    property BeginGroup: WordBool dispid 1610874880;
    property BuiltIn: WordBool readonly dispid 1610874882;
    property Caption: WideString dispid 1610874883;
    property Control: IDispatch readonly dispid 1610874885;
    function Copy(Bar: OleVariant; Before: OleVariant): CommandBarControl; dispid 1610874886;
    procedure Delete(Temporary: OleVariant); dispid 1610874887;
    property DescriptionText: WideString dispid 1610874888;
    property Enabled: WordBool dispid 1610874890;
    procedure Execute; dispid 1610874892;
    property Height: SYSINT dispid 1610874893;
    property HelpContextId: SYSINT dispid 1610874895;
    property HelpFile: WideString dispid 1610874897;
    property Id: SYSINT readonly dispid 1610874899;
    property Index: SYSINT readonly dispid 1610874900;
    property InstanceId: Integer readonly dispid 1610874901;
    function Move(Bar: OleVariant; Before: OleVariant): CommandBarControl; dispid 1610874902;
    property Left: SYSINT readonly dispid 1610874903;
    property OLEUsage: MsoControlOLEUsage dispid 1610874904;
    property OnAction: WideString dispid 1610874906;
    property Parent: CommandBar readonly dispid 1610874908;
    property Parameter: WideString dispid 1610874909;
    property Priority: SYSINT dispid 1610874911;
    procedure Reset; dispid 1610874913;
    procedure SetFocus; dispid 1610874914;
    property Tag: WideString dispid 1610874915;
    property TooltipText: WideString dispid 1610874917;
    property Top: SYSINT readonly dispid 1610874919;
    property type_: MsoControlType readonly dispid 1610874920;
    property Visible: WordBool dispid 1610874921;
    property Width: SYSINT dispid 1610874923;
    property IsPriorityDropped: WordBool readonly dispid 1610874925;
    procedure Reserved1; dispid 1610874926;
    procedure Reserved2; dispid 1610874927;
    procedure Reserved3; dispid 1610874928;
    procedure Reserved4; dispid 1610874929;
    procedure Reserved5; dispid 1610874930;
    procedure Reserved6; dispid 1610874931;
    procedure Reserved7; dispid 1610874932;
    property Application: IDispatch readonly dispid 1610809344;
    property Creator: Integer readonly dispid 1610809345;
    property accParent: IDispatch readonly dispid -5000;
    property accChildCount: Integer readonly dispid -5001;
    property accChild[varChild: OleVariant]: IDispatch readonly dispid -5002;
    property accName[varChild: OleVariant]: WideString dispid -5003;
    property accValue[varChild: OleVariant]: WideString dispid -5004;
    property accDescription[varChild: OleVariant]: WideString readonly dispid -5005;
    property accRole[varChild: OleVariant]: OleVariant readonly dispid -5006;
    property accState[varChild: OleVariant]: OleVariant readonly dispid -5007;
    property accHelp[varChild: OleVariant]: WideString readonly dispid -5008;
    property accHelpTopic[out pszHelpFile: WideString; varChild: OleVariant]: Integer readonly dispid -5009;
    property accKeyboardShortcut[varChild: OleVariant]: WideString readonly dispid -5010;
    property accFocus: OleVariant readonly dispid -5011;
    property accSelection: OleVariant readonly dispid -5012;
    property accDefaultAction[varChild: OleVariant]: WideString readonly dispid -5013;
    procedure accSelect(flagsSelect: Integer; varChild: OleVariant); dispid -5014;
    procedure accLocation(out pxLeft: Integer; out pyTop: Integer; out pcxWidth: Integer; 
                          out pcyHeight: Integer; varChild: OleVariant); dispid -5015;
    function accNavigate(navDir: Integer; varStart: OleVariant): OleVariant; dispid -5016;
    function accHitTest(xLeft: Integer; yTop: Integer): OleVariant; dispid -5017;
    procedure accDoDefaultAction(varChild: OleVariant); dispid -5018;
  end;

// *********************************************************************//
// Interface: _CommandBarComboBox
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C030C-0000-0000-C000-000000000046}
// *********************************************************************//
  _CommandBarComboBox = interface(CommandBarControl)
    ['{000C030C-0000-0000-C000-000000000046}']
    procedure AddItem(const Text: WideString; Index: OleVariant); safecall;
    procedure Clear; safecall;
    function Get_DropDownLines: SYSINT; safecall;
    procedure Set_DropDownLines(pcLines: SYSINT); safecall;
    function Get_DropDownWidth: SYSINT; safecall;
    procedure Set_DropDownWidth(pdx: SYSINT); safecall;
    function Get_List(Index: SYSINT): WideString; safecall;
    procedure Set_List(Index: SYSINT; const pbstrItem: WideString); safecall;
    function Get_ListCount: SYSINT; safecall;
    function Get_ListHeaderCount: SYSINT; safecall;
    procedure Set_ListHeaderCount(pcItems: SYSINT); safecall;
    function Get_ListIndex: SYSINT; safecall;
    procedure Set_ListIndex(pi: SYSINT); safecall;
    procedure RemoveItem(Index: SYSINT); safecall;
    function Get_Style: MsoComboStyle; safecall;
    procedure Set_Style(pstyle: MsoComboStyle); safecall;
    function Get_Text: WideString; safecall;
    procedure Set_Text(const pbstrText: WideString); safecall;
    property DropDownLines: SYSINT read Get_DropDownLines write Set_DropDownLines;
    property DropDownWidth: SYSINT read Get_DropDownWidth write Set_DropDownWidth;
    property List[Index: SYSINT]: WideString read Get_List write Set_List;
    property ListCount: SYSINT read Get_ListCount;
    property ListHeaderCount: SYSINT read Get_ListHeaderCount write Set_ListHeaderCount;
    property ListIndex: SYSINT read Get_ListIndex write Set_ListIndex;
    property Style: MsoComboStyle read Get_Style write Set_Style;
    property Text: WideString read Get_Text write Set_Text;
  end;

// *********************************************************************//
// DispIntf:  _CommandBarComboBoxDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C030C-0000-0000-C000-000000000046}
// *********************************************************************//
  _CommandBarComboBoxDisp = dispinterface
    ['{000C030C-0000-0000-C000-000000000046}']
    procedure AddItem(const Text: WideString; Index: OleVariant); dispid 1610940416;
    procedure Clear; dispid 1610940417;
    property DropDownLines: SYSINT dispid 1610940418;
    property DropDownWidth: SYSINT dispid 1610940420;
    property List[Index: SYSINT]: WideString dispid 1610940422;
    property ListCount: SYSINT readonly dispid 1610940424;
    property ListHeaderCount: SYSINT dispid 1610940425;
    property ListIndex: SYSINT dispid 1610940427;
    procedure RemoveItem(Index: SYSINT); dispid 1610940429;
    property Style: MsoComboStyle dispid 1610940430;
    property Text: WideString dispid 1610940432;
    property BeginGroup: WordBool dispid 1610874880;
    property BuiltIn: WordBool readonly dispid 1610874882;
    property Caption: WideString dispid 1610874883;
    property Control: IDispatch readonly dispid 1610874885;
    function Copy(Bar: OleVariant; Before: OleVariant): CommandBarControl; dispid 1610874886;
    procedure Delete(Temporary: OleVariant); dispid 1610874887;
    property DescriptionText: WideString dispid 1610874888;
    property Enabled: WordBool dispid 1610874890;
    procedure Execute; dispid 1610874892;
    property Height: SYSINT dispid 1610874893;
    property HelpContextId: SYSINT dispid 1610874895;
    property HelpFile: WideString dispid 1610874897;
    property Id: SYSINT readonly dispid 1610874899;
    property Index: SYSINT readonly dispid 1610874900;
    property InstanceId: Integer readonly dispid 1610874901;
    function Move(Bar: OleVariant; Before: OleVariant): CommandBarControl; dispid 1610874902;
    property Left: SYSINT readonly dispid 1610874903;
    property OLEUsage: MsoControlOLEUsage dispid 1610874904;
    property OnAction: WideString dispid 1610874906;
    property Parent: CommandBar readonly dispid 1610874908;
    property Parameter: WideString dispid 1610874909;
    property Priority: SYSINT dispid 1610874911;
    procedure Reset; dispid 1610874913;
    procedure SetFocus; dispid 1610874914;
    property Tag: WideString dispid 1610874915;
    property TooltipText: WideString dispid 1610874917;
    property Top: SYSINT readonly dispid 1610874919;
    property type_: MsoControlType readonly dispid 1610874920;
    property Visible: WordBool dispid 1610874921;
    property Width: SYSINT dispid 1610874923;
    property IsPriorityDropped: WordBool readonly dispid 1610874925;
    procedure Reserved1; dispid 1610874926;
    procedure Reserved2; dispid 1610874927;
    procedure Reserved3; dispid 1610874928;
    procedure Reserved4; dispid 1610874929;
    procedure Reserved5; dispid 1610874930;
    procedure Reserved6; dispid 1610874931;
    procedure Reserved7; dispid 1610874932;
    property Application: IDispatch readonly dispid 1610809344;
    property Creator: Integer readonly dispid 1610809345;
    property accParent: IDispatch readonly dispid -5000;
    property accChildCount: Integer readonly dispid -5001;
    property accChild[varChild: OleVariant]: IDispatch readonly dispid -5002;
    property accName[varChild: OleVariant]: WideString dispid -5003;
    property accValue[varChild: OleVariant]: WideString dispid -5004;
    property accDescription[varChild: OleVariant]: WideString readonly dispid -5005;
    property accRole[varChild: OleVariant]: OleVariant readonly dispid -5006;
    property accState[varChild: OleVariant]: OleVariant readonly dispid -5007;
    property accHelp[varChild: OleVariant]: WideString readonly dispid -5008;
    property accHelpTopic[out pszHelpFile: WideString; varChild: OleVariant]: Integer readonly dispid -5009;
    property accKeyboardShortcut[varChild: OleVariant]: WideString readonly dispid -5010;
    property accFocus: OleVariant readonly dispid -5011;
    property accSelection: OleVariant readonly dispid -5012;
    property accDefaultAction[varChild: OleVariant]: WideString readonly dispid -5013;
    procedure accSelect(flagsSelect: Integer; varChild: OleVariant); dispid -5014;
    procedure accLocation(out pxLeft: Integer; out pyTop: Integer; out pcxWidth: Integer; 
                          out pcyHeight: Integer; varChild: OleVariant); dispid -5015;
    function accNavigate(navDir: Integer; varStart: OleVariant): OleVariant; dispid -5016;
    function accHitTest(xLeft: Integer; yTop: Integer): OleVariant; dispid -5017;
    procedure accDoDefaultAction(varChild: OleVariant); dispid -5018;
  end;

// *********************************************************************//
// Interface: _CommandBarActiveX
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C030D-0000-0000-C000-000000000046}
// *********************************************************************//
  _CommandBarActiveX = interface(CommandBarControl)
    ['{000C030D-0000-0000-C000-000000000046}']
    function Get_ControlCLSID: WideString; safecall;
    procedure Set_ControlCLSID(const pbstrClsid: WideString); safecall;
    function Get_QueryControlInterface(const bstrIid: WideString): IUnknown; safecall;
    procedure SetInnerObjectFactory(const pUnk: IUnknown); safecall;
    procedure EnsureControl; safecall;
    procedure Set_InitWith(const Param1: IUnknown); safecall;
    property ControlCLSID: WideString read Get_ControlCLSID write Set_ControlCLSID;
    property QueryControlInterface[const bstrIid: WideString]: IUnknown read Get_QueryControlInterface;
    property InitWith: IUnknown write Set_InitWith;
  end;

// *********************************************************************//
// DispIntf:  _CommandBarActiveXDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C030D-0000-0000-C000-000000000046}
// *********************************************************************//
  _CommandBarActiveXDisp = dispinterface
    ['{000C030D-0000-0000-C000-000000000046}']
    property ControlCLSID: WideString dispid 1610940416;
    property QueryControlInterface[const bstrIid: WideString]: IUnknown readonly dispid 1610940418;
    procedure SetInnerObjectFactory(const pUnk: IUnknown); dispid 1610940419;
    procedure EnsureControl; dispid 1610940420;
    property InitWith: IUnknown writeonly dispid 1610940421;
    property BeginGroup: WordBool dispid 1610874880;
    property BuiltIn: WordBool readonly dispid 1610874882;
    property Caption: WideString dispid 1610874883;
    property Control: IDispatch readonly dispid 1610874885;
    function Copy(Bar: OleVariant; Before: OleVariant): CommandBarControl; dispid 1610874886;
    procedure Delete(Temporary: OleVariant); dispid 1610874887;
    property DescriptionText: WideString dispid 1610874888;
    property Enabled: WordBool dispid 1610874890;
    procedure Execute; dispid 1610874892;
    property Height: SYSINT dispid 1610874893;
    property HelpContextId: SYSINT dispid 1610874895;
    property HelpFile: WideString dispid 1610874897;
    property Id: SYSINT readonly dispid 1610874899;
    property Index: SYSINT readonly dispid 1610874900;
    property InstanceId: Integer readonly dispid 1610874901;
    function Move(Bar: OleVariant; Before: OleVariant): CommandBarControl; dispid 1610874902;
    property Left: SYSINT readonly dispid 1610874903;
    property OLEUsage: MsoControlOLEUsage dispid 1610874904;
    property OnAction: WideString dispid 1610874906;
    property Parent: CommandBar readonly dispid 1610874908;
    property Parameter: WideString dispid 1610874909;
    property Priority: SYSINT dispid 1610874911;
    procedure Reset; dispid 1610874913;
    procedure SetFocus; dispid 1610874914;
    property Tag: WideString dispid 1610874915;
    property TooltipText: WideString dispid 1610874917;
    property Top: SYSINT readonly dispid 1610874919;
    property type_: MsoControlType readonly dispid 1610874920;
    property Visible: WordBool dispid 1610874921;
    property Width: SYSINT dispid 1610874923;
    property IsPriorityDropped: WordBool readonly dispid 1610874925;
    procedure Reserved1; dispid 1610874926;
    procedure Reserved2; dispid 1610874927;
    procedure Reserved3; dispid 1610874928;
    procedure Reserved4; dispid 1610874929;
    procedure Reserved5; dispid 1610874930;
    procedure Reserved6; dispid 1610874931;
    procedure Reserved7; dispid 1610874932;
    property Application: IDispatch readonly dispid 1610809344;
    property Creator: Integer readonly dispid 1610809345;
    property accParent: IDispatch readonly dispid -5000;
    property accChildCount: Integer readonly dispid -5001;
    property accChild[varChild: OleVariant]: IDispatch readonly dispid -5002;
    property accName[varChild: OleVariant]: WideString dispid -5003;
    property accValue[varChild: OleVariant]: WideString dispid -5004;
    property accDescription[varChild: OleVariant]: WideString readonly dispid -5005;
    property accRole[varChild: OleVariant]: OleVariant readonly dispid -5006;
    property accState[varChild: OleVariant]: OleVariant readonly dispid -5007;
    property accHelp[varChild: OleVariant]: WideString readonly dispid -5008;
    property accHelpTopic[out pszHelpFile: WideString; varChild: OleVariant]: Integer readonly dispid -5009;
    property accKeyboardShortcut[varChild: OleVariant]: WideString readonly dispid -5010;
    property accFocus: OleVariant readonly dispid -5011;
    property accSelection: OleVariant readonly dispid -5012;
    property accDefaultAction[varChild: OleVariant]: WideString readonly dispid -5013;
    procedure accSelect(flagsSelect: Integer; varChild: OleVariant); dispid -5014;
    procedure accLocation(out pxLeft: Integer; out pyTop: Integer; out pcxWidth: Integer; 
                          out pcyHeight: Integer; varChild: OleVariant); dispid -5015;
    function accNavigate(navDir: Integer; varStart: OleVariant): OleVariant; dispid -5016;
    function accHitTest(xLeft: Integer; yTop: Integer): OleVariant; dispid -5017;
    procedure accDoDefaultAction(varChild: OleVariant); dispid -5018;
  end;

// *********************************************************************//
// Interface: Adjustments
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C0310-0000-0000-C000-000000000046}
// *********************************************************************//
  Adjustments = interface(_IMsoDispObj)
    ['{000C0310-0000-0000-C000-000000000046}']
    function Get_Parent: IDispatch; safecall;
    function Get_Count: SYSINT; safecall;
    function Get_Item(Index: SYSINT): Single; safecall;
    procedure Set_Item(Index: SYSINT; Val: Single); safecall;
    property Parent: IDispatch read Get_Parent;
    property Count: SYSINT read Get_Count;
    property Item[Index: SYSINT]: Single read Get_Item write Set_Item; default;
  end;

// *********************************************************************//
// DispIntf:  AdjustmentsDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C0310-0000-0000-C000-000000000046}
// *********************************************************************//
  AdjustmentsDisp = dispinterface
    ['{000C0310-0000-0000-C000-000000000046}']
    property Parent: IDispatch readonly dispid 1;
    property Count: SYSINT readonly dispid 2;
    property Item[Index: SYSINT]: Single dispid 0; default;
    property Application: IDispatch readonly dispid 1610743808;
    property Creator: Integer readonly dispid 1610743809;
  end;

// *********************************************************************//
// Interface: CalloutFormat
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C0311-0000-0000-C000-000000000046}
// *********************************************************************//
  CalloutFormat = interface(_IMsoDispObj)
    ['{000C0311-0000-0000-C000-000000000046}']
    function Get_Parent: IDispatch; safecall;
    procedure AutomaticLength; safecall;
    procedure CustomDrop(Drop: Single); safecall;
    procedure CustomLength(Length: Single); safecall;
    procedure PresetDrop(DropType: MsoCalloutDropType); safecall;
    function Get_Accent: MsoTriState; safecall;
    procedure Set_Accent(Accent: MsoTriState); safecall;
    function Get_Angle: MsoCalloutAngleType; safecall;
    procedure Set_Angle(Angle: MsoCalloutAngleType); safecall;
    function Get_AutoAttach: MsoTriState; safecall;
    procedure Set_AutoAttach(AutoAttach: MsoTriState); safecall;
    function Get_AutoLength: MsoTriState; safecall;
    function Get_Border: MsoTriState; safecall;
    procedure Set_Border(Border: MsoTriState); safecall;
    function Get_Drop: Single; safecall;
    function Get_DropType: MsoCalloutDropType; safecall;
    function Get_Gap: Single; safecall;
    procedure Set_Gap(Gap: Single); safecall;
    function Get_Length: Single; safecall;
    function Get_type_: MsoCalloutType; safecall;
    procedure Set_type_(Type_: MsoCalloutType); safecall;
    property Parent: IDispatch read Get_Parent;
    property Accent: MsoTriState read Get_Accent write Set_Accent;
    property Angle: MsoCalloutAngleType read Get_Angle write Set_Angle;
    property AutoAttach: MsoTriState read Get_AutoAttach write Set_AutoAttach;
    property AutoLength: MsoTriState read Get_AutoLength;
    property Border: MsoTriState read Get_Border write Set_Border;
    property Drop: Single read Get_Drop;
    property DropType: MsoCalloutDropType read Get_DropType;
    property Gap: Single read Get_Gap write Set_Gap;
    property Length: Single read Get_Length;
    property type_: MsoCalloutType read Get_type_ write Set_type_;
  end;

// *********************************************************************//
// DispIntf:  CalloutFormatDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C0311-0000-0000-C000-000000000046}
// *********************************************************************//
  CalloutFormatDisp = dispinterface
    ['{000C0311-0000-0000-C000-000000000046}']
    property Parent: IDispatch readonly dispid 1;
    procedure AutomaticLength; dispid 10;
    procedure CustomDrop(Drop: Single); dispid 11;
    procedure CustomLength(Length: Single); dispid 12;
    procedure PresetDrop(DropType: MsoCalloutDropType); dispid 13;
    property Accent: MsoTriState dispid 100;
    property Angle: MsoCalloutAngleType dispid 101;
    property AutoAttach: MsoTriState dispid 102;
    property AutoLength: MsoTriState readonly dispid 103;
    property Border: MsoTriState dispid 104;
    property Drop: Single readonly dispid 105;
    property DropType: MsoCalloutDropType readonly dispid 106;
    property Gap: Single dispid 107;
    property Length: Single readonly dispid 108;
    property type_: MsoCalloutType dispid 109;
    property Application: IDispatch readonly dispid 1610743808;
    property Creator: Integer readonly dispid 1610743809;
  end;

// *********************************************************************//
// Interface: ColorFormat
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C0312-0000-0000-C000-000000000046}
// *********************************************************************//
  ColorFormat = interface(_IMsoDispObj)
    ['{000C0312-0000-0000-C000-000000000046}']
    function Get_Parent: IDispatch; safecall;
    function Get_RGB: MsoRGBType; safecall;
    procedure Set_RGB(RGB: MsoRGBType); safecall;
    function Get_SchemeColor: SYSINT; safecall;
    procedure Set_SchemeColor(SchemeColor: SYSINT); safecall;
    function Get_type_: MsoColorType; safecall;
    property Parent: IDispatch read Get_Parent;
    property RGB: MsoRGBType read Get_RGB write Set_RGB;
    property SchemeColor: SYSINT read Get_SchemeColor write Set_SchemeColor;
    property type_: MsoColorType read Get_type_;
  end;

// *********************************************************************//
// DispIntf:  ColorFormatDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C0312-0000-0000-C000-000000000046}
// *********************************************************************//
  ColorFormatDisp = dispinterface
    ['{000C0312-0000-0000-C000-000000000046}']
    property Parent: IDispatch readonly dispid 1;
    property RGB: MsoRGBType dispid 0;
    property SchemeColor: SYSINT dispid 100;
    property type_: MsoColorType readonly dispid 101;
    property Application: IDispatch readonly dispid 1610743808;
    property Creator: Integer readonly dispid 1610743809;
  end;

// *********************************************************************//
// Interface: ConnectorFormat
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C0313-0000-0000-C000-000000000046}
// *********************************************************************//
  ConnectorFormat = interface(_IMsoDispObj)
    ['{000C0313-0000-0000-C000-000000000046}']
    function Get_Parent: IDispatch; safecall;
    procedure BeginConnect(const ConnectedShape: Shape; ConnectionSite: SYSINT); safecall;
    procedure BeginDisconnect; safecall;
    procedure EndConnect(const ConnectedShape: Shape; ConnectionSite: SYSINT); safecall;
    procedure EndDisconnect; safecall;
    function Get_BeginConnected: MsoTriState; safecall;
    function Get_BeginConnectedShape: Shape; safecall;
    function Get_BeginConnectionSite: SYSINT; safecall;
    function Get_EndConnected: MsoTriState; safecall;
    function Get_EndConnectedShape: Shape; safecall;
    function Get_EndConnectionSite: SYSINT; safecall;
    function Get_type_: MsoConnectorType; safecall;
    procedure Set_type_(Type_: MsoConnectorType); safecall;
    property Parent: IDispatch read Get_Parent;
    property BeginConnected: MsoTriState read Get_BeginConnected;
    property BeginConnectedShape: Shape read Get_BeginConnectedShape;
    property BeginConnectionSite: SYSINT read Get_BeginConnectionSite;
    property EndConnected: MsoTriState read Get_EndConnected;
    property EndConnectedShape: Shape read Get_EndConnectedShape;
    property EndConnectionSite: SYSINT read Get_EndConnectionSite;
    property type_: MsoConnectorType read Get_type_ write Set_type_;
  end;

// *********************************************************************//
// DispIntf:  ConnectorFormatDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C0313-0000-0000-C000-000000000046}
// *********************************************************************//
  ConnectorFormatDisp = dispinterface
    ['{000C0313-0000-0000-C000-000000000046}']
    property Parent: IDispatch readonly dispid 1;
    procedure BeginConnect(const ConnectedShape: Shape; ConnectionSite: SYSINT); dispid 10;
    procedure BeginDisconnect; dispid 11;
    procedure EndConnect(const ConnectedShape: Shape; ConnectionSite: SYSINT); dispid 12;
    procedure EndDisconnect; dispid 13;
    property BeginConnected: MsoTriState readonly dispid 100;
    property BeginConnectedShape: Shape readonly dispid 101;
    property BeginConnectionSite: SYSINT readonly dispid 102;
    property EndConnected: MsoTriState readonly dispid 103;
    property EndConnectedShape: Shape readonly dispid 104;
    property EndConnectionSite: SYSINT readonly dispid 105;
    property type_: MsoConnectorType dispid 106;
    property Application: IDispatch readonly dispid 1610743808;
    property Creator: Integer readonly dispid 1610743809;
  end;

// *********************************************************************//
// Interface: FillFormat
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C0314-0000-0000-C000-000000000046}
// *********************************************************************//
  FillFormat = interface(_IMsoDispObj)
    ['{000C0314-0000-0000-C000-000000000046}']
    function Get_Parent: IDispatch; safecall;
    procedure Background; safecall;
    procedure OneColorGradient(Style: MsoGradientStyle; Variant: SYSINT; Degree: Single); safecall;
    procedure Patterned(Pattern: MsoPatternType); safecall;
    procedure PresetGradient(Style: MsoGradientStyle; Variant: SYSINT; 
                             PresetGradientType: MsoPresetGradientType); safecall;
    procedure PresetTextured(PresetTexture: MsoPresetTexture); safecall;
    procedure Solid; safecall;
    procedure TwoColorGradient(Style: MsoGradientStyle; Variant: SYSINT); safecall;
    procedure UserPicture(const PictureFile: WideString); safecall;
    procedure UserTextured(const TextureFile: WideString); safecall;
    function Get_BackColor: ColorFormat; safecall;
    procedure Set_BackColor(const BackColor: ColorFormat); safecall;
    function Get_ForeColor: ColorFormat; safecall;
    procedure Set_ForeColor(const ForeColor: ColorFormat); safecall;
    function Get_GradientColorType: MsoGradientColorType; safecall;
    function Get_GradientDegree: Single; safecall;
    function Get_GradientStyle: MsoGradientStyle; safecall;
    function Get_GradientVariant: SYSINT; safecall;
    function Get_Pattern: MsoPatternType; safecall;
    function Get_PresetGradientType: MsoPresetGradientType; safecall;
    function Get_PresetTexture: MsoPresetTexture; safecall;
    function Get_TextureName: WideString; safecall;
    function Get_TextureType: MsoTextureType; safecall;
    function Get_Transparency: Single; safecall;
    procedure Set_Transparency(Transparency: Single); safecall;
    function Get_type_: MsoFillType; safecall;
    function Get_Visible: MsoTriState; safecall;
    procedure Set_Visible(Visible: MsoTriState); safecall;
    property Parent: IDispatch read Get_Parent;
    property BackColor: ColorFormat read Get_BackColor write Set_BackColor;
    property ForeColor: ColorFormat read Get_ForeColor write Set_ForeColor;
    property GradientColorType: MsoGradientColorType read Get_GradientColorType;
    property GradientDegree: Single read Get_GradientDegree;
    property GradientStyle: MsoGradientStyle read Get_GradientStyle;
    property GradientVariant: SYSINT read Get_GradientVariant;
    property Pattern: MsoPatternType read Get_Pattern;
    property PresetGradientType: MsoPresetGradientType read Get_PresetGradientType;
    property PresetTexture: MsoPresetTexture read Get_PresetTexture;
    property TextureName: WideString read Get_TextureName;
    property TextureType: MsoTextureType read Get_TextureType;
    property Transparency: Single read Get_Transparency write Set_Transparency;
    property type_: MsoFillType read Get_type_;
    property Visible: MsoTriState read Get_Visible write Set_Visible;
  end;

// *********************************************************************//
// DispIntf:  FillFormatDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C0314-0000-0000-C000-000000000046}
// *********************************************************************//
  FillFormatDisp = dispinterface
    ['{000C0314-0000-0000-C000-000000000046}']
    property Parent: IDispatch readonly dispid 1;
    procedure Background; dispid 10;
    procedure OneColorGradient(Style: MsoGradientStyle; Variant: SYSINT; Degree: Single); dispid 11;
    procedure Patterned(Pattern: MsoPatternType); dispid 12;
    procedure PresetGradient(Style: MsoGradientStyle; Variant: SYSINT; 
                             PresetGradientType: MsoPresetGradientType); dispid 13;
    procedure PresetTextured(PresetTexture: MsoPresetTexture); dispid 14;
    procedure Solid; dispid 15;
    procedure TwoColorGradient(Style: MsoGradientStyle; Variant: SYSINT); dispid 16;
    procedure UserPicture(const PictureFile: WideString); dispid 17;
    procedure UserTextured(const TextureFile: WideString); dispid 18;
    property BackColor: ColorFormat dispid 100;
    property ForeColor: ColorFormat dispid 101;
    property GradientColorType: MsoGradientColorType readonly dispid 102;
    property GradientDegree: Single readonly dispid 103;
    property GradientStyle: MsoGradientStyle readonly dispid 104;
    property GradientVariant: SYSINT readonly dispid 105;
    property Pattern: MsoPatternType readonly dispid 106;
    property PresetGradientType: MsoPresetGradientType readonly dispid 107;
    property PresetTexture: MsoPresetTexture readonly dispid 108;
    property TextureName: WideString readonly dispid 109;
    property TextureType: MsoTextureType readonly dispid 110;
    property Transparency: Single dispid 111;
    property type_: MsoFillType readonly dispid 112;
    property Visible: MsoTriState dispid 113;
    property Application: IDispatch readonly dispid 1610743808;
    property Creator: Integer readonly dispid 1610743809;
  end;

// *********************************************************************//
// Interface: FreeformBuilder
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C0315-0000-0000-C000-000000000046}
// *********************************************************************//
  FreeformBuilder = interface(_IMsoDispObj)
    ['{000C0315-0000-0000-C000-000000000046}']
    function Get_Parent: IDispatch; safecall;
    procedure AddNodes(SegmentType: MsoSegmentType; EditingType: MsoEditingType; X1: Single; 
                       Y1: Single; X2: Single; Y2: Single; X3: Single; Y3: Single); safecall;
    function ConvertToShape: Shape; safecall;
    property Parent: IDispatch read Get_Parent;
  end;

// *********************************************************************//
// DispIntf:  FreeformBuilderDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C0315-0000-0000-C000-000000000046}
// *********************************************************************//
  FreeformBuilderDisp = dispinterface
    ['{000C0315-0000-0000-C000-000000000046}']
    property Parent: IDispatch readonly dispid 1;
    procedure AddNodes(SegmentType: MsoSegmentType; EditingType: MsoEditingType; X1: Single; 
                       Y1: Single; X2: Single; Y2: Single; X3: Single; Y3: Single); dispid 10;
    function ConvertToShape: Shape; dispid 11;
    property Application: IDispatch readonly dispid 1610743808;
    property Creator: Integer readonly dispid 1610743809;
  end;

// *********************************************************************//
// Interface: GroupShapes
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C0316-0000-0000-C000-000000000046}
// *********************************************************************//
  GroupShapes = interface(_IMsoDispObj)
    ['{000C0316-0000-0000-C000-000000000046}']
    function Get_Parent: IDispatch; safecall;
    function Get_Count: SYSINT; safecall;
    function Item(Index: OleVariant): Shape; safecall;
    function Get__NewEnum: IUnknown; safecall;
    property Parent: IDispatch read Get_Parent;
    property Count: SYSINT read Get_Count;
    property _NewEnum: IUnknown read Get__NewEnum;
  end;

// *********************************************************************//
// DispIntf:  GroupShapesDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C0316-0000-0000-C000-000000000046}
// *********************************************************************//
  GroupShapesDisp = dispinterface
    ['{000C0316-0000-0000-C000-000000000046}']
    property Parent: IDispatch readonly dispid 1;
    property Count: SYSINT readonly dispid 2;
    function Item(Index: OleVariant): Shape; dispid 0;
    property _NewEnum: IUnknown readonly dispid -4;
    property Application: IDispatch readonly dispid 1610743808;
    property Creator: Integer readonly dispid 1610743809;
  end;

// *********************************************************************//
// Interface: LineFormat
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C0317-0000-0000-C000-000000000046}
// *********************************************************************//
  LineFormat = interface(_IMsoDispObj)
    ['{000C0317-0000-0000-C000-000000000046}']
    function Get_Parent: IDispatch; safecall;
    function Get_BackColor: ColorFormat; safecall;
    procedure Set_BackColor(const BackColor: ColorFormat); safecall;
    function Get_BeginArrowheadLength: MsoArrowheadLength; safecall;
    procedure Set_BeginArrowheadLength(BeginArrowheadLength: MsoArrowheadLength); safecall;
    function Get_BeginArrowheadStyle: MsoArrowheadStyle; safecall;
    procedure Set_BeginArrowheadStyle(BeginArrowheadStyle: MsoArrowheadStyle); safecall;
    function Get_BeginArrowheadWidth: MsoArrowheadWidth; safecall;
    procedure Set_BeginArrowheadWidth(BeginArrowheadWidth: MsoArrowheadWidth); safecall;
    function Get_DashStyle: MsoLineDashStyle; safecall;
    procedure Set_DashStyle(DashStyle: MsoLineDashStyle); safecall;
    function Get_EndArrowheadLength: MsoArrowheadLength; safecall;
    procedure Set_EndArrowheadLength(EndArrowheadLength: MsoArrowheadLength); safecall;
    function Get_EndArrowheadStyle: MsoArrowheadStyle; safecall;
    procedure Set_EndArrowheadStyle(EndArrowheadStyle: MsoArrowheadStyle); safecall;
    function Get_EndArrowheadWidth: MsoArrowheadWidth; safecall;
    procedure Set_EndArrowheadWidth(EndArrowheadWidth: MsoArrowheadWidth); safecall;
    function Get_ForeColor: ColorFormat; safecall;
    procedure Set_ForeColor(const ForeColor: ColorFormat); safecall;
    function Get_Pattern: MsoPatternType; safecall;
    procedure Set_Pattern(Pattern: MsoPatternType); safecall;
    function Get_Style: MsoLineStyle; safecall;
    procedure Set_Style(Style: MsoLineStyle); safecall;
    function Get_Transparency: Single; safecall;
    procedure Set_Transparency(Transparency: Single); safecall;
    function Get_Visible: MsoTriState; safecall;
    procedure Set_Visible(Visible: MsoTriState); safecall;
    function Get_Weight: Single; safecall;
    procedure Set_Weight(Weight: Single); safecall;
    property Parent: IDispatch read Get_Parent;
    property BackColor: ColorFormat read Get_BackColor write Set_BackColor;
    property BeginArrowheadLength: MsoArrowheadLength read Get_BeginArrowheadLength write Set_BeginArrowheadLength;
    property BeginArrowheadStyle: MsoArrowheadStyle read Get_BeginArrowheadStyle write Set_BeginArrowheadStyle;
    property BeginArrowheadWidth: MsoArrowheadWidth read Get_BeginArrowheadWidth write Set_BeginArrowheadWidth;
    property DashStyle: MsoLineDashStyle read Get_DashStyle write Set_DashStyle;
    property EndArrowheadLength: MsoArrowheadLength read Get_EndArrowheadLength write Set_EndArrowheadLength;
    property EndArrowheadStyle: MsoArrowheadStyle read Get_EndArrowheadStyle write Set_EndArrowheadStyle;
    property EndArrowheadWidth: MsoArrowheadWidth read Get_EndArrowheadWidth write Set_EndArrowheadWidth;
    property ForeColor: ColorFormat read Get_ForeColor write Set_ForeColor;
    property Pattern: MsoPatternType read Get_Pattern write Set_Pattern;
    property Style: MsoLineStyle read Get_Style write Set_Style;
    property Transparency: Single read Get_Transparency write Set_Transparency;
    property Visible: MsoTriState read Get_Visible write Set_Visible;
    property Weight: Single read Get_Weight write Set_Weight;
  end;

// *********************************************************************//
// DispIntf:  LineFormatDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C0317-0000-0000-C000-000000000046}
// *********************************************************************//
  LineFormatDisp = dispinterface
    ['{000C0317-0000-0000-C000-000000000046}']
    property Parent: IDispatch readonly dispid 1;
    property BackColor: ColorFormat dispid 100;
    property BeginArrowheadLength: MsoArrowheadLength dispid 101;
    property BeginArrowheadStyle: MsoArrowheadStyle dispid 102;
    property BeginArrowheadWidth: MsoArrowheadWidth dispid 103;
    property DashStyle: MsoLineDashStyle dispid 104;
    property EndArrowheadLength: MsoArrowheadLength dispid 105;
    property EndArrowheadStyle: MsoArrowheadStyle dispid 106;
    property EndArrowheadWidth: MsoArrowheadWidth dispid 107;
    property ForeColor: ColorFormat dispid 108;
    property Pattern: MsoPatternType dispid 109;
    property Style: MsoLineStyle dispid 110;
    property Transparency: Single dispid 111;
    property Visible: MsoTriState dispid 112;
    property Weight: Single dispid 113;
    property Application: IDispatch readonly dispid 1610743808;
    property Creator: Integer readonly dispid 1610743809;
  end;

// *********************************************************************//
// Interface: ShapeNode
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C0318-0000-0000-C000-000000000046}
// *********************************************************************//
  ShapeNode = interface(_IMsoDispObj)
    ['{000C0318-0000-0000-C000-000000000046}']
    function Get_Parent: IDispatch; safecall;
    function Get_EditingType: MsoEditingType; safecall;
    function Get_Points: OleVariant; safecall;
    function Get_SegmentType: MsoSegmentType; safecall;
    property Parent: IDispatch read Get_Parent;
    property EditingType: MsoEditingType read Get_EditingType;
    property Points: OleVariant read Get_Points;
    property SegmentType: MsoSegmentType read Get_SegmentType;
  end;

// *********************************************************************//
// DispIntf:  ShapeNodeDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C0318-0000-0000-C000-000000000046}
// *********************************************************************//
  ShapeNodeDisp = dispinterface
    ['{000C0318-0000-0000-C000-000000000046}']
    property Parent: IDispatch readonly dispid 1;
    property EditingType: MsoEditingType readonly dispid 100;
    property Points: OleVariant readonly dispid 101;
    property SegmentType: MsoSegmentType readonly dispid 102;
    property Application: IDispatch readonly dispid 1610743808;
    property Creator: Integer readonly dispid 1610743809;
  end;

// *********************************************************************//
// Interface: ShapeNodes
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C0319-0000-0000-C000-000000000046}
// *********************************************************************//
  ShapeNodes = interface(_IMsoDispObj)
    ['{000C0319-0000-0000-C000-000000000046}']
    function Get_Parent: IDispatch; safecall;
    function Get_Count: SYSINT; safecall;
    function Item(Index: OleVariant): ShapeNode; safecall;
    function Get__NewEnum: IUnknown; safecall;
    procedure Delete(Index: SYSINT); safecall;
    procedure Insert(Index: SYSINT; SegmentType: MsoSegmentType; EditingType: MsoEditingType; 
                     X1: Single; Y1: Single; X2: Single; Y2: Single; X3: Single; Y3: Single); safecall;
    procedure SetEditingType(Index: SYSINT; EditingType: MsoEditingType); safecall;
    procedure SetPosition(Index: SYSINT; X1: Single; Y1: Single); safecall;
    procedure SetSegmentType(Index: SYSINT; SegmentType: MsoSegmentType); safecall;
    property Parent: IDispatch read Get_Parent;
    property Count: SYSINT read Get_Count;
    property _NewEnum: IUnknown read Get__NewEnum;
  end;

// *********************************************************************//
// DispIntf:  ShapeNodesDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C0319-0000-0000-C000-000000000046}
// *********************************************************************//
  ShapeNodesDisp = dispinterface
    ['{000C0319-0000-0000-C000-000000000046}']
    property Parent: IDispatch readonly dispid 1;
    property Count: SYSINT readonly dispid 2;
    function Item(Index: OleVariant): ShapeNode; dispid 0;
    property _NewEnum: IUnknown readonly dispid -4;
    procedure Delete(Index: SYSINT); dispid 11;
    procedure Insert(Index: SYSINT; SegmentType: MsoSegmentType; EditingType: MsoEditingType; 
                     X1: Single; Y1: Single; X2: Single; Y2: Single; X3: Single; Y3: Single); dispid 12;
    procedure SetEditingType(Index: SYSINT; EditingType: MsoEditingType); dispid 13;
    procedure SetPosition(Index: SYSINT; X1: Single; Y1: Single); dispid 14;
    procedure SetSegmentType(Index: SYSINT; SegmentType: MsoSegmentType); dispid 15;
    property Application: IDispatch readonly dispid 1610743808;
    property Creator: Integer readonly dispid 1610743809;
  end;

// *********************************************************************//
// Interface: PictureFormat
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C031A-0000-0000-C000-000000000046}
// *********************************************************************//
  PictureFormat = interface(_IMsoDispObj)
    ['{000C031A-0000-0000-C000-000000000046}']
    function Get_Parent: IDispatch; safecall;
    procedure IncrementBrightness(Increment: Single); safecall;
    procedure IncrementContrast(Increment: Single); safecall;
    function Get_Brightness: Single; safecall;
    procedure Set_Brightness(Brightness: Single); safecall;
    function Get_ColorType: MsoPictureColorType; safecall;
    procedure Set_ColorType(ColorType: MsoPictureColorType); safecall;
    function Get_Contrast: Single; safecall;
    procedure Set_Contrast(Contrast: Single); safecall;
    function Get_CropBottom: Single; safecall;
    procedure Set_CropBottom(CropBottom: Single); safecall;
    function Get_CropLeft: Single; safecall;
    procedure Set_CropLeft(CropLeft: Single); safecall;
    function Get_CropRight: Single; safecall;
    procedure Set_CropRight(CropRight: Single); safecall;
    function Get_CropTop: Single; safecall;
    procedure Set_CropTop(CropTop: Single); safecall;
    function Get_TransparencyColor: MsoRGBType; safecall;
    procedure Set_TransparencyColor(TransparencyColor: MsoRGBType); safecall;
    function Get_TransparentBackground: MsoTriState; safecall;
    procedure Set_TransparentBackground(TransparentBackground: MsoTriState); safecall;
    property Parent: IDispatch read Get_Parent;
    property Brightness: Single read Get_Brightness write Set_Brightness;
    property ColorType: MsoPictureColorType read Get_ColorType write Set_ColorType;
    property Contrast: Single read Get_Contrast write Set_Contrast;
    property CropBottom: Single read Get_CropBottom write Set_CropBottom;
    property CropLeft: Single read Get_CropLeft write Set_CropLeft;
    property CropRight: Single read Get_CropRight write Set_CropRight;
    property CropTop: Single read Get_CropTop write Set_CropTop;
    property TransparencyColor: MsoRGBType read Get_TransparencyColor write Set_TransparencyColor;
    property TransparentBackground: MsoTriState read Get_TransparentBackground write Set_TransparentBackground;
  end;

// *********************************************************************//
// DispIntf:  PictureFormatDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C031A-0000-0000-C000-000000000046}
// *********************************************************************//
  PictureFormatDisp = dispinterface
    ['{000C031A-0000-0000-C000-000000000046}']
    property Parent: IDispatch readonly dispid 1;
    procedure IncrementBrightness(Increment: Single); dispid 10;
    procedure IncrementContrast(Increment: Single); dispid 11;
    property Brightness: Single dispid 100;
    property ColorType: MsoPictureColorType dispid 101;
    property Contrast: Single dispid 102;
    property CropBottom: Single dispid 103;
    property CropLeft: Single dispid 104;
    property CropRight: Single dispid 105;
    property CropTop: Single dispid 106;
    property TransparencyColor: MsoRGBType dispid 107;
    property TransparentBackground: MsoTriState dispid 108;
    property Application: IDispatch readonly dispid 1610743808;
    property Creator: Integer readonly dispid 1610743809;
  end;

// *********************************************************************//
// Interface: ShadowFormat
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C031B-0000-0000-C000-000000000046}
// *********************************************************************//
  ShadowFormat = interface(_IMsoDispObj)
    ['{000C031B-0000-0000-C000-000000000046}']
    function Get_Parent: IDispatch; safecall;
    procedure IncrementOffsetX(Increment: Single); safecall;
    procedure IncrementOffsetY(Increment: Single); safecall;
    function Get_ForeColor: ColorFormat; safecall;
    procedure Set_ForeColor(const ForeColor: ColorFormat); safecall;
    function Get_Obscured: MsoTriState; safecall;
    procedure Set_Obscured(Obscured: MsoTriState); safecall;
    function Get_OffsetX: Single; safecall;
    procedure Set_OffsetX(OffsetX: Single); safecall;
    function Get_OffsetY: Single; safecall;
    procedure Set_OffsetY(OffsetY: Single); safecall;
    function Get_Transparency: Single; safecall;
    procedure Set_Transparency(Transparency: Single); safecall;
    function Get_type_: MsoShadowType; safecall;
    procedure Set_type_(Type_: MsoShadowType); safecall;
    function Get_Visible: MsoTriState; safecall;
    procedure Set_Visible(Visible: MsoTriState); safecall;
    property Parent: IDispatch read Get_Parent;
    property ForeColor: ColorFormat read Get_ForeColor write Set_ForeColor;
    property Obscured: MsoTriState read Get_Obscured write Set_Obscured;
    property OffsetX: Single read Get_OffsetX write Set_OffsetX;
    property OffsetY: Single read Get_OffsetY write Set_OffsetY;
    property Transparency: Single read Get_Transparency write Set_Transparency;
    property type_: MsoShadowType read Get_type_ write Set_type_;
    property Visible: MsoTriState read Get_Visible write Set_Visible;
  end;

// *********************************************************************//
// DispIntf:  ShadowFormatDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C031B-0000-0000-C000-000000000046}
// *********************************************************************//
  ShadowFormatDisp = dispinterface
    ['{000C031B-0000-0000-C000-000000000046}']
    property Parent: IDispatch readonly dispid 1;
    procedure IncrementOffsetX(Increment: Single); dispid 10;
    procedure IncrementOffsetY(Increment: Single); dispid 11;
    property ForeColor: ColorFormat dispid 100;
    property Obscured: MsoTriState dispid 101;
    property OffsetX: Single dispid 102;
    property OffsetY: Single dispid 103;
    property Transparency: Single dispid 104;
    property type_: MsoShadowType dispid 105;
    property Visible: MsoTriState dispid 106;
    property Application: IDispatch readonly dispid 1610743808;
    property Creator: Integer readonly dispid 1610743809;
  end;

// *********************************************************************//
// Interface: Script
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C0341-0000-0000-C000-000000000046}
// *********************************************************************//
  Script = interface(_IMsoDispObj)
    ['{000C0341-0000-0000-C000-000000000046}']
    function Get_Parent: IDispatch; safecall;
    function Get_Extended: WideString; safecall;
    procedure Set_Extended(const Extended: WideString); safecall;
    function Get_Id: WideString; safecall;
    procedure Set_Id(const Id: WideString); safecall;
    function Get_Language: MsoScriptLanguage; safecall;
    procedure Set_Language(Language: MsoScriptLanguage); safecall;
    function Get_Location: MsoScriptLocation; safecall;
    procedure Delete; safecall;
    function Get_Shape: IDispatch; safecall;
    function Get_ScriptText: WideString; safecall;
    procedure Set_ScriptText(const Script: WideString); safecall;
    property Parent: IDispatch read Get_Parent;
    property Extended: WideString read Get_Extended write Set_Extended;
    property Id: WideString read Get_Id write Set_Id;
    property Language: MsoScriptLanguage read Get_Language write Set_Language;
    property Location: MsoScriptLocation read Get_Location;
    property Shape: IDispatch read Get_Shape;
    property ScriptText: WideString read Get_ScriptText write Set_ScriptText;
  end;

// *********************************************************************//
// DispIntf:  ScriptDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C0341-0000-0000-C000-000000000046}
// *********************************************************************//
  ScriptDisp = dispinterface
    ['{000C0341-0000-0000-C000-000000000046}']
    property Parent: IDispatch readonly dispid 1610809344;
    property Extended: WideString dispid 1610809345;
    property Id: WideString dispid 1610809347;
    property Language: MsoScriptLanguage dispid 1610809349;
    property Location: MsoScriptLocation readonly dispid 1610809351;
    procedure Delete; dispid 1610809352;
    property Shape: IDispatch readonly dispid 1610809353;
    property ScriptText: WideString dispid 0;
    property Application: IDispatch readonly dispid 1610743808;
    property Creator: Integer readonly dispid 1610743809;
  end;

// *********************************************************************//
// Interface: Scripts
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C0340-0000-0000-C000-000000000046}
// *********************************************************************//
  Scripts = interface(_IMsoDispObj)
    ['{000C0340-0000-0000-C000-000000000046}']
    function Get_Parent: IDispatch; safecall;
    function Get_Count: Integer; safecall;
    function Get__NewEnum: IUnknown; safecall;
    function Item(Index: OleVariant): Script; safecall;
    function Add(const Anchor: IDispatch; Location: MsoScriptLocation; Language: MsoScriptLanguage; 
                 const Id: WideString; const Extended: WideString; const ScriptText: WideString): Script; safecall;
    procedure Delete; safecall;
    property Parent: IDispatch read Get_Parent;
    property Count: Integer read Get_Count;
    property _NewEnum: IUnknown read Get__NewEnum;
  end;

// *********************************************************************//
// DispIntf:  ScriptsDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C0340-0000-0000-C000-000000000046}
// *********************************************************************//
  ScriptsDisp = dispinterface
    ['{000C0340-0000-0000-C000-000000000046}']
    property Parent: IDispatch readonly dispid 1610809344;
    property Count: Integer readonly dispid 1610809345;
    property _NewEnum: IUnknown readonly dispid -4;
    function Item(Index: OleVariant): Script; dispid 0;
    function Add(const Anchor: IDispatch; Location: MsoScriptLocation; Language: MsoScriptLanguage; 
                 const Id: WideString; const Extended: WideString; const ScriptText: WideString): Script; dispid 1610809348;
    procedure Delete; dispid 1610809349;
    property Application: IDispatch readonly dispid 1610743808;
    property Creator: Integer readonly dispid 1610743809;
  end;

// *********************************************************************//
// Interface: Shape
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C031C-0000-0000-C000-000000000046}
// *********************************************************************//
  Shape = interface(_IMsoDispObj)
    ['{000C031C-0000-0000-C000-000000000046}']
    function Get_Parent: IDispatch; safecall;
    procedure Apply; safecall;
    procedure Delete; safecall;
    function Duplicate: Shape; safecall;
    procedure Flip(FlipCmd: MsoFlipCmd); safecall;
    procedure IncrementLeft(Increment: Single); safecall;
    procedure IncrementRotation(Increment: Single); safecall;
    procedure IncrementTop(Increment: Single); safecall;
    procedure PickUp; safecall;
    procedure RerouteConnections; safecall;
    procedure ScaleHeight(Factor: Single; RelativeToOriginalSize: MsoTriState; fScale: MsoScaleFrom); safecall;
    procedure ScaleWidth(Factor: Single; RelativeToOriginalSize: MsoTriState; fScale: MsoScaleFrom); safecall;
    procedure Select(Replace: OleVariant); safecall;
    procedure SetShapesDefaultProperties; safecall;
    function Ungroup: ShapeRange; safecall;
    procedure ZOrder(ZOrderCmd: MsoZOrderCmd); safecall;
    function Get_Adjustments: Adjustments; safecall;
    function Get_AutoShapeType: MsoAutoShapeType; safecall;
    procedure Set_AutoShapeType(AutoShapeType: MsoAutoShapeType); safecall;
    function Get_BlackWhiteMode: MsoBlackWhiteMode; safecall;
    procedure Set_BlackWhiteMode(BlackWhiteMode: MsoBlackWhiteMode); safecall;
    function Get_Callout: CalloutFormat; safecall;
    function Get_ConnectionSiteCount: SYSINT; safecall;
    function Get_Connector: MsoTriState; safecall;
    function Get_ConnectorFormat: ConnectorFormat; safecall;
    function Get_Fill: FillFormat; safecall;
    function Get_GroupItems: GroupShapes; safecall;
    function Get_Height: Single; safecall;
    procedure Set_Height(Height: Single); safecall;
    function Get_HorizontalFlip: MsoTriState; safecall;
    function Get_Left: Single; safecall;
    procedure Set_Left(Left: Single); safecall;
    function Get_Line: LineFormat; safecall;
    function Get_LockAspectRatio: MsoTriState; safecall;
    procedure Set_LockAspectRatio(LockAspectRatio: MsoTriState); safecall;
    function Get_Name: WideString; safecall;
    procedure Set_Name(const Name: WideString); safecall;
    function Get_Nodes: ShapeNodes; safecall;
    function Get_Rotation: Single; safecall;
    procedure Set_Rotation(Rotation: Single); safecall;
    function Get_PictureFormat: PictureFormat; safecall;
    function Get_Shadow: ShadowFormat; safecall;
    function Get_TextEffect: TextEffectFormat; safecall;
    function Get_TextFrame: TextFrame; safecall;
    function Get_ThreeD: ThreeDFormat; safecall;
    function Get_Top: Single; safecall;
    procedure Set_Top(Top: Single); safecall;
    function Get_type_: MsoShapeType; safecall;
    function Get_VerticalFlip: MsoTriState; safecall;
    function Get_Vertices: OleVariant; safecall;
    function Get_Visible: MsoTriState; safecall;
    procedure Set_Visible(Visible: MsoTriState); safecall;
    function Get_Width: Single; safecall;
    procedure Set_Width(Width: Single); safecall;
    function Get_ZOrderPosition: SYSINT; safecall;
    function Get_Script: Script; safecall;
    function Get_AlternativeText: WideString; safecall;
    procedure Set_AlternativeText(const AlternativeText: WideString); safecall;
    property Parent: IDispatch read Get_Parent;
    property Adjustments: Adjustments read Get_Adjustments;
    property AutoShapeType: MsoAutoShapeType read Get_AutoShapeType write Set_AutoShapeType;
    property BlackWhiteMode: MsoBlackWhiteMode read Get_BlackWhiteMode write Set_BlackWhiteMode;
    property Callout: CalloutFormat read Get_Callout;
    property ConnectionSiteCount: SYSINT read Get_ConnectionSiteCount;
    property Connector: MsoTriState read Get_Connector;
    property ConnectorFormat: ConnectorFormat read Get_ConnectorFormat;
    property Fill: FillFormat read Get_Fill;
    property GroupItems: GroupShapes read Get_GroupItems;
    property Height: Single read Get_Height write Set_Height;
    property HorizontalFlip: MsoTriState read Get_HorizontalFlip;
    property Left: Single read Get_Left write Set_Left;
    property Line: LineFormat read Get_Line;
    property LockAspectRatio: MsoTriState read Get_LockAspectRatio write Set_LockAspectRatio;
    property Name: WideString read Get_Name write Set_Name;
    property Nodes: ShapeNodes read Get_Nodes;
    property Rotation: Single read Get_Rotation write Set_Rotation;
    property PictureFormat: PictureFormat read Get_PictureFormat;
    property Shadow: ShadowFormat read Get_Shadow;
    property TextEffect: TextEffectFormat read Get_TextEffect;
    property TextFrame: TextFrame read Get_TextFrame;
    property ThreeD: ThreeDFormat read Get_ThreeD;
    property Top: Single read Get_Top write Set_Top;
    property type_: MsoShapeType read Get_type_;
    property VerticalFlip: MsoTriState read Get_VerticalFlip;
    property Vertices: OleVariant read Get_Vertices;
    property Visible: MsoTriState read Get_Visible write Set_Visible;
    property Width: Single read Get_Width write Set_Width;
    property ZOrderPosition: SYSINT read Get_ZOrderPosition;
    property Script: Script read Get_Script;
    property AlternativeText: WideString read Get_AlternativeText write Set_AlternativeText;
  end;

// *********************************************************************//
// DispIntf:  ShapeDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C031C-0000-0000-C000-000000000046}
// *********************************************************************//
  ShapeDisp = dispinterface
    ['{000C031C-0000-0000-C000-000000000046}']
    property Parent: IDispatch readonly dispid 1;
    procedure Apply; dispid 10;
    procedure Delete; dispid 11;
    function Duplicate: Shape; dispid 12;
    procedure Flip(FlipCmd: MsoFlipCmd); dispid 13;
    procedure IncrementLeft(Increment: Single); dispid 14;
    procedure IncrementRotation(Increment: Single); dispid 15;
    procedure IncrementTop(Increment: Single); dispid 16;
    procedure PickUp; dispid 17;
    procedure RerouteConnections; dispid 18;
    procedure ScaleHeight(Factor: Single; RelativeToOriginalSize: MsoTriState; fScale: MsoScaleFrom); dispid 19;
    procedure ScaleWidth(Factor: Single; RelativeToOriginalSize: MsoTriState; fScale: MsoScaleFrom); dispid 20;
    procedure Select(Replace: OleVariant); dispid 21;
    procedure SetShapesDefaultProperties; dispid 22;
    function Ungroup: ShapeRange; dispid 23;
    procedure ZOrder(ZOrderCmd: MsoZOrderCmd); dispid 24;
    property Adjustments: Adjustments readonly dispid 100;
    property AutoShapeType: MsoAutoShapeType dispid 101;
    property BlackWhiteMode: MsoBlackWhiteMode dispid 102;
    property Callout: CalloutFormat readonly dispid 103;
    property ConnectionSiteCount: SYSINT readonly dispid 104;
    property Connector: MsoTriState readonly dispid 105;
    property ConnectorFormat: ConnectorFormat readonly dispid 106;
    property Fill: FillFormat readonly dispid 107;
    property GroupItems: GroupShapes readonly dispid 108;
    property Height: Single dispid 109;
    property HorizontalFlip: MsoTriState readonly dispid 110;
    property Left: Single dispid 111;
    property Line: LineFormat readonly dispid 112;
    property LockAspectRatio: MsoTriState dispid 113;
    property Name: WideString dispid 115;
    property Nodes: ShapeNodes readonly dispid 116;
    property Rotation: Single dispid 117;
    property PictureFormat: PictureFormat readonly dispid 118;
    property Shadow: ShadowFormat readonly dispid 119;
    property TextEffect: TextEffectFormat readonly dispid 120;
    property TextFrame: TextFrame readonly dispid 121;
    property ThreeD: ThreeDFormat readonly dispid 122;
    property Top: Single dispid 123;
    property type_: MsoShapeType readonly dispid 124;
    property VerticalFlip: MsoTriState readonly dispid 125;
    property Vertices: OleVariant readonly dispid 126;
    property Visible: MsoTriState dispid 127;
    property Width: Single dispid 128;
    property ZOrderPosition: SYSINT readonly dispid 129;
    property Script: Script readonly dispid 130;
    property AlternativeText: WideString dispid 131;
    property Application: IDispatch readonly dispid 1610743808;
    property Creator: Integer readonly dispid 1610743809;
  end;

// *********************************************************************//
// Interface: ShapeRange
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C031D-0000-0000-C000-000000000046}
// *********************************************************************//
  ShapeRange = interface(_IMsoDispObj)
    ['{000C031D-0000-0000-C000-000000000046}']
    function Get_Parent: IDispatch; safecall;
    function Get_Count: SYSINT; safecall;
    function Item(Index: OleVariant): Shape; safecall;
    function Get__NewEnum: IUnknown; safecall;
    procedure Align(AlignCmd: MsoAlignCmd; RelativeTo: MsoTriState); safecall;
    procedure Apply; safecall;
    procedure Delete; safecall;
    procedure Distribute(DistributeCmd: MsoDistributeCmd; RelativeTo: MsoTriState); safecall;
    function Duplicate: ShapeRange; safecall;
    procedure Flip(FlipCmd: MsoFlipCmd); safecall;
    procedure IncrementLeft(Increment: Single); safecall;
    procedure IncrementRotation(Increment: Single); safecall;
    procedure IncrementTop(Increment: Single); safecall;
    function Group: Shape; safecall;
    procedure PickUp; safecall;
    function Regroup: Shape; safecall;
    procedure RerouteConnections; safecall;
    procedure ScaleHeight(Factor: Single; RelativeToOriginalSize: MsoTriState; fScale: MsoScaleFrom); safecall;
    procedure ScaleWidth(Factor: Single; RelativeToOriginalSize: MsoTriState; fScale: MsoScaleFrom); safecall;
    procedure Select(Replace: OleVariant); safecall;
    procedure SetShapesDefaultProperties; safecall;
    function Ungroup: ShapeRange; safecall;
    procedure ZOrder(ZOrderCmd: MsoZOrderCmd); safecall;
    function Get_Adjustments: Adjustments; safecall;
    function Get_AutoShapeType: MsoAutoShapeType; safecall;
    procedure Set_AutoShapeType(AutoShapeType: MsoAutoShapeType); safecall;
    function Get_BlackWhiteMode: MsoBlackWhiteMode; safecall;
    procedure Set_BlackWhiteMode(BlackWhiteMode: MsoBlackWhiteMode); safecall;
    function Get_Callout: CalloutFormat; safecall;
    function Get_ConnectionSiteCount: SYSINT; safecall;
    function Get_Connector: MsoTriState; safecall;
    function Get_ConnectorFormat: ConnectorFormat; safecall;
    function Get_Fill: FillFormat; safecall;
    function Get_GroupItems: GroupShapes; safecall;
    function Get_Height: Single; safecall;
    procedure Set_Height(Height: Single); safecall;
    function Get_HorizontalFlip: MsoTriState; safecall;
    function Get_Left: Single; safecall;
    procedure Set_Left(Left: Single); safecall;
    function Get_Line: LineFormat; safecall;
    function Get_LockAspectRatio: MsoTriState; safecall;
    procedure Set_LockAspectRatio(LockAspectRatio: MsoTriState); safecall;
    function Get_Name: WideString; safecall;
    procedure Set_Name(const Name: WideString); safecall;
    function Get_Nodes: ShapeNodes; safecall;
    function Get_Rotation: Single; safecall;
    procedure Set_Rotation(Rotation: Single); safecall;
    function Get_PictureFormat: PictureFormat; safecall;
    function Get_Shadow: ShadowFormat; safecall;
    function Get_TextEffect: TextEffectFormat; safecall;
    function Get_TextFrame: TextFrame; safecall;
    function Get_ThreeD: ThreeDFormat; safecall;
    function Get_Top: Single; safecall;
    procedure Set_Top(Top: Single); safecall;
    function Get_type_: MsoShapeType; safecall;
    function Get_VerticalFlip: MsoTriState; safecall;
    function Get_Vertices: OleVariant; safecall;
    function Get_Visible: MsoTriState; safecall;
    procedure Set_Visible(Visible: MsoTriState); safecall;
    function Get_Width: Single; safecall;
    procedure Set_Width(Width: Single); safecall;
    function Get_ZOrderPosition: SYSINT; safecall;
    function Get_Script: Script; safecall;
    function Get_AlternativeText: WideString; safecall;
    procedure Set_AlternativeText(const AlternativeText: WideString); safecall;
    property Parent: IDispatch read Get_Parent;
    property Count: SYSINT read Get_Count;
    property _NewEnum: IUnknown read Get__NewEnum;
    property Adjustments: Adjustments read Get_Adjustments;
    property AutoShapeType: MsoAutoShapeType read Get_AutoShapeType write Set_AutoShapeType;
    property BlackWhiteMode: MsoBlackWhiteMode read Get_BlackWhiteMode write Set_BlackWhiteMode;
    property Callout: CalloutFormat read Get_Callout;
    property ConnectionSiteCount: SYSINT read Get_ConnectionSiteCount;
    property Connector: MsoTriState read Get_Connector;
    property ConnectorFormat: ConnectorFormat read Get_ConnectorFormat;
    property Fill: FillFormat read Get_Fill;
    property GroupItems: GroupShapes read Get_GroupItems;
    property Height: Single read Get_Height write Set_Height;
    property HorizontalFlip: MsoTriState read Get_HorizontalFlip;
    property Left: Single read Get_Left write Set_Left;
    property Line: LineFormat read Get_Line;
    property LockAspectRatio: MsoTriState read Get_LockAspectRatio write Set_LockAspectRatio;
    property Name: WideString read Get_Name write Set_Name;
    property Nodes: ShapeNodes read Get_Nodes;
    property Rotation: Single read Get_Rotation write Set_Rotation;
    property PictureFormat: PictureFormat read Get_PictureFormat;
    property Shadow: ShadowFormat read Get_Shadow;
    property TextEffect: TextEffectFormat read Get_TextEffect;
    property TextFrame: TextFrame read Get_TextFrame;
    property ThreeD: ThreeDFormat read Get_ThreeD;
    property Top: Single read Get_Top write Set_Top;
    property type_: MsoShapeType read Get_type_;
    property VerticalFlip: MsoTriState read Get_VerticalFlip;
    property Vertices: OleVariant read Get_Vertices;
    property Visible: MsoTriState read Get_Visible write Set_Visible;
    property Width: Single read Get_Width write Set_Width;
    property ZOrderPosition: SYSINT read Get_ZOrderPosition;
    property Script: Script read Get_Script;
    property AlternativeText: WideString read Get_AlternativeText write Set_AlternativeText;
  end;

// *********************************************************************//
// DispIntf:  ShapeRangeDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C031D-0000-0000-C000-000000000046}
// *********************************************************************//
  ShapeRangeDisp = dispinterface
    ['{000C031D-0000-0000-C000-000000000046}']
    property Parent: IDispatch readonly dispid 1;
    property Count: SYSINT readonly dispid 2;
    function Item(Index: OleVariant): Shape; dispid 0;
    property _NewEnum: IUnknown readonly dispid -4;
    procedure Align(AlignCmd: MsoAlignCmd; RelativeTo: MsoTriState); dispid 10;
    procedure Apply; dispid 11;
    procedure Delete; dispid 12;
    procedure Distribute(DistributeCmd: MsoDistributeCmd; RelativeTo: MsoTriState); dispid 13;
    function Duplicate: ShapeRange; dispid 14;
    procedure Flip(FlipCmd: MsoFlipCmd); dispid 15;
    procedure IncrementLeft(Increment: Single); dispid 16;
    procedure IncrementRotation(Increment: Single); dispid 17;
    procedure IncrementTop(Increment: Single); dispid 18;
    function Group: Shape; dispid 19;
    procedure PickUp; dispid 20;
    function Regroup: Shape; dispid 21;
    procedure RerouteConnections; dispid 22;
    procedure ScaleHeight(Factor: Single; RelativeToOriginalSize: MsoTriState; fScale: MsoScaleFrom); dispid 23;
    procedure ScaleWidth(Factor: Single; RelativeToOriginalSize: MsoTriState; fScale: MsoScaleFrom); dispid 24;
    procedure Select(Replace: OleVariant); dispid 25;
    procedure SetShapesDefaultProperties; dispid 26;
    function Ungroup: ShapeRange; dispid 27;
    procedure ZOrder(ZOrderCmd: MsoZOrderCmd); dispid 28;
    property Adjustments: Adjustments readonly dispid 100;
    property AutoShapeType: MsoAutoShapeType dispid 101;
    property BlackWhiteMode: MsoBlackWhiteMode dispid 102;
    property Callout: CalloutFormat readonly dispid 103;
    property ConnectionSiteCount: SYSINT readonly dispid 104;
    property Connector: MsoTriState readonly dispid 105;
    property ConnectorFormat: ConnectorFormat readonly dispid 106;
    property Fill: FillFormat readonly dispid 107;
    property GroupItems: GroupShapes readonly dispid 108;
    property Height: Single dispid 109;
    property HorizontalFlip: MsoTriState readonly dispid 110;
    property Left: Single dispid 111;
    property Line: LineFormat readonly dispid 112;
    property LockAspectRatio: MsoTriState dispid 113;
    property Name: WideString dispid 115;
    property Nodes: ShapeNodes readonly dispid 116;
    property Rotation: Single dispid 117;
    property PictureFormat: PictureFormat readonly dispid 118;
    property Shadow: ShadowFormat readonly dispid 119;
    property TextEffect: TextEffectFormat readonly dispid 120;
    property TextFrame: TextFrame readonly dispid 121;
    property ThreeD: ThreeDFormat readonly dispid 122;
    property Top: Single dispid 123;
    property type_: MsoShapeType readonly dispid 124;
    property VerticalFlip: MsoTriState readonly dispid 125;
    property Vertices: OleVariant readonly dispid 126;
    property Visible: MsoTriState dispid 127;
    property Width: Single dispid 128;
    property ZOrderPosition: SYSINT readonly dispid 129;
    property Script: Script readonly dispid 130;
    property AlternativeText: WideString dispid 131;
    property Application: IDispatch readonly dispid 1610743808;
    property Creator: Integer readonly dispid 1610743809;
  end;

// *********************************************************************//
// Interface: Shapes
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C031E-0000-0000-C000-000000000046}
// *********************************************************************//
  Shapes = interface(_IMsoDispObj)
    ['{000C031E-0000-0000-C000-000000000046}']
    function Get_Parent: IDispatch; safecall;
    function Get_Count: SYSINT; safecall;
    function Item(Index: OleVariant): Shape; safecall;
    function Get__NewEnum: IUnknown; safecall;
    function AddCallout(Type_: MsoCalloutType; Left: Single; Top: Single; Width: Single; 
                        Height: Single): Shape; safecall;
    function AddConnector(Type_: MsoConnectorType; BeginX: Single; BeginY: Single; EndX: Single; 
                          EndY: Single): Shape; safecall;
    function AddCurve(SafeArrayOfPoints: OleVariant): Shape; safecall;
    function AddLabel(Orientation: MsoTextOrientation; Left: Single; Top: Single; Width: Single; 
                      Height: Single): Shape; safecall;
    function AddLine(BeginX: Single; BeginY: Single; EndX: Single; EndY: Single): Shape; safecall;
    function AddPicture(const FileName: WideString; LinkToFile: MsoTriState; 
                        SaveWithDocument: MsoTriState; Left: Single; Top: Single; Width: Single; 
                        Height: Single): Shape; safecall;
    function AddPolyline(SafeArrayOfPoints: OleVariant): Shape; safecall;
    function AddShape(Type_: MsoAutoShapeType; Left: Single; Top: Single; Width: Single; 
                      Height: Single): Shape; safecall;
    function AddTextEffect(PresetTextEffect: MsoPresetTextEffect; const Text: WideString; 
                           const FontName: WideString; FontSize: Single; FontBold: MsoTriState; 
                           FontItalic: MsoTriState; Left: Single; Top: Single): Shape; safecall;
    function AddTextbox(Orientation: MsoTextOrientation; Left: Single; Top: Single; Width: Single; 
                        Height: Single): Shape; safecall;
    function BuildFreeform(EditingType: MsoEditingType; X1: Single; Y1: Single): FreeformBuilder; safecall;
    function Range(Index: OleVariant): ShapeRange; safecall;
    procedure SelectAll; safecall;
    function Get_Background: Shape; safecall;
    function Get_Default: Shape; safecall;
    property Parent: IDispatch read Get_Parent;
    property Count: SYSINT read Get_Count;
    property _NewEnum: IUnknown read Get__NewEnum;
    property Background: Shape read Get_Background;
    property Default: Shape read Get_Default;
  end;

// *********************************************************************//
// DispIntf:  ShapesDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C031E-0000-0000-C000-000000000046}
// *********************************************************************//
  ShapesDisp = dispinterface
    ['{000C031E-0000-0000-C000-000000000046}']
    property Parent: IDispatch readonly dispid 1;
    property Count: SYSINT readonly dispid 2;
    function Item(Index: OleVariant): Shape; dispid 0;
    property _NewEnum: IUnknown readonly dispid -4;
    function AddCallout(Type_: MsoCalloutType; Left: Single; Top: Single; Width: Single; 
                        Height: Single): Shape; dispid 10;
    function AddConnector(Type_: MsoConnectorType; BeginX: Single; BeginY: Single; EndX: Single; 
                          EndY: Single): Shape; dispid 11;
    function AddCurve(SafeArrayOfPoints: OleVariant): Shape; dispid 12;
    function AddLabel(Orientation: MsoTextOrientation; Left: Single; Top: Single; Width: Single; 
                      Height: Single): Shape; dispid 13;
    function AddLine(BeginX: Single; BeginY: Single; EndX: Single; EndY: Single): Shape; dispid 14;
    function AddPicture(const FileName: WideString; LinkToFile: MsoTriState; 
                        SaveWithDocument: MsoTriState; Left: Single; Top: Single; Width: Single; 
                        Height: Single): Shape; dispid 15;
    function AddPolyline(SafeArrayOfPoints: OleVariant): Shape; dispid 16;
    function AddShape(Type_: MsoAutoShapeType; Left: Single; Top: Single; Width: Single; 
                      Height: Single): Shape; dispid 17;
    function AddTextEffect(PresetTextEffect: MsoPresetTextEffect; const Text: WideString; 
                           const FontName: WideString; FontSize: Single; FontBold: MsoTriState; 
                           FontItalic: MsoTriState; Left: Single; Top: Single): Shape; dispid 18;
    function AddTextbox(Orientation: MsoTextOrientation; Left: Single; Top: Single; Width: Single; 
                        Height: Single): Shape; dispid 19;
    function BuildFreeform(EditingType: MsoEditingType; X1: Single; Y1: Single): FreeformBuilder; dispid 20;
    function Range(Index: OleVariant): ShapeRange; dispid 21;
    procedure SelectAll; dispid 22;
    property Background: Shape readonly dispid 100;
    property Default: Shape readonly dispid 101;
    property Application: IDispatch readonly dispid 1610743808;
    property Creator: Integer readonly dispid 1610743809;
  end;

// *********************************************************************//
// Interface: TextEffectFormat
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C031F-0000-0000-C000-000000000046}
// *********************************************************************//
  TextEffectFormat = interface(_IMsoDispObj)
    ['{000C031F-0000-0000-C000-000000000046}']
    function Get_Parent: IDispatch; safecall;
    procedure ToggleVerticalText; safecall;
    function Get_Alignment: MsoTextEffectAlignment; safecall;
    procedure Set_Alignment(Alignment: MsoTextEffectAlignment); safecall;
    function Get_FontBold: MsoTriState; safecall;
    procedure Set_FontBold(FontBold: MsoTriState); safecall;
    function Get_FontItalic: MsoTriState; safecall;
    procedure Set_FontItalic(FontItalic: MsoTriState); safecall;
    function Get_FontName: WideString; safecall;
    procedure Set_FontName(const FontName: WideString); safecall;
    function Get_FontSize: Single; safecall;
    procedure Set_FontSize(FontSize: Single); safecall;
    function Get_KernedPairs: MsoTriState; safecall;
    procedure Set_KernedPairs(KernedPairs: MsoTriState); safecall;
    function Get_NormalizedHeight: MsoTriState; safecall;
    procedure Set_NormalizedHeight(NormalizedHeight: MsoTriState); safecall;
    function Get_PresetShape: MsoPresetTextEffectShape; safecall;
    procedure Set_PresetShape(PresetShape: MsoPresetTextEffectShape); safecall;
    function Get_PresetTextEffect: MsoPresetTextEffect; safecall;
    procedure Set_PresetTextEffect(Preset: MsoPresetTextEffect); safecall;
    function Get_RotatedChars: MsoTriState; safecall;
    procedure Set_RotatedChars(RotatedChars: MsoTriState); safecall;
    function Get_Text: WideString; safecall;
    procedure Set_Text(const Text: WideString); safecall;
    function Get_Tracking: Single; safecall;
    procedure Set_Tracking(Tracking: Single); safecall;
    property Parent: IDispatch read Get_Parent;
    property Alignment: MsoTextEffectAlignment read Get_Alignment write Set_Alignment;
    property FontBold: MsoTriState read Get_FontBold write Set_FontBold;
    property FontItalic: MsoTriState read Get_FontItalic write Set_FontItalic;
    property FontName: WideString read Get_FontName write Set_FontName;
    property FontSize: Single read Get_FontSize write Set_FontSize;
    property KernedPairs: MsoTriState read Get_KernedPairs write Set_KernedPairs;
    property NormalizedHeight: MsoTriState read Get_NormalizedHeight write Set_NormalizedHeight;
    property PresetShape: MsoPresetTextEffectShape read Get_PresetShape write Set_PresetShape;
    property PresetTextEffect: MsoPresetTextEffect read Get_PresetTextEffect write Set_PresetTextEffect;
    property RotatedChars: MsoTriState read Get_RotatedChars write Set_RotatedChars;
    property Text: WideString read Get_Text write Set_Text;
    property Tracking: Single read Get_Tracking write Set_Tracking;
  end;

// *********************************************************************//
// DispIntf:  TextEffectFormatDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C031F-0000-0000-C000-000000000046}
// *********************************************************************//
  TextEffectFormatDisp = dispinterface
    ['{000C031F-0000-0000-C000-000000000046}']
    property Parent: IDispatch readonly dispid 1;
    procedure ToggleVerticalText; dispid 10;
    property Alignment: MsoTextEffectAlignment dispid 100;
    property FontBold: MsoTriState dispid 101;
    property FontItalic: MsoTriState dispid 102;
    property FontName: WideString dispid 103;
    property FontSize: Single dispid 104;
    property KernedPairs: MsoTriState dispid 105;
    property NormalizedHeight: MsoTriState dispid 106;
    property PresetShape: MsoPresetTextEffectShape dispid 107;
    property PresetTextEffect: MsoPresetTextEffect dispid 108;
    property RotatedChars: MsoTriState dispid 109;
    property Text: WideString dispid 110;
    property Tracking: Single dispid 111;
    property Application: IDispatch readonly dispid 1610743808;
    property Creator: Integer readonly dispid 1610743809;
  end;

// *********************************************************************//
// Interface: TextFrame
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C0320-0000-0000-C000-000000000046}
// *********************************************************************//
  TextFrame = interface(_IMsoDispObj)
    ['{000C0320-0000-0000-C000-000000000046}']
    function Get_Parent: IDispatch; safecall;
    function Get_MarginBottom: Single; safecall;
    procedure Set_MarginBottom(MarginBottom: Single); safecall;
    function Get_MarginLeft: Single; safecall;
    procedure Set_MarginLeft(MarginLeft: Single); safecall;
    function Get_MarginRight: Single; safecall;
    procedure Set_MarginRight(MarginRight: Single); safecall;
    function Get_MarginTop: Single; safecall;
    procedure Set_MarginTop(MarginTop: Single); safecall;
    function Get_Orientation: MsoTextOrientation; safecall;
    procedure Set_Orientation(Orientation: MsoTextOrientation); safecall;
    property Parent: IDispatch read Get_Parent;
    property MarginBottom: Single read Get_MarginBottom write Set_MarginBottom;
    property MarginLeft: Single read Get_MarginLeft write Set_MarginLeft;
    property MarginRight: Single read Get_MarginRight write Set_MarginRight;
    property MarginTop: Single read Get_MarginTop write Set_MarginTop;
    property Orientation: MsoTextOrientation read Get_Orientation write Set_Orientation;
  end;

// *********************************************************************//
// DispIntf:  TextFrameDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C0320-0000-0000-C000-000000000046}
// *********************************************************************//
  TextFrameDisp = dispinterface
    ['{000C0320-0000-0000-C000-000000000046}']
    property Parent: IDispatch readonly dispid 1;
    property MarginBottom: Single dispid 100;
    property MarginLeft: Single dispid 101;
    property MarginRight: Single dispid 102;
    property MarginTop: Single dispid 103;
    property Orientation: MsoTextOrientation dispid 104;
    property Application: IDispatch readonly dispid 1610743808;
    property Creator: Integer readonly dispid 1610743809;
  end;

// *********************************************************************//
// Interface: ThreeDFormat
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C0321-0000-0000-C000-000000000046}
// *********************************************************************//
  ThreeDFormat = interface(_IMsoDispObj)
    ['{000C0321-0000-0000-C000-000000000046}']
    function Get_Parent: IDispatch; safecall;
    procedure IncrementRotationX(Increment: Single); safecall;
    procedure IncrementRotationY(Increment: Single); safecall;
    procedure ResetRotation; safecall;
    procedure SetThreeDFormat(PresetThreeDFormat: MsoPresetThreeDFormat); safecall;
    procedure SetExtrusionDirection(PresetExtrusionDirection: MsoPresetExtrusionDirection); safecall;
    function Get_Depth: Single; safecall;
    procedure Set_Depth(Depth: Single); safecall;
    function Get_ExtrusionColor: ColorFormat; safecall;
    function Get_ExtrusionColorType: MsoExtrusionColorType; safecall;
    procedure Set_ExtrusionColorType(ExtrusionColorType: MsoExtrusionColorType); safecall;
    function Get_Perspective: MsoTriState; safecall;
    procedure Set_Perspective(Perspective: MsoTriState); safecall;
    function Get_PresetExtrusionDirection: MsoPresetExtrusionDirection; safecall;
    function Get_PresetLightingDirection: MsoPresetLightingDirection; safecall;
    procedure Set_PresetLightingDirection(PresetLightingDirection: MsoPresetLightingDirection); safecall;
    function Get_PresetLightingSoftness: MsoPresetLightingSoftness; safecall;
    procedure Set_PresetLightingSoftness(PresetLightingSoftness: MsoPresetLightingSoftness); safecall;
    function Get_PresetMaterial: MsoPresetMaterial; safecall;
    procedure Set_PresetMaterial(PresetMaterial: MsoPresetMaterial); safecall;
    function Get_PresetThreeDFormat: MsoPresetThreeDFormat; safecall;
    function Get_RotationX: Single; safecall;
    procedure Set_RotationX(RotationX: Single); safecall;
    function Get_RotationY: Single; safecall;
    procedure Set_RotationY(RotationY: Single); safecall;
    function Get_Visible: MsoTriState; safecall;
    procedure Set_Visible(Visible: MsoTriState); safecall;
    property Parent: IDispatch read Get_Parent;
    property Depth: Single read Get_Depth write Set_Depth;
    property ExtrusionColor: ColorFormat read Get_ExtrusionColor;
    property ExtrusionColorType: MsoExtrusionColorType read Get_ExtrusionColorType write Set_ExtrusionColorType;
    property Perspective: MsoTriState read Get_Perspective write Set_Perspective;
    property PresetExtrusionDirection: MsoPresetExtrusionDirection read Get_PresetExtrusionDirection;
    property PresetLightingDirection: MsoPresetLightingDirection read Get_PresetLightingDirection write Set_PresetLightingDirection;
    property PresetLightingSoftness: MsoPresetLightingSoftness read Get_PresetLightingSoftness write Set_PresetLightingSoftness;
    property PresetMaterial: MsoPresetMaterial read Get_PresetMaterial write Set_PresetMaterial;
    property PresetThreeDFormat: MsoPresetThreeDFormat read Get_PresetThreeDFormat;
    property RotationX: Single read Get_RotationX write Set_RotationX;
    property RotationY: Single read Get_RotationY write Set_RotationY;
    property Visible: MsoTriState read Get_Visible write Set_Visible;
  end;

// *********************************************************************//
// DispIntf:  ThreeDFormatDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C0321-0000-0000-C000-000000000046}
// *********************************************************************//
  ThreeDFormatDisp = dispinterface
    ['{000C0321-0000-0000-C000-000000000046}']
    property Parent: IDispatch readonly dispid 1;
    procedure IncrementRotationX(Increment: Single); dispid 10;
    procedure IncrementRotationY(Increment: Single); dispid 11;
    procedure ResetRotation; dispid 12;
    procedure SetThreeDFormat(PresetThreeDFormat: MsoPresetThreeDFormat); dispid 13;
    procedure SetExtrusionDirection(PresetExtrusionDirection: MsoPresetExtrusionDirection); dispid 14;
    property Depth: Single dispid 100;
    property ExtrusionColor: ColorFormat readonly dispid 101;
    property ExtrusionColorType: MsoExtrusionColorType dispid 102;
    property Perspective: MsoTriState dispid 103;
    property PresetExtrusionDirection: MsoPresetExtrusionDirection readonly dispid 104;
    property PresetLightingDirection: MsoPresetLightingDirection dispid 105;
    property PresetLightingSoftness: MsoPresetLightingSoftness dispid 106;
    property PresetMaterial: MsoPresetMaterial dispid 107;
    property PresetThreeDFormat: MsoPresetThreeDFormat readonly dispid 108;
    property RotationX: Single dispid 109;
    property RotationY: Single dispid 110;
    property Visible: MsoTriState dispid 111;
    property Application: IDispatch readonly dispid 1610743808;
    property Creator: Integer readonly dispid 1610743809;
  end;

// *********************************************************************//
// Interface: IMsoDispCagNotifySink
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C0359-0000-0000-C000-000000000046}
// *********************************************************************//
  IMsoDispCagNotifySink = interface(IDispatch)
    ['{000C0359-0000-0000-C000-000000000046}']
    procedure InsertClip(const pClipMoniker: IUnknown; const pItemMoniker: IUnknown); safecall;
    procedure WindowIsClosing; safecall;
  end;

// *********************************************************************//
// DispIntf:  IMsoDispCagNotifySinkDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C0359-0000-0000-C000-000000000046}
// *********************************************************************//
  IMsoDispCagNotifySinkDisp = dispinterface
    ['{000C0359-0000-0000-C000-000000000046}']
    procedure InsertClip(const pClipMoniker: IUnknown; const pItemMoniker: IUnknown); dispid 1;
    procedure WindowIsClosing; dispid 2;
  end;

// *********************************************************************//
// Interface: Balloon
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C0324-0000-0000-C000-000000000046}
// *********************************************************************//
  Balloon = interface(_IMsoDispObj)
    ['{000C0324-0000-0000-C000-000000000046}']
    function Get_Parent: IDispatch; safecall;
    function Get_Checkboxes: IDispatch; safecall;
    function Get_Labels: IDispatch; safecall;
    procedure Set_BalloonType(pbty: MsoBalloonType); safecall;
    function Get_BalloonType: MsoBalloonType; safecall;
    procedure Set_Icon(picn: MsoIconType); safecall;
    function Get_Icon: MsoIconType; safecall;
    procedure Set_Heading(const pbstr: WideString); safecall;
    function Get_Heading: WideString; safecall;
    procedure Set_Text(const pbstr: WideString); safecall;
    function Get_Text: WideString; safecall;
    procedure Set_Mode(pmd: MsoModeType); safecall;
    function Get_Mode: MsoModeType; safecall;
    procedure Set_Animation(pfca: MsoAnimationType); safecall;
    function Get_Animation: MsoAnimationType; safecall;
    procedure Set_Button(psbs: MsoButtonSetType); safecall;
    function Get_Button: MsoButtonSetType; safecall;
    procedure Set_Callback(const pbstr: WideString); safecall;
    function Get_Callback: WideString; safecall;
    procedure Set_Private_(plPrivate: Integer); safecall;
    function Get_Private_: Integer; safecall;
    procedure SetAvoidRectangle(Left: SYSINT; Top: SYSINT; Right: SYSINT; Bottom: SYSINT); safecall;
    function Get_Name: WideString; safecall;
    function Show: MsoBalloonButtonType; safecall;
    procedure Close; safecall;
    property Parent: IDispatch read Get_Parent;
    property Checkboxes: IDispatch read Get_Checkboxes;
    property Labels: IDispatch read Get_Labels;
    property BalloonType: MsoBalloonType read Get_BalloonType write Set_BalloonType;
    property Icon: MsoIconType read Get_Icon write Set_Icon;
    property Heading: WideString read Get_Heading write Set_Heading;
    property Text: WideString read Get_Text write Set_Text;
    property Mode: MsoModeType read Get_Mode write Set_Mode;
    property Animation: MsoAnimationType read Get_Animation write Set_Animation;
    property Button: MsoButtonSetType read Get_Button write Set_Button;
    property Callback: WideString read Get_Callback write Set_Callback;
    property Private_: Integer read Get_Private_ write Set_Private_;
    property Name: WideString read Get_Name;
  end;

// *********************************************************************//
// DispIntf:  BalloonDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C0324-0000-0000-C000-000000000046}
// *********************************************************************//
  BalloonDisp = dispinterface
    ['{000C0324-0000-0000-C000-000000000046}']
    property Parent: IDispatch readonly dispid 1610809344;
    property Checkboxes: IDispatch readonly dispid 1610809345;
    property Labels: IDispatch readonly dispid 1610809346;
    property BalloonType: MsoBalloonType dispid 1610809347;
    property Icon: MsoIconType dispid 1610809349;
    property Heading: WideString dispid 1610809351;
    property Text: WideString dispid 1610809353;
    property Mode: MsoModeType dispid 1610809355;
    property Animation: MsoAnimationType dispid 1610809357;
    property Button: MsoButtonSetType dispid 1610809359;
    property Callback: WideString dispid 1610809361;
    property Private_: Integer dispid 1610809363;
    procedure SetAvoidRectangle(Left: SYSINT; Top: SYSINT; Right: SYSINT; Bottom: SYSINT); dispid 1610809365;
    property Name: WideString readonly dispid 1610809366;
    function Show: MsoBalloonButtonType; dispid 1610809367;
    procedure Close; dispid 1610809368;
    property Application: IDispatch readonly dispid 1610743808;
    property Creator: Integer readonly dispid 1610743809;
  end;

// *********************************************************************//
// Interface: BalloonCheckboxes
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C0326-0000-0000-C000-000000000046}
// *********************************************************************//
  BalloonCheckboxes = interface(_IMsoDispObj)
    ['{000C0326-0000-0000-C000-000000000046}']
    function Get_Name: WideString; safecall;
    function Get_Parent: IDispatch; safecall;
    function Get_Item(Index: SYSINT): IDispatch; safecall;
    function Get_Count: SYSINT; safecall;
    procedure Set_Count(pccbx: SYSINT); safecall;
    function Get__NewEnum: IUnknown; safecall;
    property Name: WideString read Get_Name;
    property Parent: IDispatch read Get_Parent;
    property Item[Index: SYSINT]: IDispatch read Get_Item; default;
    property Count: SYSINT read Get_Count write Set_Count;
    property _NewEnum: IUnknown read Get__NewEnum;
  end;

// *********************************************************************//
// DispIntf:  BalloonCheckboxesDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C0326-0000-0000-C000-000000000046}
// *********************************************************************//
  BalloonCheckboxesDisp = dispinterface
    ['{000C0326-0000-0000-C000-000000000046}']
    property Name: WideString readonly dispid 1610809344;
    property Parent: IDispatch readonly dispid 1610809345;
    property Item[Index: SYSINT]: IDispatch readonly dispid 0; default;
    property Count: SYSINT dispid 1610809347;
    property _NewEnum: IUnknown readonly dispid -4;
    property Application: IDispatch readonly dispid 1610743808;
    property Creator: Integer readonly dispid 1610743809;
  end;

// *********************************************************************//
// Interface: BalloonCheckbox
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C0328-0000-0000-C000-000000000046}
// *********************************************************************//
  BalloonCheckbox = interface(_IMsoDispObj)
    ['{000C0328-0000-0000-C000-000000000046}']
    function Get_Item: WideString; safecall;
    function Get_Name: WideString; safecall;
    function Get_Parent: IDispatch; safecall;
    procedure Set_Checked(pvarfChecked: WordBool); safecall;
    function Get_Checked: WordBool; safecall;
    procedure Set_Text(const pbstr: WideString); safecall;
    function Get_Text: WideString; safecall;
    property Item: WideString read Get_Item;
    property Name: WideString read Get_Name;
    property Parent: IDispatch read Get_Parent;
    property Checked: WordBool read Get_Checked write Set_Checked;
    property Text: WideString read Get_Text write Set_Text;
  end;

// *********************************************************************//
// DispIntf:  BalloonCheckboxDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C0328-0000-0000-C000-000000000046}
// *********************************************************************//
  BalloonCheckboxDisp = dispinterface
    ['{000C0328-0000-0000-C000-000000000046}']
    property Item: WideString readonly dispid 0;
    property Name: WideString readonly dispid 1610809345;
    property Parent: IDispatch readonly dispid 1610809346;
    property Checked: WordBool dispid 1610809347;
    property Text: WideString dispid 1610809349;
    property Application: IDispatch readonly dispid 1610743808;
    property Creator: Integer readonly dispid 1610743809;
  end;

// *********************************************************************//
// Interface: BalloonLabels
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C032E-0000-0000-C000-000000000046}
// *********************************************************************//
  BalloonLabels = interface(_IMsoDispObj)
    ['{000C032E-0000-0000-C000-000000000046}']
    function Get_Name: WideString; safecall;
    function Get_Parent: IDispatch; safecall;
    function Get_Item(Index: SYSINT): IDispatch; safecall;
    function Get_Count: SYSINT; safecall;
    procedure Set_Count(pcwz: SYSINT); safecall;
    function Get__NewEnum: IUnknown; safecall;
    property Name: WideString read Get_Name;
    property Parent: IDispatch read Get_Parent;
    property Item[Index: SYSINT]: IDispatch read Get_Item; default;
    property Count: SYSINT read Get_Count write Set_Count;
    property _NewEnum: IUnknown read Get__NewEnum;
  end;

// *********************************************************************//
// DispIntf:  BalloonLabelsDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C032E-0000-0000-C000-000000000046}
// *********************************************************************//
  BalloonLabelsDisp = dispinterface
    ['{000C032E-0000-0000-C000-000000000046}']
    property Name: WideString readonly dispid 1610809344;
    property Parent: IDispatch readonly dispid 1610809345;
    property Item[Index: SYSINT]: IDispatch readonly dispid 0; default;
    property Count: SYSINT dispid 1610809347;
    property _NewEnum: IUnknown readonly dispid -4;
    property Application: IDispatch readonly dispid 1610743808;
    property Creator: Integer readonly dispid 1610743809;
  end;

// *********************************************************************//
// Interface: BalloonLabel
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C0330-0000-0000-C000-000000000046}
// *********************************************************************//
  BalloonLabel = interface(_IMsoDispObj)
    ['{000C0330-0000-0000-C000-000000000046}']
    function Get_Item: WideString; safecall;
    function Get_Name: WideString; safecall;
    function Get_Parent: IDispatch; safecall;
    procedure Set_Text(const pbstr: WideString); safecall;
    function Get_Text: WideString; safecall;
    property Item: WideString read Get_Item;
    property Name: WideString read Get_Name;
    property Parent: IDispatch read Get_Parent;
    property Text: WideString read Get_Text write Set_Text;
  end;

// *********************************************************************//
// DispIntf:  BalloonLabelDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C0330-0000-0000-C000-000000000046}
// *********************************************************************//
  BalloonLabelDisp = dispinterface
    ['{000C0330-0000-0000-C000-000000000046}']
    property Item: WideString readonly dispid 0;
    property Name: WideString readonly dispid 1610809345;
    property Parent: IDispatch readonly dispid 1610809346;
    property Text: WideString dispid 1610809347;
    property Application: IDispatch readonly dispid 1610743808;
    property Creator: Integer readonly dispid 1610743809;
  end;

// *********************************************************************//
// Interface: AnswerWizardFiles
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C0361-0000-0000-C000-000000000046}
// *********************************************************************//
  AnswerWizardFiles = interface(_IMsoDispObj)
    ['{000C0361-0000-0000-C000-000000000046}']
    function Get_Parent: IDispatch; safecall;
    function Get_Item(Index: SYSINT): WideString; safecall;
    function Get_Count: SYSINT; safecall;
    procedure Add(const FileName: WideString); safecall;
    procedure Delete(const FileName: WideString); safecall;
    property Parent: IDispatch read Get_Parent;
    property Item[Index: SYSINT]: WideString read Get_Item; default;
    property Count: SYSINT read Get_Count;
  end;

// *********************************************************************//
// DispIntf:  AnswerWizardFilesDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C0361-0000-0000-C000-000000000046}
// *********************************************************************//
  AnswerWizardFilesDisp = dispinterface
    ['{000C0361-0000-0000-C000-000000000046}']
    property Parent: IDispatch readonly dispid 1610809344;
    property Item[Index: SYSINT]: WideString readonly dispid 0; default;
    property Count: SYSINT readonly dispid 1610809346;
    procedure Add(const FileName: WideString); dispid 1610809347;
    procedure Delete(const FileName: WideString); dispid 1610809348;
    property Application: IDispatch readonly dispid 1610743808;
    property Creator: Integer readonly dispid 1610743809;
  end;

// *********************************************************************//
// Interface: AnswerWizard
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C0360-0000-0000-C000-000000000046}
// *********************************************************************//
  AnswerWizard = interface(_IMsoDispObj)
    ['{000C0360-0000-0000-C000-000000000046}']
    function Get_Parent: IDispatch; safecall;
    function Get_Files: AnswerWizardFiles; safecall;
    procedure ClearFileList; safecall;
    procedure ResetFileList; safecall;
    property Parent: IDispatch read Get_Parent;
    property Files: AnswerWizardFiles read Get_Files;
  end;

// *********************************************************************//
// DispIntf:  AnswerWizardDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C0360-0000-0000-C000-000000000046}
// *********************************************************************//
  AnswerWizardDisp = dispinterface
    ['{000C0360-0000-0000-C000-000000000046}']
    property Parent: IDispatch readonly dispid 1610809344;
    property Files: AnswerWizardFiles readonly dispid 1610809345;
    procedure ClearFileList; dispid 1610809346;
    procedure ResetFileList; dispid 1610809347;
    property Application: IDispatch readonly dispid 1610743808;
    property Creator: Integer readonly dispid 1610743809;
  end;

// *********************************************************************//
// Interface: Assistant
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C0322-0000-0000-C000-000000000046}
// *********************************************************************//
  Assistant = interface(_IMsoDispObj)
    ['{000C0322-0000-0000-C000-000000000046}']
    function Get_Parent: IDispatch; safecall;
    procedure Move(xLeft: SYSINT; yTop: SYSINT); safecall;
    procedure Set_Top(pyTop: SYSINT); safecall;
    function Get_Top: SYSINT; safecall;
    procedure Set_Left(pxLeft: SYSINT); safecall;
    function Get_Left: SYSINT; safecall;
    procedure Help; safecall;
    function StartWizard(On_: WordBool; const Callback: WideString; PrivateX: Integer; 
                         Animation: OleVariant; CustomTeaser: OleVariant; Top: OleVariant; 
                         Left: OleVariant; Bottom: OleVariant; Right: OleVariant): Integer; safecall;
    procedure EndWizard(WizardID: Integer; varfSuccess: WordBool; Animation: OleVariant); safecall;
    procedure ActivateWizard(WizardID: Integer; act: MsoWizardActType; Animation: OleVariant); safecall;
    procedure ResetTips; safecall;
    function Get_NewBalloon: Balloon; safecall;
    function Get_BalloonError: MsoBalloonErrorType; safecall;
    function Get_Visible: WordBool; safecall;
    procedure Set_Visible(pvarfVisible: WordBool); safecall;
    function Get_Animation: MsoAnimationType; safecall;
    procedure Set_Animation(pfca: MsoAnimationType); safecall;
    function Get_Reduced: WordBool; safecall;
    procedure Set_Reduced(pvarfReduced: WordBool); safecall;
    procedure Set_AssistWithHelp(pvarfAssistWithHelp: WordBool); safecall;
    function Get_AssistWithHelp: WordBool; safecall;
    procedure Set_AssistWithWizards(pvarfAssistWithWizards: WordBool); safecall;
    function Get_AssistWithWizards: WordBool; safecall;
    procedure Set_AssistWithAlerts(pvarfAssistWithAlerts: WordBool); safecall;
    function Get_AssistWithAlerts: WordBool; safecall;
    procedure Set_MoveWhenInTheWay(pvarfMove: WordBool); safecall;
    function Get_MoveWhenInTheWay: WordBool; safecall;
    procedure Set_Sounds(pvarfSounds: WordBool); safecall;
    function Get_Sounds: WordBool; safecall;
    procedure Set_FeatureTips(pvarfFeatures: WordBool); safecall;
    function Get_FeatureTips: WordBool; safecall;
    procedure Set_MouseTips(pvarfMouse: WordBool); safecall;
    function Get_MouseTips: WordBool; safecall;
    procedure Set_KeyboardShortcutTips(pvarfKeyboardShortcuts: WordBool); safecall;
    function Get_KeyboardShortcutTips: WordBool; safecall;
    procedure Set_HighPriorityTips(pvarfHighPriorityTips: WordBool); safecall;
    function Get_HighPriorityTips: WordBool; safecall;
    procedure Set_TipOfDay(pvarfTipOfDay: WordBool); safecall;
    function Get_TipOfDay: WordBool; safecall;
    procedure Set_GuessHelp(pvarfGuessHelp: WordBool); safecall;
    function Get_GuessHelp: WordBool; safecall;
    procedure Set_SearchWhenProgramming(pvarfSearchInProgram: WordBool); safecall;
    function Get_SearchWhenProgramming: WordBool; safecall;
    function Get_Item: WideString; safecall;
    function Get_FileName: WideString; safecall;
    procedure Set_FileName(const pbstr: WideString); safecall;
    function Get_Name: WideString; safecall;
    function Get_On_: WordBool; safecall;
    procedure Set_On_(pvarfOn: WordBool); safecall;
    property Parent: IDispatch read Get_Parent;
    property Top: SYSINT read Get_Top write Set_Top;
    property Left: SYSINT read Get_Left write Set_Left;
    property NewBalloon: Balloon read Get_NewBalloon;
    property BalloonError: MsoBalloonErrorType read Get_BalloonError;
    property Visible: WordBool read Get_Visible write Set_Visible;
    property Animation: MsoAnimationType read Get_Animation write Set_Animation;
    property Reduced: WordBool read Get_Reduced write Set_Reduced;
    property AssistWithHelp: WordBool read Get_AssistWithHelp write Set_AssistWithHelp;
    property AssistWithWizards: WordBool read Get_AssistWithWizards write Set_AssistWithWizards;
    property AssistWithAlerts: WordBool read Get_AssistWithAlerts write Set_AssistWithAlerts;
    property MoveWhenInTheWay: WordBool read Get_MoveWhenInTheWay write Set_MoveWhenInTheWay;
    property Sounds: WordBool read Get_Sounds write Set_Sounds;
    property FeatureTips: WordBool read Get_FeatureTips write Set_FeatureTips;
    property MouseTips: WordBool read Get_MouseTips write Set_MouseTips;
    property KeyboardShortcutTips: WordBool read Get_KeyboardShortcutTips write Set_KeyboardShortcutTips;
    property HighPriorityTips: WordBool read Get_HighPriorityTips write Set_HighPriorityTips;
    property TipOfDay: WordBool read Get_TipOfDay write Set_TipOfDay;
    property GuessHelp: WordBool read Get_GuessHelp write Set_GuessHelp;
    property SearchWhenProgramming: WordBool read Get_SearchWhenProgramming write Set_SearchWhenProgramming;
    property Item: WideString read Get_Item;
    property FileName: WideString read Get_FileName write Set_FileName;
    property Name: WideString read Get_Name;
    property On_: WordBool read Get_On_ write Set_On_;
  end;

// *********************************************************************//
// DispIntf:  AssistantDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C0322-0000-0000-C000-000000000046}
// *********************************************************************//
  AssistantDisp = dispinterface
    ['{000C0322-0000-0000-C000-000000000046}']
    property Parent: IDispatch readonly dispid 1610809344;
    procedure Move(xLeft: SYSINT; yTop: SYSINT); dispid 1610809345;
    property Top: SYSINT dispid 1610809346;
    property Left: SYSINT dispid 1610809348;
    procedure Help; dispid 1610809350;
    function StartWizard(On_: WordBool; const Callback: WideString; PrivateX: Integer; 
                         Animation: OleVariant; CustomTeaser: OleVariant; Top: OleVariant; 
                         Left: OleVariant; Bottom: OleVariant; Right: OleVariant): Integer; dispid 1610809351;
    procedure EndWizard(WizardID: Integer; varfSuccess: WordBool; Animation: OleVariant); dispid 1610809352;
    procedure ActivateWizard(WizardID: Integer; act: MsoWizardActType; Animation: OleVariant); dispid 1610809353;
    procedure ResetTips; dispid 1610809354;
    property NewBalloon: Balloon readonly dispid 1610809355;
    property BalloonError: MsoBalloonErrorType readonly dispid 1610809356;
    property Visible: WordBool dispid 1610809357;
    property Animation: MsoAnimationType dispid 1610809359;
    property Reduced: WordBool dispid 1610809361;
    property AssistWithHelp: WordBool dispid 1610809363;
    property AssistWithWizards: WordBool dispid 1610809365;
    property AssistWithAlerts: WordBool dispid 1610809367;
    property MoveWhenInTheWay: WordBool dispid 1610809369;
    property Sounds: WordBool dispid 1610809371;
    property FeatureTips: WordBool dispid 1610809373;
    property MouseTips: WordBool dispid 1610809375;
    property KeyboardShortcutTips: WordBool dispid 1610809377;
    property HighPriorityTips: WordBool dispid 1610809379;
    property TipOfDay: WordBool dispid 1610809381;
    property GuessHelp: WordBool dispid 1610809383;
    property SearchWhenProgramming: WordBool dispid 1610809385;
    property Item: WideString readonly dispid 0;
    property FileName: WideString dispid 1610809388;
    property Name: WideString readonly dispid 1610809390;
    property On_: WordBool dispid 1610809391;
    property Application: IDispatch readonly dispid 1610743808;
    property Creator: Integer readonly dispid 1610743809;
  end;

// *********************************************************************//
// Interface: DocumentProperty
// Flags:     (4096) Dispatchable
// GUID:      {2DF8D04E-5BFA-101B-BDE5-00AA0044DE52}
// *********************************************************************//
  DocumentProperty = interface(IDispatch)
    ['{2DF8D04E-5BFA-101B-BDE5-00AA0044DE52}']
    function Get_Parent: IDispatch; stdcall;
    function Delete: HResult; stdcall;
    function Get_Name(lcid: Integer; out pbstrRetVal: WideString): HResult; stdcall;
    function Set_Name(lcid: Integer; const pbstrRetVal: WideString): HResult; stdcall;
    function Get_Value(lcid: Integer; out pvargRetVal: OleVariant): HResult; stdcall;
    function Set_Value(lcid: Integer; pvargRetVal: OleVariant): HResult; stdcall;
    function Get_type_(lcid: Integer; out ptypeRetVal: MsoDocProperties): HResult; stdcall;
    function Set_type_(lcid: Integer; ptypeRetVal: MsoDocProperties): HResult; stdcall;
    function Get_LinkToContent(out pfLinkRetVal: WordBool): HResult; stdcall;
    function Set_LinkToContent(pfLinkRetVal: WordBool): HResult; stdcall;
    function Get_LinkSource(out pbstrSourceRetVal: WideString): HResult; stdcall;
    function Set_LinkSource(const pbstrSourceRetVal: WideString): HResult; stdcall;
    function Get_Application(out ppidisp: IDispatch): HResult; stdcall;
    function Get_Creator(out plCreator: Integer): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: DocumentProperties
// Flags:     (4096) Dispatchable
// GUID:      {2DF8D04D-5BFA-101B-BDE5-00AA0044DE52}
// *********************************************************************//
  DocumentProperties = interface(IDispatch)
    ['{2DF8D04D-5BFA-101B-BDE5-00AA0044DE52}']
    function Get_Parent: IDispatch; stdcall;
    function Get_Item(Index: OleVariant; lcid: Integer; out ppIDocProp: DocumentProperty): HResult; stdcall;
    function Get_Count(out pc: Integer): HResult; stdcall;
    function Add(const Name: WideString; LinkToContent: WordBool; Type_: OleVariant; 
                 Value: OleVariant; LinkSource: OleVariant; lcid: Integer; 
                 out ppIDocProp: DocumentProperty): HResult; stdcall;
    function Get__NewEnum(out ppunkEnum: IUnknown): HResult; stdcall;
    function Get_Application(out ppidisp: IDispatch): HResult; stdcall;
    function Get_Creator(out plCreator: Integer): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IFoundFiles
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C0338-0000-0000-C000-000000000046}
// *********************************************************************//
  IFoundFiles = interface(IDispatch)
    ['{000C0338-0000-0000-C000-000000000046}']
    function Get_Item(Index: SYSINT): WideString; safecall;
    function Get_Count: SYSINT; safecall;
    function Get__NewEnum: IUnknown; safecall;
    property Item[Index: SYSINT]: WideString read Get_Item; default;
    property Count: SYSINT read Get_Count;
    property _NewEnum: IUnknown read Get__NewEnum;
  end;

// *********************************************************************//
// DispIntf:  IFoundFilesDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C0338-0000-0000-C000-000000000046}
// *********************************************************************//
  IFoundFilesDisp = dispinterface
    ['{000C0338-0000-0000-C000-000000000046}']
    property Item[Index: SYSINT]: WideString readonly dispid 0; default;
    property Count: SYSINT readonly dispid 1610743809;
    property _NewEnum: IUnknown readonly dispid -4;
  end;

// *********************************************************************//
// Interface: IFind
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C0337-0000-0000-C000-000000000046}
// *********************************************************************//
  IFind = interface(IDispatch)
    ['{000C0337-0000-0000-C000-000000000046}']
    function Get_SearchPath: WideString; safecall;
    function Get_Name: WideString; safecall;
    function Get_SubDir: WordBool; safecall;
    function Get_Title: WideString; safecall;
    function Get_Author: WideString; safecall;
    function Get_Keywords: WideString; safecall;
    function Get_Subject: WideString; safecall;
    function Get_Options: MsoFileFindOptions; safecall;
    function Get_MatchCase: WordBool; safecall;
    function Get_Text: WideString; safecall;
    function Get_PatternMatch: WordBool; safecall;
    function Get_DateSavedFrom: OleVariant; safecall;
    function Get_DateSavedTo: OleVariant; safecall;
    function Get_SavedBy: WideString; safecall;
    function Get_DateCreatedFrom: OleVariant; safecall;
    function Get_DateCreatedTo: OleVariant; safecall;
    function Get_View: MsoFileFindView; safecall;
    function Get_SortBy: MsoFileFindSortBy; safecall;
    function Get_ListBy: MsoFileFindListBy; safecall;
    function Get_SelectedFile: SYSINT; safecall;
    function Get_Results: IFoundFiles; safecall;
    function Show: SYSINT; safecall;
    procedure Set_SearchPath(const pbstr: WideString); safecall;
    procedure Set_Name(const pbstr: WideString); safecall;
    procedure Set_SubDir(retval: WordBool); safecall;
    procedure Set_Title(const pbstr: WideString); safecall;
    procedure Set_Author(const pbstr: WideString); safecall;
    procedure Set_Keywords(const pbstr: WideString); safecall;
    procedure Set_Subject(const pbstr: WideString); safecall;
    procedure Set_Options(penmOptions: MsoFileFindOptions); safecall;
    procedure Set_MatchCase(retval: WordBool); safecall;
    procedure Set_Text(const pbstr: WideString); safecall;
    procedure Set_PatternMatch(retval: WordBool); safecall;
    procedure Set_DateSavedFrom(pdatSavedFrom: OleVariant); safecall;
    procedure Set_DateSavedTo(pdatSavedTo: OleVariant); safecall;
    procedure Set_SavedBy(const pbstr: WideString); safecall;
    procedure Set_DateCreatedFrom(pdatCreatedFrom: OleVariant); safecall;
    procedure Set_DateCreatedTo(pdatCreatedTo: OleVariant); safecall;
    procedure Set_View(penmView: MsoFileFindView); safecall;
    procedure Set_SortBy(penmSortBy: MsoFileFindSortBy); safecall;
    procedure Set_ListBy(penmListBy: MsoFileFindListBy); safecall;
    procedure Set_SelectedFile(pintSelectedFile: SYSINT); safecall;
    procedure Execute; safecall;
    procedure Load(const bstrQueryName: WideString); safecall;
    procedure Save(const bstrQueryName: WideString); safecall;
    procedure Delete(const bstrQueryName: WideString); safecall;
    function Get_FileType: Integer; safecall;
    procedure Set_FileType(plFileType: Integer); safecall;
    property SearchPath: WideString read Get_SearchPath write Set_SearchPath;
    property Name: WideString read Get_Name write Set_Name;
    property SubDir: WordBool read Get_SubDir write Set_SubDir;
    property Title: WideString read Get_Title write Set_Title;
    property Author: WideString read Get_Author write Set_Author;
    property Keywords: WideString read Get_Keywords write Set_Keywords;
    property Subject: WideString read Get_Subject write Set_Subject;
    property Options: MsoFileFindOptions read Get_Options write Set_Options;
    property MatchCase: WordBool read Get_MatchCase write Set_MatchCase;
    property Text: WideString read Get_Text write Set_Text;
    property PatternMatch: WordBool read Get_PatternMatch write Set_PatternMatch;
    property DateSavedFrom: OleVariant read Get_DateSavedFrom write Set_DateSavedFrom;
    property DateSavedTo: OleVariant read Get_DateSavedTo write Set_DateSavedTo;
    property SavedBy: WideString read Get_SavedBy write Set_SavedBy;
    property DateCreatedFrom: OleVariant read Get_DateCreatedFrom write Set_DateCreatedFrom;
    property DateCreatedTo: OleVariant read Get_DateCreatedTo write Set_DateCreatedTo;
    property View: MsoFileFindView read Get_View write Set_View;
    property SortBy: MsoFileFindSortBy read Get_SortBy write Set_SortBy;
    property ListBy: MsoFileFindListBy read Get_ListBy write Set_ListBy;
    property SelectedFile: SYSINT read Get_SelectedFile write Set_SelectedFile;
    property Results: IFoundFiles read Get_Results;
    property FileType: Integer read Get_FileType write Set_FileType;
  end;

// *********************************************************************//
// DispIntf:  IFindDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C0337-0000-0000-C000-000000000046}
// *********************************************************************//
  IFindDisp = dispinterface
    ['{000C0337-0000-0000-C000-000000000046}']
    property SearchPath: WideString dispid 0;
    property Name: WideString dispid 1610743809;
    property SubDir: WordBool dispid 1610743810;
    property Title: WideString dispid 1610743811;
    property Author: WideString dispid 1610743812;
    property Keywords: WideString dispid 1610743813;
    property Subject: WideString dispid 1610743814;
    property Options: MsoFileFindOptions dispid 1610743815;
    property MatchCase: WordBool dispid 1610743816;
    property Text: WideString dispid 1610743817;
    property PatternMatch: WordBool dispid 1610743818;
    property DateSavedFrom: OleVariant dispid 1610743819;
    property DateSavedTo: OleVariant dispid 1610743820;
    property SavedBy: WideString dispid 1610743821;
    property DateCreatedFrom: OleVariant dispid 1610743822;
    property DateCreatedTo: OleVariant dispid 1610743823;
    property View: MsoFileFindView dispid 1610743824;
    property SortBy: MsoFileFindSortBy dispid 1610743825;
    property ListBy: MsoFileFindListBy dispid 1610743826;
    property SelectedFile: SYSINT dispid 1610743827;
    property Results: IFoundFiles readonly dispid 1610743828;
    function Show: SYSINT; dispid 1610743829;
    procedure Execute; dispid 1610743850;
    procedure Load(const bstrQueryName: WideString); dispid 1610743851;
    procedure Save(const bstrQueryName: WideString); dispid 1610743852;
    procedure Delete(const bstrQueryName: WideString); dispid 1610743853;
    property FileType: Integer dispid 1610743854;
  end;

// *********************************************************************//
// Interface: FoundFiles
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {000C0331-0000-0000-C000-000000000046}
// *********************************************************************//
  FoundFiles = interface(_IMsoDispObj)
    ['{000C0331-0000-0000-C000-000000000046}']
    function Get_Item(Index: SYSINT; lcid: Integer): WideString; safecall;
    function Get_Count: Integer; safecall;
    function Get__NewEnum: IUnknown; safecall;
    property Item[Index: SYSINT; lcid: Integer]: WideString read Get_Item;
    property Count: Integer read Get_Count;
    property _NewEnum: IUnknown read Get__NewEnum;
  end;

// *********************************************************************//
// DispIntf:  FoundFilesDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {000C0331-0000-0000-C000-000000000046}
// *********************************************************************//
  FoundFilesDisp = dispinterface
    ['{000C0331-0000-0000-C000-000000000046}']
    property Item[Index: SYSINT; lcid: Integer]: WideString readonly dispid 0;
    property Count: Integer readonly dispid 4;
    property _NewEnum: IUnknown readonly dispid -4;
    property Application: IDispatch readonly dispid 1610743808;
    property Creator: Integer readonly dispid 1610743809;
  end;

// *********************************************************************//
// Interface: PropertyTest
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C0333-0000-0000-C000-000000000046}
// *********************************************************************//
  PropertyTest = interface(_IMsoDispObj)
    ['{000C0333-0000-0000-C000-000000000046}']
    function Get_Name: WideString; safecall;
    function Get_Condition: MsoCondition; safecall;
    function Get_Value: OleVariant; safecall;
    function Get_SecondValue: OleVariant; safecall;
    function Get_Connector: MsoConnector; safecall;
    property Name: WideString read Get_Name;
    property Condition: MsoCondition read Get_Condition;
    property Value: OleVariant read Get_Value;
    property SecondValue: OleVariant read Get_SecondValue;
    property Connector: MsoConnector read Get_Connector;
  end;

// *********************************************************************//
// DispIntf:  PropertyTestDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C0333-0000-0000-C000-000000000046}
// *********************************************************************//
  PropertyTestDisp = dispinterface
    ['{000C0333-0000-0000-C000-000000000046}']
    property Name: WideString readonly dispid 0;
    property Condition: MsoCondition readonly dispid 2;
    property Value: OleVariant readonly dispid 3;
    property SecondValue: OleVariant readonly dispid 4;
    property Connector: MsoConnector readonly dispid 5;
    property Application: IDispatch readonly dispid 1610743808;
    property Creator: Integer readonly dispid 1610743809;
  end;

// *********************************************************************//
// Interface: PropertyTests
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {000C0334-0000-0000-C000-000000000046}
// *********************************************************************//
  PropertyTests = interface(_IMsoDispObj)
    ['{000C0334-0000-0000-C000-000000000046}']
    function Get_Item(Index: SYSINT; lcid: Integer): PropertyTest; safecall;
    function Get_Count: Integer; safecall;
    procedure Add(const Name: WideString; Condition: MsoCondition; Value: OleVariant; 
                  SecondValue: OleVariant; Connector: MsoConnector); safecall;
    procedure Remove(Index: SYSINT); safecall;
    function Get__NewEnum: IUnknown; safecall;
    property Item[Index: SYSINT; lcid: Integer]: PropertyTest read Get_Item;
    property Count: Integer read Get_Count;
    property _NewEnum: IUnknown read Get__NewEnum;
  end;

// *********************************************************************//
// DispIntf:  PropertyTestsDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {000C0334-0000-0000-C000-000000000046}
// *********************************************************************//
  PropertyTestsDisp = dispinterface
    ['{000C0334-0000-0000-C000-000000000046}']
    property Item[Index: SYSINT; lcid: Integer]: PropertyTest readonly dispid 0;
    property Count: Integer readonly dispid 4;
    procedure Add(const Name: WideString; Condition: MsoCondition; Value: OleVariant; 
                  SecondValue: OleVariant; Connector: MsoConnector); dispid 5;
    procedure Remove(Index: SYSINT); dispid 6;
    property _NewEnum: IUnknown readonly dispid -4;
    property Application: IDispatch readonly dispid 1610743808;
    property Creator: Integer readonly dispid 1610743809;
  end;

// *********************************************************************//
// Interface: FileSearch
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {000C0332-0000-0000-C000-000000000046}
// *********************************************************************//
  FileSearch = interface(_IMsoDispObj)
    ['{000C0332-0000-0000-C000-000000000046}']
    function Get_SearchSubFolders: WordBool; safecall;
    procedure Set_SearchSubFolders(SearchSubFoldersRetVal: WordBool); safecall;
    function Get_MatchTextExactly: WordBool; safecall;
    procedure Set_MatchTextExactly(MatchTextRetVal: WordBool); safecall;
    function Get_MatchAllWordForms: WordBool; safecall;
    procedure Set_MatchAllWordForms(MatchAllWordFormsRetVal: WordBool); safecall;
    function Get_FileName: WideString; safecall;
    procedure Set_FileName(const FileNameRetVal: WideString); safecall;
    function Get_FileType: MsoFileType; safecall;
    procedure Set_FileType(FileTypeRetVal: MsoFileType); safecall;
    function Get_LastModified: MsoLastModified; safecall;
    procedure Set_LastModified(LastModifiedRetVal: MsoLastModified); safecall;
    function Get_TextOrProperty: WideString; safecall;
    procedure Set_TextOrProperty(const TextOrProperty: WideString); safecall;
    function Get_LookIn: WideString; safecall;
    procedure Set_LookIn(const LookInRetVal: WideString); safecall;
    function Execute(SortBy: MsoSortBy; SortOrder: MsoSortOrder; AlwaysAccurate: WordBool): SYSINT; safecall;
    procedure NewSearch; safecall;
    function Get_FoundFiles: FoundFiles; safecall;
    function Get_PropertyTests: PropertyTests; safecall;
    property SearchSubFolders: WordBool read Get_SearchSubFolders write Set_SearchSubFolders;
    property MatchTextExactly: WordBool read Get_MatchTextExactly write Set_MatchTextExactly;
    property MatchAllWordForms: WordBool read Get_MatchAllWordForms write Set_MatchAllWordForms;
    property FileName: WideString read Get_FileName write Set_FileName;
    property FileType: MsoFileType read Get_FileType write Set_FileType;
    property LastModified: MsoLastModified read Get_LastModified write Set_LastModified;
    property TextOrProperty: WideString read Get_TextOrProperty write Set_TextOrProperty;
    property LookIn: WideString read Get_LookIn write Set_LookIn;
    property FoundFiles: FoundFiles read Get_FoundFiles;
    property PropertyTests: PropertyTests read Get_PropertyTests;
  end;

// *********************************************************************//
// DispIntf:  FileSearchDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {000C0332-0000-0000-C000-000000000046}
// *********************************************************************//
  FileSearchDisp = dispinterface
    ['{000C0332-0000-0000-C000-000000000046}']
    property SearchSubFolders: WordBool dispid 1;
    property MatchTextExactly: WordBool dispid 2;
    property MatchAllWordForms: WordBool dispid 3;
    property FileName: WideString dispid 4;
    property FileType: MsoFileType dispid 5;
    property LastModified: MsoLastModified dispid 6;
    property TextOrProperty: WideString dispid 7;
    property LookIn: WideString dispid 8;
    function Execute(SortBy: MsoSortBy; SortOrder: MsoSortOrder; AlwaysAccurate: WordBool): SYSINT; dispid 9;
    procedure NewSearch; dispid 10;
    property FoundFiles: FoundFiles readonly dispid 11;
    property PropertyTests: PropertyTests readonly dispid 12;
    property Application: IDispatch readonly dispid 1610743808;
    property Creator: Integer readonly dispid 1610743809;
  end;

// *********************************************************************//
// Interface: COMAddIn
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C033A-0000-0000-C000-000000000046}
// *********************************************************************//
  COMAddIn = interface(_IMsoDispObj)
    ['{000C033A-0000-0000-C000-000000000046}']
    function Get_Description: WideString; safecall;
    procedure Set_Description(const RetValue: WideString); safecall;
    function Get_ProgId: WideString; safecall;
    function Get_Guid: WideString; safecall;
    function Get_Connect: WordBool; safecall;
    procedure Set_Connect(RetValue: WordBool); safecall;
    function Get_Object_: IDispatch; safecall;
    procedure Set_Object_(const RetValue: IDispatch); safecall;
    function Get_Parent: IDispatch; safecall;
    property Description: WideString read Get_Description write Set_Description;
    property ProgId: WideString read Get_ProgId;
    property Guid: WideString read Get_Guid;
    property Connect: WordBool read Get_Connect write Set_Connect;
    property Object_: IDispatch read Get_Object_ write Set_Object_;
    property Parent: IDispatch read Get_Parent;
  end;

// *********************************************************************//
// DispIntf:  COMAddInDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C033A-0000-0000-C000-000000000046}
// *********************************************************************//
  COMAddInDisp = dispinterface
    ['{000C033A-0000-0000-C000-000000000046}']
    property Description: WideString dispid 0;
    property ProgId: WideString readonly dispid 3;
    property Guid: WideString readonly dispid 4;
    property Connect: WordBool dispid 6;
    property Object_: IDispatch dispid 7;
    property Parent: IDispatch readonly dispid 8;
    property Application: IDispatch readonly dispid 1610743808;
    property Creator: Integer readonly dispid 1610743809;
  end;

// *********************************************************************//
// Interface: COMAddIns
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C0339-0000-0000-C000-000000000046}
// *********************************************************************//
  COMAddIns = interface(_IMsoDispObj)
    ['{000C0339-0000-0000-C000-000000000046}']
    function Item(var Index: OleVariant): COMAddIn; safecall;
    function Get_Count: Integer; safecall;
    function Get__NewEnum: IUnknown; safecall;
    procedure Update; safecall;
    function Get_Parent: IDispatch; safecall;
    procedure SetAppModal(varfModal: WordBool); safecall;
    property Count: Integer read Get_Count;
    property _NewEnum: IUnknown read Get__NewEnum;
    property Parent: IDispatch read Get_Parent;
  end;

// *********************************************************************//
// DispIntf:  COMAddInsDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C0339-0000-0000-C000-000000000046}
// *********************************************************************//
  COMAddInsDisp = dispinterface
    ['{000C0339-0000-0000-C000-000000000046}']
    function Item(var Index: OleVariant): COMAddIn; dispid 0;
    property Count: Integer readonly dispid 1;
    property _NewEnum: IUnknown readonly dispid -4;
    procedure Update; dispid 2;
    property Parent: IDispatch readonly dispid 3;
    procedure SetAppModal(varfModal: WordBool); dispid 4;
    property Application: IDispatch readonly dispid 1610743808;
    property Creator: Integer readonly dispid 1610743809;
  end;

// *********************************************************************//
// Interface: LanguageSettings
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C0353-0000-0000-C000-000000000046}
// *********************************************************************//
  LanguageSettings = interface(_IMsoDispObj)
    ['{000C0353-0000-0000-C000-000000000046}']
    function Get_LanguageID(Id: MsoAppLanguageID): SYSINT; safecall;
    function Get_LanguagePreferredForEditing(lid: MsoLanguageID): WordBool; safecall;
    property LanguageID[Id: MsoAppLanguageID]: SYSINT read Get_LanguageID;
    property LanguagePreferredForEditing[lid: MsoLanguageID]: WordBool read Get_LanguagePreferredForEditing;
  end;

// *********************************************************************//
// DispIntf:  LanguageSettingsDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C0353-0000-0000-C000-000000000046}
// *********************************************************************//
  LanguageSettingsDisp = dispinterface
    ['{000C0353-0000-0000-C000-000000000046}']
    property LanguageID[Id: MsoAppLanguageID]: SYSINT readonly dispid 1;
    property LanguagePreferredForEditing[lid: MsoLanguageID]: WordBool readonly dispid 2;
    property Application: IDispatch readonly dispid 1610743808;
    property Creator: Integer readonly dispid 1610743809;
  end;

// *********************************************************************//
// Interface: ICommandBarsEvents
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {55F88892-7708-11D1-ACEB-006008961DA5}
// *********************************************************************//
  ICommandBarsEvents = interface(IDispatch)
    ['{55F88892-7708-11D1-ACEB-006008961DA5}']
    procedure OnUpdate; stdcall;
  end;

// *********************************************************************//
// DispIntf:  ICommandBarsEventsDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {55F88892-7708-11D1-ACEB-006008961DA5}
// *********************************************************************//
  ICommandBarsEventsDisp = dispinterface
    ['{55F88892-7708-11D1-ACEB-006008961DA5}']
    procedure OnUpdate; dispid 1;
  end;

// *********************************************************************//
// DispIntf:  _CommandBarsEvents
// Flags:     (4112) Hidden Dispatchable
// GUID:      {000C0352-0000-0000-C000-000000000046}
// *********************************************************************//
  _CommandBarsEvents = dispinterface
    ['{000C0352-0000-0000-C000-000000000046}']
    procedure OnUpdate; dispid 1;
  end;

// *********************************************************************//
// Interface: ICommandBarComboBoxEvents
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {55F88896-7708-11D1-ACEB-006008961DA5}
// *********************************************************************//
  ICommandBarComboBoxEvents = interface(IDispatch)
    ['{55F88896-7708-11D1-ACEB-006008961DA5}']
    procedure Change(const Ctrl: CommandBarComboBox); stdcall;
  end;

// *********************************************************************//
// DispIntf:  ICommandBarComboBoxEventsDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {55F88896-7708-11D1-ACEB-006008961DA5}
// *********************************************************************//
  ICommandBarComboBoxEventsDisp = dispinterface
    ['{55F88896-7708-11D1-ACEB-006008961DA5}']
    procedure Change(const Ctrl: CommandBarComboBox); dispid 1;
  end;

// *********************************************************************//
// DispIntf:  _CommandBarComboBoxEvents
// Flags:     (4112) Hidden Dispatchable
// GUID:      {000C0354-0000-0000-C000-000000000046}
// *********************************************************************//
  _CommandBarComboBoxEvents = dispinterface
    ['{000C0354-0000-0000-C000-000000000046}']
    procedure Change(const Ctrl: CommandBarComboBox); dispid 1;
  end;

// *********************************************************************//
// Interface: ICommandBarButtonEvents
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {55F88890-7708-11D1-ACEB-006008961DA5}
// *********************************************************************//
  ICommandBarButtonEvents = interface(IDispatch)
    ['{55F88890-7708-11D1-ACEB-006008961DA5}']
    procedure Click(const Ctrl: CommandBarButton; var CancelDefault: WordBool); stdcall;
  end;

// *********************************************************************//
// DispIntf:  ICommandBarButtonEventsDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {55F88890-7708-11D1-ACEB-006008961DA5}
// *********************************************************************//
  ICommandBarButtonEventsDisp = dispinterface
    ['{55F88890-7708-11D1-ACEB-006008961DA5}']
    procedure Click(const Ctrl: CommandBarButton; var CancelDefault: WordBool); dispid 1;
  end;

// *********************************************************************//
// DispIntf:  _CommandBarButtonEvents
// Flags:     (4112) Hidden Dispatchable
// GUID:      {000C0351-0000-0000-C000-000000000046}
// *********************************************************************//
  _CommandBarButtonEvents = dispinterface
    ['{000C0351-0000-0000-C000-000000000046}']
    procedure Click(const Ctrl: CommandBarButton; var CancelDefault: WordBool); dispid 1;
  end;

// *********************************************************************//
// Interface: WebPageFont
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C0913-0000-0000-C000-000000000046}
// *********************************************************************//
  WebPageFont = interface(_IMsoDispObj)
    ['{000C0913-0000-0000-C000-000000000046}']
    function Get_ProportionalFont: WideString; safecall;
    procedure Set_ProportionalFont(const pstr: WideString); safecall;
    function Get_ProportionalFontSize: Single; safecall;
    procedure Set_ProportionalFontSize(pf: Single); safecall;
    function Get_FixedWidthFont: WideString; safecall;
    procedure Set_FixedWidthFont(const pstr: WideString); safecall;
    function Get_FixedWidthFontSize: Single; safecall;
    procedure Set_FixedWidthFontSize(pf: Single); safecall;
    property ProportionalFont: WideString read Get_ProportionalFont write Set_ProportionalFont;
    property ProportionalFontSize: Single read Get_ProportionalFontSize write Set_ProportionalFontSize;
    property FixedWidthFont: WideString read Get_FixedWidthFont write Set_FixedWidthFont;
    property FixedWidthFontSize: Single read Get_FixedWidthFontSize write Set_FixedWidthFontSize;
  end;

// *********************************************************************//
// DispIntf:  WebPageFontDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C0913-0000-0000-C000-000000000046}
// *********************************************************************//
  WebPageFontDisp = dispinterface
    ['{000C0913-0000-0000-C000-000000000046}']
    property ProportionalFont: WideString dispid 10;
    property ProportionalFontSize: Single dispid 11;
    property FixedWidthFont: WideString dispid 12;
    property FixedWidthFontSize: Single dispid 13;
    property Application: IDispatch readonly dispid 1610743808;
    property Creator: Integer readonly dispid 1610743809;
  end;

// *********************************************************************//
// Interface: WebPageFonts
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C0914-0000-0000-C000-000000000046}
// *********************************************************************//
  WebPageFonts = interface(_IMsoDispObj)
    ['{000C0914-0000-0000-C000-000000000046}']
    function Get_Count: SYSINT; safecall;
    function Get_Item(Index: MsoCharacterSet): WebPageFont; safecall;
    function Get__NewEnum: IUnknown; safecall;
    property Count: SYSINT read Get_Count;
    property Item[Index: MsoCharacterSet]: WebPageFont read Get_Item; default;
    property _NewEnum: IUnknown read Get__NewEnum;
  end;

// *********************************************************************//
// DispIntf:  WebPageFontsDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C0914-0000-0000-C000-000000000046}
// *********************************************************************//
  WebPageFontsDisp = dispinterface
    ['{000C0914-0000-0000-C000-000000000046}']
    property Count: SYSINT readonly dispid 1;
    property Item[Index: MsoCharacterSet]: WebPageFont readonly dispid 0; default;
    property _NewEnum: IUnknown readonly dispid -4;
    property Application: IDispatch readonly dispid 1610743808;
    property Creator: Integer readonly dispid 1610743809;
  end;

// *********************************************************************//
// Interface: HTMLProjectItem
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C0358-0000-0000-C000-000000000046}
// *********************************************************************//
  HTMLProjectItem = interface(_IMsoDispObj)
    ['{000C0358-0000-0000-C000-000000000046}']
    function Get_Name: WideString; safecall;
    function Get_IsOpen: WordBool; safecall;
    procedure LoadFromFile(const FileName: WideString); safecall;
    procedure Open(OpenKind: MsoHTMLProjectOpen); safecall;
    procedure SaveCopyAs(const FileName: WideString); safecall;
    function Get_Text: WideString; safecall;
    procedure Set_Text(const Text: WideString); safecall;
    function Get_Parent: IDispatch; safecall;
    property Name: WideString read Get_Name;
    property IsOpen: WordBool read Get_IsOpen;
    property Text: WideString read Get_Text write Set_Text;
    property Parent: IDispatch read Get_Parent;
  end;

// *********************************************************************//
// DispIntf:  HTMLProjectItemDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C0358-0000-0000-C000-000000000046}
// *********************************************************************//
  HTMLProjectItemDisp = dispinterface
    ['{000C0358-0000-0000-C000-000000000046}']
    property Name: WideString readonly dispid 0;
    property IsOpen: WordBool readonly dispid 4;
    procedure LoadFromFile(const FileName: WideString); dispid 5;
    procedure Open(OpenKind: MsoHTMLProjectOpen); dispid 6;
    procedure SaveCopyAs(const FileName: WideString); dispid 7;
    property Text: WideString dispid 8;
    property Parent: IDispatch readonly dispid 10;
    property Application: IDispatch readonly dispid 1610743808;
    property Creator: Integer readonly dispid 1610743809;
  end;

// *********************************************************************//
// Interface: HTMLProjectItems
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C0357-0000-0000-C000-000000000046}
// *********************************************************************//
  HTMLProjectItems = interface(_IMsoDispObj)
    ['{000C0357-0000-0000-C000-000000000046}']
    function Item(var Index: OleVariant): HTMLProjectItem; safecall;
    function Get_Count: Integer; safecall;
    function Get__NewEnum: IUnknown; safecall;
    function Get_Parent: IDispatch; safecall;
    property Count: Integer read Get_Count;
    property _NewEnum: IUnknown read Get__NewEnum;
    property Parent: IDispatch read Get_Parent;
  end;

// *********************************************************************//
// DispIntf:  HTMLProjectItemsDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C0357-0000-0000-C000-000000000046}
// *********************************************************************//
  HTMLProjectItemsDisp = dispinterface
    ['{000C0357-0000-0000-C000-000000000046}']
    function Item(var Index: OleVariant): HTMLProjectItem; dispid 0;
    property Count: Integer readonly dispid 1;
    property _NewEnum: IUnknown readonly dispid -4;
    property Parent: IDispatch readonly dispid 2;
    property Application: IDispatch readonly dispid 1610743808;
    property Creator: Integer readonly dispid 1610743809;
  end;

// *********************************************************************//
// Interface: HTMLProject
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C0356-0000-0000-C000-000000000046}
// *********************************************************************//
  HTMLProject = interface(_IMsoDispObj)
    ['{000C0356-0000-0000-C000-000000000046}']
    function Get_State: MsoHTMLProjectState; safecall;
    procedure RefreshProject(Refresh: WordBool); safecall;
    procedure RefreshDocument(Refresh: WordBool); safecall;
    function Get_HTMLProjectItems: HTMLProjectItems; safecall;
    function Get_Parent: IDispatch; safecall;
    procedure Open(OpenKind: MsoHTMLProjectOpen); safecall;
    property State: MsoHTMLProjectState read Get_State;
    property HTMLProjectItems: HTMLProjectItems read Get_HTMLProjectItems;
    property Parent: IDispatch read Get_Parent;
  end;

// *********************************************************************//
// DispIntf:  HTMLProjectDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C0356-0000-0000-C000-000000000046}
// *********************************************************************//
  HTMLProjectDisp = dispinterface
    ['{000C0356-0000-0000-C000-000000000046}']
    property State: MsoHTMLProjectState readonly dispid 0;
    procedure RefreshProject(Refresh: WordBool); dispid 1;
    procedure RefreshDocument(Refresh: WordBool); dispid 2;
    property HTMLProjectItems: HTMLProjectItems readonly dispid 3;
    property Parent: IDispatch readonly dispid 4;
    procedure Open(OpenKind: MsoHTMLProjectOpen); dispid 5;
    property Application: IDispatch readonly dispid 1610743808;
    property Creator: Integer readonly dispid 1610743809;
  end;

// *********************************************************************//
// Interface: MsoDebugOptions
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C035A-0000-0000-C000-000000000046}
// *********************************************************************//
  MsoDebugOptions = interface(_IMsoDispObj)
    ['{000C035A-0000-0000-C000-000000000046}']
    function Get_FeatureReports: SYSINT; safecall;
    procedure Set_FeatureReports(puintFeatureReports: SYSINT); safecall;
    property FeatureReports: SYSINT read Get_FeatureReports write Set_FeatureReports;
  end;

// *********************************************************************//
// DispIntf:  MsoDebugOptionsDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {000C035A-0000-0000-C000-000000000046}
// *********************************************************************//
  MsoDebugOptionsDisp = dispinterface
    ['{000C035A-0000-0000-C000-000000000046}']
    property FeatureReports: SYSINT dispid 4;
    property Application: IDispatch readonly dispid 1610743808;
    property Creator: Integer readonly dispid 1610743809;
  end;

// *********************************************************************//
// The Class CoCommandBars provides a Create and CreateRemote method to          
// create instances of the default interface _CommandBars exposed by              
// the CoClass CommandBars. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoCommandBars = class
    class function Create: _CommandBars;
    class function CreateRemote(const MachineName: string): _CommandBars;
  end;

// *********************************************************************//
// The Class CoCommandBarComboBox provides a Create and CreateRemote method to          
// create instances of the default interface _CommandBarComboBox exposed by              
// the CoClass CommandBarComboBox. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoCommandBarComboBox = class
    class function Create: _CommandBarComboBox;
    class function CreateRemote(const MachineName: string): _CommandBarComboBox;
  end;

// *********************************************************************//
// The Class CoCommandBarButton provides a Create and CreateRemote method to          
// create instances of the default interface _CommandBarButton exposed by              
// the CoClass CommandBarButton. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoCommandBarButton = class
    class function Create: _CommandBarButton;
    class function CreateRemote(const MachineName: string): _CommandBarButton;
  end;

implementation

uses ComObj;

class function CoCommandBars.Create: _CommandBars;
begin
  Result := CreateComObject(CLASS_CommandBars) as _CommandBars;
end;

class function CoCommandBars.CreateRemote(const MachineName: string): _CommandBars;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_CommandBars) as _CommandBars;
end;

class function CoCommandBarComboBox.Create: _CommandBarComboBox;
begin
  Result := CreateComObject(CLASS_CommandBarComboBox) as _CommandBarComboBox;
end;

class function CoCommandBarComboBox.CreateRemote(const MachineName: string): _CommandBarComboBox;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_CommandBarComboBox) as _CommandBarComboBox;
end;

class function CoCommandBarButton.Create: _CommandBarButton;
begin
  Result := CreateComObject(CLASS_CommandBarButton) as _CommandBarButton;
end;

class function CoCommandBarButton.CreateRemote(const MachineName: string): _CommandBarButton;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_CommandBarButton) as _CommandBarButton;
end;

end.
