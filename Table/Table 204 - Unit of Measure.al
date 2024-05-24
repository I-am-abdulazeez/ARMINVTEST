table 204 "Unit of Measure"
{
    // version NAVW113.02

    Caption = 'Unit of Measure';
    DataCaptionFields = "Code",Description;
    DrillDownPageID = "Units of Measure";
    LookupPageID = "Units of Measure";

    fields
    {
        field(1;"Code";Code[10])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(2;Description;Text[10])
        {
            Caption = 'Description';
        }
        field(3;"International Standard Code";Code[10])
        {
            Caption = 'International Standard Code';
        }
        field(4;Symbol;Text[10])
        {
            Caption = 'Symbol';
        }
        field(5;"Last Modified Date Time";DateTime)
        {
            Caption = 'Last Modified Date Time';
            Editable = false;
        }
        field(8000;Id;Guid)
        {
            Caption = 'Id';
        }
    }

    keys
    {
        key(Key1;"Code")
        {
        }
        key(Key2;Description)
        {
        }
    }

    fieldgroups
    {
        fieldgroup(Brick;"Code",Description,"International Standard Code")
        {
        }
    }

    trigger OnDelete()
    begin
        UnitOfMeasureTranslation.SetRange(Code,Code);
        UnitOfMeasureTranslation.DeleteAll;
    end;

    trigger OnInsert()
    begin
        SetLastDateTimeModified;
    end;

    trigger OnModify()
    begin
        SetLastDateTimeModified;
    end;

    trigger OnRename()
    begin
        UpdateItemBaseUnitOfMeasure;
    end;

    var
        UnitOfMeasureTranslation: Record "Unit of Measure Translation";

    local procedure UpdateItemBaseUnitOfMeasure()
    var
        Item: Record Item;
    begin
        Item.SetCurrentKey("Base Unit of Measure");
        Item.SetRange("Base Unit of Measure",xRec.Code);
        if not Item.IsEmpty then
          Item.ModifyAll("Base Unit of Measure",Code,true);
    end;

    [Scope('Personalization')]
    procedure GetDescriptionInCurrentLanguage(): Text[10]
    var
        Language: Record Language;
        UnitOfMeasureTranslation: Record "Unit of Measure Translation";
    begin
        if UnitOfMeasureTranslation.Get(Code,Language.GetUserLanguage) then
          exit(UnitOfMeasureTranslation.Description);
        exit(Description);
    end;

    [Scope('Personalization')]
    procedure CreateListInCurrentLanguage(var TempUnitOfMeasure: Record "Unit of Measure" temporary)
    var
        UnitOfMeasure: Record "Unit of Measure";
    begin
        if UnitOfMeasure.FindSet then
          repeat
            TempUnitOfMeasure := UnitOfMeasure;
            TempUnitOfMeasure.Description := UnitOfMeasure.GetDescriptionInCurrentLanguage;
            TempUnitOfMeasure.Insert;
          until UnitOfMeasure.Next = 0;
    end;

    local procedure SetLastDateTimeModified()
    var
        DateFilterCalc: Codeunit "DateFilter-Calc";
    begin
        "Last Modified Date Time" := DateFilterCalc.ConvertToUtcDateTime(CurrentDateTime);
    end;
}

