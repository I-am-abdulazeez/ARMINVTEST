table 50089 "Payment Schedule"
{

    fields
    {
        field(1;"Payment Date";Date)
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
        key(Key1;"Payment Date",Batch)
        {
        }
    }

    fieldgroups
    {
    }
}

