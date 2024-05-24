page 50031 Cautions
{
    PageType = List;
    SourceTable = "Caution Types";
    SourceTableView = WHERE(Type=CONST(Caution));

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
                field("Restriction Type";"Restriction Type")
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
        Type:=Type::Caution;
    end;
}

