report 50021 "Client Holding Bal-Per fund"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Client Holding Bal-Per fund.rdlc';

    dataset
    {
        dataitem("Client Account";"Client Account")
        {
            RequestFilterFields = "Client ID","Account No","Fund No","No of Units";
            column(ClientID_Client;Client."Membership ID")
            {
            }
            column(Name_Client;Client.Name)
            {
            }
            column(Gender_Client;Client.Gender)
            {
            }
            column(BVN;Client."BVN Number")
            {
            }
            column(ClientType;Client."Client Type")
            {
            }
            column(BankCode_ClientAccount;"Client Account"."Bank Code")
            {
            }
            column(BankAccountName_ClientAccount;"Client Account"."Bank Account Name")
            {
            }
            column(BankAccountNumber_ClientAccount;"Client Account"."Bank Account Number")
            {
            }
            column(DividendMandate_ClientAccount;"Client Account"."Dividend Mandate")
            {
            }
            column(EMail_ClientAccount;"Client Account"."E-Mail")
            {
            }
            column(PhoneNo_ClientAccount;"Client Account"."Phone No.")
            {
            }
            column(KYCTier_ClientAccount;"Client Account"."KYC Tier")
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

            trigger OnAfterGetRecord()
            begin
                if Client.Get("Client Account"."Client ID") then
                  ACCmanager:=Client."Account Executive Code"+'-'+ClientAdministration.GetAccountManagerName(Client."Account Executive Code");

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
                "Client Account".SetRange("Client Account"."Fund No",FundCode);
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
                    field("Fund Code";FundCode)
                    {
                        TableRelation = Fund;
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
        if FundCode='' then
          Error('Please select the Fund Code');
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
        FundCode: Code[20];
        Client: Record Client;
}

