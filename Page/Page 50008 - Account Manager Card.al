page 50008 "Account Manager Card"
{
    PageType = Card;
    SourceTable = "Account Manager";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Agent Code";"Agent Code")
                {
                }
                field("First Name";"First Name")
                {
                    ShowMandatory = true;
                }
                field(Surname;Surname)
                {
                    ShowMandatory = true;
                }
                field("Middle Name";"Middle Name")
                {
                }
                field("Is RM";"Is RM")
                {
                }
                field("RM Code";"RM Code")
                {
                }
                field("RM Name";"RM Name")
                {
                }
                field("Email Address";"Email Address")
                {
                    ShowMandatory = true;
                }
                field("Investment Center";"Investment Center")
                {
                }
                field("No of Agents Managed";"No of Agents Managed")
                {
                }
                field("No of Clients Managed";"No of Clients Managed")
                {
                }
                field("Commission Structure";"Commission Structure")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(History)
            {
                Image = History;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Account Manager History";
                RunPageLink = "Account Manager"=FIELD("Agent Code");
            }
        }
    }
}

