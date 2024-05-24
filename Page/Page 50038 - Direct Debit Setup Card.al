page 50038 "Direct Debit Setup Card"
{
    DeleteAllowed = false;
    PageType = Card;
    SourceTable = "Direct Debit Mandate";

    layout
    {
        area(content)
        {
            group(General)
            {
                field(No;No)
                {
                }
                field("Request Type";"Request Type")
                {
                }
                field("Account No";"Account No")
                {
                    ShowMandatory = true;
                }
                field("Client ID";"Client ID")
                {
                }
                field("Fund Code";"Fund Code")
                {
                }
                field("Sub Fund Code";"Sub Fund Code")
                {
                }
                field("Client Name";"Client Name")
                {
                }
                field("Bank Code";"Bank Code")
                {
                }
                field("Bank Branch Code";"Bank Branch Code")
                {
                }
                field("Bank Account Name";"Bank Account Name")
                {
                }
                field("Bank Account Number";"Bank Account Number")
                {
                }
                field("Phone No.";"Phone No.")
                {
                }
                field("E-Mail";"E-Mail")
                {
                }
                field(Frequency;Frequency)
                {
                }
                field("Start Date";"Start Date")
                {
                }
                field("End Date";"End Date")
                {
                }
                field(Status;Status)
                {
                }
                field(Amount;Amount)
                {
                }
                field("Multiple Beneficiaries";"Multiple Beneficiaries")
                {

                    trigger OnValidate()
                    begin
                        if "Multiple Beneficiaries" then
                          showbeneficiaries:=true
                        else
                          showbeneficiaries:= false;
                    end;
                }
                field("Total Beneficiaries Amount";"Total Beneficiaries Amount")
                {
                }
                field("Document Link";"Document Link")
                {
                }
                field("Direct Debit to Be cancelled";"Direct Debit to Be cancelled")
                {
                }
                field(Comments;Comments)
                {
                    MultiLine = true;
                }
            }
            part(Control15;"DD Mandate Beneficiaries")
            {
                Enabled = showbeneficiaries;
                SubPageLink = "Mandate No"=FIELD(No);
                Visible = showbeneficiaries;
            }
            group("NIBBS Response")
            {
                Editable = false;
                field("Response Code";"Response Code")
                {
                }
                field("Response Description";"Response Description")
                {
                }
                field("Reference Number";"Reference Number")
                {
                }
                field(AdditionalComments;AdditionalComments)
                {
                }
                field("Nibbs Approval Status";"Nibbs Approval Status")
                {
                }
                field("WorkFlow Status";"WorkFlow Status")
                {
                }
                field("WorkFlow Status Description";"WorkFlow Status Description")
                {
                }
                field("Cancelled Reference Number";"Cancelled Reference Number")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
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
                    FundAdministration.ViewDirectDebitTracker(Rec.No);
                end;
            }
            action("Forward to Operations")
            {
                Image = MoveToNextPeriod;
                Promoted = true;
                PromotedIsBig = true;
                Visible = showreceived;

                trigger OnAction()
                var
                    FundAdministration: Codeunit "Fund Administration";
                    Statusoptions: Option Received,"ARM Registrar","Logged on Bank Platform","Approved By Bank","Rejected By Bank",Cancelled,"Batch ID Generated","Mandate Cancelled","Update Direct Debit","Sent letter to Bank","Received Response From Bank";
                begin


                    FundAdministration.ChangeDirectDebitSetupStatussingle(Statusoptions::Received,Statusoptions::"ARM Registrar",Rec);
                end;
            }
            action("Mark As Logged At Bank PlatForm")
            {
                Image = MoveToNextPeriod;
                Promoted = true;
                PromotedIsBig = true;
                Visible = ShowARM;

                trigger OnAction()
                var
                    FundAdministration: Codeunit "Fund Administration";
                    Statusoptions: Option Received,"ARM Registrar","Logged on Bank Platform","Approved By Bank","Rejected By Bank",Cancelled,"Batch ID Generated","Mandate Cancelled","Update Direct Debit","Sent letter to Bank","Received Response From Bank";
                begin
                    FundAdministration.ChangeDirectDebitSetupStatussingle(Statusoptions::"ARM Registrar",Statusoptions::"Logged on Bank Platform",Rec);
                end;
            }
            action("Mark As Approved By Bank")
            {
                Image = MoveToNextPeriod;
                Promoted = true;
                PromotedIsBig = true;
                Visible = ShowBank;

                trigger OnAction()
                var
                    FundAdministration: Codeunit "Fund Administration";
                    Statusoptions: Option Received,"ARM Registrar","Logged on Bank Platform","Approved By Bank","Rejected By Bank",Cancelled,"Batch ID Generated","Mandate Cancelled","Update Direct Debit","Sent letter to Bank","Received Response From Bank";
                begin
                    FundAdministration.ChangeDirectDebitSetupStatussingle(Statusoptions::"Logged on Bank Platform",Statusoptions::"Approved By Bank",Rec);
                end;
            }
            action("Mark As Rejected By Bank")
            {
                Image = Reject;
                Promoted = true;
                PromotedIsBig = true;
                Visible = ShowBank;

                trigger OnAction()
                var
                    FundAdministration: Codeunit "Fund Administration";
                    Statusoptions: Option Received,"ARM Registrar","Logged on Bank Platform","Approved By Bank","Rejected By Bank",Cancelled,"Batch ID Generated","Mandate Cancelled","Update Direct Debit","Sent letter to Bank","Received Response From Bank";
                begin
                    FundAdministration.ChangeDirectDebitSetupStatussingle(Statusoptions::"Logged on Bank Platform",Statusoptions::"Rejected By Bank",Rec);
                end;
            }
            action(Reject)
            {
                Image = Reject;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = ShowARM;

                trigger OnAction()
                var
                    FundAdministration: Codeunit "Fund Administration";
                    Statusoptions: Option Received,"ARM Registrar","Logged on Bank Platform","Approved By Bank","Rejected By Bank","Rejected By ARM Reg",Cancelled,"Batch ID Generated","Mandate Cancelled","Update Direct Debit","Sent letter to Bank","Received Response From Bank";
                begin
                    //FundAdministration.ChangeDirectDebitSetupStatussingle(Statusoptions::"ARM Registrar",Statusoptions::"Rejected By Bank",Rec);
                    if not Confirm('Do you want to reject mandate?') then
                        Error('');
                    FundAdministration.ChangeDirectDebitSetupStatussingle(Statusoptions::"ARM Registrar",Statusoptions::"Rejected By ARM Reg",Rec);
                end;
            }
            action("Attach Document")
            {
                Image = Attach;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = showreceived;

                trigger OnAction()
                var
                    SharepointIntegration: Codeunit "Sharepoint Integration";
                begin
                    if "Document Link"<>'' then
                      if not Confirm('There is an existing Document For this record. Do you Want to overwrite it?') then
                        Error('');
                    "Document Link":=SharepointIntegration.SaveDebitonsharepoint(No,'Direct_Debit',"Client ID",Rec);
                    //MODIFY;
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
            action("Check Nibbs Status")
            {
                Image = MoveToNextPeriod;
                Promoted = true;
                PromotedIsBig = true;
                Visible = ShowBank;

                trigger OnAction()
                var
                    FundAdministration: Codeunit "Fund Administration";
                    Statusoptions: Option Received,"ARM Registrar","Logged on Bank Platform","Approved By Bank","Rejected By Bank",Cancelled,"Batch ID Generated","Mandate Cancelled","Update Direct Debit","Sent letter to Bank","Received Response From Bank";
                begin
                    if "Reference Number"='' then
                      Error('There is no Reference number from Nibbs in this record');
                    ExternalCallService.GetNibbsResponse("Reference Number",Rec);
                end;
            }
            action("Cancel Mandate")
            {
                Image = CancelFALedgerEntries;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    FundAdministration: Codeunit "Fund Administration";
                    Statusoptions: Option Received,"ARM Registrar","Logged on Bank Platform","Approved By Bank","Rejected By Bank","Rejected By ARM Reg",Cancelled,"Batch ID Generated","Mandate Cancelled","Update Direct Debit","Sent letter to Bank","Received Response From Bank";
                begin
                    //Maxwell: Button for cancelling Direct Debit Mandate
                    if not Confirm('Do you want to cancel mandate?') then
                        Error('');
                    FundAdministration.ChangeDirectDebitSetupStatussingle(Statusoptions::"ARM Registrar",Statusoptions::"Mandate Cancelled",Rec);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        if "Multiple Beneficiaries" then
          showbeneficiaries:=true
        else
          showbeneficiaries:= false;
        if(Status=Status::Received) or (Status=Status::"Rejected By Bank")  then begin
          ShowReceived:=true;
          ShowARM:=false;
          ShowBank:=false;
        end else if Status=Status::"ARM Registrar" then begin
           ShowReceived:=false;
          ShowARM:=true;
          ShowBank:=false;
        end else if Status=Status::"Logged on Bank Platform"then begin
         ShowReceived:=false;
          ShowARM:=false;
          ShowBank:=true;
        end else   begin
         ShowReceived:=false;
          ShowARM:=false;
          ShowBank:=false;
        end;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        //"Request Type":="Request Type"::Setup;
    end;

    trigger OnOpenPage()
    begin
        if (Status=Status::Received) or (Status=Status::"Rejected By Bank") then begin
          ShowReceived:=true;
          ShowARM:=false;
          ShowBank:=false;
        end else if Status=Status::"ARM Registrar" then begin
           ShowReceived:=false;
          ShowARM:=true;
          ShowBank:=false;
        end else if Status=Status::"Logged on Bank Platform"then begin
         ShowReceived:=false;
          ShowARM:=false;
          ShowBank:=true;
        end else   begin
         ShowReceived:=false;
          ShowARM:=false;
          ShowBank:=false;
        end;
    end;

    var
        showbeneficiaries: Boolean;
        ShowReceived: Boolean;
        ShowARM: Boolean;
        ShowBank: Boolean;
        Showverified: Boolean;
        ExternalCallService: Codeunit ExternalCallService;
}

