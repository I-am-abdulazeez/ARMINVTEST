page 5992 "Troubleshooting Subform"
{
    // version NAVW113.00

    AutoSplitKey = true;
    Caption = 'Lines';
    LinksAllowed = false;
    PageType = ListPart;
    SourceTable = "Troubleshooting Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field(Comment;Comment)
                {
                    ApplicationArea = Comments;
                    ToolTip = 'Specifies the troubleshooting comment or guidelines.';
                }
            }
        }
    }

    actions
    {
    }
}
