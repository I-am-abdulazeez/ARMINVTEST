report 50073 "copy prices"
{
    DefaultLayout = RDLC;
    RDLCLayout = './copy prices.rdlc';

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
        FundPrices.SetRange("Value Date",20190405D);
        if FundPrices.FindFirst then
          repeat
            FundPrices2.Init;
            FundPrices2.Copy(FundPrices);
            FundPrices2."Value Date":=20190407D;
            FundPrices2.Insert;
          until FundPrices.Next=0;
    end;

    var
        FundPrices2: Record "Fund Prices";
        FundPrices: Record "Fund Prices";
}

