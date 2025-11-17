<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AdminView.aspx.cs" Inherits="WebApplication7.AdminView" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin View</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://unpkg.com/lucide@latest"></script>
</head>

<body class="bg-gray-50 flex">

    <!-- SIDEBAR -->
    <div class="w-64 h-screen bg-gray-900 text-white flex flex-col fixed top-0 left-0">

        <div class="p-6 border-b border-gray-700">
            <h1 class="text-xl font-bold flex gap-0.5">
                <span class="text-red-500 drop-shadow-[0_0_3px_rgba(255,0,0,0.4)]">Valo</span>
                <span class="text-yellow-400 drop-shadow-[0_0_3px_rgba(255,215,0,0.4)]">Pro</span>
            </h1>
            <p class="text-xs text-gray-400 mt-1">Admin Control Panel</p>
        </div>

        <nav class="flex-1 p-4 space-y-2">

            <button onclick="loadPage('dashboard')"
                    class="w-full text-left px-3 py-2 rounded hover:bg-gray-700 flex items-center gap-2">
                <i data-lucide="layout-dashboard"></i> Dashboard
            </button>

            <a href="PendingRegistrations.aspx"
               class="w-full text-left px-3 py-2 rounded hover:bg-gray-700 flex items-center gap-2">
                <i data-lucide="user-check"></i> Pending Registrations
            </a>

            <button onclick="loadPage('users')"
                    class="w-full text-left px-3 py-2 rounded hover:bg-gray-700 flex items-center gap-2">
                <i data-lucide="users"></i> Manage Users
            </button>

            <button onclick="loadPage('content')"
                    class="w-full text-left px-3 py-2 rounded hover:bg-gray-700 flex items-center gap-2">
                <i data-lucide="folder"></i> Content Management
            </button>

            <button onclick="loadPage('profile')"
                    class="w-full text-left px-3 py-2 rounded hover:bg-gray-700 flex items-center gap-2">
                <i data-lucide="user"></i> Profile
            </button>

        </nav>

        <div class="p-4 border-t border-gray-700">
            <!-- ADMIN INFO LABEL -->
            <asp:Label ID="lblAdminInfo" runat="server"
                CssClass="block text-xs text-gray-400 mb-3"></asp:Label>

            <!-- LOGOUT -->
            <a href="Logout.aspx" class="text-red-400 hover:text-red-300 text-sm flex items-center gap-2">
                <i data-lucide="log-out"></i> Logout
            </a>
        </div>

    </div>

    <!-- MAIN CONTENT -->
    <div id="app" class="flex-1 ml-64 overflow-y-auto"></div>


    <!-- ADMIN JS -->
    <script>

        /* --------------------- ADMIN PAGES ---------------------- */

        const AdminDashboard = () => `
    <div class="p-10 w-full">

        <h2 class="text-3xl font-bold mb-6">Admin Dashboard</h2>

        <!-- STAT CARDS -->
        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6 mb-8 w-full">

            <div class="p-6 border-2 border-dashed border-gray-300 rounded-lg flex items-center gap-4">
                <div class="p-3 bg-red-100 text-red-600 rounded-full">
                    <i data-lucide="user-check" class="w-6 h-6"></i>
                </div>
                <div>
                    <p id="dashboard_pending" class="text-3xl font-bold">0</p>
                    <p class="uppercase text-xs text-gray-500">Pending Registrations</p>
                </div>
            </div>

            <div class="p-6 border-2 border-dashed border-gray-300 rounded-lg flex items-center gap-4">
                <div class="p-3 bg-red-100 text-red-600 rounded-full">
                    <i data-lucide="users" class="w-6 h-6"></i>
                </div>
                <div>
                    <p id="dashboard_users" class="text-3xl font-bold">0</p>
                    <p class="uppercase text-xs text-gray-500">Total Users</p>
                </div>
            </div>

           

        </div>

        <!-- QUICK ACTIONS -->
        <div class="border-2 border-dashed border-gray-300 p-6 rounded-lg">
            <h3 class="font-bold mb-3">Quick Actions</h3>

            <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4 w-full">

                <a href="PendingRegistrations.aspx"
                   class="border p-4 rounded bg-white hover:bg-gray-100 shadow text-center">
                   Review Pending Registrations
                </a>

                <button onclick="loadPage('users')"
                    class="border p-4 rounded bg-white hover:bg-gray-100 shadow text-center">
                    Manage Users
                </button>

                <!-- NEW BUTTON: PROFILE -->
                <button onclick="loadPage('profile')"
                    class="border p-4 rounded bg-white hover:bg-gray-100 shadow text-center">
                    Profile Settings
                </button>

            </div>
        </div>

    </div>
`;


        /* ------------- MANAGE USERS (dynamic table + modal) ------------- */

        const ManageUsers = () => `
    <div class="p-10">
        <h2 class="text-3xl font-bold mb-6">Manage Users</h2>

        <div class="border-2 border-dashed border-gray-300 p-6 rounded-lg">

            <div class="flex items-center justify-between mb-4">
                <input id="user_search"
                    class="border p-2 rounded w-1/3"
                    placeholder="Search by username or email..." />
                <span id="user_count" class="text-sm text-gray-500"></span>
            </div>

            <div class="overflow-x-auto">
                <table class="w-full text-left text-sm">
                    <thead>
                        <tr class="border-b bg-gray-50 text-xs uppercase text-gray-500">
                            <th class="py-2 pr-2">ID</th>
                            <th class="py-2 pr-2">Username</th>
                            <th class="py-2 pr-2">Email</th>
                            <th class="py-2 pr-2">Role</th>
                            <th class="py-2 pr-2">Status</th>
                            <th class="py-2 pr-2 text-center">Actions</th>
                        </tr>
                    </thead>
                    <tbody id="users_tbody"></tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- EDIT MODAL -->
    <div id="edit_modal"
         class="fixed inset-0 bg-black/40 hidden items-center justify-center z-50">
        <div class="bg-white rounded-lg p-6 w-full max-w-md space-y-4 shadow-lg">
            <h3 class="text-xl font-bold mb-2">Edit User</h3>

            <input type="hidden" id="edit_user_id" />

            <div>
                <label class="block text-sm font-semibold mb-1">Username</label>
                <input id="edit_username"
                       class="w-full p-2 border rounded bg-gray-100"
                       disabled />
            </div>

            <div>
                <label class="block text-sm font-semibold mb-1">Email</label>
                <input id="edit_email"
                       class="w-full p-2 border rounded bg-gray-100"
                       disabled />
            </div>

            <div class="grid grid-cols-2 gap-4">
                <div>
                    <label class="block text-sm font-semibold mb-1">Role</label>
                    <select id="edit_role" class="w-full p-2 border rounded">
                        <option>Member</option>
                        <option>Coach</option>
                        <option>Admin</option>
                    </select>
                </div>

                <div>
                    <label class="block text-sm font-semibold mb-1">Status</label>
                    <select id="edit_status" class="w-full p-2 border rounded">
                        <option>Active</option>
                        <option>Inactive</option>
                    </select>
                </div>
            </div>

            <div class="flex justify-end gap-3 pt-2">
                <button type="button"
                        onclick="closeEditModal()"
                        class="px-4 py-2 rounded border text-sm">
                    Cancel
                </button>
                <button type="button"
                        onclick="saveUserChanges()"
                        class="px-4 py-2 rounded bg-red-600 text-white text-sm font-semibold">
                    Save Changes
                </button>
            </div>
        </div>
    </div>
`;

        const ContentManagement = () => `
            <div class="p-10">
                <h2 class="text-3xl font-bold mb-6">Content Management</h2>

                <div class="border-2 border-dashed border-gray-300 p-6 rounded-lg space-y-6">
                    <div>
                        <p class="text-sm font-semibold">Upload New Guide</p>
                        <div class="border p-3 rounded bg-gray-50 mt-1">Upload field placeholder</div>
                    </div>

                    <div>
                        <p class="text-sm font-semibold">Existing Content</p>
                        <ul class="list-disc ml-6 text-gray-600 mt-2">
                            <li>Beginner Aim Guide</li>
                            <li>Agent Ability Breakdown</li>
                            <li>Map Callouts v2</li>
                        </ul>
                    </div>
                </div>
            </div>
        `;

        const AdminProfile = () => `
<div class="p-10 flex justify-center">
    <div class="max-w-3xl w-full border-2 border-gray-300 p-8 bg-white rounded-lg space-y-10">

        <!-- HEADER -->
        <div class="border-b pb-6">
            <h1 class="text-3xl font-bold text-gray-800">Profile Settings</h1>
        </div>

        <!-- NON-EDITABLE ACCOUNT INFO -->
        <div class="border-b pb-8">
            <h3 class="font-semibold text-gray-700 mb-4">Account Information (Not Editable)</h3>

            <div class="grid grid-cols-2 gap-4">

                <div>
                    <label class="block text-sm font-semibold mb-1">Admin Username</label>
                    <input id="acc_username" type="text"
                           class="w-full p-3 border rounded bg-gray-100 text-gray-500" disabled>
                </div>

                <div>
                    <label class="block text-sm font-semibold mb-1">Email</label>
                    <input id="acc_email" type="text"
                           class="w-full p-3 border rounded bg-gray-100 text-gray-500" disabled>
                </div>

                <div class="col-span-2">
                    <label class="block text-sm font-semibold mb-1">Password</label>

                    <div class="flex items-center gap-3 w-full">
                        <input id="acc_password" type="password"
                               readonly
                               class="w-full p-3 border rounded bg-gray-100 text-gray-500">

                        <button type="button" onclick="togglePassword()"
                                class="p-2 text-gray-600 hover:text-black">
                            <i id="pwd_icon" data-lucide="eye"></i>
                        </button>
                    </div>
                </div>

            </div>
        </div>

        <!-- EDITABLE ADMIN PROFILE -->
        <div class="space-y-6">
            <h3 class="font-semibold text-gray-700">Admin Profile (Editable)</h3>

            <div class="grid grid-cols-2 gap-4">

                <div>
                    <label class="block text-sm font-semibold mb-1">Full Name</label>
                    <input id="fullname" type="text" class="w-full p-3 border rounded">
                </div>

                <div>
                    <label class="block text-sm font-semibold mb-1">Phone Number</label>
                    <input id="phone" type="text"
                           minlength="8"
                           class="w-full p-3 border rounded"
                           placeholder="Min 8 digits"
                           oninput="validatePhone(this)">
                </div>

                <div>
                    <label class="block text-sm font-semibold mb-1">Region</label>
                    <select id="region" class="w-full p-3 border rounded">
                        <option>Asia</option>
                        <option>Europe</option>
                        <option>North America</option>
                        <option>South America</option>
                        <option>Oceania</option>
                        <option>Africa</option>
                    </select>
                </div>

                <div>
                    <label class="block text-sm font-semibold mb-1">Gender</label>
                    <select id="gender" class="w-full p-3 border rounded">
                        <option>Male</option>
                        <option>Female</option>
                        <option>Non-binary</option>
                        <option>Prefer not to say</option>
                    </select>
                </div>

                <div>
                    <label class="block text-sm font-semibold mb-1">Age</label>
                    <input id="age" type="number" class="w-full p-3 border rounded">
                </div>

            </div>
        </div>

        <!-- SAVE BUTTON -->
        <div class="pt-4">
            <button onclick="saveAdminProfile()"
                class="bg-red-600 text-white px-6 py-3 rounded-lg font-bold w-full">
                Save Changes
            </button>
        </div>

    </div>
</div>
`;

        /* -----------------------------------------------------
           VALIDATION
        ------------------------------------------------------ */

        function validatePhone(input) {
            input.value = input.value.replace(/[^0-9]/g, "");
        }

        /* -----------------------------------------------------
           LOAD ADMIN ACCOUNT (Non-editable)
        ------------------------------------------------------ */

        function loadAdminAccount() {
            fetch("AdminView.aspx/LoadAdminAccountInfo", {
                method: "POST",
                headers: { "Content-Type": "application/json; charset=utf-8" },
                body: "{}"
            })
                .then(r => r.json())
                .then(res => {
                    const d = res.d || {};
                    document.getElementById("acc_username").value = d.Username || "";
                    document.getElementById("acc_email").value = d.Email || "";

                    const p = document.getElementById("acc_password");
                    p.type = "text";
                    p.value = d.Password || "";
                    setTimeout(() => p.type = "password", 50);
                });
        }

        /* -----------------------------------------------------
           LOAD ADMIN PROFILE (Editable)
        ------------------------------------------------------ */

        function loadAdminProfileData() {
            fetch("AdminView.aspx/LoadAdminProfile", {
                method: "POST",
                headers: { "Content-Type": "application/json; charset=utf-8" },
                body: "{}"
            })
                .then(r => r.json())
                .then(res => {
                    const d = res.d || {};

                    document.getElementById("fullname").value = d.FullName || "";
                    document.getElementById("phone").value = d.Phone || "";
                    document.getElementById("region").value = d.Region || "Asia";
                    document.getElementById("gender").value = d.Gender || "Male";
                    document.getElementById("age").value = d.Age || "";
                });
        }

        /* -----------------------------------------------------
           SAVE ADMIN PROFILE
        ------------------------------------------------------ */

        function saveAdminProfile() {

            let phone = document.getElementById("phone").value;
            if (phone.length < 8) {
                alert("Phone number must be at least 8 digits.");
                return;
            }

            const payload = {
                fullname: document.getElementById("fullname").value,
                phone: phone,
                region: document.getElementById("region").value,
                gender: document.getElementById("gender").value,
                age: document.getElementById("age").value
            };

            fetch("AdminView.aspx/SaveAdminProfile", {
                method: "POST",
                headers: { "Content-Type": "application/json; charset=utf-8" },
                body: JSON.stringify(payload)
            })
                .then(r => r.json())
                .then(res => {
                    if (res.d && res.d.status === "success") alert("Profile saved!");
                    else alert("Error: " + (res.d ? res.d.error : "Unknown error"));
                });
        }

        /* -----------------------------------------------------
           PASSWORD TOGGLE
        ------------------------------------------------------ */

        function togglePassword() {
            const p = document.getElementById("acc_password");
            const icon = document.getElementById("pwd_icon");

            if (p.type === "password") {
                p.type = "text";
                icon.setAttribute("data-lucide", "eye-off");
            } else {
                p.type = "password";
                icon.setAttribute("data-lucide", "eye");
            }

            lucide.createIcons();
        }

        /* ================= DASHBOARD COUNTS ==================== */

        function loadDashboardCounts() {
            fetch("AdminView.aspx/GetDashboardCounts", {
                method: "POST",
                headers: { "Content-Type": "application/json; charset=utf-8" },
                body: "{}"
            })
                .then(r => r.json())
                .then(res => {
                    const d = res.d || res || {};

                    const pendingEl = document.getElementById("dashboard_pending");
                    const usersEl = document.getElementById("dashboard_users");

                    if (pendingEl) pendingEl.textContent = (d.Pending != null ? d.Pending : 0);
                    if (usersEl) usersEl.textContent = (d.TotalUsers != null ? d.TotalUsers : 0);
                })
                .catch(err => console.error("Dashboard counts error:", err));
        }

        /* ================= MANAGE USERS JS ==================== */

        let allUsers = [];

        function fetchUsers(searchTerm) {
            fetch("AdminView.aspx/LoadAllUsers", {
                method: "POST",
                headers: { "Content-Type": "application/json; charset=utf-8" },
                body: JSON.stringify({ search: searchTerm || "" })
            })
                .then(r => r.json())
                .then(res => {
                    if (res.d && res.d.error) {
                        alert("Error: " + res.d.error);
                        return;
                    }
                    allUsers = (res.d && res.d.users) || [];
                    renderUsersTable(allUsers);
                });
        }

        function renderUsersTable(list) {
            const tbody = document.getElementById("users_tbody");
            if (!tbody) return;

            tbody.innerHTML = list.map(u => `
        <tr class="border-b">
            <td class="py-2 pr-2 text-xs text-gray-500">${u.UserID}</td>
            <td class="py-2 pr-2">${u.Username}</td>
            <td class="py-2 pr-2">${u.Email}</td>
            <td class="py-2 pr-2">${u.Role}</td>
            <td class="py-2 pr-2">
                <span class="px-2 py-1 rounded text-xs ${u.Status === "Active"
                    ? "bg-green-100 text-green-700"
                    : "bg-gray-200 text-gray-700"
                }">
                    ${u.Status}
                </span>
            </td>
            <td class="py-2 pr-2 text-center">
                <button onclick="openEditModal(${u.UserID})"
                        class="inline-flex items-center justify-center w-8 h-8 rounded hover:bg-gray-100">
                    <i data-lucide="pencil" class="w-4 h-4 text-blue-600"></i>
                </button>
            </td>
        </tr>
    `).join("");

            lucide.createIcons();
        }

        function openEditModal(userId) {
            const u = allUsers.find(x => x.UserID === userId);
            if (!u) return;

            document.getElementById("edit_user_id").value = u.UserID;
            document.getElementById("edit_username").value = u.Username;
            document.getElementById("edit_email").value = u.Email;
            document.getElementById("edit_role").value = u.Role || "Member";
            document.getElementById("edit_status").value = u.Status || "Active";

            const modal = document.getElementById("edit_modal");
            modal.classList.remove("hidden");
            modal.classList.add("flex");
        }

        function closeEditModal() {
            const modal = document.getElementById("edit_modal");
            if (!modal) return;
            modal.classList.add("hidden");
            modal.classList.remove("flex");
        }

        function saveUserChanges() {
            const id = parseInt(document.getElementById("edit_user_id").value, 10);
            const role = document.getElementById("edit_role").value;
            const status = document.getElementById("edit_status").value;

            fetch("AdminView.aspx/UpdateUserRoleStatus", {
                method: "POST",
                headers: { "Content-Type": "application/json; charset=utf-8" },
                body: JSON.stringify({ userId: id, role: role, status: status })
            })
                .then(r => r.json())
                .then(res => {
                    if (res.d && res.d.status === "success") {
                        alert("User updated.");
                        closeEditModal();
                        const term = document.getElementById("user_search")?.value || "";
                        fetchUsers(term.trim());
                        // also refresh dashboard numbers
                        loadDashboardCounts();
                    } else {
                        alert("Error: " + (res.d ? res.d.error : "Unknown error"));
                    }
                });
        }

        /* --------------------- ROUTING ---------------------- */

        function loadPage(page) {
            const pages = {
                dashboard: AdminDashboard(),
                users: ManageUsers(),
                content: ContentManagement(),
                profile: AdminProfile(),
            };

            document.getElementById("app").innerHTML = pages[page];
            lucide.createIcons();

            if (page === "dashboard") {
                setTimeout(() => {
                    loadDashboardCounts();
                }, 50);
            }

            if (page === "profile") {
                setTimeout(() => {
                    loadAdminAccount();
                    loadAdminProfileData();
                }, 50);
            }

            if (page === "users") {
                setTimeout(() => {
                    fetchUsers("");

                    const search = document.getElementById("user_search");
                    if (search) {
                        search.addEventListener("input", (e) => {
                            fetchUsers(e.target.value.trim());
                        });
                    }
                }, 50);
            }
        }

        // default
        loadPage("dashboard");

    </script>

</body>
</html>
