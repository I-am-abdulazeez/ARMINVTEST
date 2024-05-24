table 347 "Close Income Statement Buffer"
{
    // version NAVW113.00

    Caption = 'Close Income Statement Buffer';
    ReplicateData = false;

    fields
    {
        field(1;"Closing Date";Date)
        {
            Caption = 'Closing Date';
            DataClassification = SystemMetadata;
        }
        field(2;"G/L Account No.";Code[20])
        {
            Caption = 'G/L Account No.';
            DataClassification = SystemMetadata;
            TableRelation = "G/L Account";
        }
    }

    keys
    {
        key(Key1;"Closing Date","G/L Account No.")
        {
        }
    }

    fieldgroups
    {
    }
}

