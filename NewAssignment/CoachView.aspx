<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CoachView.aspx.cs" Inherits="WebApplication7.CoachView" %>

<!DOCTYPE html>
<html>
<head>
    <title>Coach View</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://unpkg.com/lucide@latest"></script>
</head>

<body class="bg-gray-50 flex">

    <!-- SIDEBAR (FIXED) -->
    <div class="w-64 h-screen bg-gray-900 text-white flex flex-col fixed top-0 left-0">
        <div class="p-6 border-b border-gray-700">
            <h1 class="text-xl font-bold flex gap-0.5">
                <span class="text-red-500 drop-shadow-[0_0_3px_rgba(255,0,0,0.4)]">Valo</span>
                <span class="text-yellow-400 drop-shadow-[0_0_3px_rgba(255,215,0,0.4)]">Pro</span>
            </h1>
            <p class="text-xs text-gray-400 mt-1">Coach Control Panel</p>
        </div>

        <nav class="flex-1 p-4 space-y-2">
            <button onclick="loadPage('dashboard')" class="w-full text-left px-3 py-2 rounded hover:bg-gray-700 flex items-center gap-2 text-sm">
                <i data-lucide="layout-dashboard"></i> Dashboard
            </button>

            <button onclick="loadPage('availability')" class="w-full text-left px-3 py-2 rounded hover:bg-gray-700 flex items-center gap-2 text-sm">
                <i data-lucide="calendar"></i> Manage Availability
            </button>

            <button onclick="loadPage('requests')" class="w-full text-left px-3 py-2 rounded hover:bg-gray-700 flex items-center gap-2 text-sm">
                <i data-lucide="inbox"></i> Booking Requests
            </button>

            <button onclick="loadPage('sessions')" class="w-full text-left px-3 py-2 rounded hover:bg-gray-700 flex items-center gap-2 text-sm">
                <i data-lucide="history"></i> Coach Sessions
            </button>

            <button onclick="loadPage('upload')" class="w-full text-left px-3 py-2 rounded hover:bg-gray-700 flex items-center gap-2 text-sm">
                <i data-lucide="upload"></i> Upload Coaching Profile
            </button>

            <button onclick="loadPage('communication')" class="w-full text-left px-3 py-2 rounded hover:bg-gray-700 flex items-center gap-2 text-sm">
                <i data-lucide="messages-square"></i> Student Communication
            </button>

            <button onclick="loadPage('profile')" class="w-full text-left px-3 py-2 rounded hover:bg-gray-700 flex items-center gap-2 text-sm">
                <i data-lucide="user"></i> Profile
            </button>
        </nav>

        <div class="p-4 border-t border-gray-700">
            <a href="Logout.aspx" class="text-red-400 hover:text-red-300 text-sm flex items-center gap-2">
                <i data-lucide="log-out"></i> Logout
            </a>
        </div>
    </div>

    <!-- PAGE CONTENT (SHIFTED RIGHT) -->
    <div id="app" class="flex-1 ml-64 overflow-y-auto"></div>

    <!-- JAVASCRIPT LOGIC -->
    <script>
        /* -------------------- COACH PAGES -------------------- */

        const CoachDashboard = () => `
            <div class="p-10">
                <h2 class="text-3xl font-bold mb-6">Coach Dashboard</h2>

                <div class="grid grid-cols-3 gap-4 mb-8">
                    ${[
                { label: 'Total Sessions', value: '47' },
                { label: 'Pending Requests', value: '3' },
                { label: 'Rating', value: '4.8 ★' }
            ].map(x => `
                        <div class="p-6 border-2 border-dashed border-gray-300 rounded-lg text-center">
                            <p class="text-3xl font-bold">${x.value}</p>
                            <p class="text-xs text-gray-500 uppercase">${x.label}</p>
                        </div>
                    `).join('')}
                </div>

                <div class="border-2 border-dashed border-gray-300 p-6 rounded-lg">
                    <h3 class="text-lg font-bold mb-4">Upcoming Sessions</h3>
                    ${[1, 2].map(i => `
                        <div class="flex justify-between items-center p-4 bg-white border rounded mb-3">
                            <div>
                                <p class="font-bold">Session with Student ${i}</p>
                                <p class="text-xs text-gray-500">Nov 20 • 3:00 PM</p>
                            </div>
                            <button class="bg-gray-200 px-4 py-1 rounded">Start</button>
                        </div>
                    `).join('')}
                </div>
            </div>
        `;

        const ManageAvailability = () => `
            <div class="p-10">
                <h2 class="text-3xl font-bold mb-6">Manage Availability</h2>

                <div class="border-2 border-dashed border-gray-300 p-6 rounded-lg">
                    ${['Monday', 'Tuesday', 'Wednesday'].map(day => `
                        <div class="flex items-center gap-4 mb-4">
                            <p class="font-bold w-24">${day}</p>

                            <div class="flex gap-2">
                                ${[9, 10, 11, 13, 14, 15].map(time => `
                                    <div class="px-3 py-2 text-xs border rounded cursor-pointer 
                                        ${time % 2 === 0
                ? 'bg-green-100 border-green-300 text-green-700'
                : 'bg-white border-gray-300 text-gray-500'}">
                                        ${time}:00
                                    </div>
                                `).join('')}
                            </div>
                        </div>
                    `).join('')}

                    <button class="mt-6 bg-red-600 text-white px-6 py-2 rounded font-bold">Save</button>
                </div>
            </div>
        `;

        /* -------------------- BOOKING REQUESTS -------------------- */

        const BookingRequests = () => `
    <div class="p-10">
        <h2 class="text-3xl font-bold mb-6">Booking Requests</h2>

        <div id="booking_cards" class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div class="col-span-2 text-center text-gray-400 text-sm">
                Loading booking requests...
            </div>
        </div>
    </div>
`;


        const CoachSessions = () => `
<div class="p-10">
    <h2 class="text-3xl font-bold mb-6">My Sessions</h2>

    <div id="coach_sessions" class="space-y-4">
        <div class="text-gray-400">Loading sessions...</div>
    </div>
</div>
`;


        /* -------------------- UPLOAD COACHING INFO -------------------- */

        const UploadMaterialsPage = () => `
            <div class="p-10">
                <h2 class="text-3xl font-bold mb-6">Upload Coaching Info</h2>

                <div class="border-2 border-dashed border-gray-300 p-8 rounded-lg space-y-6 bg-white">

                    <div>
                        <p class="font-bold mb-2">Title</p>
                        <input id="service_title"
                               class="w-full border rounded p-3"
                               placeholder="e.g., Aim Training & Gamesense Coaching" />
                    </div>

                    <div>
                        <p class="font-bold mb-2">Description</p>
                        <textarea id="service_desc"
                                  class="w-full border rounded p-3 h-32 resize-none"
                                  placeholder="Describe your coaching style, what students will learn, etc."></textarea>
                    </div>

                    <div>
                        <p class="font-bold mb-2">Price per hour (USD)</p>
                        <input id="service_price"
                               type="number"
                               step="0.01"
                               min="0"
                               class="w-40 border rounded p-2"
                               placeholder="20.00" />
                        <p class="text-xs text-gray-500 mt-1">
                            Enter numbers only. This price will appear on the Book Coaching page.
                        </p>
                    </div>

                    <button type="button"
                            onclick="saveCoachService()"
                            class="bg-red-600 text-white px-6 py-2 rounded font-bold">
                        Update
                    </button>

                </div>
            </div>
        `;

        const StudentCommunicationPage = () => `
            <div class="p-10">
                <h2 class="text-3xl font-bold mb-6">Student Communication</h2>

                <div class="border flex h-[500px] rounded-lg overflow-hidden">

                    <div class="w-1/3 bg-gray-50 border-r p-4">
                        <p class="font-bold mb-3">Inbox</p>

                        ${[1, 2, 3].map(i => `
                            <div class="p-3 bg-white rounded shadow mb-2 cursor-pointer">
                                <p class="font-bold text-sm">Student ${i}</p>
                                <p class="text-xs text-gray-400">Hey coach…</p>
                            </div>
                        `).join('')}
                    </div>

                    <div class="w-2/3 flex flex-col bg-white">
                        <div class="p-4 border-b flex justify-between">
                            <p class="font-bold">Student 1</p>
                        </div>

                        <div class="flex-1 p-4 space-y-3 bg-gray-50 overflow-y-auto">
                            <div class="p-3 bg-white border rounded-lg w-3/4">Hello coach, can we resched?</div>
                            <div class="p-3 bg-red-600 text-white rounded-lg w-3/4 ml-auto">Sure, what time?</div>
                        </div>

                        <div class="p-4 border-t">
                            <div class="border p-3 rounded text-gray-400">Type message…</div>
                        </div>

                    </div>

                </div>
            </div>
        `;

        /* -------------------- PROFILE PAGE -------------------- */

        const ProfilePage = () => `
            <div class="p-10 flex justify-center">
                <div class="max-w-2xl w-full border-2 border-gray-300 p-8 rounded-lg bg-white space-y-10">

                    <!-- HEADER -->
                    <div class="border-b pb-6">
                        <h1 class="text-3xl font-bold text-gray-800">Profile Settings</h1>
                    </div>

                    <!-- NON-EDITABLE ACCOUNT INFO -->
                    <div class="border-b pb-6">
                        <h3 class="font-semibold text-gray-700 mb-4">Account Information (Not Editable)</h3>

                        <div class="grid grid-cols-2 gap-4">

                            <div>
                                <label class="block text-sm font-semibold mb-1">Account Username</label>
                                <input id="acc_username"
                                       class="w-full p-3 border rounded bg-gray-100 text-gray-500"
                                       disabled />
                            </div>

                            <div>
                                <label class="block text-sm font-semibold mb-1">Email</label>
                                <input id="acc_email"
                                       class="w-full p-3 border rounded bg-gray-100 text-gray-500"
                                       disabled />
                            </div>

                            <div class="col-span-2">
                                <label class="block text-sm font-semibold mb-1">Password</label>
                                <div class="flex items-center gap-3">
                                    <input id="acc_password"
                                           type="password"
                                           readonly
                                           class="w-full p-3 border rounded bg-gray-100 text-gray-500" />

                                    <button type="button" onclick="togglePassword()"
                                            class="p-2 text-gray-600 hover:text-black">
                                        <i id="pwd_icon" data-lucide="eye"></i>
                                    </button>
                                </div>
                            </div>

                        </div>
                    </div>

                    <!-- EDITABLE COACH PROFILE -->
                    <div class="space-y-6">
                        <h3 class="font-semibold text-gray-700">Coach Profile (Editable)</h3>

                        <div class="grid grid-cols-2 gap-4">

                            <div>
                                <label class="block text-sm font-semibold mb-1">Real Name</label>
                                <input id="fullname" type="text" class="w-full p-3 border rounded">
                            </div>

                            <div>
                                <label class="block text-sm font-semibold mb-1">Player Username</label>
                                <input id="playerusername" class="w-full p-3 border rounded">
                            </div>

                            <div>
                                <label class="block text-sm font-semibold mb-1">Riot ID</label>
                                <input id="riotid" class="w-full p-3 border rounded" placeholder="Player#1234">
                                <p class="text-xs text-gray-400">Format: Username#Tag (required)</p>
                            </div>

                            <div>
                                <label class="block text-sm font-semibold mb-1">Rank</label>
                                <select id="rank" class="w-full p-3 border rounded">
                                    <option>Iron</option>
                                    <option>Bronze</option>
                                    <option>Silver</option>
                                    <option>Gold</option>
                                    <option>Platinum</option>
                                    <option>Diamond</option>
                                    <option>Ascendant</option>
                                    <option>Immortal</option>
                                    <option>Radiant</option>
                                </select>
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
                        <button onclick="saveCoachProfile()"
                                class="bg-red-600 text-white px-6 py-3 rounded-lg font-bold w-full">
                            Save Changes
                        </button>
                    </div>

                </div>
            </div>
        `;

        /* -------------------- ACCOUNT + PROFILE LOADERS -------------------- */

        function loadCoachAccount() {
            fetch("CoachView.aspx/LoadCoachAccountInfo", {
                method: "POST",
                headers: { "Content-Type": "application/json; charset=utf-8" },
                body: "{}"
            })
                .then(r => r.json())
                .then(res => {
                    const d = res.d;

                    acc_username.value = d.Username;
                    acc_email.value = d.Email;

                    // show password briefly then hide
                    acc_password.type = "text";
                    acc_password.value = d.Password;
                    setTimeout(() => acc_password.type = "password", 50);
                });
        }

        function loadCoachProfileData() {
            fetch("CoachView.aspx/LoadCoachProfile", {
                method: "POST",
                headers: { "Content-Type": "application/json; charset=utf-8" },
                body: "{}"
            })
                .then(r => r.json())
                .then(res => {
                    const d = res.d || {};

                    fullname.value = d.FullName || "";
                    playerusername.value = d.PlayerUsername || "";
                    riotid.value = d.RiotID || "";
                    rank.value = d.Rank || "Iron";
                    region.value = d.Region || "Asia";
                    gender.value = d.Gender || "Male";
                    age.value = d.Age || "";
                });
        }

        function saveCoachProfile() {
            const riot = riotid.value.trim();
            if (!riot.includes("#")) {
                alert("Riot ID must be in the format Username#Tag");
                return;
            }

            const payload = {
                fullname: fullname.value,
                playerusername: playerusername.value,
                riotid: riot,
                rank: rank.value,
                region: region.value,
                gender: gender.value,
                age: age.value
            };

            fetch("CoachView.aspx/SaveCoachProfile", {
                method: "POST",
                headers: { "Content-Type": "application/json; charset=utf-8" },
                body: JSON.stringify(payload)
            })
                .then(r => r.json())
                .then(res => {
                    if (res.d.status === "success") alert("Profile saved!");
                    else alert("Error: " + res.d.error);
                });
        }

        function togglePassword() {
            const input = acc_password;
            const icon = document.getElementById("pwd_icon");

            input.type = input.type === "password" ? "text" : "password";
            icon.setAttribute("data-lucide", input.type === "password" ? "eye" : "eye-off");
            lucide.createIcons();
        }

        /* -------------------- COACH SERVICES (TITLE/DESC/PRICE) -------------------- */

        function loadCoachService() {
            fetch("CoachView.aspx/LoadCoachService", {
                method: "POST",
                headers: { "Content-Type": "application/json; charset=utf-8" },
                body: "{}"
            })
                .then(r => r.json())
                .then(res => {
                    const d = res.d || {};
                    const t = document.getElementById("service_title");
                    const desc = document.getElementById("service_desc");
                    const price = document.getElementById("service_price");

                    if (!t || !desc || !price) return;

                    t.value = d.Title || "";
                    desc.value = d.Description || "";
                    price.value = d.PricePerHour ? d.PricePerHour : "";
                })
                .catch(err => console.error(err));
        }

        function saveCoachService() {
            const t = document.getElementById("service_title").value.trim();
            const desc = document.getElementById("service_desc").value.trim();
            const priceStr = document.getElementById("service_price").value.trim();

            if (!priceStr || isNaN(priceStr) || Number(priceStr) <= 0) {
                alert("Please enter a valid price greater than 0.");
                return;
            }

            const payload = {
                title: t,
                description: desc,
                pricePerHour: priceStr
            };

            fetch("CoachView.aspx/SaveCoachService", {
                method: "POST",
                headers: { "Content-Type": "application/json; charset=utf-8" },
                body: JSON.stringify(payload)
            })
                .then(r => r.json())
                .then(res => {
                    if (res.d.status === "success") {
                        alert("Coaching info updated.");
                    } else {
                        alert("Error: " + res.d.error);
                    }
                })
                .catch(err => {
                    console.error(err);
                    alert("Unexpected error while saving.");
                });
        }

        function updateCoachSessionStatus(id, status) {
            fetch("CoachView.aspx/UpdateSessionStatus", {
                method: "POST",
                headers: { "Content-Type": "application/json; charset=utf-8" },
                body: JSON.stringify({ bookingId: id, status: status })
            })
                .then(r => r.json())
                .then(res => console.log(res));
        }


        function loadCoachSessions() {
            fetch("CoachView.aspx/GetMySessions", {
                method: "POST",
                headers: { "Content-Type": "application/json; charset=utf-8" },
                body: "{}"
            })
                .then(r => r.json())
                .then(res => renderCoachSessions(res.d?.sessions || []))
                .catch(err => console.error(err));
        }

        function renderCoachSessions(list) {
            const box = document.getElementById("coach_sessions");
            if (!box) return;

            if (!list.length) {
                box.innerHTML = `<p class="text-gray-400">No confirmed sessions yet.</p>`;
                return;
            }

            box.innerHTML = list.map(s => `
        <div class="border-2 border-dashed p-6 rounded-lg flex justify-between items-center bg-white">
            
            <div>
                <p class="font-bold text-lg">${s.Title}</p>
                <p class="text-sm text-gray-600">${s.Date} • Student: ${s.Student}</p>
            </div>

            <div class="flex items-center gap-4">
                <p class="text-green-600 font-bold">$${s.Price} Paid</p>

                <select onchange="updateCoachSessionStatus(${s.BookingID}, this.value)"
        class="border p-2 rounded">
    <option value="Incomplete" ${s.Status === "Incomplete" ? "selected" : ""}>Incomplete</option>
<option value="Completed" ${s.Status === "Completed" ? "selected" : ""}>Completed</option>

</select>

            </div>
        </div>
    `).join("");
        }

        /* -------------------- BOOKING REQUESTS (FROM MemberView) -------------------- */

        function loadBookingRequests() {
            fetch("CoachView.aspx/GetBookingRequests", {
                method: "POST",
                headers: { "Content-Type": "application/json; charset=utf-8" },
                body: "{}"
            })
                .then(r => r.json())
                .then(res => renderBookingRequests(res.d?.requests || []))
                .catch(err => {
                    console.error(err);
                    renderBookingRequests([]);
                });
        }

        function renderBookingRequests(list) {
            const container = document.querySelector("#booking_cards");
            if (!container) return;

            if (!list.length) {
                container.innerHTML = `
            <div class="col-span-2 text-center text-gray-400">No booking requests yet.</div>`;
                return;
            }

            container.innerHTML = list.map(r => {
                const isPending = r.Status === "Pending";

                const statusColor =
                    r.Status === "Confirmed" ? "bg-green-100 text-green-700"
                        : r.Status === "Rejected" ? "bg-red-100 text-red-700"
                            : "bg-yellow-100 text-yellow-700";

                const statusLabel = r.Status ? r.Status.toUpperCase() : "PENDING";

                const actionButtons = isPending
                    ? `
            <div class="flex gap-2 mt-4">
                <button
                    onclick="updateBookingStatus(${r.BookingID}, 'Confirmed')"
                    class="px-4 py-1 rounded bg-green-600 text-white text-sm font-semibold">
                    Accept
                </button>
                <button
                    onclick="updateBookingStatus(${r.BookingID}, 'Rejected')"
                    class="px-4 py-1 rounded bg-red-100 text-red-600 text-sm font-semibold">
                    Reject
                </button>
            </div>`
                    : "";

                return `
        <div class="border-2 border-dashed border-gray-300 p-6 rounded-lg bg-white">
            <h3 class="font-bold text-xl mb-2">${r.MemberName}</h3>

            <div class="space-y-1 text-sm text-gray-700">
                <p><span class="font-semibold">Phone:</span> ${r.Phone}</p>
                <p><span class="font-semibold">Discord:</span> ${r.DiscordID}</p>
                <p><span class="font-semibold">Session Time:</span> ${r.DateTime}</p>
            </div>

            <div class="mt-3 inline-block px-3 py-1 rounded text-xs font-bold ${statusColor}">
                ${statusLabel}
            </div>

            ${actionButtons}
        </div>`;
            }).join("");

            lucide.createIcons();
        }

        function updateBookingStatus(id, status) {
            fetch("CoachView.aspx/UpdateBookingStatus", {
                method: "POST",
                headers: { "Content-Type": "application/json; charset=utf-8" },
                body: JSON.stringify({ bookingId: id, status: status })
            })
                .then(r => r.json())
                .then(res => {
                    if (res.d?.status === "success") {
                        loadBookingRequests();
                    } else {
                        alert(res.d?.error || "Failed to update booking status.");
                    }
                })
                .catch(err => {
                    console.error(err);
                    alert("Server error updating status.");
                });
        }


        /* -------------------- ROUTER -------------------- */

        function loadPage(page) {
            const pages = {
                dashboard: CoachDashboard(),
                availability: ManageAvailability(),
                requests: BookingRequests(),
                sessions: CoachSessions(),
                upload: UploadMaterialsPage(),
                communication: StudentCommunicationPage(),
                profile: ProfilePage()
            };

            document.getElementById("app").innerHTML = pages[page];
            lucide.createIcons();

            if (page === "requests") {
                setTimeout(loadBookingRequests, 50);
            }

            if (page === "profile") {
                setTimeout(() => {
                    loadCoachAccount();
                    loadCoachProfileData();
                }, 50);
            }

            if (page === "sessions") {
                setTimeout(loadCoachSessions, 50);
            }


            if (page === "upload") {
                setTimeout(() => {
                    loadCoachService();
                }, 50);
            }
        }

        // Default load
        loadPage('dashboard');
    </script>
</body>
</html>
