report 50105 "Summary Of Liquidated Loans"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Summary Of Liquidated Loans.rdlc';

    dataset
    {
        dataitem("Loan Application";"Loan Application")
        {
            column(LoanNo;"Loan Application"."Loan No.")
            {
            }
            column(RepaymentMethod;"Loan Application"."Principal Repayment Method")
            {
            }
            column(Principal_HistoricalLoans;"Loan Application".Principal)
            {
            }
            column(RepaymentStartDate;"Loan Application"."Repayment Start Date")
            {
            }
            column(OutstandingPrincipal;"Loan Application"."Outstanding Principal")
            {
            }
            column(TotalAmountOutstanding;"Loan Application"."Total Amount Outstanding")
            {
            }
            column(FundCode;"Loan Application"."Fund Code")
            {
            }
            column(StaffID;"Loan Application"."Staff ID")
            {
            }
            column(LoanYears;"Loan Application"."Loan Years")
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
            column(ApprovedAmount;"Loan Application"."Approved Amount")
            {
            }
            column(NoofOutstandingPeriods;"Loan Application"."No. of Outstanding Periods")
            {
            }
            column(OutstandingInterest;"Loan Application"."Outstanding Interest")
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
            column(paymentDate;paymentDate)
            {
            }
            column(OutOfPocket;OutOfPocket)
            {
            }
            column(AmountLiquidated;AmountLiquidated)
            {
            }

            trigger OnAfterGetRecord()
            begin
                //"Loan Application".SETRANGE("Loan Application"."Application Date",StartDate,EndDate);
                 if "Loan Application"."Application Date" < StartDate then
                  CurrReport.Skip;
                 if "Loan Application"."Application Date" > EndDate then
                  CurrReport.Skip;
                Schedule.Reset;
                Schedule.SetRange("Loan No.","Loan Application"."Loan No.");
                //Schedule.SETRANGE("Fully Paid",TRUE);
                if Schedule.FindLast then begin
                  paymentDate := Schedule."Settlement Date";
                  end
                  else begin
                    Schedule2.Reset;
                    Schedule2.SetRange("Loan No.","Loan Application"."Loan No.");
                      if Schedule2.FindLast then begin
                        paymentDate := Schedule2."Settlement Date";
                      end;
                    end;
                  if paymentDate > EndDate then
                    CurrReport.Skip;
                  if paymentDate = 0D then
                    CurrReport.Skip;

                  OutOfPocket := 0;
                //get out of pocket amount
                ScheduleOutOfPocket.Reset;
                ScheduleOutOfPocket.SetRange("Loan No.","Loan No.");
                ScheduleOutOfPocket.SetRange("Settlement Date",StartDate,EndDate);
                ScheduleOutOfPocket.SetRange("Entry Type",ScheduleOutOfPocket."Entry Type"::"Off-Schedule");
                ScheduleOutOfPocket.CalcSums("Total Settlement");
                OutOfPocket := ScheduleOutOfPocket."Total Settlement";

                principalsettlement := 0;
                //get Amount liquidated
                ScheduleOutOfPocket.Reset;
                ScheduleOutOfPocket.SetRange("Loan No.","Loan No.");
                ScheduleOutOfPocket.SetRange("Settlement Date",StartDate,EndDate);
                ScheduleOutOfPocket.CalcSums("Principal Settlement");
                principalsettlement := ScheduleOutOfPocket."Principal Settlement";

                LastInterest := 0;
                //get the interest for last payment date
                ScheduleOutOfPocket.Reset;
                ScheduleOutOfPocket.SetRange("Loan No.","Loan No.");
                ScheduleOutOfPocket.SetRange("Settlement Date",paymentDate);
                if ScheduleOutOfPocket.FindFirst then
                  LastInterest:= ScheduleOutOfPocket."Interest Settlement";

                principalinterest := 0;
                //get interest within date range
                ScheduleOutOfPocket.Reset;
                ScheduleOutOfPocket.SetRange("Loan No.","Loan No.");
                ScheduleOutOfPocket.SetRange("Settlement Date",StartDate,EndDate);
                ScheduleOutOfPocket.SetFilter("Settlement Date",'<>%1',paymentDate);
                ScheduleOutOfPocket.CalcSums("Interest Settlement");
                principalinterest := ScheduleOutOfPocket."Interest Settlement";

                AmountLiquidated := principalsettlement + principalinterest + LastInterest;
                SerialNo := SerialNo+1;
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
        Schedule: Record "Loan Repayment Schedule";
        paymentDate: Date;
        Schedule2: Record "Loan Repayment Schedule";
        loanApplication: Record "Loan Application";
        OutOfPocket: Decimal;
        ScheduleOutOfPocket: Record "Loan Repayment Schedule";
        AmountLiquidated: Decimal;
        prevMonth: Date;
        principalsettlement: Decimal;
        LastInterest: Decimal;
        dt: Text;
        principalinterest: Decimal;
}

