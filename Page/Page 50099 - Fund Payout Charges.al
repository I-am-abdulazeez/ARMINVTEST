page 50099 "Fund Payout Charges"
{
    PageType = List;
    SourceTable = "Fund Payout Charges";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Fund No";"Fund No")
                {
                    Editable = false;
                }
                field("Lower Limit";"Lower Limit")
                {
                }
                field("Upper Limit";"Upper Limit")
                {
                }
                field("Fee Type";"Fee Type")
                {
                }
                field(Fee;Fee)
                {
                }
            }
        }
    }

    actions
    {
    }
}

