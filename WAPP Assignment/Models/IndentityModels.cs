using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
using System.Data.Entity;

namespace WAPP_Assignment.Models
{
    public class IndentityModels
    {
    }

    // You can add profile data for the user by adding more properties to your ApplicationUser class
    public class ApplicationUser : IdentityUser
    {
        // Example: Add properties for ValoPro
        // public string ValorantRank { get; set; }
    }

    public class ApplicationDbContext : IdentityDbContext<ApplicationUser>
    {
        public ApplicationDbContext()
            : base("DefaultConnection", throwIfV1Schema: false)
        {
        }

        public static ApplicationDbContext Create()
        {
            return new ApplicationDbContext();
        }
        public System.Data.Entity.DbSet<WAPP_Assignment.Models.Weapon> Weapons { get; set; }
        // Add your other models here to create tables
        // public DbSet<ValoPro.Models.Weapon> Weapons { get; set; }
        // public DbSet<ValoPro.Models.Agent> Agents { get; set; }
    }
}