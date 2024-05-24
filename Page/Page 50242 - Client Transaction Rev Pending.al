page 50242 "Client Transaction Rev Pending"
{
    // version Rev-1.0

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
                Visible = false;

                trigger OnAction()
                begin
                    // IF NOT CONFIRM('Are you sure you want to reverse this transaction?') THEN
                    //  ERROR('');
                    // ClientTransactions.COPYFILTERS(Rec);
                    // CurrPage.SETSELECTIONFILTER(ClientTransactions);
                    // IF ClientTransactions.FINDFIRST THEN
                    // BEGIN
                    //   Eod.RESET;
                    // IF Eod.FINDLAST THEN
                    //  Valuedate:=CALCDATE('1D',Eod.Date);
                    // EntryNo:=0;
                    // EntryNo:=GetLastTransactionNo;
                    // ClientTransactions.RESET;
                    // ClientTransactions."Entry No":=EntryNo+1;
                    // ClientTransactions."Transaction Type":= Rec."Transaction Type";
                    // ClientTransactions."Value Date":= Valuedate;
                    // ClientTransactions."Transaction Date":=TODAY;
                    // ClientTransactions."Fund Code":=Rec."Fund Code";
                    //
                    // ClientTransactions."Fund Sub Code":=Rec."Fund Sub Code";
                    // ClientTransactions."Transaction Sub Type":= Rec."Transaction Sub Type";
                    // ClientTransactions."Transaction Sub Type 2":=Rec."Transaction Sub Type 2";
                    // ClientTransactions."Transaction Sub Type 3" := Rec."Transaction Sub Type 3";
                    // IF ClientTransactions."Transaction Type" = ClientTransactions."Transaction Type"::Subscription THEN BEGIN
                    // ClientTransactions.Narration:= 'Subscription Reversal - ' + FORMAT(Rec."Value Date");
                    //  ClientTransactions.Amount:= -Rec.Amount;
                    //  ClientTransactions."No of Units":= -Rec."No of Units";
                    //  END ELSE BEGIN
                    //    ClientTransactions.Narration:= 'Redemption Reversal - '+ FORMAT(Rec."Value Date");
                    //    ClientTransactions.Amount:= ABS(Rec.Amount);
                    // ClientTransactions."No of Units":= ABS(Rec."No of Units");
                    //    END;
                    // ClientTransactions."Transaction No":= Rec."Transaction No";
                    // ClientTransactions."Price Per Unit":= Rec."Price Per Unit";
                    // ClientTransactions.Currency:= Rec.Currency;
                    // ClientTransactions."Agent Code":= Rec."Agent Code";
                    // ClientTransactions."Created By":=USERID;
                    // ClientTransactions."Created Date Time":=CURRENTDATETIME;
                    // ClientTransactions."Transaction Source Document":= Rec."Transaction Source Document";
                    // ClientTransactions.Reversed := TRUE;
                    // IF ClientTransactions.Amount<>0 THEN
                    // ClientTransactions.INSERT(TRUE);
                    // IF ClientTransactions."Transaction Type" = ClientTransactions."Transaction Type"::Subscription THEN BEGIN
                    //    ReverseSubscription(ClientTransactions."Transaction No");
                    //  END ELSE BEGIN
                    //    ReverseRedemption(ClientTransactions."Transaction No");
                    //    END;
                    // // ClientTransactions.RESET;
                    // // ClientTransactions.SETRANGE("Entry No",Rec."Entry No");
                    // // IF ClientTransactions.FINDFIRST THEN BEGIN
                    // //  ClientTransactions.Reversed := TRUE;
                    // //  ClientTransactions.MODIFY;
                    // //  END;
                    //
                    //  MESSAGE('Reversal Completed');
                    //  END;
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

