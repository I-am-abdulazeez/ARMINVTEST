table 50051 "Fund Payout Charges"
{

    fields
    {
        field(1;"Entry No";Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(2;"Fund No";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3;Name;Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(4;"Lower Limit";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(5;"Upper Limit";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(6;"Fee Type";Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "Flat Amount",Percentage;
        }
        field(7;Fee;Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"Entry No","Fund No")
        {
        }
    }

    fieldgroups
    {
    }
}

