codeunit 50003 "Fund Processing"
{

    trigger OnRun()
    begin
    end;

    var
        NoSeriesManagement: Codeunit NoSeriesManagement;
        FundAdministrationSetup: Record "Fund Administration Setup";
        Window: Dialog;
        DailyDistributableIncome: Record "Daily Distributable Income";
        DailyIncomeDistribCard: Page "Daily Income Distrib Card";
        EOQHeader: Record "EOQ Header";
        EOQList: Page "EOQ List";
        FundTransactionManagement: Codeunit "Fund Transaction Management";
        NarrationTransType: Option " ","Subscription Initial","Subscription Additional","Redemption Part","Redemption Full","Account Transfer","Dividend Reinvest";
        FundAdministration: Codeunit "Fund Administration";
        EOQTracker: Record "EOQ Tracker";
        EOQTracker2: Record "EOQ Tracker";
        EOQTrackers: Page "EOQ Tracker";
        MFDistributableIncome: Record "MF Distributable Income";
        MFIncomeDistribCard: Page "MF Income Distrib Card";
        ClientTransact: Record "Client Transactions";

    procedure DistributeIncome(IncomeRegister: Record "Income Register")
    var
        DailyDistributableIncome: Record "Daily Distributable Income";
        DailyIncomeDistribLines: Record "Daily Income Distrib Lines";
        Client: Record Client;
        ClientAccount: Record "Client Account";
        Fund: Record Fund;
        Lineno: Integer;
        DailyDistributableIncome2: Record "Daily Distributable Income";
        DailyIncomeDistribLines2: Record "Daily Income Distrib Lines";
        EODTracker: Record "EOD Tracker";
    begin
        IncomeRegister.TestField("Fund ID");
        IncomeRegister.TestField("Value Date");

        IncomeRegister.Reset;
        IncomeRegister.SetRange("Value Date");
        IncomeRegister.SetRange("Fund ID");

        if IncomeRegister."Value Date">Today then
          Error('You cannot Distribute Income for a future Date');
        if (IncomeRegister."Distributed Income"=0) and (IncomeRegister."Earnings Per Unit"=0) then
          Error('Please input Total Income Distributed or the earning per unit');

        //Maxwell: To check if EOD has been run before distributing income.

        EODTracker.Reset;
        EODTracker.SetRange(Date,IncomeRegister."Value Date");
        EODTracker.SetRange("Fund Code",IncomeRegister."Fund ID");
        if EODTracker.FindFirst then begin

        Window.Open('Distributing for client Account #1#######');
        Fund.Get(IncomeRegister."Fund ID");
        Fund.CalcFields("No of Units");
        FundAdministrationSetup.Get;
        FundAdministrationSetup.TestField("Daily Distributable Income Nos");
        Lineno:=0;
        DailyDistributableIncome.Reset;
        DailyDistributableIncome.SetRange(Date,IncomeRegister."Value Date");
        DailyDistributableIncome.SetRange("Fund Code",IncomeRegister."Fund ID");
        if DailyDistributableIncome.FindFirst then begin

          DailyDistributableIncome.Date:=IncomeRegister."Value Date";
          DailyDistributableIncome."Fund Code":=IncomeRegister."Fund ID";
          DailyDistributableIncome."Daily Distributable Income":=IncomeRegister."Distributed Income";
          DailyDistributableIncome."Total Fund Units":=Round(Fund."No of Units",0.0004,'=');
          if IncomeRegister."Earnings Per Unit">0 then
             DailyDistributableIncome."Earnings Per Unit":=IncomeRegister."Earnings Per Unit"
          else
          DailyDistributableIncome."Earnings Per Unit":=Round(DailyDistributableIncome."Daily Distributable Income"/DailyDistributableIncome."Total Fund Units",0.000000000001,'=');
          DailyDistributableIncome.Modify;

          IncomeRegister."Earnings Per Unit":=DailyDistributableIncome."Earnings Per Unit";
          IncomeRegister.Modify
        end
        else begin

          DailyDistributableIncome.Init;
          DailyDistributableIncome.No:=NoSeriesManagement.GetNextNo(FundAdministrationSetup."Daily Distributable Income Nos",Today,true);
          DailyDistributableIncome.Date:=IncomeRegister."Value Date";
          DailyDistributableIncome."Fund Code":=IncomeRegister."Fund ID";
          DailyDistributableIncome."Daily Distributable Income":=IncomeRegister."Distributed Income";
          DailyDistributableIncome."Total Fund Units":=Fund."No of Units";
          if IncomeRegister."Earnings Per Unit">0 then
             DailyDistributableIncome."Earnings Per Unit":=IncomeRegister."Earnings Per Unit"
          else
          DailyDistributableIncome."Earnings Per Unit":=Round(DailyDistributableIncome."Daily Distributable Income"/DailyDistributableIncome."Total Fund Units",0.000000000001,'=');
          DailyDistributableIncome.Insert(true);
          IncomeRegister."Earnings Per Unit":=DailyDistributableIncome."Earnings Per Unit";
          IncomeRegister.Modify
        end;

        DailyIncomeDistribLines2.Reset;
        DailyIncomeDistribLines2.SetRange(No,DailyDistributableIncome.No);
        DailyIncomeDistribLines2.DeleteAll;

        ClientAccount.Reset;
        ClientAccount.SetRange("Fund No",IncomeRegister."Fund ID");
        ClientAccount.SetFilter("Account Status",'<>%1',ClientAccount."Account Status"::Closed);
        //
        ClientAccount.SetFilter("Date Filter",'..%1',DailyDistributableIncome.Date);

        //
        if ClientAccount.FindFirst then
          repeat

            Window.Update(1,ClientAccount."Account No");
            ClientAccount.CalcFields("No of Units");
            Lineno:=Lineno+1;
            if Client.Get(ClientAccount."Client ID") then ;
            DailyIncomeDistribLines.Init;
            DailyIncomeDistribLines.No:=DailyDistributableIncome.No;
            DailyIncomeDistribLines."Value Date":=DailyDistributableIncome.Date;
            DailyIncomeDistribLines."Line No":=Lineno;
            //Maxwell: Identify Nominee Clients
            DailyIncomeDistribLines."Nominee Client" := ClientAccount."Nominee Client";
            DailyIncomeDistribLines."Portfolio Code" := ClientAccount."Portfolio Code";
            //
            DailyIncomeDistribLines."Account No":=ClientAccount."Account No";
            DailyIncomeDistribLines."Client ID":=ClientAccount."Client ID";
            DailyIncomeDistribLines."Client Name":=Client.Name;
            DailyIncomeDistribLines."Fund Code":=ClientAccount."Fund No";
            DailyIncomeDistribLines."No of Units":=Round(ClientAccount."No of Units",0.0001,'=');
            DailyIncomeDistribLines."Income Per unit":=Round(DailyDistributableIncome."Earnings Per Unit",0.000000000001,'=');
            DailyIncomeDistribLines."Income accrued":=Round(DailyIncomeDistribLines."No of Units"*DailyIncomeDistribLines."Income Per unit",0.0001,'=');
           if DailyIncomeDistribLines."Income accrued">0 then
            DailyIncomeDistribLines.Insert;
          until ClientAccount.Next=0;
          Window.Close;
        end else
          Error('Please, run EOD for %1 before distributing income.',IncomeRegister."Value Date");
    end;

    procedure DistributeIncomeBatch()
    var
        IncomeRegister: Record "Income Register";
    begin
        IncomeRegister.Reset;
        IncomeRegister.SetRange("Value Date",Today);
        if IncomeRegister.FindFirst then
          repeat
            DistributeIncome(IncomeRegister);
          until IncomeRegister.Next=0;
    end;

    procedure ViewDistributedIncome(IncomeRegister: Record "Income Register")
    begin
        Clear(DailyIncomeDistribCard);
        DailyDistributableIncome.FilterGroup(10);
        DailyDistributableIncome.SetRange(Date,IncomeRegister."Value Date");
        DailyDistributableIncome.SetRange("Fund Code",IncomeRegister."Fund ID");
        DailyDistributableIncome.FilterGroup(0);
        DailyIncomeDistribCard.SetTableView(DailyDistributableIncome);
        DailyIncomeDistribCard.RunModal;
    end;

    procedure ProcessEOQBatch(Quarters: Record Quarters)
    var
        Fund: Record Fund;
        ClientAccount: Record "Client Account";
        Client: Record Client;
        DailyIncomeDistribLines: Record "Daily Income Distrib Lines";
        EOQHeader: Record "EOQ Header";
        EOQLines: Record "EOQ Lines";
        Lineno: Integer;
        Quarters2: Record Quarters;
        ClientAccount2: Record "Client Account";
        Client2: Record Client;
    begin
        Quarters.TestField("Start Date");
        Quarters.TestField("End Date");
        Quarters2.Reset;
        Quarters2.SetFilter("End Date",'<%1',Quarters."Start Date");
        Quarters2.SetRange(Closed,false);
        if Quarters2.FindFirst then
          Error('Please Ensure all Preceeding Quarters Before Processing this Quarter');



        Window.Open('Running EOQ for  #1#######');
        FundAdministrationSetup.Get;
        FundAdministrationSetup.TestField("End of Quarter Nos");
        Lineno:=0;
        Fund.Reset;
        Fund.SetRange("Active Fund",true);
        Fund.SetRange("Dividend Period",Fund."Dividend Period"::Quartely);
        if Fund.FindFirst then
          repeat
            DailyIncomeDistribLines.Reset;
            DailyIncomeDistribLines.SetRange("Value Date",Quarters."Start Date",Quarters."End Date");
            DailyIncomeDistribLines.SetRange("Fully Paid",false);
            DailyIncomeDistribLines.SetRange("Fund Code",Fund."Fund Code");
            if  DailyIncomeDistribLines.FindFirst then begin
              EOQHeader.Reset;
              EOQHeader.SetRange(Quarter,Quarters.Code);
              EOQHeader.SetRange("Fund Code",Fund."Fund Code");
              if EOQHeader.FindFirst then begin
                EOQHeader.TestField(Status, EOQHeader.Status::Generated);
                EOQHeader.Quarter:=Quarters.Code;
                //EOQHeader.Date:=TODAY;
                EOQHeader.Date:=CalcDate('1D', Quarters."End Date");
                EOQHeader."Created By":=UserId;
                EOQHeader."Creation Date":=Today;
                EOQHeader."Fund Code":=Fund."Fund Code";
                EOQHeader.Modify;
              end else begin
                EOQHeader.Init;
                EOQHeader.No:=NoSeriesManagement.GetNextNo(FundAdministrationSetup."End of Quarter Nos",Today,true);
                EOQHeader.Quarter:=Quarters.Code;
                //EOQHeader.Date:=TODAY;
                EOQHeader.Date:=CalcDate('1D', Quarters."End Date");
                EOQHeader."Created By":=UserId;
                EOQHeader."Creation Date":=Today;
                EOQHeader."Fund Code":=Fund."Fund Code";
                EOQHeader.Insert;
              end;

              EOQLines.Reset;
              EOQLines.SetRange("Header No",EOQHeader.No);
              EOQLines.DeleteAll;

              ClientAccount.Reset;
              ClientAccount.SetRange("Fund No",Fund."Fund Code");
              if ClientAccount.FindFirst then
                repeat
                 Window.Update(1,ClientAccount."Account No");
                  if Client.Get(ClientAccount."Client ID") then;
                  DailyIncomeDistribLines.Reset;
                  DailyIncomeDistribLines.SetCurrentKey("Account No","Value Date");
                  DailyIncomeDistribLines.SetRange("Account No",ClientAccount."Account No");
                  DailyIncomeDistribLines.SetRange("Value Date",Quarters."Start Date",Quarters."End Date");
                  DailyIncomeDistribLines.SetRange("Fully Paid",false);
                  DailyIncomeDistribLines.CalcSums("Income accrued");

                  Lineno:=Lineno+1;

                  EOQLines.Init;
                  EOQLines."Header No":=EOQHeader.No;
                  EOQLines."Line No":=Lineno;
                  EOQLines."Account No":=ClientAccount."Account No";
                  EOQLines."Fund Code":=ClientAccount."Fund No";
                  EOQLines."Client ID":=ClientAccount."Client ID";
                  EOQLines."Client Name":=Client.Name;
                  EOQLines."Bank Code":=ClientAccount."Bank Code";
                  EOQLines."Bank Branch":=ClientAccount."Bank Branch";
                  EOQLines."Bank Account":=ClientAccount."Bank Account Number";
                  //Nominee Dividend
                  EOQLines."Nominee Client" := ClientAccount."Nominee Client";
                  EOQLines."Portfolio Code" := ClientAccount."Portfolio Code";
                  if (ClientAccount."Split Dividend") and (ClientAccount."Account No To Split To"<>'')  then begin
                    EOQLines."Dividend Amount":=((100-ClientAccount."Split Percentage")/100)*DailyIncomeDistribLines."Income accrued";
                      EOQLines.Split:=true;
                      EOQLines."Split to Account":=ClientAccount."Account No To Split To";
                      EOQLines."Split Percentage":=100-ClientAccount."Split Percentage";
                  end
                  else
                    EOQLines."Dividend Amount":=DailyIncomeDistribLines."Income accrued";

                  EOQLines."Dividend Mandate":=ClientAccount."Dividend Mandate";

                  EOQLines."Total Dividend Earned":=DailyIncomeDistribLines."Income accrued";
                  if EOQLines."Dividend Amount">0 then
                    EOQLines.Insert;

                 if (ClientAccount."Split Dividend") and (ClientAccount."Account No To Split To"<>'')  then begin
                   Lineno:=Lineno+1;
                   ClientAccount2.Reset;
                   if ClientAccount2.Get(ClientAccount."Account No To Split To") then ;
                          if Client2.Get(ClientAccount2."Client ID") then;
                    EOQLines.Init;
                    EOQLines."Header No":=EOQHeader.No;
                    EOQLines."Line No":=Lineno;
                    EOQLines."Account No":=ClientAccount2."Account No";
                    EOQLines."Fund Code":=ClientAccount2."Fund No";
                    EOQLines."Client ID":=ClientAccount2."Client ID";
                    EOQLines."Client Name":=Client2.Name;
                    EOQLines."Bank Code":=ClientAccount2."Bank Code";
                    EOQLines."Bank Branch":=ClientAccount2."Bank Branch";
                    EOQLines."Bank Account":=ClientAccount2."Bank Account Number";
                    EOQLines."Dividend Amount":=(ClientAccount."Split Percentage"/100)*DailyIncomeDistribLines."Income accrued";
                     EOQLines.Split:=true;
                     EOQLines."Split Percentage":=ClientAccount."Split Percentage";
                    EOQLines."Dividend Mandate":=ClientAccount2."Dividend Mandate";
                    if EOQLines."Dividend Amount">0 then
                      EOQLines.Insert;
                end
                until ClientAccount.Next=0;

            end;
          until Fund.Next=0;
         InsertEOQTracker(EOQHeader.Status,EOQHeader.No);
         //Charges BEGIN
          PaidChargesToFundManagers(Quarters."Start Date",Quarters."End Date");
        //END
          Window.Close;
        Message('EOQ dividend generated successfully for verifications.')
    end;

    local procedure ProcessEOQ()
    begin
    end;

    procedure ViewEOQ(Quarters: Record Quarters)
    begin
        Clear(EOQList);
        EOQHeader.FilterGroup(10);
        EOQHeader.SetRange(Quarter,Quarters.Code);
        EOQHeader.FilterGroup(0);
        EOQList.SetTableView(EOQHeader);
        EOQList.RunModal;
    end;

    procedure SendEOQtoTreasury(EOQHeader: Record "EOQ Header")
    var
        EOQLines: Record "EOQ Lines";
        EntryNo: Integer;
    begin
        if not Confirm(StrSubstNo('Are you sure you want Process to this EOQ %1 ? Please note that any account without Dividend mandate will be automatically Reinvested',EOQHeader.No)) then
          Error('');
        Window.Open('Processing Line #1#######');
          EntryNo:=0;
          EntryNo:=FundTransactionManagement.GetLastTransactionNo;
        EOQLines.Reset;
        EOQLines.SetRange("Header No",EOQHeader.No);
        EOQLines.SetRange(EOQLines.Verified,true);
        EOQLines.SetRange(Processed,false);
        if EOQLines.FindFirst then
          repeat
            Window.Update(1,EOQLines."Line No");
            if (EOQLines."Dividend Mandate"=EOQLines."Dividend Mandate"::Reinvest)  or (EOQLines."Dividend Mandate"=EOQLines."Dividend Mandate"::" ") or (EOQLines."Total Dividend Earned" < 553) then begin
              EntryNo:=EntryNo+1;
              EOQReinvest(EOQLines,EntryNo,EOQHeader.Date,EOQHeader.Quarter);
            end ;

            EOQLines.Processed:=true;
            EOQLines."DateTime Processed":=CurrentDateTime;
            EOQLines.Modify;
          until EOQLines.Next=0;

        EOQHeader.Status:=EOQHeader.Status::"Sent to Treasury";
        EOQHeader."DateTime Verified":=CurrentDateTime;
        EOQHeader.Modify;
        InsertEOQTracker(EOQHeader.Status,EOQHeader.No);
          Window.Close;

        Message('EOQ Dividend reinvested successfully');
    end;

    local procedure EOQReinvest(EOQLines: Record "EOQ Lines";EntryNo: Integer;ValueDate: Date;CurrQuarter: Code[30])
    var
        ClientTransactions: Record "Client Transactions";
        NarrationText: Text;
        Client: Record Client;
    begin

        ClientTransactions.Init;
        ClientTransactions."Entry No":=EntryNo;
        ClientTransactions."Transaction Type":=ClientTransactions."Transaction Type"::Subscription;
        ClientTransactions."Transaction Sub Type":=ClientTransactions."Transaction Sub Type"::additional;
        ClientTransactions."Transaction Sub Type 2":=ClientTransactions."Transaction Sub Type 2"::"Dividend ReInvestment";
        ClientTransactions."Transaction Sub Type 3" :=ClientTransactions."Transaction Sub Type 3"::Dividend;
        NarrationText:=FundTransactionManagement.GetNarration(NarrationTransType::"Dividend Reinvest");
        if NarrationText<>'' then
            ClientTransactions.Narration:=NarrationText+'-'+CurrQuarter
        else
           ClientTransactions.Narration:='Dividend Reinvest -'+CurrQuarter;
        ClientTransactions."Value Date":=ValueDate;
        ClientTransactions."Transaction Date":=Today;
        ClientTransactions.Validate("Account No",EOQLines."Account No");
        ClientTransactions.Validate("Client ID",EOQLines."Client ID");
        if Client.Get(EOQLines."Client ID") then;
        ClientTransactions."Fund Code":=EOQLines."Fund Code";

        ClientTransactions."Transaction No":=EOQLines."Header No";
        ClientTransactions.Amount:=EOQLines."Dividend Amount";
        ClientTransactions."No of Units":=FundAdministration.GetFundNounits(EOQLines."Fund Code",ValueDate,ClientTransactions.Amount,2);
        ClientTransactions."Price Per Unit":=FundAdministration.GetFundPrice(EOQLines."Fund Code",ValueDate,2);
        ClientTransactions.TestField("No of Units");
        //Nominee Dividend
        ClientTransactions."Portfolio Code" := EOQLines."Portfolio Code";
        ClientTransactions."Nominee Dividend" := EOQLines."Nominee Client";

        ClientTransactions."Agent Code":=Client."Account Executive Code";
        ClientTransactions."Created By":=UserId;
        ClientTransactions."Created Date Time":=CurrentDateTime;
        ClientTransactions.Insert(true);
    end;

    procedure SendEOQforverification(EOQHeader: Record "EOQ Header")
    var
        EOQLines: Record "EOQ Lines";
        EntryNo: Integer;
    begin
        if not Confirm(StrSubstNo('Are you sure you want to verify this EOQ %1 ?',EOQHeader.No)) then
          Error('');
        EOQLines.Reset;
        EOQLines.SetRange("Header No",EOQHeader.No);
        if not EOQLines.FindFirst then
         Error('There should be at least one line being verified');

        EOQHeader.Status:=EOQHeader.Status::"Internal Control";
        EOQHeader."DateTime Verified":=CurrentDateTime;
        EOQHeader.Modify;
        InsertEOQTracker(EOQHeader.Status,EOQHeader.No);
         Message('EOQ sent to Internal Control');
    end;

    procedure VerifyEOQ(EOQHeader: Record "EOQ Header")
    var
        EOQLines: Record "EOQ Lines";
        EntryNo: Integer;
    begin
        if not Confirm(StrSubstNo('Are you sure you want to verify this EOQ %1 ?',EOQHeader.No)) then
          Error('');

        Window.Open('Verifying Line #1#######');

        EOQLines.Reset;
        EOQLines.SetRange("Header No",EOQHeader.No);
        if EOQLines.FindFirst then
          repeat
            Window.Update(1,EOQLines."Line No");

            EOQLines.Verified:=true;
            EOQLines."DateTime Verified":=CurrentDateTime;
            EOQLines.Modify;
          until EOQLines.Next=0;

        EOQHeader.Status:=EOQHeader.Status::Verified;
        EOQHeader."DateTime Verified":=CurrentDateTime;
        EOQHeader.Modify;
        InsertEOQTracker(EOQHeader.Status,EOQHeader.No);
          Window.Close;
          Message('EOQ verified and forwarded for processing');
    end;

    procedure RejectEOQ(EOQHeader: Record "EOQ Header")
    var
        EOQLines: Record "EOQ Lines";
        EntryNo: Integer;
    begin

        EOQHeader.Status:=EOQHeader.Status::Generated;

        EOQHeader.Modify;
        InsertEOQTracker(EOQHeader.Status,EOQHeader.No);
        Message('EOQ returned to Operations');
    end;

    procedure InsertEOQTracker(newstatus: Option Generated,"Internal Control",Verified,"Sent to Treasury","Fully Processed";EOQNo: Code[20])
    var
        lineno: Integer;
    begin
        if EOQTracker2.FindLast then
          lineno:=EOQTracker2."Entry No"+1
        else
            lineno:=1;
        EOQTracker.Init;
        EOQTracker."Entry No":=lineno;
        EOQTracker.EOQ:=EOQNo;
        EOQTracker."Changed By":=UserId;
        EOQTracker."Date Time":=CurrentDateTime;
        EOQTracker.Status:=newstatus;
        EOQTracker.Insert;
    end;

    procedure ViewEOQTracker(EOQNo: Code[20])
    begin
        Clear(EOQTrackers);
        EOQTracker.FilterGroup(10);
        EOQTracker.SetRange(EOQ,EOQNo);
        EOQTracker.FilterGroup(0);
        EOQTrackers.SetTableView(EOQTracker);
        EOQTrackers.RunModal;
    end;

    procedure CloseQuarter(Quarters: Record Quarters)
    var
        IncomeRegister: Record "Income Register";
        DailyDistributableIncome: Record "Daily Distributable Income";
        DailyIncomeDistribLines: Record "Daily Income Distrib Lines";
        DailyIncDistribLinesPosted: Record "Daily Inc Distrib Lines Posted";
    begin
        if Quarters.Closed = true then
          Error('Quarter has already been Closed!!');

        EOQHeader.Reset;
        EOQHeader.SetRange(Quarter,Quarters.Code);
        if EOQHeader.FindFirst then begin
          if (EOQHeader.Status<>EOQHeader.Status::"Sent to Treasury") and (EOQHeader.Status<>EOQHeader.Status::"Fully Processed") then
            Error('EOQ for this Quarter has not been Fully Processed');
        end else
            Error('EOQ for this Quarter has not been run');

        if not Confirm(StrSubstNo('Are you sure you want to close Quarter %1 ?',Quarters.Code)) then
          Error('');

        Window.Open('Closing #1#######');
        Window.Update(1,'Income Registers');
        IncomeRegister.Reset;
        IncomeRegister.SetRange("Value Date",Quarters."Start Date",Quarters."End Date");
        if IncomeRegister.FindSet then
          IncomeRegister.ModifyAll("Quarter Closed",true,true);

        DailyDistributableIncome.Reset;
        DailyDistributableIncome.SetRange(Date,Quarters."Start Date",Quarters."End Date");
        if DailyDistributableIncome.FindFirst then
          repeat
            Window.Update(1,StrSubstNo('Date %1',Format(DailyDistributableIncome.Date)));
            DailyDistributableIncome."Quarter Closed":=true;
            DailyDistributableIncome."Date Closed":=CurrentDateTime;
            DailyDistributableIncome.Modify;
          until DailyDistributableIncome.Next = 0;

        Quarters.Closed:=true;
        Quarters."Date Closed":=CurrentDateTime;
        Quarters."Closed By":=UserId;
        Quarters.Modify;
        Window.Close;
        Message('Quarter Closed Successfully');
    end;

    procedure PostChargeOnInterest(ValueDate: Date;AcctNum: Code[40];Amount: Decimal;Price: Decimal;AmountChargedOn: Decimal)
    var
        DailyDistributableIncome: Record "Daily Distributable Income";
        DailyIncomeDistribLines: Record "Daily Income Distrib Lines";
        Client: Record Client;
        ClientAccount: Record "Client Account";
        Fund: Record Fund;
        Lineno: Integer;
        DailyDistributableIncome2: Record "Daily Distributable Income";
        DailyIncomeDistribLines2: Record "Daily Income Distrib Lines";
        EODTracker: Record "EOD Tracker";
        Quarters: Record Quarters;
        CurrentQuarter: Code[20];
    begin
        Quarters.Reset;
        Quarters.SetRange(Closed, false);
        if Quarters.FindFirst then
          CurrentQuarter := Quarters.Code;

        if DailyIncomeDistribLines2.FindLast then
          Lineno:=DailyIncomeDistribLines2."Line No" + 1
        else
          Lineno:=1;
        ClientAccount.Reset;
        ClientAccount.SetRange("Account No",AcctNum);
        if ClientAccount.FindFirst then begin
          DailyIncomeDistribLines.Init;
          DailyIncomeDistribLines.No:='IC004';
          DailyIncomeDistribLines."Value Date":=ValueDate;
          DailyIncomeDistribLines."Line No":=Lineno;
          DailyIncomeDistribLines."Account No":=ClientAccount."Account No";
          DailyIncomeDistribLines."Client ID":=ClientAccount."Client ID";
          DailyIncomeDistribLines."Client Name":=ClientAccount."Client Name";
          DailyIncomeDistribLines."Fund Code":=ClientAccount."Fund No";
          DailyIncomeDistribLines."Penalty Charge" := true;
          DailyIncomeDistribLines."Charges No" := Lineno;
          DailyIncomeDistribLines.Quarter := CurrentQuarter;
          DailyIncomeDistribLines."No of Units":=-Abs(Round(Amount,0.0001,'='));
          DailyIncomeDistribLines."Income Per unit":= 0;
          DailyIncomeDistribLines."Income accrued":=-Abs(Round(Amount,0.0001,'='));
          //IF DailyIncomeDistribLines."Income accrued"<0 THEN
          DailyIncomeDistribLines.Insert;
        end
    end;

    procedure PaidChargesToFundManagers(StartDate: Date;EndDate: Date)
    var
        AccruedCharges: Record "Charges on Accrued Interest";
    begin
        AccruedCharges.Reset;
        AccruedCharges.SetFilter("Value Date",'%1..%2',StartDate,EndDate);
        AccruedCharges.SetRange("Paid To Fund Managers",false);
        if AccruedCharges.FindSet then
          repeat
            AccruedCharges."Paid To Fund Managers" := true;
            AccruedCharges.Modify;
          until AccruedCharges.Next = 0;
    end;

    procedure ViewMFDistributedIncome(IncomeRegister: Record "Income Register")
    begin
        Clear(DailyIncomeDistribCard);
        MFDistributableIncome.FilterGroup(10);
        MFDistributableIncome.SetRange(Date,IncomeRegister."Value Date");
        MFDistributableIncome.SetRange("Fund Code",IncomeRegister."Fund ID");
        MFDistributableIncome.FilterGroup(0);
        MFIncomeDistribCard.SetTableView(MFDistributableIncome);
        MFIncomeDistribCard.RunModal;
    end;

    procedure ProcessMFPayment(Register: Record "Income Register")
    var
        Fund: Record Fund;
        ClientAccount: Record "Client Account";
        Client: Record Client;
        IncomeDistribLines: Record "MF Income Distrib Lines";
        PaymentHeader: Record "MF Payment Header";
        PaymentLines: Record "MF Payment Lines";
        Lineno: Integer;
        Quarters2: Record Quarters;
        ClientAccount2: Record "Client Account";
        Client2: Record Client;
        IncomeReg2: Record "Income Register";
        NetDividend: Decimal;
    begin
        IncomeReg2.Reset;
        IncomeReg2.SetRange("Value Date",Register."Value Date");
        IncomeReg2.SetRange("Fund ID",Register."Fund ID");
        IncomeReg2.SetRange(Distributed,false);
        if IncomeReg2.FindFirst then
          Error('Please distribute income for %1 on %2.',Register."Fund ID",Register."Value Date");


        Window.Open('Running Process for  #1#######');
        FundAdministrationSetup.Get;
        FundAdministrationSetup.TestField("Mutual Fund Payment Nos");
        Lineno:=0;
        Fund.Reset;
        // Fund.SETFILTER("Fund Code",'<>%1','ARMMMF');
        Fund.SetFilter("Fund Code",Register."Fund ID");
        //Fund.SETRANGE("Active Fund",TRUE);
        if Fund.FindFirst then
          repeat
            IncomeDistribLines.Reset;
            IncomeDistribLines.SetRange("Value Date",Register."Value Date");
            IncomeDistribLines.SetRange("Fully Paid",false);
            IncomeDistribLines.SetRange("Fund Code",Fund."Fund Code");
            if  IncomeDistribLines.FindFirst then begin
              PaymentHeader.Reset;
              PaymentHeader.SetRange("Fund Code",Fund."Fund Code");
              PaymentHeader.SetRange(Date,Register."Expected Payment Date");
              if PaymentHeader.FindFirst then begin
                PaymentHeader.TestField(Status, PaymentHeader.Status::Generated);
                PaymentHeader."Payment Date" :=Register."Expected Payment Date";
                PaymentHeader.Date := Today;
                PaymentHeader."Created By":=UserId;
                PaymentHeader."Creation Date":=Today;
                PaymentHeader."Fund Code":=Fund."Fund Code";
                PaymentHeader.Modify;
              end else begin
                PaymentHeader.Init;
                PaymentHeader.No:=NoSeriesManagement.GetNextNo(FundAdministrationSetup."Mutual Fund Payment Nos",Today,true);
                PaymentHeader."Payment Date" :=Register."Expected Payment Date";
                PaymentHeader.Date:= Today;
                PaymentHeader."Created By":=UserId;
                PaymentHeader."Creation Date":=Today;
                PaymentHeader."Fund Code":=Fund."Fund Code";
                PaymentHeader.Insert;
              end;

              PaymentLines.Reset;
              PaymentLines.SetRange("Header No",PaymentHeader.No);
              PaymentLines.DeleteAll;

              ClientAccount.Reset;
              ClientAccount.SetRange("Fund No",Fund."Fund Code");
              if ClientAccount.FindFirst then
                repeat
                 Window.Update(1,ClientAccount."Account No");
                  if Client.Get(ClientAccount."Client ID") then;
                  IncomeDistribLines.Reset;
                  IncomeDistribLines.SetCurrentKey("Account No","Value Date");
                  IncomeDistribLines.SetRange("Account No",ClientAccount."Account No");
                  IncomeDistribLines.SetRange("Value Date",Register."Value Date");
                  IncomeDistribLines.SetRange("Fully Paid",false);
                  IncomeDistribLines.CalcSums("Income accrued");

                  Lineno:=Lineno+1;

                  PaymentLines.Init;
                  PaymentLines."Header No":=PaymentHeader.No;
                  PaymentLines."Line No":=Lineno;
                  PaymentLines."Account No":=ClientAccount."Account No";
                  PaymentLines."Fund Code":=ClientAccount."Fund No";
                  PaymentLines."Client ID":=ClientAccount."Client ID";
                  PaymentLines."Client Name":=Client.Name;
                  PaymentLines."Bank Code":=ClientAccount."Bank Code";
                  PaymentLines."Bank Branch":=ClientAccount."Bank Branch";
                  PaymentLines."Bank Account":=ClientAccount."Bank Account Number";
                  PaymentLines."MF Income Batch No" := IncomeDistribLines.No;
                  PaymentLines."Portfolio Code" := ClientAccount."Portfolio Code";
                  PaymentLines."Tax Rate" := Register."WHT Rate";
                  PaymentLines."Tax Amount" := (Register."WHT Rate"/100)*IncomeDistribLines."Income accrued";
                  NetDividend := IncomeDistribLines."Income accrued"-PaymentLines."Tax Amount";
                  if (ClientAccount."Split Dividend") and (ClientAccount."Account No To Split To"<>'')  then begin
                    PaymentLines."Dividend Amount":=((100-ClientAccount."Split Percentage")/100)*NetDividend;
                      PaymentLines.Split:=true;
                      PaymentLines."Split to Account":=ClientAccount."Account No To Split To";
                      PaymentLines."Split Percentage":=100-ClientAccount."Split Percentage";
                  end
                  else
                    PaymentLines."Dividend Amount":= NetDividend;

                  PaymentLines."Dividend Mandate":=ClientAccount."Dividend Mandate";

                  PaymentLines."Total Dividend Earned":=IncomeDistribLines."Income accrued";
                  if PaymentLines."Dividend Amount">0 then
                    PaymentLines.Insert;

                 if (ClientAccount."Split Dividend") and (ClientAccount."Account No To Split To"<>'')  then begin
                   Lineno:=Lineno+1;
                   ClientAccount2.Reset;
                   if ClientAccount2.Get(ClientAccount."Account No To Split To") then ;
                          if Client2.Get(ClientAccount2."Client ID") then;
                    PaymentLines.Init;
                    PaymentLines."Header No":=PaymentHeader.No;
                    PaymentLines."Line No":=Lineno;
                    PaymentLines."Account No":=ClientAccount2."Account No";
                    PaymentLines."Fund Code":=ClientAccount2."Fund No";
                    PaymentLines."Client ID":=ClientAccount2."Client ID";
                    PaymentLines."Client Name":=Client2.Name;
                    PaymentLines."Bank Code":=ClientAccount2."Bank Code";
                    PaymentLines."Bank Branch":=ClientAccount2."Bank Branch";
                    PaymentLines."Bank Account":=ClientAccount2."Bank Account Number";
                    PaymentLines."Dividend Amount":=(ClientAccount."Split Percentage"/100)*IncomeDistribLines."Income accrued";
                     PaymentLines.Split:=true;
                     PaymentLines."Split Percentage":=ClientAccount."Split Percentage";
                    PaymentLines."Dividend Mandate":=ClientAccount2."Dividend Mandate";
                    if PaymentLines."Dividend Amount">0 then
                      PaymentLines.Insert;
                end
                until ClientAccount.Next=0;

            end;
          until Fund.Next=0;
         InsertMFPaymentTracker(PaymentHeader.Status,PaymentHeader.No);
         //Charges BEGIN
          //PaidChargesToFundManagers(Quarters."Start Date",Quarters."End Date");
        //END
          Window.Close;
        Message('Mutual Fund Payments generated successfully for verifications.')
    end;

    procedure InsertMFPaymentTracker(newstatus: Option Generated,"Internal Control",Verified,"Sent to Treasury","Fully Processed";MFNo: Code[20])
    var
        lineno: Integer;
        MFTracker: Record "MF Payment Tracker";
    begin
        if MFTracker.FindLast then
          lineno:=MFTracker."Entry No"+1
        else
            lineno:=1;
        MFTracker.Init;
        MFTracker."Entry No":=lineno;
        MFTracker.EOQ:=MFNo;
        MFTracker."Changed By":=UserId;
        MFTracker."Date Time":=CurrentDateTime;
        MFTracker.Status:=newstatus;
        MFTracker.Insert;
    end;

    procedure VerifyMFP(MFPHeader: Record "MF Payment Header")
    var
        MFPLines: Record "MF Payment Lines";
        EntryNo: Integer;
    begin
        if not Confirm(StrSubstNo('Are you sure you want to verify this Mutual Fund Payment %1 ?',MFPHeader.No)) then
          Error('');

        Window.Open('Verifying Line #1#######');

        MFPLines.Reset;
        MFPLines.SetRange("Header No",MFPHeader.No);
        if MFPLines.FindFirst then
          repeat
            Window.Update(1,MFPLines."Line No");

            MFPLines.Verified:=true;
            MFPLines."DateTime Verified":=CurrentDateTime;
            MFPLines.Modify;
          until MFPLines.Next=0;

        MFPHeader.Status:=MFPHeader.Status::Verified;
        MFPHeader."DateTime Verified":=CurrentDateTime;
        MFPHeader.Modify;
        InsertMFPaymentTracker(MFPHeader.Status,MFPHeader.No);
          Window.Close;
          Message('Mutual Fund Payment verified and forwarded for processing');
    end;

    procedure RejectMFP(MFPHeader: Record "MF Payment Header")
    var
        MFPLines: Record "MF Payment Lines";
        EntryNo: Integer;
    begin

        MFPHeader.Status:=MFPHeader.Status::Generated;

        MFPHeader.Modify;
        InsertEOQTracker(MFPHeader.Status,MFPHeader.No);
        Message('Mutual Fund Payment returned to Operations');
    end;

    local procedure ProcessMFPPayout(MFPLines: Record "MF Payment Lines";var EntryNo: Integer;ValueDate: Date;Narration: Text[100])
    var
        ClientTransactions: Record "Client Transactions";
        Client: Record Client;
        FeeAmount: Decimal;
        FeeUnit: Decimal;
    begin

        ClientTransactions.Init;
        ClientTransactions."Entry No":=EntryNo;
        ClientTransactions."Value Date":=ValueDate;
        ClientTransactions."Transaction Date":=Today;
        ClientTransactions.Validate("Account No",MFPLines."Account No");
        ClientTransactions.Validate("Client ID",MFPLines."Client ID");
        if Client.Get(MFPLines."Client ID") then;
        ClientTransactions."Fund Code":= MFPLines."Fund Code";
        ClientTransactions.Narration:= Narration; //'Dividend Payment - ' + FORMAT(ValueDate);
        ClientTransactions."Transaction Type":=ClientTransactions."Transaction Type"::Redemption;
        ClientTransactions."Transaction Sub Type":=ClientTransactions."Transaction Sub Type"::additional;
        ClientTransactions."Transaction Sub Type 2":=ClientTransactions."Transaction Sub Type 2"::"Dividend Payout";
        ClientTransactions."Transaction Sub Type 3" :=ClientTransactions."Transaction Sub Type 3"::Dividend;
        ClientTransactions."Transaction No":= MFPLines."Header No";
        //get fee amount and unit
        FeeAmount := Abs(FundAdministration.GetFee(MFPLines."Fund Code", MFPLines."Dividend Amount")) *-1;
        FeeUnit := Abs(FundAdministration.GetFundNounits(MFPLines."Fund Code",ValueDate,FeeAmount,ClientTransactions."Transaction Type"::Redemption)) *-1;
        ClientTransactions.Amount := Abs(MFPLines."Dividend Amount" - Abs(FeeAmount)) *-1;
        ClientTransactions."No of Units" := Abs(FundAdministration.GetFundNounits(MFPLines."Fund Code",ValueDate,ClientTransactions.Amount,2)) *-1;
        ClientTransactions."Price Per Unit":= FundAdministration.GetMFReinvestBidPrice(MFPLines."Fund Code",ValueDate,2);
        ClientTransactions."Agent Code":=Client."Account Executive Code";
        ClientTransactions."Created By":=UserId;
        ClientTransactions."Created Date Time":=CurrentDateTime;
        ClientTransactions."Transaction Source Document":=ClientTransactions."Transaction Source Document"::Redemption;
        if ClientTransactions.Amount<>0 then
        ClientTransactions.Insert(true);
        //fee
        EntryNo:=EntryNo+1;
        ClientTransactions.Init;
        ClientTransactions."Entry No":=EntryNo;
        ClientTransactions."Transaction Type":=ClientTransactions."Transaction Type"::Fee;
        ClientTransactions."Value Date":= ValueDate;
        ClientTransactions."Transaction Date":= Today;
        ClientTransactions.Validate("Account No",MFPLines."Account No");
        ClientTransactions.Validate("Client ID",MFPLines."Client ID");
        ClientTransactions."Fund Code":= MFPLines."Fund Code";
        ClientTransactions."Transaction Sub Type":=ClientTransactions."Transaction Sub Type"::additional;
        ClientTransactions."Transaction Sub Type 2":=ClientTransactions."Transaction Sub Type 2"::"Dividend Payout";
        ClientTransactions."Transaction Sub Type 3" :=ClientTransactions."Transaction Sub Type 3"::Dividend;
        ClientTransactions.Narration:='Bank Fee';// -'+FORMAT(ClientTransactions."Transaction Sub Type");
        ClientTransactions."Transaction No":= MFPLines."Header No";
        // ClientTransactions.Amount:= ABS(FundAdministration.GetFee(MFPLines."Fund Code", MFPLines."Total Dividend Earned")) *-1;
        // ClientTransactions."No of Units":= ABS(FundAdministration.GetFundNounits(MFPLines."Fund Code",ValueDate,ClientTransactions.Amount,ClientTransactions."Transaction Type"::Redemption)) *-1;
        ClientTransactions.Amount := Abs(FeeAmount) * -1;
        ClientTransactions."No of Units" := Abs(FeeUnit) *-1;
        ClientTransactions."Price Per Unit":= FundAdministration.GetMFReinvestBidPrice(MFPLines."Fund Code",ValueDate,2);
        ClientTransactions."Agent Code":= Client."Account Executive Code";
        ClientTransactions."Created By":=UserId;
        ClientTransactions."Created Date Time":=CurrentDateTime;
        ClientTransactions."Transaction Source Document":=ClientTransactions."Transaction Source Document"::Redemption;
        if ClientTransactions.Amount<>0 then
        ClientTransactions.Insert(true);
    end;

    procedure DistributeMFIncomeNew(IncomeRegister: Record "Income Register")
    var
        MFDistributableIncome: Record "MF Distributable Income";
        MFIncomeDistribLines: Record "MF Income Distrib Lines";
        Client: Record Client;
        ClientAccount: Record "Client Account";
        Fund: Record Fund;
        Lineno: Integer;
        MFDistributableIncome2: Record "MF Distributable Income";
        MFIncomeDistribLines2: Record "MF Income Distrib Lines";
        EODTracker: Record "EOD Tracker";
        EntryNo: Integer;
        countNo: Integer;
    begin
        IncomeRegister.TestField("Fund ID");
        IncomeRegister.TestField("Value Date");

        IncomeRegister.Reset;
        IncomeRegister.SetRange("Value Date");
        IncomeRegister.SetRange("Fund ID");

        if IncomeRegister."Value Date">Today then
          Error('You cannot Distribute Income for a future Date');
        if (IncomeRegister."Distributed Income"=0) and (IncomeRegister."Earnings Per Unit"=0) then
          Error('Please input Total Income Distributed or the earning per unit');


        EODTracker.Reset;
        EODTracker.SetRange(Date,IncomeRegister."Value Date");
        EODTracker.SetRange("Fund Code",IncomeRegister."Fund ID");
        if EODTracker.FindFirst then begin

        Window.Open('Distributing for client Account #1#######');
        Fund.Get(IncomeRegister."Fund ID");
        Fund.CalcFields("No of Units");
        FundAdministrationSetup.Get;
        FundAdministrationSetup.TestField("MF Distributable Income Nos");
        Lineno:=0;
        DailyDistributableIncome.Reset;
        DailyDistributableIncome.SetRange(Date,IncomeRegister."Value Date");
        DailyDistributableIncome.SetRange("Fund Code",IncomeRegister."Fund ID");
        if DailyDistributableIncome.FindFirst then begin

          DailyDistributableIncome.Date:=IncomeRegister."Value Date";
          DailyDistributableIncome."Fund Code":=IncomeRegister."Fund ID";
          DailyDistributableIncome."Daily Distributable Income":=IncomeRegister."Distributed Income";
          DailyDistributableIncome."Total Fund Units":=Round(Fund."No of Units",0.0004,'=');
          if IncomeRegister."Earnings Per Unit">0 then
             DailyDistributableIncome."Earnings Per Unit":=IncomeRegister."Earnings Per Unit"
          else
          DailyDistributableIncome."Earnings Per Unit":=Round(DailyDistributableIncome."Daily Distributable Income"/DailyDistributableIncome."Total Fund Units",0.000000000001,'=');
          DailyDistributableIncome.Modify;

          IncomeRegister."Earnings Per Unit":=DailyDistributableIncome."Earnings Per Unit";
          IncomeRegister.Modify

        end
        else begin

          MFDistributableIncome.Init;
          MFDistributableIncome.No:=NoSeriesManagement.GetNextNo(FundAdministrationSetup."MF Distributable Income Nos",Today,true);
          MFDistributableIncome.Date:=IncomeRegister."Value Date";
          MFDistributableIncome."Fund Code":=IncomeRegister."Fund ID";
          MFDistributableIncome."Daily Distributable Income":=IncomeRegister."Distributed Income";
          MFDistributableIncome."Total Fund Units":=Fund."No of Units";
          if IncomeRegister."Earnings Per Unit">0 then
             MFDistributableIncome."Earnings Per Unit":=IncomeRegister."Earnings Per Unit"
          else
          MFDistributableIncome."Earnings Per Unit":=Round(MFDistributableIncome."Daily Distributable Income"/MFDistributableIncome."Total Fund Units",0.000000000001,'=');
          MFDistributableIncome.Insert(true);
          IncomeRegister."Earnings Per Unit":=MFDistributableIncome."Earnings Per Unit";
          IncomeRegister.Modify
        end;

         MFIncomeDistribLines2.Reset;
         MFIncomeDistribLines2.SetRange(No,MFDistributableIncome.No);
         MFIncomeDistribLines2.DeleteAll;

         ClientAccount.Reset;
         ClientAccount.SetRange("Fund No",IncomeRegister."Fund ID");
         ClientAccount.SetFilter("Account Status",'<>%1',ClientAccount."Account Status"::Closed);
         //ClientAccount.SETFILTER("No of Units",'>%1',0);
         ClientAccount.SetFilter("Date Filter",'..%1',MFDistributableIncome.Date);
         if ClientAccount.FindFirst then
           repeat

             Window.Update(1,ClientAccount."Account No");
             ClientAccount.CalcFields("No of Units");
             Lineno:=Lineno+1;
             if Client.Get(ClientAccount."Client ID") then ;
             MFIncomeDistribLines.Init;
             MFIncomeDistribLines.No:=MFDistributableIncome.No;
             MFIncomeDistribLines."Value Date":=MFDistributableIncome.Date;
             MFIncomeDistribLines."Line No":=Lineno;
             MFIncomeDistribLines."Nominee Client" := ClientAccount."Nominee Client";
             MFIncomeDistribLines."Portfolio Code" := ClientAccount."Portfolio Code";
             MFIncomeDistribLines."Account No":=ClientAccount."Account No";
             MFIncomeDistribLines."Client ID":=ClientAccount."Client ID";
             MFIncomeDistribLines."Client Name":=Client.Name;
             MFIncomeDistribLines."Fund Code":=ClientAccount."Fund No";
             MFIncomeDistribLines."No of Units":= ClientAccount."No of Units";
             MFIncomeDistribLines."Income Per unit":= MFDistributableIncome."Earnings Per Unit";
             MFIncomeDistribLines."Income accrued":= MFIncomeDistribLines."No of Units"*MFIncomeDistribLines."Income Per unit";
            if MFIncomeDistribLines."Income accrued">0 then
             MFIncomeDistribLines.Insert;
            //insert method to write dividend to client transaction
            if MFIncomeDistribLines."Income accrued" <> 0 then begin
            EntryNo:=0;
             EntryNo:=FundTransactionManagement.GetLastTransactionNo;
             EntryNo:=EntryNo+1;
            MFPostDividend(MFIncomeDistribLines,EntryNo,MFIncomeDistribLines."Value Date");
            end;
           until ClientAccount.Next=0;
           Window.Close;
         end else
          Error('Please, run EOD for %1 before distributing income.',IncomeRegister."Value Date");
    end;

    local procedure MFPostDividend(MFLines: Record "MF Income Distrib Lines";EntryNo: Integer;ValueDate: Date)
    var
        ClientTransactions: Record "Client Transactions";
        NarrationText: Text;
        Client: Record Client;
    begin
        ClientTransactions.Init;
        ClientTransactions."Entry No":=EntryNo;
        ClientTransactions."Transaction Type":=ClientTransactions."Transaction Type"::Dividend;
        ClientTransactions."Transaction Sub Type":=ClientTransactions."Transaction Sub Type"::additional;
        ClientTransactions."Transaction Sub Type 2":=ClientTransactions."Transaction Sub Type 2"::"Dividend Declared";
        ClientTransactions."Transaction Sub Type 3" :=ClientTransactions."Transaction Sub Type 3"::Dividend;
        ClientTransactions.Narration:='Dividend Declared';
        ClientTransactions."Value Date":=ValueDate;
        ClientTransactions."Transaction Date":=Today;
        ClientTransactions.Validate("Account No",MFLines."Account No");
        ClientTransactions.Validate("Client ID",MFLines."Client ID");
        if Client.Get(MFLines."Client ID") then;
        ClientTransactions."Fund Code":=MFLines."Fund Code";

        ClientTransactions."Transaction No":=MFLines.No;
        // ClientTransactions.Amount:=MFPLines."Dividend Amount";
        ClientTransactions.Amount:=MFLines."Income accrued";
        ClientTransactions."No of Units":= 0;//FundAdministration.GetFundNounits(MFLines."Fund Code",ValueDate,ClientTransactions.Amount,2);
        // IF ClientTransactions."No of Units" = 0 THEN
        //  EXIT;
        //ClientTransactions."Price Per Unit":=FundAdministration.GetFundPrice(MFLines."Fund Code",ValueDate,2);
        //ClientTransactions.TESTFIELD("No of Units");
        ClientTransactions."Agent Code":=Client."Account Executive Code";
        ClientTransactions."Created By":=UserId;
        ClientTransactions."Created Date Time":=CurrentDateTime;
        ClientTransactions.Insert(true);
    end;

    local procedure MFPReinvestNew(MFPLines: Record "MF Payment Lines";EntryNo: Integer;ValueDate: Date)
    var
        ClientTransactions: Record "Client Transactions";
        NarrationText: Text;
        Client: Record Client;
    begin
        ClientTransactions.Init;
        ClientTransactions."Entry No":=EntryNo;
        ClientTransactions."Transaction Type":=ClientTransactions."Transaction Type"::Subscription;
        ClientTransactions."Transaction Sub Type":=ClientTransactions."Transaction Sub Type"::additional;
        ClientTransactions."Transaction Sub Type 2":=ClientTransactions."Transaction Sub Type 2"::"Dividend ReInvestment";
        ClientTransactions."Transaction Sub Type 3" :=ClientTransactions."Transaction Sub Type 3"::Dividend;
        // NarrationText:=FundTransactionManagement.GetNarration(NarrationTransType::"Dividend Reinvest");
        // IF NarrationText<>'' THEN
        //    ClientTransactions.Narration:=NarrationText+'-'+CurrQuarter
        // ELSE
        ClientTransactions.Narration:='Dividend Income';
        ClientTransactions."Value Date":=ValueDate;
        ClientTransactions."Transaction Date":=Today;
        ClientTransactions.Validate("Account No",MFPLines."Account No");
        ClientTransactions.Validate("Client ID",MFPLines."Client ID");
        if Client.Get(MFPLines."Client ID") then;
        ClientTransactions."Fund Code":=MFPLines."Fund Code";

        ClientTransactions."Transaction No":=MFPLines."Header No";
         ClientTransactions.Amount:=MFPLines."Total Dividend Earned";
        ClientTransactions."No of Units":=FundAdministration.GetFundNounits(MFPLines."Fund Code",ValueDate,ClientTransactions.Amount,2);
        if ClientTransactions."No of Units" = 0 then
          exit;
        //ClientTransactions."Price Per Unit":=FundAdministration.GetFundPrice(MFPLines."Fund Code",ValueDate,2);
        ClientTransactions."Price Per Unit":=FundAdministration.GetMFReinvestBidPrice(MFPLines."Fund Code",ValueDate,2);
        ClientTransactions.TestField("No of Units");

        ClientTransactions."Agent Code":=Client."Account Executive Code";
        ClientTransactions."Created By":=UserId;
        ClientTransactions."Created Date Time":=CurrentDateTime;
        ClientTransactions.Insert(true);

        //fees
        if MFPLines."Tax Rate" > 0 then begin
        ClientTransactions.Init;
        ClientTransactions."Entry No":=EntryNo +1;
        ClientTransactions."Transaction Type":=ClientTransactions."Transaction Type"::Fee;
        ClientTransactions."Transaction Sub Type":=ClientTransactions."Transaction Sub Type"::additional;
        ClientTransactions."Transaction Sub Type 2":=ClientTransactions."Transaction Sub Type 2"::"Dividend ReInvestment";
        ClientTransactions."Transaction Sub Type 3" :=ClientTransactions."Transaction Sub Type 3"::Dividend;
        ClientTransactions.Narration:='WHT tax on dividend';
        ClientTransactions."Value Date":=ValueDate;
        ClientTransactions."Transaction Date":=Today;
        ClientTransactions.Validate("Account No",MFPLines."Account No");
        ClientTransactions.Validate("Client ID",MFPLines."Client ID");
        if Client.Get(MFPLines."Client ID") then;
        ClientTransactions."Fund Code":=MFPLines."Fund Code";

        ClientTransactions."Transaction No":=MFPLines."Header No";
        // ClientTransactions.Amount:=MFPLines."Dividend Amount";
        ClientTransactions.Amount:= -Abs(MFPLines."Tax Amount");
        ClientTransactions."No of Units":=-Abs(FundAdministration.GetFundNounits(MFPLines."Fund Code",ValueDate,ClientTransactions.Amount,2));
        if ClientTransactions."No of Units" = 0 then
          exit;
        ClientTransactions."Price Per Unit":=FundAdministration.GetMFReinvestBidPrice(MFPLines."Fund Code",ValueDate,2);
        ClientTransactions.TestField("No of Units");

        ClientTransactions."Agent Code":=Client."Account Executive Code";
        ClientTransactions."Created By":=UserId;
        ClientTransactions."Created Date Time":=CurrentDateTime;
        ClientTransactions.Insert(true);
        end;

        //set dividend paid to true on client transaction
         //IF MFPLines."Dividend Mandate" = MFPLines."Dividend Mandate"::Reinvest THEN BEGIN
          ClientTransact.Reset;
          ClientTransact.SetRange("Client ID",MFPLines."Client ID");
          ClientTransact.SetRange("Account No",MFPLines."Account No");
          ClientTransact.SetRange("Transaction No",MFPLines."MF Income Batch No");
          ClientTransact.SetRange("Transaction Type", ClientTransact."Transaction Type"::Dividend);
          ClientTransact.SetRange("Dividend Paid",false);
          if ClientTransact.FindFirst then begin
            ClientTransact."Dividend Paid" := true;
            ClientTransact.Modify(true);
            end;
          //END;
    end;

    procedure SendMFPtoTreasuryNew(MFPHeader: Record "MF Payment Header")
    var
        MFPLines: Record "MF Payment Lines";
        EntryNo: Integer;
        MFPLines2: Record "MF Payment Lines";
        IncomeDistributionLines: Record "MF Income Distrib Lines";
        DeclearedDate: Date;
    begin
        if not Confirm(StrSubstNo('Are you sure you want Process to this Mutual Fund payment %1 ? Please note that any account without Dividend mandate will be automatically Reinvested',MFPHeader.No)) then
          Error('');
        Window.Open('Processing Line #1#######');
        MFPLines.Reset;
        MFPLines.SetRange("Header No",MFPHeader.No);
        MFPLines.SetRange(MFPLines.Verified,true);
        MFPLines.SetRange(Processed,false);
        if MFPLines.FindFirst then
          repeat
            EntryNo:=0;
            EntryNo:=FundTransactionManagement.GetLastTransactionNo;
            Window.Update(1,MFPLines."Line No");
            EntryNo:=EntryNo+1;
            MFPReinvestNew(MFPLines,EntryNo,MFPHeader."Payment Date");
            if (MFPLines."Dividend Mandate" = MFPLines."Dividend Mandate"::Payout) and (MFPLines."Dividend Amount" > 500) then begin
              EntryNo:=0;
              EntryNo:=FundTransactionManagement.GetLastTransactionNo;
              EntryNo:=EntryNo+1;
              ProcessMFPPayout(MFPLines,EntryNo,MFPHeader."Payment Date", MFPHeader.Narration);
              end;
            MFPLines.Processed:=true;
            MFPLines."DateTime Processed":=CurrentDateTime;
            MFPLines.Modify;
            IncomeDistributionLines.Reset;
            IncomeDistributionLines.SetRange(No,MFPLines."MF Income Batch No");
            IncomeDistributionLines.SetRange("Client ID",MFPLines."Client ID");
            IncomeDistributionLines.SetRange("Account No",MFPLines."Account No");
            IncomeDistributionLines.SetRange(Processed,false);
            if IncomeDistributionLines.FindFirst then begin
              IncomeDistributionLines.Processed := true;
              IncomeDistributionLines."Date Processed" := Today;
              IncomeDistributionLines.Modify;
            end;
          until MFPLines.Next=0;
        MFPHeader.Status:=MFPHeader.Status::"Sent to Treasury";
        MFPHeader."DateTime Verified":=CurrentDateTime;
        MFPHeader.Modify;
        //InsertMFTranscations(MFPHeader);
        InsertMFPaymentTracker(MFPHeader.Status,MFPHeader.No);
          Window.Close;
          MFPaymentSummary(MFPLines."Fund Code",MFPHeader.No,MFPHeader."Payment Date",IncomeDistributionLines."Value Date");
          //MFPaymentSummaryReinvest(MFPLines."Fund Code",MFPHeader.No,MFPHeader."Payment Date",IncomeDistributionLines."Value Date");
          MFReinvestmentSummary(MFPLines."Fund Code",MFPHeader.No,MFPHeader."Payment Date",IncomeDistributionLines."Value Date");
          MFReinvestmentSummary2(MFPLines."Fund Code",MFPHeader.No,MFPHeader."Payment Date",IncomeDistributionLines."Value Date");
        Message('Mutual Funds Dividend processed successfully');
    end;

    local procedure MFPaymentSummary(fundcode: Code[10];headerNo: Code[20];paymentDate: Date;declearedDate: Date)
    var
        MFPayment: Record "MF Payment Lines";
        MFdividend: Record "MF Dividend";
        Portfolio: Record Portfolio;
        MFPayment2: Record "MF Payment Lines";
        MFdividend2: Record "MF Dividend";
        Portfolio2: Record Portfolio;
    begin
        //Payout
        Portfolio.Reset;
        if Portfolio.FindFirst then begin
          repeat
        MFPayment.Reset;
        MFPayment.SetRange("Fund Code",fundcode);
        MFPayment.SetRange("Header No",headerNo);
        //MFPayment.SETRANGE("Dividend Mandate",MFPayment."Dividend Mandate"::Payout);
        MFPayment.SetFilter("Dividend Mandate",'%1|%2',MFPayment."Dividend Mandate"::" ",MFPayment."Dividend Mandate"::Reinvest);
        MFPayment.SetRange("Portfolio Code",Portfolio."Portfolio Code");
        //MFPayment.SETRANGE("Dividend Amount",'>,500);
        if MFPayment.FindSet then begin
        MFPayment.CalcSums("Dividend Amount");
        MFPayment.CalcSums("Tax Amount");
        MFdividend.Init;
        if MFdividend.FindLast then begin
          MFdividend.No := MFdividend.No + 1;
          end else begin
          MFdividend.No := 1;
          end;
          MFdividend.PortfolioCode := Portfolio."Portfolio Code";
          MFdividend.FundCode := fundcode;
          MFdividend.AssetClassId := Portfolio."Instrument Id";
          MFdividend.DeclaredDate := declearedDate;
          MFdividend.TransactionDate := paymentDate;
          MFdividend.Amount := MFPayment."Dividend Amount";
          MFdividend.ReinvestmentPrice := FundAdministration.GetMFReinvestBidPrice(fundcode,paymentDate,2);
          MFdividend.Unit := MFdividend.Amount/MFdividend.ReinvestmentPrice;
          MFdividend.TaxAmount := MFPayment."Tax Amount";
          MFdividend.IsReinvestment := true;
          MFdividend.CreatedDate := Today;
        //  MFdividend.BankAccountNo := '';
          MFdividend.Insert(true);
          end;
          until Portfolio.Next = 0;
          end;
    end;

    local procedure MFReinvestmentSummary(fundcode: Code[10];headerNo: Code[20];paymentDate: Date;declearedDate: Date)
    var
        MFPayment: Record "MF Payment Lines";
        MFReinvest: Record "MF Dividend Reinvest Summary";
        Portfolio: Record Portfolio;
        Price: Decimal;
        FundBankAccount: Record "Fund Bank Accounts";
    begin
        // Portfolio.RESET;
        // IF Portfolio.FINDFIRST THEN BEGIN
        //  REPEAT
        MFPayment.Reset;
        MFPayment.SetRange("Fund Code",fundcode);
        MFPayment.SetRange("Header No",headerNo);
        MFPayment.SetFilter("Dividend Mandate",'%1|%2',MFPayment."Dividend Mandate"::" ",MFPayment."Dividend Mandate"::Reinvest);
        // MFPayment.SETRANGE("Dividend Mandate",MFPayment."Dividend Mandate"::Reinvest);
        //MFPayment.SETRANGE("Portfolio Code",Portfolio."Portfolio Code");//MFReinvestmentSummary
        //MFPayment.SETRANGE("Dividend Amount",'>,500);
        if MFPayment.FindSet then begin
        MFPayment.CalcSums("Dividend Amount");
        MFPayment.CalcSums("Tax Amount");
        MFReinvest.Init;
        if MFReinvest.FindLast then begin
          MFReinvest.No := MFReinvest.No + 1;
          end else begin
          MFReinvest.No := 1;
          end;
          //MFReinvest.PortfolioCode := Portfolio."Portfolio Code";
          MFReinvest.FundCode := fundcode;
          //MFReinvest.AssetClassId := Portfolio."Instrument Id";
          MFReinvest.DeclaredDate := declearedDate;
          MFReinvest.TransactionDate := paymentDate;
          MFReinvest.Amount := MFPayment."Dividend Amount";
          Price := FundAdministration.GetMFReinvestBidPrice(fundcode,paymentDate,2);
          MFReinvest.Unit := MFReinvest.Amount/Price;
          MFReinvest.TaxAmount := MFPayment."Tax Amount";
          MFReinvest.IsReinvestment := true;
          MFReinvest.CreatedDate := Today;
          FundBankAccount.Reset;
          FundBankAccount.SetRange("Fund Code",MFReinvest.FundCode);
          FundBankAccount.SetRange("Transaction Type",FundBankAccount."Transaction Type"::Redemption);
          if FundBankAccount.FindFirst then
          MFReinvest."Bank Account No" := FundBankAccount."Bank Account No";
          MFReinvest.Insert(true);
          end;
        //  UNTIL Portfolio.NEXT = 0;
        //  END;
    end;

    local procedure MFReinvestmentSummary2(fundcode: Code[10];headerNo: Code[20];paymentDate: Date;declearedDate: Date)
    var
        MFPayment: Record "MF Payment Lines";
        MFReinvest: Record "MF Dividend Reinvest Summary";
        Portfolio: Record Portfolio;
        Price: Decimal;
        FundBankAccount: Record "Fund Bank Accounts";
    begin
        // Portfolio.RESET;
        // IF Portfolio.FINDFIRST THEN BEGIN
        //  REPEAT
        MFPayment.Reset;
        MFPayment.SetRange("Fund Code",fundcode);
        MFPayment.SetRange("Header No",headerNo);
        MFPayment.SetRange("Dividend Mandate",MFPayment."Dividend Mandate"::Payout);
        //MFPayment.SETFILTER("Dividend Mandate",'%1|%2',MFPayment."Dividend Mandate"::" ",MFPayment."Dividend Mandate"::Reinvest);
        // MFPayment.SETRANGE("Dividend Mandate",MFPayment."Dividend Mandate"::Reinvest);
        //MFPayment.SETRANGE("Portfolio Code",Portfolio."Portfolio Code");
        //MFPayment.SETRANGE("Dividend Amount",'>,500);
        if MFPayment.FindSet then begin
        MFPayment.CalcSums("Dividend Amount");
        MFPayment.CalcSums("Tax Amount");
        MFReinvest.Init;
        if MFReinvest.FindLast then begin
          MFReinvest.No := MFReinvest.No + 1;
          end else begin
          MFReinvest.No := 1;
          end;
          //MFReinvest.PortfolioCode := Portfolio."Portfolio Code";
          MFReinvest.FundCode := fundcode;
          //MFReinvest.AssetClassId := Portfolio."Instrument Id";
          MFReinvest.DeclaredDate := declearedDate;
          MFReinvest.TransactionDate := paymentDate;
          MFReinvest.Amount := MFPayment."Dividend Amount";
          Price := FundAdministration.GetMFReinvestBidPrice(fundcode,paymentDate,2);
          MFReinvest.Unit := MFReinvest.Amount/Price;
          MFReinvest.TaxAmount := MFPayment."Tax Amount";
          MFReinvest.IsReinvestment := false;
          MFReinvest.CreatedDate := Today;
          FundBankAccount.Reset;
          FundBankAccount.SetRange("Fund Code",MFReinvest.FundCode);
          FundBankAccount.SetRange("Transaction Type",FundBankAccount."Transaction Type"::Subscription);
          if FundBankAccount.FindFirst then
          MFReinvest."Bank Account No" := FundBankAccount."Bank Account No";
          MFReinvest.Insert(true);
          end;
        //  UNTIL Portfolio.NEXT = 0;
        //  END;
    end;

    procedure GenerateIncomeLines(DailyDistributableIncome: Record "Daily Distributable Income")
    var
        DailyIncomeDistribLines: Record "Daily Income Distrib Lines";
        Client: Record Client;
        ClientAccount: Record "Client Account";
        Fund: Record Fund;
        Lineno: Integer;
        DailyDistributableIncome2: Record "Daily Distributable Income";
        DailyIncomeDistribLines2: Record "Daily Income Distrib Lines";
        EODTracker: Record "EOD Tracker";
        IncomeRegister: Record "Income Register";
        Quarters: Record Quarters;
        CurrentQuarter: Code[20];
    begin
        DailyDistributableIncome.TestField(Date);
        DailyDistributableIncome.TestField("Fund Code");

        Quarters.Reset;
        Quarters.SetRange(Closed, false);
        if Quarters.FindFirst then
          CurrentQuarter := Quarters.Code;

        IncomeRegister.Reset;
        IncomeRegister.SetRange("Value Date", DailyDistributableIncome.Date);
        IncomeRegister.SetRange("Fund ID", DailyDistributableIncome."Fund Code");
        if IncomeRegister."Value Date">Today then
          Error('You cannot Distribute Income for a future Date');
        if (DailyDistributableIncome."Daily Distributable Income" = 0) and (DailyDistributableIncome."Earnings Per Unit" = 0) then
          Error('Please input Total Income Distributed or the earning per unit');

        //Maxwell: To check if EOD has been run before distributing income.

        EODTracker.Reset;
        EODTracker.SetRange(Date,DailyDistributableIncome.Date);
        EODTracker.SetRange("Fund Code",DailyDistributableIncome."Fund Code");
        if EODTracker.FindFirst then begin

          Window.Open('Distributing for client Account #1#######');
          Fund.Get(DailyDistributableIncome."Fund Code");
          Fund.CalcFields("No of Units");
          FundAdministrationSetup.Get;
          FundAdministrationSetup.TestField("Daily Distributable Income Nos");
          Lineno:=0;
          DailyDistributableIncome.CalcFields("Reversed Dividend");
          if DailyDistributableIncome."Total Fund Units" <> Fund."No of Units" then begin
            DailyDistributableIncome."Total Fund Units" := Fund."No of Units";
        //    DailyDistributableIncome."Earnings Per Unit" := ROUND(DailyDistributableIncome."Daily Distributable Income"/ROUND(Fund."No of Units",0.0004,'='),0.000000000001,'=');
        DailyDistributableIncome."Earnings Per Unit" := Round((DailyDistributableIncome."Daily Distributable Income"+DailyDistributableIncome."Reversed Dividend") /Round(Fund."No of Units",0.0004,'='),0.000000000001,'=');
          end;

          DailyIncomeDistribLines2.Reset;
          DailyIncomeDistribLines2.SetRange(No,DailyDistributableIncome.No);
          DailyIncomeDistribLines2.DeleteAll;

          ClientAccount.Reset;
          ClientAccount.SetRange("Fund No",DailyDistributableIncome."Fund Code");
          ClientAccount.SetFilter("Account Status",'<>%1',ClientAccount."Account Status"::Closed);
          ClientAccount.SetFilter("No of Units", '>%1', 0);
          ClientAccount.SetFilter("Date Filter",'..%1',DailyDistributableIncome.Date);
          if ClientAccount.FindFirst then
            repeat
              Window.Update(1,ClientAccount."Account No");
              ClientAccount.CalcFields("No of Units");
              Lineno:=Lineno+1;
              if Client.Get(ClientAccount."Client ID") then ;
              DailyIncomeDistribLines.Init;
              DailyIncomeDistribLines.No:=DailyDistributableIncome.No;
              DailyIncomeDistribLines."Value Date":=DailyDistributableIncome.Date;
              DailyIncomeDistribLines."Line No":=Lineno;
              DailyIncomeDistribLines.Quarter := CurrentQuarter;
              //Maxwell: Identify Nominee Clients
              DailyIncomeDistribLines."Nominee Client" := ClientAccount."Nominee Client";
              DailyIncomeDistribLines."Portfolio Code" := ClientAccount."Portfolio Code";
              //
              DailyIncomeDistribLines."Account No":=ClientAccount."Account No";
              DailyIncomeDistribLines."Client ID":=ClientAccount."Client ID";
              DailyIncomeDistribLines."Client Name":=Client.Name;
              DailyIncomeDistribLines."Fund Code":=ClientAccount."Fund No";
              DailyIncomeDistribLines."No of Units":=Round(ClientAccount."No of Units",0.0001,'=');
              DailyIncomeDistribLines."Income Per unit":=Round(DailyDistributableIncome."Earnings Per Unit",0.000000000001,'=');
              DailyIncomeDistribLines."Income accrued":=Round(DailyIncomeDistribLines."No of Units"*DailyIncomeDistribLines."Income Per unit",0.0001,'=');
             if DailyIncomeDistribLines."Income accrued">0 then
              DailyIncomeDistribLines.Insert;
            until ClientAccount.Next=0;

            Window.Close;
        end else
          Error('Please, run EOD for %1 before distributing income.',DailyDistributableIncome.Date)
    end;

    procedure GetQuarter(DateExpr: Text;RefDate: Date): Code[20]
    var
        Month: Integer;
        CurrYear: Integer;
        Quatr: Code[20];
        ExpectedDate: Date;
    begin
        ExpectedDate := CalcDate(DateExpr, RefDate);
        Month := Date2DMY(ExpectedDate,2);
        CurrYear := Date2DMY(ExpectedDate,3);
        case Month of
         1..3:
           Quatr := 'Q1';
         4..6:
           Quatr := 'Q2';
         7..9:
          Quatr := 'Q3';
        else
           Quatr := 'Q4';
        end;

        exit(Quatr + ' ' + Format(CurrYear))
    end;

    procedure CreateNewQuarter(CreationDate: Date)
    var
        NewQuarter: Record Quarters;
    begin
        with NewQuarter do begin
          Init;
          Code := GetQuarter('<CQ>', CreationDate);
          Description := 'ARMMMF ' + Code;
          "Start Date" := CalcDate('<-CQ>');
          "End Date" := CalcDate('<CQ>');
          if Insert(true) then
            Message('%1 created', Code)
        end;
    end;

    procedure ArchiveQuarterIncomeLine(StartDate: Date;EndDate: Date)
    var
        DailyDistributedIncomeLine: Record "Daily Income Distrib Lines";
        ArchivedIncomeLines: Record "Daily Inc Distrib Lines Posted";
    begin
        DailyDistributedIncomeLine.Reset;
        DailyDistributedIncomeLine.SetFilter("Value Date", '%1..%2', StartDate, EndDate);
        if DailyDistributedIncomeLine.FindFirst then
          repeat
            ArchivedIncomeLines.TransferFields(DailyDistributedIncomeLine);
            ArchivedIncomeLines.Insert;
          until DailyDistributedIncomeLine.Next = 0;

        DailyDistributedIncomeLine.DeleteAll;
        Message('Done');

    end;
}

