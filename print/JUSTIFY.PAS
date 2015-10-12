unit Justify;

interface

uses Classes;

{ LEFT, CENTRE OR RIGHT JUSTIFY A STRING, ADDING LEADING/TRAILING
    SPACES OR TRUNCATING TO FORM A STRING OF EXACT LENGTH }

function Align(
        const text : string; SetLength : integer; align :TAlignment ): string;


implementation
{ ADD TRAILING SPACES OR TRUNCATE A STRING TO PRODUCE A LEFT
    JUSTIFIED STRING OF EXACT LENGTH }

function Pad( const text : String; SetLength : integer ) : string;

var index   : integer;
    size    : integer;

begin
    result := text;
    size   := length( text );

    if size > SetLength then
        delete( result, SetLength + 1, 100 )
    else
        begin
        index := size;
        while index < SetLength do
            begin
            inc( index );
            result := result + ' ';
            end;
        end;
end;

{ ADD LEADING SPACES OR TRUNCATE A STRING TO PRODUCE A RIGHT
    JUSTIFIED STRING OF EXACT LENGTH }

function RightJustify( const text : string; SetLength : integer ) : string;

var size  : integer;
    shift : integer;

begin
    size := Length( text );

    if size > SetLength then
        begin
        result := text;
        end
    else
        begin
        shift := SetLength - size;
        result := text;
        while shift > 0 do
            begin
            insert( ' ', result, 1 );
            dec( shift );
            end;
        end;

    result := pad( result, SetLength );
end;


{ TRUNCATE OR ADD LEADING AND TRAILING SPACES TO PRODUCE A
    CENTRE JUSTIFIED STRING OF EXACT LENGTH }

function Center( const text : string; SetLength : integer ) : string;

var size  : integer;
    shift : integer;

begin
    size := Length( text );

    if size > SetLength then
        begin
        result := text;
        end
    else
        begin
        shift := ( SetLength - size ) div 2;
        result := text;
        while shift > 0 do
            begin
            insert( ' ', result, 1 );
            dec( shift );
            end;
        end;
    result := pad( result, SetLength );
end;

{ LEFT, CENTRE OR RIGHT JUSTIFY A STRING, ADDING LEADING/TRAILING
    SPACES OR TRUNCATING TO FORM A STRING OF EXACT LENGTH }

function Align(
        const text : string; SetLength : integer; align :TAlignment ): string;
begin
    if align = taLeftJustify then
        result := Pad( Text, SetLength )

    else if align = taRightJustify then
        result := RightJustify( text, SetLength )

    else
        result := Center( text, SetLength );

end;

end.
 
