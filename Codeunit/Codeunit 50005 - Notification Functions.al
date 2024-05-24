codeunit 50005 "Notification Functions"
{
    // version NAVW19.00

    Permissions = TableData "Overdue Approval Entry"=i,
                  TableData TableData1510=r,
                  TableData "Notification Entry"=rimd;

    trigger OnRun()
    var
        UserSetup: Record "User Setup";
        UserIDsbyNotificationType: Query "User IDs by Notification Type";
    begin
        CreateNotificationEntry(0,UserId,CurrentDateTime,'Test Request','RQ979797','new request from client','1003105','Received','ARMMMF','1003105-ARMMMF-01',
        'New Redemption',760000.0,3)
    end;

    var
        SoftwareNameTxt: Label 'Microsoft Dynamics NAV', Locked=true;
        TitleWorkflowNotificationEngineTxt: Label 'Workflow Notification Engine';
        TitleApprovalSystemTxt: Label 'Microsoft Dynamics NAV Approval System';
        RTCHyperlinkTxt: Label 'To view the record in the Windows client, choose this link';
        WebHyperlinkTxt: Label 'Web client';
        PurchDocTypeTxt: Label 'Purchase %1', Comment='%1 = Document No.';
        SalesDocTypeTxt: Label 'Sales %1', Comment='%1 = Document No.';
        CustomerTypeTxt: Label 'Customer %1', Comment='%1 = Customer No.';
        ActionApproveTxt: Label 'requires your approval.';
        ActionApprovedTxt: Label 'has been approved.';
        ActionCreateTxt: Label 'has been created.';
        ActionCancelTxt: Label 'has been canceled.';
        ActionRejectTxt: Label 'has been rejected.';
        ActionOverdueTxt: Label 'has a pending approval with due date %1.', Comment='%1 = date when document was due.';
        ActionNoTxt: Label 'No action is required for %1.', Comment='%1 = Document identifier such as ''Sales Invoice 1002''';
        CustomUrlAndAnchorTxt: Label '(<a href="%1">other client</a>)', Comment='Translate only "Other link". The rest needs to stay the same. Eg. (<a href="http://dynamics.sharepoint.com/">Other link</a>)';
        AdditionalHtmlLineTxt: Label '<p><span style="font-size: 11.0pt; font-family: Calibri">%1</span></p>', Locked=true;
        CommentsHdrTxt: Label 'Comments:';
        PageManagement: Codeunit "Page Management";
        LinkNotAvailableTxt: Label 'There is no link for this notification entry, because the related record no longer exists.';
        ClientLinksTok: Label '<a href="%1">%2</a> (<a href="%3">%4</a>)', Locked=true;
        OverdueEntriesMsg: Label 'Overdue approval entries have been created.';
        NotificationMailSubjectTxt: Label 'Microsoft Dynamics NAV Notification ';
        SMTPSetupErr: Label 'The SMTP Setup does not exist.';

    procedure CreateOverdueNotifications(WorkflowStepArgument: Record "Workflow Step Argument")
    var
        UserSetup: Record "User Setup";
        ApprovalEntry: Record "Approval Entry";
        NotificationEntry: Record "Notification Entry";
    begin
        if UserSetup.FindSet then
          repeat
            ApprovalEntry.Reset;
            ApprovalEntry.SetRange("Approver ID",UserSetup."User ID");
            ApprovalEntry.SetRange(Status,ApprovalEntry.Status::Open);
            ApprovalEntry.SetFilter("Due Date",'<=%1',Today);
            if ApprovalEntry.FindSet then
              repeat
                NotificationEntry.CreateNew(NotificationEntry.Type::Overdue,
                  UserSetup."User ID",ApprovalEntry,WorkflowStepArgument."Link Target Page",
                  WorkflowStepArgument."Custom Link");
                InsertOverdueEntry(ApprovalEntry);
              until ApprovalEntry.Next = 0;
          until UserSetup.Next = 0;

        Message(OverdueEntriesMsg);
    end;

    procedure PopulateNotificationTemplateWithRecIndependentInfo(var NotificationBody: Text;NotificationEntry: Record "Notification Entries")
    var
        NotificationSetup: Record "Notification Setup";
        DataTypeManagement: Codeunit "Data Type Management";
        RecRef: RecordRef;
        NotificationBodyString: DotNet String;
        PageID: Integer;
    begin
        NotificationSetup.Init;
        NotificationSetup.SetRange("User ID",NotificationEntry."Created By");
        DataTypeManagement.GetRecordRef(NotificationSetup,RecRef);
        PageID := PageManagement.GetPageID(RecRef);

        NotificationBodyString := NotificationBodyString.Copy(NotificationBody);

        NotificationBodyString := NotificationBodyString.Replace('%SoftwareName%',SoftwareNameTxt);
        case NotificationEntry.Type of
          NotificationEntry.Type::Update,
          NotificationEntry.Type::Overdue:
            NotificationBodyString := NotificationBodyString.Replace('%Title%',TitleApprovalSystemTxt);
          else
            NotificationBodyString := NotificationBodyString.Replace('%Title%',TitleWorkflowNotificationEngineTxt);
        end;
        NotificationBodyString := NotificationBodyString.Replace(
            '%RTCChangeSettingsHyperLink%',GetUrl(CLIENTTYPE::Windows,CompanyName,OBJECTTYPE::Page,PageID,RecRef,true));
        NotificationBodyString := NotificationBodyString.Replace(
            '%WebChangeSettingsHyperLink%',GetUrl(CLIENTTYPE::Web,CompanyName,OBJECTTYPE::Page,PageID,RecRef,true));

        NotificationBody := NotificationBodyString.ToString;
    end;

    procedure PopulateNotificationTemplateWithRecordInfo(var NotificationBody: Text;NotificationEntry: Record "Notification Entries")
    var
        DataTypeManagement: Codeunit "Data Type Management";
        RecRef: RecordRef;
        NotificationBodyString: DotNet String;
        ClientLinks: Text;
        Client: Record Client;
        ClientAccount: Record "Client Account";
        AccountManager: Record "Account Manager";
    begin
        if Client.Get(NotificationEntry."Client ID") then ;
        if ClientAccount.Get(NotificationEntry."Client Account") then;
        if AccountManager.Get(Client."Account Executive Code") then;
        NotificationBodyString := NotificationBodyString.Copy(NotificationBody);
        NotificationBodyString := NotificationBodyString.Replace('@Date',Format(NotificationEntry."Created Date-Time"));
        NotificationBodyString := NotificationBodyString.Replace('@LoggedBy',NotificationEntry."Created By");
        NotificationBodyString := NotificationBodyString.Replace('@RequestType',NotificationEntry."Instruction Type");
        NotificationBodyString := NotificationBodyString.Replace('@RequestID',NotificationEntry."Transaction No");
        NotificationBodyString := NotificationBodyString.Replace('@ClientName',Client.Name);
        NotificationBodyString := NotificationBodyString.Replace('@relationshipManager',AccountManager."First Name"+ ' '+ AccountManager.Surname);
        NotificationBodyString := NotificationBodyString.Replace('@ReferenceCode',NotificationEntry."Client Account");
        NotificationBodyString := NotificationBodyString.Replace('@Status',NotificationEntry.Status);
        NotificationBodyString := NotificationBodyString.Replace('@IsInstrucByMail','');
        NotificationBodyString := NotificationBodyString.Replace('@Description','');
        NotificationBodyString := NotificationBodyString.Replace('@Appfee','');
        NotificationBodyString := NotificationBodyString.Replace('@ProductName',NotificationEntry."Product Name");
        NotificationBodyString := NotificationBodyString.Replace('@Amount',Format(NotificationEntry.Amount));
        NotificationBodyString := NotificationBodyString.Replace('@ClientAccountName','');
        NotificationBodyString := NotificationBodyString.Replace('@ClientAccountNumber','');
        NotificationBodyString := NotificationBodyString.Replace('@ClientBankName','');
        NotificationBodyString := NotificationBodyString.Replace('@BankSortCode','');
        NotificationBodyString := NotificationBodyString.Replace('@ClientChequeName','');

        NotificationBody := NotificationBodyString.ToString;
    end;

    local procedure ReplaceTokensWithRecInfo(var NotificationBody: DotNet String;RecRef: RecordRef)
    begin
        // Special Mappings
        case RecRef.Number of
          DATABASE::"Incoming Document":
            begin
              NotificationBody := NotificationBody.Replace('%DocumentType%',Format(RecRef.Caption));
              SetTokenToValueOfField(NotificationBody,'%DocumentNo%',RecRef,'Entry No.');
            end;
          DATABASE::Customer:
            begin
              NotificationBody := NotificationBody.Replace('%DocumentType%',Format(RecRef.Caption));
              SetTokenToValueOfField(NotificationBody,'%DocumentNo%',RecRef,'No.');
              NotificationBody := NotificationBody.Replace('%CustomerVendorCaption%',Format(RecRef.Caption));
              SetTokenToValueOfField(NotificationBody,'%CustomerVendorNo%',RecRef,'No.');
              SetTokenToValueOfField(NotificationBody,'%CustomerVendorName%',RecRef,'Name');
              NotificationBody := NotificationBody.Replace('%CurrencyCode%','');
            end;
          DATABASE::"Approval Entry":
            begin
              NotificationBody := NotificationBody.Replace('%DocumentType%','');
              SetTokenToValueOfField(NotificationBody,'%DocumentNo%',RecRef,'Record ID to Approve');
            end;
          else begin
            NotificationBody := NotificationBody.Replace('%DocumentType%','');
            NotificationBody := NotificationBody.Replace('%DocumentNo%',Format(RecRef.RecordId));
          end;
        end;

        // Generic Mappings
        SetTokenToCaptionOfField(NotificationBody,'%AmountCaption%',RecRef,'Amount');
        SetTokenToValueOfField(NotificationBody,'%Amount%',RecRef,'Amount');

        SetTokenToValueOfField(NotificationBody,'%CurrencyCode%',RecRef,'Currency Code');

        SetTokenToCaptionOfField(NotificationBody,'%AmountLCYCaption%',RecRef,'Amount (LCY)');
        SetTokenToValueOfField(NotificationBody,'%AmountLCY%',RecRef,'Amount (LCY)');

        SetTokenToCaptionOfField(NotificationBody,'%DueDateCaption%',RecRef,'Due Date');
        SetTokenToValueOfField(NotificationBody,'%DueDate%',RecRef,'Due Date');

        NotificationBody := NotificationBody.Replace('%CustomerVendorCaption%','');
        NotificationBody := NotificationBody.Replace('%CustomerVendorNo%','');
        NotificationBody := NotificationBody.Replace('%CustomerVendorName%','');
    end;

    local procedure ReplaceTokensWithApprovalInfo(var NotificationBody: DotNet String;RecRef: RecordRef;NotificationType: Option "New Record",Approval,Overdue)
    var
        Customer: Record Customer;
        Vendor: Record Vendor;
        ApprovalEntry: Record "Approval Entry";
        CustVendorNo: Code[20];
        CustVendorName: Text[50];
        HtmlCommentLines: Text;
    begin
        RecRef.SetTable(ApprovalEntry);

        HtmlCommentLines := GetApprovalCommentLines(ApprovalEntry);

        case NotificationType of
          NotificationType::Approval:
            case ApprovalEntry.Status of
              ApprovalEntry.Status::Open:
                NotificationBody := NotificationBody.Replace('%Action%',ActionApproveTxt);
              ApprovalEntry.Status::Canceled:
                NotificationBody := NotificationBody.Replace('%Action%',ActionCancelTxt);
              ApprovalEntry.Status::Rejected:
                NotificationBody := NotificationBody.Replace('%Action%',ActionRejectTxt);
              ApprovalEntry.Status::Created:
                NotificationBody := NotificationBody.Replace('%Action%',ActionCreateTxt);
              ApprovalEntry.Status::Approved:
                NotificationBody := NotificationBody.Replace('%Action%',ActionApprovedTxt);
            end;
          NotificationType::Overdue:
            NotificationBody := NotificationBody.Replace('%Action%',StrSubstNo(ActionOverdueTxt,Format(ApprovalEntry."Due Date",10)));
        end;

        case ApprovalEntry."Limit Type" of
          ApprovalEntry."Limit Type"::"Request Limits":
            begin
              NotificationBody := NotificationBody.Replace('%CreditLimitCaption%',Format(ApprovalEntry.FieldCaption("Amount (LCY)")));
              NotificationBody := NotificationBody.Replace('%CreditLimit%',Format(ApprovalEntry."Amount (LCY)"));
            end;
          ApprovalEntry."Limit Type"::"Credit Limits":
            begin
              NotificationBody :=
                NotificationBody.Replace('%CreditLimitCaption%',ApprovalEntry.FieldCaption("Available Credit Limit (LCY)"));
              NotificationBody := NotificationBody.Replace('%CreditLimit%',Format(ApprovalEntry."Available Credit Limit (LCY)"));
            end;
          else begin
            NotificationBody := NotificationBody.Replace('%CreditLimitCaption%',' ');
            NotificationBody := NotificationBody.Replace('%CreditLimit%',' ');
          end;
        end;

        ApprovalEntry.GetCustVendorDetails(CustVendorNo,CustVendorName);
        NotificationBody := NotificationBody.Replace('%CustomerVendorNo%',CustVendorNo);
        NotificationBody := NotificationBody.Replace('%CustomerVendorName%',CustVendorName);
        NotificationBody := NotificationBody.Replace('%Details%',ApprovalEntry.GetChangeRecordDetails);

        case ApprovalEntry."Table ID" of
          DATABASE::"Purchase Header":
            begin
              NotificationBody := NotificationBody.Replace('%CustomerVendorCaption%',Vendor.TableCaption);
              NotificationBody := NotificationBody.Replace('%DocumentType%',StrSubstNo(PurchDocTypeTxt,ApprovalEntry."Document Type"));
              NotificationBody := NotificationBody.Replace('%DocumentNo%',ApprovalEntry."Document No.");
            end;
          DATABASE::"Sales Header":
            begin
              NotificationBody := NotificationBody.Replace('%CustomerVendorCaption%',Customer.TableCaption);
              NotificationBody := NotificationBody.Replace('%DocumentType%',StrSubstNo(SalesDocTypeTxt,ApprovalEntry."Document Type"));
              NotificationBody := NotificationBody.Replace('%DocumentNo%',ApprovalEntry."Document No.");
            end;
          DATABASE::Customer:
            begin
              Customer.Get(ApprovalEntry."Record ID to Approve");
              NotificationBody := NotificationBody.Replace('%CustomerVendorCaption%',Customer.TableCaption);
              NotificationBody := NotificationBody.Replace('%DocumentNo%','');
              NotificationBody := NotificationBody.Replace('%DocumentType%',StrSubstNo(CustomerTypeTxt,Customer."No."));
              NotificationBody := NotificationBody.Replace('%CurrencyCode%','');
            end;
          DATABASE::"Gen. Journal Line":
            begin
              NotificationBody := NotificationBody.Replace('%DocumentType%','');
              NotificationBody := NotificationBody.Replace('%DocumentNo%',Format(ApprovalEntry."Record ID to Approve"));
            end;
          DATABASE::"Gen. Journal Batch":
            begin
              NotificationBody := NotificationBody.Replace('%DocumentType%','');
              NotificationBody := NotificationBody.Replace('%DocumentNo%',Format(ApprovalEntry."Record ID to Approve"));
            end;
        end;

        NotificationBody := NotificationBody.Replace('%ApprovalComments%',HtmlCommentLines);
    end;

    local procedure ReplaceTokensWithBlanks(var NotificationBody: DotNet String;RecordIdentifier: Text)
    begin
        NotificationBody := NotificationBody.Replace('%DocumentType%','');
        NotificationBody := NotificationBody.Replace('%DocumentNo%','');
        NotificationBody := NotificationBody.Replace('%Action%',StrSubstNo(ActionNoTxt,RecordIdentifier));
        NotificationBody := NotificationBody.Replace('%Details%','');

        NotificationBody := NotificationBody.Replace('%AmountCaption%','');
        NotificationBody := NotificationBody.Replace('%CurrencyCode%','');
        NotificationBody := NotificationBody.Replace('%Amount%','');

        NotificationBody := NotificationBody.Replace('%AmountLCY%','');
        NotificationBody := NotificationBody.Replace('%AmountLCYCaption%','');

        NotificationBody := NotificationBody.Replace('%CustomerVendorCaption%','');
        NotificationBody := NotificationBody.Replace('%CustomerVendorNo%','');
        NotificationBody := NotificationBody.Replace('%CustomerVendorName%','');

        NotificationBody := NotificationBody.Replace('%DueDateCaption%','');
        NotificationBody := NotificationBody.Replace('%DueDate%','');

        NotificationBody := NotificationBody.Replace('%CreditLimit%','');
        NotificationBody := NotificationBody.Replace('%CreditLimitCaption%','');
        NotificationBody := NotificationBody.Replace('%ApprovalComments%','');
    end;

    local procedure SetTokenToValueOfField(var NotificationBody: DotNet String;Token: Text;RecRef: RecordRef;FieldName: Text)
    var
        "Field": Record "Field";
        FieldRef: FieldRef;
        FieldValue: Text;
    begin
        Field.SetRange(TableNo,RecRef.Number);
        Field.SetRange(FieldName,FieldName);
        if Field.FindFirst then begin
          FieldRef := RecRef.Field(Field."No.");
          if Field.Type = Field.Type::Decimal then
            FieldValue := Format(FieldRef.Value,0,'<Precision,2:2><Standard Format,0>')
          else
            FieldValue := Format(FieldRef.Value);
        end;
        NotificationBody := NotificationBody.Replace(Token,FieldValue);
    end;

    local procedure SetTokenToCaptionOfField(var NotificationBody: DotNet String;Token: Text;RecRef: RecordRef;FieldName: Text)
    var
        "Field": Record "Field";
        FieldRef: FieldRef;
        FieldValue: Text;
    begin
        Field.SetRange(TableNo,RecRef.Number);
        Field.SetRange(FieldName,FieldName);
        if Field.FindFirst then begin
          FieldRef := RecRef.Field(Field."No.");
          FieldValue := Format(FieldRef.Caption);
        end;
        NotificationBody := NotificationBody.Replace(Token,FieldValue);
    end;

    local procedure GetCustomUrlAndAnchor(CustomURL: Text): Text
    begin
        if CustomURL <> '' then
          exit(StrSubstNo(CustomUrlAndAnchorTxt,CustomURL));
        exit('');
    end;

    local procedure GetApprovalCommentLines(ApprovalEntry: Record "Approval Entry") HTMLApprovalComments: Text
    var
        ApprovalCommentLine: Record "Approval Comment Line";
    begin
        ApprovalEntry.CalcFields(Comment);
        if not ApprovalEntry.Comment then
          exit;

        ApprovalCommentLine.SetRange("Table ID",ApprovalEntry."Table ID");
        ApprovalCommentLine.SetRange("Record ID to Approve",ApprovalEntry."Record ID to Approve");
        if ApprovalCommentLine.FindSet then begin
          HTMLApprovalComments := StrSubstNo(AdditionalHtmlLineTxt,CommentsHdrTxt);
          repeat
            HTMLApprovalComments += StrSubstNo(AdditionalHtmlLineTxt,ApprovalCommentLine.Comment);
          until ApprovalCommentLine.Next = 0;
        end;
    end;

    local procedure InsertOverdueEntry(ApprovalEntry: Record "Approval Entry")
    var
        User: Record User;
        OverdueApprovalEntry: Record "Overdue Approval Entry";
        UserSetup: Record "User Setup";
    begin
        with OverdueApprovalEntry do begin
          Init;
          "Approver ID" := ApprovalEntry."Approver ID";
          User.SetRange("User Name",ApprovalEntry."Approver ID");
          if User.FindFirst then begin
            "Sent to Name" := CopyStr(User."Full Name",1,MaxStrLen("Sent to Name"));
            UserSetup.Get(User."User Name");
          end;

          "Table ID" := ApprovalEntry."Table ID";
          "Document Type" := ApprovalEntry."Document Type";
          "Document No." := ApprovalEntry."Document No.";
          "Sent to ID" := ApprovalEntry."Approver ID";
          "Sent Date" := Today;
          "Sent Time" := Time;
          "E-Mail" := UserSetup."E-Mail";
          "Sequence No." := ApprovalEntry."Sequence No.";
          "Due Date" := ApprovalEntry."Due Date";
          "Approval Code" := ApprovalEntry."Approval Code";
          "Approval Type" := ApprovalEntry."Approval Type";
          "Limit Type" := ApprovalEntry."Limit Type";
          "Record ID to Approve" := ApprovalEntry."Record ID to Approve";
          Insert;
        end;
    end;

    procedure CreateDefaultNotificationTemplate(var NotificationTemplate: Record "Notification Template";NotificationType: Option)
    begin
        NotificationTemplate.SetRange(Type,NotificationType);
        NotificationTemplate.SetRange(Default,true);
        if NotificationTemplate.FindFirst then
          exit;

        NotificationTemplate.CreateNewDefault(NotificationType);
    end;

    procedure CreateDefaultNotificationSetup(NotificationType: Option)
    var
        NotificationSetup: Record "Notification Setup";
        NotificationTemplate: Record "Notification Template";
    begin
        if DefaultNotificationEntryExists(NotificationType) then
          exit;

        CreateDefaultNotificationTemplate(NotificationTemplate,NotificationType);

        NotificationSetup.Init;
        NotificationSetup."User ID" := '';
        NotificationSetup.Validate("Notification Type",NotificationType);
        //NotificationSetup.VALIDATE("Notification Template Code",NotificationTemplate.Code);
        NotificationSetup.Insert(true);
    end;

    local procedure DefaultNotificationEntryExists(NotificationType: Option): Boolean
    var
        NotificationSetup: Record "Notification Setup";
    begin
        NotificationSetup.SetRange("User ID",'');
        NotificationSetup.SetRange("Notification Type",NotificationType);
        exit(not NotificationSetup.IsEmpty)
    end;

    local procedure DispatchForNotificationType(NotificationEntry: Record "Notification Entries")
    var
        NotificationTemplate: Record "Notification Template";
        NonAggregatedNotifications: Boolean;
    begin

        GetNotificationTemplate(NotificationTemplate,NonAggregatedNotifications,NotificationEntry.Type);
        NonAggregatedNotifications:=true;
        case NotificationTemplate."Notification Method" of
          NotificationTemplate."Notification Method"::"E-mail":
            ApplyEmailTemplateAndDispatch(NotificationEntry,NotificationTemplate,NonAggregatedNotifications);
          NotificationTemplate."Notification Method"::Note:
            ApplyNoteTemplateAndDispatch(NotificationEntry,NotificationTemplate);
        end;
    end;

    local procedure ApplyEmailTemplateAndDispatch(var NotificationEntry: Record "Notification Entries";NotificationTemplate: Record "Notification Template";NonAggregatedNotifications: Boolean)
    var
        NotificationBody: Text;
        AggregatedNotificationBody: Text;
    begin
        if NonAggregatedNotifications then begin
          repeat
            NotificationBody := GetNonAggregatedEmailMessageBody(NotificationEntry,NotificationTemplate);
            if SendEmail(NotificationBody,NotificationEntry) then begin
              MoveNotificationEntryToSentNotificationEntries(
                NotificationEntry,NotificationBody,NonAggregatedNotifications,NotificationTemplate."Notification Method")
            end
            else begin
              NotificationEntry.Validate("Error Message",GetLastErrorText);
              ClearLastError;
              NotificationEntry.Modify(true);
            end;
          until NotificationEntry.Next = 0;
        end else begin
          AggregatedNotificationBody := GetAggregatedEmailMessageBody(NotificationEntry,NotificationTemplate);
          if SendEmail(AggregatedNotificationBody,NotificationEntry) then
            MoveNotificationEntryToSentNotificationEntries(
              NotificationEntry,AggregatedNotificationBody,NonAggregatedNotifications,NotificationTemplate."Notification Method")
          else begin
            NotificationEntry.ModifyAll("Error Message",GetLastErrorText,true);
            ClearLastError;
          end;
        end;
    end;

    local procedure ApplyNoteTemplateAndDispatch(var NotificationEntry: Record "Notification Entries";NotificationTemplate: Record "Notification Template")
    var
        NotificationBody: Text;
        NotificationHeader: Text;
        NotificationFooter: Text;
    begin
        ApplyTemplateHeaderAndFooter(NotificationHeader,NotificationFooter,NotificationTemplate,NotificationEntry);

        repeat
          ApplyTemplate(NotificationBody,NotificationTemplate,NotificationEntry);
          if AddNote(NotificationEntry,NotificationHeader + NotificationBody + NotificationFooter) then
            MoveNotificationEntryToSentNotificationEntries(
              NotificationEntry,NotificationHeader + NotificationBody + NotificationFooter,false,
              NotificationTemplate."Notification Method"::Note);
        until NotificationEntry.Next = 0;
    end;

    local procedure GetNotificationTemplate(var NotificationTemplate: Record "Notification Template";var NonAggregatedNotifications: Boolean;NotificationType: Option "New Record",Approval,Overdue)
    var
        NotificationSetup: Record "Notification Setup";
    begin
        NotificationTemplate.SetRange(Type,NotificationType);
        if NotificationTemplate.FindFirst then;
    end;

    local procedure ApplyTemplate(var NotificationBody: Text;NotificationTemplate: Record "Notification Template";NotificationEntry: Record "Notification Entries")
    begin
        NotificationBody := NotificationTemplate.GetNotificationBody;
        PopulateNotificationTemplateWithRecordInfo(NotificationBody,NotificationEntry);
        PopulateNotificationTemplateWithRecIndependentInfo(NotificationBody,NotificationEntry);
    end;

    [TryFunction]
    local procedure SendEmail(Body: Text;NotificationEntries: Record "Notification Entries")
    var
        EmailItem: Record "Email Item";
        MailManagement: Codeunit "Mail Management";
        DotNetExceptionHandler: Codeunit "DotNet Exception Handler";
        OutStream: OutStream;
    begin
        EmailItem.Init;
        EmailItem."From Address":=NotificationEntries."From Address";
        EmailItem."From Name" := CompanyName;
        EmailItem.Subject := NotificationMailSubjectTxt;
        EmailItem."Send to" := NotificationEntries."Send to";
        if NotificationEntries.CC<>'' then
          EmailItem."Send CC":=NotificationEntries.CC;
        if NotificationEntries.BCC<>'' then
           EmailItem."Send BCC":=NotificationEntries.BCC;
        EmailItem.Body.CreateOutStream(OutStream);
        OutStream.Write(Body);

        if MailManagement.IsSMTPEnabled and MailManagement.IsEnabled then begin
          MailManagement.InitializeFrom(true,false);
          if not MailManagement.Send(EmailItem) then begin
            DotNetExceptionHandler.Collect;
            Error(DotNetExceptionHandler.GetMessage);
          end;
        end else
          Error(SMTPSetupErr);
    end;

    local procedure ApplyTemplateHeaderAndFooter(var NotificationHeader: Text;var NotificationFooter: Text;NotificationTemplate: Record "Notification Template";NotificationEntry: Record "Notification Entries")
    begin
        NotificationHeader := NotificationTemplate.GetNotificationHeader;
        NotificationFooter := NotificationTemplate.GetNotificationFooter;
        PopulateNotificationTemplateWithRecIndependentInfo(NotificationHeader,NotificationEntry);
        PopulateNotificationTemplateWithRecIndependentInfo(NotificationFooter,NotificationEntry);
    end;

    local procedure AddNote(NotificationEntry: Record "Notification Entries";Body: Text): Boolean
    var
        RecordLink: Record "Record Link";
        DataTypeManagement: Codeunit "Data Type Management";
        PageManagement: Codeunit "Page Management";
        RecRef: RecordRef;
        Link: Text;
    begin
        /*DataTypeManagement.GetRecordRef(NotificationEntry."Triggered By Record",RecRef);
        IF NOT RecRef.HASFILTER THEN
          RecRef.SETRECFILTER;
        
        WITH RecordLink DO BEGIN
          INIT;
          "Link ID" := 0;
          "Record ID" := NotificationEntry."Triggered By Record";
          Link := GETURL(DEFAULTCLIENTTYPE,COMPANYNAME,OBJECTTYPE::Page,PageManagement.GetPageID(RecRef),RecRef,TRUE);
          URL1 := COPYSTR(Link,1,MAXSTRLEN(URL1));
          IF STRLEN(Link) > MAXSTRLEN(URL1) THEN
            URL2 := COPYSTR(Link,MAXSTRLEN(URL1) + 1,MAXSTRLEN(URL2));
          Description := COPYSTR(FORMAT(NotificationEntry."Triggered By Record"),1,250);
          Type := Type::Note;
          WriteNoteText(RecordLink,Body);
          Created := CURRENTDATETIME;
          "User ID" := NotificationEntry."Created By";
          Company := COMPANYNAME;
          Notify := TRUE;
          "To User ID" := NotificationEntry."Recipient User ID";
          EXIT(INSERT(TRUE));
        END;
        */
        exit(false);

    end;

    local procedure WriteNoteText(var RecordLink: Record "Record Link";Note: Text)
    var
        SystemUTF8Encoder: DotNet UTF8Encoding;
        SystemByteArray: DotNet Array;
        OStr: OutStream;
        c1: Char;
        c2: Char;
        x: Integer;
        y: Integer;
        i: Integer;
    begin
        SystemUTF8Encoder := SystemUTF8Encoder.UTF8Encoding;
        SystemByteArray := SystemUTF8Encoder.GetBytes(Note);

        RecordLink.Note.CreateOutStream(OStr);
        x := SystemByteArray.Length div 128;
        if x > 1 then
          y := SystemByteArray.Length - 128 * (x - 1)
        else
          y := SystemByteArray.Length;
        c1 := y;
        OStr.Write(c1);
        if x > 0 then begin
          c2 := x;
          OStr.Write(c2);
        end;
        for i := 0 to SystemByteArray.Length - 1 do begin
          c1 := SystemByteArray.GetValue(i);
          OStr.Write(c1);
        end;
    end;

    procedure GetAggregatedEmailMessageBody(var NotificationEntry: Record "Notification Entries";NotificationTemplate: Record "Notification Template") AggregatedNotificationBody: Text
    var
        NotificationBody: Text;
        NotificationHeader: Text;
        NotificationFooter: Text;
    begin
        ApplyTemplateHeaderAndFooter(NotificationHeader,NotificationFooter,NotificationTemplate,NotificationEntry);

        repeat
          ApplyTemplate(NotificationBody,NotificationTemplate,NotificationEntry);
          AggregatedNotificationBody += NotificationBody;
        until NotificationEntry.Next = 0;

        exit(NotificationHeader + AggregatedNotificationBody + NotificationFooter);
    end;

    procedure GetNonAggregatedEmailMessageBody(var NotificationEntry: Record "Notification Entries";NotificationTemplate: Record "Notification Template"): Text
    var
        NotificationHeader: Text;
        NotificationFooter: Text;
        NotificationBody: Text;
    begin
        ApplyTemplate(NotificationBody,NotificationTemplate,NotificationEntry);

        exit(NotificationBody);
    end;

    local procedure MoveNotificationEntryToSentNotificationEntries(var NotificationEntry: Record "Notification Entries";NotificationBody: Text;NonAggregatedNotifications: Boolean;NotificationMethod: Option)
    var
        SentNotificationEntry: Record "Sent Notification Entry";
        InitialSentNotificationEntry: Record "Sent Notification Entry";
    begin
        /*IF NonAggregatedNotifications THEN BEGIN
          SentNotificationEntry.NewRecord(NotificationEntry,NotificationBody,NotificationMethod);
          NotificationEntry.DELETE(TRUE);
        END ELSE BEGIN
          IF NotificationEntry.FINDSET THEN BEGIN
            InitialSentNotificationEntry.NewRecord(NotificationEntry,NotificationBody,NotificationMethod);
            WHILE NotificationEntry.NEXT <> 0 DO BEGIN
              SentNotificationEntry.NewRecord(NotificationEntry,NotificationBody,NotificationMethod);
              SentNotificationEntry.VALIDATE("Aggregated with Entry",InitialSentNotificationEntry.ID);
              SentNotificationEntry.MODIFY(TRUE);
            END;
          END;
          NotificationEntry.DELETEALL(TRUE);
        END;
        */

    end;

    local procedure FilterToActiveNotificationEntries(var NotificationEntry: Record "Notification Entry")
    begin
        repeat
          NotificationEntry.Mark(true);
        until NotificationEntry.Next = 0;
        NotificationEntry.MarkedOnly(true);
        NotificationEntry.FindSet;
    end;

    procedure CreateNotificationEntry(Type: Option "New Record",Approval,Overdue;CreatedBy: Code[50];CreatedDateTime: DateTime;Title: Text;TransactionNo: Code[50];Description: Text;ClientID: Code[50];Status: Text;ProductName: Text;ClientAccount: Code[50];InstructionType: Text;Amount: Decimal;TransactionType: Option " ","Direct Debit","Online Redmption Mandate",Subscription,Redemption,"Unit Transfer")
    var
        NotificationEntries: Record "Notification Entries";
        NotificationSetups: Record "Notification Setups";
    begin
        NotificationSetups.Reset;
        NotificationSetups.SetRange("Transaction Type",TransactionType);
        if NotificationSetups.FindFirst then begin

          NotificationEntries.Init;
          NotificationEntries.Type:=Type;
          NotificationEntries."Created By":=CreatedBy;
          NotificationEntries."Created Date-Time":=CreatedDateTime;
          NotificationEntries.Title:=Title;
          NotificationEntries."Transaction No":=TransactionNo;
          NotificationEntries.Description:=Description;
          NotificationEntries."Client ID":=ClientID;
          NotificationEntries."Client Account":=ClientAccount;
          NotificationEntries."Product Name":=ProductName;
          NotificationEntries.Status:=Status;
          NotificationEntries."Instruction Type":=InstructionType;
          NotificationEntries.Amount:=Amount;
          NotificationEntries."Send to":=NotificationSetups."Send to";
          NotificationEntries.CC:=NotificationSetups.CC;
          NotificationEntries.BCC:=NotificationSetups.BCC;
          NotificationEntries.Insert(true);
          DispatchForNotificationType(NotificationEntries);
        end;
    end;
}

