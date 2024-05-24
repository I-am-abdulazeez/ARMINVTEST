report 50035 ExportEOQPayoutToTreasury
{
    ProcessingOnly = true;
    UseRequestPage = false;

    dataset
    {
        dataitem("EOQ Lines";"EOQ Lines")
        {
            DataItemTableView = WHERE(Verified=CONST(true),Processed=CONST(false),"Dividend Mandate"=CONST(Payout));

            trigger OnAfterGetRecord()
            begin
                MakeExcelBody;
                "EOQ Lines".Processed := true;
                "EOQ Lines"."DateTime Processed" := CurrentDateTime;
                "EOQ Lines".Modify;
                generate := true;
            end;

            trigger OnPreDataItem()
            begin
                "EOQ Lines".Reset;
                "EOQ Lines".SetRange("EOQ Lines"."Header No",EOQHeader.No);
                "EOQ Lines".SetRange("EOQ Lines".Verified,true);
                "EOQ Lines".SetRange("EOQ Lines".Processed,false);
                "EOQ Lines".SetRange("EOQ Lines"."Dividend Mandate","EOQ Lines"."Dividend Mandate"::Payout);
                "EOQ Lines".SetFilter("EOQ Lines"."Total Dividend Earned",'>=%1',554);
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
        PaymentSchedule."Payment Date" := Today;
        Batch := 'Batch'+Format(PaymentSchedule.Count+1);
        generate:=false;

        EOQHeader.Reset;
        EOQHeader.SetRange(Status,EOQHeader.Status::Verified);
        if EOQHeader.FindFirst then
          EOQHeader.Get(EOQHeader.No);

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
        EOQHeader: Record "EOQ Header";

    local procedure MakeExcelheader()
    begin
        ExcelBuffer.AddColumn(Format(Today),false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Approval Check List ' ,false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        //ExcelBuffer.AddColumn( Batch,FALSE,'',TRUE,FALSE,TRUE,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.NewRow;
        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn('ORDER NO',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Quarter',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('CLIENT NO',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('ACCOUNT/PORTFOLIO',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('NAME',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('SECURITY',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('QUANTITY',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('DIVIDEND PAYOUT',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('CHARGE',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('NET PAYABLE',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('COMMENTS',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('BANK',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('BANK SORT CODE',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn('BANK ACCOUNT NO',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('BANK ACCOUNT NAME',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
    end;

    local procedure MakeExcelBody()
    var
        BankName: Text;
        BankSortCode: Text;
    begin

        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn("EOQ Lines"."Account No",false,'',false,false,false,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(EOQHeader.Quarter,false,'',false,false,false,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn("EOQ Lines"."Client ID",false,'',false,false,false,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn("EOQ Lines"."OLD Account No",false,'',false,false,false,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn("EOQ Lines"."Client Name",false,'',false,false,false,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn("EOQ Lines"."Fund Code",false,'',false,false,false,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn("EOQ Lines"."Dividend Amount",false,'',false,false,false,'',ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn("EOQ Lines"."Dividend Amount",false,'',false,false,false,'',ExcelBuffer."Cell Type"::Number);
        if "EOQ Lines"."Dividend Amount"<=5000 then begin
          ExcelBuffer.AddColumn(10.75,false,'',false,false,false,'',ExcelBuffer."Cell Type"::Number);
          ExcelBuffer.AddColumn("EOQ Lines"."Dividend Amount"-10.75,false,'',false,false,false,'',ExcelBuffer."Cell Type"::Number);
        end else if (("EOQ Lines"."Dividend Amount" >5000) and ("EOQ Lines"."Dividend Amount" <=50000)) then begin
          ExcelBuffer.AddColumn(26.88,false,'',false,false,false,'',ExcelBuffer."Cell Type"::Number);
          ExcelBuffer.AddColumn("EOQ Lines"."Dividend Amount"-26.88,false,'',false,false,false,'',ExcelBuffer."Cell Type"::Number);
        end else begin
          ExcelBuffer.AddColumn(53.75,false,'',false,false,false,'',ExcelBuffer."Cell Type"::Number);
          ExcelBuffer.AddColumn("EOQ Lines"."Dividend Amount"-53.75,false,'',false,false,false,'',ExcelBuffer."Cell Type"::Number);
        end;
        ExcelBuffer.AddColumn("EOQ Lines"."Dividend Mandate",false,'',false,false,false,'',ExcelBuffer."Cell Type"::Text);
        BankSortCode:='';
        BankName:='';
        Bank.Reset;
        if Bank.Get("EOQ Lines"."Bank Code") then begin
          BankName:=Bank.Name;
          BankSortCode:=Bank."Sort Code";
        end;
        ExcelBuffer.AddColumn(BankName,false,'',false,false,false,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(BankSortCode,false,'',false,false,false,'',ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn("EOQ Lines"."Bank Account",false,'',false,false,false,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn("EOQ Lines"."Client Name",false,'',false,false,false,'',ExcelBuffer."Cell Type"::Text);
    end;

    local procedure CreateExcelWorkbook()
    begin
        if generate then begin
        EODDateTxt:=Format(Today,0,'<Day,2><Month,2><Year,2>')+'_'+Batch;
        Filename:=TemporaryPath+'DIVIDEND'+EOQHeader.Quarter+ 'PAYOUT SCHEDULE_'+EODDateTxt+'.xlsx';
        SheetName:='DIVIDEND PAYOUT SHEDULE_'+EODDateTxt;
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
        PaymentSchedule2.FileLink := sharepoint.UploadPaymentFiletosharepoint(Filename);
        PaymentSchedule2.Insert;
        end
    end;
}

