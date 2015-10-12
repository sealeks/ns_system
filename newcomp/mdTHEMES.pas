{
 -----------------------------------------------------------------------------

 MODUL          mdTHEMES.PAS

 COPYRIGHT      micro dynamics GmbH
 AUTHOR(S)      Michael Frank
 UPDATE         30.06.2002

 COMPILER       Delphi 5/6
 PLATFORM       Windows 95/98/Me/NT4/2000/XP

 DESCRIPTION    Windows XP Visual Styles API

 -----------------------------------------------------------------------------
 Revision History:   Original Version  12.01

 30.06.2002     Version 2.20
 18.06.2002     Version 2.10
 08.06.2002	Version 2.00
 11.01.2002	Version 1.10
 29.12.2001	Version 1.00
 -----------------------------------------------------------------------------
}
unit mdTHEMES;

//============================================================================

interface

//============================================================================

uses
  Windows, Graphics;

const
  {$EXTERNALSYM WM_THEMECHANGED}
  WM_THEMECHANGED = $031A;

//----------------------------------------------------------------------------
// "Button" Parts and States
//----------------------------------------------------------------------------

  {$EXTERNALSYM BP_PUSHBUTTON}
  BP_PUSHBUTTON = 1;
  {$EXTERNALSYM BP_RADIOBUTTON}
  BP_RADIOBUTTON = 2;
  {$EXTERNALSYM BP_CHECKBOX}
  BP_CHECKBOX = 3;
  {$EXTERNALSYM BP_GROUPBOX}
  BP_GROUPBOX = 4;
  {$EXTERNALSYM BP_USERBUTTON}
  BP_USERBUTTON = 5;

  {$EXTERNALSYM PBS_NORMAL}
  PBS_NORMAL = 1;
  {$EXTERNALSYM PBS_HOT}
  PBS_HOT = 2;
  {$EXTERNALSYM PBS_PRESSED}
  PBS_PRESSED = 3;
  {$EXTERNALSYM PBS_DISABLED}
  PBS_DISABLED = 4;
  {$EXTERNALSYM PBS_DEFAULTED}
  PBS_DEFAULTED = 5;

  {$EXTERNALSYM RBS_UNCHECKEDNORMAL}
  RBS_UNCHECKEDNORMAL = 1;
  {$EXTERNALSYM RBS_UNCHECKEDHOT}
  RBS_UNCHECKEDHOT = 2;
  {$EXTERNALSYM RBS_UNCHECKEDPRESSED}
  RBS_UNCHECKEDPRESSED = 3;
  {$EXTERNALSYM RBS_UNCHECKEDDISABLED}
  RBS_UNCHECKEDDISABLED = 4;
  {$EXTERNALSYM RBS_CHECKEDNORMAL}
  RBS_CHECKEDNORMAL = 5;
  {$EXTERNALSYM RBS_CHECKEDHOT}
  RBS_CHECKEDHOT = 6;
  {$EXTERNALSYM RBS_CHECKEDPRESSED}
  RBS_CHECKEDPRESSED = 7;
  {$EXTERNALSYM RBS_CHECKEDDISABLED}
  RBS_CHECKEDDISABLED = 8;

  {$EXTERNALSYM CBS_UNCHECKEDNORMAL}
  CBS_UNCHECKEDNORMAL = 1;
  {$EXTERNALSYM CBS_UNCHECKEDHOT}
  CBS_UNCHECKEDHOT = 2;
  {$EXTERNALSYM CBS_UNCHECKEDPRESSED}
  CBS_UNCHECKEDPRESSED = 3;
  {$EXTERNALSYM CBS_UNCHECKEDDISABLED}
  CBS_UNCHECKEDDISABLED = 4;
  {$EXTERNALSYM CBS_CHECKEDNORMAL}
  CBS_CHECKEDNORMAL = 5;
  {$EXTERNALSYM CBS_CHECKEDHOT}
  CBS_CHECKEDHOT = 6;
  {$EXTERNALSYM CBS_CHECKEDPRESSED}
  CBS_CHECKEDPRESSED = 7;
  {$EXTERNALSYM CBS_CHECKEDDISABLED}
  CBS_CHECKEDDISABLED = 8;
  {$EXTERNALSYM CBS_MIXEDNORMAL}
  CBS_MIXEDNORMAL = 9;
  {$EXTERNALSYM CBS_MIXEDHOT}
  CBS_MIXEDHOT = 10;
  {$EXTERNALSYM CBS_MIXEDPRESSED}
  CBS_MIXEDPRESSED = 11;
  {$EXTERNALSYM CBS_MIXEDDISABLED}
  CBS_MIXEDDISABLED = 12;

  {$EXTERNALSYM GBS_NORMAL}
  GBS_NORMAL = 1;
  {$EXTERNALSYM GBS_DISABLED}
  GBS_DISABLED = 2;

//----------------------------------------------------------------------------
// "Clock" Parts and States
//----------------------------------------------------------------------------

  {$EXTERNALSYM CLP_TIME}
  CLP_TIME = 1;

  {$EXTERNALSYM CLS_NORMAL}
  CLS_NORMAL = 1;

//----------------------------------------------------------------------------
// "ComboBox" Parts & States
//----------------------------------------------------------------------------

  {$EXTERNALSYM CP_DROPDOWNBUTTON}
  CP_DROPDOWNBUTTON = 1;

  {$EXTERNALSYM CBXS_NORMAL}
  CBXS_NORMAL = 1;
  {$EXTERNALSYM CBXS_HOT}
  CBXS_HOT = 2;
  {$EXTERNALSYM CBXS_PRESSED}
  CBXS_PRESSED = 3;
  {$EXTERNALSYM CBXS_DISABLED}
  CBXS_DISABLED = 4;

//----------------------------------------------------------------------------
// "Edit" Parts and States
//----------------------------------------------------------------------------

  {$EXTERNALSYM EP_EDITTEXT}
  EP_EDITTEXT = 1;
  {$EXTERNALSYM EP_CARET}
  EP_CARET = 2;

  {$EXTERNALSYM ETS_NORMAL}
  ETS_NORMAL = 1;
  {$EXTERNALSYM ETS_HOT}
  ETS_HOT = 2;
  {$EXTERNALSYM ETS_SELECTED}
  ETS_SELECTED = 3;
  {$EXTERNALSYM ETS_DISABLED}
  ETS_DISABLED = 4;
  {$EXTERNALSYM ETS_FOCUSED}
  ETS_FOCUSED = 5;
  {$EXTERNALSYM ETS_READONLY}
  ETS_READONLY = 6;
  {$EXTERNALSYM ETS_ASSIST}
  ETS_ASSIST = 7;

//----------------------------------------------------------------------------
// "ExplorerBar" Parts and States
//----------------------------------------------------------------------------

  {$EXTERNALSYM EBP_HEADERBACKGROUND}
  EBP_HEADERBACKGROUND = 1;
  {$EXTERNALSYM EBP_HEADERCLOSE}
  EBP_HEADERCLOSE = 2;
  {$EXTERNALSYM EBP_HEADERPIN}
  EBP_HEADERPIN = 3;
  {$EXTERNALSYM EBP_IEBARMENU}
  EBP_IEBARMENU = 4;
  {$EXTERNALSYM EBP_NORMALGROUPBACKGROUND}
  EBP_NORMALGROUPBACKGROUND = 5;
  {$EXTERNALSYM EBP_NORMALGROUPCOLLAPSE}
  EBP_NORMALGROUPCOLLAPSE = 6;
  {$EXTERNALSYM EBP_NORMALGROUPEXPAND}
  EBP_NORMALGROUPEXPAND = 7;
  {$EXTERNALSYM EBP_NORMALGROUPHEAD}
  EBP_NORMALGROUPHEAD = 8;
  {$EXTERNALSYM EBP_SPECIALGROUPBACKGROUND}
  EBP_SPECIALGROUPBACKGROUND = 9;
  {$EXTERNALSYM EBP_SPECIALGROUPCOLLAPSE}
  EBP_SPECIALGROUPCOLLAPSE = 10;
  {$EXTERNALSYM EBP_SPECIALGROUPEXPAND}
  EBP_SPECIALGROUPEXPAND = 11;
  {$EXTERNALSYM EBP_SPECIALGROUPHEAD}
  EBP_SPECIALGROUPHEAD = 12;

  {$EXTERNALSYM EBHC_NORMAL}
  EBHC_NORMAL = 1;
  {$EXTERNALSYM EBHC_HOT}
  EBHC_HOT = 2;
  {$EXTERNALSYM EBHC_PRESSED}
  EBHC_PRESSED = 3;

  {$EXTERNALSYM EBHP_NORMAL}
  EBHP_NORMAL = 1;
  {$EXTERNALSYM EBHP_HOT}
  EBHP_HOT = 2;
  {$EXTERNALSYM EBHP_PRESSED}
  EBHP_PRESSED = 3;
  {$EXTERNALSYM EBHP_SELECTEDNORMAL}
  EBHP_SELECTEDNORMAL = 4;
  {$EXTERNALSYM EBHP_SELECTEDHOT}
  EBHP_SELECTEDHOT = 5;
  {$EXTERNALSYM EBHP_SELECTEDPRESSED}
  EBHP_SELECTEDPRESSED = 6;

  {$EXTERNALSYM EBM_NORMAL}
  EBM_NORMAL = 1;
  {$EXTERNALSYM EBM_HOT}
  EBM_HOT = 2;
  {$EXTERNALSYM EBM_PRESSED}
  EBM_PRESSED = 3;

  {$EXTERNALSYM EBNGC_NORMAL}
  EBNGC_NORMAL = 1;
  {$EXTERNALSYM EBNGC_HOT}
  EBNGC_HOT = 2;
  {$EXTERNALSYM EBNGC_PRESSED}
  EBNGC_PRESSED = 3;

  {$EXTERNALSYM EBNGE_NORMAL}
  EBNGE_NORMAL = 1;
  {$EXTERNALSYM EBNGE_HOT}
  EBNGE_HOT = 2;
  {$EXTERNALSYM EBNGE_PRESSED}
  EBNGE_PRESSED = 3;

  {$EXTERNALSYM EBSGC_NORMAL}
  EBSGC_NORMAL = 1;
  {$EXTERNALSYM EBSGC_HOT}
  EBSGC_HOT = 2;
  {$EXTERNALSYM EBSGC_PRESSED}
  EBSGC_PRESSED = 3;

  {$EXTERNALSYM EBSGE_NORMAL}
  EBSGE_NORMAL = 1;
  {$EXTERNALSYM EBSGE_HOT}
  EBSGE_HOT = 2;
  {$EXTERNALSYM EBSGE_PRESSED}
  EBSGE_PRESSED = 3;

