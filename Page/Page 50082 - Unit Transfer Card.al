page 50082 "Unit Transfer Card"
{
    PageType = Card;
    SourceTable = "Fund Transfer";

    layout
    {
        area(content)
        {
            group(General)
            {
                field(No;No)
                {
                }
                field("Value Date";"Value Date")
                {
                }
                field("Transaction Date";"Transaction Date")
                {
                }
                field(Type;Type)
                {
                }
                field("From Account No";"From Account No")
                {
                }
                field("From Client Name";"From Client Name")
                {
                }
                field(Remarks;Remarks)
                {
                }
                field("From Fund Code";"From Fund Code")
                {
                }
                field("From Client ID";"From Client ID")
                {
                }
                field("From Fund Sub Account";"From Fund Sub Account")
                {
                }
                field("To Account No";"To Account No")
                {
                }
                field("To Fund Code";"To Fund Code")
                {
                }
                field("To Client ID";"To Client ID")
                {
                }
                field("To Fund Sub Account";"To Fund Sub Account")
                {
                }
                field("To Client Name";"To Client Name")
                {
                }
                field("Fund Transfer Status";"Fund Transfer Status")
                {
                }
                field("Transfer Type";"Transfer Type")
                {
                }
                field("Document Link";"Document Link")
                {
                }
                field(Comments;Comments)
                {
                }
                field("Reason For Rejection";"Reason For Rejection")
                {
                }
            }
            group("Transfer Details")
            {
                field(Amount;Amount)
                {
                }
                field("Price Per Unit";"Price Per Unit")
                {
                }
                field("No. Of Units";"No. Of Units")
                {
                }
                field("Fee Amount";"Fee Amount")
                {
                }
                field("Fee Units";"Fee Units")
                {
                }
                field("To Price Per Unit";"To Price Per Unit")
                {
                }
                field("To No. Of Units";"To No. Of Units")
                {
                }
                field("Current Unit Balance";"Current Unit Balance")
                {
                }
                field("Unit Balance after Redmption";"Unit Balance after Redmption")
                {
                }
                field("Accrued Dividend";"Accrued Dividend")
                {
                }
                field("Net Amount Payable";"Net Amount Payable")
                {
                }
                field("Total Amount Payable";"Total Amount Payable")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Forward to ARM Registrar")
            {
                Image = MoveToNextPeriod;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = ShowReceived;

                trigger OnAction()
                var
                    FundAdministration: Codeunit "Fund Administration";
                    Statusoptions: Option Received,"ARM Registrar","External Registrar",Rejected,Verified,Posted;
                begin
                    if Amount=0 then Error('Please Input amount to transfer');
                    FundAdministration.ChangeFundTransferStatusSingle(Statusoptions::Received,Statusoptions::"ARM Registrar",Rec);
                end;
            }
            action("Send to Verified")
            {
                Image = MoveToNextPeriod;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = ShowARM;

                trigger OnAction()
                var
                    FundAdministration: Codeunit "Fund Administration";
                    Statusoptions: Option Received,"ARM Registrar","External Registrar",Rejected,Verified,Posted;
                begin
                    FundAdministration.ChangeFundTransferStatusSingle(Statusoptions::"ARM Registrar",Statusoptions::"External Registrar",Rec);
                end;
            }
            action("Verified By External Registrar")
            {
                Image = MoveToNextPeriod;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = ShowExt;

                trigger OnAction()
                var
                    FundAdministration: Codeunit "Fund Administration";
                    Statusoptions: Option Received,"ARM Registrar","External Registrar",Rejected,Verified,Posted;
                begin
                    FundAdministration.ChangeFundTransferStatusSingle(Statusoptions::"External Registrar",Statusoptions::Verified,Rec);
                end;
            }
            action(Post)
            {
                Image = PostBatch;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = Showverified;

                trigger OnAction()
                var
                    FundTransactionManagement: Codeunit "Fund Transaction Management";
                    Statusoptions: Option Received,"ARM Registrar","External Registrar",Rejected,Verified,Posted;
                begin
                    FundTransactionManagement.PostSingleFundTransfer(Rec);
                end;
            }
            action("Record History")
            {
                Image = History;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    FundAdministration: Codeunit "Fund Administration";
                    Statusoptions: Option Received,"ARM Registrar","Logged on Bank Platform","Approved By Bank","Rejected By Bank",Cancelled,"Batch ID Generated","Mandate Cancelled","Update Direct Debit","Sent letter to Bank","Received Response From Bank";
                begin
                    FundAdministration.ViewFundTransferTracker(Rec.No);
                end;
            }
            action("Attach Document")
            {
                Image = Attach;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    SharepointIntegration: Codeunit "Sharepoint Integration";
                begin
                    if "Document Link"<>'' then
                      if not Confirm('There is an existing Document For this record. Do you Want to overwrite it?') then
                        Error('');
                    "Document Link":=SharepointIntegration.SaveFileonsharepoint(No,'UnitTransfer',"From Client ID");
                    Modify;
                end;
            }
            action("View Document")
            {
                Image = Web;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    SharepointIntegration: Codeunit "Sharepoint Integration";
                begin
                    SharepointIntegration.ViewDocument("Document Link");
                end;
            }
            action(AODS)
            {
                Image = DocInBrowser;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    ClientAdministration: Codeunit "Client Administration";
                begin
                    ClientAdministration.ViewKYCLinks("From Client ID");
                end;
            }
            action(Reject)
            {
                Image = Reject;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    FundAdministration: Codeunit "Fund Administration";
                    Statusoptions: Option Received,"ARM Registrar","External Registrar",Rejected,Verified,Posted;
                begin
                    TestField("Reason For Rejection");
                    if "Fund Transfer Status"="Fund Transfer Status"::"ARM Registrar" then
                      FundAdministration.ChangeFundTransferStatusSingle(Statusoptions::"External Registrar",Statusoptions::Rejected,Rec)
                    else if "Fund Transfer Status"="Fund Transfer Status"::"External Registrar" then
                      FundAdministration.ChangeFundTransferStatusSingle(Statusoptions::"External Registrar",Statusoptions::Rejected,Rec)
                    else if "Fund Transfer Status"="Fund Transfer Status"::Verified then
                      FundAdministration.ChangeFundTransferStatusSingle(Statusoptions::Verified,Statusoptions::Rejected,Rec)
                    else
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        if "Fund Transfer Status"="Fund Transfer Status"::Received then begin
          ShowReceived:=true;
          ShowARM:=false;
          ShowExt:=false;
          Showverified:=false;
        end else if "Fund Transfer Status"="Fund Transfer Status"::"ARM Registrar" then begin
          ShowReceived:=false;
          ShowARM:=true;
          ShowExt:=false;
          Showverified:=false;
        end else if "Fund Transfer Status"="Fund Transfer Status"::"External Registrar" then begin
        ShowReceived:=false;
          ShowARM:=false;
          ShowExt:=true;
          Showverified:=false;
        end else if "Fund Transfer Status"="Fund Transfer Status"::Verified then begin
          ShowReceived:=false;
          ShowARM:=false;
          ShowExt:=false;
          Showverified:=true;
        end else begin

        end
    end;

    var
        ShowReceived: Boolean;
        ShowARM: Boolean;
        ShowExt: Boolean;
        Showverified: Boolean;
}

