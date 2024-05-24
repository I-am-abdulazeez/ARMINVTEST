codeunit 1421 "Doc. Exch. Serv. - Recv. Docs."
{
    // version NAVW19.00


    trigger OnRun()
    var
        DocExchServiceSetup: Record "Doc. Exch. Service Setup";
        DocExchServiceMgt: Codeunit "Doc. Exch. Service Mgt.";
    begin
        DocExchServiceSetup.Get;
        DocExchServiceMgt.ReceiveDocuments(DocExchServiceSetup.RecordId);
    end;
}

