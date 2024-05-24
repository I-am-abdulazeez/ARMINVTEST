codeunit 50000 "Client Administration"
{

    trigger OnRun()
    begin
    end;

    var
        Client: Record Client;
        ClientSubAccounts: Page "Client Sub Accounts";
        ClientAccounts: Page "Client Accounts";
        ClientAccountsSubscribed: Page "Client Accounts Subscribed";
        ClientAccount: Record "Client Account";
        ClientAccount2: Record "Client Account";
        AccountManagersTracker: Record "Account Managers Tracker";
        AccountManagersHistory: Page "Account Managers History";
        ClientCaution: Record "Client Cautions";
        ClientCautions: Page "Client Cautions Requests";
        ClientTransaction: Record "Client Transactions";
        ClientTransactions: Page "Client Transactions";
        CheckAccount: Integer;
        AccountStatement: Report "Account Statement";
        AllDirectDebitRequests: Page "All Direct Debit Requests";
        AllOnlineIndemnities: Page "All Online Indemnities";
        DirectDebitMandate: Record "Direct Debit Mandate";
        OnlineIndemnityMandate: Record "Online Indemnity Mandate";
        PostedSubscription: Record "Posted Subscription";
        PostedSubscriptions: Page "Posted Subscription Card";
        PostedRedemption: Record "Posted Redemption";
        PostedRedemptions: Page "Posted Redemption Card";
        PostedFundTransfer: Record "Posted Fund Transfer";
        PostedFundTransfers: Page "Posted Unit Transfer Card";
        EOQHeader: Record "EOQ Header";
        EOQList: Page "EOQ Card";
        AccountLien: Record "Account Liens";
        AccountLiens: Page "Account Liens";
        DailyIncdistribLinesPosteds: Page "Daily Inc distrib Lines Posted";
        DailyIncDistribLinesPosted: Record "Daily Inc Distrib Lines Posted";
        DailyIncomedistribLines: Page "Daily Income distrib Lines";
        DailyIncomeDistribLine: Record "Daily Income Distrib Lines";
        FundAdministration: Codeunit "Fund Administration";
        TransactType: Option Subscription,Redemption,Dividend;
        UnitSwitchHeader: Record "Unit Switch Header";
        UnitSwitchPosted: Page "Unit Switch Posted";
        SubscriptionSchedulesHeader: Record "Subscription Schedules Header";
        SubscriptionSchedulePosted: Page "Subscription Schedule Posted";
        ClientAccountCard: Page "Client Account Card";
        ClientCautionCard: Page "Client Caution Card";
        LienCard: Page "Lien Card";
        KYCLinks: Record "KYC Links";
        ClientKYCDocuments: Page "Client KYC Documents";
        InvalidEmailAddressErr: Label 'The email address "%1" is not valid.';
        InstitutionalAccntStatement: Report "Institutional Accnt Statement";
        ClientTransactionRev: Page "Client Transactions Rev";
        fundcode: Code[20];

    procedure GetAccountManagerName(AccMngcode: Code[20]): Text
    var
        AccountManager: Record "Account Manager";
    begin
        if AccountManager.Get(AccMngcode) then ;
        exit(AccountManager."First Name"+' '+AccountManager."Middle Name"+' '+ AccountManager.Surname);
    end;

    procedure AccountManagerHistory(ClientID: Code[20])
    begin
        Clear(AccountManagersHistory);
        AccountManagersTracker.Reset;
        AccountManagersTracker.FilterGroup(11);
        AccountManagersTracker.SetRange("Client ID",ClientID);
        AccountManagersTracker.FilterGroup(0);
        AccountManagersHistory.SetTableView(AccountManagersTracker);
        AccountManagersHistory.RunModal;
    end;

    procedure AccountsSubscribed(ClientID: Code[20])
    begin
        Clear(ClientAccountsSubscribed);
        ClientAccount.Reset;
        ClientAccount.FilterGroup(9);
        ClientAccount.SetRange("Client ID",ClientID);
        ClientAccount.FilterGroup(0);
        ClientAccountsSubscribed.GetClientID(ClientID);
        ClientAccountsSubscribed.SetTableView(ClientAccount);
        ClientAccountsSubscribed.RunModal;
    end;

    procedure NewAccount(ClientID: Code[40];Fundcode: Code[40])
    begin
        Clear(ClientAccountCard);
        ClientAccount.Reset;
        ClientAccount.Init;
        ClientAccount.Insert(true);
        ClientAccount.Validate("Client ID",ClientID);
        ClientAccount.Validate("Fund No",Fundcode);
        ClientAccount.Modify;
        ClientAccount2.Reset;
        ClientAccount2.SetRange("Account No",ClientAccount."Account No");
        ClientAccountCard.SetTableView(ClientAccount2);
        ClientAccountCard.Run;
    end;

    procedure NewAccountReturnACC(ClientID: Code[40];Fundcode: Code[40]): Code[40]
    var
        Accno: Code[40];
    begin
        Clear(ClientAccountCard);
        ClientAccount.Reset;
        ClientAccount."Account No":='';
        ClientAccount.Init;
        ClientAccount."Account No":='';
        Accno:=ClientAccount."Account No";
        ClientAccount.Insert(true);
        ClientAccount.Validate("Client ID",ClientID);
        ClientAccount.Validate("Fund No",Fundcode);
        Accno:=ClientAccount."Account No";
        ClientAccount.Modify;
        exit(Accno);
    end;

    procedure NewPaydayACC(ClientID: Code[40];Fundcode: Code[40];Oldno: Code[40]): Code[40]
    var
        Accno: Code[40];
    begin
        Clear(ClientAccountCard);
        ClientAccount.Reset;
        ClientAccount."Account No":='';
        ClientAccount.Init;
        ClientAccount."Account No":='';
        Accno:=ClientAccount."Account No";
        ClientAccount.Insert(true);
        ClientAccount."Pay Day":=true;
        ClientAccount.Validate("Client ID",ClientID);
        ClientAccount.Validate("Fund No",Fundcode);
        ClientAccount."Old Account Number":=Oldno;
        Accno:=ClientAccount."Account No";
        ClientAccount.Modify;
        exit(Accno);
    end;

    procedure ClientSubAccount(ClientID: Code[20])
    begin
        Clear(ClientSubAccounts);
        Client.Reset;
        Client.FilterGroup(10);
        Client.SetRange("Main Account",ClientID);
        Client.FilterGroup(0);
        ClientSubAccounts.SetTableView(Client);
        ClientSubAccounts.RunModal;
    end;

    procedure ViewClientCautions(ClientID: Code[20])
    begin
        Clear(ClientCautions);
        ClientCaution.Reset;
        ClientCaution.FilterGroup(10);
        ClientCaution.SetRange("Client ID",ClientID);
        ClientCaution.FilterGroup(0);
        ClientCautions.SetTableView(ClientCaution);
        ClientCautions.RunModal;
    end;

    procedure NewCaution(ClientID: Code[20])
    begin
        Clear(ClientCautionCard);
        ClientCaution.Init;
        ClientCaution.Validate("Client ID",ClientID);
        ClientCaution.Insert(true);;
        ClientCautionCard.SetTableView(ClientCaution);
        ClientCautionCard.Run;
    end;

    procedure CheckifJointaccount(clientid: Code[20]): Boolean
    begin
        Client.Reset;
        Client.Get(clientid);
        if Client."Client Type"=Client."Client Type"::Joint then
          exit(true)
        else
          exit(false);
    end;

    procedure CheckifJointaccountExits(clientid: Code[20]): Boolean
    var
        JointAccountHolders: Record "Joint Account Holders";
    begin
        JointAccountHolders.Reset;
        JointAccountHolders.SetRange("Client ID",clientid);
        if JointAccountHolders.FindFirst then
          exit(true)
        else
          exit(false);
    end;

    procedure CheckifNOKexists(clientid: Code[20]): Boolean
    var
        ClientNextofKin: Record "Client Next of Kin";
    begin
        ClientNextofKin.Reset;
        ClientNextofKin.SetRange("Client ID",clientid);
        if ClientNextofKin.FindFirst then
          exit(true)
        else
          exit(false);
    end;

    procedure CheckifaccountExits(clientid: Code[20]): Boolean
    var
        ClientAccount: Record "Client Account";
    begin
        ClientAccount.Reset;
        ClientAccount.SetRange("Client ID",clientid);
        if ClientAccount.FindFirst then
          exit(true)
        else
          exit(false);
    end;

    procedure CheckifAODSexists(clientid: Code[20]): Boolean
    var
        KYCLinks: Record "KYC Links";
    begin
        KYCLinks.Reset;
        KYCLinks.SetRange("Client ID",clientid);
        if KYCLinks.FindFirst then
          exit(true)
        else
          exit(false);
    end;

    procedure CheckifCautionexists(ClientID: Code[20]): Boolean
    begin
        ClientCaution.Reset;
        ClientCaution.SetRange("Client ID",ClientID);
        ClientCaution.SetFilter(Status,'<>%1',ClientCaution.Status::Closed);
        if ClientCaution.FindFirst then
          exit(true)
        else
          exit(false);
    end;

    procedure ViewClientTransactions(ClientID: Code[20])
    begin
        Clear(ClientTransactions);
        ClientTransaction.Reset;
        ClientTransaction.FilterGroup(10);
        ClientTransaction.SetRange("Client ID",ClientID);
        ClientTransaction.FilterGroup(0);
        ClientTransactions.SetTableView(ClientTransaction);
        ClientTransactions.RunModal;
    end;

    procedure ViewAccountTransactions(AccountID: Code[40])
    begin
        Clear(ClientTransactions);
        ClientTransaction.Reset;
        ClientTransaction.FilterGroup(10);
        ClientTransaction.SetRange("Account No",AccountID);
        ClientTransaction.FilterGroup(0);
        ClientTransactions.SetTableView(ClientTransaction);
        ClientTransactions.RunModal;
    end;

    procedure ViewFundAccountsSubscribed(FundCode: Code[20])
    begin
        Clear(ClientAccounts);
        ClientAccount.Reset;
        ClientAccount.FilterGroup(9);
        ClientAccount.SetRange("Fund No",FundCode);
        ClientAccount.FilterGroup(0);
        ClientAccounts.SetTableView(ClientAccount);
        ClientAccounts.RunModal;
    end;

    procedure CheckifResctrictionExists(Accountno: Code[40];Requestlevel: Option Client,Account;Restrictiontype: Option "No Restrictions","Restrict Subscription","Restrict Redemption","Restrict Both"): Boolean
    begin
        ClientCaution.Reset;
        if Requestlevel=Requestlevel::Account then
          ClientCaution.SetRange("Account No",Accountno)
        else
          ClientCaution.SetRange("Account No",Accountno);
        ClientCaution.SetFilter("Restriction Type",'%1|%2',Restrictiontype,ClientCaution."Restriction Type"::"Restrict Both");
        ClientCaution.SetFilter(Status,'%1',ClientCaution.Status::Verified);
        if ClientCaution.FindFirst then
          exit(true)
        else
          exit(false);
    end;

    procedure CheckifLienExists()
    begin
    end;

    procedure ViewClientstatement(AccountNo: Code[20];Requestlevel: Option Client,Account)
    begin
        Clear(AccountStatement);
        ClientAccount.Reset;
        if Requestlevel=Requestlevel::Client then
          ClientAccount.SetRange("Client ID",AccountNo)
        else
          ClientAccount.SetRange("Account No",AccountNo);
        AccountStatement.SetTableView(ClientAccount);
        AccountStatement.RunModal;
    end;

    procedure CalculateAge(DOB: Date): Integer
    begin
        if DOB<>0D then
        exit(Round((Today-DOB)/365,1,'<'))
        else exit(0);
    end;

    procedure CheckClientDuplicates(NewClient: Record Client)
    var
        ExistingClients: Record Client;
    begin
        ExistingClients.Reset;
        ExistingClients.SetRange("First Name",NewClient."First Name");
        ExistingClients.SetRange(Surname,NewClient.Surname);
        ExistingClients.SetRange("Other Name/Middle Name",NewClient."Other Name/Middle Name");
        ExistingClients.SetRange("E-Mail",NewClient."E-Mail");
        ExistingClients.SetRange("Phone Number",NewClient."Phone Number");
        ExistingClients.SetFilter("Membership ID",'<>%1',NewClient."Membership ID");
        if ExistingClients.FindFirst then
          Error('Client %1 has the same details as this new client',ExistingClients."Membership ID");
    end;

    procedure ViewDirectDebit(ClientID: Code[20])
    begin
        Clear(AllDirectDebitRequests);
        DirectDebitMandate.Reset;
        DirectDebitMandate.FilterGroup(9);
        DirectDebitMandate.SetRange("Client ID",ClientID);
        DirectDebitMandate.FilterGroup(0);
        AllDirectDebitRequests.SetTableView(DirectDebitMandate);
        AllDirectDebitRequests.RunModal;
    end;

    local procedure NewDirectDebit()
    begin
    end;

    procedure ViewOnlineIndemnity(ClientID: Code[20])
    begin
        Clear(AllOnlineIndemnities);
        OnlineIndemnityMandate.Reset;
        OnlineIndemnityMandate.FilterGroup(9);
        OnlineIndemnityMandate.SetRange("Client ID",ClientID);
        OnlineIndemnityMandate.FilterGroup(0);
        AllOnlineIndemnities.SetTableView(OnlineIndemnityMandate);
        AllOnlineIndemnities.RunModal;
    end;

    local procedure NewOnlineIndemnity()
    begin
    end;

    procedure ViewSourceDocument(ClientTrans: Record "Client Transactions")
    begin
        if ClientTrans."Transaction Source Document"=ClientTrans."Transaction Source Document"::Subscription then begin
          Clear(PostedSubscription);
          PostedSubscription.Reset;
          PostedSubscription.FilterGroup(9);
          PostedSubscription.SetRange(No,ClientTrans."Transaction No");
          PostedSubscription.FilterGroup(0);
          PostedSubscriptions.SetTableView(PostedSubscription);
          PostedSubscriptions.RunModal;
        end else if ClientTrans."Transaction Source Document"=ClientTrans."Transaction Source Document"::Redemption then begin
         Clear(PostedRedemptions);
          PostedRedemption.Reset;
          PostedRedemption.FilterGroup(9);
          PostedRedemption.SetRange(No,ClientTrans."Transaction No");
          PostedRedemption.FilterGroup(0);
          PostedRedemptions.SetTableView(PostedRedemption);
          PostedRedemptions.RunModal;
        end else if ClientTrans."Transaction Source Document"=ClientTrans."Transaction Source Document"::"Fund Transfer" then begin
           Clear(PostedFundTransfers);
          PostedFundTransfer.Reset;
          PostedFundTransfer.FilterGroup(9);
          PostedFundTransfer.SetRange(No,ClientTrans."Transaction No");
          PostedFundTransfer.FilterGroup(0);
          PostedFundTransfers.SetTableView(PostedFundTransfer);
          PostedFundTransfers.RunModal;
        end else if ClientTrans."Transaction Source Document"=ClientTrans."Transaction Source Document"::"Dividend Reinvest" then begin
           Clear(EOQList);
          EOQHeader.Reset;
          EOQHeader.FilterGroup(9);
          EOQHeader.SetRange(No,ClientTrans."Transaction No");
          EOQHeader.FilterGroup(0);
          EOQList.SetTableView(EOQHeader);
          EOQList.RunModal;
        end else if ClientTrans."Transaction Source Document"=ClientTrans."Transaction Source Document"::"Unit Switch" then begin
           Clear(UnitSwitchPosted);
          UnitSwitchHeader.Reset;
          UnitSwitchHeader.FilterGroup(9);
          UnitSwitchHeader.SetRange("Transaction No",ClientTrans."Transaction No");
          UnitSwitchHeader.FilterGroup(0);
          UnitSwitchPosted.SetTableView(UnitSwitchHeader);
          UnitSwitchPosted.RunModal;
        end else if ClientTrans."Transaction Source Document"=ClientTrans."Transaction Source Document"::"Subscription Schedule" then begin
           Clear(SubscriptionSchedulePosted);
          UnitSwitchHeader.Reset;
          UnitSwitchHeader.FilterGroup(9);
          SubscriptionSchedulesHeader.SetRange("Schedule No",ClientTrans."Transaction No");
          SubscriptionSchedulesHeader.FilterGroup(0);
          SubscriptionSchedulePosted.SetTableView(SubscriptionSchedulesHeader);
          SubscriptionSchedulePosted.RunModal;
        end
    end;

    procedure ViewAccountLines(ClientID: Code[20];Requestlevel: Option Client,Account)
    begin
        Clear(AccountLiens);
        AccountLien.Reset;
        AccountLien.FilterGroup(10);
        if Requestlevel=Requestlevel::Client then
        AccountLien.SetRange("CLient ID",ClientID)
        else
          AccountLien.SetRange("Account No",ClientID);
        AccountLien.FilterGroup(0);
        AccountLiens.SetTableView(AccountLien);
        AccountLiens.RunModal;
    end;

    procedure Viewpostedinterest(ClientID: Code[20];Requestlevel: Option Client,Account)
    begin
        Clear(DailyIncdistribLinesPosteds);
        DailyIncDistribLinesPosted.Reset;
        DailyIncDistribLinesPosted.FilterGroup(10);
        if Requestlevel=Requestlevel::Client then
        DailyIncDistribLinesPosted.SetRange("Client ID",ClientID)
        else
          DailyIncDistribLinesPosted.SetRange("Account No",ClientID);
        DailyIncDistribLinesPosted.FilterGroup(0);
        DailyIncdistribLinesPosteds.SetTableView(DailyIncDistribLinesPosted);
        DailyIncdistribLinesPosteds.RunModal;
    end;

    procedure ViewAccruedinterest(ClientID: Code[20];Requestlevel: Option Client,Account)
    begin
        Clear(DailyIncomedistribLines);
        DailyIncomeDistribLine.Reset;
        DailyIncomeDistribLine.FilterGroup(10);
        if Requestlevel=Requestlevel::Client then
        DailyIncomeDistribLine.SetRange("Client ID",ClientID)
        else
          DailyIncomeDistribLine.SetRange("Account No",ClientID);
        DailyIncomeDistribLine.FilterGroup(0);
        DailyIncomedistribLines.SetTableView(DailyIncomeDistribLine);
        DailyIncomedistribLines.RunModal;
    end;

    procedure ValidateKYC(AccountNo: Code[50])
    var
        KYCTier: Record "KYC Tier";
        ClientAccount: Record "Client Account";
        NAV: Decimal;
    begin
        if ClientAccount.Get(AccountNo) then begin
          ClientAccount.CalcFields("No of Units");
          NAV:=FundAdministration.GetFundPrice(ClientAccount."Fund No",Today,TransactType::Redemption)* ClientAccount."No of Units";

        KYCTier.Reset;
        KYCTier.SetRange("KYC Code",ClientAccount."KYC Tier");
        if KYCTier.FindFirst then begin
            if (NAV> KYCTier."Account Balance Threshold") and( KYCTier."Account Balance Threshold"<>0)  then
              Error('This account has exceeded KYC threshhold and thus you cannot redeem until its upgrade to the next Tier');
        end
        else Error('Account No %1 must have a KYC Tier',AccountNo);
        end;
    end;

    procedure ViewOngoingSubscriptions(ClientID: Code[40])
    begin
    end;

    procedure ViewOngoingRedemtions(ClientID: Code[40])
    begin
    end;

    procedure NewLien(ClientID: Code[40];Requestlevel: Option Client,Account)
    begin
        Clear(LienCard);
        AccountLien.Init;
        AccountLien.Validate("CLient ID",ClientID);
        AccountLien.Insert(true);
        AccountLien.SetRange("Lien No",AccountLien."Lien No");
        LienCard.SetTableView(AccountLien);
        LienCard.Run;
    end;

    local procedure ViewLien(ClientID: Code[40])
    begin
    end;

    procedure ViewKYCLinks(ClientID: Code[20])
    begin
        Clear(ClientKYCDocuments);
        KYCLinks.Reset;
        KYCLinks.FilterGroup(10);
        KYCLinks.SetRange("Client ID",ClientID);
        KYCLinks.FilterGroup(0);
        ClientKYCDocuments.SetTableView(KYCLinks);
        ClientKYCDocuments.RunModal;
    end;

    procedure ValidateEmail(EmailAddress: Text)
    var
        NoOfAtSigns: Integer;
        i: Integer;
        noofdots: Integer;
        emailchars: array [50] of Char;
    begin
        EmailAddress := DelChr(EmailAddress,'<>');

        if EmailAddress = '' then
          Error(InvalidEmailAddressErr,EmailAddress);

        if (EmailAddress[1] = '@') or (EmailAddress[StrLen(EmailAddress)] = '@') then
          Error(InvalidEmailAddressErr,EmailAddress);
        if (EmailAddress[1] = '.') or (EmailAddress[StrLen(EmailAddress)] = '.') then
          Error(InvalidEmailAddressErr,EmailAddress);
        for i := 1 to StrLen(EmailAddress) do begin
          Evaluate(emailchars[i],CopyStr(EmailAddress,i,1));
          if emailchars[i] = '@' then
            NoOfAtSigns := NoOfAtSigns + 1
          else
            if emailchars[i] = ' ' then
              Error(InvalidEmailAddressErr,EmailAddress);
        end;


        if NoOfAtSigns <> 1 then
          Error(InvalidEmailAddressErr,EmailAddress);

        for i:=StrPos(EmailAddress,'@') to StrLen(EmailAddress) do begin
          if EmailAddress[i] = '.' then
            noofdots := noofdots + 1
          else
            if EmailAddress[i] = ' ' then
              Error(InvalidEmailAddressErr,EmailAddress);

        end;
        for i:=StrPos(EmailAddress,'@') to StrLen(EmailAddress) do begin
          Evaluate(emailchars[i],CopyStr(EmailAddress,i,1));
          if emailchars[i] = '.' then
           noofdots := noofdots + 1
          else
            if emailchars[i] = ' ' then
              Error(InvalidEmailAddressErr,EmailAddress);
        end;
        if noofdots < 1 then
          Error(InvalidEmailAddressErr,EmailAddress);
    end;

    procedure ValidatePhoneNo(Phoneno: Code[20])
    begin
        if Phoneno<>'' then
        if (StrLen(Format(Phoneno))<8) or (StrLen(Format(Phoneno))>15) then
          Error('Phone Number can have a minimum of 8 and a maximum of 15 characters ');
        if not Isphoneno(Phoneno) then
          Error('Phone number must not have letters');
    end;

    procedure ValidateFirstname(Name: Text)
    begin
        if Name<>'' then
        if (StrLen(Name)<3)then
          Error('First Name must have a minimum of 3 characters ');
        if Isnumeric(Name) then
          Error('Name must not have digits');
    end;

    procedure ValidateSurname(Name: Text)
    begin
        if Name<>'' then
        if (StrLen(Name)<3)then
          Error('Surname Name must have a minimum of 3 characters ');
        if Isnumeric(Name) then
          Error('Name must not have digits');
    end;

    procedure Validateothername(Name: Text)
    begin
        /*IF Name<>'' THEN
        IF (STRLEN(Name)<1)THEN
          ERROR('other  must have a minimum of 1 ');
        */
        if Isnumeric(Name) then
          Error('Name must not have digits');

    end;

    local procedure Isnumeric(pText: Text): Boolean
    var
        i: Integer;
        chars: array [50] of Char;
    begin
        begin
          for i := 1 to StrLen(pText) do
              Evaluate(chars[i],CopyStr(pText,i,1));


            if (Format(chars[i]) in  ['0'..'9'])then
              if StrLen(DelChr(pText, '=', DelChr(pText,'=', '.'))) <= 1 then
                exit(true)
              else
                exit(false)
            else
              exit(false);
        end;
    end;

    procedure ValidateAccountNo(accno: Code[50])
    begin
        if not Isnumeric(accno) then
          Error('Account number must be digits only');
        if (StrLen(Format(accno))<10) or (StrLen(Format(accno))>10) then
          Error('Account number must be 10 digits');
    end;

    procedure GetTier(ClientID: Code[40]): Code[40]
    var
        KYCTier: Record "KYC Tier";
        KYCLinks: Record "KYC Links";
        Change: Boolean;
        KYCTierRequirements: Record "KYC Tier Requirements";
        NewTier: Code[10];
    begin
        if Client.Get(ClientID) then begin
          KYCTier.Reset;
          NewTier:='';
          if KYCTier.FindFirst then
            repeat
              if NewTier='' then
                NewTier:=KYCTier."KYC Code";
              Change:=false;
              KYCTierRequirements.Reset;
              KYCTierRequirements.SetRange("KYC Tier",KYCTier."KYC Code");
              if KYCTierRequirements.FindFirst then
                repeat
                  KYCLinks.Reset;
                  KYCLinks.SetRange("Client ID",Client."Membership ID");
                  KYCLinks.SetRange("KYC Type",KYCTierRequirements.Requirement);
                  if KYCLinks.FindFirst then
                    Change:=true
                  else
                    Change:=false;

                until KYCTierRequirements.Next=0;
                if Change then begin
                  NewTier:=KYCTier."KYC Code";
                end
              until KYCTier.Next=0;
            exit(NewTier);
        end;
    end;

    procedure ValidateBVN(accno: Code[50])
    begin
        if not Isnumeric(accno) then
          Error('BVN number must be digits only');
        if (StrLen(Format(accno))<11) or (StrLen(Format(accno))>11) then
          Error('BVN number must be 11 digits');
    end;

    local procedure Isphoneno(pText: Text): Boolean
    var
        i: Integer;
        chars: array [50] of Char;
    begin
        begin
          for i := 1 to StrLen(pText) do begin
              Evaluate(chars[i],CopyStr(pText,i,1));
              if (Format(chars[i]) in  ['0'..'9']) or (Format(chars[i]) in  ['+']) then begin

                end
              else
              exit(false);
            end;
            exit(true);
        end;
    end;

    procedure ViewInstClientstatement(AccountNo: Code[20];FundGroup: Code[40])
    begin
        Clear(InstitutionalAccntStatement);
        Client.Reset;
        Client.SetRange("Membership ID",AccountNo);
        InstitutionalAccntStatement.GetFundgroup(FundGroup);
        InstitutionalAccntStatement.SetTableView(Client);
        InstitutionalAccntStatement.RunModal;
    end;

    procedure ViewClientTransactions2(ClientID: Code[20])
    begin
        Clear(ClientTransactions);
        ClientTransaction.Reset;
        ClientTransaction.FilterGroup(10);
        ClientTransaction.SetRange("Client ID",ClientID);
        ClientAccount.Reset;
        ClientAccount.SetRange("Client ID",ClientID);
        if ClientAccount.FindFirst then
          fundcode := ClientAccount."Fund No";
        ClientTransaction.SetRange("Fund Code",fundcode);
        ClientTransaction.FilterGroup(0);
        ClientTransactionRev.SetTableView(ClientTransaction);
        ClientTransactionRev.RunModal;
    end;

    procedure ViewPendingClientTransactions(ClientID: Code[20])
    var
        TempClientTransaction: Record "Temp Client Transactions";
        ClientTransactionPending: Page "Client Transaction Rev Pending";
    begin
        Clear(TempClientTransaction);
        TempClientTransaction.Reset;
        TempClientTransaction.FilterGroup(10);
        TempClientTransaction.SetRange("Client ID",ClientID);
        ClientAccount.Reset;
        ClientAccount.SetRange("Client ID",ClientID);
        ClientAccount.SetFilter("Reversal Approval",'%1',ClientAccount."Reversal Approval"::pending);
        if ClientAccount.FindFirst then
          fundcode := ClientAccount."Fund No";
        TempClientTransaction.SetRange("Fund Code",fundcode);
        TempClientTransaction.SetRange(Reversed,false);
        TempClientTransaction.FilterGroup(0);
        ClientTransactionPending.SetTableView(TempClientTransaction);
        ClientTransactionPending.RunModal;
    end;

    procedure ViewApproveClientTransactions(ClientID: Code[20])
    var
        TempClientTransaction: Record "Temp Client Transactions";
        ClientTransactionApprove: Page "Client Transaction Rev Approve";
    begin
        Clear(TempClientTransaction);
        TempClientTransaction.Reset;
        TempClientTransaction.FilterGroup(10);
        TempClientTransaction.SetRange("Client ID",ClientID);
        ClientAccount.Reset;
        ClientAccount.SetRange("Client ID",ClientID);
        ClientAccount.SetFilter("Reversal Approval",'%1',ClientAccount."Reversal Approval"::approved);
        if ClientAccount.FindFirst then
          fundcode := ClientAccount."Fund No";
        TempClientTransaction.SetRange("Fund Code",fundcode);
        TempClientTransaction.SetRange(Reversed,false);
        TempClientTransaction.FilterGroup(0);
        ClientTransactionApprove.SetTableView(TempClientTransaction);
        ClientTransactionApprove.RunModal;
    end;
}

