table 1210 "SWIFT Code"
{
    // version NAVW113.04

    Caption = 'SWIFT Code';
    LookupPageID = "SWIFT Codes";

    fields
    {
        field(1;"Code";Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(2;Name;Text[100])
        {
            Caption = 'Name';
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
        fieldgroup(Brick;"Code",Name)
        {
        }
    }
}

