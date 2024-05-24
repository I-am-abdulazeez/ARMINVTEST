page 50015 Banks
{
    PageType = List;
    SourceTable = Bank;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("code";code)
                {
                }
                field(Name;Name)
                {
                }
                field(Address;Address)
                {
                }
                field(Email;Email)
                {
                }
                field("Phone Number";"Phone Number")
                {
                }
                field("Sort Code";"Sort Code")
                {
                }
                field("Swift Code";"Swift Code")
                {
                }
                field("CRM Code";"CRM Code")
                {
                }
                field(Fundware;Fundware)
                {
                }
                field(Nibbs;Nibbs)
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action(Branches)
            {
                Image = BankAccount;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Page "Bank Branches";
                RunPageLink = "Bank Code"=FIELD(code);
            }
        }
    }
}

