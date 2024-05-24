page 50257 "MFP Process Payout"
{
    // version MFD-1.0

    CardPageID = "MFP Process Payout Card";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "MF Payment Header";
    SourceTableView = WHERE(Status=CONST("Sent to Treasury"));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(No;No)
                {
                }
                field("Payment Date";"Payment Date")
                {
                }
                field(Date;Date)
                {
                }
                field("Fund Code";"Fund Code")
                {
                }
                field("Total Dividend Amount";"Total Dividend Amount")
                {
                    Visible = false;
                }
                field("Total Dividend Calculated";"Total Dividend Calculated")
                {
                }
                field("No of Accounts";"No of Accounts")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(History)
            {
                Image = History;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    FundProcessing.ViewEOQTracker(No);
                end;
            }
        }
    }

    var
        FundProcessing: Codeunit "Fund Processing";
}

