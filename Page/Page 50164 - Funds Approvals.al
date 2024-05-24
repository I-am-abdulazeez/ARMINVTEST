page 50164 "Funds Approvals"
{
    CardPageID = "Fund Card Approvals";
    Editable = false;
    PageType = List;
    SourceTable = Fund;
    SourceTableView = WHERE("Approval Status"=FILTER("Pending Approval"));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Fund Code";"Fund Code")
                {
                }
                field(Name;Name)
                {
                }
                field("Fund Type";"Fund Type")
                {
                }
                field("Dividend Distribution Type";"Dividend Distribution Type")
                {
                }
                field("No of Accounts";"No of Accounts")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Fund Prices")
            {
                Image = ResourcePrice;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Fund Prices";
                RunPageLink = "Fund No."=FIELD("Fund Code");
            }
        }
    }
}

