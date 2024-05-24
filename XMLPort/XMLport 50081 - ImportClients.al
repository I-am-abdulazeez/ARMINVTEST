xmlport 50081 ImportClients
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
                fieldelement(Fname;Client."First Name")
                {
                    FieldValidate = no;
                }
                fieldelement(sname;Client.Surname)
                {
                    FieldValidate = no;
                }
                fieldelement(mname;Client."Other Name/Middle Name")
                {
                    FieldValidate = no;
                }
                fieldelement(address;Client."Mailing Address")
                {
                }
                fieldelement(City;Client."City/Town")
                {
                    FieldValidate = no;
                }
                fieldelement(Number;Client."Phone Number")
                {
                    FieldValidate = no;
                }
                fieldelement(Title;Client.Title)
                {
                    FieldValidate = no;
                }
                fieldelement(HseNumber;Client."House Number")
                {
                    FieldValidate = no;
                }
                fieldelement(Estate;Client."Premises/Estate")
                {
                }
                fieldelement(Country;Client.Country)
                {
                    FieldValidate = no;
                }
                fieldelement(AE;Client."Account Executive Code")
                {
                    FieldValidate = no;
                }
                fieldelement(State;Client.State)
                {
                    FieldValidate = no;
                }
                textelement(address2)
                {
                    XmlName = 'Address2';
                }
                fieldelement(DOB;Client."Date Of Birth")
                {
                    FieldValidate = no;
                }
                fieldelement(nation;Client.Nationality)
                {
                    FieldValidate = no;
                }
                fieldelement(occupation;Client."Business/Occupation")
                {
                    FieldValidate = no;
                }
                fieldelement(mothersname;Client."Mothers Maiden Name")
                {
                    FieldValidate = no;
                }
                fieldelement(gender;Client.Gender)
                {
                    FieldValidate = no;
                }
                fieldelement(maritalStatus;Client."Marital Status")
                {
                    FieldValidate = no;
                }
                fieldelement(PlaceofBrith;Client."Place of Birth")
                {
                    FieldValidate = no;
                }
                fieldelement(Sfanme;Client."Sponsor First Name")
                {
                }
                fieldelement(Slname;Client."Sponsor Last Name")
                {
                    FieldValidate = no;
                }
                fieldelement(Smname;Client."Sponsor Middle Names")
                {
                }
                fieldelement(Stitle;Client.SponsorTitle)
                {
                    FieldValidate = no;
                }
                fieldelement(IDtype;Client."Type of ID")
                {
                    FieldValidate = no;
                }
                fieldelement(idno;Client."ID Card Number")
                {
                    FieldValidate = no;
                }
                fieldelement(bvn;Client."BVN Number")
                {
                    FieldValidate = no;
                }
                textelement(cities)
                {
                    XmlName = 'cities';
                }
                fieldelement(Religion;Client.Religion)
                {
                    FieldValidate = no;
                }
                fieldelement(NIN;Client.NIN)
                {
                }
                fieldelement(email;Client."E-Mail")
                {
                    FieldValidate = no;
                }
                fieldelement(Type;Client."Client Type")
                {
                    FieldValidate = no;
                }
                fieldelement(bankacc;Client."Bank Account Number")
                {
                    MinOccurs = Zero;
                }
                fieldelement(Bank;Client."Bank Code")
                {
                    MinOccurs = Zero;
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
        window.Close;
    end;

    trigger OnPreXmlPort()
    begin
        window.Open('uploading client #1#####');
    end;

    var
        window: Dialog;
}

