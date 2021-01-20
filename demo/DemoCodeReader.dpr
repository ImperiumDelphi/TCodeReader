program DemoCodeReader;

uses
  System.StartUpCopy,
  FMX.Forms,
  uDemoCodeReader in 'uDemoCodeReader.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
