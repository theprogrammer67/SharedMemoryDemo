unit ufmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Common.Thread;

type
  TfrmMain = class(TForm)
    btnWrite: TButton;
    btnRead: TButton;
    mmoData: TMemo;
    btnThreadWrite: TButton;
    edtMonitor: TEdit;
    btnThreadRead: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnWriteClick(Sender: TObject);
    procedure btnReadClick(Sender: TObject);
    procedure btnThreadWriteClick(Sender: TObject);
    procedure btnThreadReadClick(Sender: TObject);
  private
    FWriteThread: TThread;
    FReadThread: TThread;
  private
    procedure WriteThreadProc;
    procedure ReadThreadProc;
  public
    { Public declarations }
  end;

  TDataRecord = record
    StrData1: ShortString;
    StrData2: string[50];
    IntData: Integer;
  end;

  PDataRecord = ^TDataRecord;

var
  DataRecord: TDataRecord;
  hFileMapping: THandle; // Mapping handle obtained using CreateFileMapping
  SharedDataRecord: PDataRecord;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure TfrmMain.btnThreadReadClick(Sender: TObject);
begin
  if Assigned(FReadThread) and (not FReadThread.Finished) then
  begin
    TThread.Stop(FReadThread);
    Exit;
  end;

  FReadThread := TThread.Run(ReadThreadProc);
end;

procedure TfrmMain.btnThreadWriteClick(Sender: TObject);
begin
  if Assigned(FWriteThread) and (not FWriteThread.Finished) then
  begin
    TThread.Stop(FWriteThread);
    Exit;
  end;

  FWriteThread := TThread.Run(WriteThreadProc);
end;

procedure TfrmMain.btnWriteClick(Sender: TObject);
begin
  SharedDataRecord^.StrData1 := 'First';
  SharedDataRecord^.StrData2 := 'Second';
  SharedDataRecord^.IntData := 12345;
end;

procedure TfrmMain.btnReadClick(Sender: TObject);
begin
  mmoData.Lines.Add(Format('%s, %s, %d', [SharedDataRecord^.StrData1,
    SharedDataRecord^.StrData2, SharedDataRecord^.IntData]));
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  hFileMapping := CreateFileMapping(0, nil, PAGE_READWRITE, 0,
    SizeOf(TDataRecord), 'DataRecord');
  if hFileMapping = 0 then
    RaiseLastOSError;
  SharedDataRecord := MapViewOfFile(hFileMapping, FILE_MAP_READ or
    FILE_MAP_WRITE, 0, 0, SizeOf(TDataRecord));
  if SharedDataRecord = nil then
    RaiseLastOSError;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  TThread.Stop(FReadThread);
  TThread.Stop(FWriteThread);
  UnmapViewOfFile(SharedDataRecord);
  CloseHandle(hFileMapping);
end;

procedure TfrmMain.ReadThreadProc;
begin
  while not TThread.CheckTerminated do
  begin
    TThread.Queue(nil,
      procedure
      begin
        mmoData.Lines.Add(Format('%s, %s, %d', [SharedDataRecord^.StrData1,
          SharedDataRecord^.StrData2, SharedDataRecord^.IntData]));
      end);
    Sleep(100);
  end;
end;

procedure TfrmMain.WriteThreadProc;
var
  LNum: Integer;
begin
  LNum := 0;
  while not TThread.CheckTerminated do
  begin
    SharedDataRecord^.StrData1 := 'First_' + ShortString(IntToStr(LNum));
    SharedDataRecord^.StrData2 := 'Second_' + ShortString(IntToStr(LNum));
    SharedDataRecord^.IntData := LNum;

    TThread.Queue(nil,
      procedure
      begin
        edtMonitor.Text := Format('%s, %s, %d', [SharedDataRecord^.StrData1,
          SharedDataRecord^.StrData2, SharedDataRecord^.IntData]);
      end);

    Inc(LNum);
    Sleep(1);
  end;
end;

end.
