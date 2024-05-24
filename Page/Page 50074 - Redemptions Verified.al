page 50074 "Redemptions Verified"
{
    CardPageID = "Redemption Card";
    DeleteAllowed = false;
    PageType = List;
    SourceTable = Redemption;
    SourceTableView = WHERE("Redemption Status"=CONST(Verified));

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
                field("Transaction No";"Transaction No")
                {
                    Editable = false;
                }
                field("Account No";"Account No")
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
                field("Client Name";"Client Name")
                {
                }
                field("Fund Sub Account";"Fund Sub Account")
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
                field("Agent Code";"Agent Code")
                {
                    Editable = false;
                }
                field("No. Of Units";"No. Of Units")
                {
                    Editable = false;
                }
                field("Price Per Unit";"Price Per Unit")
                {
                    Editable = false;
                }
                field(Amount;Amount)
                {
                    Editable = false;
                }
                field("Accrued Dividend";"Accrued Dividend")
                {
                }
                field("Total Amount Payable";"Total Amount Payable")
                {
                }
                field("Redemption Type";"Redemption Type")
                {
                }
                field(Remarks;Remarks)
                {
                    Editable = false;
                }
                field("OLD Account No";"OLD Account No")
                {
                }
                field("Fee Amount";"Fee Amount")
                {
                }
                field("Net Amount Payable";"Net Amount Payable")
                {
                }
                field("Bank Sort Code";"Bank Sort Code")
                {
                }
                field("Bank Name";"Bank Name")
                {
                }
                field("Bank Account No";"Bank Account No")
                {
                }
                field("Bank Account Name";"Bank Account Name")
                {
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
                    Redemption: Record Redemption;
                    vDate: Date;
                    Fundcode: Code[20];
                begin
                    Redemption.Reset;
                    Redemption.SetRange("Redemption Status",Redemption."Redemption Status"::Verified);
                    Evaluate(vDate,GetFilter("Value Date"));
                    if vDate<>0D then
                      Redemption.SetFilter("Value Date",'=%1',vDate);
                    if GetFilter("Fund Code")<>'' then
                      Redemption.SetFilter("Fund Code",GetFilter("Fund Code") );;
                    if  Redemption.FindFirst then begin
                      repeat

                        Redemption.Validate(Select,true);
                        Redemption."Selected By":=UserId;
                        Redemption.Modify;
                      until Redemption.Next=0;
                    end


                    //FundAdministration.SelectALLRedemption(Statusoptions::Verified);
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
                    FundAdministration.UnSelectALLRedemption(Statusoptions::Verified);
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
                    FundTransactionManagement: Codeunit "Fund Transaction Management";
                    Statusoptions: Option Received,"ARM Registrar","External Registrar",Rejected,Verified,Posted;
                begin
                    FundTransactionManagement.PostBatchRedmption
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
                    FundAdministration.ViewRedemptionTracker(Rec."Transaction No");
                end;
            }
            action("View Document")
            {
                Image = Web;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    SharepointIntegration: Codeunit "Sharepoint Integration";
                begin
                    SharepointIntegration.ViewDocument("Document Link");
                end;
            }
            action(AODS)
            {
                Image = DocInBrowser;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    ClientAdministration: Codeunit "Client Administration";
                begin
                    ClientAdministration.ViewKYCLinks("Client ID");
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
                    vDate: Date;
                    Fundcode: Code[20];
                begin
                    //FundTransactionManagement.UpdateRedemptionsPrice(Rec);

                    if not Confirm('Are you sure you want to update this Redemptions?') then
                      Error('');


                    Window.Open('Updating Line No #1#######');

                    Redemption.Reset;
                    Evaluate(vDate,GetFilter("Value Date"));
                    if vDate<>0D then
                      Redemption.SetFilter("Value Date",'=%1',vDate);
                    if GetFilter("Fund Code")<>'' then
                      Redemption.SetFilter("Fund Code",GetFilter("Fund Code"));
                    Redemption.SetRange("Redemption Status",Redemption."Redemption Status"::Verified);
                    if Redemption.FindFirst then begin
                      repeat
                        Window.Update(1,Redemption."Transaction No");
                       Redemption.Validate(Amount);
                       Redemption.Modify;

                    until Redemption.Next=0;
                    end else begin
                      Window.Close;
                      Error('There are no Lines to update');
                    end;
                    Window.Close;

                    Message('Redemption has been update successfully');
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        BankSortcode:='';
        if Bank.Get("Bank Code") then begin
          BankSortcode:=Bank."Sort Code";
            Bankname:=Bank.Name;
        end else begin
          BankSortcode:='';
          Bankname:='';
        end
    end;

    var
        FundTransactionManagement: Codeunit "Fund Transaction Management";
        Window: Dialog;
        Redemption: Record Redemption;
        BankSortcode: Code[40];
        Bank: Record Bank;
        Bankname: Text;
}

