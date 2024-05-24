page 50126 "Unit Switch Header"
{
    PageType = Card;
    SourceTable = "Unit Switch Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Transaction No";"Transaction No")
                {
                }
                field("CLient ID";"CLient ID")
                {
                }
                field("Client Name";"Client Name")
                {
                }
                field("Value Date";"Value Date")
                {
                }
                field("Transaction Date";"Transaction Date")
                {
                }
                field(Narration;Narration)
                {
                }
                field("Fund Group";"Fund Group")
                {
                }
            }
            part(Control9;"Unit Switch Lines")
            {
                SubPageLink = "Header No"=FIELD("Transaction No");
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Import Schedule")
            {
                Image = ImportExcel;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = showimport;

                trigger OnAction()
                begin
                    Clear(ImportUnitSwitchSchedule);
                    ImportUnitSwitchSchedule.Getheader("Transaction No","Fund Group");
                    ImportUnitSwitchSchedule.Run;
                end;
            }
            action("Send for Confirmation")
            {
                Image = Confirm;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = ShowConfirm;

                trigger OnAction()
                begin
                    FundTransactionManagement.SendUnitSwitchforConfirm(Rec);
                end;
            }
            action("Post ")
            {
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = ShowPost;

                trigger OnAction()
                begin
                    FundTransactionManagement.PostUnitswitch(Rec);
                end;
            }
            action("Update Prices")
            {
                Image = UpdateUnitCost;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    FundTransactionManagement.UpdateUnitswitchprices(Rec);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        if "Switch Status"="Switch Status"::Received then begin
          ShowConfirm:=true;
          ShowImport:=true;
          ShowPost:=false;
        end else begin
          ShowConfirm:=false;
          ShowImport:=false;
          ShowPost:=true;
        end
    end;

    trigger OnOpenPage()
    begin
        if "Switch Status"="Switch Status"::Received then begin
          ShowConfirm:=true;
          ShowImport:=true;
          ShowPost:=false;
        end else begin
          ShowConfirm:=false;
          ShowImport:=false;
          ShowPost:=true;
        end
    end;

    var
        ShowPost: Boolean;
        ShowConfirm: Boolean;
        ShowImport: Boolean;
        ImportUnitSwitchSchedule: XMLport "Import Unit Switch Schedule";
        FundTransactionManagement: Codeunit "Fund Transaction Management";
}

