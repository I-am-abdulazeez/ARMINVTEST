page 432 "Reminder Levels"
{
    // version NAVW113.00

    Caption = 'Reminder Levels';
    DataCaptionFields = "Reminder Terms Code";
    PageType = List;
    SourceTable = "Reminder Level";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Reminder Terms Code";"Reminder Terms Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the reminder terms code for the reminder.';
                    Visible = ReminderTermsCodeVisible;
                }
                field("No.";"No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                }
                field("Grace Period";"Grace Period")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the length of the grace period for this reminder level.';
                }
                field("Due Date Calculation";"Due Date Calculation")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a formula that determines how to calculate the due date on the reminder.';
                }
                field("Calculate Interest";"Calculate Interest")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies whether interest should be calculated on the reminder lines.';
                }
                field("Additional Fee (LCY)";"Additional Fee (LCY)")
                {
                    ApplicationArea = Basic,Suite;
                    Enabled = AddFeeFieldsEnabled;
                    ToolTip = 'Specifies the amount of the additional fee in LCY that will be added on the reminder.';
                }
                field("Add. Fee per Line Amount (LCY)";"Add. Fee per Line Amount (LCY)")
                {
                    ApplicationArea = Basic,Suite;
                    Enabled = AddFeeFieldsEnabled;
                    ToolTip = 'Specifies the line amount of the additional fee.';
                }
                field("Add. Fee Calculation Type";"Add. Fee Calculation Type")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies how the additional fees are calculated.';

                    trigger OnValidate()
                    begin
                        CheckAddFeeCalcType;
                    end;
                }
                field("Add. Fee per Line Description";"Add. Fee per Line Description")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a description of the additional fee.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207;Links)
            {
                Visible = false;
            }
            systempart(Control1905767507;Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Level")
            {
                Caption = '&Level';
                Image = ReminderTerms;
                action(BeginningText)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Beginning Text';
                    Image = BeginningText;
                    RunObject = Page "Reminder Text";
                    RunPageLink = "Reminder Terms Code"=FIELD("Reminder Terms Code"),
                                  "Reminder Level"=FIELD("No."),
                                  Position=CONST(Beginning);
                    ToolTip = 'Define a beginning text for each reminder level. The text will then be printed on the reminder.';
                }
                action(EndingText)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Ending Text';
                    Image = EndingText;
                    RunObject = Page "Reminder Text";
                    RunPageLink = "Reminder Terms Code"=FIELD("Reminder Terms Code"),
                                  "Reminder Level"=FIELD("No."),
                                  Position=CONST(Ending);
                    ToolTip = 'Define an ending text for each reminder level. The text will then be printed on the reminder.';
                }
                separator(Separator21)
                {
                }
                action(Currencies)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Currencies';
                    Enabled = AddFeeFieldsEnabled;
                    Image = Currency;
                    RunObject = Page "Currencies for Reminder Level";
                    RunPageLink = "Reminder Terms Code"=FIELD("Reminder Terms Code"),
                                  "No."=FIELD("No.");
                    ToolTip = 'View or edit additional feed in additional currencies.';
                }
            }
            group(Setup)
            {
                Caption = 'Setup';
                action("Additional Fee")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Additional Fee';
                    Enabled = AddFeeSetupEnabled;
                    Image = SetupColumns;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Additional Fee Setup";
                    RunPageLink = "Charge Per Line"=CONST(false),
                                  "Reminder Terms Code"=FIELD("Reminder Terms Code"),
                                  "Reminder Level No."=FIELD("No.");
                    ToolTip = 'View or edit the fees that apply to late payments.';
                }
                action("Additional Fee per Line")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Additional Fee per Line';
                    Enabled = AddFeeSetupEnabled;
                    Image = SetupLines;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Additional Fee Setup";
                    RunPageLink = "Charge Per Line"=CONST(true),
                                  "Reminder Terms Code"=FIELD("Reminder Terms Code"),
                                  "Reminder Level No."=FIELD("No.");
                    ToolTip = 'View or edit the fees that apply to late payments.';
                }
                action("View Additional Fee Chart")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'View Additional Fee Chart';
                    Image = Forecast;
                    ToolTip = 'View additional fees in a chart.';
                    Visible = NOT IsSaaS;

                    trigger OnAction()
                    var
                        AddFeeChart: Page "Additional Fee Chart";
                    begin
                        if FileMgt.IsWebClient then
                          Error(ChartNotAvailableInWebErr,PRODUCTNAME.Short);

                        AddFeeChart.SetViewMode(Rec,false,true);
                        AddFeeChart.RunModal;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        CheckAddFeeCalcType;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        NewRecord;
    end;

    trigger OnOpenPage()
    begin
        ReminderTerms.SetFilter(Code,GetFilter("Reminder Terms Code"));
        ShowColumn := true;
        if ReminderTerms.FindFirst then begin
          ReminderTerms.SetRecFilter;
          if ReminderTerms.GetFilter(Code) = GetFilter("Reminder Terms Code") then
            ShowColumn := false;
        end;
        ReminderTermsCodeVisible := ShowColumn;
        IsSaaS := PermissionManager.SoftwareAsAService;
    end;

    var
        ReminderTerms: Record "Reminder Terms";
        FileMgt: Codeunit "File Management";
        PermissionManager: Codeunit "Permission Manager";
        ShowColumn: Boolean;
        [InDataSet]
        ReminderTermsCodeVisible: Boolean;
        AddFeeSetupEnabled: Boolean;
        AddFeeFieldsEnabled: Boolean;
        ChartNotAvailableInWebErr: Label 'The chart cannot be shown in the %1 Web client. To see the chart, use the %1 Windows client.', Comment='%1 - product name';
        IsSaaS: Boolean;

    local procedure CheckAddFeeCalcType()
    begin
        if "Add. Fee Calculation Type" = "Add. Fee Calculation Type"::Fixed then begin
          AddFeeSetupEnabled := false;
          AddFeeFieldsEnabled := true;
        end else begin
          AddFeeSetupEnabled := true;
          AddFeeFieldsEnabled := false;
        end;
    end;
}

