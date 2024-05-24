report 50027 "Export Paid Payment Schedule"
{
    ProcessingOnly = true;
    UseRequestPage = true;

    dataset
    {
        dataitem("Posted Redemption";"Posted Redemption")
        {
            //The property 'DataItemTableView' shouldn't have an empty value.
            //DataItemTableView = '';
            RequestFilterFields = "Date Sent to Treasury","Time Sent to Treasury";

            trigger OnAfterGetRecord()
            begin
                "Posted Redemption".CalcFields("OLD Account No","Posted Redemption"."Accrued Dividend Paid");
                MakeExcelBody;
                "Posted Redemption"."Sent to Treasury":=true;
                "Posted Redemption"."Date Sent to Treasury":=Today;
                "Posted Redemption"."Time Sent to Treasury":=Time;
                //"Posted Redemption".MODIFY;
            end;

            trigger OnPostDataItem()
            begin
                ExcelBuffer.NewRow;
                ExcelBuffer.NewRow;
                ExcelBuffer.NewRow;
                ExcelBuffer.AddColumn(' Name/Sign/Date',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
            end;

            trigger OnPreDataItem()
            begin
                "Posted Redemption".SetRange("Posted Redemption"."Sent to Treasury",true);
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
        CreateExcelWorkbook
    end;

    trigger OnPreReport()
    begin
        ExcelBuffer.DeleteAll;
        MakeExcelheader;
    end;

    var
        ExcelBuffer: Record "Excel Buffer" temporary;
        EODDate: Date;
        Filename: Text;
        SheetName: Text;
        ReportHeader: Text;
        Company: Text;
        user: Text;
        EODDateTxt: Text;
        Ledger: Text;
        ccy: Text;
        DRCR: Text;
        SettledDate: Text;
        NO: Integer;
        Bank: Record Bank;

    local procedure MakeExcelheader()
    begin
        ExcelBuffer.AddColumn(Format(Today)+ ' Approval Check List',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.NewRow;
        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn('ORDER NO',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('VALUE DATE',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('CLIENT NO',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('OLD CLIENT NO',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('NAME',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('FUND CODE',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('QUANTITY',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('AMOUNT',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('DIVIDEND PAYABLE',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('TOTAL PAYABLE AMOUNT',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('CHARGE',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('NET PAYABLE',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('COMMENTS',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('BANK',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('BANK SORT CODE',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('BANK ACCOUNT NO',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('BANK ACCOUNT NAME',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
    end;

    local procedure MakeExcelBody()
    var
        BankName: Text;
        BankSortCode: Text;
    begin

        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn("Posted Redemption".No,false,'',false,false,false,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn("Posted Redemption"."Value Date",false,'',false,false,false,'',ExcelBuffer."Cell Type"::Date);
        ExcelBuffer.AddColumn("Posted Redemption"."Client ID",false,'',false,false,false,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn("Posted Redemption"."OLD Account No",false,'',false,false,false,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn("Posted Redemption"."Client Name",false,'',false,false,false,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn("Posted Redemption"."Fund Code",false,'',false,false,false,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn("Posted Redemption"."No. Of Units",false,'',false,false,false,'',ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn("Posted Redemption".Amount,false,'',false,false,false,'',ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn("Posted Redemption"."Accrued Dividend Paid",false,'',false,false,false,'',ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn("Posted Redemption"."Total Amount Payable",false,'',false,false,false,'',ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(0,false,'',false,false,false,'',ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn("Posted Redemption"."Total Amount Payable",false,'',false,false,false,'',ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn("Posted Redemption"."Redemption Type",false,'',false,false,false,'',ExcelBuffer."Cell Type"::Text);
        BankSortCode:='';
        BankName:='';
        Bank.Reset;
        if Bank.Get("Posted Redemption"."Bank Code") then
        begin
          BankName:=Bank.Name;
          BankSortCode:=Bank."Sort Code";
        end;
        ExcelBuffer.AddColumn(BankName,false,'',false,false,false,'',ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(BankSortCode,false,'',false,false,false,'',ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn("Posted Redemption"."Bank Account No",false,'',false,false,false,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn("Posted Redemption"."Bank Account Name",false,'',false,false,false,'',ExcelBuffer."Cell Type"::Text);
    end;

    local procedure CreateExcelWorkbook()
    begin
        //ExcelBuffer.CreateBookAndOpenExcel(FORMAT(EODDate),FORMAT(EODDate),FORMAT(EODDate),FORMAT(EODDate),FORMAT(EODDate));
        
        EODDateTxt:=Format(Today,0,'<Day,2><Month,2><Year,2>')+Format(CurrentDateTime,0,'<Hours24,2><Minutes,2><Seconds,2><AM/PM>');
        
        //Filename:=TEMPORARYPATH+'\OC'+EODDateTxt+'.xlsx';
        //Filename:=TEMPORARYPATH+'\OC'+EODDateTxt+'.xlsx';
        //Filename:='E:\Kazi\Clients\TEKNOHUB\Backups\dividend\PAYMENT SCHEDULE_'+EODDateTxt+'.xlsx';
        Filename:=TemporaryPath+'\PAYMENT SCHEDULE_'+EODDateTxt+'.xlsx';
        SheetName:='PAYMENT SCHEDULE_'+EODDateTxt;
        ReportHeader:='';
        Company:='';
        user:='';
        ExcelBuffer.CreateBookAndOpenExcel(Filename,SheetName,'','','');
        /*
        ExcelBuffer.CreateBook(Filename,SheetName);
        ExcelBuffer.WriteSheet(ReportHeader,Company,'');
        ExcelBuffer.OpenBook(Filename,SheetName);
        */
        //ERROR('');

    end;
}

