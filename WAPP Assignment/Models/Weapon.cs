using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace WAPP_Assignment.Models
{
    public class Weapon
    {
        public int Id { get; set; }

        [Required]
        [Display(Name = "Weapon Name")]
        public string Name { get; set; }

        [Required]
        public string Type { get; set; }
        public int Damage { get; set; }
        public int Cost { get; set; }

        [Display(Name = "Image URL")]
        public string ImageUrl { get; set; }
    }
}