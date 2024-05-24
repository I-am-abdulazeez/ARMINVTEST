report 50117 "Mutual Fund Payout Schedule"
{
    // version MFD-1.0

    DefaultLayout = RDLC;
    RDLCLayout = './Mutual Fund Payout Schedule.rdlc';

    dataset
    {
        dataitem("MF Payment Header";"MF Payment Header")
        {
            column(CompanyInformationName;CompanyInformation.Name)
            {
            }
            column(PaymentDate_MFPaymentHeader;"MF Payment Header"."Payment Date")
            {
            }
            column(FundCode_MFPaymentHeader;"MF Payment Header"."Fund Code")
            {
            }
            dataitem("MF Payment Lines";"MF Payment Lines")
            {
                DataItemLink = "Header No"=FIELD(No);
                DataItemTableView = WHERE("Dividend Mandate"=CONST(Payout));
                column(AccountNo_MFPaymentLines;"MF Payment Lines"."Account No")
                {
                }
                column(ClientID_MFPaymentLines;"MF Payment Lines"."Client ID")
                {
                }
                column(ClientName_MFPaymentLines;"MF Payment Lines"."Client Name")
                {
                }
                column(FundCode_MFPaymentLines;"MF Payment Lines"."Fund Code")
                {
                }
                column(BankCode_MFPaymentLines;"MF Payment Lines"."Bank Code")
                {
                }
                column(BankAccount_MFPaymentLines;"MF Payment Lines"."Bank Account")
                {
                }
                column(TotalDividendEarned_MFPaymentLines;"MF Payment Lines"."Total Dividend Earned")
                {
                }
                column(DividendAmount_MFPaymentLines;"MF Payment Lines"."Dividend Amount")
                {
                }
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

    var
        CompanyInformation: Record "Company Information";
}

