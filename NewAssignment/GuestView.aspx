<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="GuestView.aspx.cs" Inherits="WebApplication7.GuestView" %>
<!DOCTYPE html>
<html>
<head>
    <title>ValoPro - Guest View</title>
    <meta charset="utf-8" />
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://unpkg.com/lucide@latest"></script>
</head>

<body class="bg-gray-50">

<form id="form1" runat="server">

    <!-- NAVBAR -->
    <div class="w-full bg-gray-900 text-white flex justify-between px-6 py-4 items-center">
        <div class="flex gap-6 items-center">

            <!-- LOGO -->
            <h1 class="text-xl font-bold cursor-pointer flex" onclick="loadPage('home')">
                <span class="text-red-500 drop-shadow-[0_0_3px_rgba(255,0,0,0.4)]">Valo</span>
                <span class="text-yellow-400 drop-shadow-[0_0_3px_rgba(255,215,0,0.4)]">Pro</span>
            </h1>

            <a href="#" onclick="loadPage('home')" class="hover:text-red-400">Home</a>
            <a href="#" onclick="loadPage('weapons')" class="hover:text-red-400">Weapons</a>
            <a href="#" onclick="loadPage('agents')" class="hover:text-red-400">Agents</a>
            <a href="#" onclick="loadPage('pricing')" class="hover:text-red-400">Pricing</a>
        </div>

        <div class="flex gap-3 items-center">
            <span class="text-sm text-gray-400 font-semibold">Current View: GUEST</span>
            <a href="Login.aspx" class="hover:text-red-400">Login</a>
            <a href="Signup.aspx" class="hover:text-red-400">Register</a>
        </div>
    </div>

    <!-- MAIN CONTENT -->
    <div id="app"></div>

</form>

