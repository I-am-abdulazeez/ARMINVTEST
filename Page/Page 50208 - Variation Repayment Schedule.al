page 50208 "Variation Repayment Schedule"
{
    // version THL-LOAN-1.0.0

    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Variation Repayment Schedule";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Installment No.";"Installment No.")
                {
                }
                field("Repayment Date";"Repayment Date")
                {
                }
                field("Due Date";"Due Date")
                {
                }
                field("Loan Product Type";"Loan Product Type")
                {
                }
                field("Loan Amount";"Loan Amount")
                {
                }
                field(Principal;Principal)
                {
                }
                field(Interest;Interest)
                {
                }
                field(Total;Total)
                {
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Confirm Payment")
            {
                Image = Confirm;
                //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                //PromotedIsBig = true;
                RunObject = Page "Loan Repayment Confirmation";
                RunPageLink = "Client No."=FIELD("Client No."),
                              "Loan No."=FIELD("Loan No."),
                              Settled=CONST(false);
            }
        }
    }
}

