codeunit 50009 "Loan Management"
{
    // version THL-LOAN-1.0.0


    trigger OnRun()
    begin
        //MESSAGE(FORMAT(GetLoanValuation('LN-0000000000000636')))
        //MESSAGE(FORMAT(GetLoanValuationWithRefDate('LN-0000000000000366',080420D)))
        //MESSAGE(FORMAT(GetLoanValuation('LN-0000000000000011')));

        //UpdateLoanVar
        //UpdateHRepaymentSchedule
    end;

    var
        FundAdministration: Codeunit "Fund Administration";
        ClientAccounts: Record "Client Account";
        Loans: Record "Loan Application";
        RSchedule: Record "Loan Repayment Schedule";
        LoanApp: Record "Loan Application";
        Text000: Label 'Interest Repayments are not expected for this Loan. Kindly confirm the Interest Repayment Frequency!';
        RSchedule2: Record "Loan Repayment Schedule";
        Window: Dialog;
        LoanVar: Record "Loan Variation";
        VSchedule: Record "Variation Repayment Schedule";
        Product: Record "Loan Product";
        LoanMgtSetup: Record "Loan Management Setup";
        HistoricalLoans: Record "Historical Loans";
        HistoricalSchedule: Record "Historical Repayment Schedules";
        HistoricalVariation: Record "Historical Loan Variation";
        Selection: Integer;
        CreatingText: Label 'Top-up,Termination,Change of Tenure,Conversion to Other Loan Type';
        counters: Integer;
        reccode: Code[20];
        TransactionMgt: Codeunit "Fund Transaction Management";
        StartDate: Date;
        EndDate: Date;
        LineNo: Integer;
        Names: Text;
        ExternalSeviceCall: Codeunit ExternalCallService;

    procedure GetInvestmentBalance(var ClientNo: Code[20]) NAV: Decimal
    begin
        NAV := 0;
        ClientAccounts.Reset;
        ClientAccounts.SetRange("Client ID",ClientNo);
        if ClientAccounts.FindSet then begin repeat
          ClientAccounts.CalcFields("No of Units");
          NAV :=NAV + FundAdministration.GetNAV(Today,ClientAccounts."Fund No",ClientAccounts."No of Units");
        until ClientAccounts.Next = 0;
        end;
    end;

    procedure RepaymentSchedule(var RepaySchedule: Record "Loan Application")
    var
        QCounter: Integer;
        InPeriod: DateFormula;
        LoanAmount: Decimal;
        RepayPeriod: Integer;
        LBalance: Decimal;
        RunDate: Date;
        InstalNo: Integer;
        RepayInterval: DateFormula;
        InterestRate: Decimal;
        InitialInstal: Integer;
        TotalMRepay: Decimal;
        LInterest: Decimal;
        LPrincipal: Decimal;
        RepayCode: Code[10];
        CumulativePrincipal: Decimal;
        PreviousCumulativePrincipal: Decimal;
        TotalInterest: Decimal;
        TotalPrincipal: Decimal;
    begin
        with RepaySchedule do begin
        if "Interest Repayment Frequency" = "Interest Repayment Frequency"::None then
          Error(Text000);

        TotalInterest := 0;

        Loans.Reset;
        Loans.SetRange(Loans."Loan No.","Loan No.");
        if Loans.Find('-') then begin
          if Loans.Status=Loans.Status::Approved then
          TestField("Loan Disbursement Date");
          TestField("Repayment Start Date");

          RSchedule.Reset;
          RSchedule.SetRange(RSchedule."Loan No.","Loan No.");
          RSchedule.SetRange(RSchedule."Entry Type",RSchedule."Entry Type"::Scheduled);
          RSchedule.DeleteAll;

          LoanAmount:=Loans."Approved Amount";
          InterestRate:=Loans."Interest Rate";

          RepayPeriod:=Loans."Loan Period (in Months)";
          LBalance:=Loans."Approved Amount";
          RunDate := "Repayment Start Date";

          if "Interest Repayment Frequency" = "Interest Repayment Frequency"::Annually then
          RunDate:=CalcDate('-1Y',RunDate);
          if "Interest Repayment Frequency" = "Interest Repayment Frequency"::Monthly then
          RunDate:=CalcDate('-1M',RunDate);
          if "Interest Repayment Frequency" = "Interest Repayment Frequency"::Quarterly then
          RunDate:=CalcDate('-1Q',RunDate);
          if "Interest Repayment Frequency" = "Interest Repayment Frequency"::"Semi-Annually" then
          RunDate:=CalcDate('-6M',RunDate);

          InstalNo:=0;
          if "Interest Repayment Frequency" = "Interest Repayment Frequency"::Annually then
          Evaluate(RepayInterval,'1Y');
          if "Interest Repayment Frequency" = "Interest Repayment Frequency"::Monthly then
          Evaluate(RepayInterval,'1M');
          if "Interest Repayment Frequency" = "Interest Repayment Frequency"::Quarterly then
          Evaluate(RepayInterval,'1Q');
          if "Interest Repayment Frequency" = "Interest Repayment Frequency"::"Semi-Annually" then
          Evaluate(RepayInterval,'6M');

        repeat
        InstalNo:=InstalNo+1;
          if "Interest Repayment Frequency" = "Interest Repayment Frequency"::Annually then
          RunDate:=CalcDate('1Y',RunDate);
          if "Interest Repayment Frequency" = "Interest Repayment Frequency"::Monthly then
          RunDate:=CalcDate('1M',RunDate);
          if "Interest Repayment Frequency" = "Interest Repayment Frequency"::Quarterly then
          RunDate:=CalcDate('1Q',RunDate);
          if "Interest Repayment Frequency" = "Interest Repayment Frequency"::"Semi-Annually" then
          RunDate:=CalcDate('6M',RunDate);


          if "Repayment Method"="Repayment Method"::Amortized then begin
            if "Principal Repayment Method" = "Principal Repayment Method"::Annuity then begin
            TotalMRepay:=Round((InterestRate/12/100) / (1 - Power((1 + (InterestRate/12/100)),- RepayPeriod)) * LoanAmount,0.01,'>');
            LInterest:=Round(LBalance / 100 / 12 * InterestRate,0.01,'>');
            LPrincipal:=TotalMRepay-LInterest;

            if (LBalance < TotalMRepay) then
            LPrincipal:=LBalance-LInterest;

            //7th Oct 2019 - Last Loan Principal Calculation
            if (InstalNo = RepayPeriod) then
            LPrincipal := (LoanAmount-TotalPrincipal);
            //
            Evaluate(RepayCode,Format(InstalNo));

            RSchedule.Init;
            RSchedule."Repayment Code":=RepayCode;
            RSchedule."Loan No.":="Loan No.";
            RSchedule."Loan Amount":=LBalance;
            RSchedule."Installment No.":=InstalNo;
            RSchedule."Repayment Date":=RunDate;
            RSchedule."Client No.":="Client No.";
            RSchedule."Loan Product Type":="Loan Product Type";
            RSchedule."Interest Due":=LInterest;
            RSchedule."Principal Due":=LPrincipal;
            RSchedule."Total Due":=LInterest + LPrincipal;
            RSchedule."Client Name":="Client Name";
            RSchedule."Due Date":=CalcDate('CM',RSchedule."Repayment Date");
            RSchedule.Insert;
            Commit;
            end;

            if "Principal Repayment Method" = "Principal Repayment Method"::Bullet then begin
              LInterest:=Round((InterestRate/12/100)  * (LoanAmount-TotalPrincipal),0.05,'>');

                Evaluate(RepayCode,Format(InstalNo));

                RSchedule.Init;
                RSchedule."Repayment Code":=RepayCode;
                RSchedule."Loan No.":="Loan No.";
                RSchedule."Loan Amount":=(LoanAmount-TotalPrincipal);
                RSchedule."Installment No.":=InstalNo;
                RSchedule."Repayment Date":=RunDate;
                RSchedule."Client No.":="Client No.";
                RSchedule."Loan Product Type":="Loan Product Type";
              if Date2DMY(RunDate,2) = 1 then
                LPrincipal:=Round(LoanAmount/"No. of Principal Repayments",0.05,'>')
              else
                LPrincipal:=0;
                RSchedule."Total Due":=LInterest+LPrincipal;
                RSchedule."Interest Due":=LInterest;
                RSchedule."Principal Due":=LPrincipal;
                RSchedule."Client Name":="Client Name";
                RSchedule."Due Date":=CalcDate('CM',RSchedule."Repayment Date");
                RSchedule.Insert;
                Commit;
            end;
          end;

        LBalance:=LBalance-LPrincipal;
        TotalInterest := TotalInterest + LInterest;
        TotalPrincipal := TotalPrincipal + LPrincipal;
        until (LBalance < 1) or (LBalance = LInterest)
        end;
        Loans.Principal := TotalPrincipal;
        Loans.Interest := TotalInterest;
        Loans.Modify;
        end;
    end;

    procedure GetInvestmentBalanceEmployee(var ClientNo: Code[20]) NAV: Decimal
    begin
        NAV := 0;
        ClientAccounts.Reset;
        ClientAccounts.SetRange("Client ID",ClientNo);
        if ClientAccounts.FindSet then begin repeat
          ClientAccounts.CalcFields("Employee Units");
          NAV :=NAV + FundAdministration.GetNAV(Today,ClientAccounts."Fund No",ClientAccounts."Employee Units");
        until ClientAccounts.Next = 0;
        end;
    end;

    procedure RecalculateRepaymentSchedule(var RepaySchedule: Record "Loan Application";var RepaymentStartDate: Date)
    var
        QCounter: Integer;
        InPeriod: DateFormula;
        LoanAmount: Decimal;
        RepayPeriod: Integer;
        LBalance: Decimal;
        RunDate: Date;
        InstalNo: Integer;
        RepayInterval: DateFormula;
        InterestRate: Decimal;
        InitialInstal: Integer;
        TotalMRepay: Decimal;
        LInterest: Decimal;
        LPrincipal: Decimal;
        RepayCode: Code[10];
        CumulativePrincipal: Decimal;
        PreviousCumulativePrincipal: Decimal;
        TotalInterest: Decimal;
        TotalPrincipal: Decimal;
        LoanRec: Record "Loan Application";
        EarlyRepayment: Decimal;
    begin
        with RepaySchedule do begin
        if "Interest Repayment Frequency" = "Interest Repayment Frequency"::None then
          Error(Text000);
        
        TotalInterest := 0;
        
        Loans.Reset;
        Loans.SetRange(Loans."Loan No.","Loan No.");
        if Loans.Find('-') then begin
          if (Loans.Status=Loans.Status::Approved) or (Loans.Status=Loans.Status::"Partially Repaid") then
          TestField("Loan Disbursement Date");
          TestField("Repayment Start Date");
        
          RSchedule.Reset;
          RSchedule.SetRange(RSchedule."Loan No.","Loan No.");
          RSchedule.SetRange(RSchedule."Entry Type",RSchedule."Entry Type"::Scheduled);
          RSchedule.SetRange("Repayment Date",0D,CalcDate('CM',RepaymentStartDate));
          if RSchedule.FindLast then
            InstalNo:=RSchedule."Installment No.";
        
          RSchedule.Reset;
          RSchedule.SetRange(RSchedule."Loan No.","Loan No.");
          RSchedule.SetRange(RSchedule."Entry Type",RSchedule."Entry Type"::Scheduled);
          RSchedule.SetFilter("Repayment Date",'>%1',CalcDate('CM',RepaymentStartDate));
          RSchedule.DeleteAll;
        
            //***************************
            LoanRec.Get(Loans."Loan No.");
            LoanRec.SetFilter("Date Filter",'%1..%2',0D,CalcDate('CM',RepaymentStartDate));
            LoanRec.CalcFields("Total Principal Repaid","Outstanding Principal");
            EarlyRepayment := LoanRec."Total Principal Repaid"+LoanRec."Outstanding Principal";
            //***************************
        
          Loans.CalcFields("Total Principal Repaid","No. of Repaid Periods","Total Principal");
          LoanAmount:=Loans."Approved Amount"-EarlyRepayment;
          InterestRate:=Loans."Interest Rate";
        
          RepayPeriod:=Loans."Loan Period (in Months)"-InstalNo;
          LBalance:=Loans."Approved Amount"-EarlyRepayment;
        
          RunDate:=RepaymentStartDate;
        
          if "Interest Repayment Frequency" = "Interest Repayment Frequency"::Annually then
          Evaluate(RepayInterval,'1Y');
          if "Interest Repayment Frequency" = "Interest Repayment Frequency"::Monthly then
          Evaluate(RepayInterval,'1M');
          if "Interest Repayment Frequency" = "Interest Repayment Frequency"::Quarterly then
          Evaluate(RepayInterval,'1Q');
          if "Interest Repayment Frequency" = "Interest Repayment Frequency"::"Semi-Annually" then
          Evaluate(RepayInterval,'6M');
        
        repeat
        InstalNo:=InstalNo+1;
          if "Interest Repayment Frequency" = "Interest Repayment Frequency"::Annually then
          RunDate:=CalcDate('1Y',RunDate);
          if "Interest Repayment Frequency" = "Interest Repayment Frequency"::Monthly then
          RunDate:=CalcDate('1M',RunDate);
          if "Interest Repayment Frequency" = "Interest Repayment Frequency"::Quarterly then
          RunDate:=CalcDate('1Q',RunDate);
          if "Interest Repayment Frequency" = "Interest Repayment Frequency"::"Semi-Annually" then
          RunDate:=CalcDate('6M',RunDate);
        
        
          if "Repayment Method"="Repayment Method"::Amortized then begin
            if "Principal Repayment Method" = "Principal Repayment Method"::Annuity then begin
        
        
            TotalMRepay:=Round((InterestRate/12/100) / (1 - Power((1 + (InterestRate/12/100)),- RepayPeriod)) * LoanAmount,0.01,'>');
            LInterest:=Round(LBalance / 100 / 12 * InterestRate,0.05,'>');
            LPrincipal:=TotalMRepay-LInterest;
        
            if (LBalance < TotalMRepay) then
            LPrincipal:=LBalance-LInterest;
        
            //7th Oct 2019 - Last Loan Principal Calculation
            if (InstalNo = Loans."Loan Period (in Months)") then
            LPrincipal := (LoanAmount-TotalPrincipal);
        
        
            Evaluate(RepayCode,Format(InstalNo));
            RSchedule.Init;
            RSchedule."Repayment Code":=RepayCode;
            RSchedule."Loan No.":="Loan No.";
            RSchedule."Loan Amount":=LBalance;
            RSchedule."Installment No.":=InstalNo;
            RSchedule."Repayment Date":=RunDate;
            RSchedule."Client No.":="Client No.";
            RSchedule."Loan Product Type":="Loan Product Type";
            RSchedule."Interest Due":=LInterest;
            RSchedule."Principal Due":=LPrincipal;
            RSchedule."Total Due":=LInterest + LPrincipal;
            RSchedule."Client Name":="Client Name";
            RSchedule."Due Date":=CalcDate('CM',RSchedule."Repayment Date");
            RSchedule.Insert;
            end;
        
            if "Principal Repayment Method" = "Principal Repayment Method"::Bullet then begin
              LInterest:=Round((InterestRate/12/100)  * (LoanAmount-TotalPrincipal),0.05,'>');
        
                Evaluate(RepayCode,Format(InstalNo));
        
                RSchedule.Init;
                RSchedule."Repayment Code":=RepayCode;
                RSchedule."Loan No.":="Loan No.";
                RSchedule."Loan Amount":=(LoanAmount-TotalPrincipal);
                RSchedule."Installment No.":=InstalNo;
                RSchedule."Repayment Date":=RunDate;
                RSchedule."Client No.":="Client No.";
                RSchedule."Loan Product Type":="Loan Product Type";
              if Date2DMY(RunDate,2) = 1 then begin
                if RepayPeriod < 12 then
                LPrincipal:=Round(LoanAmount/1)
                else
                LPrincipal:=Round(LoanAmount/Round(RepayPeriod/12,1,'='),0.05,'>')
        
              end else
                LPrincipal:=0;
                RSchedule."Total Due":=LInterest+LPrincipal;
                RSchedule."Interest Due":=LInterest;
                RSchedule."Principal Due":=LPrincipal;
                RSchedule."Client Name":="Client Name";
                RSchedule."Due Date":=CalcDate('CM',RSchedule."Repayment Date");
                RSchedule.Insert;
            end;
          end;
        
        
        LBalance:=LBalance-LPrincipal;
        
        
        TotalInterest := TotalInterest + LInterest;
        TotalPrincipal := TotalPrincipal + LPrincipal;
        until (LBalance < 1) or (LBalance = LInterest)
        end;
        Loans.Principal := TotalPrincipal;
        Loans.Interest := TotalInterest;
        Loans.Modify;
        end;
        
        //Maxwell: Comment out the codes below
        
        /*WITH RepaySchedule DO BEGIN
        IF "Interest Repayment Frequency" = "Interest Repayment Frequency"::None THEN
          ERROR(Text000);
        
        TotalInterest := 0;
        
        Loans.RESET;
        Loans.SETRANGE(Loans."Loan No.","Loan No.");
        IF Loans.FIND('-') THEN BEGIN
          IF (Loans.Status=Loans.Status::Approved) OR (Loans.Status=Loans.Status::"Partially Repaid") THEN
          TESTFIELD("Loan Disbursement Date");
          TESTFIELD("Repayment Start Date");
        
          RSchedule.RESET;
          RSchedule.SETRANGE(RSchedule."Loan No.","Loan No.");
          RSchedule.SETRANGE(RSchedule."Entry Type",RSchedule."Entry Type"::Scheduled);
          RSchedule.SETRANGE("Repayment Date",0D,CALCDATE('CM',RepaymentStartDate));
          IF RSchedule.FINDLAST THEN
            InstalNo:=RSchedule."Installment No.";
        
          RSchedule.RESET;
          RSchedule.SETRANGE(RSchedule."Loan No.","Loan No.");
          RSchedule.SETRANGE(RSchedule."Entry Type",RSchedule."Entry Type"::Scheduled);
          RSchedule.SETFILTER("Repayment Date",'>%1',CALCDATE('CM',RepaymentStartDate));
          RSchedule.DELETEALL;
        
            //***************************
            LoanRec.GET(Loans."Loan No.");
            LoanRec.SETFILTER("Date Filter",'%1..%2',0D,CALCDATE('CM',RepaymentStartDate));
            LoanRec.CALCFIELDS("Total Principal Repaid","Outstanding Principal");
            EarlyRepayment := LoanRec."Total Principal Repaid"+LoanRec."Outstanding Principal";
            //MESSAGE('Early Repayment: %1',EarlyRepayment);
            //***************************
        
          Loans.CALCFIELDS("Total Principal Repaid","No. of Repaid Periods","Total Principal");
          LoanAmount:=Loans."Approved Amount"-EarlyRepayment;
          InterestRate:=Loans."Interest Rate";
        
          RepayPeriod:=Loans."Loan Period (in Months)"-Loans."No. of Repaid Periods";
          LBalance:=Loans."Approved Amount"-EarlyRepayment;
        
          RunDate:=RepaymentStartDate;
        
          {IF "Interest Repayment Frequency" = "Interest Repayment Frequency"::Annually THEN
          RunDate:=CALCDATE('-1Y',RunDate);
          IF "Interest Repayment Frequency" = "Interest Repayment Frequency"::Monthly THEN
          RunDate:=CALCDATE('-1M',RunDate);
          IF "Interest Repayment Frequency" = "Interest Repayment Frequency"::Quarterly THEN
          RunDate:=CALCDATE('-1Q',RunDate);
          IF "Interest Repayment Frequency" = "Interest Repayment Frequency"::"Semi-Annually" THEN
          RunDate:=CALCDATE('-6M',RunDate);}
        
        
          IF "Interest Repayment Frequency" = "Interest Repayment Frequency"::Annually THEN
          EVALUATE(RepayInterval,'1Y');
          IF "Interest Repayment Frequency" = "Interest Repayment Frequency"::Monthly THEN
          EVALUATE(RepayInterval,'1M');
          IF "Interest Repayment Frequency" = "Interest Repayment Frequency"::Quarterly THEN
          EVALUATE(RepayInterval,'1Q');
          IF "Interest Repayment Frequency" = "Interest Repayment Frequency"::"Semi-Annually" THEN
          EVALUATE(RepayInterval,'6M');
        
        REPEAT
        InstalNo:=InstalNo+1;
          IF "Interest Repayment Frequency" = "Interest Repayment Frequency"::Annually THEN
          RunDate:=CALCDATE('1Y',RunDate);
          IF "Interest Repayment Frequency" = "Interest Repayment Frequency"::Monthly THEN
          RunDate:=CALCDATE('1M',RunDate);
          IF "Interest Repayment Frequency" = "Interest Repayment Frequency"::Quarterly THEN
          RunDate:=CALCDATE('1Q',RunDate);
          IF "Interest Repayment Frequency" = "Interest Repayment Frequency"::"Semi-Annually" THEN
          RunDate:=CALCDATE('6M',RunDate);
        
        
          IF "Repayment Method"="Repayment Method"::Amortized THEN BEGIN
            IF "Principal Repayment Method" = "Principal Repayment Method"::Annuity THEN BEGIN
        
        
            TotalMRepay:=ROUND((InterestRate/12/100) / (1 - POWER((1 + (InterestRate/12/100)),- RepayPeriod)) * LBalance,0.01,'>');
            LInterest:=ROUND(LBalance / 100 / 12 * InterestRate,0.05,'>');
            LPrincipal:=TotalMRepay-LInterest;
        
            IF (LBalance < TotalMRepay) THEN
            LPrincipal:=LBalance-LInterest;
        
            //7th Oct 2019 - Last Loan Principal Calculation
            IF (InstalNo = RepayPeriod) THEN
            LPrincipal := (LoanAmount-TotalPrincipal);
        
        
            EVALUATE(RepayCode,FORMAT(InstalNo));
        
            RSchedule.INIT;
            RSchedule."Repayment Code":=RepayCode;
            RSchedule."Loan No.":="Loan No.";
            RSchedule."Loan Amount":=LBalance;
            RSchedule."Installment No.":=InstalNo;
            RSchedule."Repayment Date":=RunDate;
            RSchedule."Client No.":="Client No.";
            RSchedule."Loan Product Type":="Loan Product Type";
            RSchedule."Interest Due":=LInterest;
            RSchedule."Principal Due":=LPrincipal;
            RSchedule."Total Due":=LInterest + LPrincipal;
            RSchedule."Client Name":="Client Name";
            RSchedule."Due Date":=CALCDATE('CM',RSchedule."Repayment Date");
            RSchedule.INSERT;
            //COMMIT;
            END;
        
            IF "Principal Repayment Method" = "Principal Repayment Method"::Bullet THEN BEGIN
              LInterest:=ROUND((InterestRate/12/100)  * (LoanAmount-TotalPrincipal),0.05,'>');
        
                EVALUATE(RepayCode,FORMAT(InstalNo));
        
                RSchedule.INIT;
                RSchedule."Repayment Code":=RepayCode;
                RSchedule."Loan No.":="Loan No.";
                RSchedule."Loan Amount":=(LoanAmount-TotalPrincipal);
                RSchedule."Installment No.":=InstalNo;
                RSchedule."Repayment Date":=RunDate;
                RSchedule."Client No.":="Client No.";
                RSchedule."Loan Product Type":="Loan Product Type";
              IF DATE2DMY(RunDate,2) = 1 THEN BEGIN
                IF RepayPeriod < 12 THEN
                LPrincipal:=ROUND(LoanAmount/1)
                ELSE
                LPrincipal:=ROUND(LoanAmount/ROUND(RepayPeriod/12,1,'='),0.05,'>')
        
              END ELSE
                LPrincipal:=0;
                RSchedule."Total Due":=LInterest+LPrincipal;
                RSchedule."Interest Due":=LInterest;
                RSchedule."Principal Due":=LPrincipal;
                RSchedule."Client Name":="Client Name";
                RSchedule."Due Date":=CALCDATE('CM',RSchedule."Repayment Date");
                RSchedule.INSERT;
                //COMMIT;
            END;
          END;
        
        
        LBalance:=LBalance-LPrincipal;
        
        
        TotalInterest := TotalInterest + LInterest;
        TotalPrincipal := TotalPrincipal + LPrincipal;
        UNTIL LBalance < 1
        END;
        Loans.Principal := TotalPrincipal;
        Loans.Interest := TotalInterest;
        Loans.MODIFY;
        END;*/

    end;

    procedure PostSingleLoan(Loan: Record "Loan Application")
    var
        EntryNo: Integer;
    begin
        if not Confirm('Are you sure you want to post the Loan?') then
          Error('');
        EntryNo:=0;
        EntryNo:=GetLastTransactionNo;
        Window.Open('Posting Loan No #1#######');
        Window.Update(1,Loan."Loan No.");
        EntryNo:=EntryNo+1;
        ValidateLoan(Loan);
        PostLoan(Loan,EntryNo);

        Window.Close;
        Message('Loan Posting Process Complete');
    end;

    procedure PostLoan(Loan: Record "Loan Application";EntryNo: Integer)
    var
        ClientTransactions: Record "Client Transactions";
    begin
        ClientTransactions.Init;
        ClientTransactions."Entry No":=EntryNo;
        ClientTransactions."Transaction Type":=ClientTransactions."Transaction Type"::Dividend;
        ClientTransactions."Value Date":=Loan."Loan Disbursement Date";
        ClientTransactions."Transaction Date":=Loan."Loan Disbursement Date";
        ClientTransactions.Validate("Account No",Loan."Account No");
        ClientTransactions.Validate("Client ID",Loan."Client No.");
        ClientTransactions."Fund Code":=Loan."Fund Code";
        ClientTransactions."Fund Sub Code":=Loan."Fund Sub Account";
        ClientTransactions.Narration:='Loan Disbursement '+Format(ClientTransactions."Transaction Sub Type")+'-'+Loan."Loan No.";
        ClientTransactions."Transaction Sub Type":=ClientTransactions."Transaction Sub Type"::"4";
        ClientTransactions."Transaction Sub Type 2":=ClientTransactions."Transaction Sub Type 2"::"Dividend Declared";
        ClientTransactions."Transaction Sub Type 3" :=ClientTransactions."Transaction Sub Type 3"::"Direct Debit - GAPS";
        ClientTransactions."Contribution Type" := ClientTransactions."Contribution Type"::Principal;
        ClientTransactions."Transaction No":=Loan."Loan No.";
        ClientTransactions.Amount:=Loan."Approved Amount";
        ClientTransactions."No of Units":=Loan."Approved Amount";
        ClientTransactions."Price Per Unit":=1;
        ClientTransactions."Created By":=UserId;
        ClientTransactions."Created Date Time":=CurrentDateTime;
        ClientTransactions."Transaction Source Document":=ClientTransactions."Transaction Source Document"::"7";
        if ClientTransactions.Amount<>0 then
        ClientTransactions.Insert(true);
        
        /*Loan.Posted:=TRUE;
        Loan."Posted By":=USERID;
        Loan."Date Posted":=TODAY;
        Loan."Time Posted":=TIME;
        Loan."Loan Status":=Loan."Loan Status"::Posted;
        Loan.Select:=FALSE;
        Loan."Selected By":='';
        Loan.MODIFY;
        MovetoPostedLoans(Loan);*/

    end;

    procedure ReverseLoan(Loan: Record "Loan Application")
    var
        ClientTransactions: Record "Client Transactions";
        ClientTransactions2: Record "Client Transactions";
        EntryNo: Integer;
    begin
        /*IF NOT CONFIRM('Are you sure you want to Reverse this Loan?') THEN
          ERROR('');
        IF Loan.Reversed=TRUE THEN
          ERROR('This Loan has already been reversed');
        IF Loan."Value Date"<>TODAY THEN
          ERROR('Only same day reversals is allowed');
        EntryNo:=0;
        EntryNo:=GetLastTransactionNo;
        ClientTransactions.RESET;
        ClientTransactions.SETRANGE("Transaction No",Loan.No);
        ClientTransactions.SETRANGE("Transaction Type",ClientTransactions."Transaction Type"::Loan);
        ClientTransactions.SETRANGE(Reversed,FALSE);
        IF ClientTransactions.FINDFIRST THEN
          REPEAT
            EntryNo:=EntryNo+1;
            ClientTransactions2.INIT;
            ClientTransactions2.COPY(ClientTransactions);
            ClientTransactions2."Entry No":=EntryNo;
            ClientTransactions2.Amount:=-ClientTransactions.Amount;
            ClientTransactions2."Transaction Type":=ClientTransactions2."Transaction Type"::Redemption;
            ClientTransactions2."No of Units":=-ClientTransactions."No of Units";
            ClientTransactions2."Reversed Entry No":=ClientTransactions."Entry No";
            ClientTransactions2.Narration:='Reversal of Loan no - '+ClientTransactions."Transaction No";
            ClientTransactions2.INSERT(TRUE);
        
            ClientTransactions.Reversed:=TRUE;
            ClientTransactions."Reversed By Entry No":=EntryNo;
            ClientTransactions.MODIFY(TRUE);
          UNTIL ClientTransactions.NEXT=0;
        Loan.Reversed:=TRUE;
        Loan."Reversed By":=USERID;
        Loan."Date Time reversed":=CURRENTDATETIME;
        Loan.MODIFY;
        MESSAGE('Loan Reversed Completely');
        */

    end;

    procedure GetLastTransactionNo(): Integer
    var
        ClientTransactions: Record "Client Transactions";
    begin
        if ClientTransactions.FindLast then
        exit(ClientTransactions."Entry No");
    end;

    procedure ValidateLoan(var Loan: Record "Loan Application")
    begin
        with Loan do begin
          //TESTFIELD(Status,Loan.Status::Approved);
          TestField("Approved Amount");
          if Status = Status::Approved then
          TestField("Loan Disbursement Date");
          if "Interest Repayment Frequency" <> "Interest Repayment Frequency"::None then begin
          TestField("Loan Period (in Months)");
          TestField("Interest Rate");
          end;
          TestField("Loan Product Type");
          TestField("Client No.");
          TestField("Application Date");


        end;
    end;

    procedure CalculateLoanInterest(var LoanAmount: Decimal;var InterestRate: Decimal;var RepayPeriod: Integer;var StartDate: Date;var LoanType: Option Annuity,Bullet,"Zero Interest") TotalInterest: Decimal
    var
        LBalance: Decimal;
        RepayDate: Date;
        InstalNo: Integer;
        RepayInterval: DateFormula;
        InitialInstal: Integer;
        TotalMRepay: Decimal;
        LInterest: Decimal;
        LPrincipal: Decimal;
        TotalPrincipal: Decimal;
    begin
        TotalInterest := 0;
        LBalance:=LoanAmount;

        RepayDate:=CalcDate('-1M',StartDate);
        repeat
            RepayDate:=CalcDate('1M',RepayDate);
            if LoanType = LoanType::Annuity then begin
            TotalMRepay:=Round((InterestRate/12/100) / (1 - Power((1 + (InterestRate/12/100)),- RepayPeriod)) * LoanAmount,0.01,'>');
            LInterest:=Round(LBalance / 100 / 12 * InterestRate,0.01,'>');
            LPrincipal:=TotalMRepay-LInterest;

            if LBalance < TotalMRepay then
            LPrincipal:=LBalance-LInterest;
            end;

            if LoanType = LoanType::Bullet then begin
              LInterest:=Round((InterestRate/12/100)  * (LoanAmount-TotalPrincipal),0.05,'>');
              if Date2DMY(RepayDate,2) = 1 then
                LPrincipal:=Round(LoanAmount/Round(RepayPeriod/12,1,'='),0.05,'>')
              else
                LPrincipal:=0;
            end;

        LBalance:=LBalance-LPrincipal;
        TotalInterest := TotalInterest + LInterest;
        TotalPrincipal := TotalPrincipal + LPrincipal;
        until (LBalance < 1) or (LBalance = LInterest);
    end;

    procedure GetNextLoanRepaymentDate(var LoanNo: Code[20]) NextRepaymentDate: Date
    var
        Repayments: Record "Loan Repayment Schedule";
    begin
        Repayments.Reset;
        Repayments.SetRange("Loan No.",LoanNo);
        Repayments.SetRange(Settled,false);
        if Repayments.FindFirst then
          NextRepaymentDate := Repayments."Repayment Date";
    end;

    procedure VariationSchedule(var RepaySchedule: Record "Loan Variation")
    var
        QCounter: Integer;
        InPeriod: DateFormula;
        LoanAmount: Decimal;
        RepayPeriod: Integer;
        LBalance: Decimal;
        RunDate: Date;
        InstalNo: Integer;
        RepayInterval: DateFormula;
        InterestRate: Decimal;
        InitialInstal: Integer;
        TotalMRepay: Decimal;
        LInterest: Decimal;
        LPrincipal: Decimal;
        RepayCode: Code[10];
        CumulativePrincipal: Decimal;
        PreviousCumulativePrincipal: Decimal;
        TotalInterest: Decimal;
        TotalPrincipal: Decimal;
    begin
        with RepaySchedule do begin
          if "Type of Variation" = "Type of Variation"::Terminate then
            exit;

        if "New Loan Type" = "New Loan Type"::"Zero Interest" then
          Error(Text000);

        TotalInterest := 0;

        LoanVar.Reset;
        LoanVar.SetRange("No.","No.");
        if LoanVar.Find('-') then begin
          if LoanVar.Status=LoanVar.Status::Approved then
          TestField("New Loan Start Date");

          VSchedule.Reset;
          VSchedule.SetRange(VSchedule."Loan No.","New Loan No.");
          VSchedule.DeleteAll;

          LoanAmount:=LoanVar."New Principal";
          InterestRate:=LoanVar."New Interest Rate";

          RepayPeriod:=LoanVar."New Tenure(Months)";
          LBalance:=LoanVar."New Principal";

          RunDate := "New Loan Start Date";

          RunDate:=CalcDate('-1M',RunDate);

          InstalNo:=0;
          Evaluate(RepayInterval,'1M');


        repeat
          InstalNo:=InstalNo+1;

          RunDate:=CalcDate('1M',RunDate);

            if "New Loan Type" = "New Loan Type"::Annuitized then begin
            TotalMRepay:=Round((InterestRate/12/100) / (1 - Power((1 + (InterestRate/12/100)),- RepayPeriod)) * LoanAmount,0.01,'>');
            LInterest:=Round(LBalance / 100 / 12 * InterestRate,0.01,'>');
            LPrincipal:=TotalMRepay-LInterest;

            if LBalance < TotalMRepay then
            LPrincipal:=LBalance-LInterest;

            Evaluate(RepayCode,Format(InstalNo));

            VSchedule.Init;
            VSchedule."Repayment Code":=RepayCode;
            VSchedule."Loan No.":="New Loan No.";
            //VSchedule."Loan Amount":=LoanAmount;
            VSchedule."Loan Amount":=LBalance;
            VSchedule."Installment No.":=InstalNo;
            VSchedule."Repayment Date":=RunDate;
            VSchedule."Client No.":="Client No.";
            if LoanApp.Get("Old Loan No.") then
            VSchedule."Loan Product Type":=LoanApp."Loan Product Type";
            VSchedule.Interest:=LInterest;
            VSchedule.Principal:=LPrincipal;
            VSchedule.Total:=LInterest + LPrincipal;
            VSchedule."Client Name":="Client Name";
            VSchedule."Due Date":=CalcDate('CM',VSchedule."Repayment Date");
            VSchedule.Insert;
            Commit;
            end;

            if "New Loan Type" = "New Loan Type"::Bullet then begin
              LInterest:=Round((InterestRate/12/100)  * (LoanAmount-TotalPrincipal),0.05,'>');

                Evaluate(RepayCode,Format(InstalNo));

                VSchedule.Init;
                VSchedule."Repayment Code":=RepayCode;
                VSchedule."Loan No.":="New Loan No.";
                VSchedule."Loan Amount":=(LoanAmount-TotalPrincipal);
                VSchedule."Installment No.":=InstalNo;
                VSchedule."Repayment Date":=RunDate;
                VSchedule."Client No.":="Client No.";
                if LoanApp.Get("Old Loan No.") then
                VSchedule."Loan Product Type":=LoanApp."Loan Product Type";
              if Date2DMY(RunDate,2) = 1 then
                LPrincipal:=Round(LoanAmount/(Round("New Tenure(Months)"/12,1)),0.05,'>')
              else
                LPrincipal:=0;
                VSchedule.Total:=LInterest+LPrincipal;
                VSchedule.Interest:=LInterest;
                VSchedule.Principal:=LPrincipal;
                VSchedule."Client Name":="Client Name";
                VSchedule."Due Date":=CalcDate('CM',VSchedule."Repayment Date");
                VSchedule.Insert;
                Commit;
            end;

        LBalance:=LBalance-LPrincipal;
        TotalInterest := TotalInterest + LInterest;
        TotalPrincipal := TotalPrincipal + LPrincipal;
        until (LBalance < 1) or (LBalance = LInterest)
        end;
        //LoanVar.Principal := TotalPrincipal;
        LoanVar."New Interest" := TotalInterest;
        LoanVar.Modify;
        end;
    end;

    procedure ApplyLoanVariation(var Variation: Record "Loan Variation")
    begin
        with Variation do begin
          if Status <> Status::Approved then
            exit;

          //Create New Loan
          LoanApp.Reset;
          LoanApp.SetRange("Loan No.","Old Loan No.");
          if LoanApp.FindFirst then begin
            if "Type of Variation" = "Type of Variation"::Terminate then begin
              PostLoanLiquidation(Variation);
              CreateInvestmentRedemptionForRemainingInvestmentBalance(Variation);
            end else begin
            "New Loan No." := CreateNewLoan(LoanApp,"New Principal","New Interest Rate","New Tenure(Months)","New Loan Start Date","New Loan Type");
            Modify;
            end;
            //
            //Settle Old Loan
            SettleOldLoanByVariation(LoanApp,"No.",Date);
            //
            LoanApp.Status := LoanApp.Status::"Fully Repaid";
            LoanApp.Modify(true);

           // UpdateLoanStatus(LoanApp);
           end else
            Error('The old loan %1 cannot be found.',"Old Loan No.");

            Status := Status::Effected;
            Modify(true);

            ArchiveEffectedLoanVariation(Variation);
        end;
    end;

    local procedure CreateNewLoan(var OldLoan: Record "Loan Application";var LoanAmount: Decimal;var InterestRate: Decimal;var RepayPeriod: Integer;var StartDate: Date;var LoanType: Option Annuity,Bullet,"Zero Interest") NewLoanNo: Code[20]
    var
        NewLoan: Record "Loan Application";
    begin
        with OldLoan do begin
          NewLoan.Init;
          NewLoan.TransferFields(OldLoan,false);
          NewLoan.Insert(true);
          Product.Reset;
          Product.SetRange("Loan Type",LoanType);
          //Product.SETRANGE(Fund,"Fund Code");
          if Product.FindLast then
          NewLoan.Validate("Loan Product Type",Product.Code);
          NewLoan."Requested Amount" := LoanAmount;
          NewLoan."Approved Amount" := LoanAmount;
          NewLoan."Application Date" := Today;
          NewLoan."Interest Rate" := InterestRate;
          NewLoan."Loan Period (in Months)" := RepayPeriod;
          NewLoan.Validate("Loan Period (in Months)");
          NewLoan."Repayment Start Date" := StartDate;
          NewLoan."Loan Source" := NewLoan."Loan Source"::Variation;
          NewLoan."Source Loan" := OldLoan."Loan No.";
          NewLoan."Sent For Valuation" := false;
          NewLoan.Status := NewLoan.Status::Approved;
          NewLoan.Modify;
          NewLoanNo := NewLoan."Loan No.";
          //Prepare Loan Schedule
          RepaymentSchedule(NewLoan);

        end;
    end;

    local procedure SettleOldLoanByVariation(var OldLoan: Record "Loan Application";var VariationNo: Code[20];var VariationDate: Date)
    begin
        with OldLoan do begin
          RSchedule.Reset;
          RSchedule.SetRange("Loan No.","Loan No.");
          RSchedule.SetRange(Settled,false);
          if RSchedule.FindSet then begin repeat
            RSchedule."Settlement Date" := VariationDate;
            RSchedule."Settlement No." := VariationNo;
            RSchedule."Repayment Line No." := 1000;
            RSchedule."Settlement Method" := RSchedule."Settlement Method"::Variation;
            RSchedule."Principal Settlement" := RSchedule."Principal Due";
            RSchedule."Interest Settlement" := RSchedule."Interest Due";
            RSchedule."Total Settlement" := RSchedule."Total Due";
            RSchedule.Validate(Settled,true);
            RSchedule."Fully Paid" := true;
            RSchedule.Modify(true);
          until RSchedule.Next = 0;
          end;
        end;
    end;

    procedure UpdateLoanStatus(var Loans: Record "Loan Application")
    var
        NonPermingingThreshold: Date;
    begin
        with Loans do begin
          CalcFields("Total Amount Repaid",Loans."Total Amount Outstanding");
          if ("Total Amount Repaid" > 0) and ("Total Amount Outstanding" > 0) then begin
            //Get Non Performing Loans
            LoanMgtSetup.Get;
            LoanMgtSetup.TestField("Non-Performing Loan Months");
            NonPermingingThreshold := CalcDate('-'+Format(LoanMgtSetup."Non-Performing Loan Months"),Today);
            if "Repayment Start Date" < NonPermingingThreshold then begin
            LoanApp.Get("Loan No.");
            LoanApp.SetFilter("Date Filter",'%1..%2',NonPermingingThreshold,Today);
            LoanApp.CalcFields("Total Amount Repaid");
            if LoanApp."Total Amount Repaid" = 0 then
              Status := Status::"Non-Performing";
            end else
            //Partially Repaid Loans
            Status := Status::"Partially Repaid";
            //
          end
          //Fully Repaid Loans
          else if ("Total Amount Repaid" > 0) and (("Total Amount Outstanding" = 0) or ("Total Amount Outstanding" < 0)) then
            Status := Status::"Fully Repaid"
          else if ("Total Amount Repaid" = 0) and ("Total Amount Outstanding" > 0) and Disbursed then
            Status := Status::Approved;
          //Frozen Loans
          if "On Repayment Holiday" then
            Status := Status::"On Repayment Holiday";
          Modify;
          ArchiveFullyRepaidLoan(Loans);
        end
    end;

    [IntegrationEvent(false, false)]
    procedure OnAfterUpdateLoanStatus(var Loans: Record "Loan Application")
    begin
    end;

    procedure ArchiveFullyRepaidLoan(var Loans: Record "Loan Application")
    begin
        if Loans.Status = Loans.Status::"Fully Repaid" then begin
          //Schedule
          RSchedule.Reset;
          RSchedule.SetRange("Loan No.",Loans."Loan No.");
          if RSchedule.FindSet then begin repeat
            HistoricalSchedule.Init;
            HistoricalSchedule.TransferFields(RSchedule);
            HistoricalSchedule.Insert;
          until RSchedule.Next = 0;
          end;
          RSchedule2.Reset;
          RSchedule2.SetRange("Loan No.",Loans."Loan No.");
          if RSchedule2.FindSet then
            RSchedule2.DeleteAll;

          //Loan
          HistoricalLoans.Init;
          HistoricalLoans.TransferFields(Loans);
          HistoricalLoans.Insert;
          if LoanApp.Get(Loans."Loan No.")then
            LoanApp.Delete;
        end else
        exit;
    end;

    procedure ArchiveEffectedLoanVariation(var Variation: Record "Loan Variation")
    begin
        if Variation.Status = Variation.Status::Effected then begin
          HistoricalVariation.Init;
          HistoricalVariation.TransferFields(Variation);
          HistoricalVariation.Insert;
          if LoanVar.Get(Variation."No.")then
            LoanVar.Delete;
        end else
        exit;
    end;

    procedure CreateInvestmentRedemptionForRemainingInvestmentBalance(var Variation: Record "Loan Variation")
    var
        Redemptions: Record Redemption;
    begin
        with Variation do begin

          TestField("Account No.");
          TestField("Fund Code");
          TestField("Balance After Loan");
          if "Balance After Loan" > 0 then begin

          Redemptions.Init;
          Redemptions.Insert(true);
          Redemptions.Validate("Account No","Account No.");
          Redemptions.Remarks := 'Redemption';
          Redemptions."Transaction Name" := 'Redemption';
          Redemptions.Validate(Amount,"Balance After Loan");
          Redemptions."Redemption Status" := Redemptions."Redemption Status"::Verified;
          Redemptions.Modify;

          Message('Ordinary Redemption No. '+Redemptions."Transaction No"+' has been created.');
          end;
        end;
    end;

    procedure CreateLoanVariationDirectly()
    begin
         Message('You are about to do a Loan Variation, kindly pick the desired option.');
          Selection := StrMenu(CreatingText,1);
          LoanMgtSetup.Get;
          LoanVar.Init;
          if Selection = 1 then begin//Top-Up
              if LoanMgtSetup."Last Loan Top-up No." <> '' then
              begin
              Evaluate(counters, ConvertStr(LoanMgtSetup."Last Loan Top-up No.",'TOP-','0000'))
              end;
              counters:= counters+1;
              reccode:= (PadStr('', 15 - StrLen(Format(counters)), '0') + Format(counters));
              LoanVar."No.":= 'TOP-' + reccode;
              LoanMgtSetup.ModifyAll("Last Loan Top-up No.",'TOP-' + reccode);
              LoanVar."Type of Variation" := LoanVar."Type of Variation"::"Top Up";
          end else
          if Selection = 2 then begin//Termination
              if LoanMgtSetup."Last Loan Termination No." <> '' then
              begin
              Evaluate(counters, ConvertStr(LoanMgtSetup."Last Loan Termination No.",'TMN-','0000'))
              end;
              counters:= counters+1;
              reccode:= (PadStr('', 15 - StrLen(Format(counters)), '0') + Format(counters));
              LoanVar."No.":= 'TMN-' + reccode;
              LoanMgtSetup.ModifyAll("Last Loan Termination No.",'TMN-' + reccode);
              LoanVar."Type of Variation" := LoanVar."Type of Variation"::Terminate;
          end else
          if Selection = 3 then begin//Change of Tenure
              if LoanMgtSetup."Last Change of Tenure No." <> '' then
              begin
              Evaluate(counters, ConvertStr(LoanMgtSetup."Last Change of Tenure No.",'TNR-','0000'))
              end;
              counters:= counters+1;
              reccode:= (PadStr('', 15 - StrLen(Format(counters)), '0') + Format(counters));
              LoanVar."No.":= 'TNR-' + reccode;
              LoanMgtSetup.ModifyAll("Last Change of Tenure No.",'TNR-' + reccode);
              LoanVar."Type of Variation" := LoanVar."Type of Variation"::"Change of Tenure";
          end else
          if Selection = 4 then begin//Conversion to Other Loan Type
              if LoanMgtSetup."Last Loan Conversion No." <> '' then
              begin
              Evaluate(counters, ConvertStr(LoanMgtSetup."Last Loan Conversion No.",'CNV-','0000'))
              end;
              counters:= counters+1;
              reccode:= (PadStr('', 15 - StrLen(Format(counters)), '0') + Format(counters));
              LoanVar."No.":= 'CNV-' + reccode;
              LoanMgtSetup.ModifyAll("Last Loan Conversion No.",'CNV-' + reccode);
              LoanVar."Type of Variation" := LoanVar."Type of Variation"::"Loan Conversion";
          end;

        LoanVar."Created By" := UserId;
        LoanVar.Date := Today;
        if LoanVar.Insert then
        PAGE.Run(50206,LoanVar);
    end;

    procedure CreateLoanVariationFromLoanCard(var Loan: Record "Loan Application")
    begin
        with Loan do begin
         Message('You are about to do a Loan Variation, kindly pick the desired option.');
          Selection := StrMenu(CreatingText,1);
          LoanMgtSetup.Get;
          LoanVar.Init;
          if Selection = 1 then begin//Top-Up
              if LoanMgtSetup."Last Loan Top-up No." <> '' then
              begin
              Evaluate(counters, ConvertStr(LoanMgtSetup."Last Loan Top-up No.",'TOP-','0000'))
              end;
              counters:= counters+1;
              reccode:= (PadStr('', 15 - StrLen(Format(counters)), '0') + Format(counters));
              LoanVar."No.":= 'TOP-' + reccode;
              LoanMgtSetup.ModifyAll("Last Loan Top-up No.",'TOP-' + reccode);
              LoanVar."Type of Variation" := LoanVar."Type of Variation"::"Top Up";
          end else
          if Selection = 2 then begin//Termination
              if LoanMgtSetup."Last Loan Termination No." <> '' then
              begin
              Evaluate(counters, ConvertStr(LoanMgtSetup."Last Loan Termination No.",'TMN-','0000'))
              end;
              counters:= counters+1;
              reccode:= (PadStr('', 15 - StrLen(Format(counters)), '0') + Format(counters));
              LoanVar."No.":= 'TMN-' + reccode;
              LoanMgtSetup.ModifyAll("Last Loan Termination No.",'TMN-' + reccode);
              LoanVar."Type of Variation" := LoanVar."Type of Variation"::Terminate;
          end else
          if Selection = 3 then begin//Change of Tenure
              if LoanMgtSetup."Last Change of Tenure No." <> '' then
              begin
              Evaluate(counters, ConvertStr(LoanMgtSetup."Last Change of Tenure No.",'TNR-','0000'))
              end;
              counters:= counters+1;
              reccode:= (PadStr('', 15 - StrLen(Format(counters)), '0') + Format(counters));
              LoanVar."No.":= 'TNR-' + reccode;
              LoanMgtSetup.ModifyAll("Last Change of Tenure No.",'TNR-' + reccode);
              LoanVar."Type of Variation" := LoanVar."Type of Variation"::"Change of Tenure";
          end else
          if Selection = 4 then begin//Conversion to Other Loan Type
              if LoanMgtSetup."Last Loan Conversion No." <> '' then
              begin
              Evaluate(counters, ConvertStr(LoanMgtSetup."Last Loan Conversion No.",'CNV-','0000'))
              end;
              counters:= counters+1;
              reccode:= (PadStr('', 15 - StrLen(Format(counters)), '0') + Format(counters));
              LoanVar."No.":= 'CNV-' + reccode;
              LoanMgtSetup.ModifyAll("Last Loan Conversion No.",'CNV-' + reccode);
              LoanVar."Type of Variation" := LoanVar."Type of Variation"::"Loan Conversion";
          end;

        LoanVar."Created By" := UserId;
        LoanVar.Date := Today;
        LoanVar.Validate("Account No.","Account No");
        LoanVar.Validate("Staff ID","Staff ID");
        LoanVar.Validate("Old Loan No.","Loan No.");
        if LoanVar.Insert then
        PAGE.Run(50206,LoanVar);
        end;
    end;

    procedure FreezeLoan(var Loan: Record "Loan Application")
    begin
        with Loan do begin
          Validate("On Repayment Holiday",true);
          "Placed On Holiday By" := UserId;
          "Date Placed On Holiday" := CurrentDateTime;
          UpdateLoanStatus(Loan);
        end;
    end;

    procedure UnFreezeLoan(var Loan: Record "Loan Application")
    begin
        with Loan do begin
          Validate("On Repayment Holiday",false);
          "Reactivated From Holiday By" := UserId;
          "Date Reactivated From Holiday" := CurrentDateTime;
          UpdateLoanStatus(Loan);
        end;
    end;

    procedure GetClientNoFromStaffID(var StaffID: Code[20]) ClientNo: Code[20]
    begin
        ClientAccounts.Reset;
        ClientAccounts.SetRange("Staff ID",StaffID);
        if ClientAccounts.FindFirst then
          ClientNo := ClientAccounts."Client ID"
        else
          ClientNo := '';
    end;

    procedure PostLoanLiquidation(Variation: Record "Loan Variation")
    var
        EntryNo: Integer;
        RedemptionScheduleLines: Record "Redemption Schedule Lines";
    begin
        if not Confirm('Are you sure you want to recover this Loan from Investment Balance?') then
          Error('');
        EntryNo:=0;
        EntryNo:=TransactionMgt.GetLastTransactionNo;

        EntryNo:=EntryNo+1;
        PostLiquidation(Variation,EntryNo);
    end;

    procedure PostLiquidation(Variation: Record "Loan Variation";EntryNo: Integer)
    var
        ClientTransactions: Record "Client Transactions";
    begin
        //FundAdministration.InsertRedemptionTracker(5,Variation."Transaction No");
        ClientTransactions.Init;
        ClientTransactions."Entry No":=EntryNo;
        ClientTransactions."Transaction Type":=ClientTransactions."Transaction Type"::Redemption;
        ClientTransactions."Value Date":=Variation.Date;
        ClientTransactions."Transaction Date":=Today;
        ClientTransactions.Validate("Account No",Variation."Account No.");
        ClientTransactions.Validate("Client ID",Variation."Client No.");
        ClientTransactions."Fund Code":=Variation."Fund Code";
        //ClientTransactions."Fund Sub Code":=Variation.fun;
        ClientTransactions.Narration:='Loan Liquidation - '+Variation."Old Loan No.";
        if TransactionMgt.CheckinitialRedemptionExist(ClientTransactions."Account No") then
          ClientTransactions."Transaction Sub Type":=ClientTransactions."Transaction Sub Type"::additional
        else
          ClientTransactions."Transaction Sub Type":=ClientTransactions."Transaction Sub Type"::Initial;
        ClientTransactions."Transaction Sub Type":=ClientTransactions."Transaction Sub Type"::"Part Redemption";
        ClientTransactions."Transaction Sub Type 2":=ClientTransactions."Transaction Sub Type 2"::"Ordinary Redemption";
        ClientTransactions."Transaction Sub Type 3" :=ClientTransactions."Transaction Sub Type 3"::"Direct Debit - GAPS";
        ClientTransactions."Transaction No":=Variation."No.";
        ClientTransactions.Amount:=-Abs(Variation."Total Outstanding Loan");
        Variation.ValidateAmount;
        ClientTransactions."No of Units":=-Abs(Variation."No. of Units");
        ClientTransactions."Price Per Unit":=Variation."Price Per Unit";
        ClientTransactions."Agent Code":=Variation."Agent Code";
        ClientTransactions."Created By":=UserId;
        ClientTransactions."Created Date Time":=CurrentDateTime;
        ClientTransactions."Transaction Source Document":=ClientTransactions."Transaction Source Document"::"7";
        if ClientTransactions.Amount<>0 then
        ClientTransactions.Insert(true);

        Variation.Status:=Variation.Status::Effected;
        Variation."Treated By":=UserId;
        Variation."Treated DateTime":=CurrentDateTime;
        Variation.Modify(true);
    end;

    procedure SuggestLoanRepaymentSchedule(var Header: Record "Loan Repayment Header")
    var
        Lines: Record "Loan Repayment Lines";
    begin
        with Header do begin
          TestField(Month);
          if Confirm('Do you want to suggest the expected repayments for '+Month+' ?',false) = true then begin
            //Clear Lines
            Lines.Reset;
            Lines.SetRange("Header No",Code);
            Lines.DeleteAll;
            //
            Window.Open('Suggesting Expected Repayments  for #####1',Names);
            TestField("Date and Time");
            StartDate := DT2Date("Date and Time");
            StartDate := DMY2Date(1,Date2DMY(StartDate,2),Date2DMY(StartDate,3));
            EndDate := CalcDate('CM',StartDate);

            LineNo := 10000;
            RSchedule.Reset;
            RSchedule.SetRange("Repayment Date",StartDate,EndDate);
            RSchedule.SetRange(RSchedule."Entry Type",RSchedule."Entry Type"::Scheduled);
            RSchedule.SetRange(Settled,false);
            if RSchedule.FindSet then begin repeat
              Lines.Init;
              Lines."Header No" := Code;
              Lines."Line No." := LineNo;
              Lines.Date := DT2Date("Date and Time");
              Lines.Received := true;
              if Loans.Get(RSchedule."Loan No.") then begin
                Lines."Pers. No." := Loans."Staff ID";
                Lines."Last Name and First Name" := Loans."Client Name";
                Lines."DB Name" := Loans."Client Name";
                Lines."Applies To Loan" := Loans."Loan No.";
                Lines."Principal Amount Due" := RSchedule."Principal Due";
                Lines."Interest Amount Due" := RSchedule."Interest Due";
                Lines."Loan No." :=  RSchedule."Loan No.";
                Lines."Sheduled Repayment Date" := RSchedule."Repayment Date";
              end;
              Lines."Total Payment" := RSchedule."Total Due";
              Lines.Validate("Total Payment");
              Lines.Insert;
              Window.Update(1,RSchedule."Client Name");
              LineNo := LineNo+1;
            until RSchedule.Next = 0;
            end;
            Window.Close;
          end;
        end;
    end;

    procedure GetLoanValuation(LoanNum: Code[50]): Decimal
    var
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
        CurrentLoanValuation: Decimal;
        LoanApp: Record "Loan Application";
    begin
        Schedule.Reset;
        Schedule.SetRange("Loan No.",LoanNum);
        Schedule.SetRange(Settled,false);
        if Schedule.FindFirst then begin
          FirstUnsettledAmount:=Schedule."Loan Amount";
          InterestPerDay := Round((Schedule."Interest Due"/31),0.01,'=');
        end;

        //MAXWELL: 26/08/2019 - Dynamically Get Loan Due Date
        Schedule.Reset;
        Schedule.SetRange("Loan No.",LoanNum);
        Schedule.SetRange(Settled,true);
        if Schedule.FindLast then
          LoanDueDate := Schedule."Repayment Date"
        else begin
          LoanApp.Reset;
          LoanApp.SetRange("Loan No.",LoanNum);
          if LoanApp.FindFirst then
            LoanDueDate := LoanApp."Application Date"; //LoanApp."Repayment Start Date";
        end;
        //

        //InterestPerDay := ROUND((Schedule."Interest Due"/31),0.01,'=');
        DueDuration := Today - LoanDueDate;

        DueDurationAmount := DueDuration * InterestPerDay;


        Loans.Get(LoanNum);
        LoanProduct.Reset;
        LoanProduct.SetRange(Code,Loans."Loan Product Type");
        if LoanProduct.FindFirst then begin
          if LoanProduct."Loan Type" = LoanProduct."Loan Type"::Bullet then begin

            LoanValuation := FirstUnsettledAmount + DueDurationAmount;
            exit(LoanValuation);
          end else begin
             LoanValuation := (FirstUnsettledAmount*(Loans."Interest Rate"/100)*(DueDuration/365)) + FirstUnsettledAmount;
            exit(LoanValuation);
          end;
        end;
    end;

    procedure GetPreviousRepaymentDate(var LoanNo: Code[20];var RefDate: Date) LastDate: Date
    begin
          RSchedule.Reset;
          RSchedule.SetRange(RSchedule."Loan No.",LoanNo);
          RSchedule.SetRange(RSchedule."Entry Type",RSchedule."Entry Type"::Scheduled);
          RSchedule.SetRange("Repayment Date",0D,RefDate);
          if RSchedule.FindLast then
            LastDate:=RSchedule."Repayment Date";
    end;

    procedure RefreshRepaymentSchedule(var RepaySchedule: Record "Loan Application")
    var
        QCounter: Integer;
        InPeriod: DateFormula;
        LoanAmount: Decimal;
        RepayPeriod: Integer;
        LBalance: Decimal;
        RunDate: Date;
        InstalNo: Integer;
        RepayInterval: DateFormula;
        InterestRate: Decimal;
        InitialInstal: Integer;
        TotalMRepay: Decimal;
        LInterest: Decimal;
        LPrincipal: Decimal;
        RepayCode: Code[10];
        CumulativePrincipal: Decimal;
        PreviousCumulativePrincipal: Decimal;
        TotalInterest: Decimal;
        TotalPrincipal: Decimal;
    begin
        with RepaySchedule do begin
        if "Interest Repayment Frequency" = "Interest Repayment Frequency"::None then
          Error(Text000);

        TotalInterest := 0;

        Loans.Reset;
        Loans.SetRange(Loans."Loan No.","Loan No.");
        if Loans.Find('-') then begin
          if Loans.Status=Loans.Status::Approved then
          TestField("Loan Disbursement Date");
          TestField("Repayment Start Date");

          RSchedule.Reset;
          RSchedule.SetRange(RSchedule."Loan No.","Loan No.");
          RSchedule.SetRange(RSchedule."Entry Type",RSchedule."Entry Type"::"Off-Schedule");
          if RSchedule.FindFirst then
            exit;


          RSchedule.Reset;
          RSchedule.SetRange(RSchedule."Loan No.","Loan No.");
          RSchedule.SetRange(RSchedule."Entry Type",RSchedule."Entry Type"::Scheduled);
          RSchedule.SetRange(RSchedule.Settled,false);
          RSchedule.DeleteAll;

          LoanAmount:=Loans."Approved Amount";
          InterestRate:=Loans."Interest Rate";

          RepayPeriod:=Loans."Loan Period (in Months)";
          LBalance:=Loans."Approved Amount";
          RunDate := "Repayment Start Date";

          if "Interest Repayment Frequency" = "Interest Repayment Frequency"::Annually then
          RunDate:=CalcDate('-1Y',RunDate);
          if "Interest Repayment Frequency" = "Interest Repayment Frequency"::Monthly then
          RunDate:=CalcDate('-1M',RunDate);
          if "Interest Repayment Frequency" = "Interest Repayment Frequency"::Quarterly then
          RunDate:=CalcDate('-1Q',RunDate);
          if "Interest Repayment Frequency" = "Interest Repayment Frequency"::"Semi-Annually" then
          RunDate:=CalcDate('-6M',RunDate);

          InstalNo:=0;
          if "Interest Repayment Frequency" = "Interest Repayment Frequency"::Annually then
          Evaluate(RepayInterval,'1Y');
          if "Interest Repayment Frequency" = "Interest Repayment Frequency"::Monthly then
          Evaluate(RepayInterval,'1M');
          if "Interest Repayment Frequency" = "Interest Repayment Frequency"::Quarterly then
          Evaluate(RepayInterval,'1Q');
          if "Interest Repayment Frequency" = "Interest Repayment Frequency"::"Semi-Annually" then
          Evaluate(RepayInterval,'6M');

        repeat
        InstalNo:=InstalNo+1;
          if "Interest Repayment Frequency" = "Interest Repayment Frequency"::Annually then
          RunDate:=CalcDate('1Y',RunDate);
          if "Interest Repayment Frequency" = "Interest Repayment Frequency"::Monthly then
          RunDate:=CalcDate('1M',RunDate);
          if "Interest Repayment Frequency" = "Interest Repayment Frequency"::Quarterly then
          RunDate:=CalcDate('1Q',RunDate);
          if "Interest Repayment Frequency" = "Interest Repayment Frequency"::"Semi-Annually" then
          RunDate:=CalcDate('6M',RunDate);


          if "Repayment Method"="Repayment Method"::Amortized then begin
            if "Principal Repayment Method" = "Principal Repayment Method"::Annuity then begin
            TotalMRepay:=Round((InterestRate/12/100) / (1 - Power((1 + (InterestRate/12/100)),- RepayPeriod)) * LoanAmount,0.01,'>');
            LInterest:=Round(LBalance / 100 / 12 * InterestRate,0.01,'>');
            LPrincipal:=TotalMRepay-LInterest;

            if (LBalance < TotalMRepay) then
            LPrincipal:=LBalance-LInterest;

            //7th Oct 2019 - Last Loan Principal Calculation
            if (InstalNo = RepayPeriod) then
            LPrincipal := (LoanAmount-TotalPrincipal);
            //
            Evaluate(RepayCode,Format(InstalNo));

            RSchedule.Init;
            RSchedule."Repayment Code":=RepayCode;
            RSchedule."Loan No.":="Loan No.";
            RSchedule."Loan Amount":=LBalance;
            RSchedule."Installment No.":=InstalNo;
            RSchedule."Repayment Date":=RunDate;
            RSchedule."Client No.":="Client No.";
            RSchedule."Loan Product Type":="Loan Product Type";
            RSchedule."Interest Due":=LInterest;
            RSchedule."Principal Due":=LPrincipal;
            RSchedule."Total Due":=LInterest + LPrincipal;
            RSchedule."Client Name":="Client Name";
            RSchedule."Due Date":=CalcDate('CM',RSchedule."Repayment Date");
            if not RSchedule2.Get("Loan No.","Client No.",RunDate,RSchedule."Entry Type") then
            RSchedule.Insert
            else begin
            RSchedule2."Repayment Code":=RepayCode;
            RSchedule2."Loan Amount":=LBalance;
            RSchedule2."Installment No.":=InstalNo;
            RSchedule2."Loan Product Type":="Loan Product Type";
            RSchedule2."Interest Due":=LInterest;
            RSchedule2."Principal Due":=LPrincipal;
            RSchedule2."Total Due":=LInterest + LPrincipal;
            RSchedule2."Client Name":="Client Name";
            RSchedule2."Due Date":=CalcDate('CM',RSchedule2."Repayment Date");
            RSchedule2.Modify;
            end;
            end;

            if "Principal Repayment Method" = "Principal Repayment Method"::Bullet then begin
              LInterest:=Round((InterestRate/12/100)  * (LoanAmount-TotalPrincipal),0.05,'>');

                Evaluate(RepayCode,Format(InstalNo));

                RSchedule.Init;
                RSchedule."Repayment Code":=RepayCode;
                RSchedule."Loan No.":="Loan No.";
                RSchedule."Loan Amount":=(LoanAmount-TotalPrincipal);
                RSchedule."Installment No.":=InstalNo;
                RSchedule."Repayment Date":=RunDate;
                RSchedule."Client No.":="Client No.";
                RSchedule."Loan Product Type":="Loan Product Type";
              if Date2DMY(RunDate,2) = 1 then
                LPrincipal:=Round(LoanAmount/"No. of Principal Repayments",0.05,'>')
              else
                LPrincipal:=0;
                RSchedule."Total Due":=LInterest+LPrincipal;
                RSchedule."Interest Due":=LInterest;
                RSchedule."Principal Due":=LPrincipal;
                RSchedule."Client Name":="Client Name";
                RSchedule."Due Date":=CalcDate('CM',RSchedule."Repayment Date");
                if not RSchedule2.Get("Loan No.","Client No.",RunDate,RSchedule."Entry Type") then
                RSchedule.Insert
                else begin
                RSchedule2."Repayment Code":=RepayCode;
                RSchedule2."Loan Amount":=(LoanAmount-TotalPrincipal);
                RSchedule2."Installment No.":=InstalNo;
                RSchedule2."Loan Product Type":="Loan Product Type";
                RSchedule2."Interest Due":=LInterest;
                if Date2DMY(RunDate,2) = 1 then
                  LPrincipal:=Round(LoanAmount/"No. of Principal Repayments",0.05,'>')
                else
                  LPrincipal:=0;
                RSchedule2."Total Due":=LInterest + LPrincipal;
                RSchedule2."Interest Due":=LInterest;
                RSchedule2."Principal Due":=LPrincipal;
                RSchedule2."Client Name":="Client Name";
                RSchedule2."Due Date":=CalcDate('CM',RSchedule2."Repayment Date");
                RSchedule2.Modify;
                end;
            end;
          end;

        LBalance:=LBalance-LPrincipal;
        TotalInterest := TotalInterest + LInterest;
        TotalPrincipal := TotalPrincipal + LPrincipal;
        until (LBalance < 1) or (LBalance = LInterest)
        end;
        Loans.Principal := TotalPrincipal;
        Loans.Interest := TotalInterest;
        Loans.Modify;
        end;
    end;

    procedure FullyRepaid(LoanNo: Code[100];Amount: Decimal)
    begin
    end;

    procedure GetLoanValuationWithRefDate(LoanNum: Code[50];RefDate: Date): Decimal
    var
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
        CurrentLoanValuation: Decimal;
        LoanApp: Record "Loan Application";
    begin
        Schedule.Reset;
        Schedule.SetRange("Loan No.",LoanNum);
        Schedule.SetRange(Settled,false);
        if Schedule.FindFirst then begin
          FirstUnsettledAmount:=Schedule."Loan Amount";
          InterestPerDay := Round((Schedule."Interest Due"/31),0.01,'=');
        end;

        //MAXWELL: 26/08/2019 - Dynamically Get Loan Due Date
        Schedule.Reset;
        Schedule.SetRange("Loan No.",LoanNum);
        Schedule.SetRange(Settled,true);
        if Schedule.FindLast then
          LoanDueDate := Schedule."Repayment Date"
        else begin
          LoanApp.Reset;
          LoanApp.SetRange("Loan No.",LoanNum);
          if LoanApp.FindFirst then
            LoanDueDate := LoanApp."Application Date"; //LoanApp."Repayment Start Date";
        end;
        //

        //InterestPerDay := ROUND((Schedule."Interest Due"/31),0.01,'=');
        DueDuration := RefDate - LoanDueDate;

        DueDurationAmount := DueDuration * InterestPerDay;


        Loans.Get(LoanNum);
        LoanProduct.Reset;
        LoanProduct.SetRange(Code,Loans."Loan Product Type");
        if LoanProduct.FindFirst then begin
          if LoanProduct."Loan Type" = LoanProduct."Loan Type"::Bullet then begin

            LoanValuation := Round((FirstUnsettledAmount + DueDurationAmount),0.01,'=');
            exit(LoanValuation);
          end else begin
             LoanValuation := Round(((FirstUnsettledAmount*(Loans."Interest Rate"/100)*(DueDuration/365)) + FirstUnsettledAmount),0.01,'=');
            exit(LoanValuation);
          end;
        end;
    end;

    procedure ClearOutstandingPeriods(var RepaySchedule: Record "Loan Application";var RepaymentStartDate: Date)
    var
        QCounter: Integer;
        InPeriod: DateFormula;
        LoanAmount: Decimal;
        RepayPeriod: Integer;
        LBalance: Decimal;
        RunDate: Date;
        InstalNo: Integer;
        RepayInterval: DateFormula;
        InterestRate: Decimal;
        InitialInstal: Integer;
        TotalMRepay: Decimal;
        LInterest: Decimal;
        LPrincipal: Decimal;
        RepayCode: Code[10];
        CumulativePrincipal: Decimal;
        PreviousCumulativePrincipal: Decimal;
        TotalInterest: Decimal;
        TotalPrincipal: Decimal;
        LoanRec: Record "Loan Application";
        EarlyRepayment: Decimal;
    begin
        with RepaySchedule do begin

        Loans.Reset;
        Loans.SetRange(Loans."Loan No.","Loan No.");
        if Loans.Find('-') then begin
        //Clear Outstanding Periods
          RSchedule.Reset;
          RSchedule.SetRange(RSchedule."Loan No.","Loan No.");
          RSchedule.SetRange(RSchedule."Entry Type",RSchedule."Entry Type"::Scheduled);
          RSchedule.SetFilter("Repayment Date",'>%1',CalcDate('CM',RepaymentStartDate));
          RSchedule.DeleteAll;
        //Mark All Periods as Settled
          RSchedule.Reset;
          RSchedule.SetRange(RSchedule."Loan No.","Loan No.");
          RSchedule.SetRange(RSchedule."Entry Type",RSchedule."Entry Type"::Scheduled);
          RSchedule.SetRange(RSchedule.Settled,false);
          RSchedule.SetFilter("Repayment Date",'<=%1',CalcDate('CM',RepaymentStartDate));
          RSchedule.ModifyAll(Settled,true);
        end;
        end;
    end;

    procedure GetDisbursedLoan()
    var
        LoanApplication: Record "Loan Application";
        PeriodInYears: Integer;
        RepaymentsPerYear: Decimal;
        StartDate: Date;
        EndDate: Date;
        ExpectedRepayment: Decimal;
        ReportPeriod: Text;
        FM: Record "Fund Managers";
        i: Integer;
        FMcode: array [5] of Code[10];
        FMDesc: array [5] of Text;
        LoanBalances: array [5] of Decimal;
        FMRatios: Record "Product Fund Manager Ratio";
        FundPortfolio: Record "Fund Portfolio Details";
        Fund: Record Fund;
        FundManagerPortion: Decimal;
        Response: Text[250];
        HLoanVariation: Record "Historical Loan Variation";
    begin
        HLoanVariation.Reset;
        HLoanVariation.SetRange("Sent For Valuation",false);
        HLoanVariation.SetRange(Status, HLoanVariation.Status::Effected);
        HLoanVariation.SetRange("Type of Variation",HLoanVariation."Type of Variation"::"Top Up");
        //LoanApplication.SETRANGE("Application Date",TODAY);
        if HLoanVariation.FindFirst then begin
          Fund.Reset;
            if Fund.FindFirst then begin
            repeat
                HLoanVariation.SetRange("Fund Code",Fund."Fund Code");
              if HLoanVariation.FindSet then begin
                HLoanVariation.CalcSums("Top Up Amount");
                FundPortfolio.Reset;
                FundPortfolio.SetRange("Fund Code",Fund."Fund Code");
                if FundPortfolio.FindFirst then
                  repeat
                    FMRatios.Reset;
                    FMRatios.SetRange("Fund Manager",FundPortfolio."Fund Manager");
                    FMRatios.SetFilter(From,'<=%1',HLoanVariation.Date);
                    FMRatios.SetFilter("To",'>=%1',HLoanVariation.Date);
                    if FMRatios.FindLast then begin
                      FundManagerPortion := Round(HLoanVariation."Top Up Amount"*FMRatios.Percentage/100,0.01);
                      //MESSAGE('Fund Manager: %1 and Amount: %2 and Portfolio Code: %3', FundPortfolio."Fund Manager",FundManagerPortion, FundPortfolio."Portfolio Code");
                      Response := ExternalSeviceCall.SendDisbursedLoanAndRepayment(FundPortfolio."Portfolio Code",'65','OTHERS',Today,FundManagerPortion,'0007803018','Loan Top Up');
                      if Response <> 'success' then
                        Error(Response);
                    end;
                  until FundPortfolio.Next = 0;
              end;
                //HLoanVariation.MODIFYALL("Sent For Valuation",TRUE,TRUE);
            until Fund.Next = 0;
          end;
        end;

        MarkTopUpAsSent;

        LoanApplication.Reset;
        LoanApplication.SetRange("Sent For Valuation",false);
        LoanApplication.SetRange(Disbursed, true);
        LoanApplication.SetRange("Loan Source",LoanApplication."Loan Source"::"Fresh Loan");
        //LoanApplication.SETRANGE("Application Date",TODAY);
        if LoanApplication.FindSet then begin
          Fund.Reset;
            if Fund.FindFirst then begin
            repeat
                LoanApplication.SetRange("Fund Code",Fund."Fund Code");
              if LoanApplication.Find('-') then begin
                LoanApplication.CalcSums("Requested Amount");
                FundPortfolio.Reset;
                FundPortfolio.SetRange("Fund Code",Fund."Fund Code");
                if FundPortfolio.FindFirst then
                  repeat
                    FMRatios.Reset;
                    FMRatios.SetRange("Fund Manager",FundPortfolio."Fund Manager");
                    FMRatios.SetFilter(From,'<=%1',LoanApplication."Application Date");
                    FMRatios.SetFilter("To",'>=%1',LoanApplication."Application Date");
                    if FMRatios.FindLast then begin
                      FundManagerPortion := Round(LoanApplication."Requested Amount"*FMRatios.Percentage/100,0.01);
                      //MESSAGE('Fund Manager: %1 and Amount: %2 and Portfolio Code: %3', FundPortfolio."Fund Manager",FundManagerPortion, FundPortfolio."Portfolio Code");
                      Response := ExternalSeviceCall.SendDisbursedLoanAndRepayment(FundPortfolio."Portfolio Code",'65','OTHERS',Today,FundManagerPortion,'0007803018','Fresh Loan');
                      if Response <> 'success' then
                        Error(Response);
                    end;
                  until FundPortfolio.Next = 0;
              end;
            until Fund.Next = 0;
          end;
          MarkLoansAsSentForValuation;
          Message('Disbursed loans have been sent successfully');
        end else
         Message('No loan was disbursed today');
    end;

    procedure GetLoanRepayment()
    var
        LoanRepayment: Record "Loan Repayment Schedule";
        PeriodInYears: Integer;
        RepaymentsPerYear: Decimal;
        StartDate: Date;
        EndDate: Date;
        ExpectedRepayment: Decimal;
        ReportPeriod: Text;
        FM: Record "Fund Managers";
        i: Integer;
        FMcode: array [5] of Code[10];
        FMDesc: array [5] of Text;
        LoanBalances: array [5] of Decimal;
        FMRatios: Record "Product Fund Manager Ratio";
        FundPortfolio: Record "Fund Portfolio Details";
        Fund: Record Fund;
        FundManagerPortion: Decimal;
        LoanApplication: Record "Loan Application";
        LoanFundCode: Code[50];
        Response: Text[250];
        Desc: Text[250];
        HistoricalRepaymentSchedule: Record "Historical Repayment Schedules";
        HistoricalLoans: Record "Historical Loans";
    begin
        /*HistoricalRepaymentSchedule.RESET;
        HistoricalRepaymentSchedule.SETRANGE("Sent For Valuation", FALSE);
        HistoricalRepaymentSchedule.SETRANGE(Settled,TRUE);
        IF HistoricalRepaymentSchedule.FINDFIRST THEN BEGIN
          REPEAT
            LoanFundCode := GetHistoricalLoanNo(HistoricalRepaymentSchedule."Loan No.");
            FundPortfolio.RESET;
            FundPortfolio.SETRANGE("Fund Code",LoanFundCode);
            IF FundPortfolio.FINDFIRST THEN
              REPEAT
                FMRatios.RESET;
                FMRatios.SETRANGE("Fund Manager",FundPortfolio."Fund Manager");
                HistoricalLoans.GET(HistoricalRepaymentSchedule."Loan No.");
                FMRatios.SETFILTER(From,'<=%1',HistoricalLoans."Application Date");
                FMRatios.SETFILTER("To",'>=%1',HistoricalLoans."Application Date");
                IF FMRatios.FINDLAST THEN BEGIN
                  FundManagerPortion := ROUND(HistoricalRepaymentSchedule."Total Settlement"*FMRatios.Percentage/100,0.01);
                  Desc := FundPortfolio."Fund Manager" + ' Loan repayment for '+LoanApplication."Staff ID";
                  Response := ExternalSeviceCall.SendDisbursedLoanAndRepayment(FundPortfolio."Portfolio Code",'65','OTHERS',TODAY,-ABS(FundManagerPortion),'0007803018',Desc);
                  IF Response <> 'success' THEN
                    ERROR(Response);
                END;
              UNTIL FundPortfolio.NEXT = 0;
              HistoricalRepaymentSchedule."Sent For Valuation" := TRUE;
              HistoricalRepaymentSchedule.MODIFY;
          UNTIL HistoricalRepaymentSchedule.NEXT = 0;
        END;*/
        
        
        LoanRepayment.Reset;
        LoanRepayment.SetRange("Sent For Valuation", false);
        LoanRepayment.SetRange(Settled,true);
        //LoanRepayment.SETFILTER("Settlement Method",'<>%',LoanRepayment."Settlement Method"::Variation);
        if LoanRepayment.FindFirst then begin
          repeat
            LoanFundCode := GetLoanNo(LoanRepayment."Loan No.");
            FundPortfolio.Reset;
            FundPortfolio.SetRange("Fund Code",LoanFundCode);
            if FundPortfolio.FindFirst then
              repeat
                FMRatios.Reset;
                FMRatios.SetRange("Fund Manager",FundPortfolio."Fund Manager");
                LoanApplication.Get(LoanRepayment."Loan No.");
                FMRatios.SetFilter(From,'<=%1',LoanApplication."Application Date");
                FMRatios.SetFilter("To",'>=%1',LoanApplication."Application Date");
                if FMRatios.FindLast then begin
                  FundManagerPortion := Round(LoanRepayment."Total Settlement"*FMRatios.Percentage/100,0.01);
                  Desc := FundPortfolio."Fund Manager" + ' Loan repayment for '+LoanApplication."Staff ID";
                  //MESSAGE('Fund Manager: %1 and Amount: %2 and Portfolio Code: %3', FundPortfolio."Fund Manager",FundManagerPortion, FundPortfolio."Portfolio Code");
                  Response := ExternalSeviceCall.SendDisbursedLoanAndRepayment(FundPortfolio."Portfolio Code",'65','OTHERS',Today,-Abs(FundManagerPortion),'0007803018',Desc);
                  if Response <> 'success' then
                    Error(Response);
                end;
              until FundPortfolio.Next = 0;
              LoanRepayment."Sent For Valuation" := true;
              LoanRepayment.Modify;
          until LoanRepayment.Next = 0;
          Message('Loan Repayments for today have been sent successfully');
        end else
         Message('No repayment was processed today')

    end;

    procedure GetLoanNo(LoanNum: Code[100]): Code[100]
    var
        Loans: Record "Loan Application";
    begin
        Loans.Reset;
        Loans.SetRange("Loan No.",LoanNum);
        if Loans.FindFirst then
          exit(Loans."Fund Code")
    end;

    procedure SendLoanVariation()
    var
        RepaidViaTermination: Record "Loan Variation";
        PeriodInYears: Integer;
        RepaymentsPerYear: Decimal;
        StartDate: Date;
        EndDate: Date;
        ExpectedRepayment: Decimal;
        ReportPeriod: Text;
        FM: Record "Fund Managers";
        i: Integer;
        FMcode: array [5] of Code[10];
        FMDesc: array [5] of Text;
        LoanBalances: array [5] of Decimal;
        FMRatios: Record "Product Fund Manager Ratio";
        FundPortfolio: Record "Fund Portfolio Details";
        Fund: Record Fund;
        FundManagerPortion: Decimal;
        HLoans: Record "Historical Loans";
        LoanFundCode: Code[50];
        Response: Text[250];
        Desc: Text[250];
    begin
        RepaidViaTermination.Reset;
        RepaidViaTermination.SetRange("Sent For Valuation",false);
        RepaidViaTermination.SetRange(Status, RepaidViaTermination.Status::Effected);
        RepaidViaTermination.SetRange("Type of Variation", RepaidViaTermination."Type of Variation"::Terminate);
        if RepaidViaTermination.FindFirst then begin
          repeat
            FundPortfolio.Reset;
            FundPortfolio.SetRange("Fund Code",RepaidViaTermination."Fund Code");
            if FundPortfolio.FindFirst then
              repeat
                FMRatios.Reset;
                FMRatios.SetRange("Fund Manager",FundPortfolio."Fund Manager");
                HLoans.Get(RepaidViaTermination."Old Loan No.");
                FMRatios.SetFilter(From,'<=%1',HLoans."Application Date");
                FMRatios.SetFilter("To",'>=%1',HLoans."Application Date");
                if FMRatios.FindLast then begin
                  FundManagerPortion := Round(RepaidViaTermination."Total Outstanding Loan"*FMRatios.Percentage/100,0.01);
                  Desc := FundPortfolio."Fund Manager" + ' Loan repayment via variaton for '+HLoans."Staff ID";
                  Response := ExternalSeviceCall.SendDisbursedLoanAndRepayment(FundPortfolio."Portfolio Code",'65','OTHERS',Today,-Abs(FundManagerPortion),'0007803018',Desc);
                  if Response <> 'success' then
                    Error(Response);
                end;
                RepaidViaTermination."Sent For Valuation" := true;
                RepaidViaTermination.Modify;
              until FundPortfolio.Next = 0;
          until RepaidViaTermination.Next = 0;
        end;
    end;

    procedure GetHistoricalLoanNo(LoanNum: Code[100]): Code[100]
    var
        HistoricalLoan: Record "Historical Loans";
    begin
        HistoricalLoan.Reset;
        HistoricalLoan.SetRange("Loan No.",LoanNum);
        if HistoricalLoan.Find('-') then
          exit(HistoricalLoan."Fund Code")
    end;

    procedure MarkLoansAsSentForValuation()
    var
        SentLoanApp: Record "Loan Application";
    begin
        SentLoanApp.Reset;
        SentLoanApp.SetRange("Sent For Valuation",false);
        SentLoanApp.SetRange(Disbursed, true);
        //SentLoanApp.SETRANGE("Loan Source",LoanApplication."Loan Source"::"Fresh Loan");
        if SentLoanApp.FindFirst then
          repeat
            SentLoanApp."Sent For Valuation" := true;
            SentLoanApp.Modify;
          until SentLoanApp.Next = 0;
    end;

    procedure MarkTopUpAsSent()
    var
        HistoricalLoanVariation: Record "Historical Loan Variation";
    begin
        HistoricalLoanVariation.Reset;
        HistoricalLoanVariation.SetRange("Sent For Valuation",false);
        HistoricalLoanVariation.SetRange(Status, HistoricalLoanVariation.Status::Effected);
        HistoricalLoanVariation.SetRange("Type of Variation",HistoricalLoanVariation."Type of Variation"::"Top Up");
        if HistoricalLoanVariation.FindFirst then begin
          repeat
            HistoricalLoanVariation."Sent For Valuation" := true;
            HistoricalLoanVariation.Modify;
          until HistoricalLoanVariation.Next = 0;
        end;
    end;
}

