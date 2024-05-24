page 50202 "Loan Repayment Lines"
{
    // version THL-LOAN-1.0.0

    AutoSplitKey = true;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Loan Repayment Lines";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Received;Received)
                {
                }
                field("Pers. No.";"Pers. No.")
                {
                }
                field("Last Name and First Name";"Last Name and First Name")
                {
                    Editable = false;
                }
                field("DB Name";"DB Name")
                {
                }
                field("Valuation Date";"Valuation Date")
                {
                }
                field(Date;Date)
                {
                }
                field("Sheduled Repayment Date";"Sheduled Repayment Date")
                {
                }
                field("Applies To Loan";"Applies To Loan")
                {
                }
                field("Principal Amount Due";"Principal Amount Due")
                {
                }
                field("Interest Amount Due";"Interest Amount Due")
                {
                }
                field(Application;Application)
                {
                }
                field("Total Payment";"Total Payment")
                {
                }
                field("Principal Applied";"Principal Applied")
                {
                }
                field("Interest Applied";"Interest Applied")
                {
                }
            }
        }
    }

    actions
    {
    }
}

