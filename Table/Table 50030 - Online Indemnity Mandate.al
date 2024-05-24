table 50030 "Online Indemnity Mandate"
{
    DrillDownPageID = "All Online Indemnities";
    LookupPageID = "All Online Indemnities";

    fields
    {
        field(1;No;Code[40])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if "Request Type"="Request Type"::Setup then begin
                  if No <> xRec.No then begin
                    FundAdministrationSetup.Get;
                    NoSeriesMgt.TestManual(FundAdministrationSetup."Online Indemnity Setup Nos");
                     "No. Series" := '';
                  end;
                end
                else begin
                  if No <> xRec.No then begin
                    FundAdministrationSetup.Get;
                    NoSeriesMgt.TestManual(FundAdministrationSetup."Online Indemnity Cancel Nos");
                     "No. Series" := '';
                  end;
                end
            end;
        }
        field(2;"Account No";Code[40])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Client Account"."Account No";

            trigger OnValidate()
            begin
                Validateaccount
            end;
        }
        field(3;"Client ID";Code[40])
        {
            DataClassification = ToBeClassified;
        }
        field(4;"Fund Code";Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = Fund;
        }
        field(5;"Sub Fund Code";Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(6;"Client Name";Text[250])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(7;"Request Type";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Setup,Cancellation';
            OptionMembers = Setup,Cancellation;
        }
        field(8;"Bank Code";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(9;"Bank Branch Code";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(10;"Bank Account Name";Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(11;"Bank Account Number";Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(12;Frequency;DateFormula)
        {
            DataClassification = ToBeClassified;
        }
        field(13;Status;Option)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = 'Received,ARM Registrar,External Registrar,Verification Successful,Verification Rejected,Cancelled';
            OptionMembers = Received,"ARM Registrar","External Registrar","Verification Successful","Verification Rejected",Cancelled;
        }
        field(14;"Created By";Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = User;
        }
        field(15;"Created Date Time";DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(17;"No. Series";Code[10])
        {
            Caption = 'No. Series';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "No. Series";
        }
        field(18;Select;Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if "Request Type"="Request Type"::Setup then begin

                  TestField("Account No");

                end else begin
                   TestField("Account No");
                end;
                if Select then
                  "Selected By":=UserId
                else
                  "Selected By":='';
            end;
        }
        field(19;"Selected By";Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = User;
        }
        field(104;Comments;Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(105;"Document Link";Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(106;Source;Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(118;"Registrar Control ID";Text[40])
        {
            DataClassification = ToBeClassified;
        }
        field(119;"Registrar Comments";Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(120;SignatureStatus;Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(121;AdditionalComments;Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(122;Blob;BLOB)
        {
            DataClassification = ToBeClassified;
        }
        field(123;FileName;Text[100])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;No)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        if "Request Type"="Request Type"::Setup then begin
          if No = '' then begin
               FundAdministrationSetup.Get;
               FundAdministrationSetup.TestField(FundAdministrationSetup."Online Indemnity Setup Nos");
               NoSeriesMgt.InitSeries(FundAdministrationSetup."Online Indemnity Setup Nos",xRec."No. Series",0D,No,"No. Series");
            end;
        end
        else begin
           if No = '' then begin
               FundAdministrationSetup.Get;
               FundAdministrationSetup.TestField(FundAdministrationSetup."Online Indemnity Cancel Nos");
               NoSeriesMgt.InitSeries(FundAdministrationSetup."Online Indemnity Cancel Nos",xRec."No. Series",0D,No,"No. Series");
            end;

        end;
        "Created By":=UserId;
        "Created Date Time":=CurrentDateTime;
        FundAdministration.InsertOnlineIndemnityTracker(Status,No);
    end;

    var
        FundAdministrationSetup: Record "Fund Administration Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        ClientAccount: Record "Client Account";
        Client: Record Client;
        ShowBeneficiaries: Boolean;
        FundAdministration: Codeunit "Fund Administration";

    local procedure Validateaccount()
    begin
        ClientAccount.Get("Account No");
        "Client ID":=ClientAccount."Client ID";
        Client.Get("Client ID");
        "Client Name":=Client.Name;
        "Fund Code":=ClientAccount."Fund No";
        "Sub Fund Code":=ClientAccount."Fund Sub Account";
        "Bank Account Name":=ClientAccount."Bank Account Name";
        "Bank Account Number":=ClientAccount."Bank Account Number";
        "Bank Code":=ClientAccount."Bank Code";
        "Bank Branch Code":=ClientAccount."Bank Branch";
    end;

    [Scope('Personalization')]
    procedure ToBase64String(): Text
    var
        IStream: InStream;
        Convert: DotNet Convert;
        MemoryStream: DotNet MemoryStream;
        Base64String: Text;
    begin
        if not Blob.HasValue then
          exit('');
        Blob.CreateInStream(IStream);
        MemoryStream := MemoryStream.MemoryStream;
        CopyStream(MemoryStream,IStream);
        Base64String := Convert.ToBase64String(MemoryStream.ToArray);
        MemoryStream.Close;
        exit(Base64String);
    end;
}

