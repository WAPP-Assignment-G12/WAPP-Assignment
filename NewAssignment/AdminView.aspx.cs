using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Web;
using System.Web.Services;
using System.Web.Script.Services;

namespace WebApplication7
{
    [ScriptService]
    public partial class AdminView : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
                Response.Redirect("Login.aspx");

            if (!IsPostBack)
            {
                lblAdminInfo.Text = "Logged in as: " + Session["Username"];
            }
        }

        [WebMethod]
        public static object GetDashboardCounts()
        {
            int pending = 0;
            int totalUsers = 0;

            string cs = ConfigurationManager.ConnectionStrings["ValoProDB"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();

                // Count from PendingUsers table
                using (SqlCommand cmd = new SqlCommand(
                    "SELECT COUNT(*) FROM PendingUsers", con))
                {
                    pending = (int)cmd.ExecuteScalar();
                }

                // Count from Users table (all roles included: Member, Coach, Admin)
                using (SqlCommand cmd = new SqlCommand(
                    "SELECT COUNT(*) FROM Users", con))
                {
                    totalUsers = (int)cmd.ExecuteScalar();
                }
            }

            return new
            {
                Pending = pending,
                TotalUsers = totalUsers
            };
        }


        /* ============================================================
           LOAD NON-EDITABLE ACCOUNT INFO (Users table)
        ============================================================ */
        [WebMethod(EnableSession = true)]
        public static object LoadAdminAccountInfo()
        {
            try
            {
                int userId = Convert.ToInt32(HttpContext.Current.Session["UserID"]);
                string cs = ConfigurationManager.ConnectionStrings["ValoProDB"].ConnectionString;

                using (SqlConnection con = new SqlConnection(cs))
                {
                    string q = "SELECT Username, Email, PasswordHash FROM Users WHERE UserID=@id";
                    SqlCommand cmd = new SqlCommand(q, con);
                    cmd.Parameters.AddWithValue("@id", userId);

                    con.Open();
                    SqlDataReader rd = cmd.ExecuteReader();

                    if (rd.Read())
                    {
                        return new
                        {
                            Username = rd["Username"].ToString(),
                            Email = rd["Email"].ToString(),
                            Password = rd["PasswordHash"].ToString()
                        };
                    }
                }

                return new { };
            }
            catch (Exception ex)
            {
                return new { error = ex.Message };
            }
        }

        /* ============================================================
           LOAD EDITABLE ADMIN PROFILE (AdminProfiles table)
        ============================================================ */
        [WebMethod(EnableSession = true)]
        public static object LoadAdminProfile()
        {
            try
            {
                int userId = Convert.ToInt32(HttpContext.Current.Session["UserID"]);
                string cs = ConfigurationManager.ConnectionStrings["ValoProDB"].ConnectionString;

                using (SqlConnection con = new SqlConnection(cs))
                {
                    string q = "SELECT * FROM AdminProfiles WHERE AdminID=@id";

                    SqlCommand cmd = new SqlCommand(q, con);
                    cmd.Parameters.AddWithValue("@id", userId);

                    con.Open();
                    SqlDataReader rd = cmd.ExecuteReader();

                    if (rd.Read())
                    {
                        return new
                        {
                            FullName = rd["FullName"].ToString(),
                            Phone = rd["Phone"].ToString(),
                            Region = rd["Region"].ToString(),
                            Gender = rd["Gender"].ToString(),
                            Age = rd["Age"].ToString()
                        };
                    }
                }

                return new { };
            }
            catch (Exception ex)
            {
                return new { error = ex.Message };
            }
        }

        /* ============================================================
           SAVE EDITABLE ADMIN PROFILE (AdminProfiles table)
        ============================================================ */
        [WebMethod(EnableSession = true)]
        public static object SaveAdminProfile(string fullname, string phone, string region, string gender, string age)
        {
            try
            {
                int userId = Convert.ToInt32(HttpContext.Current.Session["UserID"]);
                string cs = ConfigurationManager.ConnectionStrings["ValoProDB"].ConnectionString;

                using (SqlConnection con = new SqlConnection(cs))
                {
                    string q = @"
                        IF EXISTS (SELECT 1 FROM AdminProfiles WHERE AdminID=@id)
                            UPDATE AdminProfiles
                            SET FullName=@fn, Phone=@ph, Region=@rg, Gender=@gd, Age=@ag
                            WHERE AdminID=@id
                        ELSE
                            INSERT INTO AdminProfiles
                                (AdminID, FullName, Phone, Region, Gender, Age)
                            VALUES
                                (@id, @fn, @ph, @rg, @gd, @ag)
                    ";

                    SqlCommand cmd = new SqlCommand(q, con);

                    cmd.Parameters.AddWithValue("@id", userId);
                    cmd.Parameters.AddWithValue("@fn", fullname ?? "");
                    cmd.Parameters.AddWithValue("@ph", phone ?? "");
                    cmd.Parameters.AddWithValue("@rg", region ?? "");
                    cmd.Parameters.AddWithValue("@gd", gender ?? "");
                    cmd.Parameters.AddWithValue("@ag", age ?? "");

                    con.Open();
                    cmd.ExecuteNonQuery();
                }

                return new { status = "success" };
            }
            catch (Exception ex)
            {
                return new { status = "error", error = ex.Message };
            }
        }

        /* ============================================================
           MANAGE USERS – LOAD ALL USERS (Members + Coaches)
        ============================================================ */
        [WebMethod(EnableSession = true)]
        public static object LoadAllUsers(string search)
        {
            try
            {
                string cs = ConfigurationManager.ConnectionStrings["ValoProDB"].ConnectionString;
                var users = new List<object>();

                using (SqlConnection con = new SqlConnection(cs))
                {
                    string q = @"
                        SELECT UserID, Username, Email, Role, Status
                        FROM Users
                        WHERE (@s IS NULL OR @s = '' 
                               OR Username LIKE '%' + @s + '%' 
                               OR Email    LIKE '%' + @s + '%')
                        ORDER BY UserID";

                    SqlCommand cmd = new SqlCommand(q, con);
                    cmd.Parameters.AddWithValue("@s", search ?? "");

                    con.Open();
                    using (SqlDataReader rd = cmd.ExecuteReader())
                    {
                        while (rd.Read())
                        {
                            users.Add(new
                            {
                                UserID = Convert.ToInt32(rd["UserID"]),
                                Username = rd["Username"].ToString(),
                                Email = rd["Email"].ToString(),
                                Role = rd["Role"].ToString(),
                                Status = rd["Status"].ToString()
                            });
                        }
                    }
                }

                return new { users };
            }
            catch (Exception ex)
            {
                return new { error = ex.Message };
            }
        }

        /* ============================================================
           UPDATE USER ROLE + STATUS
        ============================================================ */
        [WebMethod(EnableSession = true)]
        public static object UpdateUserRoleStatus(int userId, string role, string status)
        {
            try
            {
                string cs = ConfigurationManager.ConnectionStrings["ValoProDB"].ConnectionString;

                using (SqlConnection con = new SqlConnection(cs))
                {
                    string q = @"UPDATE Users 
                                 SET Role=@role, Status=@status 
                                 WHERE UserID=@id";

                    SqlCommand cmd = new SqlCommand(q, con);
                    cmd.Parameters.AddWithValue("@id", userId);
                    cmd.Parameters.AddWithValue("@role", string.IsNullOrEmpty(role) ? "Member" : role);
                    cmd.Parameters.AddWithValue("@status", string.IsNullOrEmpty(status) ? "Active" : status);

                    con.Open();
                    cmd.ExecuteNonQuery();
                }

                return new { status = "success" };
            }
            catch (Exception ex)
            {
                return new { status = "error", error = ex.Message };
            }
        }

        [WebMethod(EnableSession = true)]
        public static object GetAllUsers()
        {
            List<object> list = new List<object>();
            string cs = ConfigurationManager.ConnectionStrings["ValoProDB"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                string q = "SELECT UserID, Username, Email, Role, Status FROM Users";
                SqlCommand cmd = new SqlCommand(q, con);

                con.Open();
                SqlDataReader rd = cmd.ExecuteReader();

                while (rd.Read())
                {
                    list.Add(new
                    {
                        UserID = rd["UserID"],
                        Username = rd["Username"].ToString(),
                        Email = rd["Email"].ToString(),
                        Role = rd["Role"].ToString(),
                        Status = rd["Status"].ToString()
                    });
                }
            }

            return list;
        }


        /* ============================================================
           DELETE USER (Deactivate button = hard delete)
        ============================================================ */
        [WebMethod(EnableSession = true)]
        public static object DeleteUser(int userId)
        {
            try
            {
                string cs = ConfigurationManager.ConnectionStrings["ValoProDB"].ConnectionString;

                using (SqlConnection con = new SqlConnection(cs))
                {
                    string q = "DELETE FROM Users WHERE UserID=@id";
                    SqlCommand cmd = new SqlCommand(q, con);
                    cmd.Parameters.AddWithValue("@id", userId);

                    con.Open();
                    cmd.ExecuteNonQuery();
                }

                return new { status = "success" };
            }
            catch (Exception ex)
            {
                return new { status = "error", error = ex.Message };
            }
        }
    }
}
