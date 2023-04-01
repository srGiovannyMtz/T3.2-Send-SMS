unit uMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Memo.Types,
  FMX.ScrollBox, FMX.Memo, FMX.Edit, FMX.StdCtrls, FMX.Controls.Presentation

  /// Helpers for Android implementations by FMX.
    , FMX.Helpers.Android
  // Java Native Interface permite a programas
  // ejecutados en la JVM interactue con otros lenguajes.
    , Androidapi.JNI.GraphicsContentViewText, Androidapi.JNI.Net,
  Androidapi.JNI.JavaTypes, Androidapi.Helpers
  // Obtiene datos de telefonia del dispositivo
    , Androidapi.JNI.Telephony;

type
  TfrmSms = class(TForm)
    tbarHeader: TToolBar;
    btnSend: TButton;
    btnExit: TButton;
    edtNumber: TEdit;
    memMessage: TMemo;
    tbarStatusText: TStatusBar;
    lblContText: TLabel;
    procedure SendSMS(target, message: string);
    procedure btnSendClick(Sender: TObject);

    procedure memMessageChangeTracking(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSms: TfrmSms;

implementation

{$R *.fmx}

procedure TfrmSms.btnSendClick(Sender: TObject);
begin
  // llamar a SendSMS que recibe 2 paramentros
  // target: Destinatario de SMS; message: contenido del SMS;
  SendSMS(edtNumber.Text, memMessage.Text);
end;

procedure TfrmSms.memMessageChangeTracking(Sender: TObject);

// este evento ocurre cuando surge un cambio en el texto del memo.
// por ende cuando ocurra un cambio se ajustará el texto del lblContText
// asignando al texto la longitud del texto del memo dando la cantidad de caracteres


// para delimitar la cantidad de caracteres se utilizo la propiedad MaxLength de el
// memMessage dándole el valor de 160

begin
  lblContText.Text := 'Total de caracteres escritos: ' +
    IntToStr(length(memMessage.Text)) + ' de 160';
end;

procedure TfrmSms.SendSMS(target, message: string);
var
  smsManager: JSmsManager; // declarar administrador de mensajes
  smsTo: JString; // variable destinatario del SMS
begin
  try
    // inicializar administrador de mensajes
    smsManager := TJSmsManager.JavaClass.getDefault;
    // convertir target a tipo Jstring tipo de dato usado por JNI
    smsTo := StringToJString(target);
    // pasar parametros a administrador para enviar mensaje
    smsManager.sendTextMessage(smsTo, nil, StringToJString(message), nil, nil);
    ShowMessage('Mensaje enviado');
  except
    on E: Exception do
      ShowMessage(E.ToString);
  end;
end;

end.
