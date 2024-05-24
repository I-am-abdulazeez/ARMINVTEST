table 6521 "Item Tracing History Buffer"
{
    // version NAVW113.00

    Caption = 'Item Tracing History Buffer';
    ReplicateData = false;

    fields
    {
        field(1;"Entry No.";Integer)
        {
            Caption = 'Entry No.';
            DataClassification = SystemMetadata;
        }
        field(2;Level;Integer)
        {
            Caption = 'Level';
            DataClassification = SystemMetadata;
        }
        field(10;"Serial No. Filter";Code[250])
        {
            Caption = 'Serial No. Filter';
            DataClassification = SystemMetadata;
        }
        field(11;"Lot No. Filter";Code[250])
        {
            Caption = 'Lot No. Filter';
            DataClassification = SystemMetadata;
        }
        field(12;"Item No. Filter";Code[250])
        {
            Caption = 'Item No. Filter';
            DataClassification = SystemMetadata;
        }
        field(13;"Variant Filter";Code[250])
        {
            Caption = 'Variant Filter';
            DataClassification = SystemMetadata;
        }
        field(14;"Trace Method";Option)
        {
            Caption = 'Trace Method';
            DataClassification = SystemMetadata;
            OptionCaption = 'Origin->Usage,Usage->Origin';
            OptionMembers = "Origin->Usage","Usage->Origin";
        }
        field(15;"Show Components";Option)
        {
            Caption = 'Show Components';
            DataClassification = SystemMetadata;
            OptionCaption = 'No,Item-tracked only,All';
            OptionMembers = No,"Item-tracked only",All;
        }
    }

    keys
    {
        key(Key1;"Entry No.",Level)
        {
        }
    }

    fieldgroups
    {
    }
}

