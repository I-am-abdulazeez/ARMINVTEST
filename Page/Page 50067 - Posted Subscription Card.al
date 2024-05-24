page 50067 "Posted Subscription Card"
{
    DeleteAllowed = false;
    Editable = true;
    InsertAllowed = false;
    ModifyAllowed = true;
    PageType = Card;
    SourceTable = "Posted Subscription";

    layout
    {
        area(content)
        {
            group(General)
            {
                Editable = false;
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
                field("Bank Account No";"Bank Account No")
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
                field(Posted;Posted)
                {
                }
                field("Date Posted";"Date Posted")
                {
                }
                field("Time Posted";"Time Posted")
                {
                }
                field("Posted By";"Posted By")
                {
                }
                field(Reversed;Reversed)
                {
                }
                field("Reversed By";"Reversed By")
                {
                }
                field("Date Time reversed";"Date Time reversed")
                {
                }
            }
            group("Reversal Details")
            {
                Caption = 'Reversal Details';
                field("Reversal Type";"Reversal Type")
                {
                    Editable = false;

                    trigger OnValidate()
                    begin
                          if "Reversal Type" = "Reversal Type"::Client then begin
                            ReverseClient:= true;
                            end;
                    end;
                }
                field("Reverse To Client";"Reverse To Client")
                {
                    Editable = OpenReversal;
                }
                field("Reversal Status";"Reversal Status")
                {
                    Editable = false;
                }
                field("Reversal Document Link";"Reversal Document Link")
                {
                    Editable = false;
                }
                field("Rejection Reason";"Rejection Reason")
                {
                }
            }
            group("Subscription Details")
            {
                Editable = false;
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
                field("Reference Code";"Reference Code")
                {
                }
                group(Amounts)
                {
                    Editable = false;
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
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Reverse)
            {
                Image = ReverseLines;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = IsVisible;

                trigger OnAction()
                var
                    Options: Text[50];
                    Selected: Integer;
                    Text001: Label ',Client,Fund';
                    Text002: Label 'What type of reversal do you want to perform?';
                begin
                    if "Reversal Document Link" = '' then
                       Error('Kindly upload a supporting document before sending to audit');
                    FundTransactionManagement.ValidateReversalValueDate(Rec."Fund Code");
                    Options := Text001;
                    Selected := DIALOG.StrMenu(Options, 1, Text002);
                    if Selected = 2 then begin
                      if "Reverse To Client" = '' then
                        Error('Select a client to reverse this transaction to');
                      FundTransactionManagement.SendSubscriptionToAuditClient(Rec,"Reverse To Client");
                    end else if Selected = 3 then begin
                      if "Reverse To Client" <> '' then
                        Error('Kindly confirm the reversal type before proceeding');
                     FundTransactionManagement.SendSubscriptionToAuditFund(Rec);
                      end else begin
                         Message('No option was selected');
                    end;
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
                     if "Reversal Document Link" <>'' then
                      if not Confirm('There is an existing Document For this record. Do you Want to overwrite it?') then
                        Error('');
                    "Reversal Document Link" :=SharepointIntegration.SaveFileonsharepoint("Account No",'Reversal',"Client ID");
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
                     SharepointIntegration.ViewDocument("Reversal Document Link");
                end;
            }
            action(Approve)
            {
                Image = Approve;
                Promoted = true;
                PromotedIsBig = true;
                Visible = ApproveReversal;

                trigger OnAction()
                begin
                    FundTransactionManagement.ApproveSubscriptionReversal(Rec);
                end;
            }
            action(Reject)
            {
                Image = Reject;
                Promoted = true;
                PromotedIsBig = true;
                Visible = ApproveReversal;

                trigger OnAction()
                begin
                    if "Rejection Reason" = '' then
                      Error('Kindly input a rejection reason before rejecting this reversal');
                    FundTransactionManagement.RejectSubscriptionReversal(Rec);
                end;
            }
        }
    }

    trigger OnInit()
    begin
        IsVisible := true;
        ApproveReversal := false;
        OpenReversal := false;
        ReverseClient := false;
    end;

    trigger OnOpenPage()
    begin
        if "Reversal Type"<> "Reversal Type"::Client then begin
          "Reverse To Client" := '';
        Modify;
        end;
        if Reversed = true then
          IsVisible := false
        else
        IsVisible := true;
        if "Reversal Status" = "Reversal Status"::"Pending Reversal" then begin
          IsVisible := false;
          ApproveReversal := true;
          end;
          if ("Reversal Status" = "Reversal Status"::" ") or ("Reversal Status" = "Reversal Status"::Rejected) then
            OpenReversal := true;
        
        /*IF "Unit Bal After Subscriptions" = "Unit Bal After Subscriptions"::"1" THEN BEGIN
          IsVisible := FALSE;
          ApproveReversal := TRUE;
          END;
          IF ("Unit Bal After Subscriptions" = "Unit Bal After Subscriptions"::"0") OR ("Unit Bal After Subscriptions" = "Unit Bal After Subscriptions"::"3") THEN
            OpenReversal := TRUE;
            */

    end;

    var
        FundTransactionManagement: Codeunit "Fund Transaction Management";
        IsVisible: Boolean;
        ApproveReversal: Boolean;
        OpenReversal: Boolean;
        ReverseClient: Boolean;
}

