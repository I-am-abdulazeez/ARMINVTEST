page 50045 "Direct Debit Cancellation Card"
{
    DeleteAllowed = false;
    PageType = Card;
    SourceTable = "Direct Debit Mandate";

    layout
    {
        area(content)
        {
            group(General)
            {
                field(No;No)
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
                field("Sub Fund Code";"Sub Fund Code")
                {
                }
                field("Client Name";"Client Name")
                {
                }
                field("Bank Code";"Bank Code")
                {
                }
                field("Bank Branch Code";"Bank Branch Code")
                {
                }
                field("Bank Account Name";"Bank Account Name")
                {
                }
                field("Bank Account Number";"Bank Account Number")
                {
                }
                field(Frequency;Frequency)
                {
                }
                field(Status;Status)
                {
                }
                field("Cancellation Channel";"Cancellation Channel")
                {
                }
                field("Direct Debit to Be cancelled";"Direct Debit to Be cancelled")
                {
                }
                field("Document Link";"Document Link")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Attach Document")
            {
                Image = Attach;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    SharepointIntegration: Codeunit "Sharepoint Integration";
                begin
                    if "Document Link"<>'' then
                      if not Confirm('There is an existing Document For this record. Do you Want to overwrite it?') then
                        Error('');
                    "Document Link":=SharepointIntegration.SaveFileonsharepoint(No,'Direct_Debit_cancel',"Client ID");
                    Modify;
                end;
            }
            action("View Document")
            {
                Image = Web;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    SharepointIntegration: Codeunit "Sharepoint Integration";
                begin
                    SharepointIntegration.ViewDocument("Document Link");
                end;
            }
            action(AODS)
            {
                Image = DocInBrowser;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    ClientAdministration: Codeunit "Client Administration";
                begin
                    ClientAdministration.ViewKYCLinks("Client ID");
                end;
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        "Request Type":="Request Type"::Cancellation;
    end;
}

