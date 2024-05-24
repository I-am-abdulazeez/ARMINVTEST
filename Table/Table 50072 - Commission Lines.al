table 50072 "Commission Lines"
{

    fields
    {
        field(1;No;Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Commission Header";
        }
        field(2;"Line No";Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(3;"Agent Code";Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(4;"Agent Name";Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(5;"Average FUM";Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 4:4;
        }
        field(6;Inflow;Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 4:4;
        }
        field(7;"New Client";Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(8;"Active Direct Debit";Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(9;"Total Fee";Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 4:4;
        }
        field(10;"MGT Fees to ARM";Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 4:4;
        }
        field(11;"MGT Fees to IC";Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 4:4;
        }
        field(12;"Max Commission";Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 4:4;
        }
        field(13;"FUM Commision Due to AE";Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 4:4;
        }
        field(14;"New Client Commision";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(15;"DDM Commission";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(16;"Total Commission";Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 4:4;
        }
    }

    keys
    {
        key(Key1;No,"Line No")
        {
        }
    }

    fieldgroups
    {
    }
}

