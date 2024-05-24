table 50125 "MF Payment Header"
{
    // version MFD-1.0


    fields
    {
        field(1;No;Code[20])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if No <> xRec.No then begin
                  FundAdministrationSetup.Get;
                  NoSeriesMgt.TestManual(FundAdministrationSetup."Daily Distributable Income Nos");
                   "No. Series" := '';
                end;
            end;
        }
        field(2;"Payment Date";Date)
        {
            DataClassification = ToBeClassified;
            TableRelation = Quarters;
        }
        field(3;Date;Date)
        {
            DataClassification = ToBeClassified;
        }
        field(4;"Fund Code";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(5;"Total Dividend Amount";Decimal)
        {
        }
        field(6;"No of Accounts";Integer)
        {
            CalcFormula = Count("MF Payment Lines" WHERE ("Header No"=FIELD(No)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(7;"Total Dividend Calculated";Decimal)
        {
            CalcFormula = Sum("MF Payment Lines"."Total Dividend Earned" WHERE ("Header No"=FIELD(No)));
            DecimalPlaces = 2:2;
            Editable = false;
            FieldClass = FlowField;
        }
        field(8;Narration;Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(11;"Created By";Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = User;
        }
        field(12;"Creation Date";Date)
        {
            DataClassification = ToBeClassified;
        }
        field(14;"No. Series";Code[10])
        {
            Caption = 'No. Series';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "No. Series";
        }
        field(15;"No of Payouts";Integer)
        {
            CalcFormula = Count("MF Payment Lines" WHERE ("Header No"=FIELD(No),
                                                          "Dividend Mandate"=CONST(Payout)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(16;"Total Payouts";Decimal)
        {
            CalcFormula = Sum("MF Payment Lines"."Dividend Amount" WHERE ("Header No"=FIELD(No),
                                                                          "Dividend Mandate"=CONST(Payout)));
            DecimalPlaces = 2:2;
            Editable = false;
            FieldClass = FlowField;
        }
        field(17;"No of Re- invest";Integer)
        {
            CalcFormula = Count("MF Payment Lines" WHERE ("Header No"=FIELD(No),
                                                          "Dividend Mandate"=CONST(Reinvest)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(18;"Total Re- invest";Decimal)
        {
            CalcFormula = Sum("MF Payment Lines"."Dividend Amount" WHERE ("Header No"=FIELD(No),
                                                                          "Dividend Mandate"=CONST(Reinvest)));
            DecimalPlaces = 2:2;
            Editable = false;
            FieldClass = FlowField;
        }
        field(19;"No Without Mandate";Integer)
        {
            CalcFormula = Count("MF Payment Lines" WHERE ("Header No"=FIELD(No),
                                                          "Dividend Mandate"=CONST(" ")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(20;"Total Without Mandate";Decimal)
        {
            CalcFormula = Sum("MF Payment Lines"."Dividend Amount" WHERE ("Header No"=FIELD(No),
                                                                          "Dividend Mandate"=CONST(" ")));
            DecimalPlaces = 2:2;
            Editable = false;
            FieldClass = FlowField;
        }
        field(22;Status;Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Generated,Internal Control,Verified,Sent to Treasury,Fully Processed';
            OptionMembers = Generated,"Internal Control",Verified,"Sent to Treasury","Fully Processed";
        }
        field(23;Processed;Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(24;"DateTime Verified";DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(25;"DateTime Processed";DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(104;Comments;Text[250])
        {
            DataClassification = ToBeClassified;
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
             FundAdministrationSetup.TestField(FundAdministrationSetup."End of Quarter Nos");
             NoSeriesMgt.InitSeries(FundAdministrationSetup."End of Quarter Nos",xRec."No. Series",0D,No,"No. Series");
          end;


        "Created By":=UserId;
        "Creation Date":=Today;
    end;

    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
        FundAdministrationSetup: Record "Fund Administration Setup";
}

