<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MemberView.aspx.cs" Inherits="WebApplication7.MemberView" %>

<!DOCTYPE html>
<html>
<head>
    <title>ValoPro - Member Dashboard</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://unpkg.com/lucide@latest"></script>
</head>

<body class="bg-gray-50">

<form id="form1" runat="server">

    <!-- NAVBAR -->
    <div class="w-full bg-gray-900 text-white flex justify-between px-6 py-4 items-center">
        <div class="flex gap-6 items-center">
            <h1 class="text-xl font-bold cursor-pointer flex gap-0.5" onclick="loadPage('dashboard')">
                <span class="text-red-500 drop-shadow-[0_0_3px_rgba(255,0,0,0.4)]">Valo</span>
                <span class="text-yellow-400 drop-shadow-[0_0_3px_rgba(255,215,0,0.4)]">Pro</span>
            </h1>

            <a href="#" onclick="loadPage('dashboard')" class="hover:text-red-400">Dashboard</a>
            <a href="#" onclick="loadPage('learning')" class="hover:text-red-400">Learning Resources</a>
            <a href="#" onclick="loadPage('tips')" class="hover:text-red-400">Tips & Tricks</a>
            <a href="#" onclick="loadPage('coaching')" class="hover:text-red-400">Book Coaching</a>
            <a href="#" onclick="loadPage('bookings')" class="hover:text-red-400">My Bookings</a>
            <a href="#" onclick="loadPage('payment')" class="hover:text-red-400">Payments</a>
            <a href="#" onclick="loadPage('profile')" class="hover:text-red-400">Profile</a>
            <a href="#" onclick="loadPage('sessions')" class="hover:text-red-400">My Sessions</a>

        </div>

        <div>
            <a href="Logout.aspx" class="text-red-400 hover:text-red-300">Logout</a>
        </div>
    </div>

    <!-- CONTENT -->
    <div id="app"></div>

</form>

