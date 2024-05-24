codeunit 50001 "Fund Administration"
{

    trigger OnRun()
    begin
    end;

    var
        DirectDebitMandate: Record "Direct Debit Mandate";
        DirectDebitTracker: Record "Direct Debit Tracker";
        DirectDebitTrackers: Page "Direct Debit Tracker";
        DirectDebitTracker2: Record "Direct Debit Tracker";
        OnlineIndemnityMandate: Record "Online Indemnity Mandate";
        OnlineIndemnityTracker: Record "Online Indemnity Tracker";
        OnlineIndemnityTracker2: Record "Online Indemnity Tracker";
        OnlineIndemnityTrackers: Page "Online Indemnity Tracker";
        Fund: Record Fund;
        Subscription: Record Subscription;
        SubscriptionTracker: Record "Subscription Tracker";
        SubscriptionTracker2: Record "Subscription Tracker";
        SubscriptionTrackers: Page "Subscription Tracker";
        FundPrices: Record "Fund Prices";
        Redemption: Record Redemption;
        RedemptionTracker: Record "Redemption Tracker";
        RedemptionTrackers: Page "Redemption Tracker";
        RedemptionTracker2: Record "Redemption Tracker";
        FundTransferTracker: Record "Fund Transfer Tracker";
        FundTransferTracker2: Record "Fund Transfer Tracker";
        FundTransferTrackers: Page "Unit Transfer Tracker";
        FundTransfer: Record "Fund Transfer";
        FundTransactionManagement: Codeunit "Fund Transaction Management";
        NotificationFunctions: Codeunit "Notification Functions";
        ExternalCallService: Codeunit ExternalCallService;
        DocumentType: Option Redemption,Subscription,UnitTransfer,OnlineIndemnity;
        TEMPBLOB3: Record TempBlob;
        base64: Text;
        FundAdministrationSetup: Record "Fund Administration Setup";
        FundPayoutCharges: Record "Fund Payout Charges";
        ClientTrans: Record "Client Transactions";
        ClientAc: Record "Client Account";
        ValidBonus: Decimal;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        WebService: Codeunit WebserviceFunctions;
        LoyaltySetup: Record "Loyalty Earnings Setup";
        DailyIncome: Record "Daily Income Distrib Lines";
        FundTransferLines: Record "Fund Transfer Lines";
        FundTransferHeader: Record "Fund Transfer Header";

    procedure ChangeDirectDebitSetupStatusBatch(OldStatus: Option Received,"ARM Registrar","Logged on Bank Platform","Approved By Bank","Rejected By Bank","Rejected By ARM Reg",Cancelled,"Batch ID Generated","Mandate Cancelled","Update Direct Debit","Sent letter to Bank","Received Response From Bank";NewStatus: Option Received,"ARM Registrar","Logged on Bank Platform","Approved By Bank","Rejected By Bank","Rejected By ARM Reg",Cancelled,"Batch ID Generated","Mandate Cancelled","Update Direct Debit","Sent letter to Bank","Received Response From Bank")
    begin

        if not Confirm('Are you sure you want to move this record(s) to the next Stage?') then
          Error('');
        DirectDebitMandate.Reset;
        DirectDebitMandate.SetRange("Request Type",DirectDebitMandate."Request Type"::Setup);
        DirectDebitMandate.SetRange(Select,true);
        DirectDebitMandate.SetRange("Selected By",UserId);
        DirectDebitMandate.SetRange(Status,OldStatus);
        if  DirectDebitMandate.FindFirst then begin
          repeat
            if NewStatus=NewStatus::"Rejected By Bank" then
            DirectDebitMandate.TestField(Comments)
           else begin
            DirectDebitMandate.TestField(Amount);
            DirectDebitMandate.TestField("Account No");
            DirectDebitMandate.TestField("Start Date");
            DirectDebitMandate.TestField("Account No");
            DirectDebitMandate.TestField("Bank Account Name");
            DirectDebitMandate.TestField("Bank Code");
           DirectDebitMandate. TestField("Bank Account Number");
           end;

            DirectDebitMandate.Status:=NewStatus;
            DirectDebitMandate.Select:=false;
            DirectDebitMandate."Selected By":='';
            DirectDebitMandate.Modify;
            InsertDirectDebitTracker(NewStatus,DirectDebitMandate.No);
            //DD Email Notification for Bulk Selection.
             if NewStatus=NewStatus::"ARM Registrar" then begin
              NotificationFunctions.CreateNotificationEntry(0,UserId,CurrentDateTime,'Direct Debit Mandate',DirectDebitMandate.No,
            DirectDebitMandate."Client Name",DirectDebitMandate."Client ID",Format(NewStatus),DirectDebitMandate."Fund Code",DirectDebitMandate."Account No",
        'Direct Debit Mandate',DirectDebitMandate.Amount,11)
        end else if NewStatus = NewStatus::"Logged on Bank Platform" then begin
            NotificationFunctions.CreateNotificationEntry(1,UserId,CurrentDateTime,'Direct Debit Mandate',DirectDebitMandate.No,
            DirectDebitMandate."Client Name",DirectDebitMandate."Client ID",Format(NewStatus),DirectDebitMandate."Fund Code",DirectDebitMandate."Account No",
        'Direct Debit Mandate',DirectDebitMandate.Amount,12)
        end else if NewStatus = NewStatus::"Approved By Bank" then begin
            NotificationFunctions.CreateNotificationEntry(1,UserId,CurrentDateTime,'Direct Debit Mandate',DirectDebitMandate.No,
            DirectDebitMandate."Client Name",DirectDebitMandate."Client ID",Format(NewStatus),DirectDebitMandate."Fund Code",DirectDebitMandate."Account No",
        'Direct Debit Mandate',DirectDebitMandate.Amount,13)
        end else if NewStatus = NewStatus::"Rejected By Bank" then begin
            NotificationFunctions.CreateNotificationEntry(1,UserId,CurrentDateTime,'Direct Debit Mandate',DirectDebitMandate.No,
            DirectDebitMandate."Client Name",DirectDebitMandate."Client ID",Format(NewStatus),DirectDebitMandate."Fund Code",DirectDebitMandate."Account No",
        'Direct Debit Mandate',DirectDebitMandate.Amount,14)
        end else if NewStatus = NewStatus::Cancelled then begin
            NotificationFunctions.CreateNotificationEntry(1,UserId,CurrentDateTime,'Direct Debit Mandate',DirectDebitMandate.No,
            DirectDebitMandate."Client Name",DirectDebitMandate."Client ID",Format(NewStatus),DirectDebitMandate."Fund Code",DirectDebitMandate."Account No",
        'Direct Debit Mandate',DirectDebitMandate.Amount,15)
        end
          until DirectDebitMandate.Next=0;
        end
        else
        Error('There is no Record selected by you');
        Message('Records moved successfully');
    end;

    procedure ChangeDirectDebitSetupStatussingle(OldStatus: Option Received,"ARM Registrar","Logged on Bank Platform","Approved By Bank","Rejected By Bank","Rejected By ARM Reg",Cancelled,"Batch ID Generated","Mandate Cancelled","Update Direct Debit","Sent letter to Bank","Received Response From Bank";NewStatus: Option Received,"ARM Registrar","Logged on Bank Platform","Approved By Bank","Rejected By Bank","Rejected By ARM Reg",Cancelled,"Batch ID Generated","Mandate Cancelled","Update Direct Debit","Sent letter to Bank","Received Response From Bank";DirectDebitMandate: Record "Direct Debit Mandate")
    var
        DirectDebitMandate2: Record "Direct Debit Mandate";
    begin
        if OldStatus=OldStatus::Received then
          if DirectDebitMandate."Document Link"='' then begin
            Error('Please attach a document');
        
          Error('');
        end else
        if not Confirm('Are you sure you want to move this record to the next Stage?') then
          //Maxwell: To check if the comment field is empty before rejecting by ARM Reg
           /*IF NewStatus=NewStatus::"Rejected By ARM Reg" THEN
             DirectDebitMandate.TESTFIELD(Comments);*/
           //
          if NewStatus=NewStatus::"Rejected By Bank" then begin
        
            DirectDebitMandate.TestField(Comments);
            if OldStatus=OldStatus::"ARM Registrar" then
              DirectDebitMandate."Rejected By":='BANK'
            else
              DirectDebitMandate."Rejected By":='ARM';
           end
           else begin
             if DirectDebitMandate."Request Type"=DirectDebitMandate."Request Type"::Setup then begin
        
            DirectDebitMandate.TestField("Account No");
             DirectDebitMandate.TestField(Amount);
            DirectDebitMandate.TestField("Start Date");
            DirectDebitMandate.TestField("Account No");
            //DirectDebitMandate.TESTFIELD("Bank Account Name");
            //DirectDebitMandate.TESTFIELD("Bank Code");
           DirectDebitMandate. TestField("Bank Account Number");
           end else begin
              DirectDebitMandate.TestField("Account No");
              DirectDebitMandate.TestField("Direct Debit to Be cancelled");
             end
           end;
           /*IF NewStatus=NewStatus::"Logged on Bank Platform" THEN
             ExternalCallService.SendNibbs('1018996198','08030607376','NDUKWE NNAMDI ANTHONY',3000,'NDUKWE NNAMDI ANTHONY','Local Address Lagos','subscription payment','1','0','sfagbola@nibss-plc.com.ng',FORMAT(DirectDebitMandate."Start Date"),
           FORMAT(DirectDebitMandate."End Date"),'55','033',DirectDebitMandate.FileName,DirectDebitMandate.ToBase64String,DirectDebitMandate);
        
            DirectDebitMandate.Status:=NewStatus;
            */
           /* TEMPBLOB3.INIT;
        TEMPBLOB3.TryDownloadFromUrl('http://www.africau.edu/images/default/sample.pdf');
        
        base64:=TEMPBLOB3.ToBase64String;
             IF NewStatus=NewStatus::"Logged on Bank Platform" THEN BEGIN
              IF DirectDebitMandate."Request Type"=DirectDebitMandate."Request Type"::Setup THEN BEGIN
        
             ExternalCallService.SendNibbs('1018996198','08030607376','NDUKWE NNAMDI ANTHONY',3000,'NDUKWE NNAMDI ANTHONY','Local Address Lagos','subscription payment','1','0','sfagbola@nibss-plc.com.ng','20190304',
           '20290304','55','033','pdf',base64,DirectDebitMandate);
           END  ELSE IF DirectDebitMandate."Request Type"=DirectDebitMandate."Request Type"::Cancellation  THEN BEGIN
                 ExternalCallService.UpdateNibbsDirectDebit(DirectDebitMandate."Cancelled Reference Number",'08030607376','NDUKWE NNAMDI ANTHONY','Local Address Lagos','3','2','sfagbola@nibss-plc.com.ng',DirectDebitMandate);
             END  ELSE IF DirectDebitMandate."Request Type"=DirectDebitMandate."Request Type"::Suspension THEN  BEGIN
              ExternalCallService.UpdateNibbsDirectDebit(DirectDebitMandate."Cancelled Reference Number",'08030607376','NDUKWE NNAMDI ANTHONY','Local Address Lagos','2','2','sfagbola@nibss-plc.com.ng',DirectDebitMandate);
            END;
        
             IF DirectDebitMandate."Response Code"='00' THEN
             DirectDebitMandate.Status:=NewStatus
            ELSE ERROR('Mandate Could not be logged on Nibbs');
        
           END  ELSE*/
            DirectDebitMandate.Status:=NewStatus;
            DirectDebitMandate.Select:=false;
            DirectDebitMandate."Selected By":='';
            DirectDebitMandate.Modify;
            if NewStatus=NewStatus::"Approved By Bank" then begin
              DirectDebitMandate2.Reset;
              DirectDebitMandate2.SetRange(No,DirectDebitMandate."Direct Debit to Be cancelled");
              if DirectDebitMandate2.FindFirst then begin
                DirectDebitMandate2.Status:=DirectDebitMandate2.Status::"Rejected By ARM Reg";
                DirectDebitMandate2.Modify;
                InsertDirectDebitTracker(DirectDebitMandate2.Status::"Rejected By ARM Reg",DirectDebitMandate2.No);
                end
              end;
              //DD Email Notification for single Request.
             if NewStatus=NewStatus::"ARM Registrar" then begin
              NotificationFunctions.CreateNotificationEntry(0,UserId,CurrentDateTime,'Direct Debit Mandate',DirectDebitMandate.No,
              DirectDebitMandate."Client Name",DirectDebitMandate."Client ID",Format(NewStatus),DirectDebitMandate."Fund Code",DirectDebitMandate."Account No",
            'Direct Debit Mandate',DirectDebitMandate.Amount,11)
            end else if NewStatus = NewStatus::"Logged on Bank Platform" then begin
                NotificationFunctions.CreateNotificationEntry(1,UserId,CurrentDateTime,'Direct Debit Mandate',DirectDebitMandate.No,
                DirectDebitMandate."Client Name",DirectDebitMandate."Client ID",Format(NewStatus),DirectDebitMandate."Fund Code",DirectDebitMandate."Account No",
            'Direct Debit Mandate',DirectDebitMandate.Amount,12)
            end else if NewStatus = NewStatus::"Approved By Bank" then begin
                NotificationFunctions.CreateNotificationEntry(1,UserId,CurrentDateTime,'Direct Debit Mandate',DirectDebitMandate.No,
                DirectDebitMandate."Client Name",DirectDebitMandate."Client ID",Format(NewStatus),DirectDebitMandate."Fund Code",DirectDebitMandate."Account No",
            'Direct Debit Mandate',DirectDebitMandate.Amount,13)
            end else if NewStatus = NewStatus::"Rejected By Bank" then begin
                NotificationFunctions.CreateNotificationEntry(1,UserId,CurrentDateTime,'Direct Debit Mandate',DirectDebitMandate.No,
                DirectDebitMandate."Client Name",DirectDebitMandate."Client ID",Format(NewStatus),DirectDebitMandate."Fund Code",DirectDebitMandate."Account No",
            'Direct Debit Mandate',DirectDebitMandate.Amount,14)
            end else if NewStatus = NewStatus::Cancelled then begin
                NotificationFunctions.CreateNotificationEntry(1,UserId,CurrentDateTime,'Direct Debit Mandate',DirectDebitMandate.No,
                DirectDebitMandate."Client Name",DirectDebitMandate."Client ID",Format(NewStatus),DirectDebitMandate."Fund Code",DirectDebitMandate."Account No",
            'Direct Debit Mandate',DirectDebitMandate.Amount,15)
            end;
            InsertDirectDebitTracker(NewStatus,DirectDebitMandate.No);
        
        Message('Records moved successfully');

    end;

    procedure InsertDirectDebitTracker(newstatus: Option Received,"ARM Registrar","Logged on Bank Platform","Approved By Bank","Rejected By Bank",Cancelled,"Batch ID Generated","Mandate Cancelled","Update Direct Debit","Sent letter to Bank","Received Response From Bank";MandateNo: Code[40])
    var
        lineno: Integer;
    begin

        if DirectDebitTracker2.FindLast then
          lineno:=DirectDebitTracker2."Entry No"+1
        else
            lineno:=1;
        if DirectDebitMandate.Get(MandateNo) then;
        DirectDebitTracker.Init;
        DirectDebitTracker."Entry No":=lineno;
        DirectDebitTracker."Direct Debit Mandate":=MandateNo;
        DirectDebitTracker."Changed By":=UserId;
        DirectDebitTracker."Date Time":=CurrentDateTime;
        DirectDebitTracker.Comments:=DirectDebitMandate.Comments;
        DirectDebitTracker.Status:=newstatus;
        DirectDebitTracker.Insert;
    end;

    procedure SelectALLDirectDebitSetup(OldStatus: Option Received,"ARM Registrar","Logged on Bank Platform","Approved By Bank","Rejected By Bank",Cancelled,"Batch ID Generated","Mandate Cancelled","Update Direct Debit","Sent letter to Bank","Received Response From Bank")
    begin
        DirectDebitMandate.Reset;
        DirectDebitMandate.SetRange("Request Type",DirectDebitMandate."Request Type"::Setup);
        DirectDebitMandate.SetRange(Status,OldStatus);
        if  DirectDebitMandate.FindFirst then begin
          repeat
            DirectDebitMandate.Validate(Select,true);
            DirectDebitMandate."Selected By":=UserId;
            DirectDebitMandate.Modify;
          until DirectDebitMandate.Next=0;
        end
    end;

    procedure UnSelectALLDirectDebitSetup(OldStatus: Option Received,"ARM Registrar","Logged on Bank Platform","Approved By Bank","Rejected By Bank",Cancelled,"Batch ID Generated","Mandate Cancelled","Update Direct Debit","Sent letter to Bank","Received Response From Bank")
    begin
        DirectDebitMandate.Reset;
        DirectDebitMandate.SetRange("Request Type",DirectDebitMandate."Request Type"::Setup);
        DirectDebitMandate.SetRange(Status,OldStatus);
        DirectDebitMandate.SetRange(Select,true);
        DirectDebitMandate.SetRange("Selected By",UserId);
        if  DirectDebitMandate.FindFirst then begin
          repeat
            DirectDebitMandate.Select:=false;
            DirectDebitMandate."Selected By":='';
            DirectDebitMandate.Modify;
          until DirectDebitMandate.Next=0;
        end
    end;

    procedure ViewDirectDebitTracker(Mandateno: Code[20])
    begin
        Clear(DirectDebitTrackers);
        DirectDebitTracker.Reset;
        DirectDebitTracker.FilterGroup(10);
        DirectDebitTracker.SetRange("Direct Debit Mandate",Mandateno);
        DirectDebitTracker.FilterGroup(0);
        DirectDebitTrackers.SetTableView(DirectDebitTracker);
        DirectDebitTrackers.RunModal;
    end;

    procedure ChangeDirectDebitCancelStatusBatch(OldStatus: Option Received,"ARM Registrar","Logged on Bank Platform","Approved By Bank","Rejected By Bank",Cancelled,"Batch ID Generated","Mandate Cancelled","Update Direct Debit","Sent letter to Bank","Received Response From Bank";NewStatus: Option Received,"ARM Registrar","Logged on Bank Platform","Approved By Bank","Rejected By Bank",Cancelled,"Batch ID Generated","Mandate Cancelled","Update Direct Debit","Sent letter to Bank","Received Response From Bank")
    begin
        if not Confirm('Are you sure you want to move this record(s) to the next Stage?') then
          Error('');
        DirectDebitMandate.Reset;
        DirectDebitMandate.SetRange("Request Type",DirectDebitMandate."Request Type"::Cancellation);
        DirectDebitMandate.SetRange(Select,true);
        DirectDebitMandate.SetRange("Selected By",UserId);
        DirectDebitMandate.SetRange(Status,OldStatus);
        if NewStatus=NewStatus::"Batch ID Generated" then
          DirectDebitMandate.SetRange("Cancellation Channel", DirectDebitMandate."Cancellation Channel"::"Online Channels")
        else if NewStatus=NewStatus::"Sent letter to Bank" then
          DirectDebitMandate.SetRange("Cancellation Channel", DirectDebitMandate."Cancellation Channel"::Bank);
        if  DirectDebitMandate.FindFirst then begin
          repeat
            DirectDebitMandate.TestField("Account No");
            DirectDebitMandate.TestField("Direct Debit to Be cancelled");
            DirectDebitMandate.Status:=NewStatus;
            DirectDebitMandate.Select:=false;
            DirectDebitMandate."Selected By":='';
            DirectDebitMandate.Modify;
            InsertDirectDebitTracker(NewStatus,DirectDebitMandate.No);
            if NewStatus=NewStatus::"Update Direct Debit" then
              UpdateDirectDebit(DirectDebitMandate."Direct Debit to Be cancelled");
         if NewStatus=NewStatus::"ARM Registrar" then begin
              NotificationFunctions.CreateNotificationEntry(0,UserId,CurrentDateTime,'Direct Debit Mandate Cancellation',DirectDebitMandate.No,
            DirectDebitMandate."Client Name",DirectDebitMandate."Client ID",Format(NewStatus),DirectDebitMandate."Fund Code",DirectDebitMandate."Account No",
        'Direct Debit Mandate Cancellation',0,1)
        end else begin
             NotificationFunctions.CreateNotificationEntry(1,UserId,CurrentDateTime,'Direct Debit Mandate cancellation',DirectDebitMandate.No,
            DirectDebitMandate."Client Name",DirectDebitMandate."Client ID",Format(NewStatus),DirectDebitMandate."Fund Code",DirectDebitMandate."Account No",
        'Direct Debit Mandate Cancellation',0,1)
        end;
          until DirectDebitMandate.Next=0;
        end
        else
        Error('There is no Record selected by you');
        Message('Records moved successfully');
    end;

    procedure ChangeDirectDebitCancelStatusSingle(OldStatus: Option Received,"ARM Registrar","Logged on Bank Platform","Approved By Bank","Rejected By Bank",Cancelled,"Batch ID Generated","Mandate Cancelled","Update Direct Debit","Sent letter to Bank","Received Response From Bank";NewStatus: Option Received,"ARM Registrar","Logged on Bank Platform","Approved By Bank","Rejected By Bank",Cancelled,"Batch ID Generated","Mandate Cancelled","Update Direct Debit","Sent letter to Bank","Received Response From Bank";DirectDebitMandate: Record "Direct Debit Mandate")
    begin
        if not Confirm('Are you sure you want to move this record(s) to the next Stage?') then
          Error('');

            DirectDebitMandate.Status:=NewStatus;
            DirectDebitMandate.Select:=false;
            DirectDebitMandate."Selected By":='';
            DirectDebitMandate.Modify;
            InsertDirectDebitTracker(NewStatus,DirectDebitMandate.No);
            if NewStatus=NewStatus::"Update Direct Debit" then
              UpdateDirectDebit(DirectDebitMandate."Direct Debit to Be cancelled");
        Message('Records moved successfully');
    end;

    procedure SelectALLDirectDebitCancel(OldStatus: Option Received,"ARM Registrar","Logged on Bank Platform","Approved By Bank","Rejected By Bank",Cancelled,"Batch ID Generated","Mandate Cancelled","Update Direct Debit","Sent letter to Bank","Received Response From Bank")
    begin
        DirectDebitMandate.Reset;
        DirectDebitMandate.SetRange("Request Type",DirectDebitMandate."Request Type"::Cancellation);
        DirectDebitMandate.SetRange(Status,OldStatus);
        if  DirectDebitMandate.FindFirst then begin
          repeat
            DirectDebitMandate.Validate(Select,true);
            DirectDebitMandate."Selected By":=UserId;
            DirectDebitMandate.Modify;
          until DirectDebitMandate.Next=0;
        end
    end;

    procedure UnSelectALLDirectDebitCancel(OldStatus: Option Received,"ARM Registrar","Logged on Bank Platform","Approved By Bank","Rejected By Bank",Cancelled,"Batch ID Generated","Mandate Cancelled","Update Direct Debit","Sent letter to Bank","Received Response From Bank")
    begin
        DirectDebitMandate.Reset;
        DirectDebitMandate.SetRange("Request Type",DirectDebitMandate."Request Type"::Cancellation);
        DirectDebitMandate.SetRange(Status,OldStatus);
        DirectDebitMandate.SetRange(Select,true);
        DirectDebitMandate.SetRange("Selected By",UserId);
        if  DirectDebitMandate.FindFirst then begin
          repeat
            DirectDebitMandate.Select:=false;
            DirectDebitMandate."Selected By":='';
            DirectDebitMandate.Modify;
          until DirectDebitMandate.Next=0;
        end
    end;

    procedure UpdateDirectDebit(Mandateno: Code[20])
    begin
        DirectDebitMandate.Reset;
        DirectDebitMandate.SetRange(No,Mandateno);
        if  DirectDebitMandate.FindFirst then begin
          repeat
            DirectDebitMandate.Status:=DirectDebitMandate.Status::"Rejected By ARM Reg";
            DirectDebitMandate.Select:=false;
            DirectDebitMandate."Selected By":='';
            DirectDebitMandate.Modify;
            InsertDirectDebitTracker(DirectDebitMandate.Status::"Rejected By ARM Reg",DirectDebitMandate.No);


          until DirectDebitMandate.Next=0;
        end
        else
        Error('There is no Record selected by you');

          Message('Records moved successfully');
    end;

    procedure ChangeOnlineIndemnityStatusbatch(OldStatus: Option Received,"ARM Registrar","External Registrar","Verification Successful","Verification Rejected",Cancelled;NewStatus: Option Received,"ARM Registrar","External Registrar","Verification Successful","Verification Rejected",Cancelled)
    begin
        if not Confirm('Are you sure you want to move this record(s) to the next Stage?') then
          Error('');
        OnlineIndemnityMandate.Reset;
        OnlineIndemnityMandate.SetRange("Request Type",OnlineIndemnityMandate."Request Type"::Setup);
        OnlineIndemnityMandate.SetRange(Select,true);
        OnlineIndemnityMandate.SetRange("Selected By",UserId);
        OnlineIndemnityMandate.SetRange(Status,OldStatus);
        if  OnlineIndemnityMandate.FindFirst then begin
          repeat
            OnlineIndemnityMandate.TestField("Account No");
            if NewStatus=NewStatus::"Verification Rejected" then
              OnlineIndemnityMandate.TestField(Comments);
            if NewStatus=NewStatus::"External Registrar" then begin
              Fund.Get(OnlineIndemnityMandate."Fund Code");
              if Fund."Ext Registrar Verification Req" then
                OnlineIndemnityMandate.Status:=NewStatus
              else
                OnlineIndemnityMandate.Status:=OnlineIndemnityMandate.Status::"Verification Successful";
            end else
              OnlineIndemnityMandate.Status:=NewStatus;
            OnlineIndemnityMandate.Select:=false;
            OnlineIndemnityMandate."Selected By":='';
            OnlineIndemnityMandate.Modify;
            InsertOnlineIndemnityTracker(NewStatus,OnlineIndemnityMandate.No);
            //Email Notification for Batch Online Indemnity Request
            if NewStatus=NewStatus::"ARM Registrar" then begin
              NotificationFunctions.CreateNotificationEntry(0,UserId,CurrentDateTime,'Online Indemnity',OnlineIndemnityMandate.No,
            OnlineIndemnityMandate."Client Name",OnlineIndemnityMandate."Client ID",Format(NewStatus),OnlineIndemnityMandate."Fund Code",OnlineIndemnityMandate."Account No",
        'Online Indemnity',0,16)
            end else if NewStatus = NewStatus::"Verification Successful" then begin
                 NotificationFunctions.CreateNotificationEntry(1,UserId,CurrentDateTime,'Online Indemnity',OnlineIndemnityMandate.No,
                OnlineIndemnityMandate."Client Name",OnlineIndemnityMandate."Client ID",Format(NewStatus),OnlineIndemnityMandate."Fund Code",OnlineIndemnityMandate."Account No",
            'Online Indemnity',0,17) ;
            end else if NewStatus = NewStatus::"Verification Rejected" then begin
                 NotificationFunctions.CreateNotificationEntry(1,UserId,CurrentDateTime,'Online Indemnity',OnlineIndemnityMandate.No,
                OnlineIndemnityMandate."Client Name",OnlineIndemnityMandate."Client ID",Format(NewStatus),OnlineIndemnityMandate."Fund Code",OnlineIndemnityMandate."Account No",
            'Online Indemnity',0,18);
            end

          until OnlineIndemnityMandate.Next=0;
        end
        else
        Error('There is no Record selected by you');

          Message('Records moved successfully');
    end;

    procedure ChangeOnlineIndemnityStatusSingle(OldStatus: Option Received,"ARM Registrar","External Registrar","Verification Successful","Verification Rejected",Cancelled;NewStatus: Option Received,"ARM Registrar","External Registrar","Verification Successful","Verification Rejected",Cancelled;OnlineIndemnityMandate: Record "Online Indemnity Mandate")
    var
        ControlID: Code[20];
    begin
        if not Confirm('Are you sure you want to move this record(s) to the next Stage?') then
          Error('');
        OnlineIndemnityMandate.TestField("Account No");
         if NewStatus=NewStatus::"Verification Rejected" then
              OnlineIndemnityMandate.TestField(Comments);
            if NewStatus=NewStatus::"External Registrar" then begin
              Fund.Get(OnlineIndemnityMandate."Fund Code");
              if Fund."Ext Registrar Verification Req" then begin
                OnlineIndemnityMandate.Status:=NewStatus;
              /*  ControlID:=ExternalCallService.SendExternalRegistrarRequest('143','Discovery',OnlineIndemnityMandate."Client ID",'0',
                OnlineIndemnityMandate."Client Name",'0',OnlineIndemnityMandate.ToBase64String,OnlineIndemnityMandate.FileName,DocumentType::OnlineIndemnity,OnlineIndemnityMandate.No);
        
        
                IF ControlID<>'' THEN
                  OnlineIndemnityMandate."Registrar Control ID":=ControlID
                ELSE
                  ERROR('There is no response from registrar');
                  */
        
                  /*
                ExternalCallService.SendExternalRegistrarRequest('143','Discovery','IV006070ST001','0',
                'Udoh Dexter Moses','0',OnlineIndemnityMandate.ToBase64String,OnlineIndemnityMandate.FileName,DocumentType::OnlineIndemnity,OnlineIndemnityMandate.No);
                */
              end else
                OnlineIndemnityMandate.Status:=OnlineIndemnityMandate.Status::"Verification Successful";
            end else
              OnlineIndemnityMandate.Status:=NewStatus;
            OnlineIndemnityMandate.Select:=false;
            OnlineIndemnityMandate."Selected By":='';
            OnlineIndemnityMandate.Modify;
            InsertOnlineIndemnityTracker(NewStatus,OnlineIndemnityMandate.No);
            //Email Notification for Single Online Indemnity Request
            if NewStatus=NewStatus::"ARM Registrar" then begin
              NotificationFunctions.CreateNotificationEntry(0,UserId,CurrentDateTime,'Online Indemnity',OnlineIndemnityMandate.No,
            OnlineIndemnityMandate."Client Name",OnlineIndemnityMandate."Client ID",Format(NewStatus),OnlineIndemnityMandate."Fund Code",DirectDebitMandate."Account No",
        'Online Indemnity',0,16)
            end else if NewStatus = NewStatus::"Verification Successful" then begin
                 NotificationFunctions.CreateNotificationEntry(1,UserId,CurrentDateTime,'Online Indemnity',OnlineIndemnityMandate.No,
                OnlineIndemnityMandate."Client Name",OnlineIndemnityMandate."Client ID",Format(NewStatus),OnlineIndemnityMandate."Fund Code",OnlineIndemnityMandate."Account No",
            'Online Indemnity',0,17) ;
            end else if NewStatus = NewStatus::"Verification Rejected" then begin
                 NotificationFunctions.CreateNotificationEntry(1,UserId,CurrentDateTime,'Online Indemnity',OnlineIndemnityMandate.No,
                OnlineIndemnityMandate."Client Name",OnlineIndemnityMandate."Client ID",Format(NewStatus),OnlineIndemnityMandate."Fund Code",OnlineIndemnityMandate."Account No",
            'Online Indemnity',0,18);
            end;
        
          Message('Record moved successfully');

    end;

    procedure SelectALLOIndemnity(OldStatus: Option Received,"ARM Registrar","External Registrar","Verification Successful","Verification Rejected",Cancelled)
    begin
        OnlineIndemnityMandate.Reset;
        OnlineIndemnityMandate.SetRange("Request Type",OnlineIndemnityMandate."Request Type"::Setup);
        OnlineIndemnityMandate.SetRange(Status,OldStatus);
        if  OnlineIndemnityMandate.FindFirst then begin
          repeat
            OnlineIndemnityMandate.Validate(Select,true);
            OnlineIndemnityMandate."Selected By":=UserId;
            OnlineIndemnityMandate.Modify;
          until OnlineIndemnityMandate.Next=0;
        end
    end;

    procedure UnSelectALLOIndemnity(OldStatus: Option Received,"ARM Registrar","External Registrar","Verification Successful","Verification Rejected",Cancelled)
    begin
        OnlineIndemnityMandate.Reset;
        OnlineIndemnityMandate.SetRange("Request Type",OnlineIndemnityMandate."Request Type"::Setup);
        OnlineIndemnityMandate.SetRange(Status,OldStatus);
        OnlineIndemnityMandate.SetRange(Select,true);
        OnlineIndemnityMandate.SetRange("Selected By",UserId);
        if  OnlineIndemnityMandate.FindFirst then begin
          repeat
            OnlineIndemnityMandate.Validate(Select,false);
            OnlineIndemnityMandate."Selected By":='';
            OnlineIndemnityMandate.Modify;
          until OnlineIndemnityMandate.Next=0;
        end
    end;

    procedure InsertOnlineIndemnityTracker(newstatus: Option Received,"ARM Registrar","External Registrar","Verification Successful","Verification Rejected",Cancelled;MandateNo: Code[40])
    var
        lineno: Integer;
    begin
        if OnlineIndemnityTracker2.FindLast then
          lineno:=OnlineIndemnityTracker2."Entry No"+1
        else
            lineno:=1;
        OnlineIndemnityTracker.Init;
        OnlineIndemnityTracker."Entry No":=lineno;
        OnlineIndemnityTracker."Online Indemnity":=MandateNo;
        OnlineIndemnityTracker."Changed By":=UserId;
        OnlineIndemnityTracker."Date Time":=CurrentDateTime;
        OnlineIndemnityTracker.Status:=newstatus;
        OnlineIndemnityTracker.Insert;
    end;

    procedure ViewOnlineIndemnityTracker(Mandateno: Code[20])
    begin
        Clear(OnlineIndemnityTrackers);
        OnlineIndemnityTracker.FilterGroup(10);
        OnlineIndemnityTracker.SetRange("Online Indemnity",Mandateno);
        OnlineIndemnityTracker.FilterGroup(0);
        OnlineIndemnityTrackers.SetTableView(OnlineIndemnityTracker);
        OnlineIndemnityTrackers.RunModal;
    end;

    procedure ChangeSubscriptionStatusBatch(OldStatus: Option Received,Confirmed,Posted;NewStatus: Option Received,Confirmed,Posted)
    begin
        if not Confirm('Are you sure you want to move this record(s) to the next Stage?') then
          Error('');
        Subscription.Reset;
        Subscription.SetRange(Select,true);
        Subscription.SetRange("Selected By",UserId);
        Subscription.SetRange("Subscription Status",OldStatus);
        if  Subscription.FindFirst then begin
          repeat
            Subscription."Subscription Status":=NewStatus;
            Subscription.Select:=false;
            Subscription."Selected By":='';
            Subscription.Modify;
            InsertSubscriptionTracker(NewStatus,Subscription.No);
          //Subscription Email Notification for Batch Request.
          if NewStatus=NewStatus::Confirmed then begin
              NotificationFunctions.CreateNotificationEntry(0,UserId,CurrentDateTime,'Subscription',Subscription.No,
            Subscription."Client Name",Subscription."Client ID",Format(NewStatus),Subscription."Fund Code",Subscription."Account No",
        'Subscription',Subscription.Amount,5);
        end;

          until Subscription.Next=0;
        end
        else
        Error('There is no Record selected by you');

          Message('Records moved successfully');
    end;

    procedure ChangeSubscriptionStatussingle(OldStatus: Option Received,Confirmed,Posted;NewStatus: Option Received,Confirmed,Posted;Subscription: Record Subscription)
    begin
        if not Confirm('Are you sure you want to move this record(s) to the next Stage?') then
          Error('');
            Subscription."Subscription Status":=NewStatus;
            Subscription.Select:=false;
            Subscription."Selected By":='';
            Subscription.Modify;
            InsertSubscriptionTracker(NewStatus,Subscription.No);

            if NewStatus=NewStatus::Confirmed then begin
              NotificationFunctions.CreateNotificationEntry(0,UserId,CurrentDateTime,'Subscription',Subscription.No,
            Subscription."Client Name",Subscription."Client ID",Format(NewStatus),Subscription."Fund Code",Subscription."Account No",
          'Subscription',Subscription.Amount,5)
          end;

          Message('Record moved successfully');
    end;

    procedure SelectALLSubscription(OldStatus: Option Received,Confirmed,Posted)
    begin
        Subscription.Reset;
        Subscription.SetRange("Subscription Status",OldStatus);
        if  Subscription.FindFirst then begin
          repeat
            Subscription.Validate(Select,true);
            Subscription."Selected By":=UserId;
            Subscription.Modify;
          until Subscription.Next=0;
        end
    end;

    procedure UnSelectALLSubscription(OldStatus: Option Received,Confirmed,Posted)
    begin
        Subscription.Reset;
        Subscription.SetRange("Subscription Status",OldStatus);
        Subscription.SetRange(Select,true);
        //Subscription.SETRANGE("Selected By",USERID);
        if  Subscription.FindFirst then begin
          repeat
            Subscription.Validate(Select,false);
            Subscription."Selected By":='';
            Subscription.Modify;
          until Subscription.Next=0;
        end
    end;

    procedure InsertSubscriptionTracker(newstatus: Option Received,Confirmed,Posted;SubscriptionNo: Code[20])
    var
        lineno: Integer;
    begin
        if SubscriptionTracker2.FindLast then
          lineno:=SubscriptionTracker2."Entry No"+1
        else
            lineno:=1;
        SubscriptionTracker.Init;
        SubscriptionTracker."Entry No":=lineno;
        SubscriptionTracker.Subscription:=SubscriptionNo;
        SubscriptionTracker."Changed By":=UserId;
        SubscriptionTracker."Date Time":=CurrentDateTime;
        SubscriptionTracker.Status:=newstatus;
        SubscriptionTracker.Insert;
    end;

    procedure ViewSubscriptionTracker(SubscriptionNo: Code[20])
    begin
        Clear(SubscriptionTrackers);
        SubscriptionTracker.FilterGroup(10);
        SubscriptionTracker.SetRange(Subscription,SubscriptionNo);
        SubscriptionTracker.FilterGroup(0);
        SubscriptionTrackers.SetTableView(SubscriptionTracker);
        SubscriptionTrackers.RunModal;
    end;

    procedure GetFundPrice(FundCode: Code[20];ValueDate: Date;TransactionType: Option Subscription,Redemption,Dividend): Decimal
    begin
        FundPrices.Reset;
        FundPrices.SetRange("Fund No.",FundCode);
        FundPrices.SetFilter("Value Date",'..%1',ValueDate);
        FundPrices.SetRange(Activated,true);
        if FundPrices.FindLast then begin
          FundPrices.TestField("Mid Price");
          FundPrices.TestField("Bid Price");
          FundPrices.TestField("Offer Price");
           if TransactionType=TransactionType::Subscription then
              exit(Round(FundPrices."Offer Price",0.0001,'='))
           else if TransactionType=TransactionType::Redemption then
             exit(Round(FundPrices."Bid Price",0.0001,'='))
           else if TransactionType=TransactionType::Dividend then
             exit(Round(FundPrices."Offer Price",0.0001,'='));

        end else
        Error('There is no Price For %1 Fund,Value Date %2 . Kindly Ensure that all Prices Have been Updated',FundCode,ValueDate);
    end;

    procedure GetFundNounits(FundCode: Code[20];ValueDate: Date;Amount: Decimal;TransactionType: Option Subscription,Redemption,Dividend): Decimal
    var
        Noofunits: Decimal;
    begin
        if Amount=0 then
          exit(0);
        FundPrices.Reset;
        FundPrices.SetRange("Fund No.",FundCode);
        FundPrices.SetFilter("Value Date",'..%1',ValueDate);
        FundPrices.SetRange(Activated,true);
        if FundPrices.FindLast then begin
          FundPrices.TestField("Mid Price");
          FundPrices.TestField("Bid Price");
          FundPrices.TestField("Offer Price");
           if TransactionType=TransactionType::Subscription then begin
              Noofunits:=Amount/Round(FundPrices."Offer Price",0.0001)
                  end
           else if TransactionType=TransactionType::Redemption then begin
             Noofunits:=Amount/Round(FundPrices."Bid Price",0.0001)
             end
           else if TransactionType=TransactionType::Dividend then begin
            Noofunits:=Amount/Round(FundPrices."Offer Price",0.0001);
           end;
           exit(Round(Noofunits,0.0001,'='));
        end else
        Error('There is no Price For %1 Fund,Value Date %2 . Kindly Ensure that all Prices Have been Updated',FundCode,ValueDate);
    end;

    procedure ChangeRedemptionStatusBatch(OldStatus: Option Received,"ARM Registrar","External Registrar",Rejected,Verified,Posted,"Customer Experience Verification";NewStatus: Option Received,"ARM Registrar","External Registrar",Rejected,Verified,Posted,"Customer Experience Verification")
    begin
        if not Confirm('Are you sure you want to move this record(s) to the next Stage?') then
          Error('');
        Redemption.Reset;
        Redemption.SetRange(Select,true);
        Redemption.SetRange("Selected By",UserId);
        Redemption.SetRange("Redemption Status",OldStatus);
        if  Redemption.FindFirst then begin
          repeat
            if OldStatus=OldStatus::Received then
          if Redemption."Document Link"='' then
            Error('Please attach a document for Redemption No %1',Redemption."Transaction No");
             if (NewStatus=NewStatus::Rejected) then begin
              Redemption.TestField(Comments);
              Redemption."Redemption Status":=NewStatus;
            end else if NewStatus=NewStatus::"ARM Registrar" then begin
              FundAdministrationSetup.Get;
              if (FundAdministrationSetup."CX Verification Threshold"<>0) and
                 (Redemption.Amount>FundAdministrationSetup."CX Verification Threshold") and
                  (OldStatus=OldStatus::Received) then
                  Redemption."Redemption Status":=Redemption."Redemption Status"::"Customer Experience Verification"
             else
              Redemption."Redemption Status":=NewStatus;

             end else   if NewStatus=NewStatus::"External Registrar"then begin
              Fund.Get(Redemption."Fund Code");
              if Fund."Ext Registrar Verification Req" then
                Redemption."Redemption Status":=NewStatus
              else begin
                if OldStatus=OldStatus::"External Registrar" then
                   if  Redemption."Value Date"<GetFundactivedate(Redemption."Fund Code") then
                        Redemption."Value Date":=GetFundactivedate(Redemption."Fund Code");
                    Redemption."Value Date":=GetFundactivedate(Redemption."Fund Code");;
                Redemption."Redemption Status":=Redemption."Redemption Status"::Verified;
                NewStatus:=NewStatus::Verified;
              end

            end else
              Redemption."Redemption Status":=NewStatus;
              if NewStatus=NewStatus::Rejected then
              Redemption.TestField(Comments)
              else
               Redemption.Validate(Amount);
            Redemption.Select:=false;
            Redemption."Selected By":='';

            Redemption.Modify;
            InsertRedemptionTracker(NewStatus,Redemption."Transaction No");
            //Redemption Email Notification for Batch Request
            if NewStatus=Redemption."Redemption Status"::"ARM Registrar"then begin
                NotificationFunctions.CreateNotificationEntry(0,UserId,CurrentDateTime,'Redemption',Redemption."Transaction No",
              Redemption."Client Name",Redemption."Client ID",Format(NewStatus),Redemption."Fund Code",Redemption."Account No",
          'Redemption',Redemption.Amount,2);
          end else if NewStatus = Redemption."Redemption Status"::"Customer Experience Verification" then begin
                NotificationFunctions.CreateNotificationEntry(0,UserId,CurrentDateTime,'Redemption',Redemption."Transaction No",
              Redemption."Client Name",Redemption."Client ID",Format(NewStatus),Redemption."Fund Code",Redemption."Account No",
          'Redemption',Redemption.Amount,1);
          end else if NewStatus = Redemption."Redemption Status"::Rejected then begin
                NotificationFunctions.CreateNotificationEntry(1,UserId,CurrentDateTime,'Redemption',Redemption."Transaction No",
              Redemption."Client Name",Redemption."Client ID",Format(NewStatus),Redemption."Fund Code",Redemption."Account No",
          'Redemption',Redemption.Amount,3);
        end

          until Redemption.Next=0;
        end
        else
        Error('There is no Record selected by you');


          Message('Records moved successfully');
    end;

    procedure ChangeRedemptionStatusSingle(OldStatus: Option Received,"ARM Registrar","External Registrar",Rejected,Verified,Posted,"Customer Experience Verification";NewStatus: Option Received,"ARM Registrar","External Registrar",Rejected,Verified,Posted,"Customer Experience Verification";Redemption: Record Redemption)
    begin
        if OldStatus=OldStatus::Received then
          if Redemption."Document Link"='' then
            Error('Please attach a document');
        if NewStatus<>NewStatus::Rejected then
          Redemption.TestField(Amount);;
        Redemption.TestField("Account No");
        if not Confirm('Are you sure you want to move this record(s) to the next Stage?') then
          Error('');
            if (NewStatus=NewStatus::Rejected) then begin
              Redemption.TestField(Comments);
              Redemption."Redemption Status":=NewStatus;
            end else if NewStatus=NewStatus::"ARM Registrar" then begin
              FundAdministrationSetup.Get;
              if (FundAdministrationSetup."CX Verification Threshold"<>0) and
                 (Redemption.Amount>FundAdministrationSetup."CX Verification Threshold") and
                  (OldStatus=OldStatus::Received) then
                  Redemption."Redemption Status":=Redemption."Redemption Status"::"Customer Experience Verification"
             else
              Redemption."Redemption Status":=NewStatus;

             end else    if NewStatus=NewStatus::"External Registrar"then begin
                  Fund.Get(Redemption."Fund Code");
                  if Fund."Ext Registrar Verification Req" then
                    Redemption."Redemption Status":=NewStatus
                  else begin
                     if OldStatus=OldStatus::"External Registrar" then
                    if  Redemption."Value Date"<GetFundactivedate(Redemption."Fund Code") then
                        Redemption."Value Date":=GetFundactivedate(Redemption."Fund Code");
                Redemption."Redemption Status":=Redemption."Redemption Status"::Verified;
                NewStatus:=NewStatus::Verified;


                  end;
              end else
              Redemption."Redemption Status":=NewStatus;
            Redemption."Value Date":=GetFundactivedate(Redemption."Fund Code");
            if NewStatus<>NewStatus::Rejected then
            Redemption.Validate("No. Of Units");
            Redemption.Select:=false;
            Redemption."Selected By":='';
            Redemption.Modify;
            InsertRedemptionTracker(NewStatus,Redemption."Transaction No");
            //Redemption Email Notification for Single Request
            if NewStatus=Redemption."Redemption Status"::"ARM Registrar"then begin
                NotificationFunctions.CreateNotificationEntry(0,UserId,CurrentDateTime,'Redemption',Redemption."Transaction No",
              Redemption."Client Name",Redemption."Client ID",Format(NewStatus),Redemption."Fund Code",Redemption."Account No",
          'Redemption',Redemption.Amount,2);
          end else if NewStatus = Redemption."Redemption Status"::"Customer Experience Verification" then begin
                NotificationFunctions.CreateNotificationEntry(0,UserId,CurrentDateTime,'Redemption',Redemption."Transaction No",
              Redemption."Client Name",Redemption."Client ID",Format(NewStatus),Redemption."Fund Code",Redemption."Account No",
          'Redemption',Redemption.Amount,1);
          end else if NewStatus = Redemption."Redemption Status"::Rejected then begin
                NotificationFunctions.CreateNotificationEntry(1,UserId,CurrentDateTime,'Redemption',Redemption."Transaction No",
              Redemption."Client Name",Redemption."Client ID",Format(NewStatus),Redemption."Fund Code",Redemption."Account No",
          'Redemption',Redemption.Amount,3);
        end;

          Message('Record moved successfully');
    end;

    procedure SelectALLRedemption(OldStatus: Option Received,"ARM Registrar","External Registrar",Rejected,Verified,Posted)
    begin
        Redemption.Reset;
        Redemption.SetRange("Redemption Status",OldStatus);
        if  Redemption.FindFirst then begin
          repeat

            Redemption.Validate(Select,true);
            Redemption."Selected By":=UserId;
            Redemption.Modify;
          until Redemption.Next=0;
        end
    end;

    procedure UnSelectALLRedemption(OldStatus: Option Received,"ARM Registrar","External Registrar",Rejected,Verified,Posted)
    begin
        Redemption.Reset;
        Redemption.SetRange("Redemption Status",OldStatus);
        Redemption.SetRange(Select,true);
        //Redemption.SETRANGE("Selected By",USERID);
        if  Redemption.FindFirst then begin
          repeat
            Redemption.Validate(Select,false);
            Redemption."Selected By":='';
            Redemption.Modify;
          until Redemption.Next=0;
        end
    end;

    procedure InsertRedemptionTracker(newstatus: Option Received,"ARM Registrar","External Registrar",Rejected,Verified,Posted;RedemptionNo: Code[50])
    var
        lineno: Integer;
    begin
        if RedemptionTracker2.FindLast then
          lineno:=RedemptionTracker2."Entry No"+1
        else
            lineno:=1;
        RedemptionTracker.Init;
        RedemptionTracker."Entry No":=lineno;
        RedemptionTracker.Redemption:=RedemptionNo;
        RedemptionTracker."Changed By":=UserId;
        RedemptionTracker."Date Time":=CurrentDateTime;
        RedemptionTracker.Status:=newstatus;
        RedemptionTracker.Insert;
    end;

    procedure ViewRedemptionTracker(RedemptionNo: Code[50])
    begin
        Clear(RedemptionTrackers);
        RedemptionTracker.FilterGroup(10);
        RedemptionTracker.SetRange(Redemption,RedemptionNo);
        RedemptionTracker.FilterGroup(0);
        RedemptionTrackers.SetTableView(RedemptionTracker);
        RedemptionTrackers.RunModal;
    end;

    procedure ChangeFundTransferStatusBatch(OldStatus: Option Received,"ARM Registrar","External Registrar",Rejected,Verified,Posted;NewStatus: Option Received,"ARM Registrar","External Registrar",Rejected,Verified,Posted)
    begin
        if not Confirm('Are you sure you want to move this record(s) to the next Stage?') then
          Error('');
        FundTransfer.Reset;
        FundTransfer.SetRange(Select,true);
        FundTransfer.SetRange("Selected By",UserId);
        FundTransfer.SetRange("Fund Transfer Status",OldStatus);
        if  FundTransfer.FindFirst then begin
          repeat
            if NewStatus=NewStatus::Rejected then
              FundTransfer.TestField(Comments);
            //FundTransactionManagement.ValidateFundTransfer(FundTransfer);
           if NewStatus=NewStatus::"External Registrar"then begin
              Fund.Get(FundTransfer."From Fund Code");
              if Fund."Ext Registrar Verification Req" then
                FundTransfer."Fund Transfer Status":=NewStatus
              else
                FundTransfer."Fund Transfer Status":=FundTransfer."Fund Transfer Status"::Verified;
            end else
              FundTransfer."Fund Transfer Status":=NewStatus;
            FundTransfer.Select:=false;
            FundTransfer."Selected By":='';
            FundTransfer.Modify;
            InsertFundTransferTracker(NewStatus,FundTransfer.No);
          if NewStatus=FundTransfer."Fund Transfer Status"::"ARM Registrar" then begin
              NotificationFunctions.CreateNotificationEntry(0,UserId,CurrentDateTime,'Fund Transfer',FundTransfer.No,FundTransfer."From Client ID",
            FundTransfer."To Client ID",Format(NewStatus),FundTransfer."To Fund Code",FundTransfer."To Account No",'Fund Transfer',FundTransfer.Amount,8);
          end else if NewStatus = FundTransfer."Fund Transfer Status"::Rejected then begin
            NotificationFunctions.CreateNotificationEntry(1,UserId,CurrentDateTime,'Fund Transfer',FundTransfer.No,FundTransfer."From Client ID",
            FundTransfer."To Client ID",Format(NewStatus),FundTransfer."To Fund Code",FundTransfer."To Account No",'Fund Transfer',FundTransfer.Amount,9);
          end;

          until FundTransfer.Next=0;
        end
        else
        Error('There is no Record selected by you');
    end;

    procedure ChangeFundTransferStatusSingle(OldStatus: Option Received,"ARM Registrar","External Registrar",Rejected,Verified,Posted;NewStatus: Option Received,"ARM Registrar","External Registrar",Rejected,Verified,Posted;FundTransfer: Record "Fund Transfer")
    begin
        if OldStatus=OldStatus::Received then
          if FundTransfer."Document Link"='' then
            Error('Please attach a document');
        if not Confirm('Are you sure you want to move this record(s) to the next Stage?') then
          Error('');

         if NewStatus=NewStatus::Rejected then
              FundTransfer.TestField(Comments);
         //FundTransactionManagement.ValidateFundTransfer(FundTransfer);
           if NewStatus=NewStatus::"External Registrar"then begin
              Fund.Get(FundTransfer."From Fund Code");
              if Fund."Ext Registrar Verification Req" then
                FundTransfer."Fund Transfer Status":=NewStatus
              else
                FundTransfer."Fund Transfer Status":=FundTransfer."Fund Transfer Status"::Verified;
            end else
              FundTransfer."Fund Transfer Status":=NewStatus;
            FundTransfer.Select:=false;
            FundTransfer."Selected By":='';
            FundTransfer.Modify;
            InsertFundTransferTracker(NewStatus,FundTransfer.No);
            //Unit Transfer Notification for Single Selection
          if NewStatus=FundTransfer."Fund Transfer Status"::"ARM Registrar" then begin
              NotificationFunctions.CreateNotificationEntry(0,UserId,CurrentDateTime,'Fund Transfer',FundTransfer.No,FundTransfer."From Client ID",
            FundTransfer."To Client ID",Format(NewStatus),FundTransfer."To Fund Code",FundTransfer."To Account No",'Fund Transfer',FundTransfer.Amount,8);
          end else if NewStatus = FundTransfer."Fund Transfer Status"::Rejected then begin
            NotificationFunctions.CreateNotificationEntry(1,UserId,CurrentDateTime,'Fund Transfer',FundTransfer.No,FundTransfer."From Client ID",
            FundTransfer."To Client ID",Format(NewStatus),FundTransfer."To Fund Code",FundTransfer."To Account No",'Fund Transfer',FundTransfer.Amount,9);
          end else if NewStatus = FundTransfer."Fund Transfer Status"::Posted then begin
            NotificationFunctions.CreateNotificationEntry(1,UserId,CurrentDateTime,'Fund Transfer',FundTransfer.No,FundTransfer."From Client ID",
            FundTransfer."To Client ID",Format(NewStatus),FundTransfer."To Fund Code",FundTransfer."To Account No",'Fund Transfer',FundTransfer.Amount,10);
          end;
          Message('Record Moved successfully');
    end;

    procedure SelectALLFundTransfer(OldStatus: Option Received,"ARM Registrar","External Registrar",Rejected,Verified,Posted)
    begin
        FundTransfer.Reset;
        FundTransfer.SetRange("Fund Transfer Status",OldStatus);
        if  FundTransfer.FindFirst then begin
          repeat
            FundTransfer.Validate(Select,true);
            FundTransfer."Selected By":=UserId;
            FundTransfer.Modify;
          until FundTransfer.Next=0;
        end
    end;

    procedure UnSelectALLFundTransfer(OldStatus: Option Received,"ARM Registrar","External Registrar",Rejected,Verified,Posted)
    begin
        FundTransfer.Reset;
        FundTransfer.SetRange("Fund Transfer Status",OldStatus);
        FundTransfer.SetRange(Select,true);
        FundTransfer.SetRange("Selected By",UserId);
        if  FundTransfer.FindFirst then begin
          repeat
            FundTransfer.Validate(Select,false);
            FundTransfer."Selected By":='';
            FundTransfer.Modify;
          until FundTransfer.Next=0;
        end
    end;

    procedure InsertFundTransferTracker(newstatus: Option Received,"ARM Registrar","External Registrar",Rejected,Verified,Posted;FundTransferNo: Code[20])
    var
        lineno: Integer;
    begin
        if FundTransferTracker2.FindLast then
          lineno:=FundTransferTracker2."Entry No"+1
        else
            lineno:=1;
        FundTransferTracker.Init;
        FundTransferTracker."Entry No":=lineno;
        FundTransferTracker."Fund Transfer No":=FundTransferNo;
        FundTransferTracker."Changed By":=UserId;
        FundTransferTracker."Date Time":=CurrentDateTime;
        FundTransferTracker.Status:=newstatus;
        FundTransferTracker.Insert;
    end;

    procedure ViewFundTransferTracker(FundTransferNo: Code[20])
    begin
        Clear(FundTransferTrackers);
        FundTransferTracker.FilterGroup(10);
        FundTransferTracker.SetRange("Fund Transfer No",FundTransferNo);
        FundTransferTracker.FilterGroup(0);
        FundTransferTrackers.SetTableView(FundTransferTracker);
        FundTransferTrackers.RunModal;
    end;

    procedure ActivatePrices()
    var
        FundPrices: Record "Fund Prices";
        EODTracker: Record "EOD Tracker";
        Redemption: Record Redemption;
        window: Dialog;
    begin
        if not Confirm('Are you sure you want to Activate the Selected Prices?') then
          Error('');
        FundPrices.Reset;
        FundPrices.SetRange(Select,true);
        FundPrices.SetRange("Selected By",UserId);
        FundPrices.SetRange(Activated,false);
        FundPrices.SetRange("Send for activation",true);
        if FundPrices.FindFirst then
          repeat
            EODTracker.Reset;
            EODTracker.SetRange(Date,CalcDate('-1D',FundPrices."Value Date"));
            if not EODTracker.FindFirst then
              Error('Please Run EOD for %1',CalcDate('-1D',FundPrices."Value Date"));

           FundPrices.TestField("Mid Price");
           FundPrices.TestField("Bid Price");
           FundPrices.TestField("Offer Price");
            FundPrices.Activated:=true;
            FundPrices."Activated By":=UserId;
            FundPrices.Modify;

          until FundPrices.Next=0;
        window.Open('Updating Line No #1#######');

        Redemption.Reset;
        Redemption.SetRange("Redemption Status",Redemption."Redemption Status"::Verified);
        if Redemption.FindFirst then begin
          repeat
            window.Update(1,Redemption."Transaction No");
            Redemption."Value Date":=GetFundactivedate(Redemption."Fund Code");
           Redemption.Validate("No. Of Units");
           Redemption.Modify;

        until Redemption.Next=0;
        end ;
        window.Close;
        Message('Fund prices Activated Successfully');
    end;

    procedure SelectALLPrices()
    var
        FundPrices: Record "Fund Prices";
    begin
        FundPrices.Reset;
        FundPrices.SetRange(Activated,false);
        if  FundPrices.FindFirst then begin
          repeat
            FundPrices.Validate(Select,true);
            FundPrices."Selected By":=UserId;
            FundPrices.Modify;
          until FundPrices.Next=0;
        end
    end;

    procedure UnSelectALPrices()
    begin
        FundPrices.Reset;
        FundPrices.SetRange(Activated,true);
        if  FundPrices.FindFirst then begin
          repeat
            FundPrices.Validate(Select,false);
            FundPrices."Selected By":=UserId;
            FundPrices.Modify;
          until FundPrices.Next=0;
        end
    end;

    procedure GetNAV(Valuedate: Date;Fundcode: Code[30];Noofunits: Decimal): Decimal
    begin
        FundPrices.Reset;
        FundPrices.SetRange("Fund No.",Fundcode);
        FundPrices.SetRange(Activated,true);
        FundPrices.SetFilter("Value Date",'..%1',Valuedate);
        if FundPrices.FindLast then begin
          exit(Noofunits*FundPrices."Bid Price");

        end else
        exit(0);
    end;

    procedure GetFundNAVPrice(FundCode: Code[20];ValueDate: Date): Decimal
    begin
        FundPrices.Reset;
        FundPrices.SetRange("Fund No.",FundCode);
        FundPrices.SetFilter("Value Date",'..%1',ValueDate);
        FundPrices.SetRange(Activated,true);
        if FundPrices.FindLast then begin

             exit(FundPrices."Bid Price")

        end
    end;

    procedure SendPriceforActivation()
    var
        FundPrices: Record "Fund Prices";
    begin
        if not Confirm('Are you sure you want send Selected Prices for activation?') then
          Error('');
        FundPrices.Reset;
        FundPrices.SetRange(Select,true);
        FundPrices.SetRange("Selected By",UserId);
        FundPrices.SetRange(Activated,false);
        FundPrices.SetRange("Send for activation",false);
        if FundPrices.FindFirst then
          repeat
            FundPrices.TestField("Mid Price");
           FundPrices.TestField("Bid Price");
           FundPrices.TestField("Offer Price");

            FundPrices."Send for activation":=true;
            FundPrices."Created By":=UserId;
            FundPrices.Select:=false;
            FundPrices."Selected By":='';
            FundPrices.Modify;

          until FundPrices.Next=0;

        Message('Fund prices sent Successfully');
    end;

    procedure Reject()
    var
        FundPrices: Record "Fund Prices";
    begin
        if not Confirm('Are you sure you want reject this prices?') then
          Error('');
        FundPrices.Reset;
        FundPrices.SetRange(Select,true);
        FundPrices.SetRange("Selected By",UserId);
        FundPrices.SetRange(Activated,false);
        FundPrices.SetRange("Send for activation",true);
        if FundPrices.FindFirst then
          repeat
            FundPrices.Select:=false;
            FundPrices."Selected By":='';
            FundPrices."Send for activation":=false;
            FundPrices.Modify;

          until FundPrices.Next=0;

        Message('Fund prices rejected Successfully');
    end;

    procedure GetFee(Fundcode: Code[30];Amount: Decimal): Decimal
    begin
        FundPayoutCharges.Reset;
        FundPayoutCharges.SetRange("Fund No",Fundcode);
        FundPayoutCharges.SetFilter("Lower Limit",'<=%1',Amount);
        FundPayoutCharges.SetFilter("Upper Limit",'>=%1',Amount);
        if FundPayoutCharges.FindFirst then
          exit(FundPayoutCharges.Fee);
    end;

    procedure GetFundactivedate(FundCode: Code[20]): Date
    begin
        FundPrices.Reset;
        FundPrices.SetRange("Fund No.",FundCode);
        //FundPrices.SETFILTER("Value Date",'..%1',ValueDate);
        FundPrices.SetRange(Activated,true);
        if FundPrices.FindLast then begin
          exit(FundPrices."Value Date")
        end else
        exit(Today);
    end;

    procedure GetBonusNAV(AcctNo: Code[40]): Decimal
    var
        ClientAcct: Record "Client Account";
        ReferredClientNAV: Decimal;
        FundAdmin: Record "Fund Administration Setup";
    begin
        ClientAcct.Reset;
        ClientAcct.SetRange("Account No",AcctNo);
        if ClientAcct.FindFirst then begin
          ClientAcct.CalcFields("No of Units");
          LoyaltySetup.Get(1);
          ReferredClientNAV := GetNAV(Today,ClientAcct."Fund No",ClientAcct."No of Units");
        exit(ReferredClientNAV*(LoyaltySetup."Bonus Rate"/100))

        end
    end;

    procedure CheckBonusValidity(AccountNo: Code[50]): Boolean
    var
        Ref: Record Referral;
        ClientTransacs: Record "Client Transactions";
        InitialDate: Date;
        FinalDate: Date;
        ExceptDividend: Code[50];
    begin
        LoyaltySetup.Get(1) ;
        InitialDate := LoyaltySetup."Initial Date";
        FinalDate := LoyaltySetup."Final Date";
        //ExceptDividend := 'Dividend Reinvest -Q3 2019';

        Ref.Reset;
        Ref.SetRange("Account No",AccountNo);
        if Ref.FindFirst then
          if (Ref."Bonus Status" = Ref."Bonus Status"::Cancelled) or (Ref."Bonus Status" = Ref."Bonus Status"::Subscribed) then
            exit(true)
          else begin
            ClientTransacs.Reset;
            ClientTransacs.SetRange("Account No",AccountNo);
            ClientTransacs.SetFilter("Value Date",'%1..%2',InitialDate,FinalDate);
            ClientTransacs.SetFilter(Narration,'<>Dividend Reinvest -Q3 2019');
            ClientTransacs.SetRange("Transaction Type",ClientTransacs."Transaction Type"::Redemption);
            if ClientTransacs.FindFirst then begin
                Ref.Get(AccountNo);
                Ref."Bonus Status" := Ref."Bonus Status"::Cancelled;
                Ref.SubscriptionDate := CurrentDateTime;
                Ref.Modify;
                exit(true);
            end;
          end else
            exit(false)
    end;

    procedure SubscribeBonusAmount(ReferredAccountNo: Code[50])
    var
        IsAccountValid: Boolean;
        Subscription: Record Subscription;
        Duration: Integer;
        Referrer: Record Referral;
        InitialDate: Date;
        FinalDate: Date;
        ExceptDividend: Code[50];
    begin
        Referrer.Reset;
        IsAccountValid := CheckBonusValidity(ReferredAccountNo);
        if IsAccountValid = false then begin
          ValidBonus := GetBonusNAV(ReferredAccountNo);
          ClientTrans.Reset;
          ClientTrans.SetRange("Account No",ReferredAccountNo);
          if ClientTrans.FindFirst then begin
            //BEGIN MODIFIED
            LoyaltySetup.Get(1) ;
            InitialDate := LoyaltySetup."Initial Date";
            FinalDate := LoyaltySetup."Final Date";
            //ExceptDividend := 'Dividend Reinvest -Q3 2019';

            ClientTrans.SetFilter("Value Date",'%1..%2',InitialDate,FinalDate);
            //ClientTrans.SETFILTER(Narration,'<>%1',ExceptDividend);
            //ClientTrans.SETFILTER(Narration,'<>Dividend Reinvest -Q4 2019');
            ClientTrans.SetFilter("Transaction Sub Type 2",'<>%1',ClientTrans."Transaction Sub Type 2"::"Dividend ReInvestment");
            ClientTrans.SetFilter("Transaction Sub Type 3",'<>%1',ClientTrans."Transaction Sub Type 3"::Dividend);

         //END
            if ClientTrans.FindLast then begin
              Duration :=  Today - (ClientTrans."Value Date");
              ClientAc.Reset;
              ClientAc.Get(ClientTrans."Account No");
              ClientAc.SetFilter("Account No",ClientAc."Account No");
              LoyaltySetup.Get(1);
              if (Duration >= LoyaltySetup.NoOfDays) and (ClientAc."Referrer Membership ID" <> '1128942') and (ValidBonus > 0) then begin
                        //Get Account to Subscribe to
                GetReferrerAccount(ClientAc."Referrer Membership ID");
                //BEGIN MODIFIED
                Referrer.Get(ReferredAccountNo);
                Referrer."Bonus Status" := Referrer."Bonus Status"::Subscribed;
                Referrer.SubscriptionDate := CurrentDateTime;
                Referrer.Modify;
                //END
              end;
            end;
          end;
        end
    end;

    procedure GetReferrerAccount(ReferrerID: Code[50])
    begin
        ClientAc.Reset;
        ClientAc.SetRange("Client ID",ReferrerID);
        if ClientAc.FindFirst then begin
          // Checks if there is price for the Value Date.
          WebService.ValidateValuedateAgainstPrice(Today,ClientAc."Fund No");
            with Subscription do begin
              Init;
              FundAdministrationSetup.Get;
              No := NoSeriesMgt.GetNextNo(FundAdministrationSetup."Subscription Nos",Today,true);
              "Value Date" := Today;
              Validate("Fund Code",ClientAc."Fund No");
              Validate("Account No",ClientAc."Account No");
              Validate("Bank Code",ClientAc."Bank Code");
              Validate(Amount,ValidBonus);
              Subscription."Payment Mode" := Subscription."Payment Mode"::Others;
              Remarks := 'Loyalty Earning.';
              "Transaction Date" := Today;
              "Creation Date" := CurrentDateTime;
              "Created By" := UserId;
              AutoMatched:=true;
              "Subscription Status":="Subscription Status"::Confirmed;
                if Insert then
                  //Post the subscription
                FundTransactionManagement.PostSTPSubscription(Subscription);
            end;
        end else
          Error('This client %1 does not have an account',ReferrerID)
    end;

    procedure RemoveHoldingPeriod()
    var
        IsAccountValid: Boolean;
        Subscription: Record Subscription;
        Duration: Integer;
        Referrer: Record Referral;
        ClientTranx: Record "Client Transactions";
    begin
        ClientTranx.Reset;
        ClientTranx.SetRange("On Hold",true);
        ClientTranx.SetFilter("Holding Due Date", '<=%1', 20230626D);
        if ClientTranx.FindFirst then
          repeat
            ClientTranx."On Hold" := false;
            ClientTranx.Modify(true);
          until ClientTranx.Next = 0;
        /*IF ClientTranx.FINDSET THEN
          ClientTranx.MODIFYALL("On Hold",FALSE,TRUE)*/

    end;

    procedure GetAccruedInterestCharge(FundCode: Code[40];RequestedAmount: Decimal;AcctNo: Code[40];RequestID: Code[50];ValDate: Date): Decimal
    var
        AmountToCharge: Decimal;
        AccruedInterest: Decimal;
        InterestCharged: Decimal;
        ClientAcct: Record "Client Account";
        SettledAmount: Decimal;
        UnsettledAmount: Decimal;
        TotAmount: Decimal;
        TotalInterestCharged: Decimal;
        RemainingAmount: Decimal;
        WithdrawnAmount: Decimal;
        WithdrawnAmountOnHold: Decimal;
        AmountOnHold: Decimal;
        ABSWithdrawnAmount: Decimal;
    begin
        TotAmount := 0;
        TotalInterestCharged := 0;
        ClientAcct.Reset;
        ClientAcct.SetRange("Account No",AcctNo);
        if ClientAcct.FindFirst then begin
          ClientAcct.CalcFields("Total Amount Settled");
          ClientAcct.CalcFields("Total Amount Withdrawn");
          ClientAcct.CalcFields("Total withdrawn Amount On Hold");
          SettledAmount := GetNAV(Today,FundCode,ClientAcct."Total Amount Settled");
          WithdrawnAmount := GetNAV(Today,FundCode,ClientAcct."Total Amount Withdrawn");
          WithdrawnAmountOnHold := GetNAV(Today,FundCode,ClientAcct."Total withdrawn Amount On Hold");
          ABSWithdrawnAmount := Abs(WithdrawnAmount);
          if ABSWithdrawnAmount >= SettledAmount then begin
            TotalInterestCharged := ChargeOnAccruedInterest(RequestedAmount,AcctNo,RequestID, FundCode);
            exit(TotalInterestCharged);
          end else if ABSWithdrawnAmount < SettledAmount then begin
            AmountToCharge := GetUnitToCharge(FundCode,RequestedAmount,AcctNo);
            if AmountToCharge = 0 then begin
              TotalInterestCharged := 0;
              exit(TotalInterestCharged);
            end else begin
              TotalInterestCharged := ChargeOnAccruedInterest(AmountToCharge,AcctNo,RequestID,FundCode);
              exit(TotalInterestCharged);
            end;
          end;
        end;
    end;

    procedure GetAccruedInterest(AccountNo: Code[40];SubscriptionDate: Date;EndDate: Date): Decimal
    var
        SumInterest: Decimal;
        SumUnits: Decimal;
        AmountSubscribed: Decimal;
    begin
        SumInterest := 0;
        SumUnits := 0;
        DailyIncome.Reset;
        DailyIncome.SetRange("Account No",AccountNo);
        DailyIncome.SetRange("Value Date",SubscriptionDate,EndDate);
        if DailyIncome.FindFirst then
          repeat
            SumUnits += DailyIncome."Income Per unit";//Take Note::Should sum income per unit and multiply it by the subscribed amount.
          until DailyIncome.Next = 0;
          exit(SumUnits);
    end;

    procedure GetUnitToCharge("Fund Code": Code[40];RequestedUnits: Decimal;AcctNo: Code[40]): Decimal
    var
        UnitToCharge: Decimal;
        AccruedInterest: Decimal;
        InterestCharged: Decimal;
        ClientAcct: Record "Client Account";
        SettledUnits: Decimal;
        UnsettledAmount: Decimal;
        TotAmount: Decimal;
        TotalInterestCharged: Decimal;
        RemainingAmount: Decimal;
        WithdrawnUnits: Decimal;
        WithdrawnAmountOnHold: Decimal;
        NetUnits: Decimal;
    begin
        ClientAcct.Reset;
        ClientAcct.SetRange("Account No",AcctNo);
        if ClientAcct.FindFirst then begin
          ClientAcct.CalcFields("Total Units Settled");
          ClientAcct.CalcFields("Total Units Withdrawn");
          SettledUnits := ClientAcct."Total Units Settled"; // GetNAV(TODAY,"Fund Code",ClientAcct."Total Units Settled");
          WithdrawnUnits := ClientAcct."Total Units Withdrawn"; //GetNAV(TODAY,"Fund Code",ClientAcct."Total Units Withdrawn");
          NetUnits := (SettledUnits + WithdrawnUnits);
          if NetUnits >= RequestedUnits then begin
            UnitToCharge := 0;
            exit(UnitToCharge);
          end else begin
            UnitToCharge := (RequestedUnits - NetUnits);
            exit(UnitToCharge);
          end;
        end;

    end;

    procedure ChargeOnAccruedInterest(RequestedAmount: Decimal;AcctNo: Code[40];RequestID: Code[50];FundCode: Code[20]): Decimal
    var
        AmountToCharge: Decimal;
        AccruedInterest: Decimal;
        InterestCharged: Decimal;
        ClientAcct: Record "Client Account";
        SettledAmount: Decimal;
        UnsettledAmount: Decimal;
        TotAmount: Decimal;
        TotalInterestCharged: Decimal;
        RemainingAmount: Decimal;
        WithdrawnAmount: Decimal;
        WithdrawnAmountOnHold: Decimal;
        AmountOnHold: Decimal;
        NetAmountOnHold: Decimal;
    begin
        Fund.Reset;
        if Fund.Get(FundCode) then begin
          TotAmount := 0;
          TotalInterestCharged := 0;
          InterestCharged := 0;
          ClientTrans.Reset;
          ClientTrans.SetRange("Account No",AcctNo);
          ClientTrans.SetRange("On Hold",true);
          if ClientTrans.FindFirst then begin
            AmountToCharge := RequestedAmount;
            ClientTrans.CalcFields("Net Amount On Hold");
            ClientTrans.SetFilter("Net Amount On Hold",'>%1',0);
            if AmountToCharge > (ClientTrans."Net Amount On Hold") then begin
              repeat
                TotAmount += ClientTrans."Net Amount On Hold";
                AccruedInterest := GetAccruedInterest(AcctNo,ClientTrans."Value Date",Today);
                HoldingPeriodTracker(Today,ClientTrans."Client ID",ClientTrans."Account No",ClientTrans."Fund Code",-Abs(ClientTrans."Net Amount On Hold"),1,ClientTrans."Entry No",RequestID, false);
                InterestCharged += ClientTrans."Net Amount On Hold"*AccruedInterest*Fund."Percentage Penalty"/100;
                TotalInterestCharged += InterestCharged;
                RemainingAmount := AmountToCharge - ClientTrans."Net Amount On Hold";
                ClientTrans.Next;
                ClientTrans.CalcFields("Net Amount On Hold");
                if RemainingAmount < (ClientTrans."Net Amount On Hold") then begin
                  AccruedInterest := GetAccruedInterest(AcctNo,ClientTrans."Value Date",Today);
                  NetAmountOnHold := ClientTrans."Net Amount On Hold";
                  InterestCharged := RemainingAmount*AccruedInterest*(Fund."Percentage Penalty"/100);
                  HoldingPeriodTracker(Today,ClientTrans."Client ID",ClientTrans."Account No",ClientTrans."Fund Code",-Abs(RemainingAmount),1,ClientTrans."Entry No",RequestID,false);
                  TotalInterestCharged += InterestCharged;
                  TotAmount += RemainingAmount;
                end;
              until TotAmount >= AmountToCharge;
              exit(TotalInterestCharged);
            end else begin
              AccruedInterest := GetAccruedInterest(AcctNo,ClientTrans."Value Date",Today);
              HoldingPeriodTracker(Today,ClientTrans."Client ID",ClientTrans."Account No",ClientTrans."Fund Code",-Abs(AmountToCharge),1,ClientTrans."Entry No",RequestID,false);
              NetAmountOnHold := ClientTrans."Net Amount On Hold";
              InterestCharged := AmountToCharge*AccruedInterest*(Fund."Percentage Penalty"/100);
              TotalInterestCharged += InterestCharged;
              exit(TotalInterestCharged);
            end;
          end;
        end;
    end;

    procedure HoldingPeriodTracker(ValueDate: Date;ClientID: Code[20];ClientAccountNo: Code[40];FundCode: Code[20];Amount: Decimal;TransType: Option Subscription,Redemption;TransactionEntryNo: Integer;RequestID: Code[50];Posted: Boolean)
    var
        HoldingPeriodTransaction: Record "Holding Period Transactions";
        LineNo: Integer;
    begin
        HoldingPeriodTransaction.Reset;
        if TransType = TransType::Redemption then begin
          HoldingPeriodTransaction.SetRange("Request ID",RequestID);
          if HoldingPeriodTransaction.Find('-') then begin
            repeat
              HoldingPeriodTransaction.Amount := Amount;
              HoldingPeriodTransaction.Modify;
            until HoldingPeriodTransaction.Next = 0;
          end else begin
            HoldingPeriodTransaction.Reset;
            if HoldingPeriodTransaction.FindLast then
            LineNo := HoldingPeriodTransaction.No + 1
            else
              LineNo := 1;
            HoldingPeriodTransaction.Init;
            HoldingPeriodTransaction.No := LineNo;
            HoldingPeriodTransaction."Value Date" := ValueDate;
            HoldingPeriodTransaction."Client ID" := ClientID;
            HoldingPeriodTransaction."Client Account No" := ClientAccountNo;
            HoldingPeriodTransaction."Fund Code" := FundCode;
            HoldingPeriodTransaction.Amount := Amount;
            HoldingPeriodTransaction."Transaction Type" := TransType;
            HoldingPeriodTransaction."Transac Entry No" := TransactionEntryNo;
            HoldingPeriodTransaction."Request ID" := RequestID;
            HoldingPeriodTransaction.Posted := Posted;
            HoldingPeriodTransaction.Insert;
          end;
        end else begin
          HoldingPeriodTransaction.Reset;
          if HoldingPeriodTransaction.FindLast then
            LineNo := HoldingPeriodTransaction.No + 1
          else
            LineNo := 1;
          HoldingPeriodTransaction.Init;
          HoldingPeriodTransaction.No := LineNo;
          HoldingPeriodTransaction."Value Date" := ValueDate;
          HoldingPeriodTransaction."Client ID" := ClientID;
          HoldingPeriodTransaction."Client Account No" := ClientAccountNo;
          HoldingPeriodTransaction."Fund Code" := FundCode;
          HoldingPeriodTransaction.Amount := Amount;
          HoldingPeriodTransaction."Transaction Type" := TransType;
          HoldingPeriodTransaction."Transac Entry No" := TransactionEntryNo;
          HoldingPeriodTransaction."Request ID" := RequestID;
          HoldingPeriodTransaction.Posted := Posted;
          HoldingPeriodTransaction.Insert;
        end
    end;

    procedure PostHoldingPeriodTrans(ValueDate: Date;ClientID: Code[20];ClientAccountNo: Code[40];RequestID: Code[50])
    var
        HoldingPeriodTransaction: Record "Holding Period Transactions";
        LineNo: Integer;
    begin
        HoldingPeriodTransaction.Reset;
        //HoldingPeriodTransaction.SETRANGE("Value Date",ValueDate);
        HoldingPeriodTransaction.SetRange("Client Account No",ClientAccountNo);
        HoldingPeriodTransaction.SetRange("Transaction Type",HoldingPeriodTransaction."Transaction Type"::Redemption);
        HoldingPeriodTransaction.SetRange("Request ID",RequestID);
        if HoldingPeriodTransaction.FindSet then
          HoldingPeriodTransaction.ModifyAll(Posted,true,true);
    end;

    procedure ChangeBulkFundTransferStatusBatch(Rec: Record "Fund Transfer Header")
    var
        FundTransferHeader2: Record "Fund Transfer Header";
    begin
        if not Confirm('Are you sure you want to move this record(s) to the next Stage?') then
          Error('');
        FundTransferLines.Reset;
        FundTransferLines.SetRange("Header No",Rec.No);
        if  FundTransferLines.FindFirst then begin
          repeat
          FundTransferLines."Fund Transfer Status" := FundTransferLines."Fund Transfer Status"::"ARM Registrar";
            FundAdministrationSetup.Get;
            FundTransferLines.No := NoSeriesMgt.GetNextNo(FundAdministrationSetup."Fund Transfer Nos",Today,true);
            FundTransferLines."Document Link" := Rec."Document Link";
            FundTransferLines.Modify(true);
            InsertFundTransferTracker(FundTransferLines."Fund Transfer Status",FundTransfer.No);
            FundTransactionManagement.MovetoFundTransfers(FundTransferLines);
          until FundTransferLines.Next=0;
        end;
        FundTransferHeader2.Reset;
        FundTransferHeader2.SetRange("Fund Transfer Status",Rec."Fund Transfer Status");
        if FundTransferHeader2.FindFirst then
          FundTransferHeader2."Fund Transfer Status" := FundTransferHeader2."Fund Transfer Status"::"ARM Registrar";
        FundTransferHeader2."Date Sent to Reg" := CurrentDateTime;
        FundTransferHeader2.Modify(true);
        Message('Records Moved Successfully');
    end;

    procedure GetMFReinvestBidPrice(FundCode: Code[20];ValueDate: Date;TransactionType: Option Subscription,Redemption,Dividend): Decimal
    begin
        FundPrices.Reset;
        FundPrices.SetRange("Fund No.",FundCode);
        FundPrices.SetFilter("Value Date",'..%1',ValueDate);
        FundPrices.SetRange(Activated,true);
        if FundPrices.FindLast then begin
          FundPrices.TestField("Mid Price");
          FundPrices.TestField("Bid Price");
          FundPrices.TestField("Offer Price");
          exit(Round(FundPrices."Bid Price",0.0001,'='))
        end else
        Error('There is no Price For %1 Fund,Value Date %2 . Kindly Ensure that all Prices Have been Updated',FundCode,ValueDate);
    end;

    procedure GetMutualFundPenaltyCharge("Fund Code": Code[40];RequestedUnits: Decimal;AcctNo: Code[40];RequestID: Code[50];ValueDate: Date): Decimal
    var
        ClientUnitInHolding: Decimal;
        MutualFund: Record Fund;
        ClientTransaction: Record "Client Transactions";
        UnitsRemaining: Decimal;
        UnitCharged: Decimal;
        CurrentFundPrice: Decimal;
        TotalUnits: Decimal;
        AmountCharged: Decimal;
        UnitsOnHold: Decimal;
        ClientAccount: Record "Client Account";
    begin
        ClientAccount.Reset;
        ClientAccount.SetRange("Account No", AcctNo);
        if ClientAccount.FindFirst and ClientAccount.Goals then
          exit(0);

        AmountCharged := 0;
        UnitsRemaining := 0;
        TotalUnits := 0;
        UnitsOnHold := 0;
        CurrentFundPrice := GetFundPrice("Fund Code",ValueDate,0);
        MutualFund.Reset;
        if MutualFund.Get("Fund Code") then begin
          if "Fund Code" = 'ARMMMF' then begin
            AmountCharged := GetAccruedInterestCharge("Fund Code",RequestedUnits,AcctNo,RequestID, ValueDate);
            exit(AmountCharged);
          end else if MutualFund."Percentage Penalty" > 0 then
            ClientUnitInHolding := GetUnitToCharge("Fund Code",RequestedUnits,AcctNo);
            if ClientUnitInHolding > 0 then begin
              ClientTransaction.Reset;
              ClientTransaction.SetRange("Account No",AcctNo);
              ClientTransaction.SetRange("On Hold", true);
              if ClientTransaction.FindFirst then begin
                if ClientUnitInHolding > ClientTransaction."No of Units" then begin
                  repeat
                    TotalUnits += ClientTransaction."No of Units";
                    if CurrentFundPrice > ClientTransaction."Price Per Unit" then begin
                      UnitsOnHold := ClientTransaction."No of Units";
                      AmountCharged += Abs(CurrentFundPrice - ClientTransaction."Price Per Unit") * ClientTransaction."No of Units" * MutualFund."Percentage Penalty"/100;
                      UnitsRemaining := ClientUnitInHolding - ClientTransaction."No of Units";
                      HoldingPeriodTracker(Today,ClientTransaction."Client ID",ClientTransaction."Account No",ClientTransaction."Fund Code",-Abs(GetNAV(ValueDate,MutualFund."Fund Code",UnitsOnHold)),1,ClientTransaction."Entry No",RequestID,false);
                    end else begin
                      UnitsOnHold := ClientTransaction."No of Units";
                      UnitsRemaining := ClientUnitInHolding - ClientTransaction."No of Units";
                      HoldingPeriodTracker(Today,ClientTransaction."Client ID",ClientTransaction."Account No",ClientTransaction."Fund Code",-Abs(GetNAV(ValueDate,MutualFund."Fund Code",UnitsOnHold)),1,ClientTransaction."Entry No",RequestID,false);
                    end;
                    ClientTransaction.Next;
                    if UnitsRemaining < ClientTransaction."No of Units" then begin
                      AmountCharged += Abs(CurrentFundPrice - ClientTransaction."Price Per Unit") * ClientTransaction."No of Units" * MutualFund."Percentage Penalty"/100;
                      HoldingPeriodTracker(Today,ClientTransaction."Client ID",ClientTransaction."Account No",ClientTransaction."Fund Code",-Abs(GetNAV(ValueDate,MutualFund."Fund Code",UnitsRemaining)),1,ClientTransaction."Entry No",RequestID,false);
                      TotalUnits += UnitsRemaining;
                    end;
                  until TotalUnits >= ClientUnitInHolding;
                  if AmountCharged > 0 then
                    exit(AmountCharged)
                  else
                    exit(0);
                end else begin
                   AmountCharged += Abs(CurrentFundPrice - ClientTransaction."Price Per Unit") * ClientUnitInHolding * MutualFund."Percentage Penalty"/100;
                   if AmountCharged > 0 then begin
                     HoldingPeriodTracker(Today,ClientTransaction."Client ID",ClientTransaction."Account No",ClientTransaction."Fund Code",-Abs(GetNAV(ValueDate,MutualFund."Fund Code",ClientUnitInHolding)),1,ClientTransaction."Entry No",RequestID,false);
                     exit(AmountCharged);
                   end else
                    exit(0);
                end;
              end;
            end else begin
              AmountCharged := 0;
              exit(AmountCharged);
            end;
        end;
    end;

    procedure GetAccuredIncome(AccountNo: Code[20];FundCode: Code[20]): Decimal
    var
        Quarters: Record Quarters;
        DailyDistribIncome: Record "Daily Income Distrib Lines";
        CurrentQuarter: Code[20];
    begin
        Quarters.Reset;
        Quarters.SetRange(Closed,false);
        if Quarters.FindFirst then
          CurrentQuarter := Quarters.Code;

        DailyDistribIncome.Reset;
        DailyDistribIncome.SetRange("Fund Code", FundCode);
        DailyDistribIncome.SetRange("Account No", AccountNo);
        DailyDistribIncome.SetRange("Fully Paid", false);
        DailyDistribIncome.SetRange(Quarter, CurrentQuarter);
        if DailyDistribIncome.FindFirst then
          DailyDistribIncome.CalcSums("Income accrued");

        exit(DailyDistribIncome."Income accrued");
    end;

    procedure GetTotalAmountInvested(AccountNo: Code[20];StartDate: Date;EndDate: Date): Decimal
    var
        ClientTranx: Record "Client Transactions";
    begin
        if StartDate = 0D then begin
          ClientTranx.Reset;
          ClientTranx.SetRange("Account No",AccountNo);
          ClientTranx.SetCurrentKey("Value Date");
            ClientTranx.Ascending(true);
            if ClientTranx.FindFirst then
              StartDate:=ClientTranx."Value Date";
        end;
        if EndDate = 0D then
          EndDate := Today;

        ClientTranx.Reset;
        ClientTranx.SetRange("Account No",AccountNo);
        if (StartDate <> 0D) and (EndDate <>0D) then begin
          ClientTranx.SetFilter("Value Date", '%1..%2',StartDate, EndDate);
          ClientTranx.SetRange("Transaction Type", ClientTranx."Transaction Type"::Subscription);
          if ClientTranx.FindFirst then begin
            ClientTranx.CalcSums(Amount);
            exit(ClientTranx.Amount);
          end;
        end
    end;

    procedure GetTotalAmountWithdrawn(AccountNo: Code[20];StartDate: Date;EndDate: Date): Decimal
    var
        ClientTransa: Record "Client Transactions";
    begin
        if StartDate = 0D then begin
          ClientTrans.Reset;
          ClientTrans.SetRange("Account No",AccountNo);
          ClientTrans.SetCurrentKey("Value Date");
            ClientTrans.Ascending(true);
            if ClientTrans.FindFirst then
              StartDate:=ClientTrans."Value Date";
        end;
        if EndDate = 0D then
          EndDate := Today;

        ClientTrans.Reset;
        ClientTrans.SetRange("Account No",AccountNo);
        if (StartDate <> 0D) and (EndDate <>0D) then begin
          ClientTrans.SetFilter("Value Date", '%1..%2',StartDate, EndDate);
          ClientTrans.SetFilter("Transaction Type", '%1|%2', ClientTrans."Transaction Type"::Redemption, ClientTrans."Transaction Type"::Fee);
          if ClientTrans.FindFirst then begin
            ClientTrans.CalcSums(Amount);
            exit(ClientTrans.Amount);
          end;
        end
    end;
}

