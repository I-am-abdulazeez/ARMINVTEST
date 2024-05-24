report 50046 "Charges on Dividend Accrued"
{
    ProcessingOnly = true;
    UseRequestPage = false;

    dataset
    {
        dataitem("Charges on Accrued Interest";"Charges on Accrued Interest")
        {

            trigger OnAfterGetRecord()
            begin
                EODDate:="Charges on Accrued Interest"."Value Date";
                //DividendCharges.RESET;
                //DividendCharges.CALCSUMS("Amount Charged");

                NO:=NO+1;
                MakeExcelBody
            end;

            trigger OnPreDataItem()
            begin
                NO:=0;
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
        SharepointIntegration: Codeunit "Sharepoint Integration";
        DividendCharges: Record "Charges on Accrued Interest";

    local procedure MakeExcelheader()
    begin
        ExcelBuffer.AddColumn('Value Date',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Account No',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Fund Code',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Amount Charged',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Number);
    end;

    local procedure MakeExcelBody()
    begin
        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn("Charges on Accrued Interest"."Value Date",false,'',false,false,false,'',ExcelBuffer."Cell Type"::Date);
        ExcelBuffer.AddColumn("Charges on Accrued Interest"."Account No",false,'',false,false,false,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn("Charges on Accrued Interest"."Fund Code",false,'',false,false,false,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn("Charges on Accrued Interest"."Amount Charged",false,'',false,false,false,'',ExcelBuffer."Cell Type"::Number);
    end;

    local procedure CreateExcelWorkbook()
    begin
        //ExcelBuffer.CreateBookAndOpenExcel(FORMAT(EODDate),FORMAT(EODDate),FORMAT(EODDate),FORMAT(EODDate),FORMAT(EODDate));
        EODDateTxt:=Format(EODDate,0,'<Day,2><Month,2><Year,2>');
        //Filename:=TEMPORARYPATH+'\OC'+EODDateTxt+'.xlsx';
        Filename:=TemporaryPath+'\DIVIDENDCHARGES'+EODDateTxt+'.xlsx';
        //Filename:='E:\OCFILES\AV'+EODDateTxt+'.xlsx';
        SheetName:='DIVIDENDCHARGES'+EODDateTxt;
        ReportHeader:='';
        Company:='';
        user:='';


        ExcelBuffer.CreateBook(Filename,SheetName);
        ExcelBuffer.WriteSheet(ReportHeader,Company,'');
        ExcelBuffer.CloseBook;
        SharepointIntegration.UploadOCtosharepoint(Filename);
    end;
}

