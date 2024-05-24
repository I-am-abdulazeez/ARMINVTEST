report 50016 CheckIfTierExceeded
{
    DefaultLayout = RDLC;
    RDLCLayout = './CheckIfTierExceeded.rdlc';

    dataset
    {
        dataitem(ClientAccount;"Client Account")
        {

            trigger OnAfterGetRecord()
            begin
                  ClientAccount.CalcFields("No of Units");
                  NAV:=FundAdministration.GetFundPrice(ClientAccount."Fund No",Today,TransactType::Redemption)* ClientAccount."No of Units";

                KYCTier.Reset;
                KYCTier.SetRange("KYC Code",ClientAccount."KYC Tier");
                if KYCTier.FindFirst then
                    if NAV> KYCTier."Account Balance Threshold" then begin
                      Subject:='KYC CATEGORIZATION EXCEEDED';
                      body:='Dear Customer';
                      Recepients:='gideonkrono@gmail.com';
                      sender:=CompanyInformation."Sender Email";
                      if (sender<>'') and (Recepients<>'') then begin
                        SMTPMail.CreateMessage(CompanyInformation.Name,sender,Recepients,Subject,body,true);
                        body:='<br><br>';
                        SMTPMail.AppendBody( body);
                        body:='Please be notified that you have exceeded your KYC tier. You are therefore requested to provide more Documentation';
                        SMTPMail.AppendBody( body);
                        body:='<br><br>';
                        SMTPMail.AppendBody( body);
                        body:='Kind Regards';
                        SMTPMail.AppendBody( body);
                        body:='<br>';
                        SMTPMail.AppendBody( body);
                        body:=CompanyInformation.Name;
                        SMTPMail.AppendBody( body);
                        SMTPMail.Send;
                      end;
                    end
            end;
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

    labels
    {
    }

    trigger OnPreReport()
    begin
        CompanyInformation.Get
    end;

    var
        KYCTier: Record "KYC Tier";
        KYCTierRequirements: Record "KYC Tier Requirements";
        KYCLinks: Record "KYC Links";
        change: Boolean;
        Client: Record Client;
        NAV: Decimal;
        FundAdministration: Codeunit "Fund Administration";
        TransactType: Option Subscription,Redemption,Dividend;
        SMTPMail: Codeunit "SMTP Mail";
        Subject: Text;
        Recepients: Text;
        sender: Text;
        body: Text;
        CC: Text;
        CompanyInformation: Record "Company Information";
}

