table 5609 "FA Location"
{
    // version NAVW17.00

    Caption = 'FA Location';
    LookupPageID = "FA Locations";

    fields
    {
        field(1;"Code";Code[10])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(2;Name;Text[50])
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
    }
}
