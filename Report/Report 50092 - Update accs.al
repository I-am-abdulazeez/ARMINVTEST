report 50092 "Update accs"
{
    // version 13

    DefaultLayout = RDLC;
    RDLCLayout = './Update accs.rdlc';

    dataset
    {
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
        ClientAccount.SetFilter("Old MembershipID",'=%1','');
        if ClientAccount.FindFirst then
          repeat
            if ClientAccount."Old MembershipID"='' then begin
              ClientAccount."Old MembershipID":=ClientAccount."Client ID";
              ClientAccount.Modify;
            end;
          until ClientAccount.Next=0;
    end;

    var
        ClientAccount: Record "Client Account";
}

