table 50005 "Fund Prices"
{

    fields
    {
        field(10;"Fund No.";Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = Fund."Fund Code" WHERE ("Fund Code"=FIELD("Fund No."));

            trigger OnValidate()
            begin
                /*Fund.GET("Fund No.");
                "Offer Price Factor":=Fund."Offer Price Factor";
                "Bid Price Factor":=Fund."Bid Price Factor";
                VALIDATE("Offer Price Factor",Fund."Offer Price Factor");
                VALIDATE("Bid Price Factor",Fund."Bid Price Factor");
                */

            end;
        }
        field(20;"Value Date";Date)
        {
            DataClassification = ToBeClassified;
        }
        field(29;"Mid Price";Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 4:4;

            trigger OnValidate()
            begin
                calculateprices
            end;
        }
        field(30;"Bid Price";Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 4:4;
            Editable = true;
        }
        field(36;Select;Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                "Selected By":=UserId;
            end;
        }
        field(40;"Offer Price";Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 4:4;
            Editable = true;

            trigger OnValidate()
            begin
                FundPricing.Reset;
                FundPricing.SetRange(FundPricing."Fund No.","Fund No.");
                FundPricing.SetFilter(FundPricing."Value Date",'<%1',"Value Date");
                if FundPricing.Find('+') then
                 LastFundPrice:=FundPricing."Offer Price";




                  //MESSAGE('%1',LastFundPrice);

                  if LastFundPrice<>0 then
                  "Fund Performance":=("Offer Price"-LastFundPrice)/
                  LastFundPrice*100;
            end;
        }
        field(41;"Bid Price Factor";Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 4:4;

            trigger OnValidate()
            begin
                calculateprices
            end;
        }
        field(42;"Offer Price Factor";Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 4:4;

            trigger OnValidate()
            begin
                calculateprices
            end;
        }
        field(50;Comments;Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(51;"Actual NSE Index";Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                FundPricing.Reset;
                FundPricing.SetRange(FundPricing."Fund No.","Fund No.");
                FundPricing.SetFilter(FundPricing."Value Date",'<%1',"Value Date");
                if FundPricing.Find('+') then
                 LastNSEPrice:=FundPricing."Actual NSE Index";




                  //MESSAGE('%1',LastFundPrice);

                  if LastNSEPrice<>0 then
                 "Market Performance":=("Actual NSE Index"-LastNSEPrice)/
                  LastNSEPrice*100;
            end;
        }
        field(52;"Fund Performance";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(53;"Market Performance";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(96;"Selected By";Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(200;"Last Modified By";Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = User;
        }
        field(201;"Last Modified DateTime";DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(202;Activated;Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(203;"Activated By";Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(204;"Activated Date Time";DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(205;Source;Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(206;"Send for activation";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(207;"Created By";Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(208;"Created Date Time";DateTime)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"Fund No.","Value Date")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnModify()
    begin
        "Last Modified By":=UserId;
        "Last Modified DateTime":=CurrentDateTime;
    end;

    var
        FundPricing: Record "Fund Prices";
        LastFundPrice: Decimal;
        LastNSEPrice: Decimal;
        Fund: Record Fund;

    local procedure calculateprices()
    begin
    end;
}

