report 50103 "Summary Of Liquidated Loans-H"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Summary Of Liquidated Loans-H.rdlc';

    dataset
    {
        dataitem("Historical Loans";"Historical Loans")
        {
            column(LoanNo;"Historical Loans"."Loan No.")
            {
            }
            column(RepaymentMethod;"Historical Loans"."Principal Repayment Method")
            {
            }
            column(Principal_HistoricalLoans;"Historical Loans".Principal)
            {
            }
            column(RepaymentStartDate;"Historical Loans"."Repayment Start Date")
            {
            }
            column(OutstandingPrincipal;"Historical Loans"."Outstanding Principal")
            {
            }
            column(TotalAmountOutstanding;"Historical Loans"."Total Amount Outstanding")
            {
            }
            column(FundCode;"Historical Loans"."Fund Code")
            {
            }
            column(StaffID;"Historical Loans"."Staff ID")
            {
            }
            column(LoanYears;"Historical Loans"."Loan Years")
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
            column(ApprovedAmount;"Historical Loans"."Approved Amount")
            {
            }
            column(NoofOutstandingPeriods;"Historical Loans"."No. of Outstanding Periods")
            {
            }
            column(OutstandingInterest;"Historical Loans"."Outstanding Interest")
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
                "Historical Loans".SetRange("Historical Loans"."Application Date",StartDate,EndDate);
                Schedule.Reset;
                Schedule.SetRange("Loan No.","Historical Loans"."Loan No.");
                //Schedule.SETRANGE("Fully Paid",TRUE);
                if Schedule.FindLast then begin
                  paymentDate := Schedule."Settlement Date";
                  end
                  else begin
                    Schedule2.Reset;
                    Schedule2.SetRange("Loan No.","Historical Loans"."Loan No.");
                      if Schedule2.FindLast then begin
                        paymentDate := Schedule2."Settlement Date";
                      end;
                    end;
                  if paymentDate > EndDate then
                    CurrReport.Skip;
                  if paymentDate = 0D then
                    CurrReport.Skip;

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

            trigger OnPreDataItem()
            begin
                // loanApplication.RESET;
                // loanApplication.SETRANGE(Status, loanApplication.Status::"Fully Repaid");
                // Schedule2.RESET;
                // Schedule2.SETRANGE("Fully Paid",TRUE);
                // Schedule2.SETRANGE("Settlement Date",StartDate,EndDate);
                // IF Schedule2.FIND find
                // IF loanApplication.FINDFIRST THEN BEGIN
                //  SerialNo := SerialNo+1;
                //  END;
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
        Schedule: Record "Historical Repayment Schedules";
        paymentDate: Date;
        Schedule2: Record "Loan Repayment Schedule";
        loanApplication: Record "Loan Application";
        OutOfPocket: Decimal;
        ScheduleOutOfPocket: Record "Historical Repayment Schedules";
        AmountLiquidated: Decimal;
        principalsettlement: Decimal;
        LastInterest: Decimal;
        principalinterest: Decimal;
}

