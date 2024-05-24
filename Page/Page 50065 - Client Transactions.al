page 50065 "Client Transactions"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Client Transactions";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No";"Entry No")
                {
                }
                field("Value Date";"Value Date")
                {
                }
                field("Account No";"Account No")
                {
                }
                field("Client ID";"Client ID")
                {
                }
                field("Fund Code";"Fund Code")
                {
                }
                field("Fund Sub Code";"Fund Sub Code")
                {
                }
                field(Narration;Narration)
                {
                }
                field("Agent Code";"Agent Code")
                {
                }
                field(Amount;Amount)
                {
                }
                field("Price Per Unit";"Price Per Unit")
                {
                }
                field("No of Units";"No of Units")
                {
                }
                field("Transaction Type";"Transaction Type")
                {
                }
                field("Transaction Sub Type";"Transaction Sub Type")
                {
                }
                field("Transaction Date";"Transaction Date")
                {
                }
                field("Contribution Type";"Contribution Type")
                {
                }
                field("Employee No";"Employee No")
                {
                }
                field(Reversed;Reversed)
                {
                }
                field("Reversed By Entry No";"Reversed By Entry No")
                {
                }
                field("Reversed Entry No";"Reversed Entry No")
                {
                }
                field(Currency;Currency)
                {
                }
                field("Transaction No";"Transaction No")
                {
                }
                field("Created By";"Created By")
                {
                }
                field("Created Date Time";"Created Date Time")
                {
                }
                field("Holding Due Date";"Holding Due Date")
                {
                }
                field("On Hold";"On Hold")
                {
                }
                field("Portfolio Code";"Portfolio Code")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("View Source Document")
            {
                Image = ViewServiceOrder;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ClientAdministration.ViewSourceDocument(Rec);
                end;
            }
        }
    }

    var
        ClientAdministration: Codeunit "Client Administration";
}