<script>
    // ================= GLOBAL STATE =================
    let selectedCoachID = null;          // which coach we're paying for
    let payValidationTimer = null;       // timer for payment validation

    // ===================================================
    // MEMBER DASHBOARD
    // ===================================================
    const MemberDashboard = () => `
    <div class="p-8">
        <div class="border-b-2 pb-4 mb-6 flex justify-between">
            <h2 class="text-2xl font-bold text-gray-800">Member Dashboard</h2>
            <button onclick="loadPage('profile')" class="text-sm text-red-600 font-bold">Edit Profile</button>
        </div>

        <div class="space-y-6">

            <!-- STATS -->
            <div class="grid grid-cols-4 gap-4">
                ${[
            { label: 'Hours', value: '24.5', icon: 'calendar' },
            { label: 'Guides Read', value: '12', icon: 'book-open' },
            { label: 'Sessions', value: '2', icon: 'video' },
            { label: 'Rank', value: 'Gold 2', icon: 'star' }
        ].map(stat => `
                    <div class="border-2 border-dashed border-gray-300 p-4 rounded-lg flex items-center gap-4">
                        <div class="p-3 bg-red-50 rounded-full text-red-600">
                            <i data-lucide="${stat.icon}" style="width:24px;height:24px"></i>
                        </div>
                        <div>
                            <p class="text-2xl font-bold text-gray-800">${stat.value}</p>
                            <p class="text-xs text-gray-500 uppercase font-bold">${stat.label}</p>
                        </div>
                    </div>
                `).join('')}
            </div>

            <!-- RECENT + UPCOMING -->
            <div class="flex gap-6">
                <div class="flex-1 border-2 border-dashed border-gray-300 p-6 rounded-lg">
                    <h3 class="font-bold mb-4 text-gray-700">Recent Activity</h3>
                    <div class="space-y-3">
                        ${[1, 2, 3].map(x => `
                            <div class="flex items-center gap-3 p-3 bg-gray-50 rounded border border-gray-100">
                                <div class="w-10 h-10 bg-gray-200 rounded flex items-center justify-center text-gray-400">
                                    <i data-lucide="book-open"></i>
                                </div>
                                <div>
                                    <p class="font-semibold text-sm">Read Guide: Vandal Recoil Control</p>
                                    <p class="text-xs text-gray-400">2 hours ago</p>
                                </div>
                            </div>
                        `).join('')}
                    </div>
                </div>

                <div class="w-1/3 border-2 border-dashed border-gray-300 p-6 rounded-lg">
                    <h3 class="font-bold mb-4 text-gray-700">Next Session</h3>
                    <div class="bg-red-600 text-white p-4 rounded-lg text-center">
                        <p class="text-4xl font-bold mb-1">20</p>
                        <p class="uppercase tracking-widest text-sm mb-4">November</p>
                        <p class="font-bold">3:00 PM with Coach Mike</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
`;

    // ===================================================
    // LEARNING RESOURCES
    // ===================================================
    const LearningResources = () => `
<div class="p-8">
    <div class="border-b-2 pb-4 mb-6">
        <h2 class="text-2xl font-bold text-gray-800">Learning Resources</h2>
    </div>

    <div class="space-y-6">

        <!-- Videos -->
        <div class="border-2 border-dashed border-gray-300 p-6 rounded-lg">
            <h3 class="font-bold mb-4">Videos</h3>
            <div class="grid grid-cols-3 gap-4">
                ${[1, 2, 3].map(i => `
                    <div class="border rounded-lg bg-white overflow-hidden">
                        <div class="w-full h-40 bg-gray-900 flex items-center justify-center text-white relative">
                            <i data-lucide="video" style="width:32px;height:32px;"></i>
                        </div>
                        <div class="p-3">
                            <p class="font-semibold text-sm mb-1">Aim Training Routine ${i}</p>
                            <p class="text-xs text-gray-500">10:24 • By ValoPro</p>
                        </div>
                    </div>
                `).join('')}
            </div>
        </div>

        <!-- Infographics -->
        <div class="border-2 border-dashed border-gray-300 p-6 rounded-lg">
            <h3 class="font-bold mb-4">Infographics</h3>
            <div class="grid grid-cols-2 gap-4">
                ${[1, 2].map(i => `
                    <div class="border rounded-lg h-48 bg-gray-100 p-4 flex items-center justify-center">
                        <p class="font-semibold text-gray-400">Map Callouts Infographic ${i}</p>
                    </div>
                `).join('')}
            </div>
        </div>

    </div>
</div>
`;

    const MemberSessions = () => `
<div class="p-8">
    <div class="border-b-2 pb-4 mb-6">
        <h2 class="text-2xl font-bold">My Coaching Sessions</h2>
    </div>

    <div id="member_sessions" class="space-y-4">
        <div class="text-gray-400">Loading sessions...</div>
    </div>
</div>
`;


    // ===================================================
    // TIPS & TRICKS
    // ===================================================
    const TipsAndTricksPage = () => `
<div class="p-8">
    <div class="border-b-2 pb-4 mb-6">
        <h2 class="text-2xl font-bold text-gray-800">Tips & Tricks</h2>
        <p class="text-sm text-gray-600">Gameplay improvement guides</p>
    </div>

    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
        ${[
            'Always keep your crosshair at head level.',
            'Use utility to clear corners.',
            'Don’t reload after one kill.',
            'Communicate constantly.'
        ].map((tip, i) => `
            <div class="flex items-start gap-3 p-4 bg-yellow-50 border border-yellow-100 rounded-lg">
                <i data-lucide="lightbulb" class="text-yellow-600"></i>
                <div>
                    <p class="font-bold">Tip #${i + 1}</p>
                    <p class="text-sm text-gray-700">${tip}</p>
                </div>
            </div>
        `).join('')}
    </div>
</div>
`;

    // ===================================================
    // BOOK COACHING
    // ===================================================
    const BookCoaching = () => `
<div class="p-8">
    <div class="border-b-2 pb-4 mb-6">
        <h2 class="text-2xl font-bold text-gray-800">Book Coaching</h2>
        <p class="text-sm text-gray-600">Browse available coaches and choose a session.</p>
    </div>

    <div id="coaching_cards"
         class="grid grid-cols-1 md:grid-cols-2 gap-6">
        <div class="col-span-2 text-center text-gray-400 text-sm">
            Loading coaches...
        </div>
    </div>
</div>
`;

    // ===================================================
    // MY BOOKINGS (dummy for now)
    // ===================================================
    const MyBookings = () => `
<div class="p-8">
    <div class="border-b-2 pb-4 mb-6">
        <h2 class="text-2xl font-bold text-gray-800">My Bookings</h2>
    </div>

    <div id="booking_list" class="space-y-4">
        <div class="text-center text-gray-400 text-sm">
            Loading your bookings...
        </div>
    </div>
</div>
`;

    function fetchMyBookings() {
        fetch("MemberView.aspx/GetMyBookings", {
            method: "POST",
            headers: { "Content-Type": "application/json; charset=utf-8" },
            body: "{}"
        })
            .then(r => r.json())
            .then(res => renderMyBookings(res.d?.bookings || []))
            .catch(err => {
                console.error(err);
                renderMyBookings([]);
            });
    }

    function renderMyBookings(list) {
        const container = document.getElementById("booking_list");
        if (!container) return;

        if (!list.length) {
            container.innerHTML = `
            <div class="text-center text-gray-400 text-sm">
                You have no bookings yet.
            </div>`;
            return;
        }

        container.innerHTML = list.map(b => {
            const statusColor =
                b.Status === "Confirmed" ? "bg-green-100 text-green-700"
                    : b.Status === "Rejected" ? "bg-red-100 text-red-700"
                        : "bg-yellow-100 text-yellow-700";

            const statusLabel = (b.Status || "Pending").toUpperCase();

            const priceText = b.PricePerHour && b.PricePerHour > 0
                ? `$${b.PricePerHour.toFixed(2)}/hr`
                : "Contact coach";

            return `
        <div class="border-2 border-dashed border-gray-300 p-6 rounded-lg">
            <div class="flex justify-between items-start gap-4">

                <div class="flex gap-4 items-start">
                    <div class="bg-gray-100 p-3 rounded text-center min-w-[60px]">
                        <p class="text-xs font-bold text-gray-500">${b.Month}</p>
                        <p class="text-xl font-bold">${b.Date}</p>
                    </div>

                    <div>
                        <p class="font-bold text-lg">${b.Title || "Valorant Coaching Session"}</p>
                        <p class="text-sm text-gray-600">${b.Time}</p>

                        <p class="text-sm text-gray-700 mt-1">
                            <span class="font-semibold">Coach:</span>
                            ${b.CoachFullName || b.CoachUsername || "-"}
                        </p>

                        <p class="text-sm text-gray-700">
                            <span class="font-semibold">Price:</span> ${priceText}
                        </p>

                        <p class="text-xs text-gray-500 mt-2">
                            ${b.Description || ""}
                        </p>

                        <span class="inline-block mt-3 text-xs px-2 py-1 rounded font-bold ${statusColor}">
                            ${statusLabel}
                        </span>
                    </div>
                </div>

                <button onclick="cancelBooking(${b.BookingID})"
                        class="text-red-500 hover:text-red-700 mt-1">
                    <i data-lucide="x-circle"></i>
                </button>

            </div>
        </div>`;
        }).join("");

        lucide.createIcons();
    }

    function loadMemberSessions() {
        fetch("MemberView.aspx/GetMemberSessions", {
            method: "POST",
            headers: { "Content-Type": "application/json; charset=utf-8" },
            body: "{}"
        })
            .then(r => r.json())
            .then(res => renderMemberSessions(res.d?.sessions || []))
            .catch(err => console.error(err));
    }

    function renderMemberSessions(list) {
        const box = document.getElementById("member_sessions");
        if (!box) return;

        if (!list.length) {
            box.innerHTML = `<p class="text-gray-400">No completed sessions yet.</p>`;
            return;
        }

        box.innerHTML = list.map(s => `
        <div class="border-2 border-dashed p-6 rounded-lg bg-white flex justify-between">
            <div>
                <p class="font-bold text-lg">${s.Title}</p>
                <p class="text-sm text-gray-600">${s.Date} • ${s.Time}</p>
                <p class="text-sm text-gray-700">Coach: ${s.CoachName}</p>

                <span class="inline-block mt-2 px-2 py-1 text-xs rounded 
                    ${s.SessionStatus === "Completed"
                ? "bg-green-100 text-green-700"
                : "bg-yellow-100 text-yellow-700"}">
                    ${s.SessionStatus || "Incomplete"}
                </span>
            </div>

            <p class="text-green-600 font-bold">$${s.Price} Paid</p>
        </div>
    `).join("");
    }




    function cancelBooking(id) {
        if (!confirm("Cancel this booking?")) return;

        fetch("MemberView.aspx/CancelBooking", {
            method: "POST",
            headers: { "Content-Type": "application/json; charset=utf-8" },
            body: JSON.stringify({ bookingId: id })
        })
            .then(r => r.json())
            .then(res => {
                if (res.d?.status === "success") {
                    fetchMyBookings();
                } else {
                    alert(res.d?.error || "Failed to cancel booking.");
                }
            })
            .catch(err => {
                console.error(err);
                alert("Server error cancelling booking.");
            });
    }

    // ===================================================
    // PAYMENT PAGE (used only after Book Session)
    // ===================================================
    const PaymentPage = () => `
<div class="p-8 flex justify-center">
    <div class="max-w-xl w-full border-2 border-gray-300 p-8 bg-white rounded-lg space-y-8">

        <h2 class="text-2xl font-bold border-b pb-4 mb-4">Payment</h2>

        <div id="payment_warning"
             class="mb-4 text-sm text-red-600 font-semibold hidden">
            No coach selected. Please go to <span class="font-bold">Book Coaching</span>
            and choose a coach first.
        </div>

        <!-- PAYMENT METHOD -->
        <div>
            <p class="font-semibold mb-2">Select Payment Method</p>

            <div class="space-y-2">
                <label class="flex items-center gap-2">
                    <input type="radio" name="paymethod" value="card" onchange="renderPaymentForm()">
                    Credit / Debit Card
                </label>

                <label class="flex items-center gap-2">
                    <input type="radio" name="paymethod" value="fpx" onchange="renderPaymentForm()">
                    FPX Online Banking
                </label>

                <label class="flex items-center gap-2">
                    <input type="radio" name="paymethod" value="tng" onchange="renderPaymentForm()">
                    Touch 'n Go eWallet
                </label>
            </div>
        </div>

        <div id="payment_fields"></div>

        <!-- CONTACT INFO -->
        <div class="space-y-4">
            <div>
                <label class="font-semibold">Phone Number</label>
                <input id="pay_phone" class="w-full p-3 border rounded" placeholder="e.g. 0123456789">
            </div>

            <div>
                <label class="font-semibold">Discord ID</label>
                <input id="pay_discord" class="w-full p-3 border rounded" placeholder="e.g. joe#1234">
            </div>

            <div>
                <label class="font-semibold">Preferred Session Date & Time</label>
                <input id="pay_datetime" type="datetime-local" class="w-full p-3 border rounded">
            </div>
        </div>

        <!-- PAY NOW -->
        <button id="pay_btn" type="button" disabled
                onclick="submitPayment()"
                class="w-full py-3 rounded-lg font-bold text-white bg-gray-400 cursor-not-allowed">
            Pay Now
        </button>

    </div>
</div>
`;

    // ===================================================
    // PAYMENT SUCCESS PAGE (Option 2 style card)
    // ===================================================
    const PaymentSuccessPage = () => `
<div class="p-8 flex justify-center">
    <div class="max-w-xl w-full border-2 border-gray-300 p-10 bg-white rounded-lg text-center space-y-6">

        <div class="flex justify-center">
            <div class="w-16 h-16 rounded-full bg-green-100 flex items-center justify-center">
                <i data-lucide="check-circle" class="w-10 h-10 text-green-600"></i>
            </div>
        </div>

        <h2 class="text-2xl font-bold text-gray-800">Booking Request Submitted</h2>

        <p class="text-gray-600 text-sm leading-relaxed">
            The coach you have applied for will personally contact you with any further information
            via Discord or SMS. Please kindly wait for them to reach out.
        </p>

        <button type="button"
        onclick="loadPage('dashboard')"
        class="bg-red-600 text-white px-6 py-3 rounded-lg font-bold">
    Back to Dashboard
</button>

    </div>
</div>
`;

    // ===================================================
    // PROFILE MANAGEMENT (no avatar)
    // ===================================================
    const ProfileManagement = () => `
<div class="p-8 flex justify-center">
    <div class="max-w-3xl w-full border-2 border-gray-300 p-8 bg-white rounded-lg space-y-8">

        <!-- HEADER -->
        <div class="border-b pb-6">
            <p class="text-3xl font-bold text-gray-800">Profile Settings</p>
            <p class="text-sm text-gray-500 mt-1">Manage your Valorant player profile</p>
        </div>

        <!-- NON-EDITABLE ACCOUNT INFO -->
        <div class="border-b pb-6">
            <h3 class="font-semibold text-gray-700 mb-4">Account Information (Not Editable)</h3>

            <div class="grid grid-cols-2 gap-4">

                <div>
                    <label class="block text-sm font-semibold mb-1">Account Username</label>
                    <input id="acc_username" type="text"
                        class="w-full p-3 border rounded bg-gray-100 text-gray-500" disabled>
                </div>

                <div>
                    <label class="block text-sm font-semibold mb-1">Email Address</label>
                    <input id="acc_email" type="text"
                        class="w-full p-3 border rounded bg-gray-100 text-gray-500" disabled>
                </div>

                <div>
                    <label class="block text-sm font-semibold mb-1">Password</label>

                    <div class="flex items-center gap-2">
                        <input id="acc_password"
                               type="password"
                               readonly
                               class="w-full p-3 border rounded bg-gray-100 text-gray-500">

                        <button type="button" onclick="togglePassword()" class="p-2">
                            <i id="pwd_icon" data-lucide="eye" class="w-5 h-5 text-gray-600"></i>
                        </button>
                    </div>
                </div>

            </div>
        </div>

        <!-- EDITABLE PLAYER PROFILE -->
        <div class="space-y-6">
            <h3 class="font-semibold text-gray-700">Player Profile (Editable)</h3>

            <div class="grid grid-cols-2 gap-4">

                <div>
                    <label class="block text-sm font-semibold mb-1">Player / In-Game Username</label>
                    <input id="playername" type="text" class="w-full p-3 border rounded" placeholder="Your IGN">
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
                    <label class="block text-sm font-semibold mb-1">Favourite Map</label>
                    <input id="favmap" type="text" class="w-full p-3 border rounded" placeholder="e.g., Ascent">
                </div>

                <div>
                    <label class="block text-sm font-semibold mb-1">Favourite Agent</label>
                    <input id="favagent" type="text" class="w-full p-3 border rounded" placeholder="e.g., Jett">
                </div>

                <div>
                    <label class="block text-sm font-semibold mb-1">Favourite Weapon</label>
                    <input id="favweapon" type="text" class="w-full p-3 border rounded" placeholder="e.g., Vandal">
                </div>

                <div>
                    <label class="block text-sm font-semibold mb-1">Platform / Device</label>
                    <select id="device" class="w-full p-3 border rounded">
                        <option>PC</option>
                        <option>Console</option>
                        <option>Mobile</option>
                        <option>Others</option>
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
                    <input id="age" type="number" class="w-full p-3 border rounded" placeholder="Your Age">
                </div>

                <div>
                    <label class="block text-sm font-semibold mb-1">Country</label>
                    <input id="country" type="text" class="w-full p-3 border rounded" placeholder="Your Country">
                </div>

            </div>
        </div>

        <!-- SAVE BUTTON -->
        <div class="pt-4">
            <button type="button" onclick="saveProfile()"
                class="bg-red-600 text-white px-6 py-3 rounded-lg font-bold w-full">
                Save Changes
            </button>
        </div>

    </div>
</div>
`;

    // ===================================================
    // AVATAR UPLOAD (if you later add avatar UI)
    // ===================================================
    function uploadAvatar() {
        const file = document.getElementById("avatar_upload")?.files[0];
        if (!file) return;

        const reader = new FileReader();

        reader.onload = function (e) {
            const base64 = e.target.result.split(",")[1];

            document.getElementById("avatar_img").src = e.target.result;

            fetch("MemberView.aspx/UploadAvatar", {
                method: "POST",
                headers: { "Content-Type": "application/json; charset=utf-8" },
                body: JSON.stringify({ imageBase64: base64 })
            })
                .then(r => r.json())
                .then(res => {
                    if (res.d?.status === "success") {
                        alert("Avatar updated!");
                    }
                });
        };

        reader.readAsDataURL(file);
    }

    // ===================================================
    // PASSWORD SHOW/HIDE
    // ===================================================
    function togglePassword() {
        const pwd = document.getElementById("acc_password");
        const icon = document.getElementById("pwd_icon");

        if (!pwd || !icon) return;

        if (pwd.type === "password") {
            pwd.type = "text";
            icon.setAttribute("data-lucide", "eye-off");
        } else {
            pwd.type = "password";
            icon.setAttribute("data-lucide", "eye");
        }

        lucide.createIcons();
    }

    // ===================================================
    // LOAD ACCOUNT INFO
    // ===================================================
    function loadAccountInfo() {
        fetch("MemberView.aspx/LoadAccountInfo", {
            method: "POST",
            headers: { "Content-Type": "application/json; charset=utf-8" },
            body: "{}"
        })
            .then(res => res.json())
            .then(result => {
                const data = result.d;
                if (!data) return;

                acc_username.value = data.Username;
                acc_email.value = data.Email;

                acc_password.type = "text";
                acc_password.value = data.Password;
                setTimeout(() => acc_password.type = "password", 50);

                if (data.Avatar && document.getElementById("avatar_img")) {
                    avatar_img.src = "data:image/png;base64," + data.Avatar;
                }
            });
    }

    // ===================================================
    // LOAD PROFILE
    // ===================================================
    function loadProfileData() {
        fetch("MemberView.aspx/LoadProfile", {
            method: "POST",
            headers: { "Content-Type": "application/json; charset=utf-8" },
            body: "{}"
        })
            .then(r => r.json())
            .then(result => {
                const d = result.d;
                if (!d) return;

                playername.value = d.PlayerName || "";
                rank.value = d.Rank || "Iron";
                favmap.value = d.FavouriteMap || "";
                favagent.value = d.FavouriteAgent || "";
                favweapon.value = d.FavouriteWeapon || "";
                device.value = d.Device || "PC";
                gender.value = d.Gender || "Male";
                age.value = d.Age || "";
                country.value = d.Country || "";
            });
    }

    // ===================================================
    // SAVE PROFILE
    // ===================================================
    function saveProfile() {
        const payload = {
            playername: playername.value,
            rank: rank.value,
            favmap: favmap.value,
            favagent: favagent.value,
            favweapon: favweapon.value,
            device: device.value,
            gender: gender.value,
            age: age.value,
            country: country.value
        };

        fetch("MemberView.aspx/SaveProfile", {
            method: "POST",
            headers: { "Content-Type": "application/json; charset=utf-8" },
            body: JSON.stringify(payload)
        })
            .then(r => r.json())
            .then(res => {
                if (res.d?.status === "success")
                    alert("Profile saved!");
            });
    }

    // ===================================================
    // LOAD COACHING LIST (for Book Coaching)
    // ===================================================
    function fetchCoachingList() {
        fetch("MemberView.aspx/LoadCoachingList", {
            method: "POST",
            headers: { "Content-Type": "application/json; charset=utf-8" },
            body: "{}"
        })
            .then(r => r.json())
            .then(res => {
                const list = (res.d && res.d.coaches) || [];
                renderCoachingCards(list);
            })
            .catch(err => {
                console.error(err);
                renderCoachingCards([]);
            });
    }

    function renderCoachingCards(list) {
        const container = document.getElementById("coaching_cards");
        if (!container) return;

        if (!list.length) {
            container.innerHTML = `
            <div class="col-span-2 text-center text-gray-400 text-sm">
                No coaches are currently available.
            </div>`;
            return;
        }

        container.innerHTML = list.map(c => {
            const title = c.Title && c.Title.trim()
                ? c.Title
                : "Valorant Coaching Session";

            const description = c.Description && c.Description.trim()
                ? c.Description
                : "This coach has not added a description yet.";

            const price = c.PricePerHour && c.PricePerHour > 0
                ? c.PricePerHour
                : 0;

            // Required fields – if any missing, button becomes greyed out
            const incomplete =
                !c.FullName || !c.FullName.trim() ||
                !c.RiotID || !c.RiotID.trim() ||
                !c.Region || !c.Region.trim() ||
                !c.Rank || !c.Rank.trim() ||
                !c.Title || !c.Title.trim() ||
                !c.Description || !c.Description.trim() ||
                !price;

            const btnClass = incomplete
                ? "bg-gray-300 text-gray-500 cursor-not-allowed"
                : "bg-red-600 text-white cursor-pointer";

            const btnText = incomplete
                ? "Incomplete Profile"
                : `Book Session ($${price.toFixed(2)}/hr)`;

            const onclickAttr = incomplete
                ? ""
                : `onclick="openPayment(${c.CoachID})"`;

            return `
    <div class="border-2 border-dashed border-gray-300 p-6 rounded-lg bg-white">

        <h3 class="text-xl font-bold text-center mb-4 text-gray-800">${title}</h3>

        <div class="space-y-1 text-sm text-gray-700 mb-4">
            <p><span class="font-semibold">Real Name:</span> ${c.FullName || "-"}</p>
            <p><span class="font-semibold">Riot ID:</span> ${c.RiotID || "-"}</p>
            <p><span class="font-semibold">Region:</span> ${c.Region || "-"}</p>
            <p><span class="font-semibold">Rank:</span> ${c.Rank || "-"}</p>
        </div>

        <p class="text-sm text-gray-500 italic mb-6">"${description}"</p>

        <button 
            class="w-full py-2 rounded font-bold text-sm ${btnClass}"
            ${incomplete ? "disabled" : ""}
            ${onclickAttr}
        >
            ${btnText}
        </button>

    </div>
`;
        }).join("");

        lucide.createIcons();
    }

    // When user clicks Book Session on a valid coach
    function openPayment(coachId) {
        selectedCoachID = coachId;
        loadPage("payment");
    }

    // ===================================================
    // PAYMENT FORM DYNAMIC FIELDS
    // ===================================================
    function renderPaymentForm() {
        const method = document.querySelector("input[name='paymethod']:checked")?.value;
        const box = document.getElementById("payment_fields");
        if (!box) return;

        let html = "";

        if (method === "card") {
            html = `
            <div class="space-y-4 mt-4">
                <div>
                    <label class="font-semibold">Card Number</label>
                    <input id="card_number" class="w-full p-3 border rounded" maxlength="16" placeholder="16-digit card number">
                </div>
                <div class="flex gap-4">
                    <div class="flex-1">
                        <label class="font-semibold">Expiry</label>
                        <input id="card_exp" class="w-full p-3 border rounded" placeholder="MM/YY">
                    </div>
                    <div class="flex-1">
                        <label class="font-semibold">CVV</label>
                        <input id="card_cvv" class="w-full p-3 border rounded" maxlength="3" placeholder="123">
                    </div>
                </div>
            </div>
        `;
        } else if (method === "fpx") {
            html = `
            <div class="mt-4">
                <label class="font-semibold">Select Bank</label>
                <select id="fp_bank" class="w-full p-3 border rounded">
                    <option value="">-- Select --</option>
                    <option>Maybank</option>
                    <option>CIMB</option>
                    <option>RHB</option>
                    <option>Public Bank</option>
                </select>
            </div>
        `;
        } else if (method === "tng") {
            html = `
            <div class="mt-4">
                <label class="font-semibold">TNG eWallet Phone</label>
                <input id="tng_phone" class="w-full p-3 border rounded" placeholder="Phone linked to TNG eWallet">
            </div>
        `;
        }

        box.innerHTML = html;
        validatePaymentForm(); // re-check after changing method
    }

    function validatePaymentForm() {
        const btn = document.getElementById("pay_btn");
        if (!btn) return;

        // If no coach selected, always disable
        if (!selectedCoachID) {
            btn.disabled = true;
            btn.classList.add("bg-gray-400", "cursor-not-allowed");
            btn.classList.remove("bg-red-600");
            return false;
        }

        const method = document.querySelector("input[name='paymethod']:checked")?.value;
        const phoneEl = document.getElementById("pay_phone");
        const discEl = document.getElementById("pay_discord");
        const dtEl = document.getElementById("pay_datetime");

        const phone = phoneEl ? phoneEl.value.trim() : "";
        const discord = discEl ? discEl.value.trim() : "";
        const dt = dtEl ? dtEl.value : "";

        let valid = !!(method && phone && discord && dt);

        if (method === "card") {
            const num = document.getElementById("card_number")?.value.trim();
            const exp = document.getElementById("card_exp")?.value.trim();
            const cvv = document.getElementById("card_cvv")?.value.trim();
            valid = valid && num && num.length === 16 && /^[0-9]+$/.test(num)
                && exp && cvv && cvv.length === 3;
        } else if (method === "fpx") {
            const bank = document.getElementById("fp_bank")?.value;
            valid = valid && bank;
        } else if (method === "tng") {
            const tngPhone = document.getElementById("tng_phone")?.value.trim();
            valid = valid && tngPhone;
        }

        if (valid) {
            btn.disabled = false;
            btn.classList.remove("bg-gray-400", "cursor-not-allowed");
            btn.classList.add("bg-red-600");
        } else {
            btn.disabled = true;
            btn.classList.add("bg-gray-400", "cursor-not-allowed");
            btn.classList.remove("bg-red-600");
        }

        return valid;
    }

    function initPaymentPage() {
        const warning = document.getElementById("payment_warning");
        if (warning) {
            if (!selectedCoachID) warning.classList.remove("hidden");
            else warning.classList.add("hidden");
        }

        // Set up validation timer (clear previous if any)
        if (payValidationTimer) clearInterval(payValidationTimer);
        payValidationTimer = setInterval(validatePaymentForm, 3000);
        validatePaymentForm();
    }

    function submitPayment() {
        // front-end guard
        const btn = document.getElementById("pay_btn");
        if (!btn || btn.disabled) {
            alert("Please complete all required fields before paying.");
            return;
        }
        if (!selectedCoachID) {
            alert("No coach selected. Please go back to Book Coaching.");
            return;
        }

        const phone = document.getElementById("pay_phone").value.trim();
        const discord = document.getElementById("pay_discord").value.trim();
        const datetime = document.getElementById("pay_datetime").value;

        const payload = {
            coachId: selectedCoachID,
            phone: phone,
            discord: discord,
            datetime: datetime
        };

        fetch("MemberView.aspx/CreateBooking", {
            method: "POST",
            headers: { "Content-Type": "application/json; charset=utf-8" },
            body: JSON.stringify(payload)
        })
            .then(r => r.json())
            .then(res => {
                if (res.d?.status === "success") {
                    // reset selected coach after booking
                    selectedCoachID = null;
                    loadPage("payment_success");
                } else {
                    alert("Something went wrong while creating the booking.");
                }
            })
            .catch(err => {
                console.error(err);
                alert("Error contacting server.");
            });
    }

    // ===================================================
    // ROUTER
    // ===================================================
    function loadPage(page) {
        if (payValidationTimer) {
            clearInterval(payValidationTimer);
            payValidationTimer = null;
        }

        const pages = {
            dashboard: MemberDashboard(),
            learning: LearningResources(),
            tips: TipsAndTricksPage(),
            coaching: BookCoaching(),
            bookings: MyBookings(),
            sessions: MemberSessions(),   // <-- ADD THIS
            payment: PaymentPage(),
            payment_success: PaymentSuccessPage(),
            profile: ProfileManagement(),
        };


        document.getElementById("app").innerHTML = pages[page] || MemberDashboard();
        lucide.createIcons();

        if (page === "coaching") {
            setTimeout(fetchCoachingList, 50);
        }

        if (page === "profile") {
            setTimeout(() => {
                loadAccountInfo();
                loadProfileData();
            }, 50);
        }

        if (page === "bookings") {
            setTimeout(fetchMyBookings, 50);
        }

        if (page === "sessions") {
            setTimeout(loadMemberSessions, 50);
        }



        if (page === "payment") {
            setTimeout(initPaymentPage, 50);
        }
    }

    // Default view
    loadPage("dashboard");
</script>

</body>
</html>
