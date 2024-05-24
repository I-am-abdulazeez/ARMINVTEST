table 50105 "Charges on Accrued Interest"
{

    fields
    {
        field(1;"Entry No";Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(2;"Account No";Code[40])
        {
            DataClassification = ToBeClassified;
        }
        field(3;"Fund Code";Code[40])
        {
            DataClassification = ToBeClassified;
        }
        field(4;"Amount Charged";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(5;"Date Charged";DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(6;"Paid To Fund Managers";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(7;"Value Date";Date)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"Entry No")
        {
        }
    }

    fieldgroups
    {
    }
}

