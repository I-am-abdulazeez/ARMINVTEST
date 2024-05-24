page 50210 "Fully Settled Loans"
{
    // version THL-LOAN-1.0.0

    Caption = 'Fully Settled Loans';
    CardPageID = "Fully Settled Loan Card";
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Historical Loans";

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
            }
        }
        area(factboxes)
        {
            systempart(Control21;Notes)
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
        Applications: XMLport "Import Loan Applications";
}

