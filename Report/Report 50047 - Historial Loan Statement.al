report 50047 "Historial Loan Statement"
{
    // version THL-LOAN-1.0.0

    DefaultLayout = RDLC;
    RDLCLayout = './Historial Loan Statement.rdlc';

    dataset
    {
        dataitem("Historical Loans";"Historical Loans")
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "Loan No.","Date Filter";
            column(LoanNo;"Historical Loans"."Loan No.")
            {
            }
            column(ClientNo;"Historical Loans"."Staff ID")
            {
            }
            column(AccountNo;"Historical Loans"."Account No")
            {
            }
            column(ClientName;"Historical Loans"."Client Name")
            {
            }
            column(LoanProductName;"Historical Loans"."Loan Product Name")
            {
            }
            column(RepaymentMethod;"Historical Loans"."Repayment Method")
            {
            }
            column(Tenure;"Historical Loans"."Loan Period (in Months)")
            {
            }
            column(PrincipalRepaymentFreq;"Historical Loans"."Principal Repayment Frequency")
            {
            }
            column(InterestRepaymentFreq;"Historical Loans"."Interest Repayment Frequency")
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
            column(ApprovedAmount;"Historical Loans"."Approved Amount")
            {
            }
            column(LoanPrincipal;"Historical Loans".Principal)
            {
            }
            column(LoanInterest;"Historical Loans".Interest)
            {
            }
            column(RepaymentStartDate;"Historical Loans"."Repayment Start Date")
            {
            }
            column(LoanValuation;LoanValuation)
            {
            }
            column(LoanSaluation;"Historical Loans"."Total Amount Outstanding")
            {
            }
            column(RepaidPeriods;NoofRepayment)
            {
            }
            column(Fund;"Historical Loans"."Fund Code")
            {
            }
            column(PeriodInYears;PeriodInYears)
            {
            }
            column(RepaymentOption;"Historical Loans"."Principal Repayment Method")
            {
            }
            column(DateFilter;DateFilter)
            {
            }
            dataitem("Historical Repayment Schedules";"Historical Repayment Schedules")
            {
                DataItemLink = "Loan No."=FIELD("Loan No.");
                DataItemTableView = SORTING("Loan No.","Client No.","Repayment Date");
                column(Installment;"Historical Repayment Schedules"."Installment No.")
                {
                }
                column(Date;"Historical Repayment Schedules"."Repayment Date")
                {
                }
                column(BeginningBalace;"Historical Repayment Schedules"."Loan Amount")
                {
                }
                column(ScheduledPayment;"Historical Repayment Schedules"."Total Due")
                {
                }
                column(ExtraPayment;ExtraPayment)
                {
                }
                column(TotalPayment;"Historical Repayment Schedules"."Total Settlement")
                {
                }
                column(Principal;"Historical Repayment Schedules"."Principal Settlement")
                {
                }
                column(Interest;"Historical Repayment Schedules"."Interest Settlement")
                {
                }
                column(EndingBalance;EndingBalance)
                {
                }
                column(CumulativeInterest;CumulativeInterest)
                {
                }
                column(Total;"Historical Repayment Schedules"."Total Due")
                {
                }
                column(DueDuration;DueDuration)
                {
                }
                column(PrincipalDue_LoanRepaymentSchedule;"Historical Repayment Schedules"."Principal Due")
                {
                }
                column(InterestDue_LoanRepaymentSchedule;"Historical Repayment Schedules"."Interest Due")
                {
                }
                column(ClientLoanProduct;ClientLoanProduct)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    ExtraPayment := 0;
                    EndingBalance := 0;
                    if "Historical Repayment Schedules"."Total Settlement" > "Historical Repayment Schedules"."Total Due" then
                    ExtraPayment := "Historical Repayment Schedules"."Total Settlement" - "Historical Repayment Schedules"."Total Due";
                    
                    //Maxwell: To get the ending balance.
                    if reccount = counter  then begin
                      "Historical Repayment Schedules"."Principal Due" := "Historical Repayment Schedules"."Loan Amount";
                      "Historical Repayment Schedules"."Total Due" := "Historical Repayment Schedules"."Loan Amount" + "Historical Repayment Schedules"."Interest Due";
                    end;
                    EndingBalance := "Historical Repayment Schedules"."Loan Amount" - "Historical Repayment Schedules"."Principal Due";
                    
                    CumulativeInterest := CumulativeInterest + "Historical Repayment Schedules"."Interest Due";
                    
                    //Maxwell: To get the Loan Product Type.
                    LoanProduct.Reset;
                    LoanProduct.SetRange(Code, "Historical Repayment Schedules"."Loan Product Type");
                    if LoanProduct.FindFirst then
                      ClientLoanProduct := LoanProduct."Loan Type";
                    
                    /*InterestPerDay := ROUND(("Historical Repayment Schedules"."Interest Due"/31),0.01,'=');
                    DueDuration := DateFilter - LoanDueDate;
                    DueDurationAmount := DueDuration * InterestPerDay;
                    //MESSAGE('due duration amt: %1...lientLoanProduct..%2...UNSETTELEDAMT:%3',DueDurationamount,ClientLoanProduct,FirstUnsettledAmount);
                    IF ClientLoanProduct = ClientLoanProduct::Bullet THEN
                      LoanValuation := FirstUnsettledAmount + DueDurationAmount
                    ELSE
                       LoanValuation := (FirstUnsettledAmount*("Historical Loans"."Interest Rate"/100)*(DueDuration/365)) + FirstUnsettledAmount;
                    
                    reccount+=1;*/

                end;

                trigger OnPreDataItem()
                begin
                    /*counter :="Historical Repayment Schedules".COUNT;
                    reccount:=1;*/

                end;
            }

            trigger OnAfterGetRecord()
            begin
                PeriodInYears := Round("Historical Loans"."Loan Period (in Months)"/12,1);
                //InterestPerDay := ROUND(("Loan Application".Interest/"Loan Application"."No. of Interest Repayments"),0.01,'=');


                Schedule.Reset;
                Schedule.SetRange("Loan No.","Historical Loans"."Loan No.");
                Schedule.SetRange(Settled,false);
                if Schedule.FindFirst then begin
                FirstUnsettledAmount:=Schedule."Loan Amount";
                end;
                //MAXWELL: 26/08/2019 - Dynamically Get Loan Due Date
                Schedule.Reset;
                Schedule.SetRange("Loan No.","Historical Loans"."Loan No.");
                Schedule.SetRange("Repayment Date",0D,DateFilter);
                Schedule.SetRange(Settled,true);
                //Schedule.SETFILTER("Total Settlement",'=0');
                NoofRepayment:=Schedule.Count;
                if Schedule.FindLast then
                  LoanDueDate := Schedule."Repayment Date"
                else
                  LoanDueDate := "Historical Loans"."Repayment Start Date";
                //
                LoanValuation := 0;//"Historical Loans".Principal + "Historical Loans".Interest;
            end;

            trigger OnPreDataItem()
            begin
                if "Historical Loans".GetFilter("Date Filter")<>'' then
                 DateFilter:="Historical Loans".GetRangeMax("Date Filter")
                else
                  DateFilter:= Today;
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

    trigger OnPreReport()
    begin
        CumulativeInterest := 0;
    end;

    var
        ExtraPayment: Decimal;
        EndingBalance: Decimal;
        CumulativeInterest: Decimal;
        PeriodInYears: Integer;
        InterestPerDay: Decimal;
        LoanValuation: Decimal;
        DueDuration: Integer;
        DueDurationAmount: Decimal;
        DateFilter: Date;
        LoanDueDate: Date;
        InterestDue: Decimal;
        Schedule: Record "Historical Repayment Schedules";
        LoanProduct: Record "Loan Product";
        ClientLoanProduct: Option Annuitized,Bullet,"Zero Interest";
        counter: Integer;
        reccount: Integer;
        FirstUnsettledAmount: Decimal;
        NoofRepayment: Integer;
}

