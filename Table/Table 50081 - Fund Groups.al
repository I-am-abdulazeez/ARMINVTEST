table 50081 "Fund Groups"
{

    fields
    {
        field(1;"code";Code[40])
        {
            DataClassification = ToBeClassified;
        }
        field(2;Description;Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(3;"Bank Code";Code[40])
        {
            DataClassification = ToBeClassified;
            TableRelation = Bank.code;
        }
        field(4;"Bank Account No";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(5;"Bank Account Name";Text[200])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"code","Bank Code")
        {
        }
    }

    fieldgroups
    {
    }
}

