report 50033 "Auto Generate Daily FUM & Fees"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("Account Manager";"Account Manager")
        {
            column(FirstName_AccountManager;"Account Manager"."First Name")
            {
            }
            column(Surname_AccountManager;"Account Manager".Surname)
            {
            }
            column(MiddleName_AccountManager;"Account Manager"."Middle Name")
            {
            }

            trigger OnAfterGetRecord()
            begin
                  window.Update(1,"Account Manager"."Agent Code");
                  TotalFees:=0;
                  TotalFUM:=0;
                  TotalInflow:=0;
                  StartDate:=StartDate2;
                  Commisionstructure.Reset;
                  Commisionstructure.SetRange(Code,"Account Manager"."Commission Structure");
                  if Commisionstructure.FindFirst then ;
                  i:=0;
                  while (StartDate<EndDate) or (StartDate=EndDate) do begin
                    i:=i+1;
                   //Z window.UPDATE(2,StartDate);
                    DailyFUM[i]:=0;
                    ClientAccount.Reset;
                    ClientAccount.SetCurrentKey("Agent Code","Fund No");
                    ClientAccount.SetRange("Agent Code","Account Manager"."Agent Code");
                    ClientAccount.SetFilter("Fund No",'=%1|%2|%3|%4|%5','ARMMMF','ARMDF','AGF','ARMEF','ETH');
                    ClientAccount.SetFilter("Date Filter",'..%1',StartDate);
                    ClientAccount.SetFilter("No of Units",'>%1',0);
                      if ClientAccount.FindFirst then begin
                        repeat
                          ClientAccount.CalcFields(ClientAccount."No of Units");
                          DailyFUM[i]:= DailyFUM[i]+(ClientAccount."No of Units"*FundAdministration.GetFundNAVPrice(ClientAccount."Fund No",StartDate));
                
                        until ClientAccount.Next=0;
                      end;
                       StartDate:=CalcDate('1D',StartDate);
                    end;
                
                
                
                i:=0;
                TotalFUM:=0;
                StartDate:=StartDate2;
                        while (StartDate<EndDate) or (StartDate=EndDate) do begin
                          i:=i+1;
                          FEntryno:=FEntryno+1;
                
                          TotalFUM:=TotalFUM+DailyFUM[i];
                          TotalFees:=TotalFees+(DailyFUM[i]*Commisionstructure."Fee %")/(100*365);
                           FUMFees.Init;
                          //FUMFees."Line No":=FEntryno;
                          FUMFees."Agent Code":="Account Manager"."Agent Code";
                          FUMFees."Agent Name":="Account Manager"."First Name"+ ' '+"Account Manager"."Middle Name"+ ' '+"Account Manager".Surname;
                          FUMFees.Date:=StartDate;
                          FUMFees.FUM:=DailyFUM[i];
                          FUMFees.Fees:=(DailyFUM[i]*Commisionstructure."Fee %")/(100*365);
                          FUMFees.Insert;
                          StartDate:=CalcDate('1D',StartDate);
                        end;
                      if i=0 then i:=1;
                
                StartDate:=StartDate2;
                ClientAccount.Reset;
                    ClientAccount.SetCurrentKey("Agent Code");
                    ClientAccount.SetRange("Agent Code","Account Manager"."Agent Code");
                    ClientAccount.SetFilter("Fund No",'=%1|%2|%3|%4|%5','ARMMMF','ARMDF','AGF','ARMEF','ETH');
                    if ClientAccount.FindFirst then
                      repeat
                
                     IEntryno:=IEntryno+1;
                      ClientTransactions.Reset;
                      ClientTransactions.SetCurrentKey("Account No","Client ID","Value Date","Transaction Type");
                      ClientTransactions.SetRange("Account No",ClientAccount."Account No");
                      ClientTransactions.SetRange("Value Date",StartDate,EndDate);
                      ClientTransactions.SetRange("Transaction Type",ClientTransactions."Transaction Type"::Subscription);
                      ClientTransactions.SetRange(Reversed,false);
                      if ClientTransactions.FindFirst then
                        repeat
                         IEntryno:=IEntryno+1;
                          Inflows.Init;
                          //Inflows.No:=CommissionHeader.No;
                          Inflows."Line No":=IEntryno;
                          Inflows."Agent Code":="Account Manager"."Agent Code";
                          Inflows."Agent Name":="Account Manager"."First Name"+ ' '+"Account Manager"."Middle Name"+ ' '+"Account Manager".Surname;
                          Inflows."Account No":=ClientTransactions."Account No";
                          Inflows.Date:=ClientTransactions."Value Date";
                          Inflows.Amount:=ClientTransactions.Amount;
                          Inflows."Transaction Ref":=ClientTransactions."Transaction No";
                          Inflows.Remarks:=ClientTransactions.Narration;
                          Inflows."Account Name":=ClientAccount."Client Name";
                          Inflows."Old Account no":=ClientAccount."Old Account Number";
                          Inflows.Insert;
                          TotalInflow:=TotalInflow+ClientTransactions.Amount;
                        until ClientTransactions.Next=0;
                
                
                
                      until ClientAccount.Next=0;
                
                
                /*
                CEntryno:=CEntryno+1;
                  CommissionLines.INIT;
                  //CommissionLines.No:=CommissionHeader.No;
                  CommissionLines."Line No":=CEntryno;
                  CommissionLines."Agent Code":="Account Manager"."Agent Code";
                  CommissionLines."Agent Name":="Account Manager"."First Name"+ ' '+"Account Manager"."Middle Name"+ ' '+"Account Manager".Surname;
                  CommissionLines."Average FUM":=TotalFUM/i;
                  CommissionLines.Inflow:=TotalInflow;
                  CommissionLines."New Client":=NoofNewClients;
                  CommissionLines."Active Direct Debit":=NoofDDM;
                  CommissionLines."Total Fee":=TotalFees;
                  CommissionLines."MGT Fees to ARM":=((Commisionstructure."ARM Fee %"*TotalFees)/Commisionstructure."Fee %");
                  CommissionLines."MGT Fees to IC":= (Commisionstructure."Agent Fee %"*TotalFees)/Commisionstructure."Fee %";
                  //CommissionLines."Max Commission":= (Commisionstructure."Max Comm %"*CommissionLines."MGT Fees to IC")/100;
                  //CommissionLines."FUM Commision Due to AE":=((Commisionstructure."Agent Fee %"/Commisionstructure."Fee %")*TotalFees);
                  CommissionLines."New Client Commision":=NoofNewClients*Commisionstructure."Amount Per New Client";
                  CommissionLines."DDM Commission":=NoofDDM*Commisionstructure."Amount Per DDM";
                  CommissionLines."Total Commission":=CommissionLines."FUM Commision Due to AE"+CommissionLines."New Client Commision"+CommissionLines."DDM Commission";
                  CommissionLines.INSERT;
                  */

            end;

            trigger OnPostDataItem()
            begin
                window.Close
            end;

            trigger OnPreDataItem()
            begin
                StartDate2:=StartDate;
                window.Open('Generating for Agent - #1#######');
                if Inflows2.FindLast then
                  IEntryno:=Inflows2."Line No"
                else
                  IEntryno:=0;
            end;
        }
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

    trigger OnPostReport()
    begin
        //CreateExcelWorkbook
    end;

    trigger OnPreReport()
    begin
        //ExcelBuffer.DELETEALL;
        //MakeExcelheader;
        StartDate := Today;
        EndDate := Today;
    end;

    var
        AccountManager: Record "Account Manager";
        Client: Record Client;
        ClientAccount: Record "Client Account";
        ClientTransactions: Record "Client Transactions";
        DirectDebitMandate: Record "Direct Debit Mandate";
        CommissionLines: Record "Commission Lines" temporary;
        FUMFees: Record "FUM & Fees";
        Inflows: Record Inflows;
        FUMFees2: Record "FUM & Fees";
        Inflows2: Record Inflows;
        InitialDDM: Record "Initial & DDM";
        NoofNewClients: Integer;
        NoofDDM: Integer;
        TotalFUM: Decimal;
        CEntryno: Integer;
        FEntryno: Integer;
        IEntryno: Integer;
        NEntryno: Integer;
        DEntryno: Integer;
        StartDate: Date;
        EndDate: Date;
        DailyFUM: array [1000] of Decimal;
        i: Integer;
        FundAdministration: Codeunit "Fund Administration";
        TotalFees: Decimal;
        Commisionstructure: Record "Commision structure";
        TotalInflow: Decimal;
        window: Dialog;
        StartDate2: Date;
        ExcelBuffer: Record "Excel Buffer" temporary;
        EODDate: Date;
        Filename: Text;
        SheetName: Text;
        ReportHeader: Text;
        Company: Text;
        user: Text;
        fund: Record Fund;

    local procedure MakeExcelheader()
    begin
        ExcelBuffer.AddColumn(Format(Today)+ ' Approval Check List',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.NewRow;
        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn('AGENT CODE',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('NAME',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('CLIENT ACCOUNT',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('CLIENT ID',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('DATE',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('AMOUNT',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('REFERENCE',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
    end;

    local procedure MakeExcelBody()
    var
        BankName: Text;
        BankSortCode: Text;
    begin
        /*
        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn("Posted Redemption".No,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn("Posted Redemption"."Value Date",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Date);
        ExcelBuffer.AddColumn("Posted Redemption"."Client ID",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn("Posted Redemption"."OLD Account No",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn("Posted Redemption"."Client Name",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn("Posted Redemption"."Fund Code",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn("Posted Redemption"."No. Of Units",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn("Posted Redemption".Amount,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn("Posted Redemption"."Accrued Dividend Paid",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn("Posted Redemption"."Total Amount Payable",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(0,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn("Posted Redemption"."Total Amount Payable",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn("Posted Redemption"."Redemption Type",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
        BankSortCode:='';
        BankName:='';
        Bank.RESET;
        IF Bank.GET("Posted Redemption"."Bank Code") THEN
        BEGIN
          BankName:=Bank.Name;
          BankSortCode:=Bank."Sort Code";
        END;
        ExcelBuffer.AddColumn(BankName,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(BankSortCode,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn("Posted Redemption"."Bank Account No",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn("Posted Redemption"."Bank Account Name",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Text);
        */

    end;

    local procedure CreateExcelWorkbook()
    begin
        //ExcelBuffer.CreateBookAndOpenExcel(FORMAT(EODDate),FORMAT(EODDate),FORMAT(EODDate),FORMAT(EODDate),FORMAT(EODDate));

        //EODDateTxt:=FORMAT(TODAY,0,'<Day,2><Month,2><Year,2>')+FORMAT(CURRENTDATETIME,0,'<Hours24,2><Minutes,2><Seconds,2><AM/PM>');

        //Filename:=TEMPORARYPATH+'\OC'+EODDateTxt+'.xlsx';
        //Filename:=TEMPORARYPATH+'\OC'+EODDateTxt+'.xlsx';
        //Filename:='E:\Kazi\Clients\TEKNOHUB\Backups\dividend\PAYMENT SCHEDULE_'+EODDateTxt+'.xlsx';
        Filename:=TemporaryPath+'Commission.xlsx';
        SheetName:='FUM';
        ReportHeader:='';
        Company:='';
        user:='';
        //ExcelBuffer.CreateBookAndOpenExcel(Filename,SheetName,'','','');

        ExcelBuffer.CreateBook(Filename,SheetName);
        ExcelBuffer.WriteSheet(ReportHeader,Company,'');
        ExcelBuffer.SelectOrAddSheet('FEES');
        CreateFees;
        ExcelBuffer.WriteSheet(ReportHeader,Company,'');

        ExcelBuffer.SelectOrAddSheet('INFLOWS');
        CreateInflow;
        ExcelBuffer.WriteSheet(ReportHeader,Company,'');
        ExcelBuffer.SelectOrAddSheet('SUMMARY');
        CreateSummary;
        ExcelBuffer.WriteSheet(ReportHeader,Company,'');

        ExcelBuffer.CloseBook;
        //ExcelBuffer.OpenBook(Filename,SheetName);
        ExcelBuffer.OpenExcel

        //ERROR('');
    end;

    local procedure CreateFees()
    begin
        StartDate:=StartDate2;
        ExcelBuffer.DeleteAll;
        ExcelBuffer.ClearNewRow;
        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn('AGENT CODE',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('NAME',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
         while (StartDate<EndDate) or (StartDate=EndDate) do begin
          ExcelBuffer.AddColumn(StartDate,false,'',true,false,true,'',ExcelBuffer."Cell Type"::Date);
           StartDate:=CalcDate('1D',StartDate);
         end;
         ExcelBuffer.AddColumn('TOTAL',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
         StartDate:=StartDate2;
        AccountManager.Reset;
        if AccountManager.FindFirst then
          repeat
            ExcelBuffer.NewRow;
            ExcelBuffer.AddColumn(AccountManager."Agent Code",false,'',false,false,false,'',ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(AccountManager."First Name"+ ' '+AccountManager."Middle Name"+ ' '+AccountManager.Surname,false,'',false,false,false,'',ExcelBuffer."Cell Type"::Text);
            TotalFees:=0;
            FUMFees.Reset;
            FUMFees.SetRange("Agent Code",AccountManager."Agent Code");
             FUMFees.SetRange(Date,StartDate,EndDate);
            if FUMFees.FindFirst then
              repeat
                ExcelBuffer.AddColumn(FUMFees.Fees,false,'',false,false,false,'',ExcelBuffer."Cell Type"::Number);
                TotalFees:=TotalFees+FUMFees.Fees;
              until FUMFees.Next=0;
               ExcelBuffer.AddColumn(TotalFees,false,'',false,false,false,'',ExcelBuffer."Cell Type"::Number);
        until AccountManager.Next=0;
    end;

    local procedure CreateInflow()
    begin
        StartDate:=StartDate2;
        ExcelBuffer.DeleteAll;
        ExcelBuffer.ClearNewRow;
        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn('AGENT CODE',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('NAME',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('CLIENT ACCOUNT',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('DATE',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('AMOUNT',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('REFERENCE',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);

        AccountManager.Reset;
        if AccountManager.FindFirst then


          repeat
           ExcelBuffer.NewRow;
            ExcelBuffer.NewRow;
            ExcelBuffer.AddColumn(AccountManager."Agent Code",false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(AccountManager."First Name"+ ' '+AccountManager."Middle Name"+ ' '+AccountManager.Surname,false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
          ExcelBuffer.NewRow;

        ExcelBuffer.AddColumn('CLIENT ACCOUNT',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('DATE',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('AMOUNT',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('REFERENCE',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
            Inflows .Reset;
            Inflows.SetRange("Agent Code",AccountManager."Agent Code");
             Inflows.SetRange(Date,StartDate,EndDate);
            if Inflows.FindFirst then
              repeat
             ExcelBuffer.NewRow;
             ExcelBuffer.AddColumn(Inflows."Account No",false,'',false,false,false,'',ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(Inflows.Date,false,'',false,false,false,'',ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(Inflows.Amount,false,'',false,false,false,'',ExcelBuffer."Cell Type"::Number);
            ExcelBuffer.AddColumn(Inflows."Transaction Ref",false,'',false,false,false,'',ExcelBuffer."Cell Type"::Text);

              until Inflows.Next=0;
        until AccountManager.Next=0;
    end;

    local procedure CreateSummary()
    begin
        StartDate:=StartDate2;
        ExcelBuffer.DeleteAll;
        ExcelBuffer.ClearNewRow;
        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn('AGENT CODE',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('NAME',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('AVERAGE FUM',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('INFLOW',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('NEW CLIENT',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('ACTIVE DDM',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('TOTAL FEES',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('FEES TO ARM',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('FEES TO AGENT',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('TOTAL COMMISSION',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
         StartDate:=StartDate2;
        AccountManager.Reset;
        if AccountManager.FindFirst then
          repeat

            CommissionLines .Reset;
            CommissionLines.SetRange("Agent Code",AccountManager."Agent Code");
            if CommissionLines.FindFirst then
              repeat
                ExcelBuffer.NewRow;
                ExcelBuffer.AddColumn(AccountManager."Agent Code",false,'',false,false,false,'',ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(AccountManager."First Name"+ ' '+AccountManager."Middle Name"+ ' '+AccountManager.Surname,false,'',false,false,false,'',ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(CommissionLines."Average FUM",false,'',false,false,false,'',ExcelBuffer."Cell Type"::Number);
                ExcelBuffer.AddColumn(CommissionLines.Inflow,false,'',false,false,false,'',ExcelBuffer."Cell Type"::Number);
                ExcelBuffer.AddColumn(CommissionLines."New Client",false,'',false,false,false,'',ExcelBuffer."Cell Type"::Number);
                ExcelBuffer.AddColumn(CommissionLines."Active Direct Debit",false,'',false,false,false,'',ExcelBuffer."Cell Type"::Number);
                ExcelBuffer.AddColumn(CommissionLines."Total Fee",false,'',false,false,false,'',ExcelBuffer."Cell Type"::Number);
                ExcelBuffer.AddColumn(CommissionLines."MGT Fees to ARM",false,'',false,false,false,'',ExcelBuffer."Cell Type"::Number);
                ExcelBuffer.AddColumn(CommissionLines."MGT Fees to IC",false,'',false,false,false,'',ExcelBuffer."Cell Type"::Number);
                ExcelBuffer.AddColumn(CommissionLines."Total Commission",false,'',false,false,false,'',ExcelBuffer."Cell Type"::Number);



              until CommissionLines.Next=0;
        until AccountManager.Next=0;
    end;

    local procedure CreateFum()
    begin
        StartDate:=StartDate2;
        ExcelBuffer.DeleteAll;
        ExcelBuffer.ClearNewRow;
        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn('AGENT CODE',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('NAME',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
         while (StartDate<EndDate) or (StartDate=EndDate) do begin
          ExcelBuffer.AddColumn(StartDate,false,'',true,false,true,'',ExcelBuffer."Cell Type"::Date);
           StartDate:=CalcDate('1D',StartDate);
         end;
         ExcelBuffer.AddColumn('AVERAGE',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
         StartDate:=StartDate2;
        AccountManager.Reset;
        if AccountManager.FindFirst then
          repeat
            TotalFUM:=0;
            ExcelBuffer.NewRow;
            ExcelBuffer.AddColumn(AccountManager."Agent Code",false,'',false,false,false,'',ExcelBuffer."Cell Type"::Text);
            ExcelBuffer.AddColumn(AccountManager."First Name"+ ' '+AccountManager."Middle Name"+ ' '+AccountManager.Surname,false,'',false,false,false,'',ExcelBuffer."Cell Type"::Text);
            i:=0;
            FUMFees.Reset;
            FUMFees.SetRange("Agent Code",AccountManager."Agent Code");
            FUMFees.SetRange(Date,StartDate,EndDate);
            if FUMFees.FindFirst then
              repeat
                ExcelBuffer.AddColumn(FUMFees.FUM,false,'',false,false,false,'',ExcelBuffer."Cell Type"::Number);
                TotalFUM:=TotalFUM+FUMFees.FUM;
              i:=1+1;
              until FUMFees.Next=0;
              ExcelBuffer.AddColumn(TotalFUM/i,false,'',false,false,false,'',ExcelBuffer."Cell Type"::Number);
        until AccountManager.Next=0;
    end;
}
