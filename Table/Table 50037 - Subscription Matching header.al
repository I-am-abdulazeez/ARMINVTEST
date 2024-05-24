table 50037 "Subscription Matching header"
{

    fields
    {
        field(1;No;Code[20])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if No <> xRec.No then begin
                    FundAdministrationSetup.Get;
                    NoSeriesMgt.TestManual(FundAdministrationSetup."Subscription Matching Nos");
                     "No. Series" := '';
                  end;
            end;
        }
        field(2;Narration;Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(3;"Value Date";Date)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if "Value Date"<>0D then
                validatevaluedate
            end;
        }
        field(4;"Transaction Date";Date)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                //IF "Posted Lines">0 THEN
                //  ERROR('You cannot modify Transaction date for header with posted lines');
            end;
        }
        field(5;"Fund Code";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Fund;
        }
        field(16;Posted;Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(17;"Date Posted";Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(18;"Time Posted";Time)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(19;"Posted By";Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = User;
        }
        field(31;"Bank Code";Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = Bank;
        }
        field(32;"Bank Branch";Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Bank Branches"."Branch Code" WHERE ("Bank Code"=FIELD("Bank Code"));
        }
        field(33;"Created By";Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(34;"Created Date Time";DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(35;"No. Series";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(36;"No of Matched Lines";Integer)
        {
            CalcFormula = Count("Subscription Matching Lines" WHERE ("Header No"=FIELD(No),
                                                                     Matched=CONST(true)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(37;"No of Un Matched Lines";Integer)
        {
            CalcFormula = Count("Subscription Matching Lines" WHERE ("Header No"=FIELD(No),
                                                                     Matched=CONST(false),
                                                                     "Non Client Transaction"=CONST(false)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(38;"Total No of Lines";Integer)
        {
            CalcFormula = Count("Subscription Matching Lines" WHERE ("Header No"=FIELD(No)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(39;"Total Sum of Inflows";Decimal)
        {
            CalcFormula = Sum("Subscription Matching Lines"."Credit Amount" WHERE ("Header No"=FIELD(No)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(40;"No of Non Client Lines";Integer)
        {
            CalcFormula = Count("Subscription Matching Lines" WHERE ("Header No"=FIELD(No),
                                                                     Matched=CONST(false),
                                                                     "Non Client Transaction"=CONST(true)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(102;"Reconciliation Status";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Not Reconciled,Reconciled with Statement,Reconciled With Investment System,Fully Reconciled';
            OptionMembers = "Not Reconciled","Reconciled with Statement","Reconciled With Investment System","Fully Reconciled";
        }
        field(104;Comments;Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(105;UserFilter;Code[40])
        {
            FieldClass = FlowFilter;
        }
        field(106;"Lines Assigned";Integer)
        {
            CalcFormula = Count("Subscription Matching Lines" WHERE ("Header No"=FIELD(No),
                                                                     Posted=CONST(false),
                                                                     "Assigned User"=FIELD(UserFilter)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(107;"Matched Lines";Integer)
        {
            CalcFormula = Count("Subscription Matching Lines" WHERE ("Header No"=FIELD(No),
                                                                     Matched=CONST(true),
                                                                     "Assigned User"=FIELD(UserFilter)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(108;"Un Matched Lines";Integer)
        {
            CalcFormula = Count("Subscription Matching Lines" WHERE ("Header No"=FIELD(No),
                                                                     Matched=CONST(false),
                                                                     "Non Client Transaction"=CONST(false),
                                                                     "Assigned User"=FIELD(UserFilter)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(109;"Non Client Lines";Integer)
        {
            CalcFormula = Count("Subscription Matching Lines" WHERE ("Header No"=FIELD(No),
                                                                     Matched=CONST(false),
                                                                     "Non Client Transaction"=CONST(true),
                                                                     "Assigned User"=FIELD(UserFilter)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(110;"Online Statement";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(117;"Posted Lines";Integer)
        {
            CalcFormula = Count("Subscription Matching Lines" WHERE ("Header No"=FIELD(No),
                                                                     Posted=CONST(true)));
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;No)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
           if No = '' then begin
               FundAdministrationSetup.Get;
               FundAdministrationSetup.TestField(FundAdministrationSetup."Subscription Matching Nos");
               NoSeriesMgt.InitSeries(FundAdministrationSetup."Subscription Matching Nos",xRec."No. Series",0D,No,"No. Series");
            end;

        "Transaction Date":=Today;
        "Value Date":=Today;
        "Created By":=UserId;
        "Created Date Time":=CurrentDateTime;
    end;

    var
        FundAdministrationSetup: Record "Fund Administration Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;

    local procedure validatevaluedate()
    var
        SubscriptionMatchingLines: Record "Subscription Matching Lines";
    begin
        SubscriptionMatchingLines.Reset;
        SubscriptionMatchingLines.SetRange("Header No",No);
        SubscriptionMatchingLines.ModifyAll("Value Date","Value Date");
    end;
}

