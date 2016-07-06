unit CARules2Int;

interface

const
 sMapSig = 'MAP CA1';
 MaxNeib = 64;

{Capabilities}

capIrrevStep = $01;
capRevStep   = $02;
capInvert    = $04;
capSaveMap   = $08;
capLoadMap   = $10;


type

 NCell = byte;
 XCell = integer;

 DVec = record
  DX,DY : Integer;
 end;

 
 TLocCells =  array[0..MaxNeib-1] of NCell;

 TBndKnd = (tbkCycl,tbkZero);

 Tfxupd = (fx_plus_y,fx_minus_y,y_minus_fx,f_special,f_spec_rev);



implementation

end.
 