using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;

namespace WebApplication7
{
    [ScriptService]
    public partial class CoachView : System.Web.UI.Page
    {
        private static readonly string cs =
           ConfigurationManager.ConnectionStrings["ValoProDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
                Response.Redirect("Login.aspx");

            // Treat UserID as CoachID
            Session["CoachID"] = Session["UserID"];
        }

        /* ============================================================
           LOAD NON-EDITABLE ACCOUNT INFO (from Users)
        ============================================================ */
        [WebMethod(EnableSession = true)]
        public static object LoadCoachAccountInfo()
        {
            try
            {
                int coachId = Convert.ToInt32(HttpContext.Current.Session["CoachID"]);

                using (SqlConnection con = new SqlConnection(cs))
                {
                    string q = "SELECT Username, Email, PasswordHash FROM Users WHERE UserID=@id";
                    SqlCommand cmd = new SqlCommand(q, con);
                    cmd.Parameters.AddWithValue("@id", coachId);

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
           LOAD COACH SERVICE INFO (Title, Description, Price)
        ============================================================ */
        [WebMethod(EnableSession = true)]
        public static object LoadCoachService()
        {
            try
            {
                int coachId = Convert.ToInt32(HttpContext.Current.Session["CoachID"]);

                using (SqlConnection con = new SqlConnection(cs))
                {
                    string q = @"
                        SELECT TOP 1 Title, Description, PricePerHour
                        FROM CoachServices
                        WHERE CoachID = @id
                        ORDER BY ServiceID DESC";

                    SqlCommand cmd = new SqlCommand(q, con);
                    cmd.Parameters.AddWithValue("@id", coachId);

                    con.Open();
                    SqlDataReader rd = cmd.ExecuteReader();

                    if (rd.Read())
                    {
                        return new
                        {
                            Title = rd["Title"].ToString(),
                            Description = rd["Description"].ToString(),
                            PricePerHour = rd["PricePerHour"] == DBNull.Value
                                ? 0
                                : Convert.ToDecimal(rd["PricePerHour"])
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
           SAVE COACH SERVICE INFO
        ============================================================ */
        [WebMethod(EnableSession = true)]
        public static object SaveCoachService(string title, string description, string pricePerHour)
        {
            try
            {
                int coachId = Convert.ToInt32(HttpContext.Current.Session["CoachID"]);
                if (coachId <= 0)
                    return new { status = "error", error = "Not logged in." };

                if (!decimal.TryParse(pricePerHour, out decimal price) || price <= 0)
                    return new { status = "error", error = "Price must be a valid number greater than 0." };

                using (SqlConnection con = new SqlConnection(cs))
                {
                    string q = @"
                        IF EXISTS (SELECT 1 FROM CoachServices WHERE CoachID = @id)
                            UPDATE CoachServices SET
                                Title=@t, Description=@d, PricePerHour=@p, LastUpdated=GETDATE()
                            WHERE CoachID=@id
                        ELSE
                            INSERT INTO CoachServices (CoachID, Title, Description, PricePerHour)
                            VALUES (@id, @t, @d, @p)";

                    SqlCommand cmd = new SqlCommand(q, con);
                    cmd.Parameters.AddWithValue("@id", coachId);
                    cmd.Parameters.AddWithValue("@t", title ?? "");
                    cmd.Parameters.AddWithValue("@d", description ?? "");
                    cmd.Parameters.AddWithValue("@p", price);

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
           FETCH BOOKING REQUESTS (students who paid)
        ============================================================ */
        [WebMethod(EnableSession = true)]
        public static object GetBookingRequests()
        {
            try
            {
                int coachId = Convert.ToInt32(HttpContext.Current.Session["CoachID"]);
                var list = new List<object>();

                using (SqlConnection con = new SqlConnection(cs))
                {
                    string q = @"
                SELECT 
                    b.BookingID,
                    b.SessionDateTime,
                    b.Status,
                    u.Username AS MemberName,
                    b.Phone,
                    b.DiscordID
                FROM Bookings b
                JOIN Users u ON u.UserID = b.MemberID
                WHERE b.CoachID = @c
                ORDER BY b.SessionDateTime DESC;";

                    SqlCommand cmd = new SqlCommand(q, con);
                    cmd.Parameters.AddWithValue("@c", coachId);

                    con.Open();
                    SqlDataReader rd = cmd.ExecuteReader();

                    while (rd.Read())
                    {
                        DateTime dt = Convert.ToDateTime(rd["SessionDateTime"]);

                        list.Add(new
                        {
                            BookingID = Convert.ToInt32(rd["BookingID"]),
                            MemberName = rd["MemberName"].ToString(),
                            Phone = rd["Phone"].ToString(),
                            DiscordID = rd["DiscordID"].ToString(),
                            DateTime = dt.ToString("yyyy-MM-dd HH:mm"),
                            Status = rd["Status"].ToString()
                        });
                    }
                }

                return new { requests = list };
            }
            catch (Exception ex)
            {
                return new { error = ex.Message };
            }
        }

        [WebMethod(EnableSession = true)]
        public static object UpdateBookingStatus(int bookingId, string status)
        {
            try
            {
                int coachId = Convert.ToInt32(HttpContext.Current.Session["CoachID"]);

                status = (status ?? "").Trim();
                if (status != "Confirmed" && status != "Rejected")
                    return new { status = "error", error = "Invalid status." };

                using (SqlConnection con = new SqlConnection(cs))
                {
                    string q = @"
                UPDATE Bookings
                   SET Status = @s
                 WHERE BookingID = @id
                   AND CoachID   = @c";

                    SqlCommand cmd = new SqlCommand(q, con);
                    cmd.Parameters.AddWithValue("@s", status);
                    cmd.Parameters.AddWithValue("@id", bookingId);
                    cmd.Parameters.AddWithValue("@c", coachId);

                    con.Open();
                    int rows = cmd.ExecuteNonQuery();
                    if (rows == 0)
                        return new { status = "error", error = "Booking not found." };
                }

                return new { status = "success" };
            }
            catch (Exception ex)
            {
                return new { status = "error", error = ex.Message };
            }
        }

        [WebMethod(EnableSession = true)]
        public static object GetMySessions()
        {
            try
            {
                int coachId = Convert.ToInt32(HttpContext.Current.Session["CoachID"]);
                var list = new List<object>();

                using (SqlConnection con = new SqlConnection(cs))
                {
                    string q = @"
                SELECT
                    b.BookingID,
                    b.SessionDateTime,
                    b.SessionStatus,
                    u.Username AS StudentUsername,
                    cs.Title,
                    cs.PricePerHour
                FROM Bookings b
                JOIN Users u ON u.UserID = b.MemberID
                LEFT JOIN CoachServices cs ON cs.CoachID = b.CoachID
                WHERE b.CoachID = @c AND b.Status = 'Confirmed'
                ORDER BY b.SessionDateTime DESC";

                    SqlCommand cmd = new SqlCommand(q, con);
                    cmd.Parameters.AddWithValue("@c", coachId);

                    con.Open();
                    SqlDataReader rd = cmd.ExecuteReader();

                    while (rd.Read())
                    {
                        DateTime dt = Convert.ToDateTime(rd["SessionDateTime"]);

                        list.Add(new
                        {
                            BookingID = Convert.ToInt32(rd["BookingID"]),
                            Date = dt.ToString("MMM dd"),
                            Title = rd["Title"].ToString(),
                            Student = rd["StudentUsername"].ToString(),
                            Price = rd["PricePerHour"] == DBNull.Value
                                ? 0
                                : Convert.ToDecimal(rd["PricePerHour"]),
                            Status = rd["SessionStatus"].ToString()
                        });
                    }
                }

                return new { sessions = list };
            }
            catch (Exception ex)
            {
                return new { error = ex.Message };
            }
        }

        [WebMethod(EnableSession = true)]
        public static object UpdateSessionStatus(int bookingId, string status)
        {
            try
            {
                int coachId = Convert.ToInt32(HttpContext.Current.Session["CoachID"]);

                using (SqlConnection con = new SqlConnection(cs))
                {
                    string q = @"
                UPDATE Bookings
SET SessionStatus = @s

                WHERE BookingID = @id AND CoachID = @c";

                    SqlCommand cmd = new SqlCommand(q, con);
                    cmd.Parameters.AddWithValue("@s", status);
                    cmd.Parameters.AddWithValue("@id", bookingId);
                    cmd.Parameters.AddWithValue("@c", coachId);

                    con.Open();
                    cmd.ExecuteNonQuery();
                }

                return new { status = "success" };


            }
            catch (Exception ex)
            {
                return new { error = ex.Message };
            }
        }



        /* ============================================================
           LOAD COACH PROFILE (editable)
        ============================================================ */
        [WebMethod(EnableSession = true)]
        public static object LoadCoachProfile()
        {
            try
            {
                int coachId = Convert.ToInt32(HttpContext.Current.Session["CoachID"]);

                using (SqlConnection con = new SqlConnection(cs))
                {
                    string q = "SELECT * FROM CoachProfiles WHERE CoachID=@id";

                    SqlCommand cmd = new SqlCommand(q, con);
                    cmd.Parameters.AddWithValue("@id", coachId);

                    con.Open();
                    SqlDataReader rd = cmd.ExecuteReader();

                    if (rd.Read())
                    {
                        return new
                        {
                            FullName = rd["FullName"].ToString(),
                            PlayerUsername = rd["PlayerUsername"].ToString(),
                            Rank = rd["Rank"].ToString(),
                            Region = rd["Region"].ToString(),
                            Gender = rd["Gender"].ToString(),
                            Age = rd["Age"].ToString(),
                            RiotID = rd["RiotID"].ToString()
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
           SAVE COACH PROFILE
        ============================================================ */
        [WebMethod(EnableSession = true)]
        public static object SaveCoachProfile(
            string fullname,
            string playerusername,
            string riotid,
            string rank,
            string region,
            string gender,
            string age)
        {
            try
            {
                int coachId = Convert.ToInt32(HttpContext.Current.Session["CoachID"]);

                using (SqlConnection con = new SqlConnection(cs))
                {
                    string q = @"
                        IF EXISTS (SELECT 1 FROM CoachProfiles WHERE CoachID=@id)
                            UPDATE CoachProfiles SET
                                FullName=@fn,
                                PlayerUsername=@pu,
                                Rank=@rk,
                                Region=@rg,
                                Gender=@gd,
                                Age=@ag,
                                RiotID=@ri
                            WHERE CoachID=@id
                        ELSE
                            INSERT INTO CoachProfiles
                                (CoachID, FullName, PlayerUsername, Rank, Region, Gender, Age, RiotID)
                            VALUES
                                (@id, @fn, @pu, @rk, @rg, @gd, @ag, @ri)";

                    SqlCommand cmd = new SqlCommand(q, con);

                    cmd.Parameters.AddWithValue("@id", coachId);
                    cmd.Parameters.AddWithValue("@fn", fullname ?? "");
                    cmd.Parameters.AddWithValue("@pu", playerusername ?? "");
                    cmd.Parameters.AddWithValue("@rk", rank ?? "");
                    cmd.Parameters.AddWithValue("@rg", region ?? "");
                    cmd.Parameters.AddWithValue("@gd", gender ?? "");
                    cmd.Parameters.AddWithValue("@ag", age ?? "");
                    cmd.Parameters.AddWithValue("@ri", riotid ?? "");

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
