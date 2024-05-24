report 50028 "Client Holding Balance Institu"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Client Holding Balance Institu.rdlc';
    Caption = 'Client Holding Balance Institutional';

    dataset
    {
        dataitem("Client Account";"Client Account")
        {
            RequestFilterFields = "Account No","Fund No";
            column(ClientID_Client;Client."Membership ID")
            {
            }
            column(Name_Client;Client.Name)
            {
            }
            column(Company;COMPANYPROPERTY.DisplayName)
            {
            }
            column(AccountManager_Client;ACCmanager)
            {
            }
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
            column(StaffID_ClientAccount;SharpID)
            {
            }
            column(FundGroupsDescription;FundGroups.Description)
            {
            }

            trigger OnAfterGetRecord()
            begin

                if ("Client Account"."No of Units"=0) or ("Client Account"."No of Units"<0.05) then
                  CurrReport.Skip;
                SharpID:='';
                if Client.Get("Client Account"."Client ID") then
                  ACCmanager:=Client."Account Executive Code"+'-'+ClientAdministration.GetAccountManagerName(Client."Account Executive Code");

                fundname:='';
                TotalNAV:=FundAdministration.GetNAV(Today,"Client Account"."Fund No","Client Account"."No of Units");
                EmployeeNAV:=FundAdministration.GetNAV(Today,"Client Account"."Fund No","Client Account"."Employee Units");
                EmployerNAV:=FundAdministration.GetNAV(Today,"Client Account"."Fund No","Client Account"."Employer Units");
                if Fund.Get("Client Account"."Fund No") then
                  fundname:=Fund.Name;
                if ("Client Account"."Staff ID"<>'') and ("Client Account"."Staff ID"<>'0')then
                SharpID:="Client Account"."Staff ID"
                else
                  SharpID:="Client Account"."Client ID";
            end;

            trigger OnPreDataItem()
            begin
                if EndDate=0D then
                  EndDate:=Today;
                "Client Account".SetFilter("Client Account"."Date Filter",'%1..%2',StartDate,EndDate);
                "Client Account".SetRange("Client Account"."Fund Group",FundGroupcode);
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
                    field("Fund Group";FundGroupcode)
                    {
                        TableRelation = "Fund Groups";
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
        if FundGroupcode='' then
          Error('Please Input Fund Group');

         FundGroups.SetRange(code,FundGroupcode);
         if FundGroups.FindFirst then;
    end;

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
        FundGroupcode: Code[40];
        Client: Record Client;
        SharpID: Code[40];
        FundGroups: Record "Fund Groups";
}

