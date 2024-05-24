report 50101 "Issued Loans (Historical)"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Issued Loans (Historical).rdlc';

    dataset
    {
        dataitem("Historical Loans";"Historical Loans")
        {
            DataItemTableView = WHERE(Disbursed=CONST(true));
            column(LoanNo;"Historical Loans"."Loan No.")
            {
            }
            column(ClientNo;"Historical Loans"."Client No.")
            {
            }
            column(ClientName;"Historical Loans"."Client Name")
            {
            }
            column(LoanProductName;"Historical Loans"."Loan Product Name")
            {
            }
            column(LoanPeriodinMonths;"Historical Loans"."Loan Period (in Months)")
            {
            }
            column(InterestRate;"Historical Loans"."Interest Rate")
            {
            }
            column(ApplicationDate;"Historical Loans"."Application Date")
            {
            }
            column(RequestedAmount;"Historical Loans"."Requested Amount")
            {
            }
            column(Principal;"Historical Loans".Principal)
            {
            }
            column(ApprovedAmount;"Historical Loans"."Approved Amount")
            {
            }
            column(LoanDisbursementDate;"Historical Loans"."Loan Disbursement Date")
            {
            }
            column(SerialNo;SerialNo)
            {
            }
            column(StartDate;StartDate)
            {
            }
            column(EndDate;EndDate)
            {
            }
            column(FundCode;"Historical Loans"."Fund Code")
            {
            }

            trigger OnAfterGetRecord()
            begin
                SerialNo := SerialNo+1;
            end;

            trigger OnPreDataItem()
            begin
                "Historical Loans".SetRange("Historical Loans"."Loan Disbursement Date",StartDate,EndDate);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(StartDate;StartDate)
                {
                }
                field(EndDate;EndDate)
                {
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        if StartDate = 0D then
        Error('Enter Start Date');

        if EndDate = 0D then
        Error('Enter Start Date');
    end;

    var
        SerialNo: Integer;
        StartDate: Date;
        EndDate: Date;
}

