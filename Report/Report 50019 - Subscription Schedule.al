report 50019 "Subscription Schedule"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Subscription Schedule.rdlc';

    dataset
    {
        dataitem("Client Transactions";"Client Transactions")
        {
            DataItemTableView = WHERE("Transaction Type"=CONST(Subscription));
            RequestFilterFields = "Value Date";
            column(CompanyInformationName;CompanyInformation.Name)
            {
            }
            column(ClientID_ClientTransactions;"Client Transactions"."Client ID")
            {
            }
            column(ClientName;ClientName)
            {
            }
            column(ClientEmail;ClientEmail)
            {
            }
            column(PhoneNumber;PhoneNumber)
            {
            }
            column(ClientAddress;ClientAddress)
            {
            }
            column(FundName;FundName)
            {
            }
            column(ValueDate_ClientTransactions;"Client Transactions"."Value Date")
            {
            }
            column(Amount_ClientTransactions;"Client Transactions".Amount)
            {
            }
            column(PricePerUnit_ClientTransactions;"Client Transactions"."Price Per Unit")
            {
            }
            column(NoofUnits_ClientTransactions;Abs("Client Transactions"."No of Units"))
            {
            }
            column(openingunits;openingunits)
            {
            }
            column(Closingunits;Closingunits)
            {
            }
            column(Narration_ClientTransactions;"Client Transactions".Narration)
            {
            }
            column(TransactionType_ClientTransactions;"Client Transactions"."Transaction Type")
            {
            }
            column(AccountNo_ClientTransactions;"Client Transactions"."Account No")
            {
            }
            column(OldAccountNumber_ClientAccount;OldMembershipID)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Closingunits:=0;
                  openingunits:=0;
                  OldMembershipID :='';
                if Client.Get("Client Transactions"."Client ID") then begin
                  ClientName:=Client.Name;
                  ClientAddress:=Client."Mailing Address";
                  ClientEmail:=Client."E-Mail";
                  PhoneNumber:=Client."Phone Number";
                  end
                else
                  ClientName:='';
                if Fund.Get("Client Transactions"."Fund Code") then
                  FundName:=Fund.Name
                else
                  FundName:='';
                ClientAccount.Reset;
                ClientAccount.SetRange("Account No","Client Transactions"."Account No");
                ClientAccount.SetFilter("Date Filter",'%1..%2',0D,"Client Transactions"."Value Date");
                if ClientAccount.FindFirst then begin
                  ClientAccount.CalcFields("No of Units");
                  Closingunits:=ClientAccount."No of Units";
                  openingunits:=Closingunits-"Client Transactions"."No of Units";
                  OldMembershipID :=ClientAccount."Old Account Number";
                end
            end;

            trigger OnPreDataItem()
            begin
                if StartDate=0D then Error('Please input Start Date');
                if EndDate=0D then Error('Please input End Date');
                "Client Transactions".SetFilter("Value Date",'%1..%2',StartDate,EndDate);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    field("Start Date";StartDate)
                    {
                    }
                    field("End Date";EndDate)
                    {
                    }
                }
            }
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
        Fund: Record Fund;
        FundName: Text;
        Client: Record Client;
        ClientName: Text;
        StartDate: Date;
        EndDate: Date;
        openingunits: Decimal;
        Closingunits: Decimal;
        ClientAccount: Record "Client Account";
        ClientAddress: Text[250];
        ClientEmail: Text[250];
        PhoneNumber: Code[30];
        OldMembershipID: Text;
}

