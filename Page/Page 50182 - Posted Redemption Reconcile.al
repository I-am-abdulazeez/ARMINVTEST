page 50182 "Posted Redemption Reconcile"
{
    CardPageID = "Posted Redemption Card";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Posted Redemption";
    SourceTableView = WHERE("Redemption Status"=CONST(Posted));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(No;No)
                {
                }
                field("Recon No";"Recon No")
                {
                }
                field("Account No";"Account No")
                {
                    Editable = false;
                    Style = Favorable;
                    StyleExpr = match;
                }
                field("Fund Code";"Fund Code")
                {
                    Editable = false;
                    Style = Favorable;
                    StyleExpr = match;
                }
                field("Client ID";"Client ID")
                {
                    Editable = false;
                    Style = Favorable;
                    StyleExpr = match;
                }
                field("Value Date";"Value Date")
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
                field("Net Amount Payable";"Net Amount Payable")
                {
                }
                field("Total Amount Payable";"Total Amount Payable")
                {
                }
                field("Reconciled Line No";"Reconciled Line No")
                {
                }
                field(Reconciled;Reconciled)
                {
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
                    FundAdministration.ViewRedemptionTracker(Rec.No);
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

    trigger OnAfterGetRecord()
    begin
        updatestyle
    end;

    trigger OnModifyRecord(): Boolean
    begin
        updatestyle
    end;

    trigger OnOpenPage()
    begin
        updatestyle
    end;

    var
        match: Boolean;

    local procedure updatestyle()
    begin
        if Reconciled then
          match:=true
        else
          match:= false;
    end;
}

