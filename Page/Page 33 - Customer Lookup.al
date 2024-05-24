page 33 "Customer Lookup"
{
    // version NAVW113.03

    ApplicationArea = Basic,Suite,Service;
    Caption = 'Customer Lookup';
    CardPageID = "Customer Card";
    Editable = false;
    PageType = List;
    SourceTable = Customer;
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
                field(Name;Name)
                {
                    ApplicationArea = All;
                }
                field(Address;Address)
                {
                    ApplicationArea = All;
                }
                field(City;City)
                {
                    ApplicationArea = All;
                }
                field("Post Code";"Post Code")
                {
                    ApplicationArea = All;
                }
                field("Phone No.";"Phone No.")
                {
                    ApplicationArea = All;
                }
                field(Contact;Contact)
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
            action(CustomerList)
            {
                ApplicationArea = All;
                Caption = 'Advanced View';
                Image = CustomerList;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                var
                    CustomerList: Page "Customer List";
                begin
                    CustomerList.SetTableView(Rec);
                    CustomerList.SetRecord(Rec);
                    CustomerList.LookupMode := true;
                    if CustomerList.RunModal = ACTION::LookupOK then
                      CustomerList.GetRecord(Rec);
                    CurrPage.Close;
                end;
            }
        }
    }
}

