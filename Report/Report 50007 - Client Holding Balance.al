report 50007 "Client Holding Balance"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Client Holding Balance.rdlc';

    dataset
    {
        dataitem(Client;Client)
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "Membership ID";
            column(ClientID_Client;Client."Membership ID")
            {
            }
            column(Name_Client;Client.Name)
            {
            }
            column(Company;COMPANYPROPERTY.DisplayName)
            {
            }
            column(ClientType_Client;Client."Client Type")
            {
            }
            column(AccountManager_Client;ACCmanager)
            {
            }
            dataitem("Client Account";"Client Account")
            {
                DataItemLink = "Client ID"=FIELD("Membership ID");
                RequestFilterFields = "Account No","Fund No";
                column(AccountNo_ClientAccount;"Client Account"."Account No")
                {
                }
                column(EmployeeUnits_ClientAccount;"Client Account"."Employee Units")
                {
                }
                column(EmployerUnits_ClientAccount;"Client Account"."Employer Units")
                {
                }
                column(NoofUnits_ClientAccount;"Client Account"."No of Units")
                {
                }
                column(TotalNAV;TotalNAV)
                {
                }
                column(EmployerNAV;EmployerNAV)
                {
                }
                column(EmployeeNAV;EmployeeNAV)
                {
                }
                column(fundname;fundname)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    fundname:='';
                    TotalNAV:=FundAdministration.GetNAV(Today,"Client Account"."Fund No","Client Account"."No of Units");
                    EmployeeNAV:=FundAdministration.GetNAV(Today,"Client Account"."Fund No","Client Account"."Employee Units");
                    EmployerNAV:=FundAdministration.GetNAV(Today,"Client Account"."Fund No","Client Account"."Employer Units");
                    if Fund.Get("Client Account"."Fund No") then
                      fundname:=Fund.Name;
                end;

                trigger OnPreDataItem()
                begin
                    if EndDate=0D then
                      EndDate:=Today;
                    "Client Account".SetFilter("Client Account"."Date Filter",'%1..%2',StartDate,EndDate);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                ACCmanager:=Client."Account Executive Code"+'-'+ClientAdministration.GetAccountManagerName(Client."Account Executive Code");
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

    var
        TotalNAV: Decimal;
        EmployerNAV: Decimal;
        EmployeeNAV: Decimal;
        StartDate: Date;
        EndDate: Date;
        FundAdministration: Codeunit "Fund Administration";
        ClientAdministration: Codeunit "Client Administration";
        ACCmanager: Text;
        Fund: Record Fund;
        fundname: Text;
}

