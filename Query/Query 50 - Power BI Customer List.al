query 50 "Power BI Customer List"
{
    // version NAVW111.00

    Caption = 'Power BI Customer List';

    elements
    {
        dataitem(Customer;Customer)
        {
            column(Customer_Name;Name)
            {
            }
            column(Customer_No;"No.")
            {
            }
            column(Credit_Limit;"Credit Limit (LCY)")
            {
            }
            column(Balance_Due;"Balance Due")
            {
            }
            dataitem(Detailed_Cust_Ledg_Entry;"Detailed Cust. Ledg. Entry")
            {
                DataItemLink = "Customer No."=Customer."No.";
                column(Posting_Date;"Posting Date")
                {
                }
                column(Cust_Ledger_Entry_No;"Cust. Ledger Entry No.")
                {
                }
                column(Amount;Amount)
                {
                }
                column(Amount_LCY;"Amount (LCY)")
                {
                }
                column(Transaction_No;"Transaction No.")
                {
                }
                column(Entry_No;"Entry No.")
                {
                }
            }
        }
    }
}

