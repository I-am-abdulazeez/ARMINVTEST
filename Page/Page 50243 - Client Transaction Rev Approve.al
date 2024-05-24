page 50243 "Client Transaction Rev Approve"
{
    // version Rev-1.0

    CardPageID = "Reversal Card Approve";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Temp Client Transactions";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No";"Entry No")
                {
                    Editable = false;
                }
                field("Value Date";"Value Date")
                {
                    Editable = false;
                }
                field("Account No";"Account No")
                {
                    Editable = false;
                }
                field("Client ID";"Client ID")
                {
                    Editable = false;
                }
                field("Fund Code";"Fund Code")
                {
                    Editable = false;
                }
                field("Fund Sub Code";"Fund Sub Code")
                {
                    Editable = false;
                }
                field(Narration;Narration)
                {
                    Editable = false;
                }
                field("Agent Code";"Agent Code")
                {
                    Editable = false;
                }
                field(Amount;Amount)
                {
                    Editable = false;
                }
                field("Price Per Unit";"Price Per Unit")
                {
                    Editable = false;
                }
                field("No of Units";"No of Units")
                {
                    Editable = false;
                }
                field("Transaction Type";"Transaction Type")
                {
                    Editable = false;
                }
                field("Transaction Sub Type";"Transaction Sub Type")
                {
                    Editable = false;
                }
                field("Transaction Date";"Transaction Date")
                {
                    Editable = false;
                }
                field("Contribution Type";"Contribution Type")
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
            }
            action("Reverse Transaction")
            {
                Image = ReverseLines;
                Promoted = true;
                PromotedCategory = New;
                PromotedIsBig = true;
                Visible = true;

                trigger OnAction()
                begin

                    if not Confirm('Are you sure you want to reverse this transaction?') then
                      Error('');
                    TempClientTransaction.CopyFilters(Rec);
                    CurrPage.SetSelectionFilter(TempClientTransaction);
                    if TempClientTransaction.FindFirst then
                     begin
                       Eod.Reset;
                    if Eod.FindLast then
                      Valuedate:=CalcDate('1D',Eod.Date);
                    EntryNo:=0;
                    EntryNo:=GetLastTransactionNo;
                    ClientTransactions.Reset;
                    ClientTransactions."Entry No":=EntryNo+1;
                    ClientTransactions."Client ID" := Rec."Client ID";
                    ClientTransactions."Account No" := Rec."Account No";
                    ClientTransactions."Transaction Type":= Rec."Transaction Type";
                    ClientTransactions."Value Date":= Valuedate;
                    ClientTransactions."Transaction Date":=Today;
                    ClientTransactions."Fund Code":=Rec."Fund Code";

                    ClientTransactions."Fund Sub Code":=Rec."Fund Sub Code";
                    ClientTransactions."Transaction Sub Type":= Rec."Transaction Sub Type";
                    ClientTransactions."Transaction Sub Type 2":=Rec."Transaction Sub Type 2";
                    ClientTransactions."Transaction Sub Type 3" := Rec."Transaction Sub Type 3";
                    if ClientTransactions."Transaction Type" = ClientTransactions."Transaction Type"::Subscription then begin
                    ClientTransactions.Narration:= 'Subscription Reversal - ' + Format(Rec."Value Date");
                      ClientTransactions.Amount:= -Rec.Amount;
                      ClientTransactions."No of Units":= -Rec."No of Units";
                      end else begin
                        ClientTransactions.Narration:= 'Redemption Reversal - '+ Format(Rec."Value Date");
                        ClientTransactions.Amount:= Abs(Rec.Amount);
                    ClientTransactions."No of Units":= Abs(Rec."No of Units");
                        end;
                    ClientTransactions."Transaction No":= Rec."Transaction No";
                    ClientTransactions."Price Per Unit":= Rec."Price Per Unit";
                    ClientTransactions.Currency:= Rec.Currency;
                    ClientTransactions."Agent Code":= Rec."Agent Code";
                    ClientTransactions."Created By":=UserId;
                    ClientTransactions."Created Date Time":=CurrentDateTime;
                    ClientTransactions."Transaction Source Document":= Rec."Transaction Source Document";
                    ClientTransactions.Reversed := true;
                    if ClientTransactions.Amount<>0 then
                    ClientTransactions.Insert(true);
                    if ClientTransactions."Transaction Type" = ClientTransactions."Transaction Type"::Subscription then begin
                        ReverseSubscription(ClientTransactions."Transaction No");
                      end else begin
                        ReverseRedemption(ClientTransactions."Transaction No");
                        end;

                     TempClientTransaction.Reset;
                     TempTransaction.SetRange("Entry No",Rec."Entry No");
                     TempClientTransaction.SetRange("Client ID",Rec."Client ID");
                     TempClientTransaction.SetRange("Account No",Rec."Account No");
                     if TempClientTransaction.FindFirst then begin
                      TempClientTransaction.Reversed := true;
                     TempClientTransaction.Modify(true);
                     end;


                      Message('Reversal Completed');
                      TempClientTransaction2.Reset;
                      TempClientTransaction2.SetRange("Client ID",Rec."Client ID");
                      TempClientTransaction2.SetRange("Account No",Rec."Account No");
                      TempClientTransaction2.SetRange(Approved,false);
                      TempClientTransaction2.SetRange(Reversed,false);
                      if TempClientTransaction2.Count = 0 then begin

                         ClientAccount.Reset;
                         ClientAccount.SetRange("Client ID", Rec."Client ID");
                         ClientAccount.SetRange("Account No",Rec."Account No");
                         ClientAccount.SetRange("Fund No", Rec."Fund Code");
                         if ClientAccount.FindFirst then begin
                          ClientAccount."Reversal Approval" := ClientAccount."Reversal Approval"::reversed;
                           ClientAccount."Document Link" := '';
                           ClientAccount."Reversal Rejection Reason" := '';
                          ClientAccount.Modify;
                        end;
                      end;
                     end;
                end;
            }
        }
    }

    var
        ClientAdministration: Codeunit "Client Administration";
        EntryNo: Integer;
        ClientTransactions: Record "Client Transactions";
        Eod: Record "EOD Tracker";
        Valuedate: Date;
        TempTransaction: Record "Temp Client Transactions";
        ClientAccount: Record "Client Account";
        TempClientTransaction: Record "Temp Client Transactions";
        TempClientTransaction2: Record "Temp Client Transactions";

    procedure GetLastTransactionNo(): Integer
    var
        ClientTransactions: Record "Client Transactions";
    begin
        if ClientTransactions.FindLast then
        exit(ClientTransactions."Entry No");
    end;

    local procedure ReverseRedemption(TransactionNo: Code[20])
    var
        Redemption: Record "Posted Redemption";
    begin
        Redemption.Reset;
        Redemption.SetRange(No,TransactionNo);
        Redemption.SetRange(Reversed,false);
        if Redemption.FindFirst then begin
          Redemption.Reversed := true;
          Redemption."Reversed By" := UserId;
          Redemption."Date Time reversed" := CurrentDateTime;
          Redemption.Modify;
          end;
    end;

    local procedure ReverseSubscription(TransactionNo: Code[20])
    var
        Subscription: Record "Posted Subscription";
    begin
        Subscription.Reset;
        Subscription.SetRange(No,TransactionNo);
        Subscription.SetRange(Reversed,false);
        if Subscription.FindFirst then begin
          Subscription.Reversed := true;
          Subscription."Reversed By" := UserId;
          Subscription."Date Time reversed" := CurrentDateTime;
          Subscription.Modify;
          end;
    end;

    local procedure MoveTransactionToTemp(transaction: Record "Client Transactions")
    begin
        TempTransaction.Init;
        TempTransaction.TransferFields(transaction);
        TempTransaction.Insert;
    end;
}

