page 50118 "Subscription Schedule Header"
{
    DeleteAllowed = false;
    InsertAllowed = true;
    PageType = Card;
    SourceTable = "Subscription Schedules Header";

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
                    ShowMandatory = true;
                }
                field("Transaction Date";"Transaction Date")
                {
                }
                field("Bank Code";"Bank Code")
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
                field("Fund Group";"Fund Group")
                {
                }
                field("Total Amount";"Total Amount")
                {
                    ShowMandatory = true;
                }
                field("Line Total";"Line Total")
                {
                }
                field("Subscription Status";"Subscription Status")
                {
                }
            }
            part(Control11;"Subscription Schedule Lines")
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

                    Clear(ImportSubscriptionSchedule);
                    ImportSubscriptionSchedule.Getheader("Schedule No","Fund Group");
                    ImportSubscriptionSchedule.Run;
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
                    TestField("Bank Code");
                    FundTransactionManagement.SendSubScheduleforConfirm(Rec);
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
                    TestField("Bank Code");
                    FundTransactionManagement.PostSubscriptionSchedule(Rec);
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
                    FundTransactionManagement.UpdateSubscriptionSchedulePrice(Rec);
                end;
            }
            action(ImportIngraschedule)
            {

                trigger OnAction()
                begin

                    Clear(ImportSubScheduleIntegra);
                    ImportSubScheduleIntegra.Getheader("Schedule No","Fund Group");
                    ImportSubScheduleIntegra.Run;
                end;
            }
            action(Reject)
            {
                Image = Reject;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = ShowReject;

                trigger OnAction()
                var
                    FundAdministration: Codeunit "Fund Administration";
                    Statusoptions: Option Received,"ARM Registrar","External Registrar",Rejected,Verified,Posted;
                begin
                    /*IF NOT CONFIRM('Are you sure you want to reject this subscription schedule?') THEN
                      ERROR('');
                    "Subscription Status" := "Subscription Status"::Rejected;*/
                    
                    if not Confirm('Are you sure you want to reject this subscription schedule?') then
                      Error('');
                    if Comment = '' then
                      Error('Please, enter the reason for rejection in the comment field')
                    else begin
                      "Subscription Status" := "Subscription Status"::Rejected;
                      Modify;
                      Message('Subscription Schedule has been rejected successfully');
                    end

                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        if "Subscription Status"="Subscription Status"::Received then begin
          ShowConfirm:=true;
          ShowImport:=true;
          ShowPost:=false;
          ShowReject := false;
        end else begin
          ShowConfirm:=false;
          ShowImport:=false;
          ShowPost:=true;
          ShowReject := true;
        end
    end;

    trigger OnOpenPage()
    begin
        if "Subscription Status"="Subscription Status"::Received then begin
          ShowConfirm:=true;
          ShowImport:=true;
          ShowPost:=false;
          ShowReject := false
        end else begin
          ShowConfirm:=false;
          ShowImport:=false;
          ShowPost:=true;
          ShowReject := true;
        end;
        if "Subscription Status" = "Subscription Status"::Rejected then
          IsEditable := false
        else
          IsEditable := true
    end;

    var
        ImportSubscriptionSchedule: XMLport "Import Sub Schedule Integra";
        FundTransactionManagement: Codeunit "Fund Transaction Management";
        ShowPost: Boolean;
        ShowConfirm: Boolean;
        ShowImport: Boolean;
        ImportSubScheduleIntegra: XMLport "Import Sub Schedule Integra";
        ShowReject: Boolean;
        IsEditable: Boolean;
}

