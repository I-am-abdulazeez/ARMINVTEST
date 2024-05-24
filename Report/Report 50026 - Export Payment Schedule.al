report 50026 "Export Payment Schedule"
{
    ProcessingOnly = true;
    UseRequestPage = false;

    dataset
    {
        dataitem("Posted Redemption";"Posted Redemption")
        {
            //The property 'DataItemTableView' shouldn't have an empty value.
            //DataItemTableView = '';

            trigger OnAfterGetRecord()
            begin
                "Posted Redemption".CalcFields("OLD Account No","Posted Redemption"."Accrued Dividend Paid");
                MakeExcelBody;
                "Posted Redemption"."Sent to Treasury":=true;
                "Posted Redemption"."Date Sent to Treasury":=Today;
                "Posted Redemption"."Time Sent to Treasury":=Time;
                "Posted Redemption"."Treasury Batch":=Batch;
                "Posted Redemption".Modify(true);
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
                "Posted Redemption".SetRange("Posted Redemption"."Sent to Treasury",false);
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
        ExcelBuffer.AddColumn('ORDER NO',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('VALUE DATE',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('CLIENT NO',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('ACCOUNT/PORTFOLIO',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('NAME',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('SECURITY',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
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
        ExcelBuffer.AddColumn("Posted Redemption"."Recon No",false,'',false,false,false,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn("Posted Redemption"."Value Date",false,'',false,false,false,'',ExcelBuffer."Cell Type"::Date);
        ExcelBuffer.AddColumn("Posted Redemption"."Client ID",false,'',false,false,false,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn("Posted Redemption"."OLD Account No",false,'',false,false,false,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn("Posted Redemption"."Client Name",false,'',false,false,false,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn("Posted Redemption"."Fund Name",false,'',false,false,false,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn("Posted Redemption"."No. Of Units",false,'',false,false,false,'',ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn("Posted Redemption".Amount,false,'',false,false,false,'',ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn("Posted Redemption"."Accrued Dividend Paid",false,'',false,false,false,'',ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn("Posted Redemption"."Total Amount Payable",false,'',false,false,false,'',ExcelBuffer."Cell Type"::Number);
        // IF "Posted Redemption"."Fee Amount">0 THEN BEGIN
        //  ExcelBuffer.AddColumn("Posted Redemption"."Fee Amount",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Number);
        //  ExcelBuffer.AddColumn("Posted Redemption"."Net Amount Payable",FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Number);
        //
        // END ELSE BEGIN
        //
        //  IF "Posted Redemption".Amount<=5000 THEN BEGIN
        //  ExcelBuffer.AddColumn(10,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Number);
        //  ExcelBuffer.AddColumn("Posted Redemption"."Total Amount Payable"-10,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Number);
        //  END ELSE IF (("Posted Redemption".Amount >5000) AND ("Posted Redemption".Amount <= 50000)) THEN BEGIN
        //  ExcelBuffer.AddColumn(25,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Number);
        //  ExcelBuffer.AddColumn("Posted Redemption"."Total Amount Payable"-25,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Number);
        //  END ELSE BEGIN
        //  ExcelBuffer.AddColumn(50,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Number);
        //  ExcelBuffer.AddColumn("Posted Redemption"."Total Amount Payable"-50,FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Number);
        //  END;
        // END ;
        if "Posted Redemption"."Fee Amount">0 then begin
          ExcelBuffer.AddColumn("Posted Redemption"."Fee Amount",false,'',false,false,false,'',ExcelBuffer."Cell Type"::Number);
          ExcelBuffer.AddColumn("Posted Redemption"."Net Amount Payable",false,'',false,false,false,'',ExcelBuffer."Cell Type"::Number);
        end else begin
         //Modified to exempt ARMEURO fees
           if "Posted Redemption"."Fund Code" = 'ARMEURO' then begin
              ExcelBuffer.AddColumn("Posted Redemption"."Fee Amount",false,'',false,false,false,'',ExcelBuffer."Cell Type"::Number);
              ExcelBuffer.AddColumn("Posted Redemption"."Net Amount Payable",false,'',false,false,false,'',ExcelBuffer."Cell Type"::Number);
           end else begin
              if "Posted Redemption".Amount<=5000 then begin
                ExcelBuffer.AddColumn(10,false,'',false,false,false,'',ExcelBuffer."Cell Type"::Number);
                ExcelBuffer.AddColumn("Posted Redemption"."Total Amount Payable"-10,false,'',false,false,false,'',ExcelBuffer."Cell Type"::Number);
              end else if (("Posted Redemption".Amount >5000) and ("Posted Redemption".Amount <= 50000)) then begin
                ExcelBuffer.AddColumn(25,false,'',false,false,false,'',ExcelBuffer."Cell Type"::Number);
                ExcelBuffer.AddColumn("Posted Redemption"."Total Amount Payable"-25,false,'',false,false,false,'',ExcelBuffer."Cell Type"::Number);
              end else begin
                ExcelBuffer.AddColumn(50,false,'',false,false,false,'',ExcelBuffer."Cell Type"::Number);
                ExcelBuffer.AddColumn("Posted Redemption"."Total Amount Payable"-50,false,'',false,false,false,'',ExcelBuffer."Cell Type"::Number);
              end;
           end;
        end ;
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
        if generate then begin
          EODDateTxt:=Format(Today,0,'<Day,2><Month,2><Year,2>')+'_'+Batch;
          Filename:=TemporaryPath+'REDEMPTION_SCHEDULE_'+EODDateTxt+'.xlsx';
          SheetName:='REDEMPTION_SCHEDULE_'+EODDateTxt;
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
          PaymentSchedule2.Insert;
        end
    end;
}

