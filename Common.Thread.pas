unit Common.Thread;

interface

uses System.Classes, System.SysUtils;

type

  TThredHelper = class helper for TThread
  public
    class function Run(const AThreadProc: TProc): TThread; overload; static;
    class function Run(const AMeth: TThreadMethod): TThread; overload; static;
    class procedure Stop(var AThread: TThread); static;
  end;

implementation

{ TThredHelper }

class function TThredHelper.Run(const AThreadProc: TProc): TThread;
begin
  Result := TThread.CreateAnonymousThread(AThreadProc);
  Result.FreeOnTerminate := False;
  Result.Start;
end;

class function TThredHelper.Run(const AMeth: TThreadMethod): TThread;
begin
  Result := Run(
    procedure
    begin
      AMeth;
    end);
end;

class procedure TThredHelper.Stop(var AThread: TThread);
begin
  if not Assigned(AThread) then
    Exit;

  AThread.Terminate;
  AThread.WaitFor;
  FreeAndNil(AThread);
end;

end.
