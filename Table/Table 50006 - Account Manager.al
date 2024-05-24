table 50006 "Account Manager"
{
    DrillDownPageID = "Account Manager List";
    LookupPageID = "Account Manager List";

    fields
    {
        field(1;"Agent Code";Code[20])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if "Agent Code" <> xRec."Agent Code" then begin
                  ClientManagementSetup.Get;
                  NoSeriesMgt.TestManual(ClientManagementSetup."Agent Nos");
                  "No. Series" := '';
                end;
            end;
        }
        field(2;"First Name";Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(3;Surname;Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(4;"Middle Name";Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(5;"RM Code";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Account Manager"."Agent Code";

            trigger OnValidate()
            begin

                AccountManager.Get("RM Code");
                "RM Name":=AccountManager."First Name"+ ' '+ AccountManager."Middle Name"+  ' '+ AccountManager.Surname;
            end;
        }
        field(6;"RM Name";Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(7;"Email Address";Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(8;"No of Agents Managed";Integer)
        {
            CalcFormula = Count("Account Manager" WHERE ("RM Code"=FIELD("Agent Code")));
            FieldClass = FlowField;
        }
        field(9;"Investment Center";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Investment Centres".Code;
        }
        field(10;"No of Clients Managed";Integer)
        {
            CalcFormula = Count(Client WHERE ("Account Executive Code"=FIELD("Agent Code")));
            FieldClass = FlowField;
        }
        field(11;"Is RM";Boolean)
        {
            DataClassification = ToBeClassified;
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
        field(202;"Commission Structure";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Commision structure".Code;
        }
    }

    keys
    {
        key(Key1;"Agent Code")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown;"Agent Code","First Name",Surname)
        {
        }
    }

    trigger OnInsert()
    begin
        if "Agent Code" = '' then begin
          ClientManagementSetup.Get;
          ClientManagementSetup.TestField("Agent Nos");
          NoSeriesMgt.InitSeries(ClientManagementSetup."Agent Nos",xRec."No. Series",0D,"Agent Code","No. Series");
        end;
        "Commission Structure":='AGC'
    end;

    trigger OnModify()
    begin
        "Last Modified By":=UserId;
        "Last Modified DateTime":=CurrentDateTime;
        if "Commission Structure" ='' then "Commission Structure":='AGC';
    end;

    var
        AccountManager: Record "Account Manager";
        ClientManagementSetup: Record "Client Management Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
}

