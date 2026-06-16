
-- DATABASE OLUŞTUR
-- -----------------------------------------

-- Eğer veritabanı yoksa oluştur
IF DB_ID('NPC_DB') IS NULL
BEGIN
    CREATE DATABASE NPC_DB;
END
GO

-- NPC_DB veritabanını kullan
USE NPC_DB;
GO


-- -----------------------------------------
-- ESKİ NESNELERİ TEMİZLE
-- -----------------------------------------

-- Daha önce oluşturulan function varsa sil
IF OBJECT_ID('dbo.GetNPCCount', 'FN') IS NOT NULL
    DROP FUNCTION dbo.GetNPCCount;

-- Daha önce oluşturulan procedure varsa sil
IF OBJECT_ID('GetNPCs', 'P') IS NOT NULL
    DROP PROCEDURE GetNPCs;

-- Daha önce oluşturulan trigger varsa sil
IF OBJECT_ID('trg_PreventDuplicateDecision', 'TR') IS NOT NULL
    DROP TRIGGER trg_PreventDuplicateDecision;

-- Daha önce oluşturulan view varsa sil
IF OBJECT_ID('dbo.NPC_Behavior', 'V') IS NOT NULL
    DROP VIEW dbo.NPC_Behavior;

-- Foreign Key kullanan ilişki tabloları silinir
IF OBJECT_ID('dbo.NPC_Level', 'U') IS NOT NULL
    DROP TABLE dbo.NPC_Level;

IF OBJECT_ID('dbo.Decisions', 'U') IS NOT NULL
    DROP TABLE dbo.Decisions;

-- Ana tablolar silinir
IF OBJECT_ID('dbo.Levels', 'U') IS NOT NULL
    DROP TABLE dbo.Levels;

IF OBJECT_ID('dbo.Conditions', 'U') IS NOT NULL
    DROP TABLE dbo.Conditions;

IF OBJECT_ID('dbo.Actions', 'U') IS NOT NULL
    DROP TABLE dbo.Actions;

IF OBJECT_ID('dbo.States', 'U') IS NOT NULL
    DROP TABLE dbo.States;

IF OBJECT_ID('dbo.NPC', 'U') IS NOT NULL
    DROP TABLE dbo.NPC;

GO


-- TABLOLAR
-- =========================================

-- NPC karakter tablosu
CREATE TABLE NPC
(
    npc_id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(50) NOT NULL,
    type NVARCHAR(20) NOT NULL
);

-- NPC durumlarını tutan tablo
CREATE TABLE States
(
    state_id INT IDENTITY(1,1) PRIMARY KEY,
    state_name NVARCHAR(50) NOT NULL
);

-- NPC aksiyonlarını tutan tablo
CREATE TABLE Actions
(
    action_id INT IDENTITY(1,1) PRIMARY KEY,
    action_name NVARCHAR(50) NOT NULL
);

-- Karar koşullarını tutan tablo
CREATE TABLE Conditions
(
    condition_id INT IDENTITY(1,1) PRIMARY KEY,
    description NVARCHAR(100) NOT NULL
);

-- Oyun bölümlerini tutan tablo
CREATE TABLE Levels
(
    level_id INT IDENTITY(1,1) PRIMARY KEY,
    level_name NVARCHAR(50) NOT NULL
);

-- NPC karar sistemini tutan tablo
CREATE TABLE Decisions
(
    decision_id INT IDENTITY(1,1) PRIMARY KEY,

    npc_id INT NOT NULL,
    state_id INT NOT NULL,
    action_id INT NOT NULL,
    condition_id INT NOT NULL,

    -- Karar öncelik puanı
    priority INT DEFAULT 1,

    FOREIGN KEY (npc_id) REFERENCES NPC(npc_id),
    FOREIGN KEY (state_id) REFERENCES States(state_id),
    FOREIGN KEY (action_id) REFERENCES Actions(action_id),
    FOREIGN KEY (condition_id) REFERENCES Conditions(condition_id)
);

-- NPC ve Level ilişkisini tutan tablo
CREATE TABLE NPC_Level
(
    id INT IDENTITY(1,1) PRIMARY KEY,

    npc_id INT NOT NULL,
    level_id INT NOT NULL,

    FOREIGN KEY (npc_id) REFERENCES NPC(npc_id),
    FOREIGN KEY (level_id) REFERENCES Levels(level_id)
);

GO

 
-- TEST VERİLERİ
-- --------------------------------------

-- NPC verileri
INSERT INTO NPC (name, type)
VALUES
(N'Goblin', N'Enemy'),
(N'Knight', N'Ally'),
(N'Dragon', N'Boss');

-- Durum verileri
INSERT INTO States (state_name)
VALUES
(N'Low Health'),
(N'Normal'),
(N'Aggressive');

-- Aksiyon verileri
INSERT INTO Actions (action_name)
VALUES
(N'Attack'),
(N'Run Away'),
(N'Defend');

-- Koşul verileri
INSERT INTO Conditions (description)
VALUES
(N'Health < 30'),
(N'Enemy Nearby'),
(N'Health > 70');

-- Level verileri
INSERT INTO Levels (level_name)
VALUES
(N'Dark Forest'),
(N'Castle');

-- NPC karar verileri
INSERT INTO Decisions
(npc_id, state_id, action_id, condition_id, priority)

VALUES
(1, 1, 2, 1, 10),
(1, 3, 1, 2, 5),
(2, 2, 3, 2, 5),
(3, 3, 1, 3, 20);

-- NPC-Level ilişkileri
INSERT INTO NPC_Level (npc_id, level_id)
VALUES
(1, 1),
(2, 2),
(3, 1);

GO



-- VIEW
-- =========================================

-- NPC davranışlarını anlamlı şekilde birleştiren view
CREATE VIEW NPC_Behavior AS

SELECT
    n.name AS NPC_Name,
    n.type AS NPC_Type,

    s.state_name AS Current_State,

    c.description AS Condition_Text,

    a.action_name AS Chosen_Action,

    d.priority AS Decision_Priority

FROM Decisions d

JOIN NPC n
ON d.npc_id = n.npc_id

JOIN States s
ON d.state_id = s.state_id

JOIN Conditions c
ON d.condition_id = c.condition_id

JOIN Actions a
ON d.action_id = a.action_id;

GO



-- INDEX
-- =========================================

-- npc_id için index
CREATE INDEX idx_npc
ON Decisions(npc_id);

-- state_id için index
CREATE INDEX idx_state
ON Decisions(state_id);

-- action_id için index
CREATE INDEX idx_action
ON Decisions(action_id);

GO