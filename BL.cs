using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Text;

/// <summary>
/// Summary description for Class1
/// </summary>
public class BL:IDisposable
{
	SqlConnection con;
	const int PAGE_SIZE= 100;
	public BL()
	{
		openConn();
	}
	void openConn()
    {
		string strConn=ConfigurationManager.ConnectionStrings["TableConn"].ConnectionString;
		con = new SqlConnection(strConn);
		con.Open();
    }
	void closeConn()
    {
		con.Close();
    }

    public void Dispose()
    {
		closeConn();
    }

	public int AddColumn(string name, string dataType, string length, string dflt)
    {
		StringBuilder sb = new StringBuilder();
		sb.Append("ALTER TABLE promotions ");
		sb.AppendFormat("ADD {0} {1}",name,dataType);
		if (length != "0")
			sb.AppendFormat("({0})", length);
		sb.Append(" NOT NULL");

		sb.AppendFormat(" CONSTRAINT dflt_promotions_{0} DEFAULT('{1}') WITH VALUES",name, dflt);

		SqlCommand cmd = new SqlCommand(sb.ToString(), con);
		
		return cmd.ExecuteNonQuery(); 
	}
	public DataTable GetTablePages(int pageFrom,int pageTo)
    {
		DataTable tbl = new DataTable { TableName = "Row" };
		SqlDataAdapter adapter= new SqlDataAdapter("select * from promotions", con);
		adapter.Fill(PAGE_SIZE*(pageFrom),PAGE_SIZE*(pageTo-pageFrom+1),tbl);
		return tbl;
    }
	public DataTable GetDataTypes()
	{
		DataTable tbl = new DataTable { TableName = "Type" };
		SqlCommand cmd = new SqlCommand("usp_getDataTypes", con);
		cmd.CommandType = CommandType.StoredProcedure;
		SqlDataAdapter adapter = new SqlDataAdapter(cmd);
		adapter.Fill(tbl);
		return tbl;
	}
}
