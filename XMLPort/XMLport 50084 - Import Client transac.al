xmlport 50084 "Import Client transac"
{
    Format = VariableText;

    schema
    {
        textelement(clienttrans)
        {
            tableelement("Client Transactions";"Client Transactions")
            {
                XmlName = 'Clienttransactions';
                fieldelement(Entry;"Client Transactions"."Entry No")
                {
                    FieldValidate = no;
                }
                fieldelement(AccountNo;"Client Transactions"."Old Account No")
                {
                    FieldValidate = no;
                }
                fieldelement(ID;"Client Transactions"."Client ID")
                {
                    FieldValidate = no;
                }
                fieldelement(Fund;"Client Transactions"."Fund Code")
                {
                    FieldValidate = no;
                }
                fieldelement(amount;"Client Transactions".Amount)
                {
                    FieldValidate = no;
                }
                fieldelement(price;"Client Transactions"."Price Per Unit")
                {
                    FieldValidate = no;
                }
                fieldelement(units;"Client Transactions"."No of Units")
                {
                    FieldValidate = no;
                }
                fieldelement(transtype;"Client Transactions"."Transaction Type")
                {
                    FieldValidate = no;
                }
                fieldelement(transsubtype;"Client Transactions"."Transaction Sub Type")
                {
                    FieldValidate = no;
                }
                fieldelement(transsubtype1;"Client Transactions"."Transaction Sub Type 2")
                {
                    FieldValidate = no;
                }
                fieldelement(transsubtype2;"Client Transactions"."Transaction Sub Type 3")
                {
                    FieldValidate = no;
                }
                fieldelement(vdate;"Client Transactions"."Value Date")
                {
                    FieldValidate = no;
                }
                fieldelement(tdate;"Client Transactions"."Transaction Date")
                {
                    FieldValidate = no;
                }
                fieldelement(employee;"Client Transactions"."Employee No")
                {
                    FieldValidate = no;
                    MaxOccurs = Unbounded;
                    MinOccurs = Zero;
                }
                fieldelement(cur;"Client Transactions".Currency)
                {
                    FieldValidate = no;
                    MaxOccurs = Unbounded;
                    MinOccurs = Zero;
                }
                fieldelement(narration;"Client Transactions".Narration)
                {
                    FieldValidate = no;
                    MaxOccurs = Unbounded;
                    MinOccurs = Zero;
                }
                fieldelement(ref;"Client Transactions"."Transaction No")
                {
                    FieldValidate = no;
                    MaxOccurs = Unbounded;
                    MinOccurs = Zero;
                }
                fieldelement(type;"Client Transactions"."Contribution Type")
                {
                    MinOccurs = Zero;
                }

                trigger OnAfterInsertRecord()
                begin
                    window.Update(1, "Client Transactions"."Entry No");
                end;

                trigger OnBeforeInsertRecord()
                begin
                    ClientAccount.Reset;
                    ClientAccount.SetRange("Old Account Number","Client Transactions"."Old Account No");
                    ClientAccount.SetRange("Fund No","Client Transactions"."Fund Code");
                    if ClientAccount.FindFirst then
                      "Client Transactions"."Account No":=ClientAccount."Account No"
                    else begin
                    ClientAccount.Reset;
                    ClientAccount.SetRange("Old MembershipID","Client Transactions"."Client ID");
                    ClientAccount.SetRange("Fund No","Client Transactions"."Fund Code");
                    if ClientAccount.FindFirst then
                      "Client Transactions"."Account No":=ClientAccount."Account No"
                    else begin
                      ClientAccount.Reset;
                    ClientAccount.SetRange("Client ID","Client Transactions"."Client ID");
                    ClientAccount.SetRange("Fund No","Client Transactions"."Fund Code");
                    if ClientAccount.FindFirst then
                      "Client Transactions"."Account No":=ClientAccount."Account No"
                    else
                      "Client Transactions"."Account No":="Client Transactions"."Client ID";
                    end

                    end
                end;
            }
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

    trigger OnPostXmlPort()
    begin
        Message('Completed');
    end;

    trigger OnPreXmlPort()
    begin
        window.Open('Inserting entry #1#######')
    end;

    var
        window: Dialog;
        ClientAccount: Record "Client Account";
}

