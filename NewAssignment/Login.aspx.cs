using System;
using System.Configuration;
using System.Data.SqlClient;

namespace WebApplication7
{
    public partial class Login : System.Web.UI.Page
    {
        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string cs = ConfigurationManager.ConnectionStrings["ValoProDB"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                string query = @"SELECT UserID, Username, Email, PasswordHash, Role 
                                 FROM Users 
                                 WHERE (Username = @u OR Email = @u) 
                                 AND PasswordHash = @p 
                                 AND IsActive = 1";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@u", txtUsername.Text.Trim());
                cmd.Parameters.AddWithValue("@p", txtPassword.Text.Trim());

                con.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                if (reader.Read())
                {
                    // store session data
                    Session["UserID"] = reader["UserID"].ToString();
                    Session["Username"] = reader["Username"].ToString();
                    Session["Role"] = reader["Role"].ToString();

                    string role = reader["Role"].ToString();

                    // Redirect based on role
                    switch (role)
                    {
                        case "Admin":
                            Response.Redirect("AdminView.aspx");
                            break;

                        case "Coach":
                            Response.Redirect("CoachView.aspx");
                            break;

                        case "Member":
                            Response.Redirect("MemberView.aspx");
                            break;

                        default:
                            lblError.Text = "Unknown role assigned.";
                            break;
                    }
                }
                else
                {
                    lblError.Text = "Invalid login credentials.";
                }
            }
        }
    }
}
