page 50192 "Loan Product Charges"
{
    // version THL-LOAN-1.0.0

    PageType = ListPart;
    SourceTable = "Loan Product Charges";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code";Code)
                {
                }
                field(Description;Description)
                {
                }
                field("Amount Type";"Amount Type")
                {
                }
                field(Amount;Amount)
                {
                }
            }
        }
    }

    actions
    {
    }
}

