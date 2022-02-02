unit uDemoCodeReader;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, CodeReader.FMX.CodeReader, FMX.Objects, FMX.Controls.Presentation,
  FMX.StdCtrls, CodeReader.FMX.Android.Permissions;

type
  TForm1 = class(TForm)
    CodeReader1: TCodeReader;
    Text1: TText;
    Button1: TButton;
    Rectangle1: TRectangle;
    AndroidPermissions1: TAndroidPermissions;
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure CodeReader1CodeReady(aCode: string);
    procedure CodeReader1Start(Sender: TObject);
    procedure CodeReader1Stop(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.Button1Click(Sender: TObject);
begin
if Button1.Text = 'Start' then
   CodeReader1.Start
Else
   CodeReader1.Stop;
end;

procedure TForm1.CodeReader1Start(Sender: TObject);
begin
Button1.Text := 'Stop';
end;

procedure TForm1.CodeReader1Stop(Sender: TObject);
begin
Button1.Text := 'Start';
end;

procedure TForm1.FormShow(Sender: TObject);
begin
CodeReader1Stop(Sender);
end;

procedure TForm1.CodeReader1CodeReady(aCode: string);
begin
Text1.Text := aCode;
end;

end.
