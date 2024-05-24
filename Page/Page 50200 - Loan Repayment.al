page 50200 "Loan Repayment"
{
    // version THL-LOAN-1.0.0

    CardPageID = "Loan Repayment Header";
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Loan Repayment Header";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code";Code)
                {
                    StyleExpr = LoanStatus;
                }
                field("Date and Time";"Date and Time")
                {
                    StyleExpr = LoanStatus;
                }
                field("Imported by";"Imported by")
                {
                    StyleExpr = LoanStatus;
                }
                field(Status;Status)
                {
                    StyleExpr = LoanStatus;

                    trigger OnValidate()
                    begin
                        if Status = Status::"Effected (Employer Advised)" then
                          LoanStatus := 'Favorable'
                        else if Status = Status::Pending then
                          LoanStatus := 'Ambiguous'
                        else if Status = Status::Open then
                          LoanStatus := 'AttentionAccent';
                    end;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Send Current Loan Valuation")
            {
                Image = SpecialOrder;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    if not Confirm('Are you sure you want to send send current loan valuation') then
                      Error('');
                    EODDate := Today;
                    EODDateTxt:=Format(EODDate,0,'<Day,2><Month,2><Year,2>');
                    Filename := TemporaryPath+'Current Loan Valuation'+EODDateTxt+'.xlsx';;
                    LoanValuationReport.SaveAsExcel(Filename);
                    sharepoint.UploadOCtosharepoint(Filename);
                    Message('Loan has been sent successfully');
                end;
            }
            action("Send Repaid Loans")
            {
                Image = Stages;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    if not Confirm('Are you sure you want to send repaid loans') then
                      Error('');
                    LoanMgt.SendLoanVariation;
                    LoanMgt.GetLoanRepayment;
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        if Status = Status::"Effected (Employer Advised)" then
          LoanStatus := 'Favorable'
        else if Status = Status::Pending then
          LoanStatus := 'Ambiguous'
        else if Status = Status::Open then
          LoanStatus := 'AttentionAccent';
    end;

    trigger OnAfterGetRecord()
    begin
        if Status = Status::"Effected (Employer Advised)" then
          LoanStatus := 'Favorable'
        else if Status = Status::Pending then
          LoanStatus := 'Ambiguous'
        else if Status = Status::Open then
          LoanStatus := 'AttentionAccent';
    end;

    trigger OnOpenPage()
    begin
        if Status = Status::"Effected (Employer Advised)" then
          LoanStatus := 'Favorable'
        else if Status = Status::Pending then
          LoanStatus := 'Ambiguous'
        else if Status = Status::Open then
          LoanStatus := 'AttentionAccent';
    end;

    var
        ImportRecords: XMLport "Import Loan Repayment";
        LoanStatus: Text;
        Filename: Text;
        sharepoint: Codeunit "Sharepoint Integration";
        LoanValuationReport: Report "Current Loan Valuation";
        EODDate: Date;
        EODDateTxt: Text;
        LoanMgt: Codeunit "Loan Management";
}

