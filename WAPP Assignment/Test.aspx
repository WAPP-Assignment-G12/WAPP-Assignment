<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Test.aspx.cs" Inherits="WAPP_Assignment.WebForm1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>ValoPro Wireframe - Role Based</title>
    <style>
        :root {
            --wireframe-black: #333;
            --wireframe-bg: #f4f4f4;
            --wireframe-white: #fff;
        }

        * {
            box-sizing: border-box;
        }

        body {
            font-family: 'Courier New', Courier, monospace; /* Monospace for wireframe look */
            margin: 0;
            padding: 0;
            background-color: var(--wireframe-bg);
            padding-top: 60px; /* Space for the role switcher */
        }

        /* --- ROLE SWITCHER (For Wireframe Demo Only) --- */
        .role-switcher {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            background: #000;
            color: #fff;
            padding: 10px;
            text-align: center;
            z-index: 1000;
            display: flex;
            justify-content: center;
            gap: 15px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.2);
        }

            .role-switcher span {
                font-weight: bold;
                margin-right: 10px;
                font-family: sans-serif;
            }

        .role-btn {
            background: #444;
            color: #fff;
            border: 1px solid #777;
            padding: 5px 15px;
            cursor: pointer;
            font-family: sans-serif;
            font-size: 12px;
        }

            .role-btn:hover, .role-btn.active {
                background: #ff4655; /* Valorant Red-ish */
                border-color: #ff4655;
            }

        /* --- MAIN CONTAINER --- */
        .container {
            max-width: 1200px;
            margin: 20px auto;
            background: var(--wireframe-white);
            border: 2px solid var(--wireframe-black);
            padding: 20px;
            min-height: 80vh;
        }

        /* --- HEADER / NAV BAR (Based on Sketch) --- */
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 40px;
            border-bottom: 1px dashed #ccc;
            padding-bottom: 20px;
        }

        .logo {
            font-size: 24px;
            font-weight: bold;
            text-transform: uppercase;
        }

        /* The Boxy Nav from the Sketch */
        .nav-bar {
            display: flex;
            gap: 10px;
        }

        .nav-item {
            border: 2px solid var(--wireframe-black);
            padding: 10px 20px;
            text-decoration: none;
            color: var(--wireframe-black);
            font-weight: bold;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: background 0.2s;
        }

            .nav-item:hover {
                background: #eee;
            }

            .nav-item i {
                /* Placeholder for icons drawn in sketch */
                font-style: normal;
                font-size: 18px;
            }

        /* --- HERO SECTION --- */
        .hero {
            text-align: center;
            padding: 60px 20px;
            border: 2px solid var(--wireframe-black);
            margin-bottom: 40px;
        }

            .hero h1 {
                font-size: 36px;
                margin-bottom: 10px;
            }

            .hero p {
                font-size: 18px;
                color: #555;
                margin-bottom: 30px;
            }

        .cta-buttons {
            display: flex;
            justify-content: center;
            gap: 20px;
        }

        .btn {
            border: 2px solid var(--wireframe-black);
            padding: 12px 30px;
            background: none;
            font-size: 16px;
            cursor: pointer;
            font-family: inherit;
            border-radius: 5px; /* Slight round per sketch */
        }

        .btn-primary {
            background: var(--wireframe-black);
            color: var(--wireframe-white);
        }

        /* --- FEATURES / ROLES CONTENT --- */
        .features-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 30px;
        }

        .feature-card {
            border: 2px solid var(--wireframe-black);
            padding: 30px;
            text-align: center;
            border-radius: 10px;
        }

        .circle-icon {
            width: 60px;
            height: 60px;
            border: 2px solid var(--wireframe-black);
            border-radius: 50%;
            margin: 0 auto 20px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .role-badge {
            display: inline-block;
            background: #eee;
            padding: 2px 8px;
            font-size: 12px;
            margin-bottom: 10px;
            border: 1px solid #999;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="role-switcher">
            <span>Select View:</span>
            <button class="role-btn active" data-role="guest" onclick="setRole('guest', event)">Guest / Public</button>
            <button class="role-btn" data-role="member" onclick="setRole('member', event)">Registered Member</button>
            <button class="role-btn" data-role="coach" onclick="setRole('coach', event)">Coach</button>
            <button class="role-btn" data-role="admin" onclick="setRole('admin', event)">Admin</button>
        </div>
         <div class="container">
             <div class="header">
                 <div class="logo">ValoPro</div>

                 <nav class="nav-bar" id="navContainer">
                 </nav>
             </div>

             <div id="mainContent">
             </div>
        </div>
            <script>
        // --- CONFIGURATION BASED ON PROJECT REQUIREMENTS ---
        const roles = {
            guest: {
                nav: [
                    { text: "Home", icon: "🏠", link: "#" },
                    { text: "About Us", icon: "ℹ", link: "#" },
                    { text: "Weapons (Preview)", icon: "🔫", link: "#" },
                    { text: "Login / Register", icon: "👤", link: "#" }
                ],
                heroTitle: "Master Valorant with ValoPro",
                heroSub: "Complete guides, agent tutorials, and pro coaching.",
                content: `
                            <div class="features-grid">
                                <div class="feature-card">
                                    <div class="circle-icon">🔫</div>
                                    <h3>Weapon Guides</h3>
                                    <p>Basic stats for beginners.</p>
                                </div>
                                <div class="feature-card">
                                    <div class="circle-icon">🦸</div>
                                    <h3>Agent Tutorials</h3>
                                    <p>Learn basic abilities.</p>
                                </div>
                                <div class="feature-card">
                                    <div class="circle-icon">🎓</div>
                                    <h3>Pro Coaching</h3>
                                    <p>Sign up to book a coach.</p>
                                    </div>
                                </div>
                         `
            },
            member: {
                nav: [
                    { text: "Dashboard", icon: "📊", link: "#" },
                    { text: "Full Library", icon: "📚", link: "#" },
                    { text: "Book Coach", icon: "📅", link: "#" },
                    { text: "My Profile", icon: "⚙", link: "#" }
                ],
                heroTitle: "Welcome back, Agent.",
                heroSub: "Continue your training or book a new session.",
                content: `
                        <div class="features-grid">
                            <div class="feature-card">
                                <div class="role-badge">Member Access</div>
                                <div class="circle-icon">📈</div>
                                <h3>My Progress</h3>
                                <p>Track your learning path.</p>
                            </div>
                            <div class="feature-card">
                                <div class="role-badge">Member Access</div>
                                <div class="circle-icon">🎥</div>
                                <h3>Premium Videos</h3>
                                <p>Watch advanced lineups.</p>
                            </div>
                            <div class="feature-card">
                                <div class="role-badge">Member Access</div>
                                <div class="circle-icon">📅</div>
                                <h3>My Bookings</h3>
                                <p>Manage upcoming sessions.</p>
                            </div>
                        </div>
                    `
            },
            coach: {
                nav: [
                    { text: "Dashboard", icon: "📊", link: "#" },
                    { text: "My Schedule", icon: "🕒", link: "#" },
                    { text: "Requests", icon: "📩", link: "#" },
                    { text: "Students", icon: "👥", link: "#" }
                ],
                heroTitle: "Coach Dashboard",
                heroSub: "Manage your availability and incoming student requests.",
                content: `
                        <div class="features-grid">
                            <div class="feature-card">
                                <div class="circle-icon">✅</div>
                                <h3>Availability</h3>
                                <p>Set your open time slots.</p>
                            </div>
                            <div class="feature-card">
                                <div class="circle-icon">💵</div>
                                <h3>Earnings</h3>
                                <p>View session payouts.</p>
                            </div>
                            <div class="feature-card">
                                <div class="circle-icon">📤</div>
                                <h3>Uploads</h3>
                                <p>Add new coaching materials.</p>
                            </div>
                        </div>
                    `
            },
            admin: {
                nav: [
                    { text: "Admin Home", icon: "🔒", link: "#" },
                    { text: "Users", icon: "👥", link: "#" },
                    { text: "Content", icon: "📝", link: "#" },
                    { text: "Finances", icon: "💰", link: "#" }
                ],
                heroTitle: "System Administration",
                heroSub: "Manage users, approve coaches, and update content.",
                content: `
                        <div class="features-grid">
                            <div class="feature-card">
                                <h3>User Mgmt</h3>
                                <p>CRUD operations for all users.</p>
                            </div>
                            <div class="feature-card">
                                <h3>Approvals</h3>
                                <p>3 Pending Coach Applications.</p>
                            </div>
                            <div class="feature-card">
                                <h3>Database</h3>
                                <p>System health and backups.</p>
                            </div>
                        </div>
                    `
            }
        };

        function setRole(roleName, evt) {
            // update evt safely
            evt = evt || window.event;

            const roleData = roles[roleName];
            const navContainer = document.getElementById('navContainer');
            const mainContent = document.getElementById('mainContent');

            // Clear previous active
            document.querySelectorAll('.role-btn').forEach(btn => btn.classList.remove('active'));

            // Prefer click event target; fallback to button matching roleName
            let btnToActivate = null;
            if (evt && evt.target && evt.target.classList) {
                btnToActivate = evt.target.closest('.role-btn') || evt.target;
            }
            if (!btnToActivate) {
                btnToActivate = document.querySelector(`.role-btn[data-role="${roleName}"]`);
            }
            if (btnToActivate && btnToActivate.classList) {
                btnToActivate.classList.add('active');
            }

            // Render Nav Bar
            navContainer.innerHTML = '';
            roleData.nav.forEach(item => {
                const link = document.createElement('a');
                link.className = 'nav-item';
                link.href = item.link;
                link.innerHTML = `<i>${item.icon}</i> ${item.text}`;
                navContainer.appendChild(link);
            });

            // Render Hero & Content...
            mainContent.innerHTML = `...`;
        }

        // Use: either call directly or pass event from inline handler
        // Inline: <button type="button" onclick="setRole('member', event)">...
        document.addEventListener('DOMContentLoaded', () => {
            setRole('guest'); // initialize without relying on click()/implicit event
        });

    </script>
    </form>
</body>
</html>
