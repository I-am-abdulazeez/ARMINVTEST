page 50249 "Mutual Fund Payments"
{
    // version MFD-1.0

    DeleteAllowed = false;
    PageType = List;
    SourceTable = "Income Register";
    SourceTableView = WHERE(Distributed=CONST(true),
                            "Fund ID"=FILTER(<>'ARMMMF'));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Expected Payment Date";"Expected Payment Date")
                {
                }
                field("Fund ID";"Fund ID")
                {
                    Editable = false;
                }
                field("Fund Name";"Fund Name")
                {
                    Editable = false;
                }
                field(Paid;"MF Payment")
                {
                    Caption = 'Paid';
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Run Payment")
            {
                Image = Replan;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    FundProcessing.ProcessMFPayment(Rec);
                end;
            }
            action("View EOQ")
            {
                Image = ViewWorksheet;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                Visible = false;

                trigger OnAction()
                begin
                    //FundProcessing.ViewEOQ(Rec);
                end;
            }
            action("Close Quarter")
            {
                Image = ClosePeriod;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = false;

                trigger OnAction()
                begin
                    //FundProcessing.CloseQuarter(Rec);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
         Eod.Reset;
         if Eod.FindLast then
          Valuedate:=CalcDate('1D',Eod.Date);
          SetFilter("Value Date",'<=%1',Valuedate);
    end;

    var
        FundProcessing: Codeunit "Fund Processing";
        FundTransMgt: Codeunit "Fund Transaction Management";
        IncomeReg: Record "Income Register";
        Eod: Record "EOD Tracker";
        Valuedate: Date;
}

