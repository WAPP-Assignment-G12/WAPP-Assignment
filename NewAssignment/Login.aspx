<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="WebApplication7.Login" %>

<!DOCTYPE html>
<html>
<head>
    <title>Login</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>

<body class="bg-gray-100 flex items-center justify-center h-screen">

    <form id="form1" runat="server" class="bg-white p-8 rounded shadow-lg w-96">

        <h2 class="text-2xl font-bold mb-6 text-center">User Login</h2>

        <asp:Label ID="lblError" runat="server"
            CssClass="text-red-600 text-sm mb-4 block"></asp:Label>

        <label class="block text-sm font-medium mb-1">Username or Email</label>
        <asp:TextBox ID="txtUsername" runat="server"
            CssClass="w-full p-2 border rounded mb-4" />

        <label class="block text-sm font-medium mb-1">Password</label>
        <asp:TextBox ID="txtPassword" runat="server"
            TextMode="Password"
            CssClass="w-full p-2 border rounded mb-6" />

        <asp:Button ID="btnLogin" runat="server"
            Text="Login"
            CssClass="w-full bg-blue-600 text-white p-2 rounded"
            OnClick="btnLogin_Click" />

    </form>

</body>
</html>
