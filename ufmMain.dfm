object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'Shared memory'
  ClientHeight = 360
  ClientWidth = 260
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    260
    360)
  PixelsPerInch = 96
  TextHeight = 13
  object btnWrite: TButton
    Left = 8
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Write'
    TabOrder = 0
    OnClick = btnWriteClick
  end
  object btnRead: TButton
    Left = 8
    Top = 83
    Width = 75
    Height = 25
    Caption = 'Read'
    TabOrder = 1
    OnClick = btnReadClick
  end
  object mmoData: TMemo
    Left = 8
    Top = 114
    Width = 241
    Height = 238
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 2
    ExplicitWidth = 164
    ExplicitHeight = 159
  end
  object btnThreadWrite: TButton
    Left = 97
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Thread write'
    TabOrder = 3
    OnClick = btnThreadWriteClick
  end
  object edtMonitor: TEdit
    Left = 8
    Top = 39
    Width = 241
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    ReadOnly = True
    TabOrder = 4
    ExplicitWidth = 164
  end
  object btnThreadRead: TButton
    Left = 97
    Top = 83
    Width = 75
    Height = 25
    Caption = 'Thread read'
    TabOrder = 5
    OnClick = btnThreadReadClick
  end
end
