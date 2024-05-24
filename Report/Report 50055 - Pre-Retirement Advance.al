report 50055 "Pre-Retirement Advance"
{
    // version THL-LOAN-1.0.0

    DefaultLayout = RDLC;
    RDLCLayout = './Pre-Retirement Advance.rdlc';

    dataset
    {
        dataitem("Loan Application";"Loan Application")
        {
            DataItemTableView = WHERE("Interest Repayment Frequency"=FILTER(None));
            RequestFilterFields = "Loan No.","Client No.","Application Date",Status,"Fund Code";
            column(Logo;CompInfo.Picture)
            {
            }
            column(ClientNo;"Loan Application"."Client No.")
            {
            }
            column(Name;"Loan Application"."Client Name")
            {
            }
            column(Tenure;"Loan Application"."Loan Period (in Months)")
            {
            }
            column(Fund;"Loan Application"."Fund Code")
            {
            }
            column(OrderNo;"Loan Application"."Loan No.")
            {
            }
            column(StatusText;StatusText)
            {
            }
            column(Security;Security)
            {
            }
            column(Amount;"Loan Application"."Investment Balance")
            {
            }
            column(LoanAmount;"Loan Application"."Approved Amount")
            {
            }
            column(TotalPayable;TotalPayable)
            {
            }
            column(ValueDate;"Loan Application"."Application Date")
            {
            }

            trigger OnAfterGetRecord()
            begin
                if "Loan Application".Status = "Loan Application".Status::New then
                  StatusText := 'Booked'
                else if "Loan Application".Status = "Loan Application".Status::"Pending Approval" then
                  StatusText := 'Pending Approval'
                else if "Loan Application".Status = "Loan Application".Status::Rejected then
                  StatusText := 'Rejected'
                else if "Loan Application".Status = "Loan Application".Status::Approved then begin
                  if "Loan Application".Disbursed then
                  StatusText := 'Executed & Settled'
                  else
                  StatusText := 'Executed not Settled';
                end;


                if Funds.Get("Loan Application"."Fund Code") then
                  Security := "Loan Application"."Fund Code"+' - '+Funds.Name;

                TotalPayable := 0;
                TotalPayable := "Loan Application"."Investment Balance" - "Loan Application"."Approved Amount";
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

    trigger OnInitReport()
    begin
        CompInfo.Get;
        CompInfo.CalcFields(Picture);
    end;

    var
        CompInfo: Record "Company Information";
        StatusText: Text;
        Security: Text;
        Funds: Record Fund;
        TotalPayable: Decimal;
}

