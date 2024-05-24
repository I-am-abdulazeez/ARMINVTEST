table 50052 "Narration Definitions"
{

    fields
    {
        field(1;"Entry No";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Initial Subscription,Additional Subscription,Full Redemption,Part Redempion,Account to Account Transfer,Dividend Reinvest';
            OptionMembers = " ","Initial Subscription","Additional Subscription","Full Redemption","Part Redempion","Account to Account Transfer","Dividend Reinvest";
        }
        field(2;"Narration Text";Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(3;"Transaction Type";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Subscription Initial,Subscription Additional,Redemption Part,Redemption Full,Account Transfer,Dividend Reinvest';
            OptionMembers = " ","Subscription Initial","Subscription Additional","Redemption Part","Redemption Full","Account Transfer","Dividend Reinvest";
        }
    }

    keys
    {
        key(Key1;"Entry No")
        {
        }
    }

    fieldgroups
    {
    }
}

