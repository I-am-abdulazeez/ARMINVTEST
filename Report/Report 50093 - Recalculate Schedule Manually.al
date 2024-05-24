report 50093 "Recalculate Schedule Manually"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Recalculate Schedule Manually.rdlc';

    dataset
    {
        dataitem(RepaymentLines;"Loan Repayment Lines")
        {
            RequestFilterFields = "Header No","Line No.","Pers. No.";

            trigger OnAfterGetRecord()
            begin
                TestField("Sheduled Repayment Date");
                  RepaymentDate := CalcDate('1M',"Sheduled Repayment Date");

                Loans.Reset;
                Loans.SetRange("Loan No.","Loan No.");
                if Loans.FindFirst then begin
                //IF (("Principal Applied" > "Principal Amount Due")) THEN // AND (Application = Application::"Apply to Principal Only") THEN
                LoanMgt.RecalculateRepaymentSchedule(Loans,RepaymentDate);

                LoanMgt.UpdateLoanStatus(Loans);
                end;
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
        Loans: Record "Loan Application";
        LoanMgt: Codeunit "Loan Management";
        RepaymentDate: Date;
}

