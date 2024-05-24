table 130403 "CAL Test Enabled Codeunit"
{
    // version NAVW113.03

    Caption = 'CAL Test Enabled Codeunit';
    ReplicateData = false;

    fields
    {
        field(1;"No.";Integer)
        {
            AutoIncrement = true;
            Caption = 'No.';
        }
        field(2;"Test Codeunit ID";Integer)
        {
            Caption = 'Test Codeunit ID';
        }
    }

    keys
    {
        key(Key1;"No.")
        {
        }
    }

    fieldgroups
    {
    }
}

