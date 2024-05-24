page 50019 "Joint Account Holders"
{
    AutoSplitKey = true;
    PageType = ListPart;
    SourceTable = "Joint Account Holders";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Title;Title)
                {
                }
                field("First Name";"First Name")
                {
                }
                field("Middle Names";"Middle Names")
                {
                }
                field("Last Name";"Last Name")
                {
                }
                field("Date of Birth";"Date of Birth")
                {
                }
                field(Gender;Gender)
                {
                }
                field("State of Origin";"State of Origin")
                {
                    ShowMandatory = true;
                }
                field(Address1;Address1)
                {
                    ShowMandatory = true;
                }
                field(Address2;Address2)
                {
                    ShowMandatory = true;
                }
                field(State;State)
                {
                    ShowMandatory = true;
                }
                field(Phone;Phone)
                {
                    ShowMandatory = true;
                }
                field(Email;Email)
                {
                    ShowMandatory = true;
                }
                field("Main Holder";"Main Holder")
                {
                }
                field(Signatory;Signatory)
                {
                }
                field("Required Signatory";"Required Signatory")
                {
                }
            }
        }
    }

    actions
    {
    }
}

