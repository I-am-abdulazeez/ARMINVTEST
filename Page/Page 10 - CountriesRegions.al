page 10 "Countries/Regions"
{
    // version NAVW113.00

    ApplicationArea = Basic,Suite;
    Caption = 'Countries';
    PageType = List;
    SourceTable = "Country/Region";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Code";Code)
                {
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic,Suite,Invoicing;
                    ToolTip = 'Specifies the country/region of the address.';
                }
            }
        }
        area(factboxes)
        {
            part(Control8;"Custom Address Format Factbox")
            {
                ApplicationArea = Basic,Suite;
                SubPageLink = "Country/Region Code"=FIELD(Code);
                Visible = "Address Format" = "Address Format"::Custom;
            }
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
            group("&Country/Region")
            {
                Caption = '&Country/Region';
                Image = CountryRegion;
                action("VAT Reg. No. Formats")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'VAT Reg. No. Formats';
                    Image = NumberSetup;
                    RunObject = Page "VAT Registration No. Formats";
                    RunPageLink = "Country/Region Code"=FIELD(Code);
                    ToolTip = 'Specify that the tax registration number for an account, such as a customer, corresponds to the standard format for tax registration numbers in an account''s country/region.';
                }
                action(CustomAddressFormat)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Custom Address Format';
                    Enabled = "Address Format" = "Address Format"::Custom;
                    Image = Addresses;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Define the scope and order of fields that make up the country/region address.';

                    trigger OnAction()
                    var
                        CustomAddressFormat: Record "Custom Address Format";
                        CustomAddressFormatPage: Page "Custom Address Format";
                    begin
                        if "Address Format" <> "Address Format"::Custom then
                          exit;

                        CustomAddressFormat.FilterGroup(2);
                        CustomAddressFormat.SetRange("Country/Region Code",Code);
                        CustomAddressFormat.FilterGroup(0);

                        Clear(CustomAddressFormatPage);
                        CustomAddressFormatPage.SetTableView(CustomAddressFormat);
                        CustomAddressFormatPage.RunModal;
                    end;
                }
            }
        }
    }
}

