page 50020 "Fund Bank Accounts"
{
    PageType = List;
    SourceTable = "Fund Bank Accounts";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Fund Code";"Fund Code")
                {
                    Editable = false;
                }
                field("Bank Account No";"Bank Account No")
                {
                }
                field("Bank Code";"Bank Code")
                {
                }
                field("Bank Branch Code";"Bank Branch Code")
                {
                }
                field("Bank Account Name";"Bank Account Name")
                {
                }
                field("Transaction Type";"Transaction Type")
                {
                }
                field(Default;Default)
                {
                }
            }
        }
    }

    actions
    {
    }
}

