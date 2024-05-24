page 50218 "Treated Failed Redemption"
{
    CardPageID = "Posted Redemption Card";
    Editable = false;
    SourceTable = "Posted Redemption";
    SourceTableView = WHERE("Redemption Status"=CONST(Posted),
                            "Sent to Treasury"=CONST(true),
                            "Processed By Bank"=CONST(true),
                            "Bank Response Status"=CONST(Failed),
                            BoughtBack=CONST(true));

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
                field("Recon No";"Recon No")
                {
                }
                field("Account No";"Account No")
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
                field("Fund Sub Account";"Fund Sub Account")
                {
                    Editable = false;
                }
                field("Value Date";"Value Date")
                {
                    Editable = false;
                }
                field("Transaction Date";"Transaction Date")
                {
                    Editable = false;
                }
                field("Agent Code";"Agent Code")
                {
                    Editable = false;
                }
                field(Amount;Amount)
                {
                    Editable = false;
                }
                field("Accrued Dividend Paid";"Accrued Dividend Paid")
                {
                }
                field("Total Amount Payable";"Total Amount Payable")
                {
                }
                field("Bank Account No";"Bank Account No")
                {
                }
                field("Bank Account Name";"Bank Account Name")
                {
                }
                field("Bank Code";"Bank Code")
                {
                }
                field(Remarks;Remarks)
                {
                    Editable = false;
                }
                field("Price Per Unit";"Price Per Unit")
                {
                    Editable = false;
                }
                field("No. Of Units";"No. Of Units")
                {
                    Editable = false;
                }
                field("Redemption Type";"Redemption Type")
                {
                }
                field(Reversed;Reversed)
                {
                }
                field("Date Sent to Treasury";"Date Sent to Treasury")
                {
                }
                field("Time Sent to Treasury";"Time Sent to Treasury")
                {
                }
                field("Treasury Batch";"Treasury Batch")
                {
                }
            }
        }
    }

    actions
    {
    }
}