//----------------------------------------------------------------------------
// "Header" Parts and States
//----------------------------------------------------------------------------

  {$EXTERNALSYM HP_HEADERITEM}
  HP_HEADERITEM = 1;
  {$EXTERNALSYM HP_HEADERITEMLEFT}
  HP_HEADERITEMLEFT = 2;
  {$EXTERNALSYM HP_HEADERITEMRIGHT}
  HP_HEADERITEMRIGHT = 3;
  {$EXTERNALSYM HP_HEADERSORTARROW}
  HP_HEADERSORTARROW = 4;

  {$EXTERNALSYM HIS_NORMAL}
  HIS_NORMAL = 1;
  {$EXTERNALSYM HIS_HOT}
  HIS_HOT = 2;
  {$EXTERNALSYM HIS_PRESSED}
  HIS_PRESSED = 3;

  {$EXTERNALSYM HILS_NORMAL}
  HILS_NORMAL = 1;
  {$EXTERNALSYM HILS_HOT}
  HILS_HOT = 2;
  {$EXTERNALSYM HILS_PRESSED}
  HILS_PRESSED = 3;

  {$EXTERNALSYM HIRS_NORMAL}
  HIRS_NORMAL = 1;
  {$EXTERNALSYM HIRS_HOT}
  HIRS_HOT = 2;
  {$EXTERNALSYM HIRS_PRESSED}
  HIRS_PRESSED = 3;

  {$EXTERNALSYM HSAS_SORTEDUP}
  HSAS_SORTEDUP = 1;
  {$EXTERNALSYM HSAS_SORTEDDOWN}
  HSAS_SORTEDDOWN = 2;

//----------------------------------------------------------------------------
// "ListView" Parts and States
//----------------------------------------------------------------------------

  {$EXTERNALSYM LVP_LISTITEM}
  LVP_LISTITEM = 1;
  {$EXTERNALSYM LVP_LISTGROUP}
  LVP_LISTGROUP = 2;
  {$EXTERNALSYM LVP_LISTDETAIL}
  LVP_LISTDETAIL = 3;
  {$EXTERNALSYM LVP_LISTSORTEDDETAIL}
  LVP_LISTSORTEDDETAIL = 4;
  {$EXTERNALSYM LVP_EMPTYTEXT}
  LVP_EMPTYTEXT = 5;

  {$EXTERNALSYM LIS_NORMAL}
  LIS_NORMAL = 1;
  {$EXTERNALSYM LIS_HOT}
  LIS_HOT = 2;
  {$EXTERNALSYM LIS_SELECTED}
  LIS_SELECTED = 3;
  {$EXTERNALSYM LIS_DISABLED}
  LIS_DISABLED = 4;
  {$EXTERNALSYM LIS_SELECTEDNOTFOCUS}
  LIS_SELECTEDNOTFOCUS = 5;

//----------------------------------------------------------------------------
// "Menu" Parts and States
//----------------------------------------------------------------------------

  {$EXTERNALSYM MP_MENUITEM}
  MP_MENUITEM = 1;
  {$EXTERNALSYM MP_MENUDROPDOWN}
  MP_MENUDROPDOWN = 2;
  {$EXTERNALSYM MP_MENUBARITEM}
  MP_MENUBARITEM = 3;
  {$EXTERNALSYM MP_MENUBARDROPDOWN}
  MP_MENUBARDROPDOWN = 4;
  {$EXTERNALSYM MP_CHEVRON}
  MP_CHEVRON = 5;
  {$EXTERNALSYM MP_SEPARATOR}
  MP_SEPARATOR = 6;

  {$EXTERNALSYM MS_NORMAL}
  MS_NORMAL = 1;
  {$EXTERNALSYM MS_SELECTED}
  MS_SELECTED = 2;
  {$EXTERNALSYM MS_DEMOTED}
  MS_DEMOTED = 3;

//----------------------------------------------------------------------------
// "MenuBand" Parts and States
//----------------------------------------------------------------------------

  {$EXTERNALSYM MDP_NEWAPPBUTTON}
  MDP_NEWAPPBUTTON = 1;
  {$EXTERNALSYM MDP_SEPARATOR}
  MDP_SEPARATOR = 2;

  {$EXTERNALSYM MDS_NORMAL}
  MDS_NORMAL = 1;
  {$EXTERNALSYM MDS_HOT}
  MDS_HOT = 2;
  {$EXTERNALSYM MDS_PRESSED}
  MDS_PRESSED = 3;
  {$EXTERNALSYM MDS_DISABLED}
  MDS_DISABLED = 4;
  {$EXTERNALSYM MDS_CHECKED}
  MDS_CHECKED = 5;
  {$EXTERNALSYM MDS_HOTCHECKED}
  MDS_HOTCHECKED = 6;

//----------------------------------------------------------------------------
// "Page" Parts and States
//----------------------------------------------------------------------------

  {$EXTERNALSYM PGRP_UP}
  PGRP_UP = 1;
  {$EXTERNALSYM PGRP_DOWN}
  PGRP_DOWN = 2;
  {$EXTERNALSYM PGRP_UPHORZ}
  PGRP_UPHORZ = 3;
  {$EXTERNALSYM PGRP_DOWNHORZ}
  PGRP_DOWNHORZ = 4;

  {$EXTERNALSYM DNS_NORMAL}
  DNS_NORMAL = 1;
  {$EXTERNALSYM DNS_HOT}
  DNS_HOT = 2;
  {$EXTERNALSYM DNS_PRESSED}
  DNS_PRESSED = 3;
  {$EXTERNALSYM DNS_DISABLED}
  DNS_DISABLED = 4;

  {$EXTERNALSYM DNHZS_NORMAL}
  DNHZS_NORMAL = 1;
  {$EXTERNALSYM DNHZS_HOT}
  DNHZS_HOT = 2;
  {$EXTERNALSYM DNHZS_PRESSED}
  DNHZS_PRESSED = 3;
  {$EXTERNALSYM DNHZS_DISABLED}
  DNHZS_DISABLED = 4;

  {$EXTERNALSYM UPS_NORMAL}
  UPS_NORMAL = 1;
  {$EXTERNALSYM UPS_HOT}
  UPS_HOT = 2;
  {$EXTERNALSYM UPS_PRESSED}
  UPS_PRESSED = 3;
  {$EXTERNALSYM UPS_DISABLED}
  UPS_DISABLED = 4;

  {$EXTERNALSYM UPHZS_NORMAL}
  UPHZS_NORMAL = 1;
  {$EXTERNALSYM UPHZS_HOT}
  UPHZS_HOT = 2;
  {$EXTERNALSYM UPHZS_PRESSED}
  UPHZS_PRESSED = 3;
  {$EXTERNALSYM UPHZS_DISABLED}
  UPHZS_DISABLED = 4;

//----------------------------------------------------------------------------
// "Progress" Parts and States
//----------------------------------------------------------------------------

  {$EXTERNALSYM PP_BAR}
  PP_BAR = 1;
  {$EXTERNALSYM PP_BARVERT}
  PP_BARVERT = 2;
  {$EXTERNALSYM PP_CHUNK}
  PP_CHUNK = 3;
  {$EXTERNALSYM PP_CHUNKVERT}
  PP_CHUNKVERT = 4;

//----------------------------------------------------------------------------
// "Rebar" Parts and States
//----------------------------------------------------------------------------

  {$EXTERNALSYM RP_GRIPPER}
  RP_GRIPPER = 1;
  {$EXTERNALSYM RP_GRIPPERVERT}
  RP_GRIPPERVERT = 2;
  {$EXTERNALSYM RP_BAND}
  RP_BAND = 3;
  {$EXTERNALSYM RP_CHEVRON}
  RP_CHEVRON = 4;
  {$EXTERNALSYM RP_CHEVRONVERT}
  RP_CHEVRONVERT = 5;

  {$EXTERNALSYM CHEVS_NORMAL}
  CHEVS_NORMAL = 1;
  {$EXTERNALSYM CHEVS_HOT}
  CHEVS_HOT = 2;
  {$EXTERNALSYM CHEVS_PRESSED}
  CHEVS_PRESSED = 3;

//----------------------------------------------------------------------------
// "Scrollbar" Parts and States
//----------------------------------------------------------------------------

  {$EXTERNALSYM SBP_ARROWBTN}
  SBP_ARROWBTN = 1;
  {$EXTERNALSYM SBP_THUMBBTNHORZ}
  SBP_THUMBBTNHORZ = 2;
  {$EXTERNALSYM SBP_THUMBBTNVERT}
  SBP_THUMBBTNVERT = 3;
  {$EXTERNALSYM SBP_LOWERTRACKHORZ}
  SBP_LOWERTRACKHORZ = 4;
  {$EXTERNALSYM SBP_UPPERTRACKHORZ}
  SBP_UPPERTRACKHORZ = 5;
  {$EXTERNALSYM SBP_LOWERTRACKHORZ}
  SBP_LOWERTRACKVERT = 6;
  {$EXTERNALSYM SBP_LOWERTRACKVERT}
  SBP_UPPERTRACKVERT = 7;
  {$EXTERNALSYM SBP_GRIPPERHORZ}
  SBP_GRIPPERHORZ = 8;
  {$EXTERNALSYM SBP_GRIPPERVERT}
  SBP_GRIPPERVERT = 9;
  {$EXTERNALSYM SBP_SIZEBOX}
  SBP_SIZEBOX = 10;

  {$EXTERNALSYM ABS_UPNORMAL}
  ABS_UPNORMAL = 1;
  {$EXTERNALSYM ABS_UPHOT}
  ABS_UPHOT = 2;
  {$EXTERNALSYM ABS_UPPRESSED}
  ABS_UPPRESSED = 3;
  {$EXTERNALSYM ABS_UPDISABLED}
  ABS_UPDISABLED = 4;
  {$EXTERNALSYM ABS_DOWNNORMAL}
  ABS_DOWNNORMAL = 5;
  {$EXTERNALSYM ABS_DOWNHOT}
  ABS_DOWNHOT = 6;
  {$EXTERNALSYM ABS_DOWNPRESSED}
  ABS_DOWNPRESSED = 7;
  {$EXTERNALSYM ABS_DOWNDISABLED}
  ABS_DOWNDISABLED = 8;
  {$EXTERNALSYM ABS_LEFTNORMAL}
  ABS_LEFTNORMAL = 9;
  {$EXTERNALSYM ABS_LEFTHOT}
  ABS_LEFTHOT = 10;
  {$EXTERNALSYM ABS_LEFTPRESSED}
  ABS_LEFTPRESSED = 11;
  {$EXTERNALSYM ABS_LEFTDISABLED}
  ABS_LEFTDISABLED = 12;
  {$EXTERNALSYM ABS_RIGHTNORMAL}
  ABS_RIGHTNORMAL = 13;
  {$EXTERNALSYM ABS_RIGHTHOT}
  ABS_RIGHTHOT = 14;
  {$EXTERNALSYM ABS_RIGHTPRESSED}
  ABS_RIGHTPRESSED = 15;
  {$EXTERNALSYM ABS_RIGHTDISABLED}
  ABS_RIGHTDISABLED = 16;

  {$EXTERNALSYM SCRBS_NORMAL}
  SCRBS_NORMAL = 1;
  {$EXTERNALSYM SCRBS_HOT}
  SCRBS_HOT = 2;
  {$EXTERNALSYM SCRBS_PRESSED}
  SCRBS_PRESSED = 3;
  {$EXTERNALSYM SCRBS_DISABLED}
  SCRBS_DISABLED = 4;

  {$EXTERNALSYM SZB_RIGHTALIGN}
  SZB_RIGHTALIGN = 1;
  {$EXTERNALSYM SZB_LEFTALIGN}
  SZB_LEFTALIGN = 2;

//----------------------------------------------------------------------------
// "Spin" Parts and States
//----------------------------------------------------------------------------

  {$EXTERNALSYM SPNP_UP}
  SPNP_UP = 1;
  {$EXTERNALSYM SPNP_DOWN}
  SPNP_DOWN = 2;
  {$EXTERNALSYM SPNP_UPHORZ}
  SPNP_UPHORZ = 3;
  {$EXTERNALSYM SPNP_DOWNHORZ}
  SPNP_DOWNHORZ = 4;

{ same States as "Page" }

//----------------------------------------------------------------------------
// "StartPanel" Parts and States
//----------------------------------------------------------------------------

  {$EXTERNALSYM SPP_USERPANE}
  SPP_USERPANE = 1;
  {$EXTERNALSYM SPP_MOREPROGRAMS}
  SPP_MOREPROGRAMS = 2;
  {$EXTERNALSYM SPP_MOREPROGRAMSARROW}
  SPP_MOREPROGRAMSARROW = 3;
  {$EXTERNALSYM SPP_PROGLIST}
  SPP_PROGLIST = 4;
  {$EXTERNALSYM SPP_PROGLISTSEPARATOR}
  SPP_PROGLISTSEPARATOR = 5;
  {$EXTERNALSYM SPP_PLACESLIST}
  SPP_PLACESLIST = 6;
  {$EXTERNALSYM SPP_PLACESLISTSEPARATOR}
  SPP_PLACESLISTSEPARATOR = 7;
  {$EXTERNALSYM SPP_LOGOFF}
  SPP_LOGOFF = 8;
  {$EXTERNALSYM SPP_LOGOFFBUTTONS}
  SPP_LOGOFFBUTTONS = 9;
  {$EXTERNALSYM SPP_USERPICTURE}
  SPP_USERPICTURE = 10;
  {$EXTERNALSYM SPP_PREVIEW}
  SPP_PREVIEW = 11;

  {$EXTERNALSYM SPS_NORMAL}
  SPS_NORMAL = 1;
  {$EXTERNALSYM SPS_HOT}
  SPS_HOT = 2;
  {$EXTERNALSYM SPS_PRESSED}
  SPS_PRESSED = 3;

  {$EXTERNALSYM SPLS_NORMAL}
  SPLS_NORMAL = 1;
  {$EXTERNALSYM SPLS_HOT}
  SPLS_HOT = 2;
  {$EXTERNALSYM SPLS_PRESSED}
  SPLS_PRESSED = 3;

//----------------------------------------------------------------------------
// "Status" Parts and States
//----------------------------------------------------------------------------

  {$EXTERNALSYM SP_PANE}
  SP_PANE = 1;
  {$EXTERNALSYM SP_GRIPPERPANE}
  SP_GRIPPERPANE = 2;
  {$EXTERNALSYM SP_GRIPPER}
  SP_GRIPPER = 3;

//----------------------------------------------------------------------------
// "Tab" Parts and States
//----------------------------------------------------------------------------

  {$EXTERNALSYM TABP_TABITEM}
  TABP_TABITEM = 1;
  {$EXTERNALSYM TABP_TABITEMLEFTEDGE}
  TABP_TABITEMLEFTEDGE = 2;
  {$EXTERNALSYM TABP_TABITEMRIGHTEDGE}
  TABP_TABITEMRIGHTEDGE = 3;
  {$EXTERNALSYM TABP_TABITEMBOTHEDGE}
  TABP_TABITEMBOTHEDGE = 4;
  {$EXTERNALSYM TABP_TOPTABITEM}
  TABP_TOPTABITEM = 5;
  {$EXTERNALSYM TABP_TOPTABITEMLEFTEDGE}
  TABP_TOPTABITEMLEFTEDGE = 6;
  {$EXTERNALSYM TABP_TOPTABITEMRIGHTEDGE}
  TABP_TOPTABITEMRIGHTEDGE = 7;
  {$EXTERNALSYM TABP_TOPTABITEMBOTHEDGE}
  TABP_TOPTABITEMBOTHEDGE = 8;
  {$EXTERNALSYM TABP_PANE}
  TABP_PANE = 9;
  {$EXTERNALSYM TABP_BODY}
  TABP_BODY = 10;

  {$EXTERNALSYM TIS_NORMAL}
  TIS_NORMAL = 1;
  {$EXTERNALSYM TIS_HOT}
  TIS_HOT = 2;
  {$EXTERNALSYM TIS_SELECTED}
  TIS_SELECTED = 3;
  {$EXTERNALSYM TIS_DISABLED}
  TIS_DISABLED = 4;
  {$EXTERNALSYM TIS_FOCUSED}
  TIS_FOCUSED = 5;

  {$EXTERNALSYM TILES_NORMAL}
  TILES_NORMAL = 1;
  {$EXTERNALSYM TILES_HOT}
  TILES_HOT = 2;
  {$EXTERNALSYM TILES_SELECTED}
  TILES_SELECTED = 3;
  {$EXTERNALSYM TILES_DISABLED}
  TILES_DISABLED = 4;
  {$EXTERNALSYM TILES_FOCUSED}
  TILES_FOCUSED = 5;

  {$EXTERNALSYM TIRES_NORMAL}
  TIRES_NORMAL = 1;
  {$EXTERNALSYM TIRES_HOT}
  TIRES_HOT = 2;
  {$EXTERNALSYM TIRES_SELECTED}
  TIRES_SELECTED = 3;
  {$EXTERNALSYM TIRES_DISABLED}
  TIRES_DISABLED = 4;
  {$EXTERNALSYM TIRES_FOCUSED}
  TIRES_FOCUSED = 5;

  {$EXTERNALSYM TIBES_NORMAL}
  TIBES_NORMAL = 1;
  {$EXTERNALSYM TIBES_HOT}
  TIBES_HOT = 2;
  {$EXTERNALSYM TIBES_SELECTED}
  TIBES_SELECTED = 3;
  {$EXTERNALSYM TIBES_DISABLED}
  TIBES_DISABLED = 4;
  {$EXTERNALSYM TIBES_FOCUSED}
  TIBES_FOCUSED = 5;

  {$EXTERNALSYM TTIS_NORMAL}
  TTIS_NORMAL = 1;
  {$EXTERNALSYM TTIS_HOT}
  TTIS_HOT = 2;
  {$EXTERNALSYM TTIS_SELECTED}
  TTIS_SELECTED = 3;
  {$EXTERNALSYM TTIS_DISABLED}
  TTIS_DISABLED = 4;
  {$EXTERNALSYM TTIS_FOCUSED}
  TTIS_FOCUSED = 5;

  {$EXTERNALSYM TTILES_NORMAL}
  TTILES_NORMAL = 1;
  {$EXTERNALSYM TTILES_HOT}
  TTILES_HOT = 2;
  {$EXTERNALSYM TTILES_SELECTED}
  TTILES_SELECTED = 3;
  {$EXTERNALSYM TTILES_DISABLED}
  TTILES_DISABLED = 4;
  {$EXTERNALSYM TTILES_FOCUSED}
  TTILES_FOCUSED = 5;

  {$EXTERNALSYM TTIRES_NORMAL}
  TTIRES_NORMAL = 1;
  {$EXTERNALSYM TTIRES_HOT}
  TTIRES_HOT = 2;
  {$EXTERNALSYM TTIRES_SELECTED}
  TTIRES_SELECTED = 3;
  {$EXTERNALSYM TTIRES_DISABLED}
  TTIRES_DISABLED = 4;
  {$EXTERNALSYM TTIRES_FOCUSED}
  TTIRES_FOCUSED = 5;

  {$EXTERNALSYM TTIBES_NORMAL}
  TTIBES_NORMAL = 1;
  {$EXTERNALSYM TTIBES_HOT}
  TTIBES_HOT = 2;
  {$EXTERNALSYM TTIBES_SELECTED}
  TTIBES_SELECTED = 3;
  {$EXTERNALSYM TTIBES_DISABLED}
  TTIBES_DISABLED = 4;
  {$EXTERNALSYM TTIBES_FOCUSED}
  TTIBES_FOCUSED = 5;

//----------------------------------------------------------------------------
// "TaskBand" Parts and States
//----------------------------------------------------------------------------

  {$EXTERNALSYM TDP_GROUPCOUNT}
  TDP_GROUPCOUNT = 1;
  {$EXTERNALSYM TDP_FLASHBUTTON}
  TDP_FLASHBUTTON = 2;
  {$EXTERNALSYM TDP_FLASHBUTTONGROUPMENU}
  TDP_FLASHBUTTONGROUPMENU = 3;

//----------------------------------------------------------------------------
// "TaskBar" Parts and States
//----------------------------------------------------------------------------

  {$EXTERNALSYM TBP_BACKGROUNDBOTTOM}
  TBP_BACKGROUNDBOTTOM = 1;
  {$EXTERNALSYM TBP_BACKGROUNDRIGHT}
  TBP_BACKGROUNDRIGHT = 2;
  {$EXTERNALSYM TBP_BACKGROUNDTOP}
  TBP_BACKGROUNDTOP = 3;
  {$EXTERNALSYM TBP_BACKGROUNDLEFT}
  TBP_BACKGROUNDLEFT = 4;
  {$EXTERNALSYM TBP_SIZINGBARBOTTOM}
  TBP_SIZINGBARBOTTOM = 5;
  {$EXTERNALSYM TBP_SIZINGBARRIGHT}
  TBP_SIZINGBARRIGHT = 6;
  {$EXTERNALSYM TBP_SIZINGBARTOP}
  TBP_SIZINGBARTOP = 7;
  {$EXTERNALSYM TBP_SIZINGBARLEFT}
  TBP_SIZINGBARLEFT = 8;

//----------------------------------------------------------------------------
// "Toolbar" Parts and States
//----------------------------------------------------------------------------

  {$EXTERNALSYM TP_BUTTON}
  TP_BUTTON = 1;
  {$EXTERNALSYM TP_DROPDOWNBUTTON}
  TP_DROPDOWNBUTTON = 2;
  {$EXTERNALSYM TP_SPLITBUTTON}
  TP_SPLITBUTTON = 3;
  {$EXTERNALSYM TP_SPLITBUTTONDROPDOWN}
  TP_SPLITBUTTONDROPDOWN = 4;
  {$EXTERNALSYM TP_SEPARATOR}
  TP_SEPARATOR = 5;
  {$EXTERNALSYM TP_SEPARATORVERT}
  TP_SEPARATORVERT = 6;

  {$EXTERNALSYM TS_NORMAL}
  TS_NORMAL = 1;
  {$EXTERNALSYM TS_HOT}
  TS_HOT = 2;
  {$EXTERNALSYM TS_PRESSED}
  TS_PRESSED = 3;
  {$EXTERNALSYM TS_DISABLED}
  TS_DISABLED = 4;
  {$EXTERNALSYM TS_CHECKED}
  TS_CHECKED = 5;
  {$EXTERNALSYM TS_HOTCHECKED}
  TS_HOTCHECKED = 6;

//----------------------------------------------------------------------------
// "Tooltip" Parts and States
//----------------------------------------------------------------------------

  {$EXTERNALSYM TTP_STANDARD}
  TTP_STANDARD = 1;
  {$EXTERNALSYM TTP_STANDARDTITLE}
  TTP_STANDARDTITLE = 2;
  {$EXTERNALSYM TTP_BALLOON}
  TTP_BALLOON = 3;
  {$EXTERNALSYM TTP_BALLOONTITLE}
  TTP_BALLOONTITLE = 4;
  {$EXTERNALSYM TTP_CLOSE}
  TTP_CLOSE = 5;

  {$EXTERNALSYM TTCS_NORMAL}
  TTCS_NORMAL = 1;
  {$EXTERNALSYM TTCS_HOT}
  TTCS_HOT = 2;
  {$EXTERNALSYM TTCS_PRESSED}
  TTCS_PRESSED = 3;

  {$EXTERNALSYM TTSS_NORMAL}
  TTSS_NORMAL = 1;
  {$EXTERNALSYM TTSS_LINK}
  TTSS_LINK = 2;

  {$EXTERNALSYM TTBS_NORMAL}
  TTBS_NORMAL = 1;
  {$EXTERNALSYM TTBS_LINK}
  TTBS_LINK = 2;

