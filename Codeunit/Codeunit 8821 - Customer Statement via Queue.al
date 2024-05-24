codeunit 8821 "Customer Statement via Queue"
{
    // version NAVW113.11

    TableNo = "Job Queue Entry";

    trigger OnRun()
    var
        TempErrorMessage: Record "Error Message" temporary;
        ErrorMessageManagement: Codeunit "Error Message Management";
        ErrorMessageHandler: Codeunit "Error Message Handler";
        CustomerLayoutStatement: Codeunit "Customer Layout - Statement";
        XmlContent: Text;
    begin
        ErrorMessageManagement.Activate(ErrorMessageHandler);
        ErrorMessageManagement.PushContext(RecordId,0,'');

        XmlContent := GetXmlContent;
        if XmlContent = '' then
          ErrorMessageManagement.LogErrorMessage(0,RequestParametersHasNotBeenSetErr,Rec,FieldNo(XML),'')
        else
          CustomerLayoutStatement.RunReportWithParameters(XmlContent);

        ErrorMessageHandler.AppendTo(TempErrorMessage);
        LogErrors(TempErrorMessage,Rec);
    end;

    var
        RequestParametersHasNotBeenSetErr: Label 'Request parameters for the Standard Statement report have not been set up.';

    local procedure LogErrors(var TempErrorMessage: Record "Error Message" temporary;JobQueueEntry: Record "Job Queue Entry")
    var
        JobQueueLogEntry: Record "Job Queue Log Entry";
    begin
        if  TempErrorMessage.FindSet then
          repeat
            JobQueueLogEntry."Entry No." := 0;
            JobQueueLogEntry.ID := JobQueueEntry.ID;
            JobQueueLogEntry."User ID" := UserId;
            JobQueueLogEntry."Start Date/Time" := CurrentDateTime;
            JobQueueLogEntry."End Date/Time" := CurrentDateTime;
            JobQueueLogEntry."Object Type to Run" := JobQueueEntry."Object Type to Run";
            JobQueueLogEntry."Object ID to Run" := JobQueueEntry."Object ID to Run";
            JobQueueLogEntry.Status := JobQueueLogEntry.Status::Error;
            JobQueueLogEntry."Error Message" := TempErrorMessage.Description;
            JobQueueLogEntry.Insert(true);
          until TempErrorMessage.Next = 0;
    end;
}

