table 50050 "KYC Links"
{

    fields
    {
        field(1;"Entry No";Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(2;"Account No";Code[40])
        {
            DataClassification = ToBeClassified;
        }
        field(3;"Client ID";Code[40])
        {
            DataClassification = ToBeClassified;
        }
        field(4;"KYC Type";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Document Types";
        }
        field(5;Link;Text[250])
        {
            DataClassification = ToBeClassified;
            ExtendedDatatype = URL;
        }
        field(6;Link2;Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(7;Link3;Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(8;Link4;Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(9;Source;Text[50])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"Entry No","Client ID")
        {
        }
    }

    fieldgroups
    {
    }
}

