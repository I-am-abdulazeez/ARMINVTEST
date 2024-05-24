page 50262 "MFP Process Payout Card"
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
                group("Dividend Mandate Summary")
                {
                    field("No of Payouts";"No of Payouts")
                    {
                    }
                    field("Total Payouts";"Total Payouts")
                    {
                    }
                }
            }
            part(Control8;"MFP Lines")
            {
                SubPageLink = "Header No"=FIELD(No),
                              "Dividend Mandate"=CONST(Payout);
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Process Payout")
            {
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    FundProcessing.InitiatePayout(Rec);
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

