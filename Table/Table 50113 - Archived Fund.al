table 50113 "Archived Fund"
{
    DrillDownPageID = "Fund List";
    LookupPageID = "Fund List";

    fields
    {
        field(1;"Fund Code";Code[20])
        {
            DataClassification = ToBeClassified;
            NotBlank = false;
        }
        field(2;Name;Text[150])
        {
            DataClassification = ToBeClassified;
            NotBlank = true;
        }
        field(3;"Fund Type";Option)
        {
            FieldClass = Normal;
            NotBlank = true;
            OptionCaption = 'Open Ended,Close Ended,ETF';
            OptionMembers = "Open Ended","Close Ended",ETF;
        }
        field(4;"Dividend Distribution Type";Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(5;"No of Accounts";Integer)
        {
            CalcFormula = Count("Client Account" WHERE ("Fund No"=FIELD("Fund Code")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(6;Picture;BLOB)
        {
            DataClassification = ToBeClassified;
            SubType = Bitmap;
        }
        field(7;"Active Fund";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(41;"Bid Price Factor";Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 4:4;
        }
        field(42;"Offer Price Factor";Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 4:4;
        }
        field(122;"Date Filter";Date)
        {
            FieldClass = FlowFilter;
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
        field(204;"No. Series";Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(205;"Currency Code";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Currency;
        }
        field(206;Country;Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Country/Region";
        }
        field(207;"Asset Class";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Debt,Equity,Balanced,Cash,Commodities,Alternate';
            OptionMembers = Debt,Equity,Balanced,Cash,Commodities,Alternate;
        }
        field(208;Classification;Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(209;Sector;Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(210;Unitized;Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(211;"Rounded Price";Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(212;"Rounded Nav";Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(213;"Rounded Units";Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(214;"Ext Registrar Verification Req";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(215;"No of Units";Decimal)
        {
            CalcFormula = Sum("Client Transactions"."No of Units" WHERE ("Fund Code"=FIELD("Fund Code"),
                                                                         "Value Date"=FIELD("Date Filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(216;"Dividend Period";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'No Dividend,Daily,Weekly,Monthly,Quartely,Half Year,Yearly';
            OptionMembers = "No Dividend",Daily,Weekly,Monthly,Quartely,"Half Year",Yearly;
        }
        field(217;"Minimum Holding Period";DateFormula)
        {
            DataClassification = ToBeClassified;
        }
        field(218;"Percentage Penalty";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(219;"Minimum Holding Balance";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(220;"Approval Status";Option)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = 'Created,Pending Approval,Approved,Rejected';
            OptionMembers = Created,"Pending Approval",Approved,Rejected;
        }
        field(221;"Approved BY";Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(222;"Special Bid Price";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(223;"Special offer Price";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(224;"Special Price Date";Date)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                //"Special Price End Date":=CALCDATE('1D',"Special Price Start Date");
            end;
        }
        field(225;"Fund Group";Code[40])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Fund Groups";
        }
    }

    keys
    {
        key(Key1;"Fund Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        if ("Fund Code" = '') then begin
          FundAdministrationSetup.Get;
          FundAdministrationSetup.TestField(FundAdministrationSetup."Fund Nos.");
          NoSeriesMgt.InitSeries(FundAdministrationSetup."Fund Nos.",
            xRec."Last Modified By",0D,"Fund Code","Last Modified By");
        end;
        "Last Modified By":=UserId;
        "Last Modified DateTime":=CurrentDateTime;
    end;

    trigger OnModify()
    begin
        "Last Modified By":=UserId;
        "Last Modified DateTime":=CurrentDateTime;
    end;

    var
        FundAdministrationSetup: Record "Fund Administration Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        DimMgt: Codeunit DimensionManagement;

    procedure AssistEdit(): Boolean
    begin
         FundAdministrationSetup.Get;
         FundAdministrationSetup.TestField(FundAdministrationSetup."Fund Nos.");
        if NoSeriesMgt.SelectSeries(FundAdministrationSetup."Fund Nos.",xRec."Last Modified By","Last Modified By") then begin
          NoSeriesMgt.SetSeries("Fund Code");
          exit(true);
        end;
    end;

    procedure ValidateShortcutDimCode(FieldNumber: Integer;var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateDimValueCode(FieldNumber,ShortcutDimCode);
        DimMgt.SaveDefaultDim(DATABASE::Fund,"Fund Code",FieldNumber,ShortcutDimCode);
        Modify;
    end;
}

