report 50077 "Update Dividend full redemptio"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Update Dividend full redemptio.rdlc';

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
        DateFilter:=20190101D;
        enddate:=20190304D;
        Window.Open('updating .....  #1########');
        
        ClientTransactions.Reset;
        ClientTransactions.SetRange("Value Date",DateFilter,enddate);
        ClientTransactions.SetRange("Transaction Type",ClientTransactions."Transaction Type"::Redemption);
        ClientTransactions.SetRange("Transaction Sub Type",ClientTransactions."Transaction Sub Type"::"Full Redemption");
        //ClientTransactions.SETRANGE("Account No",'1102652-ARMMMF-01');
        if ClientTransactions.FindFirst then
          repeat
            Window.Update(1,ClientTransactions."Account No");
            DailyIncomeDistribLines2.Reset;
        
            DailyIncomeDistribLines2.SetRange("Account No",ClientTransactions."Account No");
            DailyIncomeDistribLines2.SetFilter("Value Date",'..%1',ClientTransactions."Value Date");
            DailyIncomeDistribLines2.SetRange("Fully Paid",false);
            if DailyIncomeDistribLines2.FindFirst then
              repeat
                DailyIncomeDistribLines2."Fully Paid":=true;
                DailyIncomeDistribLines2."Payment Date":=ClientTransactions."Value Date";
                DailyIncomeDistribLines2."Transaction No":=ClientTransactions."Transaction No";
                DailyIncomeDistribLines2."Payment Mode":=DailyIncomeDistribLines2."Payment Mode"::"Full Redemption";
                DailyIncomeDistribLines2."inserted on update":=true;
                DailyIncomeDistribLines2.Modify;
        
              until DailyIncomeDistribLines2.Next=0;
          until ClientTransactions.Next=0;
        
        /*
        WHILE DateFilter< enddate DO BEGIN
            IF DateFilter=0D THEN
              ERROR('Please Input Datefilter');
        
        
            DailyIncomeDistribLines2.RESET;
            DailyIncomeDistribLines2.SETRANGE("Value Date",DateFilter);
            DailyIncomeDistribLines2.SETRANGE("Account No",ClientAccount."Account No");
            IF DailyIncomeDistribLines2.FINDFIRST THEN  BEGIN
                DailyIncomeDistribLines2."No of Units":=ROUND(ClientAccount."No of Units",0.0001,'=');
                DailyIncomeDistribLines2."Income Per unit":=ROUND(DailyDistributableIncome."Earnings Per Unit",0.000000000001,'=');
                DailyIncomeDistribLines2."Income accrued":=ROUND(DailyIncomeDistribLines2."No of Units"*DailyIncomeDistribLines2."Income Per unit",0.0001,'=');
                DailyIncomeDistribLines2.MODIFY;
              END ELSE BEGIN
        
                Lineno:=Lineno+1;
                IF Client.GET(ClientAccount."Client ID") THEN ;
                DailyIncomeDistribLines.INIT;
                DailyIncomeDistribLines.No:=DailyDistributableIncome.No;
                DailyIncomeDistribLines."Value Date":=DailyDistributableIncome.Date;
                DailyIncomeDistribLines."Line No":=Lineno;
                DailyIncomeDistribLines."Account No":=ClientAccount."Account No";
                DailyIncomeDistribLines."Client ID":=ClientAccount."Client ID";
                DailyIncomeDistribLines."Client Name":=Client.Name;
                DailyIncomeDistribLines."Fund Code":=ClientAccount."Fund No";
                DailyIncomeDistribLines."No of Units":=ROUND(ClientAccount."No of Units",0.0001,'=');
                DailyIncomeDistribLines."Income Per unit":=ROUND(DailyDistributableIncome."Earnings Per Unit",0.000000000001,'=');
                DailyIncomeDistribLines."Income accrued":=ROUND(DailyIncomeDistribLines."No of Units"*DailyIncomeDistribLines."Income Per unit",0.0001,'=');
                DailyIncomeDistribLines."inserted on update":=TRUE;
               IF DailyIncomeDistribLines."Income accrued">0 THEN
                DailyIncomeDistribLines.INSERT;
        
            END;
              UNTIL ClientAccount.NEXT=0;
        
              DateFilter:=CALCDATE('1D',DateFilter);
        END;
        
        */
          Window.Close;

    end;

    var
        ClientAccount: Record "Client Account";
        DateFilter: Date;
        Window: Dialog;
        DailyIncomeDistribLines: Record "Daily Income Distrib Lines";
        DailyIncomeDistribLines2: Record "Daily Income Distrib Lines";
        Lineno: Integer;
        DailyDistributableIncome: Record "Daily Distributable Income";
        Client: Record Client;
        enddate: Date;
        ClientTransactions: Record "Client Transactions";
}

