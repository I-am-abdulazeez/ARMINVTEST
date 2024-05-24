table 1259 "Bank Data Conv. Bank"
{
    // version NAVW18.00

    Caption = 'Bank Data Conv. Bank';
    LookupPageID = "Bank Name - Data Conv. List";

    fields
    {
        field(1;Bank;Text[50])
        {
            Caption = 'Bank';
            Editable = false;
        }
        field(2;"Bank Name";Text[50])
        {
            Caption = 'Bank Name';
            Editable = false;
        }
        field(3;"Country/Region Code";Code[10])
        {
            Caption = 'Country/Region Code';
            Editable = false;
        }
        field(4;"Last Update Date";Date)
        {
            Caption = 'Last Update Date';
            Editable = false;
        }
        field(5;Index;Integer)
        {
            AutoIncrement = true;
            Caption = 'Index';
        }
    }

    keys
    {
        key(Key1;Bank,Index)
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown;Bank)
        {
        }
    }
}
