report 50099 "Update redemption percentages"
{
    ProcessingOnly = true;

    dataset
    {
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

    trigger OnPreReport()
    begin
        window.Open('Calculating ...... #1####');
        Entryno:=1512000;
        FundGroups.Reset;
        FundGroups.SetFilter(code,'<>%1','EXXON');
        if FundGroups.FindFirst then
          repeat
        
        
           Fund.Reset;
            //Fund.SETFILTER("Fund Code",'=%1|%2|%3|%4|%5|%6|%7','GNAGG','GNBAL','GNLTG','EMSPC','GNINC','EMRSC','GNCONS');
            Fund.SetRange("Fund Group",FundGroups.code);
            if Fund.FindFirst then
              repeat
                if (Fund."Fund Code"='ARMMMF') or(Fund."Fund Code"='ARMDF') or (Fund."Fund Code"='AGF')
                   or (Fund."Fund Code"='ARMEF') or (Fund."Fund Code"='ETH') then
                  Error('Wrong Fund');
                ClientAccount.Reset;
                ClientAccount.SetRange("Fund No",Fund."Fund Code");
        
                if ClientAccount.FindFirst then
                  repeat
                    window.Update(1,ClientAccount."Account No");
                    Employee:=0;
                    Employer:=0;
                    ClientTransactions.Reset;
                    ClientTransactions.SetCurrentKey("Account No","Client ID","Value Date");
                    ClientTransactions.SetRange("Account No",ClientAccount."Account No");
                    //ClientTransactions.SETRANGE("Transaction Type",ClientTransactions."Transaction Type"::Redemption);
        
                    //ClientTransactions.SETRANGE("Contribution Type", ClientTransactions."Contribution Type"::Employee);
                    if ClientTransactions.FindFirst then
                      repeat
                       // ClientTransactions.DELETE;
                      /*
                        Employee:=ClientTransactions.Amount;
                        ClientTransactions2.RESET;
                        ClientTransactions2.SETCURRENTKEY("Account No","Client ID","Value Date");
                        ClientTransactions2.SETRANGE("Account No",ClientAccount."Account No");
                        ClientTransactions2.SETRANGE("Transaction Type",ClientTransactions2."Transaction Type"::Redemption);
                        ClientTransactions2.SETRANGE("Contribution Type", ClientTransactions2."Contribution Type"::Employer);
                        ClientTransactions2.SETRANGE("Value Date",ClientTransactions."Value Date");
                        IF NOT ClientTransactions2.FINDFIRST THEN BEGIN
                          EmployeeEmployer.RESET;
                          EmployeeEmployer.SETRANGE(AccountNo,ClientTransactions."Account No");
                         EmployeeEmployer.SETFILTER(ValueDate,'..%1',ClientTransactions."Value Date");
                         EmployeeEmployer.CALCSUMS("EMployee%","Employer%");
                        IF EmployeeEmployer."Employer%"<>0 THEN BEGIN
                          {Entryno:=Entryno+1;
                          EmployeeEmployerred.INIT;
                          EmployeeEmployerred.EntryNo:=Entryno;
                          EmployeeEmployerred.ValueDate:=ClientTransactions."Value Date";
                          EmployeeEmployerred.ClientID:=ClientAccount."Client ID";
                          EmployeeEmployerred.AccountNo:=ClientAccount."Account No";
                          EmployeeEmployerred."EMployee%":= (EmployeeEmployer."EMployee%"/(EmployeeEmployer."EMployee%"+EmployeeEmployer."Employer%"))*ClientTransactions.Amount;
                          EmployeeEmployerred."Employer%":= (EmployeeEmployer."Employer%"/(EmployeeEmployer."EMployee%"+EmployeeEmployer."Employer%"))*ClientTransactions.Amount;
                          EmployeeEmployerred.Total:=ClientTransactions.Amount;
                          EmployeeEmployerred."OLd Entry":=ClientTransactions."Entry No";
                          EmployeeEmployerred.INSERT;}
        
        
                    Entryno:=Entryno+1;
                  ClientTransactions3.INIT;
                  ClientTransactions3:=ClientTransactions;
                  ClientTransactions3."Entry No":=Entryno;
                   ClientTransactions3."Contribution Type":=ClientTransactions3."Contribution Type"::Employee;
                    ClientTransactions3.Amount:=(EmployeeEmployer."EMployee%"/(EmployeeEmployer."EMployee%"+EmployeeEmployer."Employer%"))*ClientTransactions.Amount;
                  ClientTransactions3."No of Units":=(EmployeeEmployer."EMployee%"/(EmployeeEmployer."EMployee%"+EmployeeEmployer."Employer%"))*ClientTransactions."No of Units";
        
                  ClientTransactions3.INSERT;
        
                    Entryno:=Entryno+1;
                  ClientTransactions3.INIT;
                  ClientTransactions3:=ClientTransactions;
                  ClientTransactions3."Entry No":=Entryno;
                  ClientTransactions3."Contribution Type":=ClientTransactions3."Contribution Type"::Employer;
                  ClientTransactions3.Amount:=(EmployeeEmployer."Employer%"/(EmployeeEmployer."EMployee%"+EmployeeEmployer."Employer%"))*ClientTransactions.Amount;
                  ClientTransactions3."No of Units":=(EmployeeEmployer."Employer%"/(EmployeeEmployer."EMployee%"+EmployeeEmployer."Employer%"))*ClientTransactions."No of Units";
                  ClientTransactions3.INSERT;
                        END;
                       END;
        
                        */
        
        
                      until ClientTransactions.Next=0;
                  until ClientAccount.Next=0;
              until Fund.Next=0;
        
          until FundGroups.Next=0;
        
        
          window.Close;
          Message('Update complete');

    end;

    var
        Fund: Record Fund;
        FundGroups: Record "Fund Groups";
        ClientAccount: Record "Client Account";
        ClientTransactions: Record "Client Transactions";
        ClientTransactions2: Record "Client Transactions";
        Entryno: Integer;
        EmployeeEmployerred: Record "Employee Employer redemption";
        Employer: Decimal;
        Employee: Decimal;
        window: Dialog;
        EmployeeEmployer: Record "Employee Employer";
        ClientTransactions3: Record "Client Transactions";
}

