program EasyScriptLauncher;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, Main,
  { you can add units after this }
  AsyncProcess,umodasyncProcess , fileinfo
  , winpeimagereader {need this for reading exe info}
  , elfreader {needed for reading ELF executables}
  , machoreader, uAbout {needed for reading MACH-O executables} ,dialogs     ;
var
  FileVerInfo: TFileVersionInfo;
{$R *.res}

begin
    FileVerInfo:=TFileVersionInfo.Create(nil);
    try
    FileVerInfo.ReadFileInfo;
    {writeln('Company: ',FileVerInfo.VersionStrings.Values['CompanyName']);
    writeln('File description: ',FileVerInfo.VersionStrings.Values['FileDescription']);
    writeln('File version: ',FileVerInfo.VersionStrings.Values['FileVersion']);
    writeln('Internal name: ',FileVerInfo.VersionStrings.Values['InternalName']);
    writeln('Legal copyright: ',FileVerInfo.VersionStrings.Values['LegalCopyright']);
    writeln('Original filename: ',FileVerInfo.VersionStrings.Values['OriginalFilename']);
    writeln('Product name: ',FileVerInfo.VersionStrings.Values['ProductName']);
    writeln('Product version: ',FileVerInfo.VersionStrings.Values['ProductVersion']);}

    RequireDerivedFormResource:=True;
    Application.Title:='EasyScriptLauncher';
    Application.Scaled:=True;
    Application.Initialize;

    Application.CreateForm(TFMain, FMain);


    Application.CreateForm(TFAbout, FAbout);
    FAbout.caption:='Easy Script Launcher  '+'Version: '+ FileVerInfo.VersionStrings.Values['FileVersion'];
    FAbout.LabelLegal.caption:=FileVerInfo.VersionStrings.Values['LegalCopyright'];
    FAbout.LabelCompany.caption:=FileVerInfo.VersionStrings.Values['CompanyName'];
    Application.Run;


    finally
    FileVerInfo.Free;
  end;

end.

