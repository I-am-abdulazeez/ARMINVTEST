table 50085 "Fund Managers"
{
    // version THL-LOAN-1.0.0


    fields
    {
        field(1;"Code";Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(2;Name;Text[50])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if Code = '' then
                  Error('Code must be entered first!');
            end;
        }
    }

    keys
    {
        key(Key1;"Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        if Code = '' then
          Error('Code must be entered first!');
    end;
}

