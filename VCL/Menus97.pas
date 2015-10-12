////////////////////////////////////////////////////////////////////////////////
// MENUS97                                                                    //
////////////////////////////////////////////////////////////////////////////////
// Menu Style 97 pour D3 (D2 ?)                                               //
////////////////////////////////////////////////////////////////////////////////
// Version 1.59 Beta                                                          //
// Date de création           : 02/07/1997                                    //
// Date dernière modification : 15/03/1998                                    //
////////////////////////////////////////////////////////////////////////////////
// Stéphane Chova        stephane.chova@hol.fr                                //
// Jean-Luc Mattei       jlucm@club-internet.fr / jlucm@mygale.org            //
// TSystemMenus97 original idea from                                          //
// * Sylvain Cresto                                                           //
// Portion of code from                                                       //
// * TSystemMenu      - Sylvain Cresto                                        //
//                      e-mail : sylvain.cresto@hol.fr                        //
// * TExplorerButton  - Fabrice Deville                                       //
//                      e-mail : fdev@tornado.be                              //
//                      WWW    : http://www.tornado.be/~fdev/                 //
// * TMSOfficeCaption - Warren F. Young                                       //
//                      e-mail : wfy@ee.ed.ac.uk or Warren.Young@ee.ed.ac.uk  //
//                      WWW    : http://www.ee.ed.ac.uk/~wfy/components.html  //
// Thanks to                                                                  //
// * Richard Alimi                                                            //
// * Ian Delisle                                                              //
// * Tom Deprez                                                               //
// * Torben Falck                                                             //
// * Olivier Grosclaude                                                       //
// * Edwin Hagen                                                              //
// * Jérome Hersant                                                           //
// * Stefan Hoffmann                                                          //
// * Steven Kamradt                                                           //
// * Kevin Lu                                                                 //
// * Arturo Monge                                                             //
// * Walter Nogueira Freire                                                   //
// * Alexander Obukhov                                                        //
// * Bart Pelgrims                                                            //
// * Larry Pierce                                                             //
// * Saverio Pieri                                                            //
// * Christian Poisson                                                        //
// * Glen Verran                                                              //
// * to be continued ...                                                      //
////////////////////////////////////////////////////////////////////////////////
// IMPORTANT NOTICE :                                                         //
//                                                                            //
// This program is FreeWare                                                   //
//                                                                            //
// Please do not release modified versions of this source code.               //
// If you've made any changes that you think should have been there,          //
// feel free to submit them to me at jlucm@club-internet.fr                   //
////////////////////////////////////////////////////////////////////////////////
// NOTES :                                                                    //
//                                                                            //
//     * MENUS97 AND MSOFFICECAPTION (Warren F. Young) :                      //
//       MSOFFICECAPTION MUST BE BEFORE MENUS97 IN CREATION ORDER             //
//                                                                            //
//     * MENUS97 AND TOOLBARBUTTON97 (Jordan Russell)                         //
//       - If you're using ToolbarButton97 Version 1.54 or greater you must   //
//         change Click code :                                                //
//                                                                            //
//         Replace this code                                                  //
//                                                                            //
//          with DropdownMenu do begin                                        //
//            PopupComponent := Self;                                         //
//            { Starting with version 1.54, this avoids using the Popup method//
//              of TPopupMenu because it uses the "track right button" flag   //
//              (which disallowed the "click and drag" selecting motion many  //
//              people are accustomed to). }                                  //
//            if Assigned(OnPopup) then                                       //
//              OnPopup (DropdownMenu);                                       //
//            TrackPopupMenu (Handle, AlignFlags[Alignment] or                //
//                            ButtonFlags[NewStyleControls],                  //
//              PopupPoint.X, PopupPoint.Y, 0, DropdownList.Window, nil);     //
//          end;                                                              //
//        end                                                                 //
//                                                                            //
//        by this one                                                         //
//                                                                            //
//          with DropdownMenu do                                              //
//            Popup(PopupPoint.x, PopupPoint.y);                              //
//        end;                                                                //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////
// REVISIONS :                                                                //
//                                                                            //
//  - 1.20 : * CalcTextWidht Modified ( Accelerators (&) )                    //
//           * HOW TO USE Section                                             //
//           * OnDrawItem Event is called now                                 //
//           * ImageList can be changed at runtime without a GPF              //
//           * Menu can be changed at runtime without GPF                     //
//             (thanks to Edwin Hagen)                                        //
//           * Accelerator Keys works fine now for all items                  //
//           * OnDrawItemEvent is called now                                  //
//  - 1.30 : * CM_MENUCHANGED event added                                     //
//           * Added First Menu Banner                                        //
//  - 1.31 : * Shortcut drawing Bug corrected (thanks to Ian Delisle)         //
//  - 1.32 : * Shortcut drawing Bug (really) corrected (now)                  //
//           * Correct HighLighted Text Color for MenuItems (with Bitmap)     //
//           * Shortcuts disableds for disabled items (thanks - again -       //
//             to Ian Delisle)                                                //
//  - 1.33 : * ItemHeight Bug Corrected                                       //
//           * Some minor bugs corrected                                      //
//           * HiLite Font Bug corrected                                      //
//           * (thanks to Christian Poisson and Kevin Lu)                     //
//  - 1.34 : * Drawing Bug corrected                                          //
//           * Supports Break property                                        //
//           * Disabled items don't open submenus (arrow is still badly paint)//
//           * (thanks to Kevin Lu - again )                                  //
//  - 1.40 : * Added custom classes                                           //
//           * Many things changed                                            //
//           * TMainMenus97, TPopupMenus97 and TSystemMenus97 classes added   //
//           * DrawItem Method changed                                        //
//           * Component editor added to auto-fill tags (ContextMenu)         //
//           * TSystemMenus97 class added (Original idea and some portions of //
//             code are from Sylvain CRESTO)                                  //
//           * WindowMenu items works now (Opened MDI Window Items)           //
//           * Works with MDI Child Menus (Main, Popup & System)              //
//  - 1.41 : * Added FontChange method to reflect changes on MenuBar          //
//             Reflects : Font, HiliteFont and Brush Changes                  //
//             (Thanks to Kevin Lu)                                           //
//  - 1.42 : * DrawItem Modified now works with any size of image             //
//             (Thanks to Christian Poisson)                                  //
//           * DrawMenuBar is called only with TMainMenus97 component         //
//           * Some Methods visibility modification                           //
//           * HideMenuBar property added to MainMenus for future use...      //
//           * ToolBar property added for future use...                       //
//           * Banners are allowed on popups and system menus                 //
//             (Thanks to Jérome Hersant)                                     //
//           * Menus97Look property added (Office97 or IE4)                   //
//             (Thanks to Walter Nogueira Freire)                             //
//           * TMenuBar97 & TMenuSpeedButton component added for future use ..//
//           * MenuHook function added for future use...                      //
//           * DON'T USE TOOLBAR PROPERTY IN THIS VERSION ... IT'S UNDER      //
//             CONSTRUCTION                                                   //
//  - 1.43 : * Disabled item flickering have been minimized                   //
//             (thanks to Arturo Monge)                                       //
//  - 1.44 : * (really) Stupid bug corrected with popup menus : FTPUHandle was//
//             null after first popup (Member of TCustomPopupMenus97)         //
//           * now you can add dynamically items to a popup it works :-)      //
//             (thanks to bart pelgrims)                                      //
//           * Little drawing bug corrected (Office97Look)                    //
//  - 1.45 : * Banner rect is calculated one time and works whith             //
//             "Multicolumns menus" (thanks to Bart Pelgrims)                 //
//           * "abstract" error when changing font or brush on popups is      //
//             corrected (thanks to Kevin Lu and Saverio Pieri)               //
//  - 1.46 : * PopupMenu SubMenus don't have any more "banner space"          //
//             (thanks to Kevin Lu, Saverio Pieri and Torben Falck)           //
//           * BarBreak is correctly repaint when submenu is open/closed      //
//  - 1.47 : * BannerImage property default is now set to -1                  //
//           * No more "Access Violation" errors when an item caption is empty//
//           * DT_EXPANDTABS added in DrawItem                                //
//           * Some minor bugs corrected                                      //
//             (thanks to Olivier Grosclaude)                                 //
//           * Hints are correctly handled now                                //
//           * new OnHint event added (thanks to Steven Kamradt)              //
//  - 1.48 : * Many little (but important) modifications in Measuring and     //
//             Drawing Functions (thanks to Olivier Grosclaude)               //
//           * Compiles under D2 without errors (csReflector and Flat)        //
//             (Thanks to Tom Deprez)                                         //
//           * No more errors when no popupmenu is selected in a TSystemMenu  //
//             and no unwanted separator drawn (thanks to Alexander Obukhov)  //
//           * DefaultFont property added                                     //
//  - 1.49 : * Submenu items with submenu have correct size now if no banner  //
//             is enabled                                                     //
//           * MenuBarBreak is correctly drawn when there's no banner         //
//  - 1.50 : * DrawDisabledimages works now with NT 4&5                       //
//             (Thanks to Microsoft for their "unified API")                  //
//           * Strange (and hard to find without NT 4) bug with PopupsMenus   //
//             and NT4 corrected (thanks to Torben Falk and Saverio Pieri for //
//             their time and informations)                                   //
//             Never happends under Win95 Win98 or NT 5                       //
//           * dcr added for SystemMenus and MenuToolBar                      //
//             (thanks to Arturo Monge)                                       //
//  - 1.51 : * AnsiString added for GetVerb (compiles with short strings      //
//             compiler options on) (thanks to Larry Pierce)                  //
//           * IsNTPlatform flag used to draw correctly disbled image         //
//             (replace compiler directive introduced in V 1.50)              //
//  - 1.52 : * Gradient Fill for Banners                                      //
//           * Images allowed in MenuBar (Tag >= 256)                         //
//           * HiliteFont Change & Font Change initialisation                 //
//           * Banner is stored in a "BannerBmp" for speed                    //
//           * A "Little bug" in IsNTPlatform initialization corrected        //
//             (NT was never detected !)                                      //
//           * If you plan to use Warren F. Young MSOffice Caption            //
//             MSOFFICECAPTION MUST BE BEFORE MENUS97 IN CREATION ORDER       //
//  - 1.53 : * Stupid debugging MessageBeep removed (for NT User only)        //
//           * MenusItems added dynamically in a OnClick Event are handled    //
//             correctly now (except under NT4)                               //
//           * NT4 USERS : Never add items dynamically in OnClick event       //
//             or Menu drawing will hang (if someone know why ...)            //
//             If you want to add items add them in OnPopup event.            //
//             Win95, Win98 and NT5 users : all's working fine                //
//  - 1.54 : * DefaultMargin value modified to Handle Item Text Width when    //
//             No ImageList is assigned                                       //
//           * DefaultHeight value modified to Handle Item Text Height when   //
//             No ImageList is assigned                                       //
//           * Little corrections in CalcMenuWidth (usefull when no imagelist //
//             are used                                                       //
//  - 1.55 : * SystemMenus97 popup bug corrected                              //
//  - 1.56 : * Toolbar property works with non mdiForms but V 1.42 warning is //
//             still here... (thanks to Stefan Hoffmann)                      //
//  - 1.57 : * TPUtilWindowsProc Hook chain is now correctly maintained       //
//             (Thanks to Saverio Pieri)                                      //
//           * Many unused messages removed for speed                         //
//           * CalcMenuBarHeight function added                               //
//           * ToolbarHeight is ok now (thanks to Stefan Hoffmann)            //
//  - 1.58 : * MenuBar items order bug corrected (with keyboard)              //
//  - 1.59 : * Now compile with or without {$T} compiler directive (thanks to //
//             Richard Alimi)                                                 //
//  - 1.60 : * ToolbarButton97 popup problem found (with version greater than //
//             1.53 (see NOTE section)                                        //                  
////////////////////////////////////////////////////////////////////////////////
// HOW TO USE :                                                               //
//                                                                            //
// - V 1.00 - V 1.3X  :                                                       //
//   * Use a standard Menu component : M                                      //
//   * Add a Menu97 component        : M97                                    //
//   * Link M to Menu property of M97                                         //
//   * Add an image list L and Link L to Image Property of M97                //
//   * Apparence of items is controlled by Tag Property                       //
//       - Standard MenuBarItem  : Tag = -1 (3D look)                         //
//       - Standard PopupItem    : Tag = -2 (Standard Look)                   //
//       - PopupItem with Bitmap : Tag = n° of Bitmap in ImageList            //
//                                                                            //
// - V 1.4X :                                                                 //
// +  MAIN and POPUP Menus                                                    //
//   * Use a standard Menu component (MainMenu or PopupMenu): M               //
//   * Add a Menu97 component (TMainMenu97 ot TPopupMenu97) : M97             //
//   * Link M to Menu property of M97                                         //
//   * Add an image list L and Link L to Image Property of M97                //
//   * Apparence of items is controlled by Tag Property                       //
//       - 3D Item               : Tag = -1 (3D look)                         //
//       - 3D Item With Bitmap   : Tag = 256 + n° of Bitmap in ImageList      //
//                                  (3D Look + Bitmap)                        //
//       - Standard PopupItem    : Tag = -2 (Standard Look)                   //
//       - PopupItem with Bitmap : Tag = n° of Bitmap in ImageList            //
//                                                                            //
// +  SYSTEM Menus                                                            //
//   * Use a standard Popup component : M                                     //
//   * Add a SystemMenus97 component  : M97                                   //
//   * Link M to PopupMenu property of M97                                    //
//   * Add an image list L and Link L to Image Property of M97                //
//   * Select ImageIndex for Standard Commands : SCxxxxx                      //
//   * New Items are added before SC_CLOSE command (if exists)                //
//   * Apparence of items is controlled by Tag Property                       //
//       - 3D Item               : Tag = -1 (3D look)                         //
//       - 3D Item With Bitmap   : Tag = 256 + n° of Bitmap in ImageList      //
//                                  (3D Look + Bitmap)                        //
//       - Standard PopupItem    : Tag = -2 (Standard Look)                   //
//       - PopupItem with Bitmap : Tag = n° of Bitmap in ImageList            //
////////////////////////////////////////////////////////////////////////////////

Unit Menus97;

interface

uses
  Windows, SysUtils, Classes, Messages, Menus, Forms, Buttons, ComCtrls,
  Controls, StdCtrls, Graphics, CommCtrl, ExtCtrls, DIALOGS,ImgList, VCLEditors, DesignEditors;

// Remove this line if you have duplicate resources compiler error
{$R MENUS97.DCR} // Charge l'icône du composant.
                 // Component icon
{$R *.RES}       // Charge la marque Check pour l'option Checked.
                 // Check Mark

