report 115 "Salesperson - Commission"
{
    // version NAVW113.01

    DefaultLayout = RDLC;
    RDLCLayout = './Salesperson - Commission.rdlc';
    ApplicationArea = #Suite;
    Caption = 'Salesperson - Commission';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Salesperson/Purchaser";"Salesperson/Purchaser")
        {
            DataItemTableView = SORTING(Code);
            PrintOnlyIfDetail = true;
            RequestFilterFields = "Code";
            column(STRSUBSTNO_Text000_PeriodText_;StrSubstNo(Text000,PeriodText))
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(COMPANYNAME;COMPANYPROPERTY.DisplayName)
            {
            }
            column(Salesperson_Purchaser__TABLECAPTION__________SalespersonFilter;TableCaption + ': ' + SalespersonFilter)
            {
            }
            column(SalespersonFilter;SalespersonFilter)
            {
            }
            column(Cust__Ledger_Entry__TABLECAPTION__________CustLedgEntryFilter;"Cust. Ledger Entry".TableCaption + ': ' + CustLedgEntryFilter)
            {
            }
            column(CustLedgEntryFilter;CustLedgEntryFilter)
            {
            }
            column(PageGroupNo;PageGroupNo)
            {
            }
            column(Salesperson_Purchaser_Code;Code)
            {
            }
            column(Salesperson_Purchaser_Name;Name)
            {
            }
            column(Salesperson_Purchaser__Commission___;"Commission %")
            {
            }
            column(Cust__Ledger_Entry___Sales__LCY__;"Cust. Ledger Entry"."Sales (LCY)")
            {
            }
            column(Cust__Ledger_Entry___Profit__LCY__;"Cust. Ledger Entry"."Profit (LCY)")
            {
            }
            column(SalesCommissionAmt;SalesCommissionAmt)
            {
                AutoFormatType = 1;
            }
            column(ProfitCommissionAmt;ProfitCommissionAmt)
            {
                AutoFormatType = 1;
            }
            column(AdjProfit;AdjProfit)
            {
                AutoFormatType = 1;
            }
            column(AdjProfitCommissionAmt;AdjProfitCommissionAmt)
            {
                AutoFormatType = 1;
            }
            column(Salesperson___CommissionCaption;Salesperson___CommissionCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(All_amounts_are_in_LCYCaption;All_amounts_are_in_LCYCaptionLbl)
            {
            }
            column(Cust__Ledger_Entry__Posting_Date_Caption;Cust__Ledger_Entry__Posting_Date_CaptionLbl)
            {
            }
            column(Cust__Ledger_Entry__Document_No__Caption;"Cust. Ledger Entry".FieldCaption("Document No."))
            {
            }
            column(Cust__Ledger_Entry__Customer_No__Caption;"Cust. Ledger Entry".FieldCaption("Customer No."))
            {
            }
            column(Cust__Ledger_Entry__Sales__LCY__Caption;"Cust. Ledger Entry".FieldCaption("Sales (LCY)"))
            {
            }
            column(Cust__Ledger_Entry__Profit__LCY__Caption;"Cust. Ledger Entry".FieldCaption("Profit (LCY)"))
            {
            }
            column(SalesCommissionAmt_Control32Caption;SalesCommissionAmt_Control32CaptionLbl)
            {
            }
            column(ProfitCommissionAmt_Control33Caption;ProfitCommissionAmt_Control33CaptionLbl)
            {
            }
            column(AdjProfit_Control39Caption;AdjProfit_Control39CaptionLbl)
            {
            }
            column(AdjProfitCommissionAmt_Control45Caption;AdjProfitCommissionAmt_Control45CaptionLbl)
            {
            }
            column(Salesperson_Purchaser__Commission___Caption;FieldCaption("Commission %"))
            {
            }
            column(TotalCaption;TotalCaptionLbl)
            {
            }
            dataitem("Cust. Ledger Entry";"Cust. Ledger Entry")
            {
                DataItemLink = "Salesperson Code"=FIELD(Code);
                DataItemTableView = SORTING("Salesperson Code","Posting Date") WHERE("Document Type"=FILTER(Invoice|"Credit Memo"));
                RequestFilterFields = "Posting Date";
                column(Cust__Ledger_Entry__Posting_Date_;Format("Posting Date"))
                {
                }
                column(Cust__Ledger_Entry__Document_No__;"Document No.")
                {
                }
                column(Cust__Ledger_Entry__Customer_No__;"Customer No.")
                {
                }
                column(Cust__Ledger_Entry__Sales__LCY__;"Sales (LCY)")
                {
                }
                column(Cust__Ledger_Entry__Profit__LCY__;"Profit (LCY)")
                {
                }
                column(SalesCommissionAmt_Control32;SalesCommissionAmt)
                {
                    AutoFormatType = 1;
                }
                column(ProfitCommissionAmt_Control33;ProfitCommissionAmt)
                {
                    AutoFormatType = 1;
                }
                column(AdjProfit_Control39;AdjProfit)
                {
                    AutoFormatType = 1;
                }
                column(AdjProfitCommissionAmt_Control45;AdjProfitCommissionAmt)
                {
                    AutoFormatType = 1;
                }
                column(Salesperson_Purchaser__Name;"Salesperson/Purchaser".Name)
                {
                }

                trigger OnAfterGetRecord()
                var
                    CostCalcMgt: Codeunit "Cost Calculation Management";
                begin
                    SalesCommissionAmt := Round("Sales (LCY)" * "Salesperson/Purchaser"."Commission %" / 100);
                    ProfitCommissionAmt := Round("Profit (LCY)" * "Salesperson/Purchaser"."Commission %" / 100);
                    AdjProfit := "Sales (LCY)" + CostCalcMgt.CalcCustLedgActualCostLCY("Cust. Ledger Entry");
                    AdjProfitCommissionAmt := Round(AdjProfit * "Salesperson/Purchaser"."Commission %" / 100);
                end;

                trigger OnPreDataItem()
                begin
                    CurrReport.CreateTotals(
                      "Sales (LCY)","Profit (LCY)",AdjProfit,
                      ProfitCommissionAmt,AdjProfitCommissionAmt,SalesCommissionAmt);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if PrintOnlyOnePerPage then
                  PageGroupNo := PageGroupNo + 1;
            end;

            trigger OnPreDataItem()
            begin
                PageGroupNo := 1;

                CurrReport.NewPagePerRecord := PrintOnlyOnePerPage;
                CurrReport.CreateTotals(
                  "Cust. Ledger Entry"."Sales (LCY)","Cust. Ledger Entry"."Profit (LCY)",
                  AdjProfit,ProfitCommissionAmt,AdjProfitCommissionAmt,SalesCommissionAmt);
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(PrintOnlyOnePerPage;PrintOnlyOnePerPage)
                    {
                        ApplicationArea = Suite;
                        Caption = 'New Page per Person';
                        ToolTip = 'Specifies if each person''s information is printed on a new page if you have chosen two or more persons to be included in the report.';
                    }
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

    trigger OnPreReport()
    begin
        SalespersonFilter := "Salesperson/Purchaser".GetFilters;
        CustLedgEntryFilter := "Cust. Ledger Entry".GetFilters;
        PeriodText := "Cust. Ledger Entry".GetFilter("Posting Date");
    end;

    var
        Text000: Label 'Period: %1';
        SalespersonFilter: Text;
        CustLedgEntryFilter: Text;
        PeriodText: Text;
        AdjProfit: Decimal;
        ProfitCommissionAmt: Decimal;
        AdjProfitCommissionAmt: Decimal;
        SalesCommissionAmt: Decimal;
        PrintOnlyOnePerPage: Boolean;
        PageGroupNo: Integer;
        Salesperson___CommissionCaptionLbl: Label 'Salesperson - Commission';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        All_amounts_are_in_LCYCaptionLbl: Label 'All amounts are in LCY';
        Cust__Ledger_Entry__Posting_Date_CaptionLbl: Label 'Posting Date';
        SalesCommissionAmt_Control32CaptionLbl: Label 'Sales Commission (LCY)';
        ProfitCommissionAmt_Control33CaptionLbl: Label 'Profit Commission (LCY)';
        AdjProfit_Control39CaptionLbl: Label 'Adjusted Profit (LCY)';
        AdjProfitCommissionAmt_Control45CaptionLbl: Label 'Adjusted Profit Commission (LCY)';
        TotalCaptionLbl: Label 'Total';
}
