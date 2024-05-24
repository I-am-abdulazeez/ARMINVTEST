codeunit 50004 WebserviceFunctions
{

    trigger OnRun()
    begin
    end;

    var
        FundTransactionManagement: Codeunit "Fund Transaction Management";
        FundAdministrationSetup: Record "Fund Administration Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        NotificationFunctions: Codeunit "Notification Functions";
        subscription: Record Subscription;
        postedSubcription: Record "Posted Subscription";
        NoSeriesManagement: Codeunit NoSeriesManagement;

    procedure UpdateClient(ClientID: Code[40];FirstName: Text[50];LastName: Text[50];MiddleNames: Text[50];Addres: Text[250];Cityp: Text;Contct: Text;PhoneNo: Code[20];Titlep: Code[10];HouseNo: Code[10];Estate: Text;Countrys: Code[100];AccountManager: Code[20];Statep: Code[20];StreetName: Text[250];DateOfBirth: Date;Nationlity: Code[100];Occupationp: Text;MothersName: Text;Genderp: Option " ",Male,Female;Maritalstatus: Option " ",Single,Married,Divorced,Widowed;PlaceofBirth: Text;SponsorFname: Text;SponsorLname: Text;SponsorMname: Text;SponsTitle: Code[10];IdentificationType: Option Please_Select,Passport,"Driving Licence","ID Card","National ID Card","Voters Cards",Others;IdentificationNumber: Code[50];BVN: Code[20];Jurisdiction: Text;UsTaxNo: Text;IsPoliticallyExposed: Boolean;PoliticalInfo: Text;Religon: Code[20];NINp: Code[20];DiasporaClient: Boolean;ClientStatus: Option Active,Inactive,Closed;EmailNotification: Boolean;PostNotification: Boolean;OfficeNotification: Boolean;SmsNotification: Boolean;SocialMedia: Boolean;DateCreated: Date;Createdby: Code[50];Email: Text[100];ClientType: Option " ",Individual,Joint,Corporate,Minor;MainAccount: Code[40];IVNumber: Code[40];Source: Text): Boolean
    var
        Client: Record Client;
        ClientAccount: Record "Client Account";
        countries: Record "Country/Region";
    begin

        if Client.Get(ClientID) then begin
        with Client do begin
         if ClientType<>ClientType::" " then
            Validate("Client Type",ClientType);
          if FirstName<>'' then
            Validate("First Name",FirstName);
          if LastName<>'' then
            Validate(Surname,LastName);
          if  MiddleNames <>'' then
            Validate("Other Name/Middle Name",MiddleNames);
          if Addres<>'' then
            Validate("Mailing Address",Addres);
           if Country <>'' then
            Validate(Country,Countrys);
          if Cityp<>'' then
            Validate("City/Town",Cityp);
          if Contct <>'' then
            Validate(Contact,Contct);
          if PhoneNo<>'' then
            Validate("Phone Number",PhoneNo);
          if Titlep <>'' then
            Validate(Title,Titlep);
          if HouseNo <>'' then
            Validate("House Number",HouseNo);
          if Estate <>'' then
            Validate("Premises/Estate",Estate);
           if AccountManager<>'' then
            Validate("Account Executive Code",AccountManager);
          if Statep <>'' then
            Validate(State,Statep);
          if StreetName <>'' then
            Validate("Street Name",StreetName);
          if DateOfBirth<> 0D then
            Validate("Date Of Birth",DateOfBirth);
          if Nationlity<>'' then
            Validate(Nationality,Nationlity);
          if Occupationp <>'' then
            Validate("Business/Occupation",Occupationp);
          if MothersName <>'' then
            Validate("Mothers Maiden Name",MothersName);
          if Genderp<>Genderp::" " then
            Validate(Gender,Genderp);
          if Maritalstatus<>Maritalstatus::" " then
            Validate("Marital Status",Maritalstatus);
          if PlaceofBirth<>'' then
            Validate("Place of Birth",PlaceofBirth);
          if ClientType=ClientType::Minor then begin
            if SponsorFname<>'' then
              Validate("Sponsor First Name",SponsorFname);
            if SponsorLname <>'' then
              Validate("Sponsor Last Name",SponsorLname);
            if SponsorMname <>'' then
              Validate("Sponsor Middle Names",SponsorMname);

          if SponsTitle <>'' then
            Validate(SponsorTitle,SponsTitle);

         end;
          if IdentificationType<> IdentificationType::Please_Select then
            Validate("Type of ID",IdentificationType);
          if IdentificationType<>IdentificationType::Please_Select then
            Validate("ID Card Number",IdentificationNumber);
          if BVN<>'' then
            Validate("BVN Number",BVN);
          if Jurisdiction<>'' then
            Validate(Jurisdiction,Jurisdiction);
          if UsTaxNo<>'' then
            Validate("US Tax Number",UsTaxNo);
            Validate("Politically Exposed Persons",IsPoliticallyExposed);
          if PoliticalInfo<>'' then
            Validate("Political Information",PoliticalInfo);
          if Religon<>'' then
            Validate(Religion,Religon);
          if NINp <>'' then
            Validate(NIN,NINp);
            Validate("Diaspora Client",DiasporaClient);

            Validate("Account Status",ClientStatus);
           // VALIDATE("Email Notification",EmailNotification);
           // VALIDATE("Post Notification",PostNotification);
           // VALIDATE("Office Notification",OfficeNotification);
            //VALIDATE("SMS Notification",SmsNotification);
          if Email<>'' then
            Validate("E-Mail",Email);

          "Last Update Source":=Source;
           if MainAccount<>'' then
            Validate("Main Account",MainAccount);
           if IVNumber <>'' then
            Validate("IV Number",IVNumber);
            "Last Modified By":=UserId;
          "Last Modified DateTime":=CurrentDateTime;

           Modify(true);
        ClientAccount.Reset;
        ClientAccount.SetRange("Client ID",Client."Membership ID");
        if ClientAccount.FindFirst then
          repeat
            ClientAccount.Validate("Client ID");
            ClientAccount.Modify;
          until ClientAccount.Next=0;

             exit(true)


          end
        end else
        Error('Client Does not Exist');
    end;

    procedure CreateClient(ClientID: Code[40];FirstName: Text[50];LastName: Text[50];MiddleNames: Text[50];Address: Text[250];City: Text;Contct: Text;PhoneNo: Code[20];Title: Code[10];HouseNo: Code[10];Estate: Text;Countrys: Code[100];AccountManager: Code[20];States: Code[20];StreetName: Text[250];DateOfBirth: Date;Nationlity: Code[100];Occupation: Text;MothersName: Text;Genderp: Option " ",Male,Female;Maritalstatus: Option " ",Single,Married,Divorced,Widowed;PlaceofBirth: Text;SponsorFname: Text;SponsorLname: Text;SponsorMname: Text;SponsTitle: Code[10];IdentificationType: Option Please_Select,Passport,"Driving Licence","ID Card","National ID Card","Voters Cards",Others;IdentificationNumber: Code[50];BVN: Code[20];Jurisdiction: Text;UsTaxNo: Text;IsPoliticallyExposed: Boolean;PoliticalInfo: Text;Religon: Code[20];NINp: Code[20];DiasporaClient: Boolean;ClientStatus: Option Active,Inactive,Closed;EmailNotification: Boolean;PostNotification: Boolean;OfficeNotification: Boolean;SmsNotification: Boolean;SocialMedia: Boolean;DateCreated: Date;Createdby: Code[50];Email: Text[100];ClientType: Option " ",Individual,Joint,Corporate,Minor;MainAccount: Code[40];IVNumber: Code[40];Source: Text): Boolean
    var
        Client: Record Client;
        Titlep: Code[100];
    begin
         if Countrys='' then Countrys:='NIGERIA';
         Titlep:=Title;
         if Client.Get(ClientID) then
           Error('Client already Exist');
        with Client do begin
          Init;
          "Membership ID":=ClientID;
          Validate("Client Type",ClientType);
          Validate("First Name",FirstName);
          Validate(Surname,LastName);
          Validate("Other Name/Middle Name",MiddleNames);
          Validate("Mailing Address",Address);
          Validate(Country,Countrys);
          Validate("City/Town",City);
          Validate(Contact,Contct);
          Validate("Phone Number",PhoneNo);
          Validate(Title,Titlep);
          Validate("House Number",HouseNo);
          Validate("Premises/Estate",Estate);
        
          Validate(State,States);
          Validate("Street Name",StreetName);
          Validate("Date Of Birth",DateOfBirth);
          Validate(Nationality,Nationlity);
          Validate("Business/Occupation",Occupation);
          Validate("Mothers Maiden Name",MothersName);
          Validate(Gender,Genderp);
          Validate("Marital Status",Maritalstatus);
          Validate("Place of Birth",PlaceofBirth);
           if ClientType=ClientType::Minor then begin
          Validate("Sponsor First Name",SponsorFname);
          Validate("Sponsor Last Name",SponsorLname);
          Validate("Sponsor Middle Names",SponsorMname);
          Validate(SponsorTitle,SponsTitle);
          end;
          Validate("Type of ID",IdentificationType);
          if IdentificationType<>IdentificationType::Please_Select then
            "ID Card Number":=IdentificationNumber;
        
            Validate("Account Executive Code",AccountManager);
          Validate("BVN Number",BVN);
          Validate(Jurisdiction,Jurisdiction);
          Validate("US Tax Number",UsTaxNo);
          Validate("Politically Exposed Persons",IsPoliticallyExposed);
          Validate("Political Information",PoliticalInfo);
          Validate(Religion,Religon);
          Validate(NIN,NINp);
          Validate("Diaspora Client",DiasporaClient);
          Validate("Account Status",ClientStatus);
            Validate("E-Mail",Email);
          Validate("Email Notification",EmailNotification);
          Validate("Post Notification",PostNotification);
          Validate("Office Notification",OfficeNotification);
          Validate("SMS Notification",SmsNotification);
          Validate("Created Dates",DateCreated);
          Validate("Created By User ID",Createdby);
        
          Validate("Main Account",MainAccount);
          Validate("IV Number",IVNumber);
          "Last Update Source":=Source;
          "Last Modified By":=UserId;
          "Last Modified DateTime":=CurrentDateTime;
          "Account Status":="Account Status"::Active;
          Insert(true);
             exit(true)
         /*  ELSE
             EXIT(FALSE);*/
        
        
        end
        
        //The CreateClient code above was changed to the one below after request was made to increase length of characters for country on 10/05/2019.
        /*
        CreateClient(ClientID : Code[40];FirstName : Text[50];LastName : Text[50];MiddleNames : Text[50];Address : Text[250];City : Text;Contct : Text;PhoneNo : Code[20];Title : Code[10];HouseNo : Code[10];Estate : Text;Countrys : Code[10];AccountManager :
         IF Countrys='' THEN Countrys:='NIGERIA';
         Titlep:=Title;
         IF Client.GET(ClientID) THEN
           ERROR('Client already Exist');
        WITH Client DO BEGIN
          INIT;
          "Membership ID":=ClientID;
          VALIDATE("Client Type",ClientType);
          VALIDATE("First Name",FirstName);
          VALIDATE(Surname,LastName);
          VALIDATE("Other Name/Middle Name",MiddleNames);
          VALIDATE("Mailing Address",Address);
          VALIDATE(Country,Countrys);
          VALIDATE("City/Town",City);
          VALIDATE(Contact,Contct);
          VALIDATE("Phone Number",PhoneNo);
          VALIDATE(Title,Titlep);
          VALIDATE("House Number",HouseNo);
          VALIDATE("Premises/Estate",Estate);
        
          VALIDATE(State,States);
          VALIDATE("Street Name",StreetName);
          VALIDATE("Date Of Birth",DateOfBirth);
          VALIDATE(Nationality,Nationlity);
          VALIDATE("Business/Occupation",Occupation);
          VALIDATE("Mothers Maiden Name",MothersName);
          VALIDATE(Gender,Genderp);
          VALIDATE("Marital Status",Maritalstatus);
          VALIDATE("Place of Birth",PlaceofBirth);
           IF ClientType=ClientType::Minor THEN BEGIN
          VALIDATE("Sponsor First Name",SponsorFname);
          VALIDATE("Sponsor Last Name",SponsorLname);
          VALIDATE("Sponsor Middle Names",SponsorMname);
          VALIDATE(SponsorTitle,SponsTitle);
          END;
          VALIDATE("Type of ID",IdentificationType);
          IF IdentificationType<>IdentificationType::Please_Select THEN
            "ID Card Number":=IdentificationNumber;
        
            VALIDATE("Account Executive Code",AccountManager);
          VALIDATE("BVN Number",BVN);
          VALIDATE(Jurisdiction,Jurisdiction);
          VALIDATE("US Tax Number",UsTaxNo);
          VALIDATE("Politically Exposed Persons",IsPoliticallyExposed);
          VALIDATE("Political Information",PoliticalInfo);
          VALIDATE(Religion,Religon);
          VALIDATE(NIN,NINp);
          VALIDATE("Diaspora Client",DiasporaClient);
          VALIDATE("Account Status",ClientStatus);
            VALIDATE("E-Mail",Email);
          VALIDATE("Email Notification",EmailNotification);
          VALIDATE("Post Notification",PostNotification);
          VALIDATE("Office Notification",OfficeNotification);
          VALIDATE("SMS Notification",SmsNotification);
          VALIDATE("Created Dates",DateCreated);
          VALIDATE("Created By User ID",Createdby);
        
          VALIDATE("Main Account",MainAccount);
          VALIDATE("IV Number",IVNumber);
          "Last Update Source":=Source;
          "Last Modified By":=USERID;
          "Last Modified DateTime":=CURRENTDATETIME;
          "Account Status":="Account Status"::Active;
          INSERT(TRUE);
             EXIT(TRUE)
         {  ELSE
             EXIT(FALSE);}
        
        
        END
        */

    end;

    procedure ChangeCLientStatus(ClientID: Code[50];NewStatus: Option Active,Inactive,Closed;Source: Text): Boolean
    var
        client: Record Client;
    begin
        if client.Get(ClientID) then begin
          client."Account Status":=NewStatus;
          client."Last Update Source":=Source;
          client."Last Modified By":=UserId;
          client."Last Modified DateTime":=CurrentDateTime;
          if client.Modify then
             exit(true)
           else
             exit(false);
        end
    end;

    procedure CreateClientAccountBackup(ClientID: Code[50];ReferrerMembershipID: Code[50];FundCode: Code[40];BankCode: Code[30];BankBranch: Code[30];BankAccName: Text;BankAccountNo: Code[50];KYCTier: Code[20];DividendMandate: Option " ",Payout,Reinvest;Source: Text;PayDay: Boolean;ForeignBankName: Code[50];SwiftCode: Code[50];RoutingNo: Code[50];FinalCredit: Code[50];BeneficiaryAccountNo: Code[50]): Code[40]
    var
        ClientAccount: Record "Client Account";
    begin
        with ClientAccount do begin
          Validate("Client ID",ClientID);

          Insert;
          Validate("Pay Day",PayDay);
          Validate("Fund No",FundCode);
          Validate("Bank Code",BankCode);
          Validate("Bank Branch",BankBranch);
          Validate("Bank Account Name","Bank Account Name");
          Validate("Bank Account Number",BankAccountNo);
          Validate("KYC Tier",KYCTier);
          Validate("Dividend Mandate",DividendMandate);
          Validate("Referrer Membership ID",ReferrerMembershipID);
          //Maxwell: Modified for EUROBOND BEGIN
          "Foreign Bank Account" := ForeignBankName;
          "Swift Code" := SwiftCode;
          "Routing No" := RoutingNo;
          "Final Credit" := FinalCredit;
          "Benificiary Account Number" := BeneficiaryAccountNo;
        //END
          "Last Modified By":=UserId;
          "Last Modified DateTime":=CurrentDateTime;
          "Old Account Number":="Client ID";
          "Old MembershipID":="Client ID";
          "Account Status":="Account Status"::Active;
          if Modify(true) then
            exit("Account No")
          else
            exit('')

        end
    end;

    procedure UpdateClientAccountBackup(AccountNo: Code[50];ClientID: Code[50];FundCode: Code[40];BankCode: Code[30];BankBranch: Code[30];BankAccName: Text;BankAccountNo: Code[50];KYCTier: Code[20];DividendMandate: Option " ",Payout,Reinvest;Source: Text): Boolean
    var
        ClientAccount: Record "Client Account";
    begin
        //Maxwell: To update client account. Updated on 05072019
        if ClientAccount.Get(AccountNo) then begin
          ClientAccount.SetFilter("Account No",AccountNo);
          if ClientAccount.FindFirst then
            ClientAccount."Dividend Mandate" := DividendMandate;
            ClientAccount."Last update Source":=Source;
            ClientAccount."Last Modified By":=UserId;
            ClientAccount."Last Modified DateTime":=CurrentDateTime;
          if ClientAccount.Modify(true) then
            exit(true)
          else
            exit(false);
        end
        
        /*ClientAccount.GET(AccountNo);
        WITH ClientAccount DO BEGIN
        {  IF "Client ID"<>'' THEN
            VALIDATE("Client ID",ClientID);}
          IF FundCode<>'' THEN
            VALIDATE("Fund No",FundCode);
          IF BankCode <>'' THEN
            VALIDATE("Bank Code",BankCode);
          IF BankBranch <>'' THEN
            VALIDATE("Bank Branch",BankBranch);
          IF BankAccName <>'' THEN
           VALIDATE("Bank Account Name",BankAccName);
          IF BankAccountNo <>'' THEN
          VALIDATE("Bank Account Number",BankAccountNo);
          IF KYCTier <>'' THEN
          VALIDATE("KYC Tier",KYCTier);
          IF DividendMandate <> DividendMandate::" " THEN
            VALIDATE("Dividend Mandate",DividendMandate);
          "Last update Source":=Source;
          "Last Modified By":=USERID;
          "Last Modified DateTime":=CURRENTDATETIME;
          IF MODIFY(TRUE) THEN
            EXIT(TRUE)
          ELSE
            EXIT(FALSE);
        
        END*/

    end;

    procedure UpdateClientAccountStatus(AccountNo: Code[50];NewStatus: Option Created,Active,"In Active",Closed;Source: Text): Boolean
    var
        ClientAccount: Record "Client Account";
    begin
        if ClientAccount.Get(AccountNo) then begin
          ClientAccount."Account Status":=NewStatus;
          ClientAccount."Last update Source":=Source;
          ClientAccount."Last Modified By":=UserId;
          ClientAccount."Last Modified DateTime":=CurrentDateTime;
          if ClientAccount.Modify then
             exit(true)
           else
             exit(false);
        end
    end;

    procedure CreateCaution(ClientID: Code[50];AccountNo: Code[50];CautionType: Code[20];RestrictionType: Option "No Restrictions","Restrict Subscription","Restrict Redemption","Restrict Both";Requestor: Code[50];Approver: Code[50];Remarks: Text;Source: Text): Code[30]
    var
        ClientCautions: Record "Client Cautions";
    begin
        with ClientCautions do begin
          Init;
          Validate("Client ID",ClientID);
          Validate("Account No",AccountNo);
          Validate("Caution Type",CautionType);
          Validate("Restriction Type",RestrictionType);
          "Last Update Source":=Source;
          "Last Modified By":=UserId;
          "Last Modified DateTime":=CurrentDateTime;
          if Insert(true) then
            exit("Caution No")
          else
            exit('');
        end;
    end;

    procedure CreateLien(AccountNo: Code[50];LienAmount: Decimal;Source: Text): Code[30]
    var
        AccountLiens: Record "Account Liens";
        ClientManagementSetup: Record "Client Management Setup";
    begin
        AccountLiens.Reset;
        AccountLiens.SetRange("Account No",AccountNo);
        if AccountLiens.FindFirst then
          Error('Lien already exist on this account %1. If you want to create another lien on the same account, kindly update the existing records',AccountNo)
        else
          with AccountLiens do begin
            Init;
            Validate("Account No",AccountNo);
            Validate(Amount,LienAmount);
            if "Lien No" = '' then begin
              ClientManagementSetup.Get;
              ClientManagementSetup.TestField("Lien Nos");
              NoSeriesMgt.InitSeries(ClientManagementSetup."Lien Nos",'',0D,"Lien No","No. Series");
            end;
            "Last Update Source":=Source;
            "Last Modified By":=UserId;
            "Created Date Time" := CurrentDateTime;
            //"Last Modified DateTime":=CURRENTDATETIME;
            if Insert(true) then
              exit ("Lien No")
            else
              exit('');
          end;
    end;

    procedure CreateSubscription(Accountno: Code[50];BankAccountNo: Code[10];BankCode: Code[20];Amountsubscribed: Decimal;ValueDate: Date;Remarks: Text[250];IsReversal: Boolean;Source: Text;DirectPosting: Boolean;ReferenceCode: Text[100];Notes: Text[250]): Code[30]
    var
        Subscription: Record Subscription;
    begin
        with Subscription do begin
          Init;
          Subscription.Reset;
          Subscription.SetRange("Reference Code",ReferenceCode);
          if Subscription.FindFirst then
            Error('Reference Code already exist');
          postedSubcription.Reset;
          postedSubcription.SetRange("Reference Code",ReferenceCode);
          if postedSubcription.FindFirst then
            Error('Reference Code already exist');
        
          Validate("Account No",Accountno);
          Validate("Bank Account No",BankAccountNo);
          Validate("Bank Code",BankCode);
          Validate("Value Date",ValueDate);
          Validate(Amount,Amountsubscribed);
          Validate("Reference Code",ReferenceCode);
          Validate(Subscription.Remarks,Notes);
          "Data Source":=Source;
          "Direct Posting":=DirectPosting;
          "Creation Date" := CurrentDateTime;
        
        /*IF ("Fund Code" = 'ARMSTBF') OR ("Fund Code" = 'ARMFIF') OR ("Fund Code" = 'ARMEURO') THEN
            ERROR('This request will not be processed today because of reinvestment');*/
        
          if DirectPosting then begin
            "Subscription Status":="Subscription Status"::Confirmed;
            AutoMatched:=true;
          end;
          if Insert(true) then begin
          if DirectPosting then
            FundTransactionManagement.PostSTPSubscription(Subscription);
           exit(Subscription.No)
        
          end
          else
            exit('');
        
        end

    end;

    procedure CreateStatementLines(ValueDate: Date;TransDate: Date;Amount: Decimal;Narration: Text;Channel: Code[10];TransReferenceNo: Code[100];AccountNo: Code[40];MembershipID: Code[40];Fundcode: Code[40];BankCode: Code[20]): Integer
    var
        SubscriptionMatchingheader: Record "Subscription Matching header";
        SubscriptionMatchingLines: Record "Subscription Matching Lines";
        SubscriptionMatchingLines2: Record "Subscription Matching Lines";
        Lineno: Integer;
    begin
        SubscriptionMatchingheader.Reset;
        SubscriptionMatchingheader.SetRange("Value Date",ValueDate);
        SubscriptionMatchingheader.SetRange("Fund Code",Fundcode);
        SubscriptionMatchingheader.SetRange("Online Statement",true);
        SubscriptionMatchingheader.SetRange("Bank Code",BankCode);
        if not SubscriptionMatchingheader.FindFirst then begin
          SubscriptionMatchingheader.Init;
          SubscriptionMatchingheader."Fund Code":=Fundcode;
          SubscriptionMatchingheader."Value Date":=ValueDate;
          SubscriptionMatchingheader.Narration:='OnlineStatement';
          SubscriptionMatchingheader."Online Statement":=true;
          SubscriptionMatchingheader."Bank Code":=BankCode;
          SubscriptionMatchingheader.Posted:=true;
          SubscriptionMatchingheader."Posted By":=UserId;
          SubscriptionMatchingheader.Insert(true);
          end;
        SubscriptionMatchingLines2.Reset;
        SubscriptionMatchingLines2.SetRange("Header No",SubscriptionMatchingheader.No);
        if SubscriptionMatchingLines2.FindLast then
         Lineno:=SubscriptionMatchingLines2."Line No"
        else
          Lineno:=0;
        Lineno:=Lineno+1;
        SubscriptionMatchingLines.Init;
        SubscriptionMatchingLines."Header No":=SubscriptionMatchingheader.No;
        SubscriptionMatchingLines."Line No":=Lineno;
        SubscriptionMatchingLines.TransactionReference:=TransReferenceNo;
        SubscriptionMatchingLines."Transaction Date":=TransDate;
        SubscriptionMatchingLines."Value Date":=ValueDate;
        SubscriptionMatchingLines.Narration:=Narration;
        SubscriptionMatchingLines.Reference:=MembershipID;
        SubscriptionMatchingLines."Credit Amount":=Amount;
        SubscriptionMatchingLines.Posted:=true;
        SubscriptionMatchingLines."Posted By":=UserId;
        SubscriptionMatchingLines."Date Posted":=Today;
        SubscriptionMatchingLines."Time Posted":=Time;
        SubscriptionMatchingLines.Validate("Account No",AccountNo);
        SubscriptionMatchingLines.Matched:=true;
        SubscriptionMatchingLines.Channel:=Channel;
        SubscriptionMatchingLines."Fund Code":=Fundcode;
        SubscriptionMatchingLines.Insert;

        exit(Lineno);
    end;

    procedure CreateRedemptionBackup(Caseno: Code[40];AccountNo: Code[50];ValueDate: Date;RedemptionType: Option "Part",Full;AmountRedeem: Decimal;noofunits: Decimal;Source: Text;DocumentPath: Text;DocumentPath2: Text;Remarks: Text;IsReversal: Boolean;OnlineRedemption: Boolean): Code[30]
    var
        Redemption: Record Redemption;
        PostedRedemption: Record "Posted Redemption";
    begin
          if PostedRedemption.Get(Caseno) then
            Error('This Case No has already Been Processed');

        with Redemption do begin
          Init;
          Validate("Transaction No",Caseno);
          Validate("Account No",AccountNo);
          Validate("Value Date",ValueDate);
          Validate("Transaction Date",Today);
          Validate("Redemption Type",RedemptionType);
          if OnlineRedemption then
          Validate("Request Mode",Redemption."Request Mode"::Online);
         if RedemptionType=RedemptionType::Part then
          Validate(Amount,AmountRedeem);
          if "No. Of Units"<>0 then
          Validate("No. Of Units");
          "Data Source":=Source;
          "Document Path":=DocumentPath;
          "Document Link":="Document Path";
          "Document Path2":=DocumentPath2;
          "Creation Date" := CurrentDateTime;
           FundAdministrationSetup.Get;
              if (FundAdministrationSetup."CX Verification Threshold"<>0) and
                 (Redemption.Amount>FundAdministrationSetup."CX Verification Threshold") then begin
                  Redemption."Redemption Status":=Redemption."Redemption Status"::"Customer Experience Verification";
                  //Email Notification
                  NotificationFunctions.CreateNotificationEntry(0,UserId,CurrentDateTime,'Redemption',Redemption."Transaction No",
              Redemption."Client Name",Redemption."Client ID",'Customer Experience Verification',Redemption."Fund Code",Redemption."Account No",
          'Redemption',Redemption.Amount,1)
             end else
              Redemption."Redemption Status":=Redemption."Redemption Status"::"ARM Registrar";
              //Email Notification
              NotificationFunctions.CreateNotificationEntry(0,UserId,CurrentDateTime,'Redemption',Redemption."Transaction No",
              Redemption."Client Name",Redemption."Client ID",'ARM Registrar',Redemption."Fund Code",Redemption."Account No",
          'Redemption',Redemption.Amount,2);
            if OnlineRedemption then
              Redemption."Redemption Status":=Redemption."Redemption Status"::Verified;
              Redemption."For Verification" := true;

            //Maxwell: To set up Recon No from the end.
            if Redemption."Recon No" = '' then begin
              FundAdministrationSetup.TestField(FundAdministrationSetup."Recon Nos");
              NoSeriesMgt.InitSeries(FundAdministrationSetup."Recon Nos",'',0D,"Recon No","No. Series");
            end;

          Insert;
          //to uncomment for stp

          if OnlineRedemption then begin
            if (FundAdministrationSetup."Online Threshold"<>0) and (Redemption.Amount<=FundAdministrationSetup."Online Threshold") then begin
              //Maxwell: STP Threshold of 1,000,000 031120
              if CheckIfSTP(Redemption."Account No",Redemption."Value Date",Redemption.Amount) then begin
                  FundTransactionManagement.PostSingleRedmptionOnline(Redemption);
              //CHARGES
              if Redemption."Fund Code" = 'ARMMMF' then
                  FundTransactionManagement.InsertAccruedInterestCharge(Redemption."Account No",Redemption."Charges On Accrued Interest",Redemption."Fund Code",Redemption."Value Date");
              //END
              if PostedRedemption.Get(Caseno) then begin
                PostedRedemption."Sent to Treasury":=true;
                PostedRedemption."For Verification":= false;
                PostedRedemption.Modify(true);
              end;
            end;
           end;
          end;
         exit("Transaction No");

        end;
    end;

    procedure CreateRedemption(Caseno: Code[40];AccountNo: Code[50];ValueDate: Date;RedemptionType: Option "Part",Full;AmountRedeem: Decimal;noofunits: Decimal;Source: Text;DocumentPath: Text;DocumentPath2: Text;Remarks: Text;IsReversal: Boolean;OnlineRedemption: Boolean): Code[30]
    var
        Redemption: Record Redemption;
        PostedRedemption: Record "Posted Redemption";
        Text001: Label 'Possible Duplicate';
        IsDuplicate: Boolean;
    begin
        if PostedRedemption.Get(Caseno) then
          Error('This Case No has already Been Processed');
        
        IsDuplicate := IsDuplicateRedemption(AccountNo,AmountRedeem,ValueDate);
        
        with Redemption do begin
          Init;
          Validate("Transaction No",Caseno);
          Validate("Account No",AccountNo);
          Validate("Value Date",ValueDate);
          Validate("Transaction Date",Today);
          Validate("Redemption Type",RedemptionType);
          if OnlineRedemption then
          Validate("Request Mode",Redemption."Request Mode"::Online);
         if RedemptionType=RedemptionType::Part then
          Validate(Amount,AmountRedeem);
          if "No. Of Units"<>0 then
          Validate("No. Of Units");
          "Data Source":=Source;
          "Document Path":=DocumentPath;
          "Document Link":="Document Path";
          "Document Path2":=DocumentPath2;
          "Creation Date" := CurrentDateTime;
           FundAdministrationSetup.Get;
              if (FundAdministrationSetup."CX Verification Threshold"<>0) and
                 (Redemption.Amount>FundAdministrationSetup."CX Verification Threshold") then begin
                  Redemption."Redemption Status":=Redemption."Redemption Status"::"Customer Experience Verification";
                  //Email Notification
                  /*NotificationFunctions.CreateNotificationEntry(0,USERID,CURRENTDATETIME,'Redemption',Redemption."Transaction No",
              Redemption."Client Name",Redemption."Client ID",'Customer Experience Verification',Redemption."Fund Code",Redemption."Account No",
          'Redemption',Redemption.Amount,1)*/
             end else
              Redemption."Redemption Status":=Redemption."Redemption Status"::"ARM Registrar";
              //Email Notification
              /*NotificationFunctions.CreateNotificationEntry(0,USERID,CURRENTDATETIME,'Redemption',Redemption."Transaction No",
              Redemption."Client Name",Redemption."Client ID",'ARM Registrar',Redemption."Fund Code",Redemption."Account No",
          'Redemption',Redemption.Amount,2);*/
            if OnlineRedemption then
              Redemption."Redemption Status":=Redemption."Redemption Status"::Verified;
              Redemption."For Verification" := true;
        
            //Maxwell: To set up Recon No from the end.
            if Redemption."Recon No" = '' then begin
              FundAdministrationSetup.TestField(FundAdministrationSetup."Recon Nos");
              NoSeriesMgt.InitSeries(FundAdministrationSetup."Recon Nos",'',0D,"Recon No","No. Series");
            end;
        
            if IsDuplicate then
              Comments := Text001;
        
          Insert;
        
        /*IF(Redemption."Fund Code" = 'ARMSTBF') OR (Redemption."Fund Code" = 'ARMFIF') OR (Redemption."Fund Code" = 'ARMEURO') THEN
              ERROR('This request will not be processed today because of reinvestment');*/
        
          //to uncomment for stp
          if (OnlineRedemption) and (IsDuplicate = false) then begin
            if (FundAdministrationSetup."Online Threshold"<>0) and (Redemption.Amount<=FundAdministrationSetup."Online Threshold") then begin
              //Bayo: Check if redemption type is full 28082022
              if RedemptionType = RedemptionType::Part then begin
                //Maxwell: STP Threshold of 1,000,000 031120
                if CheckIfSTP(Redemption."Account No",Redemption."Value Date",Redemption.Amount) then begin
                      FundTransactionManagement.PostSingleRedmptionOnline(Redemption);
                  //CHARGES
                  if Redemption."Charges On Accrued Interest" > 0 then
                      FundTransactionManagement.InsertAccruedInterestCharge(Redemption."Account No",Redemption."Charges On Accrued Interest",Redemption."Fund Code",Redemption."Value Date");
                  //END
                  if PostedRedemption.Get(Caseno) then begin
                    PostedRedemption."Sent to Treasury":=true;
                    PostedRedemption."For Verification":= false;
                    PostedRedemption.Modify(true);
                  end;
                end;
              end;
            //check redemption type end;
           end;
          end;
         exit("Transaction No");
        
        end;

    end;

    procedure CreateOnlineIndemnityRequest(Caseno: Code[40];AccountNo: Code[40];DocumentLink: Text;Updatesource: Text[50];ClientID: Code[40];Requestor: Code[50];Approver: Code[50];Remarks: Text): Code[20]
    var
        ClientAccount: Record "Client Account";
        OnlineIndemnityMandate: Record "Online Indemnity Mandate";
    begin
        if not ClientAccount.Get(AccountNo) then
          Error('Account Does not Exist');

        with OnlineIndemnityMandate do begin
          Init;
           Validate(No,Caseno);
          Validate("Account No",AccountNo);
          Validate("Document Link",DocumentLink);
          Validate(Status,Status::"ARM Registrar");
          Validate(Source,Updatesource);
          if Insert(true) then begin
            NotificationFunctions.CreateNotificationEntry(0,UserId,CurrentDateTime,'Online Indemnity',OnlineIndemnityMandate.No,
            OnlineIndemnityMandate."Client Name",OnlineIndemnityMandate."Client ID",'ARM Registrar',OnlineIndemnityMandate."Fund Code",OnlineIndemnityMandate."Account No",
        'Online Indemnity',0,16);
            exit(No);
          end else
            exit('');
        end
    end;

    procedure CreateDirectDebitRequest(Caseno: Code[40];AccountNo: Code[40];DocumentLink: Text;DebitFrequency: Option Variable,Weekly,"Every 2 Weeks",Monthly,"Every 2 Months","Every 3 Months","Every 4 Months","Every 5 Months","Every 6 Months";StartDate: Date;DebitAmount: Decimal;RequestType: Option Setup,Cancellation,Suspension;Updatesource: Text): Code[30]
    var
        DirectDebitMandate: Record "Direct Debit Mandate";
        ClientAccount: Record "Client Account";
    begin
        if not ClientAccount.Get(AccountNo) then
          Error('Account Does not Exist');
        with DirectDebitMandate do begin
          Init;
          Validate(No,Caseno);
          Validate("Request Type", RequestType);
          Validate("Account No",AccountNo);
          Validate(Frequency,DebitFrequency);
          Validate("Document Link",DocumentLink);
          Validate("Start Date",StartDate);
          Validate(Amount,DebitAmount);
          Validate(Status,Status::"ARM Registrar");
          Source:=Updatesource;
          /*IF INSERT(TRUE) THEN BEGIN
            NotificationFunctions.CreateNotificationEntry(0,USERID,CURRENTDATETIME,'Direct Debit Mandate',DirectDebitMandate.No,
            DirectDebitMandate."Client Name",DirectDebitMandate."Client ID",'ARM Registrar',DirectDebitMandate."Fund Code",DirectDebitMandate."Account No",
        'Direct Debit Mandate',DirectDebitMandate.Amount,11);
            EXIT(No)*/
           if Insert(true) then
            exit(No)
           else
            exit('');
        end

    end;

    procedure CreateKycLinks(ClientID: Code[50];DocumentType: Text;DocLink: Text;Updatesource: Text): Integer
    var
        Client: Record Client;
        KYCLinks: Record "KYC Links";
    begin

        if not Client.Get(ClientID) then
            Error('Client Does not Exist');

        KYCLinks.Init;
        KYCLinks."Client ID":=ClientID;
        KYCLinks."KYC Type":=DocumentType;
        KYCLinks.Link:=DocLink;
        KYCLinks.Source:=Updatesource;
        if KYCLinks.Insert(true) then
          exit(KYCLinks."Entry No")
        else
          exit(0);
    end;

    procedure CreateNextofKinBackup(ClientID: Code[50];NOKRelationShip: Code[20];NOKTitle: Text;NOKLastName: Text;NOKFirstName: Text;NOKMiddleName: Text;NOKGender: Option Please_Select,Male,Female;NOKAddress: Text;NOKTelephoneNo: Code[20];NOKEmail: Text;NOKState: Text;NOKTown: Text;NOKCountry: Code[20];Updatesource: Text): Integer
    var
        Client: Record Client;
        ClientNextofKin: Record "Client Next of Kin";
        entryno: Integer;
        ClientNextofKin2: Record "Client Next of Kin";
    begin
        if not Client.Get(ClientID) then
            Error('Client Does not Exist');
        ClientNextofKin2.Reset;
        ClientNextofKin2.SetRange("Client ID",ClientID);
        if ClientNextofKin2.FindLast then
        entryno:=ClientNextofKin2."Line No"+1
        else
        entryno:=1;
          with ClientNextofKin do begin
            Init;
            "Line No":=entryno;
            Validate("Client ID",ClientID);
            Validate("NOK Relationship",NOKRelationShip);
            Validate("NOK Title",NOKTitle);
            Validate("NOK Last Name",NOKLastName);
            Validate("NOK First Name",NOKFirstName);
            Validate("NOK Middle Name",NOKMiddleName);
            Validate("NOK Gender",NOKGender);
            Validate("NOK Address",NOKAddress);
            Validate("NOK Telephone No",NOKTelephoneNo);
           // VALIDATE("NOK Email",NOKEmail);
            Validate("NOK State of Origin",NOKState);
            Validate("NOK Town",NOKTown);
            Validate("NOK Country",NOKCountry);
            Source:=Updatesource;
            if Insert(true) then
              exit("Line No")
            else
              exit(0);
          end;
    end;

    procedure CreateJointAccountHolder(ClientID: Code[50];HolderTitle: Text;LastName: Text;FirstName: Text;MiddleName: Text;JGender: Option Please_Select,Male,Female;Address: Text;TelephoneNo: Code[10];JEmail: Text;State: Text;KTown: Text;Country: Code[20];JSignatory: Boolean;MandatorySignatory: Boolean;DateofBirth: Date;MainHolder: Boolean;Updatesource: Text): Integer
    var
        Client: Record Client;
        JointAccountHolders: Record "Joint Account Holders";
        JointAccountHolders2: Record "Joint Account Holders";
        entryno: Integer;
    begin
        if not Client.Get(ClientID) then
            Error('Client Does not Exist');
        JointAccountHolders2.Reset;
        JointAccountHolders2.SetRange("Client ID",ClientID);
        if JointAccountHolders2.FindLast then
        entryno:=JointAccountHolders2."Line no"+1
        else
        entryno:=1;
        with JointAccountHolders do begin
          Init;
          "Line no":=entryno;
          Validate("Client ID",ClientID);
          Validate(Title,HolderTitle);
          Validate("Last Name",LastName);
          Validate("First Name",FirstName);
          Validate("Middle Names",MiddleName);
          Validate("Date of Birth",DateofBirth);
          Validate(Gender,JGender);
          Validate("State of Origin",State);
          Validate(Address1,Address);
          Validate(Email,JEmail);
          Validate("Main Holder",MainHolder);
          Validate(Signatory,JSignatory);
          Validate("Required Signatory",MandatorySignatory);
          Source:=Updatesource;
          if Insert(true) then
            exit("Line no")
          else
            exit(0)
        end
    end;

    procedure CreatefundPrice(ValueDate: Date;FundCode: Code[20];MidPrice: Decimal;UpdateSource: Text): Boolean
    var
        FundPrices: Record "Fund Prices";
    begin
        FundPrices.Init;
        FundPrices.Validate("Value Date",ValueDate);
        FundPrices.Validate("Fund No.",FundCode);
        FundPrices.Validate("Mid Price",MidPrice);
        FundPrices.Source:=UpdateSource;
        if FundPrices.Insert(true) then
          exit(true)
        else
          exit(false)
    end;

    procedure GetAccountBalance(ClientAccountNo: Code[50]): Decimal
    var
        ClientAccount: Record "Client Account";
        FundAdministration: Codeunit "Fund Administration";
    begin
        if ClientAccount.Get(ClientAccountNo) then begin
          ClientAccount.CalcFields("No of Units");
          exit(FundAdministration.GetNAV(Today,ClientAccount."Fund No",ClientAccount."No of Units"));


        end else Error('Client Account Does not Exist');
    end;

    procedure GetAccountDividend(ClientAccountNo: Code[40];StartDate: Date;EndDate: Date): Decimal
    var
        ClientAccount: Record "Client Account";
        FundAdministration: Codeunit "Fund Administration";
    begin
        ClientAccount.Reset;
        ClientAccount.SetRange("Account No",ClientAccountNo);
        ClientAccount.SetRange("Date Filter",StartDate,EndDate);
        if ClientAccount.Get(ClientAccountNo) then begin
          ClientAccount.CalcFields("Accrued Interest");
          exit(ClientAccount."Accrued Interest");


        end else Error('Client Account Does not Exist');
    end;

    procedure GetClientTransactions(var ExportClientTransactions: XMLport "Export Client Transactions";Accountno: Text;StartDate: Date;EndDate: Date)
    var
        ClientTransactions: Record "Client Transactions";
    begin
        ClientTransactions.Reset;
        ClientTransactions.SetFilter("Account No",'=%1',Accountno);
        ClientTransactions.SetRange ("Value Date",StartDate ,EndDate);
        ExportClientTransactions.SetTableView(ClientTransactions);
    end;

    procedure GetClientRedemptionstoPushtobank(var ExportRedemptionsToBank: XMLport "Export Redemptions To Bank";StartDate: Date;EndDate: Date)
    var
        PostedRedemption: Record "Posted Redemption";
    begin
        PostedRedemption.Reset;
        PostedRedemption.SetRange("Value Date",StartDate ,EndDate);
        ExportRedemptionsToBank.SetTableView(PostedRedemption);
    end;

    procedure GetClientTransferstopushtoBank(var ExportUnitTransferToBank: XMLport "Export Unit Transfer To Bank";StartDate: Date;EndDate: Date)
    var
        PostedFundTransfer: Record "Posted Fund Transfer";
    begin
        PostedFundTransfer.Reset;
        PostedFundTransfer.SetRange("Value Date",StartDate ,EndDate);
        ExportUnitTransferToBank.SetTableView(PostedFundTransfer);
    end;

    procedure MarkRedemptionsaspushedtoBank(TransactionNo: Code[30]): Boolean
    var
        PostedRedemption: Record "Posted Redemption";
    begin
        if PostedRedemption.Get(TransactionNo) then begin
          PostedRedemption."Sent to Treasury":=true;
          PostedRedemption."Date Sent to Treasury":=Today;
            if PostedRedemption.Modify then
              exit(true)
            else
              exit (false);
         end else
         Error('Transaction Does not Exist');
    end;

    procedure MarkTransferaspushedtoBank(TransactionNo: Code[30]): Boolean
    var
        PostedFundTransfer: Record "Posted Fund Transfer";
    begin
        if PostedFundTransfer.Get(TransactionNo) then begin
          PostedFundTransfer."Sent to treasury":=true;
          PostedFundTransfer."Date Sent to Treasury":=Today;
            if PostedFundTransfer.Modify then
              exit(true)
            else
              exit (false);
        end else
          Error('Transaction Does not Exist');
    end;

    procedure UpdateKycLinks(ClientID: Code[50];DocumentType: Text;DocLink: Text;Updatesource: Text;Entryno: Integer): Boolean
    var
        Client: Record Client;
        KYCLinks: Record "KYC Links";
    begin
        //Maxwell: To update KYC Links.
        if not Client.Get(ClientID) then
            Error('Client Does not Exist')
        else begin
          KYCLinks.SetFilter("Client ID",ClientID);
          KYCLinks.SetFilter("KYC Type",DocumentType);
          if KYCLinks.FindFirst then begin
            //KYCLinks."KYC Type":=DocumentType;
            KYCLinks.Link:=DocLink;
            KYCLinks.Source:=Updatesource;
            if KYCLinks.Modify(true) then
              exit(true)
            else
              exit(false);
          end;
        end
        
        /*
        //UpdateKYCLink up till 26-Jun-2019
        
        IF NOT Client.GET(ClientID) THEN
            ERROR('Client Does not Exist');
        IF  KYCLinks.GET(Entryno,ClientID) THEN  BEGIN
        
          KYCLinks."KYC Type":=DocumentType;
          KYCLinks.Link:=DocLink;
          KYCLinks.Source:=Updatesource;
          IF KYCLinks.MODIFY(TRUE) THEN
            EXIT(TRUE)
          ELSE
            EXIT(FALSE);
        END ELSE*/

    end;

    procedure updateNextofKin(ClientID: Code[50];LineNo: Integer;NOKRelationShip: Code[20];NOKTitle: Text;NOKLastName: Text;NOKFirstName: Text;NOKMiddleName: Text;NOKGender: Option Please_Select,Male,Female;NOKAddress: Text;NOKTelephoneNo: Code[20];NOKEmail: Text;NOKState: Text;NOKTown: Text;NOKCountry: Code[20];Updatesource: Text): Integer
    var
        Client: Record Client;
        ClientNextofKin: Record "Client Next of Kin";
    begin
        if not Client.Get(ClientID) then
            Error('Client Does not Exist');
        if ClientNextofKin.Get(ClientID,LineNo) then begin
          with ClientNextofKin do begin
            Init;
            Validate("Client ID",ClientID);
            Validate("NOK Relationship",NOKRelationShip);
            Validate("NOK Title",NOKTitle);
            Validate("NOK Last Name",NOKLastName);
            Validate("NOK First Name",NOKFirstName);
            Validate("NOK Middle Name",NOKMiddleName);
            Validate("NOK Gender",NOKGender);
            Validate("NOK Address",NOKAddress);
            Validate("NOK Telephone No",NOKTelephoneNo);
           Validate("NOK Email",NOKEmail);
            Validate("NOK State of Origin",NOKState);
            Validate("NOK Town",NOKTown);
            Validate("NOK Country",NOKCountry);
            Source:=Updatesource;
            if Modify(true) then
              exit("Line No")
            else
              exit(0);
          end;

        end else
          Error('Client Next of kin Does not exist');
    end;

    procedure updateJointAccountHolder(ClientID: Code[50];LineNo: Integer;HolderTitle: Text;LastName: Text;FirstName: Text;MiddleName: Text;JGender: Option Please_Select,Male,Female;Address: Text;TelephoneNo: Code[10];JEmail: Text;State: Text;KTown: Text;Country: Code[20];JSignatory: Boolean;MandatorySignatory: Boolean;DateofBirth: Date;MainHolder: Boolean;Updatesource: Text): Integer
    var
        Client: Record Client;
        JointAccountHolders: Record "Joint Account Holders";
    begin
        if not Client.Get(ClientID) then
            Error('Client Does not Exist');

        if JointAccountHolders.Get(ClientID,LineNo) then begin
        with JointAccountHolders do begin
          Init;
          Validate("Client ID",ClientID);
          Validate(Title,HolderTitle);
          Validate("Last Name",LastName);
          Validate("First Name",FirstName);
          Validate("Middle Names",MiddleName);
          Validate("Date of Birth",DateofBirth);
          Validate(Gender,JGender);
          Validate("State of Origin",State);
          Validate(Address1,Address);
          Validate(Email,JEmail);
          Validate("Main Holder",MainHolder);
          Validate(Signatory,JSignatory);
          Validate("Required Signatory",MandatorySignatory);
          Source:=Updatesource;
          if Modify(true) then
            exit("Line no")
          else
            exit(0)
        end
        end else
        Error('KYC does not Exist')
    end;

    procedure CreateAllClientDetails(ClientID: Code[40];FirstName: Text[50];LastName: Text[50];MiddleNames: Text[50];Address: Text[250];City: Text;Contct: Text;PhoneNo: Code[20];Title: Code[10];HouseNo: Code[10];Estate: Text;Country: Code[10];AccountManager: Code[20];State: Code[20];StreetName: Text[250];DateOfBirth: Date;Nationlity: Code[10];Occupation: Text;MothersName: Text;Genderp: Option " ",Male,Female;Maritalstatus: Option " ",Single,Married,Divorced,Widowed;PlaceofBirth: Text;SponsorFname: Text;SponsorLname: Text;SponsorMname: Text;SponsTitle: Code[10];IdentificationType: Option Please_Select,Passport,"Driving Licence","ID Card","National ID Card","Voters Cards",Others;IdentificationNumber: Code[50];BVN: Code[20];Jurisdiction: Text;UsTaxNo: Text;IsPoliticallyExposed: Boolean;PoliticalInfo: Text;Religon: Code[20];NINp: Code[20];DiasporaClient: Boolean;ClientStatus: Option Active,Inactive,Closed;EmailNotification: Boolean;PostNotification: Boolean;OfficeNotification: Boolean;SmsNotification: Boolean;SocialMedia: Boolean;DateCreated: Date;Createdby: Code[50];Email: Text[100];ClientType: Option " ",Individual,Joint,Corporate,Minor;MainAccount: Code[40];IVNumber: Code[40];Source: Text;NOKRelationShip: Code[20];NOKTitle: Text;NOKLastName: Text;NOKFirstName: Text;NOKMiddleName: Text;NOKGender: Option Please_Select,Male,Female;NOKAddress: Text;NOKTelephoneNo: Code[20];NOKEmail: Text;NOKState: Text;NOKTown: Text;NOKCountry: Code[20];HolderTitle: Text;JointLastName: Text;JointFirstName: Text;MiddleName: Text;TelephoneNo: Code[10];JSignatory: Boolean;MandatorySignatory: Boolean;MainHolder: Boolean;FundCode: Code[40];BankCode: Code[30];BankBranch: Code[30];BankAccName: Text;BankAccountNo: Code[50];KYCTier: Code[20];DividendMandate: Option " ",Payout,Reinvest): Code[50]
    var
        Client: Record Client;
        Accountno: Code[50];
    begin
         /*CreateClient(ClientID,FirstName,LastName,MiddleNames,Address,City,Contct,PhoneNo,Title,HouseNo,Estate,Country,AccountManager,State,
        StreetName,DateOfBirth,Nationlity,Occupation,MothersName,Genderp,Maritalstatus,PlaceofBirth,SponsorFname,SponsorLname,
        SponsorMname,SponsTitle,IdentificationType,IdentificationNumber,BVN,Jurisdiction,UsTaxNo,IsPoliticallyExposed,PoliticalInfo
        ,Religon,NINp,DiasporaClient,ClientStatus,EmailNotification,PostNotification,OfficeNotification,SmsNotification,SocialMedia,DateCreated,
        Createdby,Email,ClientType,MainAccount,IVNumber,Source);
        */
        if ClientType= ClientType::Joint then
        CreateJointAccountHolder(ClientID,HolderTitle,LastName,FirstName,MiddleName,Genderp,Address,PhoneNo,Email,State,City,Country,JSignatory,MandatorySignatory,
        DateOfBirth,MainHolder,Source);
        
        if (ClientType=ClientType::Individual) or (ClientType=ClientType::Minor) then
          CreateNextofKin(ClientID,NOKRelationShip,NOKTitle,NOKLastName,NOKFirstName,NOKMiddleName,NOKGender,NOKAddress,NOKTelephoneNo,NOKEmail,NOKState,NOKTown,NOKCountry,Source);
        
        
        //Accountno:= CreateClientAccount(ClientID,FundCode,BankCode,BankBranch,BankAccName,BankAccountNo,KYCTier,DividendMandate,Source);
        
        exit(Accountno);

    end;

    procedure PostdailyDistributableIncome(ValueDate: Date;Fundcode: Code[50];subscriptionUnits: Decimal;Redemptionunits: Decimal;EODNAV: Decimal;DailyDistributableincome: Decimal)
    begin
    end;

    procedure GetClientDetails(var ExportClientDetails: XMLport "Export Client Details";MembershipID: Code[40])
    var
        Client: Record Client;
    begin
        Client.Reset;
        Client.SetRange("Membership ID",MembershipID);
        ExportClientDetails.SetTableView(Client);
    end;

    procedure GetClientAccountDetails(var ExportClientAccounts: XMLport "Export Client Accounts";MembershipID: Code[40])
    var
        ClientAccount: Record "Client Account";
    begin
        ClientAccount.Reset;
        ClientAccount.SetRange("Client ID",MembershipID);
        ExportClientAccounts.SetTableView(ClientAccount);
    end;

    procedure GetKYCTier(AccountNo: Code[40]): Code[20]
    var
        ClientAccount: Record "Client Account";
    begin
        if ClientAccount.Get(AccountNo) then
          exit(ClientAccount."KYC Tier")
        else
          Error('Client Account Does not Exist');
    end;

    procedure GetRedemptionStatus(Redemptioncode: Code[40]): Text
    var
        Redemption: Record Redemption;
        PostedRedemption: Record "Posted Redemption";
    begin
        if Redemption.Get(Redemptioncode) then begin
          exit(Format(Redemption."Redemption Status"));
        end else
        if PostedRedemption.Get(Redemptioncode) then  begin
            if PostedRedemption."Sent to Treasury" then
              exit('Payment schedule sent to Treasury')
            else
            exit(Format(PostedRedemption."Redemption Status"));

          end  else
        Error('Redemption Does not exist');
    end;

    procedure GetSubscriptionStatus(SubscriptionCode: Code[40]): Text
    var
        Subscription: Record Subscription;
        PostedSubscription: Record "Posted Subscription";
    begin
        if Subscription.Get(SubscriptionCode) then begin
          exit(Format(Subscription."Subscription Status"));
        end else
        if PostedSubscription.Get(SubscriptionCode) then begin
          exit(Format(PostedSubscription."Subscription Status"));
        end else
        Error('Subscription Does not exist');
    end;

    procedure GetOnlineIndemnityStatus(IndemnityNo: Code[40]): Text
    var
        OnlineIndemnityMandate: Record "Online Indemnity Mandate";
    begin
        if OnlineIndemnityMandate.Get(IndemnityNo) then
          exit(Format(OnlineIndemnityMandate.Status))
        else
          Error('Online Indemnity Does not Exist');
    end;

    procedure GetDirectDebitStatus(DirectDebitNo: Code[40]): Text
    var
        DirectDebitMandate: Record "Direct Debit Mandate";
    begin
        if DirectDebitMandate.Get(DirectDebitNo) then
          exit(Format(DirectDebitMandate.Status))
        else
          Error('Direct Debit Mandate does not Exist');
    end;

    procedure UpdateRedemptionBankResponse(ReconNo: Code[40];TransactionDate: Date;BankResponseStatus: Option ,Successful,Failed,"Not Sent to Bank";BankResponseComment: Text;ProcessedByBank: Boolean;TimeProcessedByBank: Time): Boolean
    var
        PostedRedemption: Record "Posted Redemption";
    begin
        PostedRedemption.Reset;
        PostedRedemption.SetRange("Recon No", ReconNo);
        if PostedRedemption.FindFirst then begin
          PostedRedemption."Processed By Bank":= ProcessedByBank;
          PostedRedemption."Date Processed By Bank":=TransactionDate;
          PostedRedemption."Time Processed By Bank" := TimeProcessedByBank;
          PostedRedemption."Bank Response Status" := BankResponseStatus;
          PostedRedemption."Bank Response Comment" := BankResponseComment;
          if PostedRedemption.Modify then
            exit(true)
         else
           exit(false);
        end
        else Error('Redemption with Transaction no %1 does not exist',ReconNo);
    end;

    procedure UpdateRedemptionBankResponseUn(TransactionNo: Code[40];AccountNo: Code[40];ClientID: Code[40];TransactionDate: Date;TransactionBatch: Code[40];PaymentStatus: Text;PaymentDescription: Text): Boolean
    var
        PostedRedemption: Record "Posted Redemption";
    begin
        PostedRedemption.Reset;
        PostedRedemption.SetRange(No,TransactionNo);
        if PostedRedemption.FindFirst then begin
          PostedRedemption."Processed By Bank":=true;
          PostedRedemption."Date Processed By Bank":=TransactionDate;
          PostedRedemption."Time Processed By Bank":=Time;
          PostedRedemption."Payment Status":=PaymentStatus;
          PostedRedemption."Payment Description":=PaymentDescription;
          if PostedRedemption.Modify then
            exit(true)
         else
           exit(false);
        end
        else Error('Redemption with Transaction no %1 does not exist',TransactionNo);
    end;

    procedure UpdateTransferBankResponse(TransactionNo: Code[40];AccountNo: Code[40];ClientID: Code[40];TransactionDate: Date;TransactionBatch: Code[40];PaymentStatus: Text;PaymentDescription: Text): Boolean
    var
        PostedFundTransfer: Record "Posted Fund Transfer";
    begin
        PostedFundTransfer.Reset;
        PostedFundTransfer.SetRange(No,TransactionNo);
        if PostedFundTransfer.FindFirst then begin
          PostedFundTransfer."Processed By Bank":=true;
          PostedFundTransfer."Date Processed By Bank":=TransactionDate;
          PostedFundTransfer."Time Processed By Bank":=Time;
          PostedFundTransfer."Payment Status":=PaymentStatus;
          PostedFundTransfer."Payment Description":=PaymentDescription;
         if  PostedFundTransfer.Modify then
           exit(true)
         else
           exit(false);
        end
        else Error('Unit Transfer with Transaction no %1 does not exist',TransactionNo);
    end;

    procedure UpdateBankDetails(ClientID: Code[40];BankCode: Code[30];BankBranch: Code[30];BankAccName: Text;BankAccountNo: Code[50];Source: Text[50]): Boolean
    var
        Client: Record Client;
        clientaccounts: Record "Client Account";
    begin
        if not Client.Get(ClientID) then
          Error('Client does not Exist');
        with Client do begin

          if BankCode <>'' then
            Validate("Bank Code",BankCode);
          if BankBranch <>'' then
            Validate("Bank Branch",BankBranch);
          if BankAccName <>'' then
           Validate("Bank Account Name",BankAccName);
          if BankAccountNo <>'' then
          Validate("Bank Account Number",BankAccountNo);
          "Last Modified By":=UserId;
          "Last Modified DateTime":=CurrentDateTime;
           "Last Update Source":=Source;
            Modify(true);
          clientaccounts.Reset;
          clientaccounts.SetRange("Client ID",Client."Membership ID");
          if clientaccounts.FindFirst then
            repeat
              if BankCode <>'' then
                clientaccounts.Validate("Bank Code",BankCode);
              if BankBranch <>'' then
                clientaccounts.Validate("Bank Branch",BankBranch);
              if BankAccName <>'' then
               clientaccounts.Validate("Bank Account Name",BankAccName);
              if BankAccountNo <>'' then
              clientaccounts.Validate("Bank Account Number",BankAccountNo);
              clientaccounts.Modify;
            until clientaccounts.Next=0;



             exit(true)

        end
    end;

    procedure GetClientNextofKinDetails(var ExportNextofKinDetails: XMLport "Export Next of Kin Details";MembershipID: Code[40])
    var
        ClientNextofKin: Record "Client Next of Kin";
    begin
        ClientNextofKin.Reset;
        ClientNextofKin.SetRange("Client ID",MembershipID);
        ExportNextofKinDetails.SetTableView(ClientNextofKin);
    end;

    procedure GetClientKycLinks(var ExportClientKycLinks: XMLport "Export Client Kyc Links";MembershipID: Code[40])
    var
        KYCLinks: Record "KYC Links";
    begin
        KYCLinks.Reset;
        KYCLinks.SetRange("Client ID",MembershipID);
        ExportClientKycLinks.SetTableView(KYCLinks);
    end;

    procedure GetJointHolderDetails(var ExportJointHolderDetails: XMLport "Export Joint Holder Details";MembershipID: Code[40])
    var
        JointAccountHolders: Record "Joint Account Holders";
    begin
        JointAccountHolders.Reset;
        JointAccountHolders.SetRange("Client ID",MembershipID);
        ExportJointHolderDetails .SetTableView(JointAccountHolders);
    end;

    procedure ReverseSubscription(TransactionNo: Code[50];Remarks: Text): Code[30]
    var
        Subscription: Record Subscription;
    begin
        if Subscription.Get(TransactionNo) then begin
          Subscription."Subscription Status":=Subscription."Subscription Status"::Rejected;
          Subscription.Remarks:=Remarks;
          Subscription.Modify;
          exit(TransactionNo);
        end
        else
        Error('Subscription Does not Exist')
    end;

    procedure GetAccountNoFromOldMembershipID(OldMembershipNo: Code[40];fundcode: Code[40]): Code[40]
    var
        ClientAccount: Record "Client Account";
    begin
        ClientAccount.Reset;
        ClientAccount.SetRange("Old Account Number",OldMembershipNo);
        ClientAccount.SetRange("Fund No",fundcode);
        if ClientAccount.FindFirst then
          exit(ClientAccount."Account No")
        else begin
          ClientAccount.Reset;
          ClientAccount.SetRange("Old MembershipID",OldMembershipNo);
          ClientAccount.SetRange("Fund No",fundcode);
          if ClientAccount.FindFirst then
            exit(ClientAccount."Account No")
          else begin
            ClientAccount.Reset;
            ClientAccount.SetRange("Client ID",OldMembershipNo);
            ClientAccount.SetRange("Fund No",fundcode);
            if ClientAccount.FindFirst then
              exit(ClientAccount."Account No")
            else
               Error('CLient Account does not Exit');
          end
        end
    end;

    procedure ReverseRedemption(TransactionNo: Code[50];Remarks: Text): Code[30]
    var
        Redemption: Record Redemption;
    begin
        if Redemption.Get(TransactionNo) then begin
          Redemption."Redemption Status":=Redemption."Redemption Status"::Rejected;
          Redemption.Remarks:=Remarks;
          Redemption.Modify;
          exit(TransactionNo);
        end
        else
        Error('Redemption Does not Exist')
    end;

    procedure GetCaseStatus(CaseNo: Code[40]): Text
    var
        Redemption: Record Redemption;
        PostedRedemption: Record "Posted Redemption";
        OnlineIndemnityMandate: Record "Online Indemnity Mandate";
        DirectDebitMandate: Record "Direct Debit Mandate";
        Subscription: Record Subscription;
        PostedSubscription: Record "Posted Subscription";
    begin
        if Redemption.Get(CaseNo) then begin
          exit(Format(Redemption."Redemption Status"));
        end else
          if PostedRedemption.Get(CaseNo) then  begin
            if PostedRedemption."Sent to Treasury" then
              exit('Payment schedule sent to Treasury')
            else
            exit('Transaction Posted');
          end;

        if Subscription.Get(CaseNo) then begin
          exit(Format(Subscription."Subscription Status"));
        end else
        if PostedSubscription.Get(CaseNo) then begin
          exit(Format(PostedSubscription."Subscription Status"));
        end ;

        if DirectDebitMandate.Get(CaseNo) then
          exit(Format(DirectDebitMandate.Status));

        if OnlineIndemnityMandate.Get(CaseNo) then
          exit(Format(OnlineIndemnityMandate.Status));

        Error('Case Does not exist');
    end;

    procedure ValidateRedemption(Caseno: Code[40];AccountNo: Code[50];ValueDate: Date;RedemptionType: Option "Part",Full;AmountRedeem: Decimal;noofunits: Decimal;Source: Text;DocumentPath: Text;DocumentPath2: Text;Remarks: Text;IsReversal: Boolean;OnlineRedemption: Boolean): Code[30]
    var
        Redemption: Record Redemption;
        PostedRedemption: Record "Posted Redemption";
    begin
          if PostedRedemption.Get(Caseno) then
            Error('This Case No has already Been Processed');

        with Redemption do begin
          Init;
          Validate("Transaction No",Caseno);
          Validate("Account No",AccountNo);
          Validate("Value Date",ValueDate);
          Validate("Transaction Date",Today);
          Validate("Redemption Type",RedemptionType);
         if RedemptionType=RedemptionType::Part then
          Validate(Amount,AmountRedeem);
          if "No. Of Units"<>0 then
          Validate("No. Of Units");
          "Data Source":=Source;
          "Document Path":=DocumentPath;
          "Document Link":="Document Path";
          "Document Path2":=DocumentPath2;
           FundAdministrationSetup.Get;
              if (FundAdministrationSetup."CX Verification Threshold"<>0) and
                 (Redemption.Amount>FundAdministrationSetup."CX Verification Threshold") then
                  Redemption."Redemption Status":=Redemption."Redemption Status"::"Customer Experience Verification"
             else
              Redemption."Redemption Status":=Redemption."Redemption Status"::"ARM Registrar";
            if OnlineRedemption then
              Redemption."Redemption Status":=Redemption."Redemption Status"::Verified;
          //INSERT;
          exit("Transaction No");

        end;
    end;

    procedure ValidateValuedateAgainstPrice(ValueDate: Date;Fundcode: Code[50]): Boolean
    var
        FundPrices: Record "Fund Prices";
        IncomeRegister: Record "Income Register";
        Fund: Record Fund;
        EODTracker: Record "EOD Tracker";
        DailyIncomeRegister: Record "Daily Distributable Income";
    begin
        //Check that EOD has not been Run
        
        EODTracker.Reset;
        EODTracker.SetRange(Date,ValueDate);
        EODTracker.SetRange("Fund Code",Fundcode);
        if EODTracker.FindFirst then
          Error('You cannot Post into Date %1 since EOD has been Run',ValueDate);
        
        
        //check if dividend has been distributed
        Fund.Reset;
        if Fund.Get(Fundcode) then begin
         if Fund."Dividend Period"<>Fund."Dividend Period"::"No Dividend" then begin
           /*IncomeRegister.RESET;
           IncomeRegister.SETRANGE("Fund ID",Fundcode);
           IncomeRegister.SETRANGE("Value Date",CALCDATE('-1D',ValueDate));
           IncomeRegister.SETRANGE(Distributed,TRUE);
           IF NOT IncomeRegister.FINDFIRST THEN
             ERROR('Income for %1 for fund %2 needs to be distributed before posting transactions',CALCDATE('-1D',ValueDate),Fundcode);*/
        
           DailyIncomeRegister.Reset;
           DailyIncomeRegister.SetRange("Fund Code",Fundcode);
           DailyIncomeRegister.SetRange(Date, CalcDate('-1D',ValueDate));
           DailyIncomeRegister.SetRange(Distributed, true);
           if not DailyIncomeRegister.FindFirst then
            Error('Please Distribute Income for %1 for fund %2 before posting transactions',CalcDate('-1D',ValueDate),Fundcode);
          end
        end;
        
        FundPrices.Reset;
        FundPrices.SetRange("Fund No.",Fundcode);
        FundPrices.SetRange(Activated,true);
        FundPrices.SetRange("Value Date",ValueDate);
        if FundPrices.FindLast then begin
          if FundPrices."Value Date">ValueDate then  begin
           Error(StrSubstNo('%1 %2 Value date (%3) is less than the last updated price of Value date(%4)','',Fundcode,ValueDate,FundPrices."Value Date"));
          end
          else if FundPrices."Value Date"<ValueDate then
            begin
           Error(StrSubstNo('%1 %2 Value date (%3) is greater than the last updated price of Value date(%4)','',Fundcode,ValueDate,FundPrices."Value Date"));
          end
        
        end
        else Error('There is no Active fund price for Fund %1',Fundcode);
        exit(true);

    end;

    procedure GetSTPTransactions(var STPResponse: XMLport "Export Online Redemption-STP";StartDate: Date;EndDate: Date)
    var
        redemption: Record "Posted Redemption";
        FundAdministrationSetup: Record "Fund Administration Setup";
    begin
        redemption.Reset;
        FundAdministrationSetup.Get;
        redemption.SetRange (redemption."Redemption Status",redemption."Redemption Status"::Posted);
        redemption.SetRange (redemption."Date Posted",StartDate ,EndDate);
        redemption.SetRange(Amount,0,FundAdministrationSetup."Online Threshold");
        redemption.SetRange("For Verification",false);
        STPResponse.SetTableView(redemption);
    end;

    procedure GetTreasuryBankResponse(var BankResponse: XMLport "Import Redemption Bank Status"): Boolean
    var
        redemption: Record "Posted Redemption";
    begin
        redemption.Reset;
        BankResponse.Import;
        Clear(BankResponse);
        exit (true);
    end;

    procedure CRMCreateSubscription(CaseNo: Code[40];Accountno: Code[50];Amountsubscribed: Decimal;ValueDate: Date;Remarks: Text;Source: Text;DocumentPath: Text): Code[30]
    var
        Subscription: Record Subscription;
        clientAccount: Record "Client Account";
    begin
        /*WITH Subscription DO BEGIN
          INIT;
          VALIDATE(No,CaseNo);
          VALIDATE("Account No",Accountno);
          VALIDATE("Value Date",ValueDate);
          //VALIDATE(Remarks,Remarks);
          VALIDATE(Amount,Amountsubscribed);
          VALIDATE(Remarks,Remarks);
          VALIDATE("Document Link",DocumentPath);
         // do;
          "Data Source":=Source;
          "Creation Date" := CURRENTDATETIME;
          Subscription."Subscription Status":=Subscription."Subscription Status"::Confirmed;//"Redemption Status":=Redemption."Redemption Status"::"ARM Registrar";
          AutoMatched:=TRUE;
          IF Remarks = '' THEN
            Remarks := 'Buyback';
          //map payment mode dropdown
          IF Remarks <> '' THEN BEGIN
             IF Remarks = 'Cash Deposits & Bank Account Transfers' THEN
             "Payment Mode" := "Payment Mode"::"Cash Deposits & Bank Account Transfers";
             IF Remarks = 'Direct debit - CMMS' THEN
             "Payment Mode" := "Payment Mode"::"Direct debit - CMMS";
             IF Remarks = 'Direct Debit - Flutterwave' THEN
             "Payment Mode" := "Payment Mode"::"Direct Debit - Flutterwave";
             IF Remarks = 'Direct Debit - GAPS' THEN
             "Payment Mode" := "Payment Mode"::"Direct Debit - GAPS";
             IF Remarks = 'Direct Debit - Standing Instruction' THEN
             "Payment Mode" := "Payment Mode"::"Direct Debit - Standing Instruction";
             IF Remarks = 'E-Payment' THEN
             "Payment Mode" := "Payment Mode"::"E-Payment";
             IF Remarks = 'Dividend' THEN
             "Payment Mode" := "Payment Mode"::Dividend;
             IF Remarks = 'Buyback' THEN
             "Payment Mode" := "Payment Mode"::"Buy Back";
             IF Remarks = 'Others' THEN
             "Payment Mode" := "Payment Mode"::Others;
            END;
              IF clientAccount.GET(Accountno) THEN BEGIN
                "Fund Code" := clientAccount."Fund No";
                "Bank Account No" := clientAccount."Bank Account Number";
                "Bank Code":= clientAccount."Bank Code";
                END;
          IF INSERT(TRUE) THEN BEGIN
            NotificationFunctions.CreateNotificationEntry(0,USERID,CURRENTDATETIME,'Subscription',Subscription.No,
            Subscription."Client Name",Subscription."Client ID",'Confirmed',Subscription."Fund Code",Subscription."Account No",
          'Subscription',Subscription.Amount,5);
            EXIT(No)
          END ELSE
          EXIT('');
        
        END*/

    end;

    procedure CreateReferral(AccountNo: Code[50]): Boolean
    var
        ClientAcc: Record "Client Account";
        Referral: Record Referral;
    begin
        if Referral.Get(AccountNo) then
           Error('Client with Membership ID %1 has referred this account.',Referral."Referrer Membership ID");
        ClientAcc.Reset;
        ClientAcc.SetFilter("Account No",AccountNo);
        if ClientAcc.FindFirst then
          if ClientAcc."Referrer Membership ID" = '' then
            Error('This Account %1 does not have a Referral Membership ID',AccountNo)
          else
            with Referral do begin
              Init;
              Validate("Account No",AccountNo);
              Referral."Bonus Status" := Referral."Bonus Status"::Active;
             if Insert(true) then
               exit(true)
             else
               exit(false);
            end
        else
          Error('Please create this account %1 before creating referral',AccountNo)
    end;

    procedure GetClientLoans(var ClientLoan: XMLport "Export Client Loans";StaffID: Code[40])
    var
        Loans: Record "Loan Application";
    begin
        Loans.Reset;
        Loans.SetFilter("Staff ID",'=%1', StaffID);
        //Loans.SETRANGE(Status,Loans.Status::Approved);
        //Loans.SETRANGE(Disbursed,Loans.Disbursed = TRUE);
        ClientLoan.SetTableView(Loans);
    end;

    procedure GetLoanRepaymentSchedule(var ClientLoanRepayment: XMLport "Export Loan Repayment";LoanNo: Code[40])
    var
        LoanRepaymentSchedule: Record "Loan Repayment Schedule";
    begin
        LoanRepaymentSchedule.Reset;
        LoanRepaymentSchedule.SetFilter("Loan No.",'=%1',LoanNo);
        //LoanRepaymentSchedule.SETRANGE("Client No.",LoanRepaymentSchedule."Client No.");
        ClientLoanRepayment.SetTableView(LoanRepaymentSchedule);
    end;

    procedure CreatePortfolioRedemption(Caseno: Code[40];AccountNo: Code[50];ValueDate: Date;RedemptionType: Option "Part",Full;noofunits: Decimal;Source: Text;DocumentPath: Text;Remarks: Text): Code[30]
    var
        Redemption: Record Redemption;
        PostedRedemption: Record "Posted Redemption";
    begin
          if PostedRedemption.Get(Caseno) then
            Error('This Case No has already Been Processed');

        with Redemption do begin
          Init;
          Validate("Transaction No",Caseno);
          Validate("Account No",AccountNo);
          Validate("Value Date",ValueDate);
          Validate("Transaction Date",Today);
          Validate("Redemption Type",RedemptionType);
          "Request Mode" := Redemption."Request Mode"::Portfolio;
         if RedemptionType=RedemptionType::Part then
          Validate("No. Of Units",noofunits);
          if Amount <>0 then
          Validate(Amount);
          "Data Source":=Source;
          Remarks := Remarks;
          "Document Link":="Document Path";
          "Creation Date":= CurrentDateTime;
           //Maxwell: To generate Recon No
          if "Recon No" = '' then begin
            FundAdministrationSetup.Get;
            FundAdministrationSetup.TestField(FundAdministrationSetup."Recon Nos");
            NoSeriesMgt.InitSeries(FundAdministrationSetup."Recon Nos","No. Series",0D,"Recon No","No. Series");
          end;
          Redemption."Redemption Status" := Redemption."Redemption Status"::Verified;
          Insert;

          exit("Transaction No");

        end;
    end;

    procedure GetPostedPortfolioRedemption(var ExportPortfolioTransactions: XMLport "Export Portfolio Redemption";ReconNo: Code[15])
    var
        PostedRedemption: Record "Posted Redemption";
    begin
        PostedRedemption.Reset;
        PostedRedemption.SetFilter("Recon No",ReconNo);
        ExportPortfolioTransactions.SetTableView(PostedRedemption);
    end;

    procedure GetPrice(var ExportPortfolioPrice: XMLport "Export Portfolio Price";FundCode: Code[40];ValueDate: Date)
    var
        FundPrice: Record "Fund Prices";
    begin
        FundPrice.Reset;
        FundPrice.SetRange("Fund No.",FundCode);
        FundPrice.SetRange("Value Date",ValueDate);
        ExportPortfolioPrice.SetTableView(FundPrice);
    end;

    procedure GetFundPrices(ValueDate: Date;FundCode: Code[40];BidPrice: Decimal;MidPrice: Decimal;OfferPrice: Decimal;Source: Text): Boolean
    var
        FundPrices: Record "Fund Prices";
    begin
        FundPrices.Reset;
        FundPrices.SetRange("Value Date",ValueDate);
        FundPrices.SetRange("Fund No.",FundCode);
        FundPrices.SetRange(Activated,true);
        if FundPrices.FindFirst then
          Error('Price already exists for %1 for %2.',FundCode,ValueDate)
        else begin
          FundPrices.Init;
          FundPrices.Validate("Value Date",ValueDate);
          FundPrices.Validate("Fund No.",FundCode);
          FundPrices.Validate("Bid Price",BidPrice);
          FundPrices.Validate("Offer Price",OfferPrice);
          FundPrices.Validate("Mid Price",MidPrice);
          FundPrices.Source:=Source;
          FundPrices.Activated := false;
          FundPrices."Send for activation" := true;
          FundPrices."Created Date Time" := CurrentDateTime;
          FundPrices."Last Modified By" := UserId;
          FundPrices."Last Modified DateTime" := CurrentDateTime;
          FundPrices."Created By" := Source;
          if FundPrices.Insert(true) then
            exit(true)
          else
            exit(false)
        end
    end;

    procedure GetDistributableIncome(ValueDate: Date;FundCode: Code[40];DistributedIncome: Decimal;UpdateSource: Code[50]): Boolean
    var
        IncomeRegister: Record "Income Register";
        DailyDistributableIncome: Record "Daily Distributable Income";
        Fund: Record Fund;
    begin
        DailyDistributableIncome.Reset;
        DailyDistributableIncome.SetRange(Date,ValueDate);
        DailyDistributableIncome.SetRange("Fund Code",FundCode);
        if DailyDistributableIncome.FindFirst then
          Error('Income already exists for this Fund %1',FundCode)
        else begin
          Fund.Reset;
          Fund.SetRange("Fund Code", FundCode);
          if Fund.FindFirst then begin
            Fund.CalcFields("No of Units");
            FundAdministrationSetup.Get;
            FundAdministrationSetup.TestField("Daily Distributable Income Nos");
            DailyDistributableIncome.Init;
            DailyDistributableIncome.No := NoSeriesManagement.GetNextNo(FundAdministrationSetup."Daily Distributable Income Nos",Today,true);
            DailyDistributableIncome.Validate(Date,ValueDate);
            DailyDistributableIncome.Validate("Fund Code", FundCode);
            DailyDistributableIncome.Validate("Daily Distributable Income", DistributedIncome);
            DailyDistributableIncome."Total Fund Units" := Fund."No of Units";
            DailyDistributableIncome."Earnings Per Unit" := Round(DistributedIncome/Round(Fund."No of Units",0.0004,'='),0.000000000001,'=');
            DailyDistributableIncome.Source := UpdateSource;
            if DailyDistributableIncome.Insert(true) then
              exit(true)
            else
              exit(false);
          end;
        end;
    end;

    procedure CheckIfSTP(AccountNo: Code[50];ValueDate: Date;Amount: Decimal): Boolean
    var
        Redemption: Record Redemption;
        PostedRedemption: Record "Posted Redemption";
    begin
        Redemption.Reset;
        Redemption.SetRange("Value Date",ValueDate);
        Redemption.SetRange("Account No",AccountNo);
        Redemption.SetFilter("Redemption Status",'<>%1',Redemption."Redemption Status"::Rejected);
        if Redemption.Find('-') then
          Redemption.CalcSums(Amount);
        PostedRedemption.Reset;
        PostedRedemption.SetRange("Value Date",ValueDate);
        PostedRedemption.SetRange("Account No",AccountNo);
        if PostedRedemption.Find('-') then
          PostedRedemption.CalcSums(Amount);
        FundAdministrationSetup.Get;
        if (Redemption.Amount + PostedRedemption.Amount) <= FundAdministrationSetup."Online Threshold" then
          exit(true)
        else
          exit(false);
    end;

    procedure CreateOnlineIndemnitySTP(AccountNo: Code[40]): Code[50]
    var
        ClientAccount: Record "Client Account";
        OnlineIndemnityMandate: Record "Online Indemnity Mandate";
        FundAdministrationSetup: Record "Fund Administration Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        if not ClientAccount.Get(AccountNo) then
          Error('66');

        OnlineIndemnityMandate.Reset;
        OnlineIndemnityMandate.SetRange("Account No",AccountNo);
        OnlineIndemnityMandate.SetRange(Status,OnlineIndemnityMandate.Status::"Verification Successful");
        if OnlineIndemnityMandate.Find('-') then
          exit('55')
        else
          with OnlineIndemnityMandate do begin
            Init;
             if No = '' then begin
                 FundAdministrationSetup.Get;
                 FundAdministrationSetup.TestField(FundAdministrationSetup."Online Indemnity Setup Nos");
                 NoSeriesMgt.InitSeries(FundAdministrationSetup."Online Indemnity Setup Nos",'',0D,No,"No. Series");
              end;
            Validate("Account No",AccountNo);
            Source := 'Request created via STP';
            "Created Date Time" := CurrentDateTime;
            //VALIDATE("Document Link",DocumentLink);
            Validate(Status,Status::"Verification Successful");
            if Insert(true) then begin
              NotificationFunctions.CreateNotificationEntry(0,UserId,CurrentDateTime,'Online Indemnity',OnlineIndemnityMandate.No,
              OnlineIndemnityMandate."Client Name",OnlineIndemnityMandate."Client ID",'ARM Registrar',OnlineIndemnityMandate."Fund Code",OnlineIndemnityMandate."Account No",
          'Online Indemnity',0,16);
              exit('00');
            end else
              exit('99');
          end
    end;

    procedure DeactivateOnlineIndemnitySTP(AccountNo: Code[40]): Text
    var
        ClientAccount: Record "Client Account";
        OnlineIndemnityMandate: Record "Online Indemnity Mandate";
        FundAdministrationSetup: Record "Fund Administration Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        if not ClientAccount.Get(AccountNo) then
          Error('66');
        
        OnlineIndemnityMandate.Reset;
        OnlineIndemnityMandate.SetRange("Account No",AccountNo);
        OnlineIndemnityMandate.SetRange(Status,OnlineIndemnityMandate.Status::"Verification Successful");
        if OnlineIndemnityMandate.Find('-') then begin
          OnlineIndemnityMandate.Status := OnlineIndemnityMandate.Status::Cancelled;
          OnlineIndemnityMandate.Comments := 'Request cancelled via STP ' + Format(Today);
          OnlineIndemnityMandate.Modify(true);
          exit('00');
        end else
          exit('33');
        /*
        00 = Successful.
        99 = Unsuccessful.
        55 = Online Indemnity already exist.
        66 = Account doesnt exist.
        33 = There is no active online indemnity
        */

    end;

    procedure CreateSubscriptionHeader(ValueDate: Date;TransDate: Date;FundCode: Code[40];BankCode: Code[20]): Code[30]
    var
        SubscriptionMatchingheader: Record "Subscription Matching header";
        SubscriptionMatchingLines: Record "Subscription Matching Lines";
        SubscriptionMatchingLines2: Record "Subscription Matching Lines";
        Lineno: Integer;
    begin
        with SubscriptionMatchingheader do begin
          Init;
          "Fund Code":=FundCode;
          "Value Date":=ValueDate;
          Narration:='Automatch_' + Format(CurrentDateTime);
          "Online Statement":=true;
          "Bank Code":=BankCode;
          Posted := false;
          "Created By" := UserId;
          if Insert(true) then
            exit(SubscriptionMatchingheader.No);
        end
    end;

    procedure CreateSubscriptionLines(ValueDate: Date;TransDate: Date;Amount: Decimal;Narration: Text;Channel: Code[10];TransReferenceNo: Code[100];AccountNo: Code[40];MembershipID: Code[20];PayMode: Option;HeaderNo: Code[30]): Text[250]
    var
        SubscriptionMatchingheader: Record "Subscription Matching header";
        SubscriptionMatchingLines: Record "Subscription Matching Lines";
        SubscriptionMatchingLines2: Record "Subscription Matching Lines";
        Lineno: Integer;
        TransNo: Code[100];
        SubscriptionLog: Record "Subscription Matching Line Log";
    begin
        //Trim spaces from transaction reference
        TransNo := DelChr(TransReferenceNo,'<>');

        SubscriptionMatchingheader.Reset;
        SubscriptionMatchingheader.SetRange(No, HeaderNo);
        if not SubscriptionMatchingheader.FindFirst then
          exit('01');
        //01 - Header No does not exist. Create Header No first.
        SubscriptionMatchingheader.Reset;
        SubscriptionMatchingheader.SetRange(No, HeaderNo);
        SubscriptionMatchingheader.SetRange(Posted, true);
        if SubscriptionMatchingheader.FindFirst then
          exit('03');
        //03 - Subscription Matching Header and Lines have been posted. Create another Header No for the new transaction.
        //check for duplicates using transaction reference no.
        SubscriptionMatchingLines2.Reset;
        SubscriptionMatchingLines2.SetRange("Automatch Reference",TransNo);
        if SubscriptionMatchingLines2.FindFirst then
          Error('02');
        //
        SubscriptionMatchingLines2.Reset;
        SubscriptionMatchingLines2.SetRange("Automatch Reference",TransNo);
        if SubscriptionMatchingLines2.FindFirst then
          exit('02');
        //02 - Duplicate. Subcription Line already exist
        //check
        // SubscriptionMatchingLines2.RESET;
        //  SubscriptionMatchingLines2.SETRANGE("Automatch Reference",TransNo);
        //  IF SubscriptionMatchingLines2.FINDFIRST THEN
        //    ERROR('02');
        //==================
          SubscriptionMatchingLines2.Reset;
          SubscriptionMatchingLines2.SetRange(TransactionReference,TransNo);
          if SubscriptionMatchingLines2.FindFirst then
            Error('02');
          postedSubcription.Reset;
          postedSubcription.SetRange("Automatch Ref",TransNo);
          if postedSubcription.FindFirst then
            Error('02');
          postedSubcription.Reset;
          postedSubcription.SetRange("Reference Code",TransNo);
          if postedSubcription.FindFirst then
            Error('02');
        //check end
        //Insert to subscription log

        SubscriptionLog.Reset;
        SubscriptionLog."Automatch Reference" := TransNo;
        SubscriptionLog."Header No" := HeaderNo;
        SubscriptionLog."Creation Date" := CurrentDateTime;
        if SubscriptionLog.Insert(true) then begin

        SubscriptionMatchingLines2.Reset;
        SubscriptionMatchingLines2.SetRange("Header No",SubscriptionMatchingheader.No);
        if SubscriptionMatchingLines2.FindLast then
         Lineno:=SubscriptionMatchingLines2."Line No"
        else
          Lineno:=0;
        Lineno:=Lineno+1;
        SubscriptionMatchingLines.Init;
        SubscriptionMatchingLines."Header No":=HeaderNo;
        SubscriptionMatchingLines."Line No":=Lineno;
        SubscriptionMatchingLines."Automatch Reference" := TransNo;// trimmed transaction reference no.
        SubscriptionMatchingLines."Transaction Date":=TransDate;
        SubscriptionMatchingLines."Value Date":=ValueDate;
        SubscriptionMatchingLines.Narration:=Narration;
        SubscriptionMatchingLines.Reference:=MembershipID;
        SubscriptionMatchingLines."Credit Amount":=Amount;
        SubscriptionMatchingLines.Posted:=false;
        SubscriptionMatchingLines."Payment Mode" := PayMode;
        SubscriptionMatchingLines.Validate("Account No",AccountNo);
        SubscriptionMatchingLines.Channel:=Channel;
        SubscriptionMatchingLines."Creation Date" := CurrentDateTime;
        SubscriptionMatchingLines."Auto Matched" := true;
        //SubscriptionMatchingLines."Fund Code":=FundCode;
        if SubscriptionMatchingLines.Insert(true) then
         exit('00');
        end else begin
          exit('02');
        end;
        //00 - Successful
    end;

    procedure CreateGoals(ClientID: Code[50];GoalName: Text[50];GoalMaturityDate: Date): Code[40]
    var
        CA: Record "Client Account";
        CAccount: Record "Client Account";
        KYCTier: Code[15];
        ClientAccount: Record "Client Account";
    begin
        CAccount.Reset;
        CAccount.SetRange("Client ID", ClientID);
        CAccount.SetRange(Goals, true);
        CAccount.SetRange("Account Status", CAccount."Account Status"::Active);
        if CAccount.Count = 10 then
          exit('You cannot create more than 10 goals');
        
        ClientAccount.Reset;
        ClientAccount.SetRange("Client ID",ClientID);
        if (ClientAccount.FindFirst) and (ClientAccount."KYC Tier" <> '') then
          KYCTier := ClientAccount."KYC Tier";
        
        with CA do begin
          Validate("Client ID",ClientID);
          Validate(Goals, true);
          Validate("Goal Name", GoalName);
          Validate("Goals Maturity Date",GoalMaturityDate);
          Validate("Fund No", 'ARMMMF');
          if Insert(true) then begin
            "Account No To Split To" := '';
            "Last Modified By":=UserId;
            "Last Modified DateTime":=CurrentDateTime;
            "Old Account Number":="Client ID";
            "Old MembershipID":="Client ID";
            "Created Date" := Today;
            "KYC Tier" := KYCTier;
            "Account Status":="Account Status"::Active;
            if Modify(true) then
                exit("Account No")
              else
                exit('')
              end;
        end
        
        /*WITH ClientAccount DO BEGIN
          VALIDATE("Client ID",ClientID);
           //check goals to reallocate or exit when up to 10
               ClientAcc.RESET;
               ClientAcc.SETRANGE("Client ID",ClientID);
               ClientAcc.SETRANGE("Fund No",'ARMMMF');
               ClientAcc.SETRANGE(Goals,TRUE);
               ClientAcc.SETRANGE("Pay Day", FALSE);
               IF ClientAcc.COUNT = 10 THEN BEGIN
                 ClientAccount2.RESET;
                 ClientAccount2.SETRANGE("Client ID",ClientID);
                 ClientAccount2.SETRANGE("Fund No",'ARMMMF');
                 ClientAccount2.SETRANGE(Goals,TRUE);
                 ClientAccount2.SETRANGE("Account Status",ClientAccount."Account Status"::Closed);
                 IF ClientAccount2.FINDFIRST THEN BEGIN
                   ClientAccount2."Account Status" := ClientAccount2."Account Status"::Active;
                   ClientAccount2."Goal Name" := GoalName;
                   ClientAccount2."Pay Day" := FALSE;
                   ClientAccount2."Goals Maturity Date" := GoalMaturityDate;
                   IF ClientAccount2.MODIFY(TRUE) THEN
                   EXIT(ClientAccount2."Account No");
                 END ELSE BEGIN
                  ERROR('You cant create more than 10 goals');
                 END;
             END;
            //check end
            IF ClientAcc.COUNT = 9 THEN BEGIN
            //check if payday account exist for client
              ClientAcct.RESET;
              ClientAcct.SETRANGE("Client ID", ClientID);
              ClientAcct.SETRANGE("Fund No", 'ARMMMF');
              ClientAcct.SETRANGE("Pay Day", TRUE);
              IF ClientAcct.FINDLAST THEN BEGIN
                "Account No" := ClientAcct."Account No";
                "Fund Sub Account" := '99';
            //end
              END ELSE
              INSERT;
              END ELSE BEGIN
                INSERT;
              END;
            //INSERT;
          Goals := TRUE;
          VALIDATE("Fund No",'ARMMMF');
          VALIDATE("Goal Name",GoalName);
          VALIDATE("Goals Maturity Date",GoalMaturityDate);
          "Pay Day" := FALSE;
          "Created Date" := TODAY;
          "Dividend Mandate" := "Dividend Mandate"::Reinvest;
          "Last Modified By":=USERID;
          "Last Modified DateTime" :=CURRENTDATETIME;
          "Old Account Number":="Client ID";
          "Old MembershipID":="Client ID";
          "Account Status":="Account Status"::Active;
          IF MODIFY(TRUE) THEN
            EXIT("Account No")
          ELSE
            EXIT('')
        
        END*/

    end;

    procedure CreateGoalsBackup(ClientID: Code[50];GoalName: Text[50];GoalMaturityDate: Date): Code[40]
    var
        ClientAccount: Record "Client Account";
        ClientAccount2: Record "Client Account";
        ClientAcc: Record "Client Account";
    begin
        with ClientAccount do begin
          Validate("Client ID",ClientID);
          //check goals to reallocate or exit when up to 10
               ClientAcc.Reset;
               ClientAcc.SetRange("Client ID",ClientID);
               ClientAcc.SetRange("Fund No",'ARMMMF');
               ClientAcc.SetRange(Goals,true);
               if ClientAcc.FindLast then begin
               if ClientAcc."Fund Sub Account" = '99' then begin
               if ClientAcc.Count = 10 then begin
                 ClientAccount2.Reset;
                 ClientAccount2.SetRange("Client ID",ClientID);
                 ClientAccount2.SetRange("Fund No",'ARMMMF');
                 ClientAccount2.SetRange(Goals,true);
                 ClientAccount2.SetRange("Account Status",ClientAccount."Account Status"::"In Active");
                 if ClientAccount2.FindFirst then begin
                 ClientAccount2."Account Status" := ClientAccount2."Account Status"::Active;
                   ClientAccount2."Goal Name" := GoalName;
                   ClientAccount2."Goals Maturity Date" := GoalMaturityDate;
                 if ClientAccount2.Modify(true) then
                 exit(ClientAccount2."Account No");
               end
               else begin
               Error('You cant create more than 10 goals');
               end;
             end;
             end;
             end;
            //check end
          Goals := true;
          Insert;
          Validate("Fund No",'ARMMMF');
          Validate("Goal Name",GoalName);
          Validate("Goals Maturity Date",GoalMaturityDate);
          "Pay Day" := false;
          "Dividend Mandate" := "Dividend Mandate"::Reinvest;
          "Last Modified By":=UserId;
          "Last Modified DateTime" :=CurrentDateTime;
          "Old Account Number":="Client ID";
          "Old MembershipID":="Client ID";
          "Account Status":="Account Status"::Active;
          if Modify(true) then
            exit("Account No")
          else
            exit('')

        end
    end;

    procedure CreateGoalsRedemption(Caseno: Code[40];AccountNo: Code[50];ValueDate: Date;RedemptionType: Option "Part",Full;AmountRedeem: Decimal;noofunits: Decimal;Source: Text;DocumentPath: Text;DocumentPath2: Text;Remarks: Text;IsReversal: Boolean;OnlineRedemption: Boolean): Code[30]
    var
        Redemption: Record Redemption;
        PostedRedemption: Record "Posted Redemption";
    begin
          if PostedRedemption.Get(Caseno) then
            Error('This Case No has already Been Processed');

        with Redemption do begin
          Init;
          Validate("Transaction No",Caseno);
          Validate("Account No",AccountNo);
          Validate("Value Date",ValueDate);
          Validate("Transaction Date",Today);
          Validate("Redemption Type",RedemptionType);
          if OnlineRedemption then
          Validate("Request Mode",Redemption."Request Mode"::Online);
         if RedemptionType=RedemptionType::Part then
          Validate(Amount,AmountRedeem);
          if "No. Of Units"<>0 then
          Validate("No. Of Units");
          "Data Source":=Source;
          "Document Path":=DocumentPath;
          "Document Link":="Document Path";
          "Document Path2":=DocumentPath2;
          "Creation Date" := CurrentDateTime;
           FundAdministrationSetup.Get;
              if (FundAdministrationSetup."CX Verification Threshold"<>0) and
                 (Redemption.Amount>FundAdministrationSetup."CX Verification Threshold") then begin
                  Redemption."Redemption Status":=Redemption."Redemption Status"::"Customer Experience Verification";
                  //Email Notification
                  NotificationFunctions.CreateNotificationEntry(0,UserId,CurrentDateTime,'Redemption',Redemption."Transaction No",
              Redemption."Client Name",Redemption."Client ID",'Customer Experience Verification',Redemption."Fund Code",Redemption."Account No",
          'Redemption',Redemption.Amount,1)
             end else
              Redemption."Redemption Status":=Redemption."Redemption Status"::"ARM Registrar";
              //Email Notification
              NotificationFunctions.CreateNotificationEntry(0,UserId,CurrentDateTime,'Redemption',Redemption."Transaction No",
              Redemption."Client Name",Redemption."Client ID",'ARM Registrar',Redemption."Fund Code",Redemption."Account No",
          'Redemption',Redemption.Amount,2);
            if OnlineRedemption then
              Redemption."Redemption Status":=Redemption."Redemption Status"::Verified;
              Redemption."For Verification" := true;

            //Maxwell: To set up Recon No from the end.
            if Redemption."Recon No" = '' then begin
              FundAdministrationSetup.TestField(FundAdministrationSetup."Recon Nos");
              NoSeriesMgt.InitSeries(FundAdministrationSetup."Recon Nos",'',0D,"Recon No","No. Series");
            end;

          Insert;
          //to uncomment for stp

          if OnlineRedemption then begin
            if (FundAdministrationSetup."Online Threshold"<>0) and (Redemption.Amount<=FundAdministrationSetup."Online Threshold") then begin
              //Maxwell: STP Threshold of 1,000,000 031120
              if CheckIfSTP(Redemption."Account No",Redemption."Value Date",Redemption.Amount) then begin
                  FundTransactionManagement.PostSingleRedmptionOnline(Redemption);
              //CHARGES
              if Redemption."Fund Code" = 'ARMMMF' then
                  FundTransactionManagement.InsertAccruedInterestCharge(Redemption."Account No",Redemption."Charges On Accrued Interest",Redemption."Fund Code",Redemption."Value Date");
              //END
              if PostedRedemption.Get(Caseno) then begin
                PostedRedemption."Sent to Treasury":=true;
                PostedRedemption."For Verification":= false;
                PostedRedemption.Modify(true);
              end;
            end;
           end;
          end;
         exit("Transaction No");

        end;
    end;

    procedure CreateGoalsSubscription(Accountno: Code[50];BankAccountNo: Code[10];BankCode: Code[20];Amountsubscribed: Decimal;ValueDate: Date;Source: Text;DirectPosting: Boolean;ReferenceCode: Text[100];Notes: Text[250]): Code[30]
    var
        Subscription: Record Subscription;
    begin
        with Subscription do begin
          Init;
          Subscription.Reset;
          Subscription.SetRange("Reference Code",ReferenceCode);
          if Subscription.FindFirst then
            Error('Reference Code already exist');
          postedSubcription.Reset;
          postedSubcription.SetRange("Reference Code",ReferenceCode);
          if postedSubcription.FindFirst then
            Error('Reference Code already exist');

          Validate("Account No",Accountno);
          Validate("Bank Account No",BankAccountNo);
          Validate("Bank Code",BankCode);
          Validate("Value Date",ValueDate);
          Validate(Amount,Amountsubscribed);
          Validate("Reference Code",ReferenceCode);
          Validate(Subscription.Remarks,Notes);
          "Data Source":=Source;
          "Direct Posting":=DirectPosting;
          "Creation Date" := CurrentDateTime;
          if DirectPosting then begin
            "Subscription Status":="Subscription Status"::Confirmed;
            AutoMatched:=true;
          end;
          if Insert(true) then begin
          if DirectPosting then
            FundTransactionManagement.PostSTPSubscription(Subscription);
           exit(Subscription.No)

          end
          else
            exit('');

        end
    end;

    procedure GetPostedRedemptions(var RedemptionsResponse: XMLport "Export Redemptions";StartDate: Date;EndDate: Date)
    var
        redemption: Record "Posted Redemption";
    begin
        redemption.Reset;
        redemption.SetRange("Date Posted",StartDate ,EndDate);
        redemption.SetFilter("Request Mode", '%1|%2', redemption."Request Mode"::Online, redemption."Request Mode"::"Walk in");
        RedemptionsResponse.SetTableView(redemption);
    end;

    procedure CreateNewClient(ClientID: Code[40];FirstName: Text[50];LastName: Text[50];MiddleNames: Text[50];Address: Text[250];City: Text;Contct: Text;PhoneNo: Code[20];Title: Code[10];HouseNo: Code[10];Estate: Text;Countrys: Code[100];AccountManager: Code[20];States: Code[20];StreetName: Text[250];DateOfBirth: Date;Nationlity: Code[100];Occupation: Text;MothersName: Text;Genderp: Option " ",Male,Female;Maritalstatus: Option " ",Single,Married,Divorced,Widowed;PlaceofBirth: Text;SponsorFname: Text;SponsorLname: Text;SponsorMname: Text;SponsTitle: Code[10];IdentificationType: Option Please_Select,Passport,"Driving Licence","ID Card","National ID Card","Voters Cards",Others;IdentificationNumber: Code[50];BVN: Code[20];Jurisdiction: Text;UsTaxNo: Text;IsPoliticallyExposed: Boolean;PoliticalInfo: Text;Religon: Code[20];NINp: Code[20];DiasporaClient: Boolean;ClientStatus: Option Active,Inactive,Closed;EmailNotification: Boolean;PostNotification: Boolean;OfficeNotification: Boolean;SmsNotification: Boolean;SocialMedia: Boolean;DateCreated: Date;Createdby: Code[50];Email: Text[100];ClientType: Option " ",Individual,Joint,Corporate,Minor;MainAccount: Code[40];IVNumber: Code[40];BankCode: Code[30];BankBranch: Code[50];Source: Text;BankAccountNo: Text): Boolean
    var
        Client: Record Client;
        Titlep: Code[100];
    begin
         if Countrys='' then Countrys:='NIGERIA';
         Titlep:=Title;
         if Client.Get(ClientID) then
           Error('Client already Exist');
        with Client do begin
          Init;
          "Membership ID":=ClientID;
          Validate("Client Type",ClientType);
          Validate("First Name",FirstName);
          Validate(Surname,LastName);
          Validate("Other Name/Middle Name",MiddleNames);
          Validate("Mailing Address",Address);
          Validate(Country,Countrys);
          Validate("City/Town",City);
          Validate(Contact,Contct);
          Validate("Phone Number",PhoneNo);
          Validate(Title,Titlep);
          Validate("House Number",HouseNo);
          Validate("Premises/Estate",Estate);
        
          Validate(State,States);
          Validate("Street Name",StreetName);
          Validate("Date Of Birth",DateOfBirth);
          Validate(Nationality,Nationlity);
          Validate("Business/Occupation",Occupation);
          Validate("Mothers Maiden Name",MothersName);
          Validate(Gender,Genderp);
          Validate("Marital Status",Maritalstatus);
          Validate("Place of Birth",PlaceofBirth);
           if ClientType=ClientType::Minor then begin
          Validate("Sponsor First Name",SponsorFname);
          Validate("Sponsor Last Name",SponsorLname);
          Validate("Sponsor Middle Names",SponsorMname);
          Validate(SponsorTitle,SponsTitle);
          end;
          Validate("Type of ID",IdentificationType);
          if IdentificationType<>IdentificationType::Please_Select then
            "ID Card Number":=IdentificationNumber;
        
            Validate("Account Executive Code",AccountManager);
          Validate("BVN Number",BVN);
          Validate(Jurisdiction,Jurisdiction);
          Validate("US Tax Number",UsTaxNo);
          Validate("Politically Exposed Persons",IsPoliticallyExposed);
          Validate("Political Information",PoliticalInfo);
          Validate(Religion,Religon);
          Validate(NIN,NINp);
          Validate("Diaspora Client",DiasporaClient);
          Validate("Account Status",ClientStatus);
            Validate("E-Mail",Email);
          Validate("Email Notification",EmailNotification);
          Validate("Post Notification",PostNotification);
          Validate("Office Notification",OfficeNotification);
          Validate("SMS Notification",SmsNotification);
          Validate("Created Dates",DateCreated);
          Validate("Created By User ID",Createdby);
        
          Validate("Main Account",MainAccount);
          Validate("IV Number",IVNumber);
          Validate("Bank Code",BankCode);
          Validate("Bank Branch",BankBranch);
          Validate("Bank Account Number", BankAccountNo);
          "Last Update Source":=Source;
          "Last Modified By":=UserId;
          "Last Modified DateTime":=CurrentDateTime;
          "Account Status":="Account Status"::Active;
          Insert(true);
             exit(true)
         /*  ELSE
             EXIT(FALSE);*/
        
        
        end
        
        //The CreateClient code above was changed to the one below after request was made to increase length of characters for country on 10/05/2019.
        /*
        CreateClient(ClientID : Code[40];FirstName : Text[50];LastName : Text[50];MiddleNames : Text[50];Address : Text[250];City : Text;Contct : Text;PhoneNo : Code[20];Title : Code[10];HouseNo : Code[10];Estate : Text;Countrys : Code[10];AccountManager :
         IF Countrys='' THEN Countrys:='NIGERIA';
         Titlep:=Title;
         IF Client.GET(ClientID) THEN
           ERROR('Client already Exist');
        WITH Client DO BEGIN
          INIT;
          "Membership ID":=ClientID;
          VALIDATE("Client Type",ClientType);
          VALIDATE("First Name",FirstName);
          VALIDATE(Surname,LastName);
          VALIDATE("Other Name/Middle Name",MiddleNames);
          VALIDATE("Mailing Address",Address);
          VALIDATE(Country,Countrys);
          VALIDATE("City/Town",City);
          VALIDATE(Contact,Contct);
          VALIDATE("Phone Number",PhoneNo);
          VALIDATE(Title,Titlep);
          VALIDATE("House Number",HouseNo);
          VALIDATE("Premises/Estate",Estate);
        
          VALIDATE(State,States);
          VALIDATE("Street Name",StreetName);
          VALIDATE("Date Of Birth",DateOfBirth);
          VALIDATE(Nationality,Nationlity);
          VALIDATE("Business/Occupation",Occupation);
          VALIDATE("Mothers Maiden Name",MothersName);
          VALIDATE(Gender,Genderp);
          VALIDATE("Marital Status",Maritalstatus);
          VALIDATE("Place of Birth",PlaceofBirth);
           IF ClientType=ClientType::Minor THEN BEGIN
          VALIDATE("Sponsor First Name",SponsorFname);
          VALIDATE("Sponsor Last Name",SponsorLname);
          VALIDATE("Sponsor Middle Names",SponsorMname);
          VALIDATE(SponsorTitle,SponsTitle);
          END;
          VALIDATE("Type of ID",IdentificationType);
          IF IdentificationType<>IdentificationType::Please_Select THEN
            "ID Card Number":=IdentificationNumber;
        
            VALIDATE("Account Executive Code",AccountManager);
          VALIDATE("BVN Number",BVN);
          VALIDATE(Jurisdiction,Jurisdiction);
          VALIDATE("US Tax Number",UsTaxNo);
          VALIDATE("Politically Exposed Persons",IsPoliticallyExposed);
          VALIDATE("Political Information",PoliticalInfo);
          VALIDATE(Religion,Religon);
          VALIDATE(NIN,NINp);
          VALIDATE("Diaspora Client",DiasporaClient);
          VALIDATE("Account Status",ClientStatus);
            VALIDATE("E-Mail",Email);
          VALIDATE("Email Notification",EmailNotification);
          VALIDATE("Post Notification",PostNotification);
          VALIDATE("Office Notification",OfficeNotification);
          VALIDATE("SMS Notification",SmsNotification);
          VALIDATE("Created Dates",DateCreated);
          VALIDATE("Created By User ID",Createdby);
        
          VALIDATE("Main Account",MainAccount);
          VALIDATE("IV Number",IVNumber);
          "Last Update Source":=Source;
          "Last Modified By":=USERID;
          "Last Modified DateTime":=CURRENTDATETIME;
          "Account Status":="Account Status"::Active;
          INSERT(TRUE);
             EXIT(TRUE)
         {  ELSE
             EXIT(FALSE);}
        
        
        END
        */

    end;

    procedure UpdateNewClient(ClientID: Code[40];FirstName: Text[50];LastName: Text[50];MiddleNames: Text[50];Addres: Text[250];Cityp: Text;Contct: Text;PhoneNo: Code[20];Titlep: Code[10];HouseNo: Code[10];Estate: Text;Countrys: Code[100];AccountManager: Code[20];Statep: Code[20];StreetName: Text[250];DateOfBirth: Date;Nationlity: Code[100];Occupationp: Text;MothersName: Text;Genderp: Option " ",Male,Female;Maritalstatus: Option " ",Single,Married,Divorced,Widowed;PlaceofBirth: Text;SponsorFname: Text;SponsorLname: Text;SponsorMname: Text;SponsTitle: Code[10];IdentificationType: Option Please_Select,Passport,"Driving Licence","ID Card","National ID Card","Voters Cards",Others;IdentificationNumber: Code[50];BVN: Code[20];Jurisdiction: Text;UsTaxNo: Text;IsPoliticallyExposed: Boolean;PoliticalInfo: Text;Religon: Code[20];NINp: Code[20];DiasporaClient: Boolean;ClientStatus: Option Active,Inactive,Closed;EmailNotification: Boolean;PostNotification: Boolean;OfficeNotification: Boolean;SmsNotification: Boolean;SocialMedia: Boolean;DateCreated: Date;Createdby: Code[50];Email: Text[100];ClientType: Option " ",Individual,Joint,Corporate,Minor;MainAccount: Code[40];IVNumber: Code[40];BankCode: Code[30];BankBranch: Code[50];Source: Text): Boolean
    var
        Client: Record Client;
        ClientAccount: Record "Client Account";
        countries: Record "Country/Region";
    begin

        if Client.Get(ClientID) then begin
        with Client do begin
         if ClientType<>ClientType::" " then
            Validate("Client Type",ClientType);
          if FirstName<>'' then
            Validate("First Name",FirstName);
          if LastName<>'' then
            Validate(Surname,LastName);
          if  MiddleNames <>'' then
            Validate("Other Name/Middle Name",MiddleNames);
          if Addres<>'' then
            Validate("Mailing Address",Addres);
           if Country <>'' then
            Validate(Country,Countrys);
          if Cityp<>'' then
            Validate("City/Town",Cityp);
          if Contct <>'' then
            Validate(Contact,Contct);
          if PhoneNo<>'' then
            Validate("Phone Number",PhoneNo);
          if Titlep <>'' then
            Validate(Title,Titlep);
          if HouseNo <>'' then
            Validate("House Number",HouseNo);
          if Estate <>'' then
            Validate("Premises/Estate",Estate);
           if AccountManager<>'' then
            Validate("Account Executive Code",AccountManager);
          if Statep <>'' then
            Validate(State,Statep);
          if StreetName <>'' then
            Validate("Street Name",StreetName);
          if DateOfBirth<> 0D then
            Validate("Date Of Birth",DateOfBirth);
          if Nationlity<>'' then
            Validate(Nationality,Nationlity);
          if Occupationp <>'' then
            Validate("Business/Occupation",Occupationp);
          if MothersName <>'' then
            Validate("Mothers Maiden Name",MothersName);
          if Genderp<>Genderp::" " then
            Validate(Gender,Genderp);
          if Maritalstatus<>Maritalstatus::" " then
            Validate("Marital Status",Maritalstatus);
          if PlaceofBirth<>'' then
            Validate("Place of Birth",PlaceofBirth);
          if ClientType=ClientType::Minor then begin
            if SponsorFname<>'' then
              Validate("Sponsor First Name",SponsorFname);
            if SponsorLname <>'' then
              Validate("Sponsor Last Name",SponsorLname);
            if SponsorMname <>'' then
              Validate("Sponsor Middle Names",SponsorMname);

          if SponsTitle <>'' then
            Validate(SponsorTitle,SponsTitle);

         end;
          if IdentificationType<> IdentificationType::Please_Select then
            Validate("Type of ID",IdentificationType);
          if IdentificationType<>IdentificationType::Please_Select then
            Validate("ID Card Number",IdentificationNumber);
          if BVN<>'' then
            Validate("BVN Number",BVN);
          if Jurisdiction<>'' then
            Validate(Jurisdiction,Jurisdiction);
          if UsTaxNo<>'' then
            Validate("US Tax Number",UsTaxNo);
            Validate("Politically Exposed Persons",IsPoliticallyExposed);
          if PoliticalInfo<>'' then
            Validate("Political Information",PoliticalInfo);
          if Religon<>'' then
            Validate(Religion,Religon);
          if NINp <>'' then
            Validate(NIN,NINp);
            Validate("Diaspora Client",DiasporaClient);

            Validate("Account Status",ClientStatus);
           // VALIDATE("Email Notification",EmailNotification);
           // VALIDATE("Post Notification",PostNotification);
           // VALIDATE("Office Notification",OfficeNotification);
            //VALIDATE("SMS Notification",SmsNotification);
          if Email<>'' then
            Validate("E-Mail",Email);

          "Last Update Source":=Source;
           if MainAccount<>'' then
            Validate("Main Account",MainAccount);
           if IVNumber <>'' then
            Validate("IV Number",IVNumber);
           if BankCode <>'' then
            Validate("Bank Code",BankCode);
           if BankBranch <>'' then
            Validate("Bank Branch",BankBranch);
            "Last Modified By":=UserId;
          "Last Modified DateTime":=CurrentDateTime;

           Modify(true);
        ClientAccount.Reset;
        ClientAccount.SetRange("Client ID",Client."Membership ID");
        if ClientAccount.FindFirst then
          repeat
            ClientAccount.Validate("Client ID");
            ClientAccount.Modify;
          until ClientAccount.Next=0;

             exit(true)


          end
        end else
        Error('Client Does not Exist');
    end;

    procedure CreateClientAccount(ClientID: Code[50];ReferrerMembershipID: Code[50];FundCode: Code[40];BankCode: Code[30];BankBranch: Code[30];BankAccName: Text;BankAccountNo: Code[50];KYCTier: Code[20];DividendMandate: Option " ",Payout,Reinvest;Source: Text;PayDay: Boolean;ForeignBankName: Code[50];SwiftCode: Code[50];RoutingNo: Code[50];FinalCredit: Code[50];BeneficiaryAccountNo: Code[50]): Code[40]
    var
        ClientAccount: Record "Client Account";
    begin
        with ClientAccount do begin
          Init;
          Validate("Client ID",ClientID);
          Validate("Pay Day",PayDay);
          Validate("Fund No",FundCode);
          Validate("Bank Code",BankCode);
          Validate("Bank Branch",BankBranch);
          Validate("Bank Account Name",BankAccName);
          Validate("Bank Account Number",BankAccountNo);
          Validate("KYC Tier",KYCTier);
          Validate("Dividend Mandate",DividendMandate);
          Validate("Referrer Membership ID",ReferrerMembershipID);
          //Maxwell: Modified for EUROBOND BEGIN
          "Foreign Bank Account" := ForeignBankName;
          "Swift Code" := SwiftCode;
          "Routing No" := RoutingNo;
          "Final Credit" := FinalCredit;
          "Benificiary Account Number" := BeneficiaryAccountNo;
          "Account No To Split To" := '';
        //END
          "Last Modified By":=UserId;
          "Created Date" := Today;
          "Last Modified DateTime":=CurrentDateTime;
          "Old Account Number":="Client ID";
          "Old MembershipID":="Client ID";
          "Account Status":="Account Status"::Active;
          if Insert(true) then
            exit("Account No")
          else
            exit('')

        end
    end;

    procedure UpdateClientAccount(AccountNo: Code[50];ClientID: Code[50];FundCode: Code[40];BankCode: Code[30];BankBranch: Code[30];BankAccName: Text;BankAccountNo: Code[50];KYCTier: Code[20];DividendMandate: Option " ",Payout,Reinvest;Source: Text): Boolean
    var
        ClientAccount: Record "Client Account";
    begin
        //Maxwell: To update client account. Updated on 05072019
        if ClientAccount.Get(AccountNo) then begin
          ClientAccount.SetFilter("Account No",AccountNo);
          if ClientAccount.FindFirst then
            ClientAccount."Dividend Mandate" := DividendMandate;
            ClientAccount."KYC Tier" := KYCTier;
            ClientAccount."Last update Source":=Source;
            ClientAccount."Last Modified By":=UserId;
            ClientAccount."Last Modified DateTime":=CurrentDateTime;
          if ClientAccount.Modify(true) then
            exit(true)
          else
            exit(false);
        end
        
        /*ClientAccount.GET(AccountNo);
        WITH ClientAccount DO BEGIN
        {  IF "Client ID"<>'' THEN
            VALIDATE("Client ID",ClientID);}
          IF FundCode<>'' THEN
            VALIDATE("Fund No",FundCode);
          IF BankCode <>'' THEN
            VALIDATE("Bank Code",BankCode);
          IF BankBranch <>'' THEN
            VALIDATE("Bank Branch",BankBranch);
          IF BankAccName <>'' THEN
           VALIDATE("Bank Account Name",BankAccName);
          IF BankAccountNo <>'' THEN
          VALIDATE("Bank Account Number",BankAccountNo);
          IF KYCTier <>'' THEN
          VALIDATE("KYC Tier",KYCTier);
          IF DividendMandate <> DividendMandate::" " THEN
            VALIDATE("Dividend Mandate",DividendMandate);
          "Last update Source":=Source;
          "Last Modified By":=USERID;
          "Last Modified DateTime":=CURRENTDATETIME;
          IF MODIFY(TRUE) THEN
            EXIT(TRUE)
          ELSE
            EXIT(FALSE);
        
        END*/

    end;

    procedure CreateNextofKin(ClientID: Code[50];NOKRelationShip: Code[20];NOKTitle: Text;NOKLastName: Text;NOKFirstName: Text;NOKMiddleName: Text;NOKGender: Option Please_Select,Male,Female;NOKAddress: Text;NOKTelephoneNo: Code[20];NOKEmail: Text;NOKState: Text;NOKTown: Text;NOKCountry: Code[20];Updatesource: Text): Integer
    var
        Client: Record Client;
        ClientNextofKin: Record "Client Next of Kin";
        entryno: Integer;
        ClientNextofKin2: Record "Client Next of Kin";
        emailNOK: Text;
    begin
        if not Client.Get(ClientID) then
            Error('Client Does not Exist');
        emailNOK:= NOKEmail;
        ClientNextofKin2.Reset;
        ClientNextofKin2.SetRange("Client ID",ClientID);
        if ClientNextofKin2.FindLast then
        entryno:=ClientNextofKin2."Line No"+1
        else
        entryno:=1;
          with ClientNextofKin do begin
            Init;
            "Line No":=entryno;
            Validate("Client ID",ClientID);
            Validate("NOK Relationship",NOKRelationShip);
            Validate("NOK Title",NOKTitle);
            Validate("NOK Last Name",NOKLastName);
            Validate("NOK First Name",NOKFirstName);
            Validate("NOK Middle Name",NOKMiddleName);
            Validate("NOK Gender",NOKGender);
            Validate("NOK Address",NOKAddress);
            Validate("NOK Telephone No",NOKTelephoneNo);
            Validate("NOK Email",emailNOK);
            Validate("NOK State of Origin",NOKState);
            Validate("NOK Town",NOKTown);
            Validate("NOK Country",NOKCountry);
            Source:=Updatesource;
            if Insert(true) then
              exit("Line No")
            else
              exit(0);
          end;
    end;

    procedure GetMutualFundsDistributableIncome(ValueDate: Date;FundCode: Code[40];DistributableIncome: Decimal;WhtAmount: Decimal;TaxRate: Decimal;PaymentDate: Date;UniqueReference: Code[50];CreatedDate: Date): Boolean
    var
        IncomeRegister: Record "Income Register";
    begin
        IncomeRegister.Reset;
        IncomeRegister.SetRange("Value Date",ValueDate);
        IncomeRegister.SetRange("Fund ID",FundCode);
        IncomeRegister.SetRange(Reference,UniqueReference);
        if IncomeRegister.FindFirst then
          Error('Income already exists for this Fund %1',FundCode)
        else begin
          IncomeRegister.Init;
          IncomeRegister.Validate("Value Date",ValueDate);
          IncomeRegister.Validate("Fund ID",FundCode);
          IncomeRegister.Validate("Total Income",DistributableIncome);
          IncomeRegister.Validate("WHT Amount",WhtAmount);
          IncomeRegister.Validate("WHT Rate",TaxRate);
          IncomeRegister.Validate("Expected Payment Date",PaymentDate);
          IncomeRegister.Validate(Reference,UniqueReference);
          IncomeRegister."Created Date" := Today;
          IncomeRegister."Created By" := 'Deluxe-XFUND';
          IncomeRegister."Date Received" := CreatedDate;
          if IncomeRegister.Insert(true) then
            exit(true)
          else
            exit(false)
        end
    end;

    procedure GetNomineeDividend(var GetNominee: XMLport "Export Nominee Client Dividend";Date: Date)
    var
        Nominee: Record "Nominee Client Dividend";
    begin
        Nominee.Reset;
        Nominee.SetRange(CreatedDate,Date);
        Nominee.SetRange(Sent,false);
        //Nominee.Sent := FALSE
        //Nominee.MODIFY(TRUE);
        GetNominee.SetTableView(Nominee);
    end;

    procedure GetMutualFundDividendPayment(var GetDividendPayment: XMLport "Export MF Dividend Payment";Date: Date)
    var
        Dividend: Record "MF Dividend";
    begin
        Dividend.Reset;
        Dividend.SetRange(CreatedDate,Date);
        //Dividend.SETRANGE(Sent,FALSE);
        //Nominee.Sent := FALSE
        //Nominee.MODIFY(TRUE);
        GetDividendPayment.SetTableView(Dividend);
    end;

    procedure GetMutualFundDividendReinvest(var GetDividendReinvest: XMLport "Export MF Dividend Reinvest";Date: Date)
    var
        DividendReinvest: Record "MF Dividend Reinvest Summary";
    begin
        DividendReinvest.Reset;
        DividendReinvest.SetRange(CreatedDate,Date);
        GetDividendReinvest.SetTableView(DividendReinvest);
    end;

    procedure CheckClientNOK(ClientID: Code[40]): Text
    var
        Client: Record Client;
        ClientNok: Record "Client Next of Kin";
    begin
        Client.Reset;
        if Client.Get(ClientID) then begin
          ClientNok.Reset;
          ClientNok.SetRange("Client ID", ClientID);
          if ClientNok.FindFirst then
            exit(Format(ClientNok."Line No"))
          else
            exit('No Next of Kin for this client.')
        end else
          exit('Client does not exist.')
    end;

    procedure IsDuplicateRedemption(AccountNo: Code[40];Amount: Decimal;ValueDate: Date): Boolean
    var
        Redemption: Record Redemption;
        PostedRedemption: Record "Posted Redemption";
    begin
        Redemption.Reset;
        Redemption.SetRange("Account No", AccountNo);
        Redemption.SetRange("Value Date", ValueDate);
        Redemption.SetRange(Amount, Amount);
        if Redemption.FindFirst then
          exit(true)
        else begin
          PostedRedemption.Reset;
          PostedRedemption.SetRange("Account No", AccountNo);
          PostedRedemption.SetRange("Value Date", ValueDate);
          PostedRedemption.SetRange(Amount,Amount);
          if PostedRedemption.FindFirst then
            exit(true)
          else
            exit(false)
        end;
    end;

    procedure GetChargeOnEarlyWithdrawal(FundCode: Code[40];Amount: Decimal;AcctNo: Code[40];RequestID: Code[50];ValueDate: Date): Decimal
    var
        FundAdministration: Codeunit "Fund Administration";
        Charge: Decimal;
        RequestedUnits: Decimal;
        TransactType: Option Subscription,Redemption,Dividend;
    begin
        //RequestedUnits := FundAdministration.GetFundNounits(FundCode,ValueDate,Amount,TransactType::Redemption);
        Charge := 0; //FundAdministration.GetMutualFundPenaltyCharge(FundCode,RequestedUnits,AcctNo,RequestID,ValueDate);
        exit(Charge);
    end;

    procedure InitialUnitTranfer(CaseNo: Code[50];TransactionDate: Date;TransferType: Option "Same Fund","Across Funds";FromAccountNo: Code[30];ToAccountNo: Code[30];NoOfUnits: Decimal;DocumentLink: Text): Code[40]
    var
        UnitTransfer: Record "Fund Transfer";
    begin
        with UnitTransfer do begin
          Init;
          Validate(No,CaseNo);
          Validate("Value Date", Today);
          Validate("Transaction Date", TransactionDate);
          Validate(Type, TransferType);
          Validate("From Account No", FromAccountNo);
          Validate("To Account No", ToAccountNo);
          Validate(Amount,NoOfUnits);
          "Fund Transfer Status" := "Fund Transfer Status"::"ARM Registrar";
          "Document Link" := DocumentLink;
          if UnitTransfer.Insert(true) then
            exit(No)
          else
            exit('Unable to transfer units');
        end
    end;

    procedure GetUnitTransferStatus(var ExportUnitTransfer: XMLport "Export Unit Transfer Status";CaseNo: Code[40])
    var
        FundTransfer: Record "Fund Transfer";
    begin
        FundTransfer.Reset;
        FundTransfer.SetRange(No, CaseNo);
        if FundTransfer.FindFirst then
          ExportUnitTransfer.SetTableView(FundTransfer)
        else
          Error('Unit Transfer not exist')
    end;

    procedure CreateSubscriptionMatchingLines(ValueDate: Date;TransDate: Date;Amount: Decimal;Narration: Text;Channel: Code[10];TransReferenceNo: Text;AccountNo: Code[40];MembershipID: Code[20];PayMode: Option;HeaderNo: Code[30]): Text[250]
    var
        SubscriptionMatchingheader: Record "Subscription Matching header";
        SubscriptionMatchingLines: Record "Subscription Matching Lines";
        SubscriptionMatchingLines2: Record "Subscription Matching Lines";
        Lineno: Integer;
        TransNo: Code[250];
        SubscriptionLog: Record "Subscription Matching Line Log";
    begin
        //Trim spaces from transaction reference
        TransNo := DelChr(TransReferenceNo,'<>');

        SubscriptionMatchingheader.Reset;
        SubscriptionMatchingheader.SetRange(No, HeaderNo);
        if not SubscriptionMatchingheader.FindFirst then
          exit('01');
        //01 - Header No does not exist. Create Header No first.
        SubscriptionMatchingheader.Reset;
        SubscriptionMatchingheader.SetRange(No, HeaderNo);
        SubscriptionMatchingheader.SetRange(Posted, true);
        if SubscriptionMatchingheader.FindFirst then
          exit('03');
        //03 - Subscription Matching Header and Lines have been posted. Create another Header No for the new transaction.
        //check for duplicates using transaction reference no.
        SubscriptionMatchingLines2.Reset;
        SubscriptionMatchingLines2.SetRange("Automatch Reference",TransNo);
        if SubscriptionMatchingLines2.FindFirst then
          Error('02');
        //
        SubscriptionMatchingLines2.Reset;
        SubscriptionMatchingLines2.SetRange("Automatch Reference",TransNo);
        if SubscriptionMatchingLines2.FindFirst then
          exit('02');
        //02 - Duplicate. Subcription Line already exist
        //check
        // SubscriptionMatchingLines2.RESET;
        //  SubscriptionMatchingLines2.SETRANGE("Automatch Reference",TransNo);
        //  IF SubscriptionMatchingLines2.FINDFIRST THEN
        //    ERROR('02');
        //==================
          SubscriptionMatchingLines2.Reset;
          SubscriptionMatchingLines2.SetRange(TransactionReference,TransNo);
          if SubscriptionMatchingLines2.FindFirst then
            Error('02');
          postedSubcription.Reset;
          postedSubcription.SetRange("Automatch Ref",TransNo);
          if postedSubcription.FindFirst then
            Error('02');
          postedSubcription.Reset;
          postedSubcription.SetRange("Reference Code",TransNo);
          if postedSubcription.FindFirst then
            Error('02');
        //check end
        //insert to subscription log

        SubscriptionLog.Reset;
        SubscriptionLog."Automatch Reference" := TransNo;
        SubscriptionLog."Header No" := HeaderNo;
        SubscriptionLog."Creation Date" := CurrentDateTime;
        if SubscriptionLog.Insert(true) then begin

        SubscriptionMatchingLines2.Reset;
        SubscriptionMatchingLines2.SetRange("Header No",SubscriptionMatchingheader.No);
        if SubscriptionMatchingLines2.FindLast then
         Lineno:=SubscriptionMatchingLines2."Line No"
        else
          Lineno:=0;
        Lineno:=Lineno+1;
        SubscriptionMatchingLines.Init;
        SubscriptionMatchingLines."Header No":=HeaderNo;
        SubscriptionMatchingLines."Line No":=Lineno;
        SubscriptionMatchingLines."Automatch Reference" := TransNo;// trimmed transaction reference no.
        SubscriptionMatchingLines."Transaction Date":=TransDate;
        SubscriptionMatchingLines."Value Date":=ValueDate;
        SubscriptionMatchingLines.Narration:=Narration;
        SubscriptionMatchingLines.Reference:=MembershipID;
        SubscriptionMatchingLines."Credit Amount":=Amount;
        SubscriptionMatchingLines.Posted:=false;
        SubscriptionMatchingLines."Payment Mode" := PayMode;
        SubscriptionMatchingLines.Validate("Account No",AccountNo);
        SubscriptionMatchingLines.Channel:=Channel;
        SubscriptionMatchingLines."Creation Date" := CurrentDateTime;
        SubscriptionMatchingLines."Auto Matched" := true;
        //SubscriptionMatchingLines."Fund Code":=FundCode;
        if SubscriptionMatchingLines.Insert(true) then
         exit('00');
        end else begin
          exit('02');
        end;
        //00 - Successful
    end;
}

