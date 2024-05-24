codeunit 50100 "Sharepoint Integration2"
{

    trigger OnRun()
    begin
        SaveFileonsharepoint
    end;

    var
        Filename: Text;
        Filepath: Text;
        DocumentServiceManagement: Codeunit "Document Service Management";
        DocLink: Text;
        Window: Dialog;

    procedure ReturnName(ACCOUNTNO: Code[30]): Text
    var
        ClientAccount: Record Table52132204;
        Client: Record Table52132202;
    begin
        if ClientAccount.GET(ACCOUNTNO) then begin
          if Client.GET(ClientAccount."Client ID") then
            exit(Client.Name);

        end else Error('Client does not exist');
    end;

    procedure SaveFileonsharepoint()
    begin
        Filename:='sample switch schedule csv.csv';
        Filepath:='E:\Kazi\Clients\TEKNOHUB\ARM\Business Requirements\FW__Tracker_Notifications\NewAlert-Nav format.html';
        Window.Open('Uploading document');
        DocLink:=DocumentServiceManagement.SaveFile(Filepath,'Chichik.html',true);
        Window.Close;
        Message(DocLink);
    end;
}

