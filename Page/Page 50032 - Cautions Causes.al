page 50032 "Cautions Causes"
{
    PageType = List;
    SourceTable = "Caution Types";
    SourceTableView = WHERE(Type=CONST(Cause));

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
        Type:=Type::Cause;
    end;
}

