codeunit 50010 "Sharepoint test"
{

    trigger OnRun()
    begin
        SaveFileonsharepoint
    end;

    var
        Filename: Text;
        Filepath: Text;
        LibraryName: Text;
        Sharepointurl: Text;
        DocumentServiceManagement: Codeunit "Document Service Management";
        DocLink: Text;

    local procedure Usedotnet()
    var
        ClientContext: DotNet ClientContext;
        Logins: DotNet String;
        FileCreation: DotNet FileCreationInformation;
        Systemfile: DotNet File;
        SWeb: DotNet Web;
        SharepointList: DotNet List;
    begin
        Logins:=StrSubstNo('gideon.rono@tecknohub.systems,xxxxx');
        LibraryName:='Documents';
        Filename:='sample switch schedule csv.csv';
        Filepath:='E:\Kazi\Clients\TEKNOHUB\ARM\'+Filename;
        Sharepointurl:='https://teknohublimited2016.sharepoint.com/sites/ARM/';

        ClientContext:=ClientContext.ClientContext(Sharepointurl);;
        ClientContext.Credentials:=Logins;
        FileCreation.Url:=Filename;
        FileCreation.Overwrite:=true;
        FileCreation.Content:=Systemfile.ReadAllBytes(Filepath);
        SWeb:=ClientContext.Web;
        SharepointList:=SWeb.Lists.GetByTitle(LibraryName);
        SharepointList.RootFolder.Files.Add(FileCreation);
        ClientContext.ExecuteQuery;
    end;

    procedure SaveFileonsharepoint()
    begin
        Filename:='sample switch schedule csv.csv';
        Filepath:='E:\Kazi\Clients\TEKNOHUB\ARM\'+Filename;

        DocLink:=DocumentServiceManagement.SaveFile(Filepath,'DynamicsExcel.csv',true);
        Message(DocLink);
    end;
}

