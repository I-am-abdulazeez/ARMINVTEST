page 50197 "Loan Applications"
{
    // version THL-LOAN-1.0.0

    Caption = 'Loan Applications';
    CardPageID = "Loan Application Card";
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Loan Application";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Status;Status)
                {
                    StyleExpr = LoanStatus;
                }
                field("Loan No.";"Loan No.")
                {
                    StyleExpr = LoanStatus;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Loans.Reset;
                        Loans.SetRange("Loan No.","Loan No.");
                        PAGE.Run(PAGE::"Loan Application Card",Loans);
                    end;
                }
                field("Client No.";"Client No.")
                {
                    StyleExpr = LoanStatus;
                }
                field("Staff ID";"Staff ID")
                {
                    StyleExpr = LoanStatus;
                }
                field("Client Name";"Client Name")
                {
                    StyleExpr = LoanStatus;
                }
                field("Loan Product Type";"Loan Product Type")
                {
                    StyleExpr = LoanStatus;
                }
                field("Loan Product Name";"Loan Product Name")
                {
                    StyleExpr = LoanStatus;
                }
                field("Loan Period (in Months)";"Loan Period (in Months)")
                {
                    StyleExpr = LoanStatus;
                }
                field("Interest Rate";"Interest Rate")
                {
                    StyleExpr = LoanStatus;
                }
                field("Application Date";"Application Date")
                {
                    StyleExpr = LoanStatus;
                }
                field("Requested Amount";"Requested Amount")
                {
                    StyleExpr = LoanStatus;
                }
                field(Disbursed;Disbursed)
                {
                    StyleExpr = LoanStatus;
                }
                field("Batch No";"Batch No")
                {
                    Editable = false;
                    StyleExpr = LoanStatus;
                }
            }
        }
        area(factboxes)
        {
            part(Control23;"Repayments FactBox")
            {
                SubPageLink = "Loan No."=FIELD("Loan No.");
            }
            part(Control9;"Fund Manager Ratios FactBox")
            {
                SubPageLink = "Loan No."=FIELD("Loan No.");
            }
            systempart(Control21;Notes)
            {
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Send to Treasury")
            {
                Image = SendConfirmation;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = SendTreasury;

                trigger OnAction()
                begin
                    FundTransactionManagement.ExportApprovedLoansToTreasury;
                    Message('Loans have been sent to Treasury')
                end;
            }
            action("Send Disbursed Loans")
            {
                Image = SendElectronicDocument;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = SendTreasury;

                trigger OnAction()
                begin
                    if not Confirm('Are you sure you want to send disbursed loans') then
                      Error('');
                    LoanMgt.GetDisbursedLoan
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        if Status = Status::Rejected then
          LoanStatus := 'Attention'
        else if Status = Status::Approved then
          LoanStatus := 'Favorable'
        else if Status = Status::"Pending Approval" then
          LoanStatus := 'Ambiguous'
        else if Status = Status::New then
          LoanStatus := 'AttentionAccent'
        //Max: Added new status
        else if Status = Status::"At Treasury" then
          LoanStatus := 'Favorable';

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
        //Max: Added new status
        AwaitingTreasury := false;
        if (Status = Status::"At Treasury") and (Disbursed = false) then
          AwaitingTreasury := true
        else
          AwaitingTreasury := false
    end;

    trigger OnAfterGetRecord()
    begin
        if Status = Status::Rejected then
          LoanStatus := 'Attention'
        else if Status = Status::Approved then
          LoanStatus := 'Favorable'
        else if Status = Status::"Pending Approval" then
          LoanStatus := 'Ambiguous'
        else if Status = Status::New then
          LoanStatus := 'AttentionAccent'
        //Max: Added new status
        else if Status = Status::"At Treasury" then
          LoanStatus := 'Favorable';

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
        //Max: Added new status
        AwaitingTreasury := false;
        if (Status = Status::"At Treasury") and (Disbursed = false) then
          AwaitingTreasury := true
        else
          AwaitingTreasury := false
    end;

    trigger OnOpenPage()
    begin
        if Status = Status::Rejected then
          LoanStatus := 'Attention'
        else if Status = Status::Approved then
          LoanStatus := 'Favorable'
        else if Status = Status::"Pending Approval" then
          LoanStatus := 'Ambiguous'
        else if Status = Status::New then
          LoanStatus := 'AttentionAccent'//Max: Added new status
        else if Status = Status::"At Treasury" then
          LoanStatus := 'Favorable';

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
          ApprovedLoan := false;//Max: Added new status
          AwaitingTreasury := false;
        if (Status = Status::"At Treasury") and (Disbursed = false) then
          AwaitingTreasury := true
        else
          AwaitingTreasury := false;
        SendTreasury := false;
        if Status = Status::Approved then
          SendTreasury := true
        else
          SendTreasury := false
    end;

    var
        LoanStatus: Text;
        Applications: XMLport "Import Loan Applications";
        EditCard: Boolean;
        Pending: Boolean;
        ApprovedLoan: Boolean;
        LoanMgt: Codeunit "Loan Management";
        Loans: Record "Loan Application";
        AwaitingTreasury: Boolean;
        FundTransactionManagement: Codeunit "Fund Transaction Management";
        SendTreasury: Boolean;
}

