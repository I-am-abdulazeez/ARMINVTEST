page 50206 "Loan Variation Card"
{
    // version THL-LOAN-1.0.0

    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "Loan Variation";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No.";"No.")
                {
                    Editable = false;
                    StyleExpr = VariationStatus;
                }
                field("Staff ID";"Staff ID")
                {
                    ShowMandatory = true;
                    StyleExpr = VariationStatus;
                }
                field("Account No.";"Account No.")
                {
                    ShowMandatory = true;
                    StyleExpr = VariationStatus;
                }
                field("Client Name";"Client Name")
                {
                    Editable = false;
                    StyleExpr = VariationStatus;
                }
                field("Type of Variation";"Type of Variation")
                {
                    Editable = false;
                    StyleExpr = VariationStatus;

                    trigger OnValidate()
                    begin
                        //////
                        TerminationVisible := true;
                        if "Type of Variation" = "Type of Variation"::Terminate then
                          TerminationVisible := false
                        else
                          TerminationVisible := true;

                        DetailVisible := true;
                        if "Type of Variation" <> "Type of Variation"::"Top Up" then
                          DetailVisible := false
                        else
                          DetailVisible := true;
                        //////
                    end;
                }
                field(Date;Date)
                {
                    Editable = false;
                    StyleExpr = VariationStatus;
                }
                field("Created By";"Created By")
                {
                    Editable = false;
                    StyleExpr = VariationStatus;
                }
            }
            group("Current Loan")
            {
                field("Old Loan No.";"Old Loan No.")
                {
                    ShowMandatory = true;
                    StyleExpr = VariationStatus;
                }
                field("Current Outstanding Principal";"Current Outstanding Principal")
                {
                    Editable = false;
                    StyleExpr = VariationStatus;
                }
                field("Current Outstanding Interest";"Current Outstanding Interest")
                {
                    Editable = false;
                    StyleExpr = VariationStatus;
                }
                field("Current Outstanding Tenure";"Current Outstanding Tenure")
                {
                    Editable = false;
                    StyleExpr = VariationStatus;
                }
                field("Total Outstanding Loan";"Total Outstanding Loan")
                {
                    Editable = false;
                    StyleExpr = VariationStatus;
                }
                field("Current Interest Rate";"Current Interest Rate")
                {
                    Editable = false;
                    StyleExpr = VariationStatus;
                }
                field("Current Loan Type";"Current Loan Type")
                {
                    Editable = false;
                    StyleExpr = VariationStatus;
                }
            }
            group("New Loan")
            {
                Visible = TerminationVisible;
                field("New Loan Type";"New Loan Type")
                {
                    StyleExpr = VariationStatus;
                }
                field("Top Up Amount";"Top Up Amount")
                {
                    ShowMandatory = true;
                    StyleExpr = VariationStatus;
                    Visible = DetailVisible;
                }
                field("New Tenure(Months)";"New Tenure(Months)")
                {
                    StyleExpr = VariationStatus;
                }
                field("New Interest Rate";"New Interest Rate")
                {
                    StyleExpr = VariationStatus;
                }
                field("New Principal";"New Principal")
                {
                    StyleExpr = VariationStatus;
                }
                field("New Interest";"New Interest")
                {
                    StyleExpr = VariationStatus;
                }
                field("New Loan Start Date";"New Loan Start Date")
                {
                    Caption = 'Repayment Start Date';
                    ShowMandatory = true;
                    StyleExpr = VariationStatus;
                }
                field("New Loan No.";"New Loan No.")
                {
                    Editable = false;
                    StyleExpr = VariationStatus;
                }
            }
            group(Review)
            {
                field(Status;Status)
                {
                    Editable = false;
                    StyleExpr = VariationStatus;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control26;Notes)
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
                    LoanMgt.VariationSchedule(Rec);
                end;
            }
            action("View Old Amortization Schedule")
            {
                Image = Agreement;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Page "Loan Repayment Schedule";
                RunPageLink = "Loan No."=FIELD("Old Loan No.");
                Visible = TerminationVisible;
            }
            action("View New Amortization Schedule")
            {
                Image = Agreement;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Page "Variation Repayment Schedule";
                RunPageLink = "Loan No."=FIELD("New Loan No.");
                Visible = TerminationVisible;
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
                      //LoanMgt.ValidateLoan(Rec);
                      Status := Status::Pending;
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
            action("Old Amortization Schedule")
            {
                Image = "Report";
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Loan.Reset;
                    Loan.SetRange("Loan No.","Old Loan No.");
                    REPORT.Run(50053,true,false,Loan);
                end;
            }
            action("New Amortization Schedule")
            {
                Image = "Report";
                Promoted = true;
                PromotedIsBig = true;
                Visible = TerminationVisible;

                trigger OnAction()
                begin
                    Reset;
                    SetRange("No.","No.");
                    REPORT.Run(50056,true,false,Rec);
                end;
            }
            action("Effect Variation")
            {
                Image = Confirm;
                Promoted = true;
                PromotedIsBig = true;
                Visible = ApprovedLoan;

                trigger OnAction()
                begin
                    if Confirm('Do you want to Apply this Loan Variation?',false) = true then
                      LoanMgt.ApplyLoanVariation(Rec)
                    else
                      exit;
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        if Status <> Status::New then
          EditCard := false
        else
          EditCard := true;

        Pending := false;
        if Status = Status::Pending then
          Pending := true
        else
          Pending := false;

        ApprovedLoan := false;
        if (Status = Status::Approved) then
          ApprovedLoan := true
        else
          ApprovedLoan := false;
        //////
        TerminationVisible := true;
        if "Type of Variation" = "Type of Variation"::Terminate then
          TerminationVisible := false
        else
          TerminationVisible := true;

        DetailVisible := true;
        if "Type of Variation" <> "Type of Variation"::"Top Up" then
          DetailVisible := false
        else
          DetailVisible := true;
        //////
        if Status = Status::Rejected then
          VariationStatus := 'Attention'
        else if Status = Status::Approved then
          VariationStatus := 'Favorable'
        else if Status = Status::Pending then
          VariationStatus := 'Ambiguous'
        else if Status = Status::New then
          VariationStatus := 'AttentionAccent';
    end;

    trigger OnAfterGetRecord()
    begin
        if Status <> Status::New then
          EditCard := false
        else
          EditCard := true;

        Pending := false;
        if Status = Status::Pending then
          Pending := true
        else
          Pending := false;

        ApprovedLoan := false;
        if (Status = Status::Approved) then
          ApprovedLoan := true
        else
          ApprovedLoan := false;
        //////
        TerminationVisible := true;
        if "Type of Variation" = "Type of Variation"::Terminate then
          TerminationVisible := false
        else
          TerminationVisible := true;

        DetailVisible := true;
        if "Type of Variation" <> "Type of Variation"::"Top Up" then
          DetailVisible := false
        else
          DetailVisible := true;
        //////
        if Status = Status::Rejected then
          VariationStatus := 'Attention'
        else if Status = Status::Approved then
          VariationStatus := 'Favorable'
        else if Status = Status::Pending then
          VariationStatus := 'Ambiguous'
        else if Status = Status::New then
          VariationStatus := 'AttentionAccent';
    end;

    trigger OnOpenPage()
    begin
        IsEditable := false;

        if Status <> Status::New then
          EditCard := false
        else
          EditCard := true;

        Pending := false;
        if Status = Status::Pending then
          Pending := true
        else
          Pending := false;

        ApprovedLoan := false;
        if (Status = Status::Approved) then
          ApprovedLoan := true
        else
          ApprovedLoan := false;
        //////
        TerminationVisible := true;
        if "Type of Variation" = "Type of Variation"::Terminate then
          TerminationVisible := false
        else
          TerminationVisible := true;

        DetailVisible := true;
        if "Type of Variation" <> "Type of Variation"::"Top Up" then
          DetailVisible := false
        else
          DetailVisible := true;
        //////
        if Status = Status::Rejected then
          VariationStatus := 'Attention'
        else if Status = Status::Approved then
          VariationStatus := 'Favorable'
        else if Status = Status::Pending then
          VariationStatus := 'Ambiguous'
        else if Status = Status::New then
          VariationStatus := 'AttentionAccent';
    end;

    var
        VariationStatus: Text;
        EditCard: Boolean;
        LoanMgt: Codeunit "Loan Management";
        Pending: Boolean;
        ApprovedLoan: Boolean;
        Loan: Record "Loan Application";
        TerminationVisible: Boolean;
        DetailVisible: Boolean;
        IsEditable: Boolean;
}

