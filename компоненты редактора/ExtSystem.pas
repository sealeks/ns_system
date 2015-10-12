{
  Библиотека дополнительных утилит

  Дополнительные процедуры и функции общего назначения

  © Роман М. Мочалов, 1997-2001
  E-mail: roman@sar.nnov.ru
}

unit ExtSystem;

interface

{$I EXT.INC}

type
  PIntArray = ^TIntArray;
  TIntArray = array[0..MaxInt div 16 - 1] of Integer;

procedure FillDWord(var Dest; Count, Value: Integer);

implementation

procedure FillDWord(var Dest; Count, Value: Integer); register;
asm
  XCHG  EDX, ECX
  PUSH  EDI
  MOV   EDI, EAX
  MOV   EAX, EDX
  REP   STOSD
  POP   EDI
end;

end.
