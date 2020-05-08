unit Main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, process, Forms, Controls, Graphics, Dialogs, StdCtrls,DateUtils,
  AsyncProcess, ExtCtrls, Menus, ComCtrls, ValEdit, Types,LCLType,umodasyncProcess,Math,uAbout{$IFDEF Windows},shellapi {$ENDIF};
const
  BUF_SIZE = 1024; // Buffer size for reading the output in chunks
var
   WorkingDir,DefaultExecutable,Separator,bash_mount,CurrentFileName,LastWorkbook:String;
   DefaultTimeThreshold,FormWidth,FormHeight,FormTop,FormLeft,OutputHeight:integer;
   LoadLastWorkbook,DefaultOpening:boolean;

type

  { TFMain }


  TFMain = class(TForm)
    AsyncProcess1: TAsyncProcess;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBoxParams: TGroupBox;
    GroupBoxOutputs: TGroupBox;
    ImageList1: TImageList;
    ImageList2: TImageList;
    Label1: TLabel;
    Label2: TLabel;
    ListBoxScripts: TListBox;
    MainMenu1: TMainMenu;
    MemoDocStrings: TMemo;
    MemoParams: TMemo;
    MenuExit: TMenuItem;
    MenuAbout: TMenuItem;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItemTimerThreshold: TMenuItem;
    MenuItemppNormal: TMenuItem;
    MenuItemppRealTime: TMenuItem;
    MenuItemppIdle: TMenuItem;
    MenuItemppHigh: TMenuItem;
    MenuItemPriority: TMenuItem;
    MenuItemEditParams: TMenuItem;
    MenuItemErrors: TMenuItem;
    MenuItemRename: TMenuItem;
    MenuItemStart: TMenuItem;
    MenuItemStop: TMenuItem;
    MenuIOpenWorkbook: TMenuItem;
    MenuItemRunNext: TMenuItem;
    MenuItemSaveWb: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    OpenDialogScript: TOpenDialog;
    OpenDialog2: TOpenDialog;
    PageControlOutput: TPageControl;
    Panel1: TPanel;
    Panel2: TPanel;
    PanelLegend: TPanel;
    PanelScripts: TPanel;
    PopupMenupar: TPopupMenu;
    PopupMenuScripts: TPopupMenu;
    PopupMenu_Par: TPopupMenu;
    SaveDialog1: TSaveDialog;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    Splitter3: TSplitter;
    StatusBar1: TStatusBar;
    Timer1: TTimer;
    TimerStatus: TTimer;
    TimerScripts: TTimer;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButtonRemove: TToolButton;
    ToolButtonSaveAs: TToolButton;
    ToolButtonSave: TToolButton;
    ToolButton2: TToolButton;
    ToolButtonAbout: TToolButton;
    ToolButtonExit: TToolButton;




    procedure AsyncProcess1Terminate(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure EditInputDblClick(Sender: TObject);

    procedure EditInputKeyPress(Sender: TObject; var Key: char);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);




    procedure FormShow(Sender: TObject);
    procedure ListBoxScriptsClick(Sender: TObject);
    procedure ListBoxScriptsDblClick(Sender: TObject);
    procedure ListBoxScriptsDrawItem(Control: TWinControl; Index: Integer;
      ARect: TRect; State: TOwnerDrawState);
    procedure ListBoxScriptsMeasureItem(Control: TWinControl; Index: Integer;
      var AHeight: Integer);


    procedure MemoArgsDblClick(Sender: TObject);
    procedure MemoParamsChange(Sender: TObject);
    procedure MemoParamsDblClick(Sender: TObject);
    procedure MenuAboutClick(Sender: TObject);
    procedure MenuExitClick(Sender: TObject);
    procedure MenuIOpenWorkbookClick(Sender: TObject);
    procedure MenuItemEditParamsClick(Sender: TObject);
    procedure MenuItemErrorsClick(Sender: TObject);
    procedure MenuItemppHighClick(Sender: TObject);
    procedure MenuItemppIdleClick(Sender: TObject);
    procedure MenuItemppNormalClick(Sender: TObject);
    procedure MenuItemppRealTimeClick(Sender: TObject);
    procedure MenuItemRenameClick(Sender: TObject);
    procedure MenuItemStartClick(Sender: TObject);
    procedure MenuItemStopClick(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);

    procedure MenuItem8Click(Sender: TObject);
    procedure MenuItem9Click(Sender: TObject);
    procedure MenuItemRunNextClick(Sender: TObject);
    procedure MenuItemSaveWbClick(Sender: TObject);
    procedure MenuItemTimerThresholdClick(Sender: TObject);

    procedure LoadParameters(AScriptID:integer);
    procedure PopupMenuScriptsPopup(Sender: TObject);
    function ExtractDocStrings(aFilename:string):string;
    procedure SaveWorkBook;
    procedure OpenWorkbook;
    procedure TabSheet1ContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure TimerScriptsTimer(Sender: TObject);

    procedure TimerStatusTimer(Sender: TObject);

    procedure ToolButton2Click(Sender: TObject);
    procedure ToolButtonRemoveClick(Sender: TObject);
    procedure ToolButtonSaveAsClick(Sender: TObject);
    procedure ToolButtonAboutClick(Sender: TObject);
    procedure ToolButtonExitClick(Sender: TObject);
    procedure ToolButtonSaveClick(Sender: TObject);

  private

  public


  end;

var
  FMain: TFMain;

implementation

{$R *.lfm}



{ TFMain }

procedure TFMain.SaveWorkBook;
{ Parse the list of loaded scripts and their parameters and writes the contents
  to a textfile MM 20200430}
var
   WBStringList:TStringList;
   i,j:integer;
begin
     try
       WBStringList:=TStringList.Create;
        for i:=0 to ListboxScripts.Count-1 do
            begin
                 with (ListBoxScripts.Items.Objects[i] as TModAsyncProcess) do
                        begin
                             WBStringList.Add('ScriptName='+Parameters[0]);
                             if successors <>'' then WBStringList.Add('*Successors='+Successors);
                             if predecessor<>-1 then  WBStringList.Add('*Predecessor='+IntToStr(Predecessor));
                             if Executable<>DefaultExecutable  then  WBStringList.Add('*Executable='+Executable);
                             if TimeThreshold<>DefaultTimeThreshold  then  WBStringList.Add('*TimeThreshold='+IntToStr(TimeThreshold));
                             if NickName<>'' then WBStringList.Add('*NickName='+NickName);
                             if Priority<>ppNormal then
                                begin
                                   if Priority = ppHigh then WBStringList.Add('*Priority=ppHigh') else
                                   if Priority = ppIdle then WBStringList.Add('*Priority=ppIdle') else
                                   if Priority = ppRealTime then WBStringList.Add('*Priority=ppRealTime')
                                end;
                             for j:=1 to Parameters.Count-1 do
                                 WBStringList.Add(Parameters[j]);
                        end;
                 WBStringList.Add(Separator)
            end;
          if WBStringList.Count>0 then WBStringList.SaveToFile(CurrentFileName)
     finally
            WBStringList.Free
     end;

