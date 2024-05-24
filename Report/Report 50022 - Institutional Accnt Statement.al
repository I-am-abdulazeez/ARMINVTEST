report 50022 "Institutional Accnt Statement"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Institutional Accnt Statement.rdlc';

    dataset
    {
        dataitem(Client;Client)
        {
            RequestFilterFields = "Membership ID";
            column(AccountNo_ClientAccount;AccountNo)
            {
            }
            column(ClientID_ClientAccount;AccountNo)
            {
            }
            column(FundNo_ClientAccount;fund.Name)
            {
            }
            column(EMail_ClientAccount;Client."E-Mail")
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
            column(Nav;Nav)
            {
            }
            column(TodaysPrice;TodaysPrice)
            {
            }
            column(ShowAverage;ShowAverage)
            {
            }
            column(OpeningPrice;OpeningPrice)
            {
            }
            column(NavUnits;NavUnits)
            {
            }
            column(EmployerNAV;EmployerNAV)
            {
            }
            column(EmployeeNAV;EmployeeNAV)
            {
            }
            column(Openingbalamt;Openingbalamt)
            {
            }
            dataitem("Client Transactions";"Client Transactions")
            {
                DataItemLink = "Client ID"=FIELD("Membership ID");
                DataItemTableView = SORTING("Value Date","Entry No") ORDER(Ascending);
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
                column(ValueDate_ClientTransactions2;"Client Transactions"."Value Date")
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
                column(EmployeeAmt;EmployeeAmt)
                {
                }
                column(EmployerAmt;EmployerAmt)
                {
                }
                column(TotalWithdawals;TotalWithdawals)
                {
                }
                column(TotalContributions;TotalContributions)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if StartDatePeriod=0D then
                      StartDatePeriod:="Client Transactions"."Value Date";

                    Noofmonths:=Round(((EndDate-StartDatePeriod)/31),1,'=');
                    if Noofmonths=0 then Noofmonths:=1;
                    //TotalUnits:=TotalUnits+"Client Transactions"."No of Units";
                    //Value:=TotalUnits*"Client Transactions"."Price Per Unit";

                    EmployeeAmt:=0;
                    EmployerAmt:=0;

                    if "Client Transactions"."Contribution Type"="Client Transactions"."Contribution Type"::Employee then
                      EmployeeAmt:="Client Transactions".Amount
                    else
                      EmployerAmt:="Client Transactions".Amount;

                    if "Client Transactions"."Transaction Type"="Client Transactions"."Transaction Type"::Subscription then  begin
                      TotalContributions:=TotalContributions+"Client Transactions".Amount;
                    end else begin
                      TotalWithdawals:=TotalWithdawals+"Client Transactions".Amount;
                    end;

                    //
                    //
                    if ("Client Transactions"."Transaction Type" = "Client Transactions"."Transaction Type"::Redemption)
                      and ("Client Transactions"."Transaction Sub Type 3"="Client Transactions"."Transaction Sub Type 3"::"Unit Switch") then begin
                     TotalUnits := 0;
                    end else
                    if ("Client Transactions"."Transaction Type" = "Client Transactions"."Transaction Type"::Subscription)
                      and ("Client Transactions"."Transaction Sub Type 3"="Client Transactions"."Transaction Sub Type 3"::"Unit Switch") then begin

                      ClientTransactions.Reset;
                      ClientTransactions.SetRange("Account No","Client Transactions"."Account No");
                      ClientTransactions.SetRange("Value Date","Client Transactions"."Value Date");
                      ClientTransactions.SetRange("Transaction Type","Client Transactions"."Transaction Type");
                      ClientTransactions.SetRange("Transaction Sub Type 3","Client Transactions"."Transaction Sub Type 3");
                      ClientTransactions.SetFilter("Contribution Type",'<>%1',"Client Transactions"."Contribution Type");
                      if ClientTransactions.FindFirst then
                      TotalUnits:="Client Transactions"."No of Units"+ClientTransactions."No of Units"
                      else
                      TotalUnits:="Client Transactions"."No of Units";
                      end
                    else
                    TotalUnits:=TotalUnits+"Client Transactions"."No of Units";
                    //

                    if "Client Transactions"."Transaction Sub Type 3"="Client Transactions"."Transaction Sub Type 3"::"Unit Switch" then begin
                     if "Client Transactions"."Transaction Type"="Client Transactions"."Transaction Type"::Subscription then  begin
                      TotalContributions:=TotalContributions-Abs("Client Transactions".Amount);

                    end else begin
                      TotalWithdawals:=TotalWithdawals+Abs("Client Transactions".Amount);

                    end ;
                    end ;

                    Value:=TotalUnits*"Client Transactions"."Price Per Unit";
                end;

                trigger OnPreDataItem()
                begin
                    "Client Transactions".SetRange("Client Transactions"."Fund Group",Fundgroup);
                    "Client Transactions".SetFilter("Value Date",'%1..%2',StartDate,EndDate);
                    //"Client Transactions".SETCURRENTKEY("Value Date","Transaction Type");
                    "Client Transactions".SetCurrentKey("Value Date","Entry No");
                    "Client Transactions".Ascending(true);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                OpenBalUnits:=0;
                
                EndDatePeriod:=EndDate;
                if StartDate=0D then begin
                  ClientTransactions.Reset;
                  ClientTransactions.SetRange("Client ID",Client."Membership ID");
                  ClientTransactions.SetCurrentKey("Value Date");
                  ClientTransactions.Ascending(true);
                  if ClientTransactions.FindFirst then
                    StartDate:=ClientTransactions."Value Date";
                end;
                
                
                
                
                if StartDate<>0D then begin
                  StartDatePeriod:=StartDate;
                ClientAccount.Reset;
                ClientAccount.SetRange(ClientAccount."Client ID",Client."Membership ID");
                ClientAccount.SetFilter("Date Filter",'..%1',CalcDate('-1D',StartDate));
                ClientAccount.SetFilter("No of Units",'>%1',0);
                ClientAccount.SetRange("Fund Group",Fundgroup);
                if ClientAccount.FindFirst then begin
                  repeat
                  ClientAccount.CalcFields("No of Units","Total Amount Invested","Total Amount Withdrawn");
                OpenBalUnits:=OpenBalUnits+ClientAccount."No of Units";
                OpenBalValue:=OpenBalValue+(OpenBalUnits*FundAdministration.GetFundNAVPrice(ClientAccount."Fund No",CalcDate('-1D',StartDate)));
                OpeningPrice:=FundAdministration.GetFundNAVPrice(ClientAccount."Fund No",CalcDate('-1D',StartDate));
                Openingbalamt:=ClientAccount."Total Amount Invested"+ClientAccount."Total Amount Withdrawn";
                
                until ClientAccount.Next=0;
                end
                end;
                
                
                ClientAccount.Reset;
                ClientAccount.SetRange(ClientAccount."Client ID",Client."Membership ID");
                ClientAccount.SetRange("Institutional Active Fund",true);
                ClientAccount.SetRange("Fund Group",Fundgroup);
                ClientAccount.SetFilter("Date Filter",'..%1',EndDate);
                if ClientAccount.FindFirst then begin
                  ClientAccount.CalcFields("No of Units");
                NavUnits:=ClientAccount."No of Units";
                Nav:=FundAdministration.GetNAV(EndDate,ClientAccount."Fund No",ClientAccount."No of Units");
                TodaysPrice:=FundAdministration.GetFundNAVPrice(ClientAccount."Fund No",EndDate);
                fund.Get(ClientAccount."Fund No");
                if (ClientAccount."Staff ID"<>'') and (ClientAccount."Staff ID"<>'0') then
                AccountNo:=ClientAccount."Staff ID"
                else
                  AccountNo:=ClientAccount."Client ID";
                end;
                
                TotalUnits:=OpenBalUnits;
                Value:=OpenBalValue;
                
                //Maxwell: To Calculate Employeee and Employer Contributions on Statement Summary
                /*ClientAccount.RESET;
                ClientAccount.SETRANGE(ClientAccount."Client ID",Client."Membership ID");
                //ClientAccount.SETRANGE("Institutional Active Fund",TRUE);
                ClientAccount.SETFILTER("Date Filter",'%1..%2',StartDate,EndDate);
                IF ClientAccount.FINDFIRST THEN BEGIN
                  ClientAccount.CALCFIELDS("Employee Units","Employer Units");
                  EmployeeNAV:=FundAdministration.GetNAV(TODAY,ClientAccount."Fund No",ClientAccount."Employee Units");
                  EmployerNAV:=FundAdministration.GetNAV(TODAY,ClientAccount."Fund No",ClientAccount."Employer Units");
                END;*/
                //
                
                
                //Previous Implementation is shown in comment above.
                //Maxwell: To Calculate Employee Contributions on Statement Summary (12/22/20 - 12/23/2020).
                ClientTransactions.Reset;
                ClientTransactions.SetRange(ClientTransactions."Client ID",Client."Membership ID");
                ClientTransactions.SetRange("Contribution Type", ClientTransactions."Contribution Type"::Employee);
                ClientTransactions.SetFilter("Value Date",'%1..%2',StartDate,EndDate);
                if ClientTransactions.FindFirst then begin
                  ClientTransactions.CalcSums("No of Units");
                  EmployeeNAV:=FundAdministration.GetNAV(Today,ClientTransactions."Fund Code",ClientTransactions."No of Units");
                end;
                //
                
                //Maxwell: To Calculate Employer Contributions on Statement Summary (12/22/20 - 12/23/2020).
                ClientTransactions.Reset;
                ClientTransactions.SetRange(ClientTransactions."Client ID",Client."Membership ID");
                ClientTransactions.SetRange("Contribution Type", ClientTransactions."Contribution Type"::Employer);
                ClientTransactions.SetFilter("Value Date",'%1..%2',StartDate,EndDate);
                if ClientTransactions.FindFirst then begin
                  ClientTransactions.CalcSums("No of Units");
                  EmployerNAV:=FundAdministration.GetNAV(Today,ClientTransactions."Fund Code",ClientTransactions."No of Units");
                end;
                //
                
                if AccountManager.Get(Client."Account Executive Code") then;

            end;

            trigger OnPreDataItem()
            begin
                if EndDate=0D then
                  EndDate:=Today;
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
                    field("Fund Group";Fundgroup)
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
        StatementTexts.Get;
        if Fundgroup='' then Error('Please Input Fund group');
    end;

    var
        Companyinfo: Record "Company Information";
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
        EmployeeAmt: Decimal;
        EmployerAmt: Decimal;
        ClientTransactions: Record "Client Transactions";
        AccountNo: Code[40];
        OpeningPrice: Decimal;
        TotalWithdawals: Decimal;
        TotalContributions: Decimal;
        NavUnits: Decimal;
        Openingbalamt: Decimal;
        Fundgroup: Code[40];
        EmployeeNAV: Decimal;
        EmployerNAV: Decimal;
        PreviousUnits: Decimal;

    procedure GetFundgroup(Fgroup: Code[50])
    begin
        Fundgroup:=Fgroup;
    end;
}

