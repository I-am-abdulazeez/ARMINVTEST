page 99000834 "Prod. Order Rtng Qlty Meas."
{
    // version NAVW111.00

    AutoSplitKey = true;
    Caption = 'Prod. Order Rtng Qlty Meas.';
    DataCaptionExpression = Caption;
    MultipleNewLines = true;
    PageType = List;
    SourceTable = "Prod. Order Rtng Qlty Meas.";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Qlty Measure Code";"Qlty Measure Code")
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies the quality measure code.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies a description of the quality measure.';
                }
                field("Min. Value";"Min. Value")
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies a minimum value, which is to be reached in the quality control.';
                }
                field("Max. Value";"Max. Value")
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies the maximum value, which may be reached in the quality control.';
                }
                field("Mean Tolerance";"Mean Tolerance")
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies the mean tolerance.';
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
