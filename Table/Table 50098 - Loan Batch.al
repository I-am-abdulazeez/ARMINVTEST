table 50098 "Loan Batch"
{
    // version THL-LOAN-1.0.0


    fields
    {
        field(1;"No.";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2;"Created By";Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(3;"No. of Requests";Integer)
        {
            CalcFormula = Count("Loan Application" WHERE ("Batch No"=FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(4;"Total Request Amount";Decimal)
        {
            CalcFormula = Sum("Loan Application"."Requested Amount" WHERE ("Batch No"=FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(5;Status;Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'New,Pending Approval,Approved,Treasury,Disbursed,Rejected';
            OptionMembers = New,"Pending Approval",Approved,Treasury,Disbursed,Rejected;
        }
        field(6;"Total New Requests";Integer)
        {
            CalcFormula = Count("Loan Application" WHERE ("Batch No"=FIELD("No."),
                                                          Status=CONST(New)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(7;"Total Pending Requests";Integer)
        {
            CalcFormula = Count("Loan Application" WHERE ("Batch No"=FIELD("No."),
                                                          Status=CONST("Pending Approval")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(8;"Total Approved Requests";Integer)
        {
            CalcFormula = Count("Loan Application" WHERE ("Batch No"=FIELD("No."),
                                                          Status=CONST(Approved)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(9;"Total Disbursed Requests";Integer)
        {
            CalcFormula = Count("Loan Application" WHERE ("Batch No"=FIELD("No."),
                                                          Disbursed=CONST(true)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(10;"Total Rejected Requests";Integer)
        {
            CalcFormula = Count("Loan Application" WHERE ("Batch No"=FIELD("No."),
                                                          Status=CONST(Rejected)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(11;Date;DateTime)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        if "No." = '' then begin
          LoanMgtSetup.Get;
          if LoanMgtSetup."Last Batch Loan No." <> '' then
          begin
          Evaluate(counters, ConvertStr(LoanMgtSetup."Last Batch Loan No.",'LB-','000'))
          end;
          counters:= counters+1;
          reccode:= (PadStr('', 16 - StrLen(Format(counters)), '0') + Format(counters));
          "No.":= 'LB-' + reccode;
          LoanMgtSetup.ModifyAll("Last Batch Loan No.",'LB-' + reccode);
        end;

        "Created By":=UserId;
        Date:=CurrentDateTime;
    end;

    var
        LoanMgtSetup: Record "Loan Management Setup";
        counters: Integer;
        reccode: Code[20];
}

