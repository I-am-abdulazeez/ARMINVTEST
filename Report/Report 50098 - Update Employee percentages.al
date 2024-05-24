report 50098 "Update Employee percentages"
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
        FundGroups.Reset;
        FundGroups.SetFilter(code,'=%1|%2|%3','EXXON','GN-VESS','GN-GRAT');
        if FundGroups.FindFirst then
          repeat
           Fund.Reset;
            Fund.SetRange("Fund Group",FundGroups.code);
            if Fund.FindFirst then
              repeat
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
                    ClientTransactions.SetRange("Transaction Type",ClientTransactions."Transaction Type"::Subscription);
                    ClientTransactions.SetRange("Contribution Type", ClientTransactions."Contribution Type"::Employee);
                    if ClientTransactions.FindFirst then
                      repeat
                        Employee:=ClientTransactions.Amount;
                        ClientTransactions2.Reset;
                        ClientTransactions2.SetCurrentKey("Account No","Client ID","Value Date");
                        ClientTransactions2.SetRange("Account No",ClientAccount."Account No");
                        ClientTransactions2.SetRange("Transaction Type",ClientTransactions2."Transaction Type"::Subscription);
                        ClientTransactions2.SetRange("Contribution Type", ClientTransactions2."Contribution Type"::Employer);
                        ClientTransactions2.SetRange("Value Date",ClientTransactions."Value Date");
                        if ClientTransactions2.FindFirst then
                          repeat
                            Employer:=ClientTransactions2.Amount

                          until ClientTransactions2.Next=0;
                        Entryno:=Entryno+1;
                        EmployeeEmployer.Init;
                        EmployeeEmployer.EntryNo:=Entryno;
                        EmployeeEmployer.ValueDate:=ClientTransactions."Value Date";
                        EmployeeEmployer.ClientID:=ClientAccount."Client ID";
                        EmployeeEmployer.AccountNo:=ClientAccount."Account No";
                        EmployeeEmployer."EMployee%":=Employee/(Employee+Employer);
                        EmployeeEmployer."Employer%":=Employer/(Employee+Employer);
                        EmployeeEmployer.Insert;


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
        EmployeeEmployer: Record "Employee Employer";
        Employer: Decimal;
        Employee: Decimal;
        window: Dialog;
}

