report 50032 "Update Agent Codes Trans"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Update Agent Codes Trans.rdlc';

    dataset
    {
        dataitem(Client;Client)
        {
            DataItemTableView = WHERE("Account Executive Code"=FILTER(<>''));

            trigger OnAfterGetRecord()
            begin
                Trans.Reset;
                Trans.SetCurrentKey("Account No","Client ID","Value Date");
                Trans.SetRange("Client ID",Client."Membership ID");
                //Trans.SETFILTER("Agent Code",'%1','');
                if Trans.FindSet then
                  Trans.ModifyAll("Agent Code",Client."Account Executive Code");
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
        Message('Complete');
    end;

    var
        Trans: Record "Client Transactions";
}

