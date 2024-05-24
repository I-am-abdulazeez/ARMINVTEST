report 50001 "Generate EOD"
{
    ProcessingOnly = true;
    UseRequestPage = true;

    dataset
    {
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("EOD Date";Valuedate)
                {
                    Caption = 'EOD Date';
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

    trigger OnInitReport()
    begin
        Eod.Reset;
        if Eod.FindLast then
          Valuedate:=CalcDate('1D',Eod.Date);
    end;

    trigger OnPreReport()
    var
        TotalAmount: Decimal;
        TotalUnit: Decimal;
        SettlementDate: Date;
        SettleBankAccount: Code[40];
        Naration: Text;
        PortfolioCode: Code[40];
        Fund: Record Fund;
        Response: Text[250];
        FundTransMgt: Codeunit "Fund Transaction Management";
        ValDate: Text;
    begin
        Eod.Reset;
        if Eod.FindLast then
          Valuedate:=CalcDate('1D',Eod.Date);
        if Valuedate=0D then
          Error('Input the date you are running EOD for');
        FundTransactionManagement.GenerateEOD(Valuedate);
        EODStepTrack.Reset;
        //Maxwell: BEGIN Deluxe EOD
        SubscriptionRedempFundware.Reset;
        SubscriptionRedempFundware.SetRange(PostDate,Valuedate);
        SubscriptionRedempFundware.SetRange(BuyBack,false);
        SubscriptionRedempFundware.SetRange("Reversed Transaction",false);
        Fund.Reset;
        if Fund.FindFirst then
          repeat
            SubscriptionRedempFundware.SetRange(PlanCode,Fund."Fund Code");
            if SubscriptionRedempFundware.FindFirst then begin
              SubscriptionRedempFundware.SetRange(TransactionType,'RED');
              SubscriptionRedempFundware.SetRange("Penalty Charge", false);
              if SubscriptionRedempFundware.FindFirst then begin
                SubscriptionRedempFundware.CalcSums(TradeAmount,TradeUnits);
                TotalAmount := SubscriptionRedempFundware.TradeAmount;
                TotalUnit := SubscriptionRedempFundware.TradeUnits;
                SettlementDate := Valuedate;
                SettleBankAccount := SubscriptionRedempFundware.BankAccountNo;
                PortfolioCode := Fund."Fund Code";
                Naration := PortfolioCode + ' Withdrawal';

                Response := ExternalSeviceCall.SendOCFile(SettlementDate,TotalUnit,TotalAmount,SettleBankAccount,Naration,PortfolioCode);
                if Response <> 'success' then
                  Error(Response)
                else
                  FundTransMgt.InsertEODStepTracker(Valuedate, PortfolioCode,'Redemption', SettleBankAccount,Response,TotalAmount,TotalUnit);
               end;
             end;
          until Fund.Next = 0;

          FundBankAccount.Reset;
          FundBankAccount.SetRange("Transaction Type", FundBankAccount."Transaction Type"::Subscription);
          if FundBankAccount.FindFirst then begin
            repeat
            TotalAmount := 0;
            TotalUnit := 0;
              SubscriptionRedempFundware.Reset;
              SubscriptionRedempFundware.SetRange(PostDate,Valuedate);
              SubscriptionRedempFundware.SetRange(TransactionType, 'PUR');
              SubscriptionRedempFundware.SetRange(BankAccountNo,FundBankAccount."Bank Account No");
              SubscriptionRedempFundware.SetRange(PlanCode,FundBankAccount."Fund Code");
              SubscriptionRedempFundware.SetRange("Reversed Transaction",false);
              SubscriptionRedempFundware.SetRange(BuyBack, false);
              if SubscriptionRedempFundware.FindFirst then begin
                SubscriptionRedempFundware.CalcSums(TradeAmount,TradeUnits);
                TotalAmount := SubscriptionRedempFundware.TradeAmount;
                TotalUnit := SubscriptionRedempFundware.TradeUnits;
                SettlementDate := Valuedate;
                SettleBankAccount := FundBankAccount."Bank Account No";
                PortfolioCode := FundBankAccount."Fund Code";
                Naration := PortfolioCode + ' Deposit';
                Response := ExternalSeviceCall.SendOCFile(SettlementDate,TotalUnit,TotalAmount,SettleBankAccount,Naration,PortfolioCode);
                if Response <> 'success' then
                  Error(Response)
                else
                  FundTransMgt.InsertEODStepTracker(Valuedate, PortfolioCode,'Subscription', SettleBankAccount,Response,TotalAmount,TotalUnit)
             end;
          until FundBankAccount.Next = 0;
        end;
        //Post Reversal module

        SubscriptionRedempFundware.Reset;
        SubscriptionRedempFundware.SetRange(PostDate,Valuedate);
        SubscriptionRedempFundware.SetRange(BuyBack,false);
        SubscriptionRedempFundware.SetRange("Reversed Transaction",true);
        Fund.Reset;
        if Fund.FindFirst then
          repeat
            SubscriptionRedempFundware.SetRange(PlanCode,Fund."Fund Code");
            if SubscriptionRedempFundware.FindFirst then begin
              SubscriptionRedempFundware.SetRange(TransactionType,'REV-RED');
              SubscriptionRedempFundware.SetRange("Penalty Charge", false);
              if SubscriptionRedempFundware.FindFirst then begin
                SubscriptionRedempFundware.CalcSums(TradeAmount,TradeUnits);
                TotalAmount := Abs(SubscriptionRedempFundware.TradeAmount);
                TotalUnit := Abs(SubscriptionRedempFundware.TradeUnits);
                SettlementDate := Valuedate;
                SettleBankAccount := SubscriptionRedempFundware.BankAccountNo;
                PortfolioCode := Fund."Fund Code";
                Naration := PortfolioCode + ' Redemption Reversal';

                Response := ExternalSeviceCall.SendOCFile(SettlementDate,TotalUnit,TotalAmount,SettleBankAccount,Naration,PortfolioCode);
                if Response <> 'success' then
                  Error(Response)
                else
                  FundTransMgt.InsertEODStepTracker(Valuedate, PortfolioCode,'Redemption Reversal', SettleBankAccount,Response,TotalAmount,TotalUnit);
               end;
             end;
          until Fund.Next = 0;

          FundBankAccount.Reset;
          FundBankAccount.SetRange("Transaction Type", FundBankAccount."Transaction Type"::Subscription);
          if FundBankAccount.FindFirst then begin
            repeat
            TotalAmount := 0;
            TotalUnit := 0;
              SubscriptionRedempFundware.Reset;
              SubscriptionRedempFundware.SetRange(PostDate,Valuedate);
              SubscriptionRedempFundware.SetRange(TransactionType, 'REV-SUB');
              SubscriptionRedempFundware.SetRange(BankAccountNo,FundBankAccount."Bank Account No");
              SubscriptionRedempFundware.SetRange(PlanCode,FundBankAccount."Fund Code");
              SubscriptionRedempFundware.SetRange("Reversed Transaction",true);
              SubscriptionRedempFundware.SetRange(BuyBack, false);
              if SubscriptionRedempFundware.FindFirst then begin
                SubscriptionRedempFundware.CalcSums(TradeAmount,TradeUnits);
                TotalAmount := -Abs(SubscriptionRedempFundware.TradeAmount);
                TotalUnit := -Abs(SubscriptionRedempFundware.TradeUnits);
                SettlementDate := Valuedate;
                SettleBankAccount := FundBankAccount."Bank Account No";
                PortfolioCode := FundBankAccount."Fund Code";
                Naration := PortfolioCode + ' Subscription Reversal';
                Response := ExternalSeviceCall.SendOCFile(SettlementDate,TotalUnit,TotalAmount,SettleBankAccount,Naration,PortfolioCode);
                if Response <> 'success' then
                  Error(Response)
                else
                  FundTransMgt.InsertEODStepTracker(Valuedate, PortfolioCode,'Subscription Reversal', SettleBankAccount,Response,TotalAmount,TotalUnit)
             end;
          until FundBankAccount.Next = 0;
        end;

        //Post Penalty Charge for other Mutual Funds.
        FundBankAccount.Reset;
        FundBankAccount.SetRange("Transaction Type", FundBankAccount."Transaction Type"::Trading);
        if FundBankAccount.FindFirst then
          repeat
            SubscriptionRedempFundware.Reset;
            SubscriptionRedempFundware.SetRange(PostDate,Valuedate);
            SubscriptionRedempFundware.SetRange(BankAccountNo,FundBankAccount."Bank Account No");
            SubscriptionRedempFundware.SetRange(PlanCode,FundBankAccount."Fund Code");
            SubscriptionRedempFundware.SetRange(BuyBack,false);
            SubscriptionRedempFundware.SetRange("Reversed Transaction", false);
            SubscriptionRedempFundware.SetRange("Penalty Charge", true);
            if SubscriptionRedempFundware.FindFirst then begin
                SubscriptionRedempFundware.CalcSums(TradeAmount,TradeUnits);
                TotalAmount := -Abs(SubscriptionRedempFundware.TradeAmount);
                TotalUnit := -Abs(SubscriptionRedempFundware.TradeUnits);
                SettlementDate := Valuedate;
                SettleBankAccount := SubscriptionRedempFundware.BankAccountNo;
                PortfolioCode := FundBankAccount."Fund Code";
                Naration := PortfolioCode + ' Pre-liquidation Charges';
                Response :=  ExternalSeviceCall.SendOCFile(SettlementDate,TotalUnit,TotalAmount,SettleBankAccount,Naration,PortfolioCode);
                if Response <> 'success' then begin
                  Error(Response);
                  end
                else begin
                  FundTransMgt.InsertEODStepTracker(Valuedate, PortfolioCode,'Penalty Charge', SettleBankAccount,Response,TotalAmount,TotalUnit);
                end;
            end;
          until FundBankAccount.Next = 0;


        //MMF Dividend Entitlement
        DividendIncomeSettled.Reset;
        DividendIncomeSettled.SetRange(PlanCode,'ARMMMF');
        DividendIncomeSettled.SetRange("Settled Date", Valuedate);
        if DividendIncomeSettled.FindFirst then
          DividendFundCode := DividendIncomeSettled.PlanCode;
          DividendAmount := DividendIncomeSettled.Amount;
          FundBankAccount.Reset;
          FundBankAccount.SetRange("Fund Code",'ARMMMF');
          FundBankAccount.SetRange("Transaction Type",FundBankAccount."Transaction Type"::Redemption);
          FundBankAccount.SetRange(Default,true);
          if FundBankAccount.FindFirst then
           DividendBankAccountNo:= FundBankAccount."Bank Account No";
          DividendNarration := 'Dividend Entitlement';
          if DividendAmount > 0 then begin
           DividendResponse := ExternalSeviceCall.SendMMFLiquidatingInterest(DividendFundCode,Format(Valuedate,0,9),DividendAmount,DividendBankAccountNo,DividendNarration);
           if DividendResponse <> 'success' then
            Error(DividendResponse)
           else
            FundTransMgt.InsertEODStepTracker(Valuedate, DividendFundCode,'Dividend Entitlement full redemption', DividendBankAccountNo,DividendResponse,DividendAmount,DividendAmount);
          end;

         //////////////////////////////////////////////////////////////////
        //Liquidating Charges on MMF Accrued Interest.
        AccruedInterestCharges.Reset;
        AccruedInterestCharges.SetRange("Fund Code",'ARMMMF');
        AccruedInterestCharges.SetRange("Value Date",Valuedate);
        if AccruedInterestCharges.FindFirst then
          AccruedInterestCharges.CalcSums("Amount Charged");
          ChargesFundCode := 'ARMMMF';
          ChargesAmount := AccruedInterestCharges."Amount Charged";
          ValDate := Format(Valuedate,0,9);
          FundBankAccount.Reset;
          FundBankAccount.SetRange("Fund Code",'ARMMMF');
          FundBankAccount.SetRange("Transaction Type",FundBankAccount."Transaction Type"::Redemption);
          FundBankAccount.SetRange(Default,true);
          if FundBankAccount.FindFirst then
            ChargesBankAccountNo := FundBankAccount."Bank Account No"; //'0011607077';
          ChargesNarration := ChargesFundCode + ' charges on interest';
          if ChargesAmount > 0 then begin
            ChargesResponse := ExternalSeviceCall.SendMMFLiquidatingInterest(ChargesFundCode,ValDate,ChargesAmount,ChargesBankAccountNo,ChargesNarration);
            if ChargesResponse <> 'success' then
              Error(ChargesResponse)
            else
              FundTransMgt.InsertEODStepTracker(Valuedate,ChargesFundCode,'Charges on interest',ChargesBankAccountNo,ChargesResponse,ChargesAmount,ChargesAmount);
          end;

        //Generate OC Excel File.
        Clear(ExportRedeemSubscriptions);
        SubscriptionRedempFundware.Reset;
        SubscriptionRedempFundware.SetRange(PostDate,Valuedate);
        SubscriptionRedempFundware.SetRange("Penalty Charge", false);
        if SubscriptionRedempFundware.FindFirst then begin
          ExportRedeemSubscriptions.SetTableView(SubscriptionRedempFundware);
          ExportRedeemSubscriptions.Run;
        end;

        //Generate Liquidating Interest Excel File.
        Clear(ExportDividendSettled);
        DividendIncomeSettled.Reset;
        DividendIncomeSettled.SetRange("Settled Date",Valuedate);
        if DividendIncomeSettled.FindFirst then begin
          ExportDividendSettled.SetTableView(DividendIncomeSettled);
          ExportDividendSettled.Run;
        end;

        //Generate Penalty Charge Excel File.
        Clear(ExportChargesOnDividend);
        AccruedInterestCharges.Reset;
        AccruedInterestCharges.SetRange("Value Date",Valuedate);
        if AccruedInterestCharges.FindFirst then begin
          ExportChargesOnDividend.SetTableView(AccruedInterestCharges);
          ExportChargesOnDividend.Run;
        end;

        //Generate Suspicious Transactions
        FundTransactionManagement.FlagInAndOutTransactions(Valuedate);
        FundTransactionManagement.FlagMultipleRedemptions(Valuedate);

        //Remove amount from on hold
        FundAdministration.RemoveHoldingPeriod;

        Message('EOD completed successfully.');
    end;

    var
        FundTransactionManagement: Codeunit "Fund Transaction Management";
        Valuedate: Date;
        Eod: Record "EOD Tracker";
        SubscriptionRedempFundware: Record "Subscription & Redemp Fundware";
        ExportRedeemSubscriptions: Report "Export Redemptions & subscrip";
        ExportDividendSettled: Report "Export Dividend Settlement";
        DividendIncomeSettled: Record "Dividend Income Settled";
        FundAdministration: Codeunit "Fund Administration";
        AccruedInterestCharges: Record "Charges on Accrued Interest";
        ExportChargesOnDividend: Report "Charges on Dividend Accrued";
        ExternalSeviceCall: Codeunit ExternalCallService;
        FundBankAccount: Record "Fund Bank Accounts";
        EODStepTrack: Record "EOD Step Tracker";
        DividendFundCode: Code[40];
        DividendAmount: Decimal;
        DividendBankAccountNo: Code[20];
        DividendNarration: Text[250];
        DividendResponse: Text[250];
        ChargesResponse: Text[250];
        ChargesFundCode: Code[40];
        ChargesAmount: Decimal;
        ChargesBankAccountNo: Code[20];
        ChargesNarration: Text[250];
}

