report 50113 "Issued Loans-Master"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Issued Loans-Master.rdlc';

    dataset
    {
        dataitem("Loan Application";"Reversed Accrued Income")
        {
            column(LoanNo;"Loan Application".No)
            {
            }
            column(ClientNo;"Loan Application"."Client ID")
            {
            }
            column(ClientName;"Loan Application"."Account No")
            {
            }
            column(LoanProductName;"Loan Application"."Reversed Unit")
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
            column(LoanDisbursementDate;DisbursementDate)
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
            column(Scheme;FundCode)
            {
            }
            column(ARMIM;ARMIM)
            {
            }
            column(Vetiva;Vetiva)
            {
            }
            column(IBTC;IBTC)
            {
            }

            trigger OnAfterGetRecord()
            begin
                SerialNo := SerialNo+1;

                ARMIM := 0;
                Vetiva := 0;
                IBTC := 0;

                if ActiveLoans.Get("Loan Application".No) then begin
                  if (ActiveLoans.Status = ActiveLoans.Status::New) or (ActiveLoans.Status = ActiveLoans.Status::"Pending Approval") or (ActiveLoans.Status = ActiveLoans.Status::Rejected) then
                    CurrReport.Skip;

                  FundCode := ActiveLoans."Fund Code";
                  DisbursementDate := ActiveLoans."Loan Disbursement Date";
                end else if HistoricalLoans.Get("Loan Application".No) then begin
                  FundCode := HistoricalLoans."Fund Code";
                  DisbursementDate := HistoricalLoans."Loan Disbursement Date";
                end;

                FundManagerRatios.Reset;
                FundManagerRatios.SetFilter(From,'<%1',"Loan Application"."Application Date");
                FundManagerRatios.SetFilter("To",'>%1',"Loan Application"."Application Date");
                if FundManagerRatios.FindSet then begin repeat
                  if FundManagerRatios."Fund Manager" = 'ARM' then
                    ARMIM := Round(FundManagerRatios.Percentage * "Loan Application"."Approved Amount"/100,0.01);
                  if FundManagerRatios."Fund Manager" = 'IBTC' then
                    IBTC := Round(FundManagerRatios.Percentage * "Loan Application"."Approved Amount"/100,0.01);
                  if FundManagerRatios."Fund Manager" = 'VETIVA' then
                    Vetiva := Round(FundManagerRatios.Percentage * "Loan Application"."Approved Amount"/100,0.01);
                until FundManagerRatios.Next = 0
                end;
            end;

            trigger OnPreDataItem()
            begin
                "Loan Application".SetRange("Loan Application"."Application Date",StartDate,EndDate);
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
        Error('Enter End Date');
    end;

    var
        SerialNo: Integer;
        StartDate: Date;
        EndDate: Date;
        FundManagerRatios: Record "Product Fund Manager Ratio";
        Vetiva: Decimal;
        IBTC: Decimal;
        ARMIM: Decimal;
        DisbursementDate: Date;
        FundCode: Code[10];
        ActiveLoans: Record "Loan Application";
        HistoricalLoans: Record "Historical Loans";
}

