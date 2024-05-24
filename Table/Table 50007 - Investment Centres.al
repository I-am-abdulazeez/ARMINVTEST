table 50007 "Investment Centres"
{

    fields
    {
        field(1;"Code";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2;Name;Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(3;State;Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(4;Address;Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(5;Manager;Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee;

            trigger OnValidate()
            begin
                Employee.Get(Manager);
                Manager:=Employee.FullName;
            end;
        }
        field(6;"Manager Name";Text[200])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(7;Email;Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(8;"Phone Number";Code[100])
        {
            DataClassification = ToBeClassified;
        }
        field(200;"Last Modified By";Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = User;
        }
        field(201;"Last Modified DateTime";DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }

    keys
    {
        key(Key1;"Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnModify()
    begin
        "Last Modified By":=UserId;
        "Last Modified DateTime":=CurrentDateTime;
    end;

    var
        Employee: Record Employee;
}

