table 50118 "Fund Transfer Header"
{

    fields
    {
        field(1;No;Code[20])
        {
            DataClassification = ToBeClassified;
            NotBlank = false;

            trigger OnValidate()
            begin
                if No <> xRec.No then begin
                  FundAdministrationSetup.Get;
                  NoSeriesMgt.TestManual(FundAdministrationSetup."Fund Transfer Nos");
                end;
            end;
        }
        field(2;"Value Date";Date)
        {
            DataClassification = ToBeClassified;
        }
        field(3;"Transaction Date";Date)
        {
            DataClassification = ToBeClassified;
        }
        field(4;Type;Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Same Fund,Across Funds';
            OptionMembers = "Same Fund","Across Funds";

            trigger OnValidate()
            begin
                //VALIDATE("To Account No",'');
            end;
        }
        field(5;Remarks;Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(6;"Fund Transfer Status";Option)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = 'Received,ARM Registrar,External Registrar,Rejected,Verified,Posted';
            OptionMembers = Received,"ARM Registrar","External Registrar",Rejected,Verified,Posted;
        }
        field(7;"Date Sent to Reg";DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(8;"Data Source";Text[30])
        {
            DataClassification = ToBeClassified;
            Editable = true;
        }
        field(9;"Transfer Type";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Part,Full';
            OptionMembers = "Part",Full;

            trigger OnValidate()
            begin
                // /
            end;
        }
        field(10;Comments;Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(11;"Created By";Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = User;
        }
        field(12;"Creation Date";Date)
        {
            DataClassification = ToBeClassified;
        }
        field(13;"Document Link";Text[250])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(36;Select;Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                //"Selected By":=USERID;
            end;
        }
        field(37;"No. Series";Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;No)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin

        if No = '' then begin
             FundAdministrationSetup.Get;
             FundAdministrationSetup.TestField(FundAdministrationSetup."Batch Fund Transfer Nos");
             NoSeriesMgt.InitSeries(FundAdministrationSetup."Batch Fund Transfer Nos",xRec."No. Series",0D,No,"No. Series");
          end;

        if "Data Source"<>'IMPORTED' then
           "Value Date":=Today;
        "Transaction Date":=Today;
        "Created By":=UserId;
        "Creation Date":=Today;
        //FundAdministration.InsertFundTransferTracker("Fund Transfer Status",No);
    end;

    var
        FundAdministrationSetup: Record "Fund Administration Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        FundRec: Record Fund;
        ClientAccount: Record "Client Account";
        Client: Record Client;
        FundAdministration: Codeunit "Fund Administration";
        TransactType: Option Subscription,Redemption,Dividend;
        ClientAdministration: Codeunit "Client Administration";
        Restrictiontype: Option "No Restrictions","Restrict Subscription","Restrict Redemption","Restrict Both";
        Fund: Record Fund;
        NAVBAL: Decimal;

    local procedure ValidateFromaccount()
    begin
        // IF ClientAccount.GET("Document Link") THEN BEGIN
        // //"From Client ID":=ClientAccount."Client ID";
        // IF ClientAdministration.CheckifResctrictionExists("Document Link",1,Restrictiontype::"Restrict Redemption") THEN
        //  ERROR('There is are a restriction on this account that Restricts Redemption');
        // VALIDATE("From Fund Code",ClientAccount."Fund No");
        // "From Fund Sub Account":=ClientAccount."Fund Sub Account";
        // IF Client.GET("From Client ID") THEN
        // "From Client Name":=Client.Name;
        // "Street Address":=Client."Mailing Address";
        // "Phone No":=FORMAT(Client."Phone Number");
        // "E-mail":=Client."E-Mail";
        // "Agent Code":=Client."Account Executive Code";
        // Remarks:='Unit Transfer From '+"Document Link"+ ' To '+"To Account No";
        // END ELSE BEGIN
        // "From Client ID":='';
        // "From Fund Code":='';
        // "From Fund Sub Account":='';
        // "From Client Name":='';
        // "Street Address":='';
        // "Phone No":='';
        // "E-mail":='';
        // "Agent Code":='';
        //
        // END
    end;

    local procedure ValidateAmount()
    begin
        // TESTFIELD("Document Link");
        // TESTFIELD("To Account No");
        // IF Amount<>0 THEN BEGIN
        // "Price Per Unit":=FundAdministration.GetFundPrice("From Fund Code","Value Date",TransactType::Redemption);
        // "No. Of Units":=FundAdministration.GetFundNounits("From Fund Code","Value Date",Amount,TransactType::Redemption);
        // //Maxwell: Unit Transfer Charges BEGIN
        // IF (("To Fund Code" <> 'ARMMMF') AND (Type <> Type::"Same Fund")) THEN BEGIN
        //  "Fee Amount" := FundAdministration.GetFee("From Fund Code",Amount);
        //  "Fee Units" := FundAdministration.GetFundNounits("From Fund Code","Value Date","Fee Amount",TransactType::Redemption);
        // END;
        // //END
        // CALCFIELDS("Current Unit Balance");
        // IF ("No. Of Units">"Current Unit Balance") OR ("Transfer Type"="Transfer Type"::"1") THEN BEGIN
        //  "No. Of Units":="Current Unit Balance";
        //  "Transfer Type":="Transfer Type"::"1";
        //  Amount:="Current Unit Balance"*"Price Per Unit";
        //  "Unit Balance after Redmption":=0;
        // END ELSE BEGIN
        //  "Unit Balance after Redmption":="Current Unit Balance"-"No. Of Units"-"Fee Units";
        //   IF Fund.GET("From Fund Code") THEN ;
        //  NAVBAL:="Unit Balance after Redmption"*"Price Per Unit";
        //  IF NAVBAL<Fund."Minimum Holding Balance" THEN BEGIN
        //   "Transfer Type":="Transfer Type"::"1";
        //  "No. Of Units":="Current Unit Balance";
        //  Amount:="Current Unit Balance"*"Price Per Unit";
        //  "Unit Balance after Redmption":=0;
        //  END
        // END;
        // "To Price Per Unit":=FundAdministration.GetFundPrice("To Fund Code","Value Date",TransactType::Subscription);
        // "To No. Of Units":=FundAdministration.GetFundNounits("To Fund Code","Value Date",Amount,TransactType::Subscription);
        // END;
        // IF "Transfer Type"="Transfer Type"::"1" THEN BEGIN
        //  //Maxwell: Added Fee Amount to the codes below --01/02/2020
        //  "Total Amount Payable":=Amount+"Accrued Dividend";
        //  "Net Amount Payable" := Amount+"Accrued Dividend"-"Fee Amount";
        // END ELSE BEGIN
        // "Total Amount Payable":=Amount+"Fee Amount";
        // "Net Amount Payable":= Amount;
        // END;
    end;

    local procedure ValidateToaccount()
    var
        FundBankAccounts: Record "Fund Bank Accounts";
    begin
        // IF ClientAccount.GET("To Account No") THEN BEGIN
        // "To Client ID":=ClientAccount."Client ID";
        // IF ClientAdministration.CheckifResctrictionExists("To Account No",1,Restrictiontype::"Restrict Redemption") THEN
        //  ERROR('There is are a restriction on this account that Restricts Redemption');
        // VALIDATE("To Fund Code",ClientAccount."Fund No");
        // "To Fund Sub Account":=ClientAccount."Fund Sub Account";
        // IF Client.GET("To Client ID") THEN
        // "To Client Name":=Client.Name;
        // Remarks:='Unit Transfer From '+"Document Link"+ ' To '+"To Account No";
        // IF Type=Type::"Across Funds" THEN BEGIN
        // FundBankAccounts.RESET;
        // FundBankAccounts.SETRANGE("Fund Code","To Fund Code");
        // FundBankAccounts.SETRANGE("Transaction Type",FundBankAccounts."Transaction Type"::Subscription);
        // IF FundBankAccounts.FINDFIRST THEN BEGIN
        // "Data Source":=FundBankAccounts."Bank Code";
        // "Bank Account No":=FundBankAccounts."Bank Account No";
        // "Bank Account Name":=FundBankAccounts."Bank Account Name";
        //
        // END
        //
        // END
        //
        // END ELSE BEGIN
        // "To Client ID":='';
        // "To Fund Code":='';
        // "To Fund Sub Account":='';
        // "To Client Name":='';
        //
        // END
    end;

    local procedure ValidateUnits()
    begin
        // TESTFIELD("Document Link");
        // TESTFIELD("To Account No");
        //
        // CALCFIELDS("Current Unit Balance");
        // IF "Transfer Type"="Transfer Type"::"1" THEN
        // "No. Of Units":="Current Unit Balance";
        // IF "No. Of Units"<>0 THEN BEGIN
        // "Price Per Unit":=FundAdministration.GetFundPrice("From Fund Code","Value Date",TransactType::Redemption);
        // Amount:="No. Of Units"*"Price Per Unit";
        //
        // IF "No. Of Units">"Current Unit Balance" THEN BEGIN
        //  "No. Of Units":="Current Unit Balance";
        //  "Transfer Type":="Transfer Type"::"1";
        //  Amount:="Current Unit Balance"*"Price Per Unit";
        //  "Unit Balance after Redmption":=0;
        // END ELSE BEGIN
        //  "Unit Balance after Redmption":="Current Unit Balance"-"No. Of Units"-"Fee Units";
        //
        //  //Maxwell: Unit Transfer Charges BEGIN
        //  IF (("To Fund Code" <> 'ARMMMF') AND (Type <> Type::"Same Fund")) THEN BEGIN
        //    "Fee Amount" := FundAdministration.GetFee("From Fund Code",Amount);
        //    "Fee Units" := FundAdministration.GetFundNounits("From Fund Code","Value Date","Fee Amount",TransactType::Redemption);
        //  END;
        //  //END
        //
        //   Fund.RESET;
        //  IF Fund.GET("From Fund Code") THEN ;
        //  NAVBAL:="Unit Balance after Redmption"*"Price Per Unit";
        //  IF NAVBAL<Fund."Minimum Holding Balance" THEN BEGIN
        //   "Transfer Type":="Transfer Type"::"1";
        //  "No. Of Units":="Current Unit Balance";
        //  Amount:="Current Unit Balance"*"Price Per Unit";
        //  "Unit Balance after Redmption":=0;
        //  END
        // END;
        // "To Price Per Unit":=FundAdministration.GetFundPrice("To Fund Code","Value Date",TransactType::Subscription);
        // "To No. Of Units":=FundAdministration.GetFundNounits("To Fund Code","Value Date",Amount,TransactType::Subscription);
        //
        // END;
        //
        // IF "Transfer Type"="Transfer Type"::"1" THEN BEGIN
        //  //Maxwell: Added Fee Amount
        //  "Total Amount Payable":=Amount+"Accrued Dividend";
        //  "Net Amount Payable" := Amount+"Accrued Dividend"-"Fee Amount";
        // END ELSE BEGIN
        // "Total Amount Payable":=Amount+"Fee Amount";
        // "Net Amount Payable" := Amount;
        // END;
    end;
}

