table 50129 "MF Dividend"
{
    // version MFD-1.0


    fields
    {
        field(1;No;Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(2;PortfolioCode;Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3;FundCode;Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(4;AssetClassId;Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(5;DeclaredDate;Date)
        {
            DataClassification = ToBeClassified;
        }
        field(6;TransactionDate;Date)
        {
            DataClassification = ToBeClassified;
        }
        field(7;Amount;Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(8;ReinvestmentPrice;Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 4:4;
        }
        field(9;Unit;Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 4:4;
        }
        field(10;TaxAmount;Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(11;IsReinvestment;Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(12;CreatedDate;Date)
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
        MFDividend.Reset;
        if MFDividend.FindLast then begin
            No := MFDividend.No +1;
          end else begin
          No := 1;
            end;
    end;

    var
        MFDividend: Record "MF Dividend";
}

