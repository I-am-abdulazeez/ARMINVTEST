page 50233 "Reversed Subscriptions"
{
    // version Rev-1.0

    CardPageID = "Posted Subscription Card";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Posted Subscription";
    SourceTableView = WHERE("Subscription Status"=CONST(Posted),
                            Reversed=CONST(true));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Select;Select)
                {
                }
                field(No;No)
                {
                    Editable = false;
                }
                field("Account No";"Account No")
                {
                    Editable = false;
                }
                field("Value Date";"Value Date")
                {
                    Editable = false;
                }
                field("Fund Code";"Fund Code")
                {
                    Editable = false;
                }
                field("Client ID";"Client ID")
                {
                    Editable = false;
                }
                field(Amount;Amount)
                {
                    Editable = false;
                }
                field("No. Of Units";"No. Of Units")
                {
                    Editable = false;
                }
                field("Bank Code";"Bank Code")
                {
                }
                field("Reference Code";"Reference Code")
                {
                }
                field(Remarks;Remarks)
                {
                }
                field("Payment Mode";"Payment Mode")
                {
                }
                field("Received From";"Received From")
                {
                    Editable = false;
                }
                field("Client Name";"Client Name")
                {
                }
                field("OLD Account No";"OLD Account No")
                {
                }
                field("Bank Narration";"Bank Narration")
                {
                }
            }
        }
    }

    actions
    {
    }
}

