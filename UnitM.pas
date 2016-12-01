unit UnitM;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Menus, ShellApi, IniFiles;

const
  WM_ICONTRAY = WM_USER + 1;

type
  TFrm = class(TForm)
    Timer: TTimer;
    PopupMenu: TPopupMenu;
    pmQuit: TMenuItem;
    procedure TimerTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure pmQuitClick(Sender: TObject);
  private
    { Private declarations }
    TrayIconData: TNotifyIconData;
    function WinTab(): Boolean;
    function CtrlWinArrow(): Boolean;
  public
    { Public declarations }
    procedure TrayMessage(var Msg: TMessage); message WM_ICONTRAY;
  end;

var
  Frm: TFrm;
  inAngle: Boolean = False;
  inSide: Cardinal = 0;
  switchDesktopDelay: Cardinal = 500;
  sensitivityMouse: Integer = 5;

implementation

{$R *.dfm}

procedure TFrm.TrayMessage(var Msg: TMessage);
begin
  case Msg.lParam of
    WM_LBUTTONDOWN:
    begin
      //
    end;
    WM_RBUTTONDOWN:
    begin
      SetForegroundWindow(Handle);
      PopupMenu.Popup(Mouse.CursorPos.X, Mouse.CursorPos.Y);
    end;
  end;
end;

procedure TFrm.FormCreate(Sender: TObject);
var
  ini: TIniFile;
begin
  ini := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'config.ini');
  try
    switchDesktopDelay := ini.ReadInteger('Options', 'switchDesktopDelay.ms', 500);
    sensitivityMouse := ini.ReadInteger('Options', 'sensitivityMouse.px', 5);

    ini.WriteInteger('Options', 'switchDesktopDelay.ms', switchDesktopDelay);
    ini.WriteInteger('Options', 'sensitivityMouse.px', sensitivityMouse);
  finally
    ini.Free;
  end;

  with TrayIconData do
  begin
    cbSize :=  TNotifyIconData.SizeOf; // SizeOf(TrayIconData);
    Wnd := Handle;
    uID := 0;
    uFlags := NIF_MESSAGE + NIF_ICON + NIF_TIP;
    uCallbackMessage := WM_ICONTRAY;
    hIcon := Application.Icon.Handle;
    StrPCopy(szTip, Application.Title);
  end;

  Shell_NotifyIcon(NIM_ADD, @TrayIconData);
end;

procedure TFrm.FormDestroy(Sender: TObject);
begin
  Shell_NotifyIcon(NIM_DELETE, @TrayIconData);
end;

procedure TFrm.pmQuitClick(Sender: TObject);
begin
  Close();
end;

function TFrm.WinTab(): Boolean;
begin
  Result := False;

  if Mouse.CursorPos.X < Screen.Width - sensitivityMouse then begin
    inAngle := False;
    Exit;
  end;

  if Mouse.CursorPos.Y < Screen.Height - sensitivityMouse then begin
    inAngle := False;
    Exit;
  end;

  if inAngle then begin
    Exit;
  end;

  inAngle := True;

  keybd_event(VK_LWIN, 0, 0, 0);
  keybd_event(VK_TAB, 0, 0, 0);
  keybd_event(VK_LWIN, 0, KEYEVENTF_KEYUP, 0);
  keybd_event(VK_TAB, 0, KEYEVENTF_KEYUP, 0);

  Result := True;
end;

function TFrm.CtrlWinArrow(): Boolean;
begin
  Result := False;

  if (Mouse.CursorPos.X > sensitivityMouse)
  and (Mouse.CursorPos.X < Screen.Width - sensitivityMouse) then begin
    inSide := 0;
    Exit;
  end;

  if Mouse.CursorPos.Y > Screen.Height - sensitivityMouse then begin
    inSide := 0;
    Exit;
  end;

  if GetAsyncKeyState(VK_LBUTTON) < 0 then begin
    inSide := 0;
    Exit;
  end;

  if GetAsyncKeyState(VK_RBUTTON) < 0 then begin
    inSide := 0;
    Exit;
  end;

  if inSide < switchDesktopDelay then begin
    inSide := inSide + Timer.Interval;
    Exit;
  end;

  inSide := 0;

  keybd_event(VK_CONTROL, 0, 0, 0);
  keybd_event(VK_LWIN, 0, 0, 0);

  if Mouse.CursorPos.X < sensitivityMouse then begin
    keybd_event(VK_LEFT, 0, 0, 0);
    keybd_event(VK_LEFT, 0, KEYEVENTF_KEYUP, 0);
  end else begin
    keybd_event(VK_RIGHT, 0, 0, 0);
    keybd_event(VK_RIGHT, 0, KEYEVENTF_KEYUP, 0);
  end;

  keybd_event(VK_LWIN, 0, KEYEVENTF_KEYUP, 0);
  keybd_event(VK_CONTROL, 0, KEYEVENTF_KEYUP, 0);

  Result := True;
end;

procedure TFrm.TimerTimer(Sender: TObject);
begin
  if WinTab then Exit;
  if CtrlWinArrow then Exit;
end;

end.
