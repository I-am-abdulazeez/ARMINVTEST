dotnet
{
    assembly("mscorlib")
    {
        type("System.Char";"Char"){}
        type("System.Globalization.CultureInfo";"CultureInfo"){}
        type("System.Type";"Type"){}
        type("System.Text.StringBuilder";"StringBuilder"){}
        type("System.IO.FileMode";"FileMode"){}
        type("System.Text.Encoding";"Encoding"){}
        type("System.Collections.IEnumerator";"IEnumerator"){}
        type("System.IO.Path";"Path"){}
        type("System.DateTime";"DateTime"){}
        type("System.DateTimeKind";"DateTimeKind"){}
        type("System.Collections.ArrayList";"ArrayList"){}
        type("System.Convert";"Convert"){}
        type("System.IO.File";"File"){}
        type("System.IO.StreamReader";"StreamReader"){}
        type("System.IO.StreamWriter";"StreamWriter"){}
        type("System.String";"String"){}
        type("System.Globalization.DateTimeStyles";"DateTimeStyles"){}
        type("System.Array";"Array"){}
        type("System.IO.StringReader";"StringReader"){}
        type("System.TimeZoneInfo";"TimeZoneInfo"){}
        type("System.Collections.Queue";"Queue"){}
        type("System.Version";"Version"){}
        type("System.Collections.Generic.IEnumerator`1";"IEnumerator_Of_T"){}
        type("System.Security.Cryptography.SHA512Managed";"SHA512Managed"){}
        type("System.IO.MemoryStream";"MemoryStream"){}
        type("System.Environment";"Environment"){}
    }

    assembly("System.Xml")
    {
        Version='4.0.0.0';
        Culture='neutral';
        PublicKeyToken='b77a5c561934e089';

        type("System.Xml.XmlNode";"XmlNode"){}
        type("System.Xml.XmlNamespaceManager";"XmlNamespaceManager"){}
        type("System.Xml.XmlDocument";"XmlDocument"){}
        type("System.Xml.XmlElement";"XmlElement"){}
        type("System.Xml.XmlTextWriter";"XmlTextWriter"){}
    }

    assembly("System")
    {
        Version='4.0.0.0';
        Culture='neutral';
        PublicKeyToken='b77a5c561934e089';

        type("System.Net.HttpStatusCode";"HttpStatusCode"){}
        type("System.Collections.Specialized.NameValueCollection";"NameValueCollection"){}
        type("System.Text.RegularExpressions.Regex";"Regex"){}
        type("System.Text.RegularExpressions.RegexOptions";"RegexOptions"){}
        type("System.Text.RegularExpressions.MatchCollection";"MatchCollection"){}
        type("System.Text.RegularExpressions.Match";"Match"){}
        type("System.Text.RegularExpressions.Group";"Group"){}
        type("System.Text.RegularExpressions.Capture";"Capture"){}
        type("System.Net.WebClient";"WebClient"){}
        type("System.Net.NetworkCredential";"NetworkCredential"){}
    }

    assembly("Newtonsoft.Json")
    {
        type("Newtonsoft.Json.Linq.JObject";"JObject"){}
        type("Newtonsoft.Json.JsonTextReader";"JsonTextReader"){}
    }

    assembly("Microsoft.Dynamics.Nav.Client.BusinessChart.Model")
    {
        Version='13.0.0.0';
        Culture='neutral';
        PublicKeyToken='31bf3856ad364e35';

        type("Microsoft.Dynamics.Nav.Client.BusinessChart.BusinessChartData";"BusinessChartData"){}
        type("Microsoft.Dynamics.Nav.Client.BusinessChart.DataMeasureType";"DataMeasureType"){}
        type("Microsoft.Dynamics.Nav.Client.BusinessChart.BusinessChartDataPoint";"BusinessChartDataPoint"){}
    }

    assembly("System.Data")
    {
        Version='4.0.0.0';
        Culture='neutral';
        PublicKeyToken='b77a5c561934e089';

        type("System.Data.DataTable";"DataTable"){}
        type("System.Data.DataRow";"DataRow"){}
        type("System.Data.DataColumn";"DataColumn"){}
    }

    assembly("Microsoft.Dynamics.Nav.Client.BusinessChart")
    {
        Version='13.0.0.0';
        Culture='neutral';
        PublicKeyToken='31bf3856ad364e35';

        type("Microsoft.Dynamics.Nav.Client.BusinessChart.BusinessChartAddIn";"BusinessChartAddIn"){}
    }

    assembly("Microsoft.Dynamics.Nav.OpenXml")
    {
        Version='13.0.0.0';
        Culture='neutral';
        PublicKeyToken='31bf3856ad364e35';

        type("Microsoft.Dynamics.Nav.OpenXml.Spreadsheet.WorkbookWriter";"WorkbookWriter"){}
        type("Microsoft.Dynamics.Nav.OpenXml.Spreadsheet.WorkbookReader";"WorkbookReader"){}
        type("Microsoft.Dynamics.Nav.OpenXml.Spreadsheet.WorksheetWriter";"WorksheetWriter"){}
        type("Microsoft.Dynamics.Nav.OpenXml.Spreadsheet.WorksheetReader";"WorksheetReader"){}
        type("Microsoft.Dynamics.Nav.OpenXml.Spreadsheet.CellDecorator";"CellDecorator"){}
        type("Microsoft.Dynamics.Nav.OpenXml.Spreadsheet.CellData";"CellData"){}
    }

    assembly("DocumentFormat.OpenXml")
    {
        Version='2.5.5631.0';
        Culture='neutral';
        PublicKeyToken='31bf3856ad364e35';

        type("DocumentFormat.OpenXml.Spreadsheet.OrientationValues";"OrientationValues"){}
        type("DocumentFormat.OpenXml.Packaging.VmlDrawingPart";"VmlDrawingPart"){}
    }

    assembly("Microsoft.Dynamics.Nav.ClientExtensions")
    {
        Version='13.0.0.0';
        Culture='neutral';
        PublicKeyToken='31bf3856ad364e35';

        type("Microsoft.Dynamics.Nav.Client.Hosts.OutlookCommand";"OutlookCommand"){}
    }

    assembly("System.Drawing")
    {
        Version='4.0.0.0';
        Culture='neutral';
        PublicKeyToken='b03f5f7f11d50a3a';

        type("System.Drawing.Bitmap";"Bitmap"){}
        type("System.Drawing.Graphics";"Graphics"){}
        type("System.Drawing.Color";"Color"){}
        type("System.Drawing.ColorTranslator";"ColorTranslator"){}
        type("System.Drawing.SolidBrush";"SolidBrush"){}
        type("System.Drawing.Imaging.ImageFormat";"ImageFormat"){}
        type("System.Drawing.Image";"Image"){}
        type("System.Drawing.ImageFormatConverter";"ImageFormatConverter"){}
    }

    assembly("Microsoft.Dynamics.Nav.EwsWrapper")
    {
        Version='13.0.0.0';
        Culture='neutral';
        PublicKeyToken='31bf3856ad364e35';

        type("Microsoft.Dynamics.Nav.Exchange.IAppointment";"IAppointment"){}
    }

    assembly("Microsoft.Exchange.WebServices")
    {
        Version='15.0.0.0';
        Culture='neutral';
        PublicKeyToken='31bf3856ad364e35';

        type("Microsoft.Exchange.WebServices.Data.WebCredentials";"WebCredentials"){}
    }

    assembly("Microsoft.Dynamics.Nav.Integration.Office")
    {
        Version='13.0.0.0';
        Culture='neutral';
        PublicKeyToken='31bf3856ad364e35';

        type("Microsoft.Dynamics.Nav.Integration.Office.Outlook.OutlookHelper";"OutlookHelper"){}
        type("Microsoft.Dynamics.Nav.Integration.Office.Outlook.OutlookStatusCode";"OutlookStatusCode"){}
    }

    assembly("Microsoft.Dynamics.Nav.CrmCustomizationHelper")
    {
        Version='13.0.0.0';
        Culture='neutral';
        PublicKeyToken='31bf3856ad364e35';

        type("Microsoft.Dynamics.Nav.CrmCustomizationHelper.CrmHelper";"CrmHelper"){}
    }

    assembly("Microsoft.Dynamics.Framework.UI.WinForms.DataVisualization.Timeline")
    {
        Version='13.0.0.0';
        Culture='neutral';
        PublicKeyToken='31bf3856ad364e35';

        type("Microsoft.Dynamics.Framework.UI.WinForms.DataVisualization.TimelineVisualization.DataModel+TransactionDataTable";"DataModel_TransactionDataTable"){}
        type("Microsoft.Dynamics.Framework.UI.WinForms.DataVisualization.TimelineVisualization.DataModel+TransactionRow";"DataModel_TransactionRow"){}
        type("Microsoft.Dynamics.Framework.UI.WinForms.DataVisualization.TimelineVisualization.DataModel+TransactionChangesDataTable";"DataModel_TransactionChangesDataTable"){}
        type("Microsoft.Dynamics.Framework.UI.WinForms.DataVisualization.TimelineVisualization.DataModel+TransactionChangesRow";"DataModel_TransactionChangesRow"){}
    }

    assembly("Microsoft.Dynamics.Nav.DocumentReport")
    {
        Version='13.0.0.0';
        Culture='neutral';
        PublicKeyToken='31bf3856ad364e35';

        type("Microsoft.Dynamics.Nav.DocumentReport.ReportUpgradeSet";"ReportUpgradeSet"){}
        type("Microsoft.Dynamics.Nav.DocumentReport.RdlcReportManager";"RdlcReportManager"){}
    }

    assembly("Microsoft.Dynamics.Nav.Types.Report")
    {
        Version='13.0.0.0';
        Culture='neutral';
        PublicKeyToken='31bf3856ad364e35';

        type("Microsoft.Dynamics.Nav.Types.Report.IReportChangeLogCollection";"IReportChangeLogCollection"){}
    }

}
