page 107 "Date Compr. Registers"
{
    // version NAVW113.00

    ApplicationArea = Suite;
    Caption = 'Date Compr. Registers';
    Editable = false;
    PageType = List;
    SourceTable = "Date Compr. Register";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("No.";"No.")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                }
                field("Creation Date";"Creation Date")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the date that the date compression took place.';
                }
                field("Table ID";"Table ID")
                {
                    ApplicationArea = Suite;
                    LookupPageID = Objects;
                    ToolTip = 'Specifies the number of the table that was compressed.';
                }
                field("Table Caption";"Table Caption")
                {
                    ApplicationArea = Suite;
                    DrillDown = false;
                    DrillDownPageID = Objects;
                    ToolTip = 'Specifies the name of the table that was compressed.';
                }
                field("Starting Date";"Starting Date")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the first date in the period for which entries were compressed.';
                }
                field("Ending Date";"Ending Date")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the last date in the period for which entries were compressed.';
                }
                field("Register No.";"Register No.")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the number of the register that was created by the date compression and that contains the compressed entries.';
                }
                field("No. of New Records";"No. of New Records")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the number of new entries that were created by the date compression.';
                }
                field("No. Records Deleted";"No. Records Deleted")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the number of entries that were deleted during the date compression.';
                }
                field("Filter";Filter)
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the filters that were placed on the date compression.';
                }
                field("Period Length";"Period Length")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the time interval of entries combined into one for the period defined in the Starting Date and Ending Date fields in the batch job.';
                }
                field("Retain Field Contents";"Retain Field Contents")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies a list of the fields whose contents the user chose to retain in the date compression.';
                }
                field("Retain Totals";"Retain Totals")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies a list of the quantity fields that the user chose to retain when they ran the date compression batch job.';
                }
                field("User ID";"User ID")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the ID of the user who posted the entry, to be used, for example, in the change log.';
                    Visible = false;
                }
                field("Source Code";"Source Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the source code that specifies where the entry was created.';
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
    }
}

