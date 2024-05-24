table 50074 Inflows
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
        field(6;"Account No";Code[40])
        {
            DataClassification = ToBeClassified;
        }
        field(7;"Account Name";Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(8;Amount;Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(9;"Transaction Ref";Code[40])
        {
            DataClassification = ToBeClassified;
        }
        field(10;"Old Account no";Code[40])
        {
            DataClassification = ToBeClassified;
        }
        field(11;Remarks;Text[100])
        {
            DataClassification = ToBeClassified;
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

