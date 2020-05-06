unit umodasyncProcess;

{$mode objfpc}{$H+}

interface

uses
 Classes, SysUtils, process, Forms, Controls, Graphics, Dialogs, StdCtrls,
  AsyncProcess, ExtCtrls, Menus, ComCtrls, ValEdit, Types,LCLType {$IFDEF Windows},shellapi {$ENDIF};
 {A class derived from TAsyncProcess that handles additional properties MM20200430}
type
  TModAsyncProcess = class(TAsyncProcess)
  private
         fsuccessors:string ;
         fpredecessor:integer;
         fRunNb :integer;
         fDocStrings:string;
         fStdOutput :string;
         FScriptID:integer;
         fMessage :string;
         fStartTime: TDateTime;
         fFinishTime : TDateTime;
         fLastUpdateTime : TDateTime;
         fNickName:string;
         fErrors:string;
         fTimeThreshold:integer;
         fErrorCode:integer;
  protected
         function GetPredecessor:integer;
         procedure SetPredecessor(aValue:integer);
         function GetSuccessors:string;
         procedure SetSuccessors(aValue:string);
         function GetRunNb:integer;
         procedure SetRunNb(aValue:integer);
         function GetDocStrings:String;
         procedure SetDocStrings(aValue:String);
         function GetStdOutput:String;
         procedure SetStdOutput(aValue:String);
         function GetScriptID:integer;
         procedure SetScriptID(aValue:integer);
         function GetMessage:String;
         procedure SetMessage(aValue:String);
         function GetStartTime:TDateTime;
         procedure SetStartTime(aValue:TDateTime);
         function GetFinishTime:TDateTime;
         procedure SetFinishTime(aValue:TDateTime);
         function GetLastUpdateTime:TDateTime;
         procedure SetLastUpdateTime(aValue:TDateTime);
         function GetNickName:String;
         procedure SetNickName(aValue:String);
         function GetErrors:String;
         procedure SetErrors(aValue:String);
         function GetTimeThreshold:Integer;
         procedure SetTimeThreshold(aValue:Integer);
         function GetErrorCode:Integer;
         procedure SetErrorCode(aValue:Integer);
  published
           property predecessor:integer read GetPredecessor write SetPredecessor default -1;  // Identifier of the preceeding thread
           property successors:string read Getsuccessors write Setsuccessors; // Identifier of the following thread
           property RunNb:integer read GetRunNb write SetRunNb default 0;  // Number of executions completed
           property DocStrings:string read GetDocStrings write SetDocStrings; // DocStrings from the python script
           property StdOutput:string read  GetStdOutput write SetStdOutput;  // Text stored in StdOutput
           property ScriptID:integer read  GetScriptID write SetScriptID;  // Thread identifier
           property Message:string read  GetMessage write SetMessage;   // Other Info on thread
           property StartTime: TDateTime read  GetStartTime write SetStartTime; // Last start execution time
           property FinishTime : TDateTime read  GetFinishTime write SetFinishTime; // Last end execution time
           property LastUpdateTime: TDateTime read  GetLastUpdateTime write SetLastUpdateTime;// Last time bytes available on StdOutput or StdError
           property NickName:string read  GetNickName write SetNickName;
           property Errors:string read  GetErrors write SetErrors;
           property TimeThreshold:integer read GetTimeThreshold write SetTimeThreshold; // Time check in seconds before warning of inactivity
           property ErrorCode:integer read GetErrorCode write SetErrorCode;


  end;

implementation

function TModAsyncProcess.GetPredecessor:integer;
begin
  result:=fpredecessor
end;

procedure TModAsyncProcess.SetPredecessor(aValue:integer);
begin
     fpredecessor:=aValue
end;

function TModAsyncProcess.Getsuccessors:string;
begin
  result:=fsuccessors
end;

procedure TModAsyncProcess.Setsuccessors(aValue:string);
begin
     fsuccessors:=aValue
end;

function TModAsyncProcess.GetRunNb:integer;
begin
  result:=fRunNb
end;

procedure TModAsyncProcess.SetRunNb(aValue:integer);
begin
     fRunNb:=aValue
end;

function TModAsyncProcess.GetDocStrings:String;
begin
  result:=fDocStrings
end;

procedure TModAsyncProcess.SetDocStrings(aValue:String);
begin
     fDocStrings:=aValue
end;

function TModAsyncProcess.GetStdOutput:String;
begin
  result:=fStdOutput
end;

procedure TModAsyncProcess.SetStdOutput(aValue:String);
begin
     fStdOutput:=aValue
end;

function TModAsyncProcess.GetScriptID:integer;
begin
  result:=fScriptID
end;

procedure TModAsyncProcess.SetScriptID(aValue:integer);
begin
     fScriptID:=aValue
end;
function TModAsyncProcess.GetMessage:String;
begin
  result:=fMessage
end;

procedure TModAsyncProcess.SetMessage(aValue:String);
begin
     fMessage:=aValue
end;
function TModAsyncProcess.GetStartTime:TDateTime;
begin
  result:=fStartTime
end;

procedure TModAsyncProcess.SetStartTime(aValue:TDateTime);
begin
     fStartTime:=aValue
end;
function TModAsyncProcess.GetFinishTime:TDateTime;
begin
  result:=fFinishTime
end;

procedure TModAsyncProcess.SetFinishTime(aValue:TDateTime);
begin
     fFinishTime:=aValue
end;
function TModAsyncProcess.GetNickName:String;
begin
  result:=fNickName
end;


function TModAsyncProcess.GetLastUpdateTime:TDateTime;
begin
  result:=fLastUpdateTime
end;

procedure TModAsyncProcess.SetLastUpdateTime(aValue:TDateTime);
begin
     fLastUpdateTime:=aValue
end;



procedure TModAsyncProcess.SetNickName(aValue:String);
begin
     fNickName:=aValue
end;
function TModAsyncProcess.GetErrors:String;
begin
  result:=fErrors
end;

procedure TModAsyncProcess.SetErrors(aValue:String);
begin
     fErrors:=aValue
end;


function TModAsyncProcess.GetTimeThreshold:Integer;
begin
  result:=fTimeThreshold
end;

procedure TModAsyncProcess.SetTimeThreshold(aValue:Integer);
begin
     fTimeThreshold:=aValue
end;



function TModAsyncProcess.GetErrorCode:Integer;
begin
  result:=fErrorCode
end;

procedure TModAsyncProcess.SetErrorCode(aValue:Integer);
begin
     fErrorCode:=aValue
end;
end.

