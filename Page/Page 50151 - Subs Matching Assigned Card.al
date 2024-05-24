page 50151 "Subs Matching Assigned Card"
{
    DeleteAllowed = false;
    Editable = true;
    PageType = Card;
    SourceTable = "Subscription Matching header";

    layout
    {
        area(content)
        {
            group(General)
            {
                field(No;No)
                {
                }
                field(Narration;Narration)
                {
                }
                field("Value Date";"Value Date")
                {
                }
                field("Transaction Date";"Transaction Date")
                {
                }
                field("Fund Code";"Fund Code")
                {
                }
                field("Bank Code";"Bank Code")
                {
                }
                field("Bank Branch";"Bank Branch")
                {
                }
                field("Matched Lines";"Matched Lines")
                {
                }
                field("Non Client Lines";"Non Client Lines")
                {
                }
                field("Un Matched Lines";"Un Matched Lines")
                {
                }
                field("Lines Assigned";"Lines Assigned")
                {
                }
            }
            part(Control10;"Subscription Matching Lines")
            {
                SubPageLink = "Header No"=FIELD(No),
                              "Assigned User"=FIELD(UserFilter);
                SubPageView = WHERE(Posted=CONST(false));
            }
            part("Posted Lines";"Subscription Matching Lines")
            {
                Caption = 'Posted Lines';
                Editable = false;
                SubPageLink = "Header No"=FIELD(No);
                SubPageView = WHERE(Posted=CONST(true));
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Send Matched For Confirmation")
            {
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    FundTransactionManagement.PostMatchedsubscriptions(Rec,0);
                end;
            }
            action("Assign users")
            {
                Image = Allocate;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Page "Assign Users";
                RunPageLink = "Matching Header"=FIELD(No);
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        FilterGroup(10);
        SetFilter(UserFilter,UserId);

        FilterGroup(0);
    end;

    trigger OnOpenPage()
    begin
        FilterGroup(10);
        SetFilter(UserFilter,UserId);

        FilterGroup(0);
    end;

    var
        ImportBankStatement: XMLport "Import Bank Statement";
        FundTransactionManagement: Codeunit "Fund Transaction Management";
}