//----------------------------------------------------------------------------
// "Trackbar" Parts and States
//----------------------------------------------------------------------------

  {$EXTERNALSYM TKP_TRACK}
  TKP_TRACK = 1;
  {$EXTERNALSYM TKP_TRACKVERT}
  TKP_TRACKVERT = 2;
  {$EXTERNALSYM TKP_THUMB}
  TKP_THUMB = 3;
  {$EXTERNALSYM TKP_THUMBBOTTOM}
  TKP_THUMBBOTTOM = 4;
  {$EXTERNALSYM TKP_THUMBTOP}
  TKP_THUMBTOP = 5;
  {$EXTERNALSYM TKP_THUMBVERT}
  TKP_THUMBVERT = 6;
  {$EXTERNALSYM TKP_THUMBLEFT}
  TKP_THUMBLEFT = 7;
  {$EXTERNALSYM TKP_THUMBRIGHT}
  TKP_THUMBRIGHT = 8;
  {$EXTERNALSYM TKP_TICS}
  TKP_TICS = 9;
  {$EXTERNALSYM TKP_TICSVERT}
  TKP_TICSVERT = 10;

  {$EXTERNALSYM TKS_NORMAL}
  TKS_NORMAL = 1;

  {$EXTERNALSYM TRS_NORMAL}
  TRS_NORMAL = 1;

  {$EXTERNALSYM TRVS_NORMAL}
  TRVS_NORMAL = 1;

  {$EXTERNALSYM TUS_NORMAL}
  TUS_NORMAL = 1;
  {$EXTERNALSYM TUS_HOT}
  TUS_HOT = 2;
  {$EXTERNALSYM TUS_PRESSED}
  TUS_PRESSED = 3;
  {$EXTERNALSYM TUS_FOCUSED}
  TUS_FOCUSED = 4;
  {$EXTERNALSYM TUS_DISABLED}
  TUS_DISABLED = 5;

  {$EXTERNALSYM TUBS_NORMAL}
  TUBS_NORMAL = 1;
  {$EXTERNALSYM TUBS_HOT}
  TUBS_HOT = 2;
  {$EXTERNALSYM TUBS_PRESSED}
  TUBS_PRESSED = 3;
  {$EXTERNALSYM TUBS_FOCUSED}
  TUBS_FOCUSED = 4;
  {$EXTERNALSYM TUBS_DISABLED}
  TUBS_DISABLED = 5;

  {$EXTERNALSYM TUTS_NORMAL}
  TUTS_NORMAL = 1;
  {$EXTERNALSYM TUTS_HOT}
  TUTS_HOT = 2;
  {$EXTERNALSYM TUTS_PRESSED}
  TUTS_PRESSED = 3;
  {$EXTERNALSYM TUTS_FOCUSED}
  TUTS_FOCUSED = 4;
  {$EXTERNALSYM TUTS_DISABLED}
  TUTS_DISABLED = 5;

  {$EXTERNALSYM TUVS_NORMAL}
  TUVS_NORMAL = 1;
  {$EXTERNALSYM TUVS_HOT}
  TUVS_HOT = 2;
  {$EXTERNALSYM TUVS_PRESSED}
  TUVS_PRESSED = 3;
  {$EXTERNALSYM TUVS_FOCUSED}
  TUVS_FOCUSED = 4;
  {$EXTERNALSYM TUVS_DISABLED}
  TUVS_DISABLED = 5;

  {$EXTERNALSYM TUVLS_NORMAL}
  TUVLS_NORMAL = 1;
  {$EXTERNALSYM TUVLS_HOT}
  TUVLS_HOT = 2;
  {$EXTERNALSYM TUVLS_PRESSED}
  TUVLS_PRESSED = 3;
  {$EXTERNALSYM TUVLS_FOCUSED}
  TUVLS_FOCUSED = 4;
  {$EXTERNALSYM TUVLS_DISABLED}
  TUVLS_DISABLED = 5;

  {$EXTERNALSYM TUVRS_NORMAL}
  TUVRS_NORMAL = 1;
  {$EXTERNALSYM TUVRS_HOT}
  TUVRS_HOT = 2;
  {$EXTERNALSYM TUVRS_PRESSED}
  TUVRS_PRESSED = 3;
  {$EXTERNALSYM TUVRS_FOCUSED}
  TUVRS_FOCUSED = 4;
  {$EXTERNALSYM TUVRS_DISABLED}
  TUVRS_DISABLED = 5;

  {$EXTERNALSYM TSS_NORMAL}
  TSS_NORMAL = 1;

  {$EXTERNALSYM TSVS_NORMAL}
  TSVS_NORMAL = 1;

//----------------------------------------------------------------------------
// "TrayNotify" Parts and States
//----------------------------------------------------------------------------

  {$EXTERNALSYM TNP_BACKGROUND}
  TNP_BACKGROUND = 1;
  {$EXTERNALSYM TNP_ANIMBACKGROUND}
  TNP_ANIMBACKGROUND = 2;

//----------------------------------------------------------------------------
// "TreeView" Parts and States
//----------------------------------------------------------------------------

  {$EXTERNALSYM TVP_TREEITEM}
  TVP_TREEITEM = 1;
  {$EXTERNALSYM TVP_GLYPH}
  TVP_GLYPH = 2;
  {$EXTERNALSYM TVP_BRANCH}
  TVP_BRANCH = 3;

  {$EXTERNALSYM GLPS_CLOSED}
  GLPS_CLOSED = 1;
  {$EXTERNALSYM GLPS_OPENED}
  GLPS_OPENED = 2;

  {$EXTERNALSYM TREIS_NORMAL}
  TREIS_NORMAL = 1;
  {$EXTERNALSYM TREIS_HOT}
  TREIS_HOT = 2;
  {$EXTERNALSYM TREIS_SELECTED}
  TREIS_SELECTED = 3;
  {$EXTERNALSYM TREIS_DISABLED}
  TREIS_DISABLED = 4;
  {$EXTERNALSYM TREIS_SELECTEDNOTFOCUS}
  TREIS_SELECTEDNOTFOCUS = 5;

//----------------------------------------------------------------------------
// "Window" Parts and States
//----------------------------------------------------------------------------

  {$EXTERNALSYM WP_CAPTION}
  WP_CAPTION = 1;
  {$EXTERNALSYM WP_SMALLCAPTION}
  WP_SMALLCAPTION = 2;
  {$EXTERNALSYM WP_MINCAPTION}
  WP_MINCAPTION = 3;
  {$EXTERNALSYM WP_SMALLMINCAPTION}
  WP_SMALLMINCAPTION = 4;
  {$EXTERNALSYM WP_MAXCAPTION}
  WP_MAXCAPTION = 5;
  {$EXTERNALSYM WP_SMALLMAXCAPTION}
  WP_SMALLMAXCAPTION = 6;
  {$EXTERNALSYM WP_FRAMELEFT}
  WP_FRAMELEFT = 7;
  {$EXTERNALSYM WP_FRAMERIGHT}
  WP_FRAMERIGHT = 8;
  {$EXTERNALSYM WP_FRAMEBOTTOM}
  WP_FRAMEBOTTOM = 9;
  {$EXTERNALSYM WP_SMALLFRAMELEFT}
  WP_SMALLFRAMELEFT = 10;
  {$EXTERNALSYM WP_SMALLFRAMERIGHT}
  WP_SMALLFRAMERIGHT = 11;
  {$EXTERNALSYM WP_SMALLFRAMEBOTTOM}
  WP_SMALLFRAMEBOTTOM = 12;

//---- Window frame buttons --------------------------------------------------

  {$EXTERNALSYM WP_SYSBUTTON}
  WP_SYSBUTTON = 13;
  {$EXTERNALSYM WP_MDISYSBUTTON}
  WP_MDISYSBUTTON = 14;
  {$EXTERNALSYM WP_MINBUTTON}
  WP_MINBUTTON = 15;
  {$EXTERNALSYM WP_MDIMINBUTTON}
  WP_MDIMINBUTTON = 16;
  {$EXTERNALSYM WP_MAXBUTTON}
  WP_MAXBUTTON = 17;
  {$EXTERNALSYM WP_CLOSEBUTTON}
  WP_CLOSEBUTTON = 18;
  {$EXTERNALSYM WP_SMALLCLOSEBUTTON}
  WP_SMALLCLOSEBUTTON = 19;
  {$EXTERNALSYM WP_MDICLOSEBUTTON}
  WP_MDICLOSEBUTTON = 20;
  {$EXTERNALSYM WP_RESTOREBUTTON}
  WP_RESTOREBUTTON = 21;
  {$EXTERNALSYM WP_MDIRESTOREBUTTON}
  WP_MDIRESTOREBUTTON = 22;
  {$EXTERNALSYM WP_HELPBUTTON}
  WP_HELPBUTTON = 23;
  {$EXTERNALSYM WP_MDIHELPBUTTON}
  WP_MDIHELPBUTTON = 24;

//---- Scrollbars ------------------------------------------------------------

  {$EXTERNALSYM WP_HORZSCROLL}
  WP_HORZSCROLL = 25;
  {$EXTERNALSYM WP_HORZTHUMB}
  WP_HORZTHUMB = 26;
  {$EXTERNALSYM WP_VERTSCROLL}
  WP_VERTSCROLL = 27;
  {$EXTERNALSYM WP_VERTTHUMB}
  WP_VERTTHUMB = 28;

