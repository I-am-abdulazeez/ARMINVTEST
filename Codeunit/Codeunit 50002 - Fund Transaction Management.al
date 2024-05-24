codeunit 50002 "Fund Transaction Management"
{

    trigger OnRun()
    begin
    end;

    var
        FundAdministrationSetup: Record "Fund Administration Setup";
        NoSeriesManagement: Codeunit NoSeriesManagement;
        Window: Dialog;
        NarrationText: Text;
        NarrationTransType: Option " ","Subscription Initial","Subscription Additional","Redemption Part","Redemption Full","Account Transfer","Dividend Reinvest";
        FundAdministration: Codeunit "Fund Administration";
        FundPayoutCharges: Record "Fund Payout Charges";
        ClientAccount: Record "Client Account";
        EODTracker: Record "EOD Tracker";
        SubscriptionMatchingheader: Record "Subscription Matching header";
        Redemption2: Record Redemption;
        NotificationFunctions: Codeunit "Notification Functions";
        AccruedInterestCharge: Record "Charges on Accrued Interest";
        AccruedInterestCharge2: Record "Charges on Accrued Interest";
        AmountChargedOn: Decimal;
        FundProcessing: Codeunit "Fund Processing";
        ExternalSeviceCall: Codeunit ExternalCallService;
        Bank: Record "Fund Bank Accounts";
        resp: Boolean;
        Fund: Record Fund;

    procedure ValidateSubscription(Subscription: Record Subscription)
    var
        PostedSubscription: Record "Posted Subscription";
        Caution: Record "Client Cautions";
    begin
        Subscription.TestField("Account No");
        Subscription.TestField("Client ID");
        Subscription.TestField("Fund Code");
        Subscription.TestField(Amount);
        Subscription.TestField("No. Of Units");
        Subscription.TestField("Price Per Unit");
        //IF NOT Subscription.AutoMatched THEN
        if Subscription."Automatch Ref" <> '' then begin
        PostedSubscription.Reset;
        PostedSubscription.SetRange("Reference Code",Subscription."Automatch Ref");
        if PostedSubscription.FindFirst then Error('Similar Transaction Reference ID (%1) is already posted',Subscription."Automatch Ref");
        end;
        
        /*IF (Subscription."Direct Posting") THEN BEGIN
          IF (Subscription."Fund Code" = 'ARMSTBF') OR (Subscription."Fund Code" = 'ARMFIF') OR (Subscription."Fund Code" = 'ARMEURO') THEN
            ERROR('This request will not be processed today because of reinvestment');
        END;*/
        
        Caution.Reset;
        Caution.SetRange("Account No", Subscription."Account No");
        Caution.SetRange(Status, Caution.Status::Verified);
        if Caution.FindFirst and ((Caution."Restriction Type" = Caution."Restriction Type"::"Restrict Both") or (Caution."Restriction Type" = Caution."Restriction Type"::"Restrict Subscription")) then
          Error('This account %1 is under caution', Subscription."Account No");
        
        
        ValidateValuedateAgainstPrice(Subscription."Value Date",Subscription."Fund Code",'Subscription No',Subscription.No);
        if Subscription."Price Per Unit"<>FundAdministration.GetFundPrice(Subscription."Fund Code",Subscription."Value Date",0) then
          Error('The Price you are using is not updated. Please update prices for subscription');
        if (Subscription."Created By"=UserId) and not Subscription.AutoMatched then  begin
          Window.Close;
          Error('You cannot post a transaction that you Created!!');
          end;
        if CheckifSubscriptionEntriesExist(Subscription.No) then
          Error('Unreversed Transactions exist for this Subscription No %1',Subscription.No);

    end;

    procedure PostBatchSubscription()
    var
        Subscription: Record Subscription;
        EntryNo: Integer;
    begin
        if not Confirm('Are you sure you want to post these Subscriptions?') then
          Error('');
        EntryNo:=0;
        EntryNo:=GetLastTransactionNo;
        Window.Open('Posting Subscription No #1#######');
        Subscription.Reset;
        Subscription.SetRange(Select,true);
        //Subscription.SETRANGE("Selected By",USERID);
        Subscription.SetRange("Subscription Status",Subscription."Subscription Status"::Confirmed);
        if Subscription.FindFirst then begin
          repeat
            Window.Update(1,Subscription.No);
            EntryNo:=EntryNo+1;
           ValidateSubscription(Subscription);
           FundAdministration.InsertSubscriptionTracker(2,Subscription.No);
           PostSubscription(Subscription,EntryNo);

          until Subscription.Next=0
          end  else
          Error('There is nothing to post');
          Window.Close;
         Message('Subscription Posting Process Complete');
    end;

    procedure PostSingleSubscription(Subscription: Record Subscription)
    var
        EntryNo: Integer;
    begin
        if not Confirm('Are you sure you want to post these Subscriptions?') then
          Error('');
        EntryNo:=0;
        EntryNo:=GetLastTransactionNo;
        Window.Open('Posting Subscription No #1#######');
        Window.Update(1,Subscription.No);
        EntryNo:=EntryNo+1;
        ValidateSubscription(Subscription);
        PostSubscription(Subscription,EntryNo);

        Window.Close;
        Message('Subscription Posting Process Complete');
    end;

    procedure PostSTPSubscription(Subscription: Record Subscription)
    var
        EntryNo: Integer;
    begin

        EntryNo:=0;
        EntryNo:=GetLastTransactionNo;

        EntryNo:=EntryNo+1;
        ValidateSubscription(Subscription);
        PostSubscription(Subscription,EntryNo);
    end;

    procedure PostSubscription(Subscription: Record Subscription;EntryNo: Integer)
    var
        ClientTransactions: Record "Client Transactions";
    begin
        FundAdministration.InsertSubscriptionTracker(2,Subscription.No);
        Fund.Reset;
        ClientTransactions.Init;
        ClientTransactions."Entry No":=EntryNo;
        ClientTransactions."Transaction Type":=ClientTransactions."Transaction Type"::Subscription;
        ClientTransactions."Value Date":=Subscription."Value Date";
        ClientTransactions."Transaction Date":=Subscription."Transaction Date";
        ClientTransactions.Validate("Account No",Subscription."Account No");
        ClientTransactions.Validate("Client ID",Subscription."Client ID");
        ClientTransactions."Fund Code":=Subscription."Fund Code";
        //Maxwell: Holding Period for subscriptions.
        /*IF Fund.GET(Subscription."Fund Code") THEN
          IF Fund."Percentage Penalty" <> 0 THEN BEGIN
            ClientTransactions."On Hold" := TRUE;
            ClientTransactions."Holding Due Date" := CALCDATE(Fund."Minimum Holding Period",ClientTransactions."Value Date");
            FundAdministration.HoldingPeriodTracker(
            Subscription."Value Date",Subscription."Client ID",Subscription."Account No",Subscription."Fund Code",Subscription.Amount,
            ClientTransactions."Transaction Type"::Subscription,EntryNo,Subscription.No, TRUE);
          END;*/
        //
        ClientTransactions."Fund Sub Code":=Subscription."Fund Sub Account";
        ClientTransactions.Narration:=Subscription.Remarks;
        if CheckinitialSubscriptionExist(ClientTransactions."Account No") then
        ClientTransactions."Transaction Sub Type":=ClientTransactions."Transaction Sub Type"::additional
        else
        ClientTransactions."Transaction Sub Type":=ClientTransactions."Transaction Sub Type"::Initial;
        ClientTransactions."Transaction Sub Type 2":=ClientTransactions."Transaction Sub Type 2"::"Bank Transaction";
        //ClientTransactions."Transaction Sub Type 3" :=ClientTransactions."Transaction Sub Type 3"::"Cash Deposits & Bank Account Transfers";
        ClientTransactions."Transaction Sub Type 3" := Subscription."Payment Mode";
        if ClientTransactions.Narration='' then begin
          if ClientTransactions."Transaction Type"=ClientTransactions."Transaction Sub Type"::Initial then
            NarrationText:=GetNarration(NarrationTransType::"Subscription Initial")
          else
            NarrationText:=GetNarration(NarrationTransType::"Subscription Additional");
          if NarrationText<>'' then
              ClientTransactions.Narration:=NarrationText+'-'+Subscription.No
          else
             ClientTransactions.Narration:='Subscription -'+Format(ClientTransactions."Transaction Sub Type");
        end;
        
        ClientTransactions."Transaction No":=Subscription.No;
        ClientTransactions.Amount:=Subscription.Amount;
        ClientTransactions."No of Units":=Subscription."No. Of Units";
        ClientTransactions."Price Per Unit":=Subscription."Price Per Unit";
        ClientTransactions."Transaction Sub Type 3" := Subscription."Payment Mode";
        ClientTransactions.Currency:=Subscription.Currency;
        ClientTransactions."Agent Code":=Subscription."Agent Code";
        ClientTransactions."Created By":=UserId;
        ClientTransactions."Created Date Time":=CurrentDateTime;
        ClientTransactions."Transaction Source Document":=ClientTransactions."Transaction Source Document"::Subscription;
        if ClientTransactions.Amount<>0 then
        ClientTransactions.Insert(true);
        
        Subscription.Posted:=true;
        Subscription."Posted By":=UserId;
        Subscription."Date Posted":=Today;
        Subscription."Time Posted":=Time;
        Subscription."Subscription Status":=Subscription."Subscription Status"::Posted;
        Subscription.Select:=false;
        Subscription."Selected By":='';
        Subscription.Modify;
        MovetoPostedSubscriptions(Subscription);

    end;

    procedure ReverseSubscription(Subscription: Record "Posted Subscription")
    var
        ClientTransactions: Record "Client Transactions";
        ClientTransactions2: Record "Client Transactions";
        EntryNo: Integer;
    begin
        if not Confirm('Are you sure you want to Reverse this Subscription?') then
          Error('');
        if Subscription.Reversed=true then
          Error('This subscription has already been reversed');
        if Subscription."Value Date"<>Today then
          Error('Only same day reversals is allowed');
        EntryNo:=0;
        EntryNo:=GetLastTransactionNo;
        ClientTransactions.Reset;
        ClientTransactions.SetRange("Transaction No",Subscription.No);
        ClientTransactions.SetRange("Transaction Type",ClientTransactions."Transaction Type"::Subscription);
        ClientTransactions.SetRange(Reversed,false);
        if ClientTransactions.FindFirst then
          repeat
            EntryNo:=EntryNo+1;
            ClientTransactions2.Init;
            ClientTransactions2.Copy(ClientTransactions);
            ClientTransactions2."Entry No":=EntryNo;
            ClientTransactions2.Amount:=-ClientTransactions.Amount;
            ClientTransactions2."Transaction Type":=ClientTransactions2."Transaction Type"::Redemption;
            ClientTransactions2."No of Units":=-ClientTransactions."No of Units";
            ClientTransactions2."Reversed Entry No":=ClientTransactions."Entry No";
            ClientTransactions2.Narration:='Reversal of Subscription no - '+ClientTransactions."Transaction No";
            ClientTransactions2.Insert(true);

            ClientTransactions.Reversed:=true;
            ClientTransactions."Reversed By Entry No":=EntryNo;
            ClientTransactions.Modify(true);
          until ClientTransactions.Next=0;
        Subscription.Reversed:=true;
        Subscription."Reversed By":=UserId;
        Subscription."Date Time reversed":=CurrentDateTime;
        Subscription.Modify;
        Message('Subscription Reversed Completely');
    end;

    procedure GetLastTransactionNo(): Integer
    var
        ClientTransactions: Record "Client Transactions";
    begin
        if ClientTransactions.FindLast then
        exit(ClientTransactions."Entry No");
    end;

    local procedure MovetoPostedSubscriptions(Subscription: Record Subscription)
    var
        PostedSubscription: Record "Posted Subscription";
        Subscription2: Record Subscription;
    begin
        PostedSubscription.Init;
        PostedSubscription.TransferFields(Subscription);
        PostedSubscription.Insert;
        if Subscription2.Get(Subscription.No)then
          Subscription2.Delete;
    end;

    local procedure CheckifSubscriptionEntriesExist(SubscriptionNo: Code[30]): Boolean
    var
        ClientTransactions: Record "Client Transactions";
    begin
        ClientTransactions.Reset;
        ClientTransactions.SetRange("Transaction No",SubscriptionNo);
        ClientTransactions.SetRange("Transaction Type",ClientTransactions."Transaction Type"::Subscription);
        ClientTransactions.SetRange(Reversed,false);
        if ClientTransactions.FindFirst then
          exit(true)
        else
          exit(false);
    end;

    local procedure CheckifSubscriptionEntriesExistInstitutional(SubscriptionNo: Code[30];ContributionType: Option Employee,Employer): Boolean
    var
        ClientTransactions: Record "Client Transactions";
    begin
        ClientTransactions.Reset;
        ClientTransactions.SetRange("Transaction No",SubscriptionNo);
        ClientTransactions.SetRange("Transaction Type",ClientTransactions."Transaction Type"::Subscription);
        ClientTransactions.SetRange("Contribution Type",ContributionType);
        ClientTransactions.SetRange(Reversed,false);
        if ClientTransactions.FindFirst then
          exit(true)
        else
          exit(false);
    end;

    procedure ValidateRedemption(Redemption: Record Redemption)
    var
        ClientAccount: Record "Client Account";
        Caution: Record "Client Cautions";
    begin
        Redemption.TestField("Account No");
        Redemption.TestField("Client ID");
        Redemption.TestField("Fund Code");
        Redemption.TestField(Amount);
        Redemption.TestField("No. Of Units");
        Redemption.TestField("Price Per Unit");
        Redemption.TestField("Net Amount Payable");
        if Redemption."Bank Account No"='' then
          Error('Bank Account must have a value for redemption %1',Redemption."Account No");
        /*IF Redemption."Bank Account Name"='' THEN
          ERROR('Bank Account Name must have a value for redemption %1',Redemption."Transaction No");*/
        if Redemption."Bank Code"='' then
          Error('Bank must have a value for redemption %1',Redemption."Account No");
        ValidateValuedateAgainstPrice(Redemption."Value Date",Redemption."Fund Code",'Redemption no',Redemption."Transaction No");
        if Redemption."Price Per Unit"<>FundAdministration.GetFundPrice(Redemption."Fund Code",Redemption."Value Date",1) then
          Error('The Price you are using is not updated. Please update prices for Redemption');
        
        /*IF(Redemption."Request Mode" = Redemption."Request Mode"::Online) THEN BEGIN
          IF((Redemption."Fund Code" = 'ARMSTBF') OR (Redemption."Fund Code" = 'ARMFIF') OR (Redemption."Fund Code" = 'ARMEURO')) THEN
            ERROR('This request will not be processed today because of reinvestment');
        END;*/
        
        Caution.Reset;
        Caution.SetRange("Account No", Redemption."Account No");
        Caution.SetRange(Status, Caution.Status::Verified);
        if Caution.FindFirst and ((Caution."Restriction Type" = Caution."Restriction Type"::"Restrict Both") or (Caution."Restriction Type" = Caution."Restriction Type"::"Restrict Redemption")) then
          Error('This account %1 is under caution', Redemption."Account No");
        
        if Redemption."Created By"=UserId then
          Error('You cannot post a transaction that you Created!!');
        
        if CheckifRedemptionEntriesExist(Redemption."Transaction No") then
          Error('Unreversed Transactions exist for this Redemption No %1',Redemption."Transaction No");
        ClientAccount.Get(Redemption."Account No");
        ClientAccount.CalcFields("No of Units");
        if Redemption."Redemption Type"=Redemption."Redemption Type"::Part then begin
          if ((Redemption."No. Of Units"+Redemption."Fee Units"+Redemption."Charge Units")>ClientAccount."No of Units") and (Redemption."Fund Code" <> 'ARMMMF') then
            Error('This transaction cannot be posted since it will throw the account %1 into Negative',Redemption."Account No");
        
          if (Redemption."No. Of Units"+Redemption."Fee Units")>ClientAccount."No of Units" then
            Error('This transaction cannot be posted since it will throw the account %1 into Negative',Redemption."Account No");
        
        end else
          if (Redemption."No. Of Units")>ClientAccount."No of Units" then
            Error('This transaction cannot be posted since it will throw the account %1 into Negative',Redemption."Account No");

    end;

    procedure PostBatchRedmption()
    var
        Redemption: Record Redemption;
        EntryNo: Integer;
        RedemptionScheduleLines: Record "Redemption Schedule Lines";
    begin
        if not Confirm('Are you sure you want to post these Redemptions') then
          Error('');
        EntryNo:=0;
        EntryNo:=GetLastTransactionNo;
        Window.Open('Posting Redemption No #1#######');
        Redemption2.Reset;
        Redemption2.SetRange(Select,true);
        Redemption2.SetRange("Selected By",UserId);
        Redemption2.SetRange("Redemption Status",Redemption2."Redemption Status"::Verified);
        if Redemption2.FindFirst then
          repeat
            Redemption2.Validate(Amount);
            Redemption2.Modify;
          until Redemption2.Next=0;
        
        Redemption.Reset;
        Redemption.SetRange(Select,true);
        Redemption.SetRange("Selected By",UserId);
        Redemption.SetRange("Redemption Status",Redemption."Redemption Status"::Verified);
        if Redemption.FindFirst then
          repeat
            Window.Update(1,Redemption."Transaction No");
        
            EntryNo:=EntryNo+1;
           ValidateRedemption(Redemption);
           PostRedemption(Redemption,EntryNo);
           if Redemption."Redemption Type"=Redemption."Redemption Type"::Full then
              Postaccruedinterest(Redemption);
          /* IF Redemption."Has Schedule?" THEN BEGIN
             RedemptionScheduleLines.RESET;
             RedemptionScheduleLines.SETRANGE("Schedule Header",Redemption."Transaction No");
             IF RedemptionScheduleLines.FINDFIRST THEN
               REPEAT
                 EntryNo:=EntryNo+1;
                 PostRedemptionSchedule(RedemptionScheduleLines,EntryNo);
                 RedemptionScheduleLines.Posted:=TRUE;
                 RedemptionScheduleLines."Posted By":=USERID;
                 RedemptionScheduleLines."Time Posted":=TIME;
                 RedemptionScheduleLines."Date Posted":=TODAY;
                 //RedemptionScheduleLines.MODIFY;
               UNTIL RedemptionScheduleLines.NEXT=0;
           END;*/
           //Maxwell: Insert into Accrued Interest Charge Table.
          if Redemption."Charges On Accrued Interest" > 0 then
            InsertAccruedInterestCharge(Redemption."Account No",Redemption."Charges On Accrued Interest",Redemption."Fund Code",Redemption."Value Date");
          //post redemption status to deluxe
          //commented out Bayo. This has been moved to the post redemptrion function -03112021
            /*IF Redemption."Data Source" = 'Deluxe-Xfund' THEN BEGIN
            resp := ExternalSeviceCall.SendRedemption(Redemption."Transaction No",Redemption."No. Of Units",Redemption."Price Per Unit",Redemption."No. Of Units"+ Redemption."Fee Units",Redemption."Fee Units");
            IF resp = FALSE THEN
            MESSAGE('Record fully matched or not found on deluxe');
            END;*/
          until Redemption.Next=0;
        Window.Close;
         Message('Redemption Posting Process Complete');

    end;

    procedure PostSingleRedmptionOnline(Redemption: Record Redemption)
    var
        EntryNo: Integer;
        RedemptionScheduleLines: Record "Redemption Schedule Lines";
    begin
        EntryNo:=0;
        EntryNo:=GetLastTransactionNo;
            EntryNo:=EntryNo+1;
           ValidateRedemption(Redemption);
           PostRedemption(Redemption,EntryNo);
        
        //Email Notification
           /*NotificationFunctions.CreateNotificationEntry(1,USERID,CURRENTDATETIME,'Redemption',Redemption."Transaction No",
              Redemption."Client Name",Redemption."Client ID",'Posted',Redemption."Fund Code",Redemption."Account No",
          'Redemption',Redemption.Amount,4);*/
        
             if Redemption."Redemption Type"=Redemption."Redemption Type"::Full then
              Postaccruedinterest(Redemption);
        
        // MESSAGE('Redemption Posting Process Complete');

    end;

    procedure PostSingleRedmption(Redemption: Record Redemption)
    var
        EntryNo: Integer;
        RedemptionScheduleLines: Record "Redemption Schedule Lines";
    begin
        if not Confirm('Are you sure you want to post these Redemption') then
          Error('');
        EntryNo:=0;
        EntryNo:=GetLastTransactionNo;
        Window.Open('Posting Redemption No #1#######');

            Window.Update(1,Redemption."Transaction No");
            EntryNo:=EntryNo+1;
           ValidateRedemption(Redemption);
           PostRedemption(Redemption,EntryNo);
             if Redemption."Redemption Type"=Redemption."Redemption Type"::Full then
              Postaccruedinterest(Redemption);

        Window.Close;
         Message('Redemption Posting Process Complete');
    end;

    procedure ReverseRedmption(Redemption: Record "Posted Redemption")
    var
        EntryNo: Integer;
        RedemptionScheduleLines: Record "Redemption Schedule Lines";
        ClientTransactions: Record "Client Transactions";
        ClientTransactions2: Record "Client Transactions";
        DailyDistributableIncome: Record "Daily Income Distrib Lines";
    begin
        if not Confirm('Are you sure you want to reverse this Redemption?') then
          Error('');
        EntryNo:=0;
        EntryNo:=GetLastTransactionNo;
        Window.Open('Posting Redemption No #1#######');

            Window.Update(1,Redemption.No);
            EntryNo:=EntryNo+1;
           Redemption.TestField(Reversed,false);
            ClientTransactions.Reset;
            ClientTransactions.SetRange(Reversed,false);
            ClientTransactions.SetRange("Transaction No",Redemption.No);
            ClientTransactions.SetRange("Transaction Type",ClientTransactions."Transaction Type"::Redemption);
            ClientTransactions.SetRange("Value Date",Redemption."Value Date");
            if ClientTransactions.FindFirst then
              repeat
                EntryNo:=EntryNo+1;
                ClientTransactions2.Init;
                ClientTransactions2.Copy(ClientTransactions);
                ClientTransactions2."Entry No":=EntryNo;
                ClientTransactions2."Transaction Type":=ClientTransactions2."Transaction Type"::Subscription;
                ClientTransactions2.Amount:=-ClientTransactions.Amount;
                ClientTransactions2."No of Units":=-ClientTransactions."No of Units";
                ClientTransactions2."Reversed Entry No":=ClientTransactions."Entry No";
                ClientTransactions2.Narration:='Reversal of Redemption no - '+ClientTransactions."Transaction No";
                ClientTransactions2.Insert(true);

                ClientTransactions.Reversed:=true;
                ClientTransactions."Reversed By Entry No":=EntryNo;
                ClientTransactions.Modify(true);
              until ClientTransactions.Next=0;
              DailyDistributableIncome.Reset;
              DailyDistributableIncome.SetRange("Account No",Redemption."Account No");
              DailyDistributableIncome.SetRange("Fully Paid",true);
              DailyDistributableIncome.SetRange("Transaction No",Redemption.No);
              if DailyDistributableIncome.FindFirst then
                repeat
                  DailyDistributableIncome."Fully Paid":=false;
                  DailyDistributableIncome."Payment Date":=0D;
                  DailyDistributableIncome."Payment Mode":=DailyDistributableIncome."Payment Mode"::" ";
                  DailyDistributableIncome."Transaction No":='';
                  DailyDistributableIncome.Modify;;

                until DailyDistributableIncome.Next=0;
            Redemption.Reversed:=true;
            Redemption."Reversed By":=UserId;
            Redemption."Date Time reversed":=CurrentDateTime;
            Redemption.Modify;
        Window.Close;
         Message('Redemption Reversal Process Complete');
    end;

    procedure PostRedemption(Redemption: Record Redemption;var EntryNo: Integer)
    var
        ClientTransactions: Record "Client Transactions";
    begin
        FundAdministration.InsertRedemptionTracker(5,Redemption."Transaction No");
        ClientTransactions.Init;
        ClientTransactions."Entry No":=EntryNo;
        ClientTransactions."Transaction Type":=ClientTransactions."Transaction Type"::Redemption;
        ClientTransactions."Value Date":=Redemption."Value Date";
        ClientTransactions."Transaction Date":=Redemption."Transaction Date";
        ClientTransactions.Validate("Account No",Redemption."Account No");
        ClientTransactions.Validate("Client ID",Redemption."Client ID");
        ClientTransactions."Fund Code":=Redemption."Fund Code";
        ClientTransactions."Fund Sub Code":=Redemption."Fund Sub Account";
        //CHARGES
        if Redemption."Charges On Accrued Interest" > 0 then begin
          ClientTransactions."Charges On Interest" := -Abs(Redemption."Charges On Accrued Interest");
          FundAdministration.PostHoldingPeriodTrans(Redemption."Value Date",Redemption."Client ID",Redemption."Account No",Redemption."Transaction No");
        end;
        //Maxwell:ClientTransaction BEGIN CHARGES
        if ((Redemption."Charges On Accrued Interest" > 0) and (Redemption."Fund Code" = 'ARMMMF')) then begin
          ClientTransactions."Charges On Interest" := -Abs(Redemption."Charges On Accrued Interest");
          AmountChargedOn := FundAdministration.GetUnitToCharge(Redemption."Fund Code",Redemption.Amount,Redemption."Account No");
          ClientTransactions.AmountChargedOn := -Abs(AmountChargedOn);
          FundProcessing.PostChargeOnInterest(Redemption."Value Date",Redemption."Account No",Redemption."Charges On Accrued Interest",Redemption."Price Per Unit",AmountChargedOn);
        end;
        //END
        ClientTransactions.Narration:=Redemption.Remarks;
        if CheckinitialRedemptionExist(ClientTransactions."Account No") then
          ClientTransactions."Transaction Sub Type":=ClientTransactions."Transaction Sub Type"::additional
        else
          ClientTransactions."Transaction Sub Type":=ClientTransactions."Transaction Sub Type"::Initial;
        if Redemption."Redemption Type"=Redemption."Redemption Type"::Full then
        ClientTransactions."Transaction Sub Type":=ClientTransactions."Transaction Sub Type"::"Full Redemption"
        else
          ClientTransactions."Transaction Sub Type":=ClientTransactions."Transaction Sub Type"::"Part Redemption";
        ClientTransactions."Transaction Sub Type 2":=ClientTransactions."Transaction Sub Type 2"::"Ordinary Redemption";
        ClientTransactions."Transaction Sub Type 3" :=ClientTransactions."Transaction Sub Type 3"::"Manual Redemption";
        if ClientTransactions.Narration='' then begin
          if ClientTransactions."Transaction Type"=ClientTransactions."Transaction Sub Type"::"Full Redemption" then
            NarrationText:=GetNarration(NarrationTransType::"Redemption Full")
          else
            NarrationText:=GetNarration(NarrationTransType::"Redemption Part");
          if NarrationText<>'' then
              ClientTransactions.Narration:=NarrationText+'-'+Redemption."Transaction No"
          else
             ClientTransactions.Narration:='Redemption -'+Format(ClientTransactions."Transaction Sub Type");
        end;
        ClientTransactions."Transaction No":=Redemption."Transaction No";

        //ClientTransactions.Amount:=-ABS(Redemption."Net Amount Payable");
        if Redemption."Redemption Type"=Redemption."Redemption Type"::Full then begin
          if Redemption."Fund Code" <> 'ARMMMF' then begin
            ClientTransactions."No of Units":=-Abs(Redemption."No. Of Units"-Redemption."Fee Units"-Redemption."Charge Units");
            ClientTransactions.Amount:=-Abs(Redemption.Amount-Redemption."Fee Amount"-Redemption."Charges On Accrued Interest");
          end else begin
            ClientTransactions."No of Units":=-Abs(Redemption."No. Of Units"-Redemption."Fee Units");
            ClientTransactions.Amount:=-Abs(Redemption.Amount-Redemption."Fee Amount");
          end;
        end else begin
          ClientTransactions."No of Units":=-Abs(Redemption."No. Of Units");
          ClientTransactions.Amount:=-Abs(Redemption.Amount);
        end;
        ClientTransactions."Price Per Unit":=Redemption."Price Per Unit";
        ClientTransactions.Currency:=Redemption.Currency;
        ClientTransactions."Agent Code":=Redemption."Agent Code";
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
        ClientTransactions."Value Date":=Redemption."Value Date";
        ClientTransactions."Transaction Date":=Redemption."Transaction Date";
        ClientTransactions.Validate("Account No",Redemption."Account No");
        ClientTransactions.Validate("Client ID",Redemption."Client ID");
        ClientTransactions."Fund Code":=Redemption."Fund Code";
        ClientTransactions."Fund Sub Code":=Redemption."Fund Sub Account";
        ClientTransactions.Narration:=Redemption.Remarks;
        if CheckinitialRedemptionExist(ClientTransactions."Account No") then
          ClientTransactions."Transaction Sub Type":=ClientTransactions."Transaction Sub Type"::additional
        else
          ClientTransactions."Transaction Sub Type":=ClientTransactions."Transaction Sub Type"::Initial;
        if Redemption."Redemption Type"=Redemption."Redemption Type"::Full then
        ClientTransactions."Transaction Sub Type":=ClientTransactions."Transaction Sub Type"::"Full Redemption"
        else
          ClientTransactions."Transaction Sub Type":=ClientTransactions."Transaction Sub Type"::"Part Redemption";
        ClientTransactions."Transaction Sub Type 2":=ClientTransactions."Transaction Sub Type 2"::"Ordinary Redemption";
        ClientTransactions."Transaction Sub Type 3" :=ClientTransactions."Transaction Sub Type 3"::"Manual Redemption";
        if ClientTransactions.Narration='' then begin
          if ClientTransactions."Transaction Type"=ClientTransactions."Transaction Sub Type"::"Full Redemption" then
            NarrationText:=GetNarration(NarrationTransType::"Redemption Full")
          else
            NarrationText:=GetNarration(NarrationTransType::"Redemption Part");
          if NarrationText<>'' then
              ClientTransactions.Narration:=NarrationText+'-'+Redemption."Transaction No"
          else
             ClientTransactions.Narration:='Bank Fee -'+Format(ClientTransactions."Transaction Sub Type");
        end;
        ClientTransactions."Transaction No":=Redemption."Transaction No";
        ClientTransactions.Amount:=-Abs(Redemption."Fee Amount");
        ClientTransactions."No of Units":=-Abs(Redemption."Fee Units");
        ClientTransactions."Price Per Unit":=Redemption."Price Per Unit";
        ClientTransactions.Currency:=Redemption.Currency;
        ClientTransactions."Agent Code":=Redemption."Agent Code";
        ClientTransactions."Created By":=UserId;
        ClientTransactions."Created Date Time":=CurrentDateTime;
        ClientTransactions."Transaction Source Document":=ClientTransactions."Transaction Source Document"::Redemption;
        if ClientTransactions.Amount<>0 then
        ClientTransactions.Insert(true);

        //Penalty Charge
        if (Redemption."Fund Code" <> 'ARMMMF') and (Redemption."Charges On Accrued Interest" > 0) then begin
          AmountChargedOn := (FundAdministration.GetUnitToCharge(Redemption."Fund Code",Redemption.Amount,Redemption."Account No")) * Redemption."Price Per Unit";
          EntryNo:=EntryNo+1;
          ClientTransactions.Init;
          ClientTransactions."Entry No":=EntryNo;
          ClientTransactions."Transaction Type":=ClientTransactions."Transaction Type"::Fee;
          ClientTransactions."Value Date":=Redemption."Value Date";
          ClientTransactions."Transaction Date":=Redemption."Transaction Date";
          ClientTransactions.Validate("Account No",Redemption."Account No");
          ClientTransactions.Validate("Client ID",Redemption."Client ID");
          ClientTransactions."Fund Code":=Redemption."Fund Code";
          ClientTransactions."Fund Sub Code":=Redemption."Fund Sub Account";
          ClientTransactions."Penalty Charge" := true;
          ClientTransactions.Narration:=Redemption.Remarks;
          if CheckinitialRedemptionExist(ClientTransactions."Account No") then
            ClientTransactions."Transaction Sub Type":=ClientTransactions."Transaction Sub Type"::additional
          else
            ClientTransactions."Transaction Sub Type":=ClientTransactions."Transaction Sub Type"::Initial;
          if Redemption."Redemption Type"=Redemption."Redemption Type"::Full then
          ClientTransactions."Transaction Sub Type":=ClientTransactions."Transaction Sub Type"::"Full Redemption"
          else
            ClientTransactions."Transaction Sub Type":=ClientTransactions."Transaction Sub Type"::"Part Redemption";
          ClientTransactions."Transaction Sub Type 2":=ClientTransactions."Transaction Sub Type 2"::"Ordinary Redemption";
          ClientTransactions."Transaction Sub Type 3" :=ClientTransactions."Transaction Sub Type 3"::"Manual Redemption";
          if ClientTransactions.Narration='' then begin
            if ClientTransactions."Transaction Type"=ClientTransactions."Transaction Sub Type"::"Full Redemption" then
              NarrationText:=GetNarration(NarrationTransType::"Redemption Full")
            else
              NarrationText:=GetNarration(NarrationTransType::"Redemption Part");
            if NarrationText<>'' then
                ClientTransactions.Narration:=NarrationText+'-'+Redemption."Transaction No"
            else
               ClientTransactions.Narration:='Pre-liquidation Charge on '+Format(ClientTransactions."Transaction Sub Type");
          end;
          ClientTransactions."Transaction No":=Redemption."Transaction No";
          ClientTransactions.Amount:=-Abs(Redemption."Charges On Accrued Interest");
          ClientTransactions."No of Units":=-Abs(Redemption."Charge Units");
          ClientTransactions."Price Per Unit":=Redemption."Price Per Unit";
          ClientTransactions.Currency:=Redemption.Currency;
          ClientTransactions."Agent Code":=Redemption."Agent Code";
          ClientTransactions."Created By":=UserId;
          ClientTransactions."Created Date Time":=CurrentDateTime;
          ClientTransactions."Transaction Source Document":=ClientTransactions."Transaction Source Document"::Redemption;
          if ClientTransactions.Amount<>0 then
          ClientTransactions.Insert(true);
        end;

        //post redemption status to deluxe
            if (Redemption."Data Source" = 'Deluxe-Xfund') or (Redemption."Request Mode" =Redemption."Request Mode"::Portfolio) then begin
              resp := ExternalSeviceCall.SendRedemption(Redemption."Transaction No",Redemption."No. Of Units",Redemption."Price Per Unit",Redemption."No. Of Units"+ Redemption."Fee Units",Redemption."Fee Units");
              if resp = false then
                Message('Record fully matched or not found on deluxe');
            end;
        Redemption.Posted:=true;
        Redemption."Posted By":=UserId;
        Redemption."Date Posted":=Today;
        Redemption."Time Posted":=Time;
        Redemption."Date And Time Posted" := CurrentDateTime;
        Redemption."Redemption Status":=Redemption."Redemption Status"::Posted;
        Redemption.Select:=false;
        Redemption."Selected By":='';
        Redemption.Modify;
        MovetoPostedRedemptions(Redemption);
    end;

    procedure SendRedScheduleforConfirm(RedemptionScheduleHeader: Record "Redemption Schedule Header")
    begin
        
        if RedemptionScheduleHeader."Line Total"=0 then
          Error('The schedule should have at least one line');
        RedemptionScheduleHeader.TestField("Value Date");
        RedemptionScheduleHeader.TestField("CLient ID");
        RedemptionScheduleHeader.TestField("Total Amount");
        /*IF RedemptionScheduleHeader."Line Total"<>RedemptionScheduleHeader."Total Amount" THEN
          ERROR('Total Amount must be Equal to Line Total');
          */
        if not Confirm('Are you sure you want to send this schedule for confirmation?') then
          Error('');
        RedemptionScheduleHeader."Redemption Status":=RedemptionScheduleHeader."Redemption Status"::Confirmation;
        RedemptionScheduleHeader.Modify;
        
                 //Email Notification after posting Redemption
          NotificationFunctions.CreateNotificationEntry(1,UserId,CurrentDateTime,'Redemption Schedule ' + RedemptionScheduleHeader."Schedule No",RedemptionScheduleHeader."Schedule No",
              RedemptionScheduleHeader."Client Name",RedemptionScheduleHeader."CLient ID",'Confirmed',RedemptionScheduleHeader."Fund Group",RedemptionScheduleHeader."Main Account",
          'Redemption',RedemptionScheduleHeader."Line Total",19);
        
        Message('Schedule send for confirmation Successfully');

    end;

    procedure PostRedemptionScheduleHeader(RedemptionScheduleHeader: Record "Redemption Schedule Header")
    var
        EntryNo: Integer;
        RedemptionScheduleLines: Record "Redemption Schedule Lines";
        RedemHeader: Record "Redemption Schedule Header";
        ClientTransactions: Record "Client Transactions";
    begin
        if not Confirm('Are you sure you want to Post this Redemption?') then
          Error('');
        EntryNo:=0;
        EntryNo:=GetLastTransactionNo;
        if RedemptionScheduleHeader."Created By"=UserId then
          Error('You cannot post a transaction that you Created!!');
        Window.Open('Posting Redemption Line No #1#######');
             RedemptionScheduleLines.Reset;
             RedemptionScheduleLines.SetRange("Schedule Header",RedemptionScheduleHeader."Schedule No");
             if RedemptionScheduleLines.FindFirst then
               repeat
                 Window.Update(1,Format(RedemptionScheduleLines."Line No"));
                 EntryNo:=EntryNo+1;
                 ValidateRedemptionschedule(RedemptionScheduleLines);
                 //PostRedemptionSchedule(RedemptionScheduleLines,EntryNo);
               if RedemHeader.Get(RedemptionScheduleLines."Schedule Header") then ;
                  ClientTransactions.Init;
                  ClientTransactions."Entry No":=EntryNo;
                  ClientTransactions."Transaction Type":=ClientTransactions."Transaction Type"::Redemption;
                  ClientTransactions."Value Date":=RedemHeader."Value Date";
                  ClientTransactions."Transaction Date":=RedemHeader."Transaction Date";
                  ClientTransactions.Validate("Account No",RedemptionScheduleLines."Account No");
                  ClientTransactions.Validate("Client ID",RedemptionScheduleLines."Client ID");
                  ClientTransactions."Fund Code":=RedemptionScheduleLines."Fund Code";
                  ClientTransactions."Fund Sub Code":=RedemptionScheduleLines."Fund Sub Account";
                  //ClientTransactions.Narration:=RedemHeader.Remarks;
                  if CheckifRedemptionEntriesExistInstitutional(ClientTransactions."Account No",ClientTransactions."Contribution Type"::Employer) then
                    ClientTransactions."Transaction Sub Type":=ClientTransactions."Transaction Sub Type"::additional
                  else
                    ClientTransactions."Transaction Sub Type":=ClientTransactions."Transaction Sub Type"::Initial;
                  if RedemptionScheduleLines."Redemption Type"=RedemptionScheduleLines."Redemption Type"::Full then
                  ClientTransactions."Transaction Sub Type":=ClientTransactions."Transaction Sub Type"::"Full Redemption"
                  else
                    ClientTransactions."Transaction Sub Type":=ClientTransactions."Transaction Sub Type"::"Part Redemption";

                  ClientTransactions."Transaction Sub Type 2":=ClientTransactions."Transaction Sub Type 2"::"Ordinary Redemption";
                  ClientTransactions."Transaction Sub Type 3" :=ClientTransactions."Transaction Sub Type 3"::"Manual Redemption";
                  if ClientTransactions.Narration='' then begin
                    if ClientTransactions."Transaction Type"=ClientTransactions."Transaction Sub Type"::"Full Redemption" then
                      NarrationText:=GetNarration(NarrationTransType::"Redemption Full")
                    else
                      NarrationText:=GetNarration(NarrationTransType::"Redemption Part");
                    if NarrationText<>'' then
                        ClientTransactions.Narration:=NarrationText+'-'+RedemptionScheduleLines."Schedule Header"
                    else
                       ClientTransactions.Narration:='Employer -'+Format(ClientTransactions."Transaction Sub Type");
                  end;
                  ClientTransactions."Transaction No":=RedemptionScheduleLines."Schedule Header";
                  ClientTransactions.Amount:=-Abs(RedemptionScheduleLines."Employer Amount");
                  ClientTransactions."No of Units":=-Abs(RedemptionScheduleLines."Employer No. Of Units");
                  ClientTransactions."Price Per Unit":=RedemptionScheduleLines."Price Per Unit";
                  ClientTransactions.Currency:=RedemptionScheduleLines.Currency;
                  ClientTransactions."Agent Code":=RedemptionScheduleLines."Agent Code";
                  ClientTransactions."Created By":=UserId;
                  ClientTransactions."Created Date Time":=CurrentDateTime;
                  ClientTransactions."Transaction Source Document":=ClientTransactions."Transaction Source Document"::Redemption;
                  ClientTransactions."Contribution Type":=ClientTransactions."Contribution Type"::Employer;
                  if ClientTransactions.Amount<>0 then
                  ClientTransactions.Insert(true);
                  //employee
                  EntryNo:=EntryNo+1;
                  ClientTransactions.Init;
                  ClientTransactions."Entry No":=EntryNo;
                  ClientTransactions."Transaction Type":=ClientTransactions."Transaction Type"::Redemption;
                  ClientTransactions."Value Date":=RedemHeader."Value Date";
                  ClientTransactions."Transaction Date":=RedemHeader."Transaction Date";
                  ClientTransactions.Validate("Account No",RedemptionScheduleLines."Account No");
                  ClientTransactions.Validate("Client ID",RedemptionScheduleLines."Client ID");
                  ClientTransactions."Fund Code":=RedemptionScheduleLines."Fund Code";
                  ClientTransactions."Fund Sub Code":=RedemptionScheduleLines."Fund Sub Account";
                  //ClientTransactions.Narration:=RedemHeader.Remarks;
                  if CheckifRedemptionEntriesExistInstitutional(ClientTransactions."Account No",ClientTransactions."Contribution Type"::Employee) then
                    ClientTransactions."Transaction Sub Type":=ClientTransactions."Transaction Sub Type"::additional
                  else
                    ClientTransactions."Transaction Sub Type":=ClientTransactions."Transaction Sub Type"::Initial;
                  if RedemptionScheduleLines."Redemption Type"=RedemptionScheduleLines."Redemption Type"::Full then
                  ClientTransactions."Transaction Sub Type":=ClientTransactions."Transaction Sub Type"::"Full Redemption"
                  else
                    ClientTransactions."Transaction Sub Type":=ClientTransactions."Transaction Sub Type"::"Part Redemption";

                  ClientTransactions."Transaction Sub Type 2":=ClientTransactions."Transaction Sub Type 2"::"Ordinary Redemption";
                  ClientTransactions."Transaction Sub Type 3" :=ClientTransactions."Transaction Sub Type 3"::"Manual Redemption";
                  if ClientTransactions.Narration='' then begin
                    if ClientTransactions."Transaction Type"=ClientTransactions."Transaction Sub Type"::"Full Redemption" then
                      NarrationText:=GetNarration(NarrationTransType::"Redemption Full")
                    else
                      NarrationText:=GetNarration(NarrationTransType::"Redemption Part");
                    if NarrationText<>'' then
                        ClientTransactions.Narration:=NarrationText+'-'+RedemptionScheduleLines."Schedule Header"
                    else
                       ClientTransactions.Narration:='Employee -'+Format(ClientTransactions."Transaction Sub Type");
                  end;
                  ClientTransactions."Transaction No":=RedemptionScheduleLines."Schedule Header";
                  ClientTransactions.Amount:=-Abs(RedemptionScheduleLines."Employee Amount");
                  ClientTransactions."No of Units":=-Abs(RedemptionScheduleLines."Employee No. Of Units");
                  ClientTransactions."Price Per Unit":=RedemptionScheduleLines."Price Per Unit";
                  ClientTransactions.Currency:=RedemptionScheduleLines.Currency;
                  ClientTransactions."Agent Code":=RedemptionScheduleLines."Agent Code";
                  ClientTransactions."Created By":=UserId;
                  ClientTransactions."Created Date Time":=CurrentDateTime;
                  ClientTransactions."Transaction Source Document":=ClientTransactions."Transaction Source Document"::Redemption;
                  ClientTransactions."Contribution Type":=ClientTransactions."Contribution Type"::Employee;
                  if ClientTransactions.Amount<>0 then
                  ClientTransactions.Insert(true);
                  RedemptionScheduleLines.Posted:=true;
                  RedemptionScheduleLines."Posted By":=UserId;
                  RedemptionScheduleLines."Date Posted":=Today;
                  RedemptionScheduleLines."Time Posted":=Time;

                  RedemptionScheduleLines.Select:=false;
                  RedemptionScheduleLines."Selected By":='';
                  RedemptionScheduleLines.Modify;

                //Email Notification after posting Redemption
          NotificationFunctions.CreateNotificationEntry(1,UserId,CurrentDateTime,'Redemption Schedule ' + RedemptionScheduleLines."Schedule Header",Format(RedemptionScheduleLines."Line No"),
              RedemptionScheduleLines."Client Name",RedemptionScheduleLines."Client ID",'Posted',RedemptionScheduleLines."Fund Code",RedemptionScheduleLines."Account No",
          'Redemption',RedemptionScheduleLines."Total Amount",20);

               until RedemptionScheduleLines.Next=0;
        RedemptionScheduleHeader.Posted:=true;
        RedemptionScheduleHeader."Posted By":=UserId;
        RedemptionScheduleHeader."Redemption Status":=RedemptionScheduleHeader."Redemption Status"::Posted;
        RedemptionScheduleHeader."Time Posted":=Time;
        RedemptionScheduleHeader."Date Posted":=Today;
        RedemptionScheduleHeader.Modify;
        Window.Close;
        Message('Redemption Schedule Posted Successfully');
    end;

    procedure PostRedemptionSchedule(Redemption: Record "Redemption Schedule Lines";EntryNo: Integer)
    var
        ClientTransactions: Record "Client Transactions";
        RedemHeader: Record "Redemption Schedule Header";
    begin
        if RedemHeader.Get(Redemption."Schedule Header") then ;


        ClientTransactions.Init;
        ClientTransactions."Entry No":=EntryNo;
        ClientTransactions."Transaction Type":=ClientTransactions."Transaction Type"::Redemption;
        ClientTransactions."Value Date":=RedemHeader."Value Date";
        ClientTransactions."Transaction Date":=RedemHeader."Transaction Date";
        ClientTransactions.Validate("Account No",Redemption."Account No");
        ClientTransactions.Validate("Client ID",Redemption."Client ID");
        ClientTransactions."Fund Code":=Redemption."Fund Code";
        ClientTransactions."Fund Sub Code":=Redemption."Fund Sub Account";
        //ClientTransactions.Narration:=RedemHeader.Remarks;
        if CheckifRedemptionEntriesExistInstitutional(ClientTransactions."Account No",ClientTransactions."Contribution Type"::Employer) then
          ClientTransactions."Transaction Sub Type":=ClientTransactions."Transaction Sub Type"::additional
        else
          ClientTransactions."Transaction Sub Type":=ClientTransactions."Transaction Sub Type"::Initial;
        if Redemption."Redemption Type"=Redemption."Redemption Type"::Full then
        ClientTransactions."Transaction Sub Type":=ClientTransactions."Transaction Sub Type"::"Full Redemption"
        else
          ClientTransactions."Transaction Sub Type":=ClientTransactions."Transaction Sub Type"::"Part Redemption";

        ClientTransactions."Transaction Sub Type 2":=ClientTransactions."Transaction Sub Type 2"::"Ordinary Redemption";
        ClientTransactions."Transaction Sub Type 3" :=ClientTransactions."Transaction Sub Type 3"::"Manual Redemption";
        if ClientTransactions.Narration='' then begin
          if ClientTransactions."Transaction Type"=ClientTransactions."Transaction Sub Type"::"Full Redemption" then
            NarrationText:=GetNarration(NarrationTransType::"Redemption Full")
          else
            NarrationText:=GetNarration(NarrationTransType::"Redemption Part");
          if NarrationText<>'' then
              ClientTransactions.Narration:=NarrationText+'-'+Redemption."Schedule Header"
          else
             ClientTransactions.Narration:='Employer -'+Format(ClientTransactions."Transaction Sub Type");
        end;
        ClientTransactions."Transaction No":=Redemption."Schedule Header";
        ClientTransactions.Amount:=-Abs(Redemption."Employer Amount");
        ClientTransactions."No of Units":=-Abs(Redemption."Employer No. Of Units");
        ClientTransactions."Price Per Unit":=Redemption."Price Per Unit";
        ClientTransactions.Currency:=Redemption.Currency;
        ClientTransactions."Agent Code":=Redemption."Agent Code";
        ClientTransactions."Created By":=UserId;
        ClientTransactions."Created Date Time":=CurrentDateTime;
        ClientTransactions."Transaction Source Document":=ClientTransactions."Transaction Source Document"::Redemption;
        ClientTransactions."Contribution Type":=ClientTransactions."Contribution Type"::Employer;
        if ClientTransactions.Amount<>0 then
        ClientTransactions.Insert(true);
        //employee

        ClientTransactions.Init;
        ClientTransactions."Entry No":=EntryNo;
        ClientTransactions."Transaction Type":=ClientTransactions."Transaction Type"::Redemption;
        ClientTransactions."Value Date":=RedemHeader."Value Date";
        ClientTransactions."Transaction Date":=RedemHeader."Transaction Date";
        ClientTransactions.Validate("Account No",Redemption."Account No");
        ClientTransactions.Validate("Client ID",Redemption."Client ID");
        ClientTransactions."Fund Code":=Redemption."Fund Code";
        ClientTransactions."Fund Sub Code":=Redemption."Fund Sub Account";
        //ClientTransactions.Narration:=RedemHeader.Remarks;
        if CheckifRedemptionEntriesExistInstitutional(ClientTransactions."Account No",ClientTransactions."Contribution Type"::Employee) then
          ClientTransactions."Transaction Sub Type":=ClientTransactions."Transaction Sub Type"::additional
        else
          ClientTransactions."Transaction Sub Type":=ClientTransactions."Transaction Sub Type"::Initial;
        if Redemption."Redemption Type"=Redemption."Redemption Type"::Full then
        ClientTransactions."Transaction Sub Type":=ClientTransactions."Transaction Sub Type"::"Full Redemption"
        else
          ClientTransactions."Transaction Sub Type":=ClientTransactions."Transaction Sub Type"::"Part Redemption";

        ClientTransactions."Transaction Sub Type 2":=ClientTransactions."Transaction Sub Type 2"::"Ordinary Redemption";
        ClientTransactions."Transaction Sub Type 3" :=ClientTransactions."Transaction Sub Type 3"::"Manual Redemption";
        if ClientTransactions.Narration='' then begin
          if ClientTransactions."Transaction Type"=ClientTransactions."Transaction Sub Type"::"Full Redemption" then
            NarrationText:=GetNarration(NarrationTransType::"Redemption Full")
          else
            NarrationText:=GetNarration(NarrationTransType::"Redemption Part");
          if NarrationText<>'' then
              ClientTransactions.Narration:=NarrationText+'-'+Redemption."Schedule Header"
          else
             ClientTransactions.Narration:='Employee -'+Format(ClientTransactions."Transaction Sub Type");
        end;
        ClientTransactions."Transaction No":=Redemption."Schedule Header";
        ClientTransactions.Amount:=-Abs(Redemption."Employee Amount");
        ClientTransactions."No of Units":=-Abs(Redemption."Employee No. Of Units");
        ClientTransactions."Price Per Unit":=Redemption."Price Per Unit";
        ClientTransactions.Currency:=Redemption.Currency;
        ClientTransactions."Agent Code":=Redemption."Agent Code";
        ClientTransactions."Created By":=UserId;
        ClientTransactions."Created Date Time":=CurrentDateTime;
        ClientTransactions."Transaction Source Document":=ClientTransactions."Transaction Source Document"::Redemption;
        ClientTransactions."Contribution Type":=ClientTransactions."Contribution Type"::Employer;
        if ClientTransactions.Amount<>0 then
        ClientTransactions.Insert(true);
        Redemption.Posted:=true;
        Redemption."Posted By":=UserId;
        Redemption."Date Posted":=Today;
        Redemption."Time Posted":=Time;

        Redemption.Select:=false;
        Redemption."Selected By":='';
        Redemption.Modify;
    end;

    procedure ValidateRedemptionschedule(Redemption: Record "Redemption Schedule Lines")
    var
        ClientAccount: Record "Client Account";
    begin
        Redemption.TestField("Account No");
        Redemption.TestField("Client ID");
        Redemption.TestField("Fund Code");
        Redemption.TestField("Total Amount");
        Redemption.TestField("Total No. Of Units");
        Redemption.TestField("Price Per Unit");

        ClientAccount.Get(Redemption."Account No");
        ClientAccount.CalcFields("No of Units");
        if Redemption."Total No. Of Units">ClientAccount."No of Units" then  begin
           Window.Close;
          Error('This transaction Line no %1 Cannot be posted since it will throw the account into Negative',Redemption."Line No");

        end
    end;

    procedure UpdateRedemptionScheduleprices(RedemptionScheduleHeader: Record "Redemption Schedule Header")
    var
        EntryNo: Integer;
        RedemptionScheduleLines: Record "Redemption Schedule Lines";
    begin
        if not Confirm('Are you sure you want to update this Redemption?') then
          Error('');

        Window.Open('Updating Redemption Line No #1#######');
             RedemptionScheduleLines.Reset;
             RedemptionScheduleLines.SetRange("Schedule Header",RedemptionScheduleHeader."Schedule No");
             if RedemptionScheduleLines.FindFirst then
               repeat
                 Window.Update(1,Format(RedemptionScheduleLines."Line No"));
                 RedemptionScheduleLines.Validate("Total Amount");
                 RedemptionScheduleLines.Validate("Employee Amount");
                 RedemptionScheduleLines.Validate("Employer Amount");
                 RedemptionScheduleLines.Modify;

               until RedemptionScheduleLines.Next=0;

        Window.Close;
        Message('Redemption Schedule updated Successfully');
    end;

    local procedure Postaccruedinterest(Redemption: Record Redemption)
    var
        DailyDistributableIncome: Record "Daily Income Distrib Lines";
    begin
        DailyDistributableIncome.Reset;
        DailyDistributableIncome.SetRange("Account No",Redemption."Account No");
        DailyDistributableIncome.SetRange("Fully Paid",false);
        if DailyDistributableIncome.FindFirst then
          repeat
            DailyDistributableIncome."Fully Paid":=true;
            DailyDistributableIncome."Payment Date":=Redemption."Value Date";
            DailyDistributableIncome."Payment Mode":=DailyDistributableIncome."Payment Mode"::"Full Redemption";
            DailyDistributableIncome."Transaction No":=Redemption."Transaction No";
            DailyDistributableIncome.Modify;

          until DailyDistributableIncome.Next=0;
    end;

    procedure ReverseRedemption(Subscription: Record Subscription)
    begin
    end;

    local procedure MovetoPostedRedemptions(Redemption: Record Redemption)
    var
        PostedRedemption: Record "Posted Redemption";
        Redemption2: Record Redemption;
    begin
        PostedRedemption.Init;
        PostedRedemption.TransferFields(Redemption);
        PostedRedemption.Insert;
        if Redemption2.Get(Redemption."Transaction No")then
          Redemption2.Delete;
    end;

    local procedure CheckifRedemptionEntriesExist(RedemptionNo: Code[30]): Boolean
    var
        ClientTransactions: Record "Client Transactions";
    begin
        ClientTransactions.Reset;
        ClientTransactions.SetRange("Transaction No",RedemptionNo);
        ClientTransactions.SetRange("Transaction Type",ClientTransactions."Transaction Type"::Redemption);
        ClientTransactions.SetRange(Reversed,false);
        if ClientTransactions.FindFirst then
          exit(true)
        else
          exit(false);
    end;

    local procedure CheckifRedemptionEntriesExistInstitutional(RedemptionNo: Code[30];ContributionType: Option Employee,Employer): Boolean
    var
        ClientTransactions: Record "Client Transactions";
    begin
        ClientTransactions.Reset;
        ClientTransactions.SetRange("Transaction No",RedemptionNo);
        ClientTransactions.SetRange("Transaction Type",ClientTransactions."Transaction Type"::Redemption);
        ClientTransactions.SetRange("Contribution Type",ContributionType);
        ClientTransactions.SetRange(Reversed,false);
        if ClientTransactions.FindFirst then
          exit(true)
        else
          exit(false);
    end;

    procedure PostMatchedsubscriptions(Matchingheader: Record "Subscription Matching header";Option: Option Assigned,All)
    var
        SubscriptionMatchingLines: Record "Subscription Matching Lines";
        Subscription: Record Subscription;
        Entryno: Integer;
    begin
        if not Confirm(StrSubstNo('Are you sure you want to Send matched transactions for confirmation?. Make sure you have confirmed that the file you imported is for the correct date')) then
          Error('');
        Window.Open('Posting line No #1#######');
        FundAdministrationSetup.Get;
        SubscriptionMatchingLines.Reset;
        SubscriptionMatchingLines.SetRange("Header No",Matchingheader.No);
        SubscriptionMatchingLines.SetRange(Posted,false);
        SubscriptionMatchingLines.SetRange(Matched,true);
        if Option=Option::Assigned then
        SubscriptionMatchingLines.SetRange("Assigned User",UserId);
        if SubscriptionMatchingLines.FindFirst then
          repeat
           // ValidateValuedateAgainstPrice(SubscriptionMatchingLines."Value Date",SubscriptionMatchingLines."Fund Code",'Line No',FORMAT(SubscriptionMatchingLines."Line No"));
            //check if subscription is posted
            if SubscriptionMatchingLines."Automatch Reference" <> '' then begin
            Subscription.Reset;
            Subscription.SetRange("Automatch Ref",SubscriptionMatchingLines."Automatch Reference");
          if Subscription.FindFirst then Error('Similar Transaction Reference ID (%1) already posted',SubscriptionMatchingLines."Automatch Reference");
          end;
          //
            Window.Update(1,SubscriptionMatchingLines."Line No");
            Subscription.Init;
            Subscription.No:=NoSeriesManagement.GetNextNo(FundAdministrationSetup."Subscription Nos",Today,true);
            Subscription.Validate("Account No",SubscriptionMatchingLines."Account No");;
            Subscription.Validate("Value Date",Matchingheader."Value Date");
            Subscription.Validate("Transaction Date",Today);
            Subscription.Validate(Amount,SubscriptionMatchingLines."Credit Amount");
            Subscription.Validate("Payment Mode",SubscriptionMatchingLines."Payment Mode");
            Subscription."Creation Date" := SubscriptionMatchingLines."Creation Date";
            Subscription."Matching Header No":=Matchingheader.No;
            Subscription."Subscription Status":=Subscription."Subscription Status"::Confirmed;
            Subscription."Bank Narration":=SubscriptionMatchingLines.Narration;
            Subscription.AutoMatched:=SubscriptionMatchingLines."Auto Matched";
            //
            Subscription."Automatch Ref" := SubscriptionMatchingLines."Automatch Reference";
            //
            Subscription."Bank Code" := Matchingheader."Bank Code";
            if Subscription."Bank Code" <> '' then begin
              Bank.Reset;
              Bank.SetRange("Bank Code",Matchingheader."Bank Code");
              Bank.SetRange("Fund Code",SubscriptionMatchingLines."Fund Code");
              Bank.SetRange("Transaction Type", Bank."Transaction Type"::Subscription);
              if Bank.FindFirst then
                Subscription."Bank Account No" := Bank."Bank Account No";
              end;
              //
            Subscription.Insert(true);
            SubscriptionMatchingLines.Posted:=true;
            SubscriptionMatchingLines."Posted By":=UserId;
            SubscriptionMatchingLines."Date Posted":=Today;
            SubscriptionMatchingLines."Time Posted":=Time;
            SubscriptionMatchingLines."Subscription No":=Subscription.No;
            SubscriptionMatchingLines.Modify;
          until SubscriptionMatchingLines.Next=0;
        SubscriptionMatchingLines.Reset;
        SubscriptionMatchingLines.SetRange("Header No",Matchingheader.No);
        SubscriptionMatchingLines.SetRange(Posted,false);
        SubscriptionMatchingLines.SetRange("Non Client Transaction",true);
        if SubscriptionMatchingLines.FindFirst then
          repeat
            Window.Update(1,SubscriptionMatchingLines."Line No");
            SubscriptionMatchingLines.Posted:=true;
            SubscriptionMatchingLines."Posted By":=UserId;
            SubscriptionMatchingLines."Date Posted":=Today;
            SubscriptionMatchingLines."Time Posted":=Time;
               SubscriptionMatchingLines.Modify;
          until SubscriptionMatchingLines.Next=0;
          Entryno:=0;
        Subscription.Reset;
        Subscription.SetRange("Created By",UserId);
        Subscription.SetRange("Subscription Status",Subscription."Subscription Status"::Confirmed);
        Subscription.SetRange(AutoMatched,true);
        if Subscription.FindFirst then
          repeat

            Entryno:=GetLastTransactionNo;

          Window.Update(1,Subscription.No);
          Entryno:=Entryno+1;
          ValidateSubscription(Subscription);
          PostSubscription(Subscription,Entryno);
          until Subscription.Next=0;



        SubscriptionMatchingLines.Reset;
        SubscriptionMatchingLines.SetRange("Header No",Matchingheader.No);
        SubscriptionMatchingLines.SetRange(Posted,false);
        if  not SubscriptionMatchingLines.FindFirst then begin
            Matchingheader.Posted:=true;
            Matchingheader."Posted By":=UserId;
            Matchingheader."Date Posted":=Today;
            Matchingheader."Time Posted":=Time;
            Matchingheader.Modify
        end;
          Window.Close;
        Message('Posting of matched Transactions Complete');
    end;

    procedure PostBatchFundTransfer()
    var
        FundTransfer: Record "Fund Transfer";
        Entryno: Integer;
    begin
        if not Confirm('Are you sure you want to post these transfers?') then
          Error('');
        Window.Open('Posting transfer No #1#######');
        Entryno:=0;
        Entryno:=GetLastTransactionNo;
         Entryno:=Entryno+1;
        FundTransfer.Reset;
        FundTransfer.SetRange(Select,true);
        FundTransfer.SetRange("Selected By",UserId);
        FundTransfer.SetRange("Fund Transfer Status",FundTransfer."Fund Transfer Status"::Verified);
        if FundTransfer.FindFirst then
          repeat
           Window.Update(1,FundTransfer.No);
           ValidateFundTransfer(FundTransfer);
           PostFundTransfer(FundTransfer,Entryno);
           if FundTransfer."Transfer Type"=FundTransfer."Transfer Type"::Full then
           PostaccruedinterestTransfer(FundTransfer);
            Entryno:=Entryno+2;
          until FundTransfer.Next=0;
          Window.Close;
         Message('Fund Transfer Posting Process Complete');
    end;

    procedure PostSingleFundTransfer(FundTransfer: Record "Fund Transfer")
    var
        Entryno: Integer;
    begin
        if not Confirm('Are you sure you want to post these transfers?') then
          Error('');
        Entryno:=0;
        Entryno:=GetLastTransactionNo;
         Entryno:=Entryno+1;

        ValidateFundTransfer(FundTransfer);
        PostFundTransfer(FundTransfer,Entryno);
        if FundTransfer."Transfer Type"=FundTransfer."Transfer Type"::Full then
          PostaccruedinterestTransfer(FundTransfer);
        Entryno:=Entryno+2;
        Message('Fund Transfer Posting Process Complete');
    end;

    procedure PostFundTransfer(FundTransfer: Record "Fund Transfer";EntryNo: Integer)
    var
        ClientTransactions: Record "Client Transactions";
    begin
        FundAdministration.InsertFundTransferTracker(5,FundTransfer.No);
        ClientTransactions.Init;
        ClientTransactions."Entry No":=EntryNo;
        ClientTransactions."Transaction Type":=ClientTransactions."Transaction Type"::Redemption;
        ClientTransactions."Value Date":=FundTransfer."Value Date";
        ClientTransactions."Transaction Date":=FundTransfer."Transaction Date";
        ClientTransactions.Validate("Account No",FundTransfer."From Account No");
        ClientTransactions.Validate("Client ID",FundTransfer."From Client ID");
        ClientTransactions."Fund Code":=FundTransfer."From Fund Code";
        ClientTransactions."Fund Sub Code":=FundTransfer."From Fund Sub Account";
        ClientTransactions.Narration:=FundTransfer.Remarks;
        //ClientTransactions.Narration:=RedemHeader.Remarks;
        if CheckinitialRedemptionExist(ClientTransactions."Account No") then
          ClientTransactions."Transaction Sub Type":=ClientTransactions."Transaction Sub Type"::additional
        else
          ClientTransactions."Transaction Sub Type":=ClientTransactions."Transaction Sub Type"::Initial;
        if FundTransfer."Transfer Type"=FundTransfer."Transfer Type"::Full then
        ClientTransactions."Transaction Sub Type":=ClientTransactions."Transaction Sub Type"::"Full Redemption"
        else
          ClientTransactions."Transaction Sub Type":=ClientTransactions."Transaction Sub Type"::"Part Redemption";
        ClientTransactions."Transaction Sub Type 2":=ClientTransactions."Transaction Sub Type 2"::"Unit Transfer";
        ClientTransactions."Transaction Sub Type 3" :=ClientTransactions."Transaction Sub Type 3"::"Unit Transfer";
        if ClientTransactions.Narration='' then begin
          if ClientTransactions."Transaction Type"=ClientTransactions."Transaction Sub Type"::"Full Redemption" then
            NarrationText:=GetNarration(NarrationTransType::"Account Transfer")
          else
            NarrationText:=GetNarration(NarrationTransType::"Account Transfer");
          if NarrationText<>'' then
              ClientTransactions.Narration:=NarrationText+'-'+FundTransfer.No
          else
             ClientTransactions.Narration:='Unit Transfer -'+Format(ClientTransactions."Transaction Sub Type");
        end;
        ClientTransactions."Transaction No":=FundTransfer.No;
        //Maxwell: Unit Transfer charges BEGIN

        if FundTransfer."Transfer Type"=FundTransfer."Transfer Type"::Full then begin
          ClientTransactions."No of Units":=-Abs(FundTransfer."No. Of Units"-FundTransfer."Fee Units");
          ClientTransactions.Amount:=-Abs(FundTransfer.Amount-FundTransfer."Fee Amount");
        end else begin
        ClientTransactions."No of Units":=-Abs(FundTransfer."No. Of Units");
        ClientTransactions.Amount:=-Abs(FundTransfer.Amount);
        end;
        //ClientTransactions.Amount:=-ABS(FundTransfer.Amount);
        //ClientTransactions."No of Units":=-ABS(FundTransfer."No. Of Units");
        //END
        ClientTransactions."Price Per Unit":=FundTransfer."Price Per Unit";
        ClientTransactions.Currency:=FundTransfer.Currency;
        ClientTransactions."Agent Code":=FundTransfer."Agent Code";
        ClientTransactions."Created By":=UserId;
        ClientTransactions."Created Date Time":=CurrentDateTime;
        ClientTransactions."Transaction Source Document":=ClientTransactions."Transaction Source Document"::Redemption;
        //Add fund transfer type to client transaction
        ClientTransactions."Transfer Type" :=Format(FundTransfer.Type);
        if ClientTransactions.Amount<>0 then
          ClientTransactions.Insert(true);


        // Maxwell: Post Unit transfer fee on client transactions table BEGIN
        if FundTransfer."Fee Amount" <> 0 then begin
          EntryNo:=EntryNo+1;
          ClientTransactions.Init;
          ClientTransactions."Entry No":=EntryNo;
          ClientTransactions."Transaction Type":=ClientTransactions."Transaction Type"::Fee;
          ClientTransactions."Value Date":=FundTransfer."Value Date";
          ClientTransactions."Transaction Date":=FundTransfer."Transaction Date";
          ClientTransactions.Validate("Account No",FundTransfer."From Account No");
          ClientTransactions.Validate("Client ID",FundTransfer."From Client ID");
          ClientTransactions."Fund Code":=FundTransfer."From Fund Code";
          ClientTransactions."Fund Sub Code":= FundTransfer."From Fund Sub Account";
          ClientTransactions.Narration:=FundTransfer.Remarks;
          if CheckinitialRedemptionExist(ClientTransactions."Account No") then
            ClientTransactions."Transaction Sub Type":=ClientTransactions."Transaction Sub Type"::additional
          else
            ClientTransactions."Transaction Sub Type":=ClientTransactions."Transaction Sub Type"::Initial;
          if FundTransfer."Transfer Type"=FundTransfer."Transfer Type"::Full then
          ClientTransactions."Transaction Sub Type":=ClientTransactions."Transaction Sub Type"::"Full Redemption"
          else
            ClientTransactions."Transaction Sub Type":=ClientTransactions."Transaction Sub Type"::"Part Redemption";
          ClientTransactions."Transaction Sub Type 2":=ClientTransactions."Transaction Sub Type 2"::"Ordinary Redemption";
          ClientTransactions."Transaction Sub Type 3" :=ClientTransactions."Transaction Sub Type 3"::"Manual Redemption";
          if ClientTransactions.Narration='' then begin
            if ClientTransactions."Transaction Type"=ClientTransactions."Transaction Sub Type"::"Full Redemption" then
              NarrationText:=GetNarration(NarrationTransType::"Account Transfer")
            else
              NarrationText:=GetNarration(NarrationTransType::"Account Transfer");
            if NarrationText<>'' then
                ClientTransactions.Narration:=NarrationText+'-'+FundTransfer.No
            else
               ClientTransactions.Narration:='Bank Fee -'+Format(ClientTransactions."Transaction Sub Type");
          end;
          ClientTransactions."Transaction No":=FundTransfer.No;
          ClientTransactions.Amount:=-Abs(FundTransfer."Fee Amount");
          ClientTransactions."No of Units":=-Abs(FundTransfer."Fee Units");
          ClientTransactions."Price Per Unit":=FundTransfer."Price Per Unit";
          ClientTransactions.Currency:=FundTransfer.Currency;
          ClientTransactions."Agent Code":=FundTransfer."Agent Code";
          ClientTransactions."Created By":=UserId;
          ClientTransactions."Created Date Time":=CurrentDateTime;
          ClientTransactions."Transaction Source Document":=ClientTransactions."Transaction Source Document"::Redemption;
          ClientTransactions."Transfer Type" :=Format(FundTransfer.Type);
          if ClientTransactions.Amount<>0 then
          ClientTransactions.Insert(true);
        end;
        //END

        if FundTransfer.Type=FundTransfer.Type::"Same Fund" then begin
          EntryNo:=EntryNo+1;
          ClientTransactions.Init;
          ClientTransactions."Entry No":=EntryNo;
          ClientTransactions."Transaction Type":=ClientTransactions."Transaction Type"::Subscription;
          ClientTransactions."Value Date":=FundTransfer."Value Date";
          ClientTransactions."Transaction Date":=FundTransfer."Transaction Date";
          ClientTransactions.Validate("Account No",FundTransfer."To Account No");
          ClientTransactions.Validate("Client ID",FundTransfer."To Client ID");
          ClientTransactions."Fund Code":=FundTransfer."To Fund Code";
          ClientTransactions."Fund Sub Code":=FundTransfer."To Fund Sub Account";
          ClientTransactions.Narration:=FundTransfer.Remarks;
          if CheckinitialSubscriptionExist (ClientTransactions."Account No") then
          ClientTransactions."Transaction Sub Type":=ClientTransactions."Transaction Sub Type"::additional
        else
          ClientTransactions."Transaction Sub Type":=ClientTransactions."Transaction Sub Type"::Initial;
        if FundTransfer."Transfer Type"=FundTransfer."Transfer Type"::Full then
        ClientTransactions."Transaction Sub Type":=ClientTransactions."Transaction Sub Type"::"Full Redemption"
        else
          ClientTransactions."Transaction Sub Type":=ClientTransactions."Transaction Sub Type"::"Part Redemption";
        ClientTransactions."Transaction Sub Type 2":=ClientTransactions."Transaction Sub Type 2"::"Unit Transfer";
        ClientTransactions."Transaction Sub Type 3" :=ClientTransactions."Transaction Sub Type 3"::"Unit Transfer";
        if ClientTransactions.Narration='' then begin
          if ClientTransactions."Transaction Type"=ClientTransactions."Transaction Sub Type"::"Full Redemption" then
            NarrationText:=GetNarration(NarrationTransType::"Account Transfer")
          else
            NarrationText:=GetNarration(NarrationTransType::"Account Transfer");
          if NarrationText<>'' then
              ClientTransactions.Narration:=NarrationText+'-'+FundTransfer.No
          else
             ClientTransactions.Narration:='Unit Transfer -'+Format(ClientTransactions."Transaction Sub Type");
        end;
          ClientTransactions."Transaction No":=FundTransfer.No;
          ClientTransactions.Amount:=FundTransfer.Amount;
          ClientTransactions."No of Units":=FundTransfer."No. Of Units";
          ClientTransactions."Price Per Unit":=FundTransfer."Price Per Unit";
          ClientTransactions.Currency:=FundTransfer.Currency;
          ClientTransactions."Agent Code":=FundTransfer."Agent Code";
          ClientTransactions."Created By":=UserId;
          ClientTransactions."Created Date Time":=CurrentDateTime;
          ClientTransactions."Transaction Source Document":=ClientTransactions."Transaction Source Document"::"Fund Transfer";
          ClientTransactions."Transfer Type" :=Format(FundTransfer.Type);
          if ClientTransactions.Amount<>0 then
          ClientTransactions.Insert(true);
        end;
        FundTransfer.Posted:=true;
        FundTransfer."Posted By":=UserId;
        FundTransfer."Date Posted":=Today;
        FundTransfer."Time Posted":=Time;
        FundTransfer."Fund Transfer Status":=FundTransfer."Fund Transfer Status"::Posted;
        FundTransfer.Select:=false;
        FundTransfer."Selected By":='';
        FundTransfer.Modify;
        MovetoPostedFundTransfers(FundTransfer);
    end;

    local procedure PostaccruedinterestTransfer(FundTransfer: Record "Fund Transfer")
    var
        DailyDistributableIncome: Record "Daily Income Distrib Lines";
        DailyDistributableIncome2: Record "Daily Income Distrib Lines";
        DailyDistributableIncome3: Record "Daily Income Distrib Lines";
        DailyDistributableIncomeHeader: Record "Daily Distributable Income";
        Dividendtransferred: Decimal;
    begin
        Dividendtransferred:=0;
        DailyDistributableIncome.Reset;
        DailyDistributableIncome.SetRange("Account No",FundTransfer."From Account No");
        DailyDistributableIncome.SetRange("Fully Paid",false);
        if DailyDistributableIncome.FindFirst then
          repeat
            DailyDistributableIncome."Fully Paid":=true;
            DailyDistributableIncome."Payment Date":=Today;
            DailyDistributableIncome."Payment Mode":=DailyDistributableIncome."Payment Mode"::"Full Transfer";
            DailyDistributableIncome."Transaction No":=FundTransfer.No;
            // add check for full unit transfer for same fund.
              if FundTransfer.Type = FundTransfer.Type::"Same Fund" then
              DailyDistributableIncome."Same Fund Full Transfer" := true;
            DailyDistributableIncome.Modify;

            Dividendtransferred:=Dividendtransferred+DailyDistributableIncome."Income accrued";
          until DailyDistributableIncome.Next=0;
          if (FundTransfer."Transfer Type"=FundTransfer."Transfer Type"::Full) and (FundTransfer.Type=FundTransfer.Type::"Same Fund") then begin
             if DailyDistributableIncomeHeader.FindLast then ;
              DailyDistributableIncome3.Reset;
              DailyDistributableIncome3.SetRange(No,DailyDistributableIncomeHeader.No);
              if DailyDistributableIncome3.FindLast then;

              DailyDistributableIncome2.Init;
              DailyDistributableIncome2.No:=DailyDistributableIncomeHeader.No;
              DailyDistributableIncome2."Line No":=DailyDistributableIncome3."Line No"+1;
              DailyDistributableIncome2."Value Date":=FundTransfer."Value Date";
              DailyDistributableIncome2."Account No":=FundTransfer."To Account No";
              DailyDistributableIncome2."Client ID":=FundTransfer."To Client ID";
              DailyDistributableIncome2."Client Name":=FundTransfer."To Client Name";
              DailyDistributableIncome2."Fund Code":=FundTransfer."To Fund Code";
              DailyDistributableIncome2."No of Units":=FundTransfer."To No. Of Units";
              DailyDistributableIncome2."Income accrued":=Dividendtransferred;
              DailyDistributableIncome2.Transferred:=true;
              DailyDistributableIncome2."Transferred from account":=FundTransfer."From Account No";
              DailyDistributableIncome2."Transfer Ref no":=FundTransfer.No;
              DailyDistributableIncome2.Insert;
            end;
    end;

    procedure ValidateFundTransfer(FundTransfer: Record "Fund Transfer")
    var
        ClientAccount: Record "Client Account";
    begin
        FundTransfer.TestField("From Account No");
        FundTransfer.TestField("To Account No");
        FundTransfer.TestField(Amount);
        FundTransfer.TestField("No. Of Units");
        FundTransfer.TestField("To No. Of Units");
        ClientAccount.Get(FundTransfer."From Account No");
        ClientAccount.CalcFields("No of Units");
        ValidateValuedateAgainstPrice(FundTransfer."Value Date",FundTransfer."From Fund Code",'Fund Transfer No',FundTransfer.No);
        if FundTransfer."Created By"=UserId then
          Error('You cannot post a transaction that you Created!!');


        if FundTransfer."No. Of Units">ClientAccount."No of Units" then
          Error('This transaction %1 Cannot be posted since it will throw the account into Negative',FundTransfer.No);
    end;

    local procedure MovetoPostedFundTransfers(FundTransfer: Record "Fund Transfer")
    var
        PostedFundTransfer: Record "Posted Fund Transfer";
        FundTransfer2: Record "Fund Transfer";
    begin
        PostedFundTransfer.Init;
        PostedFundTransfer.TransferFields(FundTransfer);
        PostedFundTransfer.Insert;
        if FundTransfer2.Get(FundTransfer.No)then
          FundTransfer2.Delete;
    end;

    procedure GenerateEOD(ValueDate: Date)
    var
        PostedRedemption: Record "Posted Redemption";
        PostedSubscription: Record "Posted Subscription";
        SubscriptionRedempFundware: Record "Subscription & Redemp Fundware";
        ClientTransactions: Record "Client Transactions";
        SubscriptionRedempFundware2: Record "Subscription & Redemp Fundware";
        EntryNo: Integer;
        Fund: Record Fund;
        ins: Boolean;
        DividendIncomeSettled: Record "Dividend Income Settled";
        DailyIncomeDistribLines: Record "Daily Income Distrib Lines";
        DividendPaid: Decimal;
        SubscriptionRedempFundware3: Record "Subscription & Redemp Fundware";
        DividendIncomeSettled2: Record "Dividend Income Settled";
        FundBankAccounts: Record "Fund Bank Accounts";
        Bank: Record Bank;
        ClientTransactions2: Record "Client Transactions";
        SubscriptionScheduleHeader: Record "Subscription Schedules Header";
        Historical: Record "Historical Client Transactions";
        ClientTransactionsCopy: Record "Client Transactions";
        HistoricalCopy: Record "Historical Client Transactions";
    begin
        Window.Open('Generating Order No #1#######');
        SubscriptionRedempFundware2.Reset;
        if SubscriptionRedempFundware2.FindLast then
          EntryNo:=SubscriptionRedempFundware2."Entry No"
        else
          EntryNo:=0;
        Fund.Reset;
        if Fund.FindFirst then
          repeat
            SubscriptionRedempFundware3.Reset;
            SubscriptionRedempFundware3.SetRange(SettledDate,ValueDate);
            SubscriptionRedempFundware3.SetRange(PlanCode,Fund."Fund Code");
            SubscriptionRedempFundware3.DeleteAll;
            ClientTransactions.Reset;
            ClientTransactions.SetRange("Value Date",ValueDate);
            ClientTransactions.SetRange("Fund Code",Fund."Fund Code");
            //filter out reversals
            ClientTransactions.SetRange(Reversed,false);
            //filter out same fund unit transfer
            ClientTransactions.SetFilter("Transfer Type",'<>%1','Same Fund');
            if ClientTransactions.FindFirst then
              repeat
                Window.Update(1,ClientTransactions."Transaction No");
                EntryNo:=EntryNo+1;
                SubscriptionRedempFundware.Init;
                SubscriptionRedempFundware."Entry No":=EntryNo;
                SubscriptionRedempFundware.OrderNO:=ClientTransactions."Transaction No";
                SubscriptionRedempFundware.PlanCode:=ClientTransactions."Fund Code";
                SubscriptionRedempFundware.FolioNo:=ClientTransactions."Client ID";
                SubscriptionRedempFundware.BuyBack := false;
                SubscriptionRedempFundware."Reversed Transaction" := false;
                if (ClientTransactions."Transaction Type"=ClientTransactions."Transaction Type"::Redemption) or(ClientTransactions."Transaction Type"=ClientTransactions."Transaction Type"::Fee)  then
                  SubscriptionRedempFundware.TransactionType:='RED'
                else
                  SubscriptionRedempFundware.TransactionType:='PUR';
                SubscriptionRedempFundware.PostDate:=ClientTransactions."Value Date";
                SubscriptionRedempFundware.TradeDate:=ClientTransactions."Transaction Date";
                SubscriptionRedempFundware.TradeUnits:=ClientTransactions."No of Units";
                SubscriptionRedempFundware.TradeAmount:=ClientTransactions.Amount;
                SubscriptionRedempFundware.TradeNav:=ClientTransactions."Price Per Unit";
                SubscriptionRedempFundware.LoadAmount:=0;
                SubscriptionRedempFundware.SettledAmount:=ClientTransactions.Amount;
                SubscriptionRedempFundware.SettledDate:=ClientTransactions."Value Date";
                SubscriptionRedempFundware."Penalty Charge" := ClientTransactions."Penalty Charge";
                SubscriptionRedempFundware.OrderStatus:='N';
                //Add transfer type to Entries
                SubscriptionRedempFundware.TransferType := ClientTransactions."Transfer Type";
                FundBankAccounts.Reset;
                FundBankAccounts.SetRange("Fund Code",SubscriptionRedempFundware.PlanCode);
                 if (ClientTransactions."Transaction Type"=ClientTransactions."Transaction Type"::Redemption) or
                   (ClientTransactions."Transaction Type"=ClientTransactions."Transaction Type"::Fee) and
                   (ClientTransactions."Penalty Charge" = false) then
                    FundBankAccounts.SetRange("Transaction Type",FundBankAccounts."Transaction Type"::Redemption)
                 else if (ClientTransactions."Transaction Type"=ClientTransactions."Transaction Type"::Redemption) or
                   (ClientTransactions."Transaction Type"=ClientTransactions."Transaction Type"::Fee) and
                   (ClientTransactions."Penalty Charge" = true) then begin
                    FundBankAccounts.SetRange("Fund Code", ClientTransactions."Fund Code");
                    FundBankAccounts.SetRange("Transaction Type",FundBankAccounts."Transaction Type"::Trading);
                 end else begin
                  PostedSubscription.Reset;
                  PostedSubscription.SetRange(No,ClientTransactions."Transaction No");
                  if PostedSubscription.FindFirst then begin
                    SubscriptionMatchingheader.Reset;
                    SubscriptionMatchingheader.SetRange(No,PostedSubscription."Matching Header No");
                    if SubscriptionMatchingheader.FindFirst then begin
                       FundBankAccounts.SetRange("Bank Code",SubscriptionMatchingheader."Bank Code");
                      FundBankAccounts.SetRange("Transaction Type",FundBankAccounts."Transaction Type"::Subscription);
                    end else if PostedSubscription."Payment Mode" = PostedSubscription."Payment Mode"::"Buy Back" then begin
                      SubscriptionRedempFundware.BuyBack := true;
                      FundBankAccounts.SetRange("Bank Code",PostedSubscription."Bank Code");
                      FundBankAccounts.SetRange("Transaction Type",FundBankAccounts."Transaction Type"::Redemption);
                    end else begin
                       FundBankAccounts.SetRange("Transaction Type",FundBankAccounts."Transaction Type"::Subscription);
                       FundBankAccounts.SetRange("Bank Code",PostedSubscription."Bank Code");
                    end;
                  end else begin
                    SubscriptionScheduleHeader.Reset;
                    SubscriptionScheduleHeader.SetRange("Schedule No", ClientTransactions."Transaction No");
                    if SubscriptionScheduleHeader.FindFirst then begin
                     FundBankAccounts.SetRange("Bank Code",SubscriptionScheduleHeader."Bank Code");
                     FundBankAccounts.SetRange("Transaction Type",FundBankAccounts."Transaction Type"::Subscription);
                   end;
                  end;
                  //Buyback
                  /*IF PostedSubscription."Payment Mode" = PostedSubscription."Payment Mode"::"Buy Back" THEN BEGIN
                    SubscriptionRedempFundware.BuyBack := TRUE;
                    FundBankAccounts.SETRANGE("Bank Code",PostedSubscription."Bank Code");
                    FundBankAccounts.SETRANGE("Transaction Type",FundBankAccounts."Transaction Type"::Redemption);
                  END;*/
                end;
                if FundBankAccounts.FindFirst then begin
                  if Bank.Get(FundBankAccounts."Bank Code") then
                  SubscriptionRedempFundware.BankID:=Bank.Fundware;
                  SubscriptionRedempFundware.BankAccountNo:=FundBankAccounts."Bank Account No"
                end;
                SubscriptionRedempFundware.Insert;
                ins:=true
              until ClientTransactions.Next=0;
        
        DividendIncomeSettled2.Reset;
        DividendIncomeSettled2.SetRange("Settled Date",ValueDate);
        DividendIncomeSettled2.SetRange(PlanCode,Fund."Fund Code");
        DividendIncomeSettled2.DeleteAll;
        DividendPaid:=0;
        DailyIncomeDistribLines.Reset;
        DailyIncomeDistribLines.SetCurrentKey("Payment Date","Fully Paid","Fund Code");
        DailyIncomeDistribLines.SetRange("Payment Date",ValueDate);
        DailyIncomeDistribLines.SetRange("Fully Paid",true);
        DailyIncomeDistribLines.SetRange("Fund Code",Fund."Fund Code");
        //add filter to filter out accrued income for same fund full unit transfer
        DailyIncomeDistribLines.SetRange("Same Fund Full Transfer",false);
        //Refactored to address differentials in total income accrued calculated
        DailyIncomeDistribLines.CalcSums("Income accrued");
        DividendPaid := DailyIncomeDistribLines."Income accrued";
        EntryNo:=EntryNo+1;
        DividendIncomeSettled.Init;
        DividendIncomeSettled."Entry No":=EntryNo;
        DividendIncomeSettled.OwnNumber:=Format(EntryNo);
        DividendIncomeSettled.SchemeDividendID:=Fund."Fund Code";
        DividendIncomeSettled."Log ID":=EntryNo;
        DividendIncomeSettled.ReferenceNumber:=EntryNo;
        DividendIncomeSettled.PlanCode:=Fund."Fund Code";
        DividendIncomeSettled."Folio Number":='';
        DividendIncomeSettled."Transaction Type":='DP';
        DividendIncomeSettled."Record Date":=ValueDate;
        DividendIncomeSettled."Ex Date":=ValueDate;
        DividendIncomeSettled.Nav:=0;
        DividendIncomeSettled.Units:=0;
        DividendIncomeSettled.Amount:=DividendPaid;
        DividendIncomeSettled."Load Amount":=DividendPaid;
        DividendIncomeSettled."Settled Date":=ValueDate;
        DividendIncomeSettled."Settled Amount":=DividendPaid;
        //map bank account
        FundBankAccounts.Reset;
        FundBankAccounts.SetRange("Fund Code",Fund."Fund Code");
        FundBankAccounts.SetRange("Transaction Type",FundBankAccounts."Transaction Type"::Redemption);
        FundBankAccounts.SetRange(Default,true);
        if FundBankAccounts.FindFirst then begin
          DividendIncomeSettled."Bank ID":= FundBankAccounts."Bank Account No";
          DividendIncomeSettled."Bank Account Number":= FundBankAccounts."Bank Code";
        end;
        DividendIncomeSettled."Reinvest Plan Code":='';
        DividendIncomeSettled."Transaction Status":='M';
        if DividendIncomeSettled.Amount>0 then
        DividendIncomeSettled.Insert;
        
         /* DividendIncomeSettled2.RESET;
          DividendIncomeSettled2.SETRANGE("Settled Date",ValueDate);
          DividendIncomeSettled2.SETRANGE(PlanCode,Fund."Fund Code");
          DividendIncomeSettled2.DELETEALL;
          DividendPaid:=0;
          DailyIncomeDistribLines.RESET;
          DailyIncomeDistribLines.SETCURRENTKEY("Payment Date","Fully Paid","Fund Code");
          DailyIncomeDistribLines.SETRANGE("Payment Date",ValueDate);
          DailyIncomeDistribLines.SETRANGE("Fully Paid",TRUE);
          //add filter to filter out accrued income for same fund full unit transfer
          DailyIncomeDistribLines.SETRANGE("Same Fund Full Transfer",FALSE);
          DailyIncomeDistribLines.SETRANGE("Fund Code",Fund."Fund Code");
          DailyIncomeDistribLines.SETRANGE(Transferred,FALSE);
          IF DailyIncomeDistribLines.FINDFIRST THEN
            REPEAT
              DividendPaid:=DividendPaid+DailyIncomeDistribLines."Income accrued";
            UNTIL DailyIncomeDistribLines.NEXT=0;
          EntryNo:=EntryNo+1;
          DividendIncomeSettled.INIT;
          DividendIncomeSettled."Entry No":=EntryNo;
          DividendIncomeSettled.OwnNumber:=FORMAT(EntryNo);
          DividendIncomeSettled.SchemeDividendID:=Fund."Fund Code";
          DividendIncomeSettled."Log ID":=EntryNo;
          DividendIncomeSettled.ReferenceNumber:=EntryNo;
          DividendIncomeSettled.PlanCode:=Fund."Fund Code";
          DividendIncomeSettled."Folio Number":='';
          DividendIncomeSettled."Transaction Type":='DP';
          DividendIncomeSettled."Record Date":=ValueDate;
          DividendIncomeSettled."Ex Date":=ValueDate;
          DividendIncomeSettled.Nav:=0;
          DividendIncomeSettled.Units:=0;
          DividendIncomeSettled.Amount:=DividendPaid;
          DividendIncomeSettled."Load Amount":=DividendPaid;
          DividendIncomeSettled."Settled Date":=ValueDate;
          DividendIncomeSettled."Settled Amount":=DividendPaid;
          //map bank account
          FundBankAccounts.RESET;
          FundBankAccounts.SETRANGE("Fund Code",Fund."Fund Code");
          FundBankAccounts.SETRANGE("Transaction Type",FundBankAccounts."Transaction Type"::Redemption);
          FundBankAccounts.SETRANGE(Default,TRUE);
          IF FundBankAccounts.FINDFIRST THEN BEGIN
            DividendIncomeSettled."Bank ID":= FundBankAccounts."Bank Account No";
            DividendIncomeSettled."Bank Account Number":= FundBankAccounts."Bank Code";
          END;
          // DividendIncomeSettled."Bank ID":='';
          // DividendIncomeSettled."Bank Account Number":='';
          DividendIncomeSettled."Reinvest Plan Code":='';
          DividendIncomeSettled."Transaction Status":='M';
          IF DividendIncomeSettled.Amount>0 THEN
          DividendIncomeSettled.INSERT;*/
        
          //reversals
        /*  ClientTransactions2.RESET;
          ClientTransactions2.SETRANGE("Fund Code",Fund."Fund Code");
          ClientTransactions2.SETRANGE(Reversed,TRUE);
          ClientTransactions2.SETRANGE("Send Reversed", FALSE);
          IF ClientTransactions2.FINDFIRST THEN BEGIN
          REPEAT
          //
              Window.UPDATE(1,ClientTransactions2."Transaction No");
              EntryNo:=EntryNo+1;
              SubscriptionRedempFundware.INIT;
              SubscriptionRedempFundware."Entry No":=EntryNo;
              SubscriptionRedempFundware.OrderNO:= ClientTransactions2."Transaction No";
              SubscriptionRedempFundware.PlanCode:= ClientTransactions2."Fund Code";
              SubscriptionRedempFundware.FolioNo:= ClientTransactions2."Client ID";
              //
              SubscriptionRedempFundware.BuyBack := FALSE;
              SubscriptionRedempFundware."Reversed Transaction" := FALSE;
              //
              FundBankAccounts.RESET;
              FundBankAccounts.SETRANGE("Fund Code",SubscriptionRedempFundware.PlanCode);
              FundBankAccounts.SETRANGE(Default,TRUE);
              IF ClientTransactions2."Transaction Type" = ClientTransactions2."Transaction Type"::Subscription THEN BEGIN
                SubscriptionRedempFundware.TransactionType := 'REV-SUB';
              SubscriptionRedempFundware."Reversed Transaction" := TRUE;
              //Add subscription bank account
              PostedSubscription.RESET;
                PostedSubscription.SETRANGE(No,ClientTransactions2."Transaction No");
                IF PostedSubscription.FINDFIRST THEN BEGIN
                  SubscriptionRedempFundware.BankID:=PostedSubscription."Bank Code";
                  SubscriptionRedempFundware.BankAccountNo:=PostedSubscription."Bank Account No";
                  END;
              END;
              IF (ClientTransactions2."Transaction Type" = ClientTransactions2."Transaction Type"::Redemption) OR (ClientTransactions2."Transaction Type"=ClientTransactions2."Transaction Type"::Fee) THEN BEGIN
        
                SubscriptionRedempFundware.TransactionType := 'REV-RED';
                SubscriptionRedempFundware."Reversed Transaction" := TRUE;
              FundBankAccounts.SETRANGE("Transaction Type",FundBankAccounts."Transaction Type"::Redemption);
          //Add redemtion bank account
              IF FundBankAccounts.FINDFIRST THEN BEGIN
                  IF Bank.GET(FundBankAccounts."Bank Code") THEN BEGIN
                  SubscriptionRedempFundware.BankID:=Bank.Fundware;
                  SubscriptionRedempFundware.BankAccountNo:=FundBankAccounts."Bank Account No";
                  END;
              END;
              END;
                  //
              SubscriptionRedempFundware.PostDate:= ValueDate;
              SubscriptionRedempFundware.TradeDate:= ValueDate;
              SubscriptionRedempFundware.TradeUnits:=ABS(ClientTransactions2."No of Units");
              SubscriptionRedempFundware.TradeAmount:=ABS(ClientTransactions2.Amount);
              SubscriptionRedempFundware.TradeNav:=ClientTransactions2."Price Per Unit";
              SubscriptionRedempFundware.LoadAmount:=0;
              SubscriptionRedempFundware.SettledAmount:=ABS(ClientTransactions2.Amount);
              SubscriptionRedempFundware.SettledDate:= ValueDate;
              SubscriptionRedempFundware.OrderStatus:='N';
              SubscriptionRedempFundware.INSERT;
          //
          ClientTransactions2."Send Reversed" := TRUE;
          ClientTransactions2.MODIFY;
          UNTIL ClientTransactions2.NEXT = 0;
          END;*/
        
          //reversal end
          // Reversal start
        ClientTransactions2.Reset;
        ClientTransactions2.SetRange("Fund Code",Fund."Fund Code");
        ClientTransactions2.SetRange(Reversed,true);
        ClientTransactions2.SetRange("Send Reversed", false);
        ClientTransactions2.SetRange("Reverse To Fund", true);
        if ClientTransactions2.FindFirst then begin
        repeat
        //
            Window.Update(1,ClientTransactions2."Transaction No");
            EntryNo:=EntryNo+1;
            SubscriptionRedempFundware.Init;
            SubscriptionRedempFundware."Entry No":=EntryNo;
            SubscriptionRedempFundware.OrderNO:= ClientTransactions2."Transaction No";
            SubscriptionRedempFundware.PlanCode:= ClientTransactions2."Fund Code";
            SubscriptionRedempFundware.FolioNo:= ClientTransactions2."Client ID";
            //
            SubscriptionRedempFundware.BuyBack := false;
            SubscriptionRedempFundware."Reversed Transaction" := false;
            //
          if ClientTransactions2."Transaction Type" = ClientTransactions2."Transaction Type"::Subscription then begin
            SubscriptionRedempFundware.TransactionType := 'REV-SUB';
          SubscriptionRedempFundware."Reversed Transaction" := true;
          //Add subscription bank account
          PostedSubscription.Reset;
            PostedSubscription.SetRange(No,ClientTransactions2."Transaction No");
            if PostedSubscription.FindFirst then begin
              SubscriptionRedempFundware.BankID:=PostedSubscription."Bank Code";
              SubscriptionRedempFundware.BankAccountNo:=PostedSubscription."Bank Account No";
              end;
          end;
          if (ClientTransactions2."Transaction Type" = ClientTransactions2."Transaction Type"::Redemption) or (ClientTransactions2."Transaction Type"=ClientTransactions2."Transaction Type"::Fee) then begin
              SubscriptionRedempFundware.TransactionType := 'REV-RED';
              SubscriptionRedempFundware."Reversed Transaction" := true;
            FundBankAccounts.Reset;
            FundBankAccounts.SetRange("Fund Code",SubscriptionRedempFundware.PlanCode);
            FundBankAccounts.SetRange(Default,true);
            FundBankAccounts.SetRange("Transaction Type",FundBankAccounts."Transaction Type"::Redemption);
        //Add redemtion bank account
            if FundBankAccounts.FindFirst then begin
                if Bank.Get(FundBankAccounts."Bank Code") then begin
                SubscriptionRedempFundware.BankID:=Bank.Fundware;
                SubscriptionRedempFundware.BankAccountNo:=FundBankAccounts."Bank Account No";
                end;
            end;
          end;
            SubscriptionRedempFundware.PostDate:= ValueDate;
            SubscriptionRedempFundware.TradeDate:= ValueDate;
            SubscriptionRedempFundware.TradeUnits:=Abs(ClientTransactions2."No of Units");
            SubscriptionRedempFundware.TradeAmount:=Abs(ClientTransactions2.Amount);
            SubscriptionRedempFundware.TradeNav:=ClientTransactions2."Price Per Unit";
            SubscriptionRedempFundware.LoadAmount:=0;
            SubscriptionRedempFundware.SettledAmount:=Abs(ClientTransactions2.Amount);
            SubscriptionRedempFundware.SettledDate:= ValueDate;
            SubscriptionRedempFundware.OrderStatus:='N';
            SubscriptionRedempFundware.Insert;
        //
        ClientTransactions2."Send Reversed" := true;
        ClientTransactions2.Modify;
        until ClientTransactions2.Next = 0;
        end;
        
        //reversal end
          InsertEODTracker(Fund."Fund Code",ValueDate);
        until Fund.Next=0;
        
        Window.Close;
        //write client transactions to historical
        HistoricalCopy.Reset;
        HistoricalCopy.SetRange("Value Date",ValueDate);
        if not HistoricalCopy.FindFirst then begin
        ClientTransactionsCopy.Reset;
        ClientTransactionsCopy.SetRange("Value Date",ValueDate);
        if ClientTransactionsCopy.FindFirst then begin
        repeat
        Historical.Reset;
        Historical.TransferFields(ClientTransactionsCopy);
        Historical.Insert;
        until ClientTransactionsCopy.Next = 0;
        end;
        end;
        //end

    end;

    procedure RunEOD()
    begin
    end;

    local procedure InsertEODTracker(fundcode: Code[20];Valuedate: Date)
    var
        EODTracker: Record "EOD Tracker";
        EODTracker2: Record "EOD Tracker";
    begin
        if EODTracker2.Get(Valuedate,fundcode) then begin
          EODTracker2."EOD Generated":=true;
          EODTracker2.Modify;
        end
        else begin
          EODTracker.Init;
          EODTracker."Fund Code":=fundcode;
          EODTracker.Date:=Valuedate;
          EODTracker."EOD Generated":=true;
          EODTracker.Insert;
        end
    end;

    procedure RunAutomatch(SubscriptionMatchingheader: Record "Subscription Matching header")
    var
        SubscriptionMatchingLines: Record "Subscription Matching Lines";
        ClientAccount: Record "Client Account";
        Client: Record Client;
        genAccountNo: Text;
    begin
        Window.Open('Matching Line No #1#######');
        SubscriptionMatchingheader.TestField("Fund Code");
        SubscriptionMatchingLines.Reset;
        SubscriptionMatchingLines.SetRange("Header No",SubscriptionMatchingheader.No);
        SubscriptionMatchingLines.SetRange(Posted,false);
        if SubscriptionMatchingLines.FindFirst then
          repeat
          Window.Update(1,SubscriptionMatchingLines."Line No");
            if StrPos(SubscriptionMatchingLines.Reference,'-')= 0 then genAccountNo := SubscriptionMatchingLines.Reference +'-' else genAccountNo := SubscriptionMatchingLines.Reference;
           if ClientAccount.Get(genAccountNo) then begin
             SubscriptionMatchingLines.Validate("Account No",SubscriptionMatchingLines.Reference);
              SubscriptionMatchingLines.Validate(Matched,true);
              SubscriptionMatchingLines."Auto Matched":=true;
            end else if Client.Get(SubscriptionMatchingLines.Reference) then begin
              ClientAccount.Reset;
              ClientAccount.SetRange("Client ID",Client."Membership ID");
              ClientAccount.SetRange("Fund No",SubscriptionMatchingLines."Fund Code");
              if ClientAccount.FindFirst then begin
                SubscriptionMatchingLines.Validate("Account No",ClientAccount."Account No");
                SubscriptionMatchingLines.Validate(Matched,true);
                  SubscriptionMatchingLines."Auto Matched":=true;
              end
              end else begin
              ClientAccount.Reset;
              ClientAccount.SetRange("Old MembershipID",SubscriptionMatchingLines.Reference);
              ClientAccount.SetRange("Fund No",SubscriptionMatchingLines."Fund Code");
              if ClientAccount.FindFirst then begin
                SubscriptionMatchingLines.Validate("Account No",ClientAccount."Account No");
                SubscriptionMatchingLines.Validate(Matched,true);
                SubscriptionMatchingLines."Auto Matched":=true;
              end
              else begin
              ClientAccount.Reset;
              ClientAccount.SetRange("Old Account Number",SubscriptionMatchingLines.Reference);
              ClientAccount.SetRange("Fund No",SubscriptionMatchingLines."Fund Code");
              if ClientAccount.FindFirst then begin
                SubscriptionMatchingLines.Validate("Account No",ClientAccount."Account No");
                SubscriptionMatchingLines.Validate(Matched,true);
                SubscriptionMatchingLines."Auto Matched":=true;
              end

              end
          end;

            if SubscriptionMatchingLines."Credit Amount"=0 then begin
               SubscriptionMatchingLines.Matched:=false;
               SubscriptionMatchingLines."Non Client Transaction":=true;
            end ;


             SubscriptionMatchingLines.Modify;
          until SubscriptionMatchingLines.Next=0;
          Window.Close;
    end;

    procedure GetNarration(TransType: Option " ","Subscription Initial","Subscription Additional","Redemption Part","Redemption Full","Account Transfer","Dividend Reinvest"): Text[250]
    var
        NarrationDefinitions: Record "Narration Definitions";
    begin
        NarrationDefinitions.Reset;
        NarrationDefinitions.SetRange("Transaction Type",TransType);
        if NarrationDefinitions.FindFirst then
          exit(NarrationDefinitions."Narration Text")
        else
          exit('');
    end;

    procedure UnmatchTransaction(Subscription: Record Subscription)
    var
        MatchingLines: Record "Subscription Matching Lines";
        SubscriptionMatchingheader: Record "Subscription Matching header";
    begin
        if not Confirm('Are you sure you want to reject this record?') then
          Error('');
        Subscription.TestField(Comments);
        MatchingLines.Reset;
        MatchingLines.SetRange("Subscription No",Subscription.No);
        if MatchingLines.FindFirst then begin
          MatchingLines.Posted:=false;
          MatchingLines.Matched:=false;
          MatchingLines.Rejected:=true;
          MatchingLines."Rejected by":=UserId;
          MatchingLines."Rejection Comments":=Subscription.Comments;
          MatchingLines.Modify;
        SubscriptionMatchingheader.Get(MatchingLines."Header No");
        SubscriptionMatchingheader.Posted:=false;
        SubscriptionMatchingheader.Modify;
        end;
        FundAdministration.InsertSubscriptionTracker(Subscription."Subscription Status"::Rejected,Subscription.No);
        Subscription."Subscription Status":=Subscription."Subscription Status"::Rejected;
        Subscription.Modify;
        Message('Record Rejected successfully');
    end;

    procedure PostSubscriptionSchedule(SubscriptionSchedulesHeader: Record "Subscription Schedules Header")
    var
        ClientTransactions: Record "Client Transactions";
        SubscriptionScheduleLines: Record "Subscription Schedule Lines";
        EntryNo: Integer;
    begin
        if not Confirm('Are you sure you want to post this schedule?') then
          Error('');

        if SubscriptionSchedulesHeader."Created By"=UserId then
          Error('You cannot post a transaction that you Created!!');
        Window.Open('Posting Line No #1#######');
        EntryNo:=GetLastTransactionNo;
        SubscriptionScheduleLines.Reset;
        SubscriptionScheduleLines.SetRange("Schedule Header",SubscriptionSchedulesHeader."Schedule No");
        if SubscriptionScheduleLines.FindFirst then begin
          repeat
            Window.Update(1,SubscriptionScheduleLines."Line No");
            ValidateValuedateAgainstPrice(SubscriptionSchedulesHeader."Value Date",SubscriptionScheduleLines."Fund Code",'Subscription Line',Format(SubscriptionScheduleLines."Line No"));
            if SubscriptionScheduleLines."Employee Amount"<>0 then begin
              EntryNo:=EntryNo+1;
              ClientTransactions.Init;
              ClientTransactions."Entry No":=EntryNo;
              ClientTransactions."Transaction Type":=ClientTransactions."Transaction Type"::Subscription;
              ClientTransactions."Value Date":=SubscriptionSchedulesHeader."Value Date";
              ClientTransactions."Transaction Date":=SubscriptionSchedulesHeader."Transaction Date";
              ClientTransactions.Validate("Account No",SubscriptionScheduleLines."Account No");
              ClientTransactions.Validate("Client ID",SubscriptionScheduleLines."Client ID");
              ClientTransactions."Fund Code":=SubscriptionScheduleLines."Fund Code";
              ClientTransactions."Fund Sub Code":=SubscriptionScheduleLines."Fund Sub Account";
              ClientTransactions.Narration:=SubscriptionSchedulesHeader.Narration;
              ClientTransactions."Contribution Type":=ClientTransactions."Contribution Type"::Employee;
              if CheckifSubscriptionEntriesExistInstitutional(SubscriptionScheduleLines."Account No",ClientTransactions."Contribution Type"::Employee) then
                ClientTransactions."Transaction Sub Type":=ClientTransactions."Transaction Sub Type"::additional
              else
                ClientTransactions."Transaction Sub Type":=ClientTransactions."Transaction Sub Type"::Initial;
               ClientTransactions."Transaction Sub Type 2":=ClientTransactions."Transaction Sub Type 2"::"Bank Transfer";
              ClientTransactions."Transaction Sub Type 3" :=ClientTransactions."Transaction Sub Type 3"::"Cash Deposits & Bank Account Transfers";
              if ClientTransactions.Narration='' then begin
                if ClientTransactions."Transaction Type"=ClientTransactions."Transaction Sub Type"::Initial then
                  NarrationText:=GetNarration(NarrationTransType::"Subscription Initial")
                else
                  NarrationText:=GetNarration(NarrationTransType::"Subscription Additional");
                if NarrationText<>'' then
                    ClientTransactions.Narration:=NarrationText+'-'+SubscriptionSchedulesHeader."Schedule No"
                else
                   ClientTransactions.Narration:='Employee -'+Format(ClientTransactions."Transaction Sub Type");
              end;
              ClientTransactions."Transaction No":=SubscriptionSchedulesHeader."Schedule No";
              ClientTransactions.Amount:=SubscriptionScheduleLines."Employee Amount";
              ClientTransactions."No of Units":=SubscriptionScheduleLines."Employee No. Of Units";
              ClientTransactions."Price Per Unit":=SubscriptionScheduleLines."Price Per Unit";

              ClientTransactions."Agent Code":=SubscriptionScheduleLines."Agent Code";
              ClientTransactions."Created By":=UserId;
              ClientTransactions."Created Date Time":=CurrentDateTime;
              ClientTransactions."Transaction Source Document":=ClientTransactions."Transaction Source Document"::Subscription;
              if ClientTransactions.Amount<>0 then
                ClientTransactions.Insert(true);
            end;

            if SubscriptionScheduleLines."Employer Amount"<>0 then begin
              EntryNo:=EntryNo+1;
              ClientTransactions.Init;
              ClientTransactions."Entry No":=EntryNo;
              ClientTransactions."Transaction Type":=ClientTransactions."Transaction Type"::Subscription;
              ClientTransactions."Value Date":=SubscriptionSchedulesHeader."Value Date";
              ClientTransactions."Transaction Date":=SubscriptionSchedulesHeader."Transaction Date";
              ClientTransactions.Validate("Account No",SubscriptionScheduleLines."Account No");
              ClientTransactions.Validate("Client ID",SubscriptionScheduleLines."Client ID");
              ClientTransactions."Fund Code":=SubscriptionScheduleLines."Fund Code";
              ClientTransactions."Fund Sub Code":=SubscriptionScheduleLines."Fund Sub Account";
              ClientTransactions.Narration:=SubscriptionSchedulesHeader.Narration;
              ClientTransactions."Contribution Type":=ClientTransactions."Contribution Type"::Employer;
              if CheckifSubscriptionEntriesExistInstitutional(SubscriptionScheduleLines."Account No",ClientTransactions."Contribution Type"::Employer)then
                ClientTransactions."Transaction Sub Type":=ClientTransactions."Transaction Sub Type"::additional
              else
                ClientTransactions."Transaction Sub Type":=ClientTransactions."Transaction Sub Type"::Initial;

              ClientTransactions."Transaction Sub Type 2":=ClientTransactions."Transaction Sub Type 2"::"Bank Transfer";
              ClientTransactions."Transaction Sub Type 3" :=ClientTransactions."Transaction Sub Type 3"::"Cash Deposits & Bank Account Transfers";
              if ClientTransactions.Narration='' then begin
                if ClientTransactions."Transaction Type"=ClientTransactions."Transaction Sub Type"::Initial then
                  NarrationText:=GetNarration(NarrationTransType::"Subscription Initial")
                else
                  NarrationText:=GetNarration(NarrationTransType::"Subscription Additional");
                if NarrationText<>'' then
                    ClientTransactions.Narration:=NarrationText+'-'+SubscriptionSchedulesHeader."Schedule No"
                else
                   ClientTransactions.Narration:='Employer -'+Format(ClientTransactions."Transaction Sub Type");
              end;
              ClientTransactions."Transaction No":=SubscriptionSchedulesHeader."Schedule No";
              ClientTransactions.Amount:=SubscriptionScheduleLines."Employer Amount";
              ClientTransactions."No of Units":=SubscriptionScheduleLines."Employer No. Of Units";
              ClientTransactions."Price Per Unit":=SubscriptionScheduleLines."Price Per Unit";

              ClientTransactions."Agent Code":=SubscriptionScheduleLines."Agent Code";
              ClientTransactions."Created By":=UserId;
              ClientTransactions."Created Date Time":=CurrentDateTime;
              ClientTransactions."Transaction Source Document":=ClientTransactions."Transaction Source Document"::Subscription;
              if ClientTransactions.Amount<>0 then
              ClientTransactions.Insert(true);
            end;

              //Email Notification after posting Subscription
          NotificationFunctions.CreateNotificationEntry(1,UserId,CurrentDateTime,'Subscription Schedule ' + SubscriptionScheduleLines."Schedule Header",Format(SubscriptionScheduleLines."Line No"),
              SubscriptionScheduleLines."Client Name",SubscriptionScheduleLines."Client ID",'Posted',SubscriptionScheduleLines."Fund Code",SubscriptionScheduleLines."Account No",
          'Subscription',SubscriptionScheduleLines."Total Amount",23);

        until SubscriptionScheduleLines.Next=0;
        end else
          Error('There are no Lines to Post');

        Window.Close;
        SubscriptionSchedulesHeader.Posted:=true;
        SubscriptionSchedulesHeader."Posted By":=UserId;
        SubscriptionSchedulesHeader."Date Posted":=Today;
        SubscriptionSchedulesHeader."Time Posted":=Time;
        SubscriptionSchedulesHeader."Subscription Status":=SubscriptionSchedulesHeader."Subscription Status"::Posted;
        SubscriptionSchedulesHeader.Modify;
        Message('Schedule has been posted successfully');
    end;

    procedure UpdateSubscriptionSchedulePrice(SubscriptionSchedulesHeader: Record "Subscription Schedules Header")
    var
        ClientTransactions: Record "Client Transactions";
        SubscriptionScheduleLines: Record "Subscription Schedule Lines";
        EntryNo: Integer;
    begin
        if not Confirm('Are you sure you want to update this schedule?') then
          Error('');


        Window.Open('Updating Line No #1#######');

        SubscriptionScheduleLines.Reset;
        SubscriptionScheduleLines.SetRange("Schedule Header",SubscriptionSchedulesHeader."Schedule No");
        if SubscriptionScheduleLines.FindFirst then begin
          repeat
            Window.Update(1,SubscriptionScheduleLines."Line No");

           SubscriptionScheduleLines.Validate("Employee Amount");
           SubscriptionScheduleLines.Validate("Employer Amount");
           SubscriptionScheduleLines.Validate("Total Amount");
           SubscriptionScheduleLines.Modify;

        until SubscriptionScheduleLines.Next=0;
        end else
          Error('There are no Lines to update');

        Window.Close;

        Message('Schedule has been update successfully');
    end;

    procedure ValidateSubscriptionschedule(Subscription: Record Subscription)
    begin
        Subscription.TestField("Account No");
        Subscription.TestField("Client ID");
        Subscription.TestField("Fund Code");
        Subscription.TestField(Amount);
        Subscription.TestField("No. Of Units");
        Subscription.TestField("Price Per Unit");
        ValidateValuedateAgainstPrice(Subscription."Value Date",Subscription."Fund Code",'Subscription No',Subscription.No);
        if CheckifSubscriptionEntriesExist(Subscription.No) then
          Error('Unreversed Transactions exist for this Subscription No %1',Subscription.No);
    end;

    procedure SendSubScheduleforConfirm(SubscriptionSchedulesHeader: Record "Subscription Schedules Header")
    begin

        if SubscriptionSchedulesHeader."Line Total"=0 then
          Error('The schedule should have at least one line');
        SubscriptionSchedulesHeader.TestField("Value Date");
        SubscriptionSchedulesHeader.TestField("CLient ID");
        SubscriptionSchedulesHeader.TestField("Total Amount");
        if SubscriptionSchedulesHeader."Line Total"<>SubscriptionSchedulesHeader."Total Amount" then
          //Maxwell: Commented out the error message and set the value of the Line Total to the Total Amount.
          SubscriptionSchedulesHeader."Line Total":=SubscriptionSchedulesHeader."Total Amount";
          //ERROR('Total Amount must be Equal to Line Total');
        if not Confirm('Are you sure you want to send this schedule for confirmation?') then
          Error('');
        SubscriptionSchedulesHeader."Subscription Status":=SubscriptionSchedulesHeader."Subscription Status"::Confirmation;
        SubscriptionSchedulesHeader.Modify;

        //Email Notification after posting Subscription
          NotificationFunctions.CreateNotificationEntry(1,UserId,CurrentDateTime,'Subscription Schedule ' + SubscriptionSchedulesHeader."Schedule No",SubscriptionSchedulesHeader."Schedule No",
              SubscriptionSchedulesHeader."Client Name",SubscriptionSchedulesHeader."CLient ID",'Confirmed',SubscriptionSchedulesHeader."Fund Group",SubscriptionSchedulesHeader."Main Account",
          'Subscription',SubscriptionSchedulesHeader."Line Total",22);

        Message('Schedule send for confirmation Successfully');
    end;

    procedure CheckinitialSubscriptionExist(accno: Code[50]): Boolean
    var
        ClientTransactions: Record "Client Transactions";
    begin
        ClientTransactions.Reset;
        ClientTransactions.SetRange("Transaction Type",ClientTransactions."Transaction Type"::Subscription);
        ClientTransactions.SetRange("Account No",accno);
        if ClientTransactions.FindFirst then
          exit(true)
        else
          exit(false);
    end;

    procedure CheckinitialRedemptionExist(accno: Code[50]): Boolean
    var
        ClientTransactions: Record "Client Transactions";
    begin
        ClientTransactions.Reset;
        ClientTransactions.SetRange("Transaction Type",ClientTransactions."Transaction Type"::Redemption);
        ClientTransactions.SetRange("Account No",accno);
        if ClientTransactions.FindFirst then
          exit(true)
        else
          exit(false);
    end;

    procedure CheckifredempLinesExist(Redemption: Record "Redemption Schedule Header"): Boolean
    var
        RedemptionScheduleLines: Record "Redemption Schedule Lines";
    begin
        RedemptionScheduleLines.Reset;
        RedemptionScheduleLines.SetRange("Schedule Header",Redemption."Schedule No");
        if RedemptionScheduleLines.FindFirst then
            exit(true)
        else
          exit(false);
    end;

    procedure PostUnitswitch(UnitSwitchHeader: Record "Unit Switch Header")
    var
        ClientTransactions: Record "Client Transactions";
        UnitSwitchLines: Record "Unit Switch Lines";
        EntryNo: Integer;
        ClientAccount1: Record "Client Account";
        ClientAccount2: Record "Client Account";
    begin
        if not Confirm('Are you sure you want to post this schedule?') then
          Error('');

        if UnitSwitchHeader."Created By"=UserId then
          Error('You cannot post a transaction that you Created!!');
        Window.Open('Posting Line No #1#######');

        EntryNo:=GetLastTransactionNo;
        UnitSwitchLines.Reset;
        UnitSwitchLines.SetRange(UnitSwitchLines."Header No",UnitSwitchHeader."Transaction No");
        if UnitSwitchLines.FindFirst then begin
          repeat
            Window.Update(1,UnitSwitchLines."Line No");
        //employyee

            EntryNo:=EntryNo+1;
              ClientTransactions.Init;
              ClientTransactions."Entry No":=EntryNo;
              ClientTransactions."Transaction Type":=ClientTransactions."Transaction Type"::Redemption;
              ClientTransactions."Value Date":=UnitSwitchHeader."Value Date";
              ClientTransactions."Transaction Date":=UnitSwitchHeader."Transaction Date";
              ClientTransactions.Validate("Account No",UnitSwitchLines."From Account No");
              ClientTransactions.Validate("Client ID",UnitSwitchLines."From Client ID");
              ClientTransactions."Fund Code":=UnitSwitchLines."From Fund Code";
              ClientTransactions."Fund Sub Code":=UnitSwitchLines."From Fund Sub Account";
              ClientTransactions.Narration:=UnitSwitchLines.Remarks;
              //ClientTransactions.Narration:=RedemHeader.Remarks;
              if CheckinitialRedemptionExist(ClientTransactions."Account No") then
                ClientTransactions."Transaction Sub Type":=ClientTransactions."Transaction Sub Type"::additional
              else
                ClientTransactions."Transaction Sub Type":=ClientTransactions."Transaction Sub Type"::Initial;
              if UnitSwitchLines."Transfer Type"=UnitSwitchLines."Transfer Type"::Full then
              ClientTransactions."Transaction Sub Type":=ClientTransactions."Transaction Sub Type"::"Full Redemption"
              else
                ClientTransactions."Transaction Sub Type":=ClientTransactions."Transaction Sub Type"::"Part Redemption";
              ClientTransactions."Transaction Sub Type 2":=ClientTransactions."Transaction Sub Type 2"::"Unit Transfer";
              ClientTransactions."Transaction Sub Type 3" :=ClientTransactions."Transaction Sub Type 3"::"Unit Switch";
              if ClientTransactions.Narration='' then begin
                if ClientTransactions."Transaction Type"=ClientTransactions."Transaction Sub Type"::"Full Redemption" then
                  NarrationText:=GetNarration(NarrationTransType::"Account Transfer")
                else
                  NarrationText:=GetNarration(NarrationTransType::"Account Transfer");
                if NarrationText<>'' then
                    ClientTransactions.Narration:=NarrationText+'-'+UnitSwitchHeader."Transaction No"
                else
                   ClientTransactions.Narration:='Unit Switch -'+Format(ClientTransactions."Transaction Sub Type");
              end;
              ClientTransactions."Transaction No":=UnitSwitchHeader."Transaction No";
              ClientTransactions.Amount:=-Abs(UnitSwitchLines."From Employee Amount");
              ClientTransactions."No of Units":=-Abs(UnitSwitchLines."From Employee No. Of Units");
              ClientTransactions."Price Per Unit":=UnitSwitchLines."Price Per Unit";
              ClientTransactions.Currency:=UnitSwitchLines.Currency;
              ClientTransactions."Agent Code":=UnitSwitchLines."Agent Code";
              ClientTransactions."Created By":=UserId;
              ClientTransactions."Created Date Time":=CurrentDateTime;
              ClientTransactions."Transaction Source Document":=ClientTransactions."Transaction Source Document"::"Unit Switch";
              ClientTransactions."Contribution Type":=ClientTransactions."Contribution Type"::Employee;
              if ClientTransactions.Amount<>0 then
                ClientTransactions.Insert(true);

        //employer
         EntryNo:=EntryNo+1;
              ClientTransactions.Init;
              ClientTransactions."Entry No":=EntryNo;
              ClientTransactions."Transaction Type":=ClientTransactions."Transaction Type"::Redemption;
              ClientTransactions."Value Date":=UnitSwitchHeader."Value Date";
              ClientTransactions."Transaction Date":=UnitSwitchHeader."Transaction Date";
              ClientTransactions.Validate("Account No",UnitSwitchLines."From Account No");
              ClientTransactions.Validate("Client ID",UnitSwitchLines."From Client ID");
              ClientTransactions."Fund Code":=UnitSwitchLines."From Fund Code";
              ClientTransactions."Fund Sub Code":=UnitSwitchLines."From Fund Sub Account";
              ClientTransactions.Narration:=UnitSwitchLines.Remarks;
              //ClientTransactions.Narration:=RedemHeader.Remarks;
              if CheckinitialRedemptionExist(ClientTransactions."Account No") then
                ClientTransactions."Transaction Sub Type":=ClientTransactions."Transaction Sub Type"::additional
              else
                ClientTransactions."Transaction Sub Type":=ClientTransactions."Transaction Sub Type"::Initial;
              if UnitSwitchLines."Transfer Type"=UnitSwitchLines."Transfer Type"::Full then
              ClientTransactions."Transaction Sub Type":=ClientTransactions."Transaction Sub Type"::"Full Redemption"
              else
                ClientTransactions."Transaction Sub Type":=ClientTransactions."Transaction Sub Type"::"Part Redemption";
              ClientTransactions."Transaction Sub Type 2":=ClientTransactions."Transaction Sub Type 2"::"Unit Transfer";
              ClientTransactions."Transaction Sub Type 3" :=ClientTransactions."Transaction Sub Type 3"::"Unit Switch";
              if ClientTransactions.Narration='' then begin
                if ClientTransactions."Transaction Type"=ClientTransactions."Transaction Sub Type"::"Full Redemption" then
                  NarrationText:=GetNarration(NarrationTransType::"Account Transfer")
                else
                  NarrationText:=GetNarration(NarrationTransType::"Account Transfer");
                if NarrationText<>'' then
                    ClientTransactions.Narration:=NarrationText+'-'+UnitSwitchHeader."Transaction No"
                else
                   ClientTransactions.Narration:='Unit Switch -'+Format(ClientTransactions."Transaction Sub Type");
              end;
              ClientTransactions."Transaction No":=UnitSwitchHeader."Transaction No";
              ClientTransactions.Amount:=-Abs(UnitSwitchLines."From Employer Amount");
              ClientTransactions."No of Units":=-Abs(UnitSwitchLines."From Employer No. Of Units");
              ClientTransactions."Price Per Unit":=UnitSwitchLines."Price Per Unit";
              ClientTransactions.Currency:=UnitSwitchLines.Currency;
              ClientTransactions."Agent Code":=UnitSwitchLines."Agent Code";
              ClientTransactions."Created By":=UserId;
              ClientTransactions."Created Date Time":=CurrentDateTime;
              ClientTransactions."Transaction Source Document":=ClientTransactions."Transaction Source Document"::"Unit Switch";
              ClientTransactions."Contribution Type":=ClientTransactions."Contribution Type"::Employer;

              if ClientTransactions.Amount<>0 then
                ClientTransactions.Insert(true);

        //Employee new subscription
                EntryNo:=EntryNo+1;
                ClientTransactions.Init;
                ClientTransactions."Entry No":=EntryNo;
                ClientTransactions."Transaction Type":=ClientTransactions."Transaction Type"::Subscription;
                ClientTransactions."Value Date":=UnitSwitchHeader."Value Date";
                ClientTransactions."Transaction Date":=UnitSwitchHeader."Transaction Date";
                ClientTransactions.Validate("Account No",UnitSwitchLines."To Account No");
                ClientTransactions.Validate("Client ID",UnitSwitchLines."To Client ID");
                ClientTransactions."Fund Code":=UnitSwitchLines."To Fund Code";
                ClientTransactions."Fund Sub Code":=UnitSwitchLines."To Fund Sub Account";
                ClientTransactions.Narration:=UnitSwitchLines.Remarks;
                if CheckinitialSubscriptionExist (ClientTransactions."Account No") then
                ClientTransactions."Transaction Sub Type":=ClientTransactions."Transaction Sub Type"::additional
              else
                ClientTransactions."Transaction Sub Type":=ClientTransactions."Transaction Sub Type"::Initial;

              ClientTransactions."Transaction Sub Type 2":=ClientTransactions."Transaction Sub Type 2"::"Unit Transfer";
              ClientTransactions."Transaction Sub Type 3" :=ClientTransactions."Transaction Sub Type 3"::"Unit Switch";
              if ClientTransactions.Narration='' then begin
                if ClientTransactions."Transaction Type"=ClientTransactions."Transaction Sub Type"::"Full Redemption" then
                  NarrationText:=GetNarration(NarrationTransType::"Account Transfer")
                else
                  NarrationText:=GetNarration(NarrationTransType::"Account Transfer");
                if NarrationText<>'' then
                    ClientTransactions.Narration:=NarrationText+'-'+UnitSwitchHeader."Transaction No"
                else
                   ClientTransactions.Narration:='Unit Switch -'+Format(ClientTransactions."Transaction Sub Type");
              end;
                ClientTransactions."Transaction No":=UnitSwitchHeader."Transaction No";
                ClientTransactions.Amount:=UnitSwitchLines."To Employee Amount";
                ClientTransactions."No of Units":=UnitSwitchLines."To Employee No. Of Units";
                ClientTransactions."Price Per Unit":=UnitSwitchLines."To Price Per Unit";
                ClientTransactions.Currency:=UnitSwitchLines.Currency;
                ClientTransactions."Agent Code":=UnitSwitchLines."Agent Code";
                ClientTransactions."Created By":=UserId;
                ClientTransactions."Created Date Time":=CurrentDateTime;
                ClientTransactions."Transaction Source Document":=ClientTransactions."Transaction Source Document"::"Unit Switch";
                ClientTransactions."Contribution Type":=ClientTransactions."Contribution Type"::Employee;
                if ClientTransactions.Amount<>0 then
                ClientTransactions.Insert(true);

        //Employer new subscription
                EntryNo:=EntryNo+1;
                ClientTransactions.Init;
                ClientTransactions."Entry No":=EntryNo;
                ClientTransactions."Transaction Type":=ClientTransactions."Transaction Type"::Subscription;
                ClientTransactions."Value Date":=UnitSwitchHeader."Value Date";
                ClientTransactions."Transaction Date":=UnitSwitchHeader."Transaction Date";
                ClientTransactions.Validate("Account No",UnitSwitchLines."To Account No");
                ClientTransactions.Validate("Client ID",UnitSwitchLines."To Client ID");
                ClientTransactions."Fund Code":=UnitSwitchLines."To Fund Code";
                ClientTransactions."Fund Sub Code":=UnitSwitchLines."To Fund Sub Account";
                ClientTransactions.Narration:=UnitSwitchLines.Remarks;
                if CheckinitialSubscriptionExist (ClientTransactions."Account No") then
                ClientTransactions."Transaction Sub Type":=ClientTransactions."Transaction Sub Type"::additional
              else
                ClientTransactions."Transaction Sub Type":=ClientTransactions."Transaction Sub Type"::Initial;

              ClientTransactions."Transaction Sub Type 2":=ClientTransactions."Transaction Sub Type 2"::"Unit Transfer";
              ClientTransactions."Transaction Sub Type 3" :=ClientTransactions."Transaction Sub Type 3"::"Unit Switch";
              if ClientTransactions.Narration='' then begin
                if ClientTransactions."Transaction Type"=ClientTransactions."Transaction Sub Type"::"Full Redemption" then
                  NarrationText:=GetNarration(NarrationTransType::"Account Transfer")
                else
                  NarrationText:=GetNarration(NarrationTransType::"Account Transfer");
                if NarrationText<>'' then
                    ClientTransactions.Narration:=NarrationText+'-'+UnitSwitchHeader."Transaction No"
                else
                   ClientTransactions.Narration:='Unit Switch -'+Format(ClientTransactions."Transaction Sub Type");
              end;
                ClientTransactions."Transaction No":=UnitSwitchHeader."Transaction No";
                ClientTransactions.Amount:=UnitSwitchLines."To Employer Amount";
                ClientTransactions."No of Units":=UnitSwitchLines."To Employer No. Of Units";
                ClientTransactions."Price Per Unit":=UnitSwitchLines."To Price Per Unit";
                ClientTransactions.Currency:=UnitSwitchLines.Currency;
                ClientTransactions."Agent Code":=UnitSwitchLines."Agent Code";
                ClientTransactions."Created By":=UserId;
                ClientTransactions."Created Date Time":=CurrentDateTime;
                ClientTransactions."Transaction Source Document":=ClientTransactions."Transaction Source Document"::"Unit Switch";
                ClientTransactions."Contribution Type":=ClientTransactions."Contribution Type"::Employer;
                if ClientTransactions.Amount<>0 then
                ClientTransactions.Insert(true);
         ClientAccount.Reset;


        until UnitSwitchLines.Next=0;
        end else
          Error('There are no Lines to Post');

        Window.Close;
         UnitSwitchHeader.Posted:=true;
        UnitSwitchHeader."Posted By":=UserId;
        UnitSwitchHeader."Date Posted":=Today;
        UnitSwitchHeader."Time Posted":=Time;
        UnitSwitchHeader."Switch Status":=UnitSwitchHeader."Switch Status"::Posted;
        UnitSwitchHeader.Modify;
        Message('Unit Schedule posted Successfully');
    end;

    procedure SendUnitSwitchforConfirm(UnitSwitchHeader: Record "Unit Switch Header")
    begin
        if not Confirm('Are you sure you want to send this schedule for confirmation?') then
          Error('');
        UnitSwitchHeader.TestField("Value Date");
        UnitSwitchHeader.TestField("CLient ID");

        UnitSwitchHeader."Switch Status":=UnitSwitchHeader."Switch Status"::Confirmation;
        UnitSwitchHeader.Modify;
        Message('Unit Schedule send for confirmation Successfully');
    end;

    procedure ValidateValuedateAgainstPrice(ValueDate: Date;Fundcode: Code[50];Text: Text;TransactionNo: Code[50])
    var
        FundPrices: Record "Fund Prices";
        IncomeRegister: Record "Income Register";
        Fund: Record Fund;
        DailyIncomeRegister: Record "Daily Distributable Income";
    begin
        //Check that EOD has not been Run
        
        
        
        
        
        EODTracker.Reset;
        EODTracker.SetRange(Date,ValueDate);
        EODTracker.SetRange("Fund Code",Fundcode);
        if EODTracker.FindFirst then
          Error('You cannot Post into Date %1 since EOD has been Run',ValueDate);
        
        
        //check if dividend has been distributed
        Fund.Reset;
        if Fund.Get(Fundcode) then begin
         if Fund."Dividend Period"<>Fund."Dividend Period"::"No Dividend" then begin
           /*IncomeRegister.RESET;
           IncomeRegister.SETRANGE("Fund ID",Fundcode);
           IncomeRegister.SETRANGE("Value Date",CALCDATE('-1D',ValueDate));
           IncomeRegister.SETRANGE(Distributed,TRUE);
           IF NOT IncomeRegister.FINDFIRST THEN
             ERROR('Please Distribute Income for %1 for fund %2 before posting transactions',CALCDATE('-1D',ValueDate),Fundcode);*/
        
          // Added by Maxwell for DI Optimization Q2 2023.
           DailyIncomeRegister.Reset;
           DailyIncomeRegister.SetRange("Fund Code",Fundcode);
           DailyIncomeRegister.SetRange(Date, CalcDate('-1D',ValueDate));
           DailyIncomeRegister.SetRange(Distributed, true);
           if not DailyIncomeRegister.FindFirst then
            Error('Please Distribute Income for %1 for fund %2 before posting transactions',CalcDate('-1D',ValueDate),Fundcode);
          end
        end;
        
        FundPrices.Reset;
        FundPrices.SetRange("Fund No.",Fundcode);
        FundPrices.SetRange(Activated,true);
        if FundPrices.FindLast then begin
          if FundPrices."Value Date">ValueDate then  begin
           Error(StrSubstNo('%1 %2 Value date (%3) is less than the last updated price of Value date(%4)',Text,TransactionNo,ValueDate,FundPrices."Value Date"));
          end
          else if FundPrices."Value Date"<ValueDate then
            begin
           Error(StrSubstNo('%1 %2 Value date (%3) is greater than the last updated price of Value date(%4)',Text,TransactionNo,ValueDate,FundPrices."Value Date"));
          end
        
        end
        else Error('There is no Active fund price for Fund %1',Fundcode);

    end;

    procedure RunReconmatch(SubscriptionMatchingheader: Record "Subscription Matching header")
    var
        SubscriptionMatchingLines: Record "Subscription Matching Lines";
        ClientAccount: Record "Client Account";
        Client: Record Client;
        SubscriptionReconLines: Record "Subscription Recon Lines";
        Submatchline: Text;
    begin
        Window.Open('Matching Line No #1#######');
        SubscriptionMatchingheader.TestField("Fund Code");
        SubscriptionMatchingLines.Reset;
        SubscriptionMatchingLines.SetRange("Fund Code",SubscriptionMatchingheader."Fund Code");
        SubscriptionMatchingLines.SetRange("Header Transaction  Date",SubscriptionMatchingheader."Transaction Date");
        SubscriptionMatchingLines.SetRange("Bank code",SubscriptionMatchingheader."Bank Code");
        //Maxwell: Uncommmented the line below to test subscription recon
        SubscriptionMatchingLines.SetRange("Header No",SubscriptionMatchingheader.No);
        //SubscriptionMatchingLines.SETRANGE(Posted,TRUE);
        if SubscriptionMatchingLines.FindFirst then
         repeat
            Window.Update(1,SubscriptionMatchingLines."Line No");
            SubscriptionReconLines.Reset;
            SubscriptionReconLines.SetRange("Fund Code",SubscriptionMatchingheader."Fund Code");
             SubscriptionReconLines.SetRange("Header Value Date",SubscriptionMatchingheader."Transaction Date");
             SubscriptionReconLines.SetRange("Bank code",SubscriptionMatchingheader."Bank Code");
           SubscriptionReconLines.SetRange(Reference,SubscriptionMatchingLines.Reference);
           SubscriptionReconLines.SetRange("Credit Amount",SubscriptionMatchingLines."Credit Amount");
            SubscriptionReconLines.SetRange("Debit Amount",SubscriptionMatchingLines."Debit Amount");
            SubscriptionReconLines.SetRange(Reconciled,false);
            if SubscriptionReconLines.FindFirst then begin
              SubscriptionMatchingLines.Reconciled:=true;
              SubscriptionMatchingLines."Reconciled Line No":=SubscriptionReconLines."Line No";
              SubscriptionMatchingLines.Modify;

              SubscriptionReconLines.Reconciled:=true;
              SubscriptionReconLines."Reconciled Line No":=SubscriptionMatchingLines."Line No";
              SubscriptionReconLines.Modify;

            end else begin
              SubscriptionReconLines.Reset;
              SubscriptionReconLines.SetRange("Fund Code",SubscriptionMatchingheader."Fund Code");
              SubscriptionReconLines.SetRange("Header Value Date",SubscriptionMatchingheader."Transaction Date");
              SubscriptionReconLines.SetRange("Bank code",SubscriptionMatchingheader."Bank Code");
              //Max: Uncommmented the line below to test subscription recon
              SubscriptionReconLines.SetRange(Narration,SubscriptionMatchingLines.Narration);
              //
              SubscriptionReconLines.SetRange("Credit Amount",SubscriptionMatchingLines."Credit Amount");
              SubscriptionReconLines.SetRange("Debit Amount",SubscriptionMatchingLines."Debit Amount");
               SubscriptionReconLines.SetRange(Reconciled,false);
                // delete white spaces
                 //Maxwell: commmented out the lines of code below to test subscription recon

                //ReplaceString(SubscriptionMatchingLines.Narration,' ','',Submatchline);
                //SubscriptionReconLines.SETRANGE(NarrationWithoutSpace,Submatchline);


              if SubscriptionReconLines.FindFirst then begin
                SubscriptionMatchingLines.Reconciled:=true;
                SubscriptionMatchingLines."Reconciled Line No":=SubscriptionReconLines."Line No";
                SubscriptionMatchingLines.Modify;

                SubscriptionReconLines.Reconciled:=true;
                SubscriptionReconLines."Reconciled Line No":=SubscriptionMatchingLines."Line No";
                SubscriptionReconLines.Modify;
              end else begin
              SubscriptionReconLines.Reset;
            SubscriptionReconLines.SetRange("Fund Code",SubscriptionMatchingheader."Fund Code");
        SubscriptionReconLines.SetRange("Header Value Date",SubscriptionMatchingheader."Transaction Date");
        SubscriptionReconLines.SetRange("Bank code",SubscriptionMatchingheader."Bank Code");
              SubscriptionReconLines.SetRange("Manual Reference",Format(SubscriptionMatchingLines."Line No"));
              SubscriptionReconLines.SetRange("Credit Amount",SubscriptionMatchingLines."Credit Amount");
              SubscriptionReconLines.SetRange("Debit Amount",SubscriptionMatchingLines."Debit Amount");
               SubscriptionReconLines.SetRange(Reconciled,false);

              if SubscriptionReconLines.FindFirst then begin
                SubscriptionMatchingLines.Reconciled:=true;
                SubscriptionMatchingLines."Reconciled Line No":=SubscriptionReconLines."Line No";
                SubscriptionMatchingLines.Modify;

                SubscriptionReconLines.Reconciled:=true;
                SubscriptionReconLines."Reconciled Line No":=SubscriptionMatchingLines."Line No";
                SubscriptionReconLines.Modify;
              end

            end;
          end;
          until SubscriptionMatchingLines.Next=0;
          Window.Close;
    end;

    procedure RunReconmatch2(SubscriptionMatchingheader: Record "Subscription Matching header")
    var
        SubscriptionMatchingLines: Record "Subscription Matching Lines";
        ClientAccount: Record "Client Account";
        Client: Record Client;
        SubscriptionReconLines: Record "Subscription Recon Lines";
        Submatchline: Text;
    begin
        // Window.OPEN('Matching Line No #1#######');
        // SubscriptionMatchingheader.TESTFIELD("Fund Code");
        // SubscriptionMatchingLines.RESET;
        // SubscriptionMatchingLines.SETRANGE("Fund Code",SubscriptionMatchingheader."Fund Code");
        // SubscriptionMatchingLines.SETRANGE("Header Transaction  Date",SubscriptionMatchingheader."Transaction Date");
        // SubscriptionMatchingLines.SETRANGE("Bank code",SubscriptionMatchingheader."Bank Code");
        // //Maxwell: commmented the line below to test subscription recon
        // //SubscriptionMatchingLines.SETRANGE("Header No",SubscriptionMatchingheader.No);
        // //
        // //SubscriptionMatchingLines.SETRANGE(Posted,TRUE);
        // IF SubscriptionMatchingLines.FINDFIRST THEN
        // REPEAT
        //    Window.UPDATE(1,SubscriptionMatchingLines."Line No");
        //    SubscriptionReconLines.RESET;
        //   { SubscriptionReconLines.SETRANGE("Fund Code",SubscriptionMatchingheader."Fund Code");
        //     SubscriptionReconLines.SETRANGE("Header Value Date",SubscriptionMatchingheader."Transaction Date");
        //     SubscriptionReconLines.SETRANGE("Bank code",SubscriptionMatchingheader."Bank Code");}
        //     SubscriptionReconLines.SETRANGE("Header No",SubscriptionMatchingheader.No);
        //    SubscriptionReconLines.SETRANGE(Reference,SubscriptionMatchingLines.Reference);
        //   SubscriptionReconLines.SETRANGE("Credit Amount",SubscriptionMatchingLines."Credit Amount");
        //    SubscriptionReconLines.SETRANGE("Debit Amount",SubscriptionMatchingLines."Debit Amount");
        //    SubscriptionReconLines.SETRANGE(Reconciled,FALSE);
        //   IF SubscriptionReconLines.FINDFIRST THEN BEGIN
        //      SubscriptionMatchingLines.Reconciled:=TRUE;
        //      SubscriptionMatchingLines."Reconciled Line No":=SubscriptionReconLines."Line No";
        //      SubscriptionMatchingLines.MODIFY;
        //
        //      SubscriptionReconLines.Reconciled:=TRUE;
        //      SubscriptionReconLines."Reconciled Line No":=SubscriptionMatchingLines."Line No";
        //      SubscriptionReconLines.MODIFY;
        //
        //    END ELSE BEGIN
        //      SubscriptionReconLines.RESET;
        //     { SubscriptionReconLines.SETRANGE("Fund Code",SubscriptionMatchingheader."Fund Code");
        //      SubscriptionReconLines.SETRANGE("Header Value Date",SubscriptionMatchingheader."Transaction Date");
        //      SubscriptionReconLines.SETRANGE("Bank code",SubscriptionMatchingheader."Bank Code");}
        //
        //      //Max: commmented the line below to test subscription recon
        //       //SubscriptionReconLines.SETRANGE("Header No",SubscriptionMatchingheader.No);
        //       //SubscriptionReconLines.SETRANGE(Narration,SubscriptionMatchingLines.Narration);
        //      //
        //      SubscriptionReconLines.SETRANGE("Credit Amount",SubscriptionMatchingLines."Credit Amount");
        //      SubscriptionReconLines.SETRANGE("Debit Amount",SubscriptionMatchingLines."Debit Amount");
        //       SubscriptionReconLines.SETRANGE(Reconciled,FALSE);
        //        // delete white spaces
        //         //Maxwell: commmented out the lines of code below to test subscription recon
        //
        //        ReplaceString(SubscriptionMatchingLines.Narration,' ','',Submatchline);
        //        SubscriptionReconLines.SETRANGE(NarrationWithoutSpace,Submatchline);
        //
        //
        //      IF SubscriptionReconLines.FINDFIRST THEN BEGIN
        //        SubscriptionMatchingLines.Reconciled:=TRUE;
        //        SubscriptionMatchingLines."Reconciled Line No":=SubscriptionReconLines."Line No";
        //        SubscriptionMatchingLines.MODIFY;
        //
        //        SubscriptionReconLines.Reconciled:=TRUE;
        //        SubscriptionReconLines."Reconciled Line No":=SubscriptionMatchingLines."Line No";
        //        SubscriptionReconLines.MODIFY;
        //      END ELSE BEGIN
        //      SubscriptionReconLines.RESET;
        //    SubscriptionReconLines.SETRANGE("Fund Code",SubscriptionMatchingheader."Fund Code");
        // SubscriptionReconLines.SETRANGE("Header Value Date",SubscriptionMatchingheader."Transaction Date");
        // SubscriptionReconLines.SETRANGE("Bank code",SubscriptionMatchingheader."Bank Code");
        //      SubscriptionReconLines.SETRANGE("Manual Reference",FORMAT(SubscriptionMatchingLines."Line No"));
        //      SubscriptionReconLines.SETRANGE("Credit Amount",SubscriptionMatchingLines."Credit Amount");
        //      SubscriptionReconLines.SETRANGE("Debit Amount",SubscriptionMatchingLines."Debit Amount");
        //       SubscriptionReconLines.SETRANGE(Reconciled,FALSE);
        //
        //      IF SubscriptionReconLines.FINDFIRST THEN BEGIN
        //        SubscriptionMatchingLines.Reconciled:=TRUE;
        //        SubscriptionMatchingLines."Reconciled Line No":=SubscriptionReconLines."Line No";
        //        SubscriptionMatchingLines.MODIFY;
        //
        //        SubscriptionReconLines.Reconciled:=TRUE;
        //        SubscriptionReconLines."Reconciled Line No":=SubscriptionMatchingLines."Line No";
        //        SubscriptionReconLines.MODIFY;
        //      END
        //
        //    END;
        //  END;
        // UNTIL SubscriptionMatchingLines.NEXT=0;
        //  Window.CLOSE;
        
        
        //updated by bayo 20-01-2022
        
        Window.Open('Matching Line No #1#######');
        SubscriptionMatchingheader.TestField("Fund Code");
        SubscriptionMatchingLines.Reset;
        SubscriptionMatchingLines.SetRange("Fund Code",SubscriptionMatchingheader."Fund Code");
        SubscriptionMatchingLines.SetRange("Header Transaction  Date",SubscriptionMatchingheader."Transaction Date");
        SubscriptionMatchingLines.SetRange("Bank code",SubscriptionMatchingheader."Bank Code");
        //Maxwell: commmented the line below to test subscription recon
        //SubscriptionMatchingLines.SETRANGE("Header No",SubscriptionMatchingheader.No);
        //
        //SubscriptionMatchingLines.SETRANGE(Posted,TRUE);
        if SubscriptionMatchingLines.FindFirst then
         repeat
            Window.Update(1,SubscriptionMatchingLines."Line No");
            SubscriptionReconLines.Reset;
           /* SubscriptionReconLines.SETRANGE("Fund Code",SubscriptionMatchingheader."Fund Code");
             SubscriptionReconLines.SETRANGE("Header Value Date",SubscriptionMatchingheader."Transaction Date");
             SubscriptionReconLines.SETRANGE("Bank code",SubscriptionMatchingheader."Bank Code");*/
             SubscriptionReconLines.SetRange("Header No",SubscriptionMatchingheader.No);
            SubscriptionReconLines.SetRange(Reference,SubscriptionMatchingLines.Reference);
           SubscriptionReconLines.SetRange("Credit Amount",SubscriptionMatchingLines."Credit Amount");
            SubscriptionReconLines.SetRange("Debit Amount",SubscriptionMatchingLines."Debit Amount");
            SubscriptionReconLines.SetRange(Reconciled,false);
           if SubscriptionReconLines.FindFirst then begin
              SubscriptionMatchingLines.Reconciled:=true;
              SubscriptionMatchingLines."Reconciled Line No":=SubscriptionReconLines."Line No";
              SubscriptionMatchingLines.Modify;
        
              SubscriptionReconLines.Reconciled:=true;
              SubscriptionReconLines."Reconciled Line No":=SubscriptionMatchingLines."Line No";
              SubscriptionReconLines.Modify;
        
            end else begin
              SubscriptionReconLines.Reset;
             /* SubscriptionReconLines.SETRANGE("Fund Code",SubscriptionMatchingheader."Fund Code");
              SubscriptionReconLines.SETRANGE("Header Value Date",SubscriptionMatchingheader."Transaction Date");
              SubscriptionReconLines.SETRANGE("Bank code",SubscriptionMatchingheader."Bank Code");*/
        
              //Max: commmented the line below to test subscription recon
               //SubscriptionReconLines.SETRANGE("Header No",SubscriptionMatchingheader.No);
               //SubscriptionReconLines.SETRANGE(Narration,SubscriptionMatchingLines.Narration);
              //
              SubscriptionReconLines.SetRange("Credit Amount",SubscriptionMatchingLines."Credit Amount");
              SubscriptionReconLines.SetRange("Debit Amount",SubscriptionMatchingLines."Debit Amount");
               SubscriptionReconLines.SetRange(Reconciled,false);
                // delete white spaces
                 //Maxwell: commmented out the lines of code below to test subscription recon
        
                ReplaceString(SubscriptionMatchingLines.Narration,' ','',Submatchline);
                SubscriptionReconLines.SetRange(NarrationWithoutSpace,Submatchline);
        
        
              if SubscriptionReconLines.FindFirst then begin
                SubscriptionMatchingLines.Reconciled:=true;
                SubscriptionMatchingLines."Reconciled Line No":=SubscriptionReconLines."Line No";
                SubscriptionMatchingLines.Modify;
        
                SubscriptionReconLines.Reconciled:=true;
                SubscriptionReconLines."Reconciled Line No":=SubscriptionMatchingLines."Line No";
                SubscriptionReconLines.Modify;
              end else begin
              SubscriptionReconLines.Reset;
            SubscriptionReconLines.SetRange("Fund Code",SubscriptionMatchingheader."Fund Code");
        SubscriptionReconLines.SetRange("Header Value Date",SubscriptionMatchingheader."Transaction Date");
        SubscriptionReconLines.SetRange("Bank code",SubscriptionMatchingheader."Bank Code");
              SubscriptionReconLines.SetRange("Manual Reference",Format(SubscriptionMatchingLines."Line No"));
              SubscriptionReconLines.SetRange("Credit Amount",SubscriptionMatchingLines."Credit Amount");
              SubscriptionReconLines.SetRange("Debit Amount",SubscriptionMatchingLines."Debit Amount");
               SubscriptionReconLines.SetRange(Reconciled,false);
        
              if SubscriptionReconLines.FindFirst then begin
                SubscriptionMatchingLines.Reconciled:=true;
                SubscriptionMatchingLines."Reconciled Line No":=SubscriptionReconLines."Line No";
                SubscriptionMatchingLines.Modify;
        
                SubscriptionReconLines.Reconciled:=true;
                SubscriptionReconLines."Reconciled Line No":=SubscriptionMatchingLines."Line No";
                SubscriptionReconLines.Modify;
              end
        
            end;
          end;
        until SubscriptionMatchingLines.Next=0;
          Window.Close;

    end;

    procedure UpdateUnitswitchprices(UnitSwitchHeader: Record "Unit Switch Header")
    var
        ClientTransactions: Record "Client Transactions";
        UnitSwitchLines: Record "Unit Switch Lines";
        EntryNo: Integer;
    begin
        if not Confirm('Are you sure you want to Update this schedule?') then
          Error('');
        Window.Open('Updating Line No #1#######');

        EntryNo:=GetLastTransactionNo;
        UnitSwitchLines.Reset;
        UnitSwitchLines.SetRange(UnitSwitchLines."Header No",UnitSwitchHeader."Transaction No");
        if UnitSwitchLines.FindFirst then begin
          repeat
            Window.Update(1,UnitSwitchLines."Line No");
            UnitSwitchLines.Validate("From Account No");
            UnitSwitchLines.Validate("To Account No");

            UnitSwitchLines.Validate("No. Of Units");
            UnitSwitchLines.Modify;
        until UnitSwitchLines.Next=0;
        end else
          Error('There are no Lines to Update');

        Window.Close;
        Message('Prices Updated Successfully');
    end;

    procedure GetBankCharges(Fundcode: Code[40];Amount: Decimal): Decimal
    begin
        FundPayoutCharges.Reset;
        FundPayoutCharges.SetRange("Fund No",Fundcode);
        FundPayoutCharges.SetFilter("Lower Limit",'<%1',Amount);
        FundPayoutCharges.SetFilter("Upper Limit",'>%1',Amount);
        if FundPayoutCharges.FindFirst then
          exit(FundPayoutCharges.Fee)
        else
          exit(0);
    end;

    procedure RunRedReconmatch(SubscriptionMatchingheader: Record "Redemption Recon header")
    var
        PostedRedemption: Record "Posted Redemption";
        ClientAccount: Record "Client Account";
        Client: Record Client;
        RedemptionReconLines: Record "Redemption Recon Lines";
    begin
        /*Window.OPEN('Matching Line No #1#######');
        SubscriptionMatchingheader.TESTFIELD("Fund Code");
        PostedRedemption.RESET;
        PostedRedemption.SETRANGE("Value Date",SubscriptionMatchingheader."Value Date");
        PostedRedemption.SETRANGE("Fund Code",SubscriptionMatchingheader."Fund Code");
        PostedRedemption.SETRANGE(Posted,TRUE);
        IF PostedRedemption.FINDFIRST THEN
          REPEAT
            Window.UPDATE(1,PostedRedemption.No);
            RedemptionReconLines.RESET;
            RedemptionReconLines.SETRANGE("Header No",SubscriptionMatchingheader.No);
            RedemptionReconLines.SETRANGE(Reference,PostedRedemption."Account No");
            RedemptionReconLines.SETRANGE("Total Amount",PostedRedemption."Total Amount Payable");
        
            IF RedemptionReconLines.FINDFIRST THEN BEGIN
              PostedRedemption.Reconciled:=TRUE;
              PostedRedemption."Reconciled Line No":=RedemptionReconLines."Line No";
              PostedRedemption.MODIFY;
        
              RedemptionReconLines.Reconciled:=TRUE;
              RedemptionReconLines."Reconciled Line No":=PostedRedemption.No;
              RedemptionReconLines.MODIFY;
        
            END ELSE BEGIN
              RedemptionReconLines.RESET;
             RedemptionReconLines.RESET;
            RedemptionReconLines.SETRANGE("Header No",SubscriptionMatchingheader.No);
            RedemptionReconLines.SETRANGE(Reference,PostedRedemption."Client ID");
            RedemptionReconLines.SETRANGE("Total Amount",PostedRedemption."Total Amount Payable");
              IF RedemptionReconLines.FINDFIRST THEN BEGIN
                PostedRedemption.Reconciled:=TRUE;
                PostedRedemption."Reconciled Line No":=RedemptionReconLines."Line No";
                PostedRedemption.MODIFY;
        
                RedemptionReconLines.Reconciled:=TRUE;
                RedemptionReconLines."Reconciled Line No":=PostedRedemption.No;
                RedemptionReconLines.MODIFY;
        
              END ELSE BEGIN
              RedemptionReconLines.RESET;
             RedemptionReconLines.RESET;
            RedemptionReconLines.SETRANGE("Header No",SubscriptionMatchingheader.No);
            RedemptionReconLines.SETRANGE("Manual Reference",PostedRedemption.No);
            RedemptionReconLines.SETRANGE("Total Amount",PostedRedemption."Total Amount Payable");
              IF RedemptionReconLines.FINDFIRST THEN BEGIN
                PostedRedemption.Reconciled:=TRUE;
                PostedRedemption."Reconciled Line No":=RedemptionReconLines."Line No";
                PostedRedemption.MODIFY;
        
                RedemptionReconLines.Reconciled:=TRUE;
                RedemptionReconLines."Reconciled Line No":=PostedRedemption.No;
                RedemptionReconLines.MODIFY;
              END
            END;
            END
        
          UNTIL PostedRedemption.NEXT=0;
          Window.CLOSE;*/
        
        
        // commented out by bayo for update 20-01-2022
        
        
        // //Maxwell: To reconcile Redemption based on transaction no.
        //  Window.OPEN('Matching Line No #1#######');
        //  SubscriptionMatchingheader.TESTFIELD("Fund Code");
        //  PostedRedemption.RESET;
        //  PostedRedemption.SETRANGE("Value Date",SubscriptionMatchingheader."Value Date");
        //  PostedRedemption.SETRANGE("Fund Code",SubscriptionMatchingheader."Fund Code");
        //  PostedRedemption.SETRANGE(Posted,TRUE);
        //  IF PostedRedemption.FINDFIRST THEN
        //  REPEAT
        //    Window.UPDATE(1,PostedRedemption."Recon No");
        //    RedemptionReconLines.RESET;
        //    RedemptionReconLines.SETRANGE("Header No",SubscriptionMatchingheader.No);
        //    RedemptionReconLines.SETRANGE(Reference,PostedRedemption."Recon No");
        //    RedemptionReconLines.SETRANGE("Total Amount",ROUND(PostedRedemption."Total Amount Payable",0.01,'='));
        //    {IF PostedRedemption."Redemption Type" <> PostedRedemption."Redemption Type"::Part THEN
        //      RedemptionReconLines.SETRANGE("Total Amount",(PostedRedemption."Total Amount Payable" + PostedRedemption."Fee Amount"));}
        //
        //    IF RedemptionReconLines.FINDFIRST THEN BEGIN
        //      PostedRedemption.Reconciled:=TRUE;
        //      PostedRedemption."Reconciled Line No":=RedemptionReconLines."Line No";
        //      PostedRedemption.MODIFY;
        //
        //      RedemptionReconLines.Reconciled:=TRUE;
        //      RedemptionReconLines."Reconciled Line No":=PostedRedemption."Recon No";
        //      RedemptionReconLines.MODIFY;
        //    END;
        //   UNTIL PostedRedemption.NEXT=0;
        //  Window.CLOSE;
        
        //updated by bayo 20-01-2022
        
        Window.Open('Matching Line No #1#######');
          SubscriptionMatchingheader.TestField("Fund Code");
          PostedRedemption.Reset;
          PostedRedemption.SetRange("Value Date",SubscriptionMatchingheader."Value Date");
          PostedRedemption.SetRange("Fund Code",SubscriptionMatchingheader."Fund Code");
          PostedRedemption.SetRange(Posted,true);
          if PostedRedemption.FindFirst then
          repeat
            Window.Update(1,PostedRedemption."Recon No");
            RedemptionReconLines.Reset;
            RedemptionReconLines.SetRange("Header No",SubscriptionMatchingheader.No);
            RedemptionReconLines.SetRange(Reference,PostedRedemption."Recon No");
            RedemptionReconLines.SetFilter("Credit Amount",'%1|%2',Round(PostedRedemption."Net Amount Payable",0.01,'<'),Round(PostedRedemption."Net Amount Payable",0.01,'>'));
        
            if RedemptionReconLines.FindFirst then begin
              PostedRedemption.Reconciled:=true;
              PostedRedemption."Reconciled Line No":=RedemptionReconLines."Line No";
              PostedRedemption.Modify;
        
              RedemptionReconLines.Reconciled:=true;
              RedemptionReconLines."Reconciled Line No":=PostedRedemption."Recon No";
              RedemptionReconLines.Modify;
            end;
           until PostedRedemption.Next=0;
          Window.Close;

    end;

    procedure ExportLargeTransactionsTotreasury()
    var
        PostedRedemption: Record "Posted Redemption";
        ExportRedemptionsToBank: Report "Export Payment Schedule";
    begin
        ExportRedemptionsToBank.SetTableView(PostedRedemption);
        ExportRedemptionsToBank.Run
    end;

    procedure UpdateSubscriptionsPrice(Subscription: Record Subscription)
    var
        ClientTransactions: Record "Client Transactions";
        SubscriptionScheduleLines: Record "Subscription Schedule Lines";
        EntryNo: Integer;
    begin
        if not Confirm('Are you sure you want to update this subscriptions?') then
          Error('');


        Window.Open('Updating Line No #1#######');

        Subscription.Reset;
        if Subscription.FindFirst then begin
          repeat
            Window.Update(1,Subscription.No);
           Subscription.Validate(Amount);
           Subscription.Modify;

        until Subscription.Next=0;
        end else begin
          Window.Close;
          Error('There are no Lines to update');
        end;
        Window.Close;

        Message('Subscription has been update successfully');
    end;

    procedure UpdateRedemptionsPrice(Redemption: Record Redemption)
    var
        ClientTransactions: Record "Client Transactions";
        SubscriptionScheduleLines: Record "Subscription Schedule Lines";
        EntryNo: Integer;
    begin
        if not Confirm('Are you sure you want to update this Redemptions?') then
          Error('');


        Window.Open('Updating Line No #1#######');

        Redemption.Reset;
        Redemption.SetRange("Redemption Status",Redemption."Redemption Status"::Verified);
        if Redemption.FindFirst then begin
          repeat
            Window.Update(1,Redemption."Transaction No");
           Redemption.Validate(Amount);
           Redemption.Modify;

        until Redemption.Next=0;
        end else begin
          Window.Close;
          Error('There are no Lines to update');
        end;
        Window.Close;

        Message('Redemption has been update successfully');
    end;

    procedure RunReconUnmatch(SubscriptionMatchingheader: Record "Subscription Matching header")
    var
        SubscriptionMatchingLines: Record "Subscription Matching Lines";
        ClientAccount: Record "Client Account";
        Client: Record Client;
        SubscriptionReconLines: Record "Subscription Recon Lines";
    begin
        Window.Open('Matching Line No #1#######');
        SubscriptionMatchingheader.TestField("Fund Code");
        SubscriptionMatchingLines.Reset;
        SubscriptionMatchingLines.SetRange("Fund Code",SubscriptionMatchingheader."Fund Code");
        SubscriptionMatchingLines.SetRange("Header Transaction  Date",SubscriptionMatchingheader."Transaction Date");
        SubscriptionMatchingLines.SetRange("Bank code",SubscriptionMatchingheader."Bank Code");
        //SubscriptionMatchingLines.SETRANGE(Posted,TRUE);
        if SubscriptionMatchingLines.FindFirst then
          repeat
            Window.Update(1,SubscriptionMatchingLines."Line No");

              SubscriptionMatchingLines.Reconciled:=false;
              SubscriptionMatchingLines."Reconciled Line No":=0;
              SubscriptionMatchingLines.Modify;






          until SubscriptionMatchingLines.Next=0;
          SubscriptionReconLines.Reset;
              SubscriptionReconLines.SetRange("Header No",SubscriptionMatchingheader.No);

              if SubscriptionReconLines.FindFirst then begin
              repeat
               Window.Update(1,SubscriptionReconLines."Line No");

                SubscriptionReconLines.Reconciled:=false;
                SubscriptionReconLines."Reconciled Line No":=0;
                SubscriptionReconLines.Modify;
                until SubscriptionReconLines.Next=0;
              end;
          Window.Close;
    end;

    procedure ReplaceString(String: Text;FindWhat: Text[500];ReplaceWith: Text[500];var NewString: Text)
    begin
        while StrPos(String,FindWhat) > 0 do
          String := DelStr(String,StrPos(String,FindWhat)) + ReplaceWith + CopyStr(String,StrPos(String,FindWhat) + StrLen(FindWhat));
        NewString := String;

        //MESSAGE('tHE sTRING %',NewString);
    end;

    procedure ExportApprovedLoansToTreasury()
    var
        LoanApplication: Record "Loan Application";
        ExportApprovedLoansToBank: Report "Export Approved Loan Payment";
    begin
        ExportApprovedLoansToBank.SetTableView(LoanApplication);
        ExportApprovedLoansToBank.Run;
    end;

    procedure ExportEOQDividendPayoutToTreasury()
    var
        ExportEOQPayoutSchedule: Report "Export EOQ Payout Schedule";
        EOQLines: Record "EOQ Lines";
        Payout: Report ExportEOQPayoutToTreasury;
    begin
        Payout.SetTableView(EOQLines);
        Payout.Run
    end;

    procedure InsertAccruedInterestCharge(AccountNum: Code[40];Charge: Decimal;FundCode: Code[20];ValueDate: Date)
    var
        LineNo: Integer;
    begin
        if AccruedInterestCharge2.FindLast then
          LineNo:=AccruedInterestCharge2."Entry No"+1
        else
          LineNo:=1;
        if Charge > 0 then begin
          AccruedInterestCharge.Init;
          AccruedInterestCharge."Entry No" := LineNo;
          AccruedInterestCharge."Account No" := AccountNum;
          AccruedInterestCharge."Fund Code" := FundCode;
          AccruedInterestCharge."Amount Charged" := Charge;
          AccruedInterestCharge."Value Date" := ValueDate;
          AccruedInterestCharge."Date Charged" := CurrentDateTime;
          AccruedInterestCharge."Paid To Fund Managers" := false;
          AccruedInterestCharge.Insert;
        end;
    end;

    procedure InsertEODStepTracker(ValueDate: Date;FundCode: Code[40];TransactionType: Code[40];FundBankAccountNo: Code[20];Response: Text[250];Amount: Decimal;Units: Decimal)
    var
        EODStepTrack: Record "EOD Step Tracker";
        EODStepTrack2: Record "EOD Step Tracker";
        LineNo: Integer;
    begin
        if EODStepTrack2.FindLast then
          LineNo := EODStepTrack2."Entry No"+1
        else
          LineNo := 1;
        EODStepTrack.Init;
        EODStepTrack."Entry No" := LineNo;
        EODStepTrack."Value Date" := ValueDate;
        EODStepTrack."Fund Code" := FundCode;
        EODStepTrack.Amount := Amount;
        EODStepTrack.Units := Units;
        EODStepTrack."Transaction Type" := TransactionType;
        EODStepTrack."Fund Bank Account No" := FundBankAccountNo;
        EODStepTrack.Status := true;
        EODStepTrack.Response := Response;
        EODStepTrack.Insert(true);
    end;

    procedure GetRedeemableInterest(AcctNo: Code[40]): Decimal
    var
        DailyIncome: Record "Daily Income Distrib Lines";
        Charges: Record "Charges on Accrued Interest";
        AvailableInterest: Decimal;
    begin
        DailyIncome.Reset;
        DailyIncome.SetRange("Account No",AcctNo);
        DailyIncome.SetRange("Fully Paid",false);
        if DailyIncome.FindFirst then begin
          DailyIncome.CalcSums("Income accrued");
        end;
        /*Charges.RESET;
        Charges.SETRANGE("Account No",AcctNo);
        IF Charges.FINDFIRST THEN BEGIN
          Charges.SETRANGE("Paid To Fund Managers",FALSE);
          Charges.CALCSUMS("Amount Charged");
        END;*/
        AvailableInterest := DailyIncome."Income accrued";
        
        exit(AvailableInterest);

    end;

    procedure ExportUnitTransferToTreasury()
    var
        PostedUnitTransfer: Record "Posted Fund Transfer";
        ExportUnitTransferToBank: Report "Export Unit Transfer";
    begin
        ExportUnitTransferToBank.SetTableView(PostedUnitTransfer);
        ExportUnitTransferToBank.Run
    end;

    procedure ExportInstitutionalRedToTreasury()
    var
        RedemptionLines: Record "Redemption Schedule Lines";
        ExportRedemptionsLinesToBank: Report "Export Redemption Schedule";
    begin
        ExportRedemptionsLinesToBank.SetTableView(RedemptionLines);
        ExportRedemptionsLinesToBank.Run
    end;

    procedure SendNomineeDividend(ValueDate: Date)
    var
        DailyIncome: Record "Daily Income Distrib Lines";
        Response: Text;
        PortfolioCode: Code[40];
        CurrencyCode: Code[20];
        SecurityCode: Code[30];
        InstrumentId: Text;
        DeclaredDate: Date;
        PaymentDate: Date;
        DPS: Decimal;
        HoldingUnits: Decimal;
        FXRate: Decimal;
        TaxRate: Decimal;
        Amount: Decimal;
        DecDate: Text;
        PayDate: Text;
    begin
        DailyIncome.Reset;
        DailyIncome.SetRange("Value Date", ValueDate);
        DailyIncome.SetRange("Nominee Client", true);
        if DailyIncome.FindFirst then
          repeat
        
            //Map Data.
            PortfolioCode := DailyIncome."Portfolio Code";
            SecurityCode := DailyIncome."Fund Code";
            CurrencyCode := 'NGN';
            InstrumentId := '43';
            DeclaredDate := DailyIncome."Value Date";
            PaymentDate := CalcDate('<CQ> +1D',DailyIncome."Value Date");
            DecDate := Format(DeclaredDate,0,9);
            PayDate := Format(PaymentDate,0,9);
            DPS := 0;
            HoldingUnits := DailyIncome."No of Units";
            Amount := DailyIncome."Income accrued";
            FXRate := 1;
            TaxRate := 0;
            //Make API Call here. CUCC
            if ((PortfolioCode <> 'OFARPC')
              and (PortfolioCode <> 'ASMARC')) then begin
              //Response := ExternalSeviceCall.SendNomineeClientDividend(PortfolioCode,SecurityCode,CurrencyCode,InstrumentId,DeclaredDate,PaymentDate,DPS,HoldingUnits,Amount,FXRate,TaxRate);
              Response := ExternalSeviceCall.SendNomineeClientDividendAccrual(PortfolioCode,SecurityCode,InstrumentId,DecDate,PayDate,HoldingUnits,Amount,TaxRate);
              if Response <> 'Success' then
                Error(Response)
            end;
          until DailyIncome.Next = 0;
        
        /*DailyIncome.RESET;
        //DailyIncome.SETRANGE("Value Date", ValueDate);
        DailyIncome.SETFILTER("Value Date", '%1..%2',100123D,101223D);
        DailyIncome.SETFILTER("Portfolio Code",'ZEENC');
        //DailyIncome.SETRANGE("Nominee Client", TRUE);
        IF DailyIncome.FINDFIRST THEN BEGIN
          DailyIncome.CALCSUMS("Income accrued");
          PortfolioCode := DailyIncome."Portfolio Code";
          SecurityCode := DailyIncome."Fund Code";
          CurrencyCode := 'NGN';
          InstrumentId := '43';
          DeclaredDate := 122723D; //DailyIncome."Value Date";
          PaymentDate := 010124D; //CALCDATE('<CQ> +1D',DailyIncome."Value Date");
          DPS := 0;
          HoldingUnits := DailyIncome."Income accrued";
          Amount := DailyIncome."Income accrued";
          FXRate := 1;
          TaxRate := 0;
          //MESSAGE(FORMAT(DailyIncome."Income accrued"),DailyIncome."Portfolio Code");
          //Make API Call here.
          Response := ExternalSeviceCall.SendNomineeClientDividendAccrual(PortfolioCode,SecurityCode,InstrumentId,DeclaredDate,PaymentDate,HoldingUnits,Amount,TaxRate);
          IF Response <> 'Success' THEN
            ERROR(Response)
        END;*/

    end;

    procedure MovetoFundTransfers(FundTransferLines: Record "Fund Transfer Lines")
    var
        FundTransfer: Record "Fund Transfer";
        FundTransferLines2: Record "Fund Transfer Lines";
    begin
        FundTransfer .Init;
        FundTransfer.TransferFields(FundTransferLines);
        FundTransfer.Insert;
    end;

    procedure SendMutualFundNomineeDividend(ValueDate: Date;FundCode: Code[20];WHT: Decimal;ExpectedPaymentDate: Date)
    var
        DailyIncome: Record "MF Income Distrib Lines";
        Response: Text;
        PortfolioCode: Code[40];
        CurrencyCode: Code[20];
        SecurityCode: Code[30];
        InstrumentId: Text;
        DeclaredDate: Date;
        PaymentDate: Date;
        HoldingUnits: Decimal;
        TaxAmount: Decimal;
        Amount: Decimal;
        Nominee: Record "Nominee Client Dividend";
        Portfolio: Record Portfolio;
    begin
        Portfolio.Reset;
        if Portfolio.FindFirst then begin
         repeat
         DailyIncome.Reset;
         DailyIncome.SetRange("Value Date", ValueDate);
         DailyIncome.SetRange("Fund Code",FundCode);
         //DailyIncome.SETRANGE("Nominee Client", TRUE);
         DailyIncome.SetRange("Portfolio Code",Portfolio."Portfolio Code");
         if DailyIncome.FindSet then begin
            if PortfolioCode <> 'OFARPC' then begin
              DailyIncome.CalcSums("Income accrued");
              DailyIncome.CalcSums("No of Units");
             Nominee.Init;
        //      FundAdministrationSetup.GET;
             Nominee.No := '';  //NoSeriesManagement.GetNextNo(FundAdministrationSetup."Mutual Fund Nominee Nos",TODAY,TRUE);
             Nominee.PortfolioCode := DailyIncome."Portfolio Code";
             Nominee.SecurityCode := DailyIncome."Fund Code";
             Nominee.InstrumentId := Portfolio."Instrument Id"; //'8E';
             Nominee.DeclaredDate := DailyIncome."Value Date";
             Nominee.PaymentDate := ExpectedPaymentDate;
             Nominee.HoldingUnits := DailyIncome."No of Units";
             Nominee.Amount := DailyIncome."Income accrued";
             Nominee.TaxAmount := (WHT/100) * Nominee.Amount;
             Nominee.CreatedDate := Today;
             Nominee.CreatedBy := UserId;
             Nominee.Insert(true);
          end;
          end;
          until Portfolio.Next = 0;
          end;

    end;

    procedure GetPortfolioMutualFundDividendPayment(ValueDate: Date;FundCode: Code[20])
    var
        DailyIncome: Record "MF Payment Lines";
        Response: Text;
        PortfolioCode: Code[40];
        CurrencyCode: Code[20];
        SecurityCode: Code[30];
        InstrumentId: Text;
        DeclaredDate: Date;
        PaymentDate: Date;
        HoldingUnits: Decimal;
        TaxAmount: Decimal;
        Amount: Decimal;
        Nominee: Record "Nominee Client Dividend";
        Portfolio: Record Portfolio;
    begin
        //
        // Portfolio.RESET;
        // IF Portfolio.FINDFIRST THEN BEGIN
        //  REPEAT
        // DailyIncome.RESET;
        // DailyIncome.SETRANGE("Value Date", ValueDate);
        // DailyIncome.SETRANGE("Fund Code",FundCode);
        // DailyIncome.SETRANGE("Nominee Client", TRUE);
        // DailyIncome.SETRANGE("Portfolio Code",Portfolio."Portfolio Code");
        // IF DailyIncome.FINDSET THEN BEGIN
        //    IF PortfolioCode <> 'OFARPC' THEN BEGIN
        //      DailyIncome.CALCSUMS("Income accrued");
        //      DailyIncome.CALCSUMS("No of Units");
        //     Nominee.INIT;
        // //      FundAdministrationSetup.GET;
        //     Nominee.No := '';  //NoSeriesManagement.GetNextNo(FundAdministrationSetup."Mutual Fund Nominee Nos",TODAY,TRUE);
        //     Nominee.PortfolioCode := DailyIncome."Portfolio Code";
        //     Nominee.SecurityCode := DailyIncome."Fund Code";
        //     Nominee.InstrumentId := Portfolio."Instrument Id"; //'8E';
        //     Nominee.DeclaredDate := DailyIncome."Value Date";
        //     Nominee.PaymentDate := DailyIncome."Value Date";
        //     Nominee.HoldingUnits := DailyIncome."No of Units";
        //     Nominee.Amount := DailyIncome."Income accrued";
        //     Nominee.TaxAmount := 0;
        //     Nominee.CreatedDate := TODAY;
        //     Nominee.CreatedBy := USERID;
        //     Nominee.INSERT(TRUE);
        //  END;
        //  END;
        //  UNTIL Portfolio.NEXT = 0;
        //  END;

    end;

    procedure FlagMultipleRedemptions(ValueDate: Date)
    var
        ClientTrans: Record "Client Transactions";
        NoOfRedemptions: Integer;
        PreviousAccountNo: Code[20];
        CurrentAccountNo: Code[20];
        IsFlagged: Boolean;
        Limit: Integer;
    begin
        ClientTrans.Reset;
        ClientTrans.SetRange("Value Date", ValueDate);
        ClientTrans.SetRange("Transaction Type", ClientTrans."Transaction Type"::Redemption);
        if ClientTrans.FindFirst then begin
          PreviousAccountNo := ClientTrans."Account No";
          NoOfRedemptions := 0;
          Limit := 3;
          IsFlagged := false;
          repeat
            CurrentAccountNo := ClientTrans."Account No";
            if (CurrentAccountNo <> PreviousAccountNo) then begin
              IsFlagged := false;
              if (NoOfRedemptions >= Limit) and (IsFlagged = false) then begin
                SuspiciousWithdrawal(ClientTrans."Value Date",ClientTrans."Account No",ClientTrans."Client ID",ClientTrans."Fund Code",1);
               IsFlagged := true;
               NoOfRedemptions := 0;
              end else
                NoOfRedemptions := 1;
            end else begin
              NoOfRedemptions += 1;
              if (NoOfRedemptions >= Limit) and (IsFlagged = false) then begin
                SuspiciousWithdrawal(ClientTrans."Value Date",ClientTrans."Account No",ClientTrans."Client ID",ClientTrans."Fund Code",1);
               IsFlagged := true;
               NoOfRedemptions := 0;
             end;
            end;
            PreviousAccountNo := CurrentAccountNo;

          until ClientTrans.Next = 0;
          if (NoOfRedemptions >= Limit) and (IsFlagged = false) then
                SuspiciousWithdrawal(ClientTrans."Value Date",ClientTrans."Account No",ClientTrans."Client ID",ClientTrans."Fund Code",1);
        end;
    end;

    procedure FlagInAndOutTransactions(ValueDate: Date)
    var
        ClientTransactions: Record "Client Transactions";
        RedemptionDate: Date;
        SubscriptionDate: Date;
        ClientTransactions2: Record "Client Transactions";
    begin
        SubscriptionDate := CalcDate('<-1D>',ValueDate);
        RedemptionDate := ValueDate; //CALCDATE('<-1D>',ValueDate);
        ClientTransactions.Reset;
        ClientTransactions.SetRange("Value Date", SubscriptionDate);
        ClientTransactions.SetRange("Transaction Type", ClientTransactions."Transaction Type"::Subscription);
        if ClientTransactions.FindFirst then
          repeat
            ClientTransactions2.Reset;
            ClientTransactions2.SetRange("Value Date", RedemptionDate);
            ClientTransactions2.SetRange("Transaction Type", ClientTransactions2."Transaction Type"::Redemption);
            ClientTransactions2.SetRange("Account No", ClientTransactions."Account No");
            if ClientTransactions2.FindFirst then
              SuspiciousWithdrawal(ClientTransactions2."Value Date",ClientTransactions2."Account No",ClientTransactions2."Client ID",ClientTransactions2."Fund Code", 0)
          until ClientTransactions.Next = 0;
    end;

    procedure SuspiciousWithdrawal(ValueDate: Date;AccountNo: Code[20];ClientID: Code[20];FundCode: Code[20];Reason: Option "In-and-Out","Mutiple Redemptions")
    var
        SuspiciousWithdrawal: Record "Suspicious Transactions";
        SuspiciousWithdrawal2: Record "Suspicious Transactions";
    begin
        SuspiciousWithdrawal2.Reset;
        SuspiciousWithdrawal2.SetRange("Value Date",ValueDate);
        SuspiciousWithdrawal2.SetRange("Account No", AccountNo);
        SuspiciousWithdrawal2.SetRange(Reason,Reason);
        if SuspiciousWithdrawal2.FindFirst then
          SuspiciousWithdrawal2.DeleteAll;

        SuspiciousWithdrawal.Init;
        SuspiciousWithdrawal."Account No" := AccountNo;
        SuspiciousWithdrawal."Value Date" := ValueDate;
        SuspiciousWithdrawal."Client ID" := ClientID;
        SuspiciousWithdrawal."Fund Code" := FundCode;
        SuspiciousWithdrawal.Reason := Reason;
        SuspiciousWithdrawal.FlaggedDate := CurrentDateTime;
        SuspiciousWithdrawal.Insert;
    end;

    procedure UpdateIncomeLineQuarter(StartDate: Date;EndDate: Date)
    var
        IncomeLine: Record "Daily Income Distrib Lines";
    begin
        IncomeLine.Reset;
        IncomeLine.SetFilter("Value Date", '%1..%2',StartDate, EndDate);
        if IncomeLine.FindSet then
          IncomeLine.ModifyAll(Quarter,'Q2 2023',true);
        Message('Done');
    end;

    procedure UpdateDistributedIncome()
    var
        DailyIncome: Record "Daily Distributable Income";
    begin
        DailyIncome.Reset;
        if DailyIncome.FindSet then
          DailyIncome.ModifyAll(Distributed, true, true);

        Message('Done');
    end;

    procedure ApproveSubscriptionReversal(Subscription: Record "Posted Subscription")
    var
        ClientTransactions: Record "Client Transactions";
        ClientTransactionsCopy: Record "Client Transactions";
        EntryNo: Integer;
        Eod: Record "EOD Tracker";
        Valuedate: Date;
        DistributableIncome: Record "Daily Income Distrib Lines";
        ReversedAccruedIncome: Record "Reversed Accrued Income";
        ReversalDate: Date;
        AccruedIncome: Decimal;
        DistributableIncome2: Record "Daily Income Distrib Lines";
        ClientAccount: Record "Client Account";
        Quarters: Record Quarters;
        CurrentQuarter: Code[20];
    begin
        if not Confirm('Are you sure you want to approve this reversal?') then
          Error('');

        Quarters.Reset;
        Quarters.SetRange(Closed, false);
        if Quarters.FindFirst then
          CurrentQuarter := Quarters.Code;

        if Subscription.Reversed=true then
          Error('This subscription has already been reversed');
        ClientTransactionsCopy.Reset;
        ClientTransactionsCopy.SetRange("Transaction No",Subscription.No);
        ClientTransactionsCopy.SetRange("Fund Code",Subscription."Fund Code");
        ClientTransactionsCopy.SetRange("Transaction Type",ClientTransactions."Transaction Type"::Subscription);
        ClientTransactionsCopy.SetRange(Reversed,false);

        if ClientTransactionsCopy.FindFirst then
         begin
           Eod.Reset;
          if Eod.FindLast then
            Valuedate:=CalcDate('1D',Eod.Date);
          EntryNo:=0;
          EntryNo:=GetLastTransactionNo;
          ClientTransactions.Reset;
          ClientTransactions."Entry No":=EntryNo+1;
          ClientTransactions."Client ID" := ClientTransactionsCopy."Client ID";
          ClientTransactions."Account No" := ClientTransactionsCopy."Account No";
         ClientTransactions."Transaction Type":= ClientTransactionsCopy."Transaction Type";
        // IF ClientTransactionsCopy."Transaction Type" = ClientTransactionsCopy."Transaction Type"::Redemption THEN
        //  ClientTransactions."Transaction Type":= ClientTransactionsCopy."Transaction Type"::Subscription;
        // IF ClientTransactionsCopy."Transaction Type" = ClientTransactionsCopy."Transaction Type"::Subscription THEN
        //  ClientTransactions."Transaction Type":= ClientTransactionsCopy."Transaction Type"::Redemption;
        // IF ClientTransactionsCopy."Transaction Type" = ClientTransactionsCopy."Transaction Type"::Fee THEN
        //  ClientTransactions."Transaction Type":= ClientTransactionsCopy."Transaction Type"::Fee;
          ClientTransactions."Value Date":= Today;
          ClientTransactions."Transaction Date":=Today;
          ClientTransactions."Fund Code":=ClientTransactionsCopy."Fund Code";
          ClientTransactions."Fund Sub Code":=ClientTransactionsCopy."Fund Sub Code";
          ClientTransactions."Transaction Sub Type":= ClientTransactionsCopy."Transaction Sub Type";
          ClientTransactions."Transaction Sub Type 2":=ClientTransactionsCopy."Transaction Sub Type 2";
          ClientTransactions."Transaction Sub Type 3" := ClientTransactionsCopy."Transaction Sub Type 3";
          ClientTransactions.Narration:= 'Subscription Reversal - ' + Format(ClientTransactionsCopy."Value Date");
          ClientTransactions.Amount:= -ClientTransactionsCopy.Amount;
           ClientTransactions."No of Units":= -ClientTransactionsCopy."No of Units";
          ClientTransactions."Transaction No":= ClientTransactionsCopy."Transaction No";
          ClientTransactions."Price Per Unit":= ClientTransactionsCopy."Price Per Unit";
          ClientTransactions.Currency:= ClientTransactionsCopy.Currency;
          ClientTransactions."Agent Code":= ClientTransactionsCopy."Agent Code";
          ClientTransactions."Created By":=UserId;
          ClientTransactions."Created Date Time":=CurrentDateTime;
          ClientTransactions."Transaction Source Document":= ClientTransactionsCopy."Transaction Source Document";
          ClientTransactions.Reversed := true;
          if Subscription."Reversal Type" = Subscription."Reversal Type"::Fund then
            ClientTransactions."Reverse To Fund" := true;
          if ClientTransactions.Amount<>0 then begin
            ClientTransactions.Insert(true);
            //ClientTransactionsCopy.Reversed := TRUE;
            //ClientTransactionsCopy.MODIFY(TRUE);
            //Get accrued income on reversed Amount
          AccruedIncome := 0;
          ReversalDate := Today; // CALCDATE('1D',Subscription."Value Date");
          DistributableIncome.Reset;
          DistributableIncome.SetRange("Fund Code",Subscription."Fund Code");
          DistributableIncome.SetRange("Account No",Subscription."Account No");
          DistributableIncome.SetRange("Fully Paid",false);
          DistributableIncome.SetRange("Value Date", Subscription."Value Date",ReversalDate);
           if DistributableIncome.FindFirst then begin
             repeat
               AccruedIncome += (Abs(ClientTransactions."No of Units") * DistributableIncome."Income Per unit");
               until DistributableIncome.Next = 0;
               //debit distributable income table
               DistributableIncome2.Reset;
               DistributableIncome2.No := 'RV-' + Subscription.No;
               DistributableIncome2."Line No" := 1;
               DistributableIncome2."Account No" := DistributableIncome."Account No";
               DistributableIncome2."Client ID" := DistributableIncome."Client ID";
               DistributableIncome2."Fund Code" := DistributableIncome."Fund Code";
               DistributableIncome2."Income accrued" := -AccruedIncome;
               DistributableIncome2."Client Name" := DistributableIncome."Client Name";
               DistributableIncome2."Transaction No" := DistributableIncome."Transaction No";
               DistributableIncome2.Transferred := DistributableIncome.Transferred;
               DistributableIncome2."Transferred from account" := DistributableIncome."Transferred from account";
               DistributableIncome2."Nominee Client" := DistributableIncome."Nominee Client";
               DistributableIncome2."Portfolio Code" := DistributableIncome."Portfolio Code";
               DistributableIncome2.Quarter := CurrentQuarter;
               DistributableIncome2.Insert(true);
               // client
               if Subscription."Reversal Type" = Subscription."Reversal Type"::Client then begin
                 DistributableIncome2.Reset;
                 DistributableIncome2.No := 'DIREV-' + Subscription.No;
                 DistributableIncome2."Line No" := 2;
                 DistributableIncome2."Account No" := Subscription."Reverse To Client";
                 if ClientAccount.Get( Subscription."Reverse To Client") then
                 DistributableIncome2."Client ID" := ClientAccount."Client ID";
                 DistributableIncome2."Fund Code" := DistributableIncome."Fund Code";
                 DistributableIncome2."Income accrued" := Abs(AccruedIncome);
                 DistributableIncome2."Client Name" := ClientAccount."Client Name";
                 DistributableIncome2."Transaction No" := DistributableIncome."Transaction No";
                 DistributableIncome2.Transferred := true;
                 DistributableIncome2."Transferred from account" := Subscription."Account No";
                 DistributableIncome2."Nominee Client" := DistributableIncome."Nominee Client";
                 DistributableIncome2."Portfolio Code" := DistributableIncome."Portfolio Code";
                 DistributableIncome2.Quarter := CurrentQuarter;
                 DistributableIncome2.Insert(true);
                 end;
                 //client end
               end;
              ReversedAccruedIncome.Reset;
              ReversedAccruedIncome."Client ID" := Subscription."Client ID";
              ReversedAccruedIncome."Account No" := Subscription."Account No";
              ReversedAccruedIncome.Fund := Subscription."Fund Code";
              ReversedAccruedIncome."Reversed Unit" := Abs(ClientTransactions."No of Units");
              ReversedAccruedIncome."Amount Reversed" := Abs(ClientTransactions.Amount);
              ReversedAccruedIncome."Accrued Income" := Abs(AccruedIncome);
              ReversedAccruedIncome."Date Reversed" := Today;
              ReversedAccruedIncome."Redistribution Date" := Valuedate;
              ReversedAccruedIncome.Insert(true);
            Subscription."Reversal Status" := Subscription."Reversal Status"::Approved;
            Subscription.Reversed:=true;
            Subscription."Reversed By":=UserId;
            Subscription."Date Time reversed":=CurrentDateTime;
            Subscription.Modify(true);
          end;
          // client
          if Subscription."Reversal Type" = Subscription."Reversal Type"::Client then begin
            EntryNo:=0;
            EntryNo:=GetLastTransactionNo;
            ClientTransactions.Reset;
            ClientTransactions."Entry No":=EntryNo+1;
            ClientTransactions."Account No" := Subscription."Reverse To Client";
            if ClientAccount.Get(Subscription."Reverse To Client") then
            ClientTransactions."Client ID" := ClientAccount."Client ID";
            ClientTransactions."Transaction Type":= ClientTransactionsCopy."Transaction Type";
            ClientTransactions."Value Date":= Today;
            ClientTransactions."Transaction Date":=Today;
            ClientTransactions."Fund Code":=ClientTransactionsCopy."Fund Code";
            ClientTransactions."Fund Sub Code":=ClientTransactionsCopy."Fund Sub Code";
            ClientTransactions."Transaction Sub Type":= ClientTransactionsCopy."Transaction Sub Type";
            ClientTransactions."Transaction Sub Type 2":=ClientTransactionsCopy."Transaction Sub Type 2";
            ClientTransactions."Transaction Sub Type 3" := ClientTransactionsCopy."Transaction Sub Type 3";
            ClientTransactions.Narration:= 'Subscription additional';
            ClientTransactions.Amount:= Abs(ClientTransactionsCopy.Amount);
             ClientTransactions."No of Units":= Abs(ClientTransactionsCopy."No of Units");
            ClientTransactions."Transaction No":= ClientTransactionsCopy."Transaction No";
            ClientTransactions."Price Per Unit":= ClientTransactionsCopy."Price Per Unit";
            ClientTransactions.Currency:= ClientTransactionsCopy.Currency;
            ClientTransactions."Agent Code":= ClientTransactionsCopy."Agent Code";
            ClientTransactions."Created By":=UserId;
            ClientTransactions."Created Date Time":=CurrentDateTime;
            ClientTransactions."Transaction Source Document":= ClientTransactionsCopy."Transaction Source Document";
            if ClientTransactions.Amount<>0 then
              ClientTransactions.Insert(true);
            end;
            Message('Subscription Reversed Completely');
        end;
    end;

    procedure RejectSubscriptionReversal(Subscription: Record "Posted Subscription")
    var
        ClientTransactions: Record "Client Transactions";
        ClientTransactionsCopy: Record "Client Transactions";
        EntryNo: Integer;
        Eod: Record "EOD Tracker";
        Valuedate: Date;
    begin
        if not Confirm('Are you sure you want to reject this reversal?') then
          Error('');
            Subscription."Reversal Status" := Subscription."Reversal Status"::Rejected;
            Subscription.Modify(true);
            Message('Reversal Rejected');
    end;

    procedure SendSubscriptionToAuditClient(Subscription: Record "Posted Subscription";Account: Code[20])
    var
        ClientTransactions: Record "Client Transactions";
        ClientTransactions2: Record "Client Transactions";
        EntryNo: Integer;
    begin
         if not Confirm('Are you sure you want to Reverse this Subscription to %1?',true,Account) then
          Error('');
         if Subscription.Reversed=true then
          Error('This subscription has already been reversed');
         if Subscription."Reversal Status" = Subscription."Reversal Status"::"Pending Reversal" then
          Error('This subscription is yet to be reviewed by Audit');
         Subscription."Reversal Type" := Subscription."Reversal Type"::Client;
         Subscription."Reversal Status" := Subscription."Reversal Status"::"Pending Reversal";
         Subscription."Date sent To Audit" :=CurrentDateTime;
         Subscription.Modify;
         Message('Transaction sent to audit for approval');
    end;

    procedure SendSubscriptionToAuditFund(Subscription: Record "Posted Subscription")
    var
        ClientTransactions: Record "Client Transactions";
        ClientTransactions2: Record "Client Transactions";
        EntryNo: Integer;
    begin
         if not Confirm('Are you sure you want to Reverse this Subscription?') then
          Error('');
         if Subscription.Reversed=true then
          Error('This subscription has already been reversed');
         if Subscription."Reversal Status" = Subscription."Reversal Status"::"Pending Reversal" then
          Error('This subscription is yet to be reviewed by Audit');
         Subscription."Reversal Type" := Subscription."Reversal Type"::Fund;
         Subscription."Reverse To Client" := '';
         Subscription."Reversal Status" := Subscription."Reversal Status"::"Pending Reversal";
         Subscription."Date sent To Audit" :=CurrentDateTime;
         Subscription.Modify;
         Message('Transaction sent to audit for approval');
    end;

    procedure ApproveRedemptionReversal(Redemption: Record "Posted Redemption")
    var
        ClientTransactions: Record "Client Transactions";
        ClientTransactionsCopy: Record "Client Transactions";
        EntryNo: Integer;
        Eod: Record "EOD Tracker";
        Valuedate: Date;
    begin
        if not Confirm('Are you sure you want to approve this reversal?') then
          Error('');
        if Redemption.Reversed=true then
          Error('This redemption has already been reversed');
        ClientTransactionsCopy.Reset;
        ClientTransactionsCopy.SetRange("Transaction No",Redemption.No);
        ClientTransactionsCopy.SetRange("Fund Code",Redemption."Fund Code");
        ClientTransactionsCopy.SetFilter("Transaction Type",'%1|%2',ClientTransactions."Transaction Type"::Redemption,ClientTransactions."Transaction Type"::Fee);
        ClientTransactionsCopy.SetRange(Reversed,false);

        if ClientTransactionsCopy.FindFirst then
         begin repeat
          EntryNo:=0;
          EntryNo:=GetLastTransactionNo;
          ClientTransactions.Reset;
          ClientTransactions."Entry No":=EntryNo+1;
          ClientTransactions."Client ID" := ClientTransactionsCopy."Client ID";
          ClientTransactions."Account No" := ClientTransactionsCopy."Account No";
          ClientTransactions."Transaction Type":= ClientTransactionsCopy."Transaction Type";
          ClientTransactions."Value Date":= Today;
          ClientTransactions."Transaction Date":=Today;
          ClientTransactions."Fund Code":=ClientTransactionsCopy."Fund Code";
          ClientTransactions."Fund Sub Code":=ClientTransactionsCopy."Fund Sub Code";
          ClientTransactions."Transaction Sub Type":= ClientTransactionsCopy."Transaction Sub Type";
          ClientTransactions."Transaction Sub Type 2":=ClientTransactionsCopy."Transaction Sub Type 2";
          ClientTransactions."Transaction Sub Type 3" := ClientTransactionsCopy."Transaction Sub Type 3";
          if ClientTransactions."Transaction Type" = ClientTransactions."Transaction Type"::Redemption then
            ClientTransactions.Narration:= 'Redemption Reversal - '+ Format(ClientTransactionsCopy."Value Date");
          if ClientTransactions."Transaction Type" = ClientTransactions."Transaction Type"::Fee then
            ClientTransactions.Narration:= 'Fee Reversal - '+ Format(ClientTransactionsCopy."Value Date");
          ClientTransactions.Amount:= Abs(ClientTransactionsCopy.Amount);
          ClientTransactions."No of Units":= Abs(ClientTransactionsCopy."No of Units");
          ClientTransactions."Transaction No":= ClientTransactionsCopy."Transaction No";
          ClientTransactions."Price Per Unit":= ClientTransactionsCopy."Price Per Unit";
          ClientTransactions.Currency:= ClientTransactionsCopy.Currency;
          ClientTransactions."Agent Code":= ClientTransactionsCopy."Agent Code";
          ClientTransactions."Created By":=UserId;
          ClientTransactions."Created Date Time":=CurrentDateTime;
          ClientTransactions."Transaction Source Document":= ClientTransactionsCopy."Transaction Source Document";
          ClientTransactions.Reversed := true;
          ClientTransactions."Reverse To Fund" := true;
            if ClientTransactions.Amount<>0 then begin
              ClientTransactions.Insert(true);
        //      ClientTransactionsCopy.Reversed := TRUE;
        //      ClientTransactionsCopy.MODIFY(TRUE);
            end;
          until ClientTransactionsCopy.Next = 0;
            Redemption."Reversal Status" := Redemption."Reversal Status"::Approved;
            Redemption.Reversed:=true;
            Redemption."Reversed By":=UserId;
            Redemption."Date Time reversed":=CurrentDateTime;
            Redemption.Modify(true);
            Message('Redemption Reversed Completely');
        end;
    end;

    procedure SendRedemptionToAudit(Redemption: Record "Posted Redemption")
    var
        EntryNo: Integer;
        RedemptionScheduleLines: Record "Redemption Schedule Lines";
        ClientTransactions: Record "Client Transactions";
        ClientTransactions2: Record "Client Transactions";
        DailyDistributableIncome: Record "Daily Income Distrib Lines";
    begin
         if not Confirm('Are you sure you want to reverse this Redemption?') then
          Error('');
         if Redemption.Reversed=true then
          Error('This redemption has already been reversed');
         if Redemption."Reversal Status" = Redemption."Reversal Status"::"Pending Reversal" then
          Error('This redemption is yet to be reviewed by Audit');
            Redemption."Reversal Status" := Redemption."Reversal Status"::"Pending Reversal";
            Redemption."Date sent To Audit":=CurrentDateTime;
            Redemption.Modify;
         Message('Transaction sent to audit for approval');
    end;

    procedure RejectRedemptionReversal(Redemption: Record "Posted Redemption")
    var
        ClientTransactions: Record "Client Transactions";
        ClientTransactionsCopy: Record "Client Transactions";
        EntryNo: Integer;
        Eod: Record "EOD Tracker";
        Valuedate: Date;
    begin
        if not Confirm('Are you sure you want to reject this reversal?') then
          Error('');
            Redemption."Reversal Status" := Redemption."Reversal Status"::Rejected;
            Redemption.Modify(true);
            Message('Reversal Rejected');
    end;

    procedure ValidateReversalValueDate(FundCode: Code[30])
    var
        FundPrice: Record "Fund Prices";
    begin
        FundPrice.Reset;
        FundPrice.SetRange("Fund No.", FundCode);
        FundPrice.SetRange(Activated, true);
        FundPrice.SetRange("Value Date", Today);
        if not FundPrice.FindFirst then
          Error('Kindly activate price for %1 for today %2 before reversing this transaction.', FundCode, Today)
    end;

    procedure SendNomineeEOQDividend(ValueDate: Date)
    var
        DailyIncome: Record "Daily Income Distrib Lines";
        Response: Text;
        PortfolioCode: Code[40];
        MutualfundCode: Code[20];
        AssetClassId: Code[30];
        DeclaredDate: Date;
        TransDate: Date;
        Amount: Decimal;
        Price: Decimal;
        UnitsHolding: Decimal;
        TaxAmount: Decimal;
        IsReinvestment: Boolean;
        BankAccountNo: Code[20];
        ClientTrans: Record "Client Transactions";
    begin
        ClientTrans.Reset;
        ClientTrans.SetRange("Value Date",ValueDate);
        ClientTrans.SetRange("Nominee Dividend", true);
        if ClientTrans.FindFirst then
          repeat
            //Map Data
            PortfolioCode := ClientTrans."Portfolio Code";
            MutualfundCode := ClientTrans."Fund Code";
            AssetClassId := '43';
            DeclaredDate := CalcDate('-1D',ClientTrans."Value Date");
            TransDate := ClientTrans."Value Date";
            Amount := ClientTrans.Amount;
            Price := 1;
            UnitsHolding := ClientTrans."No of Units";
            TaxAmount := 0;
            BankAccountNo := '0124516495';
            //Make API Call here.
            if (PortfolioCode <> 'OFARPC') and (PortfolioCode <> 'ASMARC') then begin
              Response := ExternalSeviceCall.SendNomineeClientDividendPayment(PortfolioCode,MutualfundCode,AssetClassId,DeclaredDate,TransDate,Amount,Price,UnitsHolding,TaxAmount,BankAccountNo);
              if Response <> 'Success' then
                Error(Response)
            end;
          until ClientTrans.Next = 0;

        Message('Nominee Dividends sent successfully');
    end;
}

