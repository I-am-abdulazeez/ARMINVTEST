table 50110 "Posted Holding Period Trans"
{

    fields
    {
        field(1;No;Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(2;"Value Date";Date)
        {
            DataClassification = ToBeClassified;
        }
        field(3;"Client ID";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(4;"Client Account No";Code[40])
        {
            DataClassification = ToBeClassified;
        }
        field(5;"Fund Code";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(6;"Transaction Type";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Subscription,Redemption';
            OptionMembers = Subscription,Redemption;
        }
        field(7;Amount;Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 2:2;
        }
        field(8;"Transac Entry No";Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(9;Withdrawn;Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(10;"Request ID";Code[50])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;No)
        {
        }
    }

    fieldgroups
    {
    }
}

