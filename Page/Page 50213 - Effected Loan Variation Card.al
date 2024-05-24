page 50213 "Effected Loan Variation Card"
{
    // version THL-LOAN-1.0.0

    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Card;
    SourceTable = "Historical Loan Variation";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No.";"No.")
                {
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
                    StyleExpr = VariationStatus;
                }
                field("Type of Variation";"Type of Variation")
                {
                    StyleExpr = VariationStatus;
                }
                field(Date;Date)
                {
                    StyleExpr = VariationStatus;
                }
                field("Created By";"Created By")
                {
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
                    StyleExpr = VariationStatus;
                }
                field("Current Outstanding Interest";"Current Outstanding Interest")
                {
                    StyleExpr = VariationStatus;
                }
                field("Current Outstanding Tenure";"Current Outstanding Tenure")
                {
                    StyleExpr = VariationStatus;
                }
                field("Total Outstanding Loan";"Total Outstanding Loan")
                {
                    StyleExpr = VariationStatus;
                }
                field("Current Interest Rate";"Current Interest Rate")
                {
                    StyleExpr = VariationStatus;
                }
                field("Current Loan Type";"Current Loan Type")
                {
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
            action("View Old Amortization Schedule")
            {
                Image = Agreement;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Page "Settled Repayment Schedule";
                RunPageLink = "Loan No."=FIELD("Old Loan No.");
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
}

