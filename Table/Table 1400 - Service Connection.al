table 1400 "Service Connection"
{
    // version NAVW113.00

    Caption = 'Service Connection';

    fields
    {
        field(1;"No.";Text[250])
        {
            Caption = 'No.';
        }
        field(2;"Record ID";RecordID)
        {
            Caption = 'Record ID';
            DataClassification = SystemMetadata;
        }
        field(3;Name;Text[250])
        {
            Caption = 'Name';
        }
        field(4;"Host Name";Text[250])
        {
            Caption = 'Host Name';
        }
        field(8;Status;Option)
        {
            Caption = 'Status';
            OptionCaption = ' ,Enabled,Disabled,Connected,Error';
            OptionMembers = " ",Enabled,Disabled,Connected,Error;
        }
        field(10;"Page ID";Integer)
        {
            Caption = 'Page ID';
        }
        field(11;"Assisted Setup Page ID";Integer)
        {
            Caption = 'Assisted Setup Page ID';
        }
    }

    keys
    {
        key(Key1;"No.")
        {
        }
    }

    fieldgroups
    {
    }

    [IntegrationEvent(false, false)]
    [Scope('Personalization')]
    procedure OnRegisterServiceConnection(var ServiceConnection: Record "Service Connection")
    begin
    end;

    [Scope('Personalization')]
    procedure InsertServiceConnection(var ServiceConnection: Record "Service Connection";RecordID: RecordID;ServiceName: Text;HostName: Text;PageID: Integer)
    begin
        InsertServiceConnectionExtended(ServiceConnection,RecordID,ServiceName,HostName,PageID,0);
    end;

    [Scope('Personalization')]
    procedure InsertServiceConnectionExtended(var ServiceConnection: Record "Service Connection";RecordID: RecordID;ServiceName: Text;HostName: Text;PageID: Integer;AssistedSetupPageId: Integer)
    var
        ServiceConnectionOld: Record "Service Connection";
    begin
        ServiceConnection."Record ID" := RecordID;
        ServiceConnection."No." := Format(RecordID);
        ServiceConnection.Name := CopyStr(ServiceName,1,MaxStrLen(ServiceConnection.Name));
        ServiceConnection."Host Name" := CopyStr(HostName,1,MaxStrLen(ServiceConnection."Host Name"));
        ServiceConnection."Page ID" := PageID;
        ServiceConnection."Assisted Setup Page ID" := AssistedSetupPageId;
        ServiceConnectionOld := ServiceConnection;
        if not ServiceConnection.Get(ServiceConnection."No.") then begin
          ServiceConnection := ServiceConnectionOld;
          ServiceConnection.Insert(true)
        end;
    end;
}

