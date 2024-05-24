page 858 "Cash Flow Comment List"
{
    // version NAVW113.00

    Caption = 'Cash Flow Comment List';
    Editable = false;
    PageType = List;
    SourceTable = "Cash Flow Account Comment";

    layout
    {
        area(content)
        {
            repeater(Control1000)
            {
                ShowCaption = false;
                field("No.";"No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                }
                field(Date;Date)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the date of the cash flow comment.';
                }
                field(Comment;Comment)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the comment for the record.';
                }
                field("Code";Code)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the code of the record.';
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }
}

