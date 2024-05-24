xmlport 50028 "Import Loan Repayment"
{
    // version THL-LOAN-1.0.0

    Format = VariableText;
    FormatEvaluate = Legacy;
    UseRequestPage = false;

    schema
    {
        textelement(ImportLoanRepayment)
        {
            tableelement("<loan repayment lines>";"Loan Repayment Lines")
            {
                XmlName = 'LoanRepyment';
                fieldelement(PersNo;"<Loan Repayment Lines>"."Pers. No.")
                {
                    Width = 1;
                }
                fieldelement(Date;"<Loan Repayment Lines>".Date)
                {
                }
                fieldelement(Name;"<Loan Repayment Lines>"."Last Name and First Name")
                {
                }
                fieldelement(ValuationDate;"<Loan Repayment Lines>"."Valuation Date")
                {
                }
                fieldelement(total;"<Loan Repayment Lines>"."Total Payment")
                {
                }

                trigger OnBeforeInsertRecord()
                begin
                    LineNo:=LineNo+1000;
                    "<Loan Repayment Lines>"."Line No.":=LineNo;
                    "<Loan Repayment Lines>"."Header No":=BatchNo;

                    if ScheduleType = ScheduleType::"Off-Schedule Repayment" then
                      "<Loan Repayment Lines>".Application := "<Loan Repayment Lines>".Application::"Apply to Principal Only";

                    if Clients.Get(LoanMgt.GetClientNoFromStaffID("<Loan Repayment Lines>"."Pers. No.")) then begin
                    "<Loan Repayment Lines>"."DB Name" := Clients.Surname+' '+Clients."First Name"+' '+Clients."Other Name/Middle Name";
                    end else
                    Error('There is no client by the staff ID %1 on the system!',"<Loan Repayment Lines>"."Pers. No.");
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    trigger OnPostXmlPort()
    begin
        Message ('Importation completed successfully');
    end;

    trigger OnPreXmlPort()
    begin
        LineNo:= 10000;
    end;

    var
        BatchNo: Code[20];
        LoanHeaderCopy: Record "Loan Repayment Header";
        Clients: Record Client;
        LineNo: Integer;
        PersNo: Code[20];
        LoanMgt: Codeunit "Loan Management";
        ScheduleType: Option "Monthly Advice to Employer","Off-Schedule Repayment";

    procedure GetRecHeader(var ImportHeader: Record "Loan Repayment Header")
    begin
        BatchNo:=ImportHeader.Code;
        LoanHeaderCopy.Copy(ImportHeader);
        ScheduleType := ImportHeader."Type of Schedule";
    end;
}

