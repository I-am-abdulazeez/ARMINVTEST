report 50079 "Update Prices"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Update Prices.rdlc';

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
        PostedRedemption.Reset;
        PostedRedemption.SetRange("Value Date",20190321D);
        PostedRedemption.SetFilter("Fund Code",'<>%1','ARMMMF');
        if PostedRedemption.FindFirst then
          repeat
            ClientTransactions.Reset;
            ClientTransactions.SetRange("Value Date",PostedRedemption."Value Date");
            ClientTransactions.SetRange("Transaction No",PostedRedemption.No);
            if ClientTransactions.FindFirst then
              repeat
              ClientTransactions."Price Per Unit":=FundAdministration.GetFundPrice(ClientTransactions."Fund Code",ClientTransactions."Value Date",TransactType::Redemption);
              ClientTransactions."No of Units":=FundAdministration.GetFundNounits(ClientTransactions."Fund Code",ClientTransactions."Value Date",ClientTransactions.Amount,TransactType::Redemption);
              ClientTransactions.Modify;
              until ClientTransactions.Next=0;

              PostedRedemption."Price Per Unit":=FundAdministration.GetFundPrice(PostedRedemption."Fund Code",PostedRedemption."Value Date",TransactType::Redemption);
              PostedRedemption."No. Of Units":=FundAdministration.GetFundNounits(PostedRedemption."Fund Code",PostedRedemption."Value Date",PostedRedemption.Amount,TransactType::Redemption);
              PostedRedemption.Modify;

          until PostedRedemption.Next=0;
        PostedSubscription.Reset;
        PostedSubscription.SetRange("Value Date",20190321D);
        PostedSubscription.SetFilter("Fund Code",'<>%1','ARMMMF');
        if PostedSubscription.FindFirst then
          repeat
            ClientTransactions.Reset;
            ClientTransactions.SetRange("Value Date",PostedSubscription."Value Date");
            ClientTransactions.SetRange("Transaction No",PostedSubscription.No);
            if ClientTransactions.FindFirst then
              repeat
                ClientTransactions."Price Per Unit":=FundAdministration.GetFundPrice(ClientTransactions."Fund Code",ClientTransactions."Value Date",TransactType::Subscription);
                ClientTransactions."No of Units":=FundAdministration.GetFundNounits(ClientTransactions."Fund Code",ClientTransactions."Value Date",ClientTransactions.Amount,TransactType::Subscription);
                ClientTransactions.Modify;
              until ClientTransactions.Next=0;

              PostedSubscription."Price Per Unit":=FundAdministration.GetFundPrice(PostedSubscription."Fund Code",PostedSubscription."Value Date",TransactType::Subscription);
              PostedSubscription."No. Of Units":=FundAdministration.GetFundNounits(PostedSubscription."Fund Code",PostedSubscription."Value Date",PostedSubscription.Amount,TransactType::Subscription);
              PostedSubscription.Modify;

          until PostedSubscription.Next=0;
    end;

    var
        PostedRedemption: Record "Posted Redemption";
        PostedSubscription: Record "Posted Subscription";
        ClientTransactions: Record "Client Transactions";
        FundAdministration: Codeunit "Fund Administration";
        TransactType: Option Subscription,Redemption,Dividend;
}

