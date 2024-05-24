page 50190 "Loan Product Type Card"
{
    // version THL-LOAN-1.0.0

    DeleteAllowed = false;
    PageType = Card;
    SourceTable = "Loan Product";

    layout
    {
        area(content)
        {
            group("Product Definition")
            {
                field("Code";Code)
                {
                    StyleExpr = ProductStatus;
                    ToolTip = 'This is the Loan Product Code';
                }
                field("Loan Type";"Loan Type")
                {
                    StyleExpr = ProductStatus;
                }
                field("Product Type";"Product Type")
                {
                    StyleExpr = ProductStatus;
                    ToolTip = 'This is a short description of the Loan Product';
                }
                field(Fund;Fund)
                {
                    StyleExpr = ProductStatus;
                }
                field("Fund Name";"Fund Name")
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
                field("No. of Installments";"No. of Installments")
                {
                    StyleExpr = ProductStatus;
                }
                field("Installment Period";"Installment Period")
                {
                    StyleExpr = ProductStatus;
                }
                field(Status;Status)
                {
                    StyleExpr = ProductStatus;
                    ToolTip = 'Set this to ''Active'' if it is available for clients to make requests, otherwise set it to ''Inactive''';

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
            }
            group("Loan Security")
            {
                field("Applicable Investment Balance";"Applicable Investment Balance")
                {
                    StyleExpr = ProductStatus;
                    ToolTip = 'This is the Investment Balance on which this Loan Product Type is secured';
                }
                field("Investment Bal. Max Percentage";"Investment Bal. Max Percentage")
                {
                    StyleExpr = ProductStatus;
                    ToolTip = 'This is the Maximum Percentage of the Investment Balance that one can apply for as Loan';
                }
            }
            group(Calculation)
            {
                field("Default Loan Amount Option";"Default Loan Amount Option")
                {
                    StyleExpr = ProductStatus;
                    ToolTip = 'This describes the method used to calculate a default/automatic loan amount (Applies to Pre-Retirement Loans only)';

                    trigger OnValidate()
                    begin
                        if "Default Loan Amount Option" = "Default Loan Amount Option"::"Percentage of Investment Balance" then
                          PreRetirement := true
                        else begin
                          "Default Loan (% of Inv. Bal)" := 0;
                          PreRetirement := false;
                        end;
                        CurrPage.Update(true);
                    end;
                }
                field("Default Loan (% of Inv. Bal)";"Default Loan (% of Inv. Bal)")
                {
                    Editable = PreRetirement;
                    StyleExpr = ProductStatus;
                    ToolTip = 'This describes the percentage used to calculate a default/automatic loan amount (Applies to Pre-Retirement Loans only)';
                }
            }
            group(Repayment)
            {
                field("Repayment Type";"Repayment Type")
                {
                    StyleExpr = ProductStatus;
                    Visible = false;
                }
                field("Principal Repayment Method";"Principal Repayment Method")
                {
                    StyleExpr = ProductStatus;
                }
                field("Grace Period before Repayment";"Grace Period before Repayment")
                {
                    StyleExpr = ProductStatus;
                }
            }
            part(Control21;"Loan Product Charges")
            {
                SubPageLink = Loan=FIELD(Code);
            }
        }
        area(factboxes)
        {
            part(Control24;"Fund Manager Ratio FactBox")
            {
                SubPageLink = Product=FIELD(Code);
            }
            systempart(Control19;Notes)
            {
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Fund Manager Ratios")
            {
                Image = Allocate;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Page "Product Fund Manager Ratios";
                RunPageLink = Product=FIELD(Code);
            }
            action(Activate)
            {
                Image = Confirm;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Validate(Status,Status::Active);
                    Modify;
                end;
            }
            action(Deactivate)
            {
                Image = DeactivateDiscounts;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Validate(Status,Status::Inactive);
                    Modify;
                end;
            }
        }
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
        if "Default Loan Amount Option" = "Default Loan Amount Option"::"Percentage of Investment Balance" then
          PreRetirement := true;

        if Status = Status::Inactive then
          ProductStatus := 'Attention'
        else
          ProductStatus := 'Favorable';
    end;

    trigger OnOpenPage()
    begin
        PreRetirement := false;
        if Status = Status::Inactive then
          ProductStatus := 'Attention'
        else
          ProductStatus := 'Favorable';
    end;

    var
        PreRetirement: Boolean;
        ProductStatus: Text;
}

