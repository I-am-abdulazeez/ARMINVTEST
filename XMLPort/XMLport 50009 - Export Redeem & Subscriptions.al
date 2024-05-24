xmlport 50009 "Export Redeem & Subscriptions"
{
    Direction = Export;
    Format = VariableText;
    UseDefaultNamespace = true;

    schema
    {
        textelement(root)
        {
            tableelement("Subscription & Redemp Fundware";"Subscription & Redemp Fundware")
            {
                XmlName = 'Lines';
                fieldelement(Orderno;"Subscription & Redemp Fundware".OrderNO)
                {
                }
                fieldelement(PlanCode;"Subscription & Redemp Fundware".PlanCode)
                {
                }
                fieldelement(FolioNo;"Subscription & Redemp Fundware".FolioNo)
                {
                }
                fieldelement(TransactionType;"Subscription & Redemp Fundware".TransactionType)
                {
                }
                fieldelement(Postdate;"Subscription & Redemp Fundware".PostDate)
                {
                }
                fieldelement(Tradedate;"Subscription & Redemp Fundware".TradeDate)
                {
                }
                fieldelement(TradeUnits;"Subscription & Redemp Fundware".TradeUnits)
                {
                }
                fieldelement(TradeNav;"Subscription & Redemp Fundware".TradeNav)
                {
                }
                fieldelement(TradeAmount;"Subscription & Redemp Fundware".TradeAmount)
                {
                }
                fieldelement(LoadAmount;"Subscription & Redemp Fundware".LoadAmount)
                {
                }
                fieldelement(Settledate;"Subscription & Redemp Fundware".SettledDate)
                {
                }
                fieldelement(SettledAmount;"Subscription & Redemp Fundware".SettledAmount)
                {
                }
                fieldelement(BankID;"Subscription & Redemp Fundware".BankID)
                {
                }
                fieldelement(BankAccountNo;"Subscription & Redemp Fundware".BankAccountNo)
                {
                }
                fieldelement(OrderStatus;"Subscription & Redemp Fundware".OrderStatus)
                {
                }
                fieldelement(SwitchPlanCode;"Subscription & Redemp Fundware".SwitchPlanCode)
                {
                }
                fieldelement(Data_Id;"Subscription & Redemp Fundware".Data_Id)
                {
                }
                fieldelement(RecordType;"Subscription & Redemp Fundware"."Record Type")
                {
                }
                fieldelement(IsPreSettlement;"Subscription & Redemp Fundware".IsPreSettlement)
                {
                }
                fieldelement(RefundAmount;"Subscription & Redemp Fundware".RefundAmount)
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

    var
        Bank: Record Bank;
}

