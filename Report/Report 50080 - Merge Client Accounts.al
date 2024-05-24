report 50080 "Merge Client Accounts"
{
    // version 3

    DefaultLayout = RDLC;
    RDLCLayout = './Merge Client Accounts.rdlc';

    dataset
    {
        dataitem(Client;Client)
        {
            DataItemTableView = WHERE("New Client ID"=FILTER(<>''));
            column(new;Client."New Client ID")
            {
            }

            trigger OnAfterGetRecord()
            begin
                window.Update(1,Client."Membership ID");
                Accno:='';
                ClientAccount.Reset;
                ClientAccount.SetRange("Client ID",Client."Membership ID");
                if ClientAccount.FindFirst then
                  repeat



                    ClientAccount2.Reset;
                    ClientAccount2."Account No":='';
                    ClientAccount2.Init;
                    ClientAccount2."Account No":='';
                    Accno:=ClientAccount2."Account No";
                    ClientAccount2.Insert(true);
                    if  StrPos(ClientAccount."Account No",'-99')>0 then
                     ClientAccount2."Pay Day":=true;
                    ClientAccount2.Validate("Client ID",Client."New Client ID");
                    ClientAccount2.Validate("Fund No",ClientAccount."Fund No");
                    ClientAccount2."Old Account Number":=ClientAccount."Old Account Number";
                    ClientAccount2."Old MembershipID":=Client."Membership ID";
                    ClientAccount2."Dividend Mandate":=ClientAccount."Dividend Mandate";
                    ClientAccount2."KYC Tier":=ClientAccount."KYC Tier";
                    ClientAccount2."Bank Code":=ClientAccount."Bank Code";
                    ClientAccount2."Bank Account Number":=ClientAccount2."Bank Account Number";
                    ClientAccount2."Bank Account Name":=ClientAccount2."Bank Account Name";

                    Accno:=ClientAccount2."Account No";
                    ClientAccount2.Modify;

                ClientAccount."New Account No":=Accno;
                ClientAccount.Modify;

                  until ClientAccount.Next=0;
            end;

            trigger OnPreDataItem()
            begin
                //Client.SETRANGE("Membership ID",'1143660');
                //Client.SETRANGE("New Client ID",'1003002');
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

    trigger OnPostReport()
    begin
        window.Close
    end;

    trigger OnPreReport()
    begin
        window.Open('updating... #1######');
    end;

    var
        ClientAccount: Record "Client Account";
        ClientAccount2: Record "Client Account";
        Accno: Code[40];
        window: Dialog;
        ClientAccount3: Record "Client Account";
}