//---- Dialog ----------------------------------------------------------------

  {$EXTERNALSYM WP_DIALOG}
  WP_DIALOG = 29;

//---- Hit-test templates ----------------------------------------------------

  {$EXTERNALSYM WP_CAPTIONSIZINGTEMPLATE}
  WP_CAPTIONSIZINGTEMPLATE = 30;
  {$EXTERNALSYM WP_SMALLCAPTIONSIZINGTEMPLATE}
  WP_SMALLCAPTIONSIZINGTEMPLATE = 31;
  {$EXTERNALSYM WP_FRAMELEFTSIZINGTEMPLATE}
  WP_FRAMELEFTSIZINGTEMPLATE = 32;
  {$EXTERNALSYM WP_SMALLFRAMELEFTSIZINGTEMPLATE}
  WP_SMALLFRAMELEFTSIZINGTEMPLATE = 33;
  {$EXTERNALSYM WP_FRAMERIGHTSIZINGTEMPLATE}
  WP_FRAMERIGHTSIZINGTEMPLATE = 34;
  {$EXTERNALSYM WP_SMALLFRAMERIGHTSIZINGTEMPLATE}
  WP_SMALLFRAMERIGHTSIZINGTEMPLATE = 35;
  {$EXTERNALSYM WP_FRAMEBOTTOMSIZINGTEMPLATE}
  WP_FRAMEBOTTOMSIZINGTEMPLATE = 36;
  {$EXTERNALSYM WP_SMALLFRAMEBOTTOMSIZINGTEMPLATE}
  WP_SMALLFRAMEBOTTOMSIZINGTEMPLATE = 37;

  {$EXTERNALSYM FS_ACTIVE}
  FS_ACTIVE = 1;
  {$EXTERNALSYM FS_INACTIVE}
  FS_INACTIVE = 2;

  {$EXTERNALSYM CS_ACTIVE}
  CS_ACTIVE = 1;
  {$EXTERNALSYM CS_INACTIVE}
  CS_INACTIVE = 2;
  {$EXTERNALSYM CS_DISABLED}
  CS_DISABLED = 3;

  {$EXTERNALSYM MXCS_ACTIVE}
  MXCS_ACTIVE = 1;
  {$EXTERNALSYM MXCS_INACTIVE}
  MXCS_INACTIVE = 2;
  {$EXTERNALSYM MXCS_DISABLED}
  MXCS_DISABLED = 3;

  {$EXTERNALSYM MNCS_ACTIVE}
  MNCS_ACTIVE = 1;
  {$EXTERNALSYM MNCS_INACTIVE}
  MNCS_INACTIVE = 2;
  {$EXTERNALSYM MNCS_DISABLED}
  MNCS_DISABLED = 3;

  {$EXTERNALSYM HSS_NORMAL}
  HSS_NORMAL = 1;
  {$EXTERNALSYM HSS_HOT}
  HSS_HOT = 2;
  {$EXTERNALSYM HSS_PUSHED}
  HSS_PUSHED = 3;
  {$EXTERNALSYM HSS_DISABLED}
  HSS_DISABLED = 4;

  {$EXTERNALSYM HTS_NORMAL}
  HTS_NORMAL = 1;
  {$EXTERNALSYM HTS_HOT}
  HTS_HOT = 2;
  {$EXTERNALSYM HTS_PUSHED}
  HTS_PUSHED = 3;
  {$EXTERNALSYM HTS_DISABLED}
  HTS_DISABLED = 4;

  {$EXTERNALSYM VSS_NORMAL}
  VSS_NORMAL = 1;
  {$EXTERNALSYM VSS_HOT}
  VSS_HOT = 2;
  {$EXTERNALSYM VSS_PUSHED}
  VSS_PUSHED = 3;
  {$EXTERNALSYM VSS_DISABLED}
  VSS_DISABLED = 4;

  {$EXTERNALSYM VTS_NORMAL}
  VTS_NORMAL = 1;
  {$EXTERNALSYM VTS_HOT}
  VTS_HOT = 2;
  {$EXTERNALSYM VTS_PUSHED}
  VTS_PUSHED = 3;
  {$EXTERNALSYM VTS_DISABLED}
  VTS_DISABLED = 4;

  {$EXTERNALSYM SBS_NORMAL}
  SBS_NORMAL = 1;
  {$EXTERNALSYM SBS_HOT}
  SBS_HOT = 2;
  {$EXTERNALSYM SBS_PUSHED}
  SBS_PUSHED = 3;
  {$EXTERNALSYM SBS_DISABLED}
  SBS_DISABLED = 4;

  {$EXTERNALSYM MINBS_NORMAL}
  MINBS_NORMAL = 1;
  {$EXTERNALSYM MINBS_HOT}
  MINBS_HOT = 2;
  {$EXTERNALSYM MINBS_PUSHED}
  MINBS_PUSHED = 3;
  {$EXTERNALSYM MINBS_DISABLED}
  MINBS_DISABLED = 4;

  {$EXTERNALSYM MAXBS_NORMAL}
  MAXBS_NORMAL = 1;
  {$EXTERNALSYM MAXBS_HOT}
  MAXBS_HOT = 2;
  {$EXTERNALSYM MAXBS_PUSHED}
  MAXBS_PUSHED = 3;
  {$EXTERNALSYM MAXBS_DISABLED}
  MAXBS_DISABLED = 4;

  {$EXTERNALSYM RBS_NORMAL}
  RBS_NORMAL = 1;
  {$EXTERNALSYM RBS_HOT}
  RBS_HOT = 2;
  {$EXTERNALSYM RBS_PUSHED}
  RBS_PUSHED = 3;
  {$EXTERNALSYM RBS_DISABLED}
  RBS_DISABLED = 4;

  {$EXTERNALSYM HBS_NORMAL}
  HBS_NORMAL = 1;
  {$EXTERNALSYM HBS_HOT}
  HBS_HOT = 2;
  {$EXTERNALSYM HBS_PUSHED}
  HBS_PUSHED = 3;
  {$EXTERNALSYM HBS_DISABLED}
  HBS_DISABLED = 4;

  {$EXTERNALSYM CBS_NORMAL}
  CBS_NORMAL = 1;
  {$EXTERNALSYM CBS_HOT}
  CBS_HOT = 2;
  {$EXTERNALSYM CBS_PUSHED}
  CBS_PUSHED = 3;
  {$EXTERNALSYM CBS_DISABLED}
  CBS_DISABLED = 4;

type
  {$EXTERNALSYM HTHEME}
  HTHEME = THandle;

var
  OpenThemeData : function (
    hWnd : THandle;
    pszClassList : LPCWSTR) : HTHEME stdcall;

  CloseThemeData : function (
    hTheme : HTHEME) : HResult stdcall;

  DrawThemeBackground : function (
    hTheme : HTHEME;
    hdc : HDC;
    iPartId : integer;
    iStateId : integer;
    const pRect : PRect;
    const pClipRect : PRect) : HResult stdcall;

const
  {$EXTERNALSYM DTT_GRAYED}
  DTT_GRAYED = $00000001;

var
  DrawThemeText : function (
    hTheme : HTHEME;
    hdc : HDC;
    iPartId : integer;
    iStateId : integer;
    pszText : LPCWSTR;
    iCharCount : integer;
    dwTextFlags : Dword;
    dwTextFlags2 : Dword;
    const pRect : PRect) : HResult stdcall;

  GetThemeBackgroundContentRect : function (
    hTheme : HTHEME;
    hdc : HDC;
    iPartId : integer;
    iStateId : integer;
    const pBoundingRect : PRect;
    var pContentRect : TRect) : HResult stdcall;

  GetThemeBackgroundExtent : function (
    hTheme : HTHEME;
    hdc : HDC;
    iPartId : integer;
    iStateId : integer;
    const pContentRect : PRect;
    var pExtentRect : TRect) : HResult stdcall;

//----------------------------------------------------------------------------

type
  {$EXTERNALSYM THEMESIZE}
  THEMESIZE = (
    TS_MIN,                  // minimum size
    TS_TRUE,                 // size without stretching
    TS_DRAW);                // size that theme manager will use to draw part
  TThemeSize = THEMESIZE;

