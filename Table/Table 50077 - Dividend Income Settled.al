table 50077 "Dividend Income Settled"
{

    fields
    {
        field(1;"Entry No";Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(2;OwnNumber;Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(3;SchemeDividendID;Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(4;"Log ID";Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(5;ReferenceNumber;Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(6;PlanCode;Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(7;"Folio Number";Code[40])
        {
            DataClassification = ToBeClassified;
        }
        field(8;"Transaction Type";Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(9;"Record Date";Date)
        {
            DataClassification = ToBeClassified;
        }
        field(10;"Ex Date";Date)
        {
            DataClassification = ToBeClassified;
        }
        field(11;Nav;Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(12;Units;Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(13;Amount;Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(14;"Load Amount";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(15;"Settled Date";Date)
        {
            DataClassification = ToBeClassified;
        }
        field(16;"Settled Amount";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(17;"Bank ID";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(18;"Bank Account Number";Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(19;"Reinvest Plan Code";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(20;Response;Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(21;"Is Valid";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(22;"is Processed";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(23;"Transaction Status";Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(24;"Other charges";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(25;"Dividend Settlement Batch No";Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(26;"Dividend Settlement Reference";Code[30])
        {
            DataClassification = ToBeClassified;
            Description = 'DIVIDEND SETTLEMENT REFERENCE NOS';
        }
    }

    keys
    {
        key(Key1;"Entry No","Record Date",PlanCode)
        {
        }
    }

    fieldgroups
    {
    }
}

