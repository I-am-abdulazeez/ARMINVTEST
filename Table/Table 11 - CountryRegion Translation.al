table 11 "Country/Region Translation"
{
    // version NAVW111.00

    Caption = 'Country/Region Translation';

    fields
    {
        field(1;"Country/Region Code";Code[50])
        {
            Caption = 'Country/Region Code';
            NotBlank = true;
            TableRelation = "Country/Region";
        }
        field(2;"Language Code";Code[10])
        {
            Caption = 'Language Code';
            TableRelation = Language;
        }
        field(3;Name;Text[50])
        {
            Caption = 'Name';
        }
    }

    keys
    {
        key(Key1;"Country/Region Code","Language Code")
        {
        }
    }

    fieldgroups
    {
    }
}
