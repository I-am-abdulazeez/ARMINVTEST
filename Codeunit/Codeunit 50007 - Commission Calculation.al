codeunit 50007 "Commission Calculation"
{

    trigger OnRun()
    begin
    end;

    var
        AccountManager: Record "Account Manager";
        Client: Record Client;
        ClientAccount: Record "Client Account";
        ClientTransactions: Record "Client Transactions";
        DirectDebitMandate: Record "Direct Debit Mandate";
        CommissionLines: Record "Commission Lines";
        FUMFees: Record "FUM & Fees";
        Inflows: Record Inflows;
        InitialDDM: Record "Initial & DDM";
        NoofNewClients: Integer;
        NoofDDM: Integer;
        TotalFUM: Decimal;
        CEntryno: Integer;
        FEntryno: Integer;
        IEntryno: Integer;
        NEntryno: Integer;
        DEntryno: Integer;
        StartDate: Date;
        EndDate: Date;
        DailyFUM: array [1000] of Decimal;
        i: Integer;
        FundAdministration: Codeunit "Fund Administration";
        TotalFees: Decimal;
        Commisionstructure: Record "Commision structure";
        TotalInflow: Decimal;
        window: Dialog;

    procedure CalculateCommission(CommissionHeader: Record "Commission Header")
    begin
        CommissionHeader.TestField("Start Date");
        CommissionHeader.TestField("End Date");
          NEntryno:=0;
            DEntryno:=0;
            CEntryno:=0;
            IEntryno:=0;
            FEntryno:=0;
            window.Open('Calculating commission for #1#######');

        Inflows.Reset;
        Inflows.SetRange(No,CommissionHeader.No);
        Inflows.DeleteAll;
        FUMFees.Reset;
        FUMFees.SetRange(No,CommissionHeader.No);
        FUMFees.DeleteAll;
        InitialDDM.Reset;
        InitialDDM.SetRange(No,CommissionHeader.No);
        InitialDDM.DeleteAll;

        CommissionLines.Reset;
        CommissionLines.SetRange(No,CommissionHeader.No);
        CommissionLines.DeleteAll;

        AccountManager.Reset;
        AccountManager.SetRange("Agent Code",'0010');
        if AccountManager.FindFirst then
          repeat
        window.Update(1,AccountManager."Agent Code");
          Commisionstructure.Reset;
          Commisionstructure.SetRange(Code,AccountManager."Commission Structure");
          if Commisionstructure.FindFirst then ;
            NoofDDM:=0;
            TotalFUM:=0;
            NoofNewClients:=0;
            Clear(DailyFUM);
            TotalFUM:=0;
            TotalFees:=0;
            TotalInflow:=0;

            Client.Reset;
            Client.SetCurrentKey("Account Executive Code");
            Client.SetRange("Account Executive Code",AccountManager."Agent Code");
            if Client.FindFirst then
              repeat
                StartDate:=CommissionHeader."Start Date";
                // check if new client
                if (Client."Created Dates">CalcDate('-1D',StartDate)) and (Client."Created Dates"<CalcDate('1D',CommissionHeader."End Date")) then begin
                  NoofNewClients:=NoofNewClients+1;
                  NEntryno:=NEntryno+1;
                  InitialDDM.Init;
                  InitialDDM.No:=CommissionHeader.No;
                  InitialDDM."Line No":=NEntryno;
                  InitialDDM."Agent Code":=AccountManager."Agent Code";
                  InitialDDM."Agent Name":=AccountManager."First Name"+ ' '+AccountManager."Middle Name"+ ' '+AccountManager.Surname;
                  InitialDDM."Account No":=Client."Membership ID";
                  InitialDDM."Account Name":=Client.Name;
                  InitialDDM.Type:=InitialDDM.Type::"New Client";
                  InitialDDM.Insert;


                  end;
                //Direct Debit
                DirectDebitMandate.Reset;
                DirectDebitMandate.SetRange("Client ID",Client."Membership ID");
                DirectDebitMandate.SetRange(Status,DirectDebitMandate.Status::"Approved By Bank");
                if DirectDebitMandate.FindFirst then repeat
                  NoofDDM:=NoofDDM+1;
                  NEntryno:=NEntryno+1;
                  InitialDDM.Init;
                  InitialDDM.No:=CommissionHeader.No;
                  InitialDDM."Line No":=NEntryno;
                  InitialDDM."Agent Code":=AccountManager."Agent Code";
                  InitialDDM."Agent Name":=AccountManager."First Name"+ ' '+AccountManager."Middle Name"+ ' '+AccountManager.Surname;
                  InitialDDM."Account No":=DirectDebitMandate."Account No";
                  InitialDDM."Account Name":=Client.Name;
                  InitialDDM.Type:=InitialDDM.Type::"Active DDM";
                  InitialDDM.Insert;
                until DirectDebitMandate.Next=0;
                //TOTAL FUM

                i:=0;







                while (StartDate<CommissionHeader."End Date") or (StartDate=CommissionHeader."End Date") do begin
                  i:=i+1;
                ClientAccount.Reset;
                ClientAccount.SetCurrentKey("Client ID");
                ClientAccount.SetRange("Client ID",Client."Membership ID");
                ClientAccount.SetFilter("Date Filter",'..%1',StartDate);
                if ClientAccount.FindFirst then begin
                  repeat
                    ClientAccount.CalcFields(ClientAccount."No of Units");
                    DailyFUM[i]:= DailyFUM[i]+(ClientAccount."No of Units"*FundAdministration.GetFundNAVPrice(ClientAccount."Fund No",StartDate));

                  until ClientAccount.Next=0;
                end;
                  StartDate:=CalcDate('1D',StartDate);

                end;


              until Client.Next=0;


              ClientTransactions.Reset;
              ClientTransactions.SetCurrentKey("Agent Code","Value Date");
              ClientTransactions.SetRange("Agent Code",AccountManager."Agent Code");
              ClientTransactions.SetRange("Value Date",CommissionHeader."Start Date",CommissionHeader."End Date");
              ClientTransactions.SetRange("Transaction Type",ClientTransactions."Transaction Type"::Subscription);
              ClientTransactions.SetRange(Reversed,false);
              if ClientTransactions.FindFirst then
                repeat
                  IEntryno:=IEntryno+1;
                  Inflows.Init;
                  Inflows.No:=CommissionHeader.No;
                  Inflows."Line No":=IEntryno;
                  Inflows."Agent Code":=AccountManager."Agent Code";
                  Inflows."Agent Name":=AccountManager."First Name"+ ' '+AccountManager."Middle Name"+ ' '+AccountManager.Surname;
                  Inflows."Account No":=ClientTransactions."Account No";
                  Inflows.Date:=ClientTransactions."Value Date";
                  Inflows.Amount:=ClientTransactions.Amount;
                  Inflows."Transaction Ref":=ClientTransactions."Transaction No";
                  Inflows.Insert;
                  TotalInflow:=TotalInflow+ClientTransactions.Amount;
                until ClientTransactions.Next=0;
                StartDate:=CommissionHeader."Start Date";
                i:=0;

                while (StartDate<CommissionHeader."End Date") or (StartDate=CommissionHeader."End Date") do begin
                  i:=i+1;
                  FEntryno:=FEntryno+1;

                  TotalFUM:=TotalFUM+DailyFUM[i];
                  TotalFees:=TotalFees+(DailyFUM[i]*Commisionstructure."Fee %")/(100*365);
                  FUMFees.Init;
                  FUMFees.No:=CommissionHeader.No;
                  FUMFees."Line No":=FEntryno;
                  FUMFees."Agent Code":=AccountManager."Agent Code";
                  FUMFees."Agent Name":=AccountManager."First Name"+ ' '+AccountManager."Middle Name"+ ' '+AccountManager.Surname;
                  FUMFees.Date:=StartDate;
                  FUMFees.FUM:=DailyFUM[i];
                  FUMFees.Fees:=(DailyFUM[i]*Commisionstructure."Fee %")/(100*365);
                  FUMFees.Insert;
                  StartDate:=CalcDate('1D',StartDate);
                end;

              if i=0 then i:=1;
        CEntryno:=CEntryno+1;
          CommissionLines.Init;
          CommissionLines.No:=CommissionHeader.No;
          CommissionLines."Line No":=CEntryno;
          CommissionLines."Agent Code":=AccountManager."Agent Code";
          CommissionLines."Agent Name":=AccountManager."First Name"+ ' '+AccountManager."Middle Name"+ ' '+AccountManager.Surname;
          CommissionLines."Average FUM":=TotalFUM/i;
          CommissionLines.Inflow:=TotalInflow;
          CommissionLines."New Client":=NoofNewClients;
          CommissionLines."Active Direct Debit":=NoofDDM;
          CommissionLines."Total Fee":=TotalFees;
          CommissionLines."MGT Fees to ARM":=((Commisionstructure."ARM Fee %"/Commisionstructure."Fee %")*TotalFees);
          //CommissionLines."MGT Fees to IC":= (Commisionstructure."IC Fees %"*TotalFees)/100;
          //CommissionLines."Max Commission":= (Commisionstructure."Max Comm %"*CommissionLines."MGT Fees to IC")/100;
          CommissionLines."FUM Commision Due to AE":=((Commisionstructure."Agent Fee %"/Commisionstructure."Fee %")*TotalFees);
          CommissionLines."New Client Commision":=NoofNewClients*Commisionstructure."Amount Per New Client";
          CommissionLines."DDM Commission":=NoofDDM*Commisionstructure."Amount Per DDM";
          CommissionLines."Total Commission":=CommissionLines."FUM Commision Due to AE"+CommissionLines."New Client Commision"+CommissionLines."DDM Commission";
          CommissionLines.Insert;

          until AccountManager.Next=0;
          window.Close;
    end;
}

