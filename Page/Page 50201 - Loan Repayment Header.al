page 50201 "Loan Repayment Header"
{
    // version THL-LOAN-1.0.0

    DeleteAllowed = false;
    PageType = Card;
    SourceTable = "Loan Repayment Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Code";Code)
                {
                    Editable = false;
                    StyleExpr = LoanStatus;
                }
                field("Type of Schedule";"Type of Schedule")
                {
                    StyleExpr = LoanStatus;
                }
                field("Date and Time";"Date and Time")
                {
                    Editable = TreatedRepayment;
                    StyleExpr = LoanStatus;
                }
                field(Month;Month)
                {
                    Editable = false;
                    StyleExpr = LoanStatus;
                }
                field("Imported by";"Imported by")
                {
                    Editable = TreatedRepayment;
                    StyleExpr = LoanStatus;
                }
                field(Status;Status)
                {
                    Editable = TreatedRepayment;
                    StyleExpr = LoanStatus;

                    trigger OnValidate()
                    begin
                        OpenRepayment := false;
                        PendingRepayment := false;
                        TreatedRepayment := false;
                        
                        //Maxwell: To enable editing on the checkbox
                        if Status = Status::Open then begin
                          OpenRepayment := true;
                          TreatedRepayment := true;
                        end else begin
                          OpenRepayment := false;
                          TreatedRepayment := false;
                        end;
                        //END
                        
                        /*IF Status = Status::Open THEN
                          OpenRepayment := TRUE
                        ELSE
                          OpenRepayment := FALSE;*/
                        
                        if Status = Status::Pending then
                          PendingRepayment := true
                        else
                          PendingRepayment := false;
                        
                        /*IF Status = Status::"Effected (Employer Advised)" THEN
                          TreatedRepayment := TRUE
                        ELSE
                          TreatedRepayment := FALSE;*/
                        
                        if Status = Status::"Effected (Employer Advised)" then
                          LoanStatus := 'Favorable'
                        else if Status = Status::Pending then
                          LoanStatus := 'Ambiguous'
                        else if Status = Status::Open then
                          LoanStatus := 'AttentionAccent'
                        else if (Status = Status::"Payment Received") or (Status = Status::Rejected) then
                          LoanStatus := 'Attention';

                    end;
                }
                field("No of Lines";"No of Lines")
                {
                    Editable = TreatedRepayment;
                    StyleExpr = LoanStatus;
                }
                field("Total Amount";"Total Amount")
                {
                    Editable = false;
                    StyleExpr = LoanStatus;
                }
            }
            part(Control7;"Loan Repayment Lines")
            {
                Editable = TreatedRepayment;
                SubPageLink = "Header No"=FIELD(Code);
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Suggest Expected Repayments")
            {
                Image = Suggest;
                Promoted = true;
                PromotedIsBig = true;
                Visible = OpenRepayment;

                trigger OnAction()
                begin
                    if "Type of Schedule" = "Type of Schedule"::"Monthly Advice to Employer" then
                    LoanMgt.SuggestLoanRepaymentSchedule(Rec)
                    else
                    Error('You can only suggest expected repayments for Monthly Advice to Employer Schedules.');
                end;
            }
            action("Import Repayment Schedule")
            {
                Caption = 'Import Repayment Schedule';
                Image = Import;
                Promoted = true;
                PromotedIsBig = true;
                Visible = OpenRepayment;

                trigger OnAction()
                begin
                    TestField(Status,Status::Open);
                    ImportRecords.GetRecHeader(Rec);
                    ImportRecords.Run;
                end;
            }
            action(Submit)
            {
                Image = Confirm;
                Promoted = true;
                PromotedIsBig = true;
                Visible = OpenRepayment;

                trigger OnAction()
                begin
                    if Confirm('Are you sure you want to submit this Repayment for Processing?',false) = true then begin
                      Status := Status::Pending;
                      Modify;
                      Message('Submitted for Processing.');
                    end;
                end;
            }
            action("Effect Repayment")
            {
                Caption = 'Effect Repayment';
                Image = ApplyEntries;
                Promoted = true;
                PromotedIsBig = true;
                Visible = PendingRepayment;

                trigger OnAction()
                var
                    CurrentLoanValuation: Decimal;
                begin
                    TestField(Status,Status::Pending);
                    
                    //Scheduled Repayments
                    LoanRepaymentLines.Reset;
                    LoanRepaymentLines.SetRange("Header No",Code);
                    LoanRepaymentLines.SetRange(Posted,false);
                    LoanRepaymentLines.SetRange(Application,LoanRepaymentLines.Application::"Apply to Interest First");
                    if LoanRepaymentLines.FindSet then begin repeat
                      LoanRepaymentLines.TestField("Sheduled Repayment Date");
                    ClientID := LoanMgt.GetClientNoFromStaffID(LoanRepaymentLines."Pers. No.");
                      LoanRepaymentSchedule.Reset;
                      LoanRepaymentSchedule.SetRange("Loan No.",LoanRepaymentLines."Applies To Loan");
                      LoanRepaymentSchedule.SetRange("Client No.",ClientID);
                      LoanRepaymentSchedule.SetRange(Settled,false);
                      LoanRepaymentSchedule.SetRange("Repayment Date",LoanRepaymentLines."Sheduled Repayment Date");
                      if LoanRepaymentSchedule.FindFirst then begin
                        LoanRepaymentSchedule.Settled :=true;
                        LoanRepaymentSchedule."Settlement No." := LoanRepaymentLines."Header No";
                        LoanRepaymentSchedule."Repayment Line No." := LoanRepaymentLines."Line No.";
                        LoanRepaymentSchedule."Settlement Method" := LoanRepaymentSchedule."Settlement Method"::Payment;
                        LoanRepaymentSchedule."Principal Settlement" := LoanRepaymentLines."Principal Applied";
                        LoanRepaymentSchedule."Interest Settlement" := LoanRepaymentLines."Interest Applied";
                        LoanRepaymentSchedule."Total Settlement" := LoanRepaymentLines."Total Payment";
                        LoanRepaymentSchedule.Validate(Settled);
                        LoanRepaymentSchedule.Modify;
                        end;
                    
                        LoanRepaymentLines.Posted := true;
                        LoanRepaymentLines.Modify;
                      until LoanRepaymentLines.Next = 0;
                      end;
                    
                    //Off-Schedule Repayments
                    LoanRepaymentLines.Reset;
                    LoanRepaymentLines.SetRange("Header No",Code);
                    LoanRepaymentLines.SetRange(Posted,false);
                    LoanRepaymentLines.SetRange(Application,LoanRepaymentLines.Application::"Apply to Principal Only");
                    LoanRepaymentLines.SetFilter(Date,'<>%1',0D);
                    if LoanRepaymentLines.Find('-') then begin repeat
                    ClientID := LoanMgt.GetClientNoFromStaffID(LoanRepaymentLines."Pers. No.");
                    
                        LoanRepaymentSchedule.Init;
                        LoanRepaymentSchedule."Loan No." := LoanRepaymentLines."Applies To Loan";
                        LoanRepaymentSchedule."Entry Type" := LoanRepaymentSchedule."Entry Type"::"Off-Schedule";
                        if Loans.Get(LoanRepaymentLines."Applies To Loan") then begin
                          LoanRepaymentSchedule."Client No." := ClientID;
                          LoanRepaymentSchedule."Client Name" := Loans."Client Name";
                          LoanRepaymentSchedule."Loan Product Type" := Loans."Loan Product Type";
                        end;
                        LoanValuation := LoanMgt.GetLoanValuationWithRefDate(LoanRepaymentLines."Applies To Loan",LoanRepaymentLines."Valuation Date");
                        LoanRepaymentSchedule."Repayment Date" := LoanRepaymentLines.Date;
                        LoanRepaymentSchedule."Repayment Code" := LoanRepaymentLines."Header No";
                        LoanRepaymentSchedule."Loan Amount" := 0;
                        LoanRepaymentSchedule."Installment No." := 100;
                        LoanRepaymentSchedule."Principal Due" := 0;
                        LoanRepaymentSchedule."Interest Due" := 0;
                        LoanRepaymentSchedule."Total Due" := 0;
                        LoanRepaymentSchedule."Due Date" := LoanRepaymentLines.Date;
                        LoanRepaymentSchedule."Settlement Date" := LoanRepaymentLines.Date;
                        LoanRepaymentSchedule.Settled := true;
                        LoanRepaymentSchedule."Confirmed By" := UserId;
                        LoanRepaymentSchedule."Settlement No." := LoanRepaymentLines."Header No";
                        LoanRepaymentSchedule."Repayment Line No." := LoanRepaymentLines."Line No.";
                        LoanRepaymentSchedule."Settlement Method" := LoanRepaymentSchedule."Settlement Method"::Payment;
                        LoanRepaymentSchedule."Principal Settlement" := LoanRepaymentLines."Total Payment";
                        LoanRepaymentSchedule."Interest Settlement" := 0;
                        LoanRepaymentSchedule."Total Settlement" := LoanRepaymentLines."Total Payment";
                    
                    if not LoanRepaymentSchedule2.Get(LoanRepaymentLines."Applies To Loan",ClientID,LoanRepaymentLines.Date,LoanRepaymentSchedule."Entry Type"::"Off-Schedule") then
                        LoanRepaymentSchedule.Insert;
                    
                        LoanRepaymentLines.Posted := true;
                        LoanRepaymentLines.Modify;
                    
                        RecalculateLoanSchedule(LoanRepaymentLines);
                      until LoanRepaymentLines.Next = 0;
                      end;
                    //
                    Status := Status::"Effected (Employer Advised)";
                    Modify;
                    Message('Repayments Effected.');
                    
                    //Close out Loan
                    /*CurrentLoanValuation := LoanMgt.GetLoanValuation(LoanRepaymentSchedule."Loan No.");
                    IF LoanRepaymentSchedule."Total Settlement" = CurrentLoanValuation THEN*/

                end;
            }
            action("Payment Received")
            {
                Image = Payment;
                Promoted = true;
                PromotedIsBig = true;
                Visible = TreatedRepayment;

                trigger OnAction()
                begin
                    TestField(Status,Status::"Effected (Employer Advised)");
                    if Confirm('Are you sure the payment for this batch has been received?',false) = true then begin
                      Status := Status::"Payment Received";
                      Modify;
                      Message('Payment Received.');
                    end;
                end;
            }
            action(Reject)
            {
                Image = Reject;
                Promoted = true;
                PromotedIsBig = true;
                Visible = PendingConfirmation;

                trigger OnAction()
                begin
                    if Confirm('Do you wish to reject the record?',false) = true then begin
                      Status := Status::Rejected;
                      Modify;
                      Message('Record rejected.');
                    end;
                end;
            }
            action("Reject to update")
            {
                Image = UpdateDescription;
                Promoted = true;
                PromotedIsBig = true;
                Visible = PendingConfirmation;

                trigger OnAction()
                begin
                    if Confirm('Do you wish to reject to update this record?',false) = true then begin
                      Status := Status::Open;
                      Modify;
                      Message('Record has been rejected for update.');
                    end;
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        OpenRepayment := false;
        PendingRepayment := false;
        TreatedRepayment := false;
        
        //Maxwell: To enable editing on the checkbox
        if Status = Status::Open then begin
          OpenRepayment := true;
          TreatedRepayment := true;
        end else begin
          OpenRepayment := false;
          TreatedRepayment := false;
        end;
        //END
        
        /*IF Status = Status::Open THEN
          OpenRepayment := TRUE
        ELSE
          OpenRepayment := FALSE;*/
        
        if Status = Status::Pending then
          PendingRepayment := true
        else
          PendingRepayment := false;
        
        
        /*IF Status = Status::"Effected (Employer Advised)" THEN
          TreatedRepayment := TRUE
        ELSE
          TreatedRepayment := FALSE;*/
        
        if Status = Status::"Effected (Employer Advised)" then
          LoanStatus := 'Favorable'
        else if Status = Status::Pending then
          LoanStatus := 'Ambiguous'
        else if Status = Status::Open then
          LoanStatus := 'AttentionAccent'
        else if (Status = Status::"Payment Received") or (Status = Status::Rejected) then
          LoanStatus := 'Attention';

    end;

    trigger OnAfterGetRecord()
    begin
        OpenRepayment := false;
        PendingRepayment := false;
        TreatedRepayment := false;
        //Maxwell: To enable editing on the checkbox
        if Status = Status::Open then begin
          OpenRepayment := true;
          TreatedRepayment := true;
        end else begin
          OpenRepayment := false;
          TreatedRepayment := false;
        end;
        //END Maxwell
        
        /*IF Status = Status::Open THEN
          OpenRepayment := TRUE
        ELSE
          OpenRepayment := FALSE;*/
        
        if Status = Status::Pending then
          PendingRepayment := true
        else
          PendingRepayment := false;
        
        /*IF Status = Status::"Effected (Employer Advised)" THEN
          TreatedRepayment := TRUE
        ELSE
          TreatedRepayment := FALSE;*/
        
        if Status = Status::"Effected (Employer Advised)" then
          LoanStatus := 'Favorable'
        else if Status = Status::Pending then
          LoanStatus := 'Ambiguous'
        else if Status = Status::Open then
          LoanStatus := 'AttentionAccent'
        else if (Status = Status::"Payment Received") or (Status = Status::Rejected) then
          LoanStatus := 'Attention';

    end;

    trigger OnInit()
    begin
        OpenRepayment := false;
        PendingRepayment := false;
        TreatedRepayment := false;
        PendingConfirmation := false;
    end;

    trigger OnOpenPage()
    begin
        OpenRepayment := false;
        PendingRepayment := false;
        TreatedRepayment := false;
        
        //Maxwell: For Reject Button
        PendingConfirmation := false;
        if Status = Status::Pending then
          PendingConfirmation := true;
        //Maxwell: To enable editing on the checkbox
        if Status = Status::Open then begin
          OpenRepayment := true;
          TreatedRepayment := true;
        end else begin
          OpenRepayment := false;
          TreatedRepayment := false;
        end;
        //END
        /*IF Status = Status::Open THEN
          OpenRepayment := TRUE
        ELSE
          OpenRepayment := FALSE;*/
        
        if Status = Status::Pending then
          PendingRepayment := true
        else
          PendingRepayment := false;
        
        /*IF Status = Status::"Effected (Employer Advised)" THEN
          TreatedRepayment := TRUE
        ELSE
          TreatedRepayment := FALSE;*/
        
        if Status = Status::"Effected (Employer Advised)" then
          LoanStatus := 'Favorable'
        else if Status = Status::Pending then
          LoanStatus := 'Ambiguous'
        else if Status = Status::Open then
          LoanStatus := 'AttentionAccent'
        else if (Status = Status::"Payment Received") or (Status = Status::Rejected) then
          LoanStatus := 'Attention';

    end;

    var
        ImportRecords: XMLport "Import Loan Repayment";
        LoanRepaymentSchedule: Record "Loan Repayment Schedule";
        l: Integer;
        LoanRepaymentLines: Record "Loan Repayment Lines";
        Loans: Record "Loan Application";
        LoanMgt: Codeunit "Loan Management";
        OpenRepayment: Boolean;
        PendingRepayment: Boolean;
        TreatedRepayment: Boolean;
        LoanStatus: Text;
        PersNo: Code[20];
        ClientID: Code[20];
        PaymentReceived: Boolean;
        PendingConfirmation: Boolean;
        LoanRepaymentSchedule2: Record "Loan Repayment Schedule";
        LoanValuation: Decimal;

    local procedure RecalculateLoanSchedule(var RepaymentLines: Record "Loan Repayment Lines")
    var
        RepaymentDate: Date;
    begin
        with RepaymentLines do begin
        TestField(Date);
        TestField("Valuation Date");
          RepaymentDate := LoanMgt.GetPreviousRepaymentDate("Applies To Loan",Date);

        Loans.Reset;
        Loans.SetRange("Loan No.","Loan No.");
        if Loans.FindFirst then begin
        if "Total Payment" <> 0 then begin
          if RepaymentLines."Total Payment" < LoanValuation then
            LoanMgt.RecalculateRepaymentSchedule(Loans,RepaymentDate)
          else if RepaymentLines."Total Payment" > LoanValuation then

            Error('The Total Repayment is higher than the Loan Valuation.')
          else
          LoanMgt.ClearOutstandingPeriods(Loans,RepaymentDate);
        end;
        end;
        end;
    end;

    local procedure GetLoanAmountOffSchedule()
    begin
    end;
}

