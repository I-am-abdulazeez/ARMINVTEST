table 1601 "Office Add-in Setup"
{
    // version NAVW113.00

    Caption = 'Office Add-in Setup';
    ReplicateData = false;

    fields
    {
        field(1;"Primary Key";Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2;"Office Host Codeunit ID";Integer)
        {
            Caption = 'Office Host Codeunit ID';
            InitValue = 1633;
        }
    }

    keys
    {
        key(Key1;"Primary Key")
        {
        }
    }

    fieldgroups
    {
    }
}
