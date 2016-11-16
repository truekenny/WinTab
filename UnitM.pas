unit UnitM;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Menus, ShellApi;

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
  public
    { Public declarations }
    procedure TrayMessage(var Msg: TMessage); message WM_ICONTRAY;
  end;

var
  Frm: TFrm;
  inAngle: Boolean;

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
begin
  inAngle := False;

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

procedure TFrm.TimerTimer(Sender: TObject);
begin
  if Mouse.CursorPos.X < Screen.Width - 5 then begin
    inAngle := False;
    Exit;
  end;

  if Mouse.CursorPos.Y < Screen.Height - 5 then begin
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
end;

end.
