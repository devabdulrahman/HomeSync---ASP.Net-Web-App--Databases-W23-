using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication1
{
    public partial class ViewEmployees : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            //take connection string from configurations
           
            string connStr = WebConfigurationManager.ConnectionStrings["Project"].ToString();
            //create a new connection
            SqlConnection conn = new SqlConnection(connStr);
            //intiate the procedure 
            SqlCommand AllEmployees = new SqlCommand("ViewEmployee", conn);
            AllEmployees.CommandType = CommandType.StoredProcedure;
            //open connection
            conn.Open();
            //execute the procedure
            SqlDataReader rdr = AllEmployees.ExecuteReader(CommandBehavior.CloseConnection);
            while (rdr.Read())
            {
                String EmployeeN= rdr.GetString(rdr.GetOrdinal("username"));
                //String EmployeefName = rdr.GetString(rdr.GetOrdinal("first_name"));
                //String EmployeemName = rdr.GetString(rdr.GetOrdinal("middle_name"));
                String EmployeeName = EmployeeN + ",\n";
                //creating a lable to put the names in it 
                Label l = new Label();
                l.Text = EmployeeName+",\n";
                //add lable to the form of this page
                form1.Controls.Add(l);
            }
            Response.Write(Session["user"]);
        }
    }
}