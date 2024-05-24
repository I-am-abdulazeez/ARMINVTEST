table 50107 "Suspicious Transactions"
{

    fields
    {
        field(1;"Account No";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2;"Client ID";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3;"Value Date";Date)
        {
            DataClassification = ToBeClassified;
        }
        field(4;Reason;Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'In-and-Out,Multiple Redemptions';
            OptionMembers = "In-and-Out","Multiple Redemptions";
        }
        field(5;"Fund Code";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(6;FlaggedDate;DateTime)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"Account No","Value Date",Reason)
        {
        }
    }

    fieldgroups
    {
    }
}

