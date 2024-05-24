page 50209 "Fully Settled Loan Card"
{
    // version THL-LOAN-1.0.0

    Caption = 'Fully Settled Loan Card';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Card;
    SourceTable = "Historical Loans";

    layout
    {
        area(content)
        {
            group("Client Details")
            {
                Editable = EditCard;
                field("Loan No.";"Loan No.")
                {
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

                        ApprovedLoan := false;
                        if Status = Status::Approved then
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
                field("Freeze Interest Calculation";"Freeze Interest Calculation")
                {
                    Editable = false;
                    StyleExpr = LoanStatus;
                }
                field("Interest Frozen By";"Interest Frozen By")
                {
                    Editable = false;
                    StyleExpr = LoanStatus;
                }
                field("Interest Frozen Date";"Interest Frozen Date")
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

                        ApprovedLoan := false;
                        if Status = Status::Approved then
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
            systempart(Control31;Notes)
            {
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("View Amortization Schedule")
            {
                Image = Agreement;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Page "Settled Repayment Schedule";
                RunPageLink = "Loan No."=FIELD("Loan No.");
            }
            action("Print Amortization Schedule")
            {
                Image = "Report";
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Reset;
                    SetRange("Loan No.","Loan No.");
                    REPORT.Run(50058,true,false,Rec);
                end;
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
                    REPORT.Run(50047,true,false,Rec);
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

        ApprovedLoan := false;
        if (Status = Status::Approved) and (Disbursed = false) then
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

        ApprovedLoan := false;
        if (Status = Status::Approved) and (Disbursed = false) then
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

        ApprovedLoan := false;
        if (Status = Status::Approved) and (Disbursed = false) then
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

    var
        LoanMgt: Codeunit "Loan Management";
        PrincipalMonth: Boolean;
        EditCard: Boolean;
        Pending: Boolean;
        LoanStatus: Text;
        ApprovedLoan: Boolean;
}

