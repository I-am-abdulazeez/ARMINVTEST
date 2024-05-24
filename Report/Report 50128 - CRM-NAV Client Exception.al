report 50128 "CRM-NAV Client Exception"
{
    DefaultLayout = RDLC;
    RDLCLayout = './CRM-NAV Client Exception.rdlc';

    dataset
    {
        dataitem(Client;Client)
        {
            column(StreetName_Client;Client."Street Name")
            {
            }
            column(MembershipID_Client;Client."Membership ID")
            {
            }
            column(FirstName_Client;Client."First Name")
            {
            }
            column(Surname_Client;Client.Surname)
            {
            }
            column(PhoneNumber_Client;Client."Phone Number")
            {
            }
            column(BankAccountNumber_Client;Client."Bank Account Number")
            {
            }
            column(EMail_Client;Client."E-Mail")
            {
            }
            column(ClientType_Client;Client."Client Type")
            {
            }
            column(SN;SN)
            {
            }

            trigger OnAfterGetRecord()
            var
                phoneLength: Integer;
                memberIDLength: Integer;
                accountLength: Integer;
            begin
                if  ((Client."Membership ID" <> '') and (Client."Bank Account Number" <> '') and (Client."Phone Number" <> '') and (Client."Street Name" <> '') and (Client."E-Mail" <> '') and (Client."First Name" <> '') and (Client.Surname <> '')) then begin
                  memberIDLength := StrLen(Client."Membership ID");
                  accountLength := StrLen(Client."Bank Account Number");
                  phoneLength := StrLen(Client."Phone Number");
                //  IF ((accountLength < 10) OR (accountLength > 10)) OR ((phoneLength < 11) OR (phoneLength > 11)) OR ((memberIDLength < 7) OR (memberIDLength > 7)) THEN BEGIN
                //    CurrReport.SKIP;
                //  END;
                 if ((accountLength = 10) or (phoneLength = 11) or (memberIDLength = 7)) then begin
                    CurrReport.Skip;
                  end;
                  CurrReport.Skip;
                end;
                SN := SN + 1;
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

    var
        SN: Integer;
}