type
  TDrawMenuItemEvent = function(Control: TMenu; Item: TMenuItem; Rect: TRect; State: TOwnerDrawState): boolean of object;
  TMeasureMenuItemEvent = procedure(Control: TMenu; Item: TMenuItem; var Height, Width: Integer) of object;
  THintEvent = function(Control: TMenu; Item: TMenuItem; Hint: String): String of object;
  TBannerJustification = (bjCenter, bjTop, bjBottom);
  TMenus97Look = (mlOffice97Look, mlIE4Look);

  TMenuState = (msInactive, msActive, msActiveDrop);

  TMenuSpeedButton = class(TSpeedButton)
  private
    FM97Handle: THandle;
    FInDown: Boolean;
    FMenuState: TMenuState;
  protected
    procedure SetMenuState(Value : TMenuState);
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure CMDialogChar(var Message: TCMDialogChar); message CM_DIALOGCHAR;
  public
    procedure Paint; override;
    property MenuState: TMenuState read FMenuState write SetMenuState;
  end;

  TCustomMenuBar97 = class(TCustomPanel)
  private
    FInMenuBar: Boolean;
    FMenuOpen: Boolean;
    FActiveControl: Integer;
  protected
  public
    procedure CreateParams(var Params: TCreateParams); override;
    constructor Create(AOwner: TComponent); override;
    procedure WndProc(var Message: TMessage); override;
  end;

  TMenuBar97 = class(TCustomMenuBar97)
    property Align;
    property Alignment;
    property BevelInner;
    property BevelOuter;
    property BevelWidth;
    property BorderWidth;
    property BorderStyle;
    property DragCursor;
    property DragMode;
    property Enabled;
    property FullRepaint;
    property Caption;
    property Color;
    property Ctl3D;
    property Font;
    property Locked;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnStartDrag;
  end;

  TCustomMenus97 = class(TComponent)
  private
    FImages: TImageList;
    FImageChangeLink: TChangeLink;
    FCanvas: TCanvas;
    FMenu: TMenu;
    FFont: TFont;
    FBrush: TBrush;
    FItemHeight: Integer;
    FItemWidth: Integer;
    FNewTFormWndProcInstance: Pointer;
    FOldTFormWndProc: Pointer;
    FOnDrawItem: TDrawMenuItemEvent;
    FOnHint: THintEvent;
    FOnMeasureItem: TMeasureMenuItemEvent;
    FHiliteBar : TColor;
    FHiliteFont : TFont;
    FDefaultMargin: Integer;
    FDefaultHeight: Integer;
    FRadioBitmap : TBitmap;
    FCheckBitmap : TBitmap;
    FBanner: Boolean;
    FBannerText: String;
    FBannerFont: TFont;
    FBannerWidth: Integer;
    FBannerColor: TColor;
    FBannerEndColor: TColor;
    FBannerNumColors: Integer;
    FBannerJustification: TBannerJustification;
    FBannerImage: Integer;
    FMDIList: TList;
    FInitOk: Boolean;
    FMenus97Look: TMenus97Look;
    FBannerRect: TRect;
    FNeedBannerRect: Boolean;
    FDefaultFont: Boolean;
    FBannerBmp: TBitmap;
    FMenuBarSelID: Integer;
    Procedure SetImages (Value: TImageList);
    procedure SetInternalMenu(Value: TMenu); virtual;
    procedure SetFont(Value: TFont);
    procedure SetHiliteFont (Value : Tfont);
    procedure SetBannerFont(Value: TFont);
    procedure SetBrush(Value: TBrush);
    procedure SetMenus97Look(Value: TMenus97Look);
    procedure WMDrawItem(var Message: TWMDrawItem); message WM_DRAWITEM;
    //procedure CNDrawItem(var Message: TWMDrawItem); message CN_DRAWITEM;
    procedure WMMeasureItem(var Message: TWMMeasureItem); message WM_MEASUREITEM;
    //procedure CNMeasureItem(var Message: TWMMeasureItem); message CN_MEASUREITEM;
    procedure DrawItem(Item: TMenuItem; Rect: TRect; State: TOwnerDrawState); virtual;
    procedure MeasureItem(Item: TMenuItem; var Height, Width: Integer); virtual;
    //procedure InternalModifyMenu(Command: Integer; Caption: String; Restore: Boolean); virtual;
    procedure ModifyMenuTree(MenuItems : TMenuItem; Restore: Boolean); virtual;
    procedure DrawDisabledImage(Var Rect : TRect; IndexImage : Integer);
    procedure DrawDisabledImageNT(Var Rect : TRect; IndexImage : Integer);
    procedure DrawDisabledImage95(Var Rect : TRect; IndexImage : Integer);
    function  CalcMenuWidth(Item: TMenuItem): Integer;
    function  CalcMenuHeight(Item: TMenuItem): Integer;
    function  ProcessAccel(Message: TWMMenuChar ): Integer;
    function  FindItemByCommand(Command: Word): TMenuItem; virtual;
    procedure InternalModifyMenuTree(MenuItems : TMenuItem; Level: Integer); virtual;
    procedure ReleaseMDIList;
    procedure FontChange(Sender: TObject); virtual;
    procedure HiliteFontChange(Sender: TObject); virtual;
    procedure BrushChange(Sender: TObject); virtual;
    procedure DrawMenuBarItem(Item: TMenuItem; Var Rect: TRect; State: TOwnerDrawState); virtual;
    procedure DrawItemText(Item: TMenuItem; Var Rect: TRect; Text: String);
    procedure CalcBannerRect; virtual;
    function  HasBanner(Item: TMenuItem): boolean; virtual;
    function  GetTextSize(ACanvas: TCanvas; Text: string ): TSize;
    function  IsFontStored: Boolean;
    procedure SetDefaultFont(Value: Boolean);
    procedure GetDefaultMenuFont(Var aFont: TFont);
    function  CalcMenuBarHeight: Integer; virtual;
    procedure GradientFill(DC: HDC; FBeginColor, FEndColor: TColor; R: TRect);
  protected
    procedure Loaded; override;
    procedure Notification (AComponent: TComponent; Operation: TOperation); override;
    procedure FixupReferences; virtual;
    property  InternalMenu: TMenu read FMenu write SetInternalMenu;
  public
    procedure   Office97Mapping; virtual;
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure   NewTFormWndProc(Var Message: TMessage); virtual;
    property BannerImage: Integer read FBannerImage write FBannerImage default -1;
    property BannerJustification: TBannerJustification read FBannerJustification write FBannerJustification;
    property BannerWidth: Integer read FBannerWidth write FBannerWidth;
    property BannerText: String read FBannerText write FBannerText;
    property BannerFont: TFont read FBannerFont write SetBannerFont;
    property BannerColor: TColor read FBannerColor write FBannerColor default clActiveCaption;
    property BannerEndColor: TColor read FBannerEndColor write FBannerEndColor default clBlack;
    property BannerNumColors: Integer read FBannerNumColors write FBannerNumColors default 16;
    property Banner: Boolean read FBanner write FBanner;
    property OnDrawItem: TDrawMenuItemEvent read FOnDrawItem write FOnDrawItem;
    property OnHint: THintEvent read FOnHint write FOnHint;
    property OnMeasureItem: TMeasureMenuItemEvent read FOnMeasureItem write FOnMeasureItem;
    property ItemHeight: Integer read FItemHeight write FItemHeight;
    property ItemWidth: Integer read FItemWidth write FItemWidth;
    property Images: TImageList read FImages write SetImages;
    property Font: TFont read FFont write SetFont stored IsFontStored;
    property Brush: TBrush read FBrush write SetBrush;
    property Canvas: TCanvas read FCanvas;
    property HiliteBar : Tcolor read FHiliteBar write FHiliteBar;
    property HiliteFont : TFont read FHiliteFont write SetHiliteFont stored IsFontStored;
    property Menus97Look: TMenus97Look read FMenus97Look write SetMenus97Look default mlOffice97Look;
    property DefaultFont: Boolean read FDefaultFont write SetDefaultFont default True;
  end;

  TCustomMainMenus97 = class(TCustomMenus97)
  private
    FHideMenuBar: Boolean;
    FPushedButton: Boolean;
    FHitTest: Boolean;
    FHitPos: Integer;
    FToolBar: TCustomMenuBar97;
    FMenuOpen: Boolean;
    procedure SetMainMenu(Value: TMainMenu);
    procedure SetHideMenuBar(Value: Boolean);
    procedure SetToolBar(Value: TCustomMenuBar97);
    function  GetMainMenu: TMainMenu;
    procedure DrawMenuBarItem(Item: TMenuItem; Var Rect: TRect; State: TOwnerDrawState); override;
    procedure FontChange(Sender: TObject); override;
    function  CalcMenuBarHeight: Integer; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure NewTFormWndProc(Var Message: TMessage); override;
    property MainMenu: TMainMenu read GetMainMenu write SetMainMenu;
    property HideMenuBar: Boolean read FHideMenuBar write SetHideMenuBar default False;
    property ToolBar: TCustomMenuBar97 read FToolBar write SetToolBar;
  end;

  TMainMenus97 = class(TCustomMainMenus97)
  published
    property BannerImage;
    property BannerJustification;
    property BannerWidth;
    property BannerText;
    property BannerFont;
    property BannerColor;
    property BannerEndColor;
    property BannerNumColors;
    property Banner;
    property MainMenu;
    property OnDrawItem;
    property OnHint;
    property OnMeasureItem;
    property ItemHeight;
    property ItemWidth;
    Property Images;
    property Font;
    property Brush;
    property Canvas;
    property HiliteBar;
    property HiliteFont;
    property HideMenuBar;
    property Menus97Look;
    property ToolBar;
    property DefaultFont;
  end;

  TCustomPopupMenus97 = class(TCustomMenus97)
  private
    FNewTPUtilWndProcInstance: Pointer;
    FOldTPUtilWndProc: Pointer;
    function  GetPopupMenu: TPopupMenu;
    procedure SetPopupMenu(Value: TPopupMenu);
    procedure CalcBannerRect; override;
    function  HasBanner(Item: TMenuItem): boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure NewTPUtilWndProc(Var Message: TMessage); virtual;
    property PopupMenu: TPopupMenu read GetPopupMenu write SetPopupMenu;
  end;

  TPopupMenus97 = class(TCustomPopupMenus97)
  published
    property BannerImage;
    property BannerJustification;
    property BannerWidth;
    property BannerText;
    property BannerFont;
    property BannerColor;
    property BannerEndColor;
    property BannerNumColors;
    property Banner;
    property PopupMenu;
    property OnDrawItem;
    property OnHint;
    property OnMeasureItem;
    property ItemHeight;
    property ItemWidth;
    Property Images;
    property Font;
    property Brush;
    property Canvas;
    property HiliteBar;
    property HiliteFont;
    property Menus97Look;
    property DefaultFont;
  end;

  TSystemMenu97ItemState = (smTrue, smFalse, smDefault);

  TCustomSystemMenus97 = class;

  TSystemMenu97Options = class(TPersistent)
  private
    FMenuItem: TMenuItem;
    FImageIndex: Integer;
    FVisible: TSystemMenu97ItemState;
    FCaption: String;
    FCommand: Integer;
    procedure MenuItemFromCommand(MenuHandle: THandle; aOwner: TCustomSystemMenus97);
  public
    constructor Create(Command: Integer);
    destructor Destroy; override;
    property MenuItem: TMenuItem read FMenuItem write FMenuItem stored False;
  published
    property ImageIndex: Integer read FImageIndex write FImageIndex default -2;
    property Visible: TSystemMenu97ItemState read FVisible write FVisible default smDefault;
    property Caption: String read FCaption write FCaption;
  end;

  TCustomSystemMenus97 = class(TCustomPopupMenus97)
  private
    FScItem: array[0..9] of TSystemMenu97Options;
    FOwnerHandle: THandle;
    FSysMenuHandle: THandle;
    FInsertBefore: Integer;
    function  FindItemByCommand(Command: Word): TMenuItem; override;
    procedure AddItemsToSytemMenu(MenuItems: TMenuItem; MenuHandle: THandle);
    procedure ModifyMenuTree(MenuItems : TMenuItem; Restore: Boolean); override;
    function  HasBanner(Item: TMenuItem): boolean; override;
    procedure CalcBannerRect; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure NewTFormWndProc(Var Message: TMessage); override;
    property scRestore: TSystemMenu97Options read FScItem[0] write FScItem[0];
    property scMove: TSystemMenu97Options read FScItem[1] write FScItem[1];
    property scSize: TSystemMenu97Options read FScItem[2] write FScItem[2];
    property scMinimize: TSystemMenu97Options read FScItem[3] write FScItem[3];
    property scMaximize: TSystemMenu97Options read FScItem[4] write FScItem[4];
    property scClose: TSystemMenu97Options read FScItem[5] write FScItem[5];
    property scNextWindow: TSystemMenu97Options read FScItem[6] write FScItem[6];
    property scPrevWindow: TSystemMenu97Options read FScItem[7] write FScItem[7];
    property scTaskList: TSystemMenu97Options read FScItem[8] write FScItem[8];
    property scScreenSave: TSystemMenu97Options read FScItem[9] write FScItem[9];
  end;

  TSystemMenus97 = class(TCustomSystemMenus97)
  published
    property BannerImage;
    property BannerJustification;
    property BannerWidth;
    property BannerText;
    property BannerFont;
    property BannerColor;
    property BannerEndColor;
    property BannerNumColors;
    property Banner;
    property PopupMenu;
    property OnDrawItem;
    property OnHint;
    property OnMeasureItem;
    property ItemHeight;
    property ItemWidth;
    Property Images;
    property Font;
    property Brush;
    property Canvas;
    property HiliteBar;
    property HiliteFont;
    property scClose;
    property scRestore;
    property scMinimize;
    property scMaximize;
    property scMove;
    property scSize;
    property scTaskList;
    property scScreenSave;
    property ScNextWindow;
    property ScPrevWindow;
    property Menus97Look;
    property DefaultFont;
  end;

procedure Register;

implementation

uses DesignIntf;

const
  FTPUCount: Integer = 0;
  FTPUHandle: THandle = 0;

var Pop: TPopupMenu;
    PopItem: TMenuItem;
    CurrentHookControl: TCustomMenuBar97;
    InternalActiveControl: TMenuSpeedButton;
    VI: TOSVersionInfo;
    IsNTPlatform: Boolean;
    FTPUtilHookList: TList;
    FOrgTPUtilWndProc: Pointer;

{ TCustomMenus97Editor }

type
  TCustomMenus97Editor = class(TDefaultEditor)
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): Ansistring; override;
    function GetVerbCount: Integer; override;
  end;

procedure TCustomMenus97Editor.ExecuteVerb(Index: Integer);
begin
  case Index of
    0: TCustomMenus97(Component).Office97Mapping;
  end;
  Designer.Modified;
end;

function TCustomMenus97Editor.GetVerb(Index: Integer): Ansistring;
begin
  case Index of
    0 : Result := 'Office97 Look';
  end;
end;

function TCustomMenus97Editor.GetVerbCount: Integer;
begin
  Result := 1;
end;

{ TMenuSpeedButton }

procedure TMenuSpeedButton.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
Var
    Pt: TPoint;
begin
  if( Not FInDown ) then begin
    FInDown:= True;
    inherited MouseDown(Button, Shift, X, Y);
    if (Button = mbLeft) and Enabled then begin
      InternalActiveControl:= Self;
      Pt:= Point(Left, Top);
      Pt:= (Owner as TCustomMenuBar97).ClientToScreen(Pt);
      TrackPopupMenu(THandle(Tag), TPM_LEFTALIGN, Pt.x, Pt.y + Height, 0, FM97Handle, nil);
    end;
  end;
end;

procedure TMenuSpeedButton.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if( FInDown ) then begin
    FInDown:= False;
    inherited MouseUp(Button, Shift, X, Y);
    if (Button = mbLeft) and Enabled then begin
      MouseUp(Button, Shift, X, Y);
    end;
  end;
end;

procedure TMenuSpeedButton.SetMenuState(Value : TMenuState);
begin
  if ( FMenuState <> Value ) then begin
    FMenuState:= Value;
    Paint;
  end;
end;

