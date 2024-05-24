page 50236 "Mass Unit Transfer Card"
{
    PageType = Card;
    SourceTable = "Fund Transfer Header";

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
                    Visible = false;
                }
                field("Transfer Type";"Transfer Type")
                {
                }
                field("Created By";"Created By")
                {
                }
                field("Creation Date";"Creation Date")
                {
                }
                field("Fund Transfer Status";"Fund Transfer Status")
                {
                }
                field("Document Link";"Document Link")
                {
                }
            }
            part("Fund Transfer Lines";"Mass Unit Transfer Lines")
            {
                SubPageLink = "Header No"=FIELD(No);
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Import Transaction")
            {
                Image = ImportExcel;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Clear(ImportFundTransfer);
                    ImportFundTransfer.GetHeader(Rec);
                    ImportFundTransfer.Run;
                end;
            }
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

                    if "Document Link"='' then
                        Error('Please attach a document');
                    FundAdministration.ChangeBulkFundTransferStatusBatch(Rec);
                end;
            }
            action("Send to External Reg /Verify")
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
                    //FundAdministration.ChangeFundTransferStatusSingle(Statusoptions::"ARM Registrar",Statusoptions::"External Registrar",Rec);
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
                    //FundAdministration.ChangeFundTransferStatusSingle(Statusoptions::"External Registrar",Statusoptions::Verified,Rec);
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
                    //FundTransactionManagement.PostSingleFundTransfer(Rec);
                end;
            }
            action("Record History")
            {
                Image = History;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = false;

                trigger OnAction()
                var
                    FundAdministration: Codeunit "Fund Administration";
                    Statusoptions: Option Received,"ARM Registrar","Logged on Bank Platform","Approved By Bank","Rejected By Bank",Cancelled,"Batch ID Generated","Mandate Cancelled","Update Direct Debit","Sent letter to Bank","Received Response From Bank";
                begin
                    //FundAdministration.ViewFundTransferTracker(Rec.No);
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
                     "Document Link":=SharepointIntegration.SaveFileonsharepoint(No,'UnitTransfer','');
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
                Visible = false;

                trigger OnAction()
                var
                    ClientAdministration: Codeunit "Client Administration";
                begin
                    //ClientAdministration.ViewKYCLinks("From Client ID");
                end;
            }
            action(Reject)
            {
                Image = Reject;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = false;

                trigger OnAction()
                var
                    FundAdministration: Codeunit "Fund Administration";
                    Statusoptions: Option Received,"ARM Registrar","External Registrar",Rejected,Verified,Posted;
                begin
                    // IF "Fund Transfer Status"="Fund Transfer Status"::"ARM Registrar" THEN
                    //  FundAdministration.ChangeFundTransferStatusSingle(Statusoptions::"External Registrar",Statusoptions::Rejected,Rec)
                    // ELSE IF "Fund Transfer Status"="Fund Transfer Status"::"External Registrar" THEN
                    //  FundAdministration.ChangeFundTransferStatusSingle(Statusoptions::"External Registrar",Statusoptions::Rejected,Rec)
                    // ELSE IF "Fund Transfer Status"="Fund Transfer Status"::Verified THEN
                    //  FundAdministration.ChangeFundTransferStatusSingle(Statusoptions::Verified,Statusoptions::Rejected,Rec)
                    // ELSE
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
        ImportFundTransfer: XMLport "Import Unit Transfer";
}

