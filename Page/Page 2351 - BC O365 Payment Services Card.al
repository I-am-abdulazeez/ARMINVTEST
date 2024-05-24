page 2351 "BC O365 Payment Services Card"
{
    // version NAVW113.01

    Caption = 'Online Payments';
    PageType = Card;
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            part(PaymentServicesSubpage;"BC O365 Payment Services")
            {
                ApplicationArea = Basic,Suite,Invoicing;
                UpdatePropagation = Both;
            }
        }
    }

    actions
    {
    }
}

