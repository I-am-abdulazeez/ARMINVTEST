codeunit 50011 "CRM Service"
{

    trigger OnRun()
    begin
        //Run job to check for failed redemption
        //CheckFailedRedemption();

        UpdateRedemptionBankStatus('CAS-101112-D5K7M3','1','Successful','1');
        Message('Done')
    end;

    var
        FundAdministrationSetup: Record "Fund Administration Setup";

    procedure CheckFailedRedemption()
    var
        PostedRedemption: Record "Posted Redemption";
        EOD: Record "EOD Tracker";
        EODdate: Date;
    begin
        EOD.Reset;
        if EOD.FindLast then
          EODdate:= EOD.Date;
        PostedRedemption.Reset;
        PostedRedemption.SetRange("Bank Response Status",PostedRedemption."Bank Response Status"::Failed);
        PostedRedemption.SetRange("Reversal Status",PostedRedemption."Reversal Status"::Approved);
        PostedRedemption.SetRange("Value Date",EODdate);
        if PostedRedemption.FindFirst then begin
          repeat
            UpdateRedemptionBankStatus(PostedRedemption.No,'1',PostedRedemption."Bank Response Comment",'2');
          until PostedRedemption.Next = 0;
        end;
    end;

    procedure UpdateRedemptionBankStatus(caseNumber: Text[100];bankResponseStatus: Code[10];bankResponseDetails: Text[100];redemptionReversalStatus: Code[10])
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

        result:=  FundAdministrationSetup."CRM Webservice"+'/Cases/App/UpdateRedemptionBankStatus?caseNumber='+caseNumber+'&bankResponseStatus='+bankResponseStatus+'&bankResponseDetails='+bankResponseDetails;
        result += '&redemptionReversalStatus='+redemptionReversalStatus;

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

        // MESSAGE(ResponseCode);
        // MESSAGE(ResponseDescription);
        // MESSAGE(ReferenceNumber);
    end;

    procedure UpdateReversalTransaction(caseNumber: Text[100];bankResponseStatus: Code[10];bankResponseDetails: Text[100];redemptionReversalStatus: Code[10])
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
        
        result:=  FundAdministrationSetup."CRM Webservice"+'/Cases/App/UpdateRedemptionBankStatus?caseNumber='+caseNumber+'&bankResponseStatus='+bankResponseStatus+'&bankResponseDetails='+bankResponseDetails;
        result += '&redemptionReversalStatus='+redemptionReversalStatus;
        
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
        
        /*MESSAGE(ResponseCode);
        MESSAGE(ResponseDescription);
        MESSAGE(ReferenceNumber);
        */

    end;
}

