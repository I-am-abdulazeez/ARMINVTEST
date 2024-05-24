codeunit 5459 "JSON Management"
{
    // version NAVW113.02


    trigger OnRun()
    begin
    end;

    var
        JsonArray: DotNet JArray;
        JsonObject: DotNet JObject;
        IEnumerator: DotNet IEnumerator_Of_T;

    [Scope('Personalization')]
    procedure InitializeCollection(JSONString: Text)
    begin
        InitializeCollectionFromString(JSONString);
    end;

    [Scope('Personalization')]
    procedure InitializeEmptyCollection()
    begin
        JsonArray := JsonArray.JArray;
    end;

    [Scope('Personalization')]
    procedure InitializeObject(JSONString: Text)
    begin
        InitializeObjectFromString(JSONString);
    end;

    [Scope('Personalization')]
    procedure InitializeObjectFromJObject(NewJsonObject: DotNet JObject)
    begin
        JsonObject := NewJsonObject;
    end;

    [Scope('Personalization')]
    procedure InitializeCollectionFromJArray(NewJsonArray: DotNet JArray)
    begin
        JsonArray := NewJsonArray;
    end;

    [Scope('Personalization')]
    procedure InitializeEmptyObject()
    begin
        JsonObject := JsonObject.JObject;
    end;

    local procedure InitializeCollectionFromString(JSONString: Text)
    begin
        Clear(JsonArray);
        if JSONString <> '' then
          JsonArray := JsonArray.Parse(JSONString)
        else
          InitializeEmptyCollection;
    end;

    local procedure InitializeObjectFromString(JSONString: Text)
    begin
        Clear(JsonObject);
        if JSONString <> '' then
          JsonObject := JsonObject.Parse(JSONString)
        else
          InitializeEmptyObject;
    end;

    [Scope('Personalization')]
    procedure InitializeFromString(JSONString: Text): Boolean
    begin
        Clear(JsonObject);
        if JSONString <> '' then
          exit(TryParseJObjectFromString(JsonObject,JSONString));

        InitializeEmptyObject;
        exit(true);
    end;

    [Scope('Personalization')]
    procedure GetJSONObject(var JObject: DotNet JObject)
    begin
        JObject := JsonObject;
    end;

    [Scope('Personalization')]
    procedure GetJsonArray(var JArray: DotNet JArray)
    begin
        JArray := JsonArray;
    end;

    [Scope('Personalization')]
    procedure GetObjectFromCollectionByIndex(var "Object": Text;Index: Integer): Boolean
    var
        JObject: DotNet JObject;
    begin
        if not GetJObjectFromCollectionByIndex(JObject,Index) then
          exit(false);

        Object := JObject.ToString();
        exit(true);
    end;

    [Scope('Personalization')]
    procedure GetJObjectFromCollectionByIndex(var JObject: DotNet JObject;Index: Integer): Boolean
    begin
        if (GetCollectionCount = 0) or (GetCollectionCount <= Index) then
          exit(false);

        JObject := JsonArray.Item(Index);
        exit(not IsNull(JObject))
    end;

    [Scope('Personalization')]
    procedure GetJObjectFromCollectionByPropertyValue(var JObject: DotNet JObject;propertyName: Text;value: Text): Boolean
    var
        IEnumerable: DotNet IEnumerable_Of_T;
        IEnumerator: DotNet IEnumerator_Of_T;
    begin
        Clear(JObject);
        IEnumerable := JsonArray.SelectTokens(StrSubstNo('$[?(@.%1 == ''%2'')]',propertyName,value),false);
        IEnumerator := IEnumerable.GetEnumerator;

        if IEnumerator.MoveNext then begin
          JObject := IEnumerator.Current;
          exit(true);
        end;
    end;

    [Scope('Personalization')]
    procedure GetPropertyValueFromJObjectByName(JObject: DotNet JObject;propertyName: Text;var value: Variant): Boolean
    var
        JProperty: DotNet JProperty;
        JToken: DotNet JToken;
    begin
        Clear(value);
        if JObject.TryGetValue(propertyName,JToken) then begin
          JProperty := JObject.Property(propertyName);
          value := JProperty.Value;
          exit(true);
        end;
    end;

    [Scope('Personalization')]
    procedure GetPropertyValueByName(propertyName: Text;var value: Variant): Boolean
    begin
        exit(GetPropertyValueFromJObjectByName(JsonObject,propertyName,value));
    end;

    [Scope('Internal')]
    procedure GetPropertyValueFromJObjectByPathSetToFieldRef(JObject: DotNet JObject;propertyPath: Text;var FieldRef: FieldRef): Boolean
    var
        TempBlob: Record TempBlob;
        OutlookSynchTypeConv: Codeunit "Outlook Synch. Type Conv";
        JProperty: DotNet JProperty;
        Value: Variant;
        DecimalVal: Decimal;
        BoolVal: Boolean;
        GuidVal: Guid;
        DateVal: Date;
        Success: Boolean;
        IntVar: Integer;
    begin
        Success := false;
        JProperty := JObject.SelectToken(propertyPath);

        if IsNull(JProperty) then
          exit(false);

        Value := Format(JProperty.Value,0,9);

        case Format(FieldRef.Type) of
          'Integer',
          'Decimal':
            begin
              Success := Evaluate(DecimalVal,Value,9);
              FieldRef.Value(DecimalVal);
            end;
          'Date':
            begin
              Success := Evaluate(DateVal,Value,9);
              FieldRef.Value(DateVal);
            end;
          'Boolean':
            begin
              Success := Evaluate(BoolVal,Value,9);
              FieldRef.Value(BoolVal);
            end;
          'GUID':
            begin
              Success := Evaluate(GuidVal,Value);
              FieldRef.Value(GuidVal);
            end;
          'Text',
          'Code':
            begin
              FieldRef.Value(CopyStr(Value,1,FieldRef.Length));
              Success := true;
            end;
          'Option':
            begin
              if not Evaluate(IntVar,Value) then
                IntVar := OutlookSynchTypeConv.TextToOptionValue(Value,FieldRef.OptionCaption);
              if IntVar >= 0 then begin
                FieldRef.Value := IntVar;
                Success := true;
              end;
            end;
          'BLOB':
            if TryReadAsBase64(TempBlob,Value) then begin
              FieldRef.Value := TempBlob.Blob;
              Success := true;
            end;
        end;

        exit(Success);
    end;

    [Scope('Personalization')]
    procedure GetPropertyValueFromJObjectByPath(JObject: DotNet JObject;fullyQualifiedPropertyName: Text;var value: Variant): Boolean
    var
        containerJObject: DotNet JObject;
        propertyName: Text;
    begin
        Clear(value);
        DecomposeQualifiedPathToContainerObjectAndPropertyName(JObject,fullyQualifiedPropertyName,containerJObject,propertyName);
        if IsNull(containerJObject) then
          exit(false);

        exit(GetPropertyValueFromJObjectByName(containerJObject,propertyName,value));
    end;

    [Scope('Personalization')]
    procedure GetStringPropertyValueFromJObjectByName(JObject: DotNet JObject;propertyName: Text;var value: Text): Boolean
    var
        VariantValue: Variant;
    begin
        Clear(value);
        if GetPropertyValueFromJObjectByName(JObject,propertyName,VariantValue) then begin
          value := Format(VariantValue);
          exit(true);
        end;
        exit(false);
    end;

    [Scope('Personalization')]
    procedure GetStringPropertyValueByName(propertyName: Text;var value: Text): Boolean
    begin
        exit(GetStringPropertyValueFromJObjectByName(JsonObject,propertyName,value));
    end;

    [Scope('Personalization')]
    procedure GetStringPropertyValueFromJObjectByPath(JObject: DotNet JObject;fullyQualifiedPropertyName: Text;var value: Text): Boolean
    var
        VariantValue: Variant;
    begin
        Clear(value);
        if GetPropertyValueFromJObjectByPath(JObject,fullyQualifiedPropertyName,VariantValue) then begin
          value := Format(VariantValue);
          exit(true);
        end;
        exit(false);
    end;

    [Scope('Personalization')]
    procedure GetEnumPropertyValueFromJObjectByName(JObject: DotNet JObject;propertyName: Text;var value: Option)
    var
        StringValue: Text;
    begin
        GetStringPropertyValueFromJObjectByName(JObject,propertyName,StringValue);
        Evaluate(value,StringValue,0);
    end;

    [Scope('Personalization')]
    procedure GetBoolPropertyValueFromJObjectByName(JObject: DotNet JObject;propertyName: Text;var value: Boolean): Boolean
    var
        StringValue: Text;
    begin
        if GetStringPropertyValueFromJObjectByName(JObject,propertyName,StringValue) then begin
          Evaluate(value,StringValue,2);
          exit(true);
        end;
        exit(false);
    end;

    [Scope('Personalization')]
    procedure GetArrayPropertyValueFromJObjectByName(JObject: DotNet JObject;propertyName: Text;var JArray: DotNet JArray): Boolean
    var
        JProperty: DotNet JProperty;
        JToken: DotNet JToken;
    begin
        Clear(JArray);
        if JObject.TryGetValue(propertyName,JToken) then begin
          JProperty := JObject.Property(propertyName);
          JArray := JProperty.Value;
          exit(true);
        end;
        exit(false);
    end;

    [Scope('Personalization')]
    procedure GetArrayPropertyValueAsStringByName(propertyName: Text;var value: Text): Boolean
    var
        JArray: DotNet JArray;
    begin
        if not GetArrayPropertyValueFromJObjectByName(JsonObject,propertyName,JArray) then
          exit(false);

        value := JArray.ToString();
        exit(true);
    end;

    [Scope('Personalization')]
    procedure GetObjectPropertyValueFromJObjectByName(JObject: DotNet JObject;propertyName: Text;var JSubObject: DotNet JObject): Boolean
    var
        JProperty: DotNet JProperty;
        JToken: DotNet JToken;
    begin
        Clear(JSubObject);
        if JObject.TryGetValue(propertyName,JToken) then begin
          JProperty := JObject.Property(propertyName);
          JSubObject := JProperty.Value;
          exit(true);
        end;
        exit(false);
    end;

    [Scope('Personalization')]
    procedure GetDecimalPropertyValueFromJObjectByName(JObject: DotNet JObject;propertyName: Text;var value: Decimal): Boolean
    var
        StringValue: Text;
    begin
        if GetStringPropertyValueFromJObjectByName(JObject,propertyName,StringValue) then begin
          Evaluate(value,StringValue);
          exit(true);
        end;
        exit(false);
    end;

    [Scope('Personalization')]
    procedure GetGuidPropertyValueFromJObjectByName(JObject: DotNet JObject;propertyName: Text;var value: Guid): Boolean
    var
        StringValue: Text;
    begin
        if GetStringPropertyValueFromJObjectByName(JObject,propertyName,StringValue) then begin
          Evaluate(value,StringValue);
          exit(true);
        end;
        exit(false);
    end;

    local procedure GetValueFromJObject(JObject: DotNet JObject;var value: Variant)
    var
        JValue: DotNet JValue;
    begin
        Clear(value);
        JValue := JObject;
        value := JValue.Value;
    end;

    [Scope('Personalization')]
    procedure GetStringValueFromJObject(JObject: DotNet JObject;var value: Text)
    var
        VariantValue: Variant;
    begin
        Clear(value);
        GetValueFromJObject(JObject,VariantValue);
        value := Format(VariantValue);
    end;

    [Scope('Personalization')]
    procedure AddJArrayToJObject(var JObject: DotNet JObject;propertyName: Text;value: Variant)
    var
        JArray2: DotNet JArray;
        JProperty: DotNet JProperty;
    begin
        JArray2 := value;
        JObject.Add(JProperty.JProperty(propertyName,JArray2));
    end;

    [Scope('Personalization')]
    procedure AddJObjectToJObject(var JObject: DotNet JObject;propertyName: Text;value: Variant)
    var
        JObject2: DotNet JObject;
        JToken: DotNet JToken;
        ValueText: Text;
    begin
        JObject2 := value;
        ValueText := Format(value);
        JObject.Add(propertyName,JToken.Parse(ValueText));
    end;

    [Scope('Personalization')]
    procedure AddJObjectToJArray(var JArray: DotNet JArray;value: Variant)
    var
        JObject: DotNet JObject;
    begin
        JObject := value;
        JArray.Add(JObject.DeepClone);
    end;

    [Scope('Personalization')]
    procedure AddJPropertyToJObject(var JObject: DotNet JObject;propertyName: Text;value: Variant)
    var
        JObject2: DotNet JObject;
        JProperty: DotNet JProperty;
        ValueText: Text;
    begin
        case true of
          value.IsDotNet:
            begin
              JObject2 := value;
              JObject.Add(propertyName,JObject2);
            end;
          value.IsInteger,
          value.IsDecimal,
          value.IsBoolean:
            begin
              JProperty := JProperty.JProperty(propertyName,value);
              JObject.Add(JProperty);
            end;
          else begin
            ValueText := Format(value,0,9);
            JProperty := JProperty.JProperty(propertyName,ValueText);
            JObject.Add(JProperty);
          end;
        end;
    end;

    [Scope('Personalization')]
    procedure AddNullJPropertyToJObject(var JObject: DotNet JObject;propertyName: Text)
    var
        JValue: DotNet JValue;
    begin
        JObject.Add(propertyName,JValue.CreateNull);
    end;

    [Scope('Personalization')]
    procedure AddJValueToJObject(var JObject: DotNet JObject;value: Variant)
    var
        JValue: DotNet JValue;
    begin
        JObject := JValue.JValue(value);
    end;

    [Scope('Personalization')]
    procedure AddJObjectToCollection(JObject: DotNet JObject)
    begin
        JsonArray.Add(JObject.DeepClone);
    end;

    [Scope('Personalization')]
    procedure AddJArrayContentToCollection(JArray: DotNet JArray)
    begin
        JsonArray.Merge(JArray.DeepClone);
    end;

    [Scope('Personalization')]
    procedure ReplaceOrAddJPropertyInJObject(var JObject: DotNet JObject;propertyName: Text;value: Variant): Boolean
    var
        JProperty: DotNet JProperty;
        OldProperty: DotNet JProperty;
        oldValue: Variant;
    begin
        JProperty := JObject.Property(propertyName);
        if not IsNull(JProperty) then begin
          OldProperty := JObject.Property(propertyName);
          oldValue := OldProperty.Value;
          JProperty.Replace(JProperty.JProperty(propertyName,value));
          exit(Format(oldValue) <> Format(value));
        end;

        AddJPropertyToJObject(JObject,propertyName,value);
        exit(true);
    end;

    [Scope('Personalization')]
    procedure ReplaceOrAddDescendantJPropertyInJObject(var JObject: DotNet JObject;fullyQualifiedPropertyName: Text;value: Variant): Boolean
    var
        containerJObject: DotNet JObject;
        propertyName: Text;
    begin
        DecomposeQualifiedPathToContainerObjectAndPropertyName(JObject,fullyQualifiedPropertyName,containerJObject,propertyName);
        exit(ReplaceOrAddJPropertyInJObject(containerJObject,propertyName,value));
    end;

    [Scope('Personalization')]
    procedure GetCollectionCount(): Integer
    begin
        exit(JsonArray.Count);
    end;

    [Scope('Personalization')]
    procedure WriteCollectionToString(): Text
    begin
        exit(JsonArray.ToString);
    end;

    [Scope('Personalization')]
    procedure WriteObjectToString(): Text
    begin
        if not IsNull(JsonObject) then
          exit(JsonObject.ToString);
    end;

    [Scope('Personalization')]
    procedure FormatDecimalToJSONProperty(Value: Decimal;PropertyName: Text): Text
    var
        JProperty: DotNet JProperty;
    begin
        JProperty := JProperty.JProperty(PropertyName,Value);
        exit(JProperty.ToString);
    end;

    local procedure GetLastIndexOfPeriod(String: Text) LastIndex: Integer
    var
        Index: Integer;
    begin
        Index := StrPos(String,'.');
        LastIndex := Index;
        while Index > 0 do begin
          String := CopyStr(String,Index + 1);
          Index := StrPos(String,'.');
          LastIndex += Index;
        end;
    end;

    local procedure GetSubstringToLastPeriod(String: Text): Text
    var
        Index: Integer;
    begin
        Index := GetLastIndexOfPeriod(String);
        if Index > 0 then
          exit(CopyStr(String,1,Index - 1));
    end;

    local procedure DecomposeQualifiedPathToContainerObjectAndPropertyName(var JObject: DotNet JObject;fullyQualifiedPropertyName: Text;var containerJObject: DotNet JObject;var propertyName: Text)
    var
        containerJToken: DotNet JToken;
        containingPath: Text;
    begin
        Clear(containerJObject);
        propertyName := '';

        containingPath := GetSubstringToLastPeriod(fullyQualifiedPropertyName);
        containerJToken := JObject.SelectToken(containingPath);
        if IsNull(containerJToken) then begin
          DecomposeQualifiedPathToContainerObjectAndPropertyName(JObject,containingPath,containerJObject,propertyName);
          containerJObject.Add(propertyName,JObject.JObject);
          containerJToken := JObject.SelectToken(containingPath);
        end;

        containerJObject := containerJToken;
        if containingPath <> '' then
          propertyName := CopyStr(fullyQualifiedPropertyName,StrLen(containingPath) + 2)
        else
          propertyName := fullyQualifiedPropertyName;
    end;

    [Scope('Personalization')]
    procedure XMLTextToJSONText(Xml: Text) Json: Text
    var
        XMLDOMMgt: Codeunit "XML DOM Management";
        JsonConvert: DotNet JsonConvert;
        JsonFormatting: DotNet Formatting;
        XmlDocument: DotNet XmlDocument;
    begin
        XMLDOMMgt.LoadXMLDocumentFromText(Xml,XmlDocument);
        Json := JsonConvert.SerializeXmlNode(XmlDocument.DocumentElement,JsonFormatting.Indented,true);
    end;

    [Scope('Personalization')]
    procedure JSONTextToXMLText(Json: Text;DocumentElementName: Text) Xml: Text
    var
        JsonConvert: DotNet JsonConvert;
        XmlDocument: DotNet XmlDocument;
    begin
        XmlDocument := JsonConvert.DeserializeXmlNode(Json,DocumentElementName);
        Xml := XmlDocument.OuterXml;
    end;

    [TryFunction]
    [Scope('Personalization')]
    procedure TryParseJObjectFromString(var JObject: DotNet JObject;StringToParse: Variant)
    begin
        JObject := JObject.Parse(Format(StringToParse));
    end;

    [TryFunction]
    [Scope('Personalization')]
    procedure TryParseJArrayFromString(var JsonArray: DotNet JArray;StringToParse: Variant)
    begin
        JsonArray := JsonArray.Parse(Format(StringToParse));
    end;

    [TryFunction]
    local procedure TryReadAsBase64(var TempBlob: Record TempBlob;Value: Text)
    begin
        TempBlob.FromBase64String(Value);
    end;

    [Scope('Personalization')]
    procedure SetValue(Path: Text;Value: Variant)
    begin
        if IsNull(JsonObject) then
          InitializeEmptyObject;
        ReplaceOrAddDescendantJPropertyInJObject(JsonObject,Path,Value);
    end;

    [Scope('Personalization')]
    procedure GetValue(Path: Text): Text
    var
        SelectedJToken: DotNet JToken;
    begin
        if IsNull(JsonObject) then
          exit('');

        SelectedJToken := JsonObject.SelectToken(Path);
        if not IsNull(SelectedJToken) then
          exit(SelectedJToken.ToString);
    end;

    [Scope('Personalization')]
    procedure GetValueAndSetToRecFieldNo(RecordRef: RecordRef;PropertyPath: Text;FieldNo: Integer): Boolean
    var
        FieldRef: FieldRef;
    begin
        if IsNull(JsonObject) then
          exit(false);

        FieldRef := RecordRef.Field(FieldNo);
        exit(GetPropertyValueFromJObjectByPathSetToFieldRef(JsonObject,PropertyPath,FieldRef));
    end;

    [Scope('Personalization')]
    procedure HasValue(Name: Text;Value: Text): Boolean
    begin
        if not IsNull(JsonObject) then
          exit(StrPos(GetValue(Name),Value) = 1);
    end;

    [Scope('Personalization')]
    procedure AddArrayValue(Value: Variant)
    begin
        if IsNull(JsonArray) then
          InitializeEmptyCollection;
        JsonArray.Add(Value);
    end;

    [Scope('Personalization')]
    procedure AddJson(Path: Text;JsonString: Text)
    var
        JObject: DotNet JObject;
    begin
        if JsonString <> '' then
          if TryParseJObjectFromString(JObject,JsonString) then
            SetValue(Path,JObject);
    end;

    [Scope('Personalization')]
    procedure AddJsonArray(Path: Text;JsonArrayString: Text)
    var
        JsonArrayLocal: DotNet JArray;
    begin
        if JsonArrayString <> '' then
          if TryParseJArrayFromString(JsonArrayLocal,JsonArrayString) then
            SetValue(Path,JsonArrayLocal);
    end;

    [Scope('Personalization')]
    procedure SelectTokenFromRoot(Path: Text): Boolean
    begin
        if IsNull(JsonObject) then
          exit(false);

        JsonObject := JsonObject.Root;
        JsonObject := JsonObject.SelectToken(Path);
        exit(not IsNull(JsonObject));
    end;

    [Scope('Personalization')]
    procedure ReadProperties(): Boolean
    var
        IEnumerable: DotNet IEnumerable_Of_T;
    begin
        if not JsonObject.HasValues then
          exit(false);

        IEnumerable := JsonObject.Properties;
        IEnumerator := IEnumerable.GetEnumerator;
        exit(true);
    end;

    [Scope('Personalization')]
    procedure GetNextProperty(var Name: Text;var Value: Text): Boolean
    var
        JProperty: DotNet JProperty;
    begin
        Name := '';
        Value := '';

        if not IEnumerator.MoveNext then
          exit(false);

        JProperty := IEnumerator.Current;
        if IsNull(JProperty) then
          exit(false);

        Name := JProperty.Name;
        Value := Format(JProperty.Value);
        exit(true);
    end;

    [Scope('Personalization')]
    procedure SelectItemFromRoot(Path: Text;Index: Integer): Boolean
    begin
        if SelectTokenFromRoot(Path) then
          JsonObject := JsonObject.Item(Index);
        exit(not IsNull(JsonObject));
    end;

    [Scope('Personalization')]
    procedure GetCount(): Integer
    begin
        if not IsNull(JsonObject) then
          exit(JsonObject.Count);
    end;

    [Scope('Personalization')]
    procedure SetJsonWebResponseError(var JsonString: Text;"code": Text;name: Text;description: Text)
    begin
        if InitializeFromString(JsonString) then begin
          SetValue('Error.code',code);
          SetValue('Error.name',name);
          SetValue('Error.description',description);
          JsonString := WriteObjectToString;
        end;
    end;

    [Scope('Personalization')]
    procedure GetJsonWebResponseError(JsonString: Text;var "code": Text;var name: Text;var description: Text): Boolean
    begin
        if InitializeFromString(JsonString) then begin
          code := GetValue('Error.code');
          name := GetValue('Error.name');
          description := GetValue('Error.description');
          exit(true);
        end;

        exit(false);
    end;
}

