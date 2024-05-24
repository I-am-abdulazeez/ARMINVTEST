table 50020 "Caution Types"
{
    DrillDownPageID = "Caution Types";
    LookupPageID = "Caution Types";

    fields
    {
        field(1;"Code";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2;Description;Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(3;"Restriction Type";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'No Restrictions,Restrict Subscription,Restrict Redemption,Restrict Both';
            OptionMembers = "No Restrictions","Restrict Subscription","Restrict Redemption","Restrict Both";
        }
        field(4;Type;Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Caution,Cause,Resolution';
            OptionMembers = Caution,Cause,Resolution;
        }
    }

    keys
    {
        key(Key1;Type,"Code")
        {
        }
    }

    fieldgroups
    {
    }
}