<script>

    /* ===========================
          PAGE TEMPLATES
       =========================== */

    const HomePage = () => `
    <div class="p-8">
        <div class="border-b-2 pb-4 mb-6">
            <h2 class="text-2xl font-bold text-gray-800">Welcome to ValoPro</h2>
            <p class="text-sm text-gray-600">Valorant training platform (Guest View)</p>
        </div>

        <div class="border-2 border-dashed border-gray-300 p-12 rounded-lg bg-gray-50 text-center">
            <p class="text-xs text-gray-500 mb-4 uppercase tracking-widest">HERO SECTION</p>
            <h3 class="text-4xl font-extrabold text-gray-900 mb-4">MASTER THE GAME</h3>
            <p class="text-lg text-gray-600 mb-8 max-w-md mx-auto">
                Learn weapons, agents, and tactics with structured coaching tools.
            </p>

            <div class="flex gap-4 justify-center">
                <a href="Signup.aspx"
                    class="bg-red-600 text-white px-8 py-3 rounded font-bold shadow-lg hover:bg-red-700 transition">
                    GET STARTED
                </a>

                <a href="Login.aspx"
                    class="bg-white border border-gray-300 px-8 py-3 rounded font-bold text-gray-700 hover:bg-gray-100 transition">
                    LOGIN
                </a>
            </div>
        </div>
    </div>
`;

    const WeaponsPage = () => `
    <div class="p-8">
        <div class="border-b-2 pb-4 mb-6 flex justify-between items-end">
            <div>
                <h2 class="text-2xl font-bold text-gray-800">Weapons Library</h2>
                <p class="text-sm text-gray-500">Guest Preview — Full access requires account</p>
            </div>
            <span class="px-3 py-1 bg-yellow-100 text-yellow-800 rounded-full text-xs border border-yellow-300">
                RESTRICTED PREVIEW
            </span>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            ${[1, 2, 3, 4].map(i => `
                <div class="border-2 border-dashed border-gray-300 p-6 rounded-lg">
                    <div class="w-full h-32 bg-gray-200 mb-4 rounded"></div>
                    <h4 class="font-bold mb-1">Vandal Type-${i}</h4>
                    <p class="text-gray-600 text-sm">Damage: <span class="font-bold">??? (Locked)</span></p>
                </div>
            `).join('')}
        </div>
    </div>
`;

    const AgentsPage = () => `
    <div class="p-8">
        <div class="border-b-2 pb-4 mb-6">
            <h2 class="text-2xl font-bold text-gray-800">Agents Library</h2>
            <p class="text-sm text-gray-500">Guest Preview — Abilities locked</p>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
            ${[1, 2, 3, 4, 5, 6].map(i => `
                <div class="border-2 border-dashed border-gray-300 p-4 rounded-lg">
                    <div class="w-full h-40 bg-gray-200 mb-3 rounded"></div>
                    <h4 class="font-bold">Agent ${i}</h4>
                    <p class="text-sm text-gray-600">Role: 🔒 Locked</p>
                    <p class="text-sm text-gray-600">Abilities: 🔒 Locked</p>
                </div>
            `).join('')}
        </div>
    </div>
`;

    const PricingPage = () => `
    <div class="p-8">
        <h2 class="text-2xl font-bold text-center mb-6">Membership Plans</h2>

        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
            ${[
            { name: "Free", price: "$0", features: ["Basic stats", "Limited content"] },
            { name: "Premium", price: "$9.99", features: ["Full weapon guides", "Full agent guides"], popular: true },
            { name: "Pro", price: "$29.99", features: ["Coaching tools", "Advanced stats"] }
        ].map(plan => `

                <div class="border-2 ${plan.popular ? 'border-red-500 bg-red-50' : 'border-gray-300'} p-6 rounded-lg relative">

                    ${plan.popular ? `
                        <span class="absolute top-0 right-0 bg-red-600 text-white px-2 py-1 text-xs rounded-bl">
                            POPULAR
                        </span>` : ''}

                    <!-- LARGE ICON -->
                    <div class="flex justify-center mb-4">
                        ${plan.name === "Free"
                ? `<i data-lucide='circle-dashed' class='w-16 h-16 text-gray-400'></i>`
                : plan.name === "Premium"
                    ? `<i data-lucide='crown' class='w-16 h-16 text-yellow-500'></i>`
                    : `<i data-lucide='swords' class='w-16 h-16 text-red-600'></i>`
            }
                    </div>

                    <h3 class="text-xl font-bold mb-2 text-center">${plan.name}</h3>
                    <p class="text-3xl font-bold text-red-600 mb-4 text-center">${plan.price}</p>

                    <ul class="mb-6 space-y-2 text-center">
                        ${plan.features.map(f => `<li class="text-sm">${f}</li>`).join('')}
                    </ul>

                    ${plan.name === "Free"
                ? `<button onclick="loadPage('home')" class="w-full bg-gray-900 text-white py-2 rounded font-bold hover:bg-gray-800 transition">Select</button>`
                : plan.name === "Premium"
                    ? `<a href="Signup.aspx?plan=premium" class="block w-full bg-gray-900 text-white py-2 rounded font-bold text-center hover:bg-gray-800 transition">Select</a>`
                    : `<a href="Signup.aspx?plan=pro" class="block w-full bg-yellow-600 text-white py-2 rounded font-bold text-center hover:bg-yellow-500 transition">Select</a>`
            }

                </div>

            `).join('')}
        </div>

        <p class="text-center text-xs text-gray-500 italic mt-6">
            *Take note that this pricing feature won't apply if you sign up as a Coach.
        </p>
    </div>
`;




    /* ===========================
            ROUTER
       =========================== */

    function loadPage(page) {
        const pages = {
            home: HomePage(),
            weapons: WeaponsPage(),
            agents: AgentsPage(),
            pricing: PricingPage()
        };

        document.getElementById("app").innerHTML = pages[page] || HomePage();
        lucide.createIcons();
    }

    loadPage("home");
</script>

</body>
</html>
