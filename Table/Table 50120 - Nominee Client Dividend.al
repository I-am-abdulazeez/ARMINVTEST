table 50120 "Nominee Client Dividend"
{
    // version MFD-1.0


    fields
    {
        field(1;No;Code[10])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if No <> xRec.No then begin
                  FundAdministrationSetup.Get;
                  NoSeriesMgt.TestManual(FundAdministrationSetup."Mutual Fund Nominee Nos");
                end;
            end;
        }
        field(2;PortfolioCode;Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3;SecurityCode;Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(4;InstrumentId;Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(5;DeclaredDate;Date)
        {
            DataClassification = ToBeClassified;
        }
        field(6;PaymentDate;Date)
        {
            DataClassification = ToBeClassified;
        }
        field(7;HoldingUnits;Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(8;Amount;Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(9;TaxAmount;Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(15;Sent;Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(16;CreatedDate;Date)
        {
            DataClassification = ToBeClassified;
        }
        field(17;CreatedBy;Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(18;"No. Series";Code[10])
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
             FundAdministrationSetup.TestField(FundAdministrationSetup."Mutual Fund Nominee Nos");
             NoSeriesMgt.InitSeries(FundAdministrationSetup."Mutual Fund Nominee Nos",xRec."No. Series",0D,No,"No. Series");
          end;
    end;

    var
        FundAdministrationSetup: Record "Fund Administration Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
}

