table 50033 "Direct Debit Mandate Benefic"
{

    fields
    {
        field(1;"Mandate No";Code[40])
        {
            DataClassification = ToBeClassified;
        }
        field(2;"Account No";Code[40])
        {
            DataClassification = ToBeClassified;
            TableRelation = IF ("Client ID"=FILTER(<>'')) "Client Account"."Account No" WHERE ("Client ID"=FIELD("Client ID"))
                            ELSE "Client Account"."Account No";

            trigger OnValidate()
            begin
                Validateaccount
            end;
        }
        field(3;"Client ID";Code[40])
        {
            DataClassification = ToBeClassified;
            TableRelation = Client."Membership ID";

            trigger OnValidate()
            begin
                TestField("Account No",'');
            end;
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
        field(14;"Created By";Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = User;
        }
        field(15;"Created Date Time";DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(22;Amount;Decimal)
        {
            DataClassification = ToBeClassified;
            MinValue = 0;
        }
        field(23;"Line No";Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(24;"Main Account";Code[40])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Client Account";
        }
    }

    keys
    {
        key(Key1;"Mandate No","Line No")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin

        "Created By":=UserId;
        "Created Date Time":=CurrentDateTime;
    end;

    var
        FundAdministrationSetup: Record "Fund Administration Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        ClientAccount: Record "Client Account";
        Client: Record Client;

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
}

