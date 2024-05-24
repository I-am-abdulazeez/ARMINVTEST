codeunit 50006 "Sharepoint Integration"
{

    trigger OnRun()
    begin
        //SaveFileonsharepoint(
        //MESSAGE(SaveUnitTransfer);
    end;

    var
        DocumentServiceManagement: Codeunit "Document Service Management";
        Window: Dialog;
        UploadName: Text;
        FileManagement: Codeunit "File Management";

    procedure SaveFileonsharepoint(OrderNo: Code[50];Task: Text;ClientID: Code[50]): Text
    var
        FileName: Text;
        FileFolder: Text;
        FilePath: Text;
        ToName: Text;
        ToPath: Text;
        DocLink: Text;
    begin
        FileFolder:='';
        FileName:='';
        ToPath:='E:\FILES\';
        
        ClearLastError;
        if not FILE.Upload('Please Select File to Upload',FileFolder,'',FileName,ToPath) then
          exit;
        ToName:=FileManagement.GetFileName(ToPath);
        
        
        exit(Uploadtosharepoint2(ToPath));;
        
        /*
        FileFolder:='';
        FileName:='';
        ToPath:='';
        CLEARLASTERROR;
        IF NOT FILE.UPLOAD('Please Select File to Upload',FileFolder,'',FileName,ToPath) THEN
          EXIT;
        ToName:=FileManagement.GetFileName(ToPath);
        ToName:=OrderNo+'_'+Task+'_'+ToName;
        Window.OPEN('Uploading Document....');
        DocLink:=DocumentServiceManagement.SaveFileFolder(ToPath,ToName,TRUE,FORMAT(ClientID));
        Window.CLOSE;
        MESSAGE('Document Uploaded Successfully');
        EXIT(DocLink);
        //MESSAGE(DocLink);
        */

    end;

    procedure ViewDocument(DocLink: Text)
    begin
        //DocumentServiceManagement.OpenDocument(DocLink);
        if DocLink='' then
          Error('There is no link attached');
        HyperLink(DocLink);
    end;

    procedure SaveIndemnityonsharepoint(OrderNo: Code[50];Task: Text;ClientID: Code[50];OnlineIndemnityMandate: Record "Online Indemnity Mandate"): Text
    var
        FileName: Text;
        FileFolder: Text;
        FilePath: Text;
        ToName: Text;
        ToPath: Text;
        DocLink: Text;
    begin
        FileFolder:='';
        FileName:='';
        ToPath:='';

        ClearLastError;
        if not FILE.Upload('Please Select File to Upload',FileFolder,'',FileName,ToPath) then
          exit;
        ToName:=FileManagement.GetFileName(ToPath);
        OnlineIndemnityMandate.Blob.Import(ToPath);
        OnlineIndemnityMandate.FileName:=ToName;


        ToName:=OrderNo+'_'+Task+'_'+ToName;
        Window.Open('Uploading Document....');
        DocLink:=DocumentServiceManagement.SaveFileFolder(ToPath,ToName,true,Format(ClientID));
        Window.Close;
        Message('Document Uploaded Successfully');
        OnlineIndemnityMandate."Document Link":=DocLink;
        OnlineIndemnityMandate.Modify;
        //MESSAGE(DocLink);
    end;

    procedure SaveDebitonsharepoint(OrderNo: Code[50];Task: Text;ClientID: Code[50];DirectDebitMandate: Record "Direct Debit Mandate"): Text
    var
        FileName: Text;
        FileFolder: Text;
        FilePath: Text;
        ToName: Text;
        ToPath: Text;
        DocLink: Text;
    begin
        FileFolder:='';
        FileName:='';
        ToPath:='';

        ClearLastError;
        if not FILE.Upload('Please Select File to Upload',FileFolder,'',FileName,ToPath) then
          exit;
        ToName:=FileManagement.GetFileName(ToPath);
        DirectDebitMandate.Blob.Import(ToPath);
        DirectDebitMandate.FileName:=ToName;


        ToName:=OrderNo+'_'+Task+'_'+ToName;
        Window.Open('Uploading Document....');
        DocLink:=DocumentServiceManagement.SaveFileFolder(ToPath,ToName,true,Format(ClientID));
        Window.Close;
        Message('Document Uploaded Successfully');
        DirectDebitMandate."Document Link":=DocLink;
        DirectDebitMandate.Modify;
        //MESSAGE(DocLink);
    end;

    procedure SaveUnitTransfer(): Text
    var
        FileName: Text;
        FileFolder: Text;
        FilePath: Text;
        ToName: Text;
        ToPath: Text;
        DocLink: Text;
    begin
        FileFolder:='';
        FileName:='';
        ToPath:='E:\FILES\';

        ClearLastError;
        if not FILE.Upload('Please Select File to Upload',FileFolder,'',FileName,ToPath) then
          exit;
        ToName:=FileManagement.GetFileName(ToPath);
        exit(Uploadtosharepoint(ToPath));;
    end;

    local procedure Uploadtosharepoint(ServerLink: Text): Text
    var
        xmlnodelist: DotNet XmlNodeList;
        xmlnode: DotNet XmlNode;
        Success: Text;
        j: Integer;
        XMLAttrib: DotNet XmlAttributeCollection;
        Nodes: Integer;
        Result: Text;
        AdditionalComments: Text;
        Comments: Text;
        UploadSharePointOnlineResult: Text;
        Childnodelist: DotNet XmlNodeList;
        Childnode: DotNet XmlNode;
        uriObj: DotNet Uri;
        Request: DotNet HttpWebRequest;
        stream: DotNet StreamWriter;
        Response: DotNet HttpWebResponse;
        reader: DotNet XmlTextReader0;
        document: DotNet XmlDocument;
        ascii: DotNet Encoding;
        FileMgt: Codeunit "File Management";
        FileSrv: Text;
        ToFile: Text;
        xml: Text;
        url: Text;
        soapAction: Text;
        FundAdministrationSetup: Record "Fund Administration Setup";
    begin
        FundAdministrationSetup.Get;
        FundAdministrationSetup.TestField("External Registrar Webservice");
        xml:= '<?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:ceto="http://tempuri.org/arm/ceto/">'+
           '<soap:Header/>'+
           '<soap:Body>'+
              '<ceto:DocUpload>'+
                 '<ceto:directUrl>'+ServerLink+'</ceto:directUrl>'+
              '</ceto:DocUpload>'+
           '</soap:Body>'+
        '</soap:Envelope>';
        
        
          /* xml :=  xml.XmlDocument();
            Result:=  FundAdministrationSetup."External Registrar Webservice"+'/DocUpload?controlId='+ FundTransfer."Registrar Control ID";
            xml.Load(Result );*/
        
                    url:=  FundAdministrationSetup."External Registrar Webservice";
        
                    uriObj := uriObj.Uri(url);
                    Request := Request.CreateDefault(uriObj);
                    Request.Method := 'POST';
                    Request.ContentType := 'text/xml';
        
                   // Request.Timeout := 120000;
                   Request.Timeout := 500000;
        // Send the request to the webservice
        stream := stream.StreamWriter(Request.GetRequestStream(), ascii.UTF8);
        stream.Write(xml);
        stream.Close();
        
        // Get the response
        Response := Request.GetResponse();
        reader := reader.XmlTextReader(Response.GetResponseStream());
        
        // Save the response to a XML
        document := document.XmlDocument();
        document.Load(reader);
        
        xmlnodelist := document.SelectNodes('//*');
            if( xmlnodelist.ToString()<>'') then
              begin
                j:=xmlnodelist.Count;
                xmlnode := xmlnodelist.Item(0);
        
                Childnodelist := xmlnode.ChildNodes();
                  for j := 0 to Childnodelist.Count - 1 do begin
                    Childnode := Childnodelist.ItemOf(j);
                    UploadSharePointOnlineResult:=Childnode.InnerText ;
        
                  end;
        
        end;
        if UploadSharePointOnlineResult<>'' then
          Message('Upload Successful');
        exit(UploadSharePointOnlineResult);

    end;

    procedure UploadOCtosharepoint(ServerLink: Text): Text
    var
        xmlnodelist: DotNet XmlNodeList;
        xmlnode: DotNet XmlNode;
        Success: Text;
        j: Integer;
        XMLAttrib: DotNet XmlAttributeCollection;
        Nodes: Integer;
        Result: Text;
        AdditionalComments: Text;
        Comments: Text;
        UploadSharePointOnlineResult: Text;
        Childnodelist: DotNet XmlNodeList;
        Childnode: DotNet XmlNode;
        uriObj: DotNet Uri;
        Request: DotNet HttpWebRequest;
        stream: DotNet StreamWriter;
        Response: DotNet HttpWebResponse;
        reader: DotNet XmlTextReader0;
        document: DotNet XmlDocument;
        ascii: DotNet Encoding;
        FileMgt: Codeunit "File Management";
        FileSrv: Text;
        ToFile: Text;
        xml: Text;
        url: Text;
        soapAction: Text;
        FundAdministrationSetup: Record "Fund Administration Setup";
        FileName: Text;
        FileFolder: Text;
        FilePath: Text;
        ToName: Text;
        ToPath: Text;
        DocLink: Text;
        xml2: DotNet XmlDocument;
    begin
        FileFolder:='';
        FileName:='';
        ToPath:='E:\FILES\';
        
        /*CLEARLASTERROR;
        IF NOT FILE.UPLOAD('Please Select File to Upload',FileFolder,'',FileName,ToPath) THEN
          EXIT;*/
        /*ToPath:=ToPath+FileManagement.GetFileName(ServerLink);
        FileManagement.UploadFileSilentToServerPath(ServerLink,ToPath);
        */
        ToPath:=ToPath+FileManagement.GetFileName(ServerLink);
        if not IsServiceTier then
        FileManagement.UploadFileSilentToServerPath(ServerLink,ToPath)
        else
        FILE.Copy(ServerLink,ToPath);
        FundAdministrationSetup.Get;
        FundAdministrationSetup.TestField("External Registrar Webservice");
        xml:= '<?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:ceto="http://tempuri.org/arm/ceto/">'+
           '<soap:Header/>'+
           '<soap:Body>'+
              '<ceto:FundAccountFolderDocUpload>'+
                 '<ceto:directUrl>'+ToPath+'</ceto:directUrl>'+
              '</ceto:FundAccountFolderDocUpload>'+
           '</soap:Body>'+
        '</soap:Envelope>';
        
        
          /* xml :=  xml.XmlDocument();
            Result:=  FundAdministrationSetup."External Registrar Webservice"+'/DocUpload?controlId='+ FundTransfer."Registrar Control ID";
            xml.Load(Result );*/
        
                    url:=  FundAdministrationSetup."External Registrar Webservice";
        
                    uriObj := uriObj.Uri(url);
                    Request := Request.CreateDefault(uriObj);
                    Request.Method := 'POST';
                    Request.ContentType := 'text/xml';
        
                    //Request.Timeout := 120000;
                    Request.Timeout := 500000;
        // Send the request to the webservice
        stream := stream.StreamWriter(Request.GetRequestStream(), ascii.UTF8);
        stream.Write(xml);
        stream.Close();
        
        // Get the response
        Response := Request.GetResponse();
        reader := reader.XmlTextReader(Response.GetResponseStream());
        
        // Save the response to a XML
        document := document.XmlDocument();
        document.Load(reader);
        
        xmlnodelist := document.SelectNodes('//*');
            if( xmlnodelist.ToString()<>'') then
              begin
                j:=xmlnodelist.Count;
                xmlnode := xmlnodelist.Item(0);
        
                Childnodelist := xmlnode.ChildNodes();
                  for j := 0 to Childnodelist.Count - 1 do begin
                    Childnode := Childnodelist.ItemOf(j);
                    UploadSharePointOnlineResult:=Childnode.InnerText ;
        
                  end;
        
        end;
        //IF UploadSharePointOnlineResult<>'' THEN
        
        exit(UploadSharePointOnlineResult);

    end;

    procedure UploadPaymentFiletosharepoint(ServerLink: Text): Text
    var
        xmlnodelist: DotNet XmlNodeList;
        xmlnode: DotNet XmlNode;
        Success: Text;
        j: Integer;
        XMLAttrib: DotNet XmlAttributeCollection;
        Nodes: Integer;
        Result: Text;
        AdditionalComments: Text;
        Comments: Text;
        UploadSharePointOnlineResult: Text;
        Childnodelist: DotNet XmlNodeList;
        Childnode: DotNet XmlNode;
        uriObj: DotNet Uri;
        Request: DotNet HttpWebRequest;
        stream: DotNet StreamWriter;
        Response: DotNet HttpWebResponse;
        reader: DotNet XmlTextReader0;
        document: DotNet XmlDocument;
        ascii: DotNet Encoding;
        FileMgt: Codeunit "File Management";
        FileSrv: Text;
        ToFile: Text;
        xml: Text;
        url: Text;
        soapAction: Text;
        FundAdministrationSetup: Record "Fund Administration Setup";
        FileName: Text;
        FileFolder: Text;
        FilePath: Text;
        ToName: Text;
        Topath: Text;
    begin
        FundAdministrationSetup.Get;
        FundAdministrationSetup.TestField("External Registrar Webservice");
        FileFolder:='';
        FileName:='';
        Topath:='E:\FILES\';
        
        /*CLEARLASTERROR;
        IF NOT FILE.UPLOAD('Please Select File to Upload',FileFolder,'',FileName,ToPath) THEN
          EXIT;*/
        Topath:=Topath+FileManagement.GetFileName(ServerLink);
        if not IsServiceTier then
        FileManagement.UploadFileSilentToServerPath(ServerLink,Topath)
        else
        FILE.Copy(ServerLink,Topath);
        
        
        
        xml:= '<?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:ceto="http://tempuri.org/arm/ceto/">'+
           '<soap:Header/>'+
           '<soap:Body>'+
              '<ceto:TreasuryFolderDocUpload>'+
                 '<ceto:directUrl>'+Topath+'</ceto:directUrl>'+
              '</ceto:TreasuryFolderDocUpload>'+
           '</soap:Body>'+
        '</soap:Envelope>';
        
        
          /* xml :=  xml.XmlDocument();
            Result:=  FundAdministrationSetup."External Registrar Webservice"+'/DocUpload?controlId='+ FundTransfer."Registrar Control ID";
            xml.Load(Result );*/
        
                    url:=  FundAdministrationSetup."External Registrar Webservice";
        
                    uriObj := uriObj.Uri(url);
                    Request := Request.CreateDefault(uriObj);
                    Request.Method := 'POST';
                    Request.ContentType := 'text/xml';
        
                    //Request.Timeout := 120000;
                    Request.Timeout := 500000;
        // Send the request to the webservice
        stream := stream.StreamWriter(Request.GetRequestStream(), ascii.UTF8);
        stream.Write(xml);
        stream.Close();
        
        // Get the response
        Response := Request.GetResponse();
        reader := reader.XmlTextReader(Response.GetResponseStream());
        
        // Save the response to a XML
        document := document.XmlDocument();
        document.Load(reader);
        
        xmlnodelist := document.SelectNodes('//*');
            if( xmlnodelist.ToString()<>'') then
              begin
                j:=xmlnodelist.Count;
                xmlnode := xmlnodelist.Item(0);
        
                Childnodelist := xmlnode.ChildNodes();
                  for j := 0 to Childnodelist.Count - 1 do begin
                    Childnode := Childnodelist.ItemOf(j);
                    UploadSharePointOnlineResult:=Childnode.InnerText ;
        
                  end;
        
        end;
        /*IF UploadSharePointOnlineResult<>'' THEN
          MESSAGE('Upload Successful');*/
        exit(UploadSharePointOnlineResult);

    end;

    procedure UploadLoanPaymentFileToSharePoint(ServerLink: Text): Text
    var
        xmlnodelist: DotNet XmlNodeList;
        xmlnode: DotNet XmlNode;
        Success: Text;
        j: Integer;
        XMLAttrib: DotNet XmlAttributeCollection;
        Nodes: Integer;
        Result: Text;
        AdditionalComments: Text;
        Comments: Text;
        UploadSharePointOnlineResult: Text;
        Childnodelist: DotNet XmlNodeList;
        Childnode: DotNet XmlNode;
        uriObj: DotNet Uri;
        Request: DotNet HttpWebRequest;
        stream: DotNet StreamWriter;
        Response: DotNet HttpWebResponse;
        reader: DotNet XmlTextReader0;
        document: DotNet XmlDocument;
        ascii: DotNet Encoding;
        FileMgt: Codeunit "File Management";
        FileSrv: Text;
        ToFile: Text;
        xml: Text;
        url: Text;
        soapAction: Text;
        FundAdministrationSetup: Record "Fund Administration Setup";
        FileName: Text;
        FileFolder: Text;
        FilePath: Text;
        ToName: Text;
        Topath: Text;
    begin
        FundAdministrationSetup.Get;
        FundAdministrationSetup.TestField("External Registrar Webservice");
        FileFolder:='';
        FileName:='';
        Topath:='E:\FILES\';
        
        Topath:=Topath+FileManagement.GetFileName(ServerLink);
        if not IsServiceTier then
        FileManagement.UploadFileSilentToServerPath(ServerLink,Topath)
        else
        FILE.Copy(ServerLink,Topath);
        
        
        
        xml:= '<?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:ceto="http://tempuri.org/arm/ceto/">'+
           '<soap:Header/>'+
           '<soap:Body>'+
              '<ceto:TreasuryLoanDocUpload>'+
                 '<ceto:directUrl>'+Topath+'</ceto:directUrl>'+
              '</ceto:TreasuryLoanDocUpload>'+
           '</soap:Body>'+
        '</soap:Envelope>';
        
                    url:=  FundAdministrationSetup."External Registrar Webservice";
        
                    uriObj := uriObj.Uri(url);
                    Request := Request.CreateDefault(uriObj);
                    Request.Method := 'POST';
                    Request.ContentType := 'text/xml';
        
                   // Request.Timeout := 120000;
                   Request.Timeout := 500000;
        // Send the request to the webservice
        stream := stream.StreamWriter(Request.GetRequestStream(), ascii.UTF8);
        stream.Write(xml);
        stream.Close();
        
        // Get the response
        Response := Request.GetResponse();
        reader := reader.XmlTextReader(Response.GetResponseStream());
        
        // Save the response to a XML
        document := document.XmlDocument();
        document.Load(reader);
        
        xmlnodelist := document.SelectNodes('//*');
            if( xmlnodelist.ToString()<>'') then
              begin
                j:=xmlnodelist.Count;
                xmlnode := xmlnodelist.Item(0);
        
                Childnodelist := xmlnode.ChildNodes();
                  for j := 0 to Childnodelist.Count - 1 do begin
                    Childnode := Childnodelist.ItemOf(j);
                    UploadSharePointOnlineResult:=Childnode.InnerText ;
        
                  end;
        
        end;
        /*IF UploadSharePointOnlineResult<>'' THEN
          MESSAGE('Upload Successful');*/
        exit(UploadSharePointOnlineResult);

    end;

    procedure UploadOCtosharepoint2(ServerLink: Text): Text
    var
        xmlnodelist: DotNet XmlNodeList;
        xmlnode: DotNet XmlNode;
        Success: Text;
        j: Integer;
        XMLAttrib: DotNet XmlAttributeCollection;
        Nodes: Integer;
        Result: Text;
        AdditionalComments: Text;
        Comments: Text;
        UploadSharePointOnlineResult: Text;
        Childnodelist: DotNet XmlNodeList;
        Childnode: DotNet XmlNode;
        uriObj: DotNet Uri;
        Request: DotNet HttpWebRequest;
        stream: DotNet StreamWriter;
        Response: DotNet HttpWebResponse;
        reader: DotNet XmlTextReader0;
        document: DotNet XmlDocument;
        ascii: DotNet Encoding;
        FileMgt: Codeunit "File Management";
        FileSrv: Text;
        ToFile: Text;
        xml: Text;
        url: Text;
        soapAction: Text;
        FundAdministrationSetup: Record "Fund Administration Setup";
        FileName: Text;
        FileFolder: Text;
        FilePath: Text;
        ToName: Text;
        ToPath: Text;
        DocLink: Text;
        xml2: DotNet XmlDocument;
    begin
        FileFolder:='';
        FileName:='';
        ToPath:='E:\FILES\';

        ToPath:=ToPath+FileManagement.GetFileName(ServerLink);
        if not IsServiceTier then
        FileManagement.UploadFileSilentToServerPath(ServerLink,ToPath)
        else
        FILE.Copy(ServerLink,ToPath);
        FundAdministrationSetup.Get;
        FundAdministrationSetup.TestField("External Registrar Webservice");

        xml2 := xml2.XmlDocument();
          //Result:=  FundAdministrationSetup."External Registrar Webservice"+'/DocUpload?directUrl='+ToPath;
          Result:=  FundAdministrationSetup."External Registrar Webservice"+'/FundAccountFolderDocUpload?directUrl='+ToPath;
          xml2.Load(Result);

        //IF Result<>'' THEN

        exit(Result);
    end;

    procedure UploadPaymentFiletosharepoint2(ServerLink: Text): Text
    var
        xmlnodelist: DotNet XmlNodeList;
        xmlnode: DotNet XmlNode;
        Success: Text;
        j: Integer;
        XMLAttrib: DotNet XmlAttributeCollection;
        Nodes: Integer;
        Result: Text;
        AdditionalComments: Text;
        Comments: Text;
        UploadSharePointOnlineResult: Text;
        Childnodelist: DotNet XmlNodeList;
        Childnode: DotNet XmlNode;
        uriObj: DotNet Uri;
        Request: DotNet HttpWebRequest;
        stream: DotNet StreamWriter;
        Response: DotNet HttpWebResponse;
        reader: DotNet XmlTextReader0;
        document: DotNet XmlDocument;
        ascii: DotNet Encoding;
        FileMgt: Codeunit "File Management";
        FileSrv: Text;
        ToFile: Text;
        xml: Text;
        url: Text;
        soapAction: Text;
        FundAdministrationSetup: Record "Fund Administration Setup";
        FileName: Text;
        FileFolder: Text;
        FilePath: Text;
        ToName: Text;
        Topath: Text;
        xml2: DotNet XmlDocument;
        resp1: Code[250];
        resp2: Text[250];
    begin
        
        FileFolder:='';
        FileName:='';
        Topath:='E:\FILES\';
        Result := '';
        /*CLEARLASTERROR;
        IF NOT FILE.UPLOAD('Please Select File to Upload',FileFolder,'',FileName,ToPath) THEN
          EXIT;*/
        Topath:=Topath+FileManagement.GetFileName(ServerLink);
        if not IsServiceTier then
        FileManagement.UploadFileSilentToServerPath(ServerLink,Topath)
        else
        FILE.Copy(ServerLink,Topath);
        
        FundAdministrationSetup.Get;
        FundAdministrationSetup.TestField("External Registrar Webservice");
        
        xml2 := xml2.XmlDocument();
          Result :=  FundAdministrationSetup."External Registrar Webservice"+'/TreasuryFolderDocUpload?directUrl='+Topath;
        xml2.Load(Result);
        
        xmlnodelist := xml2.SelectNodes('//*');
        if( xmlnodelist.ToString()<>'') then
        begin
        j:=xmlnodelist.Count;
        
        xmlnode := xmlnodelist.Item(0);
          if xmlnode.HasChildNodes then begin
            resp1:=xmlnode.FirstChild.InnerText;
            resp2 :=xmlnode.LastChild.InnerText;
            if resp2 <> '' then
              exit(resp2)
            else
              exit(resp2)
          end;
        end;
        //EXIT(resp);

    end;

    local procedure Uploadtosharepoint2(ServerLink: Text): Text
    var
        xmlnodelist: DotNet XmlNodeList;
        xmlnode: DotNet XmlNode;
        Success: Text;
        j: Integer;
        XMLAttrib: DotNet XmlAttributeCollection;
        Nodes: Integer;
        Result: Text;
        AdditionalComments: Text;
        Comments: Text;
        UploadSharePointOnlineResult: Text;
        Childnodelist: DotNet XmlNodeList;
        Childnode: DotNet XmlNode;
        uriObj: DotNet Uri;
        Request: DotNet HttpWebRequest;
        stream: DotNet StreamWriter;
        Response: DotNet HttpWebResponse;
        reader: DotNet XmlTextReader0;
        document: DotNet XmlDocument;
        ascii: DotNet Encoding;
        FileMgt: Codeunit "File Management";
        FileSrv: Text;
        ToFile: Text;
        xml: Text;
        url: Text;
        soapAction: Text;
        FundAdministrationSetup: Record "Fund Administration Setup";
        xml2: DotNet XmlDocument;
        resp1: Code[250];
        resp2: Text[250];
    begin
        FundAdministrationSetup.Get;
        FundAdministrationSetup.TestField("External Registrar Webservice");
        
        xml2 := xml2.XmlDocument();
          Result :=  FundAdministrationSetup."External Registrar Webservice"+'/DocUpload?directUrl='+ServerLink;
        xml2.Load(Result);
        
        xmlnodelist := xml2.SelectNodes('//*');
        if( xmlnodelist.ToString()<>'') then
        begin
        j:=xmlnodelist.Count;
        
        xmlnode := xmlnodelist.Item(0);
          if xmlnode.HasChildNodes then begin
            resp1:=xmlnode.FirstChild.InnerText;
            resp2 :=xmlnode.LastChild.InnerText;
            if resp2 <> '' then begin
              Message('Upload Successful');
              exit(resp2);
            end else begin
              Message('Upload Successful');
              exit(resp2);
              end;
          end;
        end;
        
        /*
                    url:=  FundAdministrationSetup."External Registrar Webservice";
        
                    uriObj := uriObj.Uri(url);
                    Request := Request.CreateDefault(uriObj);
                    Request.Method := 'POST';
                    Request.ContentType := 'text/xml';
        
                   // Request.Timeout := 120000;
                   Request.Timeout := 500000;
        // Send the request to the webservice
        stream := stream.StreamWriter(Request.GetRequestStream(), ascii.UTF8);
        stream.Write(xml);
        stream.Close();
        
        // Get the response
        Response := Request.GetResponse();
        reader := reader.XmlTextReader(Response.GetResponseStream());
        
        // Save the response to a XML
        document := document.XmlDocument();
        document.Load(reader);
        
        xmlnodelist := document.SelectNodes('//*');
            IF( xmlnodelist.ToString()<>'') THEN
              BEGIN
                j:=xmlnodelist.Count;
                xmlnode := xmlnodelist.Item(0);
        
                Childnodelist := xmlnode.ChildNodes();
                  FOR j := 0 TO Childnodelist.Count - 1 DO BEGIN
                    Childnode := Childnodelist.ItemOf(j);
                    UploadSharePointOnlineResult:=Childnode.InnerText ;
        
                  END;
        
        END;
        IF UploadSharePointOnlineResult<>'' THEN
          MESSAGE('Upload Successful');
        EXIT(UploadSharePointOnlineResult);
        */

    end;
}

