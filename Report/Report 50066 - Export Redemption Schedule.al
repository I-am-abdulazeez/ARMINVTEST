report 50066 "Export Redemption Schedule"
{
    ProcessingOnly = true;
    UseRequestPage = false;

    dataset
    {
        dataitem("Redemption Schedule Lines";"Redemption Schedule Lines")
        {
            //The property 'DataItemTableView' shouldn't have an empty value.
            //DataItemTableView = '';

            trigger OnAfterGetRecord()
            begin
                MakeExcelBody;
                "Redemption Schedule Lines"."Sent to Treasury":=true;
                "Redemption Schedule Lines"."Date Sent to Treasury":=Today;
                "Redemption Schedule Lines"."Treasury Batch":=Batch;
                "Redemption Schedule Lines".Modify;
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
                "Redemption Schedule Lines".SetRange("Redemption Schedule Lines"."Sent to Treasury",false);
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
        RedScheduleHeader: Record "Redemption Schedule Header";
        Client: Record Client;

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
        ExcelBuffer.AddColumn('AMOUNT',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('REQUEST TYPE',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('COMMENT',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('BANK',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('BANK SORT CODE',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('BANK ACCOUNT NO',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('BANK ACCOUNT NAME',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('EMPLOYER PAYMENT OPTION',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
    end;

    local procedure MakeExcelBody()
    var
        BankName: Text;
        BankSortCode: Text;
    begin

        ExcelBuffer.NewRow;
        if "Redemption Schedule Lines"."Employee Amount" > 0 then begin
          ExcelBuffer.AddColumn("Redemption Schedule Lines"."Schedule Header",false,'',false,false,false,'',ExcelBuffer."Cell Type"::Text);
          ExcelBuffer.AddColumn("Redemption Schedule Lines"."Schedule Header",false,'',false,false,false,'',ExcelBuffer."Cell Type"::Text);
          RedScheduleHeader.Reset;
          RedScheduleHeader.SetRange("Schedule No","Redemption Schedule Lines"."Schedule Header");
          if RedScheduleHeader.Find('-') then
            ExcelBuffer.AddColumn(RedScheduleHeader."Value Date",false,'',false,false,false,'',ExcelBuffer."Cell Type"::Date);

          ExcelBuffer.AddColumn("Redemption Schedule Lines"."Client ID",false,'',false,false,false,'',ExcelBuffer."Cell Type"::Text);
          ExcelBuffer.AddColumn("Redemption Schedule Lines"."Account No",false,'',false,false,false,'',ExcelBuffer."Cell Type"::Text);
          ExcelBuffer.AddColumn("Redemption Schedule Lines"."Client Name",false,'',false,false,false,'',ExcelBuffer."Cell Type"::Text);
          ExcelBuffer.AddColumn("Redemption Schedule Lines"."Fund Name",false,'',false,false,false,'',ExcelBuffer."Cell Type"::Text);
          ExcelBuffer.AddColumn("Redemption Schedule Lines"."Employee Amount",false,'',false,false,false,'',ExcelBuffer."Cell Type"::Number);
          ExcelBuffer.AddColumn("Redemption Schedule Lines"."Redemption Type",false,'',false,false,false,'',ExcelBuffer."Cell Type"::Text);
          ExcelBuffer.AddColumn('Employee Redemption',false,'',false,false,false,'',ExcelBuffer."Cell Type"::Text);
          BankSortCode:='';
          BankName:='';

          Client.Reset;
          Client.Get("Redemption Schedule Lines"."Client ID");
          Bank.Reset;
          if Bank.Get(Client."Bank Code") then begin
            BankName:=Bank.Name;
            BankSortCode:=Bank."Sort Code";
          end;
          ExcelBuffer.AddColumn(BankName,false,'',false,false,false,'',ExcelBuffer."Cell Type"::Number);
          ExcelBuffer.AddColumn(BankSortCode,false,'',false,false,false,'',ExcelBuffer."Cell Type"::Number);
          ExcelBuffer.AddColumn(Client."Bank Account Number",false,'',false,false,false,'',ExcelBuffer."Cell Type"::Text);
          ExcelBuffer.AddColumn(Client."Bank Account Name",false,'',false,false,false,'',ExcelBuffer."Cell Type"::Text);
          ExcelBuffer.AddColumn('Bank Transfer',false,'',false,false,false,'',ExcelBuffer."Cell Type"::Text);
        end;

        ExcelBuffer.NewRow;

        if "Redemption Schedule Lines"."Employer Amount" > 0 then begin
          ExcelBuffer.AddColumn("Redemption Schedule Lines"."Schedule Header",false,'',false,false,false,'',ExcelBuffer."Cell Type"::Text);
          ExcelBuffer.AddColumn("Redemption Schedule Lines"."Schedule Header",false,'',false,false,false,'',ExcelBuffer."Cell Type"::Text);
          RedScheduleHeader.Reset;
          RedScheduleHeader.SetRange("Schedule No","Redemption Schedule Lines"."Schedule Header");
          if RedScheduleHeader.Find('-') then
            ExcelBuffer.AddColumn(RedScheduleHeader."Value Date",false,'',false,false,false,'',ExcelBuffer."Cell Type"::Date);

          ExcelBuffer.AddColumn("Redemption Schedule Lines"."Client ID",false,'',false,false,false,'',ExcelBuffer."Cell Type"::Text);
          ExcelBuffer.AddColumn("Redemption Schedule Lines"."Account No",false,'',false,false,false,'',ExcelBuffer."Cell Type"::Text);
          ExcelBuffer.AddColumn("Redemption Schedule Lines"."Client Name",false,'',false,false,false,'',ExcelBuffer."Cell Type"::Text);
          ExcelBuffer.AddColumn("Redemption Schedule Lines"."Fund Name",false,'',false,false,false,'',ExcelBuffer."Cell Type"::Text);
          ExcelBuffer.AddColumn("Redemption Schedule Lines"."Employer Amount",false,'',false,false,false,'',ExcelBuffer."Cell Type"::Number);
          ExcelBuffer.AddColumn("Redemption Schedule Lines"."Redemption Type",false,'',false,false,false,'',ExcelBuffer."Cell Type"::Text);
          ExcelBuffer.AddColumn('Employer Redemption',false,'',false,false,false,'',ExcelBuffer."Cell Type"::Text);
          BankSortCode:='';
          BankName:='';

          Bank.Reset;
          if Bank.Get("Redemption Schedule Lines"."Employer Bank Code") then begin
            BankName:=Bank.Name;
            BankSortCode:=Bank."Sort Code";
          end;
          ExcelBuffer.AddColumn(BankName,false,'',false,false,false,'',ExcelBuffer."Cell Type"::Number);
          ExcelBuffer.AddColumn(BankSortCode,false,'',false,false,false,'',ExcelBuffer."Cell Type"::Number);
          ExcelBuffer.AddColumn("Redemption Schedule Lines"."Employer Bank Account No",false,'',false,false,false,'',ExcelBuffer."Cell Type"::Text);
          ExcelBuffer.AddColumn("Redemption Schedule Lines"."Employer Bank Account Name",false,'',false,false,false,'',ExcelBuffer."Cell Type"::Text);
          ExcelBuffer.AddColumn("Redemption Schedule Lines"."Employer Payment Option",false,'',false,false,false,'',ExcelBuffer."Cell Type"::Text);

        end
    end;

    local procedure CreateExcelWorkbook()
    begin
        if generate then begin
        EODDateTxt:=Format(Today,0,'<Day,2><Month,2><Year,2>')+'_'+Batch;

        Filename:=TemporaryPath+'INSTITUTIONAL CLIENTS REDEMPTION SCHEDULE_'+EODDateTxt+'.xlsx';
        SheetName:='INSTITUTIONAL CLIENTS REDEMPTION SCHEDULE_'+EODDateTxt;
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

