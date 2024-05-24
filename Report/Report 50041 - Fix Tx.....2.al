report 50041 "Fix Tx.....2"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Fix Tx.....2.rdlc';

    dataset
    {
        dataitem("Client TransactionsX";"Client TransactionsX")
        {

            trigger OnAfterGetRecord()
            begin
                "Client TransactionsX"."New Entry No" := 0;
                "Client TransactionsX".Modify;

                TransCopy.Reset;
                TransCopy.SetFilter("Entry No",'<>%1',"Client TransactionsX"."Entry No");
                TransCopy.SetRange("Client ID","Client TransactionsX"."Client ID");
                TransCopy.SetRange("Contribution Type","Client TransactionsX"."Contribution Type");
                if TransCopy.FindFirst then begin
                  if TransCopy."Transaction Type" = TransCopy."Transaction Type"::Redemption then begin
                    if "Client TransactionsX"."Entry No" < TransCopy."Entry No" then begin
                      TransCopy."New Entry No" := "Client TransactionsX"."Entry No";
                      TransCopy.Modify;

                      "Client TransactionsX"."New Entry No" := TransCopy."Entry No";
                      "Client TransactionsX".Modify;
                    end else begin
                      TransCopy."New Entry No" := TransCopy."Entry No";
                      TransCopy.Modify;

                      "Client TransactionsX"."New Entry No" := "Client TransactionsX"."Entry No";
                      "Client TransactionsX".Modify;
                    end;
                  end;

                  if TransCopy."Transaction Type" = TransCopy."Transaction Type"::Subscription then begin
                    if "Client TransactionsX"."Entry No" > TransCopy."Entry No" then begin
                      TransCopy."New Entry No" := "Client TransactionsX"."Entry No";
                      TransCopy.Modify;

                      "Client TransactionsX"."New Entry No" := TransCopy."Entry No";
                      "Client TransactionsX".Modify;
                    end else begin
                      TransCopy."New Entry No" := TransCopy."Entry No";
                      TransCopy.Modify;

                      "Client TransactionsX"."New Entry No" := "Client TransactionsX"."Entry No";
                      "Client TransactionsX".Modify;
                    end;
                  end;
                end;
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
        TransCopy: Record "Client TransactionsX";
}

