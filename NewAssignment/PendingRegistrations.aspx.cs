using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace WebApplication7
{
    public partial class PendingRegistrations : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Only admin can access
            if (Session["Role"] == null || Session["Role"].ToString() != "Admin")
            {
                Response.Redirect("Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadPendingUsers();
            }
        }

        private void LoadPendingUsers()
        {
            string cs = ConfigurationManager.ConnectionStrings["ValoProDB"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            using (SqlCommand cmd = new SqlCommand(
                "SELECT PendingID, Username, Email, RequestedRole FROM PendingUsers", con))
            using (SqlDataAdapter da = new SqlDataAdapter(cmd))
            {
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvPending.DataSource = dt;
                gvPending.DataBind();
            }
        }

        protected void gvPending_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
        {
            if (e.CommandArgument == null)
                return;

            int pendingId = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "ApproveUser")
            {
                ApproveUser(pendingId);
            }
            else if (e.CommandName == "RejectUser")
            {
                RejectUser(pendingId);
            }

            LoadPendingUsers();
        }

        private void ApproveUser(int pendingId)
        {
            string cs = ConfigurationManager.ConnectionStrings["ValoProDB"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                SqlTransaction tx = con.BeginTransaction();

                try
                {
                    // 1. Read pending user info
                    string selectQuery = @"
                        SELECT Username, Email, PasswordHash, FirstName, LastName, RequestedRole
                        FROM PendingUsers WHERE PendingID = @id";

                    SqlCommand selectCmd = new SqlCommand(selectQuery, con, tx);
                    selectCmd.Parameters.AddWithValue("@id", pendingId);

                    string username, email, password, first, last, role;

                    using (SqlDataReader reader = selectCmd.ExecuteReader())
                    {
                        if (!reader.Read())
                        {
                            tx.Rollback();
                            lblMessage.Text = "User not found.";
                            return;
                        }

                        username = reader["Username"].ToString();
                        email = reader["Email"].ToString();
                        password = reader["PasswordHash"].ToString();
                        first = reader["FirstName"].ToString();
                        last = reader["LastName"].ToString();
                        role = reader["RequestedRole"].ToString();
                    }

                    // 2. Insert into Users table (UPDATED WITH STATUS)
                    string insertQuery = @"
                        INSERT INTO Users 
                            (Username, Email, PasswordHash, FirstName, LastName, Role, IsActive, Status)
                        VALUES 
                            (@u, @e, @p, @f, @l, @r, 1, 'Active')";

                    SqlCommand insertCmd = new SqlCommand(insertQuery, con, tx);
                    insertCmd.Parameters.AddWithValue("@u", username);
                    insertCmd.Parameters.AddWithValue("@e", email);
                    insertCmd.Parameters.AddWithValue("@p", password);
                    insertCmd.Parameters.AddWithValue("@f", first);
                    insertCmd.Parameters.AddWithValue("@l", last);
                    insertCmd.Parameters.AddWithValue("@r", role);
                    insertCmd.ExecuteNonQuery();

                    // 3. Remove record from PendingUsers
                    SqlCommand deleteCmd = new SqlCommand(
                        "DELETE FROM PendingUsers WHERE PendingID = @id", con, tx);
                    deleteCmd.Parameters.AddWithValue("@id", pendingId);
                    deleteCmd.ExecuteNonQuery();

                    tx.Commit();
                    lblMessage.Text = "User approved successfully.";
                }
                catch (Exception ex)
                {
                    tx.Rollback();
                    lblMessage.Text = "Error approving user.";
                }
            }
        }

        private void RejectUser(int pendingId)
        {
            string cs = ConfigurationManager.ConnectionStrings["ValoProDB"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            using (SqlCommand cmd = new SqlCommand(
                "DELETE FROM PendingUsers WHERE PendingID = @id", con))
            {
                cmd.Parameters.AddWithValue("@id", pendingId);

                con.Open();
                cmd.ExecuteNonQuery();
            }

            lblMessage.Text = "User rejected and removed.";
        }
    }
}
