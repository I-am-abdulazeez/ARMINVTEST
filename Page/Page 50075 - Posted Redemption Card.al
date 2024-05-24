page 50075 "Posted Redemption Card"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = true;
    PageType = Card;
    SourceTable = "Posted Redemption";

    layout
    {
        area(content)
        {
            group(General)
            {
                Editable = IsEditable;
                field(No;No)
                {
                }
                field("Recon No";"Recon No")
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
                field("Client Name";"Client Name")
                {
                }
                field(Remarks;Remarks)
                {
                }
                field("Transaction Name";"Transaction Name")
                {
                }
                field("Client ID";"Client ID")
                {
                }
                field("Redemption Status";"Redemption Status")
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
                field("Redemption Type";"Redemption Type")
                {
                }
                field("Agent Code";"Agent Code")
                {
                }
                field("Online Indemnity Exist";"Online Indemnity Exist")
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
                field("Has Schedule?";"Has Schedule?")
                {
                }
            }
            group("Reversal Details")
            {
                Editable = OpenReversal;
                field("Reversal Status";"Reversal Status")
                {
                    Editable = false;
                }
                field("Rejection Reason";"Rejection Reason")
                {
                    Editable = ApproveReversal;
                }
                field("Reversal Document Link";"Reversal Document Link")
                {
                    Editable = false;
                }
                field(Reversed;Reversed)
                {
                    Editable = false;
                }
                field("Date Time reversed";"Date Time reversed")
                {
                    Editable = false;
                }
                field("Reversed By";"Reversed By")
                {
                    Editable = false;
                }
            }
            group("Redemption Details")
            {
                Editable = IsEditable;
                field("Fund Code";"Fund Code")
                {
                }
                field("Fund Name";"Fund Name")
                {
                }
                field("Fund Sub Account";"Fund Sub Account")
                {
                }
                field(Amount;Amount)
                {
                }
                field("Price Per Unit";"Price Per Unit")
                {
                }
                field("No. Of Units";"No. Of Units")
                {
                }
                field(Currency;Currency)
                {
                }
                field("Accrued Dividend Paid";"Accrued Dividend Paid")
                {
                }
                field("Total Amount Payable";"Total Amount Payable")
                {
                }
            }
            group(Payments)
            {
                Editable = IsEditable;
                field("Sent to Treasury";"Sent to Treasury")
                {
                }
                field("Date Sent to Treasury";"Date Sent to Treasury")
                {
                }
                field("Time Sent to Treasury";"Time Sent to Treasury")
                {
                }
                field("Processed By Bank";"Processed By Bank")
                {
                }
                field("Date Processed By Bank";"Date Processed By Bank")
                {
                }
                field("Time Processed By Bank";"Time Processed By Bank")
                {
                }
                field("Payment Status";"Payment Status")
                {
                }
                field("Payment Description";"Payment Description")
                {
                }
            }
            group("Buy back")
            {
                Visible = IsFailed;
                field("Buyback Subscription CaseNo";"Buyback Subscription CaseNo")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
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
                Visible = IsVisible;

                trigger OnAction()
                var
                    ClientAdministration: Codeunit "Client Administration";
                begin
                    ClientAdministration.ViewKYCLinks("Client ID");
                end;
            }
            action(Reverse)
            {
                Image = ReverseLines;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = OpenReversal;

                trigger OnAction()
                begin
                    if "Reversal Document Link" = '' then
                      Error('Kindly upload a supporting document before sending to audit');
                    FundTransactionManagement.ValidateReversalValueDate(Rec."Fund Code");
                    FundTransactionManagement.SendRedemptionToAudit(Rec);
                end;
            }
            action("Mark As Completed")
            {
                Image = Completed;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = IsFailed;

                trigger OnAction()
                var
                    SharepointIntegration: Codeunit "Sharepoint Integration";
                    PostedRec: Record "Posted Redemption";
                begin
                    //FundAdministration.ChangeRedemptionStatusSingle(Statusoptions::Posted,Statusoptions::Completed,PostedRec);
                    if not Confirm('Are you sure this request has been bought back?') then
                      Error('');
                    
                    //Works without validating subscription
                    
                      /*IF "Buyback Subscription CaseNo" = '' THEN
                        ERROR('Please enter the Subscription Case No for this buy back')
                      ELSE
                        IF PostedRec.FINDFIRST THEN BEGIN
                          PostedRec.RESET;
                          BoughtBack := TRUE;
                          MODIFY;
                      END;
                      MESSAGE('Request has been moved to Treated Failed Redemption');*/
                    
                    //Validates the subscription code
                      if "Buyback Subscription CaseNo" = '' then
                        Error('Please enter the Subscription Case No for this buy back.');
                    
                      if "Buyback Subscription CaseNo" <> '' then begin
                        Subscription.SetFilter(No,"Buyback Subscription CaseNo");
                        if Subscription.FindFirst then begin
                            PostedRec.Reset;
                            BoughtBack := true;
                            Modify;
                            Message('This request has been moved to Treated Failed Redemptions')
                        end
                      else begin
                        PostedSubscription.SetFilter(No,"Buyback Subscription CaseNo");
                        if PostedSubscription.FindFirst then begin
                            PostedRec.Reset;
                            BoughtBack := true;
                            Modify;
                            Message('This request has been moved to Treated Failed Redemptions')
                        end
                    else
                        Error('This Case No %1 does not exist. Please kindly confirm.', "Buyback Subscription CaseNo")
                     end
                     end

                end;
            }
            action("Attach Document")
            {
                Image = Attach;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = OpenReversal;

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
            action("View Reversal Document")
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
                    FundTransactionManagement.ApproveRedemptionReversal(Rec);
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
                    FundTransactionManagement.RejectRedemptionReversal(Rec);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        if "Has Schedule?"  then
          showLines:= true
        else
          showLines:= false;
    end;

    trigger OnInit()
    begin
        IsVisible := false;
        ApproveReversal := false;
        OpenReversal := false;
    end;

    trigger OnOpenPage()
    begin
        // IF Reversed = TRUE THEN
        //  IsVisible := FALSE
        // ELSE
        // IsVisible := TRUE;
        if ("Reversal Status" = "Reversal Status"::" ") or ("Reversal Status" = "Reversal Status"::Rejected) then begin
          IsVisible := false;
          ApproveReversal := false;
          OpenReversal := true;
          end;

        if "Redemption Status" = PostedRedem."Redemption Status"::Posted then
          IsEditable := false
        else
          IsEditable := true;

        if "Bank Response Status" = PostedRedem."Bank Response Status"::Failed then
          IsFailed := true
        else
          IsFailed := false;

        if "Reversal Status" = "Reversal Status"::"Pending Reversal" then begin
          IsVisible := true;
          ApproveReversal := true;
          OpenReversal := true;
          end;
    end;

    var
        showLines: Boolean;
        FundTransactionManagement: Codeunit "Fund Transaction Management";
        IsFailed: Boolean;
        PostedRedem: Record "Posted Redemption";
        IsEditable: Boolean;
        Subscription: Record Subscription;
        PostedSubscription: Record "Posted Subscription";
        IsVisible: Boolean;
        ApproveReversal: Boolean;
        OpenReversal: Boolean;
}

