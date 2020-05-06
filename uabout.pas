unit uAbout;

{$mode objfpc}{$H+}
 interface
uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ColorBox, StdCtrls{$IFDEF Windows},shellapi {$ENDIF};

type

  { TFAbout }

  TFAbout = class(TForm)
    ColorListBox1: TColorListBox;
    Label1: TLabel;
    LabelLegal: TLabel;
    LabelCompany: TLabel;
    Memo1: TMemo;
    procedure FormShow(Sender: TObject);
    procedure LabelCompanyClick(Sender: TObject);
  private

  public

  end;

var
  FAbout: TFAbout;

implementation

{$R *.lfm}

{ TFAbout }

procedure TFAbout.FormShow(Sender: TObject);
begin
  {$IFDEF Windows}
  LabelCompany.Font.Color:=clBlue;
  LabelCompany.Font.Style:=[fsUnderline];
  LabelCompany.Cursor:=crHandPoint;
  {$ENDIF}
end;

procedure TFAbout.LabelCompanyClick(Sender: TObject);
begin
  {$IFDEF Windows}
  Shellexecute(handle, 'open', pchar('https://mcicllc.com/'), nil,nil,1)
  {$ENDIF}
end;

end.

