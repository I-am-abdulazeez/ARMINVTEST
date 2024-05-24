table 50101 Referral
{
    DrillDownPageID = Referrals;
    LookupPageID = Referrals;

    fields
    {
        field(1;"Account No";Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = true;
            TableRelation = "Client Account"."Account No";

            trigger OnValidate()
            begin
                ValidateAcctNo
            end;
        }
        field(2;"Client ID";Code[40])
        {
            DataClassification = ToBeClassified;
            TableRelation = Client;
        }
        field(3;"Fund No";Code[20])
        {
            DataClassification = ToBeClassified;
            NotBlank = true;
            TableRelation = Fund;
        }
        field(5;"Bonus Status";Option)
        {
            DataClassification = ToBeClassified;
            Editable = true;
            OptionCaption = 'Active,Subscribed,Cancelled';
            OptionMembers = Active,Subscribed,Cancelled;
        }
        field(6;"Referrer Membership ID";Code[40])
        {
            DataClassification = ToBeClassified;
            TableRelation = Client;
        }
        field(7;CreatedDate;DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = true;
        }
        field(8;SubscriptionDate;DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(9;"Agent Code";Code[40])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"Account No")
        {
        }
    }

    fieldgroups
    {
    }

    var
        FundAdministration: Codeunit "Fund Administration";
        "Client Acct": Record "Client Account";

    local procedure ValidateAcctNo()
    begin
        if "Client Acct".Get("Account No") then begin
          "Client ID" := "Client Acct"."Client ID";
          "Referrer Membership ID" := "Client Acct"."Referrer Membership ID";
          "Fund No" := "Client Acct"."Fund No";
          "Agent Code" := "Client Acct"."Agent Code";
          CreatedDate := CurrentDateTime;
        end else begin
          "Client ID" := '';
          "Referrer Membership ID" := '';
          "Fund No" := '';
        end
    end;
}

