codeunit 1503 "Workflow Record Management"
{
    // version NAVW111.00

    SingleInstance = true;

    trigger OnRun()
    begin
    end;

    var
        VarArray: array [100] of Variant;
        NotSupportedTypeErr: Label 'The type is not supported.';
        NotEnoughSpaceErr: Label 'There is not enough space to save the record.';

    [Scope('Personalization')]
    procedure BackupRecord(Variant: Variant) Idx: Integer
    var
        VariantArrayElem: Variant;
    begin
        if not Variant.IsRecord then
          Error(NotSupportedTypeErr);

        for Idx := 1 to ArrayLen(VarArray) do begin
          VariantArrayElem := VarArray[Idx];
          if not VariantArrayElem.IsRecord then begin
            VarArray[Idx] := Variant;
            exit(Idx);
          end;
        end;

        Error(NotEnoughSpaceErr);
    end;

    [Scope('Personalization')]
    procedure RestoreRecord(Index: Integer;var Variant: Variant)
    begin
        Variant := VarArray[Index];
        Clear(VarArray[Index]);
    end;
}

