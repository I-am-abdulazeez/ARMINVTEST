report 50123 "Client Account Exception"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Client Account Exception.rdlc';

    dataset
    {
        dataitem("Client Account";"Client Account")
        {
            DataItemTableView = WHERE("No of Units"=FILTER(<0),"Account Status"=FILTER(<>Closed));
            RequestFilterFields = "Fund No";
            column(AccountNo_ClientAccount;"Client Account"."Account No")
            {
            }
            column(ClientID_ClientAccount;"Client Account"."Client ID")
            {
            }
            column(FundNo_ClientAccount;"Client Account"."Fund No")
            {
            }
            column(sNo;sNo)
            {
            }
            column(NoofUnits_ClientAccount;"Client Account"."No of Units")
            {
            }
            column(AccountStatus_ClientAccount;"Client Account"."Account Status")
            {
            }
            column(ClientName_ClientAccount;"Client Account"."Client Name")
            {
            }
            column(ExceptionDetails;ExceptionDetails)
            {
            }

            trigger OnAfterGetRecord()
            begin
                sNo := sNo +1;
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
        client: Record Client;
        sNo: Integer;
        ExceptionDetails: Text;
}

