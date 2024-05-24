page 50003 "Client Card"
{
    DeleteAllowed = false;
    InsertAllowed = true;
    PageType = Card;
    SourceTable = Client;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Membership ID";"Membership ID")
                {
                    Editable = false;
                    ShowMandatory = true;
                }
                field("Client Type";"Client Type")
                {
                    ShowMandatory = true;

                    trigger OnValidate()
                    begin
                        toggleshow
                    end;
                }
            }
            group(Individual)
            {
                Visible = showIndividualname;
                field(Title;Title)
                {
                    Editable = false;
                    ShowMandatory = true;
                }
                field("First Name";"First Name")
                {
                    Editable = false;
                    ShowMandatory = true;
                }
                field(Surname;Surname)
                {
                    Editable = false;
                    ShowMandatory = true;
                }
                field("Other Name/Middle Name";"Other Name/Middle Name")
                {
                    Editable = false;
                    ShowMandatory = true;
                }
                field(Gender;Gender)
                {
                    Editable = false;
                    ShowMandatory = true;
                    Visible = showIndividualname;
                }
                field("Date Of Birth";"Date Of Birth")
                {
                    Caption = 'Date of Birth';
                    Editable = false;
                    ShowMandatory = true;

                    trigger OnValidate()
                    begin
                        calcage
                    end;
                }
                field(Age;Age)
                {
                    Editable = false;
                }
                field("House Number";"House Number")
                {
                    Caption = 'House Number';
                    ShowMandatory = true;
                }
                field("Premises/Estate";"Premises/Estate")
                {
                }
                field("Street Name";"Street Name")
                {
                    ShowMandatory = true;
                }
                field("City/Town";"City/Town")
                {
                    ShowMandatory = true;
                }
                field(State;State)
                {
                    ShowMandatory = true;
                }
                field(Country;Country)
                {
                    ShowMandatory = true;
                }
                field("Mailing Address";"Mailing Address")
                {
                    Editable = false;
                    ShowMandatory = true;
                }
                field(Nationality;Nationality)
                {
                }
                field("Business/Occupation";"Business/Occupation")
                {
                }
                field("Mothers Maiden Name";"Mothers Maiden Name")
                {
                }
                field("Marital Status";"Marital Status")
                {
                }
                field("Place of Birth";"Place of Birth")
                {
                }
                field("Type of ID";"Type of ID")
                {
                }
                field("ID Card Number";"ID Card Number")
                {
                }
                field("BVN Number";"BVN Number")
                {
                    ShowMandatory = true;
                }
                field(NIN;NIN)
                {
                }
                field("Politically Exposed Persons";"Politically Exposed Persons")
                {
                }
                field("Political Information";"Political Information")
                {
                    MultiLine = true;
                }
                field(Jurisdiction;Jurisdiction)
                {
                }
                field("US Tax Number";"US Tax Number")
                {
                }
                field(Religion;Religion)
                {
                }
            }
            group("Sponsor Details")
            {
                Visible = Showminor;
                field(SponsorTitle;SponsorTitle)
                {
                    ShowMandatory = true;
                }
                field("Sponsor First Name";"Sponsor First Name")
                {
                    ShowMandatory = true;
                }
                field("Sponsor Last Name";"Sponsor Last Name")
                {
                    ShowMandatory = true;
                }
                field("Sponsor Middle Names";"Sponsor Middle Names")
                {
                    ShowMandatory = true;
                }
            }
            group(Corporate)
            {
                Visible = ShowCompanyname;
                field("Company Name";"First Name")
                {
                    ShowMandatory = true;
                }
                field("Certificate of Incorporation";"Certificate of Incorporation")
                {
                }
                field("Date of Incorporation";"Date Of Birth")
                {
                    Caption = 'Date of Incorporation';
                    ShowMandatory = true;

                    trigger OnValidate()
                    begin
                        calcage
                    end;
                }
                field("Office NUmber";"House Number")
                {
                }
                field(Street;"Street Name")
                {
                    Caption = 'Street Name';
                }
                field("Estate/Area";"Premises/Estate")
                {
                }
                field("City ";"City/Town")
                {
                    ShowMandatory = true;
                }
                field(CorprateState;State)
                {
                    Caption = 'State';
                    ShowMandatory = true;
                }
                field("Corporate Country";Country)
                {
                    ShowMandatory = true;
                }
                field("Company Address";"Mailing Address")
                {
                    Editable = false;
                }
                field("Company Jurisdiction";Jurisdiction)
                {
                }
                field("Tax Number";"US Tax Number")
                {
                }
            }
            group(Joint)
            {
                Visible = ShowJoint;
                field("Account Name";"First Name")
                {
                    ShowMandatory = true;
                }
                field("Joint Country";Country)
                {
                    ShowMandatory = true;
                }
                field("Joint Mailing Address";"Mailing Address")
                {
                }
            }
            part(Control39;"Joint Account Holders")
            {
                SubPageLink = "Client ID"=FIELD("Membership ID");
                Visible = ShowJoint;
            }
            group(Communication)
            {
                field("E-Mail";"E-Mail")
                {
                    ShowMandatory = true;
                }
                field("Phone Number";"Phone Number")
                {
                    ShowMandatory = true;
                }
                field("SMS Notification";"SMS Notification")
                {
                }
                field("Social Media Engagement";"Social Media Engagement")
                {
                }
                field("Email Notification";"Email Notification")
                {
                }
                field("Post Notification";"Post Notification")
                {
                }
            }
            group(Administration)
            {
                field("Account Executive Code";"Account Executive Code")
                {
                    ShowMandatory = true;
                }
                field("Main Account";"Main Account")
                {
                }
                field("Diaspora Client";"Diaspora Client")
                {
                }
                field("Account Status";"Account Status")
                {
                }
                field("AOD Verified";"AOD Verified")
                {
                }
                field("AOD Verified By";"AOD Verified By")
                {
                }
                field("No of Cautions";"No of Cautions")
                {
                }
                field("Caution Restrictions";"Caution Restrictions")
                {
                }
                field("Bank Code";"Bank Code")
                {
                }
                field("Bank Branch";"Bank Branch")
                {
                }
                field("Bank Account Name";"Bank Account Name")
                {
                }
                field("Bank Account Number";"Bank Account Number")
                {
                }
            }
            part(NOK;"Client Next of Kins")
            {
                SubPageLink = "Client ID"=FIELD("Membership ID");
                Visible =  showNOK;
            }
            part(Control40;"Client Accounts")
            {
                SubPageLink = "Client ID"=FIELD("Membership ID");
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("New Account")
            {
                Image = CreateBinContent;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    CreateAccountDialog.getClientId("Membership ID");
                    CreateAccountDialog.Run;
                end;
            }
            action("New Caution")
            {
                Image = CreateCreditMemo;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ClientAdministration.NewCaution("Membership ID");
                end;
            }
            action("New Lien")
            {
                Image = CreatePutAway;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ClientAdministration.NewLien("Membership ID",Requestlevel::Client);
                end;
            }
            action("Send AOD for Verification")
            {
                Image = AddWatch;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = Showverify;

                trigger OnAction()
                begin
                    if not Confirm('Are you sure you want to send this Client AOD for verification?') then
                      Error('');
                    "AOD Verified":="AOD Verified"::"Pending Approval";
                    Modify;
                end;
            }
        }
        area(navigation)
        {
            action(AODS)
            {
                Image = DocInBrowser;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ClientAdministration.ViewKYCLinks("Membership ID");
                end;
            }
            action("Account Managers History")
            {
                Image = MaintenanceLedgerEntries;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ClientAdministration.AccountManagerHistory("Membership ID");
                end;
            }
            action("Accounts Subscribed")
            {
                Image = BOMRegisters;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ClientAdministration.AccountsSubscribed("Membership ID");
                end;
            }
            action("Sub Clients")
            {
                Image = JobRegisters;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ClientAdministration.ClientSubAccount("Membership ID");
                end;
            }
            action("Client Cautions")
            {
                Image = VoidCheck;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ClientAdministration.ViewClientCautions("Membership ID");
                end;
            }
            action(Liens)
            {
                Image = ReceivableBill;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ClientAdministration.ViewAccountLines("Membership ID",0);
                end;
            }
            action(Transactions)
            {
                Image = LedgerEntries;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ClientAdministration.ViewClientTransactions("Membership ID");
                end;
            }
            action("Online Indemnities")
            {
                Image = BinLedger;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ClientAdministration.ViewOnlineIndemnity("Membership ID");
                end;
            }
            action("Direct Debit Mandates")
            {
                Image = Agreement;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ClientAdministration.ViewDirectDebit("Membership ID");
                end;
            }
        }
        area(reporting)
        {
            action("Account Statement")
            {
                Image = SalesTaxStatement;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ClientAdministration.ViewClientstatement("Membership ID",0);
                end;
            }
            action("Institutional Account Statement")
            {
                Image = SalesTaxStatement;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    //ClientAdministration.ViewInstClientstatement("Membership ID");
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        toggleshow;
        calcage
    end;

    trigger OnOpenPage()
    begin
        toggleshow;
        calcage
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if "Client Type"="Client Type"::Individual then begin
          if  ("First Name"='') or
              (Surname='') or
              ("Date Of Birth"=0D) or
              ("Account Executive Code"='') or
              ("E-Mail"='') or
              (State='') or
              (Country='') or
              ("Phone Number"='') or
              ("BVN Number"='') or
              ("Bank Account Name"='') or
              ("Bank Account Number"='') or
              ("Mailing Address"='')
              then;
            /*IF NOT CONFIRM('There are some mandatory fields that you have not filled. Are you sure you want to exit?') THEN
              ERROR('');
          IF NOT ClientAdministration.CheckifNOKexists("Membership ID") THEN
           IF NOT CONFIRM('There is no Next of Kin specified. Are you sure you want to exit?') THEN
              ERROR('');*/
        end else if "Client Type"="Client Type"::Minor then begin
            if  ("First Name"='') or
              (Surname='') or
              ("Date Of Birth"=0D) or
              ("Account Executive Code"='') or
              ("E-Mail"='') or
              (State='') or
              (Country='') or
              ("Phone Number"='') or
              ("BVN Number"='') or
              ("Bank Account Name"='') or
              ("Bank Account Number"='') or
              ("Mailing Address"='')
              then;
            /*IF NOT CONFIRM('There are some mandatory fields that you have not filled. Are you sure you want to exit?') THEN
              ERROR('');
            IF NOT ClientAdministration.CheckifNOKexists("Membership ID") THEN
           IF NOT CONFIRM('There is no Next of Kin specified. Are you sure you want to exit?') THEN
              ERROR('');*/
        end else if   "Client Type"="Client Type"::Joint then begin
          if ClientAdministration.CheckifJointaccountExits("Membership ID") then
        
          if  ("First Name"='') or
            (Country='') or
             ("Mailing Address"='')
              then;
              /*
            IF NOT CONFIRM('There are some mandatory fields that you have not filled. Are you sure you want to exit?') THEN
              ERROR('');
        IF NOT ClientAdministration.CheckifJointaccountExits("Membership ID") THEN
           IF NOT CONFIRM('There are no Joint account holders specified. Are you sure you want to exit?') THEN
              ERROR('');*/
        end  else if   "Client Type"="Client Type"::Corporate then begin
          if  ("First Name"='') or
              ("Date Of Birth"=0D) or
              ("Account Executive Code"='') or
              ("E-Mail"='') or
              (State='') or
              ("Phone Number"='') or
              ("Bank Account Name"='') or
              ("Bank Account Number"='') or
              (Country='') or
              ("Mailing Address"='')
              then;
           /* IF NOT CONFIRM('There are some mandatory fields that you have not filled. Are you sure you want to exit?') THEN
              ERROR('');*/
        end ;
        /*IF NOT ClientAdministration.CheckifaccountExits("Membership ID") THEN
           IF NOT CONFIRM('There are no Client Accounts created. Are you sure you want to exit?') THEN
              ERROR('');
        IF NOT ClientAdministration.CheckifaccountExits("Membership ID") THEN
           IF NOT CONFIRM('There are no AODS uploaded. Are you sure you want to exit?') THEN
              ERROR('');
        */

    end;

    var
        ClientAdministration: Codeunit "Client Administration";
        Age: Text;
        Requestlevel: Option Client,Account;
        ShowJoint: Boolean;
        Showminor: Boolean;
        ShowGender: Boolean;
        ShowCompanyname: Boolean;
        showIndividualname: Boolean;
        CreateAccountDialog: Page "Create Account Dialog";
        ShowNok: Boolean;
        Showverify: Boolean;

    local procedure calcage()
    begin
        if "Date Of Birth"<>0D then
        Age:=Format(ClientAdministration.CalculateAge("Date Of Birth")) +' Years'
        else
         Age:= 'There is no Date of birth'
    end;

    local procedure toggleshow()
    begin
        if ("Client Type"="Client Type"::Individual) then begin
          ShowJoint:=false;
          Showminor:=false;
          ShowCompanyname:=false;
          showIndividualname:=true;
          ShowNok:=true;
        end else if  ("Client Type"="Client Type"::Minor) then begin
           ShowJoint:=false;
          Showminor:=true;
          ShowCompanyname:=false;
          showIndividualname:=true;
           ShowNok:=true;
        end else if  ("Client Type"="Client Type"::Joint) then begin
         ShowJoint:=true;
          Showminor:=false;
          ShowCompanyname:=false;
          showIndividualname:=false;
           ShowNok:=true;
        end else if  ("Client Type"="Client Type"::Corporate) then begin
          ShowJoint:=false;
          Showminor:=false;
          ShowCompanyname:=true;
          showIndividualname:=false;
           ShowNok:=false;
        end;

        if ("AOD Verified"="AOD Verified"::Created) or ("AOD Verified"="AOD Verified"::Rejected) then begin
          Showverify:=true
        end else
        Showverify:=false;
    end;
}

