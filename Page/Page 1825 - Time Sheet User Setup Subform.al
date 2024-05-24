page 1825 "Time Sheet User Setup Subform"
{
    // version NAVW111.00

    Caption = 'Time Sheet User Setup Subform';
    PageType = ListPart;
    SourceTable = "User Setup";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("User ID";"User ID")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the ID of the user who posted the entry, to be used, for example, in the change log.';
                }
                field("Register Time";"Register Time")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies if you want to register time for this user. This is based on the time spent from when the user logs in to when the user logs out.';
                }
                field("Time Sheet Admin.";"Time Sheet Admin.")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Time Sheet Administrator';
                    ToolTip = 'Specifies if the user can edit, change, and delete time sheets.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        HideExternalUsers;
    end;
}
