page 50238 "MF Income Register"
{
    // version MFD-1.0

    DeleteAllowed = false;
    PageType = List;
    SourceTable = "Income Register";
    SourceTableView = WHERE(Distributed=CONST(false),
                            "Fund ID"=FILTER(<>'ARMMMF'));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Value Date";"Value Date")
                {
                }
                field("Expected Payment Date";"Expected Payment Date")
                {
                }
                field("Fund ID";"Fund ID")
                {
                }
                field("Fund Name";"Fund Name")
                {
                }
                field("Total Income";"Total Income")
                {
                }
                field("Total Expenses";"Total Expenses")
                {
                }
                field("Distributed Income";"Distributed Income")
                {
                }
                field("Earnings Per Unit";"Earnings Per Unit")
                {
                }
                field(Distributed;Distributed)
                {
                    Editable = false;
                }
                field(Processed;Processed)
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Distribute Income")
            {
                Image = GetEntries;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    TestField(Distributed,false);
                    FundProcessing.DistributeMFIncomeNew(Rec);
                    IncomeReg.Reset;
                    IncomeReg.SetRange("Value Date","Value Date");
                    IncomeReg.SetRange("Fund ID","Fund ID");
                    IncomeReg.SetRange(Distributed,false);
                    if IncomeReg.FindFirst then begin
                      IncomeReg.Distributed := true;
                      IncomeReg.Modify;
                      end;
                      if IncomeReg."Fund ID" <> 'ARMMMF' then begin
                        FundTransMgt.SendMutualFundNomineeDividend(Rec."Value Date",Rec."Fund ID",Rec."WHT Rate",Rec."Expected Payment Date");
                      end;
                    Message('Income distribution completed successfully');
                end;
            }
            action("View Distributed Income")
            {
                Image = ViewWorksheet;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    FundProcessing.ViewMFDistributedIncome(Rec);
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

