page 50017 "Client Next of Kins"
{
    AutoSplitKey = true;
    PageType = ListPart;
    SourceTable = "Client Next of Kin";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("NOK Name";"NOK Name")
                {
                    Editable = false;
                    ShowMandatory = true;
                }
                field("NOK Relationship";"NOK Relationship")
                {
                    ShowMandatory = true;
                }
                field("NOK Title";"NOK Title")
                {
                }
                field("NOK First Name";"NOK First Name")
                {
                    ShowMandatory = true;
                }
                field("NOK Middle Name";"NOK Middle Name")
                {
                    ShowMandatory = true;
                }
                field("NOK Last Name";"NOK Last Name")
                {
                    ShowMandatory = true;
                }
                field("NOK Telephone No";"NOK Telephone No")
                {
                    ShowMandatory = true;
                }
                field("NOK Town";"NOK Town")
                {
                    ShowMandatory = true;
                }
                field("NOK State of Origin";"NOK State of Origin")
                {
                    ShowMandatory = true;
                }
                field("NOK Country";"NOK Country")
                {
                    ShowMandatory = true;
                }
                field("NOK Address";"NOK Address")
                {
                    ShowMandatory = true;
                }
                field("NOK Email";"NOK Email")
                {
                    ShowMandatory = true;
                }
                field("NOK Gender";"NOK Gender")
                {
                }
            }
        }
    }

    actions
    {
    }
}

