codeunit 580 "Run Template Trial Balance"
{
    // version NAVW111.00


    trigger OnRun()
    var
        ODataUtility: Codeunit ODataUtility;
        ObjectTypeParam: Option ,,,,,,,,"Page","Query";
        StatementType: Option BalanceSheet,SummaryTrialBalance,CashFlowStatement,StatementOfRetainedEarnings,AgedAccountsReceivable,AgedAccountsPayable,IncomeStatement;
    begin
        if not (ClientTypeManagement.GetCurrentClientType in [CLIENTTYPE::Phone,CLIENTTYPE::Tablet]) then
          ODataUtility.GenerateExcelTemplateWorkBook(ObjectTypeParam::Page,'ExcelTemplateTrialBalance',true,
            StatementType::SummaryTrialBalance)
        else begin
          Message(OfficeMobileMsg);
          exit;
        end;
    end;

    var
        OfficeMobileMsg: Label 'Excel Reports cannot be opened in this environment because this version of Office does not support the file format.';
        ClientTypeManagement: Codeunit ClientTypeManagement;
}
