table 50019 "Client Cautions"
{
    DrillDownPageID = "Client Cautions Requests";
    LookupPageID = "Client Cautions Requests";

    fields
    {
        field(1;"Caution No";Code[40])
        {
            DataClassification = ToBeClassified;
            Editable = false;

            trigger OnValidate()
            begin

                if "Caution No"<> xRec."Caution No" then begin
                  ClientManagementSetup.Get;
                  NoSeriesMgt.TestManual(ClientManagementSetup."Caution Nos");
                  "No. Series" := '';
                end;
            end;
        }
        field(2;"Client ID";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Client;

            trigger OnValidate()
            begin
                if ClientSetupFunctions.CheckifCautionexists("Client ID") then
                  //ERROR(Text001);
                  Error('There is an Unclosed Caution for this Client %1', "Client ID");
                if Client.Get("Client ID") then
                "Client Name":=Client.Name
            end;
        }
        field(3;"Caution Type";Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = true;
            TableRelation = "Caution Types".Code WHERE (Type=CONST(Caution));

            trigger OnValidate()
            begin
                if CautionTypes.Get(CautionTypes.Type::Caution,"Caution Type") then
                Description:=CautionTypes.Description;
            end;
        }
        field(4;Description;Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(5;"Client Name";Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(6;"Cause Code";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Caution Types".Code WHERE (Type=CONST(Cause));

            trigger OnValidate()
            begin
                TestField("Caution Type");
                if CautionTypes.Get(CautionTypes.Type::Cause,"Cause Code") then
                "Cause Description":=CautionTypes.Description;
            end;
        }
        field(7;"Cause Description";Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(8;"Resolution code";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Caution Types".Code WHERE (Type=CONST(Resolution));

            trigger OnValidate()
            begin
                TestField("Cause Code");
                if CautionTypes.Get(CautionTypes.Type::Resolution,"Resolution code") then
                Resolution:=CautionTypes.Description;
            end;
        }
        field(9;Resolution;Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(10;Status;Option)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = 'Logged,Pending Verification,Verified,Closed';
            OptionMembers = Logged,"Pending Verification",Verified,Closed;

            trigger OnValidate()
            begin
                if Status=Status::"Pending Verification" then
                  TestField("Cause Code")
                else if Status=Status::Verified then
                  TestField("Resolution code")
                else if Status=Status::Closed then
                  TestField("Restriction Type","Restriction Type"::"No Restrictions");
            end;
        }
        field(11;"Restriction Type";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'No Restrictions,Restrict Subscription,Restrict Redemption,Restrict Both';
            OptionMembers = "No Restrictions","Restrict Subscription","Restrict Redemption","Restrict Both";
        }
        field(13;"Account No";Code[40])
        {
            Caption = 'Account No.';
            DataClassification = ToBeClassified;
            TableRelation = "Client Account"."Account No";

            trigger OnValidate()
            begin
                Validateaccount
            end;
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
        field(203;"Request for closure";Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"Caution No")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin

        if "Caution No" = '' then begin
          ClientManagementSetup.Get;
          ClientManagementSetup.TestField("Caution Nos");
          NoSeriesMgt.InitSeries(ClientManagementSetup."Caution Nos",xRec."No. Series",0D,"Caution No","No. Series");
        end;
    end;

    var
        CautionTypes: Record "Caution Types";
        Client: Record Client;
        ClientManagementSetup: Record "Client Management Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        ClientSetupFunctions: Codeunit "Client Administration";
        Text001: Label 'There is an Unclosed Caution for this Client';
        ClientAccount: Record "Client Account";

    local procedure Validateaccount()
    begin
        ClientAccount.Get("Account No");
        "Client ID":=ClientAccount."Client ID";
        Client.Get("Client ID");
        "Client Name":=Client.Name;
    end;
}

