unit uAbout;

{$mode objfpc}{$H+}
 interface
uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ColorBox, StdCtrls,lclintf{$IFDEF Windows},shellapi {$ENDIF};

type

  { TFAbout }

  TFAbout = class(TForm)
    ColorListBox1: TColorListBox;
    Label1: TLabel;
    LabelLegal: TLabel;
    LabelCompany: TLabel;
    Memo1: TMemo;

    procedure LabelCompanyClick(Sender: TObject);
  private

  public

  end;

var
  FAbout: TFAbout;

implementation

{$R *.lfm}

{ TFAbout }



procedure TFAbout.LabelCompanyClick(Sender: TObject);
begin
  OpenUrl('https://mcicllc.com/')
end;

end.

