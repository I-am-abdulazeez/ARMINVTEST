table 50057 "Account Liens"
{
    DrillDownPageID = "Verified Account Liens";
    LookupPageID = "Verified Account Liens";

    fields
    {
        field(1;"Lien No";Code[20])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin

                if "Lien No"<> xRec."Lien No" then begin
                  ClientManagementSetup.Get;
                  NoSeriesMgt.TestManual(ClientManagementSetup."Lien Nos");
                  "No. Series" := '';
                end;
            end;
        }
        field(2;Description;Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(3;"Account No";Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Client Account"."Account No";

            trigger OnValidate()
            begin
                validateaccount
            end;
        }
        field(4;"CLient ID";Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(5;"Client Name";Text[200])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(6;status;Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Logged,Pending Verification,Verified,Closed,Rejected';
            OptionMembers = Logged,"Pending Verification",Verified,Closed,Rejected;
        }
        field(7;Amount;Decimal)
        {
            DataClassification = ToBeClassified;
            MinValue = 0;
        }
        field(8;"Created By";Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = User;
        }
        field(9;"Created Date Time";DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(105;"Document Link";Text[250])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            ExtendedDatatype = URL;
        }
        field(106;"Closure Document Link";Text[250])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            ExtendedDatatype = URL;
        }
        field(107;"No. Series";Code[10])
        {
            Caption = 'No. Series';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "No. Series";
        }
        field(200;"Last Modified By";Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = User;
        }
        field(201;"Last Modified DateTime";DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(202;"Last Update Source";Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(203;"Sent for Closure";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(204;Comment;Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(205;"Verified By";Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(206;"Verified Date Time";DateTime)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"Lien No")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        if "Lien No" = '' then begin
          ClientManagementSetup.Get;
          ClientManagementSetup.TestField("Lien Nos");
          NoSeriesMgt.InitSeries(ClientManagementSetup."Lien Nos",xRec."No. Series",0D,"Lien No","No. Series");
        end;
        "Created By" := UserId;
        "Created Date Time" := CurrentDateTime;
        status := status::Logged;
    end;

    var
        ClientManagementSetup: Record "Client Management Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        ClientAccount: Record "Client Account";

    local procedure validateaccount()
    begin
        if ClientAccount.Get("Account No") then begin
          "CLient ID":=ClientAccount."Client ID";
          "Client Name":=ClientAccount."Client Name";
        end;
        if "Account No"='' then begin
          "CLient ID":='';
          "Client Name":='';
        end;
    end;
}

