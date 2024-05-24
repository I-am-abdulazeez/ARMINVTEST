table 50127 "MF Dividend Reinvest Summary"
{
    // version MFD-1.0


    fields
    {
        field(1;No;Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(2;FundCode;Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3;DeclaredDate;Date)
        {
            DataClassification = ToBeClassified;
        }
        field(4;TransactionDate;Date)
        {
            DataClassification = ToBeClassified;
        }
        field(5;Amount;Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(6;Unit;Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 4:4;
        }
        field(7;TaxAmount;Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(8;IsReinvestment;Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(9;"Bank Account No";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(10;CreatedDate;Date)
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
        MFReinvest.Reset;
        if MFReinvest.FindLast then begin
            No := MFReinvest.No +1;
          end else begin
          No := 1;
            end;
    end;

    var
        MFReinvest: Record "MF Dividend Reinvest Summary";
}

