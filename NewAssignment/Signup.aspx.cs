using System;
using System.Configuration;
using System.Data.SqlClient;

namespace WebApplication7
{
    public partial class Signup : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string plan = Request.QueryString["plan"];

                if (!string.IsNullOrEmpty(plan))
                {
                    plan = plan.ToLower();

                    if (plan == "premium")
                    {
                        lblSelectedPlan.Text = "PREMIUM";
                        lblSelectedPlan.CssClass += " bg-red-100 text-red-600 border border-red-300";
                    }
                    else if (plan == "pro")
                    {
                        lblSelectedPlan.Text = "PRO";

                        // FULL GOLD BADGE LOOK
                        lblSelectedPlan.CssClass += " px-4 py-1 rounded-full font-bold " +
                            " text-yellow-400 border-2 border-yellow-400 " +
                            " drop-shadow-[0_0_6px_rgba(255,215,0,0.6)]";
                    }

                    else
                    {
                        lblSelectedPlan.Visible = false;
                    }
                }
                else
                {
                    lblSelectedPlan.Visible = false;
                }
            }
        }


        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            string cs = ConfigurationManager.ConnectionStrings["ValoProDB"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                // 1️⃣ CHECK DUPLICATE EMAIL OR USERNAME
                string checkQuery = @"
            SELECT COUNT(*) 
            FROM PendingUsers 
            WHERE Email = @e OR Username = @u";

                using (SqlCommand check = new SqlCommand(checkQuery, con))
                {
                    check.Parameters.AddWithValue("@e", txtEmail.Text.Trim());
                    check.Parameters.AddWithValue("@u", txtUsername.Text.Trim());

                    con.Open();
                    int exists = (int)check.ExecuteScalar();
                    con.Close();

                    if (exists > 0)
                    {
                        lblError.Text = "This username or email is already registered and pending approval.";
                        lblError.Visible = true;
                        return;
                    }
                }

                // 2️⃣ INSERT NEW RECORD
                string query = @"
            INSERT INTO PendingUsers
            (Username, Email, PasswordHash, FirstName, LastName, RequestedRole)
            VALUES (@u, @e, @p, @f, @l, @r)";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@u", txtUsername.Text.Trim());
                    cmd.Parameters.AddWithValue("@e", txtEmail.Text.Trim());
                    cmd.Parameters.AddWithValue("@p", txtPassword.Text.Trim());
                    cmd.Parameters.AddWithValue("@f", txtFirstName.Text.Trim());
                    cmd.Parameters.AddWithValue("@l", txtLastName.Text.Trim());
                    cmd.Parameters.AddWithValue("@r", ddlRole.SelectedValue);

                    con.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            Response.Redirect("RegistrationSubmitted.aspx");
        }

    }
}
