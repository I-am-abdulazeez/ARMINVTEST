report 50009 "Redemption Payout Schedule"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Redemption Payout Schedule.rdlc';

    dataset
    {
        dataitem("Posted Redemption";"Posted Redemption")
        {
            RequestFilterFields = "Value Date";
            column(FundCode_PostedRedemption;"Posted Redemption"."Fund Code")
            {
            }
            column(ValueDate_PostedRedemption;"Posted Redemption"."Value Date")
            {
            }
            column(AccountNo_PostedRedemption;"Posted Redemption"."Account No")
            {
            }
            column(ClientName_PostedRedemption;"Posted Redemption"."Client Name")
            {
            }
            column(TotalAmountPayable_PostedRedemption;"Posted Redemption"."Total Amount Payable")
            {
            }
            column(BankAccountNo_PostedRedemption;"Posted Redemption"."Bank Account No")
            {
            }
            column(BankCode_PostedRedemption;"Posted Redemption"."Bank Code")
            {
            }
            column(CompanyInformationName;CompanyInformation.Name)
            {
            }

            trigger OnPreDataItem()
            begin
                if "Posted Redemption".GetFilter("Posted Redemption"."Value Date")='' then
                  Error('Please input value date filter');
            end;
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
        CompanyInformation.Get;
    end;

    var
        CompanyInformation: Record "Company Information";
}

