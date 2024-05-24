page 34 "Vendor Lookup"
{
    // version NAVW113.03

    ApplicationArea = Basic,Suite,Service;
    Caption = 'Vendors';
    CardPageID = "Vendor Card";
    Editable = false;
    PageType = List;
    SourceTable = Vendor;
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
            action(VendorList)
            {
                ApplicationArea = All;
                Caption = 'Advanced View';
                Image = CustomerList;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                var
                    VendorList: Page "Vendor List";
                begin
                    VendorList.SetTableView(Rec);
                    VendorList.SetRecord(Rec);
                    VendorList.LookupMode := true;
                    if VendorList.RunModal = ACTION::LookupOK then
                      VendorList.GetRecord(Rec);
                    CurrPage.Close;
                end;
            }
        }
    }
}

