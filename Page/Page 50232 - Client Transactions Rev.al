page 50232 "Client Transactions Rev"
{
    // version Rev-1.0

    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Client Transactions";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Select;Select)
                {
                }
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
                Visible = false;

                trigger OnAction()
                begin
                    if not Confirm('Are you sure you want to reverse this transaction?') then
                      Error('');
                    ClientTransactions.CopyFilters(Rec);
                    CurrPage.SetSelectionFilter(ClientTransactions);
                    if ClientTransactions.FindFirst then
                     begin
                       Eod.Reset;
                    if Eod.FindLast then
                      Valuedate:=CalcDate('1D',Eod.Date);
                    EntryNo:=0;
                    EntryNo:=GetLastTransactionNo;
                    ClientTransactions.Reset;
                    ClientTransactions."Entry No":=EntryNo+1;
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
                    // ClientTransactions.RESET;
                    // ClientTransactions.SETRANGE("Entry No",Rec."Entry No");
                    // IF ClientTransactions.FINDFIRST THEN BEGIN
                    //  ClientTransactions.Reversed := TRUE;
                    //  ClientTransactions.MODIFY;
                    //  END;

                      Message('Reversal Completed');
                      end;
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
                    ClientTransactions.Reset;
                    ClientTransactions.SetRange(Select,true);
                    ClientTransactions.SetRange("Selected By",UserId);
                    if ClientTransactions.FindFirst then begin
                      repeat
                        ClientTransactions.Validate(Select,false);
                        ClientTransactions."Selected By":='';
                        ClientTransactions.Modify;
                      until ClientTransactions.Next=0;
                    end
                end;
            }
            action("Send For Approval")
            {
                Image = SendTo;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ClientTransactions.Reset;
                    ClientTransactions.SetRange(Select,true);
                    ClientTransactions.SetRange("Selected By",UserId);
                    if ClientTransactions.FindFirst then begin
                      repeat
                        MoveTransactionToTemp(ClientTransactions);
                        until ClientTransactions.Next = 0;
                       ClientAccount.Reset;
                       ClientAccount.SetRange("Client ID",ClientTransactions."Client ID");
                       ClientAccount.SetRange("Account No",ClientTransactions."Account No");
                       ClientAccount.SetRange("Fund No",ClientTransactions."Fund Code");
                       if ClientAccount.FindFirst then begin
                         ClientAccount."Reversal Approval" := ClientAccount."Reversal Approval"::pending;
                         ClientAccount."Reversal Rejection Reason" := '';
                         ClientAccount.Modify;
                         end;
                        end;
                         Message('Sent for approval');
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        ClientTransactions.Reset;
        ClientTransactions.SetRange(Select,true);
        ClientTransactions.SetRange("Selected By",UserId);
        if ClientTransactions.FindFirst then begin
          repeat
            ClientTransactions.Validate(Select,false);
            ClientTransactions."Selected By":='';
            ClientTransactions.Modify;
          until ClientTransactions.Next=0;
        end
    end;

    var
        ClientAdministration: Codeunit "Client Administration";
        EntryNo: Integer;
        ClientTransactions: Record "Client Transactions";
        Eod: Record "EOD Tracker";
        Valuedate: Date;
        TempTransaction: Record "Temp Client Transactions";
        ClientAccount: Record "Client Account";
        TempTransaction2: Record "Temp Client Transactions";

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
    var
        postedSub: Record "Posted Subscription";
        postedRed: Record "Posted Redemption";
    begin
        TempTransaction2.Reset;
        TempTransaction2.SetRange("Entry No",transaction."Entry No");
        if TempTransaction2.FindFirst then begin
          if TempTransaction2.Reversed = true then
            Error('This transaction has been reversed previously');
          exit;
          end;
          //check for transaction no processed on NAV
          postedSub.Reset;
          postedSub.SetRange(No,transaction."Transaction No");
          if not postedSub.FindFirst then begin
            //ERROR('Transaction %1 cannot be reversed', transaction.Narration);
            postedRed.Reset;
            postedRed.SetRange(No,transaction."Transaction No");
            if not postedRed.FindFirst then
            Error('Transaction %1 cannot be reversed', transaction.Amount);
          end;
        // TempTransaction.INIT;
        // TempTransaction.TRANSFERFIELDS(transaction);
        // TempTransaction.INSERT;
        TempTransaction.Reset;
        TempTransaction."Entry No":= transaction."Entry No";
        TempTransaction."Client ID" := transaction."Client ID";
        TempTransaction."Account No":= transaction."Account No";
        TempTransaction."Transaction Type":= transaction."Transaction Type";
        TempTransaction."Value Date":= transaction."Value Date";
        TempTransaction."Transaction Date":=transaction."Transaction Date";
        TempTransaction."Fund Code":= transaction."Fund Code";
        TempTransaction."Fund Sub Code":= transaction."Fund Sub Code";
        TempTransaction."Transaction Sub Type":= transaction."Transaction Sub Type";
        TempTransaction."Transaction Sub Type 2":=transaction."Transaction Sub Type 2";
        TempTransaction."Transaction Sub Type 3" := transaction."Transaction Sub Type 3";
        TempTransaction.Narration:= transaction.Narration;
        TempTransaction.Amount:= transaction.Amount;
        TempTransaction."No of Units":= transaction."No of Units";
        TempTransaction."Transaction No":= transaction."Transaction No";
        TempTransaction."Price Per Unit":= transaction."Price Per Unit";
        TempTransaction.Currency:= transaction.Currency;
        TempTransaction."Agent Code":= transaction."Agent Code";
        TempTransaction."Created By":= UserId; //transaction."Created By";
        TempTransaction."Created Date Time":= CurrentDateTime; //transaction."Created Date Time";
        TempTransaction."Transaction Source Document":= transaction."Transaction Source Document";
        TempTransaction."Old Account No" := transaction."Old Account No";
        TempTransaction.Insert(true);
    end;
}

