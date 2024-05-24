report 50037 "Post Loyalty Earning"
{
    ProcessingOnly = true;
    UseRequestPage = false;

    dataset
    {
        dataitem(Referral;Referral)
        {

            trigger OnAfterGetRecord()
            begin
                FundAdministration.SubscribeBonusAmount(Referral."Account No")
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        FundAdministration: Codeunit "Fund Administration";
}

