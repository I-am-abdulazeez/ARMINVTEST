page 50086 "Unit Transfer Verified"
{
    CardPageID = "Unit Transfer Card";
    DeleteAllowed = false;
    PageType = List;
    SourceTable = "Fund Transfer";
    SourceTableView = WHERE("Fund Transfer Status"=CONST(Verified));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Select;Select)
                {
                }
                field(Comments;Comments)
                {
                }
                field(No;No)
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
                field("From Account No";"From Account No")
                {
                    Editable = false;
                }
                field("From Client Name";"From Client Name")
                {
                    Enabled = false;
                }
                field("To Account No";"To Account No")
                {
                    Editable = false;
                }
                field("To Client Name";"To Client Name")
                {
                    Editable = false;
                }
                field(Amount;Amount)
                {
                    Editable = false;
                }
                field(Remarks;Remarks)
                {
                    Editable = false;
                }
                field("From Fund Code";"From Fund Code")
                {
                    Editable = false;
                }
                field("From Fund Name";"From Fund Name")
                {
                    Editable = false;
                }
                field("From Client ID";"From Client ID")
                {
                    Editable = false;
                }
                field("From Fund Sub Account";"From Fund Sub Account")
                {
                    Editable = false;
                }
                field("To Fund Code";"To Fund Code")
                {
                    Editable = false;
                }
                field("To Client ID";"To Client ID")
                {
                    Editable = false;
                }
                field("To Fund Sub Account";"To Fund Sub Account")
                {
                    Editable = false;
                }
                field("To Fund Name";"To Fund Name")
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
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
                    Statusoptions: Option Received,"ARM Registrar","External Registrar",Rejected,Verified,Posted;
                begin
                    FundAdministration.SelectALLFundTransfer(Statusoptions::Verified);
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
                    Statusoptions: Option Received,"ARM Registrar","External Registrar",Rejected,Verified,Posted;
                begin
                    FundAdministration.UnSelectALLFundTransfer(Statusoptions::Verified);
                end;
            }
            action(Post)
            {
                Image = PostBatch;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    FundTransactionManagement: Codeunit "Fund Transaction Management";
                    Statusoptions: Option Received,"ARM Registrar","External Registrar",Rejected,Verified,Posted;
                begin
                    FundTransactionManagement.PostBatchFundTransfer
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
                    FundAdministration.ViewFundTransferTracker(Rec.No);
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
                    //This Update Prices Action was added to set price to value date of the transaction.
                    if not Confirm('Are you sure you want to update these Unit Transfers?') then
                      Error('');


                    Window.Open('Updating Line No #1#######');

                    UnitTransfer.Reset;
                    Evaluate(vDate,GetFilter("Value Date"));
                    if vDate<>0D then
                      UnitTransfer.SetFilter("Value Date",'=%1',vDate);
                    if GetFilter("Price Per Unit")<>'' then
                      UnitTransfer.SetFilter("Price Per Unit",GetFilter("Price Per Unit") );;
                    UnitTransfer.SetRange("Fund Transfer Status",UnitTransfer."Fund Transfer Status"::Verified);
                    if UnitTransfer.FindFirst then begin
                      repeat
                        Window.Update(1,UnitTransfer.No);
                       UnitTransfer.Validate(Amount);
                       UnitTransfer.Modify;

                    until UnitTransfer.Next=0;
                    end else begin
                      Window.Close;
                      Error('There are no Lines to update');
                    end;
                    Window.Close;

                    Message('Unit Transfer has been update successfully');
                end;
            }
        }
    }

    var
        Window: Dialog;
        UnitTransfer: Record "Fund Transfer";
        vDate: Date;
}

