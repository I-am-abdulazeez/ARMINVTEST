table 7504 "Item Attribute Value Selection"
{
    // version NAVW113.03

    Caption = 'Item Attribute Value Selection';

    fields
    {
        field(1;"Attribute Name";Text[250])
        {
            Caption = 'Attribute Name';
            NotBlank = true;

            trigger OnValidate()
            var
                ItemAttribute: Record "Item Attribute";
            begin
                FindItemAttributeCaseInsensitive(ItemAttribute);
                CheckForDuplicate;
                CheckIfBlocked(ItemAttribute);
                AdjustAttributeName(ItemAttribute);
                ValidateChangedAttribute(ItemAttribute);
            end;
        }
        field(2;Value;Text[250])
        {
            Caption = 'Value';

            trigger OnValidate()
            var
                ItemAttributeValue: Record "Item Attribute Value";
                ItemAttribute: Record "Item Attribute";
                DecimalValue: Decimal;
                IntegerValue: Integer;
                DateValue: Date;
            begin
                if Value = '' then
                  exit;

                ItemAttribute.Get("Attribute ID");
                if FindItemAttributeValueCaseSensitive(ItemAttributeValue) then
                  CheckIfValueBlocked(ItemAttributeValue);

                case "Attribute Type" of
                  "Attribute Type"::Option:
                    begin
                      if ItemAttributeValue.Value = '' then begin
                        if not FindItemAttributeValueCaseInsensitive(ItemAttributeValue) then
                          Error(AttributeValueDoesntExistErr,Value);
                        CheckIfValueBlocked(ItemAttributeValue);
                      end;
                      AdjustAttributeValue(ItemAttributeValue);
                    end;
                  "Attribute Type"::Decimal:
                    ValidateType(DecimalValue,Value,ItemAttribute);
                  "Attribute Type"::Integer:
                    ValidateType(IntegerValue,Value,ItemAttribute);
                  "Attribute Type"::Date:
                    ValidateType(DateValue,Value,ItemAttribute);
                end;
            end;
        }
        field(3;"Attribute ID";Integer)
        {
            Caption = 'Attribute ID';
        }
        field(4;"Unit of Measure";Text[30])
        {
            Caption = 'Unit of Measure';
            Editable = false;
        }
        field(6;Blocked;Boolean)
        {
            Caption = 'Blocked';
        }
        field(7;"Attribute Type";Option)
        {
            Caption = 'Attribute Type';
            OptionCaption = 'Option,Text,Integer,Decimal,Date';
            OptionMembers = Option,Text,"Integer",Decimal,Date;
        }
        field(8;"Inherited-From Table ID";Integer)
        {
            Caption = 'Inherited-From Table ID';
        }
        field(9;"Inherited-From Key Value";Code[20])
        {
            Caption = 'Inherited-From Key Value';
        }
        field(10;"Inheritance Level";Integer)
        {
            Caption = 'Inheritance Level';
        }
    }

    keys
    {
        key(Key1;"Attribute Name")
        {
        }
        key(Key2;"Inheritance Level","Attribute Name")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown;"Attribute ID")
        {
        }
        fieldgroup(Brick;"Attribute Name",Value,"Unit of Measure")
        {
        }
    }

    var
        AttributeDoesntExistErr: Label 'The item attribute ''%1'' doesn''t exist.', Comment='%1 - arbitrary name';
        AttributeBlockedErr: Label 'The item attribute ''%1'' is blocked.', Comment='%1 - arbitrary name';
        AttributeValueBlockedErr: Label 'The item attribute value ''%1'' is blocked.', Comment='%1 - arbitrary name';
        AttributeValueDoesntExistErr: Label 'The item attribute value ''%1'' doesn''t exist.', Comment='%1 - arbitrary name';
        AttributeValueAlreadySpecifiedErr: Label 'You have already specified a value for item attribute ''%1''.', Comment='%1 - attribute name';
        AttributeValueTypeMismatchErr: Label 'The value ''%1'' does not match the item attribute of type %2.', Comment=' %1 is arbitrary string, %2 is type name';

    [Scope('Personalization')]
    procedure PopulateItemAttributeValueSelection(var TempItemAttributeValue: Record "Item Attribute Value" temporary)
    begin
        if TempItemAttributeValue.FindSet then
          repeat
            InsertRecord(TempItemAttributeValue,0,'');
          until TempItemAttributeValue.Next = 0;
    end;

    [Scope('Personalization')]
    procedure PopulateItemAttributeValue(var TempNewItemAttributeValue: Record "Item Attribute Value" temporary)
    var
        ItemAttributeValue: Record "Item Attribute Value";
        ValDecimal: Decimal;
    begin
        if FindSet then
          repeat
            Clear(TempNewItemAttributeValue);
            TempNewItemAttributeValue.Init;
            TempNewItemAttributeValue."Attribute ID" := "Attribute ID";
            TempNewItemAttributeValue.Blocked := Blocked;
            ItemAttributeValue.Reset;
            ItemAttributeValue.SetRange("Attribute ID","Attribute ID");
            case "Attribute Type" of
              "Attribute Type"::Option,
              "Attribute Type"::Text,
              "Attribute Type"::Integer:
                begin
                  TempNewItemAttributeValue.Value := Value;
                  ItemAttributeValue.SetRange(Value,Value);
                end;
              "Attribute Type"::Decimal:
                begin
                  if Value <> '' then begin
                    Evaluate(ValDecimal,Value);
                    ItemAttributeValue.SetRange(Value,Format(ValDecimal,0,9));
                    if ItemAttributeValue.IsEmpty then begin
                      ItemAttributeValue.SetRange(Value,Format(ValDecimal));
                      if ItemAttributeValue.IsEmpty then
                        ItemAttributeValue.SetRange(Value,Value);
                    end;
                  end;
                  TempNewItemAttributeValue.Value := Format(ValDecimal);
                end;
            end;
            if not ItemAttributeValue.FindFirst then
              InsertItemAttributeValue(ItemAttributeValue,Rec);
            TempNewItemAttributeValue.ID := ItemAttributeValue.ID;
            TempNewItemAttributeValue.Insert;
          until Next = 0;
    end;

    [Scope('Personalization')]
    procedure InsertItemAttributeValue(var ItemAttributeValue: Record "Item Attribute Value";TempItemAttributeValueSelection: Record "Item Attribute Value Selection" temporary)
    var
        ValDecimal: Decimal;
        ValDate: Date;
    begin
        Clear(ItemAttributeValue);
        ItemAttributeValue."Attribute ID" := TempItemAttributeValueSelection."Attribute ID";
        ItemAttributeValue.Blocked := TempItemAttributeValueSelection.Blocked;
        case TempItemAttributeValueSelection."Attribute Type" of
          TempItemAttributeValueSelection."Attribute Type"::Option,
          TempItemAttributeValueSelection."Attribute Type"::Text:
            ItemAttributeValue.Value := TempItemAttributeValueSelection.Value;
          TempItemAttributeValueSelection."Attribute Type"::Integer:
            ItemAttributeValue.Validate(Value,TempItemAttributeValueSelection.Value);
          TempItemAttributeValueSelection."Attribute Type"::Decimal:
            if TempItemAttributeValueSelection.Value <> '' then begin
              Evaluate(ValDecimal,TempItemAttributeValueSelection.Value);
              ItemAttributeValue.Validate(Value,Format(ValDecimal));
            end;
          TempItemAttributeValueSelection."Attribute Type"::Date:
            if TempItemAttributeValueSelection.Value <> '' then begin
              Evaluate(ValDate,TempItemAttributeValueSelection.Value);
              ItemAttributeValue.Validate("Date Value",ValDate);
            end;
        end;
        ItemAttributeValue.Insert;
    end;

    [Scope('Personalization')]
    procedure InsertRecord(var TempItemAttributeValue: Record "Item Attribute Value" temporary;DefinedOnTableID: Integer;DefinedOnKeyValue: Code[20])
    var
        ItemAttribute: Record "Item Attribute";
    begin
        "Attribute ID" := TempItemAttributeValue."Attribute ID";
        ItemAttribute.Get(TempItemAttributeValue."Attribute ID");
        "Attribute Name" := ItemAttribute.Name;
        "Attribute Type" := ItemAttribute.Type;
        Value := TempItemAttributeValue.GetValueInCurrentLanguageWithoutUnitOfMeasure;
        Blocked := TempItemAttributeValue.Blocked;
        "Unit of Measure" := ItemAttribute."Unit of Measure";
        "Inherited-From Table ID" := DefinedOnTableID;
        "Inherited-From Key Value" := DefinedOnKeyValue;
        Insert;
    end;

    local procedure ValidateType(Variant: Variant;ValueToValidate: Text;ItemAttribute: Record "Item Attribute")
    var
        TypeHelper: Codeunit "Type Helper";
        CultureInfo: DotNet CultureInfo;
    begin
        if (ValueToValidate <> '') and not TypeHelper.Evaluate(Variant,ValueToValidate,'',CultureInfo.CurrentCulture.Name) then
          Error(AttributeValueTypeMismatchErr,ValueToValidate,ItemAttribute.Type);
    end;

    local procedure FindItemAttributeCaseInsensitive(var ItemAttribute: Record "Item Attribute")
    var
        AttributeName: Text[250];
    begin
        OnBeforeFindItemAttributeCaseInsensitive(ItemAttribute,Rec);

        ItemAttribute.SetRange(Name,"Attribute Name");
        if ItemAttribute.FindFirst then
          exit;

        AttributeName := LowerCase("Attribute Name");
        ItemAttribute.SetRange(Name);
        if ItemAttribute.FindSet then
          repeat
            if LowerCase(ItemAttribute.Name) = AttributeName then
              exit;
          until ItemAttribute.Next = 0;

        Error(AttributeDoesntExistErr,"Attribute Name");
    end;

    local procedure FindItemAttributeValueCaseSensitive(var ItemAttributeValue: Record "Item Attribute Value"): Boolean
    begin
        ItemAttributeValue.SetRange("Attribute ID","Attribute ID");
        ItemAttributeValue.SetRange(Value,Value);
        exit(ItemAttributeValue.FindFirst);
    end;

    local procedure FindItemAttributeValueCaseInsensitive(var ItemAttributeValue: Record "Item Attribute Value"): Boolean
    var
        AttributeValue: Text[250];
    begin
        ItemAttributeValue.SetRange("Attribute ID","Attribute ID");
        ItemAttributeValue.SetRange(Value);
        if ItemAttributeValue.FindSet then begin
          AttributeValue := LowerCase(Value);
          repeat
            if LowerCase(ItemAttributeValue.Value) = AttributeValue then
              exit(true);
          until ItemAttributeValue.Next = 0;
        end;
        exit(false);
    end;

    local procedure CheckForDuplicate()
    var
        TempItemAttributeValueSelection: Record "Item Attribute Value Selection" temporary;
        AttributeName: Text[250];
    begin
        if IsEmpty then
          exit;
        AttributeName := LowerCase("Attribute Name");
        TempItemAttributeValueSelection.Copy(Rec,true);
        if TempItemAttributeValueSelection.FindSet then
          repeat
            if TempItemAttributeValueSelection."Attribute ID" <> "Attribute ID" then
              if LowerCase(TempItemAttributeValueSelection."Attribute Name") = AttributeName then
                Error(AttributeValueAlreadySpecifiedErr,"Attribute Name");
          until TempItemAttributeValueSelection.Next = 0;
    end;

    local procedure CheckIfBlocked(var ItemAttribute: Record "Item Attribute")
    begin
        if ItemAttribute.Blocked then
          Error(AttributeBlockedErr,ItemAttribute.Name);
    end;

    local procedure CheckIfValueBlocked(ItemAttributeValue: Record "Item Attribute Value")
    begin
        if ItemAttributeValue.Blocked then
          Error(AttributeValueBlockedErr,ItemAttributeValue.Value);
    end;

    local procedure AdjustAttributeName(var ItemAttribute: Record "Item Attribute")
    begin
        if "Attribute Name" <> ItemAttribute.Name then
          "Attribute Name" := ItemAttribute.Name;
    end;

    local procedure AdjustAttributeValue(var ItemAttributeValue: Record "Item Attribute Value")
    begin
        if Value <> ItemAttributeValue.Value then
          Value := ItemAttributeValue.Value;
    end;

    local procedure ValidateChangedAttribute(var ItemAttribute: Record "Item Attribute")
    begin
        if "Attribute ID" <> ItemAttribute.ID then begin
          Validate("Attribute ID",ItemAttribute.ID);
          Validate("Attribute Type",ItemAttribute.Type);
          Validate("Unit of Measure",ItemAttribute."Unit of Measure");
          Validate(Value,'');
        end;
    end;

    [Scope('Personalization')]
    procedure FindAttributeValue(var ItemAttributeValue: Record "Item Attribute Value"): Boolean
    begin
        exit(FindAttributeValueFromRecord(ItemAttributeValue,Rec));
    end;

    [Scope('Personalization')]
    procedure FindAttributeValueFromRecord(var ItemAttributeValue: Record "Item Attribute Value";ItemAttributeValueSelection: Record "Item Attribute Value Selection"): Boolean
    var
        ValDecimal: Decimal;
    begin
        ItemAttributeValue.Reset;
        ItemAttributeValue.SetRange("Attribute ID",ItemAttributeValueSelection."Attribute ID");
        if IsNotBlankDecimal(ItemAttributeValueSelection.Value) then begin
          Evaluate(ValDecimal,ItemAttributeValueSelection.Value);
          ItemAttributeValue.SetRange("Numeric Value",ValDecimal);
        end else
          ItemAttributeValue.SetRange(Value,ItemAttributeValueSelection.Value);
        exit(ItemAttributeValue.FindFirst);
    end;

    [Scope('Personalization')]
    procedure GetAttributeValueID(var TempItemAttributeValueToInsert: Record "Item Attribute Value" temporary): Integer
    var
        ItemAttributeValue: Record "Item Attribute Value";
        ValDecimal: Decimal;
    begin
        if not FindAttributeValue(ItemAttributeValue) then begin
          ItemAttributeValue."Attribute ID" := "Attribute ID";
          if IsNotBlankDecimal(Value) then begin
            Evaluate(ValDecimal,Value);
            ItemAttributeValue.Validate(Value,Format(ValDecimal));
          end else
            ItemAttributeValue.Value := Value;
          ItemAttributeValue.Insert;
        end;
        TempItemAttributeValueToInsert.TransferFields(ItemAttributeValue);
        TempItemAttributeValueToInsert.Insert;
        exit(ItemAttributeValue.ID);
    end;

    [Scope('Personalization')]
    procedure IsNotBlankDecimal(TextValue: Text[250]): Boolean
    var
        ItemAttribute: Record "Item Attribute";
    begin
        if TextValue = '' then
          exit(false);
        ItemAttribute.Get("Attribute ID");
        exit(ItemAttribute.Type = ItemAttribute.Type::Decimal);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeFindItemAttributeCaseInsensitive(var ItemAttribute: Record "Item Attribute";var ItemAttributeValueSelection: Record "Item Attribute Value Selection")
    begin
    end;
}
