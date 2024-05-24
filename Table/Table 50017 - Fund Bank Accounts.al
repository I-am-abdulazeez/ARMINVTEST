table 50017 "Fund Bank Accounts"
{

    fields
    {
        field(1;"Fund Code";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2;"Bank Account No";Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(3;"Bank Code";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Bank;
        }
        field(4;"Bank Branch Code";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Bank Branches"."Branch Code" WHERE ("Bank Code"=FIELD("Bank Code"));
        }
        field(5;"Transaction Type";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Subscription,Redemption,Dividend,Trading';
            OptionMembers = Subscription,Redemption,Dividend,Trading;
        }
        field(6;Default;Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(7;"Bank Account Name";Text[200])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"Fund Code","Bank Account No","Transaction Type")
        {
        }
    }

    fieldgroups
    {
    }
}

