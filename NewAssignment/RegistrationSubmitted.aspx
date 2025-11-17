<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="RegistrationSubmitted.aspx.cs" Inherits="WebApplication7.RegistrationSubmitted" %>
<!DOCTYPE html>
<html>
<head>
    <title>Registration Submitted</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100">

    <form id="form1" runat="server" class="max-w-lg mx-auto mt-10 bg-white p-8 rounded shadow text-center">
        <h2 class="text-2xl font-bold mb-4 text-gray-800">Registration Submitted</h2>
        <p class="text-gray-600 mb-6">
            Your account request has been submitted. An admin will review and approve it. If you're registering as a member, please DM the following phone number/gmail to conduct your payment: 011-24016136 or valopro123@gmail.com. Otherwise, your account shall remain invalid.
        </p>
        <a href="GuestView.aspx" class="bg-red-600 text-white px-6 py-2 rounded font-bold hover:bg-red-700">
            Back to Home
        </a>
    </form>

</body>
</html>
