page 50064 "Confirmed Subscriptions"
{
    CardPageID = "Subscription Card";
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = true;
    PageType = List;
    SourceTable = Subscription;
    SourceTableView = WHERE("Subscription Status"=CONST(Confirmed));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Select;Select)
                {
                }
                field(No;No)
                {
                    Editable = false;
                }
                field("Account No";"Account No")
                {
                    Editable = false;
                }
                field("Value Date";"Value Date")
                {
                    Editable = false;
                }
                field("Fund Code";"Fund Code")
                {
                    Editable = false;
                }
                field("Client ID";"Client ID")
                {
                    Editable = false;
                }
                field(Amount;Amount)
                {
                    Editable = false;
                }
                field("No. Of Units";"No. Of Units")
                {
                    DecimalPlaces = 4:4;
                    Editable = false;
                }
                field("Payment Mode";"Payment Mode")
                {
                }
                field("Received From";"Received From")
                {
                    Editable = false;
                }
                field("Matching Header No";"Matching Header No")
                {
                    Editable = false;
                }
                field("Bank Narration";"Bank Narration")
                {
                }
                field("Creation Date";"Creation Date")
                {
                }
                field("Created By";"Created By")
                {
                }
                field("Client Name";"Client Name")
                {
                }
                field("OLD Account No";"OLD Account No")
                {
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Select All")
            {
                Image = SelectEntries;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    FundAdministration: Codeunit "Fund Administration";
                    Statusoptions: Option Received,Confirmed,Posted;
                begin
                    //FundAdministration.SelectALLSubscription(Statusoptions::Confirmed);
                    Subscription.Reset;
                    Subscription.SetRange("Subscription Status",Subscription."Subscription Status"::Confirmed);
                    Evaluate(Vdate,GetFilter("Value Date"));
                    if Vdate<>0D then
                    Subscription.SetFilter("Value Date",'=%1',Vdate);
                    if  Subscription.FindFirst then begin
                      repeat
                        Subscription.Validate(Select,true);
                        Subscription."Selected By":=UserId;
                        Subscription.Modify;
                      until Subscription.Next=0;
                    end
                end;
            }
            action("Un Select All")
            {
                Image = UnApply;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    FundAdministration: Codeunit "Fund Administration";
                    Statusoptions: Option Received,Confirmed,Posted;
                begin
                    FundAdministration.UnSelectALLSubscription(Statusoptions::Confirmed);
                end;
            }
            action(Post)
            {
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    FundAdministration: Codeunit "Fund Administration";
                    Statusoptions: Option Received,Confirmed,Posted;
                begin
                    //FundTransactionManagement.UpdateSubscriptionsPrice(Rec)
                    FundTransactionManagement.PostBatchSubscription;
                end;
            }
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
                    FundAdministration.ViewSubscriptionTracker(Rec.No);
                end;
            }
            action("Update Prices")
            {
                Image = UpdateUnitCost;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    FundAdministration: Codeunit "Fund Administration";
                begin
                    FundTransactionManagement.UpdateSubscriptionsPrice(Rec)
                end;
            }
        }
    }

    var
        FundTransactionManagement: Codeunit "Fund Transaction Management";
        Subscription: Record Subscription;
        Vdate: Date;
}

