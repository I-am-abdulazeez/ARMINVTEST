page 50275 "Audit Subscription Reversal"
{
    CardPageID = "Posted Subscription Card";
    PageType = List;
    SourceTable = "Posted Subscription";
    SourceTableView = WHERE("Reversal Status"=FILTER("Pending Reversal"));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
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

