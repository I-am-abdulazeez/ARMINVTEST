page 50211 "Settled Repayment Schedule"
{
    // version THL-LOAN-1.0.0

    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Historical Repayment Schedules";

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
                field("Principal Due";"Principal Due")
                {
                }
                field("Interest Due";"Interest Due")
                {
                }
                field("Total Due";"Total Due")
                {
                }
                field(Settled;Settled)
                {
                }
                field("Settlement Method";"Settlement Method")
                {
                }
                field("Settlement No.";"Settlement No.")
                {
                }
                field("Settlement Date";"Settlement Date")
                {
                }
                field("Confirmed By";"Confirmed By")
                {
                }
                field("Principal Settlement";"Principal Settlement")
                {
                }
                field("Interest Settlement";"Interest Settlement")
                {
                }
                field("Total Settlement";"Total Settlement")
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

