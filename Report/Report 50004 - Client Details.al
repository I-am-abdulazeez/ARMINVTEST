report 50004 "Client Details"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Client Details.rdlc';

    dataset
    {
        dataitem(Client;Client)
        {
            column(ClientID_Client;Client."Membership ID")
            {
            }
            column(Name_Client;Client.Name)
            {
            }
            column(Address_Client;Client."Mailing Address")
            {
            }
            column(PhoneNo_Client;Client."Phone Number")
            {
            }
            column(AccountManager_Client;ACCmanager)
            {
            }
            column(DateOfBirth_Client;Client."Date Of Birth")
            {
            }
            column(Gender_Client;Client.Gender)
            {
            }
            column(EMail_Client;Client."E-Mail")
            {
            }
            column(Company;COMPANYPROPERTY.DisplayName)
            {
            }
            column(Religion_Client;Client.Religion)
            {
            }
            column(MaritalStatus_Client;Client."Marital Status")
            {
            }
            column(Occupation_Client;Client."Business/Occupation")
            {
            }
            column(Nationality_Client;Client.Nationality)
            {
            }
            column(CountryRegionCode_Client;Client.Country)
            {
            }
            dataitem("Client Account";"Client Account")
            {
                DataItemLink = "Client ID"=FIELD("Membership ID");
                column(AccountNo_ClientAccount;"Client Account"."Account No")
                {
                }
                column(FundNo_ClientAccount;"Client Account"."Fund No")
                {
                }
                column(BankAccountName_ClientAccount;"Client Account"."Bank Account Name")
                {
                }
                column(BankAccountNumber_ClientAccount;"Client Account"."Bank Account Number")
                {
                }
                column(KYCTier_ClientAccount;"Client Account"."KYC Tier")
                {
                }
                column(DividendMandate_ClientAccount;"Client Account"."Dividend Mandate")
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                ACCmanager:=ClientAdministration.GetAccountManagerName(Client."Account Executive Code");
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
        ClientAdministration: Codeunit "Client Administration";
        ACCmanager: Text;
}

