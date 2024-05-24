query 135 "OCR Vendor Bank Accounts"
{
    // version NAVW113.00

    Caption = 'OCR Vendor Bank Accounts';

    elements
    {
        dataitem(Vendor_Bank_Account;"Vendor Bank Account")
        {
            DataItemTableFilter = "Bank Account No."=FILTER(<>'');
            column(Name;Name)
            {
            }
            column(Bank_Branch_No;"Bank Branch No.")
            {
            }
            column(Bank_Account_No;"Bank Account No.")
            {
            }
            dataitem(Vendor;Vendor)
            {
                DataItemLink = "No."=Vendor_Bank_Account."Vendor No.";
                SqlJoinType = InnerJoin;
                column(Id;Id)
                {
                }
                column(No;"No.")
                {
                }
                dataitem(Integration_Record;"Integration Record")
                {
                    DataItemLink = "Integration ID"=Vendor.Id;
                    SqlJoinType = InnerJoin;
                    DataItemTableFilter = "Table ID"=CONST(23);
                    column(Modified_On;"Modified On")
                    {
                    }
                }
            }
        }
    }
}

