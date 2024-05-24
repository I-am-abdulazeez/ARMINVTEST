page 50170 "Redemption Schedule Card"
{
    PageType = Card;
    SourceTable = "Redemption Schedule Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Schedule No";"Schedule No")
                {
                }
                field("Value Date";"Value Date")
                {
                }
                field("Transaction Date";"Transaction Date")
                {
                }
                field("Payment Option";"Payment Option")
                {
                }
                field(Narration;Narration)
                {
                }
                field("CLient ID";"CLient ID")
                {
                }
                field("Client Name";"Client Name")
                {
                }
                field("Total Amount";"Total Amount")
                {
                    DecimalPlaces = 4:4;
                }
                field("Fund Group";"Fund Group")
                {
                }
                field("Created By";"Created By")
                {
                }
                field("Created Date Time";"Created Date Time")
                {
                }
                field("Redemption Status";"Redemption Status")
                {
                }
                field("Line Total";"Line Total")
                {
                    DecimalPlaces = 4:4;
                }
                field("Primary Document";"Primary Document")
                {
                }
                field("Secondary Document";"Secondary Document")
                {
                }
                field("Other Document";"Other Document")
                {
                }
            }
            part(Control15;"Redemption Lines")
            {
                SubPageLink = "Schedule Header"=FIELD("Schedule No");
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
                    TestField("Fund Group");
                    //TESTFIELD("Payment Option");
                    if "Payment Option" = "Payment Option"::" " then
                      Error('Payment option cannot be null');

                    if FundTransactionManagement.CheckifredempLinesExist(Rec) then
                      Error('Please delete the existing schedule lines before you can import again');
                    Clear(ImportRedemptionSchedule);
                    ImportRedemptionSchedule.Getheader("Schedule No","Fund Group","Payment Option");
                    ImportRedemptionSchedule.Run;
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
                    if "Primary Document" = '' then
                      Error('You need to attach at least the Primary document.');
                    FundTransactionManagement.SendRedScheduleforConfirm(Rec);
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
                    FundTransactionManagement.PostRedemptionScheduleHeader(Rec);
                end;
            }
            action("Update Prices")
            {
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    FundTransactionManagement.UpdateRedemptionScheduleprices(Rec);
                end;
            }
            action("Attach Document")
            {
                Image = Attach;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = ShowAttachButton;

                trigger OnAction()
                var
                    SharepointIntegration: Codeunit "Sharepoint Integration";
                    UploadChoice: Label 'Primary Document, Secondary Document, Other Douments';
                    Selection: Integer;
                begin
                    Selection := StrMenu(UploadChoice,1,'Select supporting document option.');
                    if Selection = 1 then begin
                      if "Primary Document"<>'' then
                        if not Confirm('There is an existing Document For this record. Do you Want to overwrite it?') then
                          Error('');
                      "Primary Document" := SharepointIntegration.SaveFileonsharepoint("Schedule No",'Redemption',"CLient ID");
                      Modify;
                    end else if Selection = 2 then begin
                      if "Secondary Document"<>'' then
                        if not Confirm('There is an existing Document For this record. Do you Want to overwrite it?') then
                          Error('');
                      "Secondary Document" := SharepointIntegration.SaveFileonsharepoint("Schedule No",'Redemption',"CLient ID");
                      Modify;
                    end else if Selection = 3 then begin
                      if "Other Document"<>'' then
                        if not Confirm('There is an existing Document For this record. Do you Want to overwrite it?') then
                          Error('');;
                      "Other Document" := SharepointIntegration.SaveFileonsharepoint("Schedule No",'Redemption',"CLient ID");
                      Modify;
                    end;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Toggleview
    end;

    trigger OnOpenPage()
    begin
        Toggleview
    end;

    var
        FundTransactionManagement: Codeunit "Fund Transaction Management";
        ShowPost: Boolean;
        ShowConfirm: Boolean;
        ShowImport: Boolean;
        ImportRedemptionSchedule: XMLport "Import Redemption Schedule";
        ShowAttachButton: Boolean;

    local procedure Toggleview()
    begin
        if "Redemption Status"="Redemption Status"::Received then begin
          ShowConfirm:=true;
          ShowImport:=true;
          ShowPost:=false;
          ShowAttachButton := true;
        end else begin
          ShowConfirm:=false;
          ShowImport:=false;
          ShowPost:=true;
          ShowAttachButton := false;
        end
    end;
}

