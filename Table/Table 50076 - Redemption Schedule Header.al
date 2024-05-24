table 50076 "Redemption Schedule Header"
{

    fields
    {
        field(1;"Schedule No";Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;

            trigger OnValidate()
            begin
                if "Schedule No" <> xRec."Schedule No" then begin
                  FundAdministrationSetup.Get;
                  NoSeriesManagement.TestManual(FundAdministrationSetup."Redemption Schedule Nos");
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
        field(6;"Total Amount";Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 4:4;
        }
        field(7;"Created By";Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = true;
            TableRelation = User;
        }
        field(8;"Created Date Time";DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(9;"Value Date";Date)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if "Value Date"<>0D then begin

                  Validatevaluedate
                end
            end;
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
        field(19;"Posted By";Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = User;
        }
        field(81;"Redemption Status";Option)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = 'Received,Confirmation,Posted,Rejected';
            OptionMembers = Received,Confirmation,Posted,Rejected;
        }
        field(82;"Line Total";Decimal)
        {
            CalcFormula = Sum("Redemption Schedule Lines"."Total Amount" WHERE ("Schedule Header"=FIELD("Schedule No")));
            DecimalPlaces = 4:4;
            Editable = false;
            FieldClass = FlowField;
        }
        field(83;"Fund Group";Code[40])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Fund Groups";
        }
        field(84;"Payment Option";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Employee only,Employee and Employer,Employer only, ';
            OptionMembers = "Employee only","Employee and Employer","Employer only"," ";
        }
        field(85;"Primary Document";Text[200])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            ExtendedDatatype = URL;
        }
        field(86;"Secondary Document";Text[200])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            ExtendedDatatype = URL;
        }
        field(87;"Other Document";Text[200])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            ExtendedDatatype = URL;
        }
    }

    keys
    {
        key(Key1;"Schedule No")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin

        if "Schedule No" = '' then begin
             FundAdministrationSetup.Get;
             FundAdministrationSetup.TestField(FundAdministrationSetup."Subscription Schedule Nos");
             NoSeriesManagement.InitSeries(FundAdministrationSetup."Subscription Schedule Nos",xRec."No. Series",0D,"Schedule No","No. Series");
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

    local procedure Validatevaluedate()
    var
        SubscriptionScheduleLines: Record "Subscription Schedule Lines";
    begin
        SubscriptionScheduleLines.Reset;
        SubscriptionScheduleLines.SetRange("Schedule Header","Schedule No");
        if SubscriptionScheduleLines.FindFirst then begin
          SubscriptionScheduleLines.SetValueDate("Value Date");
          SubscriptionScheduleLines.Validate("Employee Amount");
          SubscriptionScheduleLines.Validate("Employer Amount");
          SubscriptionScheduleLines.Modify;
        end;
    end;
}

