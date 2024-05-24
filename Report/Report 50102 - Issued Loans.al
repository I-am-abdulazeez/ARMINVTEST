report 50102 "Issued Loans"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Issued Loans.rdlc';

    dataset
    {
        dataitem("Loan Application";"Loan Application")
        {
            DataItemTableView = WHERE(Disbursed=CONST(true));
            column(LoanNo;"Loan Application"."Loan No.")
            {
            }
            column(ClientNo;"Loan Application"."Client No.")
            {
            }
            column(ClientName;"Loan Application"."Client Name")
            {
            }
            column(LoanProductName;"Loan Application"."Loan Product Name")
            {
            }
            column(LoanPeriodinMonths;"Loan Application"."Loan Period (in Months)")
            {
            }
            column(InterestRate;"Loan Application"."Interest Rate")
            {
            }
            column(ApplicationDate;"Loan Application"."Application Date")
            {
            }
            column(RequestedAmount;"Loan Application"."Requested Amount")
            {
            }
            column(Principal;"Loan Application".Principal)
            {
            }
            column(ApprovedAmount;"Loan Application"."Approved Amount")
            {
            }
            column(LoanDisbursementDate;"Loan Application"."Loan Disbursement Date")
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
            column(FundCode;"Loan Application"."Fund Code")
            {
            }

            trigger OnAfterGetRecord()
            begin
                SerialNo := SerialNo+1;
            end;

            trigger OnPreDataItem()
            begin
                "Loan Application".SetRange("Loan Application"."Loan Disbursement Date",StartDate,EndDate);
                //"Loan Application"."Application Date"
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

