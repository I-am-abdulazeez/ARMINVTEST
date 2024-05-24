page 5068 "Industry Group Contacts"
{
    // version NAVW110.0

    Caption = 'Industry Group Contacts';
    DataCaptionFields = "Industry Group Code";
    PageType = List;
    SourceTable = "Contact Industry Group";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Contact No.";"Contact No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the contact company you are assigning industry groups.';
                }
                field("Contact Name";"Contact Name")
                {
                    ApplicationArea = RelationshipMgmt;
                    DrillDown = false;
                    ToolTip = 'Specifies the name of the contact company you are assigning an industry group.';
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
    }
}

