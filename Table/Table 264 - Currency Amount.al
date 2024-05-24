table 264 "Currency Amount"
{
    // version NAVW16.00

    Caption = 'Currency Amount';

    fields
    {
        field(1;"Currency Code";Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(2;Date;Date)
        {
            Caption = 'Date';
        }
        field(3;Amount;Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Amount';
        }
    }

    keys
    {
        key(Key1;"Currency Code",Date)
        {
        }
    }

    fieldgroups
    {
    }
}

