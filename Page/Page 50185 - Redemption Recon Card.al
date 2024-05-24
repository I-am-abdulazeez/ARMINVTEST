page 50185 "Redemption Recon Card"
{
    PageType = Card;
    SourceTable = "Redemption Recon header";

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
                field("Bank Code";"Bank Code")
                {
                }
                field("Bank Branch";"Bank Branch")
                {
                }
            }
            group("Reconcilation Lines")
            {
                part(Control18;"Redemption Recon Lines")
                {
                    SubPageLink = "Header No"=FIELD(No);
                }
                part(Control14;"Posted Redemption Reconcile")
                {
                    SubPageLink = "Value Date"=FIELD("Value Date");
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
                var
                    ImportBankStatement: XMLport "Import Bank Redemption Recon";
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
                    FundTransactionManagement.RunRedReconmatch(Rec);
                end;
            }
        }
    }

    var
        FundTransactionManagement: Codeunit "Fund Transaction Management";
}

