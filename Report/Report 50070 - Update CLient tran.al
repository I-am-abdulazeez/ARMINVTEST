report 50070 "Update CLient tran"
{
    ProcessingOnly = true;

    dataset
    {
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        window.Open('updat...#1#####');
        ClientTransactions.Reset;
        ClientTransactions.SetRange("Fund Code",'EMRSC');
        ClientTransactions.SetRange("Value Date",20190306D);
        //ClientTransactions.SETRANGE("Transaction Sub Type",ClientTransactions."Transaction Sub Type"::"Full Redemption");
        ClientTransactions.SetRange("Transaction Type",ClientTransactions."Transaction Type"::Subscription);
        if ClientTransactions.FindFirst then
          repeat
            window.Update(1,ClientTransactions."Entry No");
            //ClientTransactions."Price Per Unit":=378.845;
            //ClientTransactions."No of Units":=FundAdministration.GetFundNounits(ClientTransactions."Fund Code",ClientTransactions."Value Date",ClientTransactions.Amount,TransactType::Subscription);
          ClientTransactions2.Reset;
        ClientTransactions2.SetRange("Fund Code",'EMRSC');
        ClientTransactions2.SetRange("Value Date",20190307D);
        ClientTransactions2.SetRange("Account No",ClientTransactions."Account No");
        ClientTransactions2.SetRange("Transaction Type",ClientTransactions2."Transaction Type"::Subscription);
        if not ClientTransactions2.FindFirst then begin
            ClientTransactions.Narration:='February 2019';
            ClientTransactions.Modify;
        end
          until ClientTransactions.Next=0;
          window.Close;
    end;

    var
        ClientTransactions: Record "Client Transactions";
        window: Dialog;
        TransactType: Option Subscription,Redemption,Dividend;
        FundAdministration: Codeunit "Fund Administration";
        ClientTransactions2: Record "Client Transactions";
}

