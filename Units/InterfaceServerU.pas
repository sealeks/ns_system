unit InterfaceServerU;

interface

uses
   Windows, Messages, Classes, SysUtils, GenAlg, Controls, Constdef, DateUtils, convFunc, StrUtils;

const
    KOYO_PEPORT_ADDRARCH =$1F71;  {oct 17561  AddrArch}
    KOYO_PEPORT_PARAMCOUNT =$1F72;  {oct 17562  ParamCount}
    KOYO_PEPORT_HOURSCOUNT =$1F73;  {oct 17563  HoursCount}
    KOYO_PEPORT_CUR_CNT =$1F77;  {oct 17570  CurAddrArch}
    KOYO_PEPORT_CUR_ADDR =$1F78;  {oct 17570  CurAddrArch}
    KOYO_DATEPERC =$1F7D;  {oct 17570  CurAddrArch}
    KOYO_TIMEPERC =8062;



type
    TEtherset = record
      bs,frt,frd,trc,tstrt,tstp,wait: integer;

      end;
type
    TCOMSet = record
      Com,br,db,sb,pt,trd,red,ri,rtm,rtc,wtm,wtc,bs,frt,frd,trc,tstrt,tstp,prttm,wait,slave: integer;
      name: string;
      flCtrl: boolean;
      // com - номер порта  1..255
      // br BaudRate - скорость 110..115200
      // db-  Databit       5..8
      // sb - StopBits      1,1.5,2
      // pt - ParityBit     None, Odd, Even, Mark, Space
      // trd-  задержка в миллисекундах до esc
      // red-  задержка в миллисекундах после esc
      // ri -  ReadInterval
      // rtm - ReadTotalMultiplier
      // rtc - ReadTotalConstant
      // wtm - WriteTotalMultiplier
      // wtc - WriteTotalConstan
      // bs -  blockSize
      // flCtrl - Flow control
      // frt - ReadTimeOUT   //  таймаут рарыва связи
      // frd - DirectTimeOUT
      // trc - TryCount попытки чтения
      //  tstrt - время начала часового цикла опроса
      //  tstp  - время конца часового цикла опроса
      //  prttm - задержка перед puge порта
      //  wait  - wait в  WaitForSingleObject


end;


type
  TInterfaceServer = class (TComponent)
  private
    function readLineRep(slaveNumber: byte; var dt: TDateTime; var res: TReportCol; addr_: integer; p_count: integer;  var errcnt: integer): boolean;

  public
   fcomset: TCOMSet;
   ProterrW: word;
   ProterrR: word;
   //function PLCreadString (slaveNumber: byte; startAddress, dataSize: integer): string;      virtual;
   function PLCreadString1 (slaveNumber: byte; startAddress, dataSize: integer; var data: string): integer;  virtual;
//   function PLCreadStringB (slaveNumber: byte; startAddress, dataSize: integer; var data: string): boolean;  virtual;
   function PLCwriteString (slaveNumber: byte; startAddress: integer; NewValue: string): integer; virtual;

   function ReadSettings: boolean; virtual;
   function Open: boolean; virtual;
   procedure Close; virtual;
   procedure setComset(val: TComset); virtual;
   procedure setTimeSync(slaveNumber: byte; dt : TDateTime);
   function Readreport(slaveNumber: byte; var dt: TDateTime; var res: TReportCol): boolean;
   function FillRepData(var res: TReportCol; vl: string; count: integer): boolean;

  end;

