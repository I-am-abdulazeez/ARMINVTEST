page 6306 "Power BI Report FactBox"
{
    // version NAVW113.02

    Caption = 'Power BI Report';
    PageType = CardPart;

    layout
    {
        area(content)
        {
            group(Control3)
            {
                ShowCaption = false;
                Visible = NOT IsGettingStartedVisible AND NOT IsErrorMessageVisible AND HasReports;
                usercontrol(WebReportViewer;"Microsoft.Dynamics.Nav.Client.WebPageViewer")
                {
                    ApplicationArea = Basic,Suite;
                }
            }
            group(Control12)
            {
                //The GridLayout property is only supported on controls of type Grid
                //GridLayout = Columns;
                ShowCaption = false;
                group(Control11)
                {
                    ShowCaption = false;
                    group(Control10)
                    {
                        ShowCaption = false;
                        Visible = IsGettingStartedVisible;
                        field(GettingStarted;'Get started with Power BI')
                        {
                            ApplicationArea = Basic,Suite;
                            Editable = false;
                            ShowCaption = false;
                            Style = StrongAccent;
                            StyleExpr = TRUE;
                            ToolTip = 'Specifies the process of connecting to Power BI.';

                            trigger OnDrillDown()
                            begin
                                if not TryAzureAdMgtGetAccessToken then
                                  ShowErrorMessage(GetLastErrorText);

                                PowerBiServiceMgt.SelectDefaultReports;
                                LoadContent;
                            end;
                        }
                    }
                    group(Control8)
                    {
                        ShowCaption = false;
                        Visible = IsErrorMessageVisible;
                        field(ErrorMessageText;ErrorMessageText)
                        {
                            ApplicationArea = Basic,Suite;
                            MultiLine = true;
                            ShowCaption = false;
                            ToolTip = 'Specifies the error message from Power BI.';
                        }
                        field(ErrorUrlTextField;ErrorUrlText)
                        {
                            ApplicationArea = Basic,Suite;
                            ExtendedDatatype = URL;
                            ShowCaption = false;
                            ToolTip = 'Specifies the link that generated the error.';
                            Visible = IsUrlFieldVisible;
                        }
                        field(GetReportsLink;'Get reports')
                        {
                            ApplicationArea = All;
                            Editable = false;
                            ShowCaption = false;
                            Style = StrongAccent;
                            StyleExpr = TRUE;
                            ToolTip = 'Specifies the reports.';
                            Visible = IsGetReportsVisible;

                            trigger OnDrillDown()
                            begin
                                SelectReports;
                            end;
                        }
                    }
                    group(Control6)
                    {
                        ShowCaption = false;
                        Visible = NOT IsGettingStartedVisible AND NOT IsErrorMessageVisible AND NOT HasReports AND NOT IsDeployingReports;
                        field(EmptyMessage;'')
                        {
                            ApplicationArea = Basic,Suite;
                            Caption = 'There are no enabled reports. Choose Select Report to see a list of reports that you can display.';
                            Editable = false;
                            ShowCaption = false;
                            ToolTip = 'Specifies that the user needs to select Power BI reports.';
                            Visible = NOT IsDeployingReports;
                        }
                    }
                    group(Control22)
                    {
                        ShowCaption = false;
                        Visible = NOT IsDeploymentUnavailable AND IsDeployingReports AND NOT HasReports;
                        field(InProgressMessage;'')
                        {
                            ApplicationArea = All;
                            Caption = 'Power BI report deployment is in progress.';
                            ToolTip = 'Specifies that the page is deploying reports to Power BI.';
                        }
                    }
                    group(Control26)
                    {
                        ShowCaption = false;
                        Visible = IsDeploymentUnavailable AND NOT IsDeployingReports AND NOT HasReports;
                        field(ServiceUnavailableMessage;'')
                        {
                            ApplicationArea = All;
                            Caption = 'Power BI report deployment is currently unavailable.';
                            ToolTip = 'Specifies that the page cannot currently deploy reports to Power BI.';
                        }
                    }
                    group(Control21)
                    {
                        ShowCaption = false;
                        usercontrol(DeployTimer;"Microsoft.Dynamics.Nav.Client.PowerBIManagement")
                        {
                            ApplicationArea = All;
                            Visible = true;
                        }
                    }
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Select Report")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Select Report';
                Enabled = NOT IsGettingStartedVisible AND NOT IsErrorMessageVisible;
                Image = SelectChart;
                ToolTip = 'Select the report.';

                trigger OnAction()
                begin
                    SelectReports;
                end;
            }
            action("Expand Report")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Expand Report';
                Enabled = HasReports AND NOT IsErrorMessageVisible;
                Image = View;
                ToolTip = 'View all information in the report.';

                trigger OnAction()
                var
                    PowerBiReportDialog: Page "Power BI Report Dialog";
                begin
                    PowerBiReportDialog.SetUrl(GetEmbedUrlWithNavigationWithFilters,GetMessage);
                    PowerBiReportDialog.Caption(TempPowerBiReportBuffer.ReportName);
                    PowerBiReportDialog.SetFilter(messagefilter,reportfirstpage);
                    PowerBiReportDialog.Run;
                end;
            }
            action("Previous Report")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Previous Report';
                Enabled = HasReports AND NOT IsErrorMessageVisible;
                Image = PreviousSet;
                ToolTip = 'Go to the previous report.';

                trigger OnAction()
                begin
                    // need to reset filters or it would load the LastLoadedReport otherwise
                    TempPowerBiReportBuffer.Reset;
                    TempPowerBiReportBuffer.SetFilter(Enabled,'%1',true);
                    if TempPowerBiReportBuffer.Next(-1) = 0 then
                      TempPowerBiReportBuffer.FindLast;

                    if AddInReady then
                      CurrPage.WebReportViewer.Navigate(GetEmbedUrl);
                end;
            }
            action("Next Report")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Next Report';
                Enabled = HasReports AND NOT IsErrorMessageVisible;
                Image = NextSet;
                ToolTip = 'Go to the next report.';

                trigger OnAction()
                begin
                    // need to reset filters or it would load the LastLoadedReport otherwise
                    TempPowerBiReportBuffer.Reset;
                    TempPowerBiReportBuffer.SetFilter(Enabled,'%1',true);
                    if TempPowerBiReportBuffer.Next = 0 then
                      TempPowerBiReportBuffer.FindFirst;

                    if AddInReady then
                      CurrPage.WebReportViewer.Navigate(GetEmbedUrl);
                end;
            }
            action(Refresh)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Refresh Page';
                Enabled = NOT IsGettingStartedVisible;
                Image = Refresh;
                ToolTip = 'Refresh the visible content.';

                trigger OnAction()
                begin
                    RefreshPart;
                end;
            }
            action("Manage Report")
            {
                ApplicationArea = All;
                Caption = 'Manage Report';
                Enabled = HasReports AND NOT IsErrorMessageVisible;
                Image = PowerBI;
                ToolTip = 'Opens current selected report for edits.';
                Visible = IsSaaSUser;

                trigger OnAction()
                var
                    PowerBIManagement: Page "Power BI Management";
                begin
                    PowerBIManagement.SetTargetReport(LastOpenedReportID,GetEmbedUrl);
                    PowerBIManagement.LookupMode(true);
                    PowerBIManagement.Run;
                    RefreshPart;
                end;
            }
        }
    }

    trigger OnInit()
    begin
        // Variables used by PingPong timer when deploying default PBI reports.
        TimerDelay := 30000; // 30 seconds
        MaxTimerCount := (60000 / TimerDelay) * 5; // 5 minutes
        IsVisible := false;
    end;

    trigger OnOpenPage()
    begin
        if IsVisible then
          LoadFactBox
    end;

    var
        NoReportsAvailableErr: Label 'There are no reports available from Power BI.';
        PowerBIUserConfiguration: Record "Power BI User Configuration";
        TempPowerBiReportBuffer: Record "Power BI Report Buffer" temporary;
        PowerBiServiceMgt: Codeunit "Power BI Service Mgt.";
        AzureAdMgt: Codeunit "Azure AD Mgt.";
        ConfPersonalizationMgt: Codeunit "Conf./Personalization Mgt.";
        SetPowerBIUserConfig: Codeunit "Set Power BI User Config";
        ClientTypeManagement: Codeunit ClientTypeManagement;
        JObject: DotNet JObject;
        JObjecttemp: DotNet JObject;
        LastOpenedReportID: Guid;
        Context: Text[30];
        NameFilter: Text;
        IsGettingStartedVisible: Boolean;
        HasReports: Boolean;
        AddInReady: Boolean;
        IsErrorMessageVisible: Boolean;
        ErrorMessageText: Text;
        IsUrlFieldVisible: Boolean;
        IsGetReportsVisible: Boolean;
        ErrorUrlText: Text;
        CurrentListSelection: Text;
        reportLoadData: Text;
        IsValueInt: Boolean;
        ExceptionMessage: Text;
        ExceptionDetails: Text;
        messagefilter: Text;
        reportfirstpage: Text;
        TimerDelay: Integer;
        MaxTimerCount: Integer;
        CurrentTimerCount: Integer;
        IsDeployingReports: Boolean;
        IsDeploymentUnavailable: Boolean;
        IsTimerReady: Boolean;
        IsTimerActive: Boolean;
        IsSaaSUser: Boolean;
        IsLoaded: Boolean;
        IsVisible: Boolean;
        PowerBiTelemetryCategoryLbl: Label 'PowerBI', Locked=true;

    procedure SetCurrentListSelection(CurrentSelection: Text;IsValueIntInput: Boolean;PowerBIVisible: Boolean)
    begin
        if not PowerBIVisible then
          exit;
        // get the name of the selected element from the corresponding list of the parent page and filter the report
        CurrentListSelection := CurrentSelection;
        IsValueInt := IsValueIntInput;
        GetAndSetReportFilter(reportLoadData);
    end;

    local procedure GetMessage(): Text
    var
        HttpUtility: DotNet HttpUtility;
    begin
        exit(
          '{"action":"loadReport","accessToken":"' +
          HttpUtility.JavaScriptStringEncode(AzureAdMgt.GetAccessToken(
              PowerBiServiceMgt.GetPowerBiResourceUrl,PowerBiServiceMgt.GetPowerBiResourceName,false)) + '"}');
    end;

    local procedure GetEmbedUrl(): Text
    begin
        if TempPowerBiReportBuffer.IsEmpty then begin
          // Clear out last opened report if there are no reports to display.
          Clear(LastOpenedReportID);
          SetLastOpenedReportID(LastOpenedReportID);
        end else begin
          // update last loaded report
          SetLastOpenedReportID(TempPowerBiReportBuffer.ReportID);
          // Hides both filters and tabs for embedding in small spaces where navigation is unnecessary.
          exit(TempPowerBiReportBuffer.EmbedUrl + '&filterPaneEnabled=false&navContentPaneEnabled=false');
        end;
    end;

    local procedure LoadContent()
    begin
        // The end to end process for loading reports onscreen, or defaulting to an error state if that fails,
        // including deploying default reports in case they haven't been loaded yet. Called when first logging
        // into Power BI or any time the part has reloaded from scratch.
        if not TryLoadPart then
          ShowErrorMessage(GetLastErrorText);

        // Always call this after TryLoadPart. Since we can't modify record from TryFunction.
        PowerBiServiceMgt.UpdateEmbedUrlCache(TempPowerBiReportBuffer,Context);

        // Always call this function after calling TryLoadPart to log exceptions to ActivityLog table
        PowerBiServiceMgt.LogException(ExceptionMessage,ExceptionDetails);
        CurrPage.Update;

        DeployDefaultReports;
    end;

    local procedure LoadPart()
    begin
        IsGettingStartedVisible := not PowerBiServiceMgt.IsUserReadyForPowerBI;

        TempPowerBiReportBuffer.Reset;
        TempPowerBiReportBuffer.DeleteAll;
        if IsGettingStartedVisible then begin
          if AzureAdMgt.IsSaaS then
            Error(PowerBiServiceMgt.GetGenericError);

          TempPowerBiReportBuffer.Insert // Hack to display Get Started link.
        end else begin
          PowerBiServiceMgt.GetReportsForUserContext(TempPowerBiReportBuffer,ExceptionMessage,ExceptionDetails,Context);
          if not TempPowerBiReportBuffer.FindFirst then
            PowerBiServiceMgt.CheckForPowerBILicense(ExceptionMessage,ExceptionDetails);
          RefreshAvailableReports;
        end;
    end;

    local procedure RefreshAvailableReports()
    begin
        // Filters the report buffer to show the user's selected report onscreen if possible, otherwise defaulting
        // to other enabled reports.
        // (The updated selection will automatically get saved on render - can't save to database here without
        // triggering errors about calling MODIFY during a TryFunction.)

        TempPowerBiReportBuffer.Reset;
        TempPowerBiReportBuffer.SetFilter(Enabled,'%1',true);
        if not IsNullGuid(LastOpenedReportID) then begin
          TempPowerBiReportBuffer.SetFilter(ReportID,'%1',LastOpenedReportID);

          if TempPowerBiReportBuffer.IsEmpty then begin
            // If last selection is invalid, clear it and default to showing the first enabled report.
            Clear(LastOpenedReportID);
            RefreshAvailableReports;
          end;
        end;

        HasReports := TempPowerBiReportBuffer.FindFirst;
    end;

    local procedure RefreshPart()
    begin
        // Refreshes content by re-rendering the whole page part - removes any current error message text, and tries to
        // reload the user's list of reports, as if the page just loaded. Used by the Refresh button or when closing the
        // Select Reports page, to make sure we have the most up to date list of reports and aren't stuck in an error state.
        IsErrorMessageVisible := false;
        IsUrlFieldVisible := false;
        IsGetReportsVisible := false;

        IsDeployingReports := PowerBiServiceMgt.GetIsDeployingReports;
        IsDeploymentUnavailable := not PowerBiServiceMgt.IsPBIServiceAvailable;

        PowerBiServiceMgt.SelectDefaultReports;

        SetPowerBIUserConfig.CreateOrReadUserConfigEntry(PowerBIUserConfiguration,LastOpenedReportID,Context);
        LoadContent;

        if AddInReady then
          CurrPage.WebReportViewer.Navigate(GetEmbedUrl);
    end;

    [Scope('Personalization')]
    procedure SetContext(ParentContext: Text[30])
    begin
        // Sets an ID that tracks which page to show reports for - called by the parent page hosting the part,
        // if possible (see UpdateContext).
        Context := ParentContext;
    end;

    local procedure UpdateContext()
    var
        ConfPersonalizationMgt: Codeunit "Conf./Personalization Mgt.";
    begin
        // Automatically sets the parent page ID based on the user's selected role center (role centers can't
        // have codebehind, so they have no other way to set the context for their reports).
        if Context = '' then
          SetContext(ConfPersonalizationMgt.GetCurrentProfileIDNoError);
    end;

    [Scope('Personalization')]
    procedure SetNameFilter(ParentFilter: Text)
    begin
        // Sets a text value that tells the selection page how to filter the reports list. This should be called
        // by the parent page hosting this page part, if possible.
        NameFilter := ParentFilter;
    end;

    local procedure ShowErrorMessage(TextToShow: Text)
    begin
        // this condition checks if we caught the authorization error that contains a link to Power BI
        // the function divide the error message into simple text and url part
        if TextToShow = PowerBiServiceMgt.GetUnauthorizedErrorText then begin
          IsUrlFieldVisible := true;
          // this message is required to have ':' at the end, but it has '.' instead due to C/AL Localizability requirement
          TextToShow := DelStr(PowerBiServiceMgt.GetUnauthorizedErrorText,StrLen(PowerBiServiceMgt.GetUnauthorizedErrorText),1) + ':';
          ErrorUrlText := PowerBiServiceMgt.GetPowerBIUrl;
        end;

        IsGetReportsVisible := (TextToShow = NoReportsAvailableErr);

        IsErrorMessageVisible := true;
        IsGettingStartedVisible := false;
        TempPowerBiReportBuffer.DeleteAll; // Required to avoid one INSERT after another (that will lead to an error)
        if TextToShow = '' then
          TextToShow := PowerBiServiceMgt.GetGenericError;
        ErrorMessageText := TextToShow;
        TempPowerBiReportBuffer.Insert; // Hack to show the field with the text
        CurrPage.Update;
    end;

    [TryFunction]
    local procedure TryLoadPart()
    begin
        // Need the try function here to catch any possible internal errors
        LoadPart;
    end;

    [TryFunction]
    local procedure TryAzureAdMgtGetAccessToken()
    begin
        AzureAdMgt.GetAccessToken(PowerBiServiceMgt.GetPowerBiResourceUrl,PowerBiServiceMgt.GetPowerBiResourceName,true);
    end;

    local procedure SetReport()
    begin
        if (ClientTypeManagement.GetCurrentClientType <> CLIENTTYPE::Phone) and
           (ClientTypeManagement.GetCurrentClientType <> CLIENTTYPE::Windows)
        then
          CurrPage.WebReportViewer.InitializeIFrame('4:3');
        // subscribe to events
        CurrPage.WebReportViewer.SubscribeToEvent('message',GetEmbedUrl);
        CurrPage.WebReportViewer.Navigate(GetEmbedUrl);
    end;

    [Scope('Personalization')]
    procedure SetLastOpenedReportID(LastOpenedReportIDInput: Guid)
    begin
        // update the last loaded report field (the record at this point should already exist bacause it was created OnOpenPage)
        LastOpenedReportID := LastOpenedReportIDInput;
        PowerBIUserConfiguration.Reset;
        PowerBIUserConfiguration.SetFilter("Page ID",'%1',Context);
        PowerBIUserConfiguration.SetFilter("User Security ID",'%1',UserSecurityId);
        PowerBIUserConfiguration.SetFilter("Profile ID",'%1',ConfPersonalizationMgt.GetCurrentProfileIDNoError);
        if not PowerBIUserConfiguration.IsEmpty then begin
          PowerBIUserConfiguration."Selected Report ID" := LastOpenedReportID;
          PowerBIUserConfiguration.Modify;
          Commit;
        end;
    end;

    [Scope('Personalization')]
    procedure SetFactBoxVisibility(var VisibilityInput: Boolean)
    begin
        if VisibilityInput then
          VisibilityInput := false
        else
          VisibilityInput := true;

        PowerBIUserConfiguration.Reset;
        PowerBIUserConfiguration.SetFilter("Page ID",'%1',Context);
        PowerBIUserConfiguration.SetFilter("User Security ID",'%1',UserSecurityId);
        PowerBIUserConfiguration.SetFilter("Profile ID",'%1',ConfPersonalizationMgt.GetCurrentProfileIDNoError);
        if PowerBIUserConfiguration.FindFirst then begin
          PowerBIUserConfiguration."Report Visibility" := VisibilityInput;
          PowerBIUserConfiguration.Modify;
        end;
        if VisibilityInput and not IsLoaded then
          LoadFactBox
    end;

    procedure GetAndSetReportFilter(data: Text)
    begin
        if not TryGetAndSetReportFilter(data) then begin
          SendTraceTag('00007BR',PowerBiTelemetryCategoryLbl,
            VERBOSITY::Error,data + ' : ' + GetLastErrorText,DATACLASSIFICATION::SystemMetadata);
          exit;
        end
    end;

    local procedure GetEmbedUrlWithNavigationWithFilters(): Text
    begin
        // update last loaded report
        SetLastOpenedReportID(TempPowerBiReportBuffer.ReportID);
        // Shows filters and shows navigation tabs.
        exit(TempPowerBiReportBuffer.EmbedUrl);
    end;

    local procedure SelectReports()
    var
        PowerBIReportSelection: Page "Power BI Report Selection";
        EmbedUrl: Text;
        PrevNameFilter: Text;
    begin
        // Opens the report selection page, then updates the onscreen report depending on the user's
        // subsequent selection and enabled/disabled settings.
        PowerBIReportSelection.SetContext(Context);
        PrevNameFilter := NameFilter;
        if Context <> '' then begin
          NameFilter := PowerBiServiceMgt.GetFactboxFilterFromID(Context);
          if NameFilter = '' then
            NameFilter := PrevNameFilter;
        end;
        PowerBIReportSelection.SetNameFilter(NameFilter);
        PowerBIReportSelection.LookupMode(true);

        PowerBIReportSelection.RunModal;
        if PowerBIReportSelection.IsPageClosedOkay then begin
          PowerBIReportSelection.GetRecord(TempPowerBiReportBuffer);

          if TempPowerBiReportBuffer.Enabled then begin
            LastOpenedReportID := TempPowerBiReportBuffer.ReportID; // RefreshAvailableReports handles fallback logic on invalid selection.
            SetLastOpenedReportID(LastOpenedReportID); // Resolves bug to set last selected report
          end;

          RefreshPart;
          EmbedUrl := GetEmbedUrl;
          if AddInReady and (EmbedUrl <> '') then
            CurrPage.WebReportViewer.Navigate(GetEmbedUrl);
          // At this point, NAV will load the web page viewer since HasReports should be true. WebReportViewer::ControlAddInReady will then fire, calling Navigate()
        end;
    end;

    local procedure DeployDefaultReports()
    begin
        if not PowerBiServiceMgt.IsPowerBIDeploymentEnabled then
          exit;

        // Checks if there are any default reports the user needs to upload/select, and automatically begins
        // those processes. The page will refresh when the PingPong control runs later.
        DeleteMarkedReports;
        FinishPartialUploads;
        if not IsGettingStartedVisible and not IsErrorMessageVisible and AzureAdMgt.IsSaaS and
           PowerBiServiceMgt.UserNeedsToDeployReports and not PowerBiServiceMgt.IsUserDeployingReports
        then begin
          IsDeployingReports := true;
          PowerBiServiceMgt.UploadDefaultReportsInBackground;
          StartDeploymentTimer;
        end;
    end;

    local procedure FinishPartialUploads()
    begin
        // Checks if there are any default reports whose uploads only partially completed, and begins a
        // background process for those reports. The page will refresh when the PingPong control runs later.
        if not IsGettingStartedVisible and not IsErrorMessageVisible and AzureAdMgt.IsSaaS and
           PowerBiServiceMgt.UserNeedsToRetryUploads and not PowerBiServiceMgt.IsUserRetryingUploads
        then begin
          IsDeployingReports := true;
          PowerBiServiceMgt.RetryUnfinishedReportsInBackground;
          StartDeploymentTimer;
        end;
    end;

    local procedure DeleteMarkedReports()
    begin
        // Checks if there are any default reports that have been marked to be deleted on page 6321, and begins
        // a background process for those reports. The page will refresh when the timer control runs later.
        if not IsGettingStartedVisible and not IsErrorMessageVisible and AzureAdMgt.IsSaaS and
           PowerBiServiceMgt.UserNeedsToDeleteReports and not PowerBiServiceMgt.IsUserDeletingReports
        then begin
          IsDeployingReports := true;
          PowerBiServiceMgt.DeleteDefaultReportsInBackground;
          StartDeploymentTimer;
        end;
    end;

    local procedure StartDeploymentTimer()
    begin
        // Resets the timer for refreshing the page during OOB report deployment, if the add-in is
        // ready to go and the timer isn't already going. (This page doesn't deploy reports itself,
        // but it may be opened while another page is deploying reports that would show up here.)
        if IsTimerReady and not IsTimerActive then begin
          CurrentTimerCount := 0;
          IsTimerActive := true;
          CurrPage.DeployTimer.Ping(TimerDelay);
        end;
    end;

    procedure InitFactBox(PageId: Text[30];PageCaption: Text;var PowerBIVisible: Boolean)
    var
        PowerBIUserConfiguration: Record "Power BI User Configuration";
        SetPowerBIUserConfig: Codeunit "Set Power BI User Config";
    begin
        SetNameFilter(PageCaption);
        SetContext(PageId);
        PowerBIVisible := SetPowerBIUserConfig.SetUserConfig(PowerBIUserConfiguration,PageId);
        IsVisible := PowerBIVisible;
    end;

    local procedure LoadFactBox()
    begin
        UpdateContext;
        RefreshPart;
        IsSaaSUser := AzureAdMgt.IsSaaS;
        IsLoaded := true;
    end;

    [TryFunction]
    local procedure TryGetAndSetReportFilter(data: Text)
    var
        firstpage: Text;
    begin
        // get all pages of the report
        if StrPos(data,'reportPageLoaded') > 0 then begin
          CurrPage.WebReportViewer.PostMessage('{"method":"GET","url":"/report/pages","headers":{"id":"getpagesfromreport"}}','*',true);
          exit;
        end;

        // navigate to the first page of the report
        if StrPos(data,'getpagesfromreport') > 0 then begin
          JObject := JObject.Parse(data);
          JObject := JObject.GetValue('body');
          JObject := JObject.First; // get the first (by index) page of the report
          firstpage := Format(JObject.GetValue('name'));
          messagefilter := '{"method":"PUT","url":"/report/pages/active","headers":{"id":"setpage,' + firstpage +
            '"},"body": {"name":"' + firstpage + '","displayName": null}}';
          reportfirstpage := messagefilter;
          CurrPage.WebReportViewer.PostMessage(messagefilter,'*',true);
          exit;
        end;

        // find all filters on this page of the report
        if StrPos(data,'setpage') > 0 then begin
          JObject := JObject.Parse(data);
          JObject := JObject.GetValue('headers');
          firstpage := SelectStr(2,Format(JObject.GetValue('id')));
          // messagefilter := '{"method":"GET","url":"/report/pages/' + firstpage + '/filters","headers": {"id":"getfilters,' + firstpage + '"}}'; // page filters
          messagefilter := '{"method":"GET","url":"/report/filters","headers": {"id":"getfilters,' + firstpage + '"}}'; // report filters
          CurrPage.WebReportViewer.PostMessage(messagefilter,'*',true);
          exit;
        end;

        // change the filter value to the one received from the corresponding list (only for basic filters)
        if (StrPos(data,'getfilters') > 0) and (StrPos(data,'schema#basic') > 0) then begin
          reportLoadData := data; // save data for filter update on change of selected list element

          JObject := JObject.Parse(data);
          JObjecttemp := JObject.GetValue('headers');
          firstpage := SelectStr(2,Format(JObjecttemp.GetValue('id')));
          JObject := JObject.GetValue('body');
          // filter only if there is a filter in the report
          if JObject.Count > 0 then begin
            JObject := JObject.First;
            JObjecttemp := JObject.GetValue('target');

            messagefilter := '{"$schema":"' + Format(JObject.GetValue('$schema')) +
              '","target":{"table":"' + Format(JObjecttemp.GetValue('table')) + '","column":"' +
              Format(JObjecttemp.GetValue('column')) + '"},';
            // filter parameter can be string, then value should be in ""; or it can be an integer, then no "" are required
            if IsValueInt then
              messagefilter := messagefilter + '"operator":"In","values":[' + CurrentListSelection + ']}'
            else
              messagefilter := messagefilter + '"operator":"In","values":["' + CurrentListSelection + '"]}';

            messagefilter := '{"method": "PUT", "url": "/report/filters", "headers": {}, "body": [' +
              messagefilter + '] }';
            CurrPage.WebReportViewer.PostMessage(messagefilter,'*',true);
          end;

          exit;
        end;
    end;
}
