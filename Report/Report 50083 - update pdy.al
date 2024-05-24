report 50083 "update pdy"
{
    // version 1

    DefaultLayout = RDLC;
    RDLCLayout = './update pdy.rdlc';

    dataset
    {
        dataitem("Client Account";"Client Account")
        {
            column(AccountNo_ClientAccount;"Client Account"."Account No")
            {
            }

            trigger OnAfterGetRecord()
            begin
                "Client Account"."Fund Sub Account":='99';
                "Client Account"."Pay Day":=true;
                "Client Account".Modify;
            end;

            trigger OnPreDataItem()
            begin
                "Client Account".SetFilter("Client Account"."Account No",'*-99*');
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
}

