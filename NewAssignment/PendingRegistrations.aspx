

<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PendingRegistrations.aspx.cs" Inherits="WebApplication7.PendingRegistrations" %>

<!DOCTYPE html>
<html>
<head>
    <title>Pending Registrations</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>

<body class="bg-gray-100">

<form id="form1" runat="server">

    <!-- MAIN CONTAINER -->
    <div class="max-w-6xl mx-auto mt-10 bg-white p-10 rounded-lg shadow">

        <!-- HEADER -->
        <h1 class="text-3xl font-bold text-gray-900 mb-2">Pending User Registrations</h1>
        <p class="text-gray-500 mb-6">Approve or reject new user accounts.</p>

        <!-- SUCCESS / ERROR MESSAGE -->
        <asp:Label ID="lblMessage" runat="server"
            CssClass="text-green-600 text-sm mb-4 block"></asp:Label>

        <!-- GRIDVIEW WRAPPER -->
        <div class="overflow-hidden border border-gray-300 rounded-lg">
            <asp:GridView ID="gvPending" runat="server"
                CssClass="min-w-full border-collapse"
                AutoGenerateColumns="False"
                DataKeyNames="PendingID"
                OnRowCommand="gvPending_RowCommand"
                HeaderStyle-CssClass="bg-gray-50 text-gray-700 text-left text-sm font-semibold border-b"
                RowStyle-CssClass="border-b hover:bg-gray-50 transition">

                <Columns>

                    <asp:BoundField DataField="PendingID" HeaderText="ID">
                        <ItemStyle CssClass="py-3 px-4 text-sm" />
                        <HeaderStyle CssClass="py-3 px-4" />
                    </asp:BoundField>

                    <asp:BoundField DataField="Username" HeaderText="Username">
                        <ItemStyle CssClass="py-3 px-4 text-sm" />
                        <HeaderStyle CssClass="py-3 px-4" />
                    </asp:BoundField>

                    <asp:BoundField DataField="Email" HeaderText="Email">
                        <ItemStyle CssClass="py-3 px-4 text-sm" />
                        <HeaderStyle CssClass="py-3 px-4" />
                    </asp:BoundField>

                    <asp:TemplateField HeaderText="Requested Role">
    <HeaderStyle CssClass="py-3 px-4" />
    <ItemStyle CssClass="py-3 px-4" />

    <ItemTemplate>
        <span class='<%# Eval("RequestedRole").ToString() == "Coach" 
                        ? "text-blue-700 font-semibold" 
                        : "text-orange-600 font-semibold" %>'>
            <%# Eval("RequestedRole") %>
        </span>
    </ItemTemplate>
</asp:TemplateField>


                    <asp:TemplateField HeaderText="Actions">
                        <HeaderStyle CssClass="py-3 px-4 text-center" />
                        <ItemStyle CssClass="py-3 px-4 text-center" />

                        <ItemTemplate>

                            <asp:Button ID="btnApprove" runat="server" Text="Approve"
                                CommandName="ApproveUser"
                                CommandArgument='<%# Eval("PendingID") %>'
                                CssClass="bg-green-600 text-white px-4 py-2 rounded text-sm mr-2 hover:bg-green-700 transition" />

                            <asp:Button ID="btnReject" runat="server" Text="Reject"
                                CommandName="RejectUser"
                                CommandArgument='<%# Eval("PendingID") %>'
                                CssClass="bg-red-500 text-white px-4 py-2 rounded text-sm hover:bg-red-600 transition" />

                        </ItemTemplate>
                    </asp:TemplateField>

                </Columns>

            </asp:GridView>
        </div>

        <!-- BACK LINK -->
        <a href="AdminView.aspx"
           class="text-red-600 font-semibold mt-6 inline-block hover:text-red-700">
            ← Back to Admin Dashboard
        </a>

    </div>

</form>

</body>
</html>
