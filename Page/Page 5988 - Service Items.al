page 5988 "Service Items"
{
    // version NAVW113.00

    Caption = 'Service Items';
    CardPageID = "Service Item Card";
    DataCaptionExpression = GetCaption;
    Editable = false;
    PageType = List;
    SourceTable = "Service Item";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                Editable = false;
                ShowCaption = false;
                field("No.";"No.")
                {
                    ApplicationArea = Service;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Service;
                    ToolTip = 'Specifies a description of this item.';
                }
                field("Item No.";"Item No.")
                {
                    ApplicationArea = Service;
                    ToolTip = 'Specifies the item number linked to the service item.';
                }
                field("Serial No.";"Serial No.")
                {
                    ApplicationArea = ItemTracking;
                    ToolTip = 'Specifies the serial number of this item.';
                }
                field("Customer No.";"Customer No.")
                {
                    ApplicationArea = Service;
                    ToolTip = 'Specifies the number of the customer who owns this item.';
                }
                field("Ship-to Code";"Ship-to Code")
                {
                    ApplicationArea = Service;
                    ToolTip = 'Specifies a code for an alternate shipment address if you want to ship to another address than the one that has been entered automatically. This field is also used in case of drop shipment.';
                }
                field("Warranty Starting Date (Parts)";"Warranty Starting Date (Parts)")
                {
                    ApplicationArea = Service;
                    ToolTip = 'Specifies the starting date of the spare parts warranty for this item.';
                }
                field("Warranty Ending Date (Parts)";"Warranty Ending Date (Parts)")
                {
                    ApplicationArea = Service;
                    ToolTip = 'Specifies the ending date of the spare parts warranty for this item.';
                }
                field("Warranty Starting Date (Labor)";"Warranty Starting Date (Labor)")
                {
                    ApplicationArea = Service;
                    ToolTip = 'Specifies the starting date of the labor warranty for this item.';
                }
                field("Warranty Ending Date (Labor)";"Warranty Ending Date (Labor)")
                {
                    ApplicationArea = Service;
                    ToolTip = 'Specifies the ending date of the labor warranty for this item.';
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
            group("&Serv. Item")
            {
                Caption = '&Serv. Item';
                Image = ServiceItem;
                action("Co&mments")
                {
                    ApplicationArea = Comments;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Service Comment Sheet";
                    RunPageLink = "Table Name"=CONST("Service Item"),
                                  "Table Subtype"=CONST("0"),
                                  "No."=FIELD("No.");
                    ToolTip = 'View or add comments for the record.';
                }
                action("Service Ledger E&ntries")
                {
                    ApplicationArea = Service;
                    Caption = 'Service Ledger E&ntries';
                    Image = ServiceLedger;
                    RunObject = Page "Service Ledger Entries";
                    RunPageLink = "Service Item No. (Serviced)"=FIELD("No."),
                                  "Service Order No."=FIELD("Service Order Filter"),
                                  "Service Contract No."=FIELD("Contract Filter"),
                                  "Posting Date"=FIELD("Date Filter");
                    RunPageView = SORTING("Service Item No. (Serviced)","Entry Type","Moved from Prepaid Acc.",Type,"Posting Date");
                    ShortCutKey = 'Ctrl+F7';
                    ToolTip = 'View all the ledger entries for the service item or service order that result from posting transactions in service documents.';
                }
                action("&Warranty Ledger Entries")
                {
                    ApplicationArea = Service;
                    Caption = '&Warranty Ledger Entries';
                    Image = WarrantyLedger;
                    RunObject = Page "Warranty Ledger Entries";
                    RunPageLink = "Service Item No. (Serviced)"=FIELD("No.");
                    RunPageView = SORTING("Service Item No. (Serviced)","Posting Date","Document No.");
                    ToolTip = 'View all the ledger entries for the service item or service order that result from posting transactions in service documents that contain warranty agreements.';
                }
                action(Statistics)
                {
                    ApplicationArea = Service;
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Service Item Statistics";
                    RunPageLink = "No."=FIELD("No.");
                    ShortCutKey = 'F7';
                    ToolTip = 'View statistical information, such as the value of posted entries, for the record.';
                }
                action("&Trendscape")
                {
                    ApplicationArea = Service;
                    Caption = '&Trendscape';
                    Image = Trendscape;
                    RunObject = Page "Service Item Trendscape";
                    RunPageLink = "No."=FIELD("No.");
                    ToolTip = 'View a scrollable summary of service ledger entries that are related to a specific service item. This summary is generated for a specific time period.';
                }
                action("L&og")
                {
                    ApplicationArea = Service;
                    Caption = 'L&og';
                    Image = Approve;
                    RunObject = Page "Service Item Log";
                    RunPageLink = "Service Item No."=FIELD("No.");
                    ToolTip = 'View the list of the service item changes that have been logged, for example, when the warranty has changed or a component has been added. This window displays the field that was changed, the old value and the new value, and the date and time that the field was changed.';
                }
                action("Com&ponents")
                {
                    ApplicationArea = Service;
                    Caption = 'Com&ponents';
                    Image = Components;
                    RunObject = Page "Service Item Component List";
                    RunPageLink = Active=CONST(true),
                                  "Parent Service Item No."=FIELD("No.");
                    RunPageView = SORTING(Active,"Parent Service Item No.","Line No.");
                    ToolTip = 'View the list of components in the service item.';
                }
                separator(Separator38)
                {
                }
                group("Trou&bleshooting  Setup")
                {
                    Caption = 'Trou&bleshooting  Setup';
                    Image = Troubleshoot;
                    action(ServiceItemGroup)
                    {
                        ApplicationArea = Service;
                        Caption = 'Service Item Group';
                        Image = ServiceItemGroup;
                        RunObject = Page "Troubleshooting Setup";
                        RunPageLink = Type=CONST("Service Item Group"),
                                      "No."=FIELD("Service Item Group Code");
                        ToolTip = 'View or edit groupings of service items.';
                    }
                    action(ServiceItem)
                    {
                        ApplicationArea = Service;
                        Caption = 'Service Item';
                        Image = "Report";
                        RunObject = Page "Troubleshooting Setup";
                        RunPageLink = Type=CONST("Service Item"),
                                      "No."=FIELD("No.");
                        ToolTip = 'Create a new service item.';
                    }
                    action(Item)
                    {
                        ApplicationArea = Service;
                        Caption = 'Item';
                        Image = Item;
                        RunObject = Page "Troubleshooting Setup";
                        RunPageLink = Type=CONST(Item),
                                      "No."=FIELD("Item No.");
                        ToolTip = 'View and edit detailed information for the item.';
                    }
                }
            }
        }
    }

    var
        Text000: Label '%1 %2', Comment='%1=Cust."No."  %2=Cust.Name';
        Text001: Label '%1 %2', Comment='%1 = Item no, %2 = Item description';

    local procedure GetCaption(): Text[80]
    var
        Cust: Record Customer;
        Item: Record Item;
    begin
        case true of
          GetFilter("Customer No.") <> '':
            begin
              if Cust.Get(GetRangeMin("Customer No.")) then
                exit(StrSubstNo(Text000,Cust."No.",Cust.Name));
              exit(StrSubstNo('%1 %2',GetRangeMin("Customer No.")));
            end;
          GetFilter("Item No.") <> '':
            begin
              if Item.Get(GetRangeMin("Item No.")) then
                exit(StrSubstNo(Text001,Item."No.",Item.Description));
              exit(StrSubstNo('%1 %2',GetRangeMin("Item No.")));
            end;
          else
            exit('');
        end;
    end;
}

