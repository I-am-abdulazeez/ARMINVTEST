dotnet
{
    assembly("mscorlib")
    {
        Version='4.0.0.0';
        Culture='neutral';
        PublicKeyToken='b77a5c561934e089';

        type("System.Convert";"Convert"){}
        type("System.Text.Encoding";"Encoding"){}
    }

    assembly("System.Xml.Linq")
    {
        Version='4.0.0.0';
        Culture='neutral';
        PublicKeyToken='b77a5c561934e089';

        type("System.Xml.Linq.XDocument";"XDocument"){}
    }

}
