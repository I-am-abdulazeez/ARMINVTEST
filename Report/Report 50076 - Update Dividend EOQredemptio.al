report 50076 "Update Dividend EOQredemptio"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Update Dividend EOQredemptio.rdlc';

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



            DailyIncomeDistribLines2.Reset;

            //DailyIncomeDistribLines2.SETRANGE("Account No",ClientTransactions."Account No");
            //DailyIncomeDistribLines2.SETFILTER("Value Date",'..%1',ClientTransactions."Value Date");
            DailyIncomeDistribLines2.SetRange("Fully Paid",false);
            if DailyIncomeDistribLines2.FindFirst then
              repeat
                Window.Update(1,DailyIncomeDistribLines2."Account No");
                DailyIncomeDistribLines2."Fully Paid":=true;
                DailyIncomeDistribLines2."Payment Date":=20190401D;
                DailyIncomeDistribLines2."Transaction No":='EOQ00001';
                DailyIncomeDistribLines2."Payment Mode":=DailyIncomeDistribLines2."Payment Mode"::EOQ;
                //DailyIncomeDistribLines2."inserted on update":=TRUE;
                DailyIncomeDistribLines2.Modify;

              until DailyIncomeDistribLines2.Next=0;

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

