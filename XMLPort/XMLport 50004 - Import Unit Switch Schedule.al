xmlport 50004 "Import Unit Switch Schedule"
{
    Direction = Import;
    Format = VariableText;
    FormatEvaluate = Legacy;
    UseRequestPage = false;

    schema
    {
        textelement(root)
        {
            tableelement("Unit Switch Lines";"Unit Switch Lines")
            {
                XmlName = 'Lines';
                fieldelement(StaffID;"Unit Switch Lines"."Staff ID")
                {
                    FieldValidate = no;
                }
                fieldelement(ClientID;"Unit Switch Lines"."From Client ID")
                {
                    FieldValidate = no;
                }
                fieldelement(ClientName;"Unit Switch Lines"."From Client Name")
                {
                }
                fieldelement(ToFund;"Unit Switch Lines"."To Fund Code")
                {
                    FieldValidate = no;
                }

                trigger OnAfterInsertRecord()
                begin
                    "Unit Switch Lines".Validate("Unit Switch Lines"."From Account No");
                    "Unit Switch Lines".Validate("Unit Switch Lines"."From Account No");
                    "Unit Switch Lines".Validate("Unit Switch Lines"."To Account No");
                    "Unit Switch Lines".Validate("Unit Switch Lines"."Transfer Type","Unit Switch Lines"."Transfer Type"::Full);
                end;

                trigger OnBeforeInsertRecord()
                begin
                    if Firstline then begin
                      Firstline:=false;
                      currXMLport.Skip;
                    end;
                    
                    
                    Lineno:=Lineno+1;
                    "Unit Switch Lines"."Header No":=Headerno;
                    "Unit Switch Lines"."Line No":=Lineno;
                    /*
                    IF "Unit Switch Lines"."From Fund Code"="Unit Switch Lines"."To Fund Code" THEN
                      ERROR('Staff ID %1 has the same FROM & TO Fund',"Unit Switch Lines"."Staff ID");
                    */
                    
                    if ("Unit Switch Lines"."From Client ID"='') and ("Unit Switch Lines"."Staff ID"='') then
                    Error('Ensure that each line has a sharp/Staff ID or Membership Number');
                    
                    if "Unit Switch Lines"."Staff ID"<>'' then begin
                    
                        ClientAccount.Reset;
                        ClientAccount.SetRange("Institutional Active Fund",true);
                        ClientAccount.SetRange("Staff ID","Unit Switch Lines"."Staff ID");
                        ClientAccount.SetRange("Fund Group",FundGrp);
                        if ClientAccount.FindFirst then  begin
                        "Unit Switch Lines".Validate("From Account No",ClientAccount."Account No");
                    
                        end else begin
                        // Accno:=ClientAdministration.NewAccountReturnACC(Client."Membership ID","Subscription Schedule Lines"."Fund Code");
                        //"Subscription Schedule Lines".VALIDATE("Account No",Accno);
                          Error('Client with SharpID/Staff ID %1 has no Active account in Fund Group %2',"Unit Switch Lines"."Staff ID",FundGrp)
                        end
                    end  else begin
                      Client.Reset;
                    
                        Client.SetRange("Membership ID","Unit Switch Lines"."From Client ID");
                    if Client.FindFirst then begin
                      ClientAccount.Reset;
                      ClientAccount.SetRange("Institutional Active Fund",true);
                      ClientAccount.SetRange("Client ID",Client."Membership ID");
                      ClientAccount.SetRange("Fund Group",FundGrp);
                      if ClientAccount.FindFirst then  begin
                        "Unit Switch Lines".Validate("From Account No",ClientAccount."Account No");
                    
                    if "Unit Switch Lines"."From Fund Code"="Unit Switch Lines"."To Fund Code" then
                    /* IF "Unit Switch Lines"."Staff ID"<>'' THEN
                      ERROR('Staff ID %1 has the same FROM & TO Fund',"Unit Switch Lines"."Staff ID")
                      ELSE IF "Unit Switch Lines"."From Client ID"<>'' THEN
                      ERROR('Member %1 has the same FROM & TO Fund',"Unit Switch Lines"."From Client ID");
                    
                    */ currXMLport.Skip;
                    
                      end else begin
                          Error('Client with SharpID/Staff ID %1 has no Active account in Fund Group %2',"Unit Switch Lines"."Staff ID",FundGrp)
                    
                      end;
                      ClientAccount.Reset;
                      ClientAccount.SetRange("Fund No","Unit Switch Lines"."To Fund Code");
                      ClientAccount.SetRange("Client ID",Client."Membership ID");
                      if ClientAccount.FindFirst then  begin
                        "Unit Switch Lines".Validate("Unit Switch Lines"."To Account No",ClientAccount."Account No");
                    
                      end else begin
                        Accno:=ClientAdministration.NewAccountReturnACC(Client."Membership ID","Unit Switch Lines"."To Fund Code");
                        "Unit Switch Lines".Validate("Unit Switch Lines"."To Account No",Accno);
                        //ERROR('Staff ID %1 has not account in Fund %2',"Unit Switch Lines"."Staff ID","Unit Switch Lines"."To Fund Code");
                      end
                    
                    
                    end else begin
                       if "Unit Switch Lines"."Staff ID"<>'' then
                        Error('Client with SharpID/Staff ID %1 does not exist',"Unit Switch Lines"."Staff ID")
                       else if "Unit Switch Lines"."From Client ID"<>'' then
                        Error('Client with Membership ID %1 does not exist',"Unit Switch Lines"."From Client ID");
                       end;
                    end;
                    "Unit Switch Lines".Validate("Unit Switch Lines"."From Account No");
                    "Unit Switch Lines".Validate("Unit Switch Lines"."To Account No");
                    "Unit Switch Lines".Validate("Unit Switch Lines"."Transfer Type","Unit Switch Lines"."Transfer Type"::Full);

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

    trigger OnPreXmlPort()
    begin
        Firstline:=true;
    end;

    var
        Headerno: Code[20];
        Lineno: Integer;
        Fundcode: Code[30];
        Client: Record Client;
        ClientAccount: Record "Client Account";
        ClientAdministration: Codeunit "Client Administration";
        Accno: Code[40];
        FundGrp: Code[40];
        Firstline: Boolean;

    procedure Getheader(pHeaderno: Code[20];Fundgroup: Code[40])
    begin
        Headerno:=pHeaderno;
        FundGrp:=Fundgroup;
        Lineno:=0
    end;
}

