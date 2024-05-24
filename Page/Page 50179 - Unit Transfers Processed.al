page 50179 "Unit Transfers Processed"
{
    CardPageID = "Posted Unit Transfer Card";
    DeleteAllowed = false;
    PageType = List;
    SourceTable = "Posted Fund Transfer";
    SourceTableView = WHERE("Fund Transfer Status"=CONST(Posted),
                            "Sent to treasury"=CONST(true),
                            Type=CONST("Across Funds"),
                            "Processed By Bank"=CONST(true));

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
                field("Value Date";"Value Date")
                {
                    Editable = false;
                }
                field("Transaction Date";"Transaction Date")
                {
                    Editable = false;
                }
                field("From Account No";"From Account No")
                {
                    Editable = false;
                }
                field("From Client Name";"From Client Name")
                {
                    Enabled = false;
                }
                field("To Account No";"To Account No")
                {
                    Editable = false;
                }
                field("To Client Name";"To Client Name")
                {
                    Editable = false;
                }
                field(Amount;Amount)
                {
                    Editable = false;
                }
                field(Remarks;Remarks)
                {
                    Editable = false;
                }
                field("From Fund Code";"From Fund Code")
                {
                    Editable = false;
                }
                field("From Fund Name";"From Fund Name")
                {
                    Editable = false;
                }
                field("From Client ID";"From Client ID")
                {
                    Editable = false;
                }
                field("From Fund Sub Account";"From Fund Sub Account")
                {
                    Editable = false;
                }
                field("To Fund Code";"To Fund Code")
                {
                    Editable = false;
                }
                field("To Client ID";"To Client ID")
                {
                    Editable = false;
                }
                field("To Fund Sub Account";"To Fund Sub Account")
                {
                    Editable = false;
                }
                field("To Fund Name";"To Fund Name")
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Record History")
            {
                Image = History;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    FundAdministration: Codeunit "Fund Administration";
                    Statusoptions: Option Received,"ARM Registrar","Logged on Bank Platform","Approved By Bank","Rejected By Bank",Cancelled,"Batch ID Generated","Mandate Cancelled","Update Direct Debit","Sent letter to Bank","Received Response From Bank";
                begin
                    FundAdministration.ViewFundTransferTracker(Rec.No);
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
                    ClientAdministration.ViewKYCLinks("From Client ID");
                end;
            }
        }
    }
}

