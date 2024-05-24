report 50038 "Export Approved Loan Payment"
{
    ProcessingOnly = true;
    UseRequestPage = false;

    dataset
    {
        dataitem("Loan Application";"Loan Application")
        {
            DataItemTableView = WHERE(Status=CONST(Approved),"Sent To Treasury"=CONST(false),Disbursed=CONST(false));

            trigger OnAfterGetRecord()
            begin
                MakeExcelBody;
                "Loan Application"."Sent To Treasury" := true;
                "Loan Application"."Date Sent To Treasury" := CurrentDateTime;
                "Loan Application"."Treasury Batch" := Batch;
                "Loan Application".Status := "Loan Application".Status::"At Treasury";
                "Loan Application".Modify;
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
                "Loan Application".SetRange("Loan Application".Status,"Loan Application".Status::Approved);
                "Loan Application".SetRange("Loan Application"."Sent To Treasury",false);
                "Loan Application".SetRange("Loan Application".Disbursed,false);
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
        LoanPaymentSchedule2.Reset;
        LoanPaymentSchedule.SetRange("Loan Payment Date",Today);
        LoanPaymentSchedule."Loan Payment Date" := Today;
        Batch := 'Batch'+Format(LoanPaymentSchedule.Count+1);
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
        LoanPaymentSchedule: Record "Loan Payment schedule";
        LoanPaymentSchedule2: Record "Loan Payment schedule";
        Batch: Code[20];
        generate: Boolean;
        sharepoint: Codeunit "Sharepoint Integration";
        FundMgrRatios: Record "Product Fund Manager Ratio";
        FundManagers: Record "Fund Managers";
        FMPercentage: array [10] of Decimal;
        FMAmount: array [10] of Decimal;
        FMName: array [10] of Text;
        ARMAmount: Decimal;
        IBTCAmount: Decimal;
        Veticamount: Decimal;
        LoanProduct: Record "Loan Product";
        ClientLoanProduct: Option Annuitized,Bullet,"Zero Interest";
        VAT: Decimal;
        NIBSS: Decimal;
        TotalCharges: Decimal;
        CommitteeFee: Decimal;

    local procedure MakeExcelheader()
    begin
        ExcelBuffer.AddColumn(Format(Today),false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Approval Check List ' ,false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn( Batch,false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.NewRow;
        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn('STAFF ID',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('EMPLOYEE NAME',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('BANK NAME',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('BANK ACCOUNT NAME',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('BANK ACCOUNT NUMBER',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('REQUESTED LOAN AMOUNT',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn('APPROVED LOAN AMOUNT',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn('CURRENT VALUE',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn('TENURE (YRS)',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn('FUND CODE',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('LOAN TYPE',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('% OF PORTFOLIO VALUE',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn('COMMITMENT FEE',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn('VAT',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn('NIBSS CHARGES',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn('TOTAL CHARGES',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn('NET PAYABLE',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn('REQUESTED DATE',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Date);
        ExcelBuffer.AddColumn('LOAN RATE',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn('ARM',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn('IBTC',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn('VETIVA',false,'',true,false,true,'',ExcelBuffer."Cell Type"::Number);
    end;

    local procedure MakeExcelBody()
    var
        BankName: Text;
        BankSortCode: Text;
    begin

        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn("Loan Application"."Staff ID",false,'',false,false,false,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn("Loan Application"."Client Name",false,'',false,false,false,'',ExcelBuffer."Cell Type"::Text);
        BankSortCode:='';
        BankName:='';
        Bank.Reset;
        if Bank.Get("Loan Application"."Bank Code") then
        begin
          BankName:=Bank.Name;
          BankSortCode:=Bank."Sort Code";
        end;
        ExcelBuffer.AddColumn("Loan Application"."Bank Name",false,'',false,false,false,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn("Loan Application"."Bank Account Name",false,'',false,false,false,'',ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn("Loan Application"."Bank Account Number",false,'',false,false,false,'',ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.AddColumn("Loan Application"."Requested Amount",false,'',false,false,false,'',ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn("Loan Application"."Approved Amount",false,'',false,false,false,'',ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn("Loan Application"."Investment Balance",false,'',false,false,false,'',ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn("Loan Application"."Loan Years",false,'',false,false,false,'',ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn("Loan Application"."Fund Code",false,'',false,false,false,'',ExcelBuffer."Cell Type"::Text);

        //Maxwell: To get the Loan Product Type.
        LoanProduct.Reset;
        LoanProduct.SetRange(Code, "Loan Application"."Loan Product Type");
        if LoanProduct.FindFirst then
          ClientLoanProduct := LoanProduct."Loan Type";

        ExcelBuffer.AddColumn(ClientLoanProduct,false,'',false,false,false,'',ExcelBuffer."Cell Type"::Text);

        CommitteeFee := 0.0025 * "Loan Application"."Approved Amount";
        VAT := 0.075 * CommitteeFee;
        NIBSS := 105;
        TotalCharges := CommitteeFee + VAT + NIBSS;

        //ExcelBuffer.AddColumn(("Loan Application"."Approved Amount"/"Loan Application"."Investment Balance"),FALSE,'',FALSE,FALSE,FALSE,'',ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(("Loan Application"."Approved Amount"/"Loan Application"."Investment Balance"),false,'',false,false,false,'',ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(CommitteeFee,false,'',false,false,false,'',ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(VAT,false,'',false,false,false,'',ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(NIBSS,false,'',false,false,false,'',ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn((VAT + CommitteeFee + NIBSS),false,'',false,false,false,'',ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(("Loan Application"."Approved Amount" - (VAT + NIBSS + CommitteeFee)),false,'',false,false,false,'',ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn("Loan Application"."Application Date",false,'',false,false,false,'',ExcelBuffer."Cell Type"::Date);
        ExcelBuffer.AddColumn("Loan Application"."Interest Rate",false,'',false,false,false,'',ExcelBuffer."Cell Type"::Number);

        FundMgrRatios.Reset;
        FundMgrRatios.SetRange(Product,"Loan Application"."Loan Product Type");
        FundMgrRatios.SetRange("Fund Manager",'ARM');
        FundMgrRatios.SetFilter(From,'<%1',"Loan Application"."Application Date");
        if FundMgrRatios.FindLast then
        ARMAmount:=Round(FundMgrRatios.Percentage/100*"Loan Application"."Approved Amount");

        FundMgrRatios.Reset;
        FundMgrRatios.SetRange(Product,"Loan Application"."Loan Product Type");
        FundMgrRatios.SetRange("Fund Manager",'IBTC');
        FundMgrRatios.SetFilter(From,'<%1',"Loan Application"."Application Date");
        if FundMgrRatios.FindLast then
        IBTCAmount:=Round(FundMgrRatios.Percentage/100*"Loan Application"."Approved Amount");

        FundMgrRatios.Reset;
        FundMgrRatios.SetRange(Product,"Loan Application"."Loan Product Type");
        FundMgrRatios.SetRange("Fund Manager",'VETIVA');
        FundMgrRatios.SetFilter(From,'<%1',"Loan Application"."Application Date");
        if FundMgrRatios.FindLast then
        Veticamount:=Round(FundMgrRatios.Percentage/100*"Loan Application"."Approved Amount");

        ExcelBuffer.AddColumn(ARMAmount,false,'',false,false,false,'',ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(IBTCAmount,false,'',false,false,false,'',ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(Veticamount,false,'',false,false,false,'',ExcelBuffer."Cell Type"::Number);
    end;

    local procedure CreateExcelWorkbook()
    begin

        if generate then begin
          EODDateTxt:=Format(Today,0,'<Day,2><Month,2><Year,2>')+'_'+Batch;

          Filename:=TemporaryPath+'LOAN PAYMENT SCHEDULE_'+EODDateTxt+'.xlsx';
          SheetName:='LOAN PAYMENT SCHEDULE_'+EODDateTxt;
          ReportHeader:='';
          Company:='';
          user:='';


          ExcelBuffer.CreateBook(Filename,SheetName);
          ExcelBuffer.WriteSheet(ReportHeader,Company,'');
          ExcelBuffer.CloseBook;

          LoanPaymentSchedule2.Init;
          LoanPaymentSchedule2."Loan Payment Date":=Today;
          LoanPaymentSchedule2.Batch := Batch;
          LoanPaymentSchedule2.Time := Time;
          LoanPaymentSchedule2.FileLink := sharepoint.UploadLoanPaymentFileToSharePoint(Filename);
          LoanPaymentSchedule2.Insert;
        end
    end;
}

