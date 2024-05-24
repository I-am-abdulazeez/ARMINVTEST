report 50018 "Employee Employer Redemption"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Employee Employer Redemption.rdlc';

    dataset
    {
        dataitem(Client;Client)
        {
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
                column(TotalAmountWithdrawn_ClientAccount;"Client Account"."Total Amount Withdrawn")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    TotalNAV:=FundAdministration.GetNAV(Today,"Client Account"."Fund No","Client Account"."No of Units");
                    EmployeeNAV:=FundAdministration.GetNAV(Today,"Client Account"."Fund No","Client Account"."Employee Units");
                    EmployerNAV:=FundAdministration.GetNAV(Today,"Client Account"."Fund No","Client Account"."Employer Units");
                end;

                trigger OnPreDataItem()
                begin
                    if EndDate=0D then
                      EndDate:=Today;
                    "Client Account".SetFilter("Client Account"."Date Filter",'%1..%2',StartDate,EndDate);
                end;
            }
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
}

