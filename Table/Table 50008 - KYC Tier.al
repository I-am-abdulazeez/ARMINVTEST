table 50008 "KYC Tier"
{
    DrillDownPageID = "KYC Tiers";
    LookupPageID = "KYC Tiers";

    fields
    {
        field(1;"KYC Code";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2;Description;Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(3;"Risk Classfication";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Low,Medium,High';
            OptionMembers = Low,Medium,High;
        }
        field(4;"Subscription Limit";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(5;"Daily Redemption Limit";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(6;"Account Balance Threshold";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(200;"Last Modified By";Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = User;
        }
        field(201;"Last Modified DateTime";DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }

    keys
    {
        key(Key1;"KYC Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnModify()
    begin
        "Last Modified By":=UserId;
        "Last Modified DateTime":=CurrentDateTime;
    end;
}

