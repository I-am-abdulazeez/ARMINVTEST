page 50105 "EOQ Reinvested Card"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Card;
    SourceTable = "EOQ Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                field(No;No)
                {
                }
                field(Quarter;Quarter)
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
            part(Control8;"EOQ Lines")
            {
                SubPageLink = "Header No"=FIELD(No);
                SubPageView = WHERE("Dividend Mandate"=CONST(Reinvest));
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
            action("Send Nominee Dividend")
            {
                Image = ApplyEntries;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    if not Confirm('Are you sure you want to reinvest for Portfolio Clients?') then
                      Error('');
                    FundTransMgt.SendNomineeEOQDividend(Rec.Date);
                end;
            }
        }
    }

    var
        FundProcessing: Codeunit "Fund Processing";
        FundTransMgt: Codeunit "Fund Transaction Management";
}

