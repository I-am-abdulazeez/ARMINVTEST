xmlport 50098 ImportExistingLoan
{
    Direction = Import;
    Format = VariableText;

    schema
    {
        textelement(ExistingLoan)
        {
            tableelement("Loan Application";"Loan Application")
            {
                XmlName = 'Loan';
                fieldelement(LoanNo;"Loan Application"."Loan No.")
                {
                }
                fieldelement(LoanProductType;"Loan Application"."Loan Product Type")
                {

                    trigger OnAfterAssignField()
                    begin
                        "Loan Application".Status := "Loan Application".Status::Approved;
                    end;
                }
                fieldelement(LoanPeriod;"Loan Application"."Loan Period (in Months)")
                {
                }
                fieldelement(NoOfPrincipalRepayment;"Loan Application"."No. of Principal Repayments")
                {
                }
                fieldelement(ApplicationDate;"Loan Application"."Application Date")
                {
                }
                fieldelement(RequestedAmount;"Loan Application"."Requested Amount")
                {
                }
                fieldelement(Principal;"Loan Application".Principal)
                {
                }
                fieldelement(RepaymentStartDate;"Loan Application"."Repayment Start Date")
                {
                }
                fieldelement(ApprovedAmount;"Loan Application"."Approved Amount")
                {
                }
                fieldelement(Disbursed;"Loan Application".Disbursed)
                {
                }
                fieldelement(FundCode;"Loan Application"."Fund Code")
                {
                }
                fieldelement(StaffID;"Loan Application"."Staff ID")
                {
                }
                fieldelement(InterestRate;"Loan Application"."Interest Rate")
                {
                }
                fieldelement(LoanDisbursementDate;"Loan Application"."Loan Disbursement Date")
                {
                }

                trigger OnAfterInsertRecord()
                begin
                    LoanMgt.RepaymentSchedule("Loan Application");
                end;

                trigger OnBeforeInsertRecord()
                var
                    ClientAccount: Record "Client Account";
                begin
                    ClientAccount.Reset;
                    ClientAccount.SetRange("Staff ID","Loan Application"."Staff ID");
                    ClientAccount.SetRange("Fund No","Loan Application"."Fund Code");
                    if ClientAccount.FindFirst then begin
                      "Loan Application"."Account No" := ClientAccount."Account No";
                      "Loan Application"."Client No." := ClientAccount."Client ID";
                      "Loan Application"."Client Name" := "Loan Application"."Client Name";
                    end;
                    "Loan Application".Validate("Staff ID");
                    "Loan Application"."Application Date":="Loan Application"."Application Date";
                    "Loan Application".Validate("Application Date");
                    "Loan Application".Validate("Loan Product Type");
                    "Loan Application".Validate("Loan Period (in Months)");
                    "Loan Application".Validate("Requested Amount");
                    
                    /*FundManagerRatio.RESET;
                    IF ARM = ARM THEN BEGIN
                      FundManagerRatio."Fund Manager" := 'ARM';
                      FundManagerRatio.VALIDATE("Fund Manager");
                      FundManagerRatio.Percentage := ARM;
                    END ELSE IF IBTC = IBTC THEN BEGIN
                      FundManagerRatio."Fund Manager" := 'IBTC';
                      FundManagerRatio.VALIDATE("Fund Manager");
                      FundManagerRatio.Percentage := IBTC
                    END ELSE IF VETIVA = VETIVA THEN
                      FundManagerRatio."Fund Manager" := 'VETIVA';
                      FundManagerRatio.VALIDATE("Fund Manager");
                      FundManagerRatio.Percentage := VETIVA;
                    END*/

                end;

                trigger OnBeforeModifyRecord()
                begin
                    window.Update(1,"Loan Application"."Staff ID");
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
        Message('Completed');
    end;

    trigger OnPreXmlPort()
    begin
        window.Open('uploading #1#####');
    end;

    var
        window: Dialog;
        LoanMgt: Codeunit "Loan Management";
        FundManagerRatio: Record "Product Fund Manager Ratio";
}