procedure TMenuSpeedButton.Paint;
//Var PaintRect: TRect;
begin
  inherited Paint;
  (*PaintRect := Rect(0, 0, Width, Height);
  case FMenuState of
    msActive     : DrawEdge(Canvas.Handle, PaintRect, BDR_RAISEDINNER, BF_RECT);
    msActiveDrop : DrawEdge(Canvas.Handle, PaintRect, BDR_RAISEDOUTER, BF_RECT);
    msInactive   : ;
  end;*)
end;

procedure TMenuSpeedButton.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseMove(Shift, X, Y);
end;

procedure TMenuSpeedButton.CMDialogChar(var Message: TCMDialogChar);
begin
  with Message do
    if IsAccel(CharCode, Caption) and Enabled then
    begin
      MouseDown(mbLeft, [], 0, 0);
      Result := 1;
    end else
      inherited;
end;

{TCustomMenuBar97}

constructor TCustomMenuBar97.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := [csAcceptsControls, csCaptureMouse, csClickEvents,
                   csSetCaption, csOpaque, csDoubleClicks, csReplicatable {$ifndef VER90}, csReflector {$endif}];
  FInMenuBar:= False;
  FMenuOpen:= False;
  FActiveControl:= 0;
  Caption:= '';
end;

procedure TCustomMenuBar97.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
end;

procedure TCustomMenuBar97.WndProc(var Message: TMessage);
begin
  case Message.Msg of
    //WM_KILLFOCUS  : if ( FInMenuBar ) then begin
    WM_GETDLGCODE : if ( FInMenuBar ) then begin
                      Message.Result:= DLGC_WANTARROWS;
                      Exit;
                    end;
    WM_SYSCOMMAND : if ( Message.wParam = SC_KEYMENU ) and ( Message.lParam = 0 ) then begin
      //case Message.wParam of
//        VK_MENU : begin
  //                  if ( GetFocus <> Handle ) then begin
                      if FMenuOpen then
                        FMenuOpen:= False;
                      //else begin
                        FInMenuBar:= Not FInMenuBar;
                        if ( FInMenuBar ) then begin
                          FActiveControl:= 0;
                          (Controls[FActiveControl] as TMenuSpeedButton).Perform(CM_MOUSEENTER, 0, 0);
                          SetFocus;
                        end
                        else
                          (Controls[FActiveControl] as TMenuSpeedButton).Perform(CM_MOUSELEAVE, 0, 0);
                      //end;
                      Message.Result:= 0;
                      Exit;
                    end;
                  //end;
      //end;
    WM_KEYDOWN :
      if ( FInMenuBar ) then begin
        case Message.wParam of
          VK_LEFT : begin

                      (Controls[FActiveControl] as TMenuSpeedButton).Perform(CM_MOUSELEAVE, 0, 0);
                      FActiveControl:= (FActiveControl+ControlCount-1) mod ControlCount;
                      (Controls[FActiveControl] as TMenuSpeedButton).Perform(CM_MOUSEENTER, 0, 0);
                      Message.Result:= 0;
                      Exit;
                    end;
          VK_RIGHT : begin
                      (Controls[FActiveControl] as TMenuSpeedButton).Perform(CM_MOUSELEAVE, 0, 0);
                      FActiveControl:= (FActiveControl +1) mod ControlCount;
                      (Controls[FActiveControl] as TMenuSpeedButton).Perform(CM_MOUSEENTER, 0, 0);
                      Message.Result:= 0;
                      Exit;
                    end;
          VK_DOWN : begin
                      if Not FMenuOpen then
                        FMenuOpen:= True;
                      (Controls[FActiveControl] as TMenuSpeedButton).MouseDown(mbLeft, [], 0, 0);
                      Message.Result:= 0;
                      Exit;
                    end;
        end;
      end;
  end;
  inherited WndProc(Message);
end;

{TCustomMenus97}

constructor TCustomMenus97.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
     // Si le menu est un MainMenu les messages arrivent à la fenêtre parente
     // donc on intercepte le gestionnaire d'évennements de la fenêtre parente

     // if We have a main menu we need to intercept TForm messages
   if ( AOwner is TForm ) then begin
     FNewTFormWndProcInstance := MakeObjectInstance(NewTFormWndProc);
     // Keep the old DefaultProc
     FOldTFormWndProc := Pointer(GetWindowLong((Owner as TForm).Handle, GWL_WNDPROC));
     // Set the new Proc
     SetWindowLong((Owner as TForm).Handle, GWL_WNDPROC, Longint(FNewTFormWndProcInstance));
   end;
   FImages:= nil;
   FImageChangeLink := TChangeLink.Create;
   FMenu:= nil;
   FCanvas:= TCanvas.Create;
   FFont:= TFont.Create;
   FHiliteFont:= TFont.create;
   GetDefaultMenuFont(FFont);
   FHiliteFont.Assign(FFont);
   FBannerFont:= TFont.create;
   FBannerFont.Name:= 'Arial';
   FBannerFont.Size:= 12;
   FBannerImage:= -1;
   FBannerWidth:= 20;
   FBannerEndColor:= clBlack;
   FBannerColor:= clActiveCaption;
   FBannerBmp:= nil;
   FBannerNumColors:= 16;
   FMenus97Look:= mlOffice97Look;
   FDefaultFont:= True;

   // Par défaut les deux fontes sont identiques
   //FHiliteFont.Assign(FFont);
   FHiliteFont.Color:= clHighlightText;
   // Couleur de sélection windows par défaut
   // Standard Windows Color for selection
   FHiliteBar:= clHighlight;

   FBrush:= TBrush.Create;
   FBrush.Color:= clBtnFace;
   FOnDrawItem:= nil;
   FOnHint:= nil;
   FOnMeasureItem:= nil;

   //Chargement de l'image pour l'option Checked & RadioItem.
   FCheckBitmap:=Tbitmap.Create;
   FRadioBitmap:=Tbitmap.Create;
   FCheckBitmap.LoadFromResourceName(HInstance,'CheckMark');
   FRadioBitmap.LoadFromResourceName(HInstance,'RadioMark');
   FDefaultMargin:= GetSystemMetrics(SM_CXMENUCHECK);
   if ( FDefaultMargin < FCheckBitmap.Width ) then
     FDefaultMargin:= FCheckBitmap.Width + 4;
   FDefaultHeight:= GetSystemMetrics(SM_CYMENUCHECK);
   if ( FDefaultHeight < FCheckBitmap.Height ) then
     FDefaultHeight:= FCheckBitmap.Height + 4;

   FItemHeight:= 0;
   FItemWidth:= 0;
   FMDILIst:= TList.Create;
   FMDIList.Capacity:= 5;
   FFont.OnChange:= FontChange;
   FHiliteFont.OnChange:= HiliteFontChange;
   FBrush.OnChange:= BrushChange;
end;

destructor TCustomMenus97.Destroy;

begin
  ReleaseMDIList;
  FMDILIst.Free;
  if ( Owner is TForm ) then begin
    //We have to set back the old default Proc of the form
    SetWindowLong((Owner as TForm).Handle, GWL_WNDPROC, Longint(FOldTFormWndProc));
    // and to release Our WndProc instance
    FreeObjectInstance(FNewTFormWndProcInstance);
  end;
  if Assigned(FBannerBmp) then
    FBannerBmp.Free;
  FImageChangeLink.Free;
  FOnDrawItem:= nil;
  FOnMeasureItem:= nil;
  FFont.Free;
  FBannerFont.Free;
  FBrush.Free;
  FCanvas.Free;
  FMenu:= nil;
  FHiliteFont.Free;
  FCheckBitmap.free;
  FRadioBitmap.free;
  inherited Destroy;
end;

function TCustomMenus97.CalcMenuBarHeight: Integer;
begin
  Result:= FItemHeight;
end;

procedure TCustomMenus97.GetDefaultMenuFont(Var aFont: TFont);
Var
  NCMetrics: TNonClientMetrics;

begin
  NCMetrics.cbSize:= sizeof(NCMetrics);
  SystemParametersInfo(SPI_GETNONCLIENTMETRICS, 0, Pointer(@NCMetrics), 0);
  with ( NCMetrics.lfMenuFont ) do begin
    aFont.Height:= lfHeight;
    if ( lfWeight > 500 ) then
      aFont.Style:= [fsBold];
    if ( lfItalic <> 0 ) then
      aFont.Style:= aFont.Style + [fsItalic];
    if ( lfUnderline <> 0 ) then
      aFont.Style:= aFont.Style + [fsUnderline];
    if ( lfStrikeOut <> 0 ) then
      aFont.Style:= aFont.Style + [fsStrikeOut];
    aFont.CharSet:= TFontCharSet(lfCharSet);
    aFont.Pitch:= TFontPitch(lfPitchAndFamily);
    aFont.Name:= StrPAS(lfFaceName);
  end;
end;

function TCustomMenus97.IsFontStored: Boolean;
begin
  Result:= Not FDefaultFont;
end;

procedure TCustomMenus97.SetDefaultFont(Value: Boolean);
begin
  if ( Value <> FDefaultFont ) then begin
    FDefaultFont:= Value;
    if ( Value ) then begin
      GetDefaultMenuFont(FFont);
      FHiliteFont.Assign(FFont);
    end;
  end;
end;

procedure TCustomMenus97.ReleaseMDIList;
Var i: Integer;
begin
  for i:= 0 to FMDIList.Count - 1 do begin
    TMenuItem(FMDIList.Items[i]).Free;
  end;
  FMDIList.Clear;
end;

procedure TCustomMenus97.FontChange(Sender: TObject);
Var aFont: TFont;
begin
  FDefaultFont:= False;
  try
    aFont:= TFont.Create;
    GetDefaultMenuFont(aFont);
    if ( FHiliteFont = aFont ) then
      FHiliteFont.Assign(FFont);
  finally
    aFont.Free;
  end;
end;

procedure TCustomMenus97.HiliteFontChange(Sender: TObject);
Var aFont: TFont;
begin
  FDefaultFont:= False;
  try
    aFont:= TFont.Create;
    GetDefaultMenuFont(aFont);
    if ( FFont = aFont ) then
      FFont.Assign(FHiliteFont);
  finally
    aFont.Free;
  end;
end;

procedure TCustomMenus97.BrushChange(Sender: TObject);
begin
end;

procedure TCustomMenus97.DrawMenuBarItem(Item: TMenuItem; Var Rect: TRect; State: TOwnerDrawState);
begin
end;

procedure TCustomMenus97.Notification;
begin
     inherited Notification (AComponent, Operation);
     if (Operation = opRemove) and (AComponent = InternalMenu) then begin
       InternalMenu := nil;
     end;
end;

procedure TCustomMenus97.FixupReferences;
begin
end;

procedure TCustomMenus97.Loaded;
begin
  inherited Loaded;
end;

function TCustomMenus97.FindItemByCommand(Command: Word): TMenuItem;
var i: Integer;
begin
  Result:= InternalMenu.FindItem(Command, fkCommand);
  if ( Result = nil ) then begin
    if ( Owner is TForm ) and Assigned((Owner As TForm).WindowMenu) and ((Owner as TForm).FormStyle = fsMdiForm) then begin
      for i:= 0 to FMDIList.Count - 1 do begin
        if ( TMenuItem(FMDIList.Items[i]).HelpContext = THelpContext(Command) ) then begin
          Result:= TMenuItem(FMDIList.Items[i]);
          Exit;
        end;
      end;
    end;
  end;
end;

procedure TCustomMenus97.SetMenus97Look(Value: TMenus97Look);
begin
  if ( Value <> FMenus97Look ) then begin
    FMenus97Look:= Value;
    if (Self is TCustomMainMenus97) then DrawMenuBar((Owner as TForm).Handle);
  end;
end;

procedure TCustomMenus97.SetImages (Value: TImageList);
begin
  if ( FImages <> Value ) then begin
    if Assigned (FImages) then
      Images.UnRegisterChanges(FImageChangeLink);
    FImages := Value;
    if ( FImages <> nil ) then begin
      FDefaultMargin:= FImages.Width + 4;
      FDefaultHeight:= FImages.Height + 4;
    end
    else begin
      FDefaultMargin:= FCheckBitmap.Width + 4;
      FDefaultHeight:= FCheckBitmap.Height + 4;
    end;
  end;
end;

function TCustomMenus97.CalcMenuHeight(Item: TMenuItem): Integer;
begin
  Result:= FDefaultHeight;
  if ( Canvas.Handle = 0 ) then Exit;
  if ( FImages <> nil ) then begin
    Result:= FImages.Height + 4;
  end;
  if ( Item <> nil ) then
    if ( Result < GetTextSize(Canvas, Item.Caption).Cy+4 ) then
      Result:= GetTextSize(Canvas, Item.Caption).Cy+4;
end;


function TCustomMenus97.GetTextSize(ACanvas: TCanvas; Text: string ): TSize;
var
  aRect: TRect;

begin
  aRect:= Rect(0, 0, 0, 0);
  DrawText( ACanvas.Handle, PChar(AnsiString(Text)), -1, aRect, DT_LEFT
            or DT_SINGLELINE or DT_EXPANDTABS or DT_CALCRECT );
  Result.cx := aRect.Right - aRect.Left;
  Result.cy := aRect.Bottom - aRect.Top + 2;
  //GetTextExtentPoint32(ACanvas.Handle, PChar(AnsiString(Text)), Length(Text), Result);
  //Result.Cy:= Result.Cy + 2;
end;

// Calcul de la largeur maxi du menu (avec accelerateurs et sous-menus)
// Max Menu Width Calculation
function TCustomMenus97.CalcMenuWidth(Item: TMenuItem): Integer;
Var
  i: Integer;
  MaxTextWithAccel: Integer;
  MaxText: Integer;
  MaxAccel: Integer;
  TmpTextWidth: Integer;
  TmpAccelWidth: Integer;
  ParentItem: TMenuItem;

begin
  Result:= 0;
  //ParentItem:= nil;
  if ( Canvas.Handle = 0 ) then Exit;
  MaxTextWithAccel:= 0;
  MaxText:= 0;
  MaxAccel:= 0;
  if (Item.Tag = -1 ) or ( Item.Tag > 255 ) then begin
    Result:= GetTextSize(Canvas, Item.Caption).Cx + 5;
    if ( Item.Tag > 255 ) and ( FImages <> nil ) then
      Result:= Result + FImages.Width + 2;
  end
  else begin
    ParentItem:= Item.Parent;
    if ( ParentItem = nil ) then begin
      ParentItem:= Item;
      TmpTextWidth:= GetTextSize(Canvas, Item.Caption).Cx;
      TmpAccelWidth:= GetTextSize(Canvas, ShortCutToText(Item.ShortCut)).Cx;
      MaxTextWithAccel:= TmpTextWidth;
      MaxAccel:= TmpAccelWidth;
      MaxText:= TmpTextWidth;
    end;
    for i:= 0 to ParentItem.Count - 1 do begin
      TmpTextWidth:= GetTextSize(Canvas, ParentItem[i].Caption).Cx;
      if ( ParentItem[i].Count > 0 ) then
        TmpTextWidth:= TmpTextWidth + FDefaultMargin
      else
        if ( ParentItem.Count < 2 ) then
          TmpTextWidth:= TmpTextWidth + FDefaultMargin Div 2;
      TmpAccelWidth:= GetTextSize(Canvas, ShortCutToText(ParentItem[i].ShortCut)).Cx;
      if MaxText < TmpTextWidth then
        MaxText:= TmpTextWidth;
      if ( MaxTextWithAccel < TmpTextWidth ) and ( TmpAccelWidth > 0 ) then
        MaxTextWithAccel:= TmpTextWidth;
      if ( MaxAccel < TmpAccelWidth ) then
        MaxAccel:= TmpAccelWidth;
    end;
    if ( ( MaxTextWithAccel + MaxAccel + FDefaultMargin ) > MaxText ) and ( MaxAccel > 0 ) then
      Result:= MaxTextWithAccel + MaxAccel + 2*FDefaultMargin
    else
      Result:= MaxText + 1*FDefaultMargin;
  end;
  if pos('&', Item.Caption) > 0 then
    Result:= Result - Canvas.TextWidth('&');
  if ( HasBanner(Item) ) then //((Self is TCustomPopupMenus97) or (InternalMenu.Items[0] = ParentItem )) And ( Banner ) ) then
    Result:= Result + FBannerWidth;
