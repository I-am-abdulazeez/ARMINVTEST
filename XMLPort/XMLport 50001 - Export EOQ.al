xmlport 50001 "Export EOQ"
{
    Direction = Export;
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement(payout;"EOQ Lines")
            {
                XmlName = 'Payout';
                SourceTableView = WHERE("Dividend Mandate"=CONST(Payout));
                fieldelement(AccountNo;Payout."Account No")
                {
                }
                fieldelement(ClientID;Payout."Client ID")
                {
                }
                fieldelement(Fund;Payout."Fund Code")
                {
                }
                fieldelement(Bank;Payout."Bank Code")
                {
                }
                fieldelement(Branch;Payout."Bank Branch")
                {
                }
                fieldelement(BankAccount;Payout."Bank Account")
                {
                }
                fieldelement(Amount;Payout."Dividend Amount")
                {
                }
            }
            tableelement(reinvest;"EOQ Lines")
            {
                XmlName = 'Reinvest';
                SourceTableView = WHERE("Dividend Mandate"=CONST(Reinvest));
                fieldelement(AccountNo;Reinvest."Account No")
                {
                }
                fieldelement(ClientID;Reinvest."Client ID")
                {
                }
                fieldelement(Fund;Reinvest."Fund Code")
                {
                }
                fieldelement(Bank;Reinvest."Bank Code")
                {
                }
                fieldelement(Branch;Reinvest."Bank Branch")
                {
                }
                fieldelement(BankAccount;Reinvest."Bank Account")
                {
                }
                fieldelement(Amount;Reinvest."Dividend Amount")
                {
                }
            }
            tableelement(nomandate;"EOQ Lines")
            {
                XmlName = 'NoMandate';
                SourceTableView = WHERE("Dividend Mandate"=CONST(" "));
                fieldelement(AccountNo;NoMandate."Account No")
                {
                }
                fieldelement(ClientID;NoMandate."Client ID")
                {
                }
                fieldelement(Fund;NoMandate."Fund Code")
                {
                }
                fieldelement(Bank;NoMandate."Bank Code")
                {
                }
                fieldelement(Branch;NoMandate."Bank Branch")
                {
                }
                fieldelement(BankAccount;NoMandate."Bank Account")
                {
                }
                fieldelement(Amount;NoMandate."Dividend Amount")
                {
                }
            }
        }
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
}

