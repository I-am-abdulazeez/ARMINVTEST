report 50023 "Institutional Active"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Institutional Active.rdlc';

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
            dataitem("Fund Groups";"Fund Groups")
            {
                dataitem("Client Account";"Client Account")
                {
                    DataItemLink = "Fund Group"=FIELD(code);
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
                        if account='' then  begin
                          account:="Client Account"."Account No";
                          amt:=TotalNAV;
                        end else begin
                          if TotalNAV>amt then begin
                             account:="Client Account"."Account No";
                          amt:=TotalNAV;
                          end
                        end;
                    end;

                    trigger OnPostDataItem()
                    begin
                        clientacc.Reset;
                        clientacc.SetRange("Account No",account);
                        if clientacc.FindFirst then begin
                          clientacc."Institutional Active Fund":=true;
                          clientacc.Modify;
                        end
                    end;

                    trigger OnPreDataItem()
                    begin
                        if EndDate=0D then
                          EndDate:=Today;
                        "Client Account".SetRange("Client Account"."Client ID",Client."Membership ID");
                        "Client Account".SetFilter("Client Account"."Date Filter",'%1..%2',StartDate,EndDate);
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    account:='';
                    amt:=0;
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
        amt: Decimal;
        account: Code[40];
        clientacc: Record "Client Account";
}

