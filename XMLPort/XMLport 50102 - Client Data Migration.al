xmlport 50102 "Client Data Migration"
{
    Format = VariableText;

    schema
    {
        textelement(root)
        {
            tableelement(Client;Client)
            {
                AutoUpdate = true;
                XmlName = 'client';
                fieldelement(ID;Client."Membership ID")
                {
                }
                fieldelement(name;Client.Name)
                {
                    FieldValidate = no;
                }
                fieldelement(email;Client."E-Mail")
                {
                    FieldValidate = no;
                }
                fieldelement(Number;Client."Phone Number")
                {
                    FieldValidate = no;
                }
                fieldelement(accountN0;Client."Bank Account Number")
                {
                }
                fieldelement(bvn;Client."BVN Number")
                {
                    FieldValidate = no;
                }
                fieldelement(DOB;Client."Date Of Birth")
                {
                    FieldValidate = no;
                }
                fieldelement(Fname;Client."First Name")
                {
                    FieldValidate = no;
                }
                fieldelement(gender;Client.Gender)
                {
                    FieldValidate = no;
                }
                fieldelement(address;Client."Mailing Address")
                {
                }
                fieldelement(mname;Client."Other Name/Middle Name")
                {
                    FieldValidate = no;
                }
                fieldelement(sname;Client.Surname)
                {
                    FieldValidate = no;
                }

                trigger OnAfterInsertRecord()
                begin
                    window.Update(1,Client."Membership ID");
                end;

                trigger OnBeforeInsertRecord()
                begin
                    Client."Created Dates":=Today;
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
        window.Close;
    end;

    trigger OnPreXmlPort()
    begin
        window.Open('uploading client #1#####');
    end;

    var
        window: Dialog;
}

