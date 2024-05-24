report 50013 "Export Redemptions & subscrip"
{
    ProcessingOnly = true;
    UseRequestPage = false;

    dataset
    {
        dataitem("Subscription & Redemp Fundware";"Subscription & Redemp Fundware")
        {
            //The property 'DataItemTableView' shouldn't have an empty value.
            //DataItemTableView = '';

            trigger OnAfterGetRecord()
            begin
                EODDate:="Subscription & Redemp Fundware".PostDate;
                MakeExcelBody
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
        sharepoint: Codeunit "Sharepoint Integration";

    local procedure MakeExcelheader()
    begin
        ExcelBuffer.AddColumn('OrderNO',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('PlanCode',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('FolioNo',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('TransactionType',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('PostDate',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('TradeDate',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('TradeUnits',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('TradeNav',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('TradeAmount',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('LoadAmount',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('SettledDate',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('SettledAmount',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('BankID',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('BankAccountNo',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('OrderStatus',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('SwitchPlanCode',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Data_Id',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Record Type',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('IsPreSettlement',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('RefundAmount',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
    end;

    local procedure MakeExcelBody()
    begin
        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn("Subscription & Redemp Fundware".OrderNO,false,'',false,false,false,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn("Subscription & Redemp Fundware".PlanCode,false,'',false,false,false,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn("Subscription & Redemp Fundware".FolioNo,false,'',false,false,false,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn("Subscription & Redemp Fundware".TransactionType,false,'',false,false,false,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn("Subscription & Redemp Fundware".PostDate,false,'',false,false,false,'',ExcelBuffer."Cell Type"::Date);
        ExcelBuffer.AddColumn("Subscription & Redemp Fundware".PostDate,false,'',false,false,false,'',ExcelBuffer."Cell Type"::Date);
        ExcelBuffer.AddColumn(Abs("Subscription & Redemp Fundware".TradeUnits),false,'',false,false,false,'',ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(Abs("Subscription & Redemp Fundware".TradeNav),false,'',false,false,false,'',ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(Abs("Subscription & Redemp Fundware".TradeAmount),false,'',false,false,false,'',ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(Abs("Subscription & Redemp Fundware".LoadAmount),false,'',false,false,false,'',ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn("Subscription & Redemp Fundware".SettledDate,false,'',false,false,false,'',ExcelBuffer."Cell Type"::Date);
        ExcelBuffer.AddColumn(Abs("Subscription & Redemp Fundware".SettledAmount),false,'',false,false,false,'',ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn("Subscription & Redemp Fundware".BankID,false,'',false,false,false,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn("Subscription & Redemp Fundware".BankAccountNo,false,'',false,false,false,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn("Subscription & Redemp Fundware".OrderStatus,false,'',false,false,false,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn("Subscription & Redemp Fundware".SwitchPlanCode,false,'',false,false,false,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn("Subscription & Redemp Fundware".Data_Id,false,'',false,false,false,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn("Subscription & Redemp Fundware"."Record Type",false,'',false,false,false,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('',false,'',false,false,false,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('',false,'',false,false,false,'',ExcelBuffer."Cell Type"::Text);
    end;

    local procedure CreateExcelWorkbook()
    begin
        //ExcelBuffer.CreateBookAndOpenExcel(FORMAT(EODDate),FORMAT(EODDate),FORMAT(EODDate),FORMAT(EODDate),FORMAT(EODDate));
        //EODDateTxt:=DELCHR(FORMAT(EODDate),'=','/');
        EODDateTxt:=Format(EODDate,0,'<Day,2><Month,2><Year,2>');
        //Filename:=TEMPORARYPATH+'OC'+EODDateTxt+'.xlsx';
        Filename:='E:\OCFILES\OC'+EODDateTxt+'.xlsx';
        SheetName:='OC'+EODDateTxt;
        ReportHeader:='';
        Company:='';
        user:='';


        ExcelBuffer.CreateBook(Filename,SheetName);
        ExcelBuffer.WriteSheet(ReportHeader,Company,'');
        ExcelBuffer.CloseBook;
        sharepoint.UploadOCtosharepoint(Filename);
    end;
}

