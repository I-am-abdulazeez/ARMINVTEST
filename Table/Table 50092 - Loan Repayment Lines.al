table 50092 "Loan Repayment Lines"
{
    // version THL-LOAN-1.0.0

    DrillDownPageID = "Loan Repayment Lines";
    LookupPageID = "Loan Repayment Lines";

    fields
    {
        field(1;"Header No";Text[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Loan Repayment Header".Code;
        }
        field(2;"Line No.";Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(3;"Pers. No.";Code[20])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if Clients.Get(LoanMgt.GetClientNoFromStaffID("Pers. No.")) then begin
                "DB Name" := Clients.Surname+' '+Clients."First Name"+' '+Clients."Other Name/Middle Name";
                if "Last Name and First Name" = '' then
                  "Last Name and First Name" := "DB Name";
                end else
                Error('There is no client by the number %1 on the system!',"Pers. No.");

                Schedule.Reset;
                Schedule.SetRange("Client No.",LoanMgt.GetClientNoFromStaffID("Pers. No."));
                Schedule.SetRange(Settled,false);
                if Schedule.FindFirst then begin
                  "Loan No." := Schedule."Loan No.";
                  "Sheduled Repayment Date" := Schedule."Repayment Date";
                  "Applies To Loan" := Schedule."Loan No.";
                  "Principal Amount Due" := Schedule."Principal Due";
                  "Interest Amount Due" := Schedule."Interest Due";
                  if "Total Payment" < Schedule."Total Due" then
                    "Total Payment" := Schedule."Total Due";
                end;

                Validate("Total Payment");
            end;
        }
        field(4;"Last Name and First Name";Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(5;Concept;Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(6;"Total Payment";Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                Validate(Application);
            end;
        }
        field(7;"DB Name";Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(8;Application;Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Apply to Interest First,Apply to Principal Only';
            OptionMembers = "Apply to Interest First","Apply to Principal Only";

            trigger OnValidate()
            begin
                if Application = Application::"Apply to Interest First" then begin
                  if ("Interest Amount Due" < "Total Payment") or ("Interest Amount Due" = "Total Payment") then begin
                    "Interest Applied" := "Interest Amount Due";
                    "Principal Applied" := "Total Payment" - "Interest Amount Due";
                  end else begin
                    "Interest Applied" := "Interest Amount Due" - "Total Payment";
                    "Principal Applied" := 0;
                  end;
                end else begin
                  "Interest Applied" := 0;
                  "Principal Applied" := "Total Payment";
                  if "Valuation Date" = 0D then
                   Error('Valuation Date must be specified.');
                end;
            end;
        }
        field(9;"Principal Applied";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(10;"Interest Applied";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(11;Date;Date)
        {
            DataClassification = ToBeClassified;
        }
        field(12;"Applies To Loan";Code[20])
        {
            DataClassification = ToBeClassified;

            trigger OnLookup()
            begin
                Schedule.Reset;
                Schedule.SetRange("Client No.",LoanMgt.GetClientNoFromStaffID("Pers. No."));
                Schedule.SetRange(Settled,false);
                if PAGE.RunModal(PAGE::"Loan Repayment Schedule",Schedule) = ACTION::LookupOK then begin
                  "Loan No." := Schedule."Loan No.";
                  "Sheduled Repayment Date" := Schedule."Repayment Date";
                  "Applies To Loan" := Schedule."Loan No.";
                  "Principal Amount Due" := Schedule."Principal Due";
                  "Interest Amount Due" := Schedule."Interest Due";
                  if "Total Payment" <> 0 then
                    if Confirm('The total payment is already captured as '+Format("Total Payment")+'. Do wish to overwrite this with the one from the loan repayment schedule?') = true then
                    "Total Payment" := Schedule."Total Due";
                end;

                Validate("Total Payment");
            end;

            trigger OnValidate()
            begin
                Validate("Total Payment");
            end;
        }
        field(13;"Principal Amount Due";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(14;"Interest Amount Due";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(15;"Loan No.";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(16;"Sheduled Repayment Date";Date)
        {
            DataClassification = ToBeClassified;
        }
        field(17;Posted;Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(18;Received;Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = true;
            Enabled = true;
        }
        field(19;"Valuation Date";Date)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"Header No","Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Clients: Record Client;
        Schedule: Record "Loan Repayment Schedule";
        LoanMgt: Codeunit "Loan Management";
}

