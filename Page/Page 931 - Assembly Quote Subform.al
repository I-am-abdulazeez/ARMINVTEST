page 931 "Assembly Quote Subform"
{
    // version NAVW113.00

    AutoSplitKey = true;
    Caption = 'Lines';
    DelayedInsert = true;
    PageType = ListPart;
    PopulateAllFields = true;
    SourceTable = "Assembly Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Avail. Warning";"Avail. Warning")
                {
                    ApplicationArea = Assembly;
                    BlankZero = true;
                    DrillDown = true;
                    ToolTip = 'Specifies Yes if the assembly component is not available in the quantity and on the due date of the assembly order line.';

                    trigger OnDrillDown()
                    begin
                        ShowAvailabilityWarning;
                    end;
                }
                field(Type;Type)
                {
                    ApplicationArea = Assembly;
                    ToolTip = 'Specifies if the assembly order line is of type Item or Resource.';
                }
                field("No.";"No.")
                {
                    ApplicationArea = Assembly;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Assembly;
                    ToolTip = 'Specifies the description of the assembly component.';
                }
                field("Description 2";"Description 2")
                {
                    ApplicationArea = Assembly;
                    ToolTip = 'Specifies the second description of the assembly component.';
                    Visible = false;
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Planning;
                    ToolTip = 'Specifies the variant of the item on the line.';
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Location;
                    ToolTip = 'Specifies the location from which you want to post consumption of the assembly component.';
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Assembly;
                    ToolTip = 'Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.';
                }
                field("Quantity per";"Quantity per")
                {
                    ApplicationArea = Assembly;
                    ToolTip = 'Specifies how many units of the assembly component are required to assemble one assembly item.';
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Assembly;
                    ToolTip = 'Specifies how many units of the assembly component are expected to be consumed.';
                }
                field("Due Date";"Due Date")
                {
                    ApplicationArea = Assembly;
                    ToolTip = 'Specifies the date when the assembly component must be available for consumption by the assembly order.';
                    Visible = false;
                }
                field("Lead-Time Offset";"Lead-Time Offset")
                {
                    ApplicationArea = Assembly;
                    ToolTip = 'Specifies the lead-time offset that is defined for the assembly component on the assembly BOM.';
                    Visible = false;
                }
                field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Dimensions;
                    ToolTip = 'Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Dimensions;
                    ToolTip = 'Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                    Visible = false;
                }
                field("Bin Code";"Bin Code")
                {
                    ApplicationArea = Warehouse;
                    ToolTip = 'Specifies the code of the bin where assembly components must be placed prior to assembly and from where they are posted as consumed.';
                    Visible = false;
                }
                field("Inventory Posting Group";"Inventory Posting Group")
                {
                    ApplicationArea = Assembly;
                    ToolTip = 'Specifies links between business transactions made for the item and an inventory account in the general ledger, to group amounts for that item type.';
                    Visible = false;
                }
                field("Unit Cost";"Unit Cost")
                {
                    ApplicationArea = Assembly;
                    ToolTip = 'Specifies the cost of one unit of the item or resource on the line.';
                }
                field("Cost Amount";"Cost Amount")
                {
                    ApplicationArea = Assembly;
                    ToolTip = 'Specifies the cost of the assembly order line.';
                }
                field("Qty. per Unit of Measure";"Qty. per Unit of Measure")
                {
                    ApplicationArea = Assembly;
                    ToolTip = 'Specifies the quantity per unit of measure of the component item on the assembly order line.';
                }
                field("Resource Usage Type";"Resource Usage Type")
                {
                    ApplicationArea = Assembly;
                    ToolTip = 'Specifies how the cost of the resource on the assembly order line is allocated to the assembly item.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
                group("Item Availability by")
                {
                    Caption = 'Item Availability by';
                    Image = ItemAvailability;
                    action("Event")
                    {
                        ApplicationArea = Assembly;
                        Caption = 'Event';
                        Image = "Event";
                        ToolTip = 'View how the actual and the projected available balance of an item will develop over time according to supply and demand events.';

                        trigger OnAction()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromAsmLine(Rec,ItemAvailFormsMgt.ByEvent);
                        end;
                    }
                    action(Period)
                    {
                        ApplicationArea = Assembly;
                        Caption = 'Period';
                        Image = Period;
                        ToolTip = 'View the projected quantity of the item over time according to time periods, such as day, week, or month.';

                        trigger OnAction()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromAsmLine(Rec,ItemAvailFormsMgt.ByPeriod);
                        end;
                    }
                    action(Variant)
                    {
                        ApplicationArea = Planning;
                        Caption = 'Variant';
                        Image = ItemVariant;
                        ToolTip = 'View or edit the item''s variants. Instead of setting up each color of an item as a separate item, you can set up the various colors as variants of the item.';

                        trigger OnAction()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromAsmLine(Rec,ItemAvailFormsMgt.ByVariant);
                        end;
                    }
                    action(Location)
                    {
                        AccessByPermission = TableData Location=R;
                        ApplicationArea = Location;
                        Caption = 'Location';
                        Image = Warehouse;
                        ToolTip = 'View the actual and projected quantity of the item per location.';

                        trigger OnAction()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromAsmLine(Rec,ItemAvailFormsMgt.ByLocation);
                        end;
                    }
                    action("BOM Level")
                    {
                        ApplicationArea = Assembly;
                        Caption = 'BOM Level';
                        Image = BOMLevel;
                        ToolTip = 'View availability figures for items on bills of materials that show how many units of a parent item you can make based on the availability of child items.';

                        trigger OnAction()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromAsmLine(Rec,ItemAvailFormsMgt.ByBOM);
                        end;
                    }
                }
                action("Show Warning")
                {
                    ApplicationArea = Assembly;
                    Caption = 'Show Warning';
                    Image = ShowWarning;
                    ToolTip = 'View details about availability issues.';

                    trigger OnAction()
                    begin
                        ShowAvailabilityWarning;
                    end;
                }
                action(Dimensions)
                {
                    AccessByPermission = TableData Dimension=R;
                    ApplicationArea = Dimensions;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';

                    trigger OnAction()
                    begin
                        ShowDimensions;
                    end;
                }
                action("Item Tracking Lines")
                {
                    ApplicationArea = ItemTracking;
                    Caption = 'Item &Tracking Lines';
                    Image = ItemTrackingLines;
                    ShortCutKey = 'Shift+Ctrl+I';
                    ToolTip = 'View or edit serial numbers and lot numbers that are assigned to the item on the document or journal line.';

                    trigger OnAction()
                    begin
                        OpenItemTrackingLines;
                    end;
                }
                action(Comments)
                {
                    ApplicationArea = Comments;
                    Caption = 'Comments';
                    Image = ViewComments;
                    RunObject = Page "Assembly Comment Sheet";
                    RunPageLink = "Document Type"=FIELD("Document Type"),
                                  "Document No."=FIELD("Document No."),
                                  "Document Line No."=FIELD("Line No.");
                    ToolTip = 'View or add comments for the record.';
                }
                action("Assembly BOM")
                {
                    ApplicationArea = Assembly;
                    Caption = 'Assembly BOM';
                    Image = AssemblyBOM;
                    ToolTip = 'View or edit the bill of material that specifies which items and resources are required to assemble the assembly item.';

                    trigger OnAction()
                    begin
                        ShowAssemblyList;
                    end;
                }
            }
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("Select Item Substitution")
                {
                    ApplicationArea = Assembly;
                    Caption = 'Select Item Substitution';
                    Image = SelectItemSubstitution;
                    ToolTip = 'Select another item that has been set up to be traded instead of the original item if it is unavailable.';

                    trigger OnAction()
                    begin
                        ShowItemSub;
                        CurrPage.Update;
                    end;
                }
                action("Explode BOM")
                {
                    ApplicationArea = Assembly;
                    Caption = 'Explode BOM';
                    Image = ExplodeBOM;
                    ToolTip = 'Insert new lines for the components on the bill of materials, for example to sell the parent item as a kit. CAUTION: The line for the parent item will be deleted and represented by a description only. To undo, you must delete the component lines and add a line the parent item again.';

                    trigger OnAction()
                    begin
                        ExplodeAssemblyList;
                        CurrPage.Update;
                    end;
                }
            }
        }
    }

    var
        ItemAvailFormsMgt: Codeunit "Item Availability Forms Mgt";
}

