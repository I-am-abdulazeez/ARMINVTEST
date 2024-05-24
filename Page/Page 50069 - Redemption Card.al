page 50069 "Redemption Card"
{
    DeleteAllowed = false;
    PageType = Card;
    SourceTable = Redemption;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Transaction No";"Transaction No")
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
                    Editable = isreceived;
                    ShowMandatory = true;
                }
                field("Client Name";"Client Name")
                {
                }
                field(Remarks;Remarks)
                {
                    Editable = isreceived;
                }
                field("Transaction Name";"Transaction Name")
                {
                    Editable = isreceived;
                }
                field("Client ID";"Client ID")
                {
                }
                field("Redemption Status";"Redemption Status")
                {
                }
                field("Street Address";"Street Address")
                {
                    Editable = isreceived;
                }
                field("E-mail";"E-mail")
                {
                    Editable = isreceived;
                }
                field("Phone No";"Phone No")
                {
                    Editable = isreceived;
                }
                field("Redemption Type";"Redemption Type")
                {
                    Editable = isreceived;

                    trigger OnValidate()
                    begin
                        if "Redemption Type"="Redemption Type"::Full then
                         showdividend:=true
                        else
                        showdividend:=false;
                        CurrPage.Update(true);
                        CurrPage.Activate(true);
                    end;
                }
                field("Agent Code";"Agent Code")
                {
                    Editable = isreceived;
                }
                field("Online Indemnity Exist";"Online Indemnity Exist")
                {
                }
                field("Request Mode";"Request Mode")
                {
                    Editable = isreceived;
                }
                field("Ongoing Customer Update";"Ongoing Customer Update")
                {
                }
                field("Bank Code";"Bank Code")
                {
                }
                field("Bank Account No";"Bank Account No")
                {
                    Editable = isreceived;
                }
                field("Recon No";"Recon No")
                {
                    Editable = false;
                }
                field("Created By";"Created By")
                {
                }
                field("Creation Date";"Creation Date")
                {

                    trigger OnValidate()
                    begin
                        "Creation Date" := CurrentDateTime;
                    end;
                }
                field("Document Link";"Document Link")
                {
                }
                field(Comments;Comments)
                {
                }
            }
            group("Redemption Details")
            {
                Editable = isreceived;
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
                    ShowMandatory = true;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field("No. Of Units";"No. Of Units")
                {
                    ShowMandatory = true;
                }
                field("Price Per Unit";"Price Per Unit")
                {
                }
                field(Currency;Currency)
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
                    Enabled = showdividend;
                }
                field("Active Lien";"Active Lien")
                {
                }
                field("Total Amount Payable";"Total Amount Payable")
                {
                }
                field("Fee Amount";"Fee Amount")
                {
                }
                field("Fee Units";"Fee Units")
                {
                }
                field("Net Amount Payable";"Net Amount Payable")
                {
                    Editable = false;
                }
                field("Charges On Accrued Interest";"Charges On Accrued Interest")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Import Schedule")
            {
                Image = ImportExcel;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = showLines;

                trigger OnAction()
                begin
                    /*IF FundTransactionManagement.CheckifredempLinesExist(Rec) THEN
                      ERROR('Please delete the existing schedule lines before you can import again');
                    CLEAR(ImportRedemptionSchedule);
                    ImportRedemptionSchedule.Getheader("Transaction No");
                    ImportRedemptionSchedule.RUN;
                    */

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
                    Statusoptions: Option Received,"ARM Registrar","External Registrar",Rejected,Verified,Posted,"Customer Experience Verification";
                begin
                    if Rec."Redemption Status"=Rec."Redemption Status"::Received then
                    FundAdministration.ChangeRedemptionStatusSingle(Statusoptions::Received,Statusoptions::"ARM Registrar",Rec)
                    else  if Rec."Redemption Status"=Rec."Redemption Status"::"Customer Experience Verification" then
                    FundAdministration.ChangeRedemptionStatusSingle(Statusoptions::"Customer Experience Verification",Statusoptions::"ARM Registrar",Rec)
                    else  if Rec."Redemption Status"=Rec."Redemption Status"::Rejected then
                    FundAdministration.ChangeRedemptionStatusSingle(Statusoptions::Rejected,Statusoptions::"ARM Registrar",Rec)
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
                    FundAdministration.ChangeRedemptionStatusSingle(Statusoptions::"ARM Registrar",Statusoptions::"External Registrar",Rec);
                end;
            }
            action(Rejected)
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
                    FundAdministration.ChangeRedemptionStatusSingle(Statusoptions::"ARM Registrar",Statusoptions::Rejected,Rec);
                end;
            }
            action(Verified)
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
                    FundAdministration.ChangeRedemptionStatusSingle(Statusoptions::"External Registrar",Statusoptions::Verified,Rec);
                end;
            }
            action("Rejected By External Registrar")
            {
                Image = Reject;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = ShowExt;

                trigger OnAction()
                var
                    FundAdministration: Codeunit "Fund Administration";
                    Statusoptions: Option Received,"ARM Registrar","External Registrar",Rejected,Verified,Posted;
                begin
                    FundAdministration.ChangeRedemptionStatusSingle(Statusoptions::"External Registrar",Statusoptions::Rejected,Rec);
                end;
            }
            action(Post)
            {
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = Showverified;

                trigger OnAction()
                var
                    FundTransactionManagement: Codeunit "Fund Transaction Management";
                    Statusoptions: Option Received,"ARM Registrar","External Registrar",Rejected,Verified,Posted;
                begin
                    Redemption2.Reset;
                    Redemption2.SetRange("Transaction No","Transaction No");
                    if Redemption2.FindFirst then
                      repeat
                        Redemption2.Validate(Amount);
                        Redemption2.Modify;
                      until Redemption2.Next=0;
                    FundTransactionManagement.PostSingleRedmption(Rec);
                    //Maxwell: To post Charges on accrued Interest.
                    if Rec."Charges On Accrued Interest" > 0 then
                      FundTransactionManagement.InsertAccruedInterestCharge(Rec."Account No",Rec."Charges On Accrued Interest",Rec."Fund Code",Rec."Value Date");
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
                    FundAdministration.ViewRedemptionTracker(Rec."Transaction No");
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
                    "Document Link":=SharepointIntegration.SaveFileonsharepoint("Transaction No",'Redemption',"Client ID");
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
                    ClientAdministration.ViewKYCLinks("Client ID");
                end;
            }
            action("Ongoing Redemption Requests")
            {
                Image = TaskList;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                RunObject = Page "All Ongoing Redemption Request";
                RunPageLink = "Account No"=FIELD("Account No");
            }
            action("Posted Redemptions")
            {
                Image = History;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                RunObject = Page "Posted Redemptions";
                RunPageLink = "Value Date"=FIELD("Value Date"),
                              "Account No"=FIELD("Account No");
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
                      "Bank Code":=Client."Bank Code";
                      "Bank Account No":=Client."Bank Account Number";
                      "Bank Account Name":=Client."Bank Account Name";
                      Modify;

                    end;

                    Message('Update Complete');
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
        if  ("Redemption Status"="Redemption Status"::Received) or ("Redemption Status"="Redemption Status"::Rejected) then begin
          ShowReceived:=true;
          ShowARM:=false;
          ShowExt:=false;
          Showverified:=false;
        end else if "Redemption Status"="Redemption Status"::"ARM Registrar" then begin
          ShowReceived:=false;
          ShowARM:=true;
          ShowExt:=false;
          Showverified:=false;
        end else if "Redemption Status"="Redemption Status"::"External Registrar" then begin
        ShowReceived:=false;
          ShowARM:=false;
          ShowExt:=true;
          Showverified:=false;
        end else if "Redemption Status"="Redemption Status"::Verified then begin
          ShowReceived:=false;
          ShowARM:=false;
          ShowExt:=false;
          Showverified:=true;
        end else begin

        end;
        if "Redemption Status"= "Redemption Status"::Received then IsReceived :=true else IsReceived :=false
    end;

    trigger OnOpenPage()
    begin
        if "Redemption Type"="Redemption Type"::Full then
         showdividend:=true
        else
        showdividend:=false;
        if "Has Schedule?"  then
          showLines:= true
        else
          showLines:= false;
        if ("Redemption Status"="Redemption Status"::Received) or ("Redemption Status"="Redemption Status"::Rejected)  then begin
          ShowReceived:=true;
          ShowARM:=false;
          ShowExt:=false;
          Showverified:=false;
        end else if "Redemption Status"="Redemption Status"::"ARM Registrar" then begin
          ShowReceived:=false;
          ShowARM:=true;
          ShowExt:=false;
          Showverified:=false;
            ShowReject:=true;
        end else if "Redemption Status"="Redemption Status"::"External Registrar" then begin
        ShowReceived:=false;
          ShowARM:=false;
          ShowExt:=true;
          Showverified:=false;
            ShowReject:=false;
        end else if "Redemption Status"="Redemption Status"::Verified then begin
          ShowReceived:=false;
          ShowARM:=false;
          ShowExt:=false;
          Showverified:=true;
            ShowReject:=true;
        end else if "Redemption Status"="Redemption Status"::"Customer Experience Verification" then  begin
          ShowReceived:=true;
          ShowARM:=false;
          ShowExt:=false;
          Showverified:=false;
          ShowReject:=true;
        end;
        if "Redemption Status"= "Redemption Status"::Received then IsReceived :=true else IsReceived :=false
    end;

    var
        showdividend: Boolean;
        showLines: Boolean;
        ImportRedemptionSchedule: XMLport "Import Redemption Schedule";
        FundTransactionManagement: Codeunit "Fund Transaction Management";
        ShowReceived: Boolean;
        ShowARM: Boolean;
        ShowExt: Boolean;
        Showverified: Boolean;
        ShowReject: Boolean;
        Redemption2: Record Redemption;
        Client: Record Client;
        IsReceived: Boolean;
        Webservice: Codeunit ExternalCallService;
        Response: Boolean;
}

