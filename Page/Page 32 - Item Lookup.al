page 32 "Item Lookup"
{
    // version NAVW113.03

    ApplicationArea = All;
    Caption = 'Items';
    CardPageID = "Item Card";
    Editable = false;
    PageType = List;
    SourceTable = Item;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No.";"No.")
                {
                    ApplicationArea = All;
                }
                field(Description;Description)
                {
                    ApplicationArea = All;
                }
                field("Base Unit of Measure";"Base Unit of Measure")
                {
                    ApplicationArea = All;
                }
                field("Unit Price";"Unit Price")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action(ItemList)
            {
                ApplicationArea = All;
                Caption = 'Advanced View';
                Image = CustomerList;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                var
                    ItemList: Page "Item List";
                begin
                    ItemList.SetTableView(Rec);
                    ItemList.SetRecord(Rec);
                    ItemList.LookupMode := true;
                    if ItemList.RunModal = ACTION::LookupOK then
                      ItemList.GetRecord(Rec);
                    CurrPage.Close;
                end;
            }
        }
    }
}

