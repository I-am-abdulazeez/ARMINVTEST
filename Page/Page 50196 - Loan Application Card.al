page 50196 "Loan Application Card"
{
    // version THL-LOAN-1.0.0

    Caption = 'Loan Application Card';
    DeleteAllowed = false;
    PageType = Card;
    SourceTable = "Loan Application";

    layout
    {
        area(content)
        {
            group("Client Details")
            {
                Editable = EditCard;
                field("Loan No.";"Loan No.")
                {
                    Editable = false;
                    StyleExpr = LoanStatus;
                }
                field("Staff ID";"Staff ID")
                {
                    ShowMandatory = true;
                    StyleExpr = LoanStatus;
                }
                field("Client No.";"Client No.")
                {
                    ShowMandatory = true;
                    StyleExpr = LoanStatus;
                }
                field("Account No";"Account No")
                {
                    ShowMandatory = true;
                    StyleExpr = LoanStatus;
                }
                field("Client Name";"Client Name")
                {
                    Editable = false;
                    StyleExpr = LoanStatus;
                }
                field("Fund Code";"Fund Code")
                {
                    Editable = false;
                    StyleExpr = LoanStatus;
                }
            }
            group("Application Details")
            {
                Editable = EditCard;
                field("Application Date";"Application Date")
                {
                    ShowMandatory = true;
                    StyleExpr = LoanStatus;
                }
                field("Loan Product Type";"Loan Product Type")
                {
                    ShowMandatory = true;
                    StyleExpr = LoanStatus;
                }
                field("Loan Product Name";"Loan Product Name")
                {
                    Editable = false;
                    StyleExpr = LoanStatus;
                }
                field("Repayment Method";"Repayment Method")
                {
                    Editable = false;
                    StyleExpr = LoanStatus;
                    Visible = false;
                }
                field("Principal Repayment Method";"Principal Repayment Method")
                {
                    Editable = false;
                    StyleExpr = LoanStatus;
                    Visible = false;
                }
                field("Principal Repayment Frequency";"Principal Repayment Frequency")
                {
                    StyleExpr = LoanStatus;
                }
                field("Principal Repayment Month";"Principal Repayment Month")
                {
                    Editable = PrincipalMonth;
                    StyleExpr = LoanStatus;
                }
                field("Interest Repayment Frequency";"Interest Repayment Frequency")
                {
                    StyleExpr = LoanStatus;
                }
                field("Loan Period (in Months)";"Loan Period (in Months)")
                {
                    ShowMandatory = true;
                    StyleExpr = LoanStatus;
                }
                field("No. of Principal Repayments";"No. of Principal Repayments")
                {
                    Editable = false;
                    StyleExpr = LoanStatus;
                }
                field("No. of Interest Repayments";"No. of Interest Repayments")
                {
                    Editable = false;
                    StyleExpr = LoanStatus;
                }
                field("Interest Rate";"Interest Rate")
                {
                    StyleExpr = LoanStatus;
                }
            }
            group("Loan Details")
            {
                Editable = EditCard;
                field("Investment Balance";"Investment Balance")
                {
                    Editable = false;
                    StyleExpr = LoanStatus;
                }
                field("Requested Amount";"Requested Amount")
                {
                    ShowMandatory = true;
                    StyleExpr = LoanStatus;
                }
                field(Principal;Principal)
                {
                    StyleExpr = LoanStatus;
                }
                field(Interest;Interest)
                {
                    StyleExpr = LoanStatus;
                }
                field("Repayment Start Date";"Repayment Start Date")
                {
                    ShowMandatory = true;
                    StyleExpr = LoanStatus;
                    ToolTip = 'Start date of loan';
                }
                field("Document Link";"Document Link")
                {
                }
            }
            group(Review)
            {
                Editable = EditCard;
                field(Status;Status)
                {
                    StyleExpr = LoanStatus;

                    trigger OnValidate()
                    begin
                        if Status <> Status::New then
                          EditCard := false
                        else
                          EditCard := true;
                        
                        Pending := false;
                        if Status = Status::"Pending Approval" then
                          Pending := true
                        else
                          Pending := false;
                        
                        /*ApprovedLoan := FALSE;
                        IF Status = Status::Approved THEN
                          ApprovedLoan := TRUE
                        ELSE
                          ApprovedLoan := FALSE;*/
                        
                        //Maxwell: To have Disburse Button visible once it is at Treasury
                        ApprovedLoan := false;
                        if (Status = Status::"At Treasury") and (Disbursed = false) then
                          ApprovedLoan := true
                        else
                          ApprovedLoan := false;
                        
                        if Status = Status::Rejected then
                          LoanStatus := 'Attention'
                        else if Status = Status::Approved then
                          LoanStatus := 'Favorable'
                        else if Status = Status::"Pending Approval" then
                          LoanStatus := 'Ambiguous'
                        else if Status = Status::New then
                          LoanStatus := 'AttentionAccent';

                    end;
                }
                field("Existing Loan Amount";"Existing Loan Amount")
                {
                    StyleExpr = LoanStatus;
                }
                field("Approved Amount";"Approved Amount")
                {
                    ShowMandatory = true;
                    StyleExpr = LoanStatus;
                }
                field(Disbursed;Disbursed)
                {
                    StyleExpr = LoanStatus;
                }
                field("Loan Disbursement Date";"Loan Disbursement Date")
                {
                    StyleExpr = LoanStatus;
                }
                field("On Repayment Holiday";"On Repayment Holiday")
                {
                    Editable = false;
                    StyleExpr = LoanStatus;
                }
                field("Placed On Holiday By";"Placed On Holiday By")
                {
                    Editable = false;
                    StyleExpr = LoanStatus;
                }
                field("Date Placed On Holiday";"Date Placed On Holiday")
                {
                    Editable = false;
                    StyleExpr = LoanStatus;
                }
            }
            group("Bank Details")
            {
                Editable = EditCard;
                field("Bank Code";"Bank Code")
                {
                    ShowMandatory = true;
                    StyleExpr = LoanStatus;

                    trigger OnValidate()
                    begin
                        if Status <> Status::New then
                          EditCard := false
                        else
                          EditCard := true;
                        
                        Pending := false;
                        if Status = Status::"Pending Approval" then
                          Pending := true
                        else
                          Pending := false;
                        
                        /*ApprovedLoan := FALSE;
                        IF Status = Status::Approved THEN
                          ApprovedLoan := TRUE
                        ELSE
                          ApprovedLoan := FALSE;*/
                        
                        //Maxwell: To have Disburse Button visible once it is at Treasury
                        ApprovedLoan := false;
                        if (Status = Status::"At Treasury") and (Disbursed = false) then
                          ApprovedLoan := true
                        else
                          ApprovedLoan := false;
                        
                        if Status = Status::Rejected then
                          LoanStatus := 'Attention'
                        else if Status = Status::Approved then
                          LoanStatus := 'Favorable'
                        else if Status = Status::"Pending Approval" then
                          LoanStatus := 'Ambiguous'
                        else if Status = Status::New then
                          LoanStatus := 'AttentionAccent';

                    end;
                }
                field("Bank Name";"Bank Name")
                {
                    ShowMandatory = true;
                    StyleExpr = LoanStatus;
                }
                field("Bank Branch";"Bank Branch")
                {
                    ShowMandatory = true;
                    StyleExpr = LoanStatus;
                }
                field("Bank Account Name";"Bank Account Name")
                {
                    ShowMandatory = true;
                    StyleExpr = LoanStatus;
                }
                field("Bank Account Number";"Bank Account Number")
                {
                    ShowMandatory = true;
                    StyleExpr = LoanStatus;
                }
            }
        }
        area(factboxes)
        {
            part(Control39;"Repayments FactBox")
            {
                SubPageLink = "Loan No."=FIELD("Loan No.");
            }
            part(Control48;"Fund Manager Ratios FactBox")
            {
                SubPageLink = "Loan No."=FIELD("Loan No.");
            }
            systempart(Control31;Notes)
            {
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Calculate)
            {
                Image = Calculate;
                Promoted = true;
                PromotedIsBig = true;
                Visible = EditCard;

                trigger OnAction()
                begin
                    LoanMgt.RepaymentSchedule(Rec);
                end;
            }
            action("Refresh Schedule")
            {
                Image = Calculate;
                Promoted = true;
                PromotedIsBig = true;
                Visible = Admin;

                trigger OnAction()
                begin
                    LoanMgt.RefreshRepaymentSchedule(Rec);
                end;
            }
            action("View Amortization Schedule")
            {
                Image = Agreement;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Page "Loan Repayment Schedule";
                RunPageLink = "Loan No."=FIELD("Loan No.");
            }
            action("Send Approval Request")
            {
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedIsBig = true;
                Visible = EditCard;

                trigger OnAction()
                begin
                    if Confirm('Do you wish to send the record for approval?',false) = true then begin
                      if "Document Link" ='' then
                        Error('Please attach a document');
                      LoanMgt.ValidateLoan(Rec);
                      Status := Status::"Pending Approval";
                      Modify;
                      Message('Approval request sent.');
                    end;
                end;
            }
            action(Approve)
            {
                Image = Approve;
                Promoted = true;
                PromotedIsBig = true;
                Visible = Pending;

                trigger OnAction()
                begin
                    if Confirm('Do you wish to approve the record?',false) = true then begin
                      Status := Status::Approved;
                      Modify;
                      Message('Record approved.');
                    end;
                end;
            }
            action(Reject)
            {
                Image = Reject;
                Promoted = true;
                PromotedIsBig = true;
                Visible = Pending;

                trigger OnAction()
                begin
                    if Confirm('Do you wish to reject the record?',false) = true then begin
                      Status := Status::Rejected;
                      Modify;
                      Message('Record rejected.');
                    end;
                end;
            }
            action("Reject to Update")
            {
                Image = UpdateDescription;
                Promoted = true;
                PromotedIsBig = true;
                Visible = Pending;

                trigger OnAction()
                begin
                    if Confirm('Do you wish to reject this record for update?',false) = true then begin
                      Status := Status::New;
                      Modify;
                      Message('Record has been rejected for update.');
                    end;
                end;
            }
            action("Disburse Loan")
            {
                Image = Confirm;
                Promoted = true;
                PromotedIsBig = true;
                Visible = ApprovedLoan;

                trigger OnAction()
                begin
                    if Confirm('Do you want to disburse this loan?',false) = true then begin
                      if "Loan Disbursement Date" = 0D then
                      "Loan Disbursement Date" := Today;
                      Disbursed := true;
                      Validate(Disbursed);
                      Status:= Status::Approved;
                      Modify;
                    end;
                end;
            }
            action("Amortization Schedule")
            {
                Image = "Report";
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Reset;
                    SetRange("Loan No.","Loan No.");
                    REPORT.Run(50053,true,false,Rec);
                end;
            }
            action("Create Loan Vartiation")
            {
                Image = Undo;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    if (Status = Status::New) or (Status = Status::Rejected) or (Status = Status::"Pending Approval") then
                      exit;

                    if Status = Status::"On Repayment Holiday" then
                      if Confirm('Creating a Variation for Loan will re-activate it from Repayment Holiday. Do you wish to continue?',false) = true then
                        LoanMgt.CreateLoanVariationFromLoanCard(Rec)
                      else
                        exit;

                    if Confirm('Do you want to create a Loan Variation?',false) = true then
                      LoanMgt.CreateLoanVariationFromLoanCard(Rec)
                    else
                      exit;
                end;
            }
            action("Freeze Loan")
            {
                Image = Stop;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    if (Status = Status::New) or (Status = Status::Rejected) or (Status = Status::"Pending Approval") then
                      exit;

                    if Confirm('By Freezing this loan, it will be placed on repayment holiday. Do you wish to continue?',false) = true then
                    LoanMgt.FreezeLoan(Rec);
                end;
            }
            action("Client Card")
            {
                Image = Customer;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Page "Client Card";
                RunPageLink = "Membership ID"=FIELD("Client No.");
            }
            action("Loan Statement")
            {
                Image = "Report";
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Reset;
                    SetRange("Loan No.","Loan No.");
                    REPORT.Run(50060,true,false,Rec);
                end;
            }
            action("Attach Document")
            {
                Image = Attach;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = EditCard;

                trigger OnAction()
                var
                    SharepointIntegration: Codeunit "Sharepoint Integration";
                begin
                    if "Document Link"<>'' then
                      if not Confirm('There is an existing Document For this record. Do you Want to overwrite it?') then
                        Error('');
                    "Document Link":=SharepointIntegration.SaveFileonsharepoint("Loan No.",'Loan',"Client No.");
                    Modify;
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        if ("Principal Repayment Frequency" <> "Principal Repayment Frequency"::Annually) then
          PrincipalMonth := false
        else
          PrincipalMonth := true;
        
        if Status <> Status::New then
          EditCard := false
        else
          EditCard := true;
        
        Pending := false;
        if Status = Status::"Pending Approval" then
          Pending := true
        else
          Pending := false;
        
        /*ApprovedLoan := FALSE;
        IF (Status = Status::Approved) AND (Disbursed = FALSE) THEN
          ApprovedLoan := TRUE
        ELSE
          ApprovedLoan := FALSE;*/
        //Maxwell: To have Disburse Button visible once it is at Treasury
        ApprovedLoan := false;
        if (Status = Status::"At Treasury") and (Disbursed = false) then
          ApprovedLoan := true
        else
          ApprovedLoan := false;
        if Status = Status::Rejected then
          LoanStatus := 'Attention'
        else if Status = Status::Approved then
          LoanStatus := 'Favorable'
        else if Status = Status::"Pending Approval" then
          LoanStatus := 'Ambiguous'
        else if Status = Status::New then
          LoanStatus := 'AttentionAccent';
        
        Admin := false;
        if UserId = 'ARM.COM.NG\GIDEON.RONO' then
          Admin := true;

    end;

    trigger OnAfterGetRecord()
    begin
        if ("Principal Repayment Frequency" <> "Principal Repayment Frequency"::Annually) then
          PrincipalMonth := false
        else
          PrincipalMonth := true;
        
        if Status <> Status::New then
          EditCard := false
        else
          EditCard := true;
        
        Pending := false;
        if Status = Status::"Pending Approval" then
          Pending := true
        else
          Pending := false;
        
        /*ApprovedLoan := FALSE;
        IF (Status = Status::Approved) AND (Disbursed = FALSE) THEN
          ApprovedLoan := TRUE
        ELSE
          ApprovedLoan := FALSE;*/
        //Maxwell: To have Disburse Button visible once it is at Treasury
        ApprovedLoan := false;
        if (Status = Status::"At Treasury") and (Disbursed = false) then
          ApprovedLoan := true
        else
          ApprovedLoan := false;
        
        if Status = Status::Rejected then
          LoanStatus := 'Attention'
        else if Status = Status::Approved then
          LoanStatus := 'Favorable'
        else if Status = Status::"Pending Approval" then
          LoanStatus := 'Ambiguous'
        else if Status = Status::New then
          LoanStatus := 'AttentionAccent';
        
        Admin := false;
        if UserId = 'ARM.COM.NG\GIDEON.RONO' then
          Admin := true;

    end;

    trigger OnOpenPage()
    begin
        if ("Principal Repayment Frequency" <> "Principal Repayment Frequency"::Annually) then
          PrincipalMonth := false
        else
          PrincipalMonth := true;
        EditCard := true;
        if Status <> Status::New then
          EditCard := false
        else
          EditCard := true;

        Pending := false;
        if Status = Status::"Pending Approval" then
          Pending := true
        else
          Pending := false;


        //Maxwell: To have Disburse Button visible once it is at Treasury
        ApprovedLoan := false;
        if (Status = Status::"At Treasury") and (Disbursed = false) then
          ApprovedLoan := true
        else
          ApprovedLoan := false;

        if Status = Status::Rejected then
          LoanStatus := 'Attention'
        else if Status = Status::Approved then
          LoanStatus := 'Favorable'
        else if Status = Status::"Pending Approval" then
          LoanStatus := 'Ambiguous'
        else if Status = Status::New then
          LoanStatus := 'AttentionAccent';

        Admin := false;
        if UserId = 'ARM.COM.NG\GIDEON.RONO' then
          Admin := true;
    end;

    var
        LoanMgt: Codeunit "Loan Management";
        PrincipalMonth: Boolean;
        EditCard: Boolean;
        Pending: Boolean;
        LoanStatus: Text;
        ApprovedLoan: Boolean;
        AwaitingTreasury: Boolean;
        Admin: Boolean;
}

