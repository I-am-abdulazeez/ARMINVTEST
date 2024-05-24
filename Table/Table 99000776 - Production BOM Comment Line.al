table 99000776 "Production BOM Comment Line"
{
    // version NAVW111.00

    Caption = 'Production BOM Comment Line';
    DrillDownPageID = "Prod. BOM Comment List";
    LookupPageID = "Prod. BOM Comment List";

    fields
    {
        field(1;"Production BOM No.";Code[20])
        {
            Caption = 'Production BOM No.';
            NotBlank = true;
            TableRelation = "Production BOM Header";
        }
        field(2;"BOM Line No.";Integer)
        {
            Caption = 'BOM Line No.';
            NotBlank = true;
            TableRelation = "Production BOM Line"."Line No." WHERE ("Production BOM No."=FIELD("Production BOM No."));
        }
        field(3;"Line No.";Integer)
        {
            Caption = 'Line No.';
        }
        field(4;"Version Code";Code[20])
        {
            Caption = 'Version Code';
            TableRelation = "Production BOM Version"."Version Code" WHERE ("Production BOM No."=FIELD("Production BOM No."),
                                                                           "Version Code"=FIELD("Version Code"));
        }
        field(10;Date;Date)
        {
            Caption = 'Date';
        }
        field(12;Comment;Text[80])
        {
            Caption = 'Comment';
        }
        field(13;"Code";Code[10])
        {
            Caption = 'Code';
        }
    }

    keys
    {
        key(Key1;"Production BOM No.","BOM Line No.","Version Code","Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    [Scope('Personalization')]
    procedure SetUpNewLine()
    var
        ProdBOMComment: Record "Production BOM Comment Line";
    begin
        ProdBOMComment.SetRange("Production BOM No.","Production BOM No.");
        ProdBOMComment.SetRange("Version Code","Version Code");
        ProdBOMComment.SetRange("BOM Line No.","BOM Line No.");
        ProdBOMComment.SetRange(Date,WorkDate);
        if not ProdBOMComment.FindFirst then
          Date := WorkDate;
    end;

    [Scope('Personalization')]
    procedure Caption(): Text[100]
    var
        ProdBOMHeader: Record "Production BOM Header";
    begin
        if GetFilters = '' then
          exit('');

        if not ProdBOMHeader.Get("Production BOM No.") then
          exit('');

        exit(
          StrSubstNo('%1 %2 %3',
            "Production BOM No.",ProdBOMHeader.Description,"BOM Line No."));
    end;
}

