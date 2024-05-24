table 50062 "Unit Switch Header"
{

    fields
    {
        field(1;"Transaction No";Code[20])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if "Transaction No" <> xRec."Transaction No" then begin
                  FundAdministrationSetup.Get;
                  NoSeriesManagement.TestManual(FundAdministrationSetup."Unit Switch Nos");
                   "No. Series" := '';
                end;
            end;
        }
        field(2;Narration;Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(3;"Main Account";Code[40])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Client Account";

            trigger OnValidate()
            begin
                Validateaccount
            end;
        }
        field(4;"CLient ID";Code[40])
        {
            DataClassification = ToBeClassified;
            TableRelation = Client;

            trigger OnValidate()
            begin
                Validateaccount
            end;
        }
        field(5;"Client Name";Text[200])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(7;"Created By";Code[100])
        {
            DataClassification = ToBeClassified;
            TableRelation = User;
        }
        field(8;"Created Date Time";DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(9;"Value Date";Date)
        {
            DataClassification = ToBeClassified;
        }
        field(10;"Transaction Date";Date)
        {
            DataClassification = ToBeClassified;
        }
        field(11;"No. Series";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(16;Posted;Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(17;"Date Posted";Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(18;"Time Posted";Time)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(19;"Posted By";Code[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = User;
        }
        field(81;"Switch Status";Option)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = 'Received,Confirmation,Posted,Rejected';
            OptionMembers = Received,Confirmation,Posted,Rejected;
        }
        field(82;"Line Total";Decimal)
        {
            CalcFormula = Sum("Unit Switch Lines".Amount WHERE ("Header No"=FIELD("Transaction No")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(83;"Fund Group";Code[40])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Fund Groups";
        }
    }

    keys
    {
        key(Key1;"Transaction No")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin

        if "Transaction No" = '' then begin
             FundAdministrationSetup.Get;
             FundAdministrationSetup.TestField(FundAdministrationSetup."Unit Switch Nos");
             NoSeriesManagement.InitSeries(FundAdministrationSetup."Unit Switch Nos",xRec."No. Series",0D,"Transaction No","No. Series");
          end;


        "Value Date":=Today;
        "Transaction Date":=Today;
        "Created By":=UserId;
        "Created Date Time":=CurrentDateTime;
    end;

    var
        FundAdministrationSetup: Record "Fund Administration Setup";
        NoSeriesManagement: Codeunit NoSeriesManagement;
        Client: Record Client;
        ClientAccount: Record "Client Account";

    local procedure Validateaccount()
    begin
        /*IF ClientAccount.GET("Main Account") THEN BEGIN
        "CLient ID":=ClientAccount."Client ID";
        */
        if Client.Get("CLient ID") then
        "Client Name":=Client.Name
         else begin
        "CLient ID":='';
        "Client Name":='';
        
        end

    end;
}

