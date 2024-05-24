table 50012 "Bank Branches"
{
    DrillDownPageID = 52132216;
    LookupPageID = 52132216;

    fields
    {
        field(1;"Bank Code";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Bank.code;

            trigger OnValidate()
            begin
                Bank.Get("Bank Code");
                Name:=Bank.Name;
            end;
        }
        field(2;Name;Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(3;"Branch Code";Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(4;"Branch Name";Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(5;State;Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = State;
        }
        field(6;Address;Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(7;Email;Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(8;"Phone Number";Code[100])
        {
            DataClassification = ToBeClassified;
        }
        field(9;"Sort Code";Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(10;"Swift Code";Code[30])
        {
            DataClassification = ToBeClassified;
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
    }

    keys
    {
        key(Key1;"Bank Code","Branch Code")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Bank: Record Bank;
}

