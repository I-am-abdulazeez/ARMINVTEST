table 50083 "Employee Employer redemption"
{

    fields
    {
        field(1;EntryNo;Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(2;ClientID;Code[40])
        {
            DataClassification = ToBeClassified;
        }
        field(3;AccountNo;Code[40])
        {
            DataClassification = ToBeClassified;
        }
        field(4;ValueDate;Date)
        {
            DataClassification = ToBeClassified;
        }
        field(5;"Employer%";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(6;"EMployee%";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(7;Total;Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(8;"OLd Entry";Integer)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;EntryNo)
        {
        }
        key(Key2;AccountNo,ValueDate)
        {
        }
    }

    fieldgroups
    {
    }
}

