table 386 "Entry No. Amount Buffer"
{
    // version NAVW113.00

    Caption = 'Entry No. Amount Buffer';
    ReplicateData = false;

    fields
    {
        field(1;"Entry No.";Integer)
        {
            Caption = 'Entry No.';
            DataClassification = SystemMetadata;
        }
        field(2;Amount;Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Amount';
            DataClassification = SystemMetadata;
        }
        field(3;Amount2;Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Amount2';
            DataClassification = SystemMetadata;
        }
        field(4;"Business Unit Code";Code[20])
        {
            Caption = 'Business Unit Code';
            DataClassification = SystemMetadata;
        }
        field(5;"Start Date";Date)
        {
            Caption = 'Start Date';
            DataClassification = SystemMetadata;
        }
        field(6;"End Date";Date)
        {
            Caption = 'End Date';
            DataClassification = SystemMetadata;
        }
    }

    keys
    {
        key(Key1;"Business Unit Code","Entry No.")
        {
        }
    }

    fieldgroups
    {
    }
}
