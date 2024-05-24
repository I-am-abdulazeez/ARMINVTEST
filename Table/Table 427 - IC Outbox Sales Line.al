table 427 "IC Outbox Sales Line"
{
    // version NAVW111.00

    Caption = 'IC Outbox Sales Line';

    fields
    {
        field(1;"Document Type";Option)
        {
            Caption = 'Document Type';
            Editable = false;
            OptionCaption = 'Order,Invoice,Credit Memo,Return Order';
            OptionMembers = "Order",Invoice,"Credit Memo","Return Order";
        }
        field(3;"Document No.";Code[20])
        {
            Caption = 'Document No.';
            Editable = false;
        }
        field(4;"Line No.";Integer)
        {
            Caption = 'Line No.';
            Editable = false;
        }
        field(11;Description;Text[50])
        {
            Caption = 'Description';
        }
        field(15;Quantity;Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(22;"Unit Price";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 2;
            Caption = 'Unit Price';
            Editable = false;
        }
        field(27;"Line Discount %";Decimal)
        {
            Caption = 'Line Discount %';
            DecimalPlaces = 0:5;
            MaxValue = 100;
            MinValue = 0;
        }
        field(28;"Line Discount Amount";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Line Discount Amount';
        }
        field(30;"Amount Including VAT";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Amount Including VAT';
            Editable = false;
        }
        field(45;"Job No.";Code[20])
        {
            AccessByPermission = TableData Job=R;
            Caption = 'Job No.';
            Editable = false;
        }
        field(63;"Shipment No.";Code[20])
        {
            Caption = 'Shipment No.';
            Editable = false;
        }
        field(64;"Shipment Line No.";Integer)
        {
            Caption = 'Shipment Line No.';
            Editable = false;
        }
        field(73;"Drop Shipment";Boolean)
        {
            AccessByPermission = TableData "Drop Shpt. Post. Buffer"=R;
            Caption = 'Drop Shipment';
            Editable = false;
        }
        field(91;"Currency Code";Code[10])
        {
            Caption = 'Currency Code';
            Editable = false;
            TableRelation = Currency;
            //This property is currently not supported
            //TestTableRelation = false;
        }
        field(99;"VAT Base Amount";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'VAT Base Amount';
            Editable = false;
        }
        field(103;"Line Amount";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Line Amount';
            Editable = false;
        }
        field(107;"IC Partner Ref. Type";Option)
        {
            Caption = 'IC Partner Ref. Type';
            Editable = false;
            OptionCaption = ' ,G/L Account,Item,,,Charge (Item),Cross reference,Common Item No.';
            OptionMembers = " ","G/L Account",Item,,,"Charge (Item)","Cross reference","Common Item No.";
        }
        field(108;"IC Partner Reference";Code[20])
        {
            Caption = 'IC Partner Reference';
            Editable = false;
            TableRelation = IF ("IC Partner Ref. Type"=CONST(" ")) "Standard Text"
                            ELSE IF ("IC Partner Ref. Type"=CONST("G/L Account")) "IC G/L Account"
                            ELSE IF ("IC Partner Ref. Type"=CONST(Item)) Item
                            ELSE IF ("IC Partner Ref. Type"=CONST("Charge (Item)")) "Item Charge"
                            ELSE IF ("IC Partner Ref. Type"=CONST("Cross reference")) "Item Cross Reference";
        }
        field(125;"IC Partner Code";Code[20])
        {
            Caption = 'IC Partner Code';
            Editable = false;
            TableRelation = "IC Partner";
        }
        field(126;"IC Transaction No.";Integer)
        {
            Caption = 'IC Transaction No.';
            Editable = false;
        }
        field(127;"Transaction Source";Option)
        {
            Caption = 'Transaction Source';
            Editable = false;
            OptionCaption = 'Rejected by Current Company,Created by Current Company';
            OptionMembers = "Rejected by Current Company","Created by Current Company";
        }
        field(5407;"Unit of Measure Code";Code[10])
        {
            Caption = 'Unit of Measure Code';
            Editable = false;
        }
        field(5790;"Requested Delivery Date";Date)
        {
            AccessByPermission = TableData "Order Promising Line"=R;
            Caption = 'Requested Delivery Date';
            Editable = false;
        }
        field(5791;"Promised Delivery Date";Date)
        {
            Caption = 'Promised Delivery Date';
        }
        field(6600;"Return Receipt No.";Code[20])
        {
            Caption = 'Return Receipt No.';
            Editable = false;
        }
        field(6601;"Return Receipt Line No.";Integer)
        {
            Caption = 'Return Receipt Line No.';
            Editable = false;
        }
    }

    keys
    {
        key(Key1;"IC Transaction No.","IC Partner Code","Transaction Source","Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        ICDocDim: Record "IC Document Dimension";
        DimMgt: Codeunit DimensionManagement;
    begin
        ICDocDim.LockTable;
        DimMgt.DeleteICDocDim(DATABASE::"IC Outbox Sales Line","IC Transaction No.","IC Partner Code","Transaction Source","Line No.");
    end;

    [Scope('Personalization')]
    procedure ShowDimensions()
    var
        ICDocDim: Record "IC Document Dimension";
    begin
        TestField("IC Transaction No.");
        TestField("Line No.");
        ICDocDim.ShowDimensions(
          DATABASE::"IC Outbox Sales Line","IC Transaction No.","IC Partner Code","Transaction Source","Line No.");
    end;
}

