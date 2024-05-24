report 50010 "Unit Transfer Schedule"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Unit Transfer Schedule.rdlc';

    dataset
    {
        dataitem("Posted Fund Transfer";"Posted Fund Transfer")
        {
            RequestFilterFields = "Value Date";
            column(ValueDate_PostedFundTransfer;"Posted Fund Transfer"."Value Date")
            {
            }
            column(BankCode_PostedFundTransfer;"Posted Fund Transfer"."Bank Code")
            {
            }
            column(FromAccountNo_PostedFundTransfer;"Posted Fund Transfer"."From Account No")
            {
            }
            column(FromClientName_PostedFundTransfer;"Posted Fund Transfer"."From Client Name")
            {
            }
            column(Amount_PostedFundTransfer;"Posted Fund Transfer".Amount)
            {
            }
            column(BankAccountNo_PostedFundTransfer;"Posted Fund Transfer"."Bank Account No")
            {
            }
            column(FromFundCode_PostedFundTransfer;"Posted Fund Transfer"."From Fund Code")
            {
            }
            column(ToAccountNo_PostedFundTransfer;"Posted Fund Transfer"."To Account No")
            {
            }
            column(ToFundCode_PostedFundTransfer;"Posted Fund Transfer"."To Fund Code")
            {
            }
            column(ToClientName_PostedFundTransfer;"Posted Fund Transfer"."To Client Name")
            {
            }
            column(CompanyInformationName;CompanyInformation.Name)
            {
            }

            trigger OnPreDataItem()
            begin
                if "Posted Fund Transfer".GetFilter("Posted Fund Transfer"."Value Date")='' then
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

    var
        CompanyInformation: Record "Company Information";
}

