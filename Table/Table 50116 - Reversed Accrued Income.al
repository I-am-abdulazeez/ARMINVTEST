table 50116 "Reversed Accrued Income"
{

    fields
    {
        field(1;No;Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(2;"Client ID";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3;"Account No";Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(4;Fund;Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(5;"Reversed Unit";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(6;"Amount Reversed";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(7;"Accrued Income";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(8;"Date Reversed";Date)
        {
            DataClassification = ToBeClassified;
        }
        field(9;"Redistribution Date";Date)
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
        ReversedAccruedIncome.Reset;
         if ReversedAccruedIncome.FindLast then begin
             No := ReversedAccruedIncome.No +1;
          end else begin
          No := 1;
            end;
    end;

    var
        ReversedAccruedIncome: Record "Reversed Accrued Income";
        sNo: Integer;
}

