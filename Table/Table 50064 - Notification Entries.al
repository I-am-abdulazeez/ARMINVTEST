table 50064 "Notification Entries"
{
    // version NAVW113.00

    Caption = 'Notification Entry';
    ReplicateData = false;

    fields
    {
        field(1;ID;Integer)
        {
            AutoIncrement = true;
            Caption = 'ID';
        }
        field(3;Type;Option)
        {
            Caption = 'Type';
            OptionCaption = 'New Record,Update,Overdue';
            OptionMembers = "New Record",Update,Overdue;
        }
        field(8;"Error Message";Text[250])
        {
            Caption = 'Error Message';
            Editable = false;
        }
        field(9;"Created Date-Time";DateTime)
        {
            Caption = 'Created Date-Time';
            Editable = false;
        }
        field(10;"Created By";Code[50])
        {
            Caption = 'Created By';
            DataClassification = EndUserIdentifiableInformation;
            Editable = false;
            TableRelation = User."User Name";
        }
        field(15;"Error Message 2";Text[250])
        {
            Caption = 'Error Message 2';
        }
        field(16;"Error Message 3";Text[250])
        {
            Caption = 'Error Message 3';
        }
        field(17;"Error Message 4";Text[250])
        {
            Caption = 'Error Message 4';
        }
        field(18;Title;Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(19;"Transaction No";Code[40])
        {
            DataClassification = ToBeClassified;
        }
        field(20;Description;Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(21;"Client ID";Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(22;Status;Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(23;"Product Name";Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(24;"Client Account";Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(25;"Instruction Type";Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(26;Amount;Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(27;"Send to";Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(28;CC;Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(29;BCC;Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(30;"From Address";Text[100])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;ID)
        {
        }
        key(Key2;"Created Date-Time")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        "Created Date-Time" := RoundDateTime(CurrentDateTime,60000);
        "Created By" := UserId;
    end;

    var
        DataTypeManagement: Codeunit "Data Type Management";

    [Scope('Personalization')]
    procedure CreateNew(NewType: Option "New Record",Approval,Overdue;NewUserID: Code[50];NewRecord: Variant;NewLinkTargetPage: Integer;NewCustomLink: Text[250])
    var
        NotificationSchedule: Record "Notification Schedule";
        NewRecRef: RecordRef;
    begin
    end;

    [Scope('Personalization')]
    procedure GetErrorMessage(): Text
    var
        TextMgt: Codeunit TextManagement;
    begin
        exit(TextMgt.GetRecordErrorMessage("Error Message","Error Message 2","Error Message 3","Error Message 4"));
    end;

    [Scope('Personalization')]
    procedure SetErrorMessage(ErrorText: Text)
    var
        TextMgt: Codeunit TextManagement;
    begin
        TextMgt.SetRecordErrorMessage("Error Message","Error Message 2","Error Message 3","Error Message 4",ErrorText);
    end;
}

