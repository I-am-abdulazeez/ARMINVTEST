page 50169 "Redemption Schedule"
{
    CardPageID = "Redemption Schedule Card";
    PageType = List;
    SourceTable = "Redemption Schedule Header";
    SourceTableView = WHERE("Redemption Status"=CONST(Received));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Schedule No";"Schedule No")
                {
                }
                field("Value Date";"Value Date")
                {
                }
                field("Transaction Date";"Transaction Date")
                {
                }
                field(Narration;Narration)
                {
                }
                field("Main Account";"Main Account")
                {
                }
                field("CLient ID";"CLient ID")
                {
                }
                field("Client Name";"Client Name")
                {
                }
                field("Total Amount";"Total Amount")
                {
                }
                field("Created By";"Created By")
                {
                }
                field("Created Date Time";"Created Date Time")
                {
                }
                field("Redemption Status";"Redemption Status")
                {
                }
                field("Line Total";"Line Total")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
        }
    }

    var
        FundTransactionManagement: Codeunit "Fund Transaction Management";
}

