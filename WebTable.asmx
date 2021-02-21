<%@ WebService Language="C#" Class="WebTable" %>

using System;
using System.Collections;
using System.ComponentModel;
using System.Data;
using System.Diagnostics;
using System.Web;
using System.Web.Services;
using System.IO;
using System.Xml;
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
// [System.Web.Script.Services.ScriptService]
public class WebTable : System.Web.Services.WebService
{
    public WebTable()
    {
        //
        // TODO: Add any constructor code required
        //
    }

    // WEB SERVICE EXAMPLE
    // The HelloWorld() example service returns the string Hello World.
    
    [WebMethod]
    public XmlDocument GetPages(int pageFrom,int pageTo,bool schema)
    {
        string result;
        using(BL bl=new BL())
        {
            try
            {
                DataTable tbl = bl.GetTablePages(pageFrom, pageTo);
                StringWriter sw = new StringWriter();
                if (schema)
                    tbl.WriteXml(sw, XmlWriteMode.WriteSchema);
                else
                    tbl.WriteXml(sw);
                result = sw.ToString();
            }catch(Exception ex)
            {
                result = $"<Error>{ex.Message}</Error>";
            }
        }
        XmlDocument doc = new XmlDocument();
        doc.LoadXml(result);
        return doc;
    }
    [WebMethod]
    public string AddCol(string name,string dataType,string length,string dflt)
    {
        string result;
        using(BL bl=new BL())
        {
            try
            {
                bl.AddColumn(name, dataType, length, dflt);
                result = "Column Added";
            }catch(Exception ex)
            {
                result = "Error:"+ex.Message;
            }
        }
        return result;
    }
}
