page 50173 "Posted Redemption Sch Card"
{
    Editable = false;
    PageType = Card;
    SourceTable = "Redemption Schedule Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Schedule No";"Schedule No")
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
                field("Value Date";"Value Date")
                {
                }
                field("Transaction Date";"Transaction Date")
                {
                }
                field("Redemption Status";"Redemption Status")
                {
                }
                field("Line Total";"Line Total")
                {
                }
                field(Posted;Posted)
                {
                }
                field("Date Posted";"Date Posted")
                {
                }
                field("Time Posted";"Time Posted")
                {
                }
                field("Posted By";"Posted By")
                {
                }
                field("Primary Document";"Primary Document")
                {
                }
                field("Secondary Document";"Secondary Document")
                {
                }
                field("Other Document";"Other Document")
                {
                }
            }
            part(Control15;"Redemption Lines")
            {
                SubPageLink = "Schedule Header"=FIELD("Schedule No");
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Export Payment Schedule")
            {
                Image = ExportToBank;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    FundTransactionManagement.ExportInstitutionalRedToTreasury;
                    Message('Schedule uploaded to treasury sharepoint folder');
                end;
            }
        }
    }

    var
        FundTransactionManagement: Codeunit "Fund Transaction Management";
}

