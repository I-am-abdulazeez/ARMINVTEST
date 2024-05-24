table 50115 "Subscription Matching Line Log"
{

    fields
    {
        field(1;"Automatch Reference";Code[250])
        {
            DataClassification = ToBeClassified;
        }
        field(2;"Header No";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3;"Creation Date";DateTime)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"Automatch Reference")
        {
            SQLIndex = "Automatch Reference";
        }
    }

    fieldgroups
    {
    }
}

