table 50073 "FUM & Fees"
{

    fields
    {
        field(1;No;Code[30])
        {
            DataClassification = ToBeClassified;
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
        field(5;Date;Date)
        {
            DataClassification = ToBeClassified;
        }
        field(6;FUM;Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 4:4;
        }
        field(7;Fees;Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 4:4;
        }
    }

    keys
    {
        key(Key1;"Agent Code",Date)
        {
        }
    }

    fieldgroups
    {
    }
}

