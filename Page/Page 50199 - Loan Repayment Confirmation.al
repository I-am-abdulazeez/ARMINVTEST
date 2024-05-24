page 50199 "Loan Repayment Confirmation"
{
    // version THL-LOAN-1.0.0

    SourceTable = "Loan Repayment Schedule";

    layout
    {
        area(content)
        {
            field("Client No.";"Client No.")
            {
                Editable = false;
            }
            field("Loan No.";"Loan No.")
            {
                Editable = false;
            }
            field("Repayment Date";"Repayment Date")
            {
                Editable = false;
            }
            field("Installment No.";"Installment No.")
            {
                Editable = false;
            }
            field("Settlement Date";"Settlement Date")
            {
            }
            field("Settlement No.";"Settlement No.")
            {
            }
            field("Total Due";"Total Due")
            {
                Editable = false;
            }
            field(Settled;Settled)
            {
            }
        }
    }

    actions
    {
    }

    trigger OnClosePage()
    begin
        if ("Settlement Date"<> 0D) and (Settled =false ) then begin
          Error ('Entering the closed date means payment is made, Kindly select the paid option');
          end;
    end;
}