implementation





  function calculateStart(tb_adr,p_cnt,h_cnt,cur_tb: integer; tmrq, curtm: TDatetime; err_delt: integer =0): integer;
    var cnt: integer;
        tmp_num: integer;
    begin
      result:=-1;
      tmrq:=normalizeHour(tmrq);
      curtm:=normalizeHour(trunc(curtm*24)/24);
      cnt:=round((curtm-tmrq)*24)+1+err_delt;
      if cnt<0 then exit;
      if cnt>h_cnt then exit;
      if (cur_tb>=cnt) then tmp_num:=cur_tb-cnt
      else tmp_num:=(h_cnt)-(cnt-cur_tb);
      result:=tb_adr+tmp_num*(2+p_cnt*2);
     // result:=result+ (2+2*(5))*2;
    end;




    function gettimeLine(val: string; var tm: TDatetime): boolean;
    var cnt: integer;
        tmp_num, yy, mm, dd, hh: word;
        test: string;
    begin
        // hh dd yy mm

      result:=false;
      tm:=0;
      if length(val)<5 then exit;

      hh:=NS_hexbyteTobinbyte(byte(val[1]));
      dd:=NS_hexbyteTobinbyte(byte(val[2]));
      yy:=NS_hexbyteTobinbyte(byte(val[3]));
      mm:=NS_hexbyteTobinbyte(byte(val[4]));

      // валидация даты

      if (hh<0) or (hh>24) then exit;
      if (dd<1) or (dd>31) then exit;
      if (mm<1) or (mm>12) then exit;
      if (yy<0) or (yy>99) then exit;

      // валидация пройдена

      tm:=encodedatetime(2000+yy,mm,dd,hh,0,0,0);
      tm:=inchour(tm,1);
      tm:=normalizeHour(tm);
      test:=Datetimetostr(tm);
      result:=true;
    end;

    function GetSingleVal(vl: string; adr: integer): single;
     var tmp_str: string;
         i: integer;
      begin
         tmp_str:='';
         for i:=1 to 4 do
           tmp_str:=tmp_str+vl[4*adr+i];
          result:= Psingle(@tmp_str[1])^;
      end;


   function TInterfaceServer.PLCreadString1 (slaveNumber: byte; startAddress, dataSize: integer; var data: string): integer;
   begin
   end;

   function TInterfaceServer.PLCwriteString (slaveNumber: byte; startAddress: integer; NewValue: string): integer;
   begin
   end;
  
   function TInterfaceServer.ReadSettings: boolean;
   begin

   end;
   function TInterfaceServer.Open: boolean;
   begin

   end;
   procedure TInterfaceServer.Close;
   begin

   end;
   procedure TInterfaceServer.setComset(val: TComset);
   begin
   end;

   function TInterfaceServer.Readreport(slaveNumber: byte; var dt: TDateTime; var res: TReportCol): boolean;


   var meta_dat, dat: string;
       p_count,h_count, addr_tab, cnt_cur, cnt_addr, sech_addr, line_length, tmp_err: integer;
       tm_line, tm_now: TDateTime;
       test: string;
       i: integer;
   begin
      setlength(res,0);
      try
      result:=false;
      tm_now:=now;
      PLCreadString1(slaveNumber,KOYO_PEPORT_ADDRARCH+1,16,meta_dat);
      if (ProterrR=0) and (length(meta_dat)>=16) then
        begin
                test:=Datetimetostr(dt);
                addr_tab:=NS_strBinOctToInt(meta_dat[2]+meta_dat[1]);
                p_count:=NS_strBinToInt(meta_dat[4]+meta_dat[3]);
                h_count:=NS_strBinToInt(meta_dat[6]+meta_dat[5]);
                cnt_cur:=NS_strBinToInt(meta_dat[14]+meta_dat[13]);
                cnt_addr:=NS_strBinOctToInt(meta_dat[16]+meta_dat[15]);

                // проверка корректности

                if (addr_tab>$4000) or
                       (p_count>$100) or
                          (h_count>$400) then
                            begin
                               result:=true;
                               exit;
                            end;

                // проверка корректности

                if (cnt_cur>h_count) or
                       (cnt_addr>(addr_tab+h_count*(2+2*(p_count+1)))) then
                            begin
                               result:=true;
                               exit;
                            end;


                sech_addr:=calculateStart(addr_tab,p_count,h_count,cnt_cur,dt,tm_now);

                // попытка прочитать текущий

                if sech_addr=cnt_addr then
                 begin
                   result:=false;
                   exit;
                 end;

                // адресс с ошибкой

                if sech_addr<0 then
                  begin

                      result:=true;
                      exit;
                  end;

              // удачная валидация адреса

             // sech_addr:=sech_addr;

              if readLineRep(slaveNumber, dt, res, sech_addr , p_count, tmp_err) then
                begin
                   if tmp_err=0 then
                     begin
                       result:=true;
                       exit;
                     end else
                     //  ловим смещение
                     begin
                       sech_addr:=calculateStart(addr_tab,p_count,h_count,cnt_cur,dt,tm_now,tmp_err);
                       setlength(res,0);
                       // повторная валидация
                       if sech_addr=cnt_addr then
                         begin
                            result:=false;
                            exit;
                         end;

                        if sech_addr<0 then
                         begin
                           result:=true;
                           exit;
                         end;

                         if not readLineRep(slaveNumber, dt, res, sech_addr , p_count, tmp_err) then setlength(res,0);
                         if tmp_err<>0 then setlength(res,0);
                           result:=true;
                           exit;


                     end;
                end else
                begin
                     setlength(res,0);
                     result:=true;
                     exit;
                end;

        end else
         begin
           result:=false;
           exit;
         end;
   except
     ProterrR:=ERRP_R_1;
     result:=false;
   end;

   end;

   function TInterfaceServer.readLineRep(slaveNumber: byte; var dt: TDateTime; var res: TReportCol; addr_: integer; p_count: integer; var errcnt: integer): boolean;
   var  dat: string;
       line_length: integer;
       tm_line: TDateTime;
       test: string;
       i: integer;

   begin
      line_length:=4+4*p_count;
      PLCreadString1(slaveNumber,addr_+1,line_length,dat);
                    // hh dd yy mm
                    if (length(dat)>=line_length) then
                      begin
                        if gettimeLine(dat,tm_line) then
                            begin
                              errcnt:=hoursBetween(dt,tm_line);
                              if errcnt=0 then
                               begin
                                dt:=tm_line;
                                FillRepData(res,dat,p_count);
                                result:=true;
                               end else
                               begin
                                 setlength(res,0);
                                 result:=true;
                               end;
                            end
                        else
                            begin
                             setlength(res,0);
                             result:=true;
                             exit;
                            end;
                      end

   end;

   function TInterfaceServer.FillRepData(var res: TReportCol; vl: string; count: integer ): boolean;
   var i: integer;
   begin
      result:=false;
      vl:=rightstr(vl,length(vl)-4);
      setlength(res,count);
      for i:=0 to count-1 do
         res[i]:=GetSingleVal(vl,i);
      result:=true;
   end;

   procedure TInterfaceServer.setTimeSync(slaveNumber: byte; dt : TDateTime);
      var dd, hh, mm, yy, ss, nn, ww, out_: longint;
          str_out: string;
     begin
        try
        ss:=SecondOf(dt);
        nn:=MinuteOf(dt);
        hh:=HourOf(dt);
        dd:=dayof(dt);
        mm:=Monthof(dt);
        yy:=YearOf(dt) mod 100;
        ww:=DayOfTheWeek(dt);
        if ww=7 then ww:=0;
        ww:=ww;

        str_out:=char(NS_binbyteToHexbyte(ss))+
            char(NS_binbyteToHexbyte(nn))+char(NS_binbyteToHexbyte(hh))+char($80);
        PLCwriteString(slaveNumber,KOYO_TIMEPERC,str_out);
        str_out:=char($80 or NS_binbyteToHexbyte(ww))+
            char(NS_binbyteToHexbyte(dd))+char(NS_binbyteToHexbyte(mm))+char(NS_binbyteToHexbyte(yy));
        PLCwriteString(slaveNumber,KOYO_TIMEPERC,str_out);
        except
        end;
     end;
end.
