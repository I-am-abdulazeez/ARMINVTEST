page 50212 "Effected Loan Variations"
{
    // version THL-LOAN-1.0.0

    CardPageID = "Effected Loan Variation Card";
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Historical Loan Variation";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Status;Status)
                {
                    StyleExpr = VariationStatus;
                }
                field("Type of Variation";"Type of Variation")
                {
                    StyleExpr = VariationStatus;
                }
                field("No.";"No.")
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
                field("Staff ID";"Staff ID")
                {
                    StyleExpr = VariationStatus;
                }
                field("Account No.";"Account No.")
                {
                    StyleExpr = VariationStatus;
                }
                field("Client Name";"Client Name")
                {
                    StyleExpr = VariationStatus;
                }
                field("Old Loan No.";"Old Loan No.")
                {
                    StyleExpr = VariationStatus;
                }
                field("Current Loan Type";"Current Loan Type")
                {
                    StyleExpr = VariationStatus;
                }
                field("New Loan No.";"New Loan No.")
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
                field("New Tenure(Months)";"New Tenure(Months)")
                {
                    StyleExpr = VariationStatus;
                }
                field("New Loan Type";"New Loan Type")
                {
                    StyleExpr = VariationStatus;
                }
                field("New Loan Start Date";"New Loan Start Date")
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
    }

    trigger OnAfterGetCurrRecord()
    begin
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
}

