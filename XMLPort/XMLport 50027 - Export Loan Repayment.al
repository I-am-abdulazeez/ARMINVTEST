xmlport 50027 "Export Loan Repayment"
{
    Direction = Export;
    Format = Xml;
    UseDefaultNamespace = true;

    schema
    {
        textelement(LoanRepayment)
        {
            tableelement("Loan Repayment Schedule";"Loan Repayment Schedule")
            {
                XmlName = 'LoanRepaymentSchedule';
                SourceTableView = WHERE("Fully Paid"=CONST(false));
                fieldelement(LoanNo;"Loan Repayment Schedule"."Loan No.")
                {
                }
                fieldelement(ClientID;"Loan Repayment Schedule"."Client No.")
                {
                }
                fieldelement(LoanAmount;"Loan Repayment Schedule"."Loan Amount")
                {
                }
                fieldelement(RepaymentDate;"Loan Repayment Schedule"."Repayment Date")
                {
                }
                fieldelement(PrincipalDue;"Loan Repayment Schedule"."Principal Due")
                {
                }
                fieldelement(InterestDue;"Loan Repayment Schedule"."Interest Due")
                {
                }
                fieldelement(TotalDue;"Loan Repayment Schedule"."Total Due")
                {
                }
                fieldelement(ClientName;"Loan Repayment Schedule"."Client Name")
                {
                }
                fieldelement(DueDate;"Loan Repayment Schedule"."Due Date")
                {
                }
                fieldelement(FullyPaid;"Loan Repayment Schedule"."Fully Paid")
                {
                }
                fieldelement(InstrumentNo;"Loan Repayment Schedule"."Installment No.")
                {
                }
                fieldelement(SettlementDate;"Loan Repayment Schedule"."Settlement Date")
                {
                }
                fieldelement(TotalSettlement;"Loan Repayment Schedule"."Total Settlement")
                {
                }
                fieldelement(LoanProductType;"Loan Repayment Schedule"."Loan Product Type")
                {
                }
                fieldelement(Settled;"Loan Repayment Schedule".Settled)
                {
                }
                fieldelement(PrincipalRepayment;"Loan Repayment Schedule"."Principal Repayment")
                {
                }
                fieldelement(InterestRepayment;"Loan Repayment Schedule"."Interest Repayment")
                {
                }
                fieldelement(RepaymentLineNo;"Loan Repayment Schedule"."Repayment Line No.")
                {
                }
                fieldelement(SettlementMethod;"Loan Repayment Schedule"."Settlement Method")
                {
                }

                trigger OnAfterInsertRecord()
                begin
                    "Loan Repayment Schedule"."Loan No." := LoanNo;
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

    var
        LoanNo: Code[40];
}

