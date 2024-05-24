table 50103 "Loyalty Earnings Setup"
{

    fields
    {
        field(1;No;Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(2;"Initial Date";Date)
        {
            DataClassification = ToBeClassified;
        }
        field(3;"Final Date";Date)
        {
            DataClassification = ToBeClassified;
        }
        field(4;NoOfDays;Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(5;"Bonus Rate";Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 7:7;
        }
        field(6;"Minimum Subscription";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(7;"Last Date Modified";DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(8;"Modified By";Code[100])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;No)
        {
        }
        key(Key2;"Initial Date")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnModify()
    begin
        "Last Date Modified" := CurrentDateTime;
        "Modified By" := UserId;
    end;
}

