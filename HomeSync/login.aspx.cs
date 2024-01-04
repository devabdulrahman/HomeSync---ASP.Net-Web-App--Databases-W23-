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
    public partial class login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void Login(object sender, EventArgs e)
        {
            //take connection string from configurations
            string connStr = WebConfigurationManager.ConnectionStrings["Project"].ToString();
            //create a new connection
            SqlConnection conn = new SqlConnection(connStr);
            //takings inputs from the html
            int id = Int16.Parse(EmployeeID.Text);
            String fname = Emp_fname.Text;
            //intiate the procedure and give it the inputs
            SqlCommand loginProc = new SqlCommand("login", conn);
            loginProc.CommandType = CommandType.StoredProcedure;
            loginProc.Parameters.Add(new SqlParameter("@id", id));
            loginProc.Parameters.Add(new SqlParameter("@first_name", fname));
            //getting the output of the procedure
            SqlParameter success = loginProc.Parameters.Add("@success", SqlDbType.Int);
            success.Direction = ParameterDirection.Output;

            conn.Open();
            loginProc.ExecuteNonQuery();
            conn.Close();

            if (success.Value.ToString()== "1") {
                Response.Write("welcome");
                Session["user"] = id;
            }
            else
                Response.Write("does not exist");
                Response.Redirect("ViewEmployees.aspx");
        }
    }
}