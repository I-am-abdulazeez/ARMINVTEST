xmlport 50002 "Import Subscription Schedule"
{
    Direction = Import;
    Format = VariableText;
    FormatEvaluate = Legacy;
    UseRequestPage = false;

    schema
    {
        textelement(root)
        {
            tableelement("Subscription Schedule Lines";"Subscription Schedule Lines")
            {
                XmlName = 'Lines';
                fieldelement(StaffID;"Subscription Schedule Lines"."Staff ID")
                {
                    FieldValidate = no;
                }
                fieldelement(Acc;"Subscription Schedule Lines"."Client ID")
                {
                    FieldValidate = no;
                }
                textelement(name)
                {
                    XmlName = 'Name';
                }
                textelement(employeeamount)
                {
                    XmlName = 'EmployeeAmount';
                }
                textelement(employeramount)
                {
                    XmlName = 'EmployerAmount';
                }
                textelement(totalamount)
                {
                    XmlName = 'TotalAmount';
                }

                trigger OnAfterInsertRecord()
                begin
                    "Subscription Schedule Lines".Validate("Subscription Schedule Lines"."Account No");
                    "Subscription Schedule Lines".Validate("Subscription Schedule Lines"."Total Amount");
                end;

                trigger OnBeforeInsertRecord()
                var
                    Accno: Code[40];
                begin
                    if Firstline then begin
                      Firstline:=false;
                      currXMLport.Skip;
                    end;
                    Lineno:=Lineno+1;
                    "Subscription Schedule Lines"."Schedule Header":=Headerno;
                    "Subscription Schedule Lines"."Line No":=Lineno;
                    if ("Subscription Schedule Lines"."Client ID"='') and ("Subscription Schedule Lines"."Staff ID"='') then
                    Error('Ensure that each line has a sharp/Staff ID or Membership Number');

                      Client.Reset;
                      if "Subscription Schedule Lines"."Staff ID"<>'' then begin

                        ClientAccount.Reset;
                        ClientAccount.SetRange("Institutional Active Fund",true);
                        ClientAccount.SetRange("Staff ID","Subscription Schedule Lines"."Staff ID");
                        ClientAccount.SetRange("Fund Group",FundGRP);
                        if ClientAccount.FindFirst then  begin
                          "Subscription Schedule Lines".Validate("Account No",ClientAccount."Account No");

                        end else begin
                        // Accno:=ClientAdministration.NewAccountReturnACC(Client."Membership ID","Subscription Schedule Lines"."Fund Code");
                        //"Subscription Schedule Lines".VALIDATE("Account No",Accno);
                          Error('Client with SharpID/Staff ID %1 has no Active account in Fund Group %2',"Subscription Schedule Lines"."Staff ID",FundGRP)
                        end

                      end else  begin

                        Client.SetRange("Membership ID","Subscription Schedule Lines"."Client ID");
                      if Client.FindFirst then begin
                        ClientAccount.Reset;
                        ClientAccount.SetRange("Institutional Active Fund",true);
                        ClientAccount.SetRange("Client ID",Client."Membership ID");
                        ClientAccount.SetRange("Fund Group",FundGRP);
                        if ClientAccount.FindFirst then  begin
                          "Subscription Schedule Lines".Validate("Account No",ClientAccount."Account No");

                        end else begin
                        // Accno:=ClientAdministration.NewAccountReturnACC(Client."Membership ID","Subscription Schedule Lines"."Fund Code");
                        //"Subscription Schedule Lines".VALIDATE("Account No",Accno);
                          Error('Client with SharpID/Staff ID %1 has no Active account in Fund Group %2',"Subscription Schedule Lines"."Staff ID",FundGRP)
                        end

                      end else begin
                       if "Subscription Schedule Lines"."Staff ID"<>'' then
                        Error('Client with SharpID/Staff ID %1 does not exist',"Subscription Schedule Lines"."Staff ID")
                       else if "Subscription Schedule Lines"."Client ID"<>'' then
                        Error('Client with Membership ID %1 does not exist',"Subscription Schedule Lines"."Client ID");
                       end;

                    end ;

                         if TotalAmount='' then TotalAmount:='0';
                       if EmployeeAmount='' then  EmployeeAmount:='0';
                       if EmployeeAmount=''then EmployerAmount:='0';

                    Evaluate(TotalAmountDec,TotalAmount);
                    Evaluate(EmployeeAmountdec,EmployeeAmount);
                    Evaluate(EmployerAmountdec,EmployerAmount);
                    "Subscription Schedule Lines".Validate("Employee Amount",EmployeeAmountdec);
                    "Subscription Schedule Lines".Validate("Employer Amount",EmployerAmountdec);
                    "Subscription Schedule Lines".Validate("Total Amount",TotalAmountDec);
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
        FundGRP: Code[40];
        Firstline: Boolean;
        EmployeeAmountdec: Decimal;
        EmployerAmountdec: Decimal;
        TotalAmountDec: Decimal;

    procedure Getheader(pHeaderno: Code[20];fundgroup: Code[40])
    begin
        Headerno:=pHeaderno;
        FundGRP:=fundgroup;
        Lineno:=0
    end;
}

