report 50060 "Loan Statement"
{
    // version THL-LOAN-1.0.0

    DefaultLayout = RDLC;
    RDLCLayout = './Loan Statement.rdlc';

    dataset
    {
        dataitem("Loan Application";"Loan Application")
        {
            RequestFilterFields = "Loan No.","Date Filter";
            column(LoanNo;"Loan Application"."Loan No.")
            {
            }
            column(ClientNo;"Loan Application"."Staff ID")
            {
            }
            column(AccountNo;"Loan Application"."Account No")
            {
            }
            column(ClientName;"Loan Application"."Client Name")
            {
            }
            column(LoanProductName;"Loan Application"."Loan Product Name")
            {
            }
            column(RepaymentMethod;"Loan Application"."Repayment Method")
            {
            }
            column(Tenure;"Loan Application"."Loan Period (in Months)")
            {
            }
            column(PrincipalRepaymentFreq;"Loan Application"."Principal Repayment Frequency")
            {
            }
            column(InterestRepaymentFreq;"Loan Application"."Interest Repayment Frequency")
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
            column(ApprovedAmount;"Loan Application"."Approved Amount")
            {
            }
            column(LoanPrincipal;"Loan Application".Principal)
            {
            }
            column(LoanInterest;"Loan Application".Interest)
            {
            }
            column(RepaymentStartDate;"Loan Application"."Repayment Start Date")
            {
            }
            column(LoanValuation;LoanValuation)
            {
            }
            column(LoanSaluation;"Loan Application"."Total Amount Outstanding")
            {
            }
            column(RepaidPeriods;NoofRepayment)
            {
            }
            column(Fund;"Loan Application"."Fund Code")
            {
            }
            column(PeriodInYears;PeriodInYears)
            {
            }
            column(RepaymentOption;"Loan Application"."Principal Repayment Method")
            {
            }
            column(DateFilter;DateFilter)
            {
            }
            dataitem("Loan Repayment Schedule";"Loan Repayment Schedule")
            {
                DataItemLink = "Loan No."=FIELD("Loan No.");
                column(Installment;"Loan Repayment Schedule"."Installment No.")
                {
                }
                column(Date;"Loan Repayment Schedule"."Repayment Date")
                {
                }
                column(BeginningBalace;"Loan Repayment Schedule"."Loan Amount")
                {
                }
                column(ScheduledPayment;"Loan Repayment Schedule"."Total Due")
                {
                }
                column(ExtraPayment;ExtraPayment)
                {
                }
                column(TotalPayment;"Loan Repayment Schedule"."Total Settlement")
                {
                }
                column(Principal;"Loan Repayment Schedule"."Principal Settlement")
                {
                }
                column(Interest;"Loan Repayment Schedule"."Interest Settlement")
                {
                }
                column(EndingBalance;EndingBalance)
                {
                }
                column(CumulativeInterest;CumulativeInterest)
                {
                }
                column(Total;"Loan Repayment Schedule"."Total Due")
                {
                }
                column(DueDuration;DueDuration)
                {
                }
                column(PrincipalDue_LoanRepaymentSchedule;"Loan Repayment Schedule"."Principal Due")
                {
                }
                column(InterestDue_LoanRepaymentSchedule;"Loan Repayment Schedule"."Interest Due")
                {
                }
                column(ClientLoanProduct;ClientLoanProduct)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    ExtraPayment := 0;
                    EndingBalance := 0;
                    if "Loan Repayment Schedule"."Total Settlement" > "Loan Repayment Schedule"."Total Due" then
                    ExtraPayment := "Loan Repayment Schedule"."Total Settlement" - "Loan Repayment Schedule"."Total Due";
                    
                    //Maxwell: To get the ending balance.
                    if reccount = counter  then begin
                      "Loan Repayment Schedule"."Principal Due" := "Loan Repayment Schedule"."Loan Amount";
                      "Loan Repayment Schedule"."Total Due" := "Loan Repayment Schedule"."Loan Amount" + "Loan Repayment Schedule"."Interest Due";
                    end;
                    EndingBalance := "Loan Repayment Schedule"."Loan Amount" - "Loan Repayment Schedule"."Principal Due";
                    
                    CumulativeInterest := CumulativeInterest + "Loan Repayment Schedule"."Interest Due";
                    
                    //Maxwell: To get the Loan Product Type.
                    LoanProduct.Reset;
                    LoanProduct.SetRange(Code, "Loan Repayment Schedule"."Loan Product Type");
                    if LoanProduct.FindFirst then
                      ClientLoanProduct := LoanProduct."Loan Type";
                    
                    InterestPerDay := Round(("Loan Repayment Schedule"."Interest Due"/31),0.01,'=');
                    DueDuration := DateFilter - LoanDueDate;
                    DueDurationAmount := DueDuration * InterestPerDay;
                    //MESSAGE('due duration amt: %1...lientLoanProduct..%2...UNSETTELEDAMT:%3',DueDurationamount,ClientLoanProduct,FirstUnsettledAmount);
                    /*IF ClientLoanProduct = ClientLoanProduct::Bullet THEN
                      LoanValuation := FirstUnsettledAmount + DueDurationAmount
                    ELSE
                       LoanValuation := (FirstUnsettledAmount*("Loan Application"."Interest Rate"/100)*(DueDuration/365)) + FirstUnsettledAmount;*/
                    
                    reccount+=1;

                end;

                trigger OnPreDataItem()
                begin
                    counter :="Loan Repayment Schedule".Count;
                    reccount:=1;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                PeriodInYears := Round("Loan Application"."Loan Period (in Months)"/12,1);
                //InterestPerDay := ROUND(("Loan Application".Interest/"Loan Application"."No. of Interest Repayments"),0.01,'=');

                LoanValuation := LoanMgt.GetLoanValuationWithRefDate("Loan Application"."Loan No.",DateFilter);

                Schedule.Reset;
                Schedule.SetRange("Loan No.","Loan Application"."Loan No.");
                Schedule.SetRange(Settled,false);
                if Schedule.FindFirst then begin
                FirstUnsettledAmount:=Schedule."Loan Amount";
                end;
                //MAXWELL: 26/08/2019 - Dynamically Get Loan Due Date
                Schedule.Reset;
                Schedule.SetRange("Loan No.","Loan Application"."Loan No.");
                Schedule.SetRange("Repayment Date",0D,DateFilter);
                Schedule.SetRange(Settled,true);
                //Schedule.SETFILTER("Total Settlement",'=0');
                NoofRepayment:=Schedule.Count;
                if Schedule.FindLast then
                  LoanDueDate := Schedule."Repayment Date"
                else
                  //LoanDueDate := "Loan Application"."Repayment Start Date";
                  LoanDueDate := "Loan Application"."Application Date";
                //
            end;

            trigger OnPreDataItem()
            begin
                if "Loan Application".GetFilter("Date Filter")<>'' then
                 DateFilter:="Loan Application".GetRangeMax("Date Filter")
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
        Schedule: Record "Loan Repayment Schedule";
        LoanProduct: Record "Loan Product";
        ClientLoanProduct: Option Annuitized,Bullet,"Zero Interest";
        counter: Integer;
        reccount: Integer;
        FirstUnsettledAmount: Decimal;
        NoofRepayment: Integer;
        LoanMgt: Codeunit "Loan Management";
}

