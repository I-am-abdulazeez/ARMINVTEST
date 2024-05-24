page 50256 "MFP Lines"
{
    // version MFD-1.0

    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "MF Payment Lines";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Account No";"Account No")
                {
                }
                field("Client ID";"Client ID")
                {
                }
                field("Client Name";"Client Name")
                {
                }
                field("Fund Code";"Fund Code")
                {
                }
                field("Dividend Mandate";"Dividend Mandate")
                {
                }
                field("Bank Code";"Bank Code")
                {
                }
                field("Bank Branch";"Bank Branch")
                {
                }
                field("Bank Account";"Bank Account")
                {
                }
                field("Dividend Amount";"Dividend Amount")
                {
                }
                field(Split;Split)
                {
                }
                field("Tax Rate";"Tax Rate")
                {
                }
                field("Tax Amount";"Tax Amount")
                {
                }
                field("Total Dividend Earned";"Total Dividend Earned")
                {
                }
                field("Split to Account";"Split to Account")
                {
                }
                field("OLD Account No";"OLD Account No")
                {
                }
                field("OLD Membership No";"OLD Membership No")
                {
                }
            }
        }
    }

    actions
    {
    }
}

