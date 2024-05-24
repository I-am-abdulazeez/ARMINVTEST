report 50000 "Account Statement"
{
    // version MFD-1.0

    DefaultLayout = RDLC;
    RDLCLayout = './Account Statement.rdlc';

    dataset
    {
        dataitem("Client Account";"Client Account")
        {
            column(AccountNo_ClientAccount;"Client Account"."Account No")
            {
            }
            column(ClientID_ClientAccount;"Client Account"."Client ID")
            {
            }
            column(FundNo_ClientAccount;fund.Name)
            {
            }
            column(EMail_ClientAccount;"Client Account"."E-Mail")
            {
            }
            column(CompanyinfoPicture;Companyinfo.Picture)
            {
            }
            column(CompanyinfoStatementAddress1;StatementTexts."Statement Address 1")
            {
            }
            column(CompanyinfoStatementAddress2;StatementTexts."Statement Address 2")
            {
            }
            column(CompanyinfoStatementAddress3;StatementTexts."Statement Address 3")
            {
            }
            column(CompanyinfoStatementAddress4;StatementTexts."Statement Address 4")
            {
            }
            column(CompanyinfoStatementAddress5;StatementTexts."Statement Address 5")
            {
            }
            column(CompanyinfoFooterNote1;StatementTexts."Footer Note1")
            {
            }
            column(CompanyinfoStatementAddressHeader1;StatementTexts."Statement Address 1 Header")
            {
            }
            column(CompanyinfoStatementAddressHeader2;StatementTexts."Statement Address 2 Header")
            {
            }
            column(CompanyinfoStatementAddressHeader3;StatementTexts."Statement Address 3 Header")
            {
            }
            column(CompanyinfoStatementAddressHeader4;StatementTexts."Statement Address 4 Header")
            {
            }
            column(CompanyinfoStatementAddressHeader5;StatementTexts."Statement Address 5 Header")
            {
            }
            column(CompanyinfoFooterNote;StatementTexts."Footer Note2")
            {
            }
            column(ClientName;Client.Name)
            {
            }
            column(ClientPhoneNo;Client."Phone Number")
            {
            }
            column(RMCode;Client."Account Executive Code")
            {
            }
            column(RMName;AccountManager."First Name" + ' '+AccountManager.Surname)
            {
            }
            column(OpenBalUnits;OpenBalUnits)
            {
            }
            column(OpenBalValue;OpenBalValue)
            {
            }
            column(TotalAmountInvested_ClientAccount;"Client Account"."Total Amount Invested")
            {
            }
            column(TotalAmountWithdrawn_ClientAccount;"Client Account"."Total Amount Withdrawn")
            {
            }
            column(AccruedInterest_ClientAccount;"Client Account"."Accrued Interest")
            {
            }
            column(ChargesonAccruedInterest_ClientAccount;"Client Account"."Charges on Accrued Interest")
            {
            }
            column(Nav;Nav)
            {
            }
            column(TodaysPrice;TodaysPrice)
            {
            }
            column(ShowAverage;ShowAverage)
            {
            }
            column(MFAccruedInterest_ClientAccount;"Client Account"."MF Accrued Interest")
            {
            }
            column(TotalAmountInvested;TotalAmountInvested)
            {
            }
            column(TotalAmountWithdrawn;TotalAmountWithdrawn)
            {
            }
            dataitem("Client Transactions";"Client Transactions")
            {
                DataItemLink = "Account No"=FIELD("Account No");
                DataItemTableView = SORTING("Account No","Client ID","Value Date") ORDER(Ascending) WHERE("Dividend Paid"=CONST(false));
                column(Narration_ClientTransactions;"Client Transactions".Narration)
                {
                }
                column(Amount_ClientTransactions;"Client Transactions".Amount)
                {
                }
                column(PricePerUnit_ClientTransactions;"Client Transactions"."Price Per Unit")
                {
                }
                column(NoofUnits_ClientTransactions;"Client Transactions"."No of Units")
                {
                }
                column(ValueDate_ClientTransactions;"Client Transactions"."Value Date")
                {
                }
                column(TotalUnits;TotalUnits)
                {
                }
                column(TransactionType_ClientTransactions;"Client Transactions"."Transaction Type")
                {
                }
                column(value;Value)
                {
                }
                column(StartDatePeriod;Format(StartDatePeriod,0,7))
                {
                }
                column(EndDatePeriod;Format(EndDatePeriod,0,7))
                {
                }
                column(noofmonths;Noofmonths)
                {
                }
                column(noofmonthstxt;Format(Noofmonths))
                {
                }
                column(AccruedInterestUnit;AccruedInterestUnit)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if StartDatePeriod=0D then
                      StartDatePeriod:="Client Transactions"."Value Date";

                    Noofmonths:=Round(((EndDate-StartDatePeriod)/31),1,'=');
                    if Noofmonths=0 then Noofmonths:=1;
                    TotalUnits:=TotalUnits+"Client Transactions"."No of Units";
                    Value:=TotalUnits*"Client Transactions"."Price Per Unit";
                    if ("Client Transactions"."Transaction Type" = "Client Transactions"."Transaction Type"::Dividend) and ("Client Transactions"."Dividend Paid" = false) then
                      AccruedInterestUnit := AccruedInterestUnit+"Client Transactions"."No of Units";
                end;

                trigger OnPreDataItem()
                begin
                    "Client Transactions".SetFilter("Value Date",'%1..%2',StartDate,EndDate);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                OpenBalUnits:=0;
                "Client Account".CalcFields("No of Units");
                EndDatePeriod:=EndDate;
                EndDatePeriod:=EndDate;
                if StartDate=0D then begin
                  ClientTransactions.Reset;
                  ClientTransactions.SetCurrentKey("Value Date");
                  ClientTransactions.SetRange("Account No","Client Account"."Account No");

                  ClientTransactions.Ascending(true);;
                  if ClientTransactions.FindFirst then
                    StartDate:=ClientTransactions."Value Date";
                end;

                if StartDate<>0D then begin
                  StartDatePeriod:=StartDate;
                ClientAccount.Reset;
                ClientAccount.SetRange(ClientAccount."Account No","Client Account"."Account No");
                ClientAccount.SetFilter("Date Filter",'..%1',CalcDate('-1D',StartDate));
                if ClientAccount.FindFirst then
                  ClientAccount.CalcFields("No of Units");
                OpenBalUnits:=ClientAccount."No of Units";
                OpenBalValue:=OpenBalUnits*FundAdministration.GetFundNAVPrice("Client Account"."Fund No",CalcDate('-1D',StartDate));
                end;


                Client.Get("Client Account"."Client ID");
                TotalUnits:=OpenBalUnits;
                Value:=OpenBalValue;
                //Maxwell: Replaced TODAY with EndDate for statement spooled for a given time
                Nav:=FundAdministration.GetNAV(EndDate,"Client Account"."Fund No","Client Account"."No of Units");
                TodaysPrice:=FundAdministration.GetFundNAVPrice("Client Account"."Fund No",EndDate);
                //Maxwell: Updated to pick the respective amounts for a specified date range
                TotalAmountInvested := FundAdministration.GetTotalAmountInvested("Client Account"."Account No", StartDate,EndDate);
                TotalAmountWithdrawn := FundAdministration.GetTotalAmountWithdrawn("Client Account"."Account No",StartDate,EndDate);


                fund.Get("Client Account"."Fund No");
                if AccountManager.Get(Client."Account Executive Code") then;

                //"Client Account".CALCFIELDS(
                CalcFields("Accrued Interest");


                //NetAccruedInterest := FundTransMgt.GetRedeemableInterest("Client Account"."Account No");
            end;

            trigger OnPreDataItem()
            begin
                if EndDate=0D then
                  EndDate:=Today;
                "Client Account".SetFilter("Client Account"."Date Filter",'..%2',StartDate,EndDate);
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
                    field(ShowAverage;ShowAverage)
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
        Companyinfo.Get;
        Companyinfo.CalcFields(Picture);
        StatementTexts.Get
    end;

    var
        Companyinfo: Record "Company Information";
        Client: Record Client;
        TotalUnits: Decimal;
        Value: Decimal;
        fund: Record Fund;
        AccountManager: Record "Account Manager";
        StartDate: Date;
        EndDate: Date;
        OpenBalUnits: Decimal;
        OpenBalValue: Decimal;
        ClientAccount: Record "Client Account";
        StartDatePeriod: Date;
        EndDatePeriod: Date;
        FundAdministration: Codeunit "Fund Administration";
        Nav: Decimal;
        TodaysPrice: Decimal;
        StatementTexts: Record "Statement Texts";
        Noofmonths: Integer;
        ShowAverage: Boolean;
        ClientTransactions: Record "Client Transactions";
        FundTransMgt: Codeunit "Fund Transaction Management";
        NetAccruedInterest: Decimal;
        AccruedInterestUnit: Decimal;
        TotalAmountInvested: Decimal;
        TotalAmountWithdrawn: Decimal;
}

