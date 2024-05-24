table 7502 "Item Attribute Translation"
{
    // version NAVW110.0

    Caption = 'Item Attribute Translation';

    fields
    {
        field(1;"Attribute ID";Integer)
        {
            Caption = 'Attribute ID';
            NotBlank = true;
            TableRelation = "Item Attribute";
        }
        field(2;"Language Code";Code[10])
        {
            Caption = 'Language Code';
            NotBlank = true;
            TableRelation = Language;
        }
        field(3;Name;Text[250])
        {
            Caption = 'Name';
        }
    }

    keys
    {
        key(Key1;"Attribute ID","Language Code")
        {
        }
    }

    fieldgroups
    {
    }
}