end;

procedure TFMain.OpenWorkBook;
{ Workbooks are text files a list of python scripts and their parameters.
  The file is read sequentially:
   1) The name of the python script with the keyword "ScriptName="
   2) A series of parameters taken by the python script.
  The procedure opens the textfile and for each script:
      - it creates an instance of TModAsyncProcess and loads its parameters.
      - it creates an entry in the listbox of scripts "ListBoxScripts" with
      a filename and the associated TModAsyncProcess object MM 20200430}
const
  KeyWordScript = 'ScriptName=';
var
   WBStringList,ParamStringList,ThreadStringList,aDocStringsParams:TStringList;
   i,WBLinesNb,FileTag,Counter,APredecessor,ParamDocStringPosition:integer;
   Aline,anExecutable,aThreadParam,aScriptFilename,aNIckName,ATimeThreshold,Asuccessors,aRawDocStrings:String;
   APriority: TProcessPriority;// (ppHigh,ppIdle,ppNormal,ppRealTime);
   anAsyncProcess:TModAsyncProcess;
   ATabSheet:TTabSheet;
   AListBox,AnErrorListBox:TListBox;
   ASplitter: TSplitter;
   APanelInput:Tpanel;
   anEdit:TEdit;
   aLabel:Tlabel;
   BeginBlock,EndBlock:boolean;
