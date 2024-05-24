dotnet
{
    assembly("Microsoft.Dynamics.Nav.ClientExtensions")
    {
        Version='13.0.0.0';
        Culture='neutral';
        PublicKeyToken='31bf3856ad364e35';

        type("Microsoft.Dynamics.Nav.Client.Capabilities.CameraOptions";"CameraOptions"){}
        type("Microsoft.Dynamics.Nav.Client.Capabilities.CameraProvider";"CameraProvider"){}
        type("Microsoft.Dynamics.Nav.Client.Capabilities.LocationProvider";"LocationProvider"){}
        type("Microsoft.Dynamics.Nav.Client.Capabilities.Location";"Location"){}
        type("Microsoft.Dynamics.Nav.Client.Capabilities.UserTours";"UserTours"){}
        type("Microsoft.Dynamics.Nav.Client.PageNotifier";"PageNotifier"){}
        type("Microsoft.Dynamics.Nav.Client.Capabilities.DeviceContactProvider";"DeviceContactProvider"){}
        type("Microsoft.Dynamics.Nav.Client.Capabilities.DeviceContact";"DeviceContact"){}
        type("Microsoft.Dynamics.Nav.Client.Hosts.OfficeHost";"OfficeHost"){}
    }

    assembly("Microsoft.Dynamics.Nav.Client.BusinessChart.Model")
    {
        Version='13.0.0.0';
        Culture='neutral';
        PublicKeyToken='31bf3856ad364e35';

        type("Microsoft.Dynamics.Nav.Client.BusinessChart.BusinessChartDataPoint";"BusinessChartDataPoint"){}
        type("Microsoft.Dynamics.Nav.Client.BusinessChart.QueryFields";"QueryFields"){}
        type("Microsoft.Dynamics.Nav.Client.BusinessChart.QueryMetadataReader";"QueryMetadataReader"){}
        type("Microsoft.Dynamics.Nav.Client.BusinessChart.BusinessChartBuilder";"BusinessChartBuilder"){}
        type("Microsoft.Dynamics.Nav.Client.BusinessChart.BusinessChartData";"BusinessChartData"){}
    }

    assembly("Microsoft.Dynamics.Nav.Ncl")
    {
        Version='13.0.0.0';
        Culture='neutral';
        PublicKeyToken='31bf3856ad364e35';

        type("Microsoft.Dynamics.Nav.Runtime.WebServiceActionContext";"WebServiceActionContext"){}
        type("Microsoft.Dynamics.Nav.Runtime.Designer.DesignerFieldProperty";"DesignerFieldProperty"){}
        type("Microsoft.Dynamics.Nav.Runtime.Designer.DesignerFieldType";"DesignerFieldType"){}
        type("Microsoft.Dynamics.Nav.Runtime.Designer.NavDesignerALFunctions";"NavDesignerALFunctions"){}
    }

    assembly("System")
    {
        Version='4.0.0.0';
        Culture='neutral';
        PublicKeyToken='b77a5c561934e089';

        type("System.Text.RegularExpressions.Regex";"Regex"){}
        type("System.Text.RegularExpressions.Match";"Match"){}
        type("System.Net.WebException";"WebException"){}
        type("System.Uri";"Uri"){}
        type("System.Net.NetworkCredential";"NetworkCredential"){}
        type("System.Text.RegularExpressions.GroupCollection";"GroupCollection"){}
        type("System.Text.RegularExpressions.Group";"Group"){}
        type("System.Text.RegularExpressions.RegexOptions";"RegexOptions"){}
    }

    assembly("System.Xml")
    {
        Version='4.0.0.0';
        Culture='neutral';
        PublicKeyToken='b77a5c561934e089';

        type("System.Xml.XmlNode";"XmlNode"){}
        type("System.Xml.XmlDocument";"XmlDocument"){}
        type("System.Xml.XmlNodeList";"XmlNodeList"){}
        type("System.Xml.XmlAttribute";"XmlAttribute"){}
        type("System.Xml.XmlAttributeCollection";"XmlAttributeCollection"){}
    }

    assembly("mscorlib")
    {
        Version='4.0.0.0';
        Culture='neutral';
        PublicKeyToken='b77a5c561934e089';

        type("System.Convert";"Convert"){}
        type("System.IO.MemoryStream";"MemoryStream"){}
        type("System.IO.File";"File"){}
        type("System.Globalization.CultureInfo";"CultureInfo"){}
        type("System.TimeSpan";"TimeSpan"){}
        type("System.Collections.Generic.Dictionary`2";"Dictionary_Of_T_U"){}
        type("System.Collections.Generic.KeyValuePair`2";"KeyValuePair_Of_T_U"){}
        type("System.Collections.Generic.List`1";"List_Of_T"){}
        type("System.Collections.IEnumerator";"IEnumerator"){}
        type("System.Text.UTF8Encoding";"UTF8Encoding"){}
        type("System.Type";"Type"){}
        type("System.String";"String"){}
    }

    assembly("Microsoft.Dynamics.Framework.UI.WinForms.DataVisualization.Timeline")
    {
        Version='13.0.0.0';
        Culture='neutral';
        PublicKeyToken='31bf3856ad364e35';

        type("Microsoft.Dynamics.Framework.UI.WinForms.DataVisualization.TimelineVisualization.DataModel+TransactionDataTable";"DataModel_TransactionDataTable"){}
        type("Microsoft.Dynamics.Framework.UI.WinForms.DataVisualization.TimelineVisualization.DataModel+TransactionChangesDataTable";"DataModel_TransactionChangesDataTable"){}
    }

    assembly("Microsoft.Dynamics.Nav.Client.TimelineVisualization")
    {
        Version='13.0.0.0';
        Culture='neutral';
        PublicKeyToken='31bf3856ad364e35';

        type("Microsoft.Dynamics.Nav.Client.TimelineVisualization.VisualizationScenarios";"VisualizationScenarios"){}
    }

    assembly("Newtonsoft.Json")
    {
        type("Newtonsoft.Json.Linq.JObject";"JObject"){}
    }

    assembly("System.Web")
    {
        Version='4.0.0.0';
        Culture='neutral';
        PublicKeyToken='b03f5f7f11d50a3a';

        type("System.Web.HttpUtility";"HttpUtility"){}
    }

    assembly("Microsoft.Dynamics.Nav.Management.DSObjectPickerWrapper")
    {
        Version='13.0.0.0';
        Culture='neutral';
        PublicKeyToken='31bf3856ad364e35';

        type("Microsoft.Dynamics.Nav.Management.DSObjectPicker.DSObjectPickerWrapper";"DSObjectPickerWrapper"){}
    }

    assembly("System.Data")
    {
        Version='2.0.0.0';
        Culture='neutral';
        PublicKeyToken='b77a5c561934e089';

        type("System.Data.DataTable";"DataTable"){}
        type("System.Data.DataRow";"DataRow"){}
    }

    assembly("Microsoft.Dynamics.Nav.NavUserAccount")
    {
        Version='13.0.0.0';
        Culture='neutral';
        PublicKeyToken='31bf3856ad364e35';

        type("Microsoft.Dynamics.Nav.NavUserAccount.NavUserAccountHelper";"NavUserAccountHelper"){}
    }

    assembly("Microsoft.Dynamics.Nav.LicensingService.Model")
    {
        Culture='neutral';
        PublicKeyToken='31bf3856ad364e35';

        type("Microsoft.Dynamics.Nav.LicensingService.Model.UserInfo";"UserInfo"){}
    }

    assembly("Microsoft.Dynamics.Nav.AzureADGraphClient")
    {
        Culture='neutral';
        PublicKeyToken='31bf3856ad364e35';

        type("Microsoft.Dynamics.Nav.AzureADGraphClient.GraphQuery";"GraphQuery"){}
    }

    assembly("Microsoft.Dynamics.Nav.Client.CodeViewerTypes")
    {
        Version='13.0.0.0';
        Culture='neutral';
        PublicKeyToken='31bf3856ad364e35';

        type("Microsoft.Dynamics.Nav.Client.CodeViewerTypes.BreakpointCollection";"BreakpointCollection"){}
        type("Microsoft.Dynamics.Nav.Client.CodeViewerTypes.VariableCollection";"VariableCollection"){}
    }

}
