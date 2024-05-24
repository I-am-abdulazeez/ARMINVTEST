table 50091 "Loan Repayment Header"
{
    // version THL-LOAN-1.0.0


    fields
    {
        field(1;"Code";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2;"Date and Time";DateTime)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                Month := Format(DT2Date("Date and Time"),0,'<Month Text> <Year4>');
                /*Repayment.RESET;
                Repayment.SETCURRENTKEY(Month,"Type of Schedule");
                Repayment.SETRANGE(Month,Month);
                Repayment.SETRANGE("Type of Schedule",Repayment."Type of Schedule"::"Monthly Advice to Employer");
                IF Repayment.FINDFIRST THEN
                  ERROR('Monthly Repayment batch was already generated for %1 as batch No. %2',Month,Repayment.Code);*/

            end;
        }
        field(3;"Imported by";Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(4;Status;Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Open,Pending,Effected (Employer Advised),Payment Received,Rejected';
            OptionMembers = Open,Pending,"Effected (Employer Advised)","Payment Received",Rejected;
        }
        field(5;"No of Lines";Integer)
        {
            CalcFormula = Count("Loan Repayment Lines" WHERE ("Header No"=FIELD(Code)));
            FieldClass = FlowField;
        }
        field(6;Month;Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(7;"Total Amount";Decimal)
        {
            CalcFormula = Sum("Loan Repayment Lines"."Total Payment" WHERE ("Header No"=FIELD(Code)));
            FieldClass = FlowField;
        }
        field(8;"Type of Schedule";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Monthly Advice to Employer,Off-Schedule Repayment';
            OptionMembers = "Monthly Advice to Employer","Off-Schedule Repayment";

            trigger OnValidate()
            begin
                /*TESTFIELD("Date and Time");
                
                IF "Type of Schedule" <>  xRec."Type of Schedule" THEN
                IF xRec."Type of Schedule" = xRec."Type of Schedule"::"Monthly Advice to Employer" THEN
                VALIDATE("Date and Time");*/

            end;
        }
    }

    keys
    {
        key(Key1;"Code")
        {
        }
        key(Key2;Month,"Type of Schedule")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        Loanrep.Reset;
        if Loanrep.FindLast then
        begin
        Evaluate(counters, ConvertStr(Loanrep.Code,'LR-','000'))
        end;
        counters:= counters+1;
        reccode:= (PadStr('', 5 - StrLen(Format(counters)), '0') + Format(counters));
        Code:= 'LR-' + reccode;
        Status := Status::Open;
        "Imported by":=UserId;
    end;

    var
        Loanrep: Record "Loan Repayment Header";
        counters: Integer;
        reccode: Text;
        Repayment: Record "Loan Repayment Header";
}

