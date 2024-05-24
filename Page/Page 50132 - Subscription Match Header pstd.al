page 50132 "Subscription Match Header pstd"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
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
            action("Send Matched For Confirmation")
            {
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    //FundTransactionManagement.PostMatchedsubscriptions(Rec);
                end;
            }
        }
    }

    var
        ImportBankStatement: XMLport "Import Bank Statement";
        FundTransactionManagement: Codeunit "Fund Transaction Management";
}

