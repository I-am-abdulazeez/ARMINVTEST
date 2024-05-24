report 50024 "Export Unit Transfer"
{
    ProcessingOnly = true;
    UseRequestPage = false;

    dataset
    {
        dataitem("Posted Fund Transfer";"Posted Fund Transfer")
        {
            //The property 'DataItemTableView' shouldn't have an empty value.
            //DataItemTableView = '';

            trigger OnAfterGetRecord()
            begin
                MakeExcelBody;
                "Posted Fund Transfer"."Sent to treasury":=true;
                "Posted Fund Transfer"."Date Sent to Treasury":=Today;
                "Posted Fund Transfer"."Time Sent to Treasury":=Time;
                "Posted Fund Transfer"."Treasury Batch":=Batch;
                "Posted Fund Transfer".Modify;
                generate:=true;
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
                "Posted Fund Transfer".SetRange("Posted Fund Transfer"."Sent to treasury",false);
                "Posted Fund Transfer".SetRange("Posted Fund Transfer".Type,"Posted Fund Transfer".Type::"Across Funds");
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
        PaymentSchedule2.Reset;
        PaymentSchedule.SetRange("Payment Date",Today);
        Batch:='BATCH'+Format(PaymentSchedule.Count+1);
        generate:=false;
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
        PaymentSchedule: Record "Payment Schedule";
        PaymentSchedule2: Record "Payment Schedule";
        Batch: Code[20];
        generate: Boolean;
        sharepoint: Codeunit "Sharepoint Integration";

    local procedure MakeExcelheader()
    begin
        ExcelBuffer.AddColumn(Format(Today),false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Approval Check List ' ,false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn( Batch,false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.NewRow;
        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn('TRANSACTION NO',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('VALUE DATE',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('TRANSACTION DATE',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('FROM FUND CODE',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('TO FUND CODE',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('TOTAL PAYABLE',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('CHARGE',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('NET PAYABLE',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('FROM ACCOUNT NUMBER',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('TO ACCOUNT NUMBER',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('FROM CLIENT NAME',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('TO CLIENT NAME',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('REMARKS',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
    end;

    local procedure MakeExcelBody()
    var
        BankName: Text;
        BankSortCode: Text;
    begin

        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn("Posted Fund Transfer".No,false,'',false,false,false,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn("Posted Fund Transfer"."Value Date",false,'',false,false,false,'',ExcelBuffer."Cell Type"::Date);
        ExcelBuffer.AddColumn("Posted Fund Transfer"."Transaction Date",false,'',false,false,false,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn("Posted Fund Transfer"."From Fund Code",false,'',false,false,false,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn("Posted Fund Transfer"."To Fund Code",false,'',false,false,false,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn("Posted Fund Transfer"."Total Amount Payable",false,'',false,false,false,'',ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn("Posted Fund Transfer"."Fee Amount",false,'',false,false,false,'',ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn("Posted Fund Transfer"."Net Amount Payable",false,'',false,false,false,'',ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn("Posted Fund Transfer"."From Account No",false,'',false,false,false,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn("Posted Fund Transfer"."To Account No",false,'',false,false,false,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn("Posted Fund Transfer"."From Client Name",false,'',false,false,false,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn("Posted Fund Transfer"."To Client Name",false,'',false,false,false,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn("Posted Fund Transfer".Remarks,false,'',false,false,false,'',ExcelBuffer."Cell Type"::Text);
    end;

    local procedure CreateExcelWorkbook()
    begin
        if generate then begin
        EODDateTxt:=Format(Today,0,'<Day,2><Month,2><Year,2>')+'_'+Batch;

        Filename:=TemporaryPath+'UNIT TRANSFER SCHEDULE_'+EODDateTxt+'.xlsx';
        SheetName:='UNIT_TRANSFER_'+EODDateTxt;
        ReportHeader:='';
        Company:='';
        user:='';

        ExcelBuffer.CreateBook(Filename,SheetName);
        ExcelBuffer.WriteSheet(ReportHeader,Company,'');
        ExcelBuffer.CloseBook;

        PaymentSchedule2.Init;
        PaymentSchedule2."Payment Date":=Today;
        PaymentSchedule2.Batch:=Batch;
        PaymentSchedule2.Time:=Time;
        PaymentSchedule2.FileLink:=sharepoint.UploadPaymentFiletosharepoint(Filename);
        //PaymentSchedule2.FileLink:=sharepoint.UploadLoanPaymentFileToSharePoint(Filename);
        PaymentSchedule2.Insert;
        end
    end;
}

