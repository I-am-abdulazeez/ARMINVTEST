page 7368 "Bin Creation Wksh. Templ. List"
{
    // version NAVW111.00

    Caption = 'Bin Creation Wksh. Templ. List';
    Editable = false;
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = "Bin Creation Wksh. Template";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field(Name;Name)
                {
                    ApplicationArea = Warehouse;
                    ToolTip = 'Specifies the name of the bin creation worksheet template you are creating.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Warehouse;
                    ToolTip = 'Specifies a description of the warehouse worksheet template you are creating.';
                }
                field("Page ID";"Page ID")
                {
                    ApplicationArea = Warehouse;
                    LookupPageID = Objects;
                    ToolTip = 'Specifies the number of the page that is used to show the journal or worksheet that uses the template.';
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207;Links)
            {
                Visible = false;
            }
            systempart(Control1905767507;Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Te&mplate")
            {
                Caption = 'Te&mplate';
                Image = Template;
                action(Names)
                {
                    ApplicationArea = Warehouse;
                    Caption = 'Names';
                    Image = Description;
                    RunObject = Page "Bin Creation Wksh. Names";
                    RunPageLink = "Worksheet Template Name"=FIELD(Name);
                    ToolTip = 'View the list of available template names.';
                }
            }
        }
    }
}

