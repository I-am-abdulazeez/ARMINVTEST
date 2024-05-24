page 50116 "Lien Card"
{
    DeleteAllowed = false;
    PageType = Card;
    SourceTable = "Account Liens";

    layout
    {
        area(content)
        {
            group(General)
            {
                Editable = Iseditable;
                field("Lien No";"Lien No")
                {
                    Editable = false;
                }
                field(Description;Description)
                {
                }
                field("Account No";"Account No")
                {
                    Editable = Edit;
                    ShowMandatory = true;
                }
                field("CLient ID";"CLient ID")
                {
                }
                field("Client Name";"Client Name")
                {
                }
                field(status;status)
                {
                    Editable = false;
                }
                field(Amount;Amount)
                {
                    Editable = Edit;

                    trigger OnValidate()
                    begin
                        ClientAcct.Reset;
                        //ClientAcct.GET("Account No");
                        ClientAcct.SetRange("Account No","Account No");
                        if ClientAcct.FindFirst then begin
                          ClientAcct.CalcFields("No of Units");
                          NAV:=FundAdministration.GetNAV(Today,ClientAcct."Fund No",ClientAcct."No of Units");
                          if Amount > NAV then
                            Error('The lien amount is greater than the current client investment balance');
                        end;
                    end;
                }
                field("Document Link";"Document Link")
                {
                }
                field("Closure Document Link";"Closure Document Link")
                {
                }
                field(Comment;Comment)
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Send for Verification")
            {
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = showlogged;

                trigger OnAction()
                begin
                    TestField("Account No");
                    if "Document Link" = '' then
                      Error('Please, attach an evidence');
                    if not Confirm('Are you sure you want to send this Lien for verification?') then
                      Error('');
                    status := status::"Pending Verification";
                    Modify;
                    Message('Lien Sent successfully');
                end;
            }
            action(Verify)
            {
                Image = ReviewWorksheet;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = showpending;

                trigger OnAction()
                begin
                    if not Confirm('Are you sure you want to verify this Lien?') then
                      Error('');
                    status := status::Verified;
                    "Verified By" := UserId;
                    "Verified Date Time" := CurrentDateTime;
                    Modify;
                    Message('Lien verified successfully');
                end;
            }
            action("Send Closure Request")
            {
                Image = Close;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = showclose;

                trigger OnAction()
                begin
                    if "Closure Document Link"='' then
                      Error('Please, attach an Closure document');
                    if not Confirm('Are you sure you want to close this Lien?') then
                      Error('');
                    "Sent for Closure" := true;
                    Modify;
                    Message('Request to close lien sent successfully');
                end;
            }
            action("Attach Document")
            {
                Image = Attach;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = showlogged;

                trigger OnAction()
                var
                    SharepointIntegration: Codeunit "Sharepoint Integration";
                begin
                    if "Document Link"<>'' then
                      if not Confirm('There is an existing Document For this record. Do you Want to overwrite it?') then
                        Error('');
                    "Document Link":=SharepointIntegration.SaveFileonsharepoint("Lien No",'Lien',"CLient ID");
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
            action("Attach Closure Document")
            {
                Image = Attach;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = showclose;

                trigger OnAction()
                var
                    SharepointIntegration: Codeunit "Sharepoint Integration";
                begin
                    if "Closure Document Link"<>'' then
                      if not Confirm('There is an existing Document For this record. Do you Want to overwrite it?') then
                        Error('');
                    "Closure Document Link":=SharepointIntegration.SaveFileonsharepoint("Lien No",'Lien',"CLient ID");
                    Modify;
                end;
            }
            action("View Closure Document")
            {
                Image = Web;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    SharepointIntegration: Codeunit "Sharepoint Integration";
                begin
                    SharepointIntegration.ViewDocument("Closure Document Link");
                end;
            }
            action(Close)
            {
                Image = Close;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = showclosed;

                trigger OnAction()
                begin
                    if not Confirm('Are you sure you want to close this Lien?') then
                      Error('');
                    status := status::Closed;
                    Modify;
                    Message('Lien closed successfully');
                end;
            }
            action(Reject)
            {
                Image = Reject;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = ShowReject;

                trigger OnAction()
                var
                    FundAdministration: Codeunit "Fund Administration";
                    Statusoptions: Option Received,"ARM Registrar","External Registrar",Rejected,Verified,Posted;
                begin
                    //FundAdministration.ChangeRedemptionStatusSingle(Statusoptions::"ARM Registrar",Statusoptions::Rejected,Rec);
                    //TESTFIELD(Comment);
                     if not Confirm('Are you sure you want to reject this Lien request?') then
                      Error('');
                    if Comment = '' then
                      Error('Please, enter the reason for rejection in the comment field')
                    else begin
                      status := status::Rejected;
                      Modify;
                      Message('Lien rejected successfully');
                    end
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SetActions
    end;

    trigger OnOpenPage()
    begin
        SetActions;
        if status = status::Rejected then
          Iseditable := false
        else
          Iseditable := true;
        if status <> status::Logged then
          Edit := false
        else
          Edit := true
    end;

    var
        showlogged: Boolean;
        showpending: Boolean;
        showclose: Boolean;
        showclosed: Boolean;
        showReject: Boolean;
        Iseditable: Boolean;
        Edit: Boolean;
        NAV: Decimal;
        FundAdministration: Codeunit "Fund Administration";
        ClientAcct: Record "Client Account";

    local procedure SetActions()
    begin
        if status = status::Logged then begin
          showlogged:=true;
          showpending:=false;
          showclose:=false;
          showclosed:=false;
          showReject := false;
        end else if status = status::"Pending Verification" then begin
          showlogged:=false;
          showpending:=true;
          showclose:=false;
          showclosed:=false;
          showReject:=true;
        end else if status= status::Verified then begin
          showlogged:=false;
          showpending:=false;
          showclose:=true;
            showclosed:=false;
          if "Sent for Closure" then begin
             showlogged:=false;
            showpending:=false;
            showclose:=false;
            showclosed:=true;
          end
        end
    end;
}

