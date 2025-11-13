namespace WAPP_Assignment.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddWeaponTable : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Weapons", "Cost", c => c.Int(nullable: false));
            AddColumn("dbo.Weapons", "ImageUrl", c => c.String());
            AlterColumn("dbo.Weapons", "Name", c => c.String(nullable: false));
            AlterColumn("dbo.Weapons", "Type", c => c.String(nullable: false));
            DropColumn("dbo.Weapons", "Weight");
            DropColumn("dbo.Weapons", "Price");
        }
        
        public override void Down()
        {
            AddColumn("dbo.Weapons", "Price", c => c.Decimal(nullable: false, precision: 18, scale: 2));
            AddColumn("dbo.Weapons", "Weight", c => c.Single(nullable: false));
            AlterColumn("dbo.Weapons", "Type", c => c.String());
            AlterColumn("dbo.Weapons", "Name", c => c.String());
            DropColumn("dbo.Weapons", "ImageUrl");
            DropColumn("dbo.Weapons", "Cost");
        }
    }
}
