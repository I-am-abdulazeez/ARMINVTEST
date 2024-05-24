page 50093 "Daily Income distrib Lines"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Daily Income Distrib Lines";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Value Date";"Value Date")
                {
                }
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
                field("No of Units";"No of Units")
                {
                    DecimalPlaces = 4:4;
                }
                field("Income Per unit";"Income Per unit")
                {
                    DecimalPlaces = 4:12;
                }
                field("Income accrued";"Income accrued")
                {
                    DecimalPlaces = 4:4;
                }
                field("Fully Paid";"Fully Paid")
                {
                }
                field("Payment Mode";"Payment Mode")
                {
                }
                field("Payment Date";"Payment Date")
                {
                }
                field("Transaction No";"Transaction No")
                {
                }
                field(Transferred;Transferred)
                {
                }
                field("Transferred from account";"Transferred from account")
                {
                }
                field("Transfer Ref no";"Transfer Ref no")
                {
                }
            }
        }
    }

    actions
    {
    }
}

