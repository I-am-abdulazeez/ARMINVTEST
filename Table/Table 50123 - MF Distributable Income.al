table 50123 "MF Distributable Income"
{
    // version MFD-1.0


    fields
    {
        field(1;Date;Date)
        {
            DataClassification = ToBeClassified;
        }
        field(2;"Fund Code";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3;"Daily Distributable Income";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(4;"Sub Units";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(5;"Redemption Units";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(6;"EOD Nav";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(7;No;Code[20])
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
        field(16;"Total Fund Units";Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 4:4;
        }
        field(17;"Earnings Per Unit";Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 4:12;
        }
        field(18;"Total Line Units";Decimal)
        {
            CalcFormula = Sum("Daily Income Distrib Lines"."No of Units" WHERE (No=FIELD(No)));
            DecimalPlaces = 4:4;
            Editable = false;
            FieldClass = FlowField;
        }
        field(19;"Total Line Amount";Decimal)
        {
            CalcFormula = Sum("Daily Income Distrib Lines"."Income accrued" WHERE (No=FIELD(No)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(21;Closed;Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(22;"Date Closed";DateTime)
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
             FundAdministrationSetup.TestField(FundAdministrationSetup."Daily Distributable Income Nos");
             NoSeriesMgt.InitSeries(FundAdministrationSetup."Daily Distributable Income Nos",xRec."No. Series",0D,No,"No. Series");
          end;


        "Created By":=UserId;
        "Creation Date":=Today;
    end;

    var
        FundAdministrationSetup: Record "Fund Administration Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
}

