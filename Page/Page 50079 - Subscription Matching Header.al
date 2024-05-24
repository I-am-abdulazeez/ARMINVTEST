page 50079 "Subscription Matching Header"
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
                field("No of Matched Lines";"No of Matched Lines")
                {
                }
                field("No of Un Matched Lines";"No of Un Matched Lines")
                {
                }
                field("No of Non Client Lines";"No of Non Client Lines")
                {
                }
                field("Total No of Lines";"Total No of Lines")
                {
                }
                field("Total Sum of Inflows";"Total Sum of Inflows")
                {
                }
            }
            part(Control10;"Subscription Matching Lines")
            {
                SubPageLink = "Header No"=FIELD(No);
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
            action("Import Statement")
            {
                Image = ImportExcel;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Clear(ImportBankStatement);
                    TestField("Fund Code");

                    ImportBankStatement.Getheader(No,"Fund Code");
                    ImportBankStatement.Run;
                end;
            }
            action("Run Auto Match")
            {
                Image = MapAccounts;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    FundTransactionManagement.RunAutomatch(Rec);
                end;
            }
            action(Post)
            {
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    FundTransactionManagement.PostMatchedsubscriptions(Rec,1);
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

    var
        ImportBankStatement: XMLport "Import Bank Statement";
        FundTransactionManagement: Codeunit "Fund Transaction Management";
}

