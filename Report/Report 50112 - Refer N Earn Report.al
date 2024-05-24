report 50112 "Refer N Earn Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Refer N Earn Report.rdlc';

    dataset
    {
        dataitem(Referral;Referral)
        {
            column(AccountNo;Referral."Account No")
            {
            }
            column(ClientID;Referral."Client ID")
            {
            }
            column(FundNo;Referral."Fund No")
            {
            }
            column(BonusStatus;Referral."Bonus Status")
            {
            }
            column(ReferrerMembershipID;Referral."Referrer Membership ID")
            {
            }
            column(CreatedDate;Referral.CreatedDate)
            {
            }
            column(SubscriptionDate;Referral.SubscriptionDate)
            {
            }
            column(AgentCode;Referral."Agent Code")
            {
            }
            column(RMName;RMName)
            {
            }
            column(AmountPaid;AmountPaid)
            {
            }
            column(SerialNo;SerialNo)
            {
            }

            trigger OnAfterGetRecord()
            begin
                SerialNo := SerialNo + 1;
                AmountPaid := 0;
                vdate := DT2Date(Referral.SubscriptionDate);
                CT.Reset;
                CT.SetRange("Client ID",Referral."Referrer Membership ID");
                CT.SetRange("Value Date",vdate);
                CT.SetFilter(Narration,'%1','Loyalty Earning.');
                if CT.FindFirst then begin
                  AmountPaid := CT.Amount;
                  end;

                AccountManager.Reset;
                AccountManager.SetRange("Agent Code",Referral."Agent Code");
                if AccountManager.FindFirst then
                  RMName := AccountManager."RM Name";
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
        RMName: Text;
        AmountPaid: Decimal;
        SerialNo: Integer;
        CT: Record "Client Transactions";
        vdate: Date;
        AccountManager: Record "Account Manager";
}

