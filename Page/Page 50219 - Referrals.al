page 50219 Referrals
{
    DeleteAllowed = false;
    Editable = true;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = Referral;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Referrer Membership ID";"Referrer Membership ID")
                {
                }
                field("Client ID";"Client ID")
                {
                }
                field("Fund No";"Fund No")
                {
                }
                field("Account No";"Account No")
                {
                }
                field("Bonus Amount";BonusAmt)
                {
                }
                field("Bonus Status";"Bonus Status")
                {
                }
                field(CreatedDate;CreatedDate)
                {
                }
                field(SubscriptionDate;SubscriptionDate)
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
          ValidityResponse := FundAdministration.CheckBonusValidity("Account No");
          if ValidityResponse then begin
            "Bonus Status" := "Bonus Status"::Cancelled;
            BonusAmt := 0;
          end else
            BonusAmt := FundAdministration.GetBonusNAV("Account No")
    end;

    var
        FundAdministration: Codeunit "Fund Administration";
        BonusAmt: Decimal;
        ValidityResponse: Boolean;
}

