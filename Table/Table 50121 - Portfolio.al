table 50121 Portfolio
{
    // version MFD-1.0


    fields
    {
        field(1;No;Integer)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(2;"Portfolio Code";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3;"Instrument Id";Code[10])
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
        portfolio.Reset;
        if portfolio.FindLast then begin
          No := portfolio.No + 1;
          end
        else begin
          No := 1;
        end;
    end;

    var
        Nos: Integer;
        portfolio: Record Portfolio;
}

