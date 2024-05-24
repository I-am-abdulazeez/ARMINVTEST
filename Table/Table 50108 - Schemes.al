table 50108 Schemes
{

    fields
    {
        field(1;"Code";Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(2;Name;Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(3;CreatedDateTime;DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(4;"Scheme Type";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Corporate Managed, Standalone';
            OptionMembers = "Corporate Managed"," Standalone";
        }
    }

    keys
    {
        key(Key1;"Code")
        {
        }
    }

    fieldgroups
    {
    }
}

