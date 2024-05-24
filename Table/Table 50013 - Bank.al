table 50013 Bank
{
    DrillDownPageID = Banks;
    LookupPageID = Banks;

    fields
    {
        field(1;"code";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2;Name;Text[50])
        {
            DataClassification = ToBeClassified;
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
        field(202;"CRM Code";Code[100])
        {
            DataClassification = ToBeClassified;
        }
        field(203;Fundware;Code[100])
        {
            DataClassification = ToBeClassified;
        }
        field(204;Nibbs;Code[100])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"code")
        {
        }
    }

    fieldgroups
    {
    }
}

