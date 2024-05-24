page 50214 "Loan Batch Card"
{
    // version THL-LOAN-1.0.0

    DeleteAllowed = false;
    PageType = Card;
    SourceTable = "Loan Batch";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No.";"No.")
                {
                    StyleExpr = LoanStatus;
                }
                field("No. of Requests";"No. of Requests")
                {
                    StyleExpr = LoanStatus;
                }
                field("Total Request Amount";"Total Request Amount")
                {
                    StyleExpr = LoanStatus;
                }
                field("Total New Requests";"Total New Requests")
                {
                    StyleExpr = LoanStatus;
                }
                field("Total Pending Requests";"Total Pending Requests")
                {
                    StyleExpr = LoanStatus;
                }
                field("Total Approved Requests";"Total Approved Requests")
                {
                    StyleExpr = LoanStatus;
                }
                field("Total Disbursed Requests";"Total Disbursed Requests")
                {
                    StyleExpr = LoanStatus;
                }
                field("Total Rejected Requests";"Total Rejected Requests")
                {
                    StyleExpr = LoanStatus;
                }
                field("Created By";"Created By")
                {
                    StyleExpr = LoanStatus;
                }
                field(Status;Status)
                {
                    StyleExpr = LoanStatus;
                }
            }
            part(Control15;"Loan Applications")
            {
                SubPageLink = "Batch No"=FIELD("No.");
            }
        }
        area(factboxes)
        {
            systempart(Control14;Notes)
            {
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Import Loan Applications")
            {
                Image = Import;
                Promoted = true;
                PromotedIsBig = true;
                Visible = EditCard;

                trigger OnAction()
                begin
                    ImportLoans.GetRecHeader(Rec);
                    ImportLoans.Run;
                end;
            }
            action("Send Approval Request")
            {
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedIsBig = true;
                Visible = EditCard;

                trigger OnAction()
                begin
                    if Confirm('Do you wish to send all the loans in the batch for approval?',false) = true then begin

                      //LoanMgt.ValidateLoan(Rec);
                      Status := Status::"Pending Approval";
                      Modify;

                      Loans.Reset;
                      Loans.SetRange("Batch No","No.");
                      if Loans.FindSet then
                        Loans.ModifyAll(Status,Loans.Status::"Pending Approval");

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
                    if Confirm('Do you wish to approve all the loans in the batch?',false) = true then begin
                      Status := Status::Approved;
                      Modify;

                      Loans.Reset;
                      Loans.SetRange("Batch No","No.");
                      if Loans.FindSet then
                        Loans.ModifyAll(Status,Loans.Status::Approved);

                      Message('Loans approved.');
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
                    if Confirm('Do you wish to reject all the loans in the batch?',false) = true then begin
                      Status := Status::Rejected;
                      Modify;

                      Loans.Reset;
                      Loans.SetRange("Batch No","No.");
                      if Loans.FindSet then
                        Loans.ModifyAll(Status,Loans.Status::Rejected);

                      Message('Loans rejected.');
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
                    if Confirm('Do you want to disburse all the loans in the batch',false) = true then begin

                      Status := Status::Disbursed;
                      Modify;

                      Loans.Reset;
                      Loans.SetRange("Batch No","No.");
                      if Loans.FindSet then begin repeat
                        Loans.Disbursed := true;
                        Loans."Loan Disbursement Date" := Today;
                        Loans.Validate(Disbursed);
                        Loans.Modify;
                      until Loans.Next = 0;
                      end;
                      Message('Loans disbursed.');
                    end;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
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
        if (Status = Status::Approved) then
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
        if (Status = Status::Approved) then
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
        ImportLoans: XMLport "Import Loan Applications";
        EditCard: Boolean;
        Pending: Boolean;
        LoanStatus: Text;
        ApprovedLoan: Boolean;
        LoanMgt: Codeunit "Loan Management";
        Loans: Record "Loan Application";
}

