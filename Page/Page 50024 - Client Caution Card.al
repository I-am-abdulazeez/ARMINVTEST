page 50024 "Client Caution Card"
{
    DeleteAllowed = false;
    PageType = Card;
    SourceTable = "Client Cautions";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Caution No";"Caution No")
                {
                }
                field("Account No";"Account No")
                {
                    Editable = IsEditable;
                }
                field("Client ID";"Client ID")
                {
                    Editable = IsEditable;
                }
                field("Caution Type";"Caution Type")
                {
                    Editable = IsEditable;
                }
                field(Description;Description)
                {
                }
                field("Cause Code";"Cause Code")
                {
                    Editable = IsEditable;
                }
                field("Cause Description";"Cause Description")
                {
                    Editable = IsEditable;
                }
                field("Resolution code";"Resolution code")
                {
                }
                field(Resolution;Resolution)
                {
                }
                field("Restriction Type";"Restriction Type")
                {
                    Editable = IsEditable;
                }
                field(Status;Status)
                {
                }
                field("Document Link";"Document Link")
                {
                }
                field("Closure Document Link";"Closure Document Link")
                {
                }
            }
            part(Control13;"Caution Comments")
            {
                SubPageLink = "Caution No"=FIELD("Caution No");
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
                    TestField("Client ID");
                    TestField("Caution Type");

                    if "Document Link"='' then
                      Error('You must attach an evidence');
                    if not Confirm('Are you sure you want to send this caution for verification?') then
                      Error('');
                    Status:=Status::"Pending Verification";
                    Modify;
                    Message('Caution Sent successfully');
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
                    if not Confirm('Are you sure you want to verify this caution?') then
                      Error('');
                    Status:=Status::Verified;
                    Modify;
                    Message('Caution verified successfully');
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
                      Error('You must attach an Closure document');
                    if not Confirm('Are you sure you want to close this caution?') then
                      Error('');
                    "Request for closure":=true;
                    Modify;
                    Message('Request to close Caution sent successfully');
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
                    "Document Link":=SharepointIntegration.SaveFileonsharepoint("Caution No",'Caution',"Client ID");
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
                    "Closure Document Link":=SharepointIntegration.SaveFileonsharepoint("Caution No",'Caution',"Client ID");
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
                    if not Confirm('Are you sure you want to close this caution?') then
                      Error('');
                    Status:=Status::Closed;
                    Modify;
                    Message('Caution closed successfully');
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        setactions
    end;

    trigger OnOpenPage()
    begin
        setactions
    end;

    var
        showlogged: Boolean;
        showpending: Boolean;
        showclose: Boolean;
        showclosed: Boolean;
        IsEditable: Boolean;

    local procedure setactions()
    begin
        if Status= Status::Logged then begin
          showlogged:=true;
          showpending:=false;
          showclose:=false;
          showclosed:=false;
          IsEditable := true;
        end else if Status= Status::"Pending Verification" then begin
          showlogged:=false;
          showpending:=true;
          showclose:=false;
          showclosed:=false;
          IsEditable := false;
        end else if Status= Status::Verified then begin
          showlogged:=false;
          showpending:=false;
          showclose:=true;
            showclosed:=false;
            IsEditable := false;
        if "Request for closure" then begin
           showlogged:=false;
          showpending:=false;
          showclose:=false;
          showclosed:=true;
          IsEditable := false;
        end
        end
    end;
}

