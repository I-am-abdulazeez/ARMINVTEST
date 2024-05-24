page 50134 "UnReconciled Subscription Card"
{
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
                field("Fund Code";"Fund Code")
                {
                    Editable = false;
                }
                field("Bank Code";"Bank Code")
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
                field("Created By";"Created By")
                {
                }
                field("Created Date Time";"Created Date Time")
                {
                }
                field("Total No of Lines";"Total No of Lines")
                {
                }
                field("Total Sum of Inflows";"Total Sum of Inflows")
                {
                }
                field("No of Non Client Lines";"No of Non Client Lines")
                {
                }
                field(Comments;Comments)
                {
                }
            }
            group(Control18)
            {
                ShowCaption = false;
                part(Control19;"Imported Statement Lines")
                {
                    SubPageLink = "Header No"=FIELD(No);
                }
                part(Control20;"Posted Matching Lines")
                {
                    SubPageLink = "Fund Code"=FIELD("Fund Code"),
                                  "Bank code"=FIELD("Bank Code"),
                                  "Header Transaction  Date"=FIELD("Transaction Date");
                }
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
                    FundTransactionManagement.RunReconmatch2(Rec);
                end;
            }
            action("Un match all")
            {
                Image = UnApply;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    FundTransactionManagement.RunReconUnmatch(Rec);
                end;
            }
        }
    }

    var
        ImportBankStatement: XMLport "Import Bank Statement Recon";
        FundTransactionManagement: Codeunit "Fund Transaction Management";
}

