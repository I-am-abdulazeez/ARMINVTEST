table 415 "IC Outbox Jnl. Line"
{
    // version NAVW18.00

    Caption = 'IC Outbox Jnl. Line';

    fields
    {
        field(1;"Transaction No.";Integer)
        {
            Caption = 'Transaction No.';
            Editable = false;
        }
        field(2;"IC Partner Code";Code[20])
        {
            Caption = 'IC Partner Code';
            Editable = false;
            TableRelation = "IC Partner".Code;
        }
        field(3;"Line No.";Integer)
        {
            Caption = 'Line No.';
            Editable = false;
        }
        field(4;"Account Type";Option)
        {
            Caption = 'Account Type';
            OptionCaption = 'G/L Account,Customer,Vendor,IC Partner';
            OptionMembers = "G/L Account",Customer,Vendor,"IC Partner";
        }
        field(5;"Account No.";Code[20])
        {
            Caption = 'Account No.';
            TableRelation = IF ("Account Type"=CONST("G/L Account")) "IC G/L Account"
                            ELSE IF ("Account Type"=CONST(Customer)) Customer
                            ELSE IF ("Account Type"=CONST(Vendor)) Vendor
                            ELSE IF ("Account Type"=CONST("IC Partner")) "IC Partner";

            trigger OnValidate()
            var
                Customer: Record Customer;
                Vendor: Record Vendor;
            begin
                if ("Account No." <> xRec."Account No.") and ("Account No." <> '') then
                  case "Account Type" of
                    "Account Type"::"IC Partner":
                      TestField("Account No.","IC Partner Code");
                    "Account Type"::Customer:
                      begin
                        Customer.Get("Account No.");
                        Customer.TestField("IC Partner Code","IC Partner Code");
                      end;
                    "Account Type"::Vendor:
                      begin
                        Vendor.Get("Account No.");
                        Vendor.TestField("IC Partner Code","IC Partner Code");
                      end;
                  end;
            end;
        }
        field(6;Amount;Decimal)
        {
            Caption = 'Amount';
            Editable = false;
        }
        field(7;Description;Text[50])
        {
            Caption = 'Description';
        }
        field(8;"VAT Amount";Decimal)
        {
            Caption = 'VAT Amount';
            Editable = false;
        }
        field(9;"Currency Code";Code[10])
        {
            AccessByPermission = TableData Currency=R;
            Caption = 'Currency Code';
            Editable = false;
        }
        field(11;"Due Date";Date)
        {
            Caption = 'Due Date';
        }
        field(12;"Payment Discount %";Decimal)
        {
            Caption = 'Payment Discount %';
            DecimalPlaces = 0:5;
            MaxValue = 100;
            MinValue = 0;
        }
        field(13;"Payment Discount Date";Date)
        {
            Caption = 'Payment Discount Date';
        }
        field(14;Quantity;Decimal)
        {
            Caption = 'Quantity';
            Editable = false;
        }
        field(15;"Transaction Source";Option)
        {
            Caption = 'Transaction Source';
            Editable = false;
            OptionCaption = 'Rejected by Current Company,Created by Current Company';
            OptionMembers = "Rejected by Current Company","Created by Current Company";
        }
        field(16;"Document No.";Code[20])
        {
            Caption = 'Document No.';
            Editable = false;
        }
    }

    keys
    {
        key(Key1;"Transaction No.","IC Partner Code","Transaction Source","Line No.")
        {
        }
        key(Key2;"IC Partner Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        DimMgt: Codeunit DimensionManagement;
    begin
        DimMgt.DeleteICJnlDim(
          DATABASE::"IC Outbox Jnl. Line","Transaction No.","IC Partner Code","Transaction Source","Line No.");
    end;
}
