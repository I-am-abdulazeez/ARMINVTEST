xmlport 50003 "Import Redemption Schedule"
{
    Direction = Import;
    Format = VariableText;
    FormatEvaluate = Legacy;
    UseRequestPage = false;

    schema
    {
        textelement(root)
        {
            tableelement("Redemption Schedule Lines";"Redemption Schedule Lines")
            {
                XmlName = 'Lines';
                fieldelement(StaffID;"Redemption Schedule Lines"."Staff ID")
                {
                }
                fieldelement(Client;"Redemption Schedule Lines"."Client ID")
                {
                    FieldValidate = no;
                }
                textelement(name)
                {
                    XmlName = 'Name';
                }
                textelement(redemptiontype)
                {
                    XmlName = 'RedemptionType';
                }
                textelement(employee)
                {
                    XmlName = 'Employee';
                }
                textelement(employer)
                {
                    XmlName = 'Employer';
                }
                textelement(totalamount)
                {
                    XmlName = 'TotalAmount';
                }
                textelement(employerpaymentoption)
                {
                    XmlName = 'EmployerPaymentOption';
                }

                trigger OnAfterInsertRecord()
                begin
                    "Redemption Schedule Lines".Validate("Redemption Schedule Lines"."Account No");
                    "Redemption Schedule Lines".Validate("Redemption Schedule Lines"."Total Amount");
                    "Redemption Schedule Lines".Validate("Total Amount");
                end;

                trigger OnBeforeInsertRecord()
                begin
                    if FirstLine then begin
                      FirstLine:=false;
                      currXMLport.Skip;
                    end;

                    Lineno:=Lineno+1;
                    "Redemption Schedule Lines"."Schedule Header":=Headerno;
                    "Redemption Schedule Lines"."Line No":=Lineno;
                    if ("Redemption Schedule Lines"."Client ID"='') then
                      Error('Ensure that each line has a Membership Number');

                    if "Redemption Schedule Lines"."Client ID" <> '' then begin
                      ClientAccount.Reset;
                      ClientAccount.SetRange("Client ID","Redemption Schedule Lines"."Client ID");
                      ClientAccount.SetRange("Fund Group",FundGRP);
                      ClientAccount.SetRange("Institutional Active Fund",true);
                      if ClientAccount.FindFirst then  begin
                        "Redemption Schedule Lines".Validate("Account No",ClientAccount."Account No");
                        "Redemption Schedule Lines"."Account No" := ClientAccount."Account No";
                        "Redemption Schedule Lines"."Client ID":=ClientAccount."Client ID";
                        "Redemption Schedule Lines"."Staff ID" := ClientAccount."Staff ID";
                      end else
                        Error('Client with Membership ID %1 does not exist',"Redemption Schedule Lines"."Client ID");
                    end;

                    if TotalAmount='' then TotalAmount:='0';
                    if Employee='' then  Employee:='0';
                    if Employer=''then Employer:='0';

                    Evaluate(TotalAmountDec,TotalAmount);
                    Evaluate(EmployeeAmountdec,Employee);
                    Evaluate(EmployerAmountdec,Employer);
                    if RedemptionType='Part' then
                      "Redemption Schedule Lines"."Redemption Type":="Redemption Schedule Lines"."Redemption Type"::Part
                    else
                      "Redemption Schedule Lines"."Redemption Type":="Redemption Schedule Lines"."Redemption Type"::Full;
                    "Redemption Schedule Lines"."Employee Amount":=EmployeeAmountdec;
                    "Redemption Schedule Lines"."Employer Amount":=EmployerAmountdec;
                    "Redemption Schedule Lines"."Total Amount":=TotalAmountDec;

                    "Redemption Schedule Lines".Validate("Employee Amount",EmployeeAmountdec);
                    "Redemption Schedule Lines".Validate("Employer Amount",EmployerAmountdec);
                    "Redemption Schedule Lines".Validate("Total Amount",TotalAmountDec);
                    "Redemption Schedule Lines"."Employee Amount":=EmployeeAmountdec;
                    "Redemption Schedule Lines"."Total Amount":=TotalAmountDec;

                    if ((EmployerPayOption = EmployerPayOption::"Employee and Employer") and (("Redemption Schedule Lines"."Employee Amount" = 0) or ("Redemption Schedule Lines"."Employer Amount" = 0))) then
                      Error('There must be amount for employer and employee for payment option %1',EmployerPayOption)
                    else if ((EmployerPayOption = EmployerPayOption::"Employee only") and (("Redemption Schedule Lines"."Employee Amount" = 0) or ("Redemption Schedule Lines"."Employer Amount" <> 0))) then
                      Error('Please specify only employee amount for %1 payment option',EmployerPayOption)
                    else if ((EmployerPayOption = EmployerPayOption::"Employer only") and (("Redemption Schedule Lines"."Employer Amount" = 0) or ("Redemption Schedule Lines"."Employee Amount" <> 0))) then
                      Error('Please specify only employer amount for %1 payment option',EmployerPayOption);


                    if ((EmployerPayOption = EmployerPayOption::"Employee and Employer") or (EmployerPayOption = EmployerPayOption::"Employer only")) then
                      if EmployerPaymentOption='Bank Transfer' then begin
                        "Redemption Schedule Lines"."Employer Payment Option" := "Redemption Schedule Lines"."Employer Payment Option"::"Bank Transfer";
                        FdGroup.Reset;
                        FdGroup.SetRange(code,FundGRP);
                        if FdGroup.Find('-') then begin
                          "Redemption Schedule Lines"."Employer Bank Code" := FdGroup."Bank Code";
                          "Redemption Schedule Lines"."Employer Bank Account Name" := FdGroup."Bank Account Name";
                          "Redemption Schedule Lines"."Employer Bank Account No" := FdGroup."Bank Account No";
                        end;
                      end else
                          "Redemption Schedule Lines"."Employer Payment Option" := "Redemption Schedule Lines"."Employer Payment Option"::Cheque;
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
        FirstLine:=true;
    end;

    var
        Headerno: Code[20];
        Lineno: Integer;
        Fundcode: Code[30];
        Client: Record Client;
        ClientAccount: Record "Client Account";
        ClientAdministration: Codeunit "Client Administration";
        FirstLine: Boolean;
        FundGRP: Code[40];
        EmployeeAmountdec: Decimal;
        EmployerAmountdec: Decimal;
        TotalAmountDec: Decimal;
        ClientId: Code[40];
        FdGroup: Record "Fund Groups";
        EmployerPayOption: Option "Employee only","Employee and Employer","Employer only";

    procedure Getheader(pHeaderno: Code[20];Fundgroup: Code[40];HeaderEmployerOption: Option "Employee only","Employee and Employer","Employer only")
    begin
        Headerno:=pHeaderno;
        FundGRP:=Fundgroup;
        EmployerPayOption := HeaderEmployerOption;
        Lineno:=0
    end;
}

