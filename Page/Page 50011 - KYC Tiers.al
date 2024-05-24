page 50011 "KYC Tiers"
{
    PageType = List;
    SourceTable = "KYC Tier";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("KYC Code";"KYC Code")
                {
                }
                field(Description;Description)
                {
                }
                field("Risk Classfication";"Risk Classfication")
                {
                }
                field("Subscription Limit";"Subscription Limit")
                {
                }
                field("Daily Redemption Limit";"Daily Redemption Limit")
                {
                }
                field("Account Balance Threshold";"Account Balance Threshold")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("KYC Requirements")
            {
                Image = ResourcePlanning;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Page "KYC Requirements";
                RunPageLink = "KYC Tier"=FIELD("KYC Code");
            }
        }
    }
}

