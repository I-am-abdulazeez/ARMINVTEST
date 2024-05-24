page 50263 "MFP Payout Card"
{
    // version MFD-1.0

    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Card;
    SourceTable = "MF Payment Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                field(No;No)
                {
                }
                field(Date;Date)
                {
                }
                field("Payment Date";"Payment Date")
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
                group("Dividend Mandate Summary")
                {
                    field("No of Payouts";"No of Payouts")
                    {
                    }
                    field("Total Payouts";"Total Payouts")
                    {
                    }
                    field("No of Re- invest";"No of Re- invest")
                    {
                    }
                    field("Total Re- invest";"Total Re- invest")
                    {
                    }
                    field("No Without Mandate";"No Without Mandate")
                    {
                    }
                    field("Total Without Mandate";"Total Without Mandate")
                    {
                    }
                }
            }
            part(Control8;"MFP Lines")
            {
                SubPageLink = "Header No"=FIELD(No);
                SubPageView = WHERE("Dividend Mandate"=CONST(Payout));
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
            action("Payout Schedule")
            {
                Image = ExportToBank;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Clear(MFPayoutSchedule);
                    MFHeader.Reset;
                    MFHeader.SetRange(No,No);
                    MFPayoutSchedule.SetTableView(MFHeader);
                    MFPayoutSchedule.RunModal;
                end;
            }
        }
    }

    var
        FundProcessing: Codeunit "Fund Processing";
        MFPayoutSchedule: Report "Mutual Fund Payout Schedule";
        MFHeader: Record "MF Payment Header";
}