begin
  with OpenDialogScript do
       begin
            FilterIndex:=2;
            if Execute then
               try

                 StatusBar1.Panels[1].Text:=Filename;
                 WBStringList:=TStringList.Create;  // Stores the entire workbook
                  ParamStringList:=TStringList.Create; // Stores the parameters of a thread
                  ThreadStringList:=TStringList.Create; // Stores some other values of a thread. Convention: these start with "*"
                  WBStringList.LoadFromFile(FileName);  //The workbook is loaded  in WBStringList, a TStringList instance

                  WBLinesNb:=WBStringList.Count;
                  Asuccessors:='';
                  Counter:=0;
                  BeginBlock:=False;
                  EndBlock:=False;

                  if  WBLinesNb>0 then // If the workbook isn't empty
                     begin
                          GroupBoxOutputs.visible:=true; // Show the StdOutput panel
                          i:=0;

                          while i<= (WBLinesNb-1) do
                                 begin

                                   ALine:= WBStringList[i]; // Reads a line
                                   FileTag:=pos(KeyWordScript,ALine);  // Checks if the line is a script filename

                                   if FileTag<>0 then // If the line is a script filename
                                      begin
                                           BeginBlock:=True;
                                           Aline:=trim(RightStr(Aline,length(Aline)-length(KeyWordScript))); // Extracts the value of the filename
                                      end;

                                   // if Aline is a thread value store it in the thread params list (not a parameter to be provided to the script )
                                   if Aline[1]='*' then ThreadStringList.add(RightStr(Aline,length(Aline)-1))
                                      else
                                            if Aline<>Separator then ParamStringList.add(Aline); //Separators are ignored

                                   if (i = WBLinesNb-1) then
                                      EndBlock := True
                                   else
                                       EndBlock := pos(KeyWordScript, WBStringList[i+1])<>0;

                                   {Parsing of a thread block in the workbook is done: create the thread and add a corresponding entry in the list of scripts}
                                   if  (BeginBlock and EndBlock) and (ParamStringList.count>0) then
                                      begin

                                           {Step1: check if the workbook has special settings for the thread that override default value}
                                           anExecutable:=trim(ThreadStringList.Values['Executable']);
                                           if anExecutable='' then anExecutable:= DefaultExecutable; //DefaultExecutable is set in the ini file


                                           ATimeThreshold:=trim(ThreadStringList.Values['TimeThreshold']);
                                           if ATimeThreshold='' then ATimeThreshold:= IntToStr(DefaultTimeThreshold);//DefaultTimeThreshold is the TimeThreshold set in the ini file

                                           aThreadParam:=trim(ThreadStringList.Values['Priority']);
                                           if aThreadParam='' then APriority:= ppNormal else
                                           if aThreadParam='ppHigh' then APriority:= ppHigh else
                                           if aThreadParam='ppIdle' then APriority:= ppIdle else
                                           if aThreadParam='ppRealTime' then APriority:= ppRealTime;

                                           Asuccessors:=trim(ThreadStringList.Values['Successors']);

                                           aThreadParam:=trim(ThreadStringList.Values['Predecessor']);
                                           if aThreadParam='' then APredecessor:=-1 else APredecessor:=StrToInt(aThreadParam);


                                           aNIckName:=trim(ThreadStringList.Values['NickName']);

                                           {------ End of Step1}


                                           {Step2: Create an instance of a TModAsyncProcess and set its values and the associated script parameters}
                                           anAsyncProcess:=TModAsyncProcess.create(FMain);
                                           with anAsyncProcess do
                                               begin
                                                    Active:=False;

                                                    {Assign values set at step 1 above}
                                                    Executable:=anExecutable;
                                                    Priority := APriority ;
                                                    Successors:=Asuccessors;
                                                    Predecessor:=APredecessor;
                                                    NIckName:=aNIckName;
                                                    TimeThreshold:=StrToInt(ATimeThreshold);
                                                    {--}


                                                    FillAttribute:=0;
                                                    Options:=[poUsePipes];
                                                    PipeBufferSize:=BUF_SIZE;
                                                    CurrentDirectory:=WorkingDir;
                                                    ErrorCode:=0;

                                                    {$IFDEF Windows}
                                                    ShowWindow := swoHIDE;
                                                    OnTerminate:=@AsyncProcess1Terminate;  // this works only on Windows, not on Linux Manjaro
                                                    {$ENDIF}

                                                    {Assign script parameters}
                                                    Parameters.addstrings(ParamStringList);


                                                    {   The Tag below is important for Linux because OnTerminate is not fired and
                                                         a workaround fix is for a timer "TimerScripts" to execute running threads
                                                         (those with a Tag=1) to the OnTerminate event handler}
                                                    Tag:=0;

                                                    aScriptFilename:= ParamStringList[0];
                                                    { in my version of Windows 10, I installed bash through WSL. Bash uses the linux mount of the file.
                                                    I have to take this into account}
                                                    {$IFDEF Windows}
                                                    if  Executable='bash' then
                                                       begin
                                                            aScriptFilename:=RightStr(aScriptFilename,length(aScriptFilename)-length(bash_mount));
                                                            aScriptFilename:=StringReplace(aScriptFilename,'/','\',[rfReplaceAll]);
                                                            Insert(':',aScriptFilename,2);
                                                       end;
                                                    {$ENDIF}
                                                    {Exctracts the docstrings and the parameters list included in the docstrings.
                                                    convention is to have "Parameters=" to start the list of parameters separated by "|"}
                                                    if FileExists(aScriptFilename) then
                                                       begin
                                                             aRawDocStrings:=ExtractDocStrings(aScriptFilename);
                                                             ParamDocStringPosition:=pos('Parameters=',aRawDocStrings);
                                                             if  ParamDocStringPosition<>0 then
                                                             try
                                                                aDocStringsParams:=TStringList.create;
                                                                aDocStringsParams.Delimiter:='|';
                                                                if ParamDocStringPosition>1 then
                                                                   begin
                                                                     DocStrings:=Copy(aRawDocStrings,1,ParamDocStringPosition-1);

                                                                   end;
                                                                aRawDocStrings:=Copy(aRawDocStrings,ParamDocStringPosition+11, length(aRawDocStrings)-10-ParamDocStringPosition);
                                                                aDocStringsParams.DelimitedText:=aRawDocStrings;
                                                                DocStrings:=DocStrings+Chr(13)+'Parameters are such:'+chr(13)+chr(13)+aDocStringsParams.Text;

                                                             finally
                                                               aDocStringsParams.Free
                                                             end;
                                                       end
                                                    else
                                                        begin
                                                              DocStrings:='';
                                                              Message:='Error=Script not found: ' + aScriptFilename
                                                        end;

                                                    ScriptId:=Counter;
                                                    Counter:=Counter+1;

                                               end;

                                           if aNickName='' then aNickName:=ExtractFileName(aScriptFilename);
                                           ListBoxScripts.AddItem(aNickName,anAsyncProcess);//Add item on list of scripts




                                           {------ End of Step2}


                                           {Step3: Add a tabsheet for this thread's StdOutput}
                                           ATabSheet:= PageControlOutput.AddTabSheet;
                                           with ATabSheet do
                                               begin
                                                 Caption:= aNickName;
                                                 TabVisible:=False;
                                                 ATabSheet.Color:=clblack;
                                               end;


                                           {Displays StdOutput }
                                           AListBox:=TListBox.Create(ATabSheet);
                                           with AListBox do
                                               begin
                                                 Parent:=ATabSheet;
                                                 BorderStyle :=bsNone;
                                                 Align:=alBottom;
                                                 Color:=clBlack;
                                                 Font.Color:=clwhite;
                                                 visible:=true;
                                                 Height:=20;
                                               end;



                                           {Displays StdError}
                                           AnErrorListBox:=TListBox.Create(ATabSheet);
                                           with AnErrorListBox do
                                               begin
                                                   Parent:=ATabSheet;
                                                   BorderStyle :=bsNone;
                                                   Align:=alTop;
                                                   Color:=clBlack;
                                                   Font.Color:=clYellow;
                                                   visible:=true;
                                                   Height:=100;
                                               end;



                                           {A Splitter to increase/decrease the size of the StdError display}
                                           ASplitter:=TSplitter.Create(ATabSheet);
                                            with ASplitter do
                                                begin
                                                     Parent :=ATabSheet;
                                                     Cursor := crVSplit;
                                                     top:=20;
                                                     ResizeAnchor := akBottom;
                                                     Left := 0;
                                                     Height := 2;
                                                     ParentColor:=False;
                                                     Color:=clDefault;
                                                     Align:= alTop;
                                                end;

                                           AListBox.Align:=alClient;

                                           {Create container panel for StdInput.
                                           To mimick the prompt, a TLabel is placed on the left of a TEdit (see below)}
                                           APanelInput:=Tpanel.create(ATabSheet);
                                           with  APanelInput do
                                               begin
                                                    Parent:=ATabSheet;
                                                    Left := 0;
                                                    Height := 30;
                                                    Align := alBottom;
                                                    BevelOuter := bvNone;
                                                    BorderStyle:=bsSingle;
                                                    Color := clBlack;
                                                    ParentColor := False;
                                                    ParentFont := True;
                                               end;

                                           {Create an input line for StdInput}
                                           anEdit:=TEdit.Create(APanelInput);
                                           with anEdit do
                                               begin
                                                   Parent:=APanelInput;
                                                   Left := 9*(Length(anExecutable)+5)+1;
                                                   Height := 30;
                                                   Top := 1;
                                                   Anchors := [akTop, akLeft, akRight];
                                                   echoMode:=emNormal;
                                                   onKeyPress:=@EditInputKeyPress;
                                                   onDblClick:=@EditInputDblClick;
                                                   BorderStyle := bsNone;
                                                   Color := clBlack;
                                                   Font.Color := clLime;
                                                   TabOrder := 0;
                                                   ParentFont := False;
                                                   Text :=''
                                               end;


                                          {Create a prompt label for StdInput}
                                          aLabel :=TLabel.create(APanelInput);
                                          with aLabel do
                                              begin
                                                   Parent:=APanelInput;
                                                    Left := 1 ;
                                                    Height := 25 ;
                                                    Top := 0;
                                                    Width := 20;
                                                    Alignment := taLeftJustify;
                                                    AutoSize := True ;
                                                    Caption := anExecutable+' >>> ' ;
                                                    Color := clBlack ;
                                                    Font.Color := clLime;
                                                    ParentColor := False;
                                                    ParentFont := False;
                                                    Transparent := False ;
                                              end;


                                           {------ End of Step3}

                                           {Step4: Reset reading blocs}
                                           ParamStringList.Clear;
                                           ThreadStringList.Clear;

                                    end;


                                   i:=i+1;
                                 end;
                     end;
                  CurrentFileName:=Filename ;
                  ToolButtonSaveAs.Enabled:=True;
                  if ListBoxScripts.Count>0 then
                     begin
                          ListBoxScripts.ItemIndex:=0;
                          ListBoxScripts.Selected[0]:=true;
                          ListBoxScriptsClick(nil)
                     end;
                  ListBoxScripts.Repaint;
                  Application.ProcessMessages;

               finally
                      WBStringList.Free;
                      ParamStringList.Free;
                      ThreadStringList.Free;

               end;



       end;
end;

procedure TFMain.TabSheet1ContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin

end;

procedure TFMain.TimerScriptsTimer(Sender: TObject);
{$IFDEF Linux}
var
   index:integer;
   AnAsyncProcess: TModAsyncProcess;
{$ENDIF}
begin
     {$IFDEF Linux} //Workaround because OnTerminate not called for TModAsyncProcess on Linux
     for index:=0 to ListBoxScripts.Count-1 do

         begin
               AnAsyncProcess:=ListBoxScripts.Items.Objects[index] as TModAsyncProcess;
               if AnAsyncProcess.Tag = 1 then
                  begin
                       if  not(AnAsyncProcess.Running) then
                          begin
                               AnAsyncProcess.tag:=0;
                               AsyncProcess1Terminate(AnAsyncProcess)
                          end;
                  end;
         end;
     {$ENDIF}
end;





procedure TFMain.TimerStatusTimer(Sender: TObject);
Var
    ReadCount,ReadErrCount,PreviousLength,PreviousLengthErr,AScriptIndex{$IFDEF Linux},lbPreviousCount {$ENDIF}: integer;
    AModAsyncProcess:TModAsyncProcess;
    anOutput,anError:string;
    SomeOutPut,someErrors:boolean;
    SecondsSinceLastUpdate:float;
  begin
       TimerStatus.Enabled:=False;
       SomeOutput:=False ;
       SomeErrors:=False;
       try
          for AScriptIndex:=0 to ListBoxScripts.count-1 do
              begin
                try
                  AModAsyncProcess:=ListBoxScripts.Items.Objects[AScriptIndex] as TModAsyncProcess;
                  if AModAsyncProcess.Running then
                     begin
                       {Read and assign the output pipe value to the thread}
                       ReadCount:= AModAsyncProcess.Output.NumBytesAvailable;
                       anOutput:=AModAsyncProcess.StdOutput; // What is currently in the thread StdOutput
                       {$IFDEF Linux}lbPreviousCount:=(PageControlOutput.Pages[AScriptIndex].Components[0] as TListbox).count;{$ENDIF}
                       while  ReadCount> 0 do
                              begin
                                   PreviousLength:=Length(anOutput);
                                   SetLength(anOutput,PreviousLength+ReadCount);
                                   AModAsyncProcess.Output.Read(anOutput[PreviousLength+1], ReadCount);
                                   ReadCount:= AModAsyncProcess.Output.NumBytesAvailable;
                                   AModAsyncProcess.LastUpdateTime:=now();
                                end;
                       AModAsyncProcess.StdOutput:=anOutput;

                       with PageControlOutput.Pages[AScriptIndex].Components[0] as TListbox do
                           if anOutput<>'' then
                             begin
                                  Items.text:=anOutput;
                                  {$IFDEF Linux} if Count<>lbPreviousCount then  {$ENDIF}
                                  ItemIndex:=count-1;
                                  Visible:=True;
                                  Repaint;
                                  SomeOutput:=True;
                             end ;


                       {Read and assign the Error pipe value to the thread}
                       ReadErrCount:= AModAsyncProcess.Stderr.NumBytesAvailable;
                       anError:=AModAsyncProcess.Errors;
                       while  ReadErrCount> 0 do
                              begin
                                   PreviousLengthErr:=Length(anError);
                                   SetLength(anError,PreviousLengthErr+ReadErrCount);
                                   AModAsyncProcess.Stderr.Read(anError[PreviousLengthErr+1], ReadErrCount);
                                   ReadErrCount:= AModAsyncProcess.Stderr.NumBytesAvailable;
                                   AModAsyncProcess.LastUpdateTime:=now();
                                end;
                       AModAsyncProcess.Errors:=anError;

                       with PageControlOutput.Pages[AScriptIndex].Components[1] as TListbox do
                           if anError<>'' then
                             begin
                                  Items.text:=anError;
                                  ItemIndex:=count-1;
                                  Visible:=True;
                                  Repaint;
                                  SomeErrors:=True;
                             end
                          else visible:=False;


                          SecondsSinceLastUpdate:= SecondsBetween(now,AModAsyncProcess.LastUpdateTime);
                          if SecondsSinceLastUpdate>AModAsyncProcess.TimeThreshold then
                             begin
                                  AModAsyncProcess.LastUpdateTime:=Now();
                                  if MessageDlg('Warning - Process: '+AModAsyncProcess.NickName,'It has been more than '+IntToStr(AModAsyncProcess.TimeThreshold)+' seconds since last response'+chr(13)+
                                  'Stop the process ?',mtConfirmation,[mbNo,mbYes],0)=mrYes then
                                        begin
                                             AModAsyncProcess.Terminate(0);
                                             AModAsyncProcess.ErrorCode:=1;
                                        end
                             end;
                     end;

                   PageControlOutput.Pages[AScriptIndex].TabVisible:=(AModAsyncProcess.StdOutput<>'') or (AModAsyncProcess.Errors<>'');

                finally

                end;
              end;
       finally
              GroupBoxOutputs.visible:=(SomeOutput or SomeErrors or GroupBoxOutputs.visible);
              application.ProcessMessages;
              TimerStatus.Enabled:=true;
       end
  end;



procedure TFMain.ToolButton2Click(Sender: TObject);
begin
     OpenWorkBook;
     ListBoxScripts.repaint;
     application.ProcessMessages;
end;

procedure TFMain.ToolButtonRemoveClick(Sender: TObject);
var i:integer;
begin
  ListBoxScripts.Clear;
  for i:=0 to PageControlOutput.PageCount-1 do
      begin
           PageControlOutput.Pages[0].Destroy;
      end;
  MemoDocStrings.Clear;
  MemoParams.clear ;
  Statusbar1.Panels[1].Text:='';
  GroupBoxOutputs.Visible:=False;


end;

procedure TFMain.ToolButtonSaveAsClick(Sender: TObject);
begin
  with SaveDialog1 do
       begin
            FileName:=OpenDialogScript.Filename;
            FilterIndex:=2;
            if Execute then
                 begin
                      CurrentFileName:=FileName;
                      SaveWorkbook
                 end;
       end;
end;

procedure TFMain.ToolButtonAboutClick(Sender: TObject);
begin
  FAbout.ShowModal;
end;

procedure TFMain.ToolButtonExitClick(Sender: TObject);
begin
  MenuExitClick(Sender)
end;

procedure TFMain.ToolButtonSaveClick(Sender: TObject);
begin
  SaveWorkBook;
  ToolButtonSave.Enabled:=False;
end;

procedure TFMain.AsyncProcess1Terminate(Sender: TObject);

  var
     aDest:string;
     ReadCount,PreviousLength,anIndex,AScriptID:integer;
     anOutput,anError:string;
     SomeOutput,SomeErrors:boolean;
     ListOfSuccessors:TStringList;
  begin
    adest:='';
    with sender as TModAsyncProcess do
         begin
              FinishTime:=now();
              SomeOutput:=False;
              SomeErrors:=False;

              {Reading StdOut one more time}
              ReadCount := Output.NumBytesAvailable;
              if ReadCount> 0 then
                 begin
                   anOutput :=  StdOutput;
                   PreviousLength:=Length(anOutput);
                   SetLength( anOutput,PreviousLength+ReadCount);
                   Output.Read(anOutput[PreviousLength+1], ReadCount);
                   StdOutput:= anOutput;
                   PageControlOutput.ActivePageIndex:=ScriptID;
                   with PageControlOutput.Pages[ScriptID].Components[0] as TListbox do
                       begin
                            if anOUtput<>'' then
                              begin
                                   Items.text:=anOutput;
                                   ItemIndex:=count-1;
                                   SomeOutput:=True;
                                   Visible:=True;
                                   Repaint;
                              end
                       end;
                 end;

              {Reading StErr one more time}
              ReadCount := StdErr.NumBytesAvailable;
              if ReadCount> 0 then
                 begin
                   anError :=  Errors;
                   PreviousLength:=Length(anError);
                   SetLength( anError,PreviousLength+ReadCount);
                   StdErr.Read(anError[PreviousLength+1], ReadCount);
                   Errors:= anError;
                   PageControlOutput.ActivePageIndex:=ScriptID;
                   with PageControlOutput.Pages[ScriptID].Components[1] as TListbox do
                       begin
                           if anError<>'' then
                               begin
                                    Items.text:=anError;
                                    ItemIndex:=count-1;
                                    SomeErrors:=True;
                                    Visible:=True;
                                    Repaint;
                               end
                       end;

                 end;
                 if Errors<>'' then ErrorCode:=2;

             adest:= Parameters.Values['destination'];
             runNb:=RunNb+1;

             if (Successors<>'') and (ErrorCode=0) then
                Try
                    ListOfSuccessors:=TStringList.create;
                    ListOfSuccessors.Delimiter:=';';
                    ListOfSuccessors.DelimitedText:=Successors;
                    for anIndex:=0 to ListOfSuccessors.Count-1 do
                        begin
                           AScriptID:= strToInt(ListOfSuccessors[anIndex]);
                           with (ListBoxScripts.Items.Objects[AScriptID] as TModAsyncProcess)do
                              begin
                                if Running then MessageDlg('Error','Process: '+NickName+' is already running!',mterror,[mbok],0) else
                                   begin
                                     Tag:=1;
                                     StartTime:=now();
                                     LastUpdateTime:= StartTime;
                                     ErrorCode:=0;
                                     Execute;
                                   end
                              end;
                     end;

                    if adest<>'' then
                     begin
                           {$IFDEF Windows}
                           ShellExecute(FMain.Handle, PChar ('open'), PChar (adest),PChar (''), PChar (''), 1);
                           {$ENDIF}
                     end;


                finally
                       ListOfSuccessors.free
                end;
         end;

   GroupBoxOutputs.visible:=(SomeOutput or SomeErrors or GroupBoxOutputs.visible);
    ListBoxScripts.Repaint;
    application.ProcessMessages;
  end;

procedure TFMain.Edit1Change(Sender: TObject);
begin

end;

procedure TFMain.EditInputDblClick(Sender: TObject);
begin
  with (Sender as TEdit)  do
     begin
       if EchoMode = emPassword then  EchoMode:= emNormal
       else  EchoMode:= emPassword
     end;
end;



procedure TFMain.EditInputKeyPress(Sender: TObject; var Key: char);
var
   aCmd:String;
   aCmdSize,ScriptID:integer;
   AModAsyncProcess:TModAsyncProcess;
begin
   try
     if Key = #13 then
      begin
           aCmd:=(Sender as TEdit).Text+#10;
           (Sender as TEdit).Text:='';
           aCmdSize:=length(aCmd);
           ScriptID:= ((((Sender as TEdit).Parent as TPanel).parent as TTabsheet).Parent as TPageControl).TabIndex;
           AModAsyncProcess:=ListBoxScripts.Items.Objects[ScriptID] as TModAsyncProcess;
           AModAsyncProcess.Input.Write(aCmd[1],aCmdSize);
      end;

   Except
     MessageDlg('Error','External hread was not expecting input',mtinformation,[mbOk],0)
   end;
end;

procedure TFMain.FormClose(Sender: TObject; var CloseAction: TCloseAction);
var AStringList:TStringList;
begin
     try
        AStringList:=TStringList.Create;
        AStringList.LoadFromFile('easyscriptlauncher.ini');
        AStringList.Values['FORM WIDTH']:=IntToStr(FMain.Width);
        AStringList.Values['FORM HEIGHT']:=IntToStr(FMain.Height);
        AStringList.Values['FORM TOP']:=IntToStr(FMain.Top);
        AStringList.Values['FORM LEFT']:=IntToStr(FMain.Left);
        if ListBoxScripts.Count >0 then AStringList.Values['LAST WORKBOOK']:= OpenDialogScript.FileName else
        AStringList.Values['LAST WORKBOOK']:='' ;

        AStringList.SaveToFile('easyscriptlauncher.ini');
     finally
            AStringList.Free
     end;
end;



procedure TFMain.FormShow(Sender: TObject);
var AStringList:TStringList;
begin
  try
    {Loads and reads program initialization file}
    AStringList:=TStringList.Create;
    AStringList.LoadFromFile('easyscriptlauncher.ini');
    WorkingDir:= Trim(AStringList.Values['DIRECTORY']);
    DefaultExecutable:= Trim(AStringList.Values['EXECUTABLE']);
    Separator:=Trim(AStringList.Values['SEPARATOR']);
    DefaultTimeThreshold:=StrToInt(Trim(AStringList.Values['TIME THRESHOLD']));
    bash_mount:=Trim(AStringList.Values['BASH MOUNT']);
    FormWidth :=StrToInt(Trim(AStringList.Values['FORM WIDTH']));
    FormHeight :=StrToInt(Trim(AStringList.Values['FORM HEIGHT']));
    FormTop :=StrToInt(Trim(AStringList.Values['FORM TOP']));
    FormLeft :=StrToInt(Trim(AStringList.Values['FORM LEFT']));
    LastWorkbook :=Trim(AStringList.Values['LAST WORKBOOK']);
    LoadLastWorkbook :=StrToBool(Trim(AStringList.Values['LOAD LAST WORKBOOK']));
    DefaultOpening :=StrToBool(Trim(AStringList.Values['DEFAULT OPENING']));
    OutputHeight := StrToInt(Trim(AStringList.Values['OUTPUT HEIGHT']));
    OpenDialogScript.FileName:=LastWorkbook;

    FMain.Width:=FormWidth;
    FMain.Height:=FormHeight;
    FMain.Top:=FormTop;
    FMain.Left:=FormLeft;
    GroupBoxOutputs.Height:=OutputHeight;

    OpenDialogScript.InitialDir:= WorkingDir;
    OpenDialog2.InitialDir:= WorkingDir;
    SaveDialog1.InitialDir:= WorkingDir;
    CurrentFileName:='';
   finally
          AStringList.Free
   end;
end;

procedure TFMain.ListBoxScriptsClick(Sender: TObject);
var
   ScriptPosition:integer;
   anAsyncProcess:TModAsyncProcess;
   ExecTimes:String;
begin
     ScriptPosition:=ListBoxScripts.ItemIndex;
     ListBoxScripts.Repaint;///
     if ScriptPosition <>-1 then
        begin
          LoadParameters(ScriptPosition);
          anAsyncProcess:= ListBoxScripts.Items.Objects[ScriptPosition] as TModAsyncProcess;
             ExecTimes:='';
             if anAsyncProcess.running then ExecTimes:='Started: '+FormatDateTime('hh:mm:ss',anAsyncProcess.startTime) else
             if (anAsyncProcess.RunNb>0) then ExecTimes  :='Started: '+FormatDateTime('hh:mm:ss',anAsyncProcess.startTime)+' - Finished: '+ FormatDateTime('hh:mm:ss',anAsyncProcess.FinishTime);
             MemoDocStrings.lines.clear;
             MemoDocStrings.lines.add(anAsyncProcess.Message+chr(13)+ExecTimes+chr(13)+anAsyncProcess.DocStrings);
             MemoParams.Enabled:= not(anAsyncProcess.Running);
             PageControlOutput.ActivePageIndex:=ScriptPosition;
        end;
end;

procedure TFMain.ListBoxScriptsDblClick(Sender: TObject);
var
   ScriptPosition:integer;
   anAsyncProcess:TModAsyncProcess;
begin
     ScriptPosition:=ListBoxScripts.ItemIndex;
     if ScriptPosition <>-1 then
        begin
              anAsyncProcess:= ListBoxScripts.Items.Objects[ScriptPosition] as TModAsyncProcess;
              if  anAsyncProcess.Running then
                 begin
                       anAsyncProcess.ShowWindow:= swoRestore

                 end
              else   if MessageDlg('Question','Launch selected script?',mtconfirmation,[mbYes,mbNo],0)=mrYes then MenuItemStartClick(sender)
        end;

end;

procedure TFMain.ListBoxScriptsDrawItem(Control: TWinControl; Index: Integer;
  ARect: TRect; State: TOwnerDrawState);
var
  aScriptThread:  TModAsyncProcess;
  ScriptRunning, alreadyRan,hasWarningMessage,hasError,WasStopped,ScriptSelected:boolean;
  CenterText,imageIndex,SelectedScriptID,aPredecessor: integer;
  aBackColor:TColor;
  aSuccessors:String;
begin
     {The list of scripts is stored in ListBoxScripts, a TListbox.
      Custom drawing is implemented to reflect different properties/status of the scripts threads.}
     ScriptRunning:=False;
     alreadyRan:=False;
     hasError:=False;
     WasStopped:=False;
     ScriptSelected:= odSelected in State;
     SelectedScriptID:= ListBoxScripts.ItemIndex;
     aScriptThread :=  (ListBoxScripts.Items.Objects[Index] as TModAsyncProcess);
     if aScriptThread<> nil then
        with aScriptThread do
        begin
             ScriptRunning :=Running;
             alreadyRan:= RunNb >0;
             hasWarningMessage:=Message<>'';
             hasError:=Errors<>'';
             WasStopped:= ErrorCode=1;
             aPredecessor:=Predecessor;
             aSuccessors:=Successors;
        end;

     {Use colors to show dependencies}
     if ScriptSelected then
        begin
             aBackColor:=clHighlight;
        end
     else
         begin
              {Show successor threads in Yellow}
              aBackColor:=cldefault;
              if aPredecessor =  SelectedScriptID then aBackColor:=$0080BFFF;
              if pos(IntTostr(SelectedScriptID)+';',aSuccessors+';')<>0 then  aBackColor:=$0077FF77;
         end  ;

     if ScriptRunning then imageIndex:= 1 else
     if alreadyRan  then
        begin
             if hasError then imageIndex:=4 else imageIndex:=2 ;
             if  WasStopped then  imageIndex:=5
        end
     else
         if hasWarningMessage then imageIndex:=3 else
     imageIndex:=0;
     ListBoxScripts.Canvas.Brush.Color:=aBackColor;
     ListBoxScripts.Canvas.FillRect(ARect);

     ImageList1.Draw(ListBoxScripts.Canvas,Arect.Left + 4, Arect.Top + 4, imageIndex );
     CenterText := ( Arect.Bottom - Arect.Top - ListBoxScripts.Canvas.TextHeight(text)) div 2 ;

     ListBoxScripts.Canvas.TextOut (Arect.left + ImageList1.Width + 8 , Arect.Top + CenterText,
     ListBoxScripts.Items.Strings[index]);

end;

procedure TFMain.ListBoxScriptsMeasureItem(Control: TWinControl;
  Index: Integer; var AHeight: Integer);
begin
      AHeight:= ImageList1.Height + 6;
end;




procedure TFMain.MemoArgsDblClick(Sender: TObject);
begin

end;



procedure TFMain.MemoParamsChange(Sender: TObject);
var
   ScriptPosition:integer;
begin
     {Any change on MemoParams is immediately applied to the selected script,
      unless MemoParams Tag is set to a value different than zero}
     if MemoParams.Tag=0 then
        begin
             ScriptPosition:=ListBoxScripts.ItemIndex;
             if ScriptPosition <>-1 then
                begin
                     with (ListBoxScripts.Items.Objects[ScriptPosition] as TModAsyncProcess) do
                        begin
                             Parameters.clear;
                             Parameters.addstrings(MemoParams.lines);
                        end;
                     ToolButtonSave.Enabled:=True;
                end;
        end;
end;

procedure TFMain.MemoParamsDblClick(Sender: TObject);
begin
     with MemoParams do
     if ReadOnly then
        begin
          ReadOnly:=False;
          Hint:='Double-click to disable editing';
          Color:=clDefault

        end
     else
         begin
              ReadOnly:=True;
              Hint:='Double-click to edit';
              Color:=clBtnFace
         end;
end;

procedure TFMain.MenuAboutClick(Sender: TObject);
begin
  FAbout.ShowModal;
end;

procedure TFMain.MenuExitClick(Sender: TObject);
begin
    if ToolButtonSave.Enabled then
       case QuestionDlg('Exiting application','Save changes before exiting?',mtWarning,[mrCancel,mrYes,mrNo],0) of
           mrYes:
                begin
                     SaveWorkBook;
                     FMain.Close;
                     //Application.Terminate
                end ;
          mrNo: FMain.Close; //Application.Terminate
       end
    else FMain.Close; //Application.Terminate
end;

procedure TFMain.MenuIOpenWorkbookClick(Sender: TObject);
begin
  OpenWorkBook
end;

procedure TFMain.MenuItemEditParamsClick(Sender: TObject);
begin

end;

procedure TFMain.MenuItemErrorsClick(Sender: TObject);
var
   ScriptPosition:integer;
   anAsyncProcess :TModAsyncProcess;
begin
     ScriptPosition:=ListBoxScripts.ItemIndex; //Getting the selected script in the list box
     if ScriptPosition <>-1 then //Getting and launching the associated process
        begin
          anAsyncProcess:=(ListBoxScripts.Items.Objects[ScriptPosition] as TModAsyncProcess);
          showmessage(anAsyncProcess.Errors)
        end;
end;

procedure TFMain.MenuItemppHighClick(Sender: TObject);
var
   ScriptPosition:integer;
   anAsyncProcess :TModAsyncProcess;
begin
     ScriptPosition:=ListBoxScripts.ItemIndex; //Getting the selected script in the list box
     if ScriptPosition <>-1 then //Getting and launching the associated process
        begin
          anAsyncProcess:=(ListBoxScripts.Items.Objects[ScriptPosition] as TModAsyncProcess);
          if MenuItemppHigh.Checked then  anAsyncProcess.Priority:=ppHigh else anAsyncProcess.Priority:=ppNormal;
          ToolButtonSave.Enabled:=True;

        end;
end;

procedure TFMain.MenuItemppIdleClick(Sender: TObject);
var
   ScriptPosition:integer;
   anAsyncProcess :TModAsyncProcess;
begin
     ScriptPosition:=ListBoxScripts.ItemIndex; //Getting the selected script in the list box
     if ScriptPosition <>-1 then //Getting and launching the associated process
        begin
          anAsyncProcess:=(ListBoxScripts.Items.Objects[ScriptPosition] as TModAsyncProcess);
          if MenuItemppIdle.Checked then  anAsyncProcess.Priority:=ppIdle else anAsyncProcess.Priority:=ppNormal;
          ToolButtonSave.Enabled:=True;

        end;
end;

procedure TFMain.MenuItemppNormalClick(Sender: TObject);
var
   ScriptPosition:integer;
   anAsyncProcess :TModAsyncProcess;
begin
     ScriptPosition:=ListBoxScripts.ItemIndex; //Getting the selected script in the list box
     if ScriptPosition <>-1 then //Getting and launching the associated process
        begin
          anAsyncProcess:=(ListBoxScripts.Items.Objects[ScriptPosition] as TModAsyncProcess);
          if MenuItemppNormal.Checked then  anAsyncProcess.Priority:=ppNormal;
          ToolButtonSave.Enabled:=True;

        end;
end;

procedure TFMain.MenuItemppRealTimeClick(Sender: TObject);
var
   ScriptPosition:integer;
   anAsyncProcess :TModAsyncProcess;
begin
     ScriptPosition:=ListBoxScripts.ItemIndex; //Getting the selected script in the list box
     if ScriptPosition <>-1 then //Getting and launching the associated process
        begin
          anAsyncProcess:=(ListBoxScripts.Items.Objects[ScriptPosition] as TModAsyncProcess);
          if MenuItemppRealTime.Checked then  anAsyncProcess.Priority:=ppRealTime else anAsyncProcess.Priority:=ppNormal;
          ToolButtonSave.Enabled:=True;

        end;
end;

procedure TFMain.MenuItemRenameClick(Sender: TObject);
var
   ScriptPosition:integer;
   anAsyncProcess :TModAsyncProcess;
   aNickName:String;
begin
     ScriptPosition:=ListBoxScripts.ItemIndex; //Getting the selected script in the list box
     if ScriptPosition <>-1 then //Getting and launching the associated process
        begin
          anAsyncProcess:=(ListBoxScripts.Items.Objects[ScriptPosition] as TModAsyncProcess);
          if  InputQuery('Script Nickname', 'Please input', aNickName) then
             begin
                   aNickName:=trim(aNickName);
                   if aNickName<>'' then
                      begin
                           anAsyncProcess.NickName:=aNickName;
                           ListBoxScripts.Items[ScriptPosition]:=aNickName;
                           ToolButtonSave.Enabled:=True;
                      end;
             end;

        end;
end;

procedure TFMain.MenuItemStartClick(Sender: TObject);
var
   ScriptPosition:integer;
   anAsyncProcess :TModAsyncProcess;
begin
     ScriptPosition:=ListBoxScripts.ItemIndex; //Getting the selected script in the list box
     if ScriptPosition <>-1 then //Getting and launching the associated process
        begin
          anAsyncProcess:=(ListBoxScripts.Items.Objects[ScriptPosition] as TModAsyncProcess);
          with  anAsyncProcess do
                begin
                     if running then showmessage('Thread is already running') else
                        begin
                          {$IFDEF Linux} //OnTerminateEvent isn't fired on linux. Workaround using timer TimerScripts checking process tag value
                          Tag:=1;
                         {$ENDIF}
                         StdOutput:='';
                         Errors:='';
                         StartTime:=now();
                         LastUpdateTime:= StartTime;
                         ErrorCode:=0;
                         Execute ;
                         TimerStatus.Enabled :=true;
                        end;
                end;
        end;
end;

procedure TFMain.MenuItemStopClick(Sender: TObject);
var
   ScriptPosition:integer;
   anAsyncProcess :TModAsyncProcess;
begin
     ScriptPosition:=ListBoxScripts.ItemIndex;
     if ScriptPosition <>-1 then
        begin
          anAsyncProcess:=(ListBoxScripts.Items.Objects[ScriptPosition] as TModAsyncProcess);
          anAsyncProcess.Terminate(0);
          anAsyncProcess.ErrorCode:=1;

        end;
end;

procedure TFMain.MenuItem1Click(Sender: TObject);
begin
  Application.Terminate
end;

function TFMain.ExtractDocStrings(aFilename:string):string;
{ For python scripts: returns the DocStrings of the "main" function}
const
  Keyword = 'def main(argv):' ;
var
  MainLocation,NbLines,i: integer;
  Description:String;
begin
     Result:='<No such file>' ;
     if FileExists(aFilename) then
         with TStringList.Create do
              try
                 LoadFromFile(aFilename);
                 NbLines:=count;
                 MainLocation:=IndexOf(Keyword);
                 Result:='' ;
                 if MainLocation<>-1 then
                    begin
                      i:=MainLocation;
                      Description:=Trim(strings[i]);
                      {Look for the beginning of Docstrings}
                      while (i<NbLines-1) and  (LeftStr(Description,3)<>'"""') do
                            begin
                                 i:=i+1;
                                 Description:=Trim(strings[i]);
                            end;
                      if i=NbLines-1 then
                         begin
                              if RightStr(Description,3)='"""' then
                                 result :=  Copy(Description,4,Length(Description)-6)
                         end
                      else
                          begin
                            Result:= Copy(Description,4,Length(Description)-3);
                            repeat
                                  i:=i+1;
                                  Description:=Trim(strings[i]);
                                  Result:=Result+Description;

                            until (i=NbLines-1) or  (RightStr(Description,3)='"""') ;
                            Result:=copy(Result,1,length(Result)-3)

                          end;
                    end;

              finally
                Free;
              end
end;







procedure TFMain.MenuItem8Click(Sender: TObject);

begin
  with OpenDialog2 do
       if execute then
          begin
            MemoParams.Lines.LoadFromFile(filename);


          end;
end;

procedure TFMain.MenuItem9Click(Sender: TObject);
begin
    with SaveDialog1 do
       if execute then
          begin
            MemoParams.Lines.SaveToFile(filename);
          end;
end;

procedure TFMain.MenuItemRunNextClick(Sender: TObject);
var
   ScriptPosition,AnIndex:integer;
   PredecessorProcess :TModAsyncProcess;
   SuccessorScriptList:TStringlist;
   SuccessorsNames, PredecessorName:string;
begin
     { Implements what scripts are called next to the termination of a given script.
       Clicking on this popup menu sets the dependancies of the selected scripts:
        - The last clicked script is the predecessor of all other selected scripts
        - If there is only one selection and
             - the ckeckbox is checked: the script will call itself
             - the checkbox is uncked: the script won't have any successors}

   {Getting the predecessor script in the list box}
   ScriptPosition:=ListBoxScripts.ItemIndex;


   {Now parsing the list of selected scripts. }
     if ScriptPosition <>-1 then
        begin
          SuccessorsNames:='';
          PredecessorName:= ListBoxScripts.Items[ScriptPosition]+' (script '+IntToStr(ScriptPosition)+')';
          PredecessorProcess:=(ListBoxScripts.Items.Objects[ScriptPosition] as TModAsyncProcess);
          with  PredecessorProcess do
             try
                SuccessorScriptList:=TStringlist.Create;
                SuccessorScriptList.Delimiter:=';';

                for AnIndex:=0 to listboxscripts.count-1 do
                   if ListBoxScripts.Selected[anIndex] then
                      begin
                          if (anIndex=ScriptPosition) then
                             begin
                                  if  (MenuItemRunNext.Checked) then
                                     begin
                                          SuccessorScriptList.Add(IntToStr(AnIndex));
                                          SuccessorsNames:= SuccessorsNames+ListBoxScripts.Items[anIndex]+' (script '+IntToStr(anIndex)+')' +chr(13);
                                     end;
                             end
                          else
                              begin
                                   (ListBoxScripts.Items.Objects[AnIndex] as TModAsyncProcess).predecessor:=ScriptPosition;
                                   SuccessorScriptList.Add(IntToStr(AnIndex));
                                   SuccessorsNames:= SuccessorsNames+ListBoxScripts.Items[anIndex]+' (script '+IntToStr(anIndex)+')' +chr(13);
                              end;
                      end;

                {Display recap and assign Successors to PredecessorProcess}
                if SuccessorsNames='' then SuccessorsNames:='<None>';
                if  MessageDlg('Dependencies','Upon termination of: '+ PredecessorName +','+chr(13)+'the following scripts will launch:'+chr(13)+chr(13)+SuccessorsNames,
                mtConfirmation,[mbCancel,Mbok],0) = mrok then
                   begin
                     Successors:= SuccessorScriptList.DelimitedText;
                     ListBoxScripts.ClearSelection;
                     ToolButtonSave.Enabled:=True;
                   end;

             finally
                    SuccessorScriptList.Free ;

             end;
        end;

end;

procedure TFMain.MenuItemSaveWbClick(Sender: TObject);
begin
  SaveWorkBook
end;

procedure TFMain.MenuItemTimerThresholdClick(Sender: TObject);
var
   ScriptPosition,AThreshold:integer;
   anAsyncProcess :TModAsyncProcess;
   aValue:string;
begin
     ScriptPosition:=ListBoxScripts.ItemIndex; //Getting the selected script in the list box
     if ScriptPosition <>-1 then //Getting and launching the associated process
        begin
          anAsyncProcess:=(ListBoxScripts.Items.Objects[ScriptPosition] as TModAsyncProcess);
          AThreshold:= anAsyncProcess.TimeThreshold;
          AValue:=IntToStr(AThreshold);
          if  InputQuery('Timer Threshold', 'Input number of seconds', aValue) then
             try
                   AThreshold:=StrToInt(trim(aValue));
                   anAsyncProcess.TimeThreshold := AThreshold;
                   ToolButtonSave.Enabled:=True;
             except
                   MessageDlg('Error','The input must be an integer',mtError,[mbok],0)
             end;

        end;
end;

procedure TFMain.LoadParameters(AScriptID:integer);
{ For a given AScriptID, loads the associated thread parameters into the MemoParams TMemo.
  Since anychange to MemoParams also updates the currently selected thread, we set MemoParams tag to 1
  during the loading to avoid a vicious circle.}
var
   anAsyncProcess : TModAsyncProcess;
begin
        try
           MemoParams.Tag:=1;//Disable immediate update of current script parameters
           anAsyncProcess:= ListBoxScripts.Items.Objects[AScriptID] as TModAsyncProcess;
           MemoParams.lines.clear;
           MemoParams.lines.addstrings(anAsyncProcess.Parameters);
        finally
               MemoParams.Tag:=0;//Enable immediate update of current script parameters
        end;
  end;

procedure TFMain.PopupMenuScriptsPopup(Sender: TObject);
var ScriptPosition:integer;
begin
  ScriptPosition:=ListBoxScripts.ItemIndex;
  if ScriptPosition <>-1 then
     with (ListBoxScripts.Items.Objects[ScriptPosition] as TModAsyncProcess) do
     begin
      // MessageDlg('Python Script Launcher',Parameters[0]+chr(13)+'Successor: '+inttostr(Successor),mtInformation,[mbok],0);
       MenuItemStart.Enabled:=not(Running) and (Message='');
       MenuItemRunNext.Checked:=pos(IntTostr(ScriptPosition)+';',Successors+';')<>0;
       MenuItemppNormal.Checked:=Priority=ppNormal;
       MenuItemppIdle.Checked:=Priority=ppIdle;
       MenuItemppHigh.Checked:=Priority=ppHigh;
       MenuItemppRealTime.Checked:=Priority=ppRealTime;
       MenuItemStop.Enabled:=Running;
       MenuItemErrors.Enabled:=Errors<>'';

     end;

end;







end.