var
  GetThemePartSize : function (
    hTheme : HTHEME;
    hdc : HDC;
    iPartId : integer;
    iStateId : integer;
    prc : PRect;
    eSize : TThemeSize;
    var psz : TSize) : HResult stdcall;

  GetThemeTextExtent : function (
    hTheme : HTHEME;
    hdc : HDC;
    iPartId : integer;
    iStateId : integer;
    pszText : LPCWSTR;
    iCharCount : integer;
    dwTextFlags : Dword;
    const pBoundingRect : PRect;
    var pExtentRect : TRect) : HResult stdcall;

  GetThemeTextMetrics : function (
    hTheme : HTHEME;
    hdc : HDC;
    iPartId : integer;
    iStateId : integer;
    var ptm : TTextMetric) : HResult stdcall;

  GetThemeBackgroundRegion : function (
    hTheme : HTHEME;
    hdc : HDC;
    iPartId : integer;
    iStateId : integer;
    const pRect : PRect;
    var pRegion : HRGN) : HResult stdcall;

const
  {$EXTERNALSYM HTTB_BACKGROUNDSEG}
  HTTB_BACKGROUNDSEG = $0000;
  {$EXTERNALSYM HTTB_FIXEDBORDER}
  HTTB_FIXEDBORDER = $0002;
  {$EXTERNALSYM HTTB_CAPTION}
  HTTB_CAPTION = $0004;
  {$EXTERNALSYM HTTB_RESIZINGBORDER_LEFT}
  HTTB_RESIZINGBORDER_LEFT = $0010;
  {$EXTERNALSYM HTTB_RESIZINGBORDER_TOP}
  HTTB_RESIZINGBORDER_TOP = $0020;
  {$EXTERNALSYM HTTB_RESIZINGBORDER_RIGHT}
  HTTB_RESIZINGBORDER_RIGHT = $0040;
  {$EXTERNALSYM HTTB_RESIZINGBORDER_BOTTOM}
  HTTB_RESIZINGBORDER_BOTTOM = $0080;

  {$EXTERNALSYM HTTB_RESIZINGBORDER}
  HTTB_RESIZINGBORDER = (HTTB_RESIZINGBORDER_LEFT or HTTB_RESIZINGBORDER_TOP);

  {$EXTERNALSYM HTTB_SIZINGTEMPLATE}
  HTTB_SIZINGTEMPLATE = $0100;
  {$EXTERNALSYM HTTB_SYSTEMSIZINGMARGINS}
  HTTB_SYSTEMSIZINGMARGINS = $0200;

var
  HitTestThemeBackground : function (
    hTheme : HTHEME;
    hdc : HDC;
    iPartId : integer;
    iStateId : integer;
    dwOptions : Dword;
    const pRect : PRect;
    hrgn : HRGN;
    ptTest : integer;
    var pwHitTestCode : word) : HResult stdcall;

  DrawThemeEdge : function (
    hTheme : HTHEME;
    hdc : HDC;
    iPartId : integer;
    iStateId : integer;
    const pDestRect : PRect;
    uEdge: word;
    uFlags: word;
    var pContentRect : TRect) : HResult stdcall;

  DrawThemeIcon : function (
    hTheme : HTHEME;
    hdc : HDC;
    iPartId : integer;
    iStateId : integer;
    const pRect : PRect;
    himl : THandle;
    iImageIndex : integer): HResult stdcall;

  IsThemePartDefined : function (
    hTheme : HTHEME;
    iPartId : integer;
    iStateId : integer) : BOOL stdcall;

  IsThemeBackGroundPartiallyTransparent : function (
    hTheme : HTHEME;
    iPartId : integer;
    iStateId: integer) : BOOL stdcall;

  GetThemeColor : function (
    hTheme : HTHEME;
    iPartId : integer;
    iStateId : integer;
    iPropId : integer;
    var pColor : TColor) : HResult stdcall;

  GetThemeMetric : function (
    hTheme : HTHEME;
    hdc : HDC;
    iPartId : integer;
    iStateId : integer;
    iPropId : integer;
    var piVal : integer) : HResult stdcall;

  GetThemeString : function (
    hTheme : HTHEME;
    iPartId : integer;
    iStateId : integer;
    iPropId : integer;
    pszBuff : LPWSTR;
    cchMaxBuffChars : integer) : HResult stdcall;

  GetThemeBool : function (
    hTheme : HTHEME;
    iPartId : integer;
    iStateId : integer;
    iPropId : integer;
    var pfVal : BOOL) : HResult stdcall;

  GetThemeInt : function (
    hTheme : HTHEME;
    iPartId : integer;
    iStateId : integer;
    iPropId : integer;
    var piVal : integer) : HResult stdcall;

  GetThemeEnumValue : function (
    hTheme : HTHEME;
    iPartId : integer;
    iStateId : integer;
    iPropId : integer;
    var piVal : integer) : HResult stdcall;

  GetThemePosition : function (
    hTheme : HTHEME;
    iPartId : integer;
    iStateId : integer;
    iPropId : integer;
    var pPoint : TPoint) : HResult stdcall;

  GetThemeFont : function (
    hTheme : HTHEME;
    hdc : HDC;
    iPartId : integer;
    iStateId : integer;
    iPropId : integer;
    var pFont : TLogFont) : HResult stdcall;

  GetThemeRect : function (
    hTheme : HTHEME;
    iPartId : integer;
    iStateId : integer;
    iPropId : integer;
    var pRect : PRect) : HResult stdcall;

//----------------------------------------------------------------------------

type
  {$EXTERNALSYM _MARGINS}
  _MARGINS = record
    cxLeftWidth : integer;
    cxRightWidth : integer;
    cyTopHeight : integer;
    cyBottomHeight : integer;
  end;
  {$EXTERNALSYM MARGINS}
  MARGINS = _MARGINS;
  {$EXTERNALSYM PMARGINS}
  PMARGINS = ^_MARGINS;
  TMargins = MARGINS;

var
  GetThemeMargins : function (
    hTheme : HTHEME;
    hdc : HDC;
    iPartId : integer;
    iStateId : integer;
    iPropId : integer;
    prc : TRect;
    var pMargins : TRect) : HResult stdcall;

//----------------------------------------------------------------------------

const
  {$EXTERNALSYM MAX_INTLIST_COUNT}
  MAX_INTLIST_COUNT = 10;

type
  {$EXTERNALSYM _INTLIST}
  _INTLIST = record
    iValueCount : integer;
    iValues : array[0..pred(MAX_INTLIST_COUNT)] of integer;
  end;
  {$EXTERNALSYM INTLIST}
  INTLIST = _INTLIST;
  {$EXTERNALSYM PINTLIST}
  PINTLIST = ^_INTLIST;
  TIntList = INTLIST;

var
  GetThemeIntList : function (
    hTheme : HTHEME;
    iPartId : integer;
    iStateId : integer;
    iPropId : integer;
    var pIntList : TIntList) : HResult stdcall;

//----------------------------------------------------------------------------

type
  {$EXTERNALSYM PROPERTYORIGIN}
  PROPERTYORIGIN = (
    PO_STATE,
    PO_PART,
    PO_CLASS,
    PO_GLOBAL,
    PO_NOTFOUND);
  TPropertyOrigin = PROPERTYORIGIN;

var
  GetPropertyOrigin : function (
    hTheme : HTHEME;
    iPartId : integer;
    iStateId : integer;
    iPropId : integer;
    var pOrigin : TPropertyOrigin) : HResult stdcall;

  SetWindowTheme : function (
    hwnd : HWND;
    pszSubAppName : LPCWSTR;
    pszSubIdList : LPCWSTR) : HResult stdcall;

  GetThemeFilename : function (
    hTheme : HTHEME;
    iPartId : integer;
    iStateId : integer;
    iPropId : integer;
    pszThemeFileName : LPWSTR;
    cchMaxBuffChars : integer) : HResult stdcall;

  GetThemeSysColor : function (
    hTheme : HTHEME;
    iColorId : integer) : integer stdcall;

  GetThemeSysColorBrush : function (
    hTheme : HTHEME;
    iColorId : integer) : integer stdcall;

  GetThemeSysBool : function (
    hTheme : HTHEME;
    iBoolId : integer) : integer stdcall;

  GetThemeSysSize : function (
    hTheme : HTHEME;
    iSizeId : integer) : integer stdcall;

  GetThemeSysFont : function (
    hTheme : HTHEME;
    iFontId : integer;
    var plf : TLogFont) : HResult stdcall;

  GetThemeSysString : function (
    hTheme : HTHEME;
    iStringId : integer;
    pszStringBuff : LPWSTR;
    cchMaxStringChars : integer) : HResult stdcall;

  GetThemeSysInt : function (
    hTheme : HTHEME;
    iIntId : integer;
    var piValue : integer) : HResult stdcall;

  IsThemeActive : function : BOOL stdcall;

  IsAppThemed : function : BOOL stdcall;

  GetWindowTheme : function (hwnd : HWnd) : integer stdcall;

//---------------------------------------------------------------------------

