<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Signup.aspx.cs" Inherits="WebApplication7.Signup" %>

<!DOCTYPE html>
<html>
<head>
    <title>Sign Up</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100">

    <form id="form1" runat="server" class="max-w-lg mx-auto mt-10 bg-white p-8 rounded shadow">

        <!-- HEADER WITH SELECTED PLAN BADGE -->
        <h2 class="text-2xl font-bold mb-6 text-gray-800 flex justify-between items-center">
            <span>Create Account</span>

            <asp:Label ID="lblSelectedPlan" runat="server"
                CssClass="text-xl font-bold px-4 py-1 rounded">
            </asp:Label>
        </h2>

        <!-- Validation summary -->
        <asp:ValidationSummary ID="ValidationSummary1" runat="server"
            CssClass="text-red-500 text-sm mb-4" />

        <!-- Username -->
        <label class="block font-semibold mb-1">Username</label>
        <asp:TextBox ID="txtUsername" runat="server" CssClass="border w-full p-2 mb-1 rounded" />
        <asp:RequiredFieldValidator ID="rfvUsername" runat="server"
            ControlToValidate="txtUsername"
            ErrorMessage="Username is required"
            CssClass="text-red-500 text-sm" Display="Dynamic" />
        <br /><br />

        <!-- Email -->
        <label class="block font-semibold mb-1">Email</label>
        <asp:TextBox ID="txtEmail" runat="server" CssClass="border w-full p-2 mb-1 rounded" />
        <asp:RequiredFieldValidator ID="rfvEmail" runat="server"
            ControlToValidate="txtEmail"
            ErrorMessage="Email is required"
            CssClass="text-red-500 text-sm" Display="Dynamic" />
        <asp:RegularExpressionValidator ID="revEmail" runat="server"
            ControlToValidate="txtEmail"
            ValidationExpression="^[^@]+@[^@]+\.[^@]+$"
            ErrorMessage="Please enter a valid email"
            CssClass="text-red-500 text-sm" Display="Dynamic" />
        <br /><br />

        <!-- Password -->
        <label class="block font-semibold mb-1">Password</label>
        <asp:TextBox ID="txtPassword" runat="server" TextMode="Password"
            CssClass="border w-full p-2 mb-1 rounded" />
        <asp:RequiredFieldValidator ID="rfvPassword" runat="server"
            ControlToValidate="txtPassword"
            ErrorMessage="Password is required"
            CssClass="text-red-500 text-sm" Display="Dynamic" />
        <asp:RegularExpressionValidator ID="revPassword" runat="server"
            ControlToValidate="txtPassword"
            ValidationExpression="^(?=.*\d).{8,}$"
            ErrorMessage="Password must be at least 8 characters and contain a number"
            CssClass="text-red-500 text-sm" Display="Dynamic" />
        <br /><br />

        <!-- First name -->
        <label class="block font-semibold mb-1">First Name</label>
        <asp:TextBox ID="txtFirstName" runat="server" CssClass="border w-full p-2 mb-1 rounded" />
        <asp:RequiredFieldValidator ID="rfvFirstName" runat="server"
            ControlToValidate="txtFirstName"
            ErrorMessage="First name is required"
            CssClass="text-red-500 text-sm" Display="Dynamic" />
        <br /><br />

        <!-- Last name -->
        <label class="block font-semibold mb-1">Last Name</label>
        <asp:TextBox ID="txtLastName" runat="server" CssClass="border w-full p-2 mb-1 rounded" />
        <asp:RequiredFieldValidator ID="rfvLastName" runat="server"
            ControlToValidate="txtLastName"
            ErrorMessage="Last name is required"
            CssClass="text-red-500 text-sm" Display="Dynamic" />
        <br /><br />

        <!-- Role -->
        <label class="block font-semibold mb-1">Role</label>
        <asp:DropDownList ID="ddlRole" runat="server" CssClass="border w-full p-2 mb-1 rounded">
            <asp:ListItem Text="-- Select Role --" Value=""></asp:ListItem>
            <asp:ListItem Text="Coach" Value="Coach"></asp:ListItem>
            <asp:ListItem Text="Member" Value="Member"></asp:ListItem>
        </asp:DropDownList>
        <asp:RequiredFieldValidator ID="rfvRole" runat="server"
            ControlToValidate="ddlRole"
            InitialValue=""
            ErrorMessage="Please select a role"
            CssClass="text-red-500 text-sm" Display="Dynamic" />
        <br /><br />

        <!-- Submit -->
        <asp:Button ID="btnSubmit" runat="server" Text="Register"
            CssClass="w-full bg-red-600 text-white p-3 rounded font-bold hover:bg-red-700"
            OnClick="btnSubmit_Click" />

        <p class="text-sm mt-4">
            Already have an account?
            <a href="Login.aspx" class="text-red-600 font-semibold">Login</a>
        </p>

    </form>

    <asp:Label ID="lblError" runat="server" 
           CssClass="text-red-600 text-sm mb-2 block" 
           Visible="false"></asp:Label>

</body>
</html>
