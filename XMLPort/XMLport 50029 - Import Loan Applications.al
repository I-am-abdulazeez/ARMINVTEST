xmlport 50029 "Import Loan Applications"
{
    // version THL-LOAN-1.0.0

    Direction = Import;
    Format = VariableText;
    UseRequestPage = false;

    schema
    {
        textelement(Root)
        {
            tableelement("Loan Application";"Loan Application")
            {
                XmlName = 'LoanApp';
                fieldattribute(PersNo;"Loan Application"."Staff ID")
                {
                }
                fieldattribute(Name;"Loan Application"."Client Name")
                {
                }
                fieldattribute(Fund;"Loan Application"."Fund Code")
                {
                }
                fieldattribute(Product;"Loan Application"."Loan Product Type")
                {
                }
                fieldattribute(BankBranch;"Loan Application"."Bank Branch")
                {
                }
                fieldattribute(LoanAmount;"Loan Application"."Requested Amount")
                {
                }
                textattribute(principalpaymentoption)
                {
                    XmlName = 'PrincipalPaymentOption';
                }
                fieldattribute(Tenor;"Loan Application"."Loan Period (in Months)")
                {
                }
                fieldattribute(BankName;"Loan Application"."Bank Name")
                {
                }
                fieldattribute(BankAccountNo;"Loan Application"."Bank Account Number")
                {
                }
                fieldattribute(LoanYears;"Loan Application"."Loan Years")
                {
                }
                fieldattribute(AnnualInstallment;"Loan Application"."Annual Installment")
                {
                }
                fieldattribute(MonthlyInstallment;"Loan Application"."Monthly Installment")
                {
                }

                trigger OnAfterInsertRecord()
                begin
                    LoanMgt.RepaymentSchedule("Loan Application");
                end;

                trigger OnBeforeInsertRecord()
                begin
                    "Loan Application"."Batch No":=BatchNo;

                    if PrincipalPaymentOption = 'Annually' then
                      "Loan Application"."Principal Repayment Frequency" := "Loan Application"."Principal Repayment Frequency"::Annually
                    else if PrincipalPaymentOption = 'Monthly' then
                      "Loan Application"."Principal Repayment Frequency" := "Loan Application"."Principal Repayment Frequency"::Monthly
                    else
                      "Loan Application"."Principal Repayment Frequency" := "Loan Application"."Principal Repayment Frequency"::None;

                    "Loan Application".Validate("Staff ID");
                    "Loan Application"."Application Date":=Today;
                    "Loan Application".Validate("Application Date");
                    "Loan Application".Validate("Loan Product Type");
                    "Loan Application".Validate("Loan Period (in Months)");
                    "Loan Application".Validate("Requested Amount");
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    trigger OnPostXmlPort()
    begin
        Message('Import Completed.');
    end;

    var
        LoanMgt: Codeunit "Loan Management";
        LoanHeaderCopy: Record "Loan Batch";
        BatchNo: Code[20];

    procedure GetRecHeader(var ImportHeader: Record "Loan Batch")
    begin
        BatchNo:=ImportHeader."No.";
        LoanHeaderCopy.Copy(ImportHeader);
    end;
}