end;

function TCustomMenus97.ProcessAccel( Message: TWMMenuChar ): Integer;

 function FindAccelerator(MenuItems: TMenuItem): Integer;
  var i: Integer;

  begin
    Result:= -1;
    for i:= 0 to MenuItems.Count - 1 do begin
      if ( Result = -1 ) and (MenuItems[i].Enabled) then begin
        if ( MenuItems.Handle <> Message.Menu ) then
          Result:= FindAccelerator(MenuItems[i]);
        if ( MenuItems.Handle = Message.Menu ) then
          if ( IsAccel(Word(Message.User), MenuItems[i].Caption) ) then begin
            Result:= MenuItems[i].MenuIndex
          end;
      end;
    end;
  end;

begin
  Result:= -1;
  if ( csDesigning in ComponentState ) then Exit;
  if ( InternalMenu <> nil ) then
    Result:= FindAccelerator(InternalMenu.Items);
end;

(*procedure TCustomMenus97.InternalModifyMenu(Command: Integer; Caption: String; Restore: Boolean);
Var
  MI: TMenuItemInfo;
  C : array[0..10] of Char;

begin
    if ( Caption = '-' ) then Exit;
    MI.cbSize:= Sizeof(TMenuItemInfo);
    MI.fMask:= MIIM_TYPE or MIIM_DATA;
    MI.fType:= 0;
    MI.cch:= 0;
    MI.dwTypeData:= nil;
    GetMenuItemInfo(InternalMenu.Handle, Command, False, MI);
    MI.cbSize:= Sizeof(TMenuItemInfo);
    MI.fMask:= MIIM_TYPE or MIIM_DATA;
      if ( ( MI.fType and MFT_OWNERDRAW ) <> MFT_OWNERDRAW ) then begin
        MI.dwItemData:= Integer(Self);
        MI.fType:= MFT_OWNERDRAW;//( MI.fType and ( Not MFT_STRING ) ) or MFT_OWNERDRAW;
        SetMenuItemInfo(InternalMenu.Handle, Command, False, MI);
      end;
end;*)

procedure TCustomMenus97.ModifyMenuTree(MenuItems : TMenuItem; Restore: Boolean);
const
  EnableFlag  : array[Boolean] of Integer = (MF_GRAYED or MF_DISABLED, MF_ENABLED);
  BreakFlag : array[TMenuBreak] of Integer = (0, MF_MENUBREAK, MF_MENUBARBREAK);
Var
  i: Integer;
  MI: TMenuItemInfo;
begin
  // Parcours de l'arborescence du menu pour définir tous les items
  // comme OWNERDRAWN
  // All Items are defined as OWNERDRAWN or back to MF_STRING
  if ( MenuItems = nil ) then Exit;
  for i:= 0 to MenuItems.Count - 1 do begin
    ModifyMenuTree(MenuItems[i], Restore);
    //InternalModifyMenu(MenuItems[i].Command, MenuItems[i].Caption, Restore);

    if ( IsNTPlatform ) then begin
      MI.cbSize:= Sizeof(TMenuItemInfo);
      MI.fMask:= MIIM_TYPE;
      MI.fType:= 0;
      MI.cch:= 0;
      GetMenuItemInfo(InternalMenu.Handle, MenuItems[i].Command, False, MI);
    end;
    if ( Menuitems[i].caption <> '-' ) then begin
      if ( Restore ) then
        ModifyMenu( InternalMenu.Handle, MenuItems[i].Command,
                    MF_STRING or MF_BYCOMMAND or EnableFlag[MenuItems[i].Enabled] or BreakFlag[MenuItems[i].Break], MenuItems[i].Command, PChar(MenuItems[i].Caption))
      else begin
        //InternalModifyMenu(MenuItems[i].Command, MenuItems[i].Caption, Restore);
        if ( Not IsNTPlatform ) or ( ( MI.fType and MFT_OWNERDRAW ) <> MFT_OWNERDRAW ) then begin
          ModifyMenu( InternalMenu.Handle, MenuItems[i].Command,
                      MF_OWNERDRAW or MF_BYCOMMAND or EnableFlag[MenuItems[i].Enabled] or BreakFlag[MenuItems[i].Break], MenuItems[i].Command, Pointer(Self));
          //Form1.ListBox1.Items.Add(Name);
        end;
      end;
    end;
  end;
end;

procedure TCustomMenus97.InternalModifyMenuTree(MenuItems : TMenuItem; Level : Integer);
Var i: Integer;
begin
  if ( MenuItems = nil ) then Exit;
  for i:= 0 to MenuItems.Count - 1 do begin
    InternalModifyMenuTree(MenuItems[i], Level+1);
    if ( Menuitems[i].Tag = 0 ) then begin
      if ( Level = 0 ) and ( Not ( Self is TCustomPopupMenus97 ) ) then
        Menuitems[i].Tag:= -1
      else
        Menuitems[i].Tag:= -2;
    end;
  end
end;

procedure TCustomMenus97.Office97Mapping;
begin
  if ( Assigned ( FMenu ) ) then begin
    InternalModifyMenuTree(FMenu.Items, 0);
  end;
end;

procedure TCustomMenus97.SetInternalMenu(Value: TMenu);
begin
  if ( FMenu <> Value ) then begin
    if ( Assigned ( FMenu ) ) then begin  // we need to restore Menu's original state
      ModifyMenuTree(FMenu.Items, True);
    end;
    FMenu:= Value;
    if ( FMenu <> nil ) then begin
      ModifyMenuTree(FMenu.Items, False);
    end;
  end;
end;

(*procedure TCustomMenus97.WMDrawItem(var Message: TWMDrawItem);
begin
  CNDrawItem(Message);
end;*)

procedure TCustomMenus97.WMDrawItem(var Message: TWMDrawItem);
var
  State     : TOwnerDrawState;
  SavedDC   : Integer;
  Item      : TMenuItem;
begin
  if ( InternalMenu = nil ) then Exit;
  with Message.DrawItemStruct^ do begin
   // State := TOwnerDrawState(WordRec(LongRec(itemState).Lo).Lo);
    SavedDC:= SaveDC(hDC);
    try
      FCanvas.Handle:= hDC;
      FCanvas.Font:= FFont;
      FCanvas.Brush:= FBrush;
      if ( ItemID = FMenuBarSelID ) then
        State:= State + [odSelected];
      if (Integer(itemID) >= 0) and (odSelected in State) then begin
        FCanvas.Brush.Color := clHighlight;
        FCanvas.Font.Color := clHighlightText;
      end;
      Item:= FindItemByCommand(itemID);
      if ( Item <> nil ) then
        DrawItem(Item, rcItem, State);
      if odFocused in State then
        DrawFocusRect(hDC, rcItem);
    finally
      FCanvas.Handle := 0;
      RestoreDC(hDC, SavedDC);
    end;
  end;
  Message.Result:= longint(True);
end;

procedure TCustomMenus97.DrawItemText(Item: TMenuItem; Var Rect: TRect; Text: String);
begin
  if ( Item.Default ) then
    Canvas.Font.Style:= [fsBold];
  Canvas.Brush.Style := bsClear;
  if not (Item.Enabled) then begin
    OffsetRect(Rect,1,1);
    Canvas.Font.color:= ClbtnHighlight;
  end;
  SetBkMode(Canvas.Handle, TRANSPARENT);
  DrawText( Canvas.Handle, PChar(AnsiString(Text)),-1, Rect,
            DT_LEFT or DT_VCENTER or DT_SINGLELINE or DT_EXPANDTABS);
  if ( Item.ShortCut <> 0 ) then begin
    Dec(Rect.Right,FDefaultMargin);
    DrawText( Canvas.Handle, PChar(ShortCutToText(Item.ShortCut)),-1,
              Rect, DT_RIGHT or DT_VCENTER or DT_SINGLELINE or DT_EXPANDTABS);
  end;
  if not (Item.Enabled) then begin
    Canvas.Font.Color:= ClbtnShadow;
    OffsetRect(Rect,-1,-1);
    DrawText( Canvas.Handle, PChar(AnsiString(Text)),-1, Rect,
              DT_LEFT or DT_VCENTER or DT_SINGLELINE or DT_EXPANDTABS);
    if ( Item.ShortCut <> 0 ) then
      DrawText( Canvas.Handle, PChar(ShortCutToText(Item.ShortCut)),
                -1, Rect, DT_RIGHT or DT_VCENTER or DT_SINGLELINE or DT_EXPANDTABS);
  end;
end;

function TCustomMenus97.HasBanner(Item: TMenuItem): boolean;
begin
  Result:= ( Item.Parent = InternalMenu.Items[0] ) and ( InternalMenu.Items[0].GroupIndex = 0);
end;

procedure TCustomMenus97.CalcBannerRect;
Var R1 : TRect;
    i: Integer;
begin
  GetMenuItemRect(InternalMenu.WindowHandle, InternalMenu.Items[0].Handle, 0, R1);
  FBannerRect:= R1;
  for i:= 0 to GetMenuItemCount(InternalMenu.Items[0].Handle) - 1 do begin
    GetMenuItemRect(InternalMenu.WindowHandle, InternalMenu.Items[0].Handle, i, R1);
    if ( R1.Bottom > FBannerRect.Bottom ) then
      FBannerRect.Bottom:= R1.Bottom;
  end;
  FBannerRect.Left:= FBannerRect.Left + FBannerWidth + 2;
  OffsetRect(FBannerRect, -FBannerRect.Left, -FBannerRect.Top);
  FBannerRect.Right:= FBannerRect.Left + FBannerWidth;
end;

// De larges portions du code de cette procedure
// proviennent de l'excellent TMSOfficeCaption
// de Warren F. Young.

procedure TCustomMenus97.GradientFill(DC: HDC; FBeginColor, FEndColor: TColor; R: TRect);
var
  { Set up working variables }
  BeginRGBValue  : array[0..2] of Byte;    { Begin RGB values }
  RGBDifference  : array[0..2] of integer; { Difference between begin and end }
                                           { RGB values                       }
  ColorBand : TRect;    { Color band rectangular coordinates }
  I         : Integer;  { Color band index }
  Red       : Byte;     { Color band Red value }
  Green     : Byte;     { Color band Green value }
  Blue      : Byte;     { Color band Blue value }
  Brush, OldBrush     : HBrush;
