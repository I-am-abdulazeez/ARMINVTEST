codeunit 50008 ExternalCallService
{

    trigger OnRun()
    var
        startdate: Date;
        enddate: Date;
    begin
        /*Response := SendNomineeClientDividendPayment('AKINBC','ARMMMF','43',123123D,010124D,186.28,1,186.28,0,'0124516495');
        MESSAGE(Response);
        Response := SendNomineeClientDividendAccrual('CUCC','ARMMMF','43','2024-02-29','2024-04-01',5822.1791,5822.1791,0);
        MESSAGE(Response);*/

    end;

    var
        TEMPBLOB3: Record TempBlob;
        base64: Text;
        FundAdministrationSetup: Record "Fund Administration Setup";
        Response: Text;

    procedure SendExternalRegistrarRequest(Fundcode: Code[40];FundName: Text;EaAccountNumber: Code[40];RegistrarAccountNumber: Code[10];InvestorName: Text;RedeemUnit: Text;PdfImages: Text;PdfName: Text;DocumentType: Option Redemption,Subscription,UnitTransfer,OnlineIndemnity;DocumentNo: Code[40]): Code[40]
    var
        i: Integer;
        xml: DotNet XmlDocument;
        xmlnodelist: DotNet XmlNodeList;
        xmlnode: DotNet XmlNode;
        Success: Text;
        j: Integer;
        XMLAttrib: DotNet XmlAttributeCollection;
        Nodes: Integer;
        controlID: Text;
        Result: Text;
        RecordExportBuffer: Record "Record Export Buffer";
        Redemption: Record Redemption;
        FundTransfer: Record "Fund Transfer";
        OnlineIndemnityMandate: Record "Online Indemnity Mandate";
    begin
        FundAdministrationSetup.Get;
        FundAdministrationSetup.TestField("External Registrar Webservice");
        xml :=  xml.XmlDocument();
        Result:=  FundAdministrationSetup."External Registrar Webservice"+'/SendPortfolio?fundCode='+ Fundcode  +'&fundname=' + FundName+'&EaAccountNumber=' + EaAccountNumber +'&RegistrarAccountNumber=' + RegistrarAccountNumber;
        Result +=  '&InvestorName=' + InvestorName+'&RedeemUnit=' + RedeemUnit+'&PdfName=' + PdfName+'&PdfImages=' + PdfImages  ;
        //MESSAGE(Result);
         xml.Load(Result );
         xmlnodelist := xml.SelectNodes('//*');
        if( xmlnodelist.ToString()<>'') then
        begin
        j:=xmlnodelist.Count;
          xmlnode := xmlnodelist.Item(0);
         if xmlnode.HasChildNodes then begin
           Success:=xmlnode.FirstChild.InnerText;
          controlID:=xmlnode.LastChild.InnerText;
        end ;
        
            /*IF controlID<>'' THEN BEGIN
              IF DocumentType=DocumentType::Redemption THEN BEGIN
              END ELSE IF DocumentType=DocumentType::Redemption THEN BEGIN
                IF Redemption.GET(DocumentNo) THEN BEGIN
                  Redemption."Registrar Control ID":=controlID;
                  Redemption.MODIFY;
                END
              END ELSE IF DocumentType=DocumentType::Subscription THEN BEGIN
        
              END ELSE IF DocumentType=DocumentType::UnitTransfer THEN BEGIN
                IF FundTransfer.GET(DocumentNo) THEN BEGIN
                  FundTransfer."Registrar Control ID":=controlID;
                  FundTransfer.MODIFY;
                END
              END ELSE IF DocumentType=DocumentType::OnlineIndemnity THEN BEGIN
                IF OnlineIndemnityMandate.GET(DocumentNo) THEN BEGIN
                  OnlineIndemnityMandate."Registrar Control ID":=controlID;
                  OnlineIndemnityMandate.MODIFY;
                END
              END
            END ELSE
            ERROR('There is no response from external Registrar');
            */
            exit(controlID);
        end

    end;

    procedure SendNibbs(AccountNumber: Code[50];PhoneNumber: Code[50];AccountName: Text;amount: Decimal;payer: Text;PayerAddress: Text;Narration: Text;ProductID: Text;Frequency: Text;Email: Text;StartDate: Text;EndDate: Text;Subscribercode: Text;BankCode: Text;fileextension: Text;fileBase64Encodedstring: Text;var DirectDebitMandate: Record "Direct Debit Mandate")
    var
        i: Integer;
        xml: DotNet XmlDocument;
        xmlnodelist: DotNet XmlNodeList;
        xmlnode: DotNet XmlNode;
        result: Text;
        j: Integer;
        ResponseCode: Text;
        ResponseDescription: Text;
        ReferenceNumber: Text;
        Childnodelist: DotNet XmlNodeList;
        Childnode: DotNet XmlNode;
    begin
        FundAdministrationSetup.Get;
        FundAdministrationSetup.TestField("NIBS Webservice");
        xml :=  xml.XmlDocument();
        
        result:=  FundAdministrationSetup."NIBS Webservice"+'/CreateDirectDebitMandate?AccountNumber='+ AccountNumber  +'&PhoneNumber=' + PhoneNumber+'&AccountName=' + AccountName +'&amount=' + Format(amount) +'&payerName=' + payer +'&PayerAddress=';
        result +=PayerAddress+ '&Narration=' + Narration+'&ProductID=' + ProductID+'&Frequency=' + Frequency+'&emailAddress=' + Email+'&StartDate=' + Format(StartDate)+'&EndDate=' + Format(EndDate)+'&Subscribercode=' +Subscribercode +'&BankCode=' ;
        result +=BankCode+'&fileExtension='+fileextension+'&fileBase64Encodedstring='+fileBase64Encodedstring;
        //MESSAGE(result);
         xml.Load(result );
        
        
        xmlnodelist := xml.SelectNodes('//*');
        if( xmlnodelist.ToString()<>'') then
        begin
        j:=xmlnodelist.Count;
        
        
        xmlnode := xmlnodelist.Item(0);
        Childnodelist := xmlnode.ChildNodes();
          for j := 0 to Childnodelist.Count - 1 do begin
            Childnode := Childnodelist.ItemOf(j);
            if Childnode.Name='ReferenceNumber' then
              ReferenceNumber:=Childnode.InnerText
            else if Childnode.Name='ResponseCode' then
              ResponseCode:=Childnode.InnerText
            else if  Childnode.Name='ResponseDescription' then
              ResponseDescription:=Childnode.InnerText;
          end;
        end;
        
        DirectDebitMandate."Response Code":=ResponseCode;
        DirectDebitMandate."Response Description":=ResponseDescription;
        DirectDebitMandate."Reference Number":=ReferenceNumber;
        
        /*MESSAGE(ResponseCode);
        MESSAGE(ResponseDescription);
        MESSAGE(ReferenceNumber);
        */

    end;

    local procedure DownloadfromSharepoint(URL: Text)
    begin
    end;

    local procedure GetExternalRegistrarRespoonse()
    var
        Redemption: Record Redemption;
        FundTransfer: Record "Fund Transfer";
        OnlineIndemnityMandate: Record "Online Indemnity Mandate";
        i: Integer;
        xml: DotNet XmlDocument;
        xmlnodelist: DotNet XmlNodeList;
        xmlnode: DotNet XmlNode;
        Success: Text;
        j: Integer;
        XMLAttrib: DotNet XmlAttributeCollection;
        Nodes: Integer;
        Result: Text;
        AdditionalComments: Text;
        Comments: Text;
        SignatureStatus: Text;
        Childnodelist: DotNet XmlNodeList;
        Childnode: DotNet XmlNode;
    begin
        FundAdministrationSetup.Get;
        FundAdministrationSetup.TestField("External Registrar Webservice");
        Redemption.Reset;
        Redemption.SetRange("Redemption Status",Redemption."Redemption Status"::"External Registrar");
        if Redemption.FindFirst then
          repeat
            xml :=  xml.XmlDocument();
            Result:=  FundAdministrationSetup."External Registrar Webservice"+'/PortfolioStatus?controlId='+ Redemption."Registrar Control ID";
            xml.Load(Result );
            xmlnodelist := xml.SelectNodes('//*');
            if( xmlnodelist.ToString()<>'') then
              begin
                j:=xmlnodelist.Count;
                xmlnode := xmlnodelist.Item(0);
                Childnodelist := xmlnode.ChildNodes();
                  for j := 0 to Childnodelist.Count - 1 do begin
                    Childnode := Childnodelist.ItemOf(j);
                    if Childnode.Name='SignatureStatus' then
                      SignatureStatus:=Childnode.InnerText
                    else if Childnode.Name='AdditionalComments' then
                      AdditionalComments:=Childnode.InnerText
                    else if  Childnode.Name='Comments' then
                      Comments:=Childnode.InnerText;
                  end;

               Redemption.SignatureStatus:=SignatureStatus;
               Redemption.AdditionalComments:=AdditionalComments;
               Redemption.Comments:=Comments;
               Redemption.Modify;
              end ;

          until Redemption.Next=0;
          //Fund Transfer

        FundTransfer.Reset;
        FundTransfer.SetRange("Fund Transfer Status",FundTransfer."Fund Transfer Status"::"External Registrar");
        if FundTransfer.FindFirst then
          repeat
             xml :=  xml.XmlDocument();
            Result:=  FundAdministrationSetup."External Registrar Webservice"+'/PortfolioStatus?controlId='+ FundTransfer."Registrar Control ID";
            xml.Load(Result );
            xmlnodelist := xml.SelectNodes('//*');
            if( xmlnodelist.ToString()<>'') then
              begin
                j:=xmlnodelist.Count;
                xmlnode := xmlnodelist.Item(0);
                Childnodelist := xmlnode.ChildNodes();
                  for j := 0 to Childnodelist.Count - 1 do begin
                    Childnode := Childnodelist.ItemOf(j);
                    if Childnode.Name='SignatureStatus' then
                      SignatureStatus:=Childnode.InnerText
                    else if Childnode.Name='AdditionalComments' then
                      AdditionalComments:=Childnode.InnerText
                    else if  Childnode.Name='Comments' then
                      Comments:=Childnode.InnerText;
                  end;

              FundTransfer.SignatureStatus:=SignatureStatus;
              FundTransfer.AdditionalComments:=AdditionalComments;
              FundTransfer."Registrar Comments":=Comments;
              FundTransfer.Modify;
              end ;
          until FundTransfer.Next=0;
          //onlineindemnity
        OnlineIndemnityMandate.Reset;
        OnlineIndemnityMandate.SetRange(Status,OnlineIndemnityMandate.Status::"External Registrar");
        if OnlineIndemnityMandate.FindFirst then
          repeat
             xml :=  xml.XmlDocument();
            Result:=  FundAdministrationSetup."External Registrar Webservice"+'/PortfolioStatus?controlId='+ OnlineIndemnityMandate."Registrar Control ID";
            xml.Load(Result );
            xmlnodelist := xml.SelectNodes('//*');
            if( xmlnodelist.ToString()<>'') then
              begin
                j:=xmlnodelist.Count;
                xmlnode := xmlnodelist.Item(0);
                Childnodelist := xmlnode.ChildNodes();
                  for j := 0 to Childnodelist.Count - 1 do begin
                    Childnode := Childnodelist.ItemOf(j);
                    if Childnode.Name='SignatureStatus' then
                      SignatureStatus:=Childnode.InnerText
                    else if Childnode.Name='AdditionalComments' then
                      AdditionalComments:=Childnode.InnerText
                    else if  Childnode.Name='Comments' then
                      Comments:=Childnode.InnerText;
                  end;

              OnlineIndemnityMandate.SignatureStatus:=SignatureStatus;
              OnlineIndemnityMandate.AdditionalComments:=AdditionalComments;
              OnlineIndemnityMandate."Registrar Comments":=Comments;
              OnlineIndemnityMandate.Modify;
              end ;
          until FundTransfer.Next=0;
    end;

    procedure GetNibbsResponse(MandateCode: Code[50];var DirectDebitMandate: Record "Direct Debit Mandate")
    var
        i: Integer;
        xml: DotNet XmlDocument;
        xmlnodelist: DotNet XmlNodeList;
        xmlnode: DotNet XmlNode;
        result: Text;
        j: Integer;
        ResponseCode: Text;
        ResponseDescription: Text;
        ReferenceNumber: Text;
        Childnodelist: DotNet XmlNodeList;
        Childnode: DotNet XmlNode;
        WorkFlowStatusDescription: Text;
        WorkFlowStatus: Text;
    begin
        FundAdministrationSetup.Get;
        FundAdministrationSetup.TestField("NIBS Webservice");
        xml :=  xml.XmlDocument();
        
        result:=  FundAdministrationSetup."NIBS Webservice"+'/DirectDebitMandateStatus?mandateCode='+ MandateCode;
        //MESSAGE(result);
         xml.Load(result );
        
        
        xmlnodelist := xml.SelectNodes('//*');
        if( xmlnodelist.ToString()<>'') then
        begin
        j:=xmlnodelist.Count;
        
        
        xmlnode := xmlnodelist.Item(0);
        Childnodelist := xmlnode.ChildNodes();
          for j := 0 to Childnodelist.Count - 1 do begin
            Childnode := Childnodelist.ItemOf(j);
            if Childnode.Name='ReferenceNumber' then
              ReferenceNumber:=Childnode.InnerText
            else if Childnode.Name='ResponseCode' then
              ResponseCode:=Childnode.InnerText
            else if  Childnode.Name='WorkFlowStatus' then
              WorkFlowStatus:=Childnode.InnerText
            else if Childnode.Name='WorkFlowStatusDescription' then
              WorkFlowStatusDescription:=Childnode.InnerText
            else if  Childnode.Name='ResponseDescription' then
            ResponseDescription:=Childnode.InnerText;
          end;
        end;
        
        //DirectDebitMandate."Response Code":=ResponseCode;
        //DirectDebitMandate."Response Description":=ResponseDescription;
        //DirectDebitMandate."Reference Number":=ReferenceNumber;
        DirectDebitMandate."WorkFlow Status":=WorkFlowStatus;
        DirectDebitMandate."WorkFlow Status Description":=WorkFlowStatusDescription;
        DirectDebitMandate."Nibbs Approval Status":=ResponseDescription;
        DirectDebitMandate.Modify;
        /*MESSAGE(ResponseCode);
        MESSAGE(ResponseDescription);
        MESSAGE(ReferenceNumber);
        */

    end;

    procedure UpdateNibbsDirectDebit(MandateCode: Code[50];PhoneNumber: Code[50];payer: Text;PayerAddress: Text;Status: Text;WorkflowStatus: Text;Email: Text;var DirectDebitMandate: Record "Direct Debit Mandate")
    var
        i: Integer;
        xml: DotNet XmlDocument;
        xmlnodelist: DotNet XmlNodeList;
        xmlnode: DotNet XmlNode;
        result: Text;
        j: Integer;
        ResponseCode: Text;
        ResponseDescription: Text;
        ReferenceNumber: Text;
        Childnodelist: DotNet XmlNodeList;
        Childnode: DotNet XmlNode;
        WorkFlowStatusDescription: Text;
        WorkFlowStatus23: Text;
    begin
        FundAdministrationSetup.Get;
        FundAdministrationSetup.TestField("NIBS Webservice");
        xml :=  xml.XmlDocument();
        
        result:=  FundAdministrationSetup."NIBS Webservice"+'/UpdateDirectDebitMandate?mandateCode='+ MandateCode+'&phoneNumber=' + PhoneNumber+'&payerName=' + payer +'&payerAddress='+PayerAddress;
        result +='&status=' + Status+'&workFlowStatus=' + WorkflowStatus+'&emailAddress=' + Email;
        
        //MESSAGE(result);
         xml.Load(result );
        
        
        xmlnodelist := xml.SelectNodes('//*');
        if( xmlnodelist.ToString()<>'') then
        begin
        j:=xmlnodelist.Count;
        
        
        xmlnode := xmlnodelist.Item(0);
        Childnodelist := xmlnode.ChildNodes();
          for j := 0 to Childnodelist.Count - 1 do begin
            Childnode := Childnodelist.ItemOf(j);
            if Childnode.Name='ReferenceNumber' then
              ReferenceNumber:=Childnode.InnerText
            else if Childnode.Name='ResponseCode' then
              ResponseCode:=Childnode.InnerText
               else if  Childnode.Name='ResponseDescription' then
            ResponseDescription:=Childnode.InnerText;
          end;
        end;
        
        DirectDebitMandate."Response Code":=ResponseCode;
        DirectDebitMandate."Response Description":=ResponseDescription;
        DirectDebitMandate."Reference Number":=ReferenceNumber;
        
        
        /*MESSAGE(ResponseCode);
        MESSAGE(ResponseDescription);
        MESSAGE(ReferenceNumber);
        */

    end;

    procedure SendOCFile(SettlementDate: Date;Units: Decimal;Amount: Decimal;SettlementBankAccount: Text;Narration: Text;PortfolioCode: Text): Text[250]
    var
        i: Integer;
        xml: DotNet XmlDocument;
        xmlnodelist: DotNet XmlNodeList;
        xmlnode: DotNet XmlNode;
        result: Text;
        j: Integer;
        Status: Code[40];
        Detail: Text;
        Childnodelist: DotNet XmlNodeList;
        Childnode: DotNet XmlNode;
        Success: Text;
        Response: Code[40];
    begin
        FundAdministrationSetup.Get;
        FundAdministrationSetup.TestField("NIBS Webservice");
        xml :=  xml.XmlDocument();

        result:=  FundAdministrationSetup."NIBS Webservice"+'/PostOCFile?SettlementDate='+ Format(SettlementDate)  +'&Units=' + Format(Units)+'&Amount=' + Format(Amount) +'&SettlementBankAccount=' + SettlementBankAccount +'&Narration=' + Narration;
        result +='&PortfolioCode=' + PortfolioCode;
        //MESSAGE(result);
         xml.Load(result );

        xmlnodelist := xml.SelectNodes('//*');
        if( xmlnodelist.ToString()<>'') then
        begin
        j:=xmlnodelist.Count;

        xmlnode := xmlnodelist.Item(0);
          if xmlnode.HasChildNodes then begin
            Response:=xmlnode.FirstChild.InnerText;
            Detail:=xmlnode.LastChild.InnerText;
            if Response = 'TRUE' then
              exit(Detail)
            else
              exit(Detail)
          end;
        end;
    end;

    procedure SendMMFLiquidatingInterest(MMFPortfolioCode: Code[40];ValueDate: Text;Amount: Decimal;BankAccountNo: Text;Narration: Text): Text[250]
    var
        i: Integer;
        xml: DotNet XmlDocument;
        xmlnodelist: DotNet XmlNodeList;
        xmlnode: DotNet XmlNode;
        result: Text;
        j: Integer;
        Status: Code[40];
        Detail: Text;
        Childnodelist: DotNet XmlNodeList;
        Childnode: DotNet XmlNode;
        Success: Text;
        Response: Code[40];
    begin
        FundAdministrationSetup.Get;
        FundAdministrationSetup.TestField("NIBS Webservice");
        xml :=  xml.XmlDocument();

        result:=  FundAdministrationSetup."NIBS Webservice"+'/PostLiquidatingInterest?MMFPortfolioCode='+ MMFPortfolioCode +'&ValueDate=' + ValueDate +'&Amount=' + Format(Amount) +'&BankAccountNo=' + BankAccountNo +'&Narration=' + Narration;

        //MESSAGE(result);
         xml.Load(result );

        xmlnodelist := xml.SelectNodes('//*');
        if( xmlnodelist.ToString()<>'') then
        begin
        j:=xmlnodelist.Count;

        xmlnode := xmlnodelist.Item(0);
          if xmlnode.HasChildNodes then begin
            Response:=xmlnode.FirstChild.InnerText;
            Detail:=xmlnode.LastChild.InnerText;
            if Response = 'TRUE' then
              exit(Detail)
            else
              exit(Detail)
          end;
        end;
    end;

    procedure SendMMFLiquidatingChargesOnInterest(MMFPortfolioCode: Code[40];ValueDate: Date;Amount: Decimal;BankAccountNo: Text;Narration: Text): Text[250]
    var
        i: Integer;
        xml: DotNet XmlDocument;
        xmlnodelist: DotNet XmlNodeList;
        xmlnode: DotNet XmlNode;
        result: Text;
        j: Integer;
        Status: Code[40];
        Detail: Text;
        Childnodelist: DotNet XmlNodeList;
        Childnode: DotNet XmlNode;
        Success: Text;
        Response: Code[20];
    begin
        FundAdministrationSetup.Get;
        FundAdministrationSetup.TestField("NIBS Webservice");
        xml :=  xml.XmlDocument();

        result:=  FundAdministrationSetup."NIBS Webservice"+'/PostLiquidatingChargesOnInterest?MMFPortfolioCode='+ MMFPortfolioCode +'&ValueDate=' + Format(ValueDate) +'&Amount=' + Format(Amount) +'&BankAccountNo=' + BankAccountNo;
        result+='&Narration=' + Narration;

        //MESSAGE(result);
         xml.Load(result );

        xmlnodelist := xml.SelectNodes('//*');
        if( xmlnodelist.ToString()<>'') then
        begin
        j:=xmlnodelist.Count;

        xmlnode := xmlnodelist.Item(0);
          if xmlnode.HasChildNodes then begin
            Response:=xmlnode.FirstChild.InnerText;
            Detail:=xmlnode.LastChild.InnerText;
            if Response = 'TRUE' then
              exit(Detail)
            else
              exit(Detail)
          end;
        end;
    end;

    procedure SendDisbursedLoanAndRepayment(PortfolioCode: Code[40];ClassCode: Code[40];ProductSymbol: Code[40];ValueDate: Date;Amount: Decimal;BankAccountNo: Text;Narration: Text): Text[250]
    var
        i: Integer;
        xml: DotNet XmlDocument;
        xmlnodelist: DotNet XmlNodeList;
        xmlnode: DotNet XmlNode;
        result: Text;
        j: Integer;
        Status: Code[40];
        Detail: Text;
        Childnodelist: DotNet XmlNodeList;
        Childnode: DotNet XmlNode;
        Success: Text;
        Response: Code[20];
    begin
        FundAdministrationSetup.Get;
        FundAdministrationSetup.TestField("NIBS Webservice");
        xml :=  xml.XmlDocument();

        result:=  FundAdministrationSetup."NIBS Webservice"+'/SendDisbursedLoanAndRepayment?portfolioCode='+ PortfolioCode +'&classCode='+ ClassCode +'&productSymbol='+ ProductSymbol +'&valueDate=' + Format(ValueDate) +'&amount=' + Format(Amount);
        result+='&bankAccountNo=' + BankAccountNo +'&narration=' + Narration;

        //MESSAGE(result);
         xml.Load(result );

        xmlnodelist := xml.SelectNodes('//*');
        if( xmlnodelist.ToString()<>'') then
        begin
        j:=xmlnodelist.Count;

        xmlnode := xmlnodelist.Item(0);
          if xmlnode.HasChildNodes then begin
            Response:=xmlnode.FirstChild.InnerText;
            Detail:=xmlnode.LastChild.InnerText;
            if Response = 'TRUE' then
              exit(Detail)
            else
              exit(Detail)
          end;
        end;
    end;

    procedure SendNomineeClientDividend(PortfolioCode: Code[40];SecurityCode: Code[30];CurrencyCode: Code[20];InstrumentId: Text;DeclaredDate: Date;PaymentDate: Date;DPS: Decimal;HoldingUnits: Decimal;Amount: Decimal;FXRate: Decimal;TaxRate: Decimal): Text[250]
    var
        i: Integer;
        xml: DotNet XmlDocument;
        xmlnodelist: DotNet XmlNodeList;
        xmlnode: DotNet XmlNode;
        result: Text;
        j: Integer;
        Status: Code[40];
        Detail: Text;
        Childnodelist: DotNet XmlNodeList;
        Childnode: DotNet XmlNode;
        Success: Text;
        Response: Code[20];
    begin
        FundAdministrationSetup.Get;
        FundAdministrationSetup.TestField("NIBS Webservice");
        xml :=  xml.XmlDocument();

        result:=  FundAdministrationSetup."NIBS Webservice"+'/SendNomineeClientDividend?portfolioCode='+ PortfolioCode +'&securityCode='+ SecurityCode +'&currencyCode='+ CurrencyCode + '&instrumentId='+ InstrumentId;
        result+='&declaredDate='+ Format(DeclaredDate) + '&paymentDate=' + Format(PaymentDate) + '&dps=' + Format(DPS) +'&holdingUnits='+ Format(HoldingUnits) + '&amount=' + Format(Amount) + '&fxRate='+ Format(FXRate);
        result+='&taxRate='+ Format(TaxRate);

        //MESSAGE(result);
         xml.Load(result );

        xmlnodelist := xml.SelectNodes('//*');
        if( xmlnodelist.ToString()<>'') then
        begin
        j:=xmlnodelist.Count;

        xmlnode := xmlnodelist.Item(0);
          if xmlnode.HasChildNodes then begin
            Response:=xmlnode.FirstChild.InnerText;
            Detail:=xmlnode.LastChild.InnerText;
            if Response = 'TRUE' then
              exit(Detail)
            else
              exit(Detail)
          end;
        end;
    end;

    procedure SendRedemption(referenceno: Text;units: Decimal;price: Decimal;totalunits: Decimal;transcharge: Decimal): Boolean
    var
        i: Integer;
        xml: DotNet XmlDocument;
        xmlnodelist: DotNet XmlNodeList;
        xmlnode: DotNet XmlNode;
        result: Text;
        j: Integer;
        Detail: Text;
        Childnodelist: DotNet XmlNodeList;
        Childnode: DotNet XmlNode;
        Success: Text;
        Response: Code[20];
        Status: Boolean;
    begin
        FundAdministrationSetup.Get;
        FundAdministrationSetup.TestField("NIBS Webservice");
        xml :=  xml.XmlDocument();
        result:=  FundAdministrationSetup."NIBS Webservice"+'/SendRedemptionStatusToDeluxe?ReferenceNo='+ referenceno;
        result+= '&Units='+ Format(units) +'&Price='+ Format(price) + '&TotalUnits='+ Format(totalunits) + '&TransCharge='+ Format(transcharge);
        //MESSAGE(result);
         xml.Load(result );

        xmlnodelist := xml.SelectNodes('//*');
        if( xmlnodelist.ToString()<>'') then
        begin
        j:=xmlnodelist.Count;

        xmlnode := xmlnodelist.Item(0);
          if xmlnode.HasChildNodes then begin
            Response:=xmlnode.FirstChild.InnerText;
            Detail:=xmlnode.LastChild.InnerText;
            if Response = 'TRUE' then begin
              Status := true;
              exit(Status)
            end else begin
              exit(Status)
              end;
          end;
        end;
    end;

    procedure SendNomineeClientDividendAccrual(PortfolioCode: Code[40];MutualfundCode: Code[20];AssetClassId: Code[10];DeclaredDate: Text;PaymentDate: Text;HoldingUnits: Decimal;Amount: Decimal;TaxAmount: Decimal): Text[250]
    var
        i: Integer;
        xml: DotNet XmlDocument;
        xmlnodelist: DotNet XmlNodeList;
        xmlnode: DotNet XmlNode;
        result: Text;
        j: Integer;
        Status: Code[40];
        Detail: Text;
        Childnodelist: DotNet XmlNodeList;
        Childnode: DotNet XmlNode;
        Success: Text;
        Response: Code[40];
    begin
        FundAdministrationSetup.Get;
        FundAdministrationSetup.TestField("External Webservice");
        xml :=  xml.XmlDocument();

        result:=  FundAdministrationSetup."External Webservice"+'/NomineeDividendAccrual?PortfolioCode='+ PortfolioCode +'&MutualfundCode=' + MutualfundCode +'&AssetClassId=' + AssetClassId +'&DeclaredDate=' + DeclaredDate;
        result+= '&PaymentDate=' + PaymentDate + '&HoldingUnits=' + Format(HoldingUnits) + '&Amount=' + Format(Amount) + '&TaxAmount=' + Format(TaxAmount);

         xml.Load(result );

        xmlnodelist := xml.SelectNodes('//*');
        if( xmlnodelist.ToString()<>'') then
        begin
        j:=xmlnodelist.Count;

        xmlnode := xmlnodelist.Item(0);
          if xmlnode.HasChildNodes then begin
            Response:=xmlnode.FirstChild.InnerText;
            Detail:=xmlnode.LastChild.InnerText;
            if Response = 'TRUE' then
              exit(Detail)
            else
              exit(Detail)
          end;
        end;
    end;

    procedure SendNomineeClientDividendPayment(PortfolioCode: Code[40];MutualfundCode: Code[20];AssetClassId: Code[10];DeclaredDate: Date;TransDate: Date;Amount: Decimal;ReInvestmentPrice: Decimal;UnitsHolding: Decimal;TaxAmount: Decimal;BankAccountNo: Text): Text[250]
    var
        i: Integer;
        xml: DotNet XmlDocument;
        xmlnodelist: DotNet XmlNodeList;
        xmlnode: DotNet XmlNode;
        result: Text;
        j: Integer;
        Status: Code[40];
        Detail: Text;
        Childnodelist: DotNet XmlNodeList;
        Childnode: DotNet XmlNode;
        Success: Text;
        Response: Code[40];
    begin
        FundAdministrationSetup.Get;
        FundAdministrationSetup.TestField("External Webservice");
        xml :=  xml.XmlDocument();

        result:=  FundAdministrationSetup."External Webservice"+'/NomineeDividendPayment?PCode='+ PortfolioCode +'&FundCode=' + MutualfundCode;
        result+=  '&AssetClassId=' + AssetClassId +'&DeclaredDate=' + Format(DeclaredDate) + '&TransDate=' + Format(TransDate) + '&Amount=' + Format(Amount);
        result+=  '&Price=' + Format(ReInvestmentPrice) + '&Units=' + Format(UnitsHolding) + '&Tax=' + Format(TaxAmount) + '&BnkAcc=' + BankAccountNo;

         xml.Load(result);

        xmlnodelist := xml.SelectNodes('//*');
        if( xmlnodelist.ToString()<>'') then
        begin
        j:=xmlnodelist.Count;

        xmlnode := xmlnodelist.Item(0);
          if xmlnode.HasChildNodes then begin
            Response:=xmlnode.FirstChild.InnerText;
            Detail:=xmlnode.LastChild.InnerText;
            if Response = 'TRUE' then
              exit(Detail)
            else
              exit(Detail)
          end;
        end;
    end;

    procedure UpdateAccountStatus(AccountNumber: Text[100];AccountStatus: Option "1","700000000","700000001","700000002","700000003";Amount: Decimal): Code[20]
    var
        i: Integer;
        xml: DotNet XmlDocument;
        xmlnodelist: DotNet XmlNodeList;
        xmlnode: DotNet XmlNode;
        result: Text;
        j: Integer;
        Status: Code[40];
        Detail: Text;
        Childnodelist: DotNet XmlNodeList;
        Childnode: DotNet XmlNode;
        Success: Text;
        Response: Code[40];
    begin
        
        /*
        
        Maxwell := Integration to CRM [October, 2023]
        
        Account status
        ==============
        Active - 1
        Lien - 700000000
        Restrict Redemption - 700000001
        Restrict Subscription - 700000002
        Restrict Redemption and Subscription - 700000003
        */
        
        FundAdministrationSetup.Get;
        FundAdministrationSetup.TestField("External Webservice");
        xml :=  xml.XmlDocument();
        result:=  FundAdministrationSetup."External Webservice"+'/UpdateAccountStatus?accountNumber='+AccountNumber;
        result+= '&accountStatus='+Format(AccountStatus)+'&amount='+Format(Amount);
        xml.Load(result);
        
        xmlnodelist := xml.SelectNodes('//*');
        if( xmlnodelist.ToString()<>'') then begin
        j:=xmlnodelist.Count;
        xmlnode := xmlnodelist.Item(0);
          if xmlnode.HasChildNodes then begin
            Response:=xmlnode.FirstChild.InnerText;
            Detail:=xmlnode.LastChild.InnerText;
            exit(Response);
          end;
        end;

    end;

    procedure UpdateRedemptionStatus(CaseNumber: Text[100];bankResponseStatus: Option "0","1";bankResponseDetails: Text;redemptionReversalStatus: Option "0","1","2","3"): Code[20]
    var
        i: Integer;
        xml: DotNet XmlDocument;
        xmlnodelist: DotNet XmlNodeList;
        xmlnode: DotNet XmlNode;
        result: Text;
        j: Integer;
        Status: Code[40];
        Detail: Text;
        Childnodelist: DotNet XmlNodeList;
        Childnode: DotNet XmlNode;
        Success: Text;
        Response: Code[40];
    begin
        
        /*
        Maxwell := Integration to CRM [October, 2023]
        
        Bank Response Statuses
        =====================
        Successful - 0
        Failed - 1
        
        Reversal Statuses
        =================
        Open - 0
        Pending Reversal - 1
        Approved - 2
        Rejected - 3
        */
        
        FundAdministrationSetup.Get;
        FundAdministrationSetup.TestField("External Webservice");
        xml :=  xml.XmlDocument();
        result:=  FundAdministrationSetup."External Webservice"+'/UpdateRedemptionStatus?caseNumber='+CaseNumber;
        result+= '&bankResponseStatus='+Format(bankResponseStatus)+'&bankResponseDetails='+bankResponseDetails+'&redemptionReversalStatus='+Format(redemptionReversalStatus);
        xml.Load(result);
        
        xmlnodelist := xml.SelectNodes('//*');
        if( xmlnodelist.ToString()<>'') then begin
        j:=xmlnodelist.Count;
        xmlnode := xmlnodelist.Item(0);
          if xmlnode.HasChildNodes then begin
            Response:=xmlnode.FirstChild.InnerText;
            Detail:=xmlnode.LastChild.InnerText;
            exit(Response);
          end;
        end;

    end;
}

