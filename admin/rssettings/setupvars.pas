unit SetupVars;

interface

uses
  Windows, ShellApi, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  ExtCtrls, ComCtrls, StdCtrls, CheckLst, StrUtils, Dialogs, global,
  Buttons;

type
  TSetupVarsForm = class(TForm)
    TreeView: TTreeView;
    PanelFace1: TPanel;
    PageControl: TPageControl;
    TabSheet26: TTabSheet;
    TabSheet3: TTabSheet;
    Panel4: TPanel;
    TabSheet4: TTabSheet;
    Panel5: TPanel;
    TabSheet21: TTabSheet;
    Panel25: TPanel;
    Label105: TLabel;
    Label106: TLabel;
    Label107: TLabel;
    ListView12: TListView;
    Edit30: TEdit;
    Edit31: TEdit;
    Button17: TButton;
    TabSheet10: TTabSheet;
    Panel11: TPanel;
    TabSheet22: TTabSheet;
    Panel26: TPanel;
    GroupBox8: TGroupBox;
    Label101: TLabel;
    Label7: TLabel;
    CheckBox23: TCheckBox;
    ComboBox8: TComboBox;
    CheckBox85: TCheckBox;
    Edit32: TEdit;
    GroupBox9: TGroupBox;
    Label52: TLabel;
    Label55: TLabel;
    Label56: TLabel;
    CheckBox24: TCheckBox;
    CheckBox28: TCheckBox;
    TabSheet37: TTabSheet;
    Panel39: TPanel;
    Label174: TLabel;
    Label175: TLabel;
    Label176: TLabel;
    Label177: TLabel;
    ListView15: TListView;
    Edit72: TEdit;
    Edit73: TEdit;
    TabSheet35: TTabSheet;
    Panel37: TPanel;
    GroupBox32: TGroupBox;
    Label146: TLabel;
    Label147: TLabel;
    Button24: TButton;
    Button25: TButton;
    Button26: TButton;
    GroupBox33: TGroupBox;
    CheckBox145: TCheckBox;
    CheckBox96: TCheckBox;
    TabSheet29: TTabSheet;
    Panel31: TPanel;
    CheckBox86: TCheckBox;
    GroupBox20: TGroupBox;
    Label109: TLabel;
    CheckBox89: TCheckBox;
    CheckBox90: TCheckBox;
    CheckBox91: TCheckBox;
    CheckBox92: TCheckBox;
    GroupBox36: TGroupBox;
    Label160: TLabel;
    Label161: TLabel;
    RadioButton6: TRadioButton;
    RadioButton7: TRadioButton;
    RadioButton8: TRadioButton;
    RadioButton13: TRadioButton;
    TabSheet36: TTabSheet;
    Panel38: TPanel;
    CheckBox153: TCheckBox;
    TabSheet27: TTabSheet;
    TabSheet5: TTabSheet;
    Panel6: TPanel;
    Label19: TLabel;
    CheckListBox1: TCheckListBox;
    TabSheet13: TTabSheet;
    Panel20: TPanel;
    Label61: TLabel;
    Label32: TLabel;
    Edit10: TEdit;
    CheckBox34: TCheckBox;
    CheckBox123: TCheckBox;
    CheckBox128: TCheckBox;
    Edit59: TEdit;
    TabSheet6: TTabSheet;
    Panel7: TPanel;
    Label20: TLabel;
    Label22: TLabel;
    GroupBox4: TGroupBox;
    CheckListBox2: TCheckListBox;
    Button5: TButton;
    Button6: TButton;
    GroupBox5: TGroupBox;
    CheckListBox3: TCheckListBox;
    Button7: TButton;
    Button8: TButton;
    TabSheet7: TTabSheet;
    Panel8: TPanel;
    Label23: TLabel;
    Label30: TLabel;
    Label50: TLabel;
    Label53: TLabel;
    Label54: TLabel;
    ListView1: TListView;
    Edit6: TEdit;
    ListView7: TListView;
    Edit11: TEdit;
    TabSheet9: TTabSheet;
    Panel10: TPanel;
    Label31: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    ListView3: TListView;
    Edit7: TEdit;
    Edit8: TEdit;
    Button11: TButton;
    CheckBox98: TCheckBox;
    TabSheet8: TTabSheet;
    Panel9: TPanel;
    Label25: TLabel;
    Label27: TLabel;
    Label17: TLabel;
    Label88: TLabel;
    ListView2: TListView;
    Edit4: TEdit;
    ListView9: TListView;
    Edit22: TEdit;
    CheckBox14: TCheckBox;
    TabSheet19: TTabSheet;
    Panel18: TPanel;
    TabSheet31: TTabSheet;
    TabSheet16: TTabSheet;
    Panel15: TPanel;
    Label62: TLabel;
    Label73: TLabel;
    Label74: TLabel;
    Label86: TLabel;
    ListView8: TListView;
    Edit19: TEdit;
    Edit20: TEdit;
    CheckBox58: TCheckBox;
    Button14: TButton;
    TabSheet15: TTabSheet;
    Panel22: TPanel;
    Label68: TLabel;
    Label69: TLabel;
    Label70: TLabel;
    Label71: TLabel;
    Label77: TLabel;
    Label78: TLabel;
    Label82: TLabel;
    Label83: TLabel;
    ListView5: TListView;
    Edit14: TEdit;
    Edit15: TEdit;
    ListView6: TListView;
    Edit17: TEdit;
    Edit18: TEdit;
    Button15: TButton;
    Button16: TButton;
    TabSheet18: TTabSheet;
    TabSheet25: TTabSheet;
    Panel914: TPanel;
    Label123: TLabel;
    ListView13: TListView;
    Edit93: TEdit;
    RadioButton913: TRadioButton;
    RadioButton914: TRadioButton;
    ListView14: TListView;
    TabSheet30: TTabSheet;
    Panel32: TPanel;
    Label135: TLabel;
    Label94: TLabel;
    Label95: TLabel;
    Label97: TLabel;
    Label166: TLabel;
    Label190: TLabel;
    Label191: TLabel;
    Label195: TLabel;
    ComboBox11: TComboBox;
    Edit25: TEdit;
    CheckBox112: TCheckBox;
    CheckBox99: TCheckBox;
    CheckBox66: TCheckBox;
    Edit27: TEdit;
    Edit65: TEdit;
    CheckBox150: TCheckBox;
    Edit83: TEdit;
    Edit86: TEdit;
    TabSheet14: TTabSheet;
    TabSheet17: TTabSheet;
    Panel17: TPanel;
    Label92: TLabel;
    Label93: TLabel;
    ListView10: TListView;
    Edit24: TEdit;
    CheckBox54: TCheckBox;
    CheckBox55: TCheckBox;
    Button12: TButton;
    CheckBox94: TCheckBox;
    CheckBox146: TCheckBox;
    TabSheet20: TTabSheet;
    Panel24: TPanel;
    Label102: TLabel;
    Label103: TLabel;
    Label104: TLabel;
    CheckBox79: TCheckBox;
    ListView11: TListView;
    Edit28: TEdit;
    Edit29: TEdit;
    Button13: TButton;
    TabSheet32: TTabSheet;
    Panel34: TPanel;
    Label116: TLabel;
    CheckBox116: TCheckBox;
    Edit39: TEdit;
    CheckBox117: TCheckBox;
    Edit40: TEdit;
    CheckBox118: TCheckBox;
    Edit41: TEdit;
    CheckBox53: TCheckBox;
    Edit48: TEdit;
    TabSheet34: TTabSheet;
    TabSheet12: TTabSheet;
    Panel19: TPanel;
    Label57: TLabel;
    Label58: TLabel;
    ListView4: TListView;
    Edit9: TEdit;
    CheckBox114: TCheckBox;
    TabSheet24: TTabSheet;
    Panel28: TPanel;
    Label118: TLabel;
    Label133: TLabel;
    Label110: TLabel;
    CheckBox119: TCheckBox;
    Edit42: TEdit;
    Edit47: TEdit;
    CheckBox93: TCheckBox;
    Edit52: TEdit;
    Button22: TButton;
    CheckBox139: TCheckBox;
    TabSheet28: TTabSheet;
    Panel30: TPanel;
    GroupBox21: TGroupBox;
    CheckBox131: TCheckBox;
    CheckBox115: TCheckBox;
    CheckBox122: TCheckBox;
    GroupBox24: TGroupBox;
    Label141: TLabel;
    CheckBox132: TCheckBox;
    Edit58: TEdit;
    GroupBox27: TGroupBox;
    CheckBox134: TCheckBox;
    CheckBox138: TCheckBox;
    TabSheet33: TTabSheet;
    Panel35: TPanel;
    GroupBox23: TGroupBox;
    Label138: TLabel;
    Label139: TLabel;
    Label140: TLabel;
    Label148: TLabel;
    CheckBox130: TCheckBox;
    Edit55: TEdit;
    Edit56: TEdit;
    Edit57: TEdit;
    Edit61: TEdit;
    Button27: TButton;
    GroupBox25: TGroupBox;
    CheckBox135: TCheckBox;
    GroupBox28: TGroupBox;
    CheckBox133: TCheckBox;
    Panel40: TPanel;
    Panel41: TPanel;
    ButtonCancel: TButton;
    ButtonOK: TButton;
    Panel42: TPanel;
    Bevel2: TBevel;
    TabSheet38: TTabSheet;
    Panel43: TPanel;
    ListView16: TListView;
    Label136: TLabel;
    Edit50: TEdit;
    Label137: TLabel;
    Edit51: TEdit;
    Button21: TButton;
    Label192: TLabel;
    Label196: TLabel;
    Edit84: TEdit;
    Label197: TLabel;
    Edit87: TEdit;
    Label198: TLabel;
    Edit88: TEdit;
    Label199: TLabel;
    CheckBox165: TCheckBox;
    ColorDialog1: TColorDialog;
    GroupBox12: TGroupBox;
    CheckBox67: TCheckBox;
    CheckBox68: TCheckBox;
    CheckBox69: TCheckBox;
    CheckBox70: TCheckBox;
    CheckBox71: TCheckBox;
    CheckBox72: TCheckBox;
    CheckBox73: TCheckBox;
    CheckBox10: TCheckBox;
    GroupBox1: TGroupBox;
    CheckBox11: TCheckBox;
    CheckBox12: TCheckBox;
    CheckBox13: TCheckBox;
    CheckBox41: TCheckBox;
    CheckBox43: TCheckBox;
    CheckBox62: TCheckBox;
    CheckBox164: TCheckBox;
    CheckBox83: TCheckBox;
    CheckBox125: TCheckBox;
    CheckBox18: TCheckBox;
    Label14: TLabel;
    CheckBox80: TCheckBox;
    CheckBox61: TCheckBox;
    GroupBox3: TGroupBox;
    Label121: TLabel;
    ComboBox10: TComboBox;
    Label2: TLabel;
    Panel2: TPanel;
    Label5: TLabel;
    Edit43: TEdit;
    Label119: TLabel;
    Label181: TLabel;
    Edit75: TEdit;
    GroupBox6: TGroupBox;
    Label131: TLabel;
    Edit3: TEdit;
    Label132: TLabel;
    CheckBox40: TCheckBox;
    CheckBox9: TCheckBox;
    CheckBox126: TCheckBox;
    CheckBox155: TCheckBox;
    Label172: TLabel;
    Edit70: TEdit;
    Label173: TLabel;
    Edit71: TEdit;
    GroupBox11: TGroupBox;
    CheckBox17: TCheckBox;
    CheckBox163: TCheckBox;
    CheckBox159: TCheckBox;
    CheckBox95: TCheckBox;
    TabSheet1: TTabSheet;
    Panel3: TPanel;
    GroupBox7: TGroupBox;
    Label1: TLabel;
    Label3: TLabel;
    Label134: TLabel;
    Memo1: TMemo;
    Button19: TButton;
    Button20: TButton;
    Edit49: TEdit;
    GroupBox2: TGroupBox;
    Label12: TLabel;
    Label108: TLabel;
    Edit33: TEdit;
    CheckBox27: TCheckBox;
    CheckBox127: TCheckBox;
    CheckBox15: TCheckBox;
    CheckBox113: TCheckBox;
    CheckBox88: TCheckBox;
    TabSheet2: TTabSheet;
    Panel12: TPanel;
    CheckBox120: TCheckBox;
    CheckBox36: TCheckBox;
    Label66: TLabel;
    CheckBox57: TCheckBox;
    TabSheet11: TTabSheet;
    Panel13: TPanel;
    Label24: TLabel;
    Edit53: TEdit;
    Label26: TLabel;
    Edit54: TEdit;
    Label122: TLabel;
    Edit45: TEdit;
    Label124: TLabel;
    Edit46: TEdit;
    Label167: TLabel;
    Edit66: TEdit;
    Label168: TLabel;
    Edit67: TEdit;
    CheckBox97: TCheckBox;
    CheckBox167: TCheckBox;
    CheckBox82: TCheckBox;
    CheckBox25: TCheckBox;
    CheckBox87: TCheckBox;
    TabSheet23: TTabSheet;
    Panel14: TPanel;
    CheckBox129: TCheckBox;
    Label63: TLabel;
    Edit12: TEdit;
    Edit44: TEdit;
    Label120: TLabel;
    Label49: TLabel;
    ComboBox7: TComboBox;
    CheckBox81: TCheckBox;
    CheckBox60: TCheckBox;
    CheckBox50: TCheckBox;
    CheckBox63: TCheckBox;
    GroupBox41: TGroupBox;
    Label182: TLabel;
    Label183: TLabel;
    Label184: TLabel;
    CheckBox157: TCheckBox;
    Edit76: TEdit;
    Edit77: TEdit;
    Edit78: TEdit;
    TabSheet39: TTabSheet;
    Panel16: TPanel;
    GroupBox10: TGroupBox;
    Label59: TLabel;
    Label60: TLabel;
    Label84: TLabel;
    Label85: TLabel;
    TrackBarMasterMax: TTrackBar;
    TrackBarWaveMax: TTrackBar;
    CheckBox31: TCheckBox;
    TrackBarMasterMin: TTrackBar;
    TrackBarWaveMin: TTrackBar;
    GroupBox17: TGroupBox;
    Label21: TLabel;
    Label117: TLabel;
    CheckBox121: TCheckBox;
    TrackBar: TTrackBar;
    RadioButton9: TRadioButton;
    RadioButton10: TRadioButton;
    RadioButton11: TRadioButton;
    RadioButton12: TRadioButton;
    GroupBox39: TGroupBox;
    Label170: TLabel;
    CheckBox154: TCheckBox;
    Edit69: TEdit;
    CheckListBox4: TCheckListBox;
    TabSheet40: TTabSheet;
    Panel21: TPanel;
    GroupBox37: TGroupBox;
    Label162: TLabel;
    Label163: TLabel;
    Label164: TLabel;
    Label165: TLabel;
    Label178: TLabel;
    Label185: TLabel;
    Label186: TLabel;
    Label187: TLabel;
    Label202: TLabel;
    CheckBox148: TCheckBox;
    Edit62: TEdit;
    Edit63: TEdit;
    Edit64: TEdit;
    CheckBox149: TCheckBox;
    Edit74: TEdit;
    CheckBox158: TCheckBox;
    Edit79: TEdit;
    Edit80: TEdit;
    Memo81: TMemo;
    Edit81: TEdit;
    TabSheet41: TTabSheet;
    Panel23: TPanel;
    GroupBox13: TGroupBox;
    Label200: TLabel;
    CheckBox144: TCheckBox;
    CheckBox142: TCheckBox;
    CheckBox166: TCheckBox;
    Edit89: TEdit;
    Button28: TButton;
    GroupBox29: TGroupBox;
    Label201: TLabel;
    CheckBox140: TCheckBox;
    Edit90: TEdit;
    GroupBox31: TGroupBox;
    CheckBox20: TCheckBox;
    CheckBox48: TCheckBox;
    CheckBox21: TCheckBox;
    CheckBox42: TCheckBox;
    TabSheet42: TTabSheet;
    Panel27: TPanel;
    GroupBox22: TGroupBox;
    Label16: TLabel;
    Label79: TLabel;
    Label80: TLabel;
    Label87: TLabel;
    CheckBox19: TCheckBox;
    ComboBox6: TComboBox;
    Edit21: TEdit;
    GroupBox14: TGroupBox;
    CheckBox51: TCheckBox;
    CheckBox52: TCheckBox;
    Label91: TLabel;
    CheckBox32: TCheckBox;
    CheckBox37: TCheckBox;
    Label67: TLabel;
    CheckBox33: TCheckBox;
    CheckBox49: TCheckBox;
    Label15: TLabel;
    CheckBox141: TCheckBox;
    CheckBox156: TCheckBox;
    Label111: TLabel;
    Edit34: TEdit;
    GroupBox15: TGroupBox;
    CheckBox162: TCheckBox;
    Label72: TLabel;
    Label194: TLabel;
    Edit85: TEdit;
    CheckBox2: TCheckBox;
    Panel29: TPanel;
    Panel33: TPanel;
    Panel36: TPanel;
    Panel44: TPanel;
    Panel45: TPanel;
    Panel46: TPanel;
    CheckBox3: TCheckBox;
    Label4: TLabel;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    Label6: TLabel;
    CheckBox6: TCheckBox;
    Label8: TLabel;
    Edit2: TEdit;
    CheckBox7: TCheckBox;
    Label9: TLabel;
    ComboBox2: TComboBox;
    CheckBox8: TCheckBox;
    CheckBox22: TCheckBox;
    Label10: TLabel;
    Label11: TLabel;
    Button3: TBitBtn;
    GroupBox16: TGroupBox;
    CheckBox26: TCheckBox;
    CheckBox29: TCheckBox;
    Edit1: TEdit;
    Label13: TLabel;
    Label18: TLabel;
    Edit5: TEdit;
    CheckBox30: TCheckBox;
    Edit13: TEdit;
    Button1: TButton;
    CheckBox35: TCheckBox;
    CheckBox38: TCheckBox;
    Label28: TLabel;
    Label29: TLabel;
    GroupBox18: TGroupBox;
    CheckBox39: TCheckBox;
    Label35: TLabel;
    Label36: TLabel;
    Image1: TImage;
    CheckBox44: TCheckBox;
    TabSheet43: TTabSheet;
    Panel1: TPanel;
    Label37: TLabel;
    GroupBox19: TGroupBox;
    Label38: TLabel;
    GroupBox26: TGroupBox;
    Label39: TLabel;
    GroupBox30: TGroupBox;
    Label40: TLabel;
    Label41: TLabel;
    ComboBox4: TComboBox;
    CheckBox45: TCheckBox;
    TabSheet44: TTabSheet;
    Panel47: TPanel;
    Label42: TLabel;
    Label43: TLabel;
    Edit16: TEdit;
    Label44: TLabel;
    CheckBox46: TCheckBox;
    Label45: TLabel;
    ComboBox5: TComboBox;
    ComboBox9: TComboBox;
    ComboBox12: TComboBox;
    Label46: TLabel;
    Label47: TLabel;
    Panel48: TPanel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    Edit36: TEdit;
    CheckBox56: TCheckBox;
    CheckBox59: TCheckBox;
    Panel49: TPanel;
    Label48: TLabel;
    Label51: TLabel;
    Edit23: TEdit;
    Edit26: TEdit;
    CheckBox47: TCheckBox;
    Bevel1: TBevel;
    Edit37: TEdit;
    CheckBox64: TCheckBox;
    CheckBox65: TCheckBox;
    CheckBox74: TCheckBox;
    ComboBox13: TComboBox;
    Edit38: TEdit;
    GroupBox35: TGroupBox;
    Label112: TLabel;
    Label113: TLabel;
    CheckBox1: TCheckBox;
    Edit35: TEdit;
    Label144: TLabel;
    Edit60: TEdit;
    Label145: TLabel;
    GroupBox34: TGroupBox;
    CheckBox75: TCheckBox;
    Label64: TLabel;
    Edit68: TEdit;
    Label65: TLabel;
    ComboBox1: TComboBox;
    CheckBox76: TCheckBox;
    TabSheet45: TTabSheet;
    Panel50: TPanel;
    TabSheet46: TTabSheet;
    Panel51: TPanel;
    CheckBox77: TCheckBox;
    TabSheet47: TTabSheet;
    Panel52: TPanel;
    CheckListBox5: TCheckListBox;
    Label81: TLabel;
    TabSheet48: TTabSheet;
    Panel53: TPanel;
    Label89: TLabel;
    ListView17: TListView;
    Label90: TLabel;
    Edit82: TEdit;
    Button2: TButton;
    TabSheet49: TTabSheet;
    Panel54: TPanel;
    CheckBox78: TCheckBox;
    Label96: TLabel;
    Label99: TLabel;
    Label100: TLabel;
    Edit91: TEdit;
    CheckBox84: TCheckBox;
    CheckBox100: TCheckBox;
    Label98: TLabel;
    Label75: TLabel;
    Label76: TLabel;
    Edit92: TEdit;
    Label114: TLabel;
    Label115: TLabel;
    Label125: TLabel;
    Label126: TLabel;
    CheckBox101: TCheckBox;
    Edit94: TEdit;
    Edit95: TEdit;
    Label127: TLabel;
    Label128: TLabel;
    Edit96: TEdit;
    Label129: TLabel;
    Label130: TLabel;
    Label142: TLabel;
    Label143: TLabel;
    Edit97: TEdit;
    CheckBox16: TCheckBox;
    CheckBox136: TCheckBox;
    CheckBox137: TCheckBox;
    Label149: TLabel;
    CheckBox102: TCheckBox;
    Label150: TLabel;
    Edit98: TEdit;
    TabSheet50: TTabSheet;
    Panel55: TPanel;
    Label151: TLabel;
    Label152: TLabel;
    CheckBox103: TCheckBox;
    TabSheet51: TTabSheet;
    Panel56: TPanel;
    ListView18: TListView;
    Label153: TLabel;
    Edit99: TEdit;
    Label154: TLabel;
    Label155: TLabel;
    Edit100: TEdit;
    Memo2: TMemo;
    Button4: TButton;
    procedure TabSheet5Show(Sender: TObject);
    procedure TabSheet6Show(Sender: TObject);
    procedure TabSheet7Show(Sender: TObject);
    procedure TabSheet9Show(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure ListView3SelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure Edit7Change(Sender: TObject);
    procedure Edit8Change(Sender: TObject);
    procedure ListView1SelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure Edit6Change(Sender: TObject);
    procedure CheckBox18Click(Sender: TObject);
    procedure CheckBox19Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure CheckBox24Click(Sender: TObject);
    procedure ListView2SelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure Edit4Change(Sender: TObject);
    procedure TabSheet8Show(Sender: TObject);
    procedure CheckBox28Click(Sender: TObject);
    procedure TabSheet12Show(Sender: TObject);
    procedure ListView4SelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure Edit9Change(Sender: TObject);
    procedure CheckBox31Click(Sender: TObject);
    procedure CheckBox36Click(Sender: TObject);
    procedure CheckBox37Click(Sender: TObject);
    procedure TabSheet15Show(Sender: TObject);
    procedure ListView5SelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure Edit14Change(Sender: TObject);
    procedure Edit15Change(Sender: TObject);
    procedure ListView6SelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure Edit17Change(Sender: TObject);
    procedure Edit18Change(Sender: TObject);
    procedure TrackBarMasterMaxChange(Sender: TObject);
    procedure TrackBarWaveMaxChange(Sender: TObject);
    procedure TrackBarMasterMinChange(Sender: TObject);
    procedure TrackBarWaveMinChange(Sender: TObject);
    procedure ListView7SelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure Edit11Change(Sender: TObject);
    procedure TreeViewChange(Sender: TObject; Node: TTreeNode);
    procedure TabSheet16Show(Sender: TObject);
    procedure ListView8SelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure Edit19Change(Sender: TObject);
    procedure Edit20Change(Sender: TObject);
    procedure CheckBox32Click(Sender: TObject);
    procedure CheckBox33Click(Sender: TObject);
    procedure CheckBox49Click(Sender: TObject);
    procedure ListView9SelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure Edit22Change(Sender: TObject);
    procedure CheckBox51Click(Sender: TObject);
    procedure CheckBox52Click(Sender: TObject);
    procedure TabSheet17Show(Sender: TObject);
    procedure ListView10SelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure Edit24Change(Sender: TObject);
    procedure CheckBox66Click(Sender: TObject);
    procedure TabSheet20Show(Sender: TObject);
    procedure ListView11SelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure Edit28Change(Sender: TObject);
    procedure Edit29Change(Sender: TObject);
    procedure TabSheet21Show(Sender: TObject);
    procedure ListView12SelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure Edit30Change(Sender: TObject);
    procedure Edit31Change(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure Button15Click(Sender: TObject);
    procedure Button16Click(Sender: TObject);
    procedure Button17Click(Sender: TObject);
    procedure CheckBox116Click(Sender: TObject);
    procedure CheckBox117Click(Sender: TObject);
    procedure CheckBox118Click(Sender: TObject);
    procedure CheckBox121Click(Sender: TObject);
    procedure TabSheet25Show(Sender: TObject);
    procedure ListView13SelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure Edit93Change(Sender: TObject);
    procedure RadioButton913Click(Sender: TObject);
    procedure RadioButton914Click(Sender: TObject);
    procedure ListView14SelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure CheckBox53Click(Sender: TObject);
    procedure Button19Click(Sender: TObject);
    procedure Button20Click(Sender: TObject);
    procedure CheckBox89Click(Sender: TObject);
    procedure CheckBox93Click(Sender: TObject);
    procedure Button22Click(Sender: TObject);
    procedure TreeViewCollapsing(Sender: TObject; Node: TTreeNode;
      var AllowCollapse: Boolean);
    procedure TreeViewEditing(Sender: TObject; Node: TTreeNode;
      var AllowEdit: Boolean);
    procedure Button24Click(Sender: TObject);
    procedure Button25Click(Sender: TObject);
    procedure Button26Click(Sender: TObject);
    procedure CheckBox96Click(Sender: TObject);
    procedure Button27Click(Sender: TObject);
    procedure RadioButton6Click(Sender: TObject);
    procedure RadioButton7Click(Sender: TObject);
    procedure RadioButton8Click(Sender: TObject);
    procedure RadioButton13Click(Sender: TObject);
    procedure CheckBox154Click(Sender: TObject);
    procedure CheckBox155Click(Sender: TObject);
    procedure TabSheet37Show(Sender: TObject);
    procedure ListView15SelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure Edit72Change(Sender: TObject);
    procedure Edit73Change(Sender: TObject);
    procedure CheckBox157Click(Sender: TObject);
    procedure CheckBox158Click(Sender: TObject);
    procedure CheckBox162Click(Sender: TObject);
    procedure TabSheet38Show(Sender: TObject);
    procedure Button21Click(Sender: TObject);
    procedure ListView16SelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure Edit50Change(Sender: TObject);
    procedure Edit51Change(Sender: TObject);
    procedure Button28Click(Sender: TObject);
    procedure CheckBox166Click(Sender: TObject);
    procedure Panel2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TabSheet39Show(Sender: TObject);
    procedure CheckBox3Click(Sender: TObject);
    procedure CheckBox5Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure CheckBox30Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Label35Click(Sender: TObject);
    procedure Label36Click(Sender: TObject);
    procedure CheckBox129Click(Sender: TObject);
    procedure CheckBox46Click(Sender: TObject);
    procedure RadioButton1Click(Sender: TObject);
    procedure CheckBox47Click(Sender: TObject);
    procedure ComboBox13Change(Sender: TObject);
    procedure CheckBox75Click(Sender: TObject);
    procedure TabSheet47Show(Sender: TObject);
    procedure TabSheet48Show(Sender: TObject);
    procedure ListView17SelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure Edit82Change(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure TabSheet51Show(Sender: TObject);
    procedure ListView18SelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure Edit99Change(Sender: TObject);
    procedure CheckBox56Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
    b_user_settings : boolean;
    num_user_pages : integer;

    function GetFolder():string;
    function GetOpenFile(filter,name:pchar):string;
    procedure SwitchToPage(idx:integer);
    procedure CheckClickGenerate(ctrl:TCheckBox);
    procedure RadioClickGenerate(ctrl:TRadioButton);
    procedure EditChangeGenerate(ctrl:TEdit);
    procedure MemoChangeGenerate(ctrl:TMemo);
    procedure ComboChangeGenerate(ctrl:TComboBox);
    procedure SetCheck(control:TCheckBox;param:string);
    procedure GetCheck(control:TCheckBox;param:string);
    procedure SetRadio(control:TRadioButton;param:string);
    procedure GetRadio(control:TRadioButton;param:string);
    procedure SetEditString(control:TEdit;param:string);
    procedure GetEditString(control:TEdit;param:string);
    procedure SetEditLongString(control:TEdit;param:string);
    procedure GetEditLongString(control:TEdit;param:string);
    procedure SetMemoString(control:TMemo;param:string);
    procedure GetMemoString(control:TMemo;param:string);
    procedure SetMemoLongString(control:TMemo;param:string);
    procedure GetMemoLongString(control:TMemo;param:string);
    procedure SetEditPath(control:TEdit;param:string);
    procedure GetEditPath(control:TEdit;param:string);
    //procedure SetComboPath(control:TComboBox;param:string);
    //procedure GetComboPath(control:TComboBox;param:string);
    procedure SetLabelPath(control:TLabel;param:string);
    procedure SetEditInt(control:TEdit;param:string;min,max:integer;def:string);
    procedure GetEditInt(control:TEdit;param:string;min,max,def:integer);
    procedure SetComboIdx(control:TComboBox;param:string;def:integer);
    procedure GetComboIdx(control:TComboBox;param:string);
    procedure SetComboIntValue(control:TComboBox;param:string;def_idx:integer);
    procedure GetComboIntValue(control:TComboBox;param:string;def_value:integer);
    procedure SetCheckLabelPath(chk:TCheckBox;lbl:TLabel;param:string);
    procedure GetLabelPath(control:TLabel;param:string);
    procedure SetPanelColor(control:TPanel;param:string);
    procedure GetPanelColor(control:TPanel;param:string);
    procedure SetDisksList(control:TCheckListBox;param:string);
    procedure GetDisksList(control:TCheckListBox;param:string);
    procedure SetList1(control:TListView;param:string);
    procedure GetList1(control:TListView;param:string);
    procedure SetList2(control:TListView;param:string);
    procedure GetList2(control:TListView;param:string);
    procedure SetInfo;
    procedure StoreInfo;
    procedure CheckInfo;
  public
    { Public declarations }
    constructor CreateForm(const title:string;is_user_settings:boolean);
    destructor Destroy; override;
  end;


function ShowSetupVarsFormModal(const title:string;is_user_settings:boolean):boolean;


implementation

uses tools, lang, tip;

{$R *.dfm}

{$INCLUDE dll.inc}


const MAXLISTITEMS = 200;  // the same value in rshell\cfg_def.cpp, rp_shared and some bodytools


type TDeskTheme = record
      path : string;
      combo_idx : integer;
      color : integer;
     end;

const desk_themes : array [0..5] of TDeskTheme =
(
  (path:'';
   combo_idx:0; color:$C0C0C0),
  (path:'res://%RS_FOLDER%\default\themes\01.theme//index.html';
   combo_idx:2; color:$C0C0C0),
  (path:'res://%RS_FOLDER%\default\themes\02.theme//index.html';
   combo_idx:3; color:$C0C0C0),
  (path:'res://%RS_FOLDER%\default\themes\03.theme//index.html';
   combo_idx:4; color:$4DC8F0),
  (path:'res://%RS_FOLDER%\default\themes\04.theme//index.html';
   combo_idx:5; color:$209DF4),
  (path:'%RS_FOLDER%\default\themes\05.theme';
   combo_idx:6; color:$B8ABBE)
);


function ShowSetupVarsFormModal(const title:string;is_user_settings:boolean):boolean;
var f:TSetupVarsForm;
    old_cur:TCursor;
begin
 old_cur:=Screen.Cursor;
 Screen.Cursor:=crHourGlass;
 f:=TSetupVarsForm.CreateForm(title,is_user_settings);
 Screen.Cursor:=old_cur;
 Result:=f.ShowModal=mrOk;
 f.Free;
end;

function TSetupVarsForm.GetFolder():string;
begin
 Result:=Tools.EmulGetFolder(false);
end;

function TSetupVarsForm.GetOpenFile(filter,name:pchar):string;
begin
 Result:=Tools.EmulGetOpenFile(filter,name);
end;

procedure TSetupVarsForm.SwitchToPage(idx:integer);
begin
 if PageControl.ActivePageIndex<>idx then
  PageControl.ActivePageIndex:=idx;
end;

constructor TSetupVarsForm.CreateForm(const title:string;is_user_settings:boolean);
var n,idx:integer;
    sibl:TTreeNode;
    s,search,sibl_name:string;
begin
 inherited Create(nil);

 b_user_settings:=is_user_settings;
 num_user_pages:=0;
 for n:=0 to PageControl.PageCount-1 do
  if PageControl.Pages[n].Tag >= 1000 then
   break
  else
   inc(num_user_pages);

 Constraints.MinWidth:=Width;
 Constraints.MinHeight:=Height;
 Button3.Enabled:=FileExists(GetLocalPath(PATH_HELP));
 Button11.Enabled:=FileExists(GetLocalPath(PATH_CLASSV));
 Caption:=Caption + ' ('+title+')';

 sibl:=nil;
 sibl_name:='';
 for n:=0 to PageControl.PageCount-1 do
  if ((PageControl.Pages[n].Tag<1000) and b_user_settings) or ((PageControl.Pages[n].Tag>=1000) and (not b_user_settings)) then
   begin
    s:=PageControl.Pages[n].Caption;
    search:=sibl_name+': ';
    if Pos(search,s)=1 then
      TreeView.Items.AddChild(sibl,AnsiReplaceText(s,search,''))
    else
     begin
      sibl_name:=s;
      sibl:=TreeView.Items.Add(nil,sibl_name);
     end;
   end;

 TreeView.FullExpand;
 TreeView.Selected:=TreeView.Items[0];

 if b_user_settings then
  idx:=0
 else
  idx:=num_user_pages;

 SwitchToPage(idx);
 for n:=0 to PageControl.PageCount-1 do
  PageControl.Pages[n].TabVisible:=false;
 SwitchToPage(idx);

 SetInfo();
end;

destructor TSetupVarsForm.Destroy;
begin
 if ModalResult=mrOk then
  begin
   StoreInfo();
   CheckInfo();
  end;

 inherited;
end;

procedure TSetupVarsForm.FormShow(Sender: TObject);
begin
 try
  TreeView.SetFocus;
 except end;
end;

procedure TSetupVarsForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if key=VK_F1 then
  if Button3.Visible and Button3.Enabled then
    Button3Click(Sender);
end;

procedure TSetupVarsForm.Button3Click(Sender: TObject);
var url:string;
    n:integer;
begin
 url:='';
 if (PageControl.ActivePage<>nil) and (PageControl.ActivePage.Tag<>0) and (PageControl.ActivePage.Tag<>1000) then
  begin
   n:=PageControl.ActivePage.Tag;
   url:='clvars/'+format('%.2d',[n])+'.html';
  end;
 HHW_DisplayTopic(0,pchar(GetLocalPath(PATH_HELP)),pchar(url),nil);
end;

procedure TSetupVarsForm.TreeViewChange(Sender: TObject; Node: TTreeNode);
var n:integer;
begin
 if Visible then
  if TreeView.Selected<>nil then
   begin
    n:=TreeView.Selected.AbsoluteIndex;
    if not b_user_settings then
     inc(n,num_user_pages);

    SwitchToPage(n);
   end;
end;

procedure TSetupVarsForm.TreeViewCollapsing(Sender: TObject; Node: TTreeNode;
  var AllowCollapse: Boolean);
begin
 AllowCollapse:=false;
end;

procedure TSetupVarsForm.TreeViewEditing(Sender: TObject; Node: TTreeNode;
  var AllowEdit: Boolean);
begin
 AllowEdit:=false;
end;

procedure TSetupVarsForm.CheckClickGenerate(ctrl:TCheckBox);
begin
 if Assigned(ctrl.OnClick) then
   ctrl.OnClick(ctrl);
end;

procedure TSetupVarsForm.RadioClickGenerate(ctrl:TRadioButton);
begin
 if Assigned(ctrl.OnClick) then
   ctrl.OnClick(ctrl);
end;

procedure TSetupVarsForm.EditChangeGenerate(ctrl:TEdit);
begin
 if Assigned(ctrl.OnChange) then
   ctrl.OnChange(ctrl);
end;

procedure TSetupVarsForm.MemoChangeGenerate(ctrl:TMemo);
begin
 if Assigned(ctrl.OnChange) then
   ctrl.OnChange(ctrl);
end;

procedure TSetupVarsForm.ComboChangeGenerate(ctrl:TComboBox);
begin
 if Assigned(ctrl.OnChange) then
   ctrl.OnChange(ctrl);
end;

procedure TSetupVarsForm.SetCheck(control:TCheckBox;param:string);
begin
 control.Checked:=CfgGetBoolValue(pchar(param));
 CheckClickGenerate(control);
end;

procedure TSetupVarsForm.GetCheck(control:TCheckBox;param:string);
begin
 CfgSetBoolValue(pchar(param),control.Checked);
end;

procedure TSetupVarsForm.SetRadio(control:TRadioButton;param:string);
begin
 control.Checked:=CfgGetBoolValue(pchar(param));
 if control.Checked then //!!!
  RadioClickGenerate(control);
end;

procedure TSetupVarsForm.GetRadio(control:TRadioButton;param:string);
begin
 CfgSetBoolValue(pchar(param),control.Checked);
end;

procedure TSetupVarsForm.SetEditString(control:TEdit;param:string);
begin
 control.Text:=CfgGetStringValue(pchar(param));
 EditChangeGenerate(control);
end;

procedure TSetupVarsForm.GetEditString(control:TEdit;param:string);
begin
 CfgSetStringValue(pchar(param),pchar(control.Text));
end;

procedure TSetupVarsForm.SetEditLongString(control:TEdit;param:string);
begin
 control.Text:=CfgGetLongStringValue(pchar(param));
 EditChangeGenerate(control);
end;

procedure TSetupVarsForm.GetEditLongString(control:TEdit;param:string);
begin
 CfgSetLongStringValue(pchar(param),pchar(control.Text));
end;

procedure TSetupVarsForm.SetMemoString(control:TMemo;param:string);
begin
 control.Text:=CfgGetStringValue(pchar(param));
 MemoChangeGenerate(control);
end;

procedure TSetupVarsForm.GetMemoString(control:TMemo;param:string);
begin
 CfgSetStringValue(pchar(param),pchar(control.Text));
end;

procedure TSetupVarsForm.SetMemoLongString(control:TMemo;param:string);
begin
 control.Text:=CfgGetLongStringValue(pchar(param));
 MemoChangeGenerate(control);
end;

procedure TSetupVarsForm.GetMemoLongString(control:TMemo;param:string);
begin
 CfgSetLongStringValue(pchar(param),pchar(control.Text));
end;

procedure TSetupVarsForm.SetEditPath(control:TEdit;param:string);
begin
 control.Text:=CfgGetPathValue(pchar(param));
 EditChangeGenerate(control);
end;

procedure TSetupVarsForm.GetEditPath(control:TEdit;param:string);
begin
 CfgSetPathValue(pchar(param),pchar(control.Text));
end;

// unused. Commented to disable hint
//procedure TSetupVarsForm.SetComboPath(control:TComboBox;param:string);
//begin
// control.Text:=CfgGetPathValue(pchar(param));
// ComboChangeGenerate(control);
//end;

// unused. Commented to disable hint
//procedure TSetupVarsForm.GetComboPath(control:TComboBox;param:string);
//begin
// CfgSetPathValue(pchar(param),pchar(control.Text));
//end;

procedure TSetupVarsForm.SetLabelPath(control:TLabel;param:string);
begin
 control.Caption:=CfgGetPathValue(pchar(param));
end;

procedure TSetupVarsForm.SetEditInt(control:TEdit;param:string;min,max:integer;def:string);
var i:integer;
begin
 i:=CfgGetIntValue(pchar(param));
 if (i<min) or (i>max) then
  control.Text:=def
 else
  control.Text:=inttostr(i);
 EditChangeGenerate(control);
end;

procedure TSetupVarsForm.GetEditInt(control:TEdit;param:string;min,max,def:integer);
var i:integer;
begin
 try
  i:=strtoint(control.Text);
  if i<min then
   i:=min;
  if i>max then
   i:=max;
 except
  i:=def;
 end;

 CfgSetIntValue(pchar(param),i);
end;

procedure TSetupVarsForm.SetComboIdx(control:TComboBox;param:string;def:integer);
var i:integer;
begin
 i:=CfgGetIntValue(pchar(param));
 if (i<0) or (i>=control.Items.Count) then
  i:=def;
 control.ItemIndex:=i;
 ComboChangeGenerate(control);
end;

procedure TSetupVarsForm.GetComboIdx(control:TComboBox;param:string);
begin
 CfgSetIntValue(pchar(param),control.ItemIndex);
end;

procedure TSetupVarsForm.SetComboIntValue(control:TComboBox;param:string;def_idx:integer);
var i,n:integer;
    find:boolean;
begin
 i:=CfgGetIntValue(pchar(param));
 find:=false;
 for n:=0 to control.Items.Count-1 do
  if control.Items[n]=inttostr(i) then
   begin
    control.ItemIndex:=n;
    find:=true;
    break;
   end;
 if not find then
  control.ItemIndex:=def_idx;
 ComboChangeGenerate(control);
end;

procedure TSetupVarsForm.GetComboIntValue(control:TComboBox;param:string;def_value:integer);
var i:integer;
begin
 i:=def_value;
 if control.itemindex<>-1 then
   i:=strtointdef(control.items[control.itemindex],def_value);

 CfgSetIntValue(pchar(param),i);
end;

procedure TSetupVarsForm.SetCheckLabelPath(chk:TCheckBox;lbl:TLabel;param:string);
begin
 lbl.Caption:=CfgGetPathValue(pchar(param));
 chk.Checked:=lbl.Caption<>'';
 CheckClickGenerate(chk);
end;

procedure TSetupVarsForm.GetLabelPath(control:TLabel;param:string);
begin
 CfgSetPathValue(pchar(param),pchar(control.Caption));
end;

procedure TSetupVarsForm.SetPanelColor(control:TPanel;param:string);
begin
 control.Color:=TColor(CfgGetIntValue(pchar(param)));
end;

procedure TSetupVarsForm.GetPanelColor(control:TPanel;param:string);
begin
 CfgSetIntValue(pchar(param),integer(control.Color));
end;

procedure TSetupVarsForm.SetDisksList(control:TCheckListBox;param:string);
var disks,n:integer;
begin
 disks:=CfgGetIntValue(pchar(param));
 for n:=0 to 25 do
  control.Checked[n]:=((disks shr n) and 1)<>0;
end;

procedure TSetupVarsForm.GetDisksList(control:TCheckListBox;param:string);
var disks,n:integer;
begin
 disks:=0;
 for n:=0 to 25 do
  if control.Checked[n] then
   disks:=disks or (integer(1) shl n);
 CfgSetIntValue(pchar(param),disks);
end;

procedure TSetupVarsForm.SetList1(control:TListView;param:string);
var n:integer;
    state:boolean;
    parm1:pchar;
begin
 for n:=0 to MAXLISTITEMS-1 do
  begin
   parm1:='';
   state:=CfgGetList1Value(pchar(param),n,@parm1);
   control.Items.Add;
   control.Items[n].Caption:=parm1;
   control.Items[n].Checked:=state;
  end;
end;

procedure TSetupVarsForm.GetList1(control:TListView;param:string);
var n:integer;
begin
 for n:=0 to MAXLISTITEMS-1 do
   CfgSetList1Value(pchar(param),n,control.Items[n].Checked,pchar(control.Items[n].Caption));
end;

procedure TSetupVarsForm.SetList2(control:TListView;param:string);
var n:integer;
    state:boolean;
    parm1,parm2:pchar;
begin
 for n:=0 to MAXLISTITEMS-1 do
  begin
   parm1:='';
   parm2:='';
   state:=CfgGetList2Value(pchar(param),n,@parm1,@parm2);
   control.Items.Add;
   control.Items[n].Caption:=parm1;
   control.Items[n].SubItems.Add(parm2);
   control.Items[n].Checked:=state;
  end;
end;

procedure TSetupVarsForm.GetList2(control:TListView;param:string);
var n:integer;
begin
 for n:=0 to MAXLISTITEMS-1 do
   CfgSetList2Value(pchar(param),n,control.Items[n].Checked,pchar(control.Items[n].Caption),pchar(control.Items[n].SubItems[0]));
end;


procedure TSetupVarsForm.SetInfo;
var s:string;
    n,count:integer;
    find:boolean;
begin
 if b_user_settings then
  begin
   SetCheckLabelPath(CheckBox162,Label72,'wait_server_path');
   SetEditInt(Edit85,'wait_server_timeout',1,300,'1');
   SetCheck(CheckBox7,'only_one_cpu');
   SetComboIdx(ComboBox4,'shutdown_action',0);

   SetEditInt(Edit16,'fastexit_idle_timeout',0,9999,'0');
   SetCheck(CheckBox46,'fastexit_use_keyboard');
   SetRadio(RadioButton1,'fastexit_use_fixed_pwd');
   SetEditString(Edit37,'fastexit_fixed_pwd_md5');
   SetCheck(CheckBox56,'fastexit_use_flash');
   SetMemoLongString(Memo2,'fastexit_flash_list');

   SetEditPath(Edit38,'curr_desktop_theme');

   find:=false;
   count:=sizeof(desk_themes) div sizeof(desk_themes[0]);
   for n:=0 to count-1 do
    begin
     if AnsiCompareText(desk_themes[n].path,Edit38.Text)=0 then
      begin
       ComboBox13.ItemIndex:=desk_themes[n].combo_idx;
       find:=true;
       break;
      end;
    end;
   if not find then
    ComboBox13.ItemIndex:=1;
   ComboChangeGenerate(ComboBox13);

   SetCheck(CheckBox65,'dont_show_theme_errors');
   SetMemoLongString(Memo1,'html_status_text2');
   SetEditString(Edit49,'html_status_text1');
   SetCheck(CheckBox8,'use_desk_shader');
   SetEditString(Edit98,'startup_sheet_name');
   SetEditInt(Edit94,'def_vmode_width',1,9999,'');
   SetEditInt(Edit95,'def_vmode_height',1,9999,'');
   SetEditInt(Edit96,'def_vmode_bpp',1,48,'');
   SetEditInt(Edit33,'display_freq',1,300,'');
   SetCheck(CheckBox27,'restore_dm_at_startup');
   SetCheck(CheckBox127,'disable_desktop_composition');
   SetComboIdx(ComboBox10,'curr_theme2d',0);
   SetPanelColor(Panel2,'def_sheet_color');
   SetEditInt(Edit43,'min_grouped_windows',0,99,'0');
   SetEditInt(Edit75,'max_vis_tray_icons',0,32,'0');
   SetEditInt(Edit3,'close_sheet_idle',0,99,'0');
   SetCheck(CheckBox102,'sheet_init_maximize');
   SetCheck(CheckBox44,'high_quality_bg_video');
   SetCheck(CheckBox40,'dont_show_empty_icons');
   SetCheck(CheckBox103,'det_empty_icons_by_icon_path');
   SetCheck(CheckBox9,'icons_winstyle');
   SetCheck(CheckBox126,'do_icon_highlight');
   SetCheck(CheckBox101,'dont_show_icon_names');
   SetComboIdx(ComboBox2,'ubericon_effect',0);
   SetCheck(CheckBox155,'use_system_icon_spacing');
   SetEditInt(Edit70,'icon_spacing_w',1,500,'1');
   SetEditInt(Edit71,'icon_spacing_h',1,500,'1');
   SetEditInt(Edit92,'icon_size_w',1,500,'1');
   SetEditInt(Edit91,'icon_size_h',1,500,'1');
   SetCheck(CheckBox83,'winkey_enable');
   SetCheck(CheckBox11,'logoff_in_menu');
   SetCheck(CheckBox12,'reboot_in_menu');
   SetCheck(CheckBox13,'shutdown_in_menu');
   SetCheck(CheckBox41,'gc_info_in_menu');
   SetCheck(CheckBox43,'mycomp_in_menu');
   SetCheck(CheckBox62,'monitor_off_in_menu');
   SetCheck(CheckBox164,'show_book_in_menu');
   SetCheck(CheckBox2,'calladmin_in_menu');
   SetCheck(CheckBox67,'use_cad_catcher');
   SetCheck(CheckBox68,'cad_taskman');
   SetCheck(CheckBox69,'cad_killall');
   SetCheck(CheckBox70,'cad_gcinfo');
   SetCheck(CheckBox71,'cad_reboot');
   SetCheck(CheckBox72,'cad_shutdown');
   SetCheck(CheckBox10,'cad_logoff');
   SetCheck(CheckBox73,'cad_monitoroff');
   SetList2(ListView12,'user_tools');
   SetCheck(CheckBox17,'allow_run_only_one');
   SetCheck(CheckBox163,'protect_run_when_nosql');
   SetCheck(CheckBox159,'protect_bodytools_when_nosql');
   SetCheck(CheckBox95,'protect_in_safe_mode');
   SetCheckLabelPath(CheckBox24,Label52,'alcohol_path');
   SetCheckLabelPath(CheckBox28,Label55,'daemon_path');
   SetCheckLabelPath(CheckBox5,Label6,'daemon_pro_path');
   SetCheck(CheckBox23,'stat_enable');
   SetComboIntValue(ComboBox8,'clear_stat_interval',0);
   SetCheck(CheckBox85,'do_web_stat');
   SetEditString(Edit32,'stat_excl');
   SetList2(ListView15,'lic_manager');
   SetLabelPath(Label147,'blocker_file');
   SetCheck(CheckBox145,'use_blocker');
   SetCheck(CheckBox96,'protect_run_at_startup');
   SetEditInt(Edit60,'ssaver_idle',0,999,'0');
   SetCheck(CheckBox86,'vip_in_menu');
   SetCheckLabelPath(CheckBox3,Label4,'vip_basefolder');
   SetEditInt(Edit5,'vip_folder_limit',0,999999,'0');
   SetCheck(CheckBox45,'force_viplogin_from_api');
   SetCheck(CheckBox89,'redirect_sys_folders');
   SetCheck(CheckBox90,'redirect_personal');
   SetCheck(CheckBox91,'redirect_appdata');
   SetCheck(CheckBox92,'redirect_localappdata');

   s:=string(CfgGetPathValue('personal_path'));
   Label160.Caption:=s;
   if s='' then
    RadioButton6.Checked:=true
   else
   if s='$default' then
    RadioButton7.Checked:=true
   else
   if s='$user_folder' then
    RadioButton8.Checked:=true
   else
    RadioButton13.Checked:=true;
   RadioClickGenerate(RadioButton6);
   RadioClickGenerate(RadioButton7);
   RadioClickGenerate(RadioButton8);
   RadioClickGenerate(RadioButton13);

   SetCheck(CheckBox39,'allow_hwident_ibutton');
   SetCheck(CheckBox153,'allow_printer_control');
   SetEditInt(Edit35,'turn_off_idle',0,999,'0');
   SetCheck(CheckBox1,'use_logoff_in_turn_off_idle');
   SetCheck(CheckBox75,'use_time_limitation');
   SetEditString(Edit68,'time_limitation_intervals');
   SetComboIdx(ComboBox1,'time_limitation_action',0);
   SetCheckLabelPath(CheckBox19,Label16,'user_folder_base');
   SetComboIntValue(ComboBox6,'clean_user_folder',0);
   SetEditString(Edit21,'uf_format');
   SetCheck(CheckBox51,'allow_use_flash');
   SetCheck(CheckBox32,'allow_use_diskette');
   SetCheck(CheckBox33,'allow_use_cdrom');
   SetCheckLabelPath(CheckBox52,Label91,'net_flash');
   SetCheckLabelPath(CheckBox37,Label67,'net_diskette');
   SetCheckLabelPath(CheckBox49,Label15,'net_cdrom');
   SetCheck(CheckBox141,'allow_flash_stat');
   SetCheck(CheckBox156,'allow_dvd_stat');

   CheckListBox1.Checked[0]:=CfgGetBoolValue('sysrestrict00');
   CheckListBox1.Checked[1]:=CfgGetBoolValue('sysrestrict01');
   CheckListBox1.Checked[2]:=CfgGetBoolValue('sysrestrict02');
   CheckListBox1.Checked[3]:=CfgGetBoolValue('sysrestrict03');
   CheckListBox1.Checked[4]:=CfgGetBoolValue('sysrestrict04');
   CheckListBox1.Checked[5]:=CfgGetBoolValue('sysrestrict05');
   CheckListBox1.Checked[6]:=CfgGetBoolValue('sysrestrict06');
   CheckListBox1.Checked[7]:=CfgGetBoolValue('sysrestrict07');
   CheckListBox1.Checked[8]:=CfgGetBoolValue('sysrestrict08');
   CheckListBox1.Checked[9]:=CfgGetBoolValue('sysrestrict09');
   CheckListBox1.Checked[10]:=CfgGetBoolValue('sysrestrict10');
   CheckListBox1.Checked[11]:=CfgGetBoolValue('sysrestrict11');
   CheckListBox1.Checked[12]:=CfgGetBoolValue('sysrestrict12');
   CheckListBox1.Checked[13]:=CfgGetBoolValue('sysrestrict13');
   CheckListBox1.Checked[14]:=CfgGetBoolValue('sysrestrict14_2');
   CheckListBox1.Checked[15]:=CfgGetBoolValue('sysrestrict15');
   CheckListBox1.Checked[16]:=CfgGetBoolValue('sysrestrict16');
   CheckListBox1.Checked[17]:=CfgGetBoolValue('sysrestrict17');
   CheckListBox1.Checked[18]:=CfgGetBoolValue('sysrestrict18');
   CheckListBox1.Checked[19]:=CfgGetBoolValue('sysrestrict19');
   CheckListBox1.Checked[20]:=CfgGetBoolValue('sysrestrict20');
   CheckListBox1.Checked[21]:=CfgGetBoolValue('sysrestrict21');
   CheckListBox1.Checked[22]:=CfgGetBoolValue('sysrestrict22');
   CheckListBox1.Checked[23]:=CfgGetBoolValue('sysrestrict23');
   CheckListBox1.Checked[24]:=CfgGetBoolValue('sysrestrict24');
   CheckListBox1.Checked[25]:=CfgGetBoolValue('sysrestrict25');
   CheckListBox1.Checked[26]:=CfgGetBoolValue('sysrestrict26');
   CheckListBox1.Checked[27]:=CfgGetBoolValue('sysrestrict27');
   CheckListBox1.Checked[28]:=CfgGetBoolValue('sysrestrict28');
   CheckListBox1.Checked[29]:=CfgGetBoolValue('sysrestrict29');

   SetEditLongString(Edit10,'allowed_ext');
   SetEditString(Edit59,'protected_protos');
   SetCheck(CheckBox123,'restrict_shellexechook');
   SetCheck(CheckBox74,'allow_run_from_folder_shortcuts');
   SetCheck(CheckBox128,'restrict_copyhook');
   SetCheck(CheckBox34,'restrict_file_dialogs');
   SetCheck(CheckBox38,'allow_newfolder_opensave');
   SetEditString(Edit97,'apps_opensave_prohibited');
   SetDisksList(CheckListBox2,'disks_disabled');
   SetDisksList(CheckListBox3,'disks_hidden');
   SetList1(ListView1,'disallow_run');
   SetList1(ListView7,'allow_run');
   SetList2(ListView3,'disable_windows');
   SetCheck(CheckBox98,'close_not_active_windows');
   SetList1(ListView2,'safe_tray_icons');
   SetList1(ListView9,'hidden_tray_icons');
   SetCheck(CheckBox14,'safe_tray');
   SetCheck(CheckBox15,'safe_winamp');
   SetCheck(CheckBox113,'safe_mplayerc');
   SetCheck(CheckBox88,'safe_powerdvd');
   SetCheck(CheckBox22,'safe_torrent');
   SetCheck(CheckBox100,'safe_garena');
   SetCheck(CheckBox125,'safe_console');
   SetCheck(CheckBox80,'disallow_power_keys');
   SetCheck(CheckBox61,'disable_input_when_monitor_off');
   SetCheckLabelPath(CheckBox18,Label14,'client_restore');
   SetCheck(CheckBox120,'allow_drag_anywhere');
   SetCheck(CheckBox76,'disallow_copy_from_lnkfolder');
   SetCheckLabelPath(CheckBox36,Label66,'winrar_path');
   SetCheck(CheckBox57,'allow_write_to_removable');
   SetCheck(CheckBox64,'delete_to_recycle');
   SetCheck(CheckBox84,'show_hiddens_in_bodyexpl');
   SetList2(ListView8,'addon_folders');
   SetCheck(CheckBox58,'allow_save_to_addon_folders');
   SetList2(ListView5,'menu_ext');
   SetList2(ListView6,'menu_ext_rev');
   SetCheck(CheckBox129,'use_bodytool_ie');
   SetEditString(Edit12,'ie_home_page');
   SetEditPath(Edit44,'fav_path');
   SetCheck(CheckBox6,'disallow_add2fav');
   SetComboIdx(ComboBox7,'max_ie_windows',0);
   SetEditString(Edit2,'bodywb_caption');
   SetCheck(CheckBox81,'close_ie_when_nosheet');
   SetCheck(CheckBox60,'rus2eng_wb');
   SetCheck(CheckBox50,'ie_clean_history');
   SetCheck(CheckBox63,'wb_search_bars');
   SetCheck(CheckBox157,'ie_use_sett');
   SetEditString(Edit76,'ie_sett_proxy');
   SetEditString(Edit77,'ie_sett_port');
   SetEditString(Edit78,'ie_sett_autoconfig');
   SetEditString(Edit53,'safe_ie_exts');
   SetEditString(Edit54,'safe_ie_protos');
   SetEditString(Edit45,'ie_local_res');
   SetEditString(Edit46,'ie_disallowed_protos');
   SetEditString(Edit66,'ie_open_with_mp');
   SetEditString(Edit67,'ie_open_with_ext');
   SetCheck(CheckBox97,'protect_run_in_ie');
   SetCheck(CheckBox167,'wb_flash_disable');
   SetCheck(CheckBox82,'disable_view_html');
   SetCheck(CheckBox25,'allow_ie_print');
   SetCheck(CheckBox87,'ftp_enable');

   if CfgGetBoolValue('disallow_sites') then
    RadioButton914.Checked:=true
   else
    RadioButton913.Checked:=true;
   RadioClickGenerate(RadioButton914);
   RadioClickGenerate(RadioButton913);

   SetList1(ListView13,'disallowed_sites');
   SetList1(ListView14,'allowed_sites');
   SetList1(ListView18,'redirected_urls');
   SetEditString(Edit100,'redirection_url');

   SetCheck(CheckBox99,'use_std_downloader');
   SetEditString(Edit86,'std_downloader_sites');
   SetComboIdx(ComboBox11,'max_download_windows',0);
   SetEditInt(Edit25,'max_download_size',0,9999,'0');
   SetCheck(CheckBox112,'allow_run_downloaded');
   SetCheck(CheckBox66,'use_allowed_download_types');
   SetEditString(Edit27,'allowed_download_types');
   SetEditString(Edit65,'download_autorun');
   SetCheck(CheckBox150,'dont_show_download_speed');
   SetEditInt(Edit83,'download_speed_limit',0,9999,'0');
   SetList2(ListView11,'autorun_items');
   SetCheck(CheckBox79,'disable_autorun');
   SetEditString(Edit34,'welcome_path');
   SetEditPath(Edit13,'la_startup_path');
   SetCheck(CheckBox30,'show_la_at_startup');
   SetCheck(CheckBox116,'autoplay_cda');
   SetCheck(CheckBox118,'autoplay_cdr');
   SetCheck(CheckBox117,'autoplay_dvd');
   SetCheck(CheckBox53,'autoplay_flash');
   SetEditPath(Edit39,'autoplay_cda_cmd');
   SetEditPath(Edit41,'autoplay_cdr_cmd');
   SetEditPath(Edit40,'autoplay_dvd_cmd');
   SetEditPath(Edit48,'autoplay_flash_cmd');
   SetList1(ListView10,'delete_folders');
   SetCheck(CheckBox94,'clear_recycle_bin');
   SetCheck(CheckBox54,'clean_temp_dir');
   SetCheck(CheckBox55,'clean_ie_dir');
   SetCheck(CheckBox146,'clean_cookies');
   SetCheck(CheckBox4,'clear_print_spooler');
   SetCheck(CheckBox31,'maxvol_enable');
   TrackBarMasterMax.Position:=CfgGetIntValue('maxvol_master');
   TrackBarWaveMax.Position:=CfgGetIntValue('maxvol_wave');
   TrackBarMasterMin.Position:=CfgGetIntValue('minvol_master');
   TrackBarWaveMin.Position:=CfgGetIntValue('minvol_wave');
   SetCheck(CheckBox121,'allow_mouse_adj');
   TrackBar.Position:=CfgGetIntValue('adj_mouse_speed');

   RadioButton9.Checked:=CfgGetIntValue('adj_mouse_acc')=0;
   RadioButton10.Checked:=CfgGetIntValue('adj_mouse_acc')=1;
   RadioButton11.Checked:=CfgGetIntValue('adj_mouse_acc')=2;
   RadioButton12.Checked:=CfgGetIntValue('adj_mouse_acc')=3;
   //ControlClickGenerate(RadioButton9); 10,11,12

   SetCheck(CheckBox154,'do_scandisk');
   SetEditInt(Edit69,'scandisk_hours',1,999,'1');
   SetDisksList(CheckListBox4,'scandisk_disks');
   SetCheck(CheckBox131,'use_bodytool_office');
   SetCheck(CheckBox115,'ext_office_print');
   SetCheck(CheckBox122,'protect_run_in_office');
   SetCheck(CheckBox35,'show_office_menu');
   SetCheck(CheckBox132,'use_bodytool_notepad');
   SetEditString(Edit58,'safe_notepad_exts');
   SetCheck(CheckBox134,'use_bodytool_pdf');
   SetCheck(CheckBox138,'show_pdf_panel');
   SetCheck(CheckBox130,'use_bodytool_mp');
   SetEditString(Edit55,'safe_mp_exts');
   SetEditString(Edit56,'safe_mp_protos');
   SetEditString(Edit57,'safe_mp_exts_winamp');
   SetEditPath(Edit61,'alternate_mp');
   SetCheck(CheckBox135,'use_bodytool_swf');
   SetCheck(CheckBox133,'use_bodytool_imgview');
   SetCheck(CheckBox148,'bodymail_integration');
   SetCheck(CheckBox149,'allow_mail_stat');
   SetCheck(CheckBox158,'bodymail_hardcoded');
   SetEditString(Edit62,'bodymail_smtp');
   SetEditInt(Edit74,'bodymail_port',0,65535,'25');
   SetEditString(Edit63,'bodymail_user');
   SetEditString(Edit64,'bodymail_password');
   SetEditString(Edit79,'bodymail_from_name');
   SetEditString(Edit80,'bodymail_from_address');
   SetEditString(Edit81,'bodymail_to');
   SetMemoString(Memo81,'bodymail_footer');
   SetCheck(CheckBox119,'burn_integration');
   SetCheck(CheckBox139,'allow_burn_stat');
   SetEditString(Edit42,'law_protected_files');
   SetEditPath(Edit47,'on_burn_complete');
   SetEditPath(Edit52,'net_burn_path');

   CheckBox93.Checked:=Edit52.Text<>'';
   CheckClickGenerate(CheckBox93);

   SetList1(ListView4,'hide_tm_programs');
   SetCheck(CheckBox16,'safe_taskmgr');
   SetCheck(CheckBox136,'safe_taskmgr2');
   SetCheck(CheckBox137,'safe_taskmgr3');
   SetCheck(CheckBox114,'kill_hidden_tasks');
   SetList2(ListView16,'mobile_content');
   SetEditString(Edit84,'mobile_files_audio');
   SetEditString(Edit87,'mobile_files_video');
   SetEditString(Edit88,'mobile_files_pictures');
   SetCheck(CheckBox165,'mobile_bodyexpl_integration');
   SetCheck(CheckBox144,'bt_integration');
   SetCheck(CheckBox142,'allow_bt_stat');
   SetEditPath(Edit89,'net_bt_path');

   CheckBox166.Checked:=Edit89.Text<>'';
   CheckClickGenerate(CheckBox166);

   SetCheck(CheckBox140,'allow_scan_stat');
   SetEditString(Edit90,'inject_scan');
   SetCheck(CheckBox20,'tray_mixer');
   SetCheck(CheckBox48,'tray_microphone');
   SetCheck(CheckBox21,'tray_indic');
   SetCheck(CheckBox42,'tray_minimize_all');
   SetCheck(CheckBox26,'allow_photocam');
  end
 else
  begin
   SetCheck(CheckBox78,'used_another_rollback');
   SetDisksList(CheckListBox5,'rollback_disks');
   SetList1(ListView17,'rollback_excl');
   SetCheck(CheckBox77,'use_rollback');

  end;
end;


procedure TSetupVarsForm.StoreInfo;
begin
 if b_user_settings then
  begin
   GetLabelPath(Label72,'wait_server_path');
   GetEditInt(Edit85,'wait_server_timeout',1,300,1);
   GetCheck(CheckBox7,'only_one_cpu');
   GetComboIdx(ComboBox4,'shutdown_action');
   GetEditInt(Edit16,'fastexit_idle_timeout',0,9999,0);
   GetCheck(CheckBox46,'fastexit_use_keyboard');
   GetRadio(RadioButton1,'fastexit_use_fixed_pwd');
   GetEditString(Edit37,'fastexit_fixed_pwd_md5');
   GetCheck(CheckBox56,'fastexit_use_flash');
   GetMemoLongString(Memo2,'fastexit_flash_list');
   GetEditPath(Edit38,'curr_desktop_theme');
   GetCheck(CheckBox65,'dont_show_theme_errors');
   GetMemoLongString(Memo1,'html_status_text2');
   GetEditString(Edit49,'html_status_text1');
   GetCheck(CheckBox8,'use_desk_shader');
   GetEditString(Edit98,'startup_sheet_name');
   GetEditInt(Edit94,'def_vmode_width',1,9999,-1);
   GetEditInt(Edit95,'def_vmode_height',1,9999,-1);
   GetEditInt(Edit96,'def_vmode_bpp',1,48,-1);
   GetEditInt(Edit33,'display_freq',1,300,-1);
   GetCheck(CheckBox27,'restore_dm_at_startup');
   GetCheck(CheckBox127,'disable_desktop_composition');
   GetComboIdx(ComboBox10,'curr_theme2d');
   GetPanelColor(Panel2,'def_sheet_color');
   GetEditInt(Edit43,'min_grouped_windows',0,99,0);
   GetEditInt(Edit75,'max_vis_tray_icons',0,32,0);
   GetEditInt(Edit3,'close_sheet_idle',0,99,0);
   GetCheck(CheckBox102,'sheet_init_maximize');
   GetCheck(CheckBox44,'high_quality_bg_video');
   GetCheck(CheckBox40,'dont_show_empty_icons');
   GetCheck(CheckBox103,'det_empty_icons_by_icon_path');
   GetCheck(CheckBox9,'icons_winstyle');
   GetCheck(CheckBox126,'do_icon_highlight');
   GetCheck(CheckBox101,'dont_show_icon_names');
   GetComboIdx(ComboBox2,'ubericon_effect');
   GetCheck(CheckBox155,'use_system_icon_spacing');
   GetEditInt(Edit70,'icon_spacing_w',1,500,1);
   GetEditInt(Edit71,'icon_spacing_h',1,500,1);
   GetEditInt(Edit92,'icon_size_w',1,500,1);
   GetEditInt(Edit91,'icon_size_h',1,500,1);
   GetCheck(CheckBox83,'winkey_enable');
   GetCheck(CheckBox11,'logoff_in_menu');
   GetCheck(CheckBox12,'reboot_in_menu');
   GetCheck(CheckBox13,'shutdown_in_menu');
   GetCheck(CheckBox41,'gc_info_in_menu');
   GetCheck(CheckBox43,'mycomp_in_menu');
   GetCheck(CheckBox62,'monitor_off_in_menu');
   GetCheck(CheckBox164,'show_book_in_menu');
   GetCheck(CheckBox2,'calladmin_in_menu');
   GetCheck(CheckBox67,'use_cad_catcher');
   GetCheck(CheckBox68,'cad_taskman');
   GetCheck(CheckBox69,'cad_killall');
   GetCheck(CheckBox70,'cad_gcinfo');
   GetCheck(CheckBox71,'cad_reboot');
   GetCheck(CheckBox72,'cad_shutdown');
   GetCheck(CheckBox10,'cad_logoff');
   GetCheck(CheckBox73,'cad_monitoroff');
   GetList2(ListView12,'user_tools');
   GetCheck(CheckBox17,'allow_run_only_one');
   GetCheck(CheckBox163,'protect_run_when_nosql');
   GetCheck(CheckBox159,'protect_bodytools_when_nosql');
   GetCheck(CheckBox95,'protect_in_safe_mode');
   GetLabelPath(Label52,'alcohol_path');
   GetLabelPath(Label55,'daemon_path');
   GetLabelPath(Label6,'daemon_pro_path');
   GetCheck(CheckBox23,'stat_enable');
   GetComboIntValue(ComboBox8,'clear_stat_interval',1);
   GetCheck(CheckBox85,'do_web_stat');
   GetEditString(Edit32,'stat_excl');
   GetList2(ListView15,'lic_manager');
   GetLabelPath(Label147,'blocker_file');
   GetCheck(CheckBox145,'use_blocker');
   GetCheck(CheckBox96,'protect_run_at_startup');
   GetEditInt(Edit60,'ssaver_idle',0,999,0);
   GetCheck(CheckBox86,'vip_in_menu');
   GetLabelPath(Label4,'vip_basefolder');
   GetEditInt(Edit5,'vip_folder_limit',0,999999,0);
   GetCheck(CheckBox45,'force_viplogin_from_api');
   GetCheck(CheckBox89,'redirect_sys_folders');
   GetCheck(CheckBox90,'redirect_personal');
   GetCheck(CheckBox91,'redirect_appdata');
   GetCheck(CheckBox92,'redirect_localappdata');
   GetLabelPath(Label160,'personal_path');
   GetCheck(CheckBox39,'allow_hwident_ibutton');
   GetCheck(CheckBox153,'allow_printer_control');
   GetEditInt(Edit35,'turn_off_idle',0,999,0);
   GetCheck(CheckBox1,'use_logoff_in_turn_off_idle');
   GetCheck(CheckBox75,'use_time_limitation');
   GetEditString(Edit68,'time_limitation_intervals');
   GetComboIdx(ComboBox1,'time_limitation_action');
   GetLabelPath(Label16,'user_folder_base');
   GetComboIntValue(ComboBox6,'clean_user_folder',0);
   GetEditString(Edit21,'uf_format');
   GetCheck(CheckBox51,'allow_use_flash');
   GetCheck(CheckBox32,'allow_use_diskette');
   GetCheck(CheckBox33,'allow_use_cdrom');
   GetLabelPath(Label91,'net_flash');
   GetLabelPath(Label67,'net_diskette');
   GetLabelPath(Label15,'net_cdrom');
   GetCheck(CheckBox141,'allow_flash_stat');
   GetCheck(CheckBox156,'allow_dvd_stat');

   CfgSetBoolValue('sysrestrict00',CheckListBox1.Checked[0]);
   CfgSetBoolValue('sysrestrict01',CheckListBox1.Checked[1]);
   CfgSetBoolValue('sysrestrict02',CheckListBox1.Checked[2]);
   CfgSetBoolValue('sysrestrict03',CheckListBox1.Checked[3]);
   CfgSetBoolValue('sysrestrict04',CheckListBox1.Checked[4]);
   CfgSetBoolValue('sysrestrict05',CheckListBox1.Checked[5]);
   CfgSetBoolValue('sysrestrict06',CheckListBox1.Checked[6]);
   CfgSetBoolValue('sysrestrict07',CheckListBox1.Checked[7]);
   CfgSetBoolValue('sysrestrict08',CheckListBox1.Checked[8]);
   CfgSetBoolValue('sysrestrict09',CheckListBox1.Checked[9]);
   CfgSetBoolValue('sysrestrict10',CheckListBox1.Checked[10]);
   CfgSetBoolValue('sysrestrict11',CheckListBox1.Checked[11]);
   CfgSetBoolValue('sysrestrict12',CheckListBox1.Checked[12]);
   CfgSetBoolValue('sysrestrict13',CheckListBox1.Checked[13]);
   CfgSetBoolValue('sysrestrict14_2',CheckListBox1.Checked[14]);
   CfgSetBoolValue('sysrestrict15',CheckListBox1.Checked[15]);
   CfgSetBoolValue('sysrestrict16',CheckListBox1.Checked[16]);
   CfgSetBoolValue('sysrestrict17',CheckListBox1.Checked[17]);
   CfgSetBoolValue('sysrestrict18',CheckListBox1.Checked[18]);
   CfgSetBoolValue('sysrestrict19',CheckListBox1.Checked[19]);
   CfgSetBoolValue('sysrestrict20',CheckListBox1.Checked[20]);
   CfgSetBoolValue('sysrestrict21',CheckListBox1.Checked[21]);
   CfgSetBoolValue('sysrestrict22',CheckListBox1.Checked[22]);
   CfgSetBoolValue('sysrestrict23',CheckListBox1.Checked[23]);
   CfgSetBoolValue('sysrestrict24',CheckListBox1.Checked[24]);
   CfgSetBoolValue('sysrestrict25',CheckListBox1.Checked[25]);
   CfgSetBoolValue('sysrestrict26',CheckListBox1.Checked[26]);
   CfgSetBoolValue('sysrestrict27',CheckListBox1.Checked[27]);
   CfgSetBoolValue('sysrestrict28',CheckListBox1.Checked[28]);
   CfgSetBoolValue('sysrestrict29',CheckListBox1.Checked[29]);

   GetEditLongString(Edit10,'allowed_ext');
   GetEditString(Edit59,'protected_protos');
   GetCheck(CheckBox123,'restrict_shellexechook');
   GetCheck(CheckBox74,'allow_run_from_folder_shortcuts');
   GetCheck(CheckBox128,'restrict_copyhook');
   GetCheck(CheckBox34,'restrict_file_dialogs');
   GetCheck(CheckBox38,'allow_newfolder_opensave');
   GetEditString(Edit97,'apps_opensave_prohibited');
   GetDisksList(CheckListBox2,'disks_disabled');
   GetDisksList(CheckListBox3,'disks_hidden');
   GetList1(ListView1,'disallow_run');
   GetList1(ListView7,'allow_run');
   GetList2(ListView3,'disable_windows');
   GetCheck(CheckBox98,'close_not_active_windows');
   GetList1(ListView2,'safe_tray_icons');
   GetList1(ListView9,'hidden_tray_icons');
   GetCheck(CheckBox14,'safe_tray');
   GetCheck(CheckBox15,'safe_winamp');
   GetCheck(CheckBox113,'safe_mplayerc');
   GetCheck(CheckBox88,'safe_powerdvd');
   GetCheck(CheckBox22,'safe_torrent');
   GetCheck(CheckBox100,'safe_garena');
   GetCheck(CheckBox125,'safe_console');
   GetCheck(CheckBox80,'disallow_power_keys');
   GetCheck(CheckBox61,'disable_input_when_monitor_off');
   GetLabelPath(Label14,'client_restore');
   GetCheck(CheckBox120,'allow_drag_anywhere');
   GetCheck(CheckBox76,'disallow_copy_from_lnkfolder');
   GetLabelPath(Label66,'winrar_path');
   GetCheck(CheckBox57,'allow_write_to_removable');
   GetCheck(CheckBox64,'delete_to_recycle');
   GetCheck(CheckBox84,'show_hiddens_in_bodyexpl');
   GetList2(ListView8,'addon_folders');
   GetCheck(CheckBox58,'allow_save_to_addon_folders');
   GetList2(ListView5,'menu_ext');
   GetList2(ListView6,'menu_ext_rev');
   GetCheck(CheckBox129,'use_bodytool_ie');
   GetEditString(Edit12,'ie_home_page');
   GetEditPath(Edit44,'fav_path');
   GetCheck(CheckBox6,'disallow_add2fav');
   GetComboIdx(ComboBox7,'max_ie_windows');
   GetEditString(Edit2,'bodywb_caption');
   GetCheck(CheckBox81,'close_ie_when_nosheet');
   GetCheck(CheckBox60,'rus2eng_wb');
   GetCheck(CheckBox50,'ie_clean_history');
   GetCheck(CheckBox63,'wb_search_bars');
   GetCheck(CheckBox157,'ie_use_sett');
   GetEditString(Edit76,'ie_sett_proxy');
   GetEditString(Edit77,'ie_sett_port');
   GetEditString(Edit78,'ie_sett_autoconfig');
   GetEditString(Edit53,'safe_ie_exts');
   GetEditString(Edit54,'safe_ie_protos');
   GetEditString(Edit45,'ie_local_res');
   GetEditString(Edit46,'ie_disallowed_protos');
   GetEditString(Edit66,'ie_open_with_mp');
   GetEditString(Edit67,'ie_open_with_ext');
   GetCheck(CheckBox97,'protect_run_in_ie');
   GetCheck(CheckBox167,'wb_flash_disable');
   GetCheck(CheckBox82,'disable_view_html');
   GetCheck(CheckBox25,'allow_ie_print');
   GetCheck(CheckBox87,'ftp_enable');

   if RadioButton914.Checked then
     CfgSetBoolValue('disallow_sites',TRUE)
   else
     CfgSetBoolValue('disallow_sites',FALSE);
   GetList1(ListView13,'disallowed_sites');
   GetList1(ListView14,'allowed_sites');
   GetList1(ListView18,'redirected_urls');
   GetEditString(Edit100,'redirection_url');

   GetCheck(CheckBox99,'use_std_downloader');
   GetEditString(Edit86,'std_downloader_sites');
   GetComboIdx(ComboBox11,'max_download_windows');
   GetEditInt(Edit25,'max_download_size',0,9999,0);
   GetCheck(CheckBox112,'allow_run_downloaded');
   GetCheck(CheckBox66,'use_allowed_download_types');
   GetEditString(Edit27,'allowed_download_types');
   GetEditString(Edit65,'download_autorun');
   GetCheck(CheckBox150,'dont_show_download_speed');
   GetEditInt(Edit83,'download_speed_limit',0,9999,0);
   GetList2(ListView11,'autorun_items');
   GetCheck(CheckBox79,'disable_autorun');
   GetEditString(Edit34,'welcome_path');
   GetEditPath(Edit13,'la_startup_path');
   GetCheck(CheckBox30,'show_la_at_startup');
   GetCheck(CheckBox116,'autoplay_cda');
   GetCheck(CheckBox118,'autoplay_cdr');
   GetCheck(CheckBox117,'autoplay_dvd');
   GetCheck(CheckBox53,'autoplay_flash');
   GetEditPath(Edit39,'autoplay_cda_cmd');
   GetEditPath(Edit41,'autoplay_cdr_cmd');
   GetEditPath(Edit40,'autoplay_dvd_cmd');
   GetEditPath(Edit48,'autoplay_flash_cmd');
   GetList1(ListView10,'delete_folders');
   GetCheck(CheckBox94,'clear_recycle_bin');
   GetCheck(CheckBox54,'clean_temp_dir');
   GetCheck(CheckBox55,'clean_ie_dir');
   GetCheck(CheckBox146,'clean_cookies');
   GetCheck(CheckBox4,'clear_print_spooler');
   GetCheck(CheckBox31,'maxvol_enable');
   CfgSetIntValue('maxvol_master',TrackBarMasterMax.Position);
   CfgSetIntValue('maxvol_wave',TrackBarWaveMax.Position);
   CfgSetIntValue('minvol_master',TrackBarMasterMin.Position);
   CfgSetIntValue('minvol_wave',TrackBarWaveMin.Position);
   GetCheck(CheckBox121,'allow_mouse_adj');
   CfgSetIntValue('adj_mouse_speed',TrackBar.Position);

   CfgSetIntValue('adj_mouse_acc',0);
   if RadioButton9.Checked then
     CfgSetIntValue('adj_mouse_acc',0);
   if RadioButton10.Checked then
     CfgSetIntValue('adj_mouse_acc',1);
   if RadioButton11.Checked then
     CfgSetIntValue('adj_mouse_acc',2);
   if RadioButton12.Checked then
     CfgSetIntValue('adj_mouse_acc',3);

   GetCheck(CheckBox154,'do_scandisk');
   GetEditInt(Edit69,'scandisk_hours',1,999,1);
   GetDisksList(CheckListBox4,'scandisk_disks');
   GetCheck(CheckBox131,'use_bodytool_office');
   GetCheck(CheckBox115,'ext_office_print');
   GetCheck(CheckBox122,'protect_run_in_office');
   GetCheck(CheckBox35,'show_office_menu');
   GetCheck(CheckBox132,'use_bodytool_notepad');
   GetEditString(Edit58,'safe_notepad_exts');
   GetCheck(CheckBox134,'use_bodytool_pdf');
   GetCheck(CheckBox138,'show_pdf_panel');
   GetCheck(CheckBox130,'use_bodytool_mp');
   GetEditString(Edit55,'safe_mp_exts');
   GetEditString(Edit56,'safe_mp_protos');
   GetEditString(Edit57,'safe_mp_exts_winamp');
   GetEditPath(Edit61,'alternate_mp');
   GetCheck(CheckBox135,'use_bodytool_swf');
   GetCheck(CheckBox133,'use_bodytool_imgview');
   GetCheck(CheckBox148,'bodymail_integration');
   GetCheck(CheckBox149,'allow_mail_stat');
   GetCheck(CheckBox158,'bodymail_hardcoded');
   GetEditString(Edit62,'bodymail_smtp');
   GetEditInt(Edit74,'bodymail_port',0,65535,25);
   GetEditString(Edit63,'bodymail_user');
   GetEditString(Edit64,'bodymail_password');
   GetEditString(Edit79,'bodymail_from_name');
   GetEditString(Edit80,'bodymail_from_address');
   GetEditString(Edit81,'bodymail_to');
   GetMemoString(Memo81,'bodymail_footer');
   GetCheck(CheckBox119,'burn_integration');
   GetCheck(CheckBox139,'allow_burn_stat');
   GetEditString(Edit42,'law_protected_files');
   GetEditPath(Edit47,'on_burn_complete');
   GetEditPath(Edit52,'net_burn_path');
   GetList1(ListView4,'hide_tm_programs');
   GetCheck(CheckBox16,'safe_taskmgr');
   GetCheck(CheckBox136,'safe_taskmgr2');
   GetCheck(CheckBox137,'safe_taskmgr3');
   GetCheck(CheckBox114,'kill_hidden_tasks');
   GetList2(ListView16,'mobile_content');
   GetEditString(Edit84,'mobile_files_audio');
   GetEditString(Edit87,'mobile_files_video');
   GetEditString(Edit88,'mobile_files_pictures');
   GetCheck(CheckBox165,'mobile_bodyexpl_integration');
   GetCheck(CheckBox144,'bt_integration');
   GetCheck(CheckBox142,'allow_bt_stat');
   GetEditPath(Edit89,'net_bt_path');
   GetCheck(CheckBox140,'allow_scan_stat');
   GetEditString(Edit90,'inject_scan');
   GetCheck(CheckBox20,'tray_mixer');
   GetCheck(CheckBox48,'tray_microphone');
   GetCheck(CheckBox21,'tray_indic');
   GetCheck(CheckBox42,'tray_minimize_all');
   GetCheck(CheckBox26,'allow_photocam');
  end
 else
  begin
   GetCheck(CheckBox78,'used_another_rollback');
   GetDisksList(CheckListBox5,'rollback_disks');
   GetList1(ListView17,'rollback_excl');
   GetCheck(CheckBox77,'use_rollback');

  end;
end;


procedure TSetupVarsForm.CheckInfo;
var uf:string;
    drive:char;
    mask:integer;
begin
 if b_user_settings then
  begin
   uf:=CfgGetPathValue('user_folder_base');
   if uf='' then
    TipForm.ShowTip(0)
   else
    begin
     if (length(uf)>=2) and (uf[2]=':') then
      begin
       drive:=AnsiUpperCase(uf[1])[1];
       if drive in ['A'..'Z'] then
        begin
         mask:=1 shl (ord(drive)-ord('A'));
         if ((mask and CfgGetIntValue('disks_disabled'))<>0) or ((mask and CfgGetIntValue('disks_hidden'))<>0) then
          TipForm.ShowTip(1);
        end;
      end;
    end;
  end;
end;

procedure TSetupVarsForm.TabSheet5Show(Sender: TObject);
begin
 CheckListBox1.ItemIndex:=-1;
end;

procedure TSetupVarsForm.TabSheet6Show(Sender: TObject);
begin
 CheckListBox2.ItemIndex:=-1;
 CheckListBox3.ItemIndex:=-1;
end;

procedure TSetupVarsForm.TabSheet7Show(Sender: TObject);
begin
 ListView1.ItemIndex:=-1;
 ListView7.ItemIndex:=-1;
 Edit6.Text:='';
 Edit11.Text:='';
end;

procedure TSetupVarsForm.TabSheet8Show(Sender: TObject);
begin
 ListView2.ItemIndex:=-1;
 ListView9.ItemIndex:=-1;
 Edit4.Text:='';
 Edit22.Text:='';
end;

procedure TSetupVarsForm.TabSheet9Show(Sender: TObject);
begin
 ListView3.ItemIndex:=-1;
 Edit7.Text:='';
 Edit8.Text:='';
end;

procedure TSetupVarsForm.Button5Click(Sender: TObject);
var n : integer;
begin
 for n:=0 to 25 do
  CheckListBox2.Checked[n]:=TRUE;
end;

procedure TSetupVarsForm.Button6Click(Sender: TObject);
var n : integer;
begin
 for n:=0 to 25 do
  CheckListBox2.Checked[n]:=FALSE;
end;

procedure TSetupVarsForm.Button7Click(Sender: TObject);
var n : integer;
begin
 for n:=0 to 25 do
  CheckListBox3.Checked[n]:=TRUE;
end;

procedure TSetupVarsForm.Button8Click(Sender: TObject);
var n : integer;
begin
 for n:=0 to 25 do
  CheckListBox3.Checked[n]:=FALSE;
end;

procedure TSetupVarsForm.ListView3SelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
 if ListView3.ItemIndex=-1 then
  begin
   Edit7.Text:='';
   Edit8.Text:='';
  end
 else
  begin
   Edit7.Text:=ListView3.Selected.Caption;
   Edit8.Text:=ListView3.Selected.SubItems[0];
  end;
end;

procedure TSetupVarsForm.Edit7Change(Sender: TObject);
begin
 if ListView3.ItemIndex<>-1 then
   ListView3.Selected.Caption:=Edit7.Text;
end;

procedure TSetupVarsForm.Edit8Change(Sender: TObject);
begin
 if ListView3.ItemIndex<>-1 then
   ListView3.Selected.SubItems[0]:=Edit8.Text;
end;

procedure TSetupVarsForm.ListView1SelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
 if ListView1.ItemIndex=-1 then
  begin
   Edit6.Text:='';
  end
 else
  begin
   Edit6.Text:=ListView1.Selected.Caption;
  end;
end;

procedure TSetupVarsForm.Edit6Change(Sender: TObject);
begin
 if ListView1.ItemIndex<>-1 then
   ListView1.Selected.Caption:=Edit6.Text;
end;

procedure TSetupVarsForm.CheckBox18Click(Sender: TObject);
var s:string;
begin
 if not Visible then
  exit;

 if CheckBox18.Checked then
  begin
   s:=GetOpenFile(pchar('EXE Files'#0'*.exe'#0#0),'');
   if s<>'' then
    Label14.Caption:=s
   else
    Label14.Caption:='';
   if Label14.Caption='' then
    CheckBox18.Checked:=FALSE;
  end
 else
  Label14.Caption:='';
end;

procedure TSetupVarsForm.CheckBox19Click(Sender: TObject);
begin
 if Visible then
  begin
   if CheckBox19.Checked then
    begin
     Label16.Caption:=GetFolder();
     if Label16.Caption='' then
      CheckBox19.Checked:=FALSE;
    end
   else
    Label16.Caption:='';
  end;

 Label79.Enabled:=CheckBox19.Checked;
 Label80.Enabled:=CheckBox19.Checked;
 Label87.Enabled:=CheckBox19.Checked;
 ComboBox6.Enabled:=CheckBox19.Checked;
 Edit21.Enabled:=CheckBox19.Checked;
end;

procedure TSetupVarsForm.Button11Click(Sender: TObject);
begin
 WinExec(pchar('"'+GetLocalPath(PATH_CLASSV)+'"'),SW_NORMAL);
end;

procedure TSetupVarsForm.CheckBox24Click(Sender: TObject);
begin
 if not Visible then
  exit;

 if CheckBox24.Checked then
  begin
   Label52.Caption:=GetOpenFile(pchar('AxCmd.EXE'#0'*.exe'#0#0),'AxCmd.exe');
   if Label52.Caption='' then
    CheckBox24.Checked:=FALSE;
  end
 else
  Label52.Caption:='';
end;

procedure TSetupVarsForm.ListView2SelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
 if ListView2.ItemIndex=-1 then
  begin
   Edit4.Text:='';
  end
 else
  begin
   Edit4.Text:=ListView2.Selected.Caption;
  end;
end;

procedure TSetupVarsForm.Edit4Change(Sender: TObject);
begin
 if ListView2.ItemIndex<>-1 then
   ListView2.Selected.Caption:=Edit4.Text;
end;


procedure TSetupVarsForm.CheckBox28Click(Sender: TObject);
begin
 if not Visible then
  exit;

 if CheckBox28.Checked then
  begin
   Label55.Caption:=GetOpenFile(pchar('DTLite.exe'#0'*.exe'#0#0),'DTLite.exe');
   if Label55.Caption='' then
    CheckBox28.Checked:=FALSE;
  end
 else
  Label55.Caption:='';
end;

procedure TSetupVarsForm.TabSheet12Show(Sender: TObject);
begin
 ListView4.ItemIndex:=-1;
 Edit9.Text:='';
end;

procedure TSetupVarsForm.ListView4SelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
 if ListView4.ItemIndex=-1 then
  begin
   Edit9.Text:='';
  end
 else
  begin
   Edit9.Text:=ListView4.Selected.Caption;
  end;
end;

procedure TSetupVarsForm.Edit9Change(Sender: TObject);
begin
 if ListView4.ItemIndex<>-1 then
   ListView4.Selected.Caption:=Edit9.Text;
end;

procedure TSetupVarsForm.CheckBox31Click(Sender: TObject);
begin
 TrackBarMasterMax.Enabled:=CheckBox31.Checked;
 TrackBarWaveMax.Enabled:=CheckBox31.Checked;
 TrackBarMasterMin.Enabled:=CheckBox31.Checked;
 TrackBarWaveMin.Enabled:=CheckBox31.Checked;
end;

procedure TSetupVarsForm.CheckBox36Click(Sender: TObject);
var s:string;
begin
 if not Visible then
  exit;

 if CheckBox36.Checked then
  begin
   s:=GetOpenFile(pchar('WinRAR.EXE, 7z.exe'#0'*.exe'#0#0),'');
   if s<>'' then
    Label66.Caption:=s
   else
    Label66.Caption:='';
   if Label66.Caption='' then
    CheckBox36.Checked:=FALSE;
  end
 else
  Label66.Caption:='';
end;

procedure TSetupVarsForm.CheckBox37Click(Sender: TObject);
var s:string;
begin
 if not Visible then
  exit;

 if CheckBox37.Checked then
  begin
   s:=GetFolder();
   if s<>'' then
    Label67.Caption:=s
   else
    Label67.Caption:='';
   if Label67.Caption='' then
    CheckBox37.Checked:=FALSE;
  end
 else
  Label67.Caption:='';
end;

procedure TSetupVarsForm.TabSheet15Show(Sender: TObject);
begin
 ListView5.ItemIndex:=-1;
 ListView6.ItemIndex:=-1;
 Edit14.Text:='';
 Edit15.Text:='';
 Edit17.Text:='';
 Edit18.Text:='';
end;

procedure TSetupVarsForm.ListView5SelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
 if ListView5.ItemIndex=-1 then
  begin
   Edit14.Text:='';
   Edit15.Text:='';
  end
 else
  begin
   Edit14.Text:=ListView5.Selected.Caption;
   Edit15.Text:=ListView5.Selected.SubItems[0];
  end;
end;

procedure TSetupVarsForm.Edit14Change(Sender: TObject);
begin
 if ListView5.ItemIndex<>-1 then
   ListView5.Selected.Caption:=Edit14.Text;
end;

procedure TSetupVarsForm.Edit15Change(Sender: TObject);
begin
 if ListView5.ItemIndex<>-1 then
   ListView5.Selected.SubItems[0]:=Edit15.Text;
end;

procedure TSetupVarsForm.ListView6SelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
 if ListView6.ItemIndex=-1 then
  begin
   Edit17.Text:='';
   Edit18.Text:='';
  end
 else
  begin
   Edit17.Text:=ListView6.Selected.Caption;
   Edit18.Text:=ListView6.Selected.SubItems[0];
  end;
end;

procedure TSetupVarsForm.Edit17Change(Sender: TObject);
begin
 if ListView6.ItemIndex<>-1 then
   ListView6.Selected.Caption:=Edit17.Text;
end;

procedure TSetupVarsForm.Edit18Change(Sender: TObject);
begin
 if ListView6.ItemIndex<>-1 then
   ListView6.Selected.SubItems[0]:=Edit18.Text;
end;

procedure TSetupVarsForm.TrackBarMasterMaxChange(Sender: TObject);
var curr,other : TTrackBar;
begin
 if not Visible then
  exit;

 curr:=Sender as TTrackBar;
 other:=TrackBarMasterMin;
 if curr.Position < other.Position then
  curr.Position:=other.Position;
end;

procedure TSetupVarsForm.TrackBarWaveMaxChange(Sender: TObject);
var curr,other : TTrackBar;
begin
 if not Visible then
  exit;

 curr:=Sender as TTrackBar;
 other:=TrackBarWaveMin;
 if curr.Position < other.Position then
  curr.Position:=other.Position;
end;

procedure TSetupVarsForm.TrackBarMasterMinChange(Sender: TObject);
var curr,other : TTrackBar;
begin
 if not Visible then
  exit;

 curr:=Sender as TTrackBar;
 other:=TrackBarMasterMax;
 if curr.Position > other.Position then
  curr.Position:=other.Position;
end;

procedure TSetupVarsForm.TrackBarWaveMinChange(Sender: TObject);
var curr,other : TTrackBar;
begin
 if not Visible then
  exit;

 curr:=Sender as TTrackBar;
 other:=TrackBarWaveMax;
 if curr.Position > other.Position then
  curr.Position:=other.Position;
end;

procedure TSetupVarsForm.ListView7SelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
 if ListView7.ItemIndex=-1 then
  begin
   Edit11.Text:='';
  end
 else
  begin
   Edit11.Text:=ListView7.Selected.Caption;
  end;
end;

procedure TSetupVarsForm.Edit11Change(Sender: TObject);
begin
 if ListView7.ItemIndex<>-1 then
   ListView7.Selected.Caption:=Edit11.Text;
end;

procedure TSetupVarsForm.TabSheet16Show(Sender: TObject);
begin
 ListView8.ItemIndex:=-1;
 Edit19.Text:='';
 Edit20.Text:='';
end;

procedure TSetupVarsForm.ListView8SelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
 if ListView8.ItemIndex=-1 then
  begin
   Edit19.Text:='';
   Edit20.Text:='';
  end
 else
  begin
   Edit19.Text:=ListView8.Selected.Caption;
   Edit20.Text:=ListView8.Selected.SubItems[0];
  end;
end;

procedure TSetupVarsForm.Edit19Change(Sender: TObject);
begin
 if ListView8.ItemIndex<>-1 then
   ListView8.Selected.Caption:=Edit19.Text;
end;

procedure TSetupVarsForm.Edit20Change(Sender: TObject);
begin
 if ListView8.ItemIndex<>-1 then
   ListView8.Selected.SubItems[0]:=Edit20.Text;
end;

procedure TSetupVarsForm.CheckBox32Click(Sender: TObject);
begin
 CheckBox37.Enabled:=CheckBox32.Checked;
 Label67.Enabled:=CheckBox32.Checked;
end;

procedure TSetupVarsForm.CheckBox33Click(Sender: TObject);
begin
 CheckBox49.Enabled:=CheckBox33.Checked;
 Label15.Enabled:=CheckBox33.Checked;
end;

procedure TSetupVarsForm.CheckBox49Click(Sender: TObject);
var s:string;
begin
 if not Visible then
  exit;

 if CheckBox49.Checked then
  begin
   s:=GetFolder();
   if s<>'' then
    Label15.Caption:=s
   else
    Label15.Caption:='';
   if Label15.Caption='' then
    CheckBox49.Checked:=FALSE;
  end
 else
  Label15.Caption:='';
end;

procedure TSetupVarsForm.ListView9SelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
 if ListView9.ItemIndex=-1 then
  begin
   Edit22.Text:='';
  end
 else
  begin
   Edit22.Text:=ListView9.Selected.Caption;
  end;
end;

procedure TSetupVarsForm.Edit22Change(Sender: TObject);
begin
 if ListView9.ItemIndex<>-1 then
   ListView9.Selected.Caption:=Edit22.Text;
end;

procedure TSetupVarsForm.CheckBox51Click(Sender: TObject);
begin
 CheckBox52.Enabled:=CheckBox51.Checked;
 Label91.Enabled:=CheckBox51.Checked;
end;

procedure TSetupVarsForm.CheckBox52Click(Sender: TObject);
var s:string;
begin
 if not Visible then
  exit;

 if CheckBox52.Checked then
  begin
   s:=GetFolder();
   if s<>'' then
    Label91.Caption:=s
   else
    Label91.Caption:='';
   if Label91.Caption='' then
    CheckBox52.Checked:=FALSE;
  end
 else
  Label91.Caption:='';
end;

procedure TSetupVarsForm.TabSheet17Show(Sender: TObject);
begin
 ListView10.ItemIndex:=-1;
 Edit24.Text:='';
end;

procedure TSetupVarsForm.ListView10SelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
 if ListView10.ItemIndex=-1 then
  begin
   Edit24.Text:='';
  end
 else
  begin
   Edit24.Text:=ListView10.Selected.Caption;
  end;
end;

procedure TSetupVarsForm.Edit24Change(Sender: TObject);
begin
 if ListView10.ItemIndex<>-1 then
   ListView10.Selected.Caption:=Edit24.Text;
end;

procedure TSetupVarsForm.CheckBox66Click(Sender: TObject);
begin
 Edit27.Enabled:=CheckBox66.Checked;
end;

procedure TSetupVarsForm.TabSheet20Show(Sender: TObject);
begin
 ListView11.ItemIndex:=-1;
 Edit28.Text:='';
 Edit29.Text:='';
end;

procedure TSetupVarsForm.ListView11SelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
 if ListView11.ItemIndex=-1 then
  begin
   Edit28.Text:='';
   Edit29.Text:='';
  end
 else
  begin
   Edit28.Text:=ListView11.Selected.Caption;
   Edit29.Text:=ListView11.Selected.SubItems[0];
  end;
end;

procedure TSetupVarsForm.Edit28Change(Sender: TObject);
begin
 if ListView11.ItemIndex<>-1 then
   ListView11.Selected.Caption:=Edit28.Text;
end;

procedure TSetupVarsForm.Edit29Change(Sender: TObject);
begin
 if ListView11.ItemIndex<>-1 then
   ListView11.Selected.SubItems[0]:=Edit29.Text;
end;

procedure TSetupVarsForm.TabSheet21Show(Sender: TObject);
begin
 ListView12.ItemIndex:=-1;
 Edit30.Text:='';
 Edit31.Text:='';
end;

procedure TSetupVarsForm.ListView12SelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
 if ListView12.ItemIndex=-1 then
  begin
   Edit30.Text:='';
   Edit31.Text:='';
  end
 else
  begin
   Edit30.Text:=ListView12.Selected.Caption;
   Edit31.Text:=ListView12.Selected.SubItems[0];
  end;
end;

procedure TSetupVarsForm.Edit30Change(Sender: TObject);
begin
 if ListView12.ItemIndex<>-1 then
   ListView12.Selected.Caption:=Edit30.Text;
end;

procedure TSetupVarsForm.Edit31Change(Sender: TObject);
begin
 if ListView12.ItemIndex<>-1 then
   ListView12.Selected.SubItems[0]:=Edit31.Text;
end;

procedure TSetupVarsForm.Button12Click(Sender: TObject);
var s:string;
begin
 s:=GetFolder();
 if s<>'' then
  Edit24.Text:=s;
end;

procedure TSetupVarsForm.Button13Click(Sender: TObject);
var s:string;
begin
 s:=GetOpenFile(pchar('EXE Files'#0'*.exe'#0#0),'');
 if s<>'' then
  Edit29.Text:=s;
end;

procedure TSetupVarsForm.Button14Click(Sender: TObject);
var s:string;
begin
 s:=GetFolder();
 if s<>'' then
  Edit20.Text:=s;
end;

procedure TSetupVarsForm.Button15Click(Sender: TObject);
var s:string;
begin
 s:=GetFolder();
 if s<>'' then
  Edit15.Text:=s;
end;

procedure TSetupVarsForm.Button16Click(Sender: TObject);
var s:string;
begin
 s:=GetFolder();
 if s<>'' then
  Edit18.Text:=s;
end;

procedure TSetupVarsForm.Button17Click(Sender: TObject);
var s:string;
begin
 s:=GetOpenFile(pchar('EXE Files'#0'*.exe'#0#0),'');
 if s<>'' then
  Edit31.Text:=s;
end;

procedure TSetupVarsForm.CheckBox116Click(Sender: TObject);
begin
 Edit39.Enabled:=CheckBox116.Checked;
end;

procedure TSetupVarsForm.CheckBox117Click(Sender: TObject);
begin
 Edit40.Enabled:=CheckBox117.Checked;
end;

procedure TSetupVarsForm.CheckBox118Click(Sender: TObject);
begin
 Edit41.Enabled:=CheckBox118.Checked;
end;

procedure TSetupVarsForm.CheckBox121Click(Sender: TObject);
var enb : boolean;
begin
 enb:=CheckBox121.Checked;
 Label21.Enabled:=enb;
 Label117.Enabled:=enb;
 TrackBar.Enabled:=enb;
 RadioButton9.Enabled:=enb;
 RadioButton10.Enabled:=enb;
 RadioButton11.Enabled:=enb;
 RadioButton12.Enabled:=enb;
end;

procedure TSetupVarsForm.TabSheet25Show(Sender: TObject);
begin
 ListView13.ItemIndex:=-1;
 ListView14.ItemIndex:=-1;
 Edit93.Text:='';
end;

procedure TSetupVarsForm.ListView13SelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
 if ListView13.ItemIndex=-1 then
  begin
   Edit93.Text:='';
  end
 else
  begin
   Edit93.Text:=ListView13.Selected.Caption;
  end;
end;

procedure TSetupVarsForm.ListView14SelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
 if ListView14.ItemIndex=-1 then
  begin
   Edit93.Text:='';
  end
 else
  begin
   Edit93.Text:=ListView14.Selected.Caption;
  end;
end;

procedure TSetupVarsForm.Edit93Change(Sender: TObject);
begin
 if ListView13.Enabled then
  begin
   if ListView13.ItemIndex<>-1 then
     ListView13.Selected.Caption:=Edit93.Text;
  end
 else
  begin
   if ListView14.ItemIndex<>-1 then
     ListView14.Selected.Caption:=Edit93.Text;
  end;
end;

procedure TSetupVarsForm.RadioButton913Click(Sender: TObject);
begin
 //if visible then
  begin
   if RadioButton913.Checked then
    begin
     ListView13.ItemIndex:=-1;
     ListView14.ItemIndex:=-1;
     ListView13.Enabled:=TRUE;
     ListView14.Enabled:=FALSE;
     Edit93.Text:='';
    end;
  end;
end;

procedure TSetupVarsForm.RadioButton914Click(Sender: TObject);
begin
 //if visible then
  begin
   if RadioButton914.Checked then
    begin
     ListView13.ItemIndex:=-1;
     ListView14.ItemIndex:=-1;
     ListView13.Enabled:=FALSE;
     ListView14.Enabled:=TRUE;
     Edit93.Text:='';
    end;
  end;
end;

procedure TSetupVarsForm.CheckBox53Click(Sender: TObject);
begin
 Edit48.Enabled:=CheckBox53.Checked;
end;

procedure TSetupVarsForm.Button19Click(Sender: TObject);
var s:string;
begin
  s:=GetOpenFile(pchar('TXT Files'#0'*.txt'#0#0),'');
  if s<>'' then
   begin
    Memo1.Text:=s;
   end;
end;

procedure TSetupVarsForm.Button20Click(Sender: TObject);
begin
 Memo1.Text:='';
end;

procedure TSetupVarsForm.CheckBox89Click(Sender: TObject);
begin
 CheckBox90.Enabled:=CheckBox89.Checked;
 CheckBox91.Enabled:=CheckBox89.Checked;
 CheckBox92.Enabled:=CheckBox89.Checked;
end;

procedure TSetupVarsForm.CheckBox93Click(Sender: TObject);
begin
 if CheckBox93.Checked then
  begin
   Label110.Enabled:=true;
   Edit52.Enabled:=true;
   Button22.Enabled:=true;
  end
 else
  begin
   Edit52.Text:='';
   Label110.Enabled:=false;
   Edit52.Enabled:=false;
   Button22.Enabled:=false;
  end;
end;

procedure TSetupVarsForm.Button22Click(Sender: TObject);
var s:string;
begin
 s:=GetFolder();
 if s<>'' then
  Edit52.Text:=s;
end;

procedure TSetupVarsForm.Button24Click(Sender: TObject);
var s:string;
begin
 s:=GetOpenFile(pchar('Video, Flash, Pictures'#0'*.avi;*.mpg;*.mpeg;*.wmv;*.swf;*.jpg;*.jpe;*.jpeg;*.bmp;*.png;*.tif;*.tiff;*.gif'#0#0),'');
 if s<>'' then
  Label147.Caption:=s;
end;

procedure TSetupVarsForm.Button25Click(Sender: TObject);
var s:string;
begin
 s:=GetFolder();
 if s<>'' then
  Label147.Caption:=s;
end;

procedure TSetupVarsForm.Button26Click(Sender: TObject);
begin
 Label147.Caption:='';
end;

procedure TSetupVarsForm.CheckBox96Click(Sender: TObject);
begin
 if visible then
  if CheckBox96.Checked then
    MessageBox(Handle,S_BLOCKWARN,S_INFO,MB_OK or MB_ICONWARNING);
end;

procedure TSetupVarsForm.Button27Click(Sender: TObject);
var s:string;
begin
 s:=GetOpenFile(pchar('EXE'#0'*.exe'#0#0),'');
 if s<>'' then
  Edit61.Text:=s;
end;

procedure TSetupVarsForm.RadioButton6Click(Sender: TObject);
begin
 if RadioButton6.Checked then
   Label160.Caption:='';
end;

procedure TSetupVarsForm.RadioButton7Click(Sender: TObject);
begin
 if RadioButton7.Checked then
   Label160.Caption:='$default';
end;

procedure TSetupVarsForm.RadioButton8Click(Sender: TObject);
begin
 if RadioButton8.Checked then
   Label160.Caption:='$user_folder';
end;

procedure TSetupVarsForm.RadioButton13Click(Sender: TObject);
var s:string;
begin
 if visible then
  begin
   if RadioButton13.Checked then
    begin
     s:=GetFolder();
     if s<>'' then
       Label160.Caption:=s
     else
      begin
       Label160.Caption:='';
       RadioButton6.Checked:=true;
       RadioButton6.SetFocus;
      end;
    end;
  end;
end;

procedure TSetupVarsForm.CheckBox154Click(Sender: TObject);
begin
 Label170.Enabled:=CheckBox154.Checked;
 Edit69.Enabled:=CheckBox154.Checked;
 CheckListBox4.Enabled:=CheckBox154.Checked;
end;

procedure TSetupVarsForm.CheckBox155Click(Sender: TObject);
begin
 Edit70.Enabled:=not CheckBox155.Checked;
 Edit71.Enabled:=not CheckBox155.Checked;
 Edit91.Enabled:=not CheckBox155.Checked;
 Edit92.Enabled:=not CheckBox155.Checked;
 Label172.Enabled:=not CheckBox155.Checked;
 Label173.Enabled:=not CheckBox155.Checked;
 Label100.Enabled:=not CheckBox155.Checked;
 Label76.Enabled:=not CheckBox155.Checked;
end;

procedure TSetupVarsForm.TabSheet37Show(Sender: TObject);
begin
 ListView15.ItemIndex:=-1;
 Edit72.Text:='';
 Edit73.Text:='';
end;

procedure TSetupVarsForm.ListView15SelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
 if ListView15.ItemIndex=-1 then
  begin
   Edit72.Text:='';
   Edit73.Text:='';
  end
 else
  begin
   Edit72.Text:=ListView15.Selected.Caption;
   Edit73.Text:=ListView15.Selected.SubItems[0];
  end;
end;

procedure TSetupVarsForm.Edit72Change(Sender: TObject);
begin
 if ListView15.ItemIndex<>-1 then
   ListView15.Selected.Caption:=Edit72.Text;
end;

procedure TSetupVarsForm.Edit73Change(Sender: TObject);
begin
 if ListView15.ItemIndex<>-1 then
   ListView15.Selected.SubItems[0]:=Edit73.Text;
end;

procedure TSetupVarsForm.CheckBox157Click(Sender: TObject);
begin
 Label182.Enabled:=CheckBox157.Checked;
 Label183.Enabled:=CheckBox157.Checked;
 Label184.Enabled:=CheckBox157.Checked;
 Edit76.Enabled:=CheckBox157.Checked;
 Edit77.Enabled:=CheckBox157.Checked;
 Edit78.Enabled:=CheckBox157.Checked;
end;

procedure TSetupVarsForm.CheckBox158Click(Sender: TObject);
begin
 Label185.Enabled:=CheckBox158.Checked;
 Label202.Enabled:=CheckBox158.Checked;
 Label186.Enabled:=CheckBox158.Checked;
 Label187.Enabled:=CheckBox158.Checked;
 Edit79.Enabled:=CheckBox158.Checked;
 Edit80.Enabled:=CheckBox158.Checked;
 Edit81.Enabled:=CheckBox158.Checked;
 Memo81.Enabled:=CheckBox158.Checked;
end;

procedure TSetupVarsForm.CheckBox162Click(Sender: TObject);
begin
 if Visible then
  begin
   if CheckBox162.Checked then
    begin
     Label72.Caption:=GetFolder();
     if Label72.Caption='' then
      CheckBox162.Checked:=FALSE;
    end
   else
    Label72.Caption:='';
  end;

 Label194.Enabled:=CheckBox162.Checked;
 Edit85.Enabled:=CheckBox162.Checked;
end;

procedure TSetupVarsForm.TabSheet38Show(Sender: TObject);
begin
 ListView16.ItemIndex:=-1;
 Edit50.Text:='';
 Edit51.Text:='';
end;

procedure TSetupVarsForm.Button21Click(Sender: TObject);
var s:string;
begin
 s:=GetFolder();
 if s<>'' then
  Edit51.Text:=s;
end;

procedure TSetupVarsForm.ListView16SelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
 if ListView16.ItemIndex=-1 then
  begin
   Edit50.Text:='';
   Edit51.Text:='';
  end
 else
  begin
   Edit50.Text:=ListView16.Selected.Caption;
   Edit51.Text:=ListView16.Selected.SubItems[0];
  end;
end;

procedure TSetupVarsForm.Edit50Change(Sender: TObject);
begin
 if ListView16.ItemIndex<>-1 then
   ListView16.Selected.Caption:=Edit50.Text;
end;

procedure TSetupVarsForm.Edit51Change(Sender: TObject);
begin
 if ListView16.ItemIndex<>-1 then
   ListView16.Selected.SubItems[0]:=Edit51.Text;
end;

procedure TSetupVarsForm.Button28Click(Sender: TObject);
var s:string;
begin
 s:=GetFolder();
 if s<>'' then
  Edit89.Text:=s;
end;

procedure TSetupVarsForm.CheckBox166Click(Sender: TObject);
begin
 if CheckBox166.Checked then
  begin
   Label200.Enabled:=true;
   Edit89.Enabled:=true;
   Button28.Enabled:=true;
  end
 else
  begin
   Edit89.Text:='';
   Label200.Enabled:=false;
   Edit89.Enabled:=false;
   Button28.Enabled:=false;
  end;
end;

procedure TSetupVarsForm.Panel2Click(Sender: TObject);
begin
 ColorDialog1.Color:=Panel2.Color;
 if ColorDialog1.Execute then
  Panel2.Color:=ColorDialog1.Color;
end;


procedure TSetupVarsForm.TabSheet39Show(Sender: TObject);
begin
 CheckListBox4.ItemIndex:=-1;
end;

procedure TSetupVarsForm.CheckBox3Click(Sender: TObject);
begin
 if Visible then
  begin
   if CheckBox3.Checked then
    begin
     Label4.Caption:=GetFolder();
     if Label4.Caption='' then
      CheckBox3.Checked:=FALSE;
    end
   else
    Label4.Caption:='';
  end;
end;

procedure TSetupVarsForm.CheckBox5Click(Sender: TObject);
begin
 if not Visible then
  exit;

 if CheckBox5.Checked then
  begin
   Label6.Caption:=GetOpenFile(pchar('DTAgent.exe'#0'*.exe'#0#0),'DTAgent.exe');
   if Label6.Caption='' then
    CheckBox5.Checked:=FALSE;
  end
 else
  Label6.Caption:='';
end;

procedure TSetupVarsForm.CheckBox30Click(Sender: TObject);
begin
 Edit13.Enabled:=CheckBox30.Checked;
 Button1.Enabled:=CheckBox30.Checked;
end;

procedure TSetupVarsForm.Button1Click(Sender: TObject);
var s:string;
begin
 s:=GetOpenFile(pchar('HTML/RTF Files'#0'*.html;*.htm;*.rtf'#0#0),'');
 if s<>'' then
  Edit13.Text:=s;
end;

procedure TSetupVarsForm.Label35Click(Sender: TObject);
begin
 ShellExecute(0,nil,'http://www.ibutton.com',nil,nil,SW_SHOWNORMAL);
end;

procedure TSetupVarsForm.Label36Click(Sender: TObject);
begin
 ShellExecute(0,nil,'http://www.aladdin.ru',nil,nil,SW_SHOWNORMAL);
end;

procedure TSetupVarsForm.CheckBox129Click(Sender: TObject);
begin
 if visible then
  begin
   if CheckBox129.Checked then
    MessageBox(handle,'Не забудьте также включить запрет на окно с классом IEFrame'#13#10'см. вкладку "Безопасность: Окна"','Информация',MB_OK or MB_ICONINFORMATION)
   else
    MessageBox(handle,'Необходимо также отключить запрет на окно с классом IEFrame'#13#10'см. вкладку "Безопасность: Окна"','Информация',MB_OK or MB_ICONINFORMATION);
  end;
end;

procedure TSetupVarsForm.CheckBox46Click(Sender: TObject);
var b_enabled:boolean;
begin
 b_enabled:=CheckBox46.Checked;

 ComboBox5.Enabled:=b_enabled;
 ComboBox9.Enabled:=b_enabled;
 ComboBox12.Enabled:=b_enabled;
 Panel48.Enabled:=b_enabled;
end;

procedure TSetupVarsForm.RadioButton1Click(Sender: TObject);
begin
 Panel49.Enabled:=true;
end;

procedure TSetupVarsForm.CheckBox47Click(Sender: TObject);
var s1,s2:string;
    msg:string;
    t:array[0..MAX_PATH] of char;
begin
 if visible then
  begin
   if CheckBox47.Checked then
    begin
     s1:=Edit23.Text;
     s2:=Edit26.Text;
     if AnsiCompareText(s1,s2)<>0 then
      begin
       MessageBox(Handle,S_DIFFERENTPWDS,S_ERR,MB_OK or MB_ICONERROR);
       CheckBox47.Checked:=false;
      end
     else
      begin
       if s1='' then
        msg:=S_DISABLEPWD
       else
        msg:=S_SETPWD;
       if MessageBox(Handle,pchar(msg),S_QUESTION,MB_OKCANCEL or MB_ICONQUESTION)=IDOK then
        begin
         Edit23.Enabled:=false;
         Edit23.Color:=clGray;
         Edit26.Enabled:=false;
         Edit26.Color:=clGray;
         CheckBox47.Enabled:=false;

         if s1='' then
          begin
           Edit37.Text:='';
          end
         else
          begin
           t[0]:=#0;
           CfgStr2MD5(pchar(AnsiLowerCase(s1)),t);
           Edit37.Text:=t;
          end;
        end
       else
        begin
         Edit23.Text:='';
         Edit26.Text:='';
         CheckBox47.Checked:=false;
        end;
      end;
    end;
  end;
end;

procedure TSetupVarsForm.ComboBox13Change(Sender: TObject);
var dis:boolean;
    idx,n,count:integer;
    find:boolean;
begin
 idx:=ComboBox13.ItemIndex;
 dis:=(idx<=0);

 Label3.Enabled:=not dis;
 Memo1.Enabled:=not dis;
 Button19.Enabled:=not dis;
 Button20.Enabled:=not dis;
 Label134.Enabled:=not dis;
 Edit49.Enabled:=not dis;
 CheckBox8.Enabled:=not dis;
 CheckBox65.Enabled:=not dis;

 Edit38.Enabled:=(idx=1);

 if visible then
  begin
   find:=false;
   count:=sizeof(desk_themes) div sizeof(desk_themes[0]);
   for n:=0 to count-1 do
    begin
     if desk_themes[n].combo_idx=idx then
      begin
       Edit38.Text:=desk_themes[n].path;
       Panel2.Color:=desk_themes[n].color;
       find:=true;
       break;
      end;
    end;
   if not find then
    begin
     Edit38.Text:=S_ENTERTHEMEURL;
     try
      Edit38.SetFocus;
     except end;
    end;
  end;
end;

procedure TSetupVarsForm.CheckBox75Click(Sender: TObject);
begin
 Edit68.Enabled:=CheckBox75.Checked;
 ComboBox1.Enabled:=CheckBox75.Checked;
end;

procedure TSetupVarsForm.TabSheet47Show(Sender: TObject);
begin
 CheckListBox5.ItemIndex:=-1;
end;

procedure TSetupVarsForm.TabSheet48Show(Sender: TObject);
begin
 ListView17.ItemIndex:=-1;
 Edit82.Text:='';
end;

procedure TSetupVarsForm.ListView17SelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
begin
 if ListView17.ItemIndex=-1 then
  begin
   Edit82.Text:='';
  end
 else
  begin
   Edit82.Text:=ListView17.Selected.Caption;
  end;
end;

procedure TSetupVarsForm.Edit82Change(Sender: TObject);
begin
 if ListView17.ItemIndex<>-1 then
   ListView17.Selected.Caption:=Edit82.Text;
end;

procedure TSetupVarsForm.Button2Click(Sender: TObject);
var s:string;
begin
 s:=GetFolder();
 if s<>'' then
  Edit82.Text:=s;
end;

procedure TSetupVarsForm.TabSheet51Show(Sender: TObject);
begin
 ListView18.ItemIndex:=-1;
 Edit99.Text:='';
end;

procedure TSetupVarsForm.ListView18SelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
begin
 if ListView18.ItemIndex=-1 then
  begin
   Edit99.Text:='';
  end
 else
  begin
   Edit99.Text:=ListView18.Selected.Caption;
  end;
end;

procedure TSetupVarsForm.Edit99Change(Sender: TObject);
begin
 if ListView18.ItemIndex<>-1 then
   ListView18.Selected.Caption:=Edit99.Text;
end;

procedure TSetupVarsForm.CheckBox56Click(Sender: TObject);
var b_enabled:boolean;
begin
 b_enabled:=CheckBox56.Checked;

 Memo2.Enabled:=b_enabled;
 Button4.Enabled:=b_enabled;
end;

procedure TSetupVarsForm.Button4Click(Sender: TObject);
var h:cardinal;
    idx:integer;
    t:array[0..MAX_PATH-1] of char;
    s:string;
begin
 h:=DLL_CreateFlashDrivesEnumerator();
 idx:=0;
 while DLL_GetNextFlashDrive(h,@idx,t,sizeof(t)) do
  begin
   s:=t;
   if Memo2.Lines.IndexOf(s)=-1 then
    Memo2.Lines.Add(s);
  end;
 DLL_DestroyFlashDrivesEnumerator(h);
end;

end.
