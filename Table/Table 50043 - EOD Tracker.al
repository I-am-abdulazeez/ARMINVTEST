table 50043 "EOD Tracker"
{

    fields
    {
        field(1;Date;Date)
        {
            DataClassification = ToBeClassified;
        }
        field(2;"Push Start Time";Time)
        {
            DataClassification = ToBeClassified;
        }
        field(3;"Push End Time";Time)
        {
            DataClassification = ToBeClassified;
        }
        field(4;"EOD Generated";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(5;"EOD Pushed";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(6;"Fund Code";Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;Date,"Fund Code")
        {
        }
    }

    fieldgroups
    {
    }
}