begin
  { Extract the begin RGB values }
  { Set the Red, Green and Blue colors }
  BeginRGBValue[0] := GetRValue (ColorToRGB (FBeginColor));
  BeginRGBValue[1] := GetGValue (ColorToRGB (FBeginColor));
  BeginRGBValue[2] := GetBValue (ColorToRGB (FBeginColor));
  { Calculate the difference between begin and end RGB values }
  RGBDifference[0] := GetRValue (ColorToRGB (FEndColor)) - BeginRGBValue[0];
  RGBDifference[1] := GetGValue (ColorToRGB (FEndColor)) - BeginRGBValue[1];
  RGBDifference[2] := GetBValue (ColorToRGB (FEndColor)) - BeginRGBValue[2];

  { Calculate the color band's top and bottom coordinates }
  { for Left To Right fills }
  begin
    ColorBand.Left:= R.Left;
    ColorBand.Right:= R.Right;
  end;

  { Perform the fill }
  for I := 0 to BannerNumColors-1 do
  begin  { iterate through the color bands }
    { Calculate the color band's left and right coordinates }
    ColorBand.Top   := R.Top+ MulDiv (I    , R.Bottom-R.Top, BannerNumColors);
    ColorBand.Bottom:= R.Top+ MulDiv (I + 1, R.Bottom-R.Top, BannerNumColors);
    { Calculate the color band's color }
    if BannerNumColors > 1 then
    begin
      Red   := BeginRGBValue[0] + MulDiv (I, RGBDifference[0], BannerNumColors - 1);
      Green := BeginRGBValue[1] + MulDiv (I, RGBDifference[1], BannerNumColors - 1);
      Blue  := BeginRGBValue[2] + MulDiv (I, RGBDifference[2], BannerNumColors - 1);
    end
    else
    { Set to the Begin Color if set to only one color }
    begin
      Red   := BeginRGBValue[0];
      Green := BeginRGBValue[1];
      Blue  := BeginRGBValue[2];
    end;

    { Create a brush with the appropriate color for this band }
    Brush := CreateSolidBrush(RGB(Red,Green,Blue));
    { Select that brush into the temporary DC. }
    OldBrush := SelectObject(DC, Brush);
    try
      { Fill the rectangle using the selected brush -- PatBlt is faster than FillRect }
      PatBlt(DC, ColorBand.Left, ColorBand.Top, ColorBand.Right-ColorBand.Left, ColorBand.Bottom-ColorBand.Top, PATCOPY);
    finally
      { Clean up the brush }
      SelectObject(DC, OldBrush);
      DeleteObject(Brush);
    end;
  end;  { iterate through the color bands }
end;  { GradientFill }

procedure TCustomMenus97.DrawItem(Item: TMenuItem; Rect: TRect; State: TOwnerDrawState);

  function CalcButtonRect(ARect: TRect; BmpWidth, BmpHeight: Integer): TRect;
  begin
    InflateRect(ARect, -2, -2);
    ARect.Left:= ARect.Left - 2;
    ARect.Top := ARect.Top  - 2;
    ARect.Right:= ARect.Left + BmpWidth + 4;
    ARect.Bottom := ARect.Top + CalcMenuHeight(Item);//BmpHeight + 4;
    Result:= ARect;
  end;

  procedure DrawButton(Rect: TRect; Up: Boolean);
  begin
    if ( FMenus97Look = mlOffice97Look ) then begin
      Rect.Right:= Rect.Right + 1;
      Canvas.FillRect(Rect);
      Rect.Right:= Rect.Right - 1;
      if (Up) then
        Frame3D(Canvas,Rect,clBtnHighlight,clBtnShadow,1)
      else
        Frame3D(Canvas,Rect,clBtnShadow,clBtnHighLight,1);
    end;
  end;

  procedure DrawItemBkGnd;
  Var //Bmp : TBitmap;
      APen: TPen;
  begin
    APen:= nil;
    if ( Item.Caption[1] = '-' ) then begin
      Item.Enabled:= False;
      try
        APen:= TPen.Create;
        APen.Style:= psSolid;
        APen.Color:= clBtnShadow;
        Canvas.Pen:= APen;
        Canvas.MoveTo ( Rect.Left+1, Rect.Top + ( Rect.Bottom - Rect.Top )  Div 2 );
        Canvas.LineTo ( Rect.Right-1, Rect.Top + ( Rect.Bottom - Rect.Top )  Div 2 );
        Canvas.Pen.Color:= clBtnHighlight;
        Canvas.MoveTo ( Rect.Left+1, Rect.Top + ( Rect.Bottom - Rect.Top )  Div 2 + 1 );
        Canvas.LineTo ( Rect.Right-1, Rect.Top + ( Rect.Bottom - Rect.Top )  Div 2 + 1 );
      finally
        APen.Free;
      end;
    end;
    if ( Item.Break = mbBarBreak ) then begin
      //Item.Enabled:= False;
      try
        APen:= TPen.Create;
        APen.Style:= psSolid;
        APen.Color:= clBtnShadow;
        Canvas.Pen:= APen;
        Canvas.MoveTo ( Rect.Left-3, FBannerRect.Top );
        Canvas.LineTo ( Rect.Left-3, FBannerRect.Bottom );
        Canvas.Pen.Color:= clBtnHighlight;
        Canvas.MoveTo ( Rect.Left-2, FBannerRect.Top );
        Canvas.LineTo ( Rect.Left-2, FBannerRect.Bottom );
      finally
        APen.Free;
      end;
    end;
    if( Item.Enabled ) then begin
      Canvas.Brush:= FBrush;
      if ( odSelected in State ) and Not ( ( Item.Caption <> '' ) and ( Item.Caption[1] = '-' ) ) then
        Canvas.Brush.Color:=FHiliteBar;
      Canvas.Fillrect(Rect);
      Canvas.Brush:= FBrush;
    end;
  end;

  procedure DrawItem;
  begin
    with Item, Canvas do begin
      DrawItemBkGnd;
      if ( Item.Enabled ) then begin
        if ( odSelected in State ) and ( ( Checked ) or (( Item.Tag >= 0 ) and (FImages <> nil)) ) then begin
          if ( Item.Tag >= 0 ) and ( FImages <> nil ) then
            DrawButton(CalcButtonRect(Rect, Fimages.Width, Fimages.Height), True)
          else
            DrawButton(CalcButtonRect(Rect, FCheckBitmap.Width, FCheckBitmap.Height), True);
        end;
        if (RadioItem) then begin
          if ( Not ( odSelected in State ) ) and ( Checked ) then begin
            if ( Item.Tag >= 0 ) and ( FImages <> nil ) then
              DrawButton(CalcButtonRect(Rect, Fimages.Width, Fimages.Height), Not Checked)
            else
              DrawButton(CalcButtonRect(Rect, FRadioBitmap.Width, FRadioBitmap.Height), Not Checked);
          end;
          if ( Item.Tag >= 0 ) and ( FImages <> nil ) then begin
            Fimages.Draw(Canvas, Rect.Left+2, Rect.Top+2, Item.Tag);
          end
          else
            if ( Checked ) then begin
              BrushCopy( Bounds(Rect.Left+1,Rect.Top+1,FRadioBitmap.Width,FRadioBitmap.height),FRadioBitmap,
                         Bounds(0,0,FRadioBitmap.Width,FRadioBitmap.Height),ClWhite);
            end;
        end
        else begin
          if ( Not ( odSelected in State ) ) and ( Checked ) then begin
            if ( Item.Tag >= 0 ) and ( FImages <> nil ) then
              DrawButton(CalcButtonRect(Rect, Fimages.Width, Fimages.Height), Not Checked)
            else
              DrawButton(CalcButtonRect(Rect, FCheckBitmap.Width, FCheckBitmap.Height), False);
          end;
          if ( Item.Tag >= 0 ) and ( FImages <> nil ) then
            Fimages.Draw(Canvas, Rect.Left+2, Rect.Top+2, Item.Tag)
          else
            if ( Checked ) then
              brushCopy( Bounds(Rect.Left+1,Rect.Top+1,FCheckBitmap.Width,FCheckBitmap.height),FcheckBitmap,
                         Bounds(0,0,FCheckBitmap.Width,FCheckBitmap.Height),ClWhite);
        end;
      end
      else begin
        if ( Item.Tag >= 0 ) and ( FImages <> nil ) then
          DrawDisabledImage(Rect, Item.Tag);
      end;
      if ( odSelected in State ) then
        Font:= FHiliteFont
      else
        Font:= FFont;
      if ( FImages <> nil ) then
        Inc(Rect.Left, FImages.Width+7)
      else
        Inc(Rect.Left, FCheckBitmap.Width+7);
      if ( Item.Caption[1] = '-' ) then
        DrawItemText(Item, Rect, Copy(Item.Caption, 2, Length(Item.Caption)))
      else
        DrawItemText(Item, Rect, Item.Caption);
    end;
  end;

  procedure DrawMenuBkGnd;
  //Var Bmp : TBitmap;
  //    R1, R2: TRect;
  begin
    (*if (Item.Parent = Menu.Items[0] ) then begin
      //Rect.Left:= Rect.Left + FBannerWidth + 2;
      GetMenuItemRect(Menu.WindowHandle, Menu.Items[0].Handle, 0, R1);
      GetMenuItemRect(Menu.WindowHandle, Menu.Items[0].Handle, Menu.Items[0].Count - 1, R2);
      R1.Bottom:= R2.Bottom;
      OffsetRect(R1, -R1.Left, -R1.Top);
      //R1.Right:= R1.Left + 20;
      if FBanner then
        R1.Left:= R1.Left + FBannerWidth;
      R2:= R1;
      //OffsetRect(R1, R1.Left, R1.Top);
      //Bmp:= TBitmap.Create;
      //Bmp.Width:= R1.Right - R1.Left;
      //Bmp.Height:= R1.Bottom - R1.Top;
      Canvas.Brush.Color:= FBrush.color;
      Canvas.Fillrect(Rect);
      if ( Assigned(FItemsEx.Bitmaps[Menu.Items[0]]) and ( Not FItemsEx.Bitmaps[Menu.Items[0]].Empty ) ) then begin
        try
          Bmp:= TBitmap.Create;
          Bmp.Width:= R1.Right - R1.Left;
          Bmp.Height:= R1.Bottom - R1.Top;
          Bmp.Canvas.StretchDraw(Bounds(0, 0, Bmp.Width,Bmp.Height), FItemsEx.Bitmaps[Menu.Items[0]]);
          Canvas.BrushCopy( Bounds(Rect.Left,Rect.Top,Bmp.Width,Rect.Bottom - Rect.Top),Bmp,
                            Bounds(Rect.Left,Rect.Top,Bmp.Width,Rect.Bottom - Rect.Top), Bmp.Canvas.Pixels[0,0]);
        finally
          Bmp.Free;
        end;
      end;
    end;*)
  end;

  procedure DrawBanner;
  var //Bmp : TBitmap;
      R2: TRect;
      LogRec: TLOGFONT;
      OldFont, NewFont: HFONT;
  begin
    NewFont:= 0;
    OldFont:= 0;
    //Bmp:= nil;
    if HasBanner(Item) then begin
      if ( Rect.Left = FBannerRect.Left ) then
        Rect.Left:= Rect.Left + FBannerWidth + 2;
      R2:= FBannerRect;
      OffsetRect(R2, R2.Left, R2.Top);
      if Not Assigned(FBannerBmp) then begin
        try
          FBannerBmp:= TBitmap.Create;
          FBannerBmp.Width:= R2.Right - R2.Left;
          FBannerBmp.Height:= R2.Bottom - R2.Top;
          if ( BannerColor = BannerEndColor ) then begin
            FBannerBmp.Canvas.Brush.Color:= BannerColor;
            FBannerBmp.Canvas.FillRect(R2);
          end
          else
            GradientFill(FBannerBmp.Canvas.Handle, BannerColor, BannerEndColor, R2);
          FBannerBmp.Canvas.Font.Color:= FBannerFont.Color;
          GetObject(BannerFont.Handle, SizeOf(LogRec), @LogRec);
          LogRec.lfEscapement := 900;
          LogRec.lfOutPrecision := OUT_TT_ONLY_PRECIS;
          NewFont:= CreateFontIndirect(LogRec);
          OldFont:= SelectObject(FBannerBmp.Canvas.Handle,NewFont);
          if ( FBannerImage >= 0 ) then
            R2.Bottom:= R2.Bottom - 4 - FBannerBmp.Width; // Bitmaps Width.
          SetBkMode(FBannerBmp.Canvas.Handle, TRANSPARENT);
          case FBannerJustification of
            bjCenter : FBannerBmp.Canvas.TextOut(R2.Left + (R2.Right - R2.Left - GetTextSize(FBannerBmp.Canvas, FBannerText).Cy) Div 2,
                          R2.Bottom - 1 - (R2.Bottom - R2.Top - GetTextSize(FBannerBmp.Canvas, FBannerText).Cx) Div 2, FBannerText);
            bjBottom : FBannerBmp.Canvas.TextOut(R2.Left + (R2.Right - R2.Left - GetTextSize(FBannerBmp.Canvas, FBannerText).Cy) Div 2,
                          R2.Bottom - 1, FBannerText);
            bjTop    : FBannerBmp.Canvas.TextOut(R2.Left + (R2.Right - R2.Left - GetTextSize(FBannerBmp.Canvas, FBannerText).Cy) Div 2,
                          R2.Top + GetTextSize(FBannerBmp.Canvas, FBannerText).Cx + 1, FBannerText);
          end;
        finally
          if ( NewFont <> 0 ) then
            DeleteObject(SelectObject(FBannerBmp.Canvas.Handle,OldFont));
          //FCanvas.Draw(FBannerRect.Left, FBannerRect.Top, FBannerBmp);
          //Bmp.Free;
        end;
      end;
      FCanvas.Draw(FBannerRect.Left, FBannerRect.Top, FBannerBmp);
    end;
  end;

begin
  if ( Item.Caption = '' ) then Item.Caption:= ' ';
  if ( odSelected in State ) then begin
    if Assigned(FOnHint) then
      Item.Hint:= FOnHint(InternalMenu, Item, Item.Hint);
    Application.Hint:= Item.Hint;
  end;
  if Assigned(FOnDrawItem) then begin
    if ( FOnDrawItem(InternalMenu, Item, Rect, State) ) then
      Exit;
  end;
  if ( FNeedBannerRect ) and HasBanner(Item) then begin
    if Assigned(FBannerBmp) then begin
      FBannerBmp.Free;
      FBannerBmp:= nil;
    end;
    FNeedBannerRect:= False;
    CalcBannerRect;
  end;
  if ( Banner ) then
    DrawBanner;
  DrawMenuBkGnd;
  if (Item.Tag = -1) or (Item.Tag > 255) then
    DrawMenuBarItem(Item, Rect, State)
  else
    DrawItem;
end; {Fin de "TCustomMenus97.DrawItem".}

(*procedure TCustomMenus97.WMMeasureItem(var Message: TWMMeasureItem);
begin
  CNMeasureItem(Message);
end;*)

procedure TCustomMenus97.WMMeasureItem(var Message: TWMMeasureItem);
Var
  Item: TMenuItem;
begin
  if ( InternalMenu = nil ) then Exit;
  FCanvas.Handle:= GetDC(InternalMenu.WindowHandle);
  FCanvas.Font:= FFont;
  try
    with Message.MeasureItemStruct^ do begin
      Item:= FindItemByCommand(itemID);
      if ( Item <> nil ) then begin
        if ( FItemHeight = 0 ) then
          itemHeight:= CalcMenuHeight(Item)
        else
          itemHeight:=  FItemHeight;
        if ( FItemWidth = 0 ) then
          itemWidth:= CalcMenuWidth(Item)
        else
          itemWidth:= FItemWidth;
      //  MeasureItem(Item, itemHeight, itemWidth);
      end;
      Message.Result:= longint(True);
    end;
  finally
    ReleaseDC(InternalMenu.WindowHandle, FCanvas.Handle);
    FCanvas.Handle:= 0;
  end;
end;

procedure TCustomMenus97.MeasureItem(Item: TMenuItem; var Height, Width: Integer);
begin
  if Assigned(FOnMeasureItem) then
    FOnMeasureItem(InternalMenu, Item, Height, Width)
end;

procedure TCustomMenus97.NewTFormWndProc(Var Message: TMessage);
Var i, j: Integer;
    MI: TMenuItemInfo;
    Item: TMenuItem;
    C: Array[0..100] of char;
    Tmp: String;
    Found: Boolean;
begin
  // Only used to handle WM_DRAWITEM and WM_MEASUREITEM from Menus
  if ( InternalMenu <> nil ) then begin
    case Message.Msg of
      WM_WININICHANGE : if ( FDefaultFont ) then begin
                          GetDefaultMenuFont(FFont);
                          FHiliteFont.Assign(FFont);
                        end;
      (*WM_NCMOUSEMOVE : begin
                         if ( Message.wParam <> HTMENU ) then begin
                           if ( FHitPos <> -1 ) then begin
                             FHitPos:= -1;
                             DrawMenuBar((Owner as TForm).Handle);
                           end;
                         end;
                       end;
      WM_NCHITTEST   : begin
                         Message.Result:= CallWindowProc(FOldTFormWndProc, (Owner as TForm).Handle, Message.Msg, Message.WParam, Message.LParam);
                         i:= -1;
                         if ( FHitTest ) then begin
                           if ( Message.Result = HTMENU ) then begin
                             if ( LoWord(Message.lParam) < 400 ) then i:= 0;
                             if ( LoWord(Message.lParam) > 401 ) then i:= 1;
                           end
                         end;
                         if ( FHitPos <> i ) then begin
                           FHitPos:= i;
                           DrawMenuBar((Owner as TForm).Handle);
                         end;
                         Exit;
                       end;*)
      //WM_RBUTTONDOWN : if Assigned(FOnRightButtonDown) then FOnRightButtonDown(InternalMenu);
      CM_MENUCHANGED : begin
                         if ( InternalMenu <> nil ) then
                           ModifyMenuTree(InternalMenu.Items, False);
                       end;
      WM_DRAWITEM    : if ( TWMDrawItem(Message).DrawItemStruct^.CtlType = ODT_MENU ) then
                         if ( TWMDrawItem(Message).DrawItemStruct^.itemData <> 0 ) then begin
                           TCustomMenus97(TWMDrawItem(Message).DrawItemStruct^.itemData).Dispatch(Message);
                           Exit;
                         end;
      WM_MEASUREITEM : if ( TWMMeasureItem(Message).idCtl = 0 ) then
                         if ( TWMMeasureItem(Message).MeasureItemStruct^.itemData <> 0 ) then begin
                           TCustomMenus97(TWMMeasureItem(Message).MeasureItemStruct^.itemData).Dispatch(Message);
                           Exit;
                         end;
      WM_MENUCHAR    : begin
                         i:=ProcessAccel( TWMMenuChar(Message) );
                         if ( i >= 0 ) then begin
                           Message.Result:= MAKELRESULT(i, 2);
                           Exit;
                         end;
                       end;
      // Used for Var initialization :
      // FInitOk       : MDI WindowMenu item initialization allowed
      // FPushedButton : MenuBarItems Look
      WM_ENTERMENULOOP : begin
                           FInitOk:= False;
                         end;
      // Used for MDI WindowsMenu Item initialization and MenuBarItem Look
      WM_INITMENUPOPUP : begin
                           //Message.Result:= CallWindowProc(FOldTFormWndProc, (Owner as TForm).Handle, Message.Msg, Message.WParam, Message.LParam);
                           //ModifyMenuTree(InternalMenu.Items, False);
                           //Message.Result:= 1;
                           if (Not FInitOk ) and ( Owner is TForm ) and Assigned((Owner As TForm).WindowMenu) and ( InternalMenu.FindItem(Message.wParam, fkHandle) <> nil ) and
                              ((Owner as TForm).FormStyle = fsMdiForm) and ((Owner As TForm).WindowMenu.Handle = Message.wParam ) then begin
                             Message.Result:= 0;
                             for i:= (Owner As TForm).WindowMenu.Count+1 to GetMenuItemCount(HMenu(Message.wParam)) - 1 do begin
                               (*MI.cbSize:= Sizeof(TMenuItemInfo);
                               MI.fMask:= MIIM_TYPE;
                               MI.fType:= 0;
                               MI.cch:= 0;
                               GetMenuItemInfo(HMenu(Message.wParam), i, TRUE, MI);
                               if ( ( MI.fType and MFT_OWNERDRAW ) <> MFT_OWNERDRAW ) then begin*)
                               MI.cbSize:= Sizeof(TMenuItemInfo);
                               MI.fMask:= MIIM_TYPE or MIIM_STATE;
                               MI.fType:= MFT_STRING;
                               MI.cch:= 100;
                               MI.dwTypeData:= Pchar(@C);
                               if ( GetMenuItemInfo(HMenu(Message.wParam), i, TRUE, MI)) then begin
                                 Item:= TMenuItem.Create(nil);
                                 Tmp:= StrPAS(C);
                                 Item.ShortCut:= 0;
                                 if ( Pos(#9, Tmp) <> 0 ) then begin
                                   Item.Caption:= Copy(Tmp, 1, Pos(#9, Tmp)-1);
                                   Tmp:= Copy(Tmp, Pos(#9, Tmp)+1, Length(Tmp)-Pos(#9, Tmp)+1);
                                   Item.ShortCut:= TextToShortCut(Tmp);
                                 end
                                 else
                                   Item.Caption:= Tmp;
                                 Item.Enabled:= True;
                                 Item.Checked:= (MI.fState and MFS_CHECKED) = MFS_CHECKED;
                                 Item.Default:= (MI.fState and MFS_DEFAULT) = MFS_DEFAULT;
                                 Item.RadioItem:= False;
                                 Item.Tag:= -2;
                                 MI.fMask:= MIIM_ID;
                                 GetMenuItemInfo(HMenu(Message.wParam), i, TRUE, MI);
                                 Item.HelpContext:= MI.wID;
                                 Found:= False;
                                 for j:= 0 to FMDIList.Count - 1 do begin
                                   if ( TMenuItem(FMDIList.Items[j]).HelpContext = MI.wID ) then begin
                                     Found:= True;
                                     TMenuItem(FMDIList.Items[j]).Checked:= Item.Checked;
                                   end;
                                 end;
                                 if ( Not Found ) then
                                   FMDIList.Insert(0, Item)
                                 else
                                   Item.Free;
                                 ModifyMenu( HMenu(Message.wParam), MI.wID,
                                               MF_OWNERDRAW or MF_BYCOMMAND, MI.wID, Pointer(Self));
                               end;
                             end;
                             FInitOk:= True;
                           end
                           else begin
                             if ( Self is TCustomMainMenus97 ) then begin
                               Message.Result:= CallWindowProc(FOldTFormWndProc, (Owner as TForm).Handle, Message.Msg, Message.WParam, Message.LParam);
                               //if ( Not IsNTPlatform ) then
                               //ModifyMenuTree(InternalMenu.Items, False);
                               FNeedBannerRect:= True;
                               Exit;
                             end;
                           end;
                           FNeedBannerRect:= True;
                         end;
    end;
  end;
  // else we call the old DefaultProc.
  Message.Result:= CallWindowProc(FOldTFormWndProc, (Owner as TForm).Handle, Message.Msg, Message.WParam, Message.LParam);
end;

procedure TCustomMenus97.SetFont(Value: TFont);
begin
  FDefaultFont:= False;
  FFont.Assign(Value);
end;

procedure TCustomMenus97.SetBannerFont(Value: TFont);
begin
  FBannerFont.Assign(Value);
end;

procedure TCustomMenus97.SetHiliteFont(Value: TFont);
begin
  FDefaultFont:= False;
  FHiliteFont.Assign(Value);
end;

procedure TCustomMenus97.SetBrush(Value: TBrush);
begin
  FBrush.Assign(Value);
end;

procedure TCustomMenus97.DrawDisabledImage(Var Rect : TRect; IndexImage : Integer);
begin
// DrawState API havn't been implmented yet in Win NT 4 & 5
// so we need to use old way to draw disabled images
//
  if ( IsNTPlatform ) then begin
    DrawDisabledImageNT(Rect, IndexImage);
  end
  else
    DrawDisabledImage95(Rect, IndexImage);
end;

// De larges portions du code de cette procedure
// proviennent de l'excellent TExplorerButton
// de Fabrice Deville.

procedure TCustomMenus97.DrawDisabledImageNT(Var Rect : TRect; IndexImage : Integer);

var
  MonoBmp: TBitmap;
  Bmp    : TBitmap;

begin
  MonoBmp:= TBitmap.Create;
  Bmp    := TBitmap.Create;
  try
    Fimages.GetBitmap(IndexImage,Bmp);

    MonoBmp.Assign(Bmp);
    MonoBmp.Canvas.Brush.Color := clBlack;
    MonoBmp.Monochrome := True;

    Canvas.Brush.Color := clBtnHighlight;
    SetTextColor(Canvas.Handle, clBlack);
    SetBkColor(Canvas.Handle, clWhite);
    BitBlt(Canvas.Handle, Rect.Left+1, Rect.Top+1, Bmp.Width, Bmp.Height,
            MonoBmp.Canvas.Handle, 0, 0, $00E20746);
    Canvas.Brush.Color := clBtnShadow;
    SetTextColor(Canvas.Handle, clBlack);
    SetBkColor(Canvas.Handle, clWhite);
    BitBlt(Canvas.Handle, Rect.Left, Rect.Top, Bmp.Width, Bmp.Height,
            MonoBmp.Canvas.Handle, 0, 0, $00E20746);
  finally
    SetBkMode(Canvas.Handle, TRANSPARENT);
    MonoBmp.Free;
    Bmp.Free;
  end
end;

procedure TCustomMenus97.DrawDisabledImage95(Var Rect : TRect; IndexImage : Integer);
var
  Bmp    : TBitmap;

begin
  Bmp    := TBitmap.Create;
  try
    Fimages.GetBitmap(IndexImage,Bmp);
    DrawState(Canvas.Handle, 0, nil, MakeLong(Bmp.Handle, 0), 0, Rect.Left+1, Rect.Top+1, Bmp.Width, Bmp.Height, DST_BITMAP or DSS_DISABLED);
  finally
    Bmp.Free;
  end
end;

// TCustomMainMenus97

var
  MenuHook: HHOOK;

// This Hook is used to handle events in Modal MenuLoop

function MenuGetMsgHook(nCode: Integer; wParam: Longint; var Msg: TMsg): Longint; stdcall;
Var Control: TMenuSpeedButton;
    Pt: TPoint;
    i: Integer;
begin
  if (nCode = MSGF_MENU) and (CurrentHookControl <> nil) then begin
    with CurrentHookControl do begin
      case Msg.Message of
        WM_LBUTTONDOWN :
          begin
            Pt:= SmallPointToPoint(TSmallPoint(Msg.lParam));
            Pt:= CurrentHookControl.ScreenToClient(Pt);
            Control := ControlAtPos(Pt, False) as TMenuSpeedButton;
            if ( Control <> nil ) and ( Control = InternalActiveControl ) and ( Control.Parent = CurrentHookControl ) then begin
              Keybd_Event(VK_ESCAPE, 0, 0, Msg.lParam);
              InternalActiveControl.MouseUp(mbLeft, [], Pt.x, Pt.y);
              CurrentHookControl.FMenuOpen:= False;
              Result:= 1;
              Exit;
            end;
          end;
        WM_MOUSEMOVE :
          begin
            Pt:= SmallPointToPoint(TSmallPoint(Msg.lParam));
            Pt:= CurrentHookControl.ScreenToClient(Pt);
            Control := ControlAtPos(Pt, False) as TMenuSpeedButton;
            i:= 0;
            if ( Control <> nil ) then
              if ( Control <> InternalActiveControl ) and ( Control.Parent = CurrentHookControl ) then begin
                InternalActiveControl.MouseUp(mbLeft, [], Pt.x, Pt.y);
                InternalActiveControl:= Control;
                while ( i < CurrentHookControl.ControlCount ) and ( CurrentHookControl.Controls[i] <> TControl(InternalActiveControl) ) do Inc(i);
                CurrentHookControl.FActiveControl:= i;
                CurrentHookControl.FActiveControl:= InternalActiveControl.ComponentIndex;
                PostMessage(CurrentHookControl.Handle, WM_LBUTTONDOWN, MK_LBUTTON, MakeLong(Pt.x, Pt.y));
                Result:= 1;
                Exit;
              end;
          end;
        WM_SYSKEYDOWN :
          case Msg.wParam of
            VK_MENU : begin
                        CurrentHookControl.FMenuOpen:= False;
                      end;
          end;
        WM_KEYDOWN :
          case Msg.wParam of
            VK_ESCAPE : begin
                        CurrentHookControl.FMenuOpen:= False;
                      end;
            VK_LEFT  : begin
                         i:= 0;
                         while ( i < CurrentHookControl.ControlCount ) and ( CurrentHookControl.Controls[i] <> TControl(InternalActiveControl) ) do Inc(i);
                         if ( i <= 0 ) then
                           i:= CurrentHookControl.ControlCount - 1
                         else
                           Dec(i);
                         CurrentHookControl.FActiveControl:= i;
                         Control:= CurrentHookControl.Controls[i] as TMenuSpeedButton;
                         if ( Control <> nil ) and ( Control <> InternalActiveControl ) and ( Control.Parent = CurrentHookControl ) then begin
                           InternalActiveControl.MouseUp(mbLeft, [], InternalActiveControl.Left, InternalActiveControl.Top);
                           InternalActiveControl:= Control;
                           PostMessage(CurrentHookControl.Handle, WM_LBUTTONDOWN, MK_LBUTTON, MakeLong(InternalActiveControl.Left, InternalActiveControl.Top));
                           Result:= 1;
                           Exit;
                         end;
                       end;
            VK_RIGHT : begin
                         i:= 0;
                         while ( i < CurrentHookControl.ControlCount ) and ( CurrentHookControl.Controls[i] <> TControl(InternalActiveControl) ) do Inc(i);
                         if ( i >= CurrentHookControl.ControlCount - 1 ) then
                           i:= 0
                         else
                           Inc(i);
                         CurrentHookControl.FActiveControl:= i;
                         Control:= CurrentHookControl.Controls[i] as TMenuSpeedButton;
                         if ( Control <> nil ) and ( Control <> InternalActiveControl ) and ( Control.Parent = CurrentHookControl ) then begin
                           InternalActiveControl.MouseUp(mbLeft, [], InternalActiveControl.Left, InternalActiveControl.Top);
                           InternalActiveControl:= Control;
                           PostMessage(CurrentHookControl.Handle, WM_LBUTTONDOWN, MK_LBUTTON, MakeLong(InternalActiveControl.Left, InternalActiveControl.Top));
                           Result:= 1;
                           Exit;
                         end;
                       end;
          end;
      end;
    end;
  end;
  Result:= CallNextHookEx(MenuHook, nCode, wParam, Longint(@Msg));
end;

procedure HookMenuHooks;
begin
  begin
    if MenuHook = 0 then
      MenuHook := SetWindowsHookEx(WH_MSGFILTER, Pointer(@MenuGetMsgHook), 0, GetCurrentThreadID);
  end;
end;

procedure UnHookMenuHooks;
begin
  if MenuHook <> 0 then UnHookWindowsHookEx(MenuHook);
  MenuHook := 0;
end;

constructor TCustomMainMenus97.Create(AOwner: TComponent);
begin
  inherited Create(aOwner);
  FHideMenuBar:= False;
  FHitTest:= True;
  FHitPos:= -1;
  FToolBar:= nil;
  FMenuOpen:= False;
end;

destructor TCustomMainMenus97.Destroy;
Var i: Integer;
begin
  UnHookMenuHooks;
  Application.OnMessage:= nil;
  if ( FToolBar <> nil ) then begin
    for i:= FToolBar.ControlCount - 1 downto 0 do
      FToolBar.Controls[i].Free;
  end;
  inherited Destroy;
end;

procedure TCustomMainMenus97.DrawMenuBarItem(Item: TMenuItem; Var Rect: TRect; State: TOwnerDrawState);
begin
  if ( FHideMenuBar ) then Exit;
  with Canvas do begin
    Brush:= FBrush;
    Fillrect(Rect);
    if ( odSelected in State ) then begin
      if ( FPushedButton ) then
        Frame3D(Canvas,Rect,clBtnShadow,clBtnHighlight,1)
      else
        Frame3D(Canvas,Rect,clBtnHighlight,clBtnShadow,1);
    end;
    if ( Item.Tag > 255 ) and ( FImages <> Nil ) then begin
      Inc(Rect.Left,3);
      Fimages.Draw(Canvas, Rect.Left, Rect.Top+1, Item.Tag - 256);
      Inc(Rect.Left, FImages.Width + 2);
    end
    else
      Inc(Rect.Left,5);
    Font:= FFont;
    DrawItemText(Item, Rect, Item.Caption);
  end;
end;

function TCustomMainMenus97.CalcMenuBarHeight: Integer;
begin
  Result:= FItemHeight;
  if ( FItemHeight <> 0 ) then Exit;
  if ( InternalMenu = nil ) then Exit;
  FCanvas.Handle:= GetDC(InternalMenu.WindowHandle);
  FCanvas.Font:= FFont;
  try
    Result:= CalcMenuHeight(InternalMenu.Items[0])
  finally
    ReleaseDC(InternalMenu.WindowHandle, FCanvas.Handle);
    FCanvas.Handle:= 0;
  end;
end;

procedure TCustomMainMenus97.NewTFormWndProc(Var Message: TMessage);
Var R: TRect;
    i: Integer;
    MI: TMenuItemInfo;
    Item: TMenuItem;
    XPos: Integer;
    TmpMenuBarHeight: Integer;
    //OldSelID: Integer;
    //Pt: TPoint;
begin
  if ( InternalMenu <> nil ) then begin
    case Message.Msg of
      //WM_NEXTDLGCTL : case Message.wParam of
      //WM_MOUSEMOVE : MessageBeep(MB_OK);
      //WM_ENTERIDLE : MessageBeep(MB_OK);

      WM_GETDLGCODE : if ( FToolBar <> nil ) and ( FToolBar.FInMenuBar ) then begin
                        Message.Result:= DLGC_WANTARROWS;
                        Exit;
                      end;
      WM_KEYDOWN : case Message.wParam of
                     VK_LEFT,
                     VK_RIGHT,
                     VK_DOWN,
                     VK_ESCAPE : if ( FToolBar <> nil ) and ( FToolBar.FInMenuBar ) then begin
                                   FToolBar.WndProc(Message);
                                   Message.Result:= 0;
                                 end;
                   end;
      // Handle Alt Key if OwnerMenuBar is choosen
      WM_SYSCOMMAND : if ( FToolBar <> nil ) then begin
                        if ( Message.wParam = SC_KEYMENU ) and ( Message.lParam = 0 ) then begin
                          FToolBar.WndProc(Message);
                          Message.Result:= 0;
                          Exit;
                        end;
                      end;
      // Used to remove MenuBar
      WM_NCCALCSIZE : begin
                        Message.Result:= CallWindowProc(FOldTFormWndProc, (Owner as TForm).Handle, Message.Msg, Message.WParam, Message.LParam);
                        if FHideMenuBar and (Application.MainForm = (Owner as TForm)) then begin
                          R:= TWMNCCalcSize(Message).CalcSize_Params.rgrc[0];
                          OffsetRect(R, 0, -GetSystemMetrics(SM_CYMENU));
                          R.Bottom:= R.Bottom + GetSystemMetrics(SM_CYMENU);
                          TWMNCCalcSize(Message).CalcSize_Params.rgrc[0]:= R;
                        end;
                        Exit;
                      end;
      // Used to remove MenuBar
      WM_NCHITTEST   : begin
                         Message.Result:= CallWindowProc(FOldTFormWndProc, (Owner as TForm).Handle, Message.Msg, Message.WParam, Message.LParam);
                         if FHideMenuBar and ( Message.Result = HTMENU ) then
                           Message.Result:= HTTRANSPARENT;
                         {else begin
                           OldSelID:= FMenuBarSelID;
                           if ( InternalMenu <> nil ) then begin
                             Pt.x:= TSmallPoint(Message.lParam).x;
                             Pt.y:= TSmallPoint(Message.lParam).y;
                             FMenuBarSelID:= Integer(MenuItemFromPoint((Owner as TForm).Handle, InternalMenu.Handle, Pt));
                             if ( FMenuBarSelID >= 0 ) and ( FMenuBarSelID <= InternalMenu.Items.Count - 1 ) then
                               FMenuBarSelID:= InternalMenu.Items[FMenuBarSelID].Command;
                             if ( OldSelID <> FMenuBarSelID ) then
                               DrawMenuBar((Owner as TForm).Handle);
                           end;
                         end;}
                         Exit;
                       end;
      // Used to handle MenuBar accelerator keys before Menu
      WM_MENUCHAR    : begin
                         //MessageBeep(MB_Ok);
                         i:=ProcessAccel( TWMMenuChar(Message) );
                         if ( i >= 0 ) then begin
                           if ( InternalMenu.Items.Handle <> TWMMenuChar(Message).Menu ) then begin
                             Message.Result:= MAKELRESULT(i, 2);
                             Exit;
                           end
                           (*else begin
                             if ( FToolBar <> nil ) and ( FToolBar.ControlCount > i ) then begin
                               InternalActiveControl:= (FToolBar.Controls[i] as TMenuSpeedButton);
                               InternalActiveControl.MouseDown(mbLeft, [], InternalActiveControl.Left+1, InternalActiveControl.Top+1);
                               Exit;
                             end;
                           end;*)
                         end;
                       end;
      //WM_PAINT :
      // Used for MDI Menus / Menu Modifications and many more
      // WM_WINDOWPOSCHANGING is the FirstMessage Sent when DrawMenuBar is called
      // Avoid calling DrawMenuBar in :
      // - WM_WINDOWPOSCHANGING,
      // - WM_WINDOWPOSCHANGED,
      // - WM_NCPAINT,
      // - WM_NCCALCSIZE
      WM_WINDOWPOSCHANGING :
                     begin
                       XPos:= 0;
                       TmpMenuBarHeight:= FItemHeight;
                       if ( InternalMenu <> nil ) and ((Not FHideMenuBar) or (FToolBar<>nil)) then begin
                         if ( Owner is TForm ) and (((Owner as TForm).FormStyle = fsMdiForm) or ((Owner as TForm).FormStyle = fsNormal)) then begin
                           Message.Result:= CallWindowProc(FOldTFormWndProc, (Owner as TForm).Handle, Message.Msg, Message.WParam, Message.LParam);
                           if ( InternalMenu <> nil ) and ( InternalActiveControl = nil ) then begin
                             if ( FToolBar <> nil ) then begin
                               for i:= GetMenuItemCount(HMenu(InternalMenu.Handle)) to FToolBar.ControlCount - 1 do
                                 FToolBar.Controls[i].Visible:= False;
                               TmpMenuBarHeight:= CalcMenuBarHeight;
                             end;
                             for i:= 0 to GetMenuItemCount(HMenu(InternalMenu.Handle)) - 1 do begin
                               MI.fMask:= MIIM_ID;
                               MI.cbSize:= Sizeof(TMenuItemInfo);
                               GetMenuItemInfo(InternalMenu.Handle, i, TRUE, MI);
                               if ( MI.wID <> 0 ) and ( MI.wID < 60000 ) then begin
                                 Item:= InternalMenu.FindItem(MI.wID, fkCommand);
                                 if ( Item = nil ) or ( Item.Parent.Handle <> InternalMenu.Handle) then begin
                                   ModifyMenu( InternalMenu.Handle, MI.wID,
                                                 MF_OWNERDRAW or MF_BYCOMMAND, MI.wID, Pointer(Self));
                                 end
                               end;
                               Item:= FindItemByCommand(MI.wID);
                               if (FToolBar <> nil ) and ( Item <> nil ) then begin
                                 ToolBar.Height:= TmpMenuBarHeight+1;
                                 if ( i > FToolBar.ControlCount - 1 ) then
                                   with TMenuSpeedButton.Create(FToolBar) do begin
                                     Parent:= FToolBar;
                                     {$ifndef VER90}
                                     Flat:= True;
                                     {$endif}
                                     AllowAllUp:= True;
                                     GroupIndex:= 0;
                                     FM97Handle:= (Self.Owner as TForm).Handle;
                                     FInDown:= False;
                                   end;
                                 with FToolBar.Controls[i] as TMenuSpeedButton do begin
                                   Visible:= True;
                                   Left:= XPos;
                                   Height:= TmpMenuBarHeight;
                                   Width:= Length(Item.Caption) * 6;
                                   XPos:= XPos + Width;
                                   Caption:= Item.Caption;
                                   Tag:= Item.Handle;
                                   Hint:= Item.Caption;
                                 end;
                               end;
                             end;
                           end;
                           ModifyMenuTree(InternalMenu.Items, False);
                           Exit;
                         end;
                       end;
                     end;
      // Used for Var initialization :
      // FInitOk       : MDI WindowMenu item initialization allowed
      // FPushedButton : MenuBarItems Look
      WM_ENTERMENULOOP : begin
                           FPushedButton:= False;
                           FHitTest:= False;
                           FMenuOpen:= True;
                           if ( FToolBar <> nil ) then begin
                             //FToolBar.SetFocus;
                             HookMenuHooks;
                             CurrentHookControl:= FToolBar;
                             if ( InternalActiveControl = nil ) and ( FToolBar.ControlCount > 0 ) and ( Not FToolBar.FInMenuBar ) then begin
                               InternalActiveControl:= (FToolBar.Controls[0] as TMenuSpeedButton);
                               InternalActiveControl.Perform(CM_MOUSEENTER, 0, 0);
                             end;
                           end;
                         end;
      WM_EXITMENULOOP  : begin
                           FHitTest:= True;
                           FMenuOpen:= False;
                           if ( FToolBar <> nil ) then begin
                             UnHookMenuHooks;
                             if ( InternalActiveControl <> nil ) and ( InternalActiveControl.FInDown ) then begin
                               InternalActiveControl.MouseUp(mbLeft, [], InternalActiveControl.Left+1, InternalActiveControl.Top+1);
                               if ( FToolBar.FInMenuBar ) then
                                 InternalActiveControl.Perform(CM_MOUSEENTER, 0, 0);
                             end;
                           end;
                           CurrentHookControl:= nil;
                           InternalActiveControl:= nil;
                         end;
      // Used for Updating MenuBarItem Look (Leaving popup with ESC key)
      WM_MENUSELECT    : begin
                           if (Not FHideMenuBar) and (Message.lParam = FMenu.Handle) and Not ( ( ( HiWord(Message.wParam) and MF_MOUSESELECT ) = MF_MOUSESELECT ) ) then begin
                             if (Self is TCustomMainMenus97) and ( FPushedButton ) then begin
                               FPushedButton:= False;
                               DrawMenuBar((Owner As TForm).Handle);
                             end;
                           end;
                           if (FHideMenuBar) and (Message.lParam = 0) and ( HiWord(Message.wParam) = $FFFF ) then begin
                             if ( FToolBar <> nil ) then begin
                               FToolBar.FMenuOpen:= False;
                               Message.Msg:= WM_SYSCOMMAND;
                               Message.wParam:= SC_KEYMENU;
                               Message.lParam:= 0;
                               //FToolBar.WndProc(Message);
                               Exit
                             end;
                           end;
                         end;
      // Used for MDI WindowsMenu Item initialization and MenuBarItem Look
      WM_INITMENUPOPUP : begin
                           Message.Result:= 1;
                           if (Not FHideMenuBar) and ( Not FPushedButton ) and ( HiWord(Message.lParam) = 0 ) then begin
                             FPushedButton:= True;
                             DrawMenuBar((Owner As TForm).Handle);
                           end;
                         end;
    end;
  end;
  // else we call the old DefaultProc.
  inherited NewTFormWndProc(Message);
end;

procedure TCustomMainMenus97.SetToolBar(Value: TCustomMenuBar97);
Var i: Integer;
begin
  if ( FToolBar = Value ) then Exit;
  FToolBar:= Value;
  if ( Value <> nil ) then begin
    for i:= FToolBar.ControlCount - 1 downto 0 do
      FToolBar.Controls[i].Free;
    FHideMenuBar:= True;
    DrawMenuBar((Owner as TForm).Handle);
  end;
end;

procedure TCustomMainMenus97.SetHideMenuBar(Value: Boolean);
begin
  if ( Value <> FHideMenuBar ) and ( FToolBar = nil ) then begin
    FHideMenuBar:= Value;
    DrawMenuBar((Owner as TForm).Handle);
  end;
end;

procedure TCustomMainMenus97.FontChange(Sender: TObject);
begin
  if (Not FHideMenuBar) then
    DrawMenuBar((Owner as TForm).Handle);
end;

procedure TCustomMainMenus97.SetMainMenu(Value: TMainMenu);
begin
  InternalMenu:= Value;
end;

function TCustomMainMenus97.GetMainMenu: TMainMenu;
begin
  Result:= TMainMenu(InternalMenu);
end;

// TCustomPopupMenus97

constructor TCustomPopupMenus97.Create(AOwner: TComponent);
Var TmpHandle    : THandle;
    ProcessId    : Pointer;
    TmpProcessId : Pointer;
    CName        : Array [0..50] of Char;
begin
  // Les messages OWNERDRAW - pour les menus - sont interceptés par
  // une fenêtre TPUtilWindow crée par delphi (PopupList)
  // moralité il faut intercepter le gestionnaire d'évenements
  // de cette fenêtre pour pouvoir recevoir les message de dessin et autres

  // Ce hook n'est nécessaire que pour les popup menus

  // TPUtilWindow is a @#!!##@& window created by delphi (CreateWindowHandle)
  // It's defaultProc Eats All PopupMenu Messages !!
  // So We Have to Override this problem like this :
  //
  // 1st Step : Search All Windows Called 'TPUtilWindow'
  // 2d  Step : How to choose the good one ?
  //            Create a PopupMenu (Pop)
  //            Create an item (PopItem) with Hint Property = 'TPUtilWindow'
  //            Send a Message (WM_MENUSELECT) to All Found Windows (1st Step)
  //            If Application.Hint = 'TPUtilWindow' we have the good one !!
  // 3d  Step : A Little Hook on Its WndProc

  // Menu97 V 1.30 or less didn't do this (First TPUtilWindow found was the good one)

  inherited Create(AOwner);

  Inc(FTPUCount);
  if ( FTPUCount = 1 ) then begin
    try
      Pop:= TPopupMenu.Create(Self);
      Pop.Name:= 'TPUtilPopup';
      PopItem:= TMenuItem.Create(Self);
      PopItem.Name:= 'TPUtilItem';
      PopItem.Caption:= 'TPUtilWindow';
      PopItem.Hint:= 'TPUtilWindow';
      Pop.Items.Add(PopItem);
      FTPUHandle:= FindWindow('TPUtilWindow', '');
      FTPUHandle:= GetNextWindow(FTPUHandle, GW_HWNDPREV);
      GetWindowThreadProcessId(Application.Handle, @ProcessId);
      TmpHandle:= FTPUHandle;
      repeat
        FTPUHandle:= GetNextWindow(FTPUHandle, GW_HWNDNEXT);
        Windows.GetClassName(FTPUHandle, CName, 50);
        if ( strcomp( CName, 'TPUtilWindow') = 0 ) then
          GetWindowThreadProcessId(FTPUHandle, @TmpProcessId)
        else
          TmpProcessId:= nil;
        if ( ( FTPUHandle <> 0 ) and ( ProcessId = TmpProcessId ) ) then begin
          Application.Hint:= '';
          SendMessage(FTPUHandle, WM_MENUSELECT, PopItem.Command, MAKELONG(PopItem.Command, 0));
          if ( Application.Hint <> 'TPUtilWindow' ) then
            TmpProcessId:= nil
          else
            Application.Hint:= '';
        end;
      until ( ( FTPUHandle = 0 ) or ( TmpHandle = FTPUHandle ) or ( ProcessId = TmpProcessId ) );
      // Si on a trouve la fenêtre on installe la procédure
      // d'interception et on sauvegarde l'ancienne.
      if Not ( ( FTPUHandle <> 0 ) and ( ProcessId = TmpProcessId ) ) then
        Dec(FTPUCount);
    finally
      Pop.Free;
    end;
  end;
  FTPUtilHookList.Add(Self);
  if ( FTPUCount > 0 ) then begin
    // Create a new proc pointer
    FNewTPUtilWndProcInstance := MakeObjectInstance(NewTPUtilWndProc);
    // Keep the old DefaultProc
    FOldTPUtilWndProc := Pointer(GetWindowLong(FTPUHandle, GWL_WNDPROC));
    // Keep Original Default Proc
    if ( FTPUCount = 1 ) then
      FOrgTPUtilWndProc:= FOldTPUtilWndProc;
    // Set the new Proc
    SetWindowLong(FTPUHandle, GWL_WNDPROC, Longint(FNewTPUtilWndProcInstance));
  end;
end;

destructor TCustomPopupMenus97.Destroy;
Var i: Integer;
begin
  Dec(FTPUCount);
  // We have to set back the old default Proc if needed
  if ( FTPUCount <> 0 ) and ( GetWindowLong(FTPUHandle, GWL_WNDPROC) = Longint(FNewTPUtilWndProcInstance) ) then
    SetWindowLong(FTPUHandle, GWL_WNDPROC, Longint(FOldTPUtilWndProc));
  // Added to keep HookChain valid
  for i:= FTPUtilHookList.Count - 1 downto 0 do begin
    if ( TCustomPopupMenus97(FTPUtilHookList[i]).FOldTPUtilWndProc = FNewTPUtilWndProcInstance ) then
      TCustomPopupMenus97(FTPUtilHookList[i]).FOldTPUtilWndProc:= FOldTPUtilWndProc;
  end;
  // This instance is no more in the list
  FTPUtilHookList.Remove(Self);
  // if there's no more instances of PopupMenus97 we set back original proc
  if ( FTPUCount = 0 ) then begin
    SetWindowLong(FTPUHandle, GWL_WNDPROC, Longint(FOrgTPUtilWndProc));
    FTPUtilHookList.Clear;
  end;
  // and we release Our WndProc instance
  FreeObjectInstance(FNewTPUtilWndProcInstance);
  inherited Destroy;
end;

procedure TCustomPopupMenus97.SetPopupMenu(Value: TPopupMenu);
begin
  InternalMenu:= Value;
end;

function TCustomPopupMenus97.GetPopupMenu: TPopupMenu;
begin
  Result:= TPopupMenu(InternalMenu);
end;

function TCustomPopupMenus97.HasBanner(Item: TMenuItem): boolean;
begin
  Result:= ((Self is TCustomPopupMenus97) and (Item.Parent = InternalMenu.Items ));
end;

procedure TCustomPopupMenus97.CalcBannerRect;
Var R1 : TRect;
    i: Integer;
begin
  GetMenuItemRect(InternalMenu.WindowHandle, InternalMenu.Handle, 0, R1);
  FBannerRect:= R1;
  for i:= 0 to GetMenuItemCount(InternalMenu.Handle) - 1 do begin
    GetMenuItemRect(InternalMenu.WindowHandle, InternalMenu.Handle, i, R1);
    if ( R1.Bottom > FBannerRect.Bottom ) then
      FBannerRect.Bottom:= R1.Bottom;
  end;
  FBannerRect.Left:= FBannerRect.Left + FBannerWidth + 2;
  OffsetRect(FBannerRect, -FBannerRect.Left, -FBannerRect.Top);
  FBannerRect.Right:= FBannerRect.Left + FBannerWidth;
end;

procedure TCustomPopupMenus97.NewTPUtilWndProc(Var Message: TMessage);
Var i: Integer;
begin
  // Only used to handle WM_DRAWITEM and WM_MEASUREITEM from Menus
  //MessageBeep(MB_OK);
  if ( InternalMenu <> nil ) then begin
    case Message.Msg of
      WM_DRAWITEM    : if ( TWMDrawItem(Message).DrawItemStruct^.CtlType = ODT_MENU ) then
                         if ( TWMDrawItem(Message).DrawItemStruct^.itemData <> 0 ) then begin
                           TCustomMenus97(TWMDrawItem(Message).DrawItemStruct^.itemData).Dispatch(Message);
                           Exit;
                         end;
      WM_MEASUREITEM : if ( TWMMeasureItem(Message).idCtl = 0 ) then
                         if ( TWMMeasureItem(Message).MeasureItemStruct^.itemData <> 0 ) then begin
                            TCustomMenus97(TWMMeasureItem(Message).MeasureItemStruct^.itemData).Dispatch(Message);
                            Exit;
                         end;
      WM_MENUCHAR    : begin
                           i:=ProcessAccel( TWMMenuChar(Message) );
                           if ( i >= 0 ) then begin
                             Message.Result:= MAKELRESULT(i, 2);
                             Exit;
                           end;
                       end;
      WM_INITMENUPOPUP : begin
                           Message.Result:= CallWindowProc(FOldTPUtilWndProc, FTPUHandle, Message.Msg, Message.WParam, Message.LParam);
                           Message.Result:= 0;
                           ModifyMenuTree(InternalMenu.Items, False);
                           FNeedBannerRect:= True;
                           Exit;
                         end;
      WM_INITMENU,
      CM_MENUCHANGED : begin
                         Message.Result:= CallWindowProc(FOldTPUtilWndProc, FTPUHandle, Message.Msg, Message.WParam, Message.LParam);
                         ModifyMenuTree(InternalMenu.Items, False);
                         Exit;
                       end;
    end;
  end;
  // else we call the old DefaultProc.
  Message.Result:= CallWindowProc(FOldTPUtilWndProc, FTPUHandle, Message.Msg, Message.WParam, Message.LParam);
end;

constructor TSystemMenu97Options.Create(Command: Integer);
begin
  inherited Create;
  FMenuItem:= TMenuItem.Create(nil);
  FMenuItem.Enabled:= True;
  FMenuItem.Caption:= '';
  FMenuItem.Tag:= -2;
  FImageIndex:= -2;
  FVisible:= smDefault;
  FCaption:= '';
  FCommand:= Command;
end;

destructor TSystemMenu97Options.Destroy;
begin
  FMenuItem.Free;
  inherited Destroy;
end;

procedure TSystemMenu97Options.MenuItemFromCommand(MenuHandle: THandle; aOwner: TCustomSystemMenus97);
const
  IBreaks: array[TMenuBreak] of Longint = (MFT_STRING, MFT_MENUBREAK, MFT_MENUBARBREAK);
  IChecks: array[Boolean] of Longint = (MFS_UNCHECKED, MFS_CHECKED);
  IDefaults: array[Boolean] of Longint = (0, MFS_DEFAULT);
  IEnables: array[Boolean] of Longint = (MFS_DISABLED or MFS_GRAYED, MFS_ENABLED);
  IRadios: array[Boolean] of Longint = (MFT_STRING, MFT_RADIOCHECK);
  ISeparators: array[Boolean] of Longint = (MFT_STRING, MFT_SEPARATOR);
var C: Array[0..100] of char;
    MI: TMenuItemInfo;
    Tmp: String;
    Exists: Boolean;
    i: Integer;
begin
  if ( Visible = smFalse ) then begin
    DeleteMenu(MenuHandle, FCommand, MF_BYCOMMAND);
  end;
  MI.cbSize:= Sizeof(TMenuItemInfo);
  MI.fMask:= MIIM_TYPE or MIIM_STATE;
  MI.fType:= MFT_STRING;
  MI.cch:= 100;
  MI.dwTypeData:= Pchar(@C);
  Exists:= GetMenuItemInfo(MenuHandle, FCommand, FALSE, MI);
  if ( Exists or ( Visible = smTrue ) ) then begin
    Tmp:= StrPAS(C);
    if ( FCaption <> '' ) or ( ( Visible = smTrue ) and ( Not Exists ) ) then begin
      Tmp:= FCaption;
      i:= Pos('#9', Tmp);
      if ( i <> 0 ) then begin
        Tmp[i]:= #9;
        Delete(Tmp, i+1, 1);
      end;
      MI.fState:= MFS_ENABLED;
    end;
    FMenuItem.ShortCut:= 0;
    if ( Pos(#9, Tmp) <> 0 ) then begin
      FMenuItem.Caption:= Copy(Tmp, 1, Pos(#9, Tmp)-1);
      Tmp:= Copy(Tmp, Pos(#9, Tmp)+1, Length(Tmp)-Pos(#9, Tmp)+1);
      FMenuItem.ShortCut:= TextToShortCut(Tmp);
    end
    else
      FMenuItem.Caption:= Tmp;
    FMenuItem.Enabled:= (MI.fState and MFS_ENABLED) = MFS_ENABLED;
    FMenuItem.Checked:= (MI.fState and MFS_CHECKED) = MFS_CHECKED;
    FMenuItem.Default:= (MI.fState and MFS_DEFAULT) = MFS_DEFAULT;
    FMenuItem.RadioItem:= (MI.hbmpChecked = 0);
    FMenuItem.Tag:= FImageIndex;
    if ( Not Exists ) then begin
      MI.cbSize := SizeOf(TMenuItemInfo);
      MI.fMask := MIIM_CHECKMARKS or MIIM_DATA or MIIM_ID or
                  MIIM_STATE or MIIM_SUBMENU or MIIM_TYPE;
      MI.fType := IRadios[FMenuItem.RadioItem] or IBreaks[FMenuItem.Break] or
      ISeparators[FCaption = '-'];
      MI.fState := IChecks[FMenuItem.Checked] or IEnables[FMenuItem.Enabled] or IDefaults[FMenuItem.Default];
      MI.wID := FCommand;
      MI.hSubMenu := 0;
      MI.hbmpChecked := 0;
      MI.hbmpUnchecked := 0;
      MI.dwTypeData := PChar(AnsiString(FCaption));
      InsertMenuItem(MenuHandle, aOwner.FInsertBefore, False, MI);
    end;
    MI.cbSize:= Sizeof(TMenuItemInfo);
    MI.fMask:= MIIM_TYPE;
    MI.fType:= 0;
    MI.cch:= 0;
    GetMenuItemInfo(MenuHandle, FCommand, FALSE, MI);
    if ( ( MI.fType and MFT_OWNERDRAW ) <> MFT_OWNERDRAW ) then
      ModifyMenu(MenuHandle, FCommand, MF_OWNERDRAW or MF_BYCOMMAND or IEnables[FMenuItem.Enabled] or IBreaks[FMenuItem.Break], FCommand, Pointer(aOwner))
  end
end;

{ TSystemMenu }

constructor TCustomSystemMenus97.Create(aOwner : Tcomponent);
begin
  inherited create(aOwner);
  FOwnerHandle:= (aOwner as TForm).Handle;
  FSysMenuHandle:= 0;
  FScItem[0]:= TSystemMenu97Options.Create(SC_RESTORE);
  FScItem[1]:= TSystemMenu97Options.Create(SC_MOVE);
  FScItem[2]:= TSystemMenu97Options.Create(SC_SIZE);
  FScItem[3]:= TSystemMenu97Options.Create(SC_MINIMIZE);
  FScItem[4]:= TSystemMenu97Options.Create(SC_MAXIMIZE);
  FScItem[5]:= TSystemMenu97Options.Create(SC_CLOSE);
  FScItem[6]:= TSystemMenu97Options.Create(SC_NEXTWINDOW);
  FScItem[7]:= TSystemMenu97Options.Create(SC_PREVWINDOW);
  FScItem[8]:= TSystemMenu97Options.Create(SC_TASKLIST);
  FScItem[9]:= TSystemMenu97Options.Create(SC_SCREENSAVE);
  if ( ( Owner as TForm ).FormStyle = fsMDIChild ) then
    FInsertBefore:= SC_NEXTWINDOW
  else
    FInsertBefore:= SC_CLOSE;
end;

destructor TCustomSystemMenus97.Destroy;
Var i: Integer;
begin
  GetSystemMenu(FOwnerHandle, TRUE);
  for i:= 0 to 9 do
    FScItem[i].Free;
  inherited Destroy;
end;

procedure TCustomSystemMenus97.ModifyMenuTree(MenuItems : TMenuItem; Restore: Boolean);
Var i: Integer;
begin
  GetSystemMenu(FOwnerHandle, TRUE);
  FSysMenuHandle:=GetSystemMenu(FOwnerHandle, FALSE);
  for i:= 0 to 9 do
    FScItem[i].MenuItemFromCommand(FSysMenuHandle, Self);
  AddItemsToSytemMenu(InternalMenu.Items, FSysMenuHandle);
  if Assigned(InternalMenu) and (InternalMenu.Items.Count>0) then
    InsertMenu(FSysMenuHandle, FInsertBefore, MF_BYCOMMAND or MF_SEPARATOR, 55000, PChar(0));
end;

function TCustomSystemMenus97.FindItemByCommand(Command: Word): TMenuItem;
Var i: Integer;
begin
  Result:= InternalMenu.FindItem(Command, fkCommand);
  if ( Result = nil ) then begin
    for i:= 0 to 9 do begin
      if ( Command = FScItem[i].FCommand ) then begin
        Result:= FScItem[i].MenuItem;
        Exit;
      end;
    end;
  end;
  if ( Result = nil ) then
    inherited FindItemByCommand(Command);
end;

function TCustomSystemMenus97.HasBanner(Item: TMenuItem): boolean;
begin
  Result:= (Item.Parent = InternalMenu.Items) or (Item.Parent = nil);
end;

procedure TCustomSystemMenus97.CalcBannerRect;
Var R1 : TRect;
    i: Integer;
begin
  GetMenuItemRect(InternalMenu.WindowHandle, FSysMenuHandle, 0, R1);
  FBannerRect:= R1;
  for i:= 0 to GetMenuItemCount(FSysMenuHandle) - 1 do begin
    GetMenuItemRect(InternalMenu.WindowHandle, FSysMenuHandle, i, R1);
    if ( R1.Bottom > FBannerRect.Bottom ) then
      FBannerRect.Bottom:= R1.Bottom;
  end;
  FBannerRect.Left:= FBannerRect.Left + FBannerWidth + 2;
  OffsetRect(FBannerRect, -FBannerRect.Left, -FBannerRect.Top);
  FBannerRect.Right:= FBannerRect.Left + FBannerWidth;
end;

procedure TCustomSystemMenus97.NewTFormWndProc(Var Message: TMessage);
var Menu: Tmenuitem;
begin
  case Message.Msg of
    WM_SYSCOMMAND     : begin
                          if (InternalMenu <> nil ) then begin
                            Menu:= InternalMenu.FindItem(Message.wParam, fkCommand);
                            if Menu <> Nil then Menu.Click;
                          end;
                        end;
  end;
  inherited NewTFormWndProc(Message);
end;

procedure TCustomSystemMenus97.AddItemsToSytemMenu(MenuItems: TMenuItem; MenuHandle: THandle);
const
  IBreaks: array[TMenuBreak] of Longint = (MFT_STRING, MFT_MENUBREAK, MFT_MENUBARBREAK);
  IChecks: array[Boolean] of Longint = (MFS_UNCHECKED, MFS_CHECKED);
  IDefaults: array[Boolean] of Longint = (0, MFS_DEFAULT);
  IEnables: array[Boolean] of Longint = (MFS_DISABLED or MFS_GRAYED, MFS_ENABLED);
  IRadios: array[Boolean] of Longint = (MFT_STRING, MFT_RADIOCHECK);
  ISeparators: array[Boolean] of Longint = (MFT_STRING, MFT_SEPARATOR);
var
  i: Integer;
  MenuItemInfo: TMenuItemInfo;
  aCaption: string;
begin
  for i:= 0 to MenuItems.Count - 1 do begin
    with ( MenuItems[i] ) do begin
      if Visible then begin
        aCaption := Caption;
        if Count > 0 then
          MenuItemInfo.hSubMenu := 0//;CreatePopupMenu
        else
          if (ShortCut <> scNone) and ((Parent = nil) or
             (Parent.Parent <> nil) or not (Parent.Owner is TMainMenu)) then
            aCaption := aCaption + #9 + ShortCutToText(ShortCut);
        MenuItemInfo.cbSize := SizeOf(TMenuItemInfo);
        MenuItemInfo.fMask := MIIM_CHECKMARKS or MIIM_DATA or MIIM_ID or
                              MIIM_STATE or MIIM_SUBMENU or MIIM_TYPE;
        MenuItemInfo.fType := IRadios[RadioItem] or IBreaks[Break] or
        ISeparators[Caption = '-'];
        MenuItemInfo.fState := IChecks[Checked] or IEnables[Enabled] or IDefaults[Default];
        MenuItemInfo.wID := Command;
        MenuItemInfo.hSubMenu := 0;
        MenuItemInfo.hbmpChecked := 0;
        MenuItemInfo.hbmpUnchecked := 0;
        MenuItemInfo.dwTypeData := PChar(AnsiString(aCaption));
        if Count > 0 then MenuITemInfo.hSubMenu := CreatePopupMenu;
        InsertMenuItem(MenuHandle, FInsertBefore, False, MenuItemInfo);
        ModifyMenu(MenuHandle, Command, MF_OWNERDRAW or MF_BYCOMMAND or IEnables[Enabled] or IBreaks[Break], Command, Pointer(Self));
        AddItemsToSytemMenu(MenuItems[i], MenuHandle);
      end
    end;
  end;
end;

procedure Register;
begin
  RegisterComponents('Travail', [TMainMenus97]);
  RegisterComponents('Travail', [TPopupMenus97]);
  RegisterComponents('Travail', [TSystemMenus97]);
  RegisterComponents('Travail', [TMenuBar97]);
  RegisterComponentEditor(TMainMenus97, TCustomMenus97Editor);
  RegisterComponentEditor(TPopupMenus97, TCustomMenus97Editor);
end;

initialization
  FTPUtilHookList:= TList.Create;
  VI.dwOSVersionInfoSize:= SizeOf(VI);
  GetVersionEx(VI);
  if (VI.dwPlatformId = VER_PLATFORM_WIN32_NT) then
    IsNTPlatform:= True
  else
    IsNTPlatform:= False;
finalization
  FTPUtilHookList.Free;
end.
