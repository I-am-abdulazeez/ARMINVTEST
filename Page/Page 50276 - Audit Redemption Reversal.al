page 50276 "Audit Redemption Reversal"
{
    CardPageID = "Posted Redemption Card";
    PageType = List;
    SourceTable = "Posted Redemption";
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
                field("Fee Units";"Fee Units")
                {
                }
                field("Fee Amount";"Fee Amount")
                {
                }
                field("Net Amount Payable";"Net Amount Payable")
                {
                }
                field("Treasury Batch";"Treasury Batch")
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
                field("Bank Code";"Bank Code")
                {
                }
                field("Bank Account No";"Bank Account No")
                {
                }
                field("Bank Account Name";"Bank Account Name")
                {
                }
                field("Unit Balance after Redmption";"Unit Balance after Redmption")
                {
                }
                field("Current Unit Balance";"Current Unit Balance")
                {
                }
                field("OLD Account No";"OLD Account No")
                {
                }
            }
        }
    }

    actions
    {
    }
}

