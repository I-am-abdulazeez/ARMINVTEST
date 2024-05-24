page 50258 "MFP Verified"
{
    // version MFD-1.0

    CardPageID = "MFP Card";
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "MF Payment Header";
    SourceTableView = WHERE(Status=CONST(Verified));

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
        area(navigation)
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

