page 224 "Res. Capacity Entries"
{
    // version NAVW113.00

    ApplicationArea = Jobs;
    Caption = 'Resource Capacity Entries';
    DataCaptionFields = "Resource No.","Resource Group No.";
    Editable = false;
    PageType = List;
    SourceTable = "Res. Capacity Entry";
    UsageCategory = History;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field(Date;Date)
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the date for which the capacity entry is valid.';
                }
                field("Resource No.";"Resource No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the number of the corresponding resource.';
                }
                field("Resource Group No.";"Resource Group No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the number of the corresponding resource group assigned to the resource.';
                }
                field(Capacity;Capacity)
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the capacity that is calculated and recorded. The capacity is in the unit of measure.';
                }
                field("Entry No.";"Entry No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the number of the entry, as assigned from the specified number series when the entry was created.';
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
