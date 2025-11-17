USE ValoProDB;
GO

------------------------------------------
-- USERS TABLE
------------------------------------------
CREATE TABLE Users (
    UserID INT PRIMARY KEY IDENTITY(1,1),
    Username NVARCHAR(50) UNIQUE NOT NULL,
    Email NVARCHAR(100) UNIQUE NOT NULL,
    Password NVARCHAR(255) NOT NULL,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    Role NVARCHAR(20) NOT NULL,
    CreatedDate DATETIME DEFAULT GETDATE(),
    IsActive BIT DEFAULT 1
);
GO

------------------------------------------
-- WEAPONS TABLE
------------------------------------------
CREATE TABLE Weapons (
    WeaponID INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100) NOT NULL,
    Type NVARCHAR(50),
    Damage INT,
    FireRate DECIMAL(5,2),
    Magazine INT,
    Cost INT,
    ImagePath NVARCHAR(255),
    Description NVARCHAR(MAX),
    CreatedDate DATETIME DEFAULT GETDATE()
);
GO

------------------------------------------
-- AGENTS TABLE
------------------------------------------
CREATE TABLE Agents (
    AgentID INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100) NOT NULL,
    Role NVARCHAR(50),
    Description NVARCHAR(MAX),
    Ability1 NVARCHAR(100),
    Ability2 NVARCHAR(100),
    Ability3 NVARCHAR(100),
    Ultimate NVARCHAR(100),
    ImagePath NVARCHAR(255),
    CreatedDate DATETIME DEFAULT GETDATE()
);
GO

------------------------------------------
-- BOOKINGS TABLE
------------------------------------------
CREATE TABLE Bookings (
    BookingID INT PRIMARY KEY IDENTITY(1,1),
    MemberID INT NOT NULL,
    CoachID INT NOT NULL,
    BookingDate DATETIME NOT NULL,
    Duration INT,
    Status NVARCHAR(20),
    Amount DECIMAL(10,2),
    CreatedDate DATETIME DEFAULT GETDATE(),

    CONSTRAINT FK_Bookings_Member FOREIGN KEY (MemberID)
        REFERENCES Users(UserID),

    CONSTRAINT FK_Bookings_Coach FOREIGN KEY (CoachID)
        REFERENCES Users(UserID)
);
GO

------------------------------------------
-- PAYMENTS TABLE
------------------------------------------
CREATE TABLE Payments (
    PaymentID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT NOT NULL,
    BookingID INT NOT NULL,
    Amount DECIMAL(10,2),
    PaymentDate DATETIME DEFAULT GETDATE(),
    PaymentMethod NVARCHAR(50),
    Status NVARCHAR(20),

    CONSTRAINT FK_Payments_User FOREIGN KEY (UserID)
        REFERENCES Users(UserID),

    CONSTRAINT FK_Payments_Booking FOREIGN KEY (BookingID)
        REFERENCES Bookings(BookingID)
);
GO

CREATE TABLE PendingRegistrations (
    PendingID INT PRIMARY KEY IDENTITY(1,1),
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    Username NVARCHAR(50),
    Email NVARCHAR(100),
    Password NVARCHAR(255),
    RequestedRole NVARCHAR(20),  -- Member / Coach / Admin
    SubmittedDate DATETIME DEFAULT GETDATE()
);

INSERT INTO Users (Username, Email, Password, FirstName, LastName, Role, IsActive)
VALUES
('admin1', 'admin1@mail.com', 'Admin123', 'Admin', 'One', 'Admin', 1),
('admin2', 'admin2@mail.com', 'admin2@mail.com', 'Admin123', 'Admin', 1),
('superadmin', 'superadmin@mail.com', 'Admin999', 'Super', 'Admin', 'Admin', 1);
