page 1051 "Additional Fee Chart"
{
    // version NAVW113.00

    Caption = 'Additional Fee Visualization';
    PageType = CardPart;
    SourceTable = "Business Chart Buffer";

    layout
    {
        area(content)
        {
            group(Options)
            {
                Caption = 'Options';
                field(ChargePerLine;ChargePerLine)
                {
                    ApplicationArea = Suite;
                    Caption = 'Line Fee';
                    ToolTip = 'Specifies the additional fee for the line.';
                    Visible = ShowOptions;

                    trigger OnValidate()
                    begin
                        UpdateData;
                    end;
                }
                field(Currency;Currency)
                {
                    ApplicationArea = Suite;
                    Caption = 'Currency Code';
                    LookupPageID = Currencies;
                    TableRelation = Currency.Code;
                    ToolTip = 'Specifies the code for the currency that amounts are shown in.';

                    trigger OnValidate()
                    begin
                        UpdateData;
                    end;
                }
                field("Max. Remaining Amount";MaxRemAmount)
                {
                    ApplicationArea = Suite;
                    Caption = 'Max. Remaining Amount';
                    MinValue = 0;
                    ToolTip = 'Specifies the maximum amount that is displayed as remaining in the chart.';

                    trigger OnValidate()
                    begin
                        UpdateData;
                    end;
                }
            }
            group(Graph)
            {
                Caption = 'Graph';
                usercontrol(BusinessChart;"Microsoft.Dynamics.Nav.Client.BusinessChart")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        Update(CurrPage.BusinessChart);
    end;

    var
        ReminderLevel: Record "Reminder Level";
        TempSortingTable: Record "Sorting Table" temporary;
        ChargePerLine: Boolean;
        RemAmountTxt: Label 'Remaining Amount';
        Currency: Code[10];
        MaxRemAmount: Decimal;
        ShowOptions: Boolean;
        AddInIsReady: Boolean;

    [Scope('Personalization')]
    procedure SetViewMode(SetReminderLevel: Record "Reminder Level";SetChargePerLine: Boolean;SetShowOptions: Boolean)
    begin
        ReminderLevel := SetReminderLevel;
        ChargePerLine := SetChargePerLine;
        ShowOptions := SetShowOptions;
    end;

    procedure UpdateData()
    begin
        if not AddInIsReady then
          exit;

        TempSortingTable.UpdateData(Rec,ReminderLevel,ChargePerLine,Currency,RemAmountTxt,MaxRemAmount);
        Update(CurrPage.BusinessChart);
    end;
}

