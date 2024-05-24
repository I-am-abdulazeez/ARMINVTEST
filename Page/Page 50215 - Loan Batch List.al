page 50215 "Loan Batch List"
{
    // version THL-LOAN-1.0.0

    CardPageID = "Loan Batch Card";
    DeleteAllowed = false;
    Editable = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Loan Batch";

    layout
    {
        area(content)
        {
            repeater(General)
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
          LoanStatus := 'AttentionAccent';
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
          LoanStatus := 'AttentionAccent';
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
          LoanStatus := 'AttentionAccent';
    end;

    var
        LoanStatus: Text;
}

