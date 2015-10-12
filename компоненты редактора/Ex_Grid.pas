{
  Библиотека дополнительных компонентов

  GridView компонент (таблица)

  Версия 1.3.13

  © Роман М. Мочалов, 1997-2001
  E-mail: roman@sar.nnov.ru
}

unit Ex_Grid;

interface

{$I EX.INC}

uses
  Windows, Messages, SysUtils, CommCtrl, Classes, Controls, Graphics, Forms,
  Dialogs, StdCtrls, Math, Mask {$IFDEF EX_D4_UP}, ImgList {$ENDIF};

type

{ Предопределение класов }

  TGridHeaderSections = class;
  TCustomGridHeader = class;
  TCustomGridColumn = class;
  TGridColumns = class;
  TCustomGridRows = class;
  TCustomGridFixed = class;
  TCustomGridView = class;

  TGridEditStyle = (geSimple, geEllipsis, gePickList, geDataList, geUserDefine);

  TGridCheckKind = (gcNone, gcCheckBox, gcRadioButton, gcUserDefine);
  TGridCheckStyle = (csFlat, cs3D, csWin95);

{ TGridHeaderSection }

  {
    Секция заголовка.

    Свойства:

    ColumnIndex -       Индекс соответствующей колонки. Для заголовка с
                        подзаголовками - это индекс, соотвествующий последнему
                        подзаголовку.
    BoundsRect -        Прямоугольник секции. Для заголовка с подзаголовками
                        не включает в себя границы подзаголовков.
    FirstColumnIndex -  Индекс самой левой колонки секции заголовка.
    FixedColumn -       Столбец заголовка или один из его подзоголовков
                        фиксирован.
    Header -            Ссылка на заголовок таблицы.
    Level -             Уровень заголовка. Самый верхний заголовок имеет
                        уровень 0, под ним - 1 и т.д.
    Parent -            Ссылка на верхнюю секцию.
    ParentSections -    Ссылка на список секций, которому принадлежит данная
                        секция.
    ResizeColumnIndex - Индекс колонки для изменения ширины при изменении
                        ширины секции мышкой. Для заголовка с подзаголовками
                        это индекс, соотвествующий последнему видимому
                        подзаголовку, для самой нижней секции это ColumnIndex.
    Visible -           Видимость секции. Секция видна, если видна хотябы одна
                        из подсекций или если видна соотвествующая олонка или
                        для секции нет колонки.

    Alignment -         Выравнивание текста заголовка по горизонтали.
    Caption -           Текст заголовка. Соответствует заголовку колонки.
    Sections -          Список подзаголовков (т.е. секций снизу).
    Width -             Ширина заголовка. Равна ширине соотвествующей колонки
                        или сумме ширин подзаголовков.
    WordWrap -          Перенос слов текста заголовка.
  }

  TGridHeaderSection = class(TCollectionItem)
  private
    FSections: TGridHeaderSections;
    FCaption: string;
    FWidth: Integer;
    FAlignment: TAlignment;
    FWordWrap: Boolean;
    FBoundsRect: TRect;
    FColumnIndex: Integer;
    function IsSectionsStored: Boolean;
    function IsWidthStored: Boolean;
    function GetAllowClick: Boolean;
    function GetBoundsRect: TRect;
    function GetFirstColumnIndex: Integer;
    function GetFixedColumn: Boolean;
    function GetHeader: TCustomGridHeader;
    function GetLevel: Integer;
    function GetParent: TGridHeaderSection;
    function GetParentSections: TGridHeaderSections;
    function GetResizeColumnIndex: Integer;
    function GetSections: TGridHeaderSections;
    function GetVisible: Boolean;
    function GetWidth: Integer;
    procedure SetAlignment(Value: TAlignment);
    procedure SetCaption(const Value: string);
    procedure SetSections(Value: TGridHeaderSections);
    procedure SetWidth(Value: Integer);
    procedure SetWordWrap(Value: Boolean);
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    property AllowClick: Boolean read GetAllowClick;
    property BoundsRect: TRect read GetBoundsRect;
    property ColumnIndex: Integer read FColumnIndex;
    property FirstColumnIndex: Integer read GetFirstColumnIndex;
    property FixedColumn: Boolean read GetFixedColumn;
    property Header: TCustomGridHeader read GetHeader;
    property Level: Integer read GetLevel;
    property Parent: TGridHeaderSection read GetParent;
    property ParentSections: TGridHeaderSections read GetParentSections;
    property ResizeColumnIndex: Integer read GetResizeColumnIndex;
    property Visible: Boolean read GetVisible;
  published
    property Alignment: TAlignment read FAlignment write SetAlignment default taLeftJustify;
    property Caption: string read FCaption write SetCaption;
    property Width: Integer read GetWidth write SetWidth stored IsWidthStored default 64;
    property WordWrap: Boolean read FWordWrap write SetWordWrap default False;
    property Sections: TGridHeaderSections read GetSections write SetSections stored IsSectionsStored;
  end;

{ TGridHeaderSections }

  {
    Список секций заголовка.

    Процедуры:

    Add -         Добавить новую секцию в список.

    Свойства:

    Header -      Ссылка на заголовок таблицы.
    MaxColumn -   Максимальный индекс столбца.
    MaxLevel -    Максимальный уровень подзаголовков. Самый верхний
                  заголовок имеет уровень 0, под ним - 1 и т.д.
    Owner -       Ссылка на секцию - владельца.
    Sections -    Список подзаголовков.
  }

  TGridHeaderSections = class(TCollection)
  private
    FHeader: TCustomGridHeader;
    FOwner: TGridHeaderSection;
    function GetMaxColumn: Integer;
    function GetMaxLevel: Integer;
    function GetSection(Index: Integer): TGridHeaderSection;
    procedure SetSection(Index: Integer; Value: TGridHeaderSection);
  protected
    function GetOwner: TPersistent; {$IFNDEF VER90} override; {$ENDIF}
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(AHeader: TCustomGridHeader; AOwner: TGridHeaderSection); virtual;
    function Add: TGridHeaderSection;
    property Header: TCustomGridHeader read FHeader;
    property MaxColumn: Integer read GetMaxColumn;
    property MaxLevel: Integer read GetMaxLevel;
    property Owner: TGridHeaderSection read FOwner;
    property Sections[Index: Integer]: TGridHeaderSection read GetSection write SetSection; default;
  end;

{ TCustomGridHeader }

  {
    Заголовок таблицы.

    Процедуры:

    SynchronizeSections - Уравнивает количество нижних секций с количеством
                          указанных столбцов.
    UpdateSections      - Обновление внутренних параметров секций (BoundsRect
                          и ColumnIndex). Данные параметры инициализируются
                          один раз при изменении заголовка для ускорения
                          работы с секциями.

    Свойства:

    Grid -              Ссылка на таблицу.
    Height -            Высота.
    Images -            Картинки секций заголовка.
    MaxColumn -         Максимальный индекс столбца.
    MaxLevel -          Максимальный уровень подзаголовков.
    Width -             Ширина

    AutoHeight -        Автоматически подбирать высоту секций.
    AutoSynchronize -   Автоматически синхронизировать секции заголовка с
                        колонками.
    Color -             Цвет фона.
    Flat -              Вид отображения секций заголовка. Если Flat = True,
                        то секции заголовока отображаются плоскими, в
                        противном слечае - виде кнопок.
    Font -              Шрифт.
    FullSynchronizing - Полностью синхронизировать секции заголовка с
                        колонками, включая текст заголовка и выравнивание
                        текста. В противном случае синхронизируется только
                        количество секций с количеством колонок.
    GridColor -         Брать ли в качестве цвета заголовка цвет таблицы.
                        ПРИМЕЧАНИЕ: если GridColor = True, то разделительные
                        линии секций заголовка рисуются одинарными линиями,
                        как сетка у обычных ячеек. В противном случае
                        разделительные линии рисуются двойными.
    GridFont -          Брать ли в качестве шрифта заголовка шрифт таблицы.
    SectionHeight -     Высота одной секции (подзаголовка). При установленном
                        свойстве AutoHeight выбирается с учетом высоты
                        картинок, 3D эффекта, значения свойства GridColor и
                        высоты шрифта.
    Sections -          Список подзаголовков.
    Synchronized -      Секции заголовка синхронизированы с колонками
                        таблицы.

    События:

    OnChange -          Событие на изменение параметров.
  }

  TCustomGridHeader = class(TPersistent)
  private
    FGrid: TCustomGridView;
    FSections: TGridHeaderSections;
    FSectionHeight: Integer;
    FAutoHeight: Boolean;
    FSynchronized: Boolean;
    FAutoSynchronize: Boolean;
    FFullSynchronizing: Boolean;
    FColor: TColor;
    FGridColor: Boolean;
    FFont: TFont;
    FGridFont: Boolean;
    FImages: TImageList;
    FImagesLink: TChangeLink;
    FFlat: Boolean;
    FOnChange: TNotifyEvent;
    procedure ImagesChange(Sender: TObject);
    function IsColorStored: Boolean;
    function IsFontStored: Boolean;
    function IsSectionsStored: Boolean;
    procedure FontChange(Sender: TObject);
    function GetHeight: Integer;
    function GetMaxColumn: Integer;
    function GetMaxLevel: Integer;
    function GetWidth: Integer;
    procedure SetAutoHeight(Value: Boolean);
    procedure SetAutoSynchronize(Value: Boolean);
    procedure SetColor(Value: TColor);
    procedure SetFlat(Value: Boolean);
    procedure SetFont(Value: TFont);
    procedure SetFullSynchronizing(Value: Boolean);
    procedure SetGridColor(Value: Boolean);
    procedure SetGridFont(Value: Boolean);
    procedure SetImages(Value: TImageList);
    procedure SetSections(Value: TGridHeaderSections);
    procedure SetSectionHeight(Value: Integer);
    procedure SetSynchronized(Value: Boolean);
  protected
    procedure Change; virtual;
    procedure GridColorChanged(NewColor: TColor); virtual;
    procedure GridFontChanged(NewFont: TFont); virtual;
  public
    constructor Create(AGrid: TCustomGridView); virtual;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure SynchronizeSections;
    procedure UpdateSections; virtual;
    property Grid: TCustomGridView read FGrid;
    property Height: Integer read GetHeight;
    property MaxColumn: Integer read GetMaxColumn;
    property MaxLevel: Integer read GetMaxLevel;
    property Width: Integer read GetWidth;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property AutoHeight: Boolean read FAutoHeight write SetAutoHeight default False;
    property AutoSynchronize: Boolean read FAutoSynchronize write SetAutoSynchronize default True;
    property Color: TColor read FColor write SetColor stored IsColorStored default clBtnFace;
    property Images: TImageList read FImages write SetImages;
    property Flat: Boolean read FFlat write SetFlat default True;
    property Font: TFont read FFont write SetFont stored IsFontStored;
    property FullSynchronizing: Boolean read FFullSynchronizing write SetFullSynchronizing default False;
    property GridColor: Boolean read FGridColor write SetGridColor default False;
    property GridFont: Boolean read FGridFont write SetGridFont default True;
    property Sections: TGridHeaderSections read FSections write SetSections stored IsSectionsStored;
    property SectionHeight: Integer read FSectionHeight write SetSectionHeight default 17;
    property Synchronized: Boolean read FSynchronized write SetSynchronized stored True;
  end;

  TGridHeader = class(TCustomGridHeader)
  published
    property AutoHeight;
    property AutoSynchronize;
    property Color;
    property Images;
    property Flat;
    property Font;
    property FullSynchronizing;
    property GridColor;
    property GridFont;
    property Sections;
    property SectionHeight;
    property Synchronized;
  end;

{ TCustomGridColumn }

  {
    Колонка таблицы.

    Свойства:

    Columns -     Ссылка на список колонок.

    AlignEdit -   Надо ли выравнивать текст в строке ввода в соответствии
                  с выравниванием текста колонки.
    Alignment -   Выравнивание текста колонки.
    AllowClick -  Можно или нет нажимать на заголовок колонки.
    Caption -     Текст заголовка.
    CheckKind -   Тип флажка колонки.
    EditMask -    Маска строки редактирования колонки.
    EditStyle -   Стиль строки ввода колонки.
    FixedSize -   Ширина колонки постоянна (нельзя изменять мышкой в RunTime).
    MaxLength -   Максимальная длина редактируемого текста. Если значение
                  установлено в -1, то строка будет ReadOnly (в то время,
                  как сама ячейка - нет).
    MaxWidth -    Максимальная ширина колонки.
    MinWidth -    Минимальная ширина колонки.
    PickList -    Содержимое выпадающего списка.
    Tag -         Аналог Tag у TComponent.
    WantReturns - Может ли быть текст в ячейках содержать символы переноса
                  строки. Если WantReturns выставлено в False, то нажатие
                  клавиши ENTER в строке ввода будет игнорировано, симовлы
                  переноса будут отображаться как обычные символы.
    WordWrap -    Разрешен ли автоматический перенос слов текста ячейки.
    ReadOnly  -   Не редактируемая.
    TabStop -     Можно ли установить курсор на колонку.
    Title -       Ссылка на секцию заголовка колонки.
    Visible -     Видимость.
    Width -       Ширина колонки. Если колонка не видима, возвращает ноль.
    DefWidth -    Реальная ширина колонки. Не зависит от видимости столбца.
  }

  TGridColumnClass = class of TCustomGridColumn;

  TCustomGridColumn = class(TCollectionItem)
  private
    FColumns: TGridColumns;
    FCaption: string;
    FWidth: Integer;
    FMinWidth: Integer;
    FMaxWidth: Integer;
    FFixedSize: Boolean;
    FMaxLength: Integer;
    FAlignment: TAlignment;
    FReadOnly: Boolean;
    FWantReturns: Boolean;
    FWordWrap: Boolean;
    FEditStyle: TGridEditStyle;
    FEditMask: string;
    FCheckKind: TGridCheckKind;
    FTabStop: Boolean;
    FVisible: Boolean;
    FPickList: TStrings;
    FAllowClick: Boolean;
    FTag: Integer;
    FAlignEdit: Boolean;
    function GetEditAlignment: TAlignment;
    function GetGrid: TCustomGridView;
    function GetPickList: TStrings;
    function GetPickListCount: Integer;
    function GetTitle: TGridHeaderSection;
    function GetWidth: Integer;
    function IsPickListStored: Boolean;
    procedure ReadMultiline(Reader: TReader);
    procedure SetAlignEdit(Value: Boolean);
    procedure SetCheckKind(Value: TGridCheckKind);
    procedure SetMaxWidth(Value: Integer);
    procedure SetMinWidth(Value: Integer);
    procedure SetPickList(Value: TStrings);
    procedure SetTabStop(Value: Boolean);
    procedure SetWantReturns(Value: Boolean);
    procedure SetWordWrap(Value: Boolean);
  protected
    procedure DefineProperties(Filer: TFiler); override;
    function GetDisplayName: string; {$IFNDEF VER90} override; {$ENDIF}
    procedure SetAlignment(Value: TAlignment); virtual;
    procedure SetCaption(const Value: string); virtual;
    procedure SetEditMask(const Value: string); virtual;
    procedure SetEditStyle(Value: TGRidEditStyle); virtual;
    procedure SetMaxLength(Value: Integer); virtual;
    procedure SetReadOnly(Value: Boolean); virtual;
    procedure SetVisible(Value: Boolean); virtual;
    procedure SetWidth(Value: Integer); virtual;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    property AlignEdit: Boolean read FAlignEdit write SetAlignEdit default False;
    property Alignment: TAlignment read FAlignment write SetAlignment default taLeftJustify;
    property AllowClick: Boolean read FAllowClick write FAllowClick default True;
    property Caption: string read FCaption write SetCaption;
    property CheckKind: TGridCheckKind read FCheckKind write SetCheckKind default gcNone;
    property Columns: TGridColumns read FColumns;
    property EditAlignment: TAlignment read GetEditAlignment;
    property EditMask: string read FEditMask write SetEditMask;
    property EditStyle: TGridEditStyle read FEditStyle write SetEditStyle default geSimple;
    property FixedSize: Boolean read FFixedSize write FFixedSize default False;
    property Grid: TCustomGridView read GetGrid;
    property MaxLength: Integer read FMaxLength write SetMaxLength default 0;
    property MaxWidth: Integer read FMaxWidth write SetMaxWidth default 10000;
    property MinWidth: Integer read FMinWidth write SetMinWidth default 0;
    property PickList: TStrings read GetPickList write SetPickList stored IsPickListStored;
    property PickListCount: Integer read GetPickListCount;
    property ReadOnly: Boolean read FReadOnly write SetReadOnly default False;
    property TabStop: Boolean read FTabStop write SetTabStop default True;
    property Tag: Integer read FTag write FTag default 0;
    property Title: TGridHeaderSection read GetTitle;
    property Visible: Boolean read FVisible write SetVisible default True;
    property WantReturns: Boolean read FWantReturns write SetWantReturns default False;
    property Width: Integer read GetWidth write SetWidth stored False default 64;
    property WordWrap: Boolean read FWordWrap write SetWordWrap default False;
    property DefWidth: Integer read FWidth write SetWidth default 64;
  end;

  TGridColumn = class(TCustomGridColumn)
  published
    property AlignEdit;
    property Alignment;
    property AllowClick;
    property Caption;
    property CheckKind;
    property EditMask;
    property EditStyle;
    property FixedSize;
    property MaxLength;
    property MaxWidth;
    property MinWidth;
    property PickList;
    property ReadOnly;
    property TabStop;
    property Tag;
    property Visible;
    property WantReturns;
    property Width;
    property WordWrap;
    property DefWidth;
  end;

{ TGridColumns }

  {
    Список колонок таблицы.

    Процедуры:

    Add -     Добавить колонку.

    Свойства:

    Columns - Список колонок.
    Layout -  Строка состояния колонок. Содержит список чисел, разделенных
              запятой, определяющий видимость и ширину каждой колонки.
              Подходит для сохранения раскладки колонок в реестр или INI
              файл.
    Grid -    Ссылка на таблицу.
  }

  TGridColumns = class(TCollection)
  private
    FGrid: TCustomGridView;
    FOnChange: TNotifyEvent;
    function GetColumn(Index: Integer): TGridColumn;
    function GetLayout: string;
    procedure SetColumn(Index: Integer; Value: TGridColumn);
    procedure SetLayout(const Value: string);
  protected
    function GetOwner: TPersistent; {$IFNDEF VER90} override; {$ENDIF}
    procedure Update(Item: TCollectionItem); override;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  public
    constructor Create(AGrid: TCustomGridView); virtual;
    function Add: TGridColumn;
    property Columns[Index: Integer]: TGridColumn read GetColumn write SetColumn; default;
    property Grid: TCustomGridView read FGrid;
    property Layout: string read GetLayout write SetLayout;
  end;

{ TCustomGridRows }

  {
    Строки таблицы.

    Свойства:

    MaxCount -    Максимально допустимое количество строк в таблице. Зависит
                  от высоты строки.

    AutoHeight -  Автоматически подбирать высоту строк.
    Count -       Количество строк в таблице.
    Grid -        Ссылка на таблицу.
    Height -      Высота одной строки. При установленном свойстве AutoHeight
                  выбирается с учетом наличия флажков, высоты картинок,
                  высоты шрифта таблицы, высоты шрифта, 3D вида, значения
                  свойства Fixed.GridColor, вертикального смещения текста
                  ячейки, наличия сетки.
                  ПРИМЕЧАНИЕ: Если высота строки меньше, чем высота текста
                  ячейки, возможны глюки с отрисовкой кнопки строки ввода
                  таблицы. Соотвествие высоты строки и шрифта таблицы
                  следует отслеживать вручную или установить AutoHeight в
                  True.

    События:

    OnChange -        Событие на изменение параметров.
  }

  TCustomGridRows = class(TPersistent)
  private
    FGrid: TCustomGridView;
    FCount: Integer;
    FHeight: Integer;
    FAutoHeight: Boolean;
    FOnChange: TNotifyEvent;
    function GetMaxCount: Integer;
    procedure SetAutoHeight(Value: Boolean);
    procedure SetHeight(Value: Integer);
  protected
    procedure Change; virtual;
    procedure SetCount(Value: Integer); virtual;
  public
    constructor Create(AGrid: TCustomGridView); virtual;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    property AutoHeight: Boolean read FAutoHeight write SetAutoHeight default False;
    property Count: Integer read FCount write SetCount default 0;
    property Grid: TCustomGridView read FGrid;
    property Height: Integer read FHeight write SetHeight default 17;
    property MaxCount: Integer read GetMaxCount;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

  TGridRows = class(TCustomGridRows)
  published
    property AutoHeight;
    property Count;
    property Height;
  end;

{ TCustomGridFixed }

  {
    Параметры фиксированныех колонок таблицы.

    Count -     Количество фиксированных столбцов. Не может быть больше, чем
                количество столбцов таблицы минус 1.
    Color -     Цвет фиксированной части.
    Flat -      Вид отображения фиксированных ячеек. Если Flat = True, то
                ячейки отображаются плоскими, иначе - в виде кнопок.
    Font -      Шрифт текста ячеек.
    GridColor - Брать ли в качестве цвета фиксированных цвет таблицы.
                ПРИМЕЧАНИЕ: если GridColor = True, то сетка фиксированных
                ячеек рисуется одинарными линимя, как у обычных ячеек. В
                противном случае сетка - двойная разделительная линия, как
                у заголовка
    GridFont -  Брать ли в качестве шрифта фиксированных шрифт таблицы.

    События:

    OnChange -  Событие на изменение параметров.
  }

  TCustomGridFixed = class(TPersistent)
  private
    FGrid: TCustomGridView;
    FCount: Integer;
    FColor: TColor;
    FGridColor: Boolean;
    FFont: TFont;
    FGridFont: Boolean;
    FFlat: Boolean;
    FOnChange: TNotifyEvent;
    function IsColorStored: Boolean;
    function IsFontStored: Boolean;
    procedure FontChange(Sender: TObject);
    procedure SetColor(Value: TColor);
    procedure SetFlat(Value: Boolean);
    procedure SetFont(Value: TFont);
    procedure SetGridColor(Value: Boolean);
    procedure SetGridFont(Value: Boolean);
  protected
    procedure Change; virtual;
    procedure GridColorChanged(NewColor: TColor); virtual;
    procedure GridFontChanged(NewFont: TFont); virtual;
    procedure SetCount(Value: Integer); virtual;
  public
    constructor Create(AGrid: TCustomGridView); virtual;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    property Color: TColor read FColor write SetColor stored IsColorStored default clBtnFace;
    property Count: Integer read FCount write SetCount default 0;
    property Flat: Boolean read FFlat write SetFlat default True;
    property Font: TFont read FFont write SetFont stored IsFontStored;
    property Grid: TCustomGridView read FGrid;
    property GridColor: Boolean read FGridColor write SetGridColor default False;
    property GridFont: Boolean read FGridFont write SetGridFont default True;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

  TGridFixed = class(TCustomGridFixed)
  published
    property Color;
    property Count;
    property Flat;
    property Font;
    property GridColor;
    property GridFont;
  end;

{ TGridCell }

  TGridCell = record
    Col: Longint;
    Row: Longint;
  end;

{ TGridScrollBar }

  {
    Полоса прокрутки таблицы.

    Процедуры:

    Change -        Вызывается стразу после изменения позиции.
    Scroll -        Вызывается непосредственно перед изменением позиции для
                    корректировки нового положения.
    ScrollGrid -    Скроллировать изображение сетки. Вызывается при смене
                    позиции движка.
    ScrollMessage - Обработать сообщение Windows о нажатии на скроллер.
    SetParams -     Установить пределы.
    SetPosition -   Установить позицию.
    SetPositionEx - Установить позицию.

    Свойства:

    Grid -           Ссылка на таблицу.
    Kind -           Вид скроллера (горизонтальный или вертикальный).
    LineStep -       Малый шаг.
    LineSize -       Размер скроллируемой части окна при смещении на 1
                     позицию.
    Min -            Минимум.
    Max -            Максимум.
    PageStep -       Большой шаг.
    Position -       Текущая позиция.

    Tracking -       Признак синхронного изменения позиции при перемещении
                     мышкой центрального движка.
    Visible -        Видимость скроллера.

    События:

    OnChange -       Произошли изменения положения.
    OnChangeParams - Произошли изменения параметров (шаг, максимум).
    OnScroll -       Вызывается непосредственно перед изменением положения
                     скроллера.
  }

  TGridScrollEvent = procedure(Sender: TObject; ScrollCode: Integer; var ScrollPos: Integer) of object;

  TGridScrollBar = class(TPersistent)
  private
    FGrid: TCustomGridView;
    FKind: TScrollBarKind;
    FPosition: Integer;
    FMin: Integer;
    FMax: Integer;
    FPageStep: Integer;
    FLineStep: Integer;
    FLineSize: Integer;
    FTracking: Boolean;
    FVisible: Boolean;
    FUpdateLock: Integer;
    FOnScroll: TGridScrollEvent;
    FOnChange: TNotifyEvent;
    FOnChangeParams: TNotifyEvent;
    function GetRange: Integer;
    procedure SetLineSize(Value: Integer);
    procedure SetLineStep(Value: Integer);
    procedure SetMax(Value: Integer);
    procedure SetMin(Value: Integer);
    procedure SetPageStep(Value: Integer);
    procedure SetVisible(Value: Boolean);
  protected
    procedure Change; virtual;
    procedure ChangeParams; virtual;
    procedure Scroll(ScrollCode: Integer; var ScrollPos: Integer); virtual;
    procedure ScrollMessage(var Message: TWMScroll); virtual;
    procedure SetParams(AMin, AMax, APageStep, ALineStep: Integer); virtual;
    procedure SetPosition(Value: Integer);
    procedure SetPositionEx(Value: Integer; ScrollCode: Integer); virtual;
    procedure Update; virtual;
  public
    constructor Create(AGrid: TCustomGridView; AKind: TScrollBarKind); virtual;
    procedure Assign(Source: TPersistent); override;
    procedure LockUpdate;
    procedure UnLockUpdate;
    property Grid: TCustomGridView read FGrid;
    property Kind: TScrollBarKind read FKind;
    property LineStep: Integer read FLineStep write SetLineStep;
    property LineSize: Integer read FLineStep write SetLineSize;
    property Max: Integer read FMax write SetMax;
    property Min: Integer read FMin write SetMin;
    property PageStep: Integer read FPageStep write SetPageStep;
    property Position: Integer read FPosition write SetPosition;
    property Range: Integer read GetRange;
    property UpdateLock: Integer read FUpdateLock;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnChangeParams: TNotifyEvent read FOnChangeParams write FOnChangeParams;
    property OnScroll: TGridScrollEvent read FOnScroll write FOnScroll;
  published
    property Tracking: Boolean read FTracking write FTracking default True;
    property Visible: Boolean read FVisible write SetVisible default True;
  end;

{ TGridListBox }

  {
    Выпадающий список строки редактирования.
  }

  TGridListBox = class(TCustomListBox)
  private
    FGrid: TCustomGridView;
    FSearchText: String;
    FSearchTime: Longint;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
    procedure KeyPress(var Key: Char); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
  public
    property OnDrawItem;
    constructor Create(AOwner: TComponent); override;
    property Grid: TCustomGridView read FGrid;
  end;

{ TCustomGridEdit }

  {
    Сторка ввода таблицы. Может содержать кнопку с многоточием или кнопку с
    выпадающим списокм.

    Процедуры:

    GetDropList -      Получить выпадающий список строки редактирования в
                       соотвествии с типом строки. Функцию следует перекрыть
                       для получения создания списка другого класса,
                       отличного от TGridListBox. Например, наследник
                       TDBGridView вовзращает список TDBLookupListBox для
                       строки типа TDataList.
    PaintButton -      Рисовать кнопку.
    UpdateBounds -     Определение положения и размера строки с последующим
                       показом ее (вызывается непосредственно из метода
                       Show).
    UpdateColors -     Определение цвета ячейки и шрифта.
    UpdateContents -   Определение текста строки, максимальной длины строки
                       и возможности редактирования.
    UpdateList -       Настройка внешнего вида выпадащенго списка.
    UpdateListBounds - Определение положения и размера выпадающего списка.
    UpdateListItems -  Заполнение текущего выпадающего списка значениями.
    UpdateListValue -  Установка выбранного значения выпадающего списка.
                       Вызывается из метода CloseUp при выборе значения.
    UpdateStyle -      Определение типа строки.

    CloseUp -          Закрыть выпадающий список.
    DropDown -         Открыть выпадающий список (только для строки с типом
                       gePickList, geDataList).
    Press -            Нажатие на кнопку с многоточием (мышкой или нажат
                       Ctrl+Enter при WantReturns = False).
    SelectNext -       Следует выбрать следующее значение из списка (нажат
                       Ctrl+Enter при WantReturns = False).

    Свойства:

    ButtonRect -       Прямоугольник кнопки.
    ButtonWidth -      Ширина кнопки.
    DropDownCount -    Количество строк в выпадающем списке.
    DropList -         Текущий выпадающий список строки. Может не совпадать
                       с DropListBox дл янаследников (например, для Lookup
                       ячеек в TDBGridView).
    DropListBox -      Собственный выпадающий список строки.
    DropListVisible -  Видимость выпадающего списка.
    EditStyle -        Тип строки. Может принимать следующие значения:
                         geSimple -      простая строка редактирования.
                         geEllipsis -    строка с кнопкой ... (с многоточием)
                         gePickList -    строка с кнопкой выпадающего списка
                         geDataList -    зарезервированно для дальнейших
                                         DB версий.
                         geUserDefine -  строка с кнопкой пользователя.
    Grid -             Ссылка на кнопку.
    LineCount -        Количество строк в строке.
    WantReturns -      Может ли текст в строке содержать символы переноса.
    WordWrap -         Разрешен ли автоматический перенос слов.
  }

  TGridEditClass = class of TCustomGridEdit;

  TCustomGridEdit = class(TCustomMaskEdit)
  private
    FGrid: TCustomGridView;
    FClickTime: Longint;
    FEditStyle: TGridEditStyle;
    FWantReturns: Boolean;
    FWordWrap: Boolean;
    FDropDownCount: Integer;
    FDropListVisible: Boolean;
    FPickList: TGridListBox;
    FActiveList: TWinControl;
    FButtonWidth: Integer;
    FButtonTracking: Boolean;
    FButtonPressed: Boolean;
    FDefocusing: Boolean;
    FAlignment: TAlignment;
    function GetButtonRect: TRect;
    function GetLineCount: Integer;
    function GetVisible: Boolean;
    procedure ListMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure SetAlignment(Value: TAlignment);
    procedure SetButtonWidth(Value: Integer);
    procedure SetDropListVisible(Value: Boolean);
    procedure SetEditStyle(Value: TGridEditStyle);
    procedure SetWordWrap(Value: Boolean);
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure WMPaste(var Message); message WM_PASTE;
    procedure WMCut(var Message); message WM_CUT;
    procedure WMClear(var Message); message WM_CLEAR;
    procedure WMUndo(var Message); message WM_UNDO;
    procedure WMCancelMode(var Message: TMessage); message WM_CANCELMODE;
    procedure WMKillFocus(var Message: TMessage); message WM_KILLFOCUS;
    procedure WMWindowPosChanged(var Message: TWMWindowPosChanged); message WM_WINDOWPOSCHANGED;
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
    procedure WMLButtonDown(var Message: TWMLButtonDown); message WM_LBUTTONDOWN;
    procedure WMLButtonDblClk(var Message: TWMLButtonDblClk); message WM_LBUTTONDBLCLK;
    procedure WMSetCursor(var Message: TWMSetCursor); message WM_SETCURSOR;
    procedure CMCancelMode(var Message: TCMCancelMode); message CM_CANCELMODE;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure CMShowingChanged(var Message: TMessage); message CM_SHOWINGCHANGED;
    procedure WMContextMenu(var Message: TMessage); message WM_CONTEXTMENU;
  protected
    procedure Change; override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure DblClick; override;
{$IFDEF EX_D4_UP}
    function DoMouseWheel(Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint): Boolean; override;
{$ENDIF}
    function EditCanModify: Boolean; override;
    function GetDropList: TWinControl; virtual;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure PaintButton(DC: HDC); virtual;
    procedure PaintWindow(DC: HDC); override;
    procedure StartButtonTracking(X, Y: Integer);
    procedure StepButtonTracking(X, Y: Integer);
    procedure StopButtonTracking;
    procedure UpdateBounds(ScrollCaret: Boolean); virtual;
    procedure UpdateColors; virtual;
    procedure UpdateContents; virtual;
    procedure UpdateList; virtual;
    procedure UpdateListBounds; virtual;
    procedure UpdateListItems; virtual;
    procedure UpdateListValue(Accept: Boolean); virtual;
    procedure UpdateStyle; virtual;
    procedure WndProc(var Message: TMessage); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure CloseUp(Accept: Boolean); virtual;
    procedure Deselect;
    procedure DropDown;
    procedure Invalidate; override;
    procedure Hide;
    procedure Press;
    procedure SelectNext;
    procedure SetFocus; override;
    procedure Show;
    property ActiveList: TWinControl read FActiveList write FActiveList;
    property Alignment: TAlignment read FAlignment write SetAlignment default taLeftJustify;
    property ButtonRect: TRect read GetButtonRect;
    property ButtonWidth: Integer read FButtonWidth write SetButtonWidth;
    property Color;
    property DropDownCount: Integer read FDropDownCount write FDropDownCount;
    property DropListVisible: Boolean read FDropListVisible write SetDropListVisible;
    property EditStyle: TGridEditStyle read FEditStyle write SetEditStyle;
    property Font;
    property Grid: TCustomGridView read FGrid;
    property LineCount: Integer read GetLineCount;
    property MaxLength;
    property PickList: TGridListBox read FPickList;
    property Visible: Boolean read GetVisible;
    property WantReturns: Boolean read FWantReturns write FWantReturns;
    property WordWrap: Boolean read FWordWrap write SetWordWrap;
  end;

  TGridEdit = class(TCustomGridEdit);

{ TGridTipsWindow }

  TGridTipsWindowClass = class of TGridTipsWindow;

  TGridTipsWindow = class(THintWindow)
  private
    FGrid: TCustomGridView;
    procedure WMNCPaint(var Message: TMessage); message WM_NCPAINT;
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
  protected
    procedure Paint; override;
  public
    procedure ActivateHint(Rect: TRect; const AHint: string); override;
{$IFNDEF VER90}
    procedure ActivateHintData(Rect: TRect; const AHint: string; AData: Pointer); override;
    function CalcHintRect(MaxWidth: Integer; const AHint: string; AData: Pointer): TRect; override; 
{$ENDIF}
  end;

{ TCustomGridView }

  {
    Таблица.

    Процедуры:

    AcquireFocus -         Установка фокуса на талицу или строку ввода.
                           Возвращает False, если по каим либо причинам фокус
                           не установлен.
    CellClick -            Нажатие машкой на ячейке.
    Change -               Ячейка выдлена.
    Changing -             Ячейка выделяется.
    CheckClick -           Нажатие машкой на флажке ячейки.
    ColumnAutoSize -       Иширина колонка изменяется на ширину, расчитанную
                           автоматически по ширине текста.
    ColumnResizing -       Изменяется ширина колонки.
    ColumnResize -         Изменена ширина колонки.
    CreateColumn -         Создать колонку. Данная функция используется
                           для создания колонок другого класса, отличного от
                           TGridColumn.
    CreateColumns -        Создать список колонок таблицы. Функцию следует
                           использовать для создания колонок другого класса,
                           отличного от TGridColumns.
    CreateEdit -           Создать строку редактирования указанного типа или
                           стандартного класса TGridEdit, если класс не
                           указан. Для указания типа строки ввода таблицы,
                           отличного от стандартного, следует перекрыть
                           функцию GetEditClass.
                           ПРИМЕЧАНИЕ: Функцией создания строки ввода
                           следует пользоваться только для только для
                           выполнения дополнительных действий, необходимых
                           для корректного создания строки (т.е.
                           непосредственно после вызова конструктора). Если
                           необходимо только изменить класс строки, следует
                           перекрыть функцию GetEditClass. 
                           ВНИМАНИЕ: На момент создания EditCell может еще
                           не указывает на ячейку редактирования. Для
                           определения будущей ячейки редактирования следует
                           использовать CellFocused.
    CreateFixed -          Создать список фиксированных колонок. Функцию
                           следует использовать для создания фиксированных
                           другого класса, отличного от TGridFixed.
    CreateHeader -         Создать заголовок. Функцию следует использовать
                           для создания заголовка другого класса, отличного
                           от TGridHeader.
    CreateHeaderSection -  Создать секцию заголовка. Данную функцию следует
                           использовать для создания секций заголовка другого
                           класса, отличного от TGridHeaderSection.
    CreateRows -           Создать список строк. Данную функцию следует
                           использовать для создания строк другого класса,
                           отличного от TGridRows.
    CreateScrollBar -      Создать полосу прокрутки. Функцию следует
                           использовать для создания полосы прокрутки другого
                           класса, отличного от TGridScrollBar.
    EditButtonPress -      Произошло нажатие на кнопке строки редактирования.
    EditCanAcceptKey -     Можно ли вводить указанный символ в ячейку.
    EditCanceled -         Строка редактирования погашена в результате
                           нажатия клавиши Escape.
    EditCanModify -        Можно ли редактировать текст в ячейке. Вызывается
                           непосредственно перед производимым изменением в
                           строке ввода (нажатие клавиши и т.п.).
    EditCanShow -          Может ли быть показана строка ввода.
    EditCanUndo -          Может ли строка ввода выполнять операцию Undo.
    EditChange -           Изменился текст в строке ввода.
    EditCloseUp -          Закрытие выпадающего списка с выбором значения.
    EditSelectNext -       Нажат Ctrl+Enter на кнопке с нераскрытым списком.
                           В параметр Value следует вернуть новое значение
                           для строки ввода.
    GetCellColors -        Установка цветов ячейки в зависимости от фокуса,
                           выделения и т.п.
    GetCellImage -         Вернуть номер картинки ячейки. Если картинок нет,
                           обязательно следует в вернуть -1.
    GetCellImageRect -     Прямоугольник картинки ячейки относительно левого
                           верхнего угла таблицы.
    GetCellHintRect -      Вернуть прямоугольника границы подсказки ячейки.
                           Если текст не помещяется в эти границы, то
                           показывается подсказка ячейкт (CellTips).
    GetCellText -          Вернуть текст ячейки.
    GetCellTextBounds -    Вычислить прямоугольник текста ячейки. Для
                           вычисления использует GetTextRect и GetCellText.
    GetCellTextIndent -    Вернуть смещение текста ячейки по горизонтали
                           относительно леавого и верхнего края прямоугольника
                           редактирования. Смещение слева по умолчанию равно
                           2 пиксела, если есть флажок или картинка, и
                           TextLeftIndent пикселов, если в ячейке только
                           текст. Смещение сверху умолчанию равно
                           TextTopIndent плюс два пиксела, если фиксированные
                           ячейки имеют вид кнопки (not Flat).
    
    GetCheckAlignment -    Вернуть выравнивание флажка ячейки. Допускаются
                           следующие значения:
                             taLeftJustify - флажок слева.
                             taCenter -      флажок по центру ячейки.
    GetCheckImage -        Венруть картинку ячейки. Картинка должна быть
                           размерами CheckWidth х CheckHeight пикселов
                           (т.е. 16х16), желательно с прозрачным фоном.
    GetCheckKind -         Вернуть тип флажка ячейки. Резальтат может
                           принимать следующие значения:
                             gcNone -        Ячейка не сожержит флажка.
                             gcCheckBox -    Ячейка содержит флажок как у
                                             компонента TCheckBox.
                             gcRadioButton - Ячейка содержит флажок как
                                             у компонента TRadioButton.
                             gcUserDefine -  Ячейка содержит флажок, вид
                                             которого определяется
                                             пользователем. Для определения
                                             вида используется событие
                                             OnGetCheckImage.
    GetCheckRect -         Получить прямоугольник флажка ячейки в координатах
                           относительно таблицы.
    GetCheckState -        Вернуть состояние влажка ячейки.
    GetColumnClass -       Вернуть класс колонок таблицы. Используется для
                           переопределения класса колонок у таблиц-наследников
                           (например TDBGridView) для корректной работы
                           редакторов Delphi IDE.
    GetCursorCell -        Найти ячейку, на которую можно установить курсор.
                           В качестве параметров передается ячейка и смещение
                           от этой ячейки. Если полученная после смещения
                           ячейка не может принимать фокус, в указанном
                           направлении  ищется следующая доступная ячейка.
                           Параметр смещения может принимать следующие
                           значения:
                             goLeft -     Сместиться от указанной на одну
                                          колонку влево.
                             goRight -    Сместиться от указанной на одну
                                          колонку вправо.
                             goUp -       Сместиться от указанной на одну
                                          колонку вверх.
                             goDown -     Сместиться от указанной на одну
                                          колонку вниз.
                             goPageUp -   Сместиться от указанной на
                                          страницу вверх.
                             goPageDown - Сместиться от указанной на
                                          страницу вниз.
                             goHome -     Найти первую доступную ячейку на
                                          указанной строке.
                             goEnd -      Найти последнюю доступную ячейку
                                          на указанной строке.
                             goGridHome - Сместиться в верхний левый угол
                                          таблицы.
                             goGridEnd -  Сместиться в нижний правый угол
                                          таблицы.
                             goSelect -   Выделить указанную ячейку. Если
                                          ячейка не доступна, найти
                                          подходящую на той же строке или в
                                          той же колонке.
                             goFirst -    Найти первую попавшуюся доступную
                                          ячейку.
                             goNext -     Найти следующую ячейку. Поиск идет
                                          вправо от указанной ячейки до края,
                                          потом переходит на строку вниз и
                                          т.д. 
                             goPrev -     Найти предыдущую ячейку. Поиск
                                          идет от указанной ячейки влево до
                                          края, потом переходит на строку
                                          вверх и т.д.
    GetEditClass -         Вернуть класс строки редактирования для указанной
                           ячейки. Если класс строки не совпадает с тем, что
                           был раньше, то создается новая строка указанного
                           класса (по аналогии с тем, как это делается в
                           TApplication.ActivateHint). Т.о. на каждую ячейку
                           можно сделать свою строку редактирования.
    GetEditList -          Заполнить выпадающий список строки редактирования.
    GetEditListBounds -    Подправить положение выпадающего списка строки
                           редактирования.
    GetEditMask -          Вернуть маску ввода для редактирования. По
                           умолчанию маски нет.
    GetEditStyle -         Вернуть стиль сроки редактирования.
    GetEditText -          Вернуть текст ячейки для редактирования. По
                           умолчанию возвращает текст ячейки.
    GrtGridLineColor -     получить цвет линии сетки.
    GetHeaderColors -      Установка цветов секции заголовка.
    GetHeaderImage -       Вернуть номер картинки секции заголовка. Если
                           картинок нет, обязательно следует в вернуть -1.
    GetSortDirection -     Определить направление сортировки для указанного
                           столбца. Результат может принимать следующие
                           значения:
                             gsNone -       Нет сортировки.
                             gsAscending -  Сортировка по возрастанию.
                             gsDescending - Сортировка по убыванию.
    GetSortImage -         Вернуть картинку сортировки для указанной колонки.
    GetTextRect -          Универсальная процедура вычисления прямоугольника
                           текста для ячейки. Не привязана к полотну таблицы
                           и ячейке. Всегда должна быть идентична
                           универсальной процедуре отрисовки текста.
    GetTipsRect -          Вычислить прямоугольник для показа подсказки с
                           текстом ячейки. Для вычисления использует
                           процедуру GetTextRect.
    GetTipsText -          Вернуть текст подсказки для указанной ячейки. По
                           умолчанию возвращается текст ячейки.
    GetTipsWindowClass -   Вернуть класс окна подсказки ячейки.
    HeaderClick -          Нажата секция заголовка.
    HeaderClicking -       Начинается нажатие на секцию заголовка.
    HideCursor -           Погасить курсор.
    HideEdit -             Скрыть строку редактирования.
    HideFocus -            Погасить прямоугольник фокуса.
    PaintCell -            Рисовать ячейку.
    PaintCells -           Рисовать ячейки.
    PaintFixed -           Рисовать фиксированные ячейки.
    PaintFixedGrid -       Рисовать сетку фиксированных ячеек.
    PaintFocus -           Рисовать прямоугольник фокуса.
    PaintFreeField -       Рисовать область, свободную от ячеек.
    PaintGridLines -       Рисовать линии сетки.
    PaintHeader -          Рисовать секцию заголовка.
    PaintHeaders -         Рисовать заголовок.
    PaintHeaderSections -  Рисовать секции заголовка.
    PaintResizeLine -      Рисовать линию при изменении размера колонки.
    PaintText -            Универсальная процедура отрисовки текста ячейки.
                           Не привязана к полотну таблицы и ячейке.
                           Используется также для отрисовки CellTips. В
                           случае перекрытия процедуры необходимо учесть
                           изменения при вычислении прямоугольника подсказки
                           (т.е. внутри функции GetTextRect).
    SetEditText -          Установть текст в ячейку из строки ввода.
                           Вызывается при смене ячейки, если только ячейка
                           не ReadOnly. Если текст не принимается, следует
                           вызвать исключение.
    SetCursor -            Установть курсор в указанную ячейку.
    ShowCursor -           Показать курсор.
    ShowEdit -             Показать строку редактирования.
    ShowEditChar -         Показать строку редактирования и передать ей
                           символ.
    ShowFocus -            Показать прямоугольник фокуса.
    StartColResize -       Начать изменение ширины колонки.
    StartHeaderClick -     Начать нажатие на заголовок.
    StepColResize -        Продолжить изменение ширины колонки.
    StepHeaderClick -      Продолжить нажатие на заголовок.
    StopColResize -        Завершить изменение ширины колонки.
    StopHeaderClick -      Завершить нажатие на заголовок.

    ApplyEdit -            Завершение редактирования с применением текста
                           ячейки. По умолчанию вызывает SetEditText.
    CancelEdit -           Отмена редактирования ячейки. В звисимости от
                           значения AlwaysEdit устанавливает текст строки
                           ввода на текст ячейки или гасит строку ввода без
                           вывода OnSetEditText.
    DrawDragRect -         Рисовать рамку фокуса на ячейке. Используется
                           для опметки ячейки при операции DragDrop.
    FindText -             Поиск ячейки с указанным текстом. Возвращает True,
                           если ячейка найдена.
    GetCellAt -            Найти ячейку по точке. Возвращает (-1, -1), если
                           ячейка не найдена.
    GetCellRect -          Прямоугольник ячейки относительно левого верхнего
                           угла таблицы.
    GetCellsRect -         Получить прямоугольник ячеек.
    GetColumnAt -          Найти колонку по точке. Возвращает -1, если
                           колонка не найдена.
    GetColumnMaxWidth -    Максмальная ширина видимого текста в указанной
                           колонке. Если отсутствует хотябы одна видимая
                           строка, возвращает ширину колонки.
    GetColumnRect -        Прямоугольник колонки.
    GetColumnsRect -       Прямоугольник колонок с указанную по указанную.
    GetColumnsWidth -      Суммарная ширина колонок с указанной по указанную.
    GetEditRect -          Вернуть прямоугольник для строки редактирования.
                           По умолчанию равен прямоугольнику ячейки за
                           вычетом флажка и картинки слева.
    GetFirstImageColumn -  Получить номер картинки для первой видимой
                           нефиксированной колонки. По умолчанию такая
                           колонка имеет картинку, остальные не имеют.
    GetFixedRect -         Прямоугольник фиксированных колонок.
    GetFixedWidth -        Суммарная ширина фиксированных колонок.
    GetFocusRect -         Прямоугольник фокуса. По умолчанию вычисляется с
                           учетом построчного выделения и наличия картинок.
    GetGridHeight -        Высота видимой части ячеек.
    GetGridOrigin -        Сдвиг ячеек относительно левого верхнего угла
                           видимого прямоугольника таблицы (т.е. исключая
                           заголовок) в пикселах. Определяется положением
                           движков скроллеров.
    GetGridRect -          Прямоугольник видимой части ячеек (в клиентских
                           координатах таблицы).
    GetHeaderHeight -      Высота заголовка. Равна 0, если не видим.
    GetHeaderRect -        Прямоугольник заголовка.
    GetHeaderSection -     Найти секцию заголовка указанного уровня для
                           указанной колонки. Если в качестве уровня указана
                           -1, то возвращается самая нижняя секция.
    GetResizeSectionAt -   Вернуть секцию заголовка, над правой границей
                           которой находится указанная точка.
    GetRowAt -             Найти строку по точке.
    GetRowRect -           Прямоугольник строки. 
    GetRowsRect -          Прямоугольник строк с указанную по указанную.
    GetRowsHeight -        Вернуть суммарную высоту строк от указанной до
                           указанной.
    GetSectionAt -         Получить секцию заголовка, которая содержит
                           указанную точку.
    InvalidateCell -       Перерисовать ячейку.
    InvalidateCheck -      Перерисовать флажок ячейки.
    InvalidateColumn -     Перерисовать колонки.
    InvalidateColumns -    Перерисовать колонки с указанной по указанную.
    InvalidateEdit -       Перерисовать строку ввода.
    InvalidateFixed -      Перерисовать фиксированные колонки.
    InvalidateFocus -      Перерисовать фокус (ячейку или строку).
    InvalidateGrid -       Перерисовать таблицу (все ачейки).
    InvalidateHeader -     Перерисовать заголовок.
    InvalidateRect -       Обновить прямоугольник таблицы.
    InvalidateRow -        Перерисовать строку.
    InvalidateRows -       Перерисовать строки с указанной по указанную.
    IsActiveControl -      Является ли таблица текущим активным компонентом
                           формы.
    IsCellAcceptCursor -   Можно ли установить курсор в ячейку.
    IsCellHasCheck -       Проверка на наличие флажка у ячейки.
    IsCellHasImage -       Проверка на наличие картинки у ячейки.
    IsCellFocused -        Проверка на попадание ячейки в фокус, а при
                           построчном выделении (RowSelect = True) - в
                           выделенную строку.
    IsCellReadOnly -       Можно или нет менять текст в строке ввода
                           указанной ячейки. 
    IsCellValid -          Проверка корректности ячейки (ненулевая ширина,
                           видимость, выход за границы столбцов и строк).
    IsCellVisible -        Проверка видимости ячеки на экране.
    IsColumnVisible -      Проверка видимости колонки ни экране.
    IsFocusAllowed -       Признак видимости фокуса. Фокус виден, если
                           разрешено выделение строки или запрещено
                           редактирвоание. В противном случае на месте
                           фокуса находится строка ввода.
    IsHeaderHasImage -     Проверка на наличие картинки у секции заголовка.
    IsHeaderPressed -      Проверка на нажатие на секцию заголовка. Возвращает
                           True, если сейчас идет нажатие на указанную
                           секцию заголовка.
    IsRowVisible -         Проверка видимости строки.
    LockUpdate -           Заблокировать перерисовку.
    MakeCellVisible -      Сдулать видимой указанную ячейку.
    UndoEdit -             Выполение операции Undo для встроенной строки
                           ввода. Вызывается при нажатии клавиши ESC в
                           случае, если строка ввода не убирается (т.е.
                           при AlwaysEdit = True).
    UnLockUpdate -         Разблокировать перерисовку.
    UpdateCursor -         Обновление положения курсора. Если курсор
                           находится на ячейке за пределами таблицы или там,
                           где фокус не разрешен - ищется первая попавшаяся
                           ячейка.
    UpdateColors -         Обновление цветов заголовка и фиксированных при
                           изменении цвета таблицы.
    UpdateEdit -           Обновление положения, текста строки ввода и ее
                           видимости в соотвествии с положением курсора.
    UpdateEditContents -   Обновление внешнего вида и текста видимой строки
                           ввода. Данный метод следует использовать в случае,
                           когда в ходе редактирования происходит обновление
                           данных таблицы, параметров колонок и т.п. и
                           требуется соотвественно обновить строку ввода.
    UpdateEditText -       Обновление данных таблицы из строки ввода.
    UpdateFixed -          Обновление параметров фиксированных (например,
                           количества в зависимости от количества колонок
                           таблицы).
    UpdateFocus -          Установить фокус на талицу, если это возможно.
    UpdateFonts -          Обновление шрифтов заголовка и фиксированных при
                           изменении шрифта таблицы.
    UpdateHeader -         Обновление заголовка (приведение в соотвествии с
                           колонками, если стоит флаг AutoSynchronize или
                           Synchronized).
    UpdateRows -           Обновление параметров строк (например, высоты
                           строки в зависимости от размера картинок и
                           размера шрифта таблицы).
    UpdateScrollBars -     Обновление настроек полос прокрутки (максимум,
                           большой шаг, малый шаг).
                           ПРИМЕЧАНИЕ: Вертикальный скроллер настраивается
                           на число строк, горизонтальный - на ширину
                           нефиксированных колонок.
    UpdateScrollPos -      Установка положения движков полос прокрутки в
                           соответствии с текущей выделенной ячейкой.
    UpdateSelection -      Провека возможности выделения указанной ячейки.
                           Если ячейка не может быть выделена, то ищется
                           ближайшая доступная для выделения.
    UpdateText -           То же самое, что и UpdateEditText.
    UpdateVisOriginSize -  Обновление настроек видимой области ячеек по
                           положению движков полос прокрутки.

    Свойства:

    AllowEdit -            Может ли быть видима строка редактирования. 
                           ПРИМЕЧАНИЕ: Хотя строка моджет быть видима, можно
                           или нет редактировать текст ячейки определяется
                           значением свойств ReadOnly колонки и всей таблицы.
    AllowSelect -          Разрешено ли выделение ячеек (строк) цветом (т.е.
                           наличие фокуса на текущей ячейке).
    AlwaysSelected -       Всегда показывать фокус выделенным.
    BorderStyle -          Вордюр таблицы.
    CellFocused -          Текущее положение курсора.
    Cells -                Доступ к содержимому ячейки.
    CellSelected -         Признак выделенности курсора.
    CheckBoxes -           Отображение флажков ячеек.
    CheckHeight -          Высота картинок флажков. Всегда равна 16 пикселам,
                           не подлежит изменению.
    CheckLeftIndent -      Смещение флажка ячейки от левого края. Влияет на
                           отрисовку флажка ячейки. Не следует без особой
                           необходимости менять это значение (а также
                           значение CheckTopIndent).
    CheckStyle -           Стиль флажков ячеек. Может принимать следующие
                           значения:
                             csFlat -  Плоские флажки.
                             cs3D -    Выпуклые флажки.
                             csWin95 - Флажки в стиле Windows 95.
    CheckTopIndent -       Смещение флажка от верхнего края ячейки.
    CheckWidth -           Ширина картинок флажков. Всегда равна 16 пикселам,
                           не подлежит изменению.
    Col -                  Текущая колонка ячейки фокуса. Равно CellFocused.Col.
    ColumnClick -          Можно или нет нажимать заголовок колонки.
    Columns -              Список колонок таблицы.
    ColumnsFullDrag -      Синхронно изменять ширину колонки при
                           перетаскивании за границу заголовка.
    CursorKeys -           Клавиши перемещения курсора по ячейкам. Может быть
                           комбинацей из следующих значений:
                             gkArrows -     Навигация по ячейкам стрелками.
                             gkTabs -       Навигация по ячейкам с помошью.
                                            клавиш TAB и SHIFT-TAB
                             gkReturn -     Переход на следующую ячейку после
                                            ввода текста в строку ввода
                                            нажатием клавиши Return.
                             gkMouse -      Выделение ячейки мышкой.
                             gkMouseMove -  Синхронное выделение ячейки при
                                            перемещении мышки с нажатой
                                            кнопкой.
                             gkMouseWheel - Навигация по ячейкам с помощью
                                            колесика мышки.
    DefaultEditMenu -      Показывать стандартное Popup меню (по правой
                           кнопке мыши) для строки ввода. Если свойство
                           выставлено в False, то для строки будет показано
                           меню таблицы.
    Edit -                 Строка редактирования.
    EditCell -             Ячейка редактирования.
    EditColumn -           Колонка, в которой находится ячейка редактирования.
    EditDropDown -         Управление видимостью выпадающего списка. При
                           установлении значения в True переводит ячейку в
                           режим редактирования и показывает список (если
                           это возможно).  
    Editing -              Признак редактирование ячейки. Позволяет начать
                           или завершить процесс редактирования ячейки.
                           ПРИМЕЧАНИЕ: При Editing := True ставит фокус на
                           строку таблицу.
    EndEllipsis -          Выводить или нет непомещающийся в ячейке текст с
                           ... (многоточием) на конце. Работает только для
                           однострочного текста с выравниваем влево. Сильно
                           влияет на скорость отрисовки.
    Fixed -                Параметры фиксированных колонок.
    FlatBorder -           Отображать "плоский" бордюр (как Bevel). 
    FlatScrollBars -       Отображать плоские скроллеры (только дял
                           comctrl32.dll версии 4.71 и выше).
    FocusOnScroll -        Забирать на себя фокус или нет при скроллировании
                           таблицы. Если FocusOnScroll = False, то
                           скроллирование мышкой за ползунок не приведет к
                           фокусированию таблицы. Если сделать FocusOnScroll
                           = True, то при установки активной ячейки со
                           скроллировнием извне (например, при управлении
                           другим компонентом), произойдет фокусировка
                           таблицы.
    GridColor -            Цвет линий сетки.
    GridLines -            Рисовать или нет линии сетки.
    GridStyle -            Стиль сетки. Может быть комбинацей из следующих
                           значений:
                             gsHorzLine -     Рисовать горизонтальные линии.
                             gsVertLine -     Рисовать вертикальные линии.
                             gsFullHorzLine - Горизонтальные линии до правого
                                              края таблицы, а не до последней
                                              колонки.
                             gsFullVertLine - Вертикальные линии до нижнего
                                              края таблицы, а не до последней
                                              строки (если Rows.Copunt > 0).
                             gsListViewLike - Рисовать горизонтальные линии
                                              на всю таблицу независимо от
                                              того, сколько строк в таблице.
                             gsDotLines -     Рисовать линии сетки точечками
                                              (красиво, но долго).
    Header -               Заголовок.
    HideSelection -        Гасить или нет курсор при пропадании фокуса.
    ImageLeftIndent -      Смещение картинки ячейки от левого края.
                           Используется для настройки отрисовки картинки
                           ячейки. Не следует без особой необходимости
                           менять это значение (а также ImageTopIndent).
    Images -               Список картинок.
    ImageIndexDef -        Номер картинки по умолчанию. Эта картинка будет
                           назначена первой видимой колонке.
    ImageHighlight -       Подсвечивать или нет картику для выделенной
                           ячейки.
    ImageTopIndent -       Смещение картинки ячейки от верхнего края.
    LeftCol -              Левая видимая (м.б. частично видимая) колонка таблицы.
                           Равно VisOrigin.Col.
    RightClickSelect -     Допускается или нет выделение ячейки правой
                           клавишей мышки.
    Row -                  Текущая строка ячейки фокуса. Равно CellFocused.Row.
    Rows -                 Параметры строк ячейки.
    RowSelect -            Выделение по целой строке или по ячейке.
    ShowCellTips -         Показывать или нет Hint с текстом ячейки, если
                           текст не помещается целиком в ячейку (для Delphi
                           версии 3 и выше).
                           ВНИМАНИЕ: Hint ячейки основан на стандартном
                           Hint-е, для отображения подсказок необходимо
                           установить ShowHint в True. Если ShowCellTips
                           установлено, то обычный Hint - отображаться не
                           будет (т.е. либо Hint, либо CellTips).
    ShowFocusRect -        Показывать рамку фокуса.
    ShowHeader -           Показываеть заголовок.

    SortLeftIndent -       Смещение картинки направления сортировки от
                           правого края текста. Используется для настройки
                           вывода картинки направления сортировки. Не следует
                           без особой необходимости менять это значение (а
                           также значение SortTopIndent).
    SortTopIndent -        Смещение картинки направления сортировки
                           относительно верхнего каря текста по вертикали.
    TextLeftIndent -       Смещение текста ячейки от левого края, в случае,
                           когда у ячейки нет картинки. Используется для
                           настройки вывода текста ячейки. Не следует без
                           особой необходимости менять это значение (а также
                           TextRightIndent и TextTopIndent).
    TextRightIndent -      Отсут текста ячейки от правого края.
    TextTopIndent -        Смещение текста ячейки сверху.
    TipsCell -             Ячейка, для которой показываетсся подсказка.
    TipsText -             Строк подсказки для ячейки TipsCell.
    TopRow -               Верхняя видимая строка таблицы. Равно VesOrigin.Row.
    VertScrollBar -        Вертикальный скроллер.
    VisibleColCount -      Количество видимых колонок. Равно VisSize.Col.
    VisibleRowCount -      Количество видимых строк. Равно VisSize.Row.
    VisOrigin -            Первая видимая ячейка.
    VisSize -              Количество видимых ячеек.

    События:

    OnCellAcceptCursor -   Можно ли устанавливать курсор на указанную ячейку.
    OnCellClick -          Щелчок мышкой на ячейке.
    OnCellTips -           Надо ли показывать подсказку по указанной ячейке.
    OnChange -             Cменилась выделенная ячейка. Вызывается сразу
                           после изменении ячеейки курсора.
    OnChangeColumns -      Произошло изменение колонок таблицы.
    OnChangeEditing -      Произошло изменение видимости строки ввода.
    OnChangeEditMode -     Произошло изменение режима редактирования.
    OnChangeFixed -        Произошло изменение фиксированных колонок таблицы.
    OnChangeRows -         Произошло изменение строк таблицы.
    OnChanging -           Меняется выделенная ячейка. Вызывается
                           непосредственно перед изменением ячейки курсора.
    OnCheckClick -         Щелчок мышкой на флажке ячейки.
    OnColumnAutoSize -     Ширина колонки меняется на ширину, подобранную
                           автоматически.
    OnColumnResize -       Ширина колонки изменилась.
    OnColumnResizing -     Изменяется ширина колонки.
    OnDraw -               Отрисовка таблицы.
    OnDrawCell -           Отрисовка ячейки. Если необходимо изменить
                           цвета ячейки, но оставить стандартную отрисовку,
                           следует переопределение цветов выполнить в
                           событии OnGetCellColors.
    OnDrawHeader -         Отрисовка секции ячейки. Если необходимо изменить
                           цвета секции, но оставить стандартную отрисовку,
                           следует переопределение цветов выполнить в
                           событии OnGetHeaderColors.
    OnEditAcceptKey -      Проверка приемлимости символа ячейки.
    OnEditButtonPress -    Нажата кнопка с многоточием у строки ввола.
    OnEditCanceled -       Ввода текста отменен, строка редактирования
                           погашена в результате нажатия клавиши Escape.
    OnEditCanModify -      Может ли изменяться текст в строке ввода.
    OnEditChange -         Изменился текст в строке ввода.
    OnEditCloseUp -        Произошло закрытие выпадающего списка с выбором
                           значения.
    OnEditSelectNext -     Нажат Ctrl+Enter на кнопке с нераскрытым списком
                           (по идее следует в ячейку вставить следующее
                           значение из списка).
    OnGetCellColors -      Определеить цвета ячейки. Событие влияет на
                           отрисовку ячейки, вид CellTips и пр.
    OnGetCellImage -       Вернуть номер картинки ячейки.
    OnGetCellImageIndent - Получить смещение картинки ячейки.
    OnGetCellReadOnly -    Получить флаг "Только для чтения" для указанной
                           ячейки.
    OnGetCellText -        Получить текст ячейки.
    OnGetCellTextIndent -  Получить смещение текста ячейки.
    OnGetCheckAlignment -  Получить выравнивание флажка ячейки.
    OnGetCheckImage -      Получить картинку флажка ячейки.
    OnGetCheckIndent -     Получить смещение картинки флажка.
    OnGetCheckKind -       Получить тип флажка ячейки.
    OnGetCheckState -      Получить состояние флажка ячейки.
    OnGetEditList -        Заполнить выпадающий список строки редактирования.
    OnGetEditListBounds -  Подправить положение и размеры выпадающего списка
                           строки редактирования.
    OnGetEditMask -        Вернуть маску ячейки для редактирования. 
    OnGetEditStyle -       Определить стиль строки редактирования.
    OnGetEditText -        Вернуть текст ячейки для редактирования. По
                           умолчанию берется текст ячейки.
    OnGetHeaderColors -    Определеить цвета секции заголовка.
    OnGetHeaderImage -     Определеть номер картинки секции заголовка.
    OnGetSortDirection -   Определить направление сортировки для указанной
                           колонки. Вызывается непосредственно при отрисовке
                           секции заголовка для определения значка сортировки. 
    OnGetSortImage -       Вернуть картинку сортировки для указанной колонки.
    OnHeaderClick -        Нажата секция заголовка.
    OnHeaderClicking -     Нажимается секция заголовка. Вызывается
                           непосредственно перед началом нажатия при
                           Header.Flat = False.
    OnResize -             Изменение размера таблицы.
    OnSetEditText -        Установить текст ячейки. Вызывается при
                           перемещении курсора. Если текст не принимается,
                           следует вызвать исключение.
  }

  TGridStyle = (gsHorzLine, gsVertLine, gsFullHorzLine, gsFullVertLine,
    gsListViewLike, gsDotLines);
  TGridStyles = set of TGridStyle;

  TGridCursorKey = (gkArrows, gkTabs, gkReturn, gkMouse, gkMouseMove, gkMouseWheel);
  TGridCursorKeys = set of TGridCursorKey;

  TGridCursorOffset = (goLeft, goRight, goUp, goDown, goPageUp, goPageDown,
    goHome, goEnd, goGridHome, goGridEnd, goSelect, goFirst, goNext, goPrev);

  TGridSortDirection = (gsNone, gsAscending, gsDescending);

  TGridTextEvent = procedure(Sender: TObject; Cell: TGridCell; var Value: string) of object;
  TGridRectEvent = procedure(Sender: TObject; Cell: TGridCell; var Rect: TRect) of object;
  TGridCellColorsEvent = procedure(Sender: TObject; Cell: TGridCell; Canvas: TCanvas) of object;
  TGridCellImageEvent = procedure(Sender: TObject; Cell: TGridCell; var ImageIndex: Integer) of object;
  TGridCellClickEvent = procedure(Sender: TObject; Cell: TGridCell; Shift: TShiftState; X, Y: Integer) of object;
  TGridCellAcceptCursorEvent = procedure(Sender: TObject; Cell: TGridCell; var Accept: Boolean) of object;
  TGridCellNotifyEvent = procedure(Sender: TObject; Cell: TGridCell) of object;
  TGridCellIndentEvent = procedure(Sender: TObject; Cell: TGridCell; var Indent: TPoint) of object;
  TGridCellTipsEvent = procedure(Sender: TObject; Cell: TGridCell; var AllowTips: Boolean) of object;
  TGridCellreadOnlyEvent = procedure(Sender: TObject; Cell: TGridCell; var CellReadOnly: Boolean) of object;
  TGridHeaderColorsEvent = procedure(Sender: TObject; Section: TGridHeaderSection; Canvas: TCanvas) of object;
  TGridHeaderImageEvent = procedure(Sender: TObject; Section: TGridHeaderSection; var ImageIndex: Integer) of object;
  TGridDrawEvent = procedure(Sender: TObject; var DefaultDrawing: Boolean) of object;
  TGridDrawCellEvent = procedure(Sender: TObject; Cell: TGridCell; var Rect: TRect; var DefaultDrawing: Boolean) of object;
  TGridDrawHeaderEvent = procedure(Sender: TObject; Section: TGridHeaderSection; Rect: TRect; var DefaultDrawing: Boolean) of object;
  TGridColumnResizeEvent = procedure(Sender: TObject; Column: Integer; var Width: Integer) of object;
  TGridHeaderClickEvent = procedure(Sender: TObject; Section: TGridHeaderSection) of object;
  TGridHeaderClickingEvent = procedure(Sender: TObject; Section: TGridHeaderSection; var AllowClick: Boolean) of object;
  TGridChangingEvent = procedure(Sender: TObject; var Cell: TGridCell; var Selected: Boolean) of object;
  TGridChangedEvent = procedure(Sender: TObject; Cell: TGridCell; Selected: Boolean) of object;
  TGridEditStyleEvent = procedure(Sender: TObject; Cell: TGridCell; var Style: TGridEditStyle) of object;
  TGridEditListEvent = procedure(Sender: TObject; Cell: TGridCell; Items: TStrings) of object;
  TGridEditCloseUpEvent = procedure(Sender: TObject; Cell: TGridCell; ItemIndex: Integer; var Accept: Boolean) of object;
  TGridEditCanModifyEvent = procedure(Sender: TObject; Cell: TGridCell; var CanModify: Boolean) of object;
  TGridAcceptKeyEvent = procedure(Sender: TObject; Cell: TGridCell; Key: Char; var Accept: Boolean) of object;
  TGridCheckKindEvent = procedure(Sender: TObject; Cell: TGridCell; var CheckKind: TGridCheckKind) of object;
  TGridCheckStateEvent = procedure(Sender: TObject; Cell: TGridCell; var CheckState: TCheckBoxState) of object;
  TGridCheckImageEvent = procedure(Sender: TObject; Cell: TGridCell; CheckImage: TBitmap) of object;
  TGridCheckAlignmentEvent = procedure(Sender: TObject; Cell: TGridCell; var CheckAlignment: TAlignment) of object;
  TGridSortDirectionEvent = procedure(Sender: TObject; Section: TGridHeaderSection; var SortDirection: TGridSortDirection) of object;
  TGridSortImageEvent = procedure(Sender: TObject; Section: TGridHeaderSection; SortImage: TBitmap) of object;

  TCustomGridView = class(TCustomControl)
  private
    FHorzScrollBar: TGridScrollBar;
    FVertScrollBar: TGridScrollBar;
    FFlatScrollBars: Boolean;
    FHeader: TCustomGridHeader;
    FColumns: TGridColumns;
    FRows: TCustomGridRows;
    FFixed: TCustomGridFixed;
    FImages: TImageList;
    FImagesLink: TChangeLink;
    FImageLeftIndent: Integer;
    FImageTopIndent: Integer;
    FImageHighlight: Boolean;
    FImageIndexDef: Integer;
    FCellFocused: TGridCell;
    FCellSelected: Boolean;
    FVisOrigin: TGridCell;
    FVisSize: TGridCell;
    FBorderStyle: TBorderStyle;
    FFlatBorder: Boolean;
    FHideSelection: Boolean;
    FShowHeader: Boolean;
    FGridLines: Boolean;
    FGridLineWidth: Integer;
    FGridStyle: TGridStyles;
    FGridColor: TColor;
    FEndEllipsis: Boolean;
    FShowFocusRect: Boolean;
    FAlwaysSelected: Boolean;
    FRowSelect: Boolean;
    FRightClickSelect: Boolean;
    FAllowSelect: Boolean;
    FFocusOnScroll: Boolean;
    FCursorKeys: TGridCursorKeys;

    FHitTest: TPoint;
    FClickPos: TGridCell;
    FColumnsSizing: Boolean;
    FColumnsFullDrag: Boolean;
    FColumnClick: Boolean;
    FColResizing: Boolean;
    FColResizeSection: TGridHeaderSection;
    FColResizeIndex: Integer;
    FColResizeOffset: Integer;
    FColResizeRect: TRect;
    FColResizePos: Integer;
    FColResizeMinWidth: Integer;
    FColResizeMaxWidth: Integer;
    FColResizeCount: Integer;
    FHeaderClickSection: TGridHeaderSection;
    FHeaderClickRect: TRect;
    FHeaderClickState: Boolean;
    FHeaderClicking: Boolean;
    FUpdateLock: Integer;
    FAllowEdit: Boolean;
    FAlwaysEdit: Boolean;
    FReadOnly: Boolean;
    FEdit: TCustomGridEdit;
    FEditCell: TGridCell;
    FEditing: Boolean;
    FShowCellTips: Boolean;
    FTipsCell: TGridCell;
    FTipsText: string;
    FCheckBoxes: Boolean;
    FCheckStyle: TGridCheckStyle;
    FCheckWidth: Integer;
    FCheckHeight: Integer;
    FCheckLeftIndent: Integer;
    FCheckTopIndent: Integer;
    FCheckBitmapCB: TBitmap;
    FCheckBitmapRB: TBitmap;
    FCheckBuffer: TBitmap;
    FSortLeftIndent: Integer;
    FSortTopIndent: Integer;
    FSortBitmapA: TBitmap;
    FSortBitmapD: TBitmap;
    FSortBuffer: TBitmap;
    FDoubleBuffered: Boolean;
    FPatternBitmap: TBitmap;
    FCancelOnExit: Boolean;
    FDefaultEditMenu: Boolean;
    FOnGetCellText: TGridTextEvent;
    FOnGetCellTextIndent: TGridCellIndentEvent;
    FOnGetCellColors: TGridCellColorsEvent;
    FOnGetCellImage: TGridCellImageEvent;
    FOnGetCellImageIndent: TGridCellIndentEvent;
    FOnGetCellReadOnly: TGridCellreadOnlyEvent;
    FOnGetHeaderColors: TGridHeaderColorsEvent;
    FOnGetHeaderImage: TGridHeaderImageEvent;
    FOnDraw: TGridDrawEvent;
    FOnDrawCell: TGridDrawCellEvent;
    FOnDrawHeader: TGridDrawHeaderEvent;
    FOnColumnAutoSize: TGridColumnResizeEvent;
    FOnColumnResizing: TGridColumnResizeEvent;
    FOnColumnResize: TGridColumnResizeEvent;
    FOnHeaderClick: TGridHeaderClickEvent;
    FOnHeaderClicking: TGridHeaderClickingEvent;
    FOnChangeColumns: TNotifyEvent;
    FOnChangeRows: TNotifyEvent;
    FOnChangeFixed: TNotifyEvent;
    FOnCellAcceptCursor: TGridCellAcceptCursorEvent;
    FOnChanging: TGridChangingEvent;
    FOnChange: TGridChangedEvent;
    FOnCellClick: TGridCellClickEvent;
    FOnGetEditStyle: TGridEditStyleEvent;
    FOnGetEditMask: TGridTextEvent;
    FOnGetEditText: TGridTextEvent;
    FOnSetEditText: TGridTextEvent;
    FOnGetEditList: TGridEditListEvent;
    FOnGetEditListBounds: TGridRectEvent;
    FOnEditCanModify: TGridEditCanModifyEvent;
    FOnEditAcceptKey: TGridAcceptKeyEvent;
    FOnEditButtonPress: TGridCellNotifyEvent;
    FOnEditSelectNext: TGridTextEvent;
    FOnEditCloseUp: TGridEditCloseUpEvent;
    FOnEditChange: TGridCellNotifyEvent;
    FOnEditCanceled: TGridCellNotifyEvent;
    FOnGetCheckKind: TGridCheckKindEvent;
    FOnGetCheckState: TGridCheckStateEvent;
    FOnGetCheckImage: TGridCheckImageEvent;
    FOnGetCheckAlignment: TGridCheckAlignmentEvent;
    FOnGetCheckIndent: TGridCellIndentEvent;
    FOnCheckClick: TGridCellNotifyEvent;
    FOnGetSortDirection: TGridSortDirectionEvent;
    FOnGetSortImage: TGridSortImageEvent;
    FOnChangeEditing: TNotifyEvent;
    FOnChangeEditMode: TNotifyEvent;
{$IFNDEF EX_D4_UP}
    FOnResize: TNotifyEvent;
{$ENDIF}
    FOnGetCellHintRect: TGridRectEvent;
    FOnCellTips: TGridCellTipsEvent;
    FOnGetTipsRect: TGridRectEvent;
    FOnGetTipsText: TGridTextEvent;
    function GetCell(Col, Row: Longint): string;
    function GetChecked(Col, Row: Longint): Boolean;
    function GetCol: Longint;
    function GetFixed: TGridFixed;
    function GetEdit: TGridEdit;
    function GetEditColumn: TGridColumn;
    function GetEditDropDown: Boolean;
    function GetEditing: Boolean;
    function GetHeader: TGridHeader;
    function GetLeftCol: Longint;
    function GetRow: Longint;
    function GetRows: TGridRows;
    function GetTopRow: Longint;
    function GetVisibleColCount: Longint;
    function GetVisibleRowCount: Longint;
    procedure ColumnsChange(Sender: TObject);
    procedure FixedChange(Sender: TObject);
    procedure HeaderChange(Sender: TObject);
    procedure HorzScroll(Sender: TObject; ScrollCode: Integer; var ScrollPos: Integer);
    procedure HorzScrollChange(Sender: TObject);
    procedure ImagesChange(Sender: TObject);
    procedure RowsChange(Sender: TObject);
    procedure SetAllowEdit(Value: Boolean);
    procedure SetAllowSelect(Value: Boolean);
    procedure SetAlwaysEdit(Value: Boolean);
    procedure SetAlwaysSelected(Value: Boolean);
    procedure SetBorderStyle(Value: TBorderStyle);
    procedure SetCell(Col, Row: Longint; Value: string);
    procedure SetCellFocused(Value: TGridCell);
    procedure SetCellSelected(Value: Boolean);
    procedure SetCheckBoxes(Value: Boolean);
    procedure SetCheckLeftIndent(Value: Integer);
    procedure SetCheckStyle(Value: TGridCheckStyle);
    procedure SetCheckTopIndent(Value: Integer);
    procedure SetCol(Value: Longint);
    procedure SetColumns(Value: TGridColumns);
    procedure SetCursorKeys(Value: TGridCursorKeys);
    procedure SetEditDropDown(Value: Boolean);
    procedure SetEditing(Value: Boolean);
    procedure SetEndEllipsis(Value: Boolean);
    procedure SetFlatBorder(Value: Boolean);
    procedure SetFlatScrollBars(Value: Boolean);
    procedure SetFixed(Value: TGridFixed);
    procedure SetGridColor(Value: TColor);
    procedure SetGridLines(Value: Boolean);
    procedure SetGridStyle(Value: TGridStyles);
    procedure SetHeader(Value: TGridHeader);
    procedure SetHideSelection(Value: Boolean);
    procedure SetHorzScrollBar(Value: TGridScrollBar);
    procedure SetImageIndexDef(Value: Integer);
    procedure SetImageHighlight(Value: Boolean);
    procedure SetImageLeftIndent(Value: Integer);
    procedure SetImages(Value: TImageList);
    procedure SetImageTopIndent(Value: Integer);
    procedure SetLeftCol(Value: Longint);
    procedure SetReadOnly(Value: Boolean);
    procedure SetRow(Value: Longint);
    procedure SetRows(Value: TGridRows);
    procedure SetRowSelect(Value: Boolean);
    procedure SetShowCellTips(Value: Boolean);
    procedure SetShowFocusRect(Value: Boolean);
    procedure SetShowHeader(Value: Boolean);
    procedure SetSortLeftIndent(Value: Integer);
    procedure SetSortTopIndent(Value: Integer);
    procedure SetTextLeftIndent(Value: Integer);
    procedure SetTextRightIndent(Value: Integer);
    procedure SetTextTopIndent(Value: Integer);
    procedure SetTopRow(Value: Longint);
    procedure SetVertScrollBar(Value: TGridScrollBar);
    procedure SetVisOrigin(Value: TGridCell);
    procedure VertScroll(Sender: TObject; ScrollCode: Integer; var ScrollPos: Integer);
    procedure VertScrollChange(Sender: TObject);
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure WMKillFocus(var Message: TWMKillFocus); message WM_KILLFOCUS;
    procedure WMSetFocus(var Message: TWMSetFocus); message WM_SETFOCUS;
    procedure WMLButtonDown(var Message: TMessage); message WM_LBUTTONDOWN;
    procedure WMChar(var Msg: TWMChar); message WM_CHAR;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure WMHScroll(var Message: TWMHScroll); message WM_HSCROLL;
    procedure WMVScroll(var Message: TWMVScroll); message WM_VSCROLL;
    procedure WMNCHitTest(var Message: TWMNCHitTest); message WM_NCHITTEST;
    procedure WMSetCursor(var Message: TWMSetCursor); message WM_SETCURSOR;
    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure CMCancelMode(var Message: TCMCancelMode); message CM_CANCELMODE;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure CMCtl3DChanged(var Message: TMessage); message CM_CTL3DCHANGED;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure CMColorChanged(var Message: TMessage); message CM_COLORCHANGED;
    procedure CMShowHintChanged(var Message: TMessage); message CM_SHOWHINTCHANGED;
    procedure CMHintShow(var Message: TMessage); message CM_HINTSHOW;
  protected
    function AcquireFocus: Boolean;
    procedure CellClick(Cell: TGridCell; Shift: TShiftState; X, Y: Integer); virtual;
    procedure CellTips(Cell: TGridCell; var AllowTips: Boolean); virtual;
    procedure Change(var Cell: TGridCell; var Selected: Boolean); virtual;
    procedure ChangeColumns; virtual;
    procedure ChangeEditing; virtual;
    procedure ChangeEditMode; virtual;
    procedure ChangeFixed; virtual;
    procedure ChangeRows; virtual;
    procedure ChangeScale(M, D: Integer); override;
    procedure Changing(var Cell: TGridCell; var Selected: Boolean); virtual;
    procedure CheckClick(Cell: TGridCell); virtual;
    procedure ColumnAutoSize(Column: Integer; var Width: Integer); virtual;
    procedure ColumnResize(Column: Integer; var Width: Integer); virtual;
    procedure ColumnResizing(Column: Integer; var Width: Integer); virtual;
    function CreateColumn(Columns: TGridColumns): TCustomGridColumn; virtual;
    function CreateColumns: TGridColumns; virtual;
    function CreateEdit(EditClass: TGridEditClass): TCustomGridEdit; virtual;
    function CreateFixed: TCustomGridFixed; virtual;
    function CreateHeader: TCustomGridHeader; virtual;
    function CreateHeaderSection(Sections: TGridHeaderSections): TGridHeaderSection; virtual;
    procedure CreateParams(var Params: TCreateParams); override;
    function CreateRows: TCustomGridRows; virtual;
    function CreateScrollBar(Kind: TScrollBarKind): TGridScrollBar; virtual;
    procedure CreateWnd; override;
    procedure DoExit; override;
{$IFDEF EX_D4_UP}
    function DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint): Boolean; override;
    function DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): Boolean; override;
{$ENDIF}
    procedure EditButtonPress(Cell: TGridCell); virtual;
    function EditCanAcceptKey(Cell: TGridCell; Key: Char): Boolean; virtual;
    procedure EditCanceled(Cell: TGridCell); virtual;
    function EditCanModify(Cell: TGridCell): Boolean; virtual;
    function EditCanShow(Cell: TGridCell): Boolean; virtual;
    function EditCanUndo(Cell: TGridCell): Boolean; virtual;
    procedure EditChange(Cell: TGridCell); virtual;
    procedure EditCloseUp(Cell: TGridCell; ItemIndex: Integer; var Accept: Boolean); virtual;
    procedure EditSelectNext(Cell: TGridCell; var Value: string); virtual;
    procedure GetCellColors(Cell: TGridCell; Canvas: TCanvas); virtual;
    function GetCellImage(Cell: TGridCell): Integer; virtual;
    function GetCellImageIndent(Cell: TGridCell): TPoint; virtual;
    function GetCellImageRect(Cell: TGridCell): TRect; virtual;
    function GetCellHintRect(Cell: TGridCell): TRect; virtual;
    function GetCellText(Cell: TGridCell): string; virtual;
    function GetCellTextBounds(Cell: TGridCell): TRect; virtual;
    function GetCellTextIndent(Cell: TGridCell): TPoint; virtual;
    function GetCheckAlignment(Cell: TGridCell): TAlignment; virtual;
    procedure GetCheckImage(Cell: TGridCell; CheckImage: TBitmap); virtual;
    function GetCheckIndent(Cell: TGridCell): TPoint; virtual;
    function GetCheckKind(Cell: TGridCell): TGridCheckKind; virtual;
    function GetCheckRect(Cell: TGridCell): TRect; virtual;
    function GetCheckState(Cell: TGridCell): TCheckBoxState; virtual;
    function GetClientOrigin: TPoint; override;
    function GetClientRect: TRect; override;
    function GetColumnClass: TGridColumnClass; virtual;
    function GetCursorCell(Cell: TGridCell; Offset: TGridCursorOffset): TGridCell; virtual;
    function GetEditClass(Cell: TGridCell): TGridEditClass; virtual;
    procedure GetEditList(Cell: TGridCell; Items: TStrings); virtual;
    procedure GetEditListBounds(Cell: TGridCell; var Rect: TRect); virtual;
    function GetEditMask(Cell: TGridCell): string; virtual;
    function GetEditStyle(Cell: TGridCell): TGridEditStyle; virtual;
    function GetEditText(Cell: TGridCell): string; virtual;
    function GetGridLineColor(BkColor: TColor): TColor; virtual;
    function GetHeaderImage(Section: TGridHeaderSection): Integer; virtual;
    procedure GetHeaderColors(Section: TGridHeaderSection; Canvas: TCanvas); virtual;
    function GetSortDirection(Section: TGridHeaderSection): TGridSortDirection; virtual;
    procedure GetSortImage(Section: TGridHeaderSection; SortImage: TBitmap); virtual;
    function GetTextRect(Canvas: TCanvas; Rect: TRect; LeftIndent, TopIndent: Integer; Alignment: TAlignment; WantReturns, WordWrap: Boolean; const Text: string): TRect; virtual;
    function GetTipsRect(Cell: TGridCell): TRect; virtual;
    function GetTipsText(Cell: TGridCell): string; virtual;
    function GetTipsWindowClass: TGridTipsWindowClass; virtual;
    procedure HeaderClick(Section: TGridHeaderSection); virtual;
    procedure HeaderClicking(Section: TGridHeaderSection; var AllowClick: Boolean); virtual;
    procedure HideCursor; virtual;
    procedure HideEdit; virtual;
    procedure HideFocus; virtual;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure Loaded; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Paint; override;
    procedure Paint3DFrame(Rect: TRect; SideFlags: Longint); virtual;
    procedure PaintCell(Cell: TGridCell; Rect: TRect); virtual;
    procedure PaintCells; virtual;
    procedure PaintDotGridLines(Points: Pointer; Count: Integer);
    procedure PaintFixed; virtual;
    procedure PaintFixedGrid; virtual;
    procedure PaintFreeField; virtual;
    procedure PaintFocus; virtual;
    procedure PaintGridLines; virtual;
    procedure PaintHeader(Section: TGridHeaderSection; Rect: TRect); virtual;
    procedure PaintHeaders(DrawFixed: Boolean); virtual;
    procedure PaintHeaderSections(Sections: TGridHeaderSections; AllowFixed: Boolean); virtual;
    procedure PaintResizeLine;
    procedure PaintText(Canvas: TCanvas; Rect: TRect; LeftIndent, TopIndent: Integer; Alignment: TAlignment; WantReturns, WordWrap: Boolean; const Text: string); virtual;
    procedure PreparePatternBitmap(Canvas: TCanvas; FillColor: TColor; Remove: Boolean); virtual;
    procedure ResetClickPos; virtual;
    procedure Resize; {$IFDEF EX_D4_UP} override; {$ELSE} dynamic; {$ENDIF}
    procedure SetEditText(Cell: TGridCell; var Value: string); virtual;
    procedure ShowCursor; virtual;
    procedure ShowEdit; virtual;
    procedure ShowEditChar(C: Char); virtual;
    procedure ShowFocus; virtual;
    procedure StartColResize(Section: TGridHeaderSection; X, Y: Integer);
    procedure StartHeaderClick(Section: TGridHeaderSection; X, Y: Integer);
    procedure StepColResize(X, Y: Integer);
    procedure StepHeaderClick(X, Y: Integer);
    procedure StopColResize(Abort: Boolean);
    procedure StopHeaderClick(Abort: Boolean);
  public
     FTextLeftIndent: Integer;
    FTextRightIndent: Integer;
    FTextTopIndent: Integer;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ApplyEdit; virtual;
    procedure CancelEdit; virtual;
    procedure DefaultDrawCell(Cell: TGridCell; Rect: TRect); virtual;
    procedure DefaultDrawHeader(Section: TGridHeaderSection; Rect: TRect); virtual;
    procedure DrawDragRect(Cell: TGridCell); virtual;
    function FindText(const SearchStr: string; StartCell: TGridCell; Options: TFindOptions; var ResultCell: TGridCell): boolean; virtual;
    function GetCellAt(X, Y: Integer): TGridCell; virtual;
    function GetCellRect(Cell: TGridCell): TRect;
    function GetCellsRect(Cell1, Cell2: TGridCell): TRect;
    function GetColumnAt(X, Y: Integer): Integer; virtual;
    function GetColumnLeftRight(Column: Integer): TRect;
    function GetColumnMaxWidth(Column: Integer): Integer;
    function GetColumnRect(Column: Integer): TRect;
    function GetColumnsRect(Column1, Column2: Integer): TRect;
    function GetColumnsWidth(Column1, Column2: Integer): Integer;
    function GetEditRect(Cell: TGridCell): TRect; virtual;
    function GetFirstImageColumn: Integer;
    function GetFixedRect: TRect; virtual;
    function GetFixedWidth: Integer;
    function GetFocusRect: TRect; virtual;
    function GetGridHeight: Integer;
    function GetGridOrigin: TPoint;
    function GetGridRect: TRect; virtual;
    function GetHeaderHeight: Integer;
    function GetHeaderRect: TRect; virtual;
    function GetHeaderSection(ColumnIndex, Level: Integer): TGridHeaderSection;
    function GetResizeSectionAt(X, Y: Integer): TGridHeaderSection;
    function GetRowAt(X, Y: Integer): Integer; virtual;
    function GetRowRect(Row: Integer): TRect;
    function GetRowsRect(Row1, Row2: Integer): TRect;
    function GetRowsHeight(Row1, Row2: Integer): Integer;
    function GetRowTopBottom(Row: Integer): TRect;
    function GetSectionAt(X, Y: Integer): TGridHeaderSection;
    procedure Invalidate; override;
    procedure InvalidateCell(Cell: TGridCell);
    procedure InvalidateCheck(Cell: TGridCell);
    procedure InvalidateColumn(Column: Integer);
    procedure InvalidateColumns(Column1, Column2: Integer);
    procedure InvalidateEdit;
    procedure InvalidateFixed;
    procedure InvalidateFocus; virtual;
    procedure InvalidateGrid;
    procedure InvalidateHeader;
    procedure InvalidateRect(Rect: TRect);
    procedure InvalidateRow(Row: Integer);
    procedure InvalidateRows(Row1, Row2: Integer);
    function IsActiveControl: Boolean;
    function IsCellAcceptCursor(Cell: TGridCell): Boolean; virtual;
    function IsCellHasCheck(Cell: TGridCell): Boolean; virtual;
    function IsCellHasImage(Cell: TGridCell): Boolean; virtual;
    function IsCellFocused(Cell: TGridCell): Boolean;
    function IsCellReadOnly(Cell: TGridCell): Boolean; virtual;
    function IsCellValid(Cell: TGridCell): Boolean;
    function IsCellValidEx(Cell: TGridCell; CheckPosition, CheckVisible: Boolean): Boolean;
    function IsCellVisible(Cell: TGridCell; PartialOK: Boolean): Boolean;
    function IsColumnVisible(Column: Integer): Boolean;
    function IsFocusAllowed: Boolean;
    function IsHeaderHasImage(Section: TGridHeaderSection): Boolean; virtual;
    function IsHeaderPressed(Section: TGridHeaderSection): Boolean; virtual;
    function IsRowVisible(Row: Integer): Boolean;
    procedure LockUpdate;
    procedure MakeCellVisible(Cell: TGridCell; PartialOK: Boolean); virtual;
    procedure SetCursor(Cell: TGridCell; Selected, Visible: Boolean); virtual;
    procedure UndoEdit; virtual;
    procedure UnLockUpdate(Redraw: Boolean);
    procedure UpdateCursor; virtual;
    procedure UpdateColors; virtual;
    procedure UpdateEdit(Activate: Boolean); virtual;
    procedure UpdateEditContents(SaveText: Boolean); virtual;
    procedure UpdateEditText; virtual;
    procedure UpdateFixed; virtual;
    procedure UpdateFocus; virtual;
    procedure UpdateFonts; virtual;
    procedure UpdateHeader; virtual;
    procedure UpdateRows; virtual;
    procedure UpdateScrollBars; virtual;
    procedure UpdateScrollPos; virtual;
    procedure UpdateSelection(var Cell: TGridCell; var Selected: Boolean); virtual;
    procedure UpdateText; virtual;
    procedure UpdateVisOriginSize; virtual;
    property AllowEdit: Boolean read FAllowEdit write SetAllowEdit default False;
    property AllowSelect: Boolean read FAllowSelect write SetAllowSelect default True;
    property AlwaysEdit: Boolean read FAlwaysEdit write SetAlwaysEdit default False;
    property AlwaysSelected: Boolean read FAlwaysSelected write SetAlwaysSelected default False;
    property BorderStyle: TBorderStyle read FBorderStyle write SetBorderStyle default bsSingle;
    property CancelOnExit: Boolean read FCancelOnExit write FCancelOnExit default True;
    property Canvas;
    property Cells[Col, Row: Longint]: string read GetCell write SetCell;
    property CellFocused: TGridCell read FCellFocused write SetCellFocused;
    property CellSelected: Boolean read FCellSelected write SetCellSelected;
    property CheckBoxes: Boolean read FCheckBoxes write SetCheckBoxes default False;
    property Checked[Col, Row: Longint]: Boolean read GetChecked;
    property CheckHeight: Integer read FCheckHeight;
    property CheckLeftIndent: Integer read FCheckLeftIndent write SetCheckLeftIndent default 0;
    property CheckStyle: TGridCheckStyle read FCheckStyle write SetCheckStyle default csWin95;
    property CheckTopIndent: Integer read FCheckTopIndent write SetCheckTopIndent default 0;
    property CheckWidth: Integer read FCheckWidth;
    property Col: Longint read GetCol write SetCol;
    property ColResizing: Boolean read FColResizing;
    property ColumnClick: Boolean read FColumnClick write FColumnClick default True;
    property Columns: TGridColumns read FColumns write SetColumns;
    property ColumnsFullDrag: Boolean read FColumnsFullDrag write FColumnsFullDrag default False;
    property ColumnsSizing: Boolean read FColumnsSizing write FColumnsSizing default True;
    property CursorKeys: TGridCursorKeys read FCursorKeys write SetCursorKeys default [gkArrows, gkMouse];
    property DefaultEditMenu: Boolean read FDefaultEditMenu write FDefaultEditMenu default False;
    property DoubleBuffered: Boolean read FDoubleBuffered write FDoubleBuffered default False;
    property Edit: TGridEdit read GetEdit;
    property EditCell: TGridCell read FEditCell;
    property EditColumn: TGridColumn read GetEditColumn;
    property EditDropDown: Boolean read GetEditDropDown write SetEditDropDown;
    property Editing: Boolean read GetEditing write SetEditing;
    property EndEllipsis: Boolean read FEndEllipsis write SetEndEllipsis default True;
    property GridColor: TColor read FGridColor write SetGridColor default clSilver;
    property GridLines: Boolean read FGridLines write SetGridLines default True;
    property GridLineWidth: Integer read FGridLineWidth;
    property GridStyle: TGridStyles read FGridStyle write SetGridStyle default [gsHorzLine, gsVertLine];
    property Fixed: TGridFixed read GetFixed write SetFixed;
    property FlatBorder: Boolean read FFlatBorder write SetFlatBorder default False;
    property FlatScrollBars: Boolean read FFlatScrollBars write SetFlatScrollBars default False;
    property FocusOnScroll: Boolean read FFocusOnScroll write FFocusOnScroll default False;
    property Header: TGridHeader read GetHeader write SetHeader;
    property HideSelection: Boolean read FHideSelection write SetHideSelection default False;
    property HorzScrollBar: TGridScrollBar read FHorzScrollBar write SetHorzScrollBar;
    property ImageIndexDef: Integer read FImageIndexDef write SetImageIndexDef default 0;
    property ImageHighlight: Boolean read FImageHighlight write SetImageHighlight default True;
    property ImageLeftIndent: Integer read FImageLeftIndent write SetImageLeftIndent default 2;
    property Images: TImageList read FImages write SetImages;
    property ImageTopIndent: Integer read FImageTopIndent write SetImageTopIndent default 1;
    property LeftCol: Longint read GetLeftCol write SetLeftCol;
    property ReadOnly: Boolean read FReadOnly write SetReadOnly default False;
    property RightClickSelect: Boolean read FRightClickSelect write FRightClickSelect default True;
    property Row: Longint read GetRow write SetRow;
    property Rows: TGridRows read GetRows write SetRows;
    property RowSelect: Boolean read FRowSelect write SetRowSelect default False;
    property ShowCellTips: Boolean read FShowCellTips write SetShowCellTips;
    property ShowFocusRect: Boolean read FShowFocusRect write SetShowFocusRect default True;
    property ShowHeader: Boolean read FShowHeader write SetShowHeader default True;
    property SortLeftIndent: Integer read FSortLeftIndent write SetSortLeftIndent default 10;
    property SortTopIndent: Integer read FSortTopIndent write SetSortTopIndent default 0;
    property TextLeftIndent: Integer read FTextLeftIndent write SetTextLeftIndent default 6;
    property TextRightIndent: Integer read FTextRightIndent write SetTextRightIndent default 6;
    property TextTopIndent: Integer read FTextTopIndent write SetTextTopIndent default 2;
    property TipsCell: TGridCell read FTipsCell;
    property TipsText: string read FTipsText;
    property TopRow: Longint read GetTopRow write SetTopRow;
    property UpdateLock: Integer read FUpdateLock;
    property VertScrollBar: TGridScrollBar read FVertScrollBar write SetVertScrollBar;
    property VisibleColCount: Longint read GetVisibleColCount;
    property VisibleRowCount: Longint read GetVisibleRowCount;
    property VisOrigin: TGridCell read FVisOrigin write SetVisOrigin;
    property VisSize: TGridCell read FVisSize;
    property OnCellAcceptCursor: TGridCellAcceptCursorEvent read FOnCellAcceptCursor write FOnCellAcceptCursor;
    property OnCellClick: TGridCellClickEvent read FOnCellClick write FOnCellClick;
    property OnCellTips: TGridCellTipsEvent read FOnCellTips write FOnCellTips;
    property OnChange: TGridChangedEvent read FOnChange write FOnChange;
    property OnChangeColumns: TNotifyEvent read FOnChangeColumns write FOnChangeColumns;
    property OnChangeEditing: TNotifyEvent read FOnChangeEditing write FOnChangeEditing;
    property OnChangeEditMode: TNotifyEvent read FOnChangeEditMode write FOnChangeEditMode;
    property OnChangeFixed: TNotifyEvent read FOnChangeFixed write FOnChangeFixed;
    property OnChangeRows: TNotifyEvent read FOnChangeRows write FOnChangeRows;
    property OnChanging: TGridChangingEvent read FOnChanging write FOnChanging;
    property OnCheckClick: TGridCellNotifyEvent read FOnCheckClick write FOnCheckClick;
    property OnColumnAutoSize: TGridColumnResizeEvent read FOnColumnAutoSize write FOnColumnAutoSize;
    property OnColumnResizing: TGridColumnResizeEvent read FOnColumnResizing write FOnColumnResizing;
    property OnColumnResize: TGridColumnResizeEvent read FOnColumnResize write FOnColumnResize;
    property OnDraw: TGridDrawEvent read FOnDraw write FOnDraw;
    property OnDrawCell: TGridDrawCellEvent read FOnDrawCell write FOnDrawCell;
    property OnDrawHeader: TGridDrawHeaderEvent read FOnDrawHeader write FOnDrawHeader;
    property OnEditAcceptKey: TGridAcceptKeyEvent read FOnEditAcceptKey write FOnEditAcceptKey;
    property OnEditButtonPress: TGridCellNotifyEvent read FOnEditButtonPress write FOnEditButtonPress;
    property OnEditCanceled: TGridCellNotifyEvent read FOnEditCanceled write FOnEditCanceled;
    property OnEditCanModify: TGridEditCanModifyEvent read FOnEditCanModify write FOnEditCanModify;
    property OnEditChange: TGridCellNotifyEvent read FOnEditChange write FOnEditChange;
    property OnEditCloseUp: TGridEditCloseUpEvent read FOnEditCloseUp write FOnEditCloseUp;
    property OnEditSelectNext: TGridTextEvent read FOnEditSelectNext write FOnEditSelectNext;
    property OnGetCellColors: TGridCellColorsEvent read FOnGetCellColors write FOnGetCellColors;
    property OnGetCellImage: TGridCellImageEvent read FOnGetCellImage write FOnGetCellImage;
    property OnGetCellImageIndent: TGridCellIndentEvent read FOnGetCellImageIndent write FOnGetCellImageIndent;
    property OnGetCellHintRect: TGridRectEvent read FOnGetCellHintRect write FOnGetCellHintRect;
    property OnGetCellReadOnly: TGridCellreadOnlyEvent read FOnGetCellReadOnly write FOnGetCellReadOnly;
    property OnGetCellText: TGridTextEvent read FOnGetCellText write FOnGetCellText;
    property OnGetCellTextIndent: TGridCellIndentEvent read FOnGetCellTextIndent write FOnGetCellTextIndent;
    property OnGetCheckAlignment: TGridCheckAlignmentEvent read FOnGetCheckAlignment write FOnGetCheckAlignment;
    property OnGetCheckImage: TGridCheckImageEvent read FOnGetCheckImage write FOnGetCheckImage;
    property OnGetCheckIndent: TGridCellIndentEvent read FOnGetCheckIndent write FOnGetCheckIndent;
    property OnGetCheckKind: TGridCheckKindEvent read FOnGetCheckKind write FOnGetCheckKind;
    property OnGetCheckState: TGridCheckStateEvent read FOnGetCheckState write FOnGetCheckState;
    property OnGetEditList: TGridEditListEvent read FOnGetEditList write FOnGetEditList;
    property OnGetEditListBounds: TGridRectEvent read FOnGetEditListBounds write FOnGetEditListBounds;
    property OnGetEditMask: TGridTextEvent read FOnGetEditMask write FOnGetEditMask;
    property OnGetEditStyle: TGridEditStyleEvent read FOnGetEditStyle write FOnGetEditStyle;
    property OnGetEditText: TGridTextEvent read FOnGetEditText write FOnGetEditText;
    property OnGetHeaderColors: TGridHeaderColorsEvent read FOnGetHeaderColors write FOnGetHeaderColors;
    property OnGetHeaderImage: TGridHeaderImageEvent read FOnGetHeaderImage write FOnGetHeaderImage;
    property OnGetSortDirection: TGridSortDirectionEvent read FOnGetSortDirection write FOnGetSortDirection;
    property OnGetSortImage: TGridSortImageEvent read FOnGetSortImage write FOnGetSortImage;
    property OnGetTipsRect: TGridRectEvent read FOnGetTipsRect write FOnGetTipsRect;
    property OnGetTipsText: TGridTextEvent read FOnGetTipsText write FOnGetTipsText;
    property OnHeaderClick: TGridHeaderClickEvent read FOnHeaderClick write FOnHeaderClick;
    property OnHeaderClicking: TGridHeaderClickingEvent read FOnHeaderClicking write FOnHeaderClicking;
{$IFNDEF EX_D4_UP}
    property OnResize: TNotifyEvent read FOnResize write FOnResize;
{$ENDIF}
    property OnSetEditText: TGridTextEvent read FOnSetEditText write FOnSetEditText;
  end;

{ TGridView }

  TGridView = class(TCustomGridView)
  published
    property Align;
    property AllowEdit;
    property AllowSelect;
    property AlwaysEdit;
    property AlwaysSelected;
{$IFDEF EX_D4_UP}
    property Anchors;
{$ENDIF}
    property BorderStyle;
    property CancelOnExit;
    property CheckBoxes;
    property CheckStyle;
    property Color;
    property ColumnClick;
    property Columns;
    property ColumnsFullDrag;
{$IFDEF EX_D4_UP}
    property Constraints;
{$ENDIF}
    property Ctl3D;
    property CursorKeys;
    property DefaultEditMenu;
    property DragCursor;
    property DragMode;
    property DoubleBuffered;
    property Enabled;
    property EndEllipsis;
    property Fixed;
    property FlatBorder;
    property FlatScrollBars;
    property FocusOnScroll;
    property Font;
    property GridColor;
    property GridLines;
    property GridStyle;
    property Header;
    property HideSelection;
    property Hint;
    property HorzScrollBar;
    property ImageIndexDef;
    property ImageHighlight;
    property Images;
    property ParentColor default False;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ReadOnly;
    property RightClickSelect;
    property Rows;
    property RowSelect;
    property ShowCellTips;
    property ShowFocusRect;
    property ShowHeader;
    property ShowHint;
    property TabOrder;
    property TabStop default True;
    property VertScrollBar;
    property Visible;
    property OnCellAcceptCursor;
    property OnCellClick;
    property OnCellTips;
    property OnChange;
    property OnChangeColumns;
    property OnChangeEditing;
    property OnChangeEditMode;
    property OnChangeFixed;
    property OnChangeRows;
    property OnChanging;
    property OnCheckClick;
    property OnClick;
    property OnColumnAutoSize;
    property OnColumnResizing;
    property OnColumnResize;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnDraw;
    property OnDrawCell;
    property OnDrawHeader;
    property OnEditAcceptKey;
    property OnEditButtonPress;
    property OnEditCanceled;
    property OnEditCanModify;
    property OnEditChange;
    property OnEditCloseUp;
    property OnEditSelectNext;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGetCellColors;
    property OnGetCellImage;
    property OnGetCellImageIndent;
    property OnGetCellHintRect;
    property OnGetCellReadOnly;
    property OnGetCellText;
    property OnGetCellTextIndent;
    property OnGetCheckAlignment;
    property OnGetCheckImage;
    property OnGetCheckIndent;
    property OnGetCheckKind;
    property OnGetCheckState;
    property OnGetEditList;
    property OnGetEditListBounds;
    property OnGetEditMask;
    property OnGetEditStyle;
    property OnGetEditText;
    property OnGetHeaderColors;
    property OnGetHeaderImage;
    property OnGetSortDirection;
    property OnGetSortImage;
    property OnGetTipsRect;
    property OnGetTipsText;
    property OnHeaderClick;
    property OnHeaderClicking;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
{$IFDEF EX_D4_UP}
    property OnMouseWheelDown;
    property OnMouseWheelUp; 
{$ENDIF}
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnResize;
    property OnSetEditText;
    property OnStartDrag;
  end;

{ Несколько утилит для работы с ячейками }

function GridCell(Col, Row: Longint): TGridCell;

function IsCellEqual(Cell1, Cell2: TGridCell): Boolean;
function IsCellEmpty(Cell: TGridCell): Boolean;

function OffsetCell(Cell: TGridCell; C, R: Longint): TGridCell;

{ Т.к. у стандартного строллера Windows есть ограничение на максимальную
  позицию (32768, может не быть под WinNT), а в таблице записей может быть
  больше, то для установки параметров скроллера их следует масштабировать }

const
  MaxWinPos = 10000;

function WinPosToScrollPos(WinPos, ScrollMin, ScrollMax: Integer): Integer;
function ScrollPosToWinPos(ScrollPos, ScrollMin, ScrollMax: Integer): Integer;

{$IFNDEF EX_D5_UP}

{ Flat Scrollbar APIs }

function FlatSB_SetScrollInfo(hWnd: HWND; BarFlag: Integer; const ScrollInfo: TScrollInfo; Redraw: BOOL): Integer; stdcall;

function InitializeFlatSB(hWnd: HWND): Bool; stdcall;
procedure UninitializeFlatSB(hWnd: HWND); stdcall;

{$ENDIF}

implementation

uses
  ExtSystem, ExtSysUtils, ExtGraphics, ExtStrUtils;
  
{$R *.RES}

{ Утилитки }

function GridCell(Col, Row: Longint): TGridCell;
begin
  Result.Col := Col;
  Result.Row := Row;
end;

function IsCellEqual(Cell1, Cell2: TGridCell): Boolean;
begin
  Result := (Cell1.Col = Cell2.Col) and (Cell1.Row = Cell2.Row);
end;

function IsCellEmpty(Cell: TGridCell): Boolean;
begin
  Result := (Cell.Col = -1) or (Cell.Row = -1);
end;

function OffsetCell(Cell: TGridCell; C, R: Longint): TGridCell;
begin
  Result.Col := Cell.Col + C;
  Result.Row := Cell.Row + R;
end;

{ Масштабирование параметров скроллера }

function WinPosToScrollPos(WinPos, ScrollMin, ScrollMax: Integer): Integer;
begin
  Result := ScrollMin + MulDiv(WinPos, ScrollMax - ScrollMin, MaxWinPos);
end;

function ScrollPosToWinPos(ScrollPos, ScrollMin, ScrollMax: Integer): Integer;
begin
  if ScrollMax <> ScrollMin then
  begin
    Result := MulDiv(ScrollPos - ScrollMin, MaxWinPos, ScrollMax - ScrollMin);
    Exit;
  end;
  Result := 0;
end;

{$IFNDEF EX_D5_UP}

const
  cctrl = 'comctl32.dll';

function FlatSB_SetScrollInfo; external cctrl name 'FlatSB_SetScrollInfo';

function InitializeFlatSB;     external cctrl name 'InitializeFlatSB';
procedure UninitializeFlatSB;  external cctrl name 'UninitializeFlatSB';

{$ENDIF}

{ TGridHeaderSection }

constructor TGridHeaderSection.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FWidth := 64;
end;

destructor TGridHeaderSection.Destroy;
begin
  inherited Destroy;
  FreeAndNil(FSections);
end;

function TGridHeaderSection.IsSectionsStored: Boolean;
begin
  Result := (FSections <> nil) and (FSections.Count > 0);
end;

function TGridHeaderSection.IsWidthStored: Boolean;
begin
  Result := ((FSections = nil) or (FSections.Count = 0)) and (Width <> 64);
end;

function TGridHeaderSection.GetAllowClick: Boolean;
var
  I: Integer;
begin
  Result := False;
  { можно ли щелкать на колонке }
  if (Header <> nil) and (Header.Grid <> nil) then
  begin
    I := ColumnIndex;
    if I < Header.Grid.Columns.Count then
      Result := Header.Grid.Columns[I].AllowClick;
  end;
end;

function TGridHeaderSection.GetBoundsRect: TRect;
begin
  { нет заголовка - нет размеров }
  if (Header = nil) or (Header.Grid = nil) then
  begin
    Result := Rect(0, 0, 0, 0);
    Exit;
  end;
  { абсолютные границы }
  Result := FBoundsRect;
  { если это не фиксированный заголовок - смещаем его на величину сдвига
    таблицы скроллером }
  if not FixedColumn then OffsetRect(Result, Header.Grid.GetGridOrigin.X, 0);
end;

function TGridHeaderSection.GetFirstColumnIndex: Integer;
begin
  if Sections.Count > 0 then
  begin
    Result := Sections[0].FirstColumnIndex;
    Exit;
  end;
  Result := ColumnIndex;
end;

function TGridHeaderSection.GetFixedColumn: Boolean;
begin
  if Sections.Count > 0 then
  begin
    Result := Sections[0].FixedColumn;
    Exit;
  end;
  if (Header = nil) or (Header.Grid = nil) then
  begin
    Result := False;
    Exit;
  end;
  Result := ColumnIndex < Header.Grid.Fixed.Count;
end;

function TGridHeaderSection.GetHeader: TCustomGridHeader;
begin
  if ParentSections <> nil then
  begin
    Result := ParentSections.Header;
    Exit;
  end;
  Result := nil;
end;

function TGridHeaderSection.GetLevel: Integer;
begin
  if Parent <> nil then
  begin
    Result := Parent.Level + 1;
    Exit;
  end;
  Result := 0
end;

function TGridHeaderSection.GetParent: TGridHeaderSection;
begin
  if ParentSections <> nil then
  begin
    Result := ParentSections.Owner;
    Exit;
  end;
  Result := nil;
end;

function TGridHeaderSection.GetParentSections: TGridHeaderSections;
begin
  if Collection <> nil then
  begin
    Result := TGridHeaderSections(Collection);
    Exit;
  end;
  Result := nil;
end;

function TGridHeaderSection.GetSections: TGridHeaderSections;
begin
  if FSections = nil then FSections := TGridHeaderSections.Create(Header, Self);
  Result := FSections;
end;

function TGridHeaderSection.GetResizeColumnIndex: Integer;
var
  I: Integer;
begin
  { если есть подзаголовки возвращаем колонку последнего из них }
  for I := Sections.Count - 1 downto 0 do
    if Sections[I].Visible then
    begin
      Result := Sections[I].ResizeColumnIndex;
      Exit;
    end;
  { возвращаем расчитанный индекс колонки }
  Result := FColumnIndex;
end;

function TGridHeaderSection.GetVisible: Boolean;
var
  I: Integer;
begin
  { если есть подзаголовки, то смотрим видимость их }
  if Sections.Count > 0 then
    for I := 0 to Sections.Count - 1 do
      if Sections[I].Visible then
      begin
        Result := True;
        Exit;
      end;
  { иначе смотрим видимость колонки }
  if (Header <> nil) and (Header.Grid <> nil) then
  begin
    I := ColumnIndex;
    if I < Header.Grid.Columns.Count then
    begin
      Result := Header.Grid.Columns[I].Visible;
      Exit;
    end;
  end;
  { нет колонки - секция видна }
  Result := True;
end;

function TGridHeaderSection.GetWidth: Integer;
var
  I: Integer;
  S: TGridHeaderSection;
begin
  { если есть подзаголовки, то ширина есть сумма ширин подзаголовков }
  if Sections.Count > 0 then
  begin
    Result := 0;
    for I := 0 to Sections.Count - 1 do
    begin
      S := Sections[I];
      Result := Result + S.Width;
    end;
    Exit;
  end;
  { иначе возвращаем ширину соответствующей колонки }
  if (Header <> nil) and (Header.Grid <> nil) then
  begin
    I := ColumnIndex;
    if I < Header.Grid.Columns.Count then
    begin
      Result := Header.Grid.Columns[I].Width;
      Exit;
    end;
  end;
  { нет колонки - своя ширина }
  Result := FWidth;
end;

procedure TGridHeaderSection.SetAlignment(Value: TAlignment);
begin
  if Alignment <> Value then
  begin
    FAlignment := Value;
    Changed(False);
  end;
end;

procedure TGridHeaderSection.SetCaption(const Value: string);
begin
  if FCaption <> Value then
  begin
    FCaption := Value;
    Changed(False);
  end;
end;

procedure TGridHeaderSection.SetSections(Value: TGridHeaderSections);
begin
  Sections.Assign(Value);
end;

procedure TGridHeaderSection.SetWidth(Value: Integer);
begin
  if (Value >= 0) and (Width <> Value) then
  begin
    if (Header <> nil) and (Header.Grid <> nil) then
      if ColumnIndex > Header.Grid.Columns.Count - 1 then
        if Sections.Count > 0 then
        begin
          with Sections[Sections.Count - 1] do SetWidth(Width + (Value - Self.Width));
          Exit;
        end;
    FWidth := Value;
    Changed(False);
  end;
end;

procedure TGridHeaderSection.SetWordWrap(Value: Boolean);
begin
  if FWordWrap <> Value then
  begin
    FWordWrap := Value;
    Changed(False);
  end;
end;

procedure TGridHeaderSection.Assign(Source: TPersistent);
begin
  if Source is TGridHeaderSection then
  begin
    Sections := TGridHeaderSection(Source).Sections;
    Caption := TGridHeaderSection(Source).Caption;
    Width := TGridHeaderSection(Source).Width;
    Alignment := TGridHeaderSection(Source).Alignment;
    WordWrap := TGridHeaderSection(Source).WordWrap;
    Exit;
  end;
  inherited Assign(Source);
end;

{ TGridHeaderSections }

constructor TGridHeaderSections.Create(AHeader: TCustomGridHeader; AOwner: TGridHeaderSection);
begin
  inherited Create(TGridHeaderSection);
  FHeader := AHeader;
  FOwner := AOwner;
end;

function TGridHeaderSections.GetMaxColumn: Integer;
begin
  if Count > 0 then
  begin
    Result := Sections[Count - 1].ColumnIndex;
    Exit;
  end;
  Result := 0;
end;

function TGridHeaderSections.GetMaxLevel: Integer;

  procedure DoGetMaxLevel(Sections: TGridHeaderSections);
  var
    I: Integer;
    S: TGridHeaderSection;
  begin
    for I := 0 to Sections.Count - 1 do
    begin
      S := Sections[I];
      if Result < S.Level then Result := S.Level;
      DoGetMaxLevel(S.Sections);
    end;
  end;

begin
  Result := 0;
  DoGetMaxLevel(Self);
end;

function TGridHeaderSections.GetSection(Index: Integer): TGridHeaderSection;
begin
  Result := TGridHeaderSection(inherited GetItem(Index));
end;

procedure TGridHeaderSections.SetSection(Index: Integer; Value: TGridHeaderSection);
begin
  inherited SetItem(Index, Value);
end;

function TGridHeaderSections.GetOwner: TPersistent;
begin
  Result := Header;
end;

procedure TGridHeaderSections.Update(Item: TCollectionItem);
begin
  if Header <> nil then Header.Change;
end;

function TGridHeaderSections.Add: TGridHeaderSection;
begin
  if (Header = nil) or (Header.Grid = nil) then
  begin
    Result := TGridHeaderSection(inherited Add);
    Exit;
  end;
  Result := Header.Grid.CreateHeaderSection(Self);
end;

{ TCustomGridHeader }

constructor TCustomGridHeader.Create(AGrid: TCustomGridView);
begin
  inherited Create;
  FGrid := AGrid;
  FColor := clBtnFace;
  FSections := TGridHeaderSections.Create(Self, nil);
  FSectionHeight := 17;
  FSynchronized := True;
  FAutoSynchronize := True;
  FColor := clBtnFace;
  FFont := TFont.Create;
  FFont.OnChange := FontChange;
  FGridFont := True;
  FImagesLink := TChangeLink.Create;
  FImagesLink.OnChange := ImagesChange;
  FFLat := True;
end;

destructor TCustomGridHeader.Destroy;
begin
  FOnChange := nil;
  FreeAndNil(FImagesLink);
  inherited Destroy;
  FreeAndNil(FSections);
  FreeAndNil(FFont);
end;

function TCustomGridHeader.IsColorStored: Boolean;
begin
  Result := not GridColor;
end;

function TCustomGridHeader.IsFontStored: Boolean;
begin
  Result := not GridFont;
end;

function TCustomGridHeader.IsSectionsStored: Boolean;
begin
  Result := not ((GetMaxLevel = 0) and FullSynchronizing and Synchronized);
end;

procedure TCustomGridHeader.ImagesChange(Sender: TObject);
begin
  Change;
end;

procedure TCustomGridHeader.FontChange(Sender: TObject);
begin
  FGridFont := False;
  { подправляем высоту, изменения }
  SetSectionHeight(SectionHeight);
  Change;
end;

function TCustomGridHeader.GetHeight: Integer;
begin
  Result := (GetMaxLevel + 1) * SectionHeight;
end;

function TCustomGridHeader.GetMaxColumn: Integer;
begin
  Result := Sections.MaxColumn;
end;

function TCustomGridHeader.GetMaxLevel: Integer;
begin
  Result := Sections.MaxLevel;
end;

function TCustomGridHeader.GetWidth: Integer;
var
  I: Integer;
  S: TGridHeaderSection;
begin
  Result := 0;
  for I := 0 to Sections.Count - 1 do
  begin
    S := Sections[I];
    Result := Result + S.Width;
  end;
end;

procedure TCustomGridHeader.SetAutoHeight(Value: Boolean);
begin
  if FAutoHeight <> Value then
  begin
    FAutoHeight := Value;
    if Value then SetSectionHeight(SectionHeight);
  end;
end;

procedure TCustomGridHeader.SetAutoSynchronize(Value: Boolean);
begin
  if FAutoSynchronize <> Value then
  begin
    FAutoSynchronize := Value;
    if Value then Synchronized := True;
  end;
end;

procedure TCustomGridHeader.SetColor(Value: TColor);
begin
  if FColor <> Value then
  begin
    FColor := Value;
    FGridColor := False;
    Change;
  end;
end;

procedure TCustomGridHeader.SetImages(Value: TImageList);
begin
  if FImages <> Value then
  begin
    if Assigned(FImages) then FImages.UnRegisterChanges(FImagesLink);
    FImages := Value;
    if Assigned(FImages) then
    begin
      FImages.RegisterChanges(FImagesLink);
      if Grid <> nil then FImages.FreeNotification(Grid);
    end;
    { подправляем высоту, изменения }
    SetSectionHeight(SectionHeight);
    Change;
  end;
end;

procedure TCustomGridHeader.SetFlat(Value: Boolean);
begin
  if FFlat <> Value then
  begin
    FFlat := Value;
    { подправляем 3D эффект фиксированных }
    if Value and (Grid <> nil) then Grid.Fixed.Flat := True;
    { подправляем высоту, изменения }
    SetSectionHeight(SectionHeight);
    Change;
  end;
end;

procedure TCustomGridHeader.SetFont(Value: TFont);
begin
  FFont.Assign(Value);
end;

procedure TCustomGridHeader.SetFullSynchronizing(Value: Boolean);
begin
  if FFullSynchronizing <> Value then
  begin
    FFullSynchronizing := Value;
    if Value then Synchronized := False;
  end;
end;

procedure TCustomGridHeader.SetGridColor(Value: Boolean);
begin
  if FGridColor <> Value then
  begin
    FGridColor := Value;
    if Grid <> nil then GridColorChanged(Grid.Color);
    { подправляем высоту, изменения }
    SetSectionHeight(SectionHeight);
    Change;
  end;
end;

procedure TCustomGridHeader.SetGridFont(Value: Boolean);
begin
  if FGridFont <> Value then
  begin
    FGridFont := Value;
    if Grid <> nil then GridFontChanged(Grid.Font);
    Change;
  end;
end;

procedure TCustomGridHeader.SetSections(Value: TGridHeaderSections);
begin
  { устанавливаем заголовок }
  FSections.Assign(Value);
  { сбрасываем флаг синхронизации }
  SetSynchronized(False);
end;

procedure TCustomGridHeader.SetSectionHeight(Value: Integer);
var
  TH, IH: Integer;
begin
  { проверяем автоподбор }
  if AutoHeight then
  begin
    { высота текста }
    TH := GetFontHeight(Font) + 2 * 2;
    { высота картинки }
    IH := 0;
    if Images <> nil then
    begin
      IH := Images.Height + 2{+ 1};
      if not GridColor then Inc(IH, 1);
      if not Flat then Inc(IH, 1);
    end;
    { высота текста }
    Value := MaxIntValue([0, TH, IH]);
  end;
  { высота секций не может быть нулевой }
  if Value < 0 then Value := 0;
  { устанавливаем }
  if FSectionHeight <> Value then
  begin
    FSectionHeight := Value;
    Change;
  end;
end;

procedure TCustomGridHeader.SetSynchronized(Value: Boolean);
begin
  if FSynchronized <> Value then
  begin
    FSynchronized := Value;
    if (Value or FAutoSynchronize) and (Grid <> nil) then
    begin
      FSynchronized := True;
      SynchronizeSections;
    end;
  end;
end;

procedure TCustomGridHeader.Change;
begin
  { обновляем секции заголовка }
  UpdateSections;
  { событие }
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TCustomGridHeader.GridColorChanged(NewColor: TColor);
begin
  if FGridColor then
  begin
    SetColor(NewColor);
    FGridColor := True;
  end;
end;

procedure TCustomGridHeader.GridFontChanged(NewFont: Tfont);
begin
  if FGridFont then
  begin
    SetFont(NewFont);
    FGridFont := True;
  end;
end;

procedure TCustomGridHeader.Assign(Source: TPersistent);
begin
  if Source is TCustomGridHeader then
  begin
    Sections := TCustomGridHeader(Source).Sections;
    SectionHeight := TCustomGridHeader(Source).SectionHeight;
    Synchronized := TCustomGridHeader(Source).Synchronized;
    AutoSynchronize := TCustomGridHeader(Source).AutoSynchronize;
    Color := TCustomGridHeader(Source).Color;
    GridColor := TCustomGridHeader(Source).GridColor;
    Font := TCustomGridHeader(Source).Font;
    GridFont := TCustomGridHeader(Source).GridFont;
    Exit;
  end;
  inherited Assign(Source);
end;

procedure TCustomGridHeader.SynchronizeSections;
var
  C: Integer;

  procedure DoAddSections(Column: Integer; SynchronizeCaption: Boolean);
  var
    R: TRect;
  begin
    { абсолютные границы заголовка }
    R.Left := Grid.GetColumnRect(Column).Left;
    R.Right := R.Left;
    R.Top := Grid.ClientRect.Top;
    R.Bottom := R.Top + Height;
    { добавляем }
    while Column < Grid.Columns.Count do
    begin
      { прямиоугольник секции }
      R.Left := R.Right;
      R.Right := R.Left + Grid.Columns[Column].Width;
      { добавляем секцию }
      with Sections.Add do
      begin
        FColumnIndex := Column;
        FBoundsRect := R;
        Width := Grid.Columns[Column].Width;
        if SynchronizeCaption then
        begin
          Caption := Grid.Columns[Column].Caption;
          Alignment := Grid.Columns[Column].Alignment
        end;
      end;
      { следующия колонка }
      Inc(Column);
    end;
  end;

  procedure DoDeleteSections(Sections: TGridHeaderSections);
  var
    I: Integer;
    S: TGridHeaderSection;
  begin
    for I := Sections.Count - 1 downto 0 do
    begin
      S := Sections[I];
      DoDeleteSections(S.Sections);
      if (S.Sections.Count = 0) and (S.ColumnIndex > Grid.Columns.Count - 1) then S.Free;
    end;
  end;

  procedure DoSynchronizeSections(Sections: TGridHeaderSections);
  var
    I: Integer;
    S: TGridHeaderSection;
  begin
    for I := Sections.Count - 1 downto 0 do
    begin
      S := Sections[I];
      if S.Sections.Count = 0 then
      begin
        C := S.ColumnIndex;
        S.Width := Grid.Columns[C].Width;
        if FullSynchronizing then
        begin
          S.Caption := Grid.Columns[C].Caption;
          S.Alignment := Grid.Columns[C].Alignment;
        end;
      end
      else
        DoSynchronizeSections(S.Sections);
    end;
  end;

begin
  { перед синхронизацией необходимо обновить внутренние параметры секций }
  UpdateSections;
  { синхронизируем секции }
  if (Grid <> nil) and (Grid.ComponentState * [csReading, csLoading] = [])
    and (Grid.Columns <> nil) then
  begin
    Sections.BeginUpdate;
    try
      { заголовок пуст - добавляем все колонки }
      if Sections.Count = 0 then
      begin
        DoAddSections(0, True);
        Exit;
      end;
      { если секций меньше - добавляем, иначе удаляем лишние }
      C := Sections[Sections.Count - 1].ColumnIndex;
      if C < Grid.Columns.Count - 1 then
        DoAddSections(C + 1, False)
      else if C > Grid.Columns.Count - 1 then
        DoDeleteSections(Sections);
      { у нижних секций синхронизируем заголовок, выравнивание и шинрину }
      DoSynchronizeSections(Sections);
    finally
      Sections.EndUpdate;
    end;
  end;
end;

procedure TCustomGridHeader.UpdateSections;
var
  R: TRect;
  C: Integer;

  procedure DoUpdateColumnIndex(Sections: TGridHeaderSections);
  var
    I: Integer;
    S: TGridHeaderSection;
  begin
    for I := 0 to Sections.Count - 1 do
    begin
      S := Sections[I];
      { есть ли подзаголовки }
      if S.Sections.Count = 0 then
      begin
        { это нижняя секция }
        S.FColumnIndex := C;
        Inc(C);
      end
      else
      begin
        { рекурсия на все подзаголовки снизу }
        DoUpdateColumnIndex(S.Sections);
        { индекс есть индекс последнего }
        S.FColumnIndex := S.Sections[S.Sections.Count - 1].FColumnIndex;
      end;
    end;
  end;

  procedure DoUpdateSecionsBounds(Sections: TGridHeaderSections; Rect: TRect);
  var
    I: Integer;
    S: TGridHeaderSection;
    R, SR: TRect;
  begin
    R := Rect;
    R.Right := R.Left;
    { перебираем подзаголовки }
    for I := 0 to Sections.Count - 1 do
    begin
      S := Sections[I];
      R.Left := R.Right;
      R.Right := R.Left + S.Width;
      { прямоугольник }
      SR := R;
      if S.Sections.Count > 0 then SR.Bottom := R.Top + SectionHeight;
      { запоминаем }
      S.FBoundsRect := SR;
      { подзаголовки }
      if S.Sections.Count > 0 then
      begin
        { вычитаем строку сверху }
        SR.Top := SR.Bottom;
        SR.Bottom := R.Bottom;
        { подзаголовки снизу }
        DoUpdateSecionsBounds(S.Sections, SR);
      end;
    end;
  end;

begin
  if (Grid <> nil) and (Grid.ComponentState * [csReading, csLoading] = []) 
    and (Grid.Columns <> nil) then
  begin
    { определяеи индексы колонок }
    C := 0;
    DoUpdateColumnIndex(Sections);
    { абсолютные границы заголовка }
    R.Left := Grid.ClientRect.Left;
    R.Right := R.Left + Grid.GetColumnsWidth(0, Grid.Columns.Count - 1);
    R.Top := Grid.ClientRect.Top;
    R.Bottom := R.Top + Height;
    { определяем границы секций }
    DoUpdateSecionsBounds(Sections, R);
  end;
end;

{ TCustomGridColumn }

constructor TCustomGridColumn.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FColumns := TGridColumns(Collection);
  FWidth := 64;
  FMinWidth := 0;
  FMaxWidth := 10000;
  FAlignment := taLeftJustify;
  FTabStop := True;
  FVisible := True;
  FAllowClick := True;
end;

destructor TCustomGridColumn.Destroy;
begin
  inherited;
  FreeAndNil(FPickList);
end;

function TCustomGridColumn.GetWidth: Integer;
begin
  { а виден ли столбец }
  if not FVisible then
  begin
    Result := 0;
    Exit;
  end;
  { возвращаем ширину }
  Result := FWidth;
end;

function TCustomGridColumn.GetEditAlignment: TAlignment;
begin
  if AlignEdit then Result := Alignment else Result := taLeftJustify;
end;

function TCustomGridColumn.GetGrid: TCustomGridView;
begin
  Result := nil;
  if Columns <> nil then Result := TCustomGridView(Columns.Grid);
end;

function TCustomGridColumn.GetPickList: TStrings;
begin
  if FPickList = nil then FPickList := TStringList.Create;
  Result := FPickList;
end;

function TCustomGridColumn.GetPickListCount: Integer;
begin
  Result := 0;
  if FPickList <> nil then Result := FPickList.Count;
end;

function TCustomGridColumn.GetTitle: TGridHeaderSection;
begin
  Result := nil;
  if Grid <> nil then Result := Grid.GetHeaderSection(Index, -1);
end;

function TCustomGridColumn.IsPickListStored: Boolean;
begin
  Result := GetPickListCount <> 0; 
end;

procedure TCustomGridColumn.ReadMultiline(Reader: TReader);
begin
  WantReturns := Reader.ReadBoolean;
end;

procedure TCustomGridColumn.SetAlignEdit(Value: Boolean);
begin
  if FAlignEdit <> Value then
  begin
    FAlignEdit := Value;
    Changed(False);
  end;
end;

procedure TCustomGridColumn.SetCheckKind(Value: TGridCheckKind);
begin
  if FCheckKind <> Value then
  begin
    FCheckKind := Value;
    Changed(False);
  end;
end;

procedure TCustomGridColumn.SetMaxWidth(Value: Integer);
begin
  if Value < FMinWidth then Value := FMinWidth;
  if Value > 10000 then Value := 10000;
  FMaxWidth := Value;
  SetWidth(FWidth);
end;

procedure TCustomGridColumn.SetMinWidth(Value: Integer);
begin
  if Value < 0 then Value := 0;
  if Value > FMaxWidth then Value := FMaxWidth;
  FMinWidth := Value;
  SetWidth(FWidth);
end;

procedure TCustomGridColumn.SetPickList(Value: TStrings);
begin
  if Value = nil then
  begin
    FreeAndNil(FPickList);
    Exit;
  end;
  PickList.Assign(Value);
end;

procedure TCustomGridColumn.SetTabStop(Value: Boolean);
begin
  if FTabStop <> Value then
  begin
    FTabStop := Value;
    Changed(False);
  end;
end;

procedure TCustomGridColumn.SetWantReturns(Value: Boolean);
begin
  if FWantReturns <> Value then
  begin
    FWantReturns := Value;
    Changed(False);
  end;
end;

procedure TCustomGridColumn.SetWordWrap(Value: Boolean);
begin
  if FWordWrap <> Value then
  begin
    FWordWrap := Value;
    Changed(False);
  end;
end;

function TCustomGridColumn.GetDisplayName: string;
begin
  Result := FCaption;
{$IFNDEF VER90}
  if Result = '' then Result := inherited GetDisplayName;
{$ENDIF}
end;

procedure TCustomGridColumn.SetAlignment(Value: TAlignment);
begin
  if Alignment <> Value then
  begin
    FAlignment := Value;
    Changed(False);
  end;
end;

procedure TCustomGridColumn.SetCaption(const Value: string);
begin
  if FCaption <> Value then
  begin
    FCaption := Value;
    Changed(False);
  end;
end;

procedure TCustomGridColumn.SetEditMask(const Value: string);
begin
  if FEditMask <> Value then
  begin
    FEditMask := Value;
    Changed(False);
  end;
end;

procedure TCustomGridColumn.SetEditStyle(Value: TGRidEditStyle);
begin
  if FEditStyle <> Value then
  begin
    FEditStyle := Value;
    Changed(False);
  end;
end;

procedure TCustomGridColumn.SetMaxLength(Value: Integer);
begin
  if FMaxLength <> Value then
  begin
    FMaxLength := Value;
    Changed(False);
  end;
end;

procedure TCustomGridColumn.SetReadOnly(Value: Boolean);
begin
  if FReadOnly <> Value then
  begin
    FReadOnly := Value;
    Changed(False);
  end;
end;

procedure TCustomGridColumn.SetVisible(Value: Boolean);
begin
  if FVisible <> Value then
  begin
    FVisible := Value;
    Changed(True);
  end;
end;

procedure TCustomGridColumn.SetWidth(Value: Integer);
begin
  if Value < FMinWidth then Value := FMinWidth;
  if Value > FMaxWidth then Value := FMaxWidth;
  if FWidth <> Value then
  begin
    FWidth := Value;
    Changed(True);
  end;
end;

procedure TCustomGridColumn.DefineProperties(Filer: TFiler);
begin
  inherited DefineProperties(Filer);
  { для совместимости со старыми версиями, где вместо свойства WantReturns
    было свойство Multiline }
  Filer.DefineProperty('Multiline', ReadMultiline, nil, False);
end;

procedure TCustomGridColumn.Assign(Source: TPersistent);
begin
  if Source is TCustomGridColumn then
  begin
    Caption := TCustomGridColumn(Source).Caption;
    DefWidth := TCustomGridColumn(Source).DefWidth;
    MinWidth := TCustomGridColumn(Source).MinWidth;
    MaxWidth := TCustomGridColumn(Source).MaxWidth;
    FixedSize := TCustomGridColumn(Source).FixedSize;
    MaxLength := TCustomGridColumn(Source).MaxLength;
    Alignment := TCustomGridColumn(Source).Alignment;
    ReadOnly := TCustomGridColumn(Source).ReadOnly;
    EditStyle := TCustomGridColumn(Source).EditStyle;
    EditMask := TCustomGridColumn(Source).EditMask;
    CheckKind := TCustomGridColumn(Source).CheckKind;
    WantReturns := TCustomGridColumn(Source).WantReturns;
    WordWrap := TCustomGridColumn(Source).WordWrap;
    TabStop := TCustomGridColumn(Source).TabStop;
    Visible := TCustomGridColumn(Source).Visible;
    PickList := TCustomGridColumn(Source).FPickList;
    Tag := TCustomGridColumn(Source).Tag;
    AllowClick := TCustomGridColumn(Source).AllowClick;
    Exit;
  end;
  inherited Assign(Source);
end;

{ TGridColumns }

constructor TGridColumns.Create(AGrid: TCustomGridView);
var
  AClass: TGridColumnClass;
begin
  AClass := TGridColumn;
  if AGrid <> nil then AClass := AGrid.GetColumnClass;
  inherited Create(AClass);
  FGrid := AGrid;
end;

function TGridColumns.GetColumn(Index: Integer): TGridColumn;
begin
  Result := TGridColumn(inherited GetItem(Index));
end;

function TGridColumns.GetLayout: string;
var
  I, W: Integer;
  Strings: TStringList;
begin
  Strings := TStringList.Create;
  try
    { добавляем в список ширины колонок }
    for I := 0 to Count - 1 do
    begin
      { отрицательное значение ширины соотвествует невидимой колонке }
      W := Columns[I].DefWidth;
      if not Columns[I].Visible then W := W * (-1);
      { добавляем в список }
      Strings.Add(IntToStr(W));
    end;
    { результат - ширины колонок, разделенные запятой }
    Result := ExpandStrings(Strings, ',')
  finally
    Strings.Free;
  end;
end;

procedure TGridColumns.SetColumn(Index: Integer; Value: TGridColumn);
begin
  inherited SetItem(Index, Value);
end;

procedure TGridColumns.SetLayout(const Value: string);
var
  I, W: Integer;
  Strings: TStringList;
begin
  BeginUpdate;
  try
    Strings := TStringList.Create;
    try
      { разбиваем ширины колонок, разделенные запятой, на строки }
      ExtractStrings([','], [' '], PChar(Value), Strings);
      { меняем ширины колонок }
      for I := 0 to Strings.Count - 1 do
      begin
        { проверяем количество колонок }
        if I > Count - 1 then Break;
        { получаем ширину }
        W := StrToIntDef(Strings[I], Columns[I].DefWidth);
        { отрицательное значение ширины соотвествует невидимой колонке }
        Columns[I].DefWidth := Abs(W);
        Columns[I].Visible := W > 0;
      end;
    finally
      Strings.Free;
    end;
  finally
    EndUpdate;
  end;
end;

function TGridColumns.GetOwner: TPersistent;
begin
  Result := FGrid; 
end;

procedure TGridColumns.Update(Item: TCollectionItem);
begin
  if Assigned(FOnChange) then FOnChange(Self);
end;

function TGridColumns.Add: TGridColumn;
begin
  if Grid = nil then
  begin
    Result := TGridColumn(inherited Add);
    Exit;
  end;
  Result := TGridColumn(Grid.CreateColumn(Self));
end;

{ TCustomGridRows }

constructor TCustomGridRows.Create(AGrid: TCustomGridView);
begin
  inherited Create;
  FGrid := AGrid;
  FHeight := 17;
end;

destructor TCustomGridRows.Destroy;
begin
  FOnChange := nil;
  SetCount(0);
  inherited Destroy;
end;

function TCustomGridRows.GetMaxCount: Integer;
begin
  Result := MaxInt - 2;
  if Height > 0 then Result := Result div Height - 2;
end;

procedure TCustomGridRows.SetAutoHeight(Value: Boolean);
begin
  if FAutoHeight <> Value then
  begin
    FAutoHeight := Value;            
    if Value then SetHeight(Height);
  end;
end;

procedure TCustomGridRows.SetHeight(Value: Integer);
var
  TH, FH, CH, IH, GH: Integer;
begin
  { проверяем автоподбор }
  if AutoHeight and (Grid <> nil) then
  begin
    { высота текста }
    TH := GetFontHeight(Grid.Font) + Grid.TextTopIndent * 2;
    FH := GetFontHeight(Grid.Fixed.Font) + Grid.TextTopIndent * 2;
    { высота флажков }
    CH := 0;
    if Grid.CheckBoxes then
    begin
      CH := Grid.CheckHeight + Grid.CheckTopIndent{+ 1};
      if Grid.Fixed.Count > 0 then
      begin
        if not Grid.Fixed.Flat then Inc(CH, 3)
        else if (not Grid.Fixed.GridColor) and Grid.GridLines and (gsHorzLine in Grid.GridStyle) then Inc(CH, 1);
      end
      else
        if Grid.GridLines and (gsHorzLine in Grid.GridStyle) then Inc(CH, 1);
    end;
    { высота картинки }
    IH := 0;
    if Grid.Images <> nil then
    begin
      IH := Grid.Images.Height + Grid.ImageTopIndent{+ 1};
      if Grid.Fixed.Count > 0 then
      begin
        if not Grid.Fixed.Flat then Inc(IH, 3)
        else if (not Grid.Fixed.GridColor) and Grid.GridLines and (gsHorzLine in Grid.GridStyle) then Inc(IH, 1);
      end
      else
        if Grid.GridLines and (gsHorzLine in Grid.GridStyle) then Inc(IH, 1);
    end;
    { учет сетки }
    GH := (Grid.FGridLineWidth * 2) * Ord(Grid.GridLines and (gsHorzLine in Grid.GridStyle));
    { высота строки }
    Value := MaxIntValue([0, TH, FH, CH, IH, GH]);
  end;
  { высота строк не может быть нулевой }
  if Value < 0 then Value := 0;
  { устанавливаем }
  if FHeight <> Value then
  begin
    FHeight := Value;
    if Count > MaxCount then SetCount(Count) else Change;
  end;
end;

procedure TCustomGridRows.Change;
begin
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TCustomGridRows.SetCount(Value: Integer);
begin
  if Value < 0 then Value := 0;
  if Value > MaxCount then Value := MaxCount;
  if FCount <> Value then
  begin
    FCount := Value;
    Change;
  end;
end;

procedure TCustomGridRows.Assign(Source: TPersistent);
begin
  if Source is TCustomGridRows then
  begin
    Count := TCustomGridRows(Source).Count;
    Height := TCustomGridRows(Source).Height;
    Exit;
  end;
  inherited Assign(Source);
end;

{ TCustomGridFixed }

constructor TCustomGridFixed.Create(AGrid: TCustomGridView);
begin
  inherited Create;
  FGrid := AGrid;
  FColor := clBtnFace;
  FFont := TFont.Create;
  FFont.OnChange := FontChange;
  FGridFont := True;
  FFLat := True;
end;

destructor TCustomGridFixed.Destroy;
begin
  FOnChange := nil;
  inherited Destroy;
  FreeandNil(FFont);
end;

function TCustomGridFixed.IsColorStored: Boolean;
begin
  Result := not GridColor;
end;

function TCustomGridFixed.IsFontStored: Boolean;
begin
  Result := not GridFont;
end;

procedure TCustomGridFixed.FontChange(Sender: TObject);
begin
  FGridFont := False;
  Change;
end;

procedure TCustomGridFixed.SetColor(Value: TColor);
begin
  if FColor <> Value then
  begin
    FColor := Value;
    FGridColor := False;
    Change;
  end;
end;

procedure TCustomGridFixed.SetFlat(Value: Boolean);
begin
  if FFlat <> Value then
  begin
    FFlat := Value;
    { подправляем 3D эффект заголовка }
    if (not Value) and (Grid <> nil) then Grid.Header.Flat := False;
    { изменение }
    Change;
  end;
end;

procedure TCustomGridFixed.SetFont(Value: TFont);
begin
  FFont.Assign(Value);
end;

procedure TCustomGridFixed.SetGridColor(Value: Boolean);
begin
  if FGridColor <> Value then
  begin
    FGridColor := Value;
    if Grid <> nil then GridColorChanged(Grid.Color);
    Change;
  end;
end;

procedure TCustomGridFixed.SetGridFont(Value: Boolean);
begin
  if FGridFont <> Value then
  begin
    FGridFont := Value;
    if Grid <> nil then GridFontChanged(Grid.Font);
    Change;
  end;
end;

procedure TCustomGridFixed.Change;
begin
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TCustomGridFixed.GridColorChanged(NewColor: TColor);
begin
  if FGridColor then
  begin
    SetColor(NewColor);
    FGridColor := True;
  end;
end;

procedure TCustomGridFixed.GridFontChanged(NewFont: TFont);
begin
  if FGridFont then
  begin
    SetFont(NewFont);
    FGridFont := True;
  end;
end;

procedure TCustomGridFixed.SetCount(Value: Integer);
begin
  { подправляем значение }
  if (Grid <> nil) and (Value > Grid.Columns.Count - 1) then Value := Grid.Columns.Count - 1;
  if Value < 0 then Value := 0;
  { устанавливаем }
  if FCount <> Value then
  begin
    FCount := Value;
    Change;
  end;
end;

procedure TCustomGridFixed.Assign(Source: TPersistent);
begin
  if Source is TCustomGridFixed then
  begin
    Count := TCustomGridFixed(Source).Count;
    Color := TCustomGridFixed(Source).Color;
    GridColor := TCustomGridFixed(Source).GridColor;
    Font := TCustomGridFixed(Source).Font;
    GridFont := TCustomGridFixed(Source).GridFont;
    Exit;
  end;
  inherited Assign(Source);
end;

{ TGridScrollBar }

constructor TGridScrollBar.Create(AGrid: TCustomGridView; AKind: TScrollBarKind);
begin
  inherited Create;
  FGrid := AGrid;
  FKind := AKind;
  FPageStep := 100;
  FLineStep := 8;
  FLineSize := 1;
  FTracking := True;
  FVisible := True;
end;

function TGridScrollBar.GetRange: Integer;
begin
  Result := Max - Min;
end;

procedure TGridScrollBar.SetLineSize(Value: Integer);
begin
  if Value < 1 then FLineSize := 1 else FLineSize := Value;
end;

procedure TGridScrollBar.SetLineStep(Value: Integer);
begin
  SetParams(Min, Max, PageStep, Value);
end;

procedure TGridScrollBar.SetMax(Value: Integer);
begin
  SetParams(Min, Value, PageStep, LineStep);
end;

procedure TGridScrollBar.SetMin(Value: Integer);
begin
  SetParams(Value, Max, PageStep, LineStep);
end;

procedure TGridScrollBar.SetPageStep(Value: Integer);
begin
  SetParams(Min, Max, Value, LineStep);
end;

procedure TGridScrollBar.SetVisible(Value: Boolean);
begin
  if FVisible <> Value then
  begin
    FVisible := Value;
    Update;
  end;
end;

procedure TGridScrollBar.Change;
begin
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TGridScrollBar.ChangeParams;
begin
  if Assigned(FOnChangeParams) then FOnChangeParams(Self);
end;

procedure TGridScrollBar.Scroll(ScrollCode: Integer; var ScrollPos: Integer);
begin
  if Assigned(FOnScroll) then FOnScroll(Self, ScrollCode, ScrollPos);
end;

procedure TGridScrollBar.ScrollMessage(var Message: TWMScroll);
begin
  with Message do
  begin
    LockUpdate;
    try
      case ScrollCode of
        SB_LINELEFT: SetPositionEx(Position - LineStep, ScrollCode);
        SB_LINERIGHT: SetPositionEx(Position + LineStep, ScrollCode);
        SB_PAGELEFT: SetPositionEx(Position - PageStep, ScrollCode);
        SB_PAGERIGHT: SetPositionEx(Position + PageStep, ScrollCode);
        SB_THUMBPOSITION: SetPositionEx(WinPosToScrollPos(Pos, Min, Max), ScrollCode);
        SB_THUMBTRACK: if Tracking then SetPositionEx(WinPosToScrollPos(Pos, Min, Max), ScrollCode);
        SB_ENDSCROLL: SetPositionEx(Position, ScrollCode);
      end;
    finally
      UnLockUpdate;
    end;
  end;
end;

procedure TGridScrollBar.SetParams(AMin, AMax, APageStep, ALineStep: Integer);
begin
  { подправляем новые значения }
  if APageStep < 0 then APageStep := 0;
  if ALineStep < 0 then ALineStep := 0;
  if AMax < AMin then AMax := AMin;
  { изменилось ли что нибудь }
  if (FMin <> AMin) or (FMax <> AMax) or (FPageStep <> APageStep) or (FLineStep <> ALineStep) then
  begin
    { устанавливаем новые значения }
    FMin := AMin;
    FMax := AMax;
    FPageStep := APageStep;
    FLineStep := ALineStep;
    { подправляем позицию }
    if FPosition > Range - FPageStep then FPosition := Range - FPageStep;
    if FPosition < 0 then FPosition := 0;
    { обновляем скроллер }
    Update;
    { событие }
    ChangeParams;
  end;
end;

procedure TGridScrollBar.SetPosition(Value: Integer);
begin
  SetPositionEx(Value, SB_ENDSCROLL);
end;

procedure TGridScrollBar.SetPositionEx(Value: Integer; ScrollCode: Integer);
var
  R: TRect;
  
  procedure UpdatePosition;
  begin
    if Value > Max - PageStep then Value := Max - PageStep;
    if Value < Min then Value := Min;
  end;

begin
  { проверяем позицию }
  UpdatePosition;
  { изменилась ли позиция }
  if Value <> FPosition then
  begin
    { позиция меняется }
    Scroll(ScrollCode, Value);
    { снова проверяем }
    UpdatePosition;
  end;
  { изменилась ли позиция после реакции пользователя }
  if Value <> FPosition then
  begin
    { сдвигаем сетку }
    with FGrid do
    begin
      { гасим фокус }
      HideFocus;
      { сдвигаем }
      if FKind = sbHorizontal then
      begin
        R := GetClientRect;
        R.Left := GetFixedRect.Right;
        ScrollWindowEx(Handle, (FPosition - Value) * FLineSize, 0, @R, @R, 0, nil, SW_INVALIDATE);
      end
      else
      begin
        R := GetGridRect;
        ScrollWindowEx(Handle, 0, (FPosition - Value) * FLineSize, @R, @R, 0, nil, SW_INVALIDATE);
      end;
      { устанавливаем новую позицию }
      FPosition :=  Value;
      { показываем фокус }
      ShowFocus;
    end;
    { устанавливаем скроллер }
    Update;
    { изменение }
    Change;
  end;
end;

procedure TGridScrollBar.Update;
var
  ScrollInfo: TScrollInfo;
  ScrollCode: Integer;
begin
  if FGrid.HandleAllocated and (FUpdateLock = 0) then
  begin
    FillChar(ScrollInfo, SizeOf(ScrollInfo), 0);
    { параметры скроллера }
    ScrollInfo.cbSize := SizeOf(ScrollInfo);
    ScrollInfo.fMask := SIF_ALL;
    ScrollInfo.nMin := 0;
    ScrollInfo.nMax := MaxWinPos * Ord(Visible and (Range > PageStep));
    ScrollInfo.nPage := ScrollPosToWinPos(Min + PageStep, Min, Max);
    ScrollInfo.nPos := ScrollPosToWinPos(Position, Min, Max);
    { тип скроллера }
    ScrollCode := SB_VERT;
    if Kind = sbHorizontal then ScrollCode := SB_HORZ;
    { устанавливаем }
    if FGrid.FFlatScrollBars then
      FlatSB_SetScrollInfo(FGrid.Handle, ScrollCode, ScrollInfo, True)
    else
      SetScrollInfo(FGrid.Handle, ScrollCode, ScrollInfo, True);
  end;
end;

procedure TGridScrollBar.Assign(Source: TPersistent);
begin
  if Source is TGridScrollBar then
  begin
    LockUpdate;
    try
      PageStep := TGridScrollBar(Source).PageStep;
      LineStep := TGridScrollBar(Source).LineStep;
      Min := TGridScrollBar(Source).Min;
      Max := TGridScrollBar(Source).Max;
      Position := TGridScrollBar(Source).Position;
      Tracking := TGridScrollBar(Source).Tracking;
      Visible := TGridScrollBar(Source).Visible;
      Exit;
    finally
      UnLockUpdate;
    end;
  end;
  inherited Assign(Source);
end;

procedure TGridScrollBar.LockUpdate;
begin
  Inc(FUpdateLock);
end;

procedure TGridScrollBar.UnLockUpdate;
begin
  Dec(FUpdateLock);
  if FUpdateLock = 0 then Update;
end;

{ TGridListBox }

constructor TGridListBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ParentShowHint := False;
  ShowHint := False;
end;

procedure TGridListBox.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
  begin
    Style := Style or WS_BORDER;
    ExStyle := WS_EX_TOOLWINDOW or WS_EX_TOPMOST;
    WindowClass.Style := CS_SAVEBITS;
  end;
end;

procedure TGridListBox.CreateWnd;
begin
  inherited CreateWnd;
  Windows.SetParent(Handle, 0);
  CallWindowProc(DefWndProc, Handle, WM_SETFOCUS, 0, 0);
end;

procedure TGridListBox.Keypress(var Key: Char);
var
  TickCount: Integer;
begin
  case Key of
    #8, #27:
      { сбрасываем текст поиска }
      FSearchText := '';
    #32..#255:
      { инициируем поиск }
      begin
        TickCount := GetTickCount;
        if TickCount - FSearchTime > 2000 then FSearchText := '';
        FSearchTime := TickCount;
        if Length(FSearchText) < 32 then FSearchText := FSearchText + Key;
        SendMessage(Handle, LB_SELECTSTRING, WORD(-1), Longint(PChar(FSearchText)));
        Key := #0;
      end;
  end;
  inherited Keypress(Key);
end;

procedure TGridListBox.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseUp(Button, Shift, X, Y);
  if (Grid <> nil) and (Grid.Edit <> nil) then
    Grid.Edit.CloseUp((X >= 0) and (Y >= 0) and (X < Width) and (Y < Height));
end;

{ TCustomGridEdit }

constructor TCustomGridEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  { внутренние переменные }
  FEditStyle := geSimple;
  FDropDownCount := 8;
  FButtonWidth := GetSystemMetrics(SM_CXVSCROLL);
  { параметры внешнего вида }
  ParentCtl3D := False;
  Ctl3D := False;
  TabStop := False;
  BorderStyle := bsNone;
  ParentShowHint := False;
  ShowHint := False;
end;

function TCustomGridEdit.GetButtonRect: TRect;
begin
  Result := Rect(Width - FButtonWidth, 0, Width, Height);
end;

function TCustomGridEdit.GetLineCount: Integer;
begin
  Result := ExtStrUtils.GetLineCount(Text);
end;

function TCustomGridEdit.GetVisible: Boolean;
begin
  Result := IsWindowVisible(Handle);
end;

procedure TCustomGridEdit.ListMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (Button = mbLeft) and (FActiveList <> nil) then CloseUp(PtInRect(FActiveList.ClientRect, Point(X, Y)));
end;

procedure TCustomGridEdit.SetAlignment(Value: TAlignment);
begin
  if FAlignment <> Value then
  begin
    FAlignment := Value;
    RecreateWnd;
  end;
end;

procedure TCustomGridEdit.SetButtonWidth(Value: Integer);
begin
  if FButtonWidth <> Value then
  begin
    FButtonWidth := Value;
    Repaint;
  end;
end;

procedure TCustomGridEdit.SetDropListVisible(Value: Boolean);
begin
  if Value then DropDown else CloseUp(False);
end;

procedure TCustomGridEdit.SetEditStyle(Value: TGridEditStyle);
begin
  if FEditStyle <> Value then
  begin
    FEditStyle := Value;
    Repaint;
  end;
end;

procedure TCustomGridEdit.SetWordWrap(Value: Boolean);
begin
  if FWordWrap <> Value then
  begin
    FWordWrap := Value;
    RecreateWnd;
  end;
end;

procedure TCustomGridEdit.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  inherited;
  { символы, переход по нажатию TAB }
  with Message do
  begin
    Result := Result or DLGC_WANTARROWS or DLGC_WANTCHARS;
    if (Grid <> nil) and (gkTabs in Grid.CursorKeys) then Result := Result or DLGC_WANTTAB;
  end;
end;

procedure TCustomGridEdit.WMCancelMode(var Message: TMessage);
begin
  StopButtonTracking;
  inherited;
end;

procedure TCustomGridEdit.WMKillFocus(var Message: TMessage);
begin
  inherited;
  CloseUp(False);
end;

procedure TCustomGridEdit.WMWindowPosChanged(var Message: TWMWindowPosChanged);
begin
  inherited;
  Invalidate;
end;

procedure TCustomGridEdit.WMPaint(var Message: TWMPaint);
begin
  PaintHandler(Message);
end;

procedure TCustomGridEdit.WMLButtonDown(var Message: TWMLButtonDown);
begin
  SendCancelMode(Self);
  with Message do
    { чтобы выделение текста не гасло при нажатии на кнопку, обрабатываем
      нажатие сами }
    if (EditStyle <> geSimple) and PtInrect(ButtonRect, Point(XPos, YPos)) then
    begin
      if csCaptureMouse in ControlStyle then MouseCapture := True;
      MouseDown(mbLeft, KeysToShiftState(Keys), XPos, YPos);
    end
    else
    begin
      CloseUp(False);
      inherited;
    end;
end;

procedure TCustomGridEdit.WMLButtonDblClk(var Message: TWMLButtonDblClk);
var
  P: TPoint;
begin
  with Message do
  begin
    P := Point(XPos, YPos);
    if (FEditStyle <> geSimple) and PtInRect(GetButtonRect, P) then Exit;
  end;
  inherited;
end;

procedure TCustomGridEdit.WMSetCursor(var Message: TWMSetCursor);
var
  P: TPoint;
begin
  GetCursorPos(P);
  { не попала ли мышка на кнопку }
  if (FEditStyle <> geSimple) and PtInRect(GetButtonRect, ScreenToClient(P)) then
  begin
    Windows.SetCursor(LoadCursor(0, IDC_ARROW));
    Exit;
  end;
  { обработка по умолчанию }
  inherited;
end;

procedure TCustomGridEdit.WMPaste(var Message);
begin
  if EditCanModify then inherited;
end;

procedure TCustomGridEdit.WMCut(var Message);
begin
  if EditCanModify then inherited;
end;

procedure TCustomGridEdit.WMClear(var Message);
begin
  if EditCanModify then inherited;
end;

procedure TCustomGridEdit.WMUndo(var Message);
begin
  if (Grid = nil) or Grid.EditCanUndo(Grid.EditCell) then inherited;
end;

procedure TCustomGridEdit.CMCancelMode(var Message: TCMCancelMode);
begin
  if (Message.Sender <> Self) and (Message.Sender <> FActiveList) then CloseUp(False);
end;

procedure TCustomGridEdit.CMEnabledChanged(var Message: TMessage);
begin
  inherited;
  Invalidate;
end;

procedure TCustomGridEdit.CMShowingChanged(var Message: TMessage);
begin
  { игнорируем изменение видимости через изменение свойства Visible }
end;

procedure TCustomGridEdit.WMContextMenu(var Message: TMessage);
begin
  { если свойство DefaultPopupMenu таблицы установлено в True, то по правой
    кнопке надо показать стандартное popup меню строки ввода, а не Popup
    меню таблицы }
  if (Grid <> nil) and Grid.DefaultEditMenu and Assigned(Grid.PopupMenu) then
    with Message do
      Result := CallWindowProc(DefWndProc, Handle, Msg, WParam, LParam)
  else
    inherited;
end;

procedure TCustomGridEdit.Change;
begin
  if Grid <> nil then Grid.EditChange(Grid.EditCell);
end;

procedure TCustomGridEdit.CreateParams(var Params: TCreateParams);
const
  WordWraps: array[Boolean] of DWORD = (0, ES_AUTOHSCROLL);
  Aligns: array[TAlignment] of DWORD = (ES_LEFT, ES_RIGHT, ES_CENTER);
begin
  inherited CreateParams(Params);
  with Params do
    Style := Style and (not WordWraps[FWordWrap]) or ES_MULTILINE or
      Aligns[FAlignment];
end;

procedure TCustomGridEdit.DblClick;
begin
  { событие таблицы }
  if Grid <> nil then Grid.DblClick;
  { двойной щелчок - эмуляция нажатия на кнопку }
  case EditStyle of
    geEllipsis: Press;
    gePickList, geDataList: if not FDropListVisible then SelectNext;
  end;
end;

{$IFDEF EX_D4_UP}

function TCustomGridEdit.DoMouseWheel(Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint): Boolean;
begin
  Result := (Grid <> nil) and Grid.DoMouseWheel(Shift, WheelDelta, MousePos);
end;

{$ENDIF}

function TCustomGridEdit.EditCanModify: Boolean;
begin
  Result := (Grid <> nil) and Grid.EditCanModify(Grid.EditCell);
end;

function TCustomGridEdit.GetDropList: TWinControl;
begin
  if FPickList = nil then
  begin
    FPickList := TGridListBox.Create(Self);
    FPickList.IntegralHeight := True;
    FPickList.FGrid := Grid;
  end;
  Result := FPickList;
end;

procedure TCustomGridEdit.KeyDown(var Key: Word; Shift: TShiftState);

  procedure SendToParent;
  begin
    if Grid <> nil then
    begin
      Grid.KeyDown(Key, Shift);
      Key := 0;
    end;
  end;

  procedure ParentEvent;
  var
    GridKeyDown: TKeyEvent;
  begin
    if Grid <> nil then
    begin
      GridKeyDown := Grid.OnKeyDown;
      if Assigned(GridKeyDown) then GridKeyDown(Grid, Key, Shift);
    end;
  end;

begin
  { обрабатываем нажатие }
  case Key of
    VK_UP,
    VK_DOWN:
      { перемещение фокуса }
      if (Shift = [ssCtrl]) or ((Shift = []) and (not (WantReturns or WordWrap))) then SendToParent;
    VK_PRIOR,
    VK_NEXT:
      { перемещение фокуса }
      if Shift = [ssCtrl] then SendToParent;
    VK_ESCAPE:
      { отмена }
      SendToParent;
    VK_DELETE:
      { удаление }
      if not EditCanModify then SendToParent;
    VK_INSERT:
      { вставка }
      if (not EditCanModify) or (Shift = []) then SendToParent;
(*
    VK_LEFT,
    VK_RIGHT,
    VK_HOME,
    VK_END:
      { перемещение фокуса при нажатом Ctrl }
      if Shift = [ssCtrl] then SendToParent;
*)
    VK_TAB:
      { табуляция }
      if not (ssAlt in Shift) then SendToParent;
  end;
  { кнопка не обработана - событие }
  if Key <> 0 then
  begin
    ParentEvent;
    inherited KeyDown(Key, Shift);
  end;
end;

procedure TCustomGridEdit.KeyPress(var Key: Char);
begin
  if Grid <> nil then
  begin
    { отсылаем клавишу таблице }
    Grid.KeyPress(Key);
    { проверяем доступность символа }
    if (Key in [#32..#255]) and not Grid.EditCanAcceptKey(Grid.EditCell, Key) then
    begin
      Key := #0;
      MessageBeep(0);
    end;
    { разбираем символ }
    case Key of                                 
      #9, #27:
        { TAB, ESC убираем }
        Key := #0;
      ^H, ^V, ^X, #32..#255:
        { BACKSPACE, обычные символы убираем, если нельзя редактировать }
        if not EditCanModify then Key := #0;
    end;
  end;
  { обработан ли символ }
  if Key <> #0 then inherited KeyPress(Key);
end;

procedure TCustomGridEdit.KeyUp(var Key: Word; Shift: TShiftState);
begin
  if Grid <> nil then Grid.KeyUp(Key, Shift);
end;

procedure TCustomGridEdit.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  { проверяем нажатие на кнопку }
  if (Button = mbLeft) and (EditStyle <> geSimple) and PtInrect(ButtonRect, Point(X, Y)) then
  begin
    { видим ли список }
    if FDropListVisible then
      { закрываем его }
      CloseUp(False)
    else
    begin
      { начинаем нажатие на кнопку и, если нужно, открываем список }
      StartButtonTracking(X, Y);
      if EditStyle <> geEllipsis then DropDown;
    end;
  end;
  inherited MouseDown(Button, Shift, X, Y);
end;

procedure TCustomGridEdit.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  P: TPoint;
  M: TSmallPoint;
begin
  if FButtonTracking then
  begin
    { нажатие на кнопку }
    StepButtonTracking(X, Y);
    { для открытого списка }
    if FDropListVisible then
    begin
      { получаем точку на списке }
      P := FActiveList.ScreenToClient(ClientToScreen(Point(X, Y)));
      { если попали на список }
      if PtInRect(FActiveList.ClientRect, P) then
      begin
        { прекращаем нажатие на кнопку }
        StopButtonTracking;
        { эмулируем нажатие на список }
        M := PointToSmallPoint(P);
        SendMessage(FActiveList.Handle, WM_LBUTTONDOWN, 0, Integer(M));
        Exit;
      end;
    end;
  end;
  { обработка по умолчанию }
  inherited MouseMove(Shift, X, Y);
end;

procedure TCustomGridEdit.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  P: Boolean;
begin
  P := FButtonPressed;
  { завершаем нажатие }
  StopButtonTracking;
  { нажатие на кнопку }
  if (Button = mbLeft) and (EditStyle = geEllipsis) and P then Press;
  { обработка по умолчанию }
  inherited MouseUp(Button, Shift, X, Y);
end;

procedure TCustomGridEdit.PaintButton(DC: HDC);
var
  R: TRect;
begin
  { рисуем кнопку }
  if EditStyle <> geSimple then
  begin
    { получаем прямоугольник кнопки }
    R := GetButtonRect;
    { рисуем кнопку }
    case EditStyle of
      geEllipsis:
        { кнопка с многоточием }
        PaintBtnEllipsis(DC, R, FButtonPressed);
      gePickList, geDataList:
        { кнопка списка }
        PaintBtnComboBox2(DC, R, FButtonPressed);
    end;
  end;
end;

procedure TCustomGridEdit.PaintWindow(DC: HDC);
var
  R: TRect;
begin
  { рисуем кнопку }
  PaintButton(DC);
  { убираем прямоугольник кнопки из области отрисовки }
  if (EditStyle <> geSimple) then 
  begin
    R := GetButtonRect;
    ExcludeClipRect(DC, R.Left, R.Top, R.Right, R.Bottom);
  end;
  { отрисовка по умолчанию }
  inherited PaintWindow(DC);
end;

procedure TCustomGridEdit.StartButtonTracking(X, Y: Integer);
begin
  MouseCapture := True;
  FButtonTracking := True;
  StepButtonTracking(X, Y);
end;

procedure TCustomGridEdit.StepButtonTracking(X, Y: Integer);
var
  R: TRect;
  P: Boolean;
begin
  R := GetButtonRect;
  P := PtInRect(R, Point(X, Y));
  if FButtonPressed <> P then
  begin
    FButtonPressed := P;
    InvalidateRect(Handle, @R, False);
  end;
end;

procedure TCustomGridEdit.StopButtonTracking;
begin
  if FButtonTracking then
  begin
    StepButtonTracking(-1, -1);
    FButtonTracking := False;
    MouseCapture := False;
  end;
end;

type
  THackWinControl = class(TWinControl);

procedure TCustomGridEdit.UpdateBounds(ScrollCaret: Boolean);
const
  Flags = SWP_SHOWWINDOW or SWP_NOREDRAW;
var
  R, F: TRect;
  L, T, W, H: Integer;
  TI: TPoint;
begin
  if Grid <> nil then
  begin
    { определяем прямоугольник ячейки строки ввоа }
    R := Grid.GetEditRect(Grid.EditCell);
    { запоминаем прямоугольник }
    F := R;
    { подправляем строку в соотвествии с фиксированными }
    with Grid.GetFixedRect do
    begin
      if R.Left < Right then R.Left := Right;
      if R.Right < Right then R.Right := Right;
    end;
    { подправляем строку в соотвествии с заголовком }
    with Grid.GetHeaderRect do
    begin
      if R.Top < Bottom then R.Top := Bottom;
      if R.Bottom < Bottom then R.Bottom := Bottom;
    end;
    { устанавливаем положение }
    W := R.Right - R.Left;
    H := R.Bottom - R.Top;
    SetWindowPos(Handle, HWND_TOP, R.Left, R.Top, W, H, Flags);
    { вычисляем новые границы такста }
    L := F.Left - R.Left;
    T := F.Top - R.Top;
    W := F.Right - F.Left;
    H := F.Bottom - F.Top;
    { смещение текста }
    TI := Grid.GetCellTextIndent(Grid.EditCell);
    { учитываем кнопку }
    if EditStyle <> geSimple then Dec(W, ButtonWidth + 1) else Dec(W, Grid.TextRightIndent);
    { устанавливаем границы текста }
    R := Bounds(L + TI.X, T + TI.Y, W - TI.X + Ord(Alignment = taRightJustify), H);
    SendMessage(Handle, EM_SETRECTNP, 0, LongInt(@R));
    { курсор в конец строки }
    if ScrollCaret then SendMessage(Handle, EM_SCROLLCARET, 0, 0);
  end
end;

procedure TCustomGridEdit.UpdateColors;
var
  Canvas: TCanvas;
begin
  if Grid <> nil then
  begin
    Canvas := TCanvas.Create;
    try
      { получаем цвета ячейки }
      Grid.GetCellColors(Grid.EditCell, Canvas);
      { запоминаем их }
      Color := Canvas.Brush.Color;
      Font := Canvas.Font;
    finally
      Canvas.Free;
    end;
  end;
end;

procedure TCustomGridEdit.UpdateContents;
begin
  if (Grid = nil) or (not Grid.IsCellValid(Grid.EditCell)) then Exit;
  { обновляем параметры строки }
  with Grid do
  begin
    Self.MaxLength := Columns[EditCell.Col].MaxLength;
    Self.ReadOnly := IsCellReadOnly(EditCell) or (Self.MaxLength = -1);
    Self.WantReturns := Columns[EditCell.Col].WantReturns;
    Self.WordWrap := Columns[EditCell.Col].WordWrap;
    Self.Alignment := Columns[EditCell.Col].EditAlignment;
    Self.EditMask := GetEditMask(EditCell);
    Self.Text := GetEditText(EditCell);
  end;
end;

procedure TCustomGridEdit.UpdateList;
begin
  if FActiveList <> nil then
  begin
    FActiveList.Visible := False;
    FActiveList.Parent := Self;
    THackWinControl(FActiveList).OnMouseUp := ListMouseUp;
    THackWinControl(FActiveList).Font := Font;
  end;
end;

procedure TCustomGridEdit.UpdateListBounds;
var
  I, X, W: Integer;
  R: TRect;
begin
  { а есть ли таблица }
  if (Grid = nil) or (FActiveList = nil) then Exit;
  { для стандартного списка определяем ширину и высоту по строкам }
  if FActiveList is TGridListBox then
    with TGridListBox(FActiveList) do
    begin
      Canvas.Font := Font;
      if Items.Count > 0 then
      begin
        W := 0;
        for I := 0 to Items.Count - 1 do
        begin
          X := Canvas.TextWidth(Items[I]);
          if W < X then W := X;
        end;
        ClientWidth := W + 6;
      end
      else
        ClientWidth := 100;
      { определяем высоту }
      if (FDropDownCount < 1) or (Items.Count = 0) then
        ClientHeight := ItemHeight
      else if Items.Count < FDropDownCount then
        ClientHeight := Items.Count * ItemHeight
      else
        ClientHeight := FDropDownCount * ItemHeight;
    end;
  { подправлям размеры списка в зависимости от размеров колонки и его
    положение на экране }
  with FActiveList do
  begin
    { подправляем по ширине колонки }
    R := Grid.GetCellRect(Grid.EditCell);
    Width := MaxIntValue([Width, R.Right - R.Left]);
    { положение }
    Left := Self.ClientOrigin.X + Self.Width - Width;
    Top := Self.ClientOrigin.Y + Self.Height;
    if Top + Height > Screen.Height then Top := Self.ClientOrigin.Y - Height;
    { подправляем в соотвествием с пожеланием пользователя }
    R := BoundsRect;
    Grid.GetEditListBounds(Grid.EditCell, R);
    BoundsRect := R;
  end;
end;

procedure TCustomGridEdit.UpdateListItems;
begin
  if (Grid = nil) or (FActiveList = nil) or (not (FActiveList is TGridListBox)) then Exit;
  { обновляем выпадающий список }
  with TGridListBox(FActiveList) do
  begin
    { очищаем старый список, заполняем новый }
    Items.Clear;
    Grid.GetEditList(Grid.EditCell, Items);
    { устанавливаем выделенную позицию }
    SendMessage(Handle, LB_SELECTSTRING, WORD(-1), Longint(PChar(Self.Text)));
  end;
end;

procedure TCustomGridEdit.UpdateListValue(Accept: Boolean);
var
  I: Integer;
begin
  if (FActiveList <> nil) and (FActiveList is TGridListBox) then
  begin
    I := TGridListBox(FActiveList).ItemIndex;
    { событие }
    if (Grid <> nil) then Grid.EditCloseUp(Grid.EditCell, I, Accept);
    { устанавливаем значение }
    if Accept and (I <> -1) then
    begin
      Text := TGridListBox(FActiveList).Items[I];
      SendMessage(Handle, EM_SETSEL, 0, -1);
    end;
  end;
end;

procedure TCustomGridEdit.UpdateStyle;
var
  Style: TGridEditStyle;
begin
  { получаем стиль строки }
  Style := geSimple;
  if (Grid <> nil) and (not Grid.ReadOnly) then Style := Grid.GetEditStyle(Grid.EditCell);
  { устанавливаем }
  EditStyle := Style;
end;

{
  Delete the requested message from the queue, but throw back
  any WM_QUIT msgs that PeekMessage may also return.
}
procedure KillMessage(Wnd: HWND; Msg: Integer);
var
  M: TMsg;
begin
  M.Message := 0;
  if PeekMessage(M, Wnd, Msg, Msg, PM_REMOVE) and (M.Message = WM_QUIT) then PostQuitMessage(M.wParam);
end;

procedure TCustomGridEdit.WndProc(var Message: TMessage);

  procedure DoDropDownKeys(var Key: Word; Shift: TShiftState);
  begin
    case Key of
      VK_UP, VK_DOWN:
        { открытие или закрытие }
        if ssAlt in Shift then
        begin
          if FDropListVisible then CloseUp(True) else DropDown;
          Key := 0;
        end;
      VK_RETURN, VK_ESCAPE:
        { закрытие списка }
        if (not (ssAlt in Shift)) and FDropListVisible then
        begin
          KillMessage(Handle, WM_CHAR);
          CloseUp(Key = VK_RETURN);
          Key := 0;
        end;
    end;
  end;

  procedure DoButtonKeys(var Key: Word; Shift: TShiftState);
  begin
    if (Key = VK_RETURN) and (Shift = [ssCtrl]) then
    begin
      KillMessage(Handle, WM_CHAR);
      Key := 0;
      { эмуляция нажатия на кнопку }
      case EditStyle of
        geEllipsis: Press;
        gePickList, geDataList: if not FDropListVisible then SelectNext;
      end;
    end;
  end;

begin
  case Message.Msg of
    WM_KEYDOWN,
    WM_SYSKEYDOWN,
    WM_CHAR:
        with TWMKey(Message) do
        begin
          { открытие списка }
          if EditStyle in [gePickList, geDataList] then
          begin
            DoDropDownKeys(CharCode, KeyDataToShiftState(KeyData));
            { передаем оставшееся событие списку }
            if (CharCode <> 0) and FDropListVisible then
            begin
              with TMessage(Message) do SendMessage(FActiveList.Handle, Msg, WParam, LParam);
              Exit;
            end;
          end;
          { эмуляция нажатия на кнопку }
          if not WantReturns then
          begin
            DoButtonKeys(CharCode, KeyDataToShiftState(KeyData));
            if CharCode = 0 then Exit;
          end;
        end;
    WM_SETFOCUS:
      begin
        if (GetParentForm(Self) = nil) or GetParentForm(Self).SetFocusedControl(Grid) then Dispatch(Message);
        Exit;
      end;
    WM_LBUTTONDOWN:
      { двойное нажатие мышки }
      with TWMLButtonDown(Message) do
      begin
        { на нажатие на кнопку не реагируем }
        if (EditStyle = geSimple) or (not PtInrect(ButtonRect, Point(XPos, YPos))) then
          { смотрим время повторного щелчка }
          if UINT(GetMessageTime - FClickTime) < GetDoubleClickTime then
            { меняем сообщение на двойной щелчок }
            Message.Msg := WM_LBUTTONDBLCLK;
        FClickTime := 0;
      end;
  end;
  inherited WndProc(Message);
end;

procedure TCustomGridEdit.CloseUp(Accept: Boolean);
const
  Flags = SWP_NOZORDER or SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE or SWP_HIDEWINDOW;
begin
  if FDropListVisible then
  begin
    if GetCapture <> 0 then SendMessage(GetCapture, WM_CANCELMODE, 0, 0);
    { скрываем список }
    SetWindowPos(FActiveList.Handle, 0, 0, 0, 0, 0, Flags);
    FDropListVisible := False;
    Invalidate;
    { устанавливаем выбранное значение }
    UpdateListValue(Accept);
  end;
end;

procedure TCustomGridEdit.Deselect;
begin
  SendMessage(Handle, EM_SETSEL, $7FFFFFFF, Longint($FFFFFFFF));
end;

procedure TCustomGridEdit.DropDown;
const
  Flags = SWP_NOSIZE or SWP_NOACTIVATE or SWP_SHOWWINDOW;
begin
  if (not FDropListVisible) and (Grid <> nil) and (EditStyle in [gePickList, geDataList]) then
  begin
    { получаем выпадающий список }
    FActiveList := GetDropList;
    if FActiveList <> nil then
    begin
      { заполяем список, устанавливаем размеры }
      UpdateList;
      UpdateListItems;
      UpdateListBounds;
      { показываем список }
      SetWindowPos(FActiveList.Handle, HWND_TOP, FActiveList.Left, FActiveList.Top, 0, 0, Flags);
      FDropListVisible := True;
      Invalidate;
      { устанавливаем на него фокус }
      Windows.SetFocus(Handle);
    end;
  end;
end;

procedure TCustomGridEdit.Invalidate;
var
  Cur: TRect;
begin
  { проверяем таблицу }
  if Grid = nil then
  begin
    inherited Invalidate;
    Exit;
  end;
  { перерисовываемся }
  ValidateRect(Handle, nil);
  InvalidateRect(Handle, nil, True);
  { обновляем прямоугольник таблицы }
  Windows.GetClientRect(Handle, Cur);
  MapWindowPoints(Handle, Grid.Handle, Cur, 2);
  ValidateRect(Grid.Handle, @Cur);
  InvalidateRect(Grid.Handle, @Cur, False);
end;

procedure TCustomGridEdit.Hide;
const
  Flags = SWP_HIDEWINDOW or SWP_NOZORDER or SWP_NOREDRAW;
begin
  if (Grid <> nil) and HandleAllocated and Visible then
  begin
    { сбрасываем флаг редактирования }
    Grid.FEditing := False;
    { скрываем строку ввода }
    Invalidate;
    SetWindowPos(Handle, 0, 0, 0, 0, 0, Flags);
    { удаляем фокус }
    if Focused then
    begin
      FDefocusing := True;
      try
        Windows.SetFocus(Grid.Handle);
      finally
        FDefocusing := False;
      end;
    end;
  end;
end;

procedure TCustomGridEdit.Press;
begin
  if Grid <> nil then Grid.EditButtonPress(Grid.EditCell);
end;

procedure TCustomGridEdit.SelectNext;
var
  OldText, NewText: string;
begin
  if Grid <> nil then
  begin
    OldText := Text;
    NewText := OldText;
    { вызываем метод таблицы }
    Grid.EditSelectNext(Grid.EditCell, NewText);
    { устанавливаем новое значение }
    if NewText <> OldText then
    begin
      Text := NewText;
      SendMessage(Handle, EM_SETSEL, 0, -1);
    end;
  end;
end;

procedure TCustomGridEdit.SetFocus;
begin
  if IsWindowVisible(Handle) then Windows.SetFocus(Handle);
end;

procedure TCustomGridEdit.Show;
var
  ScrollCaret: Boolean;
begin
  if Grid <> nil then
  begin
    ScrollCaret := not Grid.FEditing;
    { поднимаем флаг редактирования }
    Grid.FEditing := True;
    Grid.FCellSelected := True;
    { подправляем цвета (следует делать до установки границ, так как
      они выставляются в зависимости от размера шрифта) }
    UpdateColors;
    { получаем размеры }
    UpdateBounds(ScrollCaret);
    { устанавливаем фокус }
    if Grid.Focused then Windows.SetFocus(Handle);
  end;
end;

{ TGridTipsWindow }

procedure TGridTipsWindow.WMNCPaint(var Message: TMessage);
begin
  Canvas.Handle := GetWindowDC(Handle);
  try
    Canvas.Pen.Color := clBlack;
    Canvas.Brush.Color := Color;
    Canvas.Rectangle(0, 0, Width, Height);
  finally
    Canvas.Handle := 0;
  end;
end;

procedure TGridTipsWindow.CMTextChanged(var Message: TMessage);
begin
  { игнорируем событие, иначе "прыгает" размер окна }
end;

procedure TGridTipsWindow.Paint;
var
  TI: TPoint;
  A: TAlignment;
  WR, WW: Boolean;
  T: string;
begin
  { а есть ли таблица }
  if FGrid = nil then
  begin
    inherited Paint;
    Exit;
  end;
  { получаем шрифт ячейки }
  FGrid.GetCellColors(FGrid.FTipsCell, Canvas);
  { подправляем цвета }
  Canvas.Brush.Color := Color;
  Canvas.Font.Color := clInfoText;
  { параметры отрисовки }
  with FGrid do
  begin
    TI := GetCellTextIndent(FTipsCell);
    A := Columns[FTipsCell.Col].Alignment;
    WR := Columns[FTipsCell.Col].WantReturns;
    WW := Columns[FTipsCell.Col].WordWrap;
    T := FTipsText;
  end;
  { рисуем текст }
  FGrid.PaintText(Canvas, ClientRect, TI.X, TI.Y, A, WR, WW, T);
end;

procedure TGridTipsWindow.ActivateHint(Rect: TRect; const AHint: string);
const
  Flags = SWP_SHOWWINDOW or SWP_NOACTIVATE;
begin
  Caption := AHint;
  UpdateBoundsRect(Rect);
  SetWindowPos(Handle, HWND_TOPMOST, Rect.Left, Rect.Top, Width, Height, Flags);
  Invalidate;
end;

{$IFNDEF VER90}

procedure TGridTipsWindow.ActivateHintData(Rect: TRect; const AHint: string; AData: Pointer);
begin
  FGrid := AData;
  inherited ActivateHintData(Rect, AHint, AData);
end;

function TGridTipsWindow.CalcHintRect(MaxWidth: Integer; const AHint: string; AData: Pointer): TRect;
var
  R: TRect;
begin
  { ссылка на таблицу }
  FGrid := AData;
  { есть ли таблица }
  if FGrid = nil then
  begin
    Result := inherited CalcHintRect(MaxWidth, AHint, AData);
    Exit;
  end;
  { прямоугольник подсказки }
  R := FGrid.GetTipsRect(FGrid.FTipsCell);
  { подправляем положение, учитываем бордюр }
  OffsetRect(R, -R.Left, -R.Top);
  { результат }
  Result := R;
end;

{$ENDIF}

{ TCustomGridView }

constructor TCustomGridView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := [csCaptureMouse, csClickEvents, csDoubleClicks, csOpaque];
  Width := 185;
  Height := 105;
  Color := clWindow;
  ParentColor := False;
  TabStop := True;
  FHorzScrollBar := CreateScrollBar(sbHorizontal);
  FHorzScrollBar.OnScroll := HorzScroll;
  FHorzScrollBar.OnChange := HorzScrollChange;
  FVertScrollBar := CreateScrollBar(sbVertical);
  FVertScrollBar.LineSize := 17;
  FVertScrollBar.OnScroll := VertScroll;
  FVertScrollBar.OnChange := VertScrollChange;
  FHeader := CreateHeader;
  FHeader.OnChange := HeaderChange;
  FColumns := CreateColumns;
  FColumns.OnChange := ColumnsChange;
  FRows := CreateRows;
  FRows.OnChange := RowsChange;
  FFixed := CreateFixed;
  FFixed.OnChange := FixedChange;
  FImagesLink := TChangeLink.Create;
  FImagesLink.OnChange := ImagesChange;
  FBorderStyle := bsSingle;
  FShowHeader := True;
  FGridLines := True;
  FGridLineWidth := 1; { <- не менять !!! }
  FGridStyle := [gsHorzLine, gsVertLine];
  FGridColor := clSilver;
  FEndEllipsis := True;
  FImageLeftIndent := 2;
  FImageTopIndent := 1;
  FTextLeftIndent := 6;
  FTextRightIndent := 6;
  FTextTopIndent := 2;
  FShowFocusRect := True;
  FRightClickSelect := True;
  FAllowSelect := True;
  FCursorKeys := [gkArrows, gkMouse];
  FColumnsSizing := True;
  FColumnClick := True;
  FEditCell := GridCell(-1, -1);
  FCheckStyle := csWin95;
  FCheckWidth := 16;
  FCheckHeight := 16;
  FCheckLeftIndent := 0;
  FCheckTopIndent := 0;
  FCheckBitmapCB := TBitmap.Create;
  FCheckBitmapCB.LoadFromResourceName(HInstance, 'BM_GRIDVIEW_CB');
  FCheckBitmapRB := TBitmap.Create;
  FCheckBitmapRB.LoadFromResourceName(HInstance, 'BM_GRIDVIEW_RB');
  FCheckBuffer := TBitmap.Create;
  FSortLeftIndent := 10;
  FSortTopIndent := 0;
  FSortBitmapA := TBitmap.Create;
  FSortBitmapA.LoadFromResourceName(HInstance, 'BM_GRIDVIEW_SA');
  FSortBitmapD := TBitmap.Create;
  FSortBitmapD.LoadFromResourceName(HInstance, 'BM_GRIDVIEW_SD');
  FSortBuffer := TBitmap.Create;
  FPatternBitmap := TBitmap.Create;
  FPatternBitmap.Width := 2;
  FPatternBitmap.Height := 2;
  FCancelOnExit := True;
end;

destructor TCustomGridView.Destroy;
begin
  FreeandNil(FPatternBitmap);
  FreeandNil(FSortBuffer);
  FreeandNil(FSortBitmapD);
  FreeandNil(FSortBitmapA);
  FreeandNil(FCheckBuffer);
  FreeandNil(FCheckBitmapRB);
  FreeandNil(FCheckBitmapCB);
  FreeandNil(FImagesLink);
  inherited Destroy;
  FreeandNil(FFixed);
  FreeandNil(FRows);
  FreeandNil(FColumns);
  FreeandNil(FHeader);
  FreeandNil(FHorzScrollBar);
  FreeandNil(FVertScrollBar);
end;

function TCustomGridView.GetCell(Col, Row: Longint): string;
begin
  Result := GetCellText(GridCell(Col, Row));
end;

function TCustomGridView.GetChecked(Col, Row: Longint): Boolean;
begin
  Result := GetCheckState(GridCell(Col, Row)) in [cbChecked, cbGrayed];
end;

function TCustomGridView.GetCol: Longint;
begin
  Result := CellFocused.Col;
end;

function TCustomGridView.GetFixed: TGridFixed;
begin
  Result := TGridFixed(FFixed);
end;

function TCustomGridView.GetEdit: TGridEdit;
begin
  Result := TGridEdit(FEdit);
end;

function TCustomGridView.GetEditColumn: TGridColumn;
begin
  Result := nil;
  if (EditCell.Col >= 0) and (EditCell.Col < Columns.Count) then Result := Columns[EditCell.Col];
end;

function TCustomGridView.GetEditDropDown: Boolean;
begin
  Result := (Edit <> nil) and Edit.DropListVisible;
end;

function TCustomGridView.GetEditing: Boolean;
begin
  Result := FEditing and (FEdit <> nil);
end;

function TCustomGridView.GetHeader: TGridHeader;
begin
  Result := TGridHeader(FHeader);
end;

function TCustomGridView.GetLeftCol: Longint;
begin
  Result := VisOrigin.Col;
end;

function TCustomGridView.GetRow: Longint;
begin
  Result := CellFocused.Row;
end;

function TCustomGridView.GetRows: TGridRows;
begin
  Result := TGridRows(FRows);
end;

function TCustomGridView.GetTopRow: Longint;
begin
  Result := VisOrigin.Row;
end;

function TCustomGridView.GetVisibleColCount: Longint;
begin
  Result := VisSize.Col;
end;

function TCustomGridView.GetVisibleRowCount: Longint;
begin
  Result := VisSize.Row;
end;

procedure TCustomGridView.ColumnsChange(Sender: TObject);
begin
  if [csReading, csLoading] * ComponentState = [] then
  begin
    { подправляем фиксированные и заголовок }
    UpdateFixed;
    UpdateHeader;
    { сбрасываем флаг синхронизации заголовка }
    if not Header.AutoSynchronize then Header.Synchronized := False;
  end;
  { подправляем параметры }
  UpdateScrollBars;
  UpdateVisOriginSize;
  UpdateCursor;
  UpdateEdit(Editing);
  { перерисовываем таблицу }
  Invalidate;
  { событие }
  ChangeColumns;
end;

procedure TCustomGridView.FixedChange(Sender: TObject);
begin
  UpdateRows;
  UpdateScrollBars;
  UpdateVisOriginSize;
  UpdateCursor;
  UpdateEdit(Editing);
  Invalidate;
  ChangeFixed; 
end;

procedure TCustomGridView.HeaderChange(Sender: TObject);
begin
  UpdateScrollBars;
  UpdateVisOriginSize;
  UpdateEdit(Editing);
  Invalidate;
end;

procedure TCustomGridView.HorzScroll(Sender: TObject; ScrollCode: Integer; var ScrollPos: Integer);
begin
  Application.CancelHint;
  if FocusOnScroll then UpdateFocus;
end;

procedure TCustomGridView.HorzScrollChange(Sender: TObject);
begin
  UpdateVisOriginSize;
  UpdateEdit(Editing);
end;

procedure TCustomGridView.ImagesChange(Sender: TObject);
begin
  InvalidateGrid;
  UpdateRows;
end;

procedure TCustomGridView.RowsChange(Sender: TObject);
begin
  { при изменении количества строк гасим подсказку }
  Application.CancelHint;
  { обновляем свойства }
  UpdateScrollBars;
  UpdateVisOriginSize;
  UpdateCursor;
  UpdateEdit(Editing);
  Invalidate;
  ChangeRows;
end;

procedure TCustomGridView.SetAllowEdit(Value: Boolean);
begin
  if FAllowEdit <> Value then
  begin
    FAllowEdit := Value;
    { гасим строку редактирвоания или построчное выделение }
    if not Value then
    begin
      AlwaysEdit := False;
      HideEdit;
    end
    else
      RowSelect := False;
    { событие }
    ChangeEditMode;
  end;
end;

procedure TCustomGridView.SetAllowSelect(Value: Boolean);
begin
  if FAllowSelect <> Value then
  begin
    FAllowSelect := Value;
    RowSelect := FRowSelect or (not Value);
    InvalidateFocus;
  end;
end;

procedure TCustomGridView.SetAlwaysEdit(Value: Boolean);
begin
  if FAlwaysEdit <> Value then
  begin
    FAlwaysEdit := Value;
    if Value then
    begin
      AllowEdit := True;
      Editing := True;
    end
    else
      HideEdit;
  end;
end;

procedure TCustomGridView.SetAlwaysSelected(Value: Boolean);
begin
  if FAlwaysSelected <> Value then
  begin
    FAlwaysSelected := Value;
    FCellSelected := FCellSelected or Value;
    InvalidateFocus;
  end;
end;

procedure TCustomGridView.SetBorderStyle(Value: TBorderStyle);
begin
  if FBorderStyle <> Value then
  begin
    FBorderStyle := Value;
    RecreateWnd;
  end;
end;

procedure TCustomGridView.SetCell(Col, Row: Longint; Value: string);
begin
  SetEditText(GridCell(Col, Row), Value);
end;

procedure TCustomGridView.SetCellFocused(Value: TGridCell);
begin
  SetCursor(Value, CellSelected, True);
end;

procedure TCustomGridView.SetCellSelected(Value: Boolean);
begin
  SetCursor(CellFocused, Value, True);
end;

procedure TCustomGridView.SetCheckBoxes(Value: Boolean);
begin
  if FCheckBoxes <> Value then
  begin
    FCheckBoxes := Value;
    UpdateRows;
    UpdateEdit(Editing);
    InvalidateGrid;
  end;
end;

procedure TCustomGridView.SetCheckLeftIndent(Value: Integer);
begin
  if FCheckLeftIndent <> Value then
  begin
    FCheckLeftIndent := Value;
    InvalidateGrid;
  end;
end;

procedure TCustomGridView.SetCheckStyle(Value: TGridCheckStyle);
begin
  if FCheckStyle <> Value then
  begin
    FCheckStyle := Value;
    InvalidateGrid;
  end;
end;

procedure TCustomGridView.SetCheckTopIndent(Value: Integer);
begin
  if FCheckTopIndent <> Value then
  begin
    FCheckTopIndent := Value;
    UpdateRows;
    UpdateEdit(Editing);
    InvalidateGrid;
  end;
end;

procedure TCustomGridView.SetCol(Value: Longint);
begin
  CellFocused := GridCell(Value, CellFocused.Row);
end;

procedure TCustomGridView.SetColumns(Value: TGridColumns);
begin
  FColumns.Assign(Value);
end;

procedure TCustomGridView.SetCursorKeys(Value: TGridCursorKeys);
begin
  { проверяем несовместимые флаги }
  if gkMouseMove in Value then Include(Value, gkMouse);
  if not (gkMouse in Value) then Exclude(Value, gkMouseMove);
  { устанавливаем значение }
  FCursorKeys := Value;
end;

procedure TCustomGridView.SetEditDropDown(Value: Boolean);
begin
  { переводим ячейку в режим редактирвания }
  Editing := True;
  { показываем выпадающий список }
  if Edit <> nil then Edit.DropListvisible := True;
end;

procedure TCustomGridView.SetEditing(Value: Boolean);
begin
  { проверяем начало редактирования }
  if Value and AllowEdit then
  begin
    { фокус на таблицу, показываем строку ввода }
    if AcquireFocus then ShowEdit;
  end
  { смотрим завершение ввода }
  else if (not Value) and FEditing then
  begin
    { проверяем текст, гасим строку }
    UpdateEditText;
    if not AlwaysEdit then HideEdit;
  end;
  { событие }
  ChangeEditing;
end;

procedure TCustomGridView.SetEndEllipsis(Value: Boolean);
begin
  if FEndEllipsis <> Value then
  begin
    FEndEllipsis := Value;
    InvalidateGrid;
  end;
end;

procedure TCustomGridView.SetFlatBorder(Value: Boolean);
begin
  if FFlatBorder <> Value then
  begin
    FFlatBorder := Value;
    RecreateWnd;
  end;
end;

procedure TCustomGridView.SetFlatScrollBars(Value: Boolean);
begin
  if FFlatScrollBars <> Value then
  begin
    { если описателья нет, то инициализация плоских скроллеров будет
      произведена в CreateWnd }
    if not HandleAllocated then
    begin
      FFlatScrollBars := Value;
      Exit;
    end;
    { инициализация плоских скроллеров }
    if not Value then UninitializeFlatSB(Handle)
    else if not InitializeFlatSB(Handle) then Value := False;
    { запоминаем значение }
    FFlatScrollBars := Value;
  end;
end;

procedure TCustomGridView.SetFixed(Value: TGridFixed);
begin
  FFixed.Assign(Value);
end;

procedure TCustomGridView.SetHeader(Value: TGridHeader);
begin
  FHeader.Assign(Value);
end;

procedure TCustomGridView.SetHideSelection(Value: Boolean);
begin
  if FHideSelection <> Value then
  begin
    FHideSelection := Value;
    InvalidateFocus;
  end;
end;

procedure TCustomGridView.SetHorzScrollBar(Value: TGridScrollBar);
begin
  FHorzScrollBar.Assign(Value);
end;

procedure TCustomGridView.SetGridColor(Value: TColor);
begin
  if FGridColor <> Value then
  begin
    FGridColor := Value;
    Invalidate;
  end;
end;

procedure TCustomGridView.SetGridLines(Value: Boolean);
begin
  if FGridLines <> Value then
  begin
    FGridLines := Value;
    UpdateRows;
    UpdateEdit(Editing);
    Invalidate;
  end;
end;

procedure TCustomGridView.SetGridStyle(Value: TGridStyles);
begin
  if FGridStyle <> Value then
  begin
    FGridStyle := Value;
    UpdateRows;
    UpdateEdit(Editing);
    Invalidate;
  end;
end;

procedure TCustomGridView.SetImageIndexDef(Value: Integer);
begin
  if FImageIndexDef <> Value then
  begin
    FImageIndexDef := Value;
    InvalidateGrid;
  end;
end;

procedure TCustomGridView.SetImageHighlight(Value: Boolean);
begin
  if FImageHighlight <> Value then
  begin
    FImageHighlight := Value;
    InvalidateGrid;
  end;
end;

procedure TCustomGridView.SetImageLeftIndent(Value: Integer);
begin
  if FImageLeftIndent <> Value then
  begin
    FImageLeftIndent := Value;
    InvalidateGrid;
  end;
end;

procedure TCustomGridView.SetImages(Value: TImageList);
begin
  if FImages <> Value then
  begin
    if Assigned(FImages) then FImages.UnRegisterChanges(FImagesLink);
    FImages := Value;
    if Assigned(FImages) then
    begin
      FImages.RegisterChanges(FImagesLink);
      FImages.FreeNotification(Self);
    end;
    { подправляем параметры }
    UpdateRows;
    UpdateEdit(Editing);
    { перерисовываем таблицу }
    InvalidateGrid;
  end;
end;

procedure TCustomGridView.SetImageTopIndent(Value: Integer);
begin
  if FImageTopIndent <> Value then
  begin
    FImageTopIndent := Value;
    UpdateRows;
    UpdateEdit(Editing);
    InvalidateGrid;
  end;
end;

procedure TCustomGridView.SetLeftCol(Value: Longint);
begin
  VisOrigin := GridCell(Value, VisOrigin.Row);
end;

procedure TCustomGridView.SetReadOnly(Value: Boolean);
begin
  if FReadOnly <> Value then
  begin
    FReadOnly := Value;
    UpdateEditContents(True);
  end;
end;

procedure TCustomGridView.SetRow(Value: Longint);
begin
  CellFocused := GridCell(CellFocused.Col, Value);
end;

procedure TCustomGridView.SetRows(Value: TGridRows);
begin
  FRows.Assign(Value);
end;

procedure TCustomGridView.SetRowSelect(Value: Boolean);
begin
  if FRowSelect <> Value then
  begin
    FRowSelect := Value;
    if Value then AllowEdit := False;
    AllowSelect := AllowSelect or (not Value);
    InvalidateGrid;
  end;
end;

procedure TCustomGridView.SetShowCellTips(Value: Boolean);
begin
  if FShowCellTips <> Value then
  begin
    FShowCellTips := Value;
    ShowHint := ShowHint or Value;
  end;
end;

procedure TCustomGridView.SetShowFocusRect(Value: Boolean);
begin
  if FShowFocusRect <> Value then
  begin
    FShowFocusRect := Value;
    InvalidateFocus;
  end;
end;

procedure TCustomGridView.SetShowHeader(Value: Boolean);
begin
  if FShowHeader <> Value then
  begin
    FShowHeader := Value;
    UpdateScrollBars;
    UpdateVisOriginSize;
    UpdateEdit(Editing);
    UpdateCursor;
    Invalidate;
  end;
end;

procedure TCustomGridView.SetSortLeftIndent(Value: Integer);
begin
  if FSortLeftIndent <> Value then
  begin
    FSortLeftIndent := Value;
    UpdateHeader;
    InvalidateHeader;
  end;
end;

procedure TCustomGridView.SetSortTopIndent(Value: Integer);
begin
  if FSortTopIndent <> Value then
  begin
    FSortTopIndent := Value;
    UpdateHeader;
    InvalidateHeader;
  end;
end;

procedure TCustomGridView.SetTextLeftIndent(Value: Integer);
begin
  if FTextLeftIndent <> Value then
  begin
    FTextLeftIndent := Value;
    UpdateEdit(Editing);
    InvalidateGrid;
  end;
end;

procedure TCustomGridView.SetTextRightIndent(Value: Integer);
begin
  if FTextRightIndent <> Value then
  begin
    FTextRightIndent := Value;
    UpdateEdit(Editing);
    InvalidateGrid;
  end;
end;

procedure TCustomGridView.SetTextTopIndent(Value: Integer);
begin
  if FTextTopIndent <> Value then
  begin
    FTextTopIndent := Value;
    UpdateRows;
    UpdateEdit(Editing);
    InvalidateGrid;
  end;
end;

procedure TCustomGridView.SetTopRow(Value: Longint);
begin
  VisOrigin := GridCell(VisOrigin.Col, Value);
end;

procedure TCustomGridView.SetVertScrollBar(Value: TGridScrollBar);
begin
  FVertScrollBar.Assign(Value);
end;

procedure TCustomGridView.SetVisOrigin(Value: TGridCell);
begin
  if (FVisOrigin.Col <> Value.Col) or (FVisOrigin.Row <> Value.Row) then
  begin
    FVisOrigin := Value;
    { подправляем положение движков скроллеров }
    UpdateScrollPos;
    UpdateVisOriginSize;
    { перерисовываем таблицу }
    Invalidate;
  end;
end;

procedure TCustomGridView.VertScroll(Sender: TObject; ScrollCode: Integer; var ScrollPos: Integer);
begin
  Application.CancelHint;
  if FocusOnScroll then UpdateFocus;
end;

procedure TCustomGridView.VertScrollChange(Sender: TObject);
begin
  UpdateVisOriginSize;
  UpdateEdit(Editing);
end;

procedure TCustomGridView.WMPaint(var Message: TWMPaint);
var
  DC, MemDC: HDC;
  MemBitmap, OldBitmap: HBITMAP;
  PS: TPaintStruct;
begin
  if DoubleBuffered and (Message.DC = 0) then
  begin
    DC := GetDC(0);
    MemBitmap := CreateCompatibleBitmap(DC, ClientRect.Right, ClientRect.Bottom);
    ReleaseDC(0, DC);
    MemDC := CreateCompatibleDC(0);
    OldBitmap := SelectObject(MemDC, MemBitmap);
    try
      DC := BeginPaint(Handle, PS);
      Perform(WM_ERASEBKGND, Longint(MemDC), Longint(MemDC));
      Message.DC := MemDC;
      WMPaint(Message);
      Message.DC := 0;
      { при буфферизированной отрисовке необходимо отсекать прямоугольник
        строки ввода, иначе он будет закрашиваться строкой ввода, что
        приводит к "миганию" }
      if Editing then
        with GetEditRect(EditCell) do
          ExcludeClipRect(DC, Left, Top, Right, Bottom);
      BitBlt(DC, 0, 0, ClientRect.Right, ClientRect.Bottom, MemDC, 0, 0, SRCCOPY);
      EndPaint(Handle, PS);
    finally
      SelectObject(MemDC, OldBitmap);
      DeleteDC(MemDC);
      DeleteObject(MemBitmap);
    end;
  end
  else
    inherited;
end;

procedure TCustomGridView.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  with Message do
  begin
    Result := DLGC_WANTARROWS;
    if not RowSelect then
    begin
      if gkTabs in CursorKeys then Result := Result or DLGC_WANTTAB;
      if AllowEdit then Result := Result or DLGC_WANTCHARS;
    end;
  end;
end;

procedure TCustomGridView.WMKillFocus(var Message: TWMKillFocus);
begin
  inherited;
  if Rows.Count > 0 then
  begin
    InvalidateFocus;
    if (FEdit <> nil) and (Message.FocusedWnd <> FEdit.Handle) then HideCursor;
  end;
end;

procedure TCustomGridView.WMSetFocus(var Message: TWMSetFocus);
begin
  inherited;
  if Rows.Count > 0 then
  begin
    InvalidateFocus;
    if (FEdit = nil) or ((Message.FocusedWnd <> FEdit.Handle) or (not FEdit.FDefocusing)) then ShowCursor;
  end;
end;

procedure TCustomGridView.WMLButtonDown(var Message: TMessage);
begin
  inherited;
  if FEdit <> nil then FEdit.FClickTime := GetMessageTime;
end;

procedure TCustomGridView.WMChar(var Msg: TWMChar);
begin
  { показываем строку ввода, если можно }
  if AllowEdit and (Char(Msg.CharCode) in [^H, #32..#255]) then
  begin
    ShowEditChar(Char(Msg.CharCode));
    Exit;
  end;
  { иначе обработка по умолчанию }
  inherited;
end;

procedure TCustomGridView.WMSize(var Message: TWMSize);
begin
  inherited;
{$IFNDEF EX_D4}
  Resize;
{$ENDIF}
end;

procedure TCustomGridView.WMHScroll(var Message: TWMHScroll);
begin
  if Message.ScrollBar = 0 then
    FHorzScrollBar.ScrollMessage(Message)
  else
    inherited;
end;

procedure TCustomGridView.WMVScroll(var Message: TWMVScroll);
begin
  if Message.ScrollBar = 0 then
    FVertScrollBar.ScrollMessage(Message)
  else
    inherited;
end;

procedure TCustomGridView.WMNCHitTest(var Message: TWMNCHitTest);
begin
  inherited;
  FHitTest := ScreenToClient(SmallPointToPoint(Message.Pos));
end;

procedure TCustomGridView.WMSetCursor(var Message: TWMSetCursor);
begin
  with Message, FHitTest do
    if not (csDesigning in ComponentState) then
    begin
      { идет ли изменение размера колонки }
      if FColResizing then
      begin
        Windows.SetCursor(Screen.Cursors[crHSplit]);
        Exit;
      end;
      { проверяем попадание на резделительную линию заголовка }
      if (HitTest = HTCLIENT) and ShowHeader then
        if PtInRect(GetHeaderRect, FHitTest) and (GetResizeSectionAt(X, Y) <> nil) then
        begin
          Windows.SetCursor(Screen.Cursors[crHSplit]);
          Exit;
        end;
    end;
  inherited;
end;

procedure TCustomGridView.WMEraseBkgnd(var Message: TWMEraseBkgnd);
begin
  Message.Result := 1;
end;

procedure TCustomGridView.CMCancelMode(var Message: TCMCancelMode); 
begin
  if FEdit <> nil then FEdit.WndProc(TMessage(Message));
  inherited;
end;

procedure TCustomGridView.CMEnabledChanged(var Message: TMessage);
begin
  inherited;
  Invalidate;
end;

procedure TCustomGridView.CMCtl3DChanged(var Message: TMessage);
begin
  if NewStyleControls and (FBorderStyle = bsSingle) then RecreateWnd;
  inherited;
end;

procedure TCustomGridView.CMFontChanged(var Message: TMessage);
begin
  { запоминаем шрифт }
  Canvas.Font := Font;
  { подправляем шрифт у заголовка и фиксированных, высоту строк }
  UpdateFonts;
  UpdateRows;
  { обработка по умолчанию }
  inherited;
end;

procedure TCustomGridView.CMColorChanged(var Message: TMessage);
begin
  { запоминаем цвет }
  Brush.Color := Color;
  { подправляем цвет у заголовка и фиксированных }
  UpdateColors;
  { обработка по умолчанию }
  inherited;
end;

procedure TCustomGridView.CMShowHintChanged(var Message: TMessage);
begin
  ShowCellTips := ShowCellTips and ShowHint;
end;

{$IFNDEF VER90}

procedure TCustomGridView.CMHintShow(var Message: TMessage);
var
  AllowTips: Boolean;
  R, TR: TRect;
  W: Integer;
begin
  with Message, PHintInfo(LParam)^ do
  begin
    if not ShowCellTips then
    begin
      inherited;
      Exit;
    end;
    { если не попали в таблицу - выход }
    if not PtInRect(GetGridRect, CursorPos) then
    begin
      Result := 1;
      Exit;
    end;
    { ищем ячейку, на которую указывает курсор }
    FTipsCell := GetCellAt(CursorPos.X, CursorPos.Y);
    { если не попали - подсказки нет, выход }
    if IsCellEmpty(FTipsCell) then
    begin
      Result := 1;
      Exit;
    end;
    { а не идет ли редактирование этой ячейки }
    if IsCellEqual(EditCell, FTipsCell) and Editing then
    begin
      Result := 1;
      Exit;
    end;
    { а нужны ли подсказки для ячейки }
    CellTips(FTipsCell, AllowTips);
    if not AllowTips then
    begin
      Result := 1;
      Exit;
    end;
    { получаем прямоугольник ячейки (без картинки) }
    R := GetCellHintRect(FTipsCell);
    { получаем прямоугольник текста ячейки }
    TR := GetCellTextBounds(FTipsCell);
    { смещаем его в соотвествии с выравниванием }
    W := TR.Right - TR.Left;
    case Columns[FTipsCell.Col].Alignment of
      taCenter:
        begin
          TR.Left := R.Left - (W - (R.Right - R.Left)) div 2;
          TR.Right := TR.Left + W;
        end;
      taRightJustify:
        begin
          TR.Right := R.Right;
          TR.Left := TR.Right - W;
        end;
    else
      TR.Left := R.Left;
      TR.Right := TR.Left + W;
    end;
    { учитываем видимую часть таблицы }
    IntersectRect(R, R, ClientRect);
    if ShowHeader then SubtractRect(R, R, GetHeaderRect);
    if FTipsCell.Col >= Fixed.Count then SubtractRect(R, R, GetFixedRect);
    { а вылезает ли текст за ячейку (слева, справа или по высоте) }
    if (TR.Left >= R.Left) and (TR.Right <= R.Right) and
      (TR.Bottom - TR.Top <= R.Bottom - R.Top) then
    begin
      Result := 1;
      Exit;
    end;
    { получаем текст подсказки }
    FTipsText := GetTipsText(FTipsCell);
    { получаем прямоугольник подсказки }
    R := GetTipsRect(FTipsCell);
    { настраиваем положение и текст подсказки }
    HintPos := ClientToScreen(R.TopLeft);
    HintStr := FTipsText;
    { настраиваем прямоугольник реакции мышки }
    R := GetCellRect(FTipsCell);
    if FTipsCell.Col < Fixed.Count then
    begin
      R.Left := MaxIntValue([R.Left, GetFixedRect.Left]);
      R.Right := MinIntValue([R.Right, GetFixedRect.Right]);
    end
    else
    begin
      R.Left := MaxIntValue([R.Left, GetFixedRect.Right]);
      R.Right := MinIntValue([R.Right, GetClientRect.Right]);
    end;
    InflateRect(R, 1, 1);
    CursorRect := R;
    { тип окна подсказки }
    HintWindowClass := GetTipsWindowClass;
    HintData := Self;
    { хинт можно показать }
    Result := 0;
  end;
end;

{$ELSE}

procedure TCustomGridView.CMHintShow(var Message: TMessage);
begin
  inherited;
end;

{$ENDIF}

function TCustomGridView.AcquireFocus: Boolean;
begin
  Result := True;
  { можно ли устанавливать фокус }
  if not (csDesigning in ComponentState) and CanFocus then
  begin
    UpdateFocus;
    Result := IsActiveControl;
  end;
end;

procedure TCustomGridView.CellClick(Cell: TGridCell; Shift: TShiftState; X, Y: Integer);
begin
  if Assigned(FOnCellClick) then FOnCellClick(Self, Cell, Shift, X, Y);
end;

procedure TCustomGridView.CellTips(Cell: TGridCell; var AllowTips: Boolean); 
begin
  AllowTips := True;
  if Assigned(FOnCellTips) then FOnCellTips(self, Cell, AllowTips);
end;

procedure TCustomGridView.Change(var Cell: TGridCell; var Selected: Boolean);
begin
  if Assigned(FOnChange) then FOnChange(Self, Cell, Selected);
end;

procedure TCustomGridView.ChangeColumns;
begin
  if Assigned(FOnChangeColumns) then FOnChangeColumns(Self);
end;

procedure TCustomGridView.ChangeEditing;
begin
  if Assigned(FOnChangeEditing) then FOnChangeEditing(Self);
end;

procedure TCustomGridView.ChangeEditMode;
begin
  if Assigned(FOnChangeEditMode) then FOnChangeEditMode(Self);
end;

procedure TCustomGridView.ChangeFixed;
begin
  if Assigned(FOnChangeFixed) then FOnChangeFixed(Self);
end;

procedure TCustomGridView.ChangeRows;
begin
  if Assigned(FOnChangeRows) then FOnChangeRows(Self);
end;

procedure TCustomGridView.ChangeScale(M, D: Integer);
var
  S: Boolean;
  I: Integer;
begin
  inherited ChangeScale(M, D);
  { а изменился ли масштаб }
  if M <> D then
  begin
    S := Header.Synchronized;
    try
      { подправляем ширину колонок }
      with Columns do
      begin
        BeginUpdate;
        try
          for I := 0 to Count - 1 do
          begin
            { пределы }
            Columns[I].FMaxWidth := MulDiv(Columns[I].FMaxWidth, M, D);
            Columns[I].FMinWidth := MulDiv(Columns[I].FMinWidth, M, D);
            { ширина }
            Columns[I].DefWidth := MulDiv(Columns[I].DefWidth, M, D);
          end;
        finally
          EndUpdate;
        end;
      end;
      { подправляем высоту строк }
      with Rows do
        Height := MulDiv(Height, M, D);
      { подправляем высоту секции заголовка и шрифта }
      with Header do
      begin
        SectionHeight := MulDiv(SectionHeight, M, D);
        if not GridFont then Font.Size := MulDiv(Font.Size, M, D);
      end;
      { подправляем высоту шрифта фиксированных }
      with Fixed do
        if not GridFont then Font.Size := MulDiv(Font.Size, M, D);
    finally
      Header.Synchronized := S;
    end;
  end;
end;

procedure TCustomGridView.Changing(var Cell: TGridCell; var Selected: Boolean);
begin
  if Assigned(FOnChanging) then FOnChanging(Self, Cell, Selected);
end;

procedure TCustomGridView.CheckClick(Cell: TGridCell);
begin
  if Assigned(FOnCheckClick) then FOnCheckClick(Self, Cell);
end;

procedure TCustomGridView.ColumnAutoSize(Column: Integer; var Width: Integer);
begin
  if Assigned(FOnColumnAutoSize) then FOnColumnAutoSize(Self, Column, Width);
end;

procedure TCustomGridView.ColumnResize(Column: Integer; var Width: Integer);
begin
  if Assigned(FOnColumnResize) then FOnColumnResize(Self, Column, Width);
end;

procedure TCustomGridView.ColumnResizing(Column: Integer; var Width: Integer);
begin
  if Assigned(FOnColumnResizing) then FOnColumnResizing(Self, Column, Width);
end;

function TCustomGridView.CreateColumn(Columns: TGridColumns): TCustomGridColumn;
begin
  Result := GetColumnClass.Create(Columns);
end;

function TCustomGridView.CreateColumns: TGridColumns;
begin
  Result := TGridColumns.Create(Self);
end;

function TCustomGridView.CreateEdit(EditClass: TGridEditClass): TCustomGridEdit;
begin
  { проверяем класс }
  if EditClass = nil then EditClass := TGridEdit;
  { создаем строку }
  Result := EditClass.Create(Self);
end;

function TCustomGridView.CreateFixed: TCustomGridFixed;
begin
  Result := TGridFixed.Create(Self);
end;

function TCustomGridView.CreateHeader: TCustomGridHeader;                 
begin
  Result := TGridHeader.Create(Self);
end;

function TCustomGridView.CreateHeaderSection(Sections: TGridHeaderSections): TGridHeaderSection;
begin
  Result := TGridHeaderSection.Create(Sections);
end;

procedure TCustomGridView.CreateParams(var Params: TCreateParams);
const
  BorderStyles: array[TBorderStyle] of DWORD = (0, WS_BORDER);
  FlatBorders: array[Boolean] of DWORD = (WS_EX_CLIENTEDGE, WS_EX_STATICEDGE);
begin
  inherited CreateParams(Params);
  with Params do
  begin
    Style := Style or WS_TABSTOP;
    Style := Style or BorderStyles[FBorderStyle];
    if FBorderStyle = bsSingle then
      if NewStyleControls and Ctl3D then
      begin
        Style := Style and not WS_BORDER;
        ExStyle := ExStyle or FlatBorders[FFlatBorder];
      end
      else
        Style := Style or WS_BORDER;
  end;
end;

function TCustomGridView.CreateRows: TCustomGridRows;
begin
  Result := TGridRows.Create(Self);
end;

function TCustomGridView.CreateScrollBar(Kind: TScrollBarKind): TGridScrollBar;
begin
  Result := TGridScrollBar.Create(Self, Kind);
end;

procedure TCustomGridView.CreateWnd;
begin
  inherited;
  { плоские скроллеры }
  if FFlatScrollBars and not InitializeFlatSB(Handle) then FFlatScrollBars := False;
  { обновляем скроллера }
  FHorzScrollBar.Update;
  FVertScrollBar.Update;
end;

procedure TCustomGridView.DoExit;
begin
  ResetClickPos;
  { устанавливаем текст и гасим строку редактирования }
  if CancelOnExit then Editing := False;
  { обработка по умолчанию }
  inherited DoExit;
end;

{$IFDEF EX_D4_UP}

function TCustomGridView.DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint): Boolean;
begin
  Result := inherited DoMouseWheelDown(Shift, MousePos);
  if (not Result) and (gkMouseWheel in CursorKeys) then
  begin
    SetCursor(GetCursorCell(CellFocused, goDown), True, True);
    Result := True;
  end;
end;

function TCustomGridView.DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): Boolean;
begin
  Result := inherited DoMouseWheelUp(Shift, MousePos);
  if (not Result) and (gkMouseWheel in CursorKeys) then
  begin
    SetCursor(GetCursorCell(CellFocused, goUp), True, True);
    Result := True;
  end;
end;

{$ENDIF}

procedure TCustomGridView.EditButtonPress(Cell: TGridCell);
begin
  if Assigned(FOnEditButtonPress) then FOnEditButtonPress(Self, Cell);
end;

procedure TCustomGridView.EditCanceled(Cell: TGridCell);
begin
  if Assigned(FOnEditCanceled) then FOnEditCanceled(Self, Cell);
end;

function TCustomGridView.EditCanModify(Cell: TGridCell): Boolean;
begin
  Result := not IsCellReadOnly(Cell);
  if Assigned(FOnEditCanModify) then FOnEditCanModify(Self, Cell, Result);
end;

function TCustomGridView.EditCanAcceptKey(Cell: TGridCell; Key: Char): Boolean;
begin
  Result := IsCellValid(Cell);
  if Assigned(FOnEditAcceptKey) then FOnEditAcceptKey(Self, Cell, Key, Result);
end;

function TCustomGridView.EditCanShow(Cell: TGridCell): Boolean;
begin
  { проверяем режим дизайна и загрузки }
  if [csReading, csLoading, csDesigning, csDestroying] * ComponentState <> [] then
  begin
    Result := False;
    Exit;
  end;
  { а есть ли ячейки }
  if (Columns.Count - Fixed.Count = 0) or (Rows.Count = 0) then
  begin
    Result := False;
    Exit;
  end;
  { результат }
  Result := HandleAllocated and AllowEdit and (AlwaysEdit or IsActiveControl);
end;

function TCustomGridView.EditCanUndo(Cell: TGridCell): Boolean;
begin
  Result := EditCanModify(Cell);
end;

procedure TCustomGridView.EditChange(Cell: TGridCell);
begin
  if Assigned(FOnEditChange) then FOnEditChange(Self, Cell);
end;

procedure TCustomGridView.EditCloseUp(Cell: TGridCell; ItemIndex: Integer; var Accept: Boolean);
begin
  if Assigned(FOnEditCloseUp) then FOnEditCloseUp(Self, Cell, ItemIndex, Accept);
end;

procedure TCustomGridView.EditSelectNext(Cell: TGridCell; var Value: string);
begin
  if Assigned(FOnEditSelectNext) then FOnEditSelectNext(Self, Cell, Value);
end;

procedure TCustomGridView.GetCellColors(Cell: TGridCell; Canvas: TCanvas);
begin
  { фиксированные ячейки }
  if Cell.Col < Fixed.Count then
  begin
    Canvas.Brush.Color := Fixed.Color;
    Canvas.Font := Fixed.Font;
  end
  else
  begin
    { обычная ячейка }
    Canvas.Brush.Color := Self.Color;
    Canvas.Font := Self.Font;
    { учитываем свойство Enabled для цвета текста }
    if not Enabled then Canvas.Font.Color := clGrayText;
    { выделенная ячейка }
    if Enabled and IsFocusAllowed and CellSelected and IsCellFocused(Cell) then
      { есть ли фокус на таблице }
      if Focused then
      begin
        Canvas.Brush.Color := clHighlight;
        Canvas.Font.Color := clHighlightText;
      end
      { надо ли гасить выделенную ячейку }
      else if not HideSelection then
      begin
        Canvas.Brush.Color := clBtnFace;
        Canvas.Font.Color := Font.Color;
      end;
  end;
  { событие пользователя }
  if Assigned(FOnGetCellColors) then FOnGetCellColors(Self, Cell, Canvas);
end;

function TCustomGridView.GetCellImage(Cell: TGridCell): Integer;
begin
  { а есть ли картинки }
  if not Assigned(Images) then
  begin
    Result := -1;
    Exit;
  end;
  { для первой картинки есть индекс, для остальных нет }
  if Cell.Col = GetFirstImageColumn then Result := ImageIndexDef else Result := -1;
  { событие пользователя }
  if Assigned(FOnGetCellImage) then FOnGetCellImage(Self, Cell, Result);
end;

function TCustomGridView.GetCellImageIndent(Cell: TGridCell): TPoint;
begin
  Result.X := ImageLeftIndent;
  Result.Y := ImageTopIndent;
  { учитываем 3D эффект }
  if (Fixed.Count > 0) and (not Fixed.Flat) then Inc(Result.Y, 1);
  { событие пользователя }
  if Assigned(FOnGetCellImageIndent) then FOnGetCellImageIndent(Self, Cell, Result);
end;

function TCustomGridView.GetCellImageRect(Cell: TGridCell): TRect;
var
  R: TRect;
begin
  { а есть ли картинка }
  if not IsCellHasImage(Cell) then
  begin
    Result := Rect(0, 0, 0, 0);
    Exit;
  end;
  { получаем прямоугольник ячейки }
  R := GetCellRect(Cell);
  { учитываем флажок }
  if IsCellHasCheck(Cell) then Inc(R.Left, CheckWidth + GetCheckIndent(Cell).X);
  { прямоугольник картинки }
  with Result do
  begin
    Left := R.Left + GetCellImageIndent(Cell).X;
    Right := MinIntValue([Left + Images.Width, R.Right]);
    Top := R.Top + GetCellImageIndent(Cell).Y;
    Bottom := R.Top + Images.Height;
  end;
end;

function TCustomGridView.GetCellHintRect(Cell: TGridCell): TRect;
begin
  Result := GetEditRect(Cell);
  if Assigned(FOnGetCellHintRect) then FOnGetCellHintRect(Self, Cell, Result);
end;

function TCustomGridView.GetCellText(Cell: TGridCell): string;
begin
  Result := '';
  if Assigned(FOnGetCellText) then FOnGetCellText(Self, Cell, Result);
end;

function TCustomGridView.GetCellTextBounds(Cell: TGridCell): TRect;
var
  R: TRect;
  TI: TPoint;
  A: TAlignment;
  WR, WW: Boolean;
  T: string;
begin
  { проверяем колонку ячейки }
  if (Cell.Col < 0) or (Cell.Col > Columns.Count - 1) then
  begin
    Result := Rect(0, 0, 0, 0);
    Exit;
  end;
  { определяем цвета }
  if (Cell.Row >= 0) and (Cell.Row < Rows.Count) then
  begin
    GetCellColors(Cell, Canvas);
    TI := GetCellTextIndent(Cell);
    T := GetCellText(Cell);
  end;
  { параметры отрисовки }
  R := Rect(0, 0, 0, 0);
  if Columns[Cell.Col].WordWrap then
  begin
    R := GetEditRect(Cell);
    OffsetRect(R, -R.Left, -R.Top);
    R.Bottom := R.Top;
  end;
  A := Columns[Cell.Col].Alignment;
  WR := Columns[Cell.Col].WantReturns;
  WW := Columns[Cell.Col].WordWrap;
  { вычисляем прямоугольник текста }
  Result := GetTextRect(Canvas, R, TI.X, TI.Y, A, WR, WW, T);
  { устанавливаем левый верхний угол в (0, 0) }
  OffsetRect(Result, -Result.Left, -Result.Top);
end;

function TCustomGridView.GetCellTextIndent(Cell: TGridCell): TPoint;
begin
  { значение по умолчанию }
  Result.X := TextLeftIndent;
  Result.Y := TextTopIndent;
  { учитываем картинки и 3D эффект }
  if IsCellHasCheck(Cell) or IsCellHasImage(Cell) then
  begin
    Result.X := 2;
    if (Fixed.Count > 0) and (not Fixed.Flat) then Inc(Result.Y, 1);
  end;
  { событие пользователя }
  if Assigned(FOnGetCellTextIndent) then FOnGetCellTextIndent(Self, Cell, Result);
end;

function TCustomGridView.GetCheckAlignment(Cell: TGridCell): TAlignment;
begin
  Result := taLeftJustify;
  if Assigned(FOnGetCheckAlignment) then FOnGetCheckAlignment(Self, Cell, Result);
end;

procedure TCustomGridView.GetCheckImage(Cell: TGridCell; CheckImage: TBitmap);
begin
  if Assigned(FOnGetCheckImage) then FOnGetCheckImage(Self, Cell, CheckImage);
end;

function TCustomGridView.GetCheckIndent(Cell: TGridCell): TPoint;
begin
  Result.X := CheckLeftIndent;
  Result.Y := CheckTopIndent;
  { учитываем 3D эффект }
  if (Fixed.Count > 0) and (not Fixed.Flat) then Inc(Result.Y, 1);
  { учитываем выравнивание флажка }
  if GetCheckAlignment(Cell) = taCenter then Result.X := (Columns[Cell.Col].Width - CheckWidth) div 2 - 1;
  { событие пользователя }
  if Assigned(FOnGetCheckIndent) then FOnGetCheckIndent(Self, Cell, Result);
end;

function TCustomGridView.GetCheckKind(Cell: TGridCell): TGridCheckKind;
begin
  Result := gcNone;
  if CheckBoxes and (Cell.Col >= 0) and (Cell.Col < Columns.Count) then
  begin
    Result := Columns[Cell.Col].CheckKind;
    if Assigned(FOnGetCheckKind) then FOnGetCheckKind(Self, Cell, Result);
  end;
end;

function TCustomGridView.GetCheckRect(Cell: TGridCell): TRect;
var
  R: TRect;
begin
  { а есть ли флажок }
  if not IsCellHasCheck(Cell) then
  begin
    Result := Rect(0, 0, 0, 0);
    Exit;
  end;
  { получаем прямоугольник ячейки }
  R := GetCellRect(Cell);
  { прямоугольник флажка }
  with Result do
  begin
    Left := R.Left + GetCheckIndent(Cell).X;
    Right := MinIntValue([Left + CheckWidth, R.Right]);
    Top := R.Top + GetCheckIndent(Cell).Y;
    Bottom := R.Top + CheckHeight;
  end;
end;

function TCustomGridView.GetCheckState(Cell: TGridCell): TCheckBoxState;
begin
  Result := cbUnchecked;
  if Assigned(FOnGetCheckState) then FOnGetCheckState(Self, Cell, Result);
end;

function TCustomGridView.GetClientOrigin: TPoint;
begin
  if Parent = nil then
    Result := GetClientRect.TopLeft
  else
    Result := inherited GetClientOrigin;
end;

function TCustomGridView.GetClientRect: TRect;
begin
  if Parent = nil then
    Result := Bounds(0, 0, Width, Height)
  else
    Result := inherited GetClientRect;
end;

function TCustomGridView.GetColumnClass: TGridColumnClass;
begin
  Result := TGridColumn;
end;

function TCustomGridView.GetCursorCell(Cell: TGridCell; Offset: TGridCursorOffset): TGridCell;

  function DoMoveLeft(O: Integer): TGridCell;
  var
    I: Integer;
    C: TGridCell;
  begin
    { новая активная колонка }
    I := MaxIntValue([Cell.Col - O, Fixed.Count]);
    { перебираем колонки до фиксированных, пока не устанвится активная }
    while I >= Fixed.Count do
    begin
      C := GridCell(I, Cell.Row);
      { пытаемся установить курсор }
      if IsCellAcceptCursor(C) then
      begin
        Result := C;
        Exit;
      end;
      { предыдущая колонка }
      Dec(I);
    end;
    { результат }
    Result := Cell;
  end;

  function DoMoveRight(O: Integer): TGridCell;
  var
    I: Integer;
    C: TGridCell;
  begin
    { новая активная колонка }
    I := MinIntValue([Cell.Col + O, Columns.Count - 1]);
    { перебираем колонки до последней, пока не устанвится активная }
    while I <= Columns.Count - 1 do
    begin
      C := GridCell(I, Cell.Row);
      { пытаемся установить курсор }
      if IsCellAcceptCursor(C) then
      begin
        Result := C;
        Exit;
      end;
      { следующая колонка }
      Inc(I);
    end;
    { результат }
    Result := Cell;
  end;

  function DoMoveUp(O: Integer): TGridCell;
  var
    J: Integer;
    C: TGridCell;
  begin
    { новая активная строка }
    J := MaxIntValue([Cell.Row - O, 0]);
    { перебираем строки до первой, пока не устанвится активная }
    while J >= 0 do
    begin
      C := GridCell(Cell.Col, J);
      { пытаемся установить курсор }
      if IsCellAcceptCursor(C) then
      begin
        Result := C;
        Exit;
      end;
      { предыдущая строка }
      Dec(J);
    end;
    { результат }
    Result := Cell;
  end;

  function DoMoveDown(O: Integer): TGridCell;
  var
    J: Integer;
    C: TGridCell;
  begin
    { новая активная строка }
    J := MinIntValue([Cell.Row + O, Rows.Count - 1]);
    { перебираем строки до последней, пока не устанвится активная }
    while J <= Rows.Count - 1 do
    begin
      C := GridCell(Cell.Col, J);
      { пытаемся установить курсор }
      if IsCellAcceptCursor(C) then
      begin
        Result := C;
        Exit;
      end;
      { следующая строка }
      Inc(J);
    end;
    { результат }
    Result := Cell;
  end;

  function DoMoveHome: TGridCell;
  var
    C: TGridCell;
  begin
    C := Cell;
    try
      Cell.Col := Fixed.Count;
      Result := DoMoveRight(0);
    finally
      Cell := C;
    end;
  end;

  function DoMoveEnd: TGridCell;
  var
    C: TGridCell;
  begin
    C := Cell;
    try
      Cell.Col := Columns.Count - 1;
      Result := DoMoveLeft(0);
    finally
      Cell := C;
    end;
  end;

  function DoMoveGridHome: TGridCell;
  var
    I, J: Integer;
    C: TGridCell;
  begin
    { новая активная колонка }
    I := Fixed.Count;
    { перебираем колонки до текущей, пока не устанвится активная }
    while I <= Cell.Col do
    begin
      { новая активная строка }
      J := 0;
      { перебираем строки до текущей, пока не устанвится активная }
      while J <= Cell.Row do
      begin
        C := GridCell(I, J);
        { пытаемся установить курсор }
        if IsCellAcceptCursor(C) then
        begin
          Result := C;
          Exit;
        end;
        { следующая строка }
        Inc(J);
      end;
      { следующая колонка }
      Inc(I);
    end;
    { результат }
    Result := Cell;
  end;

  function DoMoveGridEnd: TGridCell;
  var
    I, J: Integer;
    C: TGridCell;
  begin
    { новая активная колонка }
    I := Columns.Count - 1;
    { перебираем колонки до текущей, пока не устанвится активная }
    while I >= Cell.Col do
    begin
      J := Rows.Count - 1;
      { перебираем строки до текущей, пока не устанвится активная }
      while J >= Cell.Row do
      begin
        C := GridCell(I, J);
        { пытаемся установить курсор }
        if IsCellAcceptCursor(C) then
        begin
          Result := C;
          Exit;
        end;
        { предыдущая строка }
        Dec(J);
      end;
      { предыдущая колонка }
      Dec(I);
    end;
    { результат }
    Result := Cell;
  end;

  function DoSelect: TGridCell;

    function DoSelectLeft: TGridCell;
    var
      I: Integer;
      C: TGridCell;
    begin
      I := MaxIntValue([Cell.Col, Fixed.Count]);
      { перебираем колонки до текущей, пока не устанвится активная }
      while I <= CellFocused.Col do
      begin
        C := GridCell(I, Cell.Row);
        { пытаемся установить курсор }
        if IsCellAcceptCursor(C) then
        begin
          Result := C;
          Exit;
        end;
        { следующая колонка }
        Inc(I);
      end;
      { ячейка не найдена }
      Result := Cell;
    end;

    function DoSelectRight: TGridCell;
    var
      I: Integer;
      C: TGridCell;
    begin
      I := MinIntValue([Cell.Col, Columns.Count - 1]);
      { перебираем колонки до текущей, пока не устанвится активная }
      while I >= CellFocused.Col do
      begin
        C := GridCell(I, Cell.Row);
        { пытаемся установить курсор }
        if IsCellAcceptCursor(C) then
        begin
          Result := C;
          Exit;
        end;
        { предыдущая колонка }
        Dec(I);
      end;
      { ячейка не найдена }
      Result := Cell;
    end;

    function DoSelectUp: TGridCell;
    var
      J: Integer;
      C: TGridCell;
    begin
      J := MaxIntValue([Cell.Row, 0]);
      { перебираем строки до текущей, пока не устанвится активная }
      while J <= CellFocused.Row do
      begin
        C := GridCell(Cell.Col, J);
        { пытаемся установить курсор }
        if IsCellAcceptCursor(C) then
        begin
          Result := C;
          Exit;
        end;
        { следующая строка }
        Inc(J);
      end;
      { ячейка не найдена }
      Result := Cell;
    end;

    function DoSelectDown: TGridCell;
    var
      J: Integer;
      C: TGridCell;
    begin
      J := MinIntValue([Cell.Row, Rows.Count - 1]);
      { перебираем строки до текущей, пока не устанвится активная }
      while J >= CellFocused.Row do
      begin
        C := GridCell(Cell.Col, J);
        { пытаемся установить курсор }
        if IsCellAcceptCursor(C) then
        begin
          Result := C;
          Exit;
        end;
        { предыдущая строка }
        Dec(J);
      end;
      { ячейка не найдена }
      Result := Cell;
    end;

  begin
    { а доступна ли указанная ячейка }
    if IsCellAcceptCursor(Cell) then
    begin
      Result := Cell;
      Exit;
    end;
    { если выделение слева от курсора - ищем слева }
    if Cell.Col < CellFocused.Col then
    begin
      Result := DoSelectLeft;
      if IsCellAcceptCursor(Result) then Exit;
    end;
    { если выделение справа от курсора - ищем справа }
    if Cell.Col > CellFocused.Col then
    begin
      Result := DoSelectRight;
      if IsCellAcceptCursor(Result) then Exit;
    end;
    { если выделение над курсором - ищем сверху }
    if Cell.Row < CellFocused.Row then
    begin
      Result := DoSelectUp;
      if IsCellAcceptCursor(Result) then Exit;
    end;
    { выделение под курсором - ищем снизу }
    if Cell.Row > CellFocused.Row then
    begin
      Result := DoSelectDown;
      if IsCellAcceptCursor(Result) then Exit;
    end;
    { ничего не изменилось }
    Result := CellFocused;
  end;

  function DoFirst: TGridCell;
  var
    C: TGridCell;
    I, J: Integer;
  begin
    J := 0;
    { перебираем строки до текущей, пока не устанвится активная }
    while J <= Rows.Count - 1 do
    begin
      I := Fixed.Count;
      { перебираем колонки до последней, пока не устанвится активная }
      while I <= Columns.Count - 1 do
      begin
        C := GridCell(I, J);
        { пытаемся установить курсор }
        if IsCellAcceptCursor(C) then
        begin
          Result := C;
          Exit;
        end;
        { следующая  колонка }
        Inc(I);
      end;
      { следующая строка }
      Inc(J);
    end;
    { результат по умолчанию }
    Result := CellFocused;
  end;

  function DoNext: TGridCell;
  var
    C: TGridCell;
    I, J: Integer;
  begin
    I := Cell.Col + 1;
    J := Cell.Row;
    { перебираем строки до последней, пока не устанвится активная }
    while J <= Rows.Count - 1 do
    begin
      { перебираем колонки до последней, пока не устанвится активная }
      while I <= Columns.Count - 1 do
      begin
        C := GridCell(I, J);
        { пытаемся установить курсор, учитываем построчное выделение }
        if IsCellAcceptCursor(C) and ((not RowSelect) or (C.Row <> Cell.Row)) then
        begin
          Result := C;
          Exit;
        end;
        { следующая  колонка }
        Inc(I);
      end;
      { следующая строка с первой колонки }
      I := Fixed.Count;
      Inc(J);
    end;
    { результат по умолчанию }
    Result := CellFocused;
  end;

  function DoPrev: TGridCell;
  var
    C: TGridCell;
    I, J: Integer;
  begin
    I := Cell.Col - 1;
    J := Cell.Row;
    { перебираем строки до первой, пока не устанвится активная }
    while J >= 0 do
    begin
      { перебираем колонки до последней, пока не устанвится активная }
      while I >= Fixed.Count do
      begin
        C := GridCell(I, J);
        { пытаемся установить курсор, учитываем построчное выделение }
        if IsCellAcceptCursor(C) and ((not RowSelect) or (C.Row <> Cell.Row)) then
        begin
          Result := C;
          Exit;
        end;
        { предыдущая колонка }
        Dec(I);
      end;
      { предыдущая строка с последней колонки }
      I := Columns.Count - 1;
      Dec(J);
    end;
    { результат по умолчанию }
    Result := CellFocused;
  end;

begin
  case Offset of
    goLeft:
      { смещение на колонку влево }
      Result := DoMoveLeft(1);
    goRight:
      { смещение вправо на одну колонку }
      Result := DoMoveRight(1);
    goUp:
      { смещение вверх на одну колонку }
      Result := DoMoveUp(1);
    goDown:
      { смещение вниз на одну колонку }
      Result := DoMoveDown(1);
    goPageUp:
      { смещение на страницу вверх }
      Result := DoMoveUp(VisSize.Row - 1);
    goPageDown:
      { смещение на страницу вниз }
      Result := DoMoveDown(VisSize.Row - 1);
    goHome:
      { в начало строки }
      Result := DoMoveHome;
    goEnd:
      { в конец строки }
      Result := DoMoveEnd;
    goGridHome:
      { в начало таблицы }
      Result := DoMoveGridHome;
    goGridEnd:
      { в конец таблицы }
      Result := DoMoveGridEnd;
    goSelect:
      { проверка ячейки }
      Result := DoSelect;
    goFirst:
      { выбрать первую возможную ячейку }
      Result := DoFirst;
    goNext:
      { выбрать следующую ячейку }
      Result := DoNext;
    goPrev:
      { выбрать предыдущую возможную ячейку }
      Result := DoPrev;
  else
    { остальное игнорируем }
    Result := Cell;
  end;
end;

function TCustomGridView.GetEditClass(Cell: TGridCell): TGridEditClass;
begin
  Result := TGridEdit;
end;

procedure TCustomGridView.GetEditList(Cell: TGridCell; Items: TStrings);
begin
  if (Cell.Col >= 0) and (Cell.Col < Columns.Count) then
  begin
    with Columns[Cell.Col] do
      if (EditStyle = gePickList) and (FPickList <> nil) then Items.Assign(FPickList);
    if Assigned(FOnGetEditList) then FOnGetEditList(Self, Cell, Items);
  end;
end;

procedure TCustomGridView.GetEditListBounds(Cell: TGridCell; var Rect: TRect);
begin
  if Assigned(FOnGetEditListBounds) then FOnGetEditListBounds(Self, Cell, Rect);
end;

function TCustomGridView.GetEditMask(Cell: TGridCell): string;
begin
  Result := '';
  { проверяем колонку }
  if (Cell.Col >= 0) and (Cell.Col < Columns.Count) then
  begin
    Result := Columns[Cell.Col].EditMask;
    if Assigned(FOnGetEditMask) then FOnGetEditMask(Self, Cell, Result);
  end;
end;

function TCustomGridView.GetEditStyle(Cell: TGridCell): TGridEditStyle;
begin
  Result := geSimple;
  { проверяем колонку }
  if (Cell.Col >= 0) and (Cell.Col < Columns.Count) then
  begin
    Result := Columns[Cell.Col].EditStyle;
    if Assigned(FOnGetEditStyle) then FOnGetEditStyle(Self, Cell, Result);
  end;
end;

function TCustomGridView.GetEditText(Cell: TGridCell): string;
begin
  Result := GetCellText(Cell);
  if Assigned(FOnGetEditText) then FOnGetEditText(Self, Cell, Result);
end;

procedure TCustomGridView.GetHeaderColors(Section: TGridHeaderSection; Canvas: TCanvas);
begin
  { стандартные цвета }
  Canvas.Brush.Color := Header.Color;
  Canvas.Font := Header.Font;
  { событие пользователя }                                           
  if Assigned(FOnGetHeaderColors) then FOnGetHeaderColors(Self, Section, Canvas);
end;

function TCustomGridView.GetGridLineColor(BkColor: TColor): TColor;
const
  LineColors: array[Boolean] of TColor = (clSilver, clGray);
begin
  Result := FGridColor;
  if ColorToRGB(Result) = ColorToRGB(BkColor) then Result := Result xor clGray;
end;

function TCustomGridView.GetHeaderImage(Section: TGridHeaderSection): Integer;
begin
  { а есть ли картинки }
  if not Assigned(Header.Images) then
  begin
    Result := -1;
    Exit;
  end;
  { по умолчанию номер картинки - номер колонки }
  Result := Section.ColumnIndex;
  { событие пользователя }
  if Assigned(FOnGetHeaderImage) then FOnGetHeaderImage(Self, Section, Result);
end;

function TCustomGridView.GetSortDirection(Section: TGridHeaderSection): TGridSortDirection;
begin
  Result := gsNone;
  if Assigned(FOnGetSortDirection) then FOnGetSortDirection(Self, Section, Result);
end;

procedure TCustomGridView.GetSortImage(Section: TGridHeaderSection; SortImage: TBitmap);
begin
  if Assigned(FOnGetSortImage) then FOnGetSortImage(Self, Section, SortImage);
end;

function TCustomGridView.GetTextRect(Canvas: TCanvas; Rect: TRect; LeftIndent, TopIndent: Integer; Alignment: TAlignment; WantReturns, WordWrap: Boolean; const Text: string): TRect;
var
  R: TRect;
  P: TDrawTextParams;
  F, W, H, I: Integer;
begin
  { проверяем, как выводится текст: с помощью DrawTextEx или TextOut }
  if WantReturns or WordWrap or EndEllipsis then
  begin
    { параметры вывода текста }
    FillChar(P, SizeOf(P), 0);
    P.cbSize := SizeOf(P);
    P.iLeftMargin := LeftIndent;
    P.iRightMargin := TextRightIndent;
    { атрибуты текста }
    F := DT_NOPREFIX;
    { горизонтальное выравнивание }
    case Alignment of
      taLeftJustify: F := F or DT_LEFT;
      taCenter: F := F or DT_CENTER;
      taRightJustify: F := F or DT_RIGHT;
    end;
    { вертикальное выравнивание }
    if not (WantReturns or WordWrap) then
    begin
      { автоматическое выравнивание }
      F := F or DT_SINGLELINE or DT_VCENTER;
      { многоточие на конце не учитываем }
    end;
    { перенос слов }
    if WordWrap then F := F or DT_WORDBREAK;
    { прямоугольник текста }
    R := Rect;
    { рисуем текст }
    DrawTextEx(Canvas.Handle, PChar(Text), Length(Text), R, F or DT_CALCRECT, @P);
    { размеры текста }
    W := MaxIntValue([Rect.Right - Rect.Left, R.Right - R.Left]);
    H := MaxIntValue([Rect.Bottom - Rect.Top, R.Bottom - R.Top]);
  end
  else
  begin
    { смещение текста слева }
    I := LeftIndent;
    { высота и ширина текста }
    W := MaxIntValue([Rect.Right - Rect.Left, I + Canvas.TextWidth(Text) + TextRightIndent]);
    H := MaxIntValue([Rect.Bottom - Rect.Top, Canvas.TextHeight(Text)]);
  end;
  { формируем прямоугольник }
  case Alignment of
    taCenter:
      begin
        R.Left := Rect.Left - (W - (Rect.Right - Rect.Left)) div 2;
        R.Right := R.Left + W;
      end;
    taRightJustify:
      begin
        R.Right := Rect.Right;
        R.Left := R.Right - W;
      end;
  else
    R.Left := Rect.Left;
    R.Right := R.Left + W;
  end;
  R.Top := Rect.Top;
  R.Bottom := R.Top + H;
  { результат }
  Result := R;
end;

function TCustomGridView.GetTipsRect(Cell: TGridCell): TRect;
var
  R: TRect;
  TI: TPoint;
  A: TAlignment;
  WR, WW: Boolean;
  T: string;
begin
  { проверяем ячейку }
  if not IsCellValid(Cell) then
  begin
    Result := Rect(0, 0, 0, 0);
    Exit;
  end;
  { вычисляем прямоугольник }
  with GetTipsWindowClass.Create(Self) do
  try
    GetCellColors(Cell, Canvas);
    { параметры отрисовки }
    R := GetEditRect(Cell);
    TI := GetCellTextIndent(Cell);
    A := Columns[Cell.Col].Alignment;
    WR := Columns[Cell.Col].WantReturns;
    WW := Columns[Cell.Col].WordWrap;
    T := GetTipsText(Cell);
    { считаем прямоугольник }
    R := GetTextRect(Canvas, R, TI.X, TI.Y, A, WR, WW, T);
  finally
    Free;
  end;
  { для текста, больше, чем высота строки - поправка }
  if R.Bottom - R.Top > Rows.Height then Inc(R.Bottom, TextTopIndent * 2); {!}
  { учитываем бордюр }
  InflateRect(R, 1, 1);
  { результат }
  Result := R;
  if Assigned(FOnGetTipsRect) then FOnGetTipsRect(Self, Cell, Result); 
end;

function TCustomGridView.GetTipsText(Cell: TGridCell): string;
begin
  Result := GetCellText(Cell);
  if Assigned(FOnGetTipsText) then FOnGetTipsText(Self, Cell, Result); 
end;

function TCustomGridView.GetTipsWindowClass: TGridTipsWindowClass;
begin
  Result := TGridTipsWindow;
end;

procedure TCustomGridView.HeaderClick(Section: TGridHeaderSection);
begin
  if Assigned(FOnHeaderClick) then FOnHeaderClick(Self, Section);
end;

procedure TCustomGridView.HeaderClicking(Section: TGridHeaderSection; var AllowClick: Boolean);
begin
  { по умолчанию можно нажимать только нижние секции }
  AllowClick := ColumnClick and Section.AllowClick and (Section.Sections.Count = 0);
  { событие пользователя }
  if Assigned(FOnHeaderClicking) then FOnHeaderClicking(Self, Section, AllowClick);
end;

procedure TCustomGridView.HideCursor;
begin
  if IsFocusAllowed then InvalidateFocus else HideEdit;
end;

procedure TCustomGridView.HideEdit;
begin
  if FEdit <> nil then
  begin
    FEditCell := GridCell(-1, -1);
    FEdit.Hide;
  end;
end;

procedure TCustomGridView.HideFocus;
begin
  if IsFocusAllowed then PaintFocus;
end;

procedure TCustomGridView.KeyDown(var Key: Word; Shift: TShiftState);
const
  HomeOffsets: array[Boolean] of TGridCursorOffset = (goHome, goGridHome);
  EndOffsets: array[Boolean] of TGridCursorOffset = (goEnd, goGridEnd);
  TabOffsets: array[Boolean] of TGridCursorOffset = (goNext, goPrev);
var
  Cell: TGridCell;
begin
  { событие - пользователю }
  inherited KeyDown(Key, Shift);
  { разбираем стрелки }
  if gkArrows in CursorKeys then
    case Key of
      VK_LEFT:
        { курсор влево }
        begin
          SetCursor(GetCursorCell(CellFocused, goLeft), True, True);
          { если выделение построчное - скроллируем таблицу влево }
          if RowSelect then with HorzScrollBar do SetPosition(Position - LineStep);
        end;
      VK_RIGHT:
        { курсор вправо }
        begin
          SetCursor(GetCursorCell(CellFocused, goRight), True, True);
          { если выделение построчное - скроллируем таблицу вправо }
          if RowSelect then with HorzScrollBar do SetPosition(Position + LineStep);
        end;
      VK_UP:
        { курсор вверх }
        begin
          { если фокуса нет, то смещаем всю таблицу }
          if not AllowSelect then Cell := VisOrigin else Cell := CellFocused;
          { меняем выделенный }
          SetCursor(GetCursorCell(Cell, goUp), True, True);
        end;
      VK_DOWN:
        { курсор вниз }
        begin
          { если фокуса нет, то смещаем всю таблицу }
          if not AllowSelect then
          begin
            Cell := GridCell(VisOrigin.Col, VisOrigin.Row + VisSize.Row - 1);
            if not IsCellVisible(Cell, False) then Dec(Cell.Row);
          end
          else
            Cell := CellFocused;
          { меняем выделенный }
          SetCursor(GetCursorCell(Cell, goDown), True, True)
        end;
      VK_PRIOR:
        { курсор на страницу вверх }
        SetCursor(GetCursorCell(CellFocused, goPageUp), True, True);
      VK_NEXT:
        { курсор на страницу вниз }
        SetCursor(GetCursorCell(CellFocused, goPageDown), True, True);
      VK_HOME:
        { курсор в начало строки или таблицы }
        begin
          Cell := GetCursorCell(CellFocused, HomeOffsets[ssCtrl in Shift]);
          SetCursor(Cell, True, True);
        end;
      VK_END:
        { курсор в конец строки или таблицы }
        begin
          Cell := GetCursorCell(CellFocused, EndOffsets[ssCtrl in Shift]);
          SetCursor(Cell, True, True);
        end;
    end;
  { курсор на следующую или предыдущую ячейку при нажатии TAB }
  if (gkTabs in CursorKeys) and (Key = VK_TAB) then
    SetCursor(GetCursorCell(CellFocused, TabOffsets[ssShift in Shift]), True, True);
end;

procedure TCustomGridView.KeyPress(var Key: Char);
begin
  { обработка по умолчанию }
  inherited KeyPress(Key);
  { нажат ENTER - показываем строку ввода, если можно }
  if Key = #13 then
  begin
    Key := #0;
    { идет ли редактирование }
    if Editing then
    begin
      { вставляем текст, гасим строку ввода }
      ApplyEdit; 
      { курсор на следующую ячейку }
      if gkReturn in CursorKeys then
        SetCursor(GetCursorCell(CellFocused, goNext), True, True);
    end
    else
      { если строки нет - показываем ее }
      if not AlwaysEdit then
      begin
        { курсор - в ячейку }
        SetCursor(CellFocused, True, True); {?}
        { показываем строку ввода }
        Editing := True;
      end;
  end;
  { нажат ESC - закрываем строку ввода }
  if Key = #27 then
  begin
    Key := #0;
    { проверяем редактирование }
    if Editing then
      { гасим строку или восстанавливаем значение }
      if not AlwaysEdit then
        CancelEdit
      else
        UndoEdit;
  end;
end;

procedure TCustomGridView.Loaded;
begin
  inherited Loaded;
  { подправляем параметры }
  UpdateFixed;
  UpdateHeader;
  UpdateColors;
  UpdateFonts;
  UpdateEdit(AlwaysEdit);
  { ищем первую ячейку фокуса }
  FCellSelected := AlwaysSelected;
  UpdateCursor;
end;

procedure TCustomGridView.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  S: TGridHeaderSection;
  I, W: Integer;
  C, P: TGridCell;
begin
  { устанавливаем фокус на себя }
  if not AcquireFocus then
  begin
    MouseCapture := False;
    Exit;
  end;
  { проверяем нажатие на заголовок }
  if Button = mbLeft then
    { если заголовок виден и попали на него }
    if ShowHeader and PtInRect(GetHeaderRect, Point(X, Y)) then
    begin
      { попали ли мышкой на край секции заголовка }
      S := GetResizeSectionAt(X, Y);
      if S <> nil then
      begin
        if ssDouble in Shift then
        begin
          { устанавливаем ширину колонки равной максимальной ширине текста }
          I := S.ResizeColumnIndex;
          if I < Columns.Count then
          begin
            W := MinIntValue([Columns[I].MaxWidth, GetColumnMaxWidth(I)]);
            ColumnAutoSize(I, W);
            ColumnResize(I, W);
            FColResizing := True;
            try
              Columns[I].Width := W;
            finally
              FColResizing := False;
            end;
          end;
        end
        else
          { начинаем изменение размера }
          StartColResize(S, X, Y);
      end
      { щелчок на секции - только одинарный }
      else if not (ssDouble in Shift) then
      begin
        { попали ли мышкой на заголовок }
        S := GetSectionAt(X, Y);
        if S <> nil then
          { проверяем 3D эффект }
          if Header.Flat then
            { нажатие сразу }
            HeaderClick(S)
          else
            { начинаем нажатие размера }
            StartHeaderClick(S, X, Y);
      end;
      { щелкнули на заголовок - не пускаем дальше }
      Exit;
    end;
  { проверяем новую выделенную ячейку }
  if (Button = mbLeft) or ((Button = mbRight) and RightClickSelect) then
    { если можно выделять мышкой и попали на ячейки }
    if (gkMouse in CursorKeys) and (PtInRect(GetGridRect, Point(X, Y))) then
    begin
      C := GetCellAt(X, Y);
      { сбрасываем ячейку последнего щелчка (из-за возможности Exit) }
      P := FClickPos;
      FClickPos := GridCell(-1, -1);
      { смортим куда попали }
      if IsCellEmpty(C) then
      begin
        { никуда - гасим выделение курсора }
        Editing := False;
        SetCursor(CellFocused, False, False);
      end
      else
      begin
        { в ячейку - выделяем ее }
        SetCursor(C, True, True);
        CellClick(C, Shift, X, Y);
        { проверяем попадание на флажок }
        if PtInRect(GetCheckRect(C), Point(X, Y)) then
        begin
          CheckClick(C);
          Exit;
        end;
        { проверяем начало редактирования (толко левой кнопкой) }
        if (Button = mbLeft) and IsCellEqual(C, CellFocused) and AllowEdit then
          { редактирование по двойному или повторному щелчку на одной и
            той же ячейке }
          if (ssDouble in Shift) or IsCellEqual(C, P) then
          begin
            { показываем строку ввода }
            Editing := True;
            if Editing then Exit;
          end;
      end;
      { запоминаем позицию последнего щелчка }
      FClickPos := C;
    end;
  { правая клавиша }
  if Button = mbRight then
  begin
    { если идет изменение размера - прекратить }
    if FColResizing then
    begin
      { прекращаем изменение }
      StopColResize(True);
      { не пускаем дальше }
      Exit;
    end;
    { если идет нажатие на заголовок - прекратить }
    if FHeaderClicking then
    begin
      { прекращаем изменение }
      StopHeaderClick(True);
      { не пускаем дальше }
      Exit;
    end;
  end;
  { обработчик по умолчанию }
  inherited MouseDown(Button, Shift, X, Y);
end;

procedure TCustomGridView.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  C: TGridCell;
begin
  { идет ли изменение размера колонки  }
  if FColResizing then
  begin
    { продолжаем изменение }
    StepColResize(X, Y);
    { не пускаем дальше }
    Exit;
  end;
  { идет ли нажатие на заголовок }
  if FHeaderClicking then
  begin
    { продолжаем нажатие  }
    StepHeaderClick(X, Y);
    { не пускаем дальше }
    Exit;
  end;
  { проверяем новую выделенную ячейку }
  if (ssLeft in Shift) or ((ssRight in Shift) and RightClickSelect) then
    { можно ли выделять мышкой }
    if gkMouseMove in CursorKeys then
    begin
      C := GetCellAt(X, Y);
      { а попали ли в новую ячейку }
      if (not IsCellEmpty(C)) and (not IsCellEqual(C, CellFocused)) then
      begin
        { выделяем новую ячейку }
        SetCursor(C, True, True);
        { проверяем начало редактирования }
        if IsCellEqual(C, CellFocused) and AlwaysEdit then
        begin
          Editing := True;
          if Editing then Exit; 
        end;
      end;
    end;
  { обработчик по умолчанию }
  inherited MouseMove(Shift, X, Y);
end;

procedure TCustomGridView.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  { идет ли изменение размера колонки }
  if FColResizing then
  begin
    { заканчиваем изменение }
    StopColResize(False);
    { не пускаем дальше }
    Exit;
  end;
  { идет ли нажатие на заголовок }
  if FHeaderClicking then
  begin
    { заканчиваем нажатие }
    StopHeaderClick(False);
    { не пускаем дальше }
    Exit;
  end;
  { обработчик по умолчанию }
  inherited MouseUp(Button, Shift, X, Y);
end;

procedure TCustomGridView.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then
  begin
    if AComponent = Images then Images := nil;
    if (Header <> nil) and (AComponent = Header.Images) then Header.Images := nil;
    if AComponent = FEdit then
    begin
      FEdit := nil;
      FEditCell := GridCell(-1, -1);
      FEditing := False;
    end;
  end;
end;

procedure TCustomGridView.Paint;
var
  DefDraw: Boolean;
  R: TRect;
begin
  { отрисовка пользователя }
  DefDraw := True;
  try
    if Assigned(FOnDraw) then FOnDraw(Self, DefDraw);
  except
    Application.HandleException(Self);
  end;
  { нужна ли отрисовка по умолчанию }
  if not DefDraw then Exit;
  { отсекаем неклиентскую область таблицы }
  with GetClientRect do
  begin
    ExcludeClipRect(Canvas.Handle, 0, Top, Left, Bottom);
    ExcludeClipRect(Canvas.Handle, Left, 0, Right, Top);
    ExcludeClipRect(Canvas.Handle, Right, Top, Width, Bottom);
    ExcludeClipRect(Canvas.Handle, Left, Bottom, Right, Height);
  end;
  { заголовок }
  if ShowHeader and RectVisible(Canvas.Handle, GetHeaderRect) then
  begin
    { фиксированная часть }
    PaintHeaders(True);
    { отсекаем прямоугольник фиксированного заголовка }
    with GetHeaderRect do
    begin
      R := GetFixedRect;
      ExcludeClipRect(Canvas.Handle, R.Left, Top, R.Right, Bottom);
    end;
    { обычная часть }
    PaintHeaders(False);
    { отсекаем прямоугольник заголовка }
    with GetHeaderRect do
      ExcludeClipRect(Canvas.Handle, Left, Top, Right, Bottom);
  end;
  { поле справа и снизу }
  PaintFreeField;
  { фиксированные ячейки }
  if (Fixed.Count > 0) and RectVisible(Canvas.Handle, GetFixedRect) then
  begin
    { ячейки }
    PaintFixed;
    { сетка }
    if GridLines then PaintFixedGrid;
    { отсекаем прямоугольник фиксированных }
    with GetFixedRect do
      ExcludeClipRect(Canvas.Handle, Left, Top, Right, Bottom);
  end;
  { обычные ячейки }
  if (VisSize.Col > 0) and (VisSize.Row > 0) then
  begin
    { отсекаем прямоугольник строки редактирования }
    if Editing then
      with GetEditRect(EditCell) do
        ExcludeClipRect(Canvas.Handle, Left, Top, Right, Bottom);
    { ячейки }
    PaintCells;
    { прямоугольник фокуса }
    if IsFocusAllowed then PaintFocus;
  end;
  { сетка }
  if GridLines then PaintGridLines;
  { линия изменения ширины столбца }
  if FColResizing and (FColResizeCount > 0) and not FColumnsFullDrag then PaintResizeLine;
end;

function GetRGBColor(Value: TColor): DWORD;
begin
  Result := ColorToRGB(Value);
  case Result of
    clNone: Result := CLR_NONE;
    clDefault: Result := CLR_DEFAULT;
  end;
end;

procedure TCustomGridView.Paint3DFrame(Rect: TRect; SideFlags: Longint);
begin
  PaintScrollBtnFrameEx(Canvas.Handle, Rect, False, SideFlags);
end;

procedure TCustomGridView.PaintCell(Cell: TGridCell; Rect: TRect);
var
  DefDraw: Boolean;
begin
  { устанавливаем цвета и шрифт ячейки }
  GetCellColors(Cell, Canvas);
  { отрисовка пользователя }
  DefDraw := True;
  try
    if Assigned(FOnDrawCell) then FOnDrawCell(Self, Cell, Rect, DefDraw);
  except
    Application.HandleException(Self);
  end;
  { нужна ли отрисовка по умолчанию }
  if DefDraw then DefaultDrawCell(Cell, Rect);
end;

procedure TCustomGridView.PaintCells;
var
  I, J: Integer;
  L, T, W: Integer;
  R: TRect;
  C: TGridCell;
begin
  { левая и верхняя краницы видимых ячеек }
  L := GetColumnRect(VisOrigin.Col).Left;
  T := GetRowRect(VisOrigin.Row).Top;
  { инициализируем верхнюю границу }
  R.Bottom := T;
  { перебираем строки }
  for J := 0 to FVisSize.Row - 1 do
  begin
    { смещаем прямоугольник по вертикали }
    R.Top := R.Bottom;
    R.Bottom := R.Bottom + Rows.Height;
    { инициализируем левую границу }
    R.Right := L;
    { пребираем колонки }
    for I := 0 to FVisSize.Col - 1 do
    begin
      { ячейка и ее ширина }
      C := GridCell(VisOrigin.Col + I, VisOrigin.Row + J);
      W := Columns[C.Col].Width;
      { рисуем только видимые ячейки }
      if W > 0 then
      begin
        { смещаем прямоугольник по горизонтали }
        R.Left := R.Right;
        R.Right := R.Right + W;
        { рисуем ячейку }
        if RectVisible(Canvas.Handle, R) then PaintCell(C, R);
      end;
    end;
  end;
end;

procedure TCustomGridView.PaintDotGridLines(Points: Pointer; Count: Integer);
var
  P: PIntArray absolute Points;
  I: Integer;
  R: TRect;
begin
  PreparePatternBitmap(Canvas, GetGridLineColor(Color), False);
  try
    { рисуем линии }
    I := 0;
    while I < Count * 2 do
    begin
      { координаты линии }
      R.Left := P^[I];
      Inc(I);
      R.Top := P^[I];
      Inc(I);
      R.Right := P^[I];
      Inc(I);
      R.Bottom := P^[I];
      Inc(I);
      { заливка не будет рисоваться, если ширина или высота прямоугольника
        нулевая }
      if (R.Left = R.Right) and (R.Top <> R.Bottom) then Inc(R.Right)
      else if (R.Left <> R.Right) and (R.Top = R.Bottom) then Inc(R.Bottom);
      { рисуем линию }
      Canvas.FillRect(R);
    end;
  finally
    PreparePatternBitmap(Canvas, GetGridLineColor(Color), True);
  end;
end;

procedure TCustomGridView.PaintFixed;
var
  I, J, W: Integer;
  R: TRect;
  C: TGridCell;
begin
  { верхняя граница строк }
  R.Bottom := GetRowRect(VisOrigin.Row).Top;
  { перебираем строки }
  for J := 0 to FVisSize.Row - 1 do
  begin
    R.Top := R.Bottom;
    R.Bottom := R.Bottom + Rows.Height;
    R.Right := GetGridRect.Left;
    { перебираем колонки }
    for I := 0 to Fixed.Count - 1 do
    begin
      C := GridCell(I, VisOrigin.Row + J);
      W := Columns[C.Col].Width;
      if W > 0 then
      begin
        R.Left := R.Right;
        R.Right := R.Right + W;
        if RectVisible(Canvas.Handle, R) then PaintCell(C, R);
      end;
    end;
  end;
  { полоска справа }
  if Fixed.Flat then
  begin
    R := GetFixedRect;
    { если цвета фиксированных и таблицы совпадают - рисуем полоску
      из одной линии  }
    if Fixed.GridColor then
    begin
      if not (gsDotLines in GridStyle) then
      begin
        Canvas.Pen.Color := GetGridLineColor(Color);
        Canvas.Pen.Width := FGridLineWidth;
        Canvas.MoveTo(R.Right - 1, R.Bottom - 1);
        Canvas.LineTo(R.Right - 1, R.Top - 1);
      end
      else
      begin
        R.Left := R.Right - 1;
        PaintDotGridLines(@R, 2);
      end;
    end
    else
      { иначе рисуем двойную полоску }
      with Canvas do
      begin
        Pen.Color := clBtnShadow;
        Pen.Width := 1;
        MoveTo(R.Right - 2, R.Top - 1);
        LineTo(R.Right - 2, R.Bottom);
        Pen.Color := clBtnHighlight;
        MoveTo(R.Right - 1, R.Bottom - 1);
        LineTo(R.Right - 1, R.Top - 1);
      end;
  end;
  { линия изменения ширины колонки }
  if FColResizing and (FColResizeCount > 0) and not FColumnsFullDrag then PaintResizeLine;
end;

procedure TCustomGridView.PaintFixedGrid;
var
  Points: PIntArray;
  PointCount: Integer;
  StrokeList: PIntArray;
  StrokeCount: Integer;
  I, L, R, T, B, X, Y, C, W: Integer;
  Index: Integer;
  Rect: TRect;

  procedure ShiftGridPoints(DX, DY: Integer);
  var
    I: Integer;
  begin
    I := 0;
    { сначала сдвигаем вертикальные линии по оси X }
    while I < Fixed.Count * Ord(gsVertLine in GridStyle) * 4 do
    begin
      if I mod 2 = 0 then Points^[I] := Points^[I] + DX;
      Inc(I);
    end;
    { потом - горизонтальные по оси Y }
    while I < PointCount * 2 do
    begin
      if I mod 2 = 1 then Points^[I] := Points^[I] + DY;
      Inc(I);
    end;
  end;

  procedure Paint3DCells(Rect: TRect);
  var
    I: Integer;
    R: TRect;
  begin
    R := Rect;
    R.Bottom := R.Top;
    { строки }
    while R.Bottom < Rect.Bottom do
    begin
      R.Top := R.Bottom;
      R.Bottom := R.Bottom + Rows.Height;
      R.Right := GetFixedRect.Left;
      { колонки }
      for I := 0 to Fixed.Count - 1 do
      begin
        W := Columns[I].Width;
        if W > 0 then
        begin
          R.Left := R.Right;
          R.Right := R.Right + W;
          if RectVisible(Canvas.Handle, R) then Paint3DFrame(R, BF_RECT);
        end;
      end;
    end;
  end;

  procedure PaintHorz3DLines(Rect: TRect);
  var
    R: TRect;
  begin
    R := Rect;
    R.Bottom := R.Top;
    { строки }
    repeat
      R.Top := R.Bottom;
      R.Bottom := R.Bottom + Rows.Height;
      if RectVisible(Canvas.Handle, R) then Paint3DFrame(R, BF_RECT);
    until R.Bottom >= Rect.Bottom;
  end;

  procedure PaintVert3DLines(Rect: TRect; DrawBottomLine: Boolean);
  const
    Flags: array[Boolean] of Longint = (BF_TOPLEFT or BF_RIGHT, BF_RECT);
  var
    I: Integer;
    R: TRect;
  begin
    R := Rect;
    R.Right := R.Left;
    { колонки }
    for I := 0 to Fixed.Count - 1 do
    begin
      W := Columns[I].Width;
      if W > 0 then
      begin
        R.Left := R.Right;
        R.Right := R.Right + W;
        if RectVisible(Canvas.Handle, R) then Paint3DFrame(R, Flags[DrawBottomLine]);
      end;
    end
  end;

  procedure PaintBottom3DMargin(Rect: TRect);
  begin
    if RectVisible(Canvas.Handle, Rect) then
      Paint3DFrame(Rect, BF_LEFT or BF_TOP or BF_RIGHT);
  end;

begin
  { надо ли рисовать плоскую сетку }
  if Fixed.Flat then
  begin
    { опрелеяем количество линий сетки }
    StrokeCount := 0;
    if gsHorzLine in GridStyle then
    begin
      StrokeCount := FVisSize.Row;
      if gsListViewLike in GridStyle then StrokeCount := GetGridHeight div Rows.Height;
    end;
    if gsVertLine in GridStyle then StrokeCount := StrokeCount + Fixed.Count;
    { а есть ли сетка }
    if StrokeCount > 0 then
    begin
      { опрелеяем количество точек сетки }
      PointCount := StrokeCount * 2;
      { выделяем память под линии }
      StrokeList := AllocMem(StrokeCount * SizeOf(Integer));
      Points := AllocMem(PointCount * SizeOf(TPoint));
      { инициализация массива количества точек полилиний }
      FillDWord(StrokeList^, StrokeCount, 2);
      Rect := GetFixedRect;
      { точки вертикальных линий }
      if gsVertLine in GridStyle then
      begin
        T := Rect.Top;
        B := Rect.Bottom;
        if [gsFullVertLine, gsListViewLike] * GridStyle = [] then B := GetRowRect(VisOrigin.Row + VisSize.Row).Top;
        X := Rect.Left;
        for I := 0 to Fixed.Count - 1 do
        begin
          X := X + Columns[I].Width;
          Index := I * 4;
          Points^[Index + 0] := X - 2;
          Points^[Index + 1] := T;
          Points^[Index + 2] := X - 2;
          Points^[Index + 3] := B;
        end;
      end;
      { точки горизонтальных линий }
      if gsHorzLine in GridStyle then
      begin
        L := Rect.Left;
        R := Rect.Right;
        Y := GetRowRect(VisOrigin.Row).Top;
        C := FVisSize.Row;
        if gsListViewLike in GridStyle then C := GetGridHeight div Rows.Height;
        for I := 0 to C - 1 do
        begin
          Y := Y + Rows.Height;
          Index := Fixed.Count * Ord(gsVertLine in GridStyle) * 4 + I * 4;
          Points^[Index + 0] := L;
          Points^[Index + 1] := Y - 2;
          Points^[Index + 2] := R;
          Points^[Index + 3] := Y - 2;
        end;
      end;
      { а двойные или одинарные линии }
      if Fixed.GridColor then
        { рисуем одинарную полоску }
        with Canvas do
        begin
          { сдвигаем линии (они расчитаны для первой двойной линии) }
          ShiftGridPoints(1, 1);
          { сетка }
          if not (gsDotLines in GridStyle) then
          begin
            Pen.Color := GetGridLineColor(Color);
            Pen.Width := FGridLineWidth;
            PolyPolyLine(Handle, Points^, StrokeList^, StrokeCount);
          end
          else
            PaintDotGridLines(Points, PointCount);
        end
      else
        { рисуем двойную полоску }
        with Canvas do
        begin
          { темные линии }
          Pen.Color := clBtnShadow;
          Pen.Width := 1;
          PolyPolyLine(Handle, Points^, StrokeList^, StrokeCount);
          { сдвигаем линии }
          ShiftGridPoints(1, 1);
          { светлые линии }
          Pen.Color := clBtnHighlight;
          PolyPolyLine(Handle, Points^, StrokeList^, StrokeCount);
        end;
      { освобождаем память }
      FreeMem(Points);
      FreeMem(StrokeList);
    end;
  end
  { надо ли рисовать все 3D ячейки }
  else if (gsHorzLine in GridStyle) and (gsVertLine in GridStyle) then
  begin
    Rect := GetFixedRect;
    if not (gsListViewLike in GridStyle) then Rect.Bottom := Rect.Top + FVisSize.Row * Rows.Height;
    { 3D ячейки }
    Paint3DCells(Rect);
    { оставшееся место }
    if not (gsListViewLike in GridStyle) then
    begin
      Rect.Top := Rect.Bottom;
      Rect.Bottom := GetFixedRect.Bottom;
      if gsFullVertLine in GridStyle then
        { только вертикальные линии }
        PaintVert3DLines(Rect, False)
      else
        { остаток снизу }
        PaintBottom3DMargin(Rect);
    end;
  end
  { надо ли рисовать только горизонтальные 3D полоски }
  else if (gsHorzLine in GridStyle) and (not (gsVertLine in GridStyle)) then
  begin
    Rect := GetFixedRect;
    if not (gsListViewLike in GridStyle) then Rect.Bottom := Rect.Top + FVisSize.Row * Rows.Height;
    { горизонтальные полоски }
    PaintHorz3DLines(Rect);
    { оставшееся место }
    if not (gsListViewLike in GridStyle) then
    begin
      Rect.Top := Rect.Bottom;
      Rect.Bottom := GetFixedRect.Bottom;
      PaintBottom3DMargin(Rect);
    end;
  end
  { надо ли рисовать только вертикальные 3D полоски }
  else if (not (gsHorzLine in GridStyle)) and (gsVertLine in GridStyle) then
  begin
    Rect := GetFixedRect;
    PaintVert3DLines(Rect, False);
  end
  else
  { просто 3D рамка вокруг фиксированных }
  begin
    Rect := GetFixedRect;
    PaintBottom3DMargin(Rect);
  end;
end;

procedure TCustomGridView.PaintFocus;
var
  R: TRect;
begin
  { а видим ли фокус }
  if ShowFocusRect and Focused and (VisSize.Row > 0) then
  begin
    { прямоугольник фокуса }
    R := GetFocusRect;
    { учитываем сетку }
    if GridLines then
    begin
      if gsVertLine in GridStyle then Dec(R.Right, FGridLineWidth);
      if gsHorzLine in GridStyle then Dec(R.Bottom, FGridLineWidth);
    end;
    { рисуем }
    with Canvas do
    begin
      { цвета }
      SetTextColor(Handle, ColorToRGB(clWhite));
      SetBkColor(Handle, ColorToRGB(clBlack));
      SetBkMode(Handle, OPAQUE);
      SetRop2(Handle, R2_COPYPEN);
      { отсекаем место под заголовок и фиксированные }
      with GetGridRect do
        IntersectClipRect(Handle, GetFixedRect.Right, Top, Right, Bottom);
      { фокус }
      DrawFocusRect(R);
    end;
  end;
end;

procedure TCustomGridView.PaintFreeField;
var
  X, Y: Integer;
  R: TRect;
begin
  { поле справа от таблицы }
  X := GetColumnRect(VisOrigin.Col + VisSize.Col).Left;
  R := GetGridRect;
  if X < R.Right then
  begin
    R.Left := X;
    with Canvas do
    begin
      Brush.Color := Color;
      FillRect(R);
    end;
  end;
  { поле снизу от таблицы }
  Y := GetRowRect(VisOrigin.Row + VisSize.Row).Top;
  R := GetGridRect;
  if Y < R.Bottom then
  begin
    R.Left := GetFixedRect.Right;
    R.Top := Y;
    with Canvas do
    begin
      Brush.Color := Color;
      FillRect(R);
    end;
    { поле под фиксированными }
    R.Right := R.Left;
    R.Left := GetFixedRect.Left;
    with Canvas do
    begin
      Brush.Color := Fixed.Color;
      FillRect(R);
    end;
  end;
  { линия изменения ширины столбца }
  if FColResizing and (FColResizeCount > 0) and not FColumnsFullDrag then PaintResizeLine;
end;

procedure TCustomGridView.PaintGridLines;
var
  Points: PIntArray;
  PointCount: Integer;
  StrokeList: PIntArray;
  StrokeCount: Integer;
  I: Integer;
  L, R, T, B, X, Y, C: Integer;
  Index: Integer;
  Rect: TRect;
begin
  { опрелеяем количество линий сетки }
  StrokeCount := 0;
  if gsHorzLine in GridStyle then
  begin
    StrokeCount := FVisSize.Row;
    if gsListViewLike in GridStyle then StrokeCount := GetGridHeight div Rows.Height;
  end;
  if gsVertLine in GridStyle then StrokeCount := StrokeCount + FVisSize.Col;
  { а есть ли сетка }
  if StrokeCount > 0 then
  begin
    { опрелеяем количество точек сетки }
    PointCount := StrokeCount * 2;
    { выделяем память под линии }
    StrokeList := AllocMem(StrokeCount * SizeOf(Integer));
    Points := AllocMem(PointCount * SizeOf(TPoint));
    { инициализация массива количества точек полилиний }
    FillDWord(StrokeList^, StrokeCount, 2);
    Rect := GetGridRect;
    { точки вертикальных линий }
    if gsVertLine in GridStyle then
    begin
      T := Rect.Top;
      B := Rect.Bottom;
      if [gsFullVertLine, gsListViewLike] * GridStyle = [] then B := GetRowRect(VisOrigin.Row + VisSize.Row).Top;
      X := GetColumnRect(VisOrigin.Col).Left;
      for I := 0 to FVisSize.Col - 1 do
      begin
        X := X + Columns[VisOrigin.Col + I].Width;
        Index := I * 4;
        Points^[Index + 0] := X - 1;
        Points^[Index + 1] := T;
        Points^[Index + 2] := X - 1;
        Points^[Index + 3] := B;
      end;
    end;
    { точки горизонтальных линий }
    if gsHorzLine in GridStyle then
    begin
      L := Rect.Left + GetFixedWidth;
      R := Rect.Right;
      if [gsFullHorzLine, gsListViewLike] * GridStyle = [] then R := GetColumnRect(VisOrigin.Col + VisSize.Col).Left;
      Y := GetRowRect(VisOrigin.Row).Top;
      C := FVisSize.Row;
      if gsListViewLike in GridStyle then C := GetGridHeight div Rows.Height;
      for I := 0 to C - 1 do
      begin
        Y := Y + Rows.Height;
        Index := FVisSize.Col * Ord(gsVertLine in GridStyle) * 4 + I * 4;
        Points^[Index + 0] := L;
        Points^[Index + 1] := Y - 1;
        Points^[Index + 2] := R;
        Points^[Index + 3] := Y - 1;
      end;
    end;
    { рисуем }
    if not (gsDotLines in GridStyle) then
    begin
      Canvas.Pen.Color := GetGridLineColor(Color);
      Canvas.Pen.Width := FGridLineWidth;
      PolyPolyLine(Canvas.Handle, Points^, StrokeList^, StrokeCount);
    end
    else
      PaintDotGridLines(Points, PointCount);
    { освобождаем память }
    FreeMem(Points);
    FreeMem(StrokeList);
  end;
end;

procedure TCustomGridView.PaintHeader(Section: TGridHeaderSection; Rect: TRect);
var
  DefDraw: Boolean;
begin
  { устанавливаем цвет и шрифт секции }
  GetHeaderColors(Section, Canvas);
  { отрисовка пользователя }
  DefDraw := True;
  try
    if Assigned(FOnDrawHeader) then FOnDrawHeader(Self, Section, Rect, DefDraw);
  except
    Application.HandleException(Self);
  end;
  { нужна ли отрисовка по умолчанию }
  if DefDraw then DefaultDrawHeader(Section, Rect);
end;

procedure TCustomGridView.PaintHeaders(DrawFixed: Boolean);
var
  R: TRect;
begin
  { подзаголовки }
  PaintHeaderSections(Header.Sections, DrawFixed);
  { оставшееся место справа }
  R := GetHeaderRect;
  R.Left := GetClientRect.Left + Header.GetWidth + GetGridOrigin.X;
  if R.Left < R.Right then
  begin
    Canvas.Brush.Color := Header.Color;
    Canvas.FillRect(R);
    if not Header.Flat then Paint3DFrame(R, BF_LEFT or BF_TOP or BF_BOTTOM);
  end;
  { серая полоска снизу }
  if Header.Flat then
  begin
    { подправляем края прямоугольника }
    if DrawFixed then
    begin
      R.Left := GetClientRect.Left;
      R.Right := GetFixedRect.Right;
    end
    else
    begin
      R.Left := GetFixedRect.Right;
      R.Right := GetClientRect.Right;
    end;
    { рисуем }
    with Canvas do
      { если цвета фиксированных и  таблицы совпадают - рисует обычную полоску }
      if Header.GridColor then
      begin
        Pen.Color := GetGridLineColor(Color);
        Pen.Width := FGridLineWidth;
        MoveTo(R.Left, R.Bottom - 1);
        LineTo(R.Right, R.Bottom - 1);
      end
      else
      { иначе рисуем двойную полоску }
      begin
      with Canvas do
      begin
        Pen.Color := clBtnShadow;
        Pen.Width := 1;
        MoveTo(R.Left, R.Bottom - 2);
        LineTo(R.Right, R.Bottom - 2);
        Pen.Color := clBtnHighlight;
        MoveTo(R.Left, R.Bottom - 1);
        LineTo(R.Right, R.Bottom - 1);
      end;
    end;
  end;
  { линия изменения ширины колонки }
  if FColResizing and (FColResizeCount > 0) and not FColumnsFullDrag then PaintResizeLine;
end;

procedure TCustomGridView.PaintHeaderSections(Sections: TGridHeaderSections; AllowFixed: Boolean);
var
  I: Integer;
  S: TGridHeaderSection;
  R, SR: TRect;
begin
  for I := 0 to Sections.Count - 1 do
  begin
    S := Sections[I];
    { рисуем только секции указанной "фиксированности" }
    if AllowFixed = S.FixedColumn then
    begin
      R := S.BoundsRect;
      { не рисуем, секции ненулевой ширины }
      if R.Right > R.Left then
      begin
        { вычисляем прямоугольник секции }
        SR := R;
        if S.Sections.Count > 0 then SR.Bottom := GetHeaderRect.Bottom;
        { рисуем только те секции и поззаголовки, которые надо перерисовывать }
        if RectVisible(Canvas.Handle, SR) then
        begin
          PaintHeader(S, R);
          PaintHeaderSections(S.Sections, AllowFixed);
        end;
      end;
    end
    else
      { некторые общие заголовки могут иметь одновременно фиксированные и
        нефиксированные подзаголовки (хотя это и неправильно), поэтому
        попробуем отрасовать их тоже }
      PaintHeaderSections(S.Sections, AllowFixed);
  end;
end;

procedure TCustomGridView.PaintResizeLine;
var
  OldPen: TPen;
begin
  OldPen := TPen.Create;
  try
    with Canvas do
    begin
      OldPen.Assign(Pen);
      try
        Pen.Color := clWhite;
        Pen.Style := psSolid;
        Pen.Mode := pmXor;
        Pen.Width := 1;
        with FColResizeRect do
        begin
          MoveTo(FColResizePos, Top);
          LineTo(FColResizePos, Bottom);
        end;
      finally
        Pen := OldPen;
      end;
    end;
  finally
    OldPen.Free;
  end;
end;

procedure TCustomGridView.PaintText(Canvas: TCanvas; Rect: TRect; LeftIndent, TopIndent: Integer; Alignment: TAlignment; WantReturns, WordWrap: Boolean; const Text: string);
var
  P: TDrawTextParams;
  F, DX: Integer;
  A: UINT;
begin
  { выводим текст }
  if WantReturns or WordWrap or EndEllipsis then
  begin
    { параметры вывода текста }
    FillChar(P, SizeOf(P), 0);
    P.cbSize := SizeOf(P);
    P.iLeftMargin := LeftIndent;
    P.iRightMargin := TextRightIndent;
    { атрибуты текста }
    F := DT_NOPREFIX;
    { горизонтальное выравнивание }
    case Alignment of
      taLeftJustify: F := F or DT_LEFT;
      taCenter: F := F or DT_CENTER;
      taRightJustify: F := F or DT_RIGHT;
    end;
    { вертикальное выравнивание }
    if not (WantReturns or WordWrap) then
    begin
      { автоматическое выравнивание }
      F := F or DT_SINGLELINE;
      { многоточие на конце }
      if Alignment = taLeftJustify then F := F or DT_END_ELLIPSIS
    end;
    { перенос слов }
    if WordWrap then F := F or DT_WORDBREAK;
    { смещение текста сверху }
    Inc(Rect.Top, TopIndent);
    { выводим текст }
    with Canvas do
    begin
      SetBkMode(Handle, TRANSPARENT);
      DrawTextEx(Handle, PChar(Text), Length(Text), Rect, F, @P);
    end;
  end
  else
  begin
    { смещение по горизонтали }
    case Alignment of
      taCenter:
        begin
          DX := LeftIndent + (Rect.Right - Rect.Left) div 2;
          A := TA_CENTER;
        end;
      taRightJustify:
        begin
          DX := (Rect.Right - Rect.Left) - TextRightIndent;
          A := TA_RIGHT;
        end;
    else
      DX := LeftIndent;
      A := TA_LEFT;
    end;                                                
    { стандартный вывод текста }
    with Canvas do
    begin
      SetBkMode(Handle, TRANSPARENT);
      SetTextAlign(Handle, A);
      ExtTextOut(Handle, Rect.Left + DX, Rect.Top + TopIndent, ETO_CLIPPED, @Rect, PChar(Text), Length(Text), nil);
      SetTextAlign(Handle, TA_LEFT);
    end;
  end;
end;

procedure TCustomGridView.PreparePatternBitmap(Canvas: TCanvas; FillColor: TColor; Remove: Boolean);
begin
  if Remove then
  begin
    if Canvas.Brush.Bitmap = nil then Exit;
    Canvas.Brush.Bitmap := nil;
  end
  else
  begin
    if Canvas.Brush.Bitmap = FPatternBitmap then Exit;
    { Линии точечками рисуются с использованием точечной заливки. Формат
      заливки устанавливается сразу на весь Canvas относительно верхнего
      левого угла компонента. Поэтому, даже заливая линию, сдвинутую на 1
      пиксел от предыдущей, мы все равно получим чередующуюся заливку.
      При горизонтальном смещение таблицы на 1 пиксел старая сетка смещается,
      и чтобы новая сетка рисовалась также чередующейся со старой, необходимо
      сместить и формат заливки. }
    if HorzScrollBar.Position mod 2 = 0 then
    begin
      FPatternBitmap.Canvas.Pixels[0, 0] := Color;
      FPatternBitmap.Canvas.Pixels[1, 1] := Color;
      FPatternBitmap.Canvas.Pixels[0, 1] := FillColor;
      FPatternBitmap.Canvas.Pixels[1, 0] := FillColor;
    end
    else
    begin
      FPatternBitmap.Canvas.Pixels[0, 0] := FillColor;
      FPatternBitmap.Canvas.Pixels[1, 1] := FillColor;
      FPatternBitmap.Canvas.Pixels[0, 1] := Color;
      FPatternBitmap.Canvas.Pixels[1, 0] := Color;
    end;
    { устанавливаем заливку }
    Canvas.Brush.Bitmap := FPatternBitmap;
  end;
  { обновляем полотно }
  Canvas.Refresh;
end;

procedure TCustomGridView.ResetClickPos;
begin
  FClickPos := GridCell(-1, -1);
end;

procedure TCustomGridView.Resize;
begin
  if UpdateLock = 0 then UpdateScrollBars;
  UpdateVisOriginSize;
  UpdateEdit(Editing);
{$IFDEF EX_D4_UP}
  inherited Resize;
{$ELSE}
  if Assigned(FOnResize) then FOnResize(Self);
{$ENDIF}
end;

procedure TCustomGridView.SetEditText(Cell: TGridCell; var Value: string);
begin
  if Assigned(FOnSetEditText) then FOnSetEditText(Self, Cell, Value);
end;

procedure TCustomGridView.ShowCursor;
begin
  if IsFocusAllowed then InvalidateFocus else ShowEdit;
end;

procedure TCustomGridView.ShowEdit;
begin
  UpdateEdit(True);
end;

procedure TCustomGridView.ShowEditChar(C: Char);
begin
  { показываем строку ввода }
  Editing := True;
  { вставляем символ }
  if (Edit <> nil) and Editing then PostMessage(Edit.Handle, WM_CHAR, Word(C), 0);
end;

procedure TCustomGridView.ShowFocus;
begin
  if IsFocusAllowed then PaintFocus;
end;

procedure TCustomGridView.StartColResize(Section: TGridHeaderSection; X, Y: Integer);
begin
  FColResizeSection := Section;
  FColResizeIndex := Section.ResizeColumnIndex;
  { вычисляем граничный прямоугольник для изменения размера }
  with FColResizeSection do
  begin
    { горизонтальные границы }
    if FColResizeIndex <= Columns.Count - 1 then
    begin
      FColResizeRect := GetColumnRect(FColResizeIndex);
      FColResizeRect.Bottom := GetClientRect.Bottom;
      FColResizeMinWidth := Columns[FColResizeIndex].MinWidth;
      FColResizeMaxWidth := Columns[FColResizeIndex].MaxWidth;
    end
    else
    begin
      FColResizeRect := BoundsRect;
      FColResizeRect.Bottom := GetClientRect.Bottom;
      FColResizeMinWidth := 0;
      FColResizeMaxWidth := 10000;
    end;
    { вертикальне границы }
    FColResizeRect.Top := Level * Header.SectionHeight;
    FColResizeRect.Bottom := Height;
  end;
  { положение линии размера }
  FColResizePos := FColResizeRect.Right;
  FColResizeOffset := FColResizePos - X;
  { можно изменять размер колонки }
  FColResizeCount := 0;
  FColResizing := True;
  { захватываем мышку }
  MouseCapture := True;
end;

procedure TCustomGridView.StepColResize(X, Y: Integer);
var
  W: Integer;
  R: TRect;
  S: TGridHeaderSection;
begin
  { а едет ли изменение размера колонки }
  if FColResizing then
  begin
    { текущее положение линии }
    X := X + FColResizeOffset;
    { текущая ширина }
    W := X - FColResizeRect.Left;
    { подправляем ширину в соотвествии с границами }
    if W < FColResizeMinWidth then W := FColResizeMinWidth;
    if W > FColResizeMaxWidth then W := FColResizeMaxWidth;
    ColumnResizing(FColResizeIndex, W);
    { опять подправляем шщирину }
    if W < FColResizeMinWidth then W := FColResizeMinWidth;
    if W > FColResizeMaxWidth then W := FColResizeMaxWidth;
    { новое положение линии }
    X := FColResizeRect.Left + W;
    { проводим линию }
    if FColResizePos <> X then
    begin
      { закрашиваем старую линию }
      if (FColResizeCount > 0) and not FColumnsFullDrag then PaintResizeLine;
      Inc(FColResizeCount);
      { новое положение линии }
      FColResizePos := X;
      { устанавливаем ширину }
      if FColumnsFullDrag and (FColResizeIndex < Columns.Count) then
      begin
        { перед изменение ширины столбца вычисляем и обновляем изменяющуюся
          часть ячеек таблицы }
        R := GetClientRect;
        R.Left := GetColumnRect(FColResizeIndex).Left;
        if FColResizeIndex >= Fixed.Count then
          { если нефиксированная колонка частично закрыта фиксированными,
            то эту закрытую часть перерисовывать не надо }
          R.Left := MaxIntValue([R.Left, GetFixedRect.Right]);
        if W < Columns[FColResizeIndex].Width then
          with HorzScrollBar do
            if (Range > PageStep) and (Position = Range - PageStep) then
              if FColResizeIndex < Columns.Count - 1 then
              begin
                { граничный случай: если горизонтальный скроллер в самом
                  правом положении, то уменьшение ширины колонки приводит к
                  сдвигу вправо всех нефиксированных колонок, расположенных
                  слева от текущей }
                R.Left := GetFixedRect.Right;
                R.Right := GetColumnRect(FColResizeIndex + 1).Left;
              end;
        InvalidateRect(R);
        { если у колонки многоуровневый заголовок, то дополнительно
          обновляем самую верхнюю секцию }
        S := GetHeaderSection(FColResizeIndex, 0);
        if S <> nil then
        begin
          R := S.BoundsRect;
          R.Bottom := GetHeaderRect.Bottom;
          InvalidateRect(R);
        end;
        { запрещаем перерисовку всей таблицы, устанавливаем новую ширину
          столбца  }
        LockUpdate;
        try
          Columns[FColResizeIndex].Width := W;
        finally
          UnlockUpdate(False);
        end;
        { теперь перерисовываем (лучше сразу - так меньше моргает) }
        Update;
      end
      else
        { рисуем новую линию }
        PaintResizeLine;
    end
    else
    begin
      { рисуем линию первый раз }
      if (FColResizeCount = 0) and not FColumnsFullDrag then PaintResizeLine;
      Inc(FColResizeCount);
    end;
  end;
end;

procedure TCustomGridView.StopColResize(Abort: Boolean);
var
  W: Integer;
begin
  if FColResizing then
  try
    { освобождаем мышку }
    MouseCapture := False;
    { было ли хотябы одно перемещение }
    if FColResizeCount > 0 then
    begin
      { закрашиваем линию }
      if not FColumnsFullDrag then PaintResizeLine;
      { а не прервано ли изменение }
      if Abort then Exit;
      { устанавливаем размер колонки }
      with FColResizeSection do
      begin
        { новая ширина }
        W := FColResizePos - FColResizeRect.Left;
        { подправляем ширину в соотвествии с границами }
        if W < FColResizeMinWidth then W := FColResizeMinWidth;
        if W > FColResizeMaxWidth then W := FColResizeMaxWidth;
        { событие пользователя }
        ColumnResize(FColResizeIndex, W);
        { опять подправляем шщирину }
        if W < FColResizeMinWidth then W := FColResizeMinWidth;
        if W > FColResizeMaxWidth then W := FColResizeMaxWidth;
        { устанавливаем ширину }
        if FColResizeIndex < Columns.Count then Columns[FColResizeIndex].Width := W;
        Width := W;
      end;
    end;
  finally
    FColResizing := False;
  end;
end;

procedure TCustomGridView.StartHeaderClick(Section: TGridHeaderSection; X, Y: Integer);
var
  AllowClick: Boolean;
begin
  { проверяем, можно ли нажимать секцию }
  AllowClick := True;
  HeaderClicking(Section, AllowClick);
  { проверяем результат }
  if AllowClick then
  begin
    { запоминаем параметры }
    FHeaderClickSection := Section;
    FHeaderClickRect := Section.BoundsRect;
    FHeaderClickState := False;
    FHeaderClicking := True;
    { захватываем мышку }
    MouseCapture := True;
    { нажимаем кнопку }
    StepHeaderClick(X, Y);
  end;
end;

procedure TCustomGridView.StepHeaderClick(X, Y: Integer);
var
  P: Boolean;
begin
  { а едет ли нажатие на секцию }
  if FHeaderClicking then
  begin
    { определяем признак нажатия }
    P := PtInRect(FHeaderClickRect, Point(X, Y));
    { изменилось ли что-нибудь }
    if FHeaderClickState <> P then
    begin
      FHeaderClickState := P;
      InvalidateRect(FHeaderClickRect);
    end;
  end;
end;

procedure TCustomGridView.StopHeaderClick(Abort: Boolean);
var
  P: Boolean;
begin
  { а едет ли нажатие на секцию }
  if FHeaderClicking then
  begin
    P := FHeaderClickState;
    { отжимаем кнопку }
    StepHeaderClick(-1, -1);
    { завершаем нажатие, отпускаем мышку }
    FHeaderClicking := False;
    MouseCapture := False;
    { вызываем событие }
    if (not Abort) and P then HeaderClick(FHeaderClickSection);
  end;
end;

procedure TCustomGridView.ApplyEdit;
begin
  Editing := False;
end;

procedure TCustomGridView.CancelEdit;
begin
  if Editing then
  begin
    { гасим строку или восстанавливаем значение }
    if not AlwaysEdit then HideEdit else UpdateEditContents(False);
    { ввод текста отменен }
    EditCanceled(EditCell);
  end;
end;

procedure TCustomGridView.DefaultDrawCell(Cell: TGridCell; Rect: TRect);
const
  DS: array[Boolean] of Longint = (ILD_NORMAL, ILD_SELECTED);
var
  DefRect: TRect;
  C: TGridCheckKind;
  CB: TBitmap;
  CR: TRect;
  I, X, Y, W, H: Integer;
  IDS: Longint;
  BKC, BLC: DWORD;
  R: TRect;
  RH, CH, IH, SH: Boolean;
  TI: TPoint;
  A: TAlignment;
  WR, WW: Boolean;
  T: string;
begin
  { запоминаем прямоугольник отрисовки }
  DefRect := Rect;
  { смещаем края чтобы не залить линии сетки }
  if GridLines then
  begin
    if gsVertLine in GridStyle then Dec(Rect.Right, FGridLineWidth);
    if gsHorzLine in GridStyle then Dec(Rect.Bottom, FGridLineWidth);
  end;
  { получаем тип флажка и номер картинки }
  C := GetCheckKind(Cell);
  I := GetCellImage(Cell);
  { определяем признак подсветки картинки: картинка не подсвечивается,
    если ячейка является первой выделенной, не выставлен флаг подсветки
    и цвет фона ячейки есть цвет выделенной }
  RH := RowSelect and (Cell.Col = Fixed.Count) and (Cell.Row = CellFocused.Row);
  CH := (not RowSelect) and IsCellEqual(Cell, CellFocused);
  SH := (Canvas.Brush.Color = clHighlight) or (Canvas.Brush.Color = clBtnFace); {?}
  IH := (not ImageHighlight) and (RH or CH) and SH;
  { рисуем флажок }
  if C <> gcNone then
  begin
    { для подсвеченного флажка восстанавливаем цвет фона }
    if IH then Canvas.Brush.Color := Color;
    { получаем прямоугольник флажка }
    R := Rect;
    R.Right := MinIntValue([R.Left + CheckWidth + GetCheckIndent(Cell).X, Rect.Right]);
    { а виден ли флажок }
    if R.Left < DefRect.Right then
    begin
      { рисуем }
      with Canvas do
      begin
        { положение флажка }
        X := R.Left + GetCheckIndent(Cell).X;
        Y := R.Top + GetCheckIndent(Cell).Y;
        { размер флажка (необходимо для отсечения флажков узких колонок) }
        W := CheckWidth;
        if X + W > R.Right then W := R.Right - X;
        H := CheckHeight;
        if Y + H > R.Bottom then H := R.Bottom - Y;
        { определяем вид флажка }
        if C <> gcUserDefine then
        begin
          { определяем серию картинок по типу флажка }
          CB := FCheckBitmapCB;
          if C = gcRadioButton then CB := FCheckBitmapRB;
          { определяем картинку флажка }
          CR := Bounds(CheckWidth * Ord(GetCheckState(Cell)), 0, W, H);
          OffsetRect(CR, CheckWidth * 4 * Ord(CheckStyle), 0);
          { рисуем влажок }                     
          FillRect(R);
          BrushCopy(Bounds(X, Y, W, H), CB, CR, CB.TransparentColor);
        end
        else
        begin
          CB := FCheckBuffer;
          { получаем флажок от пользователя }
          GetCheckImage(Cell, CB);
          { заливаем фон }
          FillRect(R);
          { рисуем }
          if not (CB.Empty or (CB.Width < 1) or (CB.Height < 1)) then
          begin
            CR := Bounds(0, 0, W, H);
            BrushCopy(Bounds(X, Y, W, H), CB, CR, CB.TransparentColor);
          end;
        end;
      end;
      { смещаем левый край исходного прямоугольника }
      Rect.Left := R.Right;
    end;
  end;
  { рисуем картинку }
  if I <> -1 then
  begin
    { для подсвеченной картинки восстанавливаем цвет фона }
    if IH then Canvas.Brush.Color := Color;
    { получаем прямоугольник картинки }
    R := Rect;
    R.Right := MinIntValue([R.Left + Images.Width + GetCellImageIndent(Cell).X, Rect.Right]);
    { а видна ли картинка }
    if R.Left < DefRect.Right then
    begin
      { положение картинки }
      X := R.Left + GetCellImageIndent(Cell).X;
      Y := R.Top + GetCellImageIndent(Cell).Y;
      { размер картинки (необходимо для отсечения картинок узких колонок) }
      W := Images.Width;
      if X + W > R.Right then W := R.Right - X;
      H := Images.Height;
      if Y + H > R.Bottom then H := R.Bottom - Y;
      { стиль и фоновые цвета картинки }
      IDS := DS[IsCellFocused(Cell) and CellSelected and Focused and IH];
      BKC := GetRGBColor(Images.BkColor);
      BLC := GetRGBColor(Images.BlendColor);
      { рисуем картинку }
      Canvas.FillRect(R);
      ImageList_DrawEx(Images.Handle, I, Canvas.Handle, X, Y, W, H, BKC, BLC, IDS);
      { смещаем левый край исходного прямоугольника }
      Rect.Left := R.Right;
    end;
  end;
  { восстанавливаем цвет фона }
  GetCellColors(Cell, Canvas);
  { рисуем текст, если не видна строка ввода }
  if not (IsCellEqual(Cell, FEditCell) and (not IsFocusAllowed)) then
  begin
    { получаем прямоугольник текста }
    R := Rect;
    { а виден ли текст }
    if R.Left < DefRect.Right then
      { рисуем }
      with Canvas do
      begin
        { параметры отрисовки текста }
        TI := GetCellTextIndent(Cell);
        A := Columns[Cell.Col].Alignment;
        WR := Columns[Cell.Col].WantReturns;
        WW := Columns[Cell.Col].WordWrap;
        T := GetCellText(Cell);
        { выводим текст }
        FillRect(R);
        PaintText(Canvas, R, TI.X, TI.Y, A, WR, WW, T);
      end;
  end;
end;

procedure TCustomGridView.DefaultDrawHeader(Section: TGridHeaderSection; Rect: TRect);
var
  DefRect: TRect;
  I, X, Y, W, H: Integer;
  BKC, BLC: DWORD;
  P: TDrawTextParams;
  F: Integer;
  T: string;
  TL: Integer;
  R: TRect;
  SD: TGridSortDirection;
  SB: TBitmap;
  SR: TRect;
begin
  { запоминаем прямоугольник отрисовки }
  DefRect := Rect;
  { заливаем оставшуюся часть }
  Canvas.FillRect(Rect);
  { если секция нажата - смещаем картинку и текст }
  if IsHeaderPressed(Section) then OffsetRect(Rect, 1, 1);
  { получаем номер картинки }
  I := GetHeaderImage(Section);
  { рисуем картинку, если она есть }                                                    
  if I <> -1 then
  begin
    { получаем прямоугольник картинки }
    R := Rect;
    R.Right := MinIntValue([R.Left + Header.Images.Width + 2, Rect.Right]);
    { а видна ли картинка }
    if R.Left < Rect.Right then
    begin
      { рисуем }
      with Canvas do
      begin
        { положение картинки }
        X := R.Left + 2;
        Y := R.Top + 1 + Ord(not Header.Flat);
        { размер картинки (необходимо для отсечения картинок узких секций) }
        W := Header.Images.Width;
        if X + W > R.Right then W := R.Right - X;
        H := Header.Images.Height;
        if Y + H > R.Bottom then H := R.Bottom - Y;
        { фоновые цвета картинки }
        BKC := GetRGBColor(Header.Images.BkColor);
        BLC := GetRGBColor(Header.Images.BlendColor);
        { рисуем картинку }
        ImageList_DrawEx(Header.Images.Handle, I, Canvas.Handle, X, Y, W, H, BKC, BLC, ILD_NORMAL);
      end;
      { смещаем левый край исходного прямоугольника }
      Rect.Left := R.Right;
    end;
  end;
  { а виден ли текст }
  if Rect.Left < Rect.Right then
  begin
    { получаем текст заголовка }
    T := Section.Caption;
    TL := Length(T);
    { для самой нижней секции получаем направление сортировки }
    SD := gsNone;
    if Section.Level = Header.MaxLevel then SD := GetSortDirection(Section);
    { рисуем }
    with Canvas do
    begin
      { параметры вывода текста }
      FillChar(P, SizeOf(P), 0);
      P.cbSize := SizeOf(P);
      P.iLeftMargin := 2 + 4 * Ord(I = -1);
      P.iRightMargin := 6;
      { выравнивание }
      F := DT_END_ELLIPSIS or DT_NOPREFIX;
      case Section.Alignment of
        taLeftJustify: F := F or DT_LEFT;
        taRightJustify: F := F or DT_RIGHT;
        taCenter: F := F or DT_CENTER;
      end;
      { перенос слов }
      if Section.WordWrap then F := F or DT_WORDBREAK;
      { если есть картинка сортировки - рисуем сначала ее }
      if SD <> gsNone then
      begin
        SB := FSortBuffer;
        { назначаем картинку по умолчанию }
        case SD of
          gsAscending: SB.Assign(FSortBitmapA);
          gsDescending: SB.Assign(FSortBitmapD);
        end;
        { если есть картинка пользователя - берем ее }
        GetSortImage(Section, SB);
        { размер картинки }
        W := SB.Width;
        H := SB.Height;
        { определяем ширину текста }
        R := Rect;
        if TL > 0 then
        begin
          DrawTextEx(Handle, PChar(T), Length(T), R, F or DT_CALCRECT, @P);
          R.Top := Rect.Top + ((Rect.Bottom - Rect.Top) - (R.Bottom - R.Top)) div 2;
        end
        else
        begin
          R.Right := R.Left;
          R.Top := Rect.Top + 2 * Ord(not Header.Flat);
        end;
        { вычисляем прямоугольник }
        SR.Left := MinIntValue([Rect.Right - W - 10, R.Right + SortLeftIndent]);
        SR.Left := MaxIntValue([Rect.Left + P.iLeftMargin, SR.Left]);
        SR.Right := MinIntValue([Rect.Right - 6, SR.Left + W]);
        SR.Top := R.Top + SortTopIndent;
        SR.Bottom := MinIntValue([Rect.Bottom, SR.Top + H]);
        { определяем новуые размеры картинки }
        W := SR.Right - SR.Left;
        H := SR.Bottom - SR.Top;
        { рисуем картинку }
        BrushCopy(SR, SB, Bounds(0, 0, W, H), clSilver);
        { подправляем прямоугольник текста }
        Rect.Right := SR.Left - SortLeftIndent;
      end;
      { рисуем текст }
      if (TL > 0) and (Rect.Left < Rect.Right) then
      begin
        { снова определяем прямоугольник текста }
        R := Rect;
        DrawTextEx(Handle, PChar(T), Length(T), R, F or DT_CALCRECT, @P);
        { для секций без картинок выравниваем текст по вертикали }
        if I = -1 then
          OffsetRect(R, 0, ((Rect.Bottom - Rect.Top) - (R.Bottom - R.Top)) div 2)
        else
          OffsetRect(R, 0, 2 + 2 * Ord(not Header.Flat));
        { подправляем левый и правый края }
        R.Right := Rect.Right;
        R.Left := Rect.Left;
        { выводим текст }
        SetBkMode(Handle, TRANSPARENT);
        DrawTextEx(Handle, PChar(T), Length(T), R, F, @P);
      end;
    end;
  end;
  { рисуем разделитель }
  with Canvas do
  begin
    Rect := DefRect;
    { определяем, что рисовать - кнопку или полоски }
    if Header.Flat then
    begin
      { если цвет заголовка и таблицы совпадает - рисует одинарную линию }
      if Header.GridColor then
      begin
        Pen.Color := GetGridLineColor(Color);
        Pen.Width := FGridLineWidth;
        { полоска снизу }
        MoveTo(Rect.Left, Rect.Bottom - 1);
        LineTo(Rect.Right - 1, Rect.Bottom - 1);
        { полоска справа }
        MoveTo(Rect.Right - 1, Rect.Top);
        LineTo(Rect.Right - 1, Rect.Bottom);
      end
      else
      begin
        Pen.Width := 1;
        { полоска снизу }
        Pen.Color := clBtnShadow;
        MoveTo(Rect.Left, Rect.Bottom - 2);
        LineTo(Rect.Right - 1, Rect.Bottom - 2);
        Pen.Color := clBtnHighlight;
        MoveTo(Rect.Left, Rect.Bottom - 1);
        LineTo(Rect.Right - 1, Rect.Bottom - 1);
        { полоска справа }
        Pen.Color := clBtnShadow;
        MoveTo(Rect.Right - 2, Rect.Top);
        LineTo(Rect.Right - 2, Rect.Bottom - 1);
        Pen.Color := clBtnHighlight;
        MoveTo(Rect.Right - 1, Rect.Top);
        LineTo(Rect.Right - 1, Rect.Bottom);
      end;
    end
    else
    begin
      { рисуем рамку кнопки }
      if IsHeaderPressed(Section) then
        DrawEdge(Handle, Rect, BDR_SUNKENOUTER, BF_RECT or BF_FLAT)
      else
        Paint3DFrame(Rect, BF_RECT);
      { подправляем прямоугольник секции }
      InflateRect(Rect, -2, -2);
    end;
  end;
end;

procedure TCustomGridView.DrawDragRect(Cell: TGridCell);
var
  R: TRect;
begin
  if IsCellVisible(Cell, True) then
  begin
    { прямоугольник ячейки }
    R := GetEditRect(Cell);
    { цвета }
    GetCellColors(CellFocused, Canvas);
    { рисуем }
    with Canvas do
    begin
      { отсекаем место под заголовок и фиксированные }
      with GetGridRect do
        IntersectClipRect(Handle, GetFixedRect.Right, Top, Right, Bottom);
      { фокус }
      DrawFocusRect(R);
    end;
  end;
end;

function TCustomGridView.FindText(const SearchStr: string; StartCell: TGridCell; Options: TFindOptions; var ResultCell: TGridCell): boolean;
var
  I, J, D, C: Integer;
  S: string;
begin
  { направление поиска, текущая строка и количество строк для поиска }
  if frDown in Options then
  begin
    D := 1;
    J := StartCell.Row + 1;
    C := Rows.Count - J;
  end
  else
  begin
    D := -1;
    J := StartCell.Row - 1;
    C := J + 1;
  end;
  { ищем }
  while C > 0 do
  begin
    { перебираем колонки }
    for I := 0 to Columns.Count - 1 do
      { сравниваем значения (только для видимых колонок) }
      if Columns[I].Width > 0 then
      begin
        S := Cells[I, J];
        { в пустой строке не ищем }
        if Length(S) = 0 then Continue;
        { сравниваем строки с учетом условий } 
        if CompareStrEx(SearchStr, S, frWholeWord in Options, frMatchCase in Options) then
        begin
          { нашли }
          ResultCell := GridCell(I, J);
          Result := True;
          { выход }
          Exit;
        end;
      end;
    { следующая строка }
    Inc(J, D);
    Dec(C);
  end;
  { не нашли }
  ResultCell := GridCell(-1, -1);
  Result := False;
end;

function TCustomGridView.GetCellAt(X, Y: Integer): TGridCell;
var
  C, R: Integer;
begin
  C := GetColumnAt(X, Y);
  R := GetRowAt(X, Y);
  if (C <> -1) and (R <> -1) then
  begin
    Result.Col := C;
    Result.Row := R;
  end
  else
  begin
    Result.Col := -1;
    Result.Row := -1;
  end;
end;

function TCustomGridView.GetCellRect(Cell: TGridCell): TRect;
begin
  IntersectRect(Result, GetColumnRect(Cell.Col), GetRowRect(Cell.Row));
end;

function TCustomGridView.GetCellsRect(Cell1, Cell2: TGridCell): TRect;
var
  CR, RR: TRect;
begin
  { проверяем границы }
  if (Cell2.Col < Cell1.Col) or (Cell2.Row < Cell1.Row) then
  begin
    Result := Rect(0, 0, 0, 0);
    Exit;
  end;
  { левая и правая границы }
  CR := GetColumnRect(Cell1.Col);
  if Cell2.Col > Cell1.Col then CR.Right := GetColumnRect(Cell2.Col).Right;
  { верхняя и нижняя границы }
  RR := GetRowRect(Cell1.Row);
  if Cell2.Row > Cell1.Row then RR.Bottom := GetRowRect(Cell2.Row).Bottom;
  { результат }
  Result.Left := CR.Left;
  Result.Right := CR.Right;
  Result.Top := CR.Top;
  Result.Bottom := CR.Bottom;
end;

function TCustomGridView.GetColumnAt(X, Y: Integer): Integer;
var
  L, R: Integer;
begin
  Result := 0;
  { ищем среди фиксированных }
  L := GetClientRect.Left;
  while Result <= Fixed.Count - 1 do
  begin
    R := L + Columns[Result].Width;
    if (R <> L) and (X >= L) and (X < R) then Exit;
    L := R;
    Inc(Result);
  end;
  { ищем среди обычных }
  L := L + GetGridOrigin.X;
  while Result <= Columns.Count - 1 do
  begin
    R := L + Columns[Result].Width;
    if (R <> L) and (X >= L) and (X < R) then Exit;
    L := R;
    Inc(Result);
  end;
  Result := -1;
end;

function TCustomGridView.GetColumnLeftRight(Column: Integer): TRect;
begin
  { проверяем колонку }
  if Columns.Count = 0 then
  begin
    { колонок вообще нет }
    Result.Left := GetGridRect.Left;
    Result.Right := Result.Left;
  end
  else if Column < 0 then
  begin
    { колонка левее самой первой }
    Result := GetColumnLeftRight(0);
    Result.Right := Result.Left;
  end
  else if Column > Columns.Count - 1 then
  begin
    { колонка правее самой последей }
    Result := GetColumnLeftRight(Columns.Count - 1);
    Result.Left := Result.Right;
  end
  else
  begin
    { обычная колонка }
    Result.Left := GetClientRect.Left + GetColumnsWidth(0, Column - 1);
    if Column >= Fixed.Count then Inc(Result.Left, GetGridOrigin.X);
    Result.Right := Result.Left + Columns[Column].Width;
  end;
end;

function TCustomGridView.GetColumnMaxWidth(Column: Integer): Integer;
var
  I, W: Integer;
  C: TGridCell;
  R: TRect;
begin
  { проверяем колонку }
  if (Column < 0) or (Column > Columns.Count - 1) then
  begin
    Result := 0;
    Exit;
  end;
  { а есть ли видимые строки }
  if FVisSize.Row = 0 then
  begin
    Result := Columns[Column].DefWidth;
    Exit;
  end;
  Result := 0;
  { вычисляем максимальную ширину по видимым строкам }
  for I := 0 to FVisSize.Row - 1 do
  begin
    { колонка и текст ячейки }
    C := GridCell(Column, VisOrigin.Row + I);
    { определяем прямоугольник текста }
    R := GetCellTextBounds(C);
    { определяем ширину }
    W := R.Right - R.Left;
    { место под флажок }
    if IsCellHasCheck(C) then Inc(W, CheckWidth + GetCheckIndent(C).X);
    { место под картинку }
    if IsCellHasImage(C) then Inc(W, Images.Width + GetCellImageIndent(C).X);
    { учитываем сетку }
    if GridLines and (gsVertLine in GridStyle) then Inc(W, FGridLineWidth);
    { запоминаем }
    if Result < W then Result := W;
  end;
end;

function TCustomGridView.GetColumnRect(Column: Integer): TRect;
begin
  Result := GetColumnLeftRight(Column);
  { верхний и нижний край строки определяется соответственно по верхнему
    краю первой строки и по нижнему краю последней строки }
  Result.Top := GetRowTopBottom(0).Top;
  Result.Bottom := GetRowTopBottom(Rows.Count - 1).Bottom;
end;

function TCustomGridView.GetColumnsRect(Column1, Column2: Integer): TRect;
var
  R1, R2: TRect;
begin
  R1 := GetColumnRect(Column1);
  R2 := GetColumnRect(Column2);
  UnionRect(Result, R1, R2); {!}
end;

function TCustomGridView.GetColumnsWidth(Column1, Column2: Integer): Integer;
var
  I: Integer;
begin
  Result := 0;
  { подправляем индексы }
  Column1 := MaxIntValue([Column1, 0]);
  Column2 := MinIntValue([Column2, Columns.Count - 1]);
  { считаем }
  for I := Column1 to Column2 do Inc(Result, Columns[I].Width);
end;

function TCustomGridView.GetEditRect(Cell: TGridCell): TRect;
begin
  Result := GetCellRect(Cell);
  { место под флажок  }
  if IsCellHasCheck(Cell) then Inc(Result.Left, CheckWidth + GetCheckIndent(Cell).X);
  { место под картинку }
  if IsCellHasImage(Cell) then Inc(Result.Left, Images.Width + GetCellImageIndent(Cell).X);
  { учитываем сетку }
  if GridLines then
  begin
    if gsVertLine in GridStyle then Dec(Result.Right, FGridLineWidth);
    if gsHorzLine in GridStyle then Dec(Result.Bottom, FGridLineWidth);
  end;
  { проверяем правый край }
  if Result.Left > Result.Right then Result.Left := Result.Right;
end;

function TCustomGridView.GetHeaderHeight: Integer;
begin
  Result := Header.Height;
end;

function TCustomGridView.GetHeaderRect: TRect;
begin
  Result := ClientRect;
  Result.Bottom := Result.Top;
  if ShowHeader then Inc(Result.Bottom, GetHeaderHeight);
end;

function TCustomGridView.GetFirstImageColumn: Integer;
var
  I: Integer;
begin
  for I := Fixed.Count to Columns.Count - 1 do
    if Columns[I].Visible then
    begin
      Result := I;
      Exit;
    end;
  Result := -1;
end;

function TCustomGridView.GetFixedRect: TRect;
begin
  Result := GetGridRect;
  Result.Right := Result.Left + GetColumnsWidth(0, Fixed.Count - 1);
end;

function TCustomGridView.GetFixedWidth: Integer;
begin
  with GetFixedRect do Result := Right - Left;
end;

function TCustomGridView.GetFocusRect: TRect;
var
  C: TGridCell;
  L: Integer;
begin
  if RowSelect then
    { прямоугольник строки }
    Result := GetRowRect(CellFocused.Row)
  else
    { прямоугольник ячейки }
    Result := GetCellRect(CellFocused);
  { получаем крайнюю левую колонку фокуса }
  C.Col := CellFocused.Col;
  if RowSelect then C.Col := Fixed.Count;
  C.Row := CellFocused.Row;
  { выделяется ли картинка ячейки }
  if not ImageHighlight then
  begin
    { место под флажок }
    if IsCellHasCheck(C) then Inc(Result.Left, CheckWidth + GetCheckIndent(C).X);
    { место под картинку }
    if IsCellHasImage(C) then Inc(Result.Left, Images.Width + GetCellImageIndent(C).X);
  end;
  { проверяем правый край результата }
  L := GetCellRect(C).Right;
  if Result.Left > L then Result.Left := L;
end;

function TCustomGridView.GetGridHeight: Integer;
begin
  with GetGridRect do Result := Bottom - Top;
end;

function TCustomGridView.GetGridOrigin: TPoint;
begin
  Result.X := - HorzScrollBar.Position;
  Result.Y := - VertScrollBar.Position * Rows.Height;
end;

function TCustomGridView.GetGridRect: TRect;
begin
  Result := ClientRect;
  Result.Top := GetHeaderRect.Bottom;
end;

function TCustomGridView.GetHeaderSection(ColumnIndex, Level: Integer): TGridHeaderSection;

  function DoGetSection(Sections: TGridHeaderSections): TGridHeaderSection;
  var
    I, L: Integer;
    S: TGridHeaderSection;
  begin
    for I := 0 to Sections.Count - 1 do
    begin
      S := Sections[I];
      L := S.Level;
      { сравниваем колонку и уровень }
      if (S.ColumnIndex >= ColumnIndex) and
        (((Level = -1) and (S.Sections.Count = 0)) or (L = Level)) then
      begin
        { нашли }
        Result := S;
        Exit;
      end;
      { рекурсия на все подзаголовки снизу }
      S := DoGetSection(S.Sections);
      { нашли или нет }
      if S <> nil then
      begin
        Result := S;
        Exit;
      end;
    end;
    { секции нет }
    Result := nil;
  end;

begin
  Result := DoGetSection(Header.Sections);
end;

function TCustomGridView.GetResizeSectionAt(X, Y: Integer): TGridHeaderSection;

  function FindSection(Sections: TGridHeaderSections; var Section: TGridHeaderSection): Boolean;
  var
    I, C, DL, DR: Integer;
    R: TRect;
    S: TGridHeaderSection;
  begin
    for I := Sections.Count - 1 downto 0 do
    begin
      { получаем ячейку и ее колонку }
      S := Sections[I];
      { ищем только для видимых колонок }
      if S.Visible then
      begin
        C := S.ResizeColumnIndex;
        { получаем прямоугольник области изменения размера }
        R := S.BoundsRect;
        with R do
        begin
          { определяем погрешность попадания }
          DL := 7;
          if R.Right - R.Left < 20 then DL := 3;
          if R.Right - R.Left < 10 then DL := 1;
          DR := 5;
          if C < Columns.Count - 1 then
          begin
            if Columns[C + 1].DefWidth < 20 then DR := 3;
            if Columns[C + 1].DefWidth < 10 then DR := 1;
          end;
          { подправляем прямоугольник попадания }
          if R.Right > R.Left then Left := Right - DL;
          Right := Right + DR;
        end;
        { попала ли точка в него }
        if PtInRect(R, Point(X, Y)) then
        begin
          { проверяем колнку на фиксированный размер }
          if (C < Columns.Count) and (Columns[C].FixedSize or (not ColumnsSizing)) then
          begin
            Section := nil;
            Result := False;
          end
          else
          begin
            Section := S;
            Result := True;
          end;
          { секцию нашли - выход }
          Exit;
        end;
        { ищем секцию в подзаголовках }
        if FindSection(S.Sections, Section) then
        begin
          Result := True;
          Exit;
        end;
      end;
    end;
    { ничего не нашли }
    Section := nil;
    Result := False;
  end;

begin
  FindSection(Header.Sections, Result);
end;

function TCustomGridView.GetRowAt(X, Y: Integer): Integer;
var
  Row: Integer;
begin
  if Rows.Height > 0 then
  begin
    Row := (Y - GetGridRect.Top - GetGridOrigin.Y) div Rows.Height;
    { проверяем ячейку }
    if (Row >= 0) and (Row < Rows.Count) then
    begin
      Result := Row;
      Exit;
    end;
  end;
  Result := -1;
end;

function TCustomGridView.GetRowRect(Row: Integer): TRect;
begin
  Result := GetRowTopBottom(Row);
  { левый и правый край строки определяется соответственно по левому
    краю первой нефиксированной колонки и по правому краю последней
    колонки }
  Result.Left := MinIntValue([GetClientRect.Left, GetColumnLeftRight(Fixed.Count).Left]);
  Result.Right := GetColumnLeftRight(Columns.Count - 1).Right;
end;

function TCustomGridView.GetRowsRect(Row1, Row2: Integer): TRect;
var
  R1, R2: TRect;
begin
  R1 := GetRowRect(Row1);
  R2 := GetRowRect(Row2);
  UnionRect(Result, R1, R2);
end;

function TCustomGridView.GetRowsHeight(Row1, Row2: Integer): Integer;
begin
  Result := 0;
  if Row2 >= Row1 then Result := (Row2 - Row1 + 1) * Rows.Height;
end;

function TCustomGridView.GetRowTopBottom(Row: Integer): TRect;
begin
  { верх и низ прямоугольника вычисляется по номеру и высоте строки }
  Result.Top := GetGridRect.Top + GetRowsHeight(0, Row - 1) + GetGridOrigin.Y;
  Result.Bottom := Result.Top + Rows.Height;
end;

function TCustomGridView.GetSectionAt(X, Y: Integer): TGridHeaderSection;

  function FindSection(Sections: TGridHeaderSections; var Section: TGridHeaderSection): Boolean;
  var
    I: Integer;
    S: TGridHeaderSection;
    R: TRect;
  begin
    for I := 0 to Sections.Count - 1 do
    begin
      { получаем секцию }
      S := Sections[I];
      { проверяем ее }
      { ищем только для видимых колонок }
      if S.Visible then
      begin
        { получаем прямоугольник секции }
        R := S.BoundsRect;
        { попала ли точка в него }
        if PtInRect(R, Point(X, Y)) then
        begin
          { секцию нашли }
          Section := S;
          Result := True;
          { выход }
          Exit;
        end;
      end;
      { ищем секцию в подзаголовках }
      if FindSection(S.Sections, Section) then
      begin
        Result := True;
        Exit;
      end;
    end;
    { ничего не нашли }
    Section := nil;
    Result := False;
  end;

begin
  FindSection(Header.Sections, Result);
end;

procedure TCustomGridView.Invalidate;
begin
  if (Parent <> nil) and (FUpdateLock = 0) then inherited;
end;

procedure TCustomGridView.InvalidateCell(Cell: TGridCell);
begin
  if (Cell.Row = CellFocused.Row) or (Cell.Col = CellFocused.Col) then HideFocus;
  InvalidateRect(GetCellRect(Cell));
  if (Cell.Row = CellFocused.Row) or (Cell.Col = CellFocused.Col) then ShowFocus;
end;

procedure TCustomGridView.InvalidateCheck(Cell: TGridCell);
begin
  InvalidateRect(GetCheckRect(Cell));
end;

procedure TCustomGridView.InvalidateColumn(Column: Integer);
begin
  HideFocus;
  InvalidateRect(GetColumnRect(Column));
  ShowFocus;
end;

procedure TCustomGridView.InvalidateColumns(Column1, Column2: Integer);
begin
  HideFocus;
  InvalidateRect(GetColumnsRect(Column1, Column2));
  ShowFocus;
end;

procedure TCustomGridView.InvalidateEdit;
begin
  if Editing then Edit.Invalidate;
end;

procedure TCustomGridView.InvalidateFixed;
begin
  InvalidateRect(GetFixedRect);
end;

procedure TCustomGridView.InvalidateFocus;
var
  Rect: TRect;
begin
  Rect := GetFocusRect;
  { подправляем прямоугольник фокуса (он не учитываемт картинку) }
  if RowSelect then
    UnionRect(Rect, Rect, GetCellRect(GridCell(Fixed.Count, CellFocused.Row)))
  else
    UnionRect(Rect, Rect, GetCellRect(CellFocused));
  { обновляем прямоугольник }
  InvalidateRect(Rect);
end;

procedure TCustomGridView.InvalidateGrid;
begin
  InvalidateEdit;
  InvalidateRect(GetGridRect);
end;

procedure TCustomGridView.InvalidateHeader;
begin
  if ShowHeader then InvalidateRect(GetHeaderRect);
end;

procedure TCustomGridView.InvalidateRect(Rect: TRect);
begin
  if (FUpdateLock = 0) and HandleAllocated and Visible then
    Windows.InvalidateRect(Handle, @Rect, False);
end;

procedure TCustomGridView.InvalidateRow(Row: Integer);
begin
  if Row = CellFocused.Row then HideFocus;
  InvalidateRect(GetRowRect(Row));
  if Row = CellFocused.Row then ShowFocus;
end;

procedure TCustomGridView.InvalidateRows(Row1, Row2: Integer);
begin
  HideFocus;
  InvalidateRect(GetRowsRect(Row1, Row2));
  ShowFocus;
end;

function TCustomGridView.IsActiveControl: Boolean;
var
  H: HWND;
begin
  { определяем активность по форме }
  if (GetParentForm(Self) <> nil) and (GetParentForm(Self).ActiveControl = Self) then
  begin
    Result := True;
    Exit;
  end;
  { определяем по описателю }
  H := GetFocus;
  while IsWindow(H) do
  begin
    if H = WindowHandle then
    begin
      Result := True;
      Exit;
    end;
    H := GetParent(H);
  end;
  { ничего не нашли }
  Result := False;
end;

function TCustomGridView.IsCellAcceptCursor(Cell: TGridCell): Boolean;
begin
  { а корректна ли ячейка }
  if not IsCellValid(Cell) then
  begin
    Result := False;
    Exit;
  end;
  { результат по умолчанию }
  Result := (Cell.Col >= Fixed.Count) and Columns[Cell.Col].TabStop;
  { можно ли устанавливать курсор на ячейку }
  if Assigned(FOnCellAcceptCursor) then FOnCellAcceptCursor(Self, Cell, Result);
end;

function TCustomGridView.IsCellHasCheck(Cell: TGridCell): Boolean;
begin
  Result := CheckBoxes and (GetCheckKind(Cell) <> gcNone);
end;

function TCustomGridView.IsCellHasImage(Cell: TGridCell): Boolean;
begin
  Result := Assigned(Images) and (GetCellImage(Cell) <> -1);
end;

function TCustomGridView.IsCellFocused(Cell: TGridCell): Boolean;
begin
  Result := ((Cell.Col = CellFocused.Col) or RowSelect) and
    (Cell.Row = CellFocused.Row) and (Cell.Col >= Fixed.Count);
end;

function TCustomGridView.IsCellReadOnly(Cell: TGridCell): Boolean;
begin
  Result := True;
  { а верна ли ячейка }
  if IsCellValid(Cell) then
  begin
    { ячейку можно редактировать, если таблица не в режиме ReadOnly,
      это не фиксированная колонка и сама колонка не ReadOnly }
    Result := ReadOnly or (Cell.Col < Fixed.Count) or Columns[Cell.Col].ReadOnly;
    if Assigned(FOnGetCellReadOnly) then FOnGetCellReadOnly(Self, Cell, Result);
  end;
end;

function TCustomGridView.IsCellValid(Cell: TGridCell): Boolean;
begin
  Result := IsCellValidEx(Cell, True, True);
end;

function TCustomGridView.IsCellValidEx(Cell: TGridCell; CheckPosition, CheckVisible: Boolean): Boolean;
var
  C, R, V: Boolean;
begin
  { определяем видимость, ширину колонки и корректность ячейки }
  with Cell do
  begin
    C := (Col >= 0) and (Col < Columns.Count);
    R := (Row >= 0) and (Row < Rows.Count);
    V := C and Columns[Col].Visible and (Columns[Col].Width > 0);
  end;
  { результат }
  Result := ((not CheckPosition) or (C and R)) and ((not CheckVisible) or V);
end;

function TCustomGridView.IsCellVisible(Cell: TGridCell; PartialOK: Boolean): Boolean;
var
  CR, GR, R: TRect;
begin
  { получаем границы ячейки и сетки }
  CR := GetCellRect(Cell);
  GR := GetGridRect;
  { если есть фиксированные и ячейка нефиксирована, то левая граница есть
    граница фиксированных, а не граница таблицы }
  if (Fixed.Count > 0) and (Cell.Col >- Fixed.Count) then
    GR.Left := GetFixedRect.Right;
  { пересечение }
  Result := IntersectRect(R, CR, GR);
  { полная видимость }
  if not PartialOK then Result := EqualRect(R, CR);
end;

function TCustomGridView.IsColumnVisible(Column: Integer): Boolean;
var
  R: TRect;
begin
  Result := IntersectRect(R, GetColumnRect(Column), GetGridRect);
end;

function TCustomGridView.IsFocusAllowed: Boolean;
begin
  Result := (RowSelect or (not (Editing or AlwaysEdit))) and AllowSelect;
end;

function TCustomGridView.IsHeaderHasImage(Section: TGridHeaderSection): Boolean;
begin
  Result := Assigned(Header.Images) and (GetHeaderImage(Section) <> -1);
end;

function TCustomGridView.IsHeaderPressed(Section: TGridHeaderSection): Boolean;
begin
  Result := ((Section = nil) or (Section = FHeaderClickSection)) and FHeaderClickState;
end;

function TCustomGridView.IsRowVisible(Row: Integer): Boolean;
var
  R: TRect;
begin
  Result := IntersectRect(R, GetRowRect(Row), GetGridRect);
end;

procedure TCustomGridView.LockUpdate;
begin
  Inc(FUpdateLock);
end;

procedure TCustomGridView.MakeCellVisible(Cell: TGridCell; PartialOK: Boolean);
var
  DX, DY, X, Y: Integer;
  R: TRect;
begin
  if not IsCellVisible(Cell, PartialOK) then
  begin
    DX := 0;
    DY := 0;
    with GetGridRect do
    begin
      { смещение по горизонтали }
      if not RowSelect then
      begin
        R := GetColumnRect(Cell.Col);
        X := Left + GetFixedWidth;
        if R.Right > Right then DX := Right - R.Right;
        if R.Left < X then DX := X - R.Left;
        if R.Right - R.Left > Right - X then DX := X - R.Left;
      end;
      { смещение по вертикали }
      if Rows.Height > 0 then
      begin
        R := GetRowRect(Cell.Row);
        if R.Bottom > Bottom then DY := Bottom - R.Bottom;
        if R.Top < Top then DY := Top - R.Top;
        if R.Bottom - R.Top > Bottom - Top then DY := Top - R.Top;
        Y := DY div Rows.Height;
        if (FVisSize.Row > 1) and (DY mod Rows.Height <> 0) then Dec(Y);
        DY := Y;
      end;
    end;
    { изменяем положение }
    with VertScrollBar do Position := Position - DY;
    with HorzScrollBar do Position := Position - DX;
  end;
end;

procedure TCustomGridView.SetCursor(Cell: TGridCell; Selected, Visible: Boolean);
begin
  { проверяем выделение }
  UpdateSelection(Cell, Selected);
  { изменилось ли что нибудь }
  if (not IsCellEqual(FCellFocused, Cell)) or (FCellSelected <> Selected) then
  begin
    { ячейка меняется }
    Changing(Cell, Selected);
    { устанавливаем активную ячейку }
    if not IsCellEqual(FCellFocused, Cell) then
    begin
      { при изменении положения курсора гасим подсказку }
      Application.CancelHint;
      { если идет редактирование - проверяем текст }
      Editing := False;
      { меняем ячейку }
      HideCursor;
      FCellFocused := Cell;
      FCellSelected := Selected;
      if Visible then MakeCellVisible(CellFocused, False);
      ShowCursor;
    end
    { устанавливаем выделение }
    else if FCellSelected <> Selected then
    begin
      { строка видна - фокус на нее, состояние не трогаем }
      if Editing then ShowEdit;
      { если строка погасла - меняем состояние курсора }
      if not Editing then
      begin
        HideCursor;
        FCellSelected := Selected;
        if Visible then MakeCellVisible(CellFocused, False);
        ShowCursor;
      end;
    end;
    { ячейка сменилась }
    Change(FCellFocused, FCellSelected);
  end
  else
    { ячейка не изменилась - подправляем видимость }
    if Visible then MakeCellVisible(CellFocused, False);
end;

procedure TCustomGridView.UndoEdit;
begin
  if (FEdit <> nil) and EditCanUndo(EditCell) then FEdit.Perform(WM_UNDO, 0, 0);
end;

procedure TCustomGridView.UnLockUpdate(Redraw: Boolean);
begin
  Dec(FUpdateLock);
  if (FUpdateLock = 0) and Redraw then Invalidate;
end;

procedure TCustomGridView.UpdateCursor;
var
  Cell: TGridCell;
  IsValidCell, Dummy: Boolean;
begin
  Cell := CellFocused;
  IsValidCell := IsCellValid(Cell) and IsCellAcceptCursor(Cell);
  { если текущая ячейка недоступна, то ищем доступную ячейку вокруг или
    первую попавшуюся, если таковой нет }
  if not IsValidCell then
  begin
    UpdateSelection(Cell, Dummy);
    if IsCellEqual(Cell, CellFocused) then Cell := GetCursorCell(Cell, goFirst);
  end;
  { подправляем выделение ячейки }
  SetCursor(Cell, CellSelected, not IsValidCell);
end;

procedure TCustomGridView.UpdateColors;
begin
  Header.GridColorChanged(Color);
  Fixed.GridColorChanged(Color);
end;

procedure TCustomGridView.UpdateEdit(Activate: Boolean);

  procedure DoValidateEdit;
  var
    EditClass: TGridEditClass;
  begin
    { получаем класс строки редактирования }
    EditClass := GetEditClass(FCellFocused);
    { создаем или меняем строку }
    if (FEdit = nil) or (FEdit.ClassType <> EditClass) then
    begin
      FEdit.Free;
      FEdit := CreateEdit(EditClass);
      FEdit.Parent := Self;
      FEdit.FGrid := Self;
    end;
  end;

  procedure DoUpdateEdit;
  begin
    FEditCell := FCellFocused;
    FEdit.Updating;
    FEdit.UpdateContents;
    FEdit.UpdateStyle;
    FEdit.Updated;
    FEdit.SelectAll;
  end;

begin
  { а разрешена ли строка ввода }
  if EditCanShow(FCellFocused) then
  begin
    { если строки ввода нет - создаем ее }
    if FEdit = nil then
    begin
      DoValidateEdit;
      DoUpdateEdit;
    end
    { если положение изменилось - гисим и обновляем строку }
    else if not (IsCellEqual(FEditCell, FCellFocused) and Editing) then
    begin
      Activate := Activate or Editing or AlwaysEdit;
      HideEdit;
      DoValidateEdit;
      DoUpdateEdit;
    end;
    { показываем строку }
    if Activate then FEdit.Show;
  end
  else
    { гасим строку }
    HideEdit;
end;

procedure TCustomGridView.UpdateEditContents(SaveText: Boolean);
var
  EditText: string;
begin
  if Editing then
  begin
    EditText := Edit.Text;
    { чтобы строка обновилась полностью, ее необходимо погасить }
    HideEdit;
    { обновляем и вновь показываем строку }
    UpdateEdit(True);
    { восстанавливаем текст }
    if SaveText then Edit.Text := EditText;
  end;
end;

procedure TCustomGridView.UpdateEditText;
var
  EditFocused: Boolean;
  EditText: string;
begin
  if (not ReadOnly) and (Edit <> nil) and (not IsCellReadOnly(EditCell)) then
  begin
    EditFocused := Editing;
    { проверяем текст строки ввода }
    try
      EditText := Edit.Text;
      try
        SetEditText(EditCell, EditText);
      finally
        Edit.Text := EditText;
      end;
    except
      on E: Exception do
      begin
        { не даем сдвигаться движку скроллера }
        MakeCellVisible(CellFocused, False);
        { если строка видна - фокус на нее, иначе она погасится после
          открытия окна с сообщением об ошибке }
        if EditFocused then Edit.SetFocus;
        { ошибка }
        raise;
      end;
    end;
  end;
end;

procedure TCustomGridView.UpdateFixed;
begin
  Fixed.SetCount(Fixed.Count);
end;

procedure TCustomGridView.UpdateFocus;
begin
  if csDesigning in ComponentState then Exit;
  { если таблица уже активна, то ставим фокус на нее еще раз насильно,
    т.к. в противном случае могут быть глюки с MDI формами }
  if IsActiveControl then
  begin
    Windows.SetFocus(Handle);
    if GetFocus = Handle then Perform(CM_UIACTIVATE, 0, 0);
  end
  else
    { а можно ли устанавливать фокус }
    if IsWindowVisible(Handle) and TabStop and (CanFocus or (GetParentForm(Self) = nil)) then
    begin
      SetFocus;
      if AlwaysEdit and (Edit <> nil) then UpdateEdit(True);
    end;
end;

procedure TCustomGridView.UpdateFonts;
begin
  Header.GridFontChanged(Font);
  Fixed.GridFontChanged(Font);
end;

procedure TCustomGridView.UpdateHeader;
begin
  with Header do
  begin
    if AutoSynchronize or Synchronized then SynchronizeSections else UpdateSections;
    SetSectionHeight(SectionHeight);
  end;
end;

procedure TCustomGridView.UpdateRows;
begin
  Rows.SetHeight(Rows.Height);
end;

procedure TCustomGridView.UpdateScrollBars;
var
  R, P, L: Integer;
begin
  { блокируем повторное обновление при изменении размеров окна, которое
    обязательно произойдет при показе скроллера или при его гашении }
  LockUpdate;
  try
    { параметры вертикального скроллера }
    if (Rows.Count > 0) and (Rows.Height > 0) then
    begin
      R := Rows.Count - 1;
      with GetGridRect do P := (Bottom - Top) div Rows.Height - 1;
      L := 1;
    end
    else
    begin
      R := 0;
      P := 0;
      L := 0;
    end;
    with VertScrollBar do
    begin
      SetLineSize(Rows.Height);
      SetParams(0, R, P, L);
    end;
    { параметры горизонтального скроллера }
    if Columns.Count > 0 then
    begin
      R := GetColumnsWidth(0, Columns.Count - 1) - GetFixedWidth;
      with GetGridRect do P := (Right - Left) - GetFixedWidth;
      L := 8;
    end
    else
    begin
      R := 0;
      P := 0;
      L := 0;
    end;
    with HorzScrollBar do
    begin
      SetLineSize(1);
      SetParams(0, R, P, L);
    end;
  finally
    UnLockUpdate(False);
  end;
end;

procedure TCustomGridView.UpdateScrollPos;
begin
  VertScrollBar.Position := FVisOrigin.Row;
  HorzScrollBar.Position := GetColumnsWidth(Fixed.Count, FVisOrigin.Col - 1);
end;

procedure TCustomGridView.UpdateSelection(var Cell: TGridCell; var Selected: Boolean);
begin
  { Проверка флага выделения }
  Selected := Selected or FAlwaysSelected;
  Selected := Selected and (Rows.Count > 0) and (Columns.Count > 0);
  { проверка ячейки на границы }
  with Cell do
  begin
    if Col < Fixed.Count then Col := Fixed.Count;
    if Col < 0 then Col := 0;
    if Col > Columns.Count - 1 then Col := Columns.Count - 1;
    if Row < 0 then Row := 0;
    if Row > Rows.Count - 1 then Row := Rows.Count - 1;
  end;
  { проверяем фокус }
  Cell := GetCursorCell(Cell, goSelect);
end;

procedure TCustomGridView.UpdateText;
begin
  UpdateEditText;
end;

procedure TCustomGridView.UpdateVisOriginSize;
var
  R: TRect;
  I, X, H: Integer;
begin
  if Columns.Count > 0 then
  begin
    { ищем первую попавшуюся видимую нефиксированную колонку }
    X := GetClientRect.Left + GetFixedWidth - HorzScrollBar.Position;
    R := GetFixedRect;
    I := Fixed.Count;
    while I < Columns.Count - 1 do
    begin
      X := X + Columns[I].Width;
      if X >= R.Right then Break;
      Inc(I);
    end;
    FVisOrigin.Col := I;
    { считаем количество видимых колонок }
    R := GetGridRect;
    while I < Columns.Count - 1 do
    begin
      if X >= R.Right then Break;
      Inc(I);
      X := X + Columns[I].Width;
    end;
    FVisSize.Col := I - FVisOrigin.Col + 1;
  end
  else
  begin
    FVisOrigin.Col := 0;
    FVisSize.Col := 0;
  end;
  if (Rows.Count > 0) and (Rows.Height > 0) then
  begin
    { вертикальный движок определяем номер первой видимой строки }
    FVisOrigin.Row := VertScrollBar.Position;
    { считаем количество видимых (пусть даже и частично) строк }
    H := GetGridHeight;
    FVisSize.Row := H div Rows.Height + Ord(H mod Rows.Height > 0);
    if FVisSize.Row + FVisOrigin.Row  > Rows.Count then
      FVisSize.Row := Rows.Count - FVisOrigin.Row;
  end
  else
  begin
    FVisOrigin.Row := 0;
    FVisSize.Row := 0;
  end;
end;

end.
