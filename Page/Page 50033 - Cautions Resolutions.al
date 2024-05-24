page 50033 "Cautions Resolutions"
{
    PageType = List;
    SourceTable = "Caution Types";
    SourceTableView = WHERE(Type=CONST(Resolution));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code";Code)
                {
                }
                field(Description;Description)
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Type:=Type::Resolution;
    end;
}

