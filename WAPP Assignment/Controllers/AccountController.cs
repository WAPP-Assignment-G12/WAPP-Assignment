using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace WAPP_Assignment.Controllers
{
    public class AccountController : Controller
    {
        // GET: Account
        public ActionResult Index()
        {
            return View();
        }

        [Authorize] // This user must be logged in
        public class MemberDashboardController : Controller
        {
            public ActionResult Index() { return View(); }
        }

        [Authorize(Roles = "Admin")] // This user must be logged in AND be in the "Admin" role
        public class AdminDashboardController : Controller
        {
            public ActionResult Index() { return View(); }
        }
    }
}