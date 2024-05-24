page 50004 "Fund List"
{
    CardPageID = "Fund Card";
    Editable = false;
    PageType = List;
    SourceTable = Fund;

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

