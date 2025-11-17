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
    public partial class MemberView : System.Web.UI.Page
    {
        private static readonly string cs =
            ConfigurationManager.ConnectionStrings["ValoProDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Allow AJAX-only calls
            if (Request.Path.ToLower().Contains("memberview.aspx/"))
                return;

            if (Session["UserID"] == null)
                Response.Redirect("Login.aspx");
        }

        /* ============================================================
           LOAD ACCOUNT INFO
           ============================================================ */
        [WebMethod(EnableSession = true)]
        public static object LoadAccountInfo()
        {
            try
            {
                int userId = Convert.ToInt32(HttpContext.Current.Session["UserID"]);

                using (SqlConnection con = new SqlConnection(cs))
                {
                    string q = "SELECT Username, Email, PasswordHash, Avatar FROM Users WHERE UserID=@id";
                    SqlCommand cmd = new SqlCommand(q, con);
                    cmd.Parameters.AddWithValue("@id", userId);

                    con.Open();
                    SqlDataReader rd = cmd.ExecuteReader();

                    if (rd.Read())
                    {
                        string avatar = rd["Avatar"] != DBNull.Value
                            ? Convert.ToBase64String((byte[])rd["Avatar"])
                            : null;

                        return new
                        {
                            Username = rd["Username"].ToString(),
                            Email = rd["Email"].ToString(),
                            Password = rd["PasswordHash"].ToString(),
                            Avatar = avatar
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
           UPLOAD AVATAR
           ============================================================ */
        [WebMethod(EnableSession = true)]
        public static object UploadAvatar(string imageBase64)
        {
            try
            {
                if (HttpContext.Current.Session["UserID"] == null)
                    return new { status = "error", error = "Not logged in" };

                int userId = Convert.ToInt32(HttpContext.Current.Session["UserID"]);
                byte[] imgBytes = Convert.FromBase64String(imageBase64);

                using (SqlConnection con = new SqlConnection(cs))
                {
                    string q = "UPDATE Users SET Avatar=@img WHERE UserID=@id";
                    SqlCommand cmd = new SqlCommand(q, con);

                    cmd.Parameters.AddWithValue("@img", imgBytes);
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

        /* ============================================================
           LOAD PLAYER PROFILE
           ============================================================ */
        [WebMethod(EnableSession = true)]
        public static object LoadProfile()
        {
            try
            {
                int userId = Convert.ToInt32(HttpContext.Current.Session["UserID"]);

                using (SqlConnection con = new SqlConnection(cs))
                {
                    string q = "SELECT * FROM UserProfiles WHERE UserID=@id";
                    SqlCommand cmd = new SqlCommand(q, con);
                    cmd.Parameters.AddWithValue("@id", userId);

                    con.Open();
                    SqlDataReader rd = cmd.ExecuteReader();

                    if (rd.Read())
                    {
                        return new
                        {
                            PlayerName = rd["PlayerName"].ToString(),
                            Rank = rd["Rank"].ToString(),
                            FavouriteMap = rd["FavouriteMap"].ToString(),
                            FavouriteAgent = rd["FavouriteAgent"].ToString(),
                            FavouriteWeapon = rd["FavouriteWeapon"].ToString(),
                            Device = rd["Device"].ToString(),
                            Gender = rd["Gender"].ToString(),
                            Age = rd["Age"].ToString(),
                            Country = rd["Country"].ToString()
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
           SAVE PLAYER PROFILE
           ============================================================ */
        [WebMethod(EnableSession = true)]
        public static object SaveProfile(
            string playername, string rank, string favmap, string favagent,
            string favweapon, string device, string gender, string age, string country)
        {
            try
            {
                int userId = Convert.ToInt32(HttpContext.Current.Session["UserID"]);

                using (SqlConnection con = new SqlConnection(cs))
                {
                    string q = @"
                        IF EXISTS (SELECT 1 FROM UserProfiles WHERE UserID=@id)
                        UPDATE UserProfiles SET
                            PlayerName=@pn, Rank=@rk, FavouriteMap=@fm,
                            FavouriteAgent=@fa, FavouriteWeapon=@fw,
                            Device=@dv, Gender=@gd, Age=@ag, Country=@ct
                        WHERE UserID=@id
                        ELSE
                        INSERT INTO UserProfiles
                            (UserID, PlayerName, Rank, FavouriteMap, FavouriteAgent,
                             FavouriteWeapon, Device, Gender, Age, Country)
                        VALUES
                            (@id, @pn, @rk, @fm, @fa, @fw, @dv, @gd, @ag, @ct)";

                    SqlCommand cmd = new SqlCommand(q, con);

                    cmd.Parameters.AddWithValue("@id", userId);
                    cmd.Parameters.AddWithValue("@pn", playername);
                    cmd.Parameters.AddWithValue("@rk", rank);
                    cmd.Parameters.AddWithValue("@fm", favmap);
                    cmd.Parameters.AddWithValue("@fa", favagent);
                    cmd.Parameters.AddWithValue("@fw", favweapon);
                    cmd.Parameters.AddWithValue("@dv", device);
                    cmd.Parameters.AddWithValue("@gd", gender);
                    cmd.Parameters.AddWithValue("@ag", age);
                    cmd.Parameters.AddWithValue("@ct", country);

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
           LOAD COACHING LIST (Shown on Member Book Coaching Page)
           ============================================================ */
        [WebMethod(EnableSession = true)]
        public static object LoadCoachingList()
        {
            List<object> coaches = new List<object>();

            using (SqlConnection con = new SqlConnection(cs))
            {
                string q = @"
                    SELECT 
                        u.UserID,
                        ISNULL(cp.FullName, '') AS FullName,
                        ISNULL(cp.RiotID, '') AS RiotID,
                        ISNULL(cp.Rank, '') AS Rank,
                        ISNULL(cp.Region, '') AS Region,
                        ISNULL(cs.Title, '') AS Title,
                        ISNULL(cs.Description, '') AS Description,
                        ISNULL(cs.PricePerHour, 0) AS PricePerHour
                    FROM Users u
                    LEFT JOIN CoachProfiles cp ON cp.CoachID = u.UserID
                    LEFT JOIN CoachServices cs ON cs.CoachID = u.UserID
                    WHERE u.Role = 'Coach'
                      AND u.Status = 'Active'
                    ORDER BY u.UserID";

                SqlCommand cmd = new SqlCommand(q, con);

                con.Open();
                SqlDataReader rd = cmd.ExecuteReader();

                while (rd.Read())
                {
                    coaches.Add(new
                    {
                        CoachID = Convert.ToInt32(rd["UserID"]),
                        FullName = rd["FullName"].ToString(),
                        RiotID = rd["RiotID"].ToString(),
                        Rank = rd["Rank"].ToString(),
                        Region = rd["Region"].ToString(),
                        Title = rd["Title"].ToString(),
                        Description = rd["Description"].ToString(),
                        PricePerHour = Convert.ToDecimal(rd["PricePerHour"])
                    });
                }
            }

            return new { coaches };
        }

        /* ============================================================
           CREATE BOOKING (Payment Page)
           ============================================================ */
        [WebMethod(EnableSession = true)]
        public static object CreateBooking(int coachId, string phone, string discord, string datetime)
        {
            try
            {
                int memberId = Convert.ToInt32(HttpContext.Current.Session["UserID"]);
                DateTime dt = DateTime.Parse(datetime);

                using (SqlConnection con = new SqlConnection(cs))
                {
                    string q = @"
                INSERT INTO Bookings
                    (CoachID, MemberID, Phone, DiscordID, SessionDateTime, Status)
                VALUES
                    (@c, @m, @p, @d, @dt, 'Pending')";

                    SqlCommand cmd = new SqlCommand(q, con);
                    cmd.Parameters.AddWithValue("@c", coachId);
                    cmd.Parameters.AddWithValue("@m", memberId);
                    cmd.Parameters.AddWithValue("@p", phone);
                    cmd.Parameters.AddWithValue("@d", discord);
                    cmd.Parameters.AddWithValue("@dt", dt);

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
        public static object GetMemberSessions()
        {
            int memberId = Convert.ToInt32(HttpContext.Current.Session["UserID"]);
            var list = new List<object>();

            using (SqlConnection con = new SqlConnection(cs))
            {
                string q = @"
            SELECT
                b.BookingID,
                b.SessionDateTime,
                b.SessionStatus,
                cs.Title,
                cs.PricePerHour,
                cp.FullName AS CoachName
            FROM Bookings b
            LEFT JOIN CoachServices cs ON cs.CoachID = b.CoachID
            LEFT JOIN CoachProfiles cp ON cp.CoachID = b.CoachID
            WHERE b.MemberID = @m AND b.Status = 'Confirmed'
            ORDER BY b.SessionDateTime DESC";

                SqlCommand cmd = new SqlCommand(q, con);
                cmd.Parameters.AddWithValue("@m", memberId);

                con.Open();
                SqlDataReader rd = cmd.ExecuteReader();

                while (rd.Read())
                {
                    DateTime dt = Convert.ToDateTime(rd["SessionDateTime"]);

                    list.Add(new
                    {
                        Date = dt.ToString("MMM dd"),
                        Time = dt.ToString("h:mm tt"),
                        Title = rd["Title"].ToString(),
                        CoachName = rd["CoachName"].ToString(),
                        Price = rd["PricePerHour"] == DBNull.Value ? 0 : Convert.ToDecimal(rd["PricePerHour"]),
                        SessionStatus = rd["SessionStatus"]?.ToString() ?? "Incomplete"
                    });
                }
            }

            return new { sessions = list };
        }

        [WebMethod(EnableSession = true)]
        public static object GetMyBookings()
        {
            try
            {
                int memberId = Convert.ToInt32(HttpContext.Current.Session["UserID"]);
                var list = new List<object>();

                using (SqlConnection con = new SqlConnection(cs))
                {
                    string q = @"
                SELECT 
                    b.BookingID,
                    b.SessionDateTime,
                    b.Status,
                    cs.Title,
                    cs.Description,
                    cs.PricePerHour,
                    cp.FullName,
                    u.Username AS CoachUsername
                FROM Bookings b
                JOIN Users u          ON u.UserID = b.CoachID
                LEFT JOIN CoachProfiles cp ON cp.CoachID = b.CoachID
                LEFT JOIN CoachServices cs ON cs.CoachID = b.CoachID
                WHERE b.MemberID = @m
                ORDER BY b.SessionDateTime DESC;";

                    SqlCommand cmd = new SqlCommand(q, con);
                    cmd.Parameters.AddWithValue("@m", memberId);

                    con.Open();
                    SqlDataReader rd = cmd.ExecuteReader();

                    while (rd.Read())
                    {
                        DateTime dt = Convert.ToDateTime(rd["SessionDateTime"]);

                        list.Add(new
                        {
                            BookingID = Convert.ToInt32(rd["BookingID"]),
                            Status = rd["Status"].ToString(),
                            Date = dt.ToString("dd"),
                            Month = dt.ToString("MMM").ToUpper(),
                            Time = dt.ToString("h:mm tt"),
                            Title = rd["Title"].ToString(),
                            Description = rd["Description"].ToString(),
                            PricePerHour = rd["PricePerHour"] == DBNull.Value
                                ? 0
                                : Convert.ToDecimal(rd["PricePerHour"]),
                            CoachFullName = rd["FullName"].ToString(),
                            CoachUsername = rd["CoachUsername"].ToString()
                        });
                    }
                }

                return new { bookings = list };
            }
            catch (Exception ex)
            {
                return new { error = ex.Message };
            }
        }

        [WebMethod(EnableSession = true)]
        public static object CancelBooking(int bookingId)
        {
            try
            {
                int memberId = Convert.ToInt32(HttpContext.Current.Session["UserID"]);

                using (SqlConnection con = new SqlConnection(cs))
                {
                    string q = "DELETE FROM Bookings WHERE BookingID=@id AND MemberID=@m";
                    SqlCommand cmd = new SqlCommand(q, con);
                    cmd.Parameters.AddWithValue("@id", bookingId);
                    cmd.Parameters.AddWithValue("@m", memberId);

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
           COACH — VIEW BOOKING REQUESTS
           ============================================================ */
        [WebMethod(EnableSession = true)]
        public static object GetBookingRequests()
        {
            try
            {
                int coachId = Convert.ToInt32(HttpContext.Current.Session["UserID"]);
                List<object> list = new List<object>();

                using (SqlConnection con = new SqlConnection(cs))
                {
                    string q = @"
                        SELECT 
                            b.BookingID,
                            u.Username AS MemberName,
                            b.Phone,
                            b.DiscordID,
                            b.SessionDateTime
                        FROM Bookings b
                        JOIN Users u ON u.UserID = b.MemberID
                        WHERE b.CoachID = @c
                        ORDER BY b.SessionDateTime DESC";

                    SqlCommand cmd = new SqlCommand(q, con);
                    cmd.Parameters.AddWithValue("@c", coachId);

                    con.Open();
                    SqlDataReader rd = cmd.ExecuteReader();

                    while (rd.Read())
                    {
                        list.Add(new
                        {
                            MemberName = rd["MemberName"].ToString(),
                            Phone = rd["Phone"].ToString(),
                            DiscordID = rd["DiscordID"].ToString(),
                            DateTime = Convert
                                .ToDateTime(rd["SessionDateTime"])
                                .ToString("yyyy-MM-dd HH:mm")
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

    }
}
