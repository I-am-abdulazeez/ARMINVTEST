report 50042 "Apply Tx Fix....4"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Apply Tx Fix....4.rdlc';

    dataset
    {
        dataitem("Client TransactionsX";"Client TransactionsX")
        {

            trigger OnAfterGetRecord()
            begin
                if not Trans.Get("Client TransactionsX"."New Entry No") then begin
                Trans.Init;
                Trans."Entry No" := "Client TransactionsX"."New Entry No";
                Trans."Account No" := "Client TransactionsX"."Account No";
                Trans."Client ID" := "Client TransactionsX"."Client ID";
                Trans."Fund Code" := "Client TransactionsX"."Fund Code";
                Trans."Fund Sub Code" := "Client TransactionsX"."Fund Sub Code";
                Trans."Agent Code" := "Client TransactionsX"."Agent Code";
                Trans.Amount := "Client TransactionsX".Amount;
                Trans."Price Per Unit" := "Client TransactionsX"."Price Per Unit";
                Trans."No of Units" := "Client TransactionsX"."No of Units";
                Trans."Transaction Type" := "Client TransactionsX"."Transaction Type";
                Trans."Transaction Sub Type" := "Client TransactionsX"."Transaction Sub Type";
                Trans."Value Date" := "Client TransactionsX"."Value Date";
                Trans."Transaction Date" := "Client TransactionsX"."Transaction Date";
                Trans."Employee No" := "Client TransactionsX"."Employee No";
                Trans.Reversed := "Client TransactionsX".Reversed;
                Trans."Reversed By Entry No" := "Client TransactionsX"."Reversed By Entry No";
                Trans."Reversed Entry No" := "Client TransactionsX"."Reversed Entry No";
                Trans."Created By" := "Client TransactionsX"."Created By";
                Trans."Created Date Time" := "Client TransactionsX"."Created Date Time";
                Trans.Currency := "Client TransactionsX".Currency;
                Trans.Narration := "Client TransactionsX".Narration;
                Trans."Transaction No" := "Client TransactionsX"."Transaction No";
                Trans."Transaction Sub Type 2" := "Client TransactionsX"."Transaction Sub Type 2";
                Trans."Transaction Sub Type 3" := "Client TransactionsX"."Transaction Sub Type 3"::"Unit Switch";
                Trans."Transaction Source Document" := "Client TransactionsX"."Transaction Source Document";
                Trans."Contribution Type" := "Client TransactionsX"."Contribution Type";
                Trans."Old Account No" := "Client TransactionsX"."Old Account No";
                Trans."Fund Group" := "Client TransactionsX"."Fund Group";
                Trans.Insert;
                end;
            end;

            trigger OnPostDataItem()
            begin
                //Trans.INSERT;
            end;

            trigger OnPreDataItem()
            begin
                //Trans.INIT;
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

