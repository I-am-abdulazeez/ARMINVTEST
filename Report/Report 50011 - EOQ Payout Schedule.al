report 50011 "EOQ Payout Schedule"
{
    DefaultLayout = RDLC;
    RDLCLayout = './EOQ Payout Schedule.rdlc';

    dataset
    {
        dataitem("EOQ Header";"EOQ Header")
        {
            column(CompanyInformationName;CompanyInformation.Name)
            {
            }
            column(Quarter_EOQHeader;"EOQ Header".Quarter)
            {
            }
            column(FundCode_EOQHeader;"EOQ Header"."Fund Code")
            {
            }
            dataitem("EOQ Lines";"EOQ Lines")
            {
                DataItemLink = "Header No"=FIELD(No);
                DataItemTableView = WHERE("Dividend Mandate"=CONST(Payout));
                column(AccountNo_EOQLines;"EOQ Lines"."Account No")
                {
                }
                column(ClientID_EOQLines;"EOQ Lines"."Client ID")
                {
                }
                column(ClientName_EOQLines;"EOQ Lines"."Client Name")
                {
                }
                column(FundCode_EOQLines;"EOQ Lines"."Fund Code")
                {
                }
                column(BankCode_EOQLines;"EOQ Lines"."Bank Code")
                {
                }
                column(BankAccount_EOQLines;"EOQ Lines"."Bank Account")
                {
                }
                column(DividendAmount_EOQLines;"EOQ Lines"."Dividend Amount")
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

