page 50096 "EOQ Card"
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
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Send for Verification")
            {
                Enabled = showIC;
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = showIC;

                trigger OnAction()
                begin
                    FundProcessing.VerifyEOQ(Rec);
                end;
            }
            action(Reject)
            {
                Enabled = showVerify;
                Image = Reject;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = showVerify;

                trigger OnAction()
                begin
                    FundProcessing.RejectEOQ(Rec);
                end;
            }
            action("Process Reinvestment")
            {
                Enabled = showreg;
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = showreg;

                trigger OnAction()
                begin
                    FundProcessing.SendEOQtoTreasury(Rec);
                end;
            }
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
            action("Export EOQ")
            {
                Image = Excel;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Clear(ExportEOQ);
                    ExportEOQ.Run;
                end;
            }
            action("Export Payout Schedule")
            {
                Image = ExportToBank;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = ShowReg;

                trigger OnAction()
                var
                    FundTransMgt: Codeunit "Fund Transaction Management";
                begin
                    FundTransMgt.ExportEOQDividendPayoutToTreasury;
                    Message('Schedule uploaded to treasury sharepoint folder');
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        if Status=Status::Generated then begin
          showIC:=true;
          showVerify:=false;
          ShowReg:=false;
        end else if Status=Status::"Internal Control"then begin
         showIC:=false;
          showVerify:=true;
          ShowReg:=false;
        end else if Status=Status::Verified then begin
          showIC:=false;
          showVerify:=false;
          ShowReg:=true;
        end else begin
          showIC:=false;
          showVerify:=false;
          ShowReg:=false;
        end
    end;

    var
        FundProcessing: Codeunit "Fund Processing";
        showVerify: Boolean;
        showIC: Boolean;
        ShowReg: Boolean;
        ExportEOQ: XMLport "Export EOQ";
}

