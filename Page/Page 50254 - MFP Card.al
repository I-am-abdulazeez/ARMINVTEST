page 50254 "MFP Card"
{
    // version MFD-1.0

    DeleteAllowed = false;
    InsertAllowed = false;
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
                    Editable = false;
                }
                field("Payment Date";"Payment Date")
                {
                    Editable = false;
                }
                field(Date;Date)
                {
                    Editable = false;
                }
                field("Fund Code";"Fund Code")
                {
                    Editable = false;
                }
                field("Total Dividend Amount";"Total Dividend Amount")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Total Dividend Calculated";"Total Dividend Calculated")
                {
                    Editable = false;
                }
                field("No of Accounts";"No of Accounts")
                {
                    Editable = false;
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
                    field(Narration;Narration)
                    {
                    }
                }
            }
            part(Control8;"MFP Lines")
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
                    FundProcessing.VerifyMFP(Rec);
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
                    FundProcessing.RejectMFP(Rec);
                end;
            }
            action("Process Reinvestment")
            {
                Caption = 'Process Transactions';
                Enabled = showreg;
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = showreg;

                trigger OnAction()
                begin
                    //FundProcessing.SendMFPtoTreasury(Rec);
                    if Narration = '' then
                      Error('Please insert a narration before posting.');
                    FundProcessing.SendMFPtoTreasuryNew(Rec);
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
                    //FundProcessing.ViewEOQTracker(No);
                end;
            }
            action("Export EOQ")
            {
                Image = Excel;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = false;

                trigger OnAction()
                begin
                    // CLEAR(ExportEOQ);
                    // ExportEOQ.RUN;
                end;
            }
            action("Export Payout Schedule")
            {
                Image = ExportToBank;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = false;

                trigger OnAction()
                var
                    FundTransMgt: Codeunit "Fund Transaction Management";
                begin
                    // FundTransMgt.ExportEOQDividendPayoutToTreasury;
                    // MESSAGE('Schedule uploaded to treasury sharepoint folder');
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

