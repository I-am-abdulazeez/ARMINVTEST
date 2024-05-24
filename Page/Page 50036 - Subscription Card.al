page 50036 "Subscription Card"
{
    DeleteAllowed = false;
    PageType = Card;
    SourceTable = Subscription;

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
                field("Account No";"Account No")
                {
                }
                field("Client ID";"Client ID")
                {
                }
                field("Client Name";"Client Name")
                {
                }
                field("Bank Code";"Bank Code")
                {
                }
                field("Received From";"Received From")
                {
                }
                field("On Behalf Of";"On Behalf Of")
                {
                }
                field(Remarks;Remarks)
                {
                }
                field("Street Address";"Street Address")
                {
                }
                field("E-mail";"E-mail")
                {
                }
                field("Phone No";"Phone No")
                {
                }
                field("Created By";"Created By")
                {
                }
                field("Document Link";"Document Link")
                {
                    Editable = false;
                }
                field("Creation Date";"Creation Date")
                {

                    trigger OnValidate()
                    begin
                        "Creation Date" := CurrentDateTime;
                    end;
                }
            }
            group("Subscription Details")
            {
                field("Fund Code";"Fund Code")
                {
                }
                field("Fund Sub Account";"Fund Sub Account")
                {
                }
                field("Subscription Status";"Subscription Status")
                {
                }
                field("Fund Name";"Fund Name")
                {
                }
                group(Amounts)
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
                    field("Payment Mode";"Payment Mode")
                    {
                    }
                }
                field("Cheque No";"Cheque No")
                {
                }
                field("Cheque Date";"Cheque Date")
                {
                }
                field("Cheque Type";"Cheque Type")
                {
                }
                field(Comments;Comments)
                {
                    MultiLine = true;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
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
                    "Document Link":=SharepointIntegration.SaveFileonsharepoint(No,'Subscription',"Client ID");
                    Modify;
                end;
            }
            action("Send for Confirmation")
            {
                Image = MoveToNextPeriod;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = ShowConfirm;

                trigger OnAction()
                var
                    FundAdministration: Codeunit "Fund Administration";
                    Statusoptions: Option Received,Confirmed,Posted;
                begin
                    TestField("Payment Mode");
                    FundAdministration.ChangeSubscriptionStatussingle(Statusoptions::Received,Statusoptions::Confirmed,Rec);
                end;
            }
            action(Post)
            {
                Image = MoveToNextPeriod;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = ShowPost;

                trigger OnAction()
                var
                    FundAdministration: Codeunit "Fund Administration";
                    Statusoptions: Option Received,Confirmed,Posted;
                begin
                    TestField("Payment Mode");
                    FundTransactionManagement.PostSingleSubscription(Rec);;
                end;
            }
            action(Reject)
            {
                Image = Reject;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = ShowPost;

                trigger OnAction()
                begin
                    FundTransactionManagement.UnmatchTransaction(Rec);
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
                    FundAdministration.ViewSubscriptionTracker(Rec.No);
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
        }
    }

    trigger OnAfterGetRecord()
    begin

        if "Subscription Status"="Subscription Status"::Received then begin
          ShowConfirm:=true;

          ShowPost:=false;
        end else begin
          ShowConfirm:=false;

          ShowPost:=true;
        end
    end;

    trigger OnOpenPage()
    begin

        if "Subscription Status"="Subscription Status"::Received then begin
          ShowConfirm:=true;

          ShowPost:=false;
        end else begin
          ShowConfirm:=false;

          ShowPost:=true;
        end
    end;

    var
        FileManagement: Codeunit "File Management";
        Tofilename: Text;
        ShowPost: Boolean;
        ShowConfirm: Boolean;
        FundTransactionManagement: Codeunit "Fund Transaction Management";
}

