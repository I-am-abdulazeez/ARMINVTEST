page 9629 "Available Field Selection Page"
{
    // version NAVW111.00

    Caption = 'Select Field';
    Editable = false;
    PageType = List;
    SourceTable = "Field";

    layout
    {
        area(content)
        {
            repeater(Control2)
            {
                ShowCaption = false;
                field("Field Caption";"Field Caption")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Name';
                    ToolTip = 'Specifies the names of the available Windows languages.';
                }
            }
        }
    }

    actions
    {
    }
}
