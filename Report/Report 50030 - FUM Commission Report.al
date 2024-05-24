report 50030 "FUM Commission Report"
{
    ProcessingOnly = true;

    dataset
    {
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("Start Date";StartDate)
                {
                }
                field("End Date";EndDate)
                {
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

    trigger OnPostReport()
    begin
        CreateExcelWorkbook
    end;

    trigger OnPreReport()
    begin
        ExcelBuffer.DeleteAll;
        //MakeExcelheader;
        if StartDate=0D then Error('Please input start date');
        if EndDate=0D then Error('Please input end date');
        StartDate2:=StartDate;
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
        CreateFum;
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
            Commisionstructure.Reset;
            Commisionstructure.SetRange(Code,AccountManager."Commission Structure");
            if not Commisionstructure.FindFirst then
              Error('Please set commission structure code for agent %1',AccountManager."Agent Code");
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
               CommissionLines.Reset;
        CommissionLines.SetRange("Agent Code",AccountManager."Agent Code");
        if CommissionLines.FindFirst then begin

          CommissionLines."Total Fee":=TotalFees;
          CommissionLines."MGT Fees to ARM":=((Commisionstructure."ARM Fee %"*TotalFees)/Commisionstructure."Fee %");
          CommissionLines."MGT Fees to IC":= (Commisionstructure."Agent Fee %"*TotalFees)/Commisionstructure."Fee %";
          //CommissionLines."Max Commission":= (Commisionstructure."Max Comm %"*CommissionLines."MGT Fees to IC")/100;
          //CommissionLines."FUM Commision Due to AE":=((Commisionstructure."Agent Fee %"/Commisionstructure."Fee %")*TotalFees);
          CommissionLines."New Client Commision":=NoofNewClients*Commisionstructure."Amount Per New Client";
          CommissionLines."DDM Commission":=NoofDDM*Commisionstructure."Amount Per DDM";
          CommissionLines."Total Commission":=CommissionLines."MGT Fees to IC"+CommissionLines."New Client Commision"+CommissionLines."DDM Commission";
         CommissionLines.Modify;
         end;
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
            TotalInflow:=0;
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
            TotalInflow:=TotalInflow+Inflows.Amount;
              until Inflows.Next=0;
        CommissionLines.Reset;
        CommissionLines.SetRange("Agent Code",AccountManager."Agent Code");
        if CommissionLines.FindFirst then begin
          CommissionLines.Inflow:=TotalInflow;
           CommissionLines.Modify
        end;

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
              i:=i+1;
              until FUMFees.Next=0;
              if i=0 then i:=1;
              ExcelBuffer.AddColumn(TotalFUM/i,false,'',false,false,false,'',ExcelBuffer."Cell Type"::Number);
              CEntryno:=CEntryno+1;
          CommissionLines.Init;
          //CommissionLines.No:=CommissionHeader.No;
          CommissionLines."Line No":=CEntryno;
          CommissionLines."Agent Code":=AccountManager."Agent Code";
          CommissionLines."Agent Name":=AccountManager."First Name"+ ' '+AccountManager."Middle Name"+ ' '+AccountManager.Surname;
          CommissionLines."Average FUM":=TotalFUM/i;
          CommissionLines.Insert;

        until AccountManager.Next=0;
    end;
}

