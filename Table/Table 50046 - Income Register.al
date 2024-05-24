table 50046 "Income Register"
{
    // version MFD-1.0


    fields
    {
        field(1;"Value Date";Date)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                TestField(Distributed,false);
            end;
        }
        field(2;"Fund ID";Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = Fund;

            trigger OnValidate()
            begin
                  if Fundrec.Get("Fund ID") then
                  "Fund Name" := Fundrec.Name;
                TestField(Distributed,false);
            end;
        }
        field(3;"Fund Name";Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(4;"Total Income";Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 4:4;

            trigger OnValidate()
            begin
                "Distributed Income" := "Total Income" - "Total Expenses";
                TestField(Distributed,false);
            end;
        }
        field(5;"Total Expenses";Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 4:4;

            trigger OnValidate()
            begin
                Validate("Total Income");
                TestField(Distributed,false);
            end;
        }
        field(6;"Distributed Income";Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 4:4;
            Editable = false;
        }
        field(7;Processed;Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(8;"Created Date";Date)
        {
            DataClassification = ToBeClassified;
        }
        field(9;"Created By";Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(10;Distributed;Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(11;"Quarter Closed";Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                "Date Closed":=CurrentDateTime;
            end;
        }
        field(12;"Date Closed";DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(17;"Earnings Per Unit";Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 4:12;

            trigger OnValidate()
            begin
                TestField(Distributed,false);
            end;
        }
        field(18;"WHT Rate";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(19;"WHT Amount";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(20;"Expected Payment Date";Date)
        {
            DataClassification = ToBeClassified;
        }
        field(21;Reference;Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(22;"Date Received";Date)
        {
            DataClassification = ToBeClassified;
        }
        field(23;"MF Payment";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(24;"MF Date Paid";DateTime)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"Value Date","Fund ID")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        //ERROR('You are not allowed to delete');
    end;

    var
        Fundrec: Record Fund;
}

