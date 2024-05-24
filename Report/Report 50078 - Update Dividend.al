report 50078 "Update Dividend"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Update Dividend.rdlc';

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
        DateFilter:=20190403D;
        enddate:=20190406D;
        Window.Open('updating .....  #1########');
        while DateFilter< enddate do begin
            if DateFilter=0D then
              Error('Please Input Datefilter');
            DailyIncomeDistribLines2.Reset;
            DailyIncomeDistribLines2.SetRange("Value Date",DateFilter);
            if DailyIncomeDistribLines2.FindLast then
            Lineno:=DailyIncomeDistribLines2."Line No";

            DailyDistributableIncome.Reset;
            DailyDistributableIncome.SetRange(Date,DateFilter);
            DailyDistributableIncome.SetRange("Fund Code",'ARMMMF');
            if  not DailyDistributableIncome.FindFirst then
              Error('There is no Distributable income');


            ClientAccount.Reset;
            //ClientAccount.SETRANGE("Account No",'1104353-ARMMMF-01');
            ClientAccount.SetRange("Fund No",'ARMMMF');
            ClientAccount.SetFilter("Account Status",'<>%1',ClientAccount."Account Status"::Closed);
            //
            ClientAccount.SetFilter("Date Filter",'..%1',DateFilter);
            if ClientAccount.FindFirst then
              repeat

                Window.Update(1,ClientAccount."Account No");
                ClientAccount.CalcFields("No of Units");


            DailyIncomeDistribLines2.Reset;
            DailyIncomeDistribLines2.SetRange("Value Date",DateFilter);
            DailyIncomeDistribLines2.SetRange("Account No",ClientAccount."Account No");
            if DailyIncomeDistribLines2.FindFirst then  begin
                DailyIncomeDistribLines2."No of Units":=Round(ClientAccount."No of Units",0.0001,'=');
                DailyIncomeDistribLines2."Income Per unit":=Round(DailyDistributableIncome."Earnings Per Unit",0.000000000001,'=');
                DailyIncomeDistribLines2."Income accrued":=Round(DailyIncomeDistribLines2."No of Units"*DailyIncomeDistribLines2."Income Per unit",0.0001,'=');
                DailyIncomeDistribLines2.Modify;
              end else begin

                Lineno:=Lineno+1;
                if Client.Get(ClientAccount."Client ID") then ;
                DailyIncomeDistribLines.Init;
                DailyIncomeDistribLines.No:=DailyDistributableIncome.No;
                DailyIncomeDistribLines."Value Date":=DailyDistributableIncome.Date;
                DailyIncomeDistribLines."Line No":=Lineno;
                DailyIncomeDistribLines."Account No":=ClientAccount."Account No";
                DailyIncomeDistribLines."Client ID":=ClientAccount."Client ID";
                DailyIncomeDistribLines."Client Name":=Client.Name;
                DailyIncomeDistribLines."Fund Code":=ClientAccount."Fund No";
                DailyIncomeDistribLines."No of Units":=Round(ClientAccount."No of Units",0.0001,'=');
                DailyIncomeDistribLines."Income Per unit":=Round(DailyDistributableIncome."Earnings Per Unit",0.000000000001,'=');
                DailyIncomeDistribLines."Income accrued":=Round(DailyIncomeDistribLines."No of Units"*DailyIncomeDistribLines."Income Per unit",0.0001,'=');
                DailyIncomeDistribLines."inserted on update":=true;
               if DailyIncomeDistribLines."Income accrued">0 then
                DailyIncomeDistribLines.Insert;

            end;
              until ClientAccount.Next=0;

              DateFilter:=CalcDate('1D',DateFilter);
        end;
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
}

