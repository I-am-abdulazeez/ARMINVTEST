report 50108 "Update Loan Product on Repayme"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("Loan Repayment Lines";"Loan Repayment Lines")
        {

            trigger OnAfterGetRecord()
            begin
                if "Loan Repayment Lines"."Applies To Loan" <> '' then begin
                  if Loan.Get("Loan Repayment Lines"."Applies To Loan") then
                    "Loan Repayment Lines"."Loan Product" := Loan."Loan Product Type"
                  else if LoanHist.Get("Loan Repayment Lines"."Applies To Loan") then
                  "Loan Repayment Lines"."Loan Product" := LoanHist."Loan Product Type";
                  "Loan Repayment Lines".Modify;
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

    trigger OnPostReport()
    begin
        Message('Complete');
    end;

    var
        Loan: Record "Loan Application";
        LoanHist: Record "Historical Loans";
}