const
  {$EXTERNALSYM ETDT_DISABLE}
  ETDT_DISABLE = $00000001;
  {$EXTERNALSYM ETDT_ENABLE}
  ETDT_ENABLE = $00000002;
  {$EXTERNALSYM ETDT_USETABTEXTURE}
  ETDT_USETABTEXTURE = $00000004;
  {$EXTERNALSYM ETDT_ENABLETAB}
  ETDT_ENABLETAB = (ETDT_ENABLE or ETDT_USETABTEXTURE);

var
  EnableThemeDialogTexture : function (
    hwnd : HWND;
    dwFlags : Dword) : HResult stdcall;

  IsThemeDialogTextureEnabled : function (
    hwnd : HWnd) : BOOL stdcall;

//---------------------------------------------------------------------------

const
  {$EXTERNALSYM STAP_ALLOW_NONCLIENT}
  STAP_ALLOW_NONCLIENT = $00000001;
  {$EXTERNALSYM STAP_ALLOW_CONTROLS}
  STAP_ALLOW_CONTROLS = $00000002;
  {$EXTERNALSYM STAP_ALLOW_WEBCONTENT}
  STAP_ALLOW_WEBCONTENT = $00000004;

var
  GetThemeAppProperties : function : Dword stdcall;

  SetThemeAppProperties : function (dwFlags : Dword) : integer stdcall;

  GetCurrentThemeName : function (
    pszThemeFileName : LPWSTR;
    cchMaxNameChars : integer;
    pszColorBuff : LPWSTR;
    cchMaxColorChars : integer;
    pszSizeBuff : LPWSTR;
    cchMaxSizeChars : integer) : HResult stdcall;

//---------------------------------------------------------------------------

const
  {$EXTERNALSYM SZ_THDOCPROP_DISPLAYNAME}
  SZ_THDOCPROP_DISPLAYNAME = WideString('DisplayName');
  {$EXTERNALSYM SZ_THDOCPROP_CANONICALNAME}
  SZ_THDOCPROP_CANONICALNAME = WideString('ThemeName');
  {$EXTERNALSYM SZ_THDOCPROP_TOOLTIP}
  SZ_THDOCPROP_TOOLTIP = WideString('ToolTip');
  {$EXTERNALSYM SZ_THDOCPROP_AUTHOR}
  SZ_THDOCPROP_AUTHOR = WideString('author');

var
  GetThemeDocumentationProperty : function (
    pszThemeName : LPCWSTR;
    pszPropertyName : LPCWSTR;
    pszValueBuff : LPWSTR;
    cchMaxValChars : integer) : HResult stdcall;

  DrawThemeParentBackground : function (
    hwnd : HWND;
    hdc : HDC;
    prc : PRect) : HResult stdcall;

  EnableTheming : function (
    fEnable : BOOL) : HResult stdcall;

function UseThemes : boolean;

//============================================================================

implementation

//============================================================================

{$R mdTHEMES.res}

const
  THEME_DLL = 'uxtheme.dll';

var
  fThemeAPILoaded : boolean;
  hThemeAPI : THandle;

//----------------------------------------------------------------------------
function UseThemes : boolean;
//----------------------------------------------------------------------------

begin
  if fThemeAPILoaded then
    result:= (IsThemeActive and IsAppThemed)
  else
    result:= false;
end;

//----------------------------------------------------------------------------
procedure LoadThemeAPI;
//----------------------------------------------------------------------------

var
  iErrorMode : integer;

begin
  fThemeAPILoaded:= false;

  iErrorMode:= SetErrorMode(SEM_NOOPENFILEERRORBOX);
  hThemeAPI:= LoadLibrary(THEME_DLL);
  SetErrorMode(iErrorMode);

  if (hThemeAPI <> 0) then
  begin
    @OpenThemeData:= GetProcAddress(hThemeAPI,'OpenThemeData');
    @CloseThemeData:= GetProcAddress(hThemeAPI,'CloseThemeData');
    @DrawThemeBackground:= GetProcAddress(hThemeAPI,'DrawThemeBackground');
    @DrawThemeText:= GetProcAddress(hThemeAPI,'DrawThemeText');

    //----------------------------------------------------------------------

    @GetThemeBackgroundContentRect:= GetProcAddress(hThemeAPI,'GetThemeBackgroundContentRect');
    @GetThemeBackgroundExtent:= GetProcAddress(hThemeAPI,'GetThemeBackgroundExtent');
    @GetThemeTextExtent:= GetProcAddress(hThemeAPI,'GetThemeTextExtent');
    @GetThemePartSize:= GetProcAddress(hThemeAPI,'GetThemePartSize');
    @GetThemeTextMetrics:= GetProcAddress(hThemeAPI,'GetThemeTextMetrics');
    @GetThemeBackgroundRegion:= GetProcAddress(hThemeAPI,'GetThemeBackgroundRegion');
    @HitTestThemeBackground:= GetProcAddress(hThemeAPI,'HitTestThemeBackground');
    @DrawThemeEdge:= GetProcAddress(hThemeAPI,'DrawThemeEdge');
    @DrawThemeIcon:= GetProcAddress(hThemeAPI,'DrawThemeIcon');
    @IsThemePartDefined:= GetProcAddress(hThemeAPI,'IsThemePartDefined');
    @IsThemeBackGroundPartiallyTransparent:= GetProcAddress(hThemeAPI,'IsThemeBackgroundPartiallyTransparent');

    //----------------------------------------------------------------------

    @GetThemeColor:= GetProcAddress(hThemeAPI,'GetThemeColor');
    @GetThemeMetric:= GetProcAddress(hThemeAPI,'GetThemeMetric');
    @GetThemeString:= GetProcAddress(hThemeAPI,'GetThemeString');
    @GetThemeBool:= GetProcAddress(hThemeAPI,'GetThemeBool');
    @GetThemeInt:= GetProcAddress(hThemeAPI,'GetThemeInt');
    @GetThemeEnumValue:= GetProcAddress(hThemeAPI,'GetThemeEnumValue');
    @GetThemePosition:= GetProcAddress(hThemeAPI,'GetThemePosition');
    @GetThemeFont:= GetProcAddress(hThemeAPI,'GetThemeFont');
    @GetThemeRect:= GetProcAddress(hThemeAPI,'GetThemeRect');
    @GetThemeMargins:= GetProcAddress(hThemeAPI,'GetThemeMargins');
    @GetThemeIntList:= GetProcAddress(hThemeAPI,'GetThemeIntList');
    @SetWindowTheme:= GetProcAddress(hThemeAPI,'SetWindowTheme');
    @GetThemeFilename:= GetProcAddress(hThemeAPI,'GetThemeFilename');
    @GetThemeSysColor:= GetProcAddress(hThemeAPI,'GetThemeSysColor');
    @GetThemeSysColorBrush:= GetProcAddress(hThemeAPI,'GetThemeSysColorBrush');
    @GetThemeSysBool:= GetProcAddress(hThemeAPI,'GetThemeSysBool');
    @GetThemeSysSize:= GetProcAddress(hThemeAPI,'GetThemeSysSize');
    @GetThemeSysFont:= GetProcAddress(hThemeAPI,'GetThemeSysFont');
    @GetThemeSysString:= GetProcAddress(hThemeAPI,'GetThemeSysString');
    @GetThemeSysInt:= GetProcAddress(hThemeAPI,'GetThemeSysInt');
    @IsThemeActive:= GetProcAddress(hThemeAPI,'IsThemeActive');
    @IsAppThemed:= GetProcAddress(hThemeAPI,'IsAppThemed');
    @GetWindowTheme:= GetProcAddress(hThemeAPI,'GetWindowTheme');
    @EnableThemeDialogTexture:= GetProcAddress(hThemeAPI,'EnableThemeDialogTexture');
    @IsThemeDialogTextureEnabled:= GetProcAddress(hThemeAPI,'IsThemeDialogTextureEnabled');
    @GetThemeAppProperties:= GetProcAddress(hThemeAPI,'GetThemeAppProperties');
    @SetThemeAppProperties:= GetProcAddress(hThemeAPI,'SetThemeAppProperties');
    @GetCurrentThemeName:= GetProcAddress(hThemeAPI,'GetCurrentThemeName');
    @GetThemeDocumentationProperty:= GetProcAddress(hThemeAPI,'GetThemeDocumentationProperty');
    @DrawThemeParentBackground:= GetProcAddress(hThemeAPI,'DrawThemeParentBackground');
    @EnableTheming:= GetProcAddress(hThemeAPI,'EnableTheming');

    fThemeAPILoaded:= true;
  end;
end;

//----------------------------------------------------------------------------
procedure UnloadThemeAPI;
//----------------------------------------------------------------------------

begin
  if fThemeAPILoaded then
  begin
    fThemeAPILoaded:= false;
    FreeLibrary(hThemeAPI);
  end;
end;

//============================================================================

initialization

//============================================================================

begin
  LoadThemeAPI;
end;

//============================================================================

finalization

//============================================================================

begin
  UnloadThemeAPI;
end;

//============================================================================

end.






