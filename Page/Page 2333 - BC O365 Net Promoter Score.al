page 2333 "BC O365 Net Promoter Score"
{
    // version NAVW113.02

    Caption = ' ';
    Editable = false;
    PageType = Card;

    layout
    {
        area(content)
        {
            usercontrol(WebPageViewer;"Microsoft.Dynamics.Nav.Client.WebPageViewer")
            {
                ApplicationArea = Basic,Suite,Invoicing;
            }
        }
    }

    actions
    {
    }

    var
        O365NetPromoterScoreMgt: Codeunit "O365 Net Promoter Score Mgt.";
        NetPromoterScoreMgt: Codeunit "Net Promoter Score Mgt.";

    local procedure Navigate()
    var
        Url: Text;
    begin
        Url := O365NetPromoterScoreMgt.GetInvRenderUrl;
        if Url = '' then
          exit;
        CurrPage.WebPageViewer.SubscribeToEvent('message',Url);
        CurrPage.WebPageViewer.Navigate(Url);
    end;
}

