page 7325 "Warehouse Registers"
{
    // version NAVW113.00

    ApplicationArea = Warehouse;
    Caption = 'Warehouse Registers';
    Editable = false;
    PageType = List;
    SourceTable = "Warehouse Register";
    UsageCategory = History;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("No.";"No.")
                {
                    ApplicationArea = Warehouse;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                }
                field("From Entry No.";"From Entry No.")
                {
                    ApplicationArea = Warehouse;
                    ToolTip = 'Specifies the first item entry number in the register.';
                }
                field("To Entry No.";"To Entry No.")
                {
                    ApplicationArea = Warehouse;
                    ToolTip = 'Specifies the last warehouse entry number in the register.';
                }
                field("Creation Date";"Creation Date")
                {
                    ApplicationArea = Warehouse;
                    ToolTip = 'Specifies the date on which the entries in the register were posted.';
                }
                field("Source Code";"Source Code")
                {
                    ApplicationArea = Warehouse;
                    ToolTip = 'Specifies the source code that specifies where the entry was created.';
                }
                field("User ID";"User ID")
                {
                    ApplicationArea = Warehouse;
                    ToolTip = 'Specifies the ID of the user who posted the entry, to be used, for example, in the change log.';
                }
                field("Journal Batch Name";"Journal Batch Name")
                {
                    ApplicationArea = Warehouse;
                    ToolTip = 'Specifies the name of the journal batch, a personalized journal layout, that the entries were posted from.';
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
            group("&Register")
            {
                Caption = '&Register';
                Image = Register;
                action("&Warehouse Entries")
                {
                    ApplicationArea = Warehouse;
                    Caption = '&Warehouse Entries';
                    Image = BinLedger;
                    ShortCutKey = 'Ctrl+F7';
                    ToolTip = 'View the history of quantities that are registered for the item in warehouse activities. ';

                    trigger OnAction()
                    var
                        WhseEntry: Record "Warehouse Entry";
                    begin
                        WhseEntry.SetRange("Entry No.","From Entry No.","To Entry No.");
                        PAGE.Run(PAGE::"Warehouse Entries",WhseEntry);
                    end;
                }
            }
        }
        area(processing)
        {
            action("Delete Empty Registers")
            {
                ApplicationArea = All;
                Caption = 'Delete Empty Registers';
                Image = Delete;
                RunObject = Report "Delete Empty Whse. Registers";
                ToolTip = 'Find and delete empty warehouse registers.';
            }
        }
    }
}

