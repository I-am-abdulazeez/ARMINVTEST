table 50102 "Loan Payment schedule"
{

    fields
    {
        field(1;"Loan Payment Date";Date)
        {
            DataClassification = ToBeClassified;
        }
        field(2;Batch;Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(3;Time;Time)
        {
            DataClassification = ToBeClassified;
        }
        field(4;FileLink;Text[250])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"Loan Payment Date",Time)
        {
        }
    }

    fieldgroups
    {
    }
}

