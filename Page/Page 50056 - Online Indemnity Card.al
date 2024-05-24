page 50056 "Online Indemnity Card"
{
    PageType = Card;
    SourceTable = "Online Indemnity Mandate";

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
                field("Account No";"Account No")
                {
                }
                field("Client ID";"Client ID")
                {
                    Editable = false;
                }
                field("Fund Code";"Fund Code")
                {
                    Editable = false;
                }
                field("Sub Fund Code";"Sub Fund Code")
                {
                    Editable = false;
                }
                field("Client Name";"Client Name")
                {
                }
                field("Bank Code";"Bank Code")
                {
                    Editable = false;
                }
                field("Bank Branch Code";"Bank Branch Code")
                {
                    Editable = false;
                }
                field("Bank Account Name";"Bank Account Name")
                {
                    Editable = false;
                }
                field("Bank Account Number";"Bank Account Number")
                {
                    Editable = false;
                }
                field(Status;Status)
                {
                }
                field("Document Link";"Document Link")
                {
                    Editable = false;
                }
                field(Comments;Comments)
                {
                }
            }
            group("External Registrar")
            {
                field("Registrar Control ID";"Registrar Control ID")
                {
                    Editable = false;
                }
                field("Registrar Comments";"Registrar Comments")
                {
                    Editable = false;
                }
                field(SignatureStatus;SignatureStatus)
                {
                    Editable = false;
                }
                field(AdditionalComments;AdditionalComments)
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Send to ARM Registrar")
            {
                Image = MoveToNextPeriod;
                Promoted = true;
                PromotedIsBig = true;
                Visible = ShowReceived;

                trigger OnAction()
                var
                    FundAdministration: Codeunit "Fund Administration";
                    Statusoptions: Option Received,"ARM Registrar","External Registrar","Verification Successful","Verification Rejected",Cancelled;
                begin
                    TestField("Account No");
                    if "Document Link"='' then
                      Error('Please attach a document');;
                    FundAdministration.ChangeOnlineIndemnityStatusSingle(Statusoptions::Received,Statusoptions::"ARM Registrar",Rec);
                end;
            }
            action("Send to  Ext Registrar/Verified")
            {
                Image = MoveToNextPeriod;
                Promoted = true;
                PromotedIsBig = true;
                Visible = ShowARM;

                trigger OnAction()
                var
                    FundAdministration: Codeunit "Fund Administration";
                    Statusoptions: Option Received,"ARM Registrar","External Registrar","Verification Successful","Verification Rejected",Cancelled;
                begin
                    FundAdministration.ChangeOnlineIndemnityStatusSingle(Statusoptions::"ARM Registrar",Statusoptions::"External Registrar",Rec);
                end;
            }
            action(Reject)
            {
                Image = Reject;
                Promoted = true;
                PromotedIsBig = true;
                Visible = ShowARM;

                trigger OnAction()
                var
                    FundAdministration: Codeunit "Fund Administration";
                    Statusoptions: Option Received,"ARM Registrar","External Registrar","Verification Successful","Verification Rejected",Cancelled;
                begin
                    FundAdministration.ChangeOnlineIndemnityStatusSingle(Statusoptions::"ARM Registrar",Statusoptions::"Verification Rejected",Rec);
                end;
            }
            action(Verified)
            {
                Image = MoveToNextPeriod;
                Promoted = true;
                PromotedIsBig = true;
                Visible = ShowExt;

                trigger OnAction()
                var
                    FundAdministration: Codeunit "Fund Administration";
                    Statusoptions: Option Received,"ARM Registrar","External Registrar","Verification Successful","Verification Rejected",Cancelled;
                begin
                    FundAdministration.ChangeOnlineIndemnityStatusSingle(Statusoptions::"External Registrar",Statusoptions::"Verification Successful",Rec);
                end;
            }
            action(Rejected)
            {
                Image = Reject;
                Promoted = true;
                PromotedIsBig = true;
                Visible = ShowExt;

                trigger OnAction()
                var
                    FundAdministration: Codeunit "Fund Administration";
                    Statusoptions: Option Received,"ARM Registrar","External Registrar","Verification Successful","Verification Rejected",Cancelled;
                begin
                    FundAdministration.ChangeOnlineIndemnityStatusSingle(Statusoptions::"External Registrar",Statusoptions::"Verification Rejected",Rec);
                end;
            }
            action("Record History")
            {
                Image = History;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    FundAdministration: Codeunit "Fund Administration";
                    Statusoptions: Option Received,"ARM Registrar","Logged on Bank Platform","Approved By Bank","Rejected By Bank",Cancelled,"Batch ID Generated","Mandate Cancelled","Update Direct Debit","Sent letter to Bank","Received Response From Bank";
                begin
                    FundAdministration.ViewOnlineIndemnityTracker(Rec.No);
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
                    SharepointIntegration.SaveIndemnityonsharepoint (No,'Online_Indemnity',"Client ID",Rec);
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
                    ClientAdministration.ViewKYCLinks("Client ID");
                end;
            }
            action("Update Bank Details")
            {
                Image = UpdateDescription;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    if Client.Get("Client ID") then begin
                      Rec."Bank Code":=Client."Bank Code";
                      Rec."Bank Account Number":=Client."Bank Account Number";
                      Rec."Bank Account Name":=Client."Bank Account Name";
                      Modify;
                      Message('Update Complete');

                    end else Error ('Membership ID ' + "Client ID" + ' not on CLIENT Table')

                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        if (Status=Status::Received) or (Status=Status::"Verification Rejected") then begin
          ShowReceived:=true;
          ShowARM:=false;
          ShowExt:=false;
          Showverified:=false;
        end else if Status=Status::"ARM Registrar" then begin
          ShowReceived:=false;
          ShowARM:=true;
          ShowExt:=false;
          Showverified:=false;
        end else if Status=Status::"External Registrar" then begin
        ShowReceived:=false;
          ShowARM:=false;
          ShowExt:=true;
          Showverified:=false;
        end else if Status=Status::"Verification Successful" then begin
          ShowReceived:=false;
          ShowARM:=false;
          ShowExt:=false;
          Showverified:=true;
        end else begin

        end
    end;

    trigger OnOpenPage()
    begin
        if (Status=Status::Received) or (Status=Status::"Verification Rejected") then begin
          ShowReceived:=true;
          ShowARM:=false;
          ShowExt:=false;
          Showverified:=false;
        end else if Status=Status::"ARM Registrar" then begin
          ShowReceived:=false;
          ShowARM:=true;
          ShowExt:=false;
          Showverified:=false;
        end else if Status=Status::"External Registrar" then begin
        ShowReceived:=false;
          ShowARM:=false;
          ShowExt:=true;
          Showverified:=false;
        end else if Status=Status::"Verification Successful" then begin
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
        Client: Record Client;
}

