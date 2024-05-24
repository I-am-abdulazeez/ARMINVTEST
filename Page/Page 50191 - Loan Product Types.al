page 50191 "Loan Product Types"
{
    // version THL-LOAN-1.0.0

    CardPageID = "Loan Product Type Card";
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Loan Product";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code";Code)
                {
                    StyleExpr = ProductStatus;
                }
                field("Loan Type";"Loan Type")
                {
                    StyleExpr = ProductStatus;
                }
                field("Product Description";"Product Description")
                {
                    StyleExpr = ProductStatus;
                }
                field("Interest Rate";"Interest Rate")
                {
                    StyleExpr = ProductStatus;
                }
                field(Status;Status)
                {
                    StyleExpr = ProductStatus;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control6;Notes)
            {
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetCurrRecord()
    begin
        if Status = Status::Inactive then
          ProductStatus := 'Attention'
        else
          ProductStatus := 'Favorable';
    end;

    trigger OnAfterGetRecord()
    begin
        if Status = Status::Inactive then
          ProductStatus := 'Attention'
        else
          ProductStatus := 'Favorable';
    end;

    trigger OnOpenPage()
    begin
        if Status = Status::Inactive then
          ProductStatus := 'Attention'
        else
          ProductStatus := 'Favorable';
    end;

    var
        ProductStatus: Text;
}

