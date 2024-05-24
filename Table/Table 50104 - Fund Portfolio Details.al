table 50104 "Fund Portfolio Details"
{

    fields
    {
        field(1;"Code";Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(2;"Fund Code";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3;"Portfolio Code";Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(4;"Fund Manager";Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"Code")
        {
        }
    }

    fieldgroups
    {
    }
}

