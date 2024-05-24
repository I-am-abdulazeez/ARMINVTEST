page 5057 "Contact Alt. Address List"
{
    // version NAVW113.00

    Caption = 'Contact Alt. Address List';
    CardPageID = "Contact Alt. Address Card";
    DataCaptionFields = "Contact No.","Code";
    Editable = false;
    PageType = List;
    SourceTable = "Contact Alt. Address";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Code";Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code for the alternate address.';
                }
                field("Company Name";"Company Name")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the name of the company for the alternate address.';
                }
                field("Company Name 2";"Company Name 2")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the additional part of the company name for the alternate address.';
                    Visible = false;
                }
                field(Address;Address)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the alternate address of the contact.';
                }
                field("Address 2";"Address 2")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies additional address information.';
                    Visible = false;
                }
                field(City;City)
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the city of the contact''s alternate address.';
                    Visible = false;
                }
                field("Post Code";"Post Code")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the postal code.';
                    Visible = false;
                }
                field(County;County)
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the county for the contact''s alternate address.';
                    Visible = false;
                }
                field("Country/Region Code";"Country/Region Code")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the country/region of the address.';
                    Visible = false;
                }
                field("Phone No.";"Phone No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the telephone number for the alternate address.';
                }
                field("Fax No.";"Fax No.")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the fax number for the alternate address.';
                    Visible = false;
                }
                field("E-Mail";"E-Mail")
                {
                    ApplicationArea = RelationshipMgmt;
                    ExtendedDatatype = EMail;
                    ToolTip = 'Specifies the e-mail address for the contact at the alternate address.';
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
        area(navigation)
        {
            group("&Alt. Contact Address")
            {
                Caption = '&Alt. Contact Address';
                action("Date Ranges")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Date Ranges';
                    Image = DateRange;
                    RunObject = Page "Alt. Addr. Date Ranges";
                    RunPageLink = "Contact No."=FIELD("Contact No."),
                                  "Contact Alt. Address Code"=FIELD(Code);
                    ToolTip = 'Specify date ranges that apply to the contact''s alternate address.';
                }
            }
        }
    }
}
