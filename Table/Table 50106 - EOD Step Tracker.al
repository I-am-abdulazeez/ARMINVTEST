table 50106 "EOD Step Tracker"
{

    fields
    {
        field(1;"Entry No";Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(2;"Value Date";Date)
        {
            DataClassification = ToBeClassified;
        }
        field(3;"Fund Code";Code[40])
        {
            DataClassification = ToBeClassified;
        }
        field(4;"Transaction Type";Code[40])
        {
            DataClassification = ToBeClassified;
        }
        field(5;"Fund Bank Account No";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(6;Status;Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(7;Response;Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(8;Amount;Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(9;Units;Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"Entry No","Value Date","Transaction Type","Fund Bank Account No","Fund Code")
        {
        }
    }

    fieldgroups
    {
    }
}

