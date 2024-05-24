table 5499 "Aged Report Entity"
{
    // version NAVW111.00

    Caption = 'Aged Report Entity';

    fields
    {
        field(1;AccountId;Guid)
        {
            Caption = 'AccountId';
        }
        field(2;"No.";Code[20])
        {
            Caption = 'No.';
        }
        field(3;Name;Text[50])
        {
            Caption = 'Name';
        }
        field(4;"Currency Code";Code[10])
        {
            Caption = 'Currency Code';
        }
        field(5;Before;Decimal)
        {
            Caption = 'Before';
        }
        field(6;"Period 1";Decimal)
        {
            Caption = 'Period 1';
        }
        field(7;"Period 2";Decimal)
        {
            Caption = 'Period 2';
        }
        field(8;"Period 3";Decimal)
        {
            Caption = 'Period 3';
        }
        field(9;After;Decimal)
        {
            Caption = 'After';
        }
        field(10;Balance;Decimal)
        {
            Caption = 'Balance';
        }
        field(11;"Period Start Date";Date)
        {
            Caption = 'Period Start Date';
        }
        field(12;"Period Length";Text[10])
        {
            Caption = 'Period Length';
        }
    }

    keys
    {
        key(Key1;AccountId)
        {
        }
    }

    fieldgroups
    {
    }
}

