table 50086 "Product Fund Manager Ratio"
{
    // version THL-LOAN-1.0.0


    fields
    {
        field(1;Product;Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Loan Product";

            trigger OnValidate()
            begin
                if LoanProduct.Get(Product) then
                  "Product Description" := LoanProduct."Product Type";
            end;
        }
        field(2;"Fund Manager";Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Fund Managers";

            trigger OnValidate()
            begin
                if FundManagers.Get("Fund Manager") then
                  "Fund Manager Name" := FundManagers.Name;
            end;
        }
        field(3;"Product Description";Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(4;"Fund Manager Name";Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(5;Percentage;Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 8:8;
        }
        field(6;From;Date)
        {
            DataClassification = ToBeClassified;
        }
        field(7;"To";Date)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;Product,"Fund Manager",From,"To")
        {
        }
    }

    fieldgroups
    {
    }

    var
        FundManagers: Record "Fund Managers";
        LoanProduct: Record "Loan Product";
}

