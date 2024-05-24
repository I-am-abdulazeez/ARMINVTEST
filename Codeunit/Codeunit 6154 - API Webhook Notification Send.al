codeunit 6154 "API Webhook Notification Send"
{
    // version NAVW113.02

    // 1. Aggregates notifications
    // 2. Generates notifications payload per notification URL
    // 3. Sends notifications


    trigger OnRun()
    begin
        if not IsApiSubscriptionEnabled then begin
          SendTraceTag('000029V',APIWebhookCategoryLbl,VERBOSITY::Normal,DisabledSubscriptionMsg,DATACLASSIFICATION::SystemMetadata);
          exit;
        end;

        Initialize;
        DeleteExpiredSubscriptions;
        DeleteObsoleteSubscriptions;

        if not GetActiveSubscriptions then begin
          SendTraceTag('000029W',APIWebhookCategoryLbl,VERBOSITY::Normal,NoActiveSubscriptionsMsg,DATACLASSIFICATION::SystemMetadata);
          exit;
        end;

        ProcessNotifications;
        DeleteInactiveJobs;
    end;

    var
        TempAPIWebhookNotificationAggr: Record "API Webhook Notification Aggr" temporary;
        TempAPIWebhookSubscription: Record "API Webhook Subscription" temporary;
        TempSubscriptionIdBySubscriptionNoNameValueBuffer: Record "Name/Value Buffer" temporary;
        TempKeyFieldTypeBySubscriptionIdNameValueBuffer: Record "Name/Value Buffer" temporary;
        TypeHelper: Codeunit "Type Helper";
        APIWebhookNotificationMgt: Codeunit "API Webhook Notification Mgt.";
        ResourceUrlBySubscriptionIdDictionaryWrapper: Codeunit "Dictionary Wrapper";
        NotificationUrlBySubscriptionIdDictionaryWrapper: Codeunit "Dictionary Wrapper";
        SubscriptionsPerNotificationUrlDictionaryWrapper: Codeunit "Dictionary Wrapper";
        ProcessingDateTime: DateTime;
        APIWebhookCategoryLbl: Label 'AL API Webhook', Locked=true;
        JobQueueCategoryCodeLbl: Label 'APIWEBHOOK', Locked=true;
        SendNotificationMsg: Label 'Send notification.', Locked=true;
        SucceedNotificationMsg: Label 'Notification has been sent successfully.', Locked=true;
        FailedNotificationRescheduleMsg: Label 'Server was not able to proceess the notification at this point. Response code %1. Notification is rescheduled.', Locked=true;
        FailedNotificationRejectedMsg: Label 'Server has rejected the notification. Response code %1.', Locked=true;
        NoPendingNotificationsMsg: Label 'No pending notifications.', Locked=true;
        NoActiveSubscriptionsMsg: Label 'No active subscriptions.', Locked=true;
        DisabledSubscriptionMsg: Label 'API subscription disabled.', Locked=true;
        DeleteObsoleteSubscriptionMsg: Label 'Delete obsolete subscription.', Locked=true;
        DeleteExpiredSubscriptionMsg: Label 'Delete expired subscription.', Locked=true;
        DeleteInvalidSubscriptionMsg: Label 'Delete invalid subscription.', Locked=true;
        DeleteSubscriptionWithTooManyFailuresMsg: Label 'Delete subscription with too many failures.', Locked=true;
        WrongNumberOfNotificationsMsg: Label 'Wrong number of notifications.', Locked=true;
        EmptyLastModifiedDateTimeMsg: Label 'Empty last modified datetime.', Locked=true;
        EmptyNotificationUrlErr: Label 'Empty notification URL.', Locked=true;
        EmptyPayloadPerSubscriptionErr: Label 'Empty payload per subscription.', Locked=true;
        EmptyPayloadPerNotificationUrlErr: Label 'Empty payload per notification URL.', Locked=true;
        CannotGetResponseErr: Label 'Cannot get response.', Locked=true;
        CannotFindValueInCacheErr: Label 'Cannot find value in cache.', Locked=true;
        SendingNotificationFailedErr: Label 'Sending notification failed for %1. Response code: %2. Error message: %3. Error details: %4.', Comment='%1 Notification Url, %2 response code, %3 error message that the URL returned, %4 Detailed error message from the site.';
        SendingNotificationFailedDescirptionTxt: Label 'Sending notification failed.', Locked=true;

    local procedure Initialize()
    begin
        TempAPIWebhookNotificationAggr.Reset;
        TempAPIWebhookNotificationAggr.DeleteAll;
        TempAPIWebhookNotificationAggr.SetCurrentKey("Subscription ID","Last Modified Date Time","Change Type");
        TempAPIWebhookNotificationAggr.Ascending(true);

        TempAPIWebhookSubscription.Reset;
        TempAPIWebhookSubscription.DeleteAll;
        TempAPIWebhookSubscription.SetCurrentKey("Subscription Id");
        TempAPIWebhookSubscription.Ascending(true);

        TempSubscriptionIdBySubscriptionNoNameValueBuffer.Reset;
        TempSubscriptionIdBySubscriptionNoNameValueBuffer.DeleteAll;
        TempSubscriptionIdBySubscriptionNoNameValueBuffer.SetCurrentKey(ID);
        TempSubscriptionIdBySubscriptionNoNameValueBuffer.Ascending(true);

        TempKeyFieldTypeBySubscriptionIdNameValueBuffer.Reset;
        TempKeyFieldTypeBySubscriptionIdNameValueBuffer.DeleteAll;
        TempKeyFieldTypeBySubscriptionIdNameValueBuffer.SetCurrentKey(Name);
        TempKeyFieldTypeBySubscriptionIdNameValueBuffer.Ascending(true);

        ResourceUrlBySubscriptionIdDictionaryWrapper.Clear;
        NotificationUrlBySubscriptionIdDictionaryWrapper.Clear;
        SubscriptionsPerNotificationUrlDictionaryWrapper.Clear;

        ProcessingDateTime := CurrentDateTime;
    end;

    local procedure ProcessNotifications()
    var
        RescheduleDateTime: DateTime;
        PendingNotificationsExist: Boolean;
    begin
        OnBeforeProcessNotifications;
        TransferAggregateNotificationsToBuffer;
        PendingNotificationsExist := GenerateAggregateNotifications;
        if PendingNotificationsExist then begin
          SendNotifications;
          UpdateTablesFromBuffer(RescheduleDateTime);
          if RescheduleDateTime > ProcessingDateTime then
            APIWebhookNotificationMgt.ScheduleJob(RescheduleDateTime);
        end;
        OnAfterProcessNotifications;
    end;

    local procedure SendNotifications()
    var
        CachedKey: Variant;
        CachedValue: Variant;
        SubscriptionNumbers: Text;
        NotificationUrl: Text;
        PayloadPerNotificationUrl: Text;
        NotificationUrlCount: Integer;
        I: Integer;
        Reschedule: Boolean;
    begin
        NotificationUrlCount := SubscriptionsPerNotificationUrlDictionaryWrapper.Count;
        for I := 1 to NotificationUrlCount do
          if SubscriptionsPerNotificationUrlDictionaryWrapper.TryGetKeyValue(I - 1,CachedKey,CachedValue) then begin
            NotificationUrl := CachedKey;
            SubscriptionNumbers := CachedValue;
            PayloadPerNotificationUrl := GetPayloadPerNotificationUrl(SubscriptionNumbers);
            if SendNotification(NotificationUrl,PayloadPerNotificationUrl,Reschedule) then
              DeleteNotifications(SubscriptionNumbers)
            else
              if Reschedule then
                IncreaseAttemptNumber(SubscriptionNumbers)
              else begin
                DeleteNotifications(SubscriptionNumbers);
                DeleteInvalidSubscriptions(SubscriptionNumbers);
              end;
          end;
    end;

    local procedure GetPayloadPerNotificationUrl(SubscriptionNumbers: Text): Text
    var
        JSONManagement: Codeunit "JSON Management";
        JsonArray: DotNet JArray;
        SubscriptionNumber: Text;
        RemainingSubscriptionNumbers: Text;
        SubscriptionId: Text;
        PayloadPerNotificationUrl: Text;
        I: Integer;
        N: Integer;
    begin
        JSONManagement.InitializeEmptyCollection;
        JSONManagement.GetJsonArray(JsonArray);

        RemainingSubscriptionNumbers := SubscriptionNumbers;
        N := StrLen(RemainingSubscriptionNumbers) div 2;
        for I := 0 to N do
          if StrLen(RemainingSubscriptionNumbers) > 0 then begin
            SubscriptionNumber := GetNextToken(RemainingSubscriptionNumbers,',');
            SubscriptionId := GetSubscriptionIdBySubscriptionNumber(SubscriptionNumber);
            AddPayloadPerSubscription(JSONManagement,JsonArray,SubscriptionId);
          end else
            I := N;

        if JsonArray.Count = 0 then begin
          SendTraceTag('000029X',APIWebhookCategoryLbl,VERBOSITY::Error,EmptyPayloadPerNotificationUrlErr,
            DATACLASSIFICATION::SystemMetadata);
          exit('')
        end;

        PayloadPerNotificationUrl := JsonArray.ToString;
        FormatPayloadPerNotificationUrl(PayloadPerNotificationUrl);
        exit(PayloadPerNotificationUrl);
    end;

    local procedure AddPayloadPerSubscription(var JSONManagement: Codeunit "JSON Management";var JsonArray: DotNet JArray;SubscriptionId: Text)
    var
        JsonObject: DotNet JObject;
        I: Integer;
    begin
        if SubscriptionId = '' then
          exit;

        ClearFiltersFromNotificationsBuffer;
        TempAPIWebhookNotificationAggr.SetRange("Subscription ID",SubscriptionId);
        if not TempAPIWebhookNotificationAggr.Find('-') then
          exit;

        repeat
          if GetEntityJObject(TempAPIWebhookNotificationAggr,JsonObject) then begin
            JSONManagement.AddJObjectToJArray(JsonArray,JsonObject);
            I += 1;
          end;
        until TempAPIWebhookNotificationAggr.Next = 0;

        if I > 0 then
          exit;

        SendTraceTag('000029Y',APIWebhookCategoryLbl,VERBOSITY::Error,EmptyPayloadPerSubscriptionErr,
          DATACLASSIFICATION::SystemMetadata);
    end;

    local procedure FormatPayloadPerNotificationUrl(var PayloadPerNotificationUrl: Text)
    var
        JSONManagement: Codeunit "JSON Management";
        JsonObject: DotNet JObject;
        JsonArray: DotNet JArray;
    begin
        if PayloadPerNotificationUrl = '' then
          exit;
        JSONManagement.InitializeCollection(PayloadPerNotificationUrl);
        JSONManagement.GetJsonArray(JsonArray);
        JSONManagement.InitializeEmptyObject;
        JSONManagement.GetJSONObject(JsonObject);
        JSONManagement.AddJArrayToJObject(JsonObject,'value',JsonArray);
        PayloadPerNotificationUrl := JsonObject.ToString;
    end;

    local procedure GetPendingNotifications(var APIWebhookNotification: Record "API Webhook Notification";ProcessingDateTime: DateTime): Boolean
    begin
        APIWebhookNotification.SetCurrentKey("Subscription ID","Last Modified Date Time","Change Type");
        APIWebhookNotification.Ascending(true);
        APIWebhookNotification.SetFilter("Last Modified Date Time",'<=%1',ProcessingDateTime);
        exit(APIWebhookNotification.FindSet(true,true));
    end;

    local procedure TransferAggregateNotificationsToBuffer()
    var
        APIWebhookNotificationAggr: Record "API Webhook Notification Aggr";
        EmptyGuid: Guid;
    begin
        APIWebhookNotificationAggr.LockTable;
        APIWebhookNotificationAggr.SetFilter(ID,'<>%1',EmptyGuid);
        APIWebhookNotificationAggr.SetFilter("Subscription ID",'<>%1','');
        if APIWebhookNotificationAggr.FindSet then
          repeat
            TempAPIWebhookNotificationAggr.TransferFields(APIWebhookNotificationAggr,true);
            TempAPIWebhookNotificationAggr.Insert;
          until APIWebhookNotificationAggr.Next = 0;
    end;

    local procedure GenerateAggregateNotifications(): Boolean
    var
        APIWebhookNotification: Record "API Webhook Notification";
        PendingNotificationsExist: Boolean;
        NewNotificationsExist: Boolean;
    begin
        ClearFiltersFromNotificationsBuffer;
        PendingNotificationsExist := TempAPIWebhookNotificationAggr.FindFirst;
        NewNotificationsExist := GetPendingNotifications(APIWebhookNotification,ProcessingDateTime);

        if (not PendingNotificationsExist) and (not NewNotificationsExist) then begin
          SendTraceTag('0000298',APIWebhookCategoryLbl,VERBOSITY::Normal,NoPendingNotificationsMsg,DATACLASSIFICATION::SystemMetadata);
          exit(false);
        end;

        if NewNotificationsExist then
          repeat
            GenerateAggregateNotification(APIWebhookNotification);
          until APIWebhookNotification.Next = 0;

        exit(true);
    end;

    local procedure GenerateAggregateNotification(var APIWebhookNotification: Record "API Webhook Notification")
    var
        LastAPIWebhookNotification: Record "API Webhook Notification";
        LastModifiedDateTime: DateTime;
        CountPerSubscription: Integer;
    begin
        ClearFiltersFromNotificationsBuffer;
        TempAPIWebhookNotificationAggr.SetRange("Subscription ID",APIWebhookNotification."Subscription ID");
        if TempAPIWebhookNotificationAggr.FindLast then begin
          CountPerSubscription := TempAPIWebhookNotificationAggr.Count;
          if TempAPIWebhookNotificationAggr."Change Type" = TempAPIWebhookNotificationAggr."Change Type"::Collection then begin
            if TempAPIWebhookNotificationAggr.Count > 1 then
              SendTraceTag('00006P2',APIWebhookCategoryLbl,VERBOSITY::Warning,WrongNumberOfNotificationsMsg,
                DATACLASSIFICATION::SystemMetadata);
            GetLastNotification(LastAPIWebhookNotification,APIWebhookNotification."Subscription ID");
            if TempAPIWebhookNotificationAggr."Last Modified Date Time" <> 0DT then
              if LastAPIWebhookNotification."Change Type" <> LastAPIWebhookNotification."Change Type"::Deleted then
                if not HasNotificationOnDelete(APIWebhookNotification."Subscription ID") then
                  LastModifiedDateTime := LastAPIWebhookNotification."Last Modified Date Time";
            TempAPIWebhookNotificationAggr."Last Modified Date Time" := LastModifiedDateTime;
            TempAPIWebhookNotificationAggr.Modify(true);
            APIWebhookNotification := LastAPIWebhookNotification;
            exit;
          end;

          if APIWebhookNotification."Change Type" = APIWebhookNotification."Change Type"::Updated then begin
            ClearFiltersFromNotificationsBuffer;
            TempAPIWebhookNotificationAggr.SetRange("Subscription ID",APIWebhookNotification."Subscription ID");
            TempAPIWebhookNotificationAggr.SetRange("Entity Key Value",APIWebhookNotification."Entity Key Value");
            if TempAPIWebhookNotificationAggr.FindLast then
              if TempAPIWebhookNotificationAggr."Change Type" = TempAPIWebhookNotificationAggr."Change Type"::Updated then begin
                TempAPIWebhookNotificationAggr."Last Modified Date Time" := APIWebhookNotification."Last Modified Date Time";
                TempAPIWebhookNotificationAggr.Modify(true);
                exit;
              end;
          end;
        end;

        if CountPerSubscription <= GetMaxNumberOfNotifications - 1 then begin
          TempAPIWebhookNotificationAggr.TransferFields(APIWebhookNotification,true);
          TempAPIWebhookNotificationAggr.Insert;
        end else begin
          ClearFiltersFromNotificationsBuffer;
          TempAPIWebhookNotificationAggr.SetRange("Subscription ID",APIWebhookNotification."Subscription ID");
          TempAPIWebhookNotificationAggr.SetRange("Change Type");
          TempAPIWebhookNotificationAggr.DeleteAll;

          if APIWebhookNotification."Change Type" <> APIWebhookNotification."Change Type"::Deleted then
            if not HasNotificationOnDelete(APIWebhookNotification."Subscription ID") then
              LastModifiedDateTime := APIWebhookNotification."Last Modified Date Time";

          TempAPIWebhookNotificationAggr.TransferFields(APIWebhookNotification,true);
          TempAPIWebhookNotificationAggr."Last Modified Date Time" := LastModifiedDateTime;
          TempAPIWebhookNotificationAggr."Change Type" := TempAPIWebhookNotificationAggr."Change Type"::Collection;
          TempAPIWebhookNotificationAggr.Insert;
          exit;
        end;
    end;

    local procedure GetLastNotification(var APIWebhookNotification: Record "API Webhook Notification";SubscriptionId: Text[150])
    begin
        APIWebhookNotification.SetRange("Subscription ID",SubscriptionId);
        APIWebhookNotification.SetCurrentKey("Last Modified Date Time","Change Type");
        APIWebhookNotification.Ascending(true);
        APIWebhookNotification.FindLast;
    end;

    local procedure HasNotificationOnDelete(SubscriptionId: Text[150]): Boolean
    var
        APIWebhookNotification: Record "API Webhook Notification";
    begin
        APIWebhookNotification.SetRange("Subscription ID",SubscriptionId);
        APIWebhookNotification.SetRange("Change Type",APIWebhookNotification."Change Type"::Deleted);
        exit(not APIWebhookNotification.IsEmpty);
    end;

    local procedure CollectValuesInDictionaries(var APIWebhookSubscription: Record "API Webhook Subscription";SubscriptionNumber: Integer)
    begin
        CollectSubscriptionIdBySubscriptionNumber(APIWebhookSubscription,SubscriptionNumber);
        CollectKeyFieldTypeBySubscriptionId(APIWebhookSubscription,SubscriptionNumber);
        CollectResourceUrlBySubscriptionId(APIWebhookSubscription);
        CollectNotificationUrlBySubscriptionId(APIWebhookSubscription);
        CollectSubscriptionsPerNotificationUrl(APIWebhookSubscription,SubscriptionNumber);
    end;

    local procedure CollectSubscriptionIdBySubscriptionNumber(var APIWebhookSubscription: Record "API Webhook Subscription";SubscriptionNumber: Integer)
    begin
        Clear(TempSubscriptionIdBySubscriptionNoNameValueBuffer);
        TempSubscriptionIdBySubscriptionNoNameValueBuffer.ID := SubscriptionNumber;
        TempSubscriptionIdBySubscriptionNoNameValueBuffer.Name := '';
        TempSubscriptionIdBySubscriptionNoNameValueBuffer.Value := APIWebhookSubscription."Subscription Id";
        TempSubscriptionIdBySubscriptionNoNameValueBuffer.Insert;
    end;

    local procedure CollectKeyFieldTypeBySubscriptionId(var APIWebhookSubscription: Record "API Webhook Subscription";SubscriptionNumber: Integer)
    var
        ApiWebhookEntity: Record "Api Webhook Entity";
        RecRef: RecordRef;
        FieldRef: FieldRef;
        KeyFieldType: Text;
    begin
        if not APIWebhookNotificationMgt.GetEntity(APIWebhookSubscription,ApiWebhookEntity) then
          exit;

        RecRef.Open(APIWebhookSubscription."Source Table Id",true);
        if not APIWebhookNotificationMgt.TryGetEntityKeyField(ApiWebhookEntity,RecRef,FieldRef) then
          exit;

        KeyFieldType := Format(FieldRef.Type);

        Clear(TempKeyFieldTypeBySubscriptionIdNameValueBuffer);
        TempKeyFieldTypeBySubscriptionIdNameValueBuffer.ID := SubscriptionNumber;
        TempKeyFieldTypeBySubscriptionIdNameValueBuffer.Name := APIWebhookSubscription."Subscription Id";
        TempKeyFieldTypeBySubscriptionIdNameValueBuffer.Value :=
          CopyStr(KeyFieldType,1,MaxStrLen(TempKeyFieldTypeBySubscriptionIdNameValueBuffer.Value));
        TempKeyFieldTypeBySubscriptionIdNameValueBuffer.Insert;
    end;

    local procedure CollectResourceUrlBySubscriptionId(var APIWebhookSubscription: Record "API Webhook Subscription")
    var
        ResourceUrl: Text;
    begin
        if ResourceUrlBySubscriptionIdDictionaryWrapper.ContainsKey(APIWebhookSubscription."Subscription Id") then
          exit;

        ResourceUrl := GetResourceUrl(APIWebhookSubscription);
        ResourceUrlBySubscriptionIdDictionaryWrapper.Set(APIWebhookSubscription."Subscription Id",ResourceUrl);
    end;

    local procedure CollectNotificationUrlBySubscriptionId(var APIWebhookSubscription: Record "API Webhook Subscription")
    var
        NotificationUrl: Text;
    begin
        if NotificationUrlBySubscriptionIdDictionaryWrapper.ContainsKey(APIWebhookSubscription."Subscription Id") then
          exit;

        NotificationUrl := GetNotificationUrl(APIWebhookSubscription);
        NotificationUrlBySubscriptionIdDictionaryWrapper.Set(APIWebhookSubscription."Subscription Id",NotificationUrl);
    end;

    local procedure CollectSubscriptionsPerNotificationUrl(var APIWebhookSubscription: Record "API Webhook Subscription";SubscriptionNumber: Integer)
    var
        CachedValue: Variant;
        NotificationUrl: Text;
        SubscriptionId: Text;
        SubscriptionNumbers: Text;
    begin
        SubscriptionId := APIWebhookSubscription."Subscription Id";

        NotificationUrl := GetNotificationUrlBySubscriptionId(SubscriptionId);
        if NotificationUrl = '' then
          exit;

        if SubscriptionsPerNotificationUrlDictionaryWrapper.TryGetValue(NotificationUrl,CachedValue) then begin
          SubscriptionNumbers := CachedValue;
          SubscriptionNumbers := StrSubstNo('%1,%2',SubscriptionNumbers,SubscriptionNumber);
        end else
          SubscriptionNumbers := Format(SubscriptionNumber);
        SubscriptionsPerNotificationUrlDictionaryWrapper.Set(NotificationUrl,SubscriptionNumbers);
    end;

    local procedure DeleteNotifications(SubscriptionNumbers: Text)
    var
        SubscriptionId: Text;
        SubscriptionNumber: Text;
        RemainingSubscriptionNumbers: Text;
        I: Integer;
        N: Integer;
    begin
        RemainingSubscriptionNumbers := SubscriptionNumbers;
        N := StrLen(RemainingSubscriptionNumbers) div 2;
        for I := 0 to N do
          if StrLen(RemainingSubscriptionNumbers) > 0 then begin
            SubscriptionNumber := GetNextToken(RemainingSubscriptionNumbers,',');
            SubscriptionId := GetSubscriptionIdBySubscriptionNumber(SubscriptionNumber);
            if SubscriptionId <> '' then begin
              ClearFiltersFromNotificationsBuffer;
              TempAPIWebhookNotificationAggr.SetRange("Subscription ID",SubscriptionId);
              TempAPIWebhookNotificationAggr.DeleteAll;
            end;
          end else
            I := N;
    end;

    local procedure DeleteInvalidSubscriptions(SubscriptionNumbers: Text)
    var
        APIWebhookSubscription: Record "API Webhook Subscription";
        SubscriptionId: Text;
        SubscriptionNumber: Text;
        RemainingSubscriptionNumbers: Text;
        I: Integer;
        N: Integer;
    begin
        RemainingSubscriptionNumbers := SubscriptionNumbers;
        N := StrLen(RemainingSubscriptionNumbers) div 2;
        for I := 0 to N do
          if StrLen(RemainingSubscriptionNumbers) > 0 then begin
            SubscriptionNumber := GetNextToken(RemainingSubscriptionNumbers,',');
            SubscriptionId := GetSubscriptionIdBySubscriptionNumber(SubscriptionNumber);
            if SubscriptionId <> '' then
              if APIWebhookSubscription.Get(SubscriptionId) then begin
                APIWebhookNotificationMgt.DeleteSubscription(APIWebhookSubscription);
                SendTraceTag('00006SJ',APIWebhookCategoryLbl,VERBOSITY::Warning,DeleteInvalidSubscriptionMsg,
                  DATACLASSIFICATION::SystemMetadata);
              end;
          end else
            I := 10;
    end;

    local procedure IncreaseAttemptNumber(SubscriptionNumbers: Text)
    var
        SubscriptionId: Text;
        SubscriptionNumber: Text;
        RemainingSubscriptionNumbers: Text;
        I: Integer;
        N: Integer;
    begin
        RemainingSubscriptionNumbers := SubscriptionNumbers;
        N := StrLen(RemainingSubscriptionNumbers) div 2;
        for I := 0 to N do
          if StrLen(RemainingSubscriptionNumbers) > 0 then begin
            SubscriptionNumber := GetNextToken(RemainingSubscriptionNumbers,',');
            SubscriptionId := GetSubscriptionIdBySubscriptionNumber(SubscriptionNumber);
            if SubscriptionId <> '' then begin
              ClearFiltersFromNotificationsBuffer;
              TempAPIWebhookNotificationAggr.SetRange("Subscription ID",SubscriptionId);
              if TempAPIWebhookNotificationAggr.Find('-') then
                repeat
                  if TempAPIWebhookNotificationAggr."Sending Scheduled Date Time" <= ProcessingDateTime then begin
                    TempAPIWebhookNotificationAggr."Attempt No." += 1;
                    TempAPIWebhookNotificationAggr.Modify;
                  end;
                until TempAPIWebhookNotificationAggr.Next = 0;
            end;
          end else
            I := N;
    end;

    local procedure UpdateTablesFromBuffer(var EarliestRescheduleDateTime: DateTime)
    begin
        DeleteSubscriptionsWithTooManyFailures;
        DeleteProcessedNotifications;
        SaveFailedAggregateNotifications(EarliestRescheduleDateTime);
    end;

    local procedure DeleteProcessedNotifications()
    var
        APIWebhookNotification: Record "API Webhook Notification";
    begin
        APIWebhookNotification.SetFilter("Last Modified Date Time",'<=%1',ProcessingDateTime);
        if not APIWebhookNotification.IsEmpty then
          APIWebhookNotification.DeleteAll(true);
    end;

    local procedure SaveFailedAggregateNotifications(var EarliestScheduledDateTime: DateTime)
    var
        APIWebhookNotificationAggr: Record "API Webhook Notification Aggr";
        ScheduledDateTime: DateTime;
    begin
        EarliestScheduledDateTime := 0DT;
        if not APIWebhookNotificationAggr.IsEmpty then
          APIWebhookNotificationAggr.DeleteAll(true);
        ClearFiltersFromNotificationsBuffer;
        if TempAPIWebhookNotificationAggr.Find('-') then
          repeat
            APIWebhookNotificationAggr.TransferFields(TempAPIWebhookNotificationAggr,true);
            if APIWebhookNotificationAggr."Sending Scheduled Date Time" < ProcessingDateTime then begin
              ScheduledDateTime := ProcessingDateTime + GetDelayTimeForAttempt(TempAPIWebhookNotificationAggr."Attempt No.");
              APIWebhookNotificationAggr."Sending Scheduled Date Time" := ScheduledDateTime;
              if (ScheduledDateTime < EarliestScheduledDateTime) or (EarliestScheduledDateTime = 0DT) then
                EarliestScheduledDateTime := ScheduledDateTime;
            end;
            APIWebhookNotificationAggr.Insert(true);
          until TempAPIWebhookNotificationAggr.Next = 0;
    end;

    local procedure SendNotification(NotificationUrl: Text;NotificationPayload: Text;var Reschedule: Boolean): Boolean
    var
        DummyAPIWebhookNotificationAggr: Record "API Webhook Notification Aggr";
        ActivityLog: Record "Activity Log";
        HttpStatusCode: DotNet HttpStatusCode;
        ResponseBody: Text;
        ErrorMessage: Text;
        ErrorDetails: Text;
        Success: Boolean;
    begin
        if NotificationUrl = '' then begin
          SendTraceTag('000029Z',APIWebhookCategoryLbl,VERBOSITY::Error,EmptyNotificationUrlErr,DATACLASSIFICATION::SystemMetadata);
          exit(true);
        end;

        if NotificationPayload = '' then begin
          SendTraceTag('00002A0',APIWebhookCategoryLbl,VERBOSITY::Error,EmptyPayloadPerNotificationUrlErr,
            DATACLASSIFICATION::SystemMetadata);
          exit(true);
        end;

        OnBeforeSendNotification(NotificationUrl,NotificationPayload);

        SendTraceTag('000029B',APIWebhookCategoryLbl,VERBOSITY::Normal,SendNotificationMsg,DATACLASSIFICATION::SystemMetadata);

        Success := SendRequest(NotificationUrl,NotificationPayload,ResponseBody,ErrorMessage,ErrorDetails,HttpStatusCode);
        if not Success then
          ErrorMessage += GetLastErrorText + ErrorMessage;

        OnAfterSendNotification(ErrorMessage,ErrorDetails,HttpStatusCode);

        if not Success then begin
          Reschedule := ShouldReschedule(HttpStatusCode);
          ActivityLog.LogActivity(
            DummyAPIWebhookNotificationAggr,ActivityLog.Status::Failed,APIWebhookCategoryLbl,SendingNotificationFailedDescirptionTxt,
            StrSubstNo(SendingNotificationFailedErr,NotificationUrl,HttpStatusCode,ErrorMessage,ErrorDetails));
          if Reschedule then begin
            SendTraceTag('000029C',APIWebhookCategoryLbl,VERBOSITY::Error,StrSubstNo(FailedNotificationRescheduleMsg,HttpStatusCode),
              DATACLASSIFICATION::SystemMetadata);
            exit(false);
          end;

          SendTraceTag('000029D',APIWebhookCategoryLbl,VERBOSITY::Error,StrSubstNo(FailedNotificationRejectedMsg,HttpStatusCode),
            DATACLASSIFICATION::SystemMetadata);
          exit(false);
        end;

        SendTraceTag('000029E',APIWebhookCategoryLbl,VERBOSITY::Normal,SucceedNotificationMsg,DATACLASSIFICATION::SystemMetadata);
        exit(true);
    end;

    [TryFunction]
    local procedure SendRequest(NotificationUrl: Text;NotificationPayload: Text;var ResponseBody: Text;var ErrorMessage: Text;var ErrorDetails: Text;var HttpStatusCode: DotNet HttpStatusCode)
    var
        HttpWebRequestMgt: Codeunit "Http Web Request Mgt.";
        ResponseHeaders: DotNet NameValueCollection;
    begin
        if NotificationUrl = '' then begin
          SendTraceTag('00002A1',APIWebhookCategoryLbl,VERBOSITY::Error,EmptyNotificationUrlErr,DATACLASSIFICATION::SystemMetadata);
          Error(EmptyNotificationUrlErr);
        end;

        if NotificationPayload = '' then begin
          SendTraceTag('00002A2',APIWebhookCategoryLbl,VERBOSITY::Error,EmptyPayloadPerNotificationUrlErr,
            DATACLASSIFICATION::SystemMetadata);
          Error(EmptyPayloadPerNotificationUrlErr);
        end;

        HttpWebRequestMgt.Initialize(NotificationUrl);
        HttpWebRequestMgt.DisableUI;
        HttpWebRequestMgt.SetMethod('POST');
        HttpWebRequestMgt.SetReturnType('application/json');
        HttpWebRequestMgt.SetContentType('application/json');
        HttpWebRequestMgt.SetTimeout(GetSendingNotificationTimeout);
        HttpWebRequestMgt.AddBodyAsText(NotificationPayload);

        if not HttpWebRequestMgt.SendRequestAndReadTextResponse(ResponseBody,ErrorMessage,ErrorDetails,HttpStatusCode,ResponseHeaders) then begin
          if IsNull(HttpStatusCode) then
            SendTraceTag('00002A3',APIWebhookCategoryLbl,VERBOSITY::Error,CannotGetResponseErr,DATACLASSIFICATION::SystemMetadata);
          Error(CannotGetResponseErr);
        end;
    end;

    local procedure ShouldReschedule(var HttpStatusCode: DotNet HttpStatusCode): Boolean
    var
        HttpStatusCodeNumber: Integer;
    begin
        if IsNull(HttpStatusCode) then
          exit(true);

        HttpStatusCodeNumber := HttpStatusCode;

        // 5xx range - Server error
        // 408 - Request Timeout, 429 - Too Many Requests
        if ((HttpStatusCodeNumber >= 500) and (HttpStatusCodeNumber <= 599)) or
           (HttpStatusCodeNumber = 408) or (HttpStatusCodeNumber = 429)
        then
          exit(true);

        exit(false);
    end;

    local procedure GetEntityJObject(var TempAPIWebhookNotificationAggr: Record "API Webhook Notification Aggr" temporary;var JSONObject: DotNet JObject): Boolean
    var
        JSONManagement: Codeunit "JSON Management";
        ResourceUrl: Text;
        LastModifiedDateTime: DateTime;
    begin
        ClearFiltersFromSubscriptionsBuffer;
        TempAPIWebhookSubscription.SetRange("Subscription Id",TempAPIWebhookNotificationAggr."Subscription ID");
        if not TempAPIWebhookSubscription.FindFirst then
          exit(false);

        ResourceUrl := GetEntityUrl(TempAPIWebhookNotificationAggr,TempAPIWebhookSubscription);
        if ResourceUrl = '' then
          exit(false);

        LastModifiedDateTime := TempAPIWebhookNotificationAggr."Last Modified Date Time";
        if LastModifiedDateTime = 0DT then
          if TempAPIWebhookNotificationAggr."Change Type" = TempAPIWebhookNotificationAggr."Change Type"::Collection then
            LastModifiedDateTime := CurrentDateTime
          else
            SendTraceTag('00006P3',APIWebhookCategoryLbl,VERBOSITY::Warning,EmptyLastModifiedDateTimeMsg,
              DATACLASSIFICATION::SystemMetadata);

        JSONManagement.InitializeEmptyObject;
        JSONManagement.GetJSONObject(JSONObject);
        JSONManagement.AddJPropertyToJObject(JSONObject,'subscriptionId',TempAPIWebhookSubscription."Subscription Id");
        JSONManagement.AddJPropertyToJObject(JSONObject,'clientState',TempAPIWebhookSubscription."Client State");
        JSONManagement.AddJPropertyToJObject(JSONObject,'expirationDateTime',TempAPIWebhookSubscription."Expiration Date Time");
        JSONManagement.AddJPropertyToJObject(JSONObject,'resource',ResourceUrl);
        JSONManagement.AddJPropertyToJObject(JSONObject,'changeType',LowerCase(Format(TempAPIWebhookNotificationAggr."Change Type")));
        JSONManagement.AddJPropertyToJObject(JSONObject,'lastModifiedDateTime',LastModifiedDateTime);
        exit(true);
    end;

    local procedure GetEntityUrl(var TempAPIWebhookNotificationAggr: Record "API Webhook Notification Aggr" temporary;var TempAPIWebhookSubscription: Record "API Webhook Subscription" temporary): Text
    var
        EntityUrl: Text;
    begin
        if TempAPIWebhookNotificationAggr."Change Type" <> TempAPIWebhookNotificationAggr."Change Type"::Collection then
          EntityUrl := GetSingleEntityUrl(TempAPIWebhookNotificationAggr,TempAPIWebhookSubscription)
        else
          EntityUrl := GetEntityCollectionUrl(TempAPIWebhookSubscription);
        exit(EntityUrl);
    end;

    local procedure GetSingleEntityUrl(var TempAPIWebhookNotificationAggr: Record "API Webhook Notification Aggr" temporary;var TempAPIWebhookSubscription: Record "API Webhook Subscription" temporary): Text
    var
        ResourceUrl: Text;
        EntityUrl: Text;
        EntityKeyFieldType: Text;
        EntityKeyValue: Text;
    begin
        ResourceUrl := GetResourceUrlBySubscriptionId(TempAPIWebhookSubscription."Subscription Id");
        if ResourceUrl = '' then
          exit('');

        EntityKeyFieldType := GetEntityKeyFieldTypeBySubscriptionId(TempAPIWebhookSubscription."Subscription Id");
        if EntityKeyFieldType = '' then
          exit('');

        EntityKeyValue := GetUriEscapeFieldValue(EntityKeyFieldType,TempAPIWebhookNotificationAggr."Entity Key Value");

        EntityUrl := StrSubstNo('%1(%2)',ResourceUrl,EntityKeyValue);
        exit(EntityUrl);
    end;

    local procedure GetEntityCollectionUrl(var TempAPIWebhookSubscription: Record "API Webhook Subscription" temporary): Text
    var
        CachedValue: Variant;
        ResourceUrl: Text;
    begin
        if not ResourceUrlBySubscriptionIdDictionaryWrapper.TryGetValue(TempAPIWebhookSubscription."Subscription Id",CachedValue) then
          exit('');
        ResourceUrl := CachedValue;

        exit(ResourceUrl);
    end;

    procedure GetUriEscapeFieldValue(FieldType: Text;FieldValue: Text): Text
    var
        FormattedValue: Text;
    begin
        case FieldType of
          'Code','Text':
            if FieldValue <> '' then
              FormattedValue := AddQuotes(TypeHelper.UriEscapeDataString(FieldValue))
            else
              FormattedValue := AddQuotes(FieldValue);
          'Option':
            FormattedValue := AddQuotes(TypeHelper.UriEscapeDataString(FieldValue));
          'DateFormula':
            FormattedValue := AddQuotes(FieldValue);
          else
            FormattedValue := FieldValue;
        end;
        exit(FormattedValue);
    end;

    local procedure AddQuotes(InText: Text) OutText: Text
    begin
        OutText := '''' + InText + '''';
    end;

    local procedure GetSubscriptionIdBySubscriptionNumber(SubscriptionNumber: Text): Text
    var
        SubscriptionId: Text;
    begin
        if not TempSubscriptionIdBySubscriptionNoNameValueBuffer.Get(SubscriptionNumber) then begin
          SendTraceTag('00002A4',APIWebhookCategoryLbl,VERBOSITY::Error,CannotFindValueInCacheErr,DATACLASSIFICATION::SystemMetadata);
          exit('');
        end;

        SubscriptionId := TempSubscriptionIdBySubscriptionNoNameValueBuffer.Value;
        exit(SubscriptionId);
    end;

    local procedure GetEntityKeyFieldTypeBySubscriptionId(SubscriptionId: Text): Text
    var
        EntityKeyFieldType: Text;
    begin
        TempKeyFieldTypeBySubscriptionIdNameValueBuffer.SetRange(Name,SubscriptionId);
        if not TempKeyFieldTypeBySubscriptionIdNameValueBuffer.FindFirst then begin
          SendTraceTag('00002A5',APIWebhookCategoryLbl,VERBOSITY::Error,CannotFindValueInCacheErr,DATACLASSIFICATION::SystemMetadata);
          exit('');
        end;

        EntityKeyFieldType := TempKeyFieldTypeBySubscriptionIdNameValueBuffer.Value;
        exit(EntityKeyFieldType);
    end;

    local procedure GetResourceUrlBySubscriptionId(SubscriptionId: Text): Text
    var
        CachedValue: Variant;
        ResourceUrl: Text;
    begin
        if not ResourceUrlBySubscriptionIdDictionaryWrapper.TryGetValue(SubscriptionId,CachedValue) then begin
          SendTraceTag('00002A6',APIWebhookCategoryLbl,VERBOSITY::Error,CannotFindValueInCacheErr,DATACLASSIFICATION::SystemMetadata);
          exit('');
        end;
        ResourceUrl := CachedValue;
        exit(ResourceUrl);
    end;

    local procedure GetNotificationUrlBySubscriptionId(SubscriptionId: Text): Text
    var
        CachedValue: Variant;
        NotificationUrl: Text;
    begin
        if not NotificationUrlBySubscriptionIdDictionaryWrapper.TryGetValue(SubscriptionId,CachedValue) then begin
          SendTraceTag('00002A7',APIWebhookCategoryLbl,VERBOSITY::Error,CannotFindValueInCacheErr,DATACLASSIFICATION::SystemMetadata);
          exit('');
        end;
        NotificationUrl := CachedValue;
        exit(NotificationUrl);
    end;

    local procedure GetNextToken(var SeparatedValues: Text;Separator: Text): Text
    var
        Token: Text;
        Pos: Integer;
    begin
        Pos := StrPos(SeparatedValues,Separator);
        if Pos > 0 then begin
          Token := CopyStr(SeparatedValues,1,Pos - 1);
          if Pos < StrLen(SeparatedValues) then
            SeparatedValues := CopyStr(SeparatedValues,Pos + 1)
          else
            SeparatedValues := '';
        end else begin
          Token := SeparatedValues;
          SeparatedValues := '';
        end;
        exit(Token);
    end;

    local procedure GetResourceUrl(var APIWebhookSubscription: Record "API Webhook Subscription"): Text
    var
        InStream: InStream;
        ResourceUrl: Text;
    begin
        APIWebhookSubscription."Resource Url Blob".CreateInStream(InStream);
        InStream.Read(ResourceUrl);
        exit(ResourceUrl);
    end;

    local procedure GetNotificationUrl(var APIWebhookSubscription: Record "API Webhook Subscription"): Text
    var
        InStream: InStream;
        NotificationUrl: Text;
    begin
        APIWebhookSubscription."Notification Url Blob".CreateInStream(InStream);
        InStream.Read(NotificationUrl);
        exit(NotificationUrl);
    end;

    local procedure GetActiveSubscriptions(): Boolean
    var
        APIWebhookSubscription: Record "API Webhook Subscription";
        SubscriptionNumber: Integer;
    begin
        APIWebhookSubscription.SetAutoCalcFields("Notification Url Blob","Resource Url Blob");
        APIWebhookSubscription.SetFilter("Expiration Date Time",'>=%1',ProcessingDateTime);
        APIWebhookSubscription.SetFilter("Company Name",'%1|%2',CompanyName,'');
        if not APIWebhookSubscription.FindSet then
          exit(false);

        SubscriptionNumber := 0;
        repeat
          SubscriptionNumber += 1;
          Clear(TempAPIWebhookSubscription);
          TempAPIWebhookSubscription.Init;
          TempAPIWebhookSubscription.TransferFields(APIWebhookSubscription,true);
          Clear(TempAPIWebhookSubscription."Notification Url Blob");
          Clear(TempAPIWebhookSubscription."Resource Url Blob");
          TempAPIWebhookSubscription.Insert;
          CollectValuesInDictionaries(APIWebhookSubscription,SubscriptionNumber);
        until APIWebhookSubscription.Next = 0;
        exit(true);
    end;

    local procedure DeleteObsoleteSubscriptions()
    var
        APIWebhookSubscription: Record "API Webhook Subscription";
        ApiWebhookEntity: Record "Api Webhook Entity";
    begin
        if not APIWebhookSubscription.FindSet(true,true) then
          exit;

        repeat
          if not APIWebhookNotificationMgt.GetEntity(APIWebhookSubscription,ApiWebhookEntity) then begin
            APIWebhookNotificationMgt.DeleteSubscription(APIWebhookSubscription);
            SendTraceTag('0000299',APIWebhookCategoryLbl,VERBOSITY::Normal,DeleteObsoleteSubscriptionMsg,
              DATACLASSIFICATION::SystemMetadata);
          end;
        until APIWebhookSubscription.Next = 0;
    end;

    local procedure DeleteExpiredSubscriptions()
    var
        APIWebhookSubscription: Record "API Webhook Subscription";
    begin
        APIWebhookSubscription.SetFilter("Expiration Date Time",'<%1',ProcessingDateTime);
        APIWebhookSubscription.SetFilter("Company Name",'%1|%2',CompanyName,'');
        if not APIWebhookSubscription.FindSet(true,true) then
          exit;

        repeat
          APIWebhookNotificationMgt.DeleteSubscription(APIWebhookSubscription);
          SendTraceTag('000029A',APIWebhookCategoryLbl,VERBOSITY::Normal,DeleteExpiredSubscriptionMsg,
            DATACLASSIFICATION::SystemMetadata);
        until APIWebhookSubscription.Next = 0;
    end;

    local procedure DeleteSubscriptionsWithTooManyFailures()
    var
        APIWebhookSubscription: Record "API Webhook Subscription";
    begin
        ClearFiltersFromNotificationsBuffer;
        TempAPIWebhookNotificationAggr.SetFilter("Attempt No.",'>%1',GetMaxNumberOfAttempts);
        if not TempAPIWebhookNotificationAggr.Find('-') then
          exit;

        repeat
          if APIWebhookSubscription.Get(TempAPIWebhookNotificationAggr."Subscription ID") then begin
            APIWebhookNotificationMgt.DeleteSubscription(APIWebhookSubscription);
            SendTraceTag('000029R',APIWebhookCategoryLbl,VERBOSITY::Normal,DeleteSubscriptionWithTooManyFailuresMsg,
              DATACLASSIFICATION::SystemMetadata);
          end;
        until TempAPIWebhookNotificationAggr.Next = 0;
        TempAPIWebhookNotificationAggr.DeleteAll;
    end;

    local procedure DeleteInactiveJobs()
    var
        JobQueueEntry: Record "Job Queue Entry";
    begin
        OnBeforeDeleteInactiveJobs;
        JobQueueEntry.SetRange("Object Type to Run",JobQueueEntry."Object Type to Run"::Codeunit);
        JobQueueEntry.SetRange("Object ID to Run",CODEUNIT::"API Webhook Notification Send");
        JobQueueEntry.SetFilter(Status,'<>%1&<>%2',JobQueueEntry.Status::"In Process",JobQueueEntry.Status::Ready);
        if JobQueueEntry.FindSet then
          repeat
            if JobQueueEntry.Delete(true) then ;
          until JobQueueEntry.Next = 0;

        JobQueueEntry.SetRange(Status,JobQueueEntry.Status::Ready);
        if JobQueueEntry.FindSet then
          repeat
            if (JobQueueEntry."Job Queue Category Code" <> JobQueueCategoryCodeLbl) or JobQueueEntry."Recurring Job" then begin
              if JobQueueEntry.Delete(true) then ;
            end else begin
              JobQueueEntry.CalcFields(Scheduled);
              if not JobQueueEntry.Scheduled then
                if JobQueueEntry.Delete(true) then ;
            end;
          until JobQueueEntry.Next = 0;
    end;

    local procedure ClearFiltersFromNotificationsBuffer()
    begin
        TempAPIWebhookNotificationAggr.SetRange("Subscription ID");
        TempAPIWebhookNotificationAggr.SetRange("Entity Key Value");
        TempAPIWebhookNotificationAggr.SetRange("Attempt No.");
    end;

    local procedure ClearFiltersFromSubscriptionsBuffer()
    begin
        TempAPIWebhookSubscription.SetRange("Subscription Id");
    end;

    local procedure IsApiSubscriptionEnabled(): Boolean
    var
        GraphMgtGeneralTools: Codeunit "Graph Mgt - General Tools";
    begin
        exit(GraphMgtGeneralTools.IsApiSubscriptionEnabled);
    end;

    local procedure GetMaxNumberOfNotifications(): Integer
    var
        ServerConfigSettingHandler: Codeunit "Server Config. Setting Handler";
        Handled: Boolean;
        MaxNumberOfNotifications: Integer;
    begin
        OnGetMaxNumberOfNotifications(Handled,MaxNumberOfNotifications);
        if Handled then
          exit(MaxNumberOfNotifications);

        MaxNumberOfNotifications := ServerConfigSettingHandler.GetApiSubscriptionMaxNumberOfNotifications;
        exit(MaxNumberOfNotifications);
    end;

    local procedure GetMaxNumberOfAttempts(): Integer
    var
        Handled: Boolean;
        Value: Integer;
    begin
        OnGetMaxNumberOfAttempts(Handled,Value);
        if Handled then
          exit(Value);

        exit(5);
    end;

    local procedure GetSendingNotificationTimeout(): Integer
    var
        ServerConfigSettingHandler: Codeunit "Server Config. Setting Handler";
        Handled: Boolean;
        Timeout: Integer;
    begin
        OnGetSendingNotificationTimeout(Handled,Timeout);
        if Handled then
          exit(Timeout);

        Timeout := ServerConfigSettingHandler.GetApiSubscriptionSendingNotificationTimeout;
        exit(Timeout);
    end;

    local procedure GetDelayTimeForAttempt(AttemptNumber: Integer): Integer
    begin
        case AttemptNumber of
          0,1,2:
            exit(60000);
          3:
            exit(600000);
          4:
            exit(6000000);
          else
            exit(60000000);
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeProcessNotifications()
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterProcessNotifications()
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeDeleteInactiveJobs()
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeSendNotification(NotificationUrl: Text;Payload: Text)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterSendNotification(var ErrorMessage: Text;var ErrorDetails: Text;var HttpStatusCode: DotNet HttpStatusCode)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnGetMaxNumberOfNotifications(var Handled: Boolean;var Value: Integer)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnGetMaxNumberOfAttempts(var Handled: Boolean;var Value: Integer)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnGetSendingNotificationTimeout(var Handled: Boolean;var Value: Integer)
    begin
    end;
}

