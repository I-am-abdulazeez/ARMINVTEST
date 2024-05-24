report 50015 "Direct Debit Cancel Letter"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Direct Debit Cancel Letter.rdlc';

    dataset
    {
        dataitem("Direct Debit Mandate";"Direct Debit Mandate")
        {
            DataItemTableView = WHERE("Request Type"=CONST(Cancellation));
            column(BankAccountNumber_DirectDebitMandate;"Direct Debit Mandate"."Bank Account Number")
            {
            }
            column(FundCode_DirectDebitMandate;"Direct Debit Mandate"."Fund Code")
            {
            }
            column(BankAccountName_DirectDebitMandate;"Direct Debit Mandate"."Bank Account Name")
            {
            }
            column(Amount_DirectDebitMandate;"Direct Debit Mandate".Amount)
            {
            }
            column(companyPicture;company.Picture)
            {
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

    labels
    {
    }

    trigger OnPreReport()
    begin
        company.Get;
        company.CalcFields(Picture);
    end;

    var
        company: Record "Company Information";
}

