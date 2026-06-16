USE NPC_DB;
GO

PRINT '====================================================';
PRINT '              NPC_DB FINAL TEST RAPORU              ';
PRINT '====================================================';


-- ====================================================
-- NPC TABLOSU
-- ====================================================

PRINT ' ';
PRINT '--- NPC TABLOSU ---';

SELECT
    npc_id AS [NPC ID],
    name AS [Karakter Adı],
    type AS [Karakter Türü]

FROM NPC;


-- ====================================================
-- STATES TABLOSU
-- ====================================================

PRINT ' ';
PRINT '--- STATES TABLOSU ---';

SELECT
    state_id AS [Durum ID],
    state_name AS [Durum Adı]

FROM States;


-- ====================================================
-- ACTIONS TABLOSU
-- ====================================================

PRINT ' ';
PRINT '--- ACTIONS TABLOSU ---';

SELECT
    action_id AS [Aksiyon ID],
    action_name AS [Aksiyon Adı]

FROM Actions;


-- ====================================================
-- CONDITIONS TABLOSU
-- ====================================================

PRINT ' ';
PRINT '--- CONDITIONS TABLOSU ---';

SELECT
    condition_id AS [Koşul ID],
    description AS [Koşul Açıklaması]

FROM Conditions;


-- ====================================================
-- LEVELS TABLOSU
-- ====================================================

PRINT ' ';
PRINT '--- LEVELS TABLOSU ---';

SELECT
    level_id AS [Level ID],
    level_name AS [Level Adı]

FROM Levels;


-- ====================================================
-- DECISIONS TABLOSU
-- ====================================================

PRINT ' ';
PRINT '--- DECISIONS TABLOSU ---';

SELECT
    decision_id AS [Karar ID],
    npc_id AS [NPC ID],
    state_id AS [Durum ID],
    action_id AS [Aksiyon ID],
    condition_id AS [Koşul ID],
    priority AS [Öncelik]

FROM Decisions;


-- ====================================================
-- NPC_LEVEL TABLOSU
-- ====================================================

PRINT ' ';
PRINT '--- NPC_LEVEL TABLOSU ---';

SELECT
    id AS [Kayıt ID],
    npc_id AS [NPC ID],
    level_id AS [Level ID]

FROM NPC_Level;


-- ====================================================
-- VIEW TESTİ
-- ====================================================

PRINT ' ';
PRINT '--- NPC_BEHAVIOR VIEW TESTİ ---';

SELECT
    NPC_Name AS [Karakter],
    NPC_Type AS [Tür],
    Current_State AS [Durum],
    Condition_Text AS [Koşul],
    Chosen_Action AS [Aksiyon],
    Decision_Priority AS [Öncelik]

FROM NPC_Behavior;


-- ====================================================
-- PROCEDURE TESTİ
-- ====================================================

PRINT ' ';
PRINT '--- PROCEDURE TESTİ ---';

EXEC GetNPCs @NPCType = N'Enemy';


-- ====================================================
-- FUNCTION TESTİ
-- ====================================================

PRINT ' ';
PRINT '--- FUNCTION TESTİ ---';

SELECT
    dbo.GetNPCCount() AS [Toplam NPC Sayısı];


-- ====================================================
-- GROUP BY SORGUSU
-- ====================================================

PRINT ' ';
PRINT '--- AKSIYON KULLANIM SAYILARI ---';

SELECT
    Chosen_Action AS [Aksiyon],
    COUNT(*) AS [Kullanım Sayısı]

FROM NPC_Behavior

GROUP BY Chosen_Action;


-- ====================================================
-- JOIN SORGUSU
-- ====================================================

PRINT ' ';
PRINT '--- NPC VE LEVEL LISTESI ---';

SELECT
    n.name AS [Karakter],
    n.type AS [Tür],
    l.level_name AS [Level]

FROM NPC_Level nl

JOIN NPC n
ON nl.npc_id = n.npc_id

JOIN Levels l
ON nl.level_id = l.level_id;


-- ====================================================
-- WHERE SORGUSU
-- ====================================================

PRINT ' ';
PRINT '--- ONCELIGI 5TEN BUYUK KARARLAR ---';

SELECT
    NPC_Name AS [Karakter],
    Chosen_Action AS [Aksiyon],
    Decision_Priority AS [Öncelik]

FROM NPC_Behavior

WHERE Decision_Priority > 5;


-- ====================================================
-- SUBQUERY SORGUSU
-- ====================================================

PRINT ' ';
PRINT '--- ORTALAMANIN UZERINDEKI KARARLAR ---';

SELECT
    NPC_Name AS [Karakter],
    Chosen_Action AS [Aksiyon],
    Decision_Priority AS [Öncelik]

FROM NPC_Behavior

WHERE Decision_Priority >
(
    SELECT AVG(priority)
    FROM Decisions
);


-- ====================================================
-- VERİ EKLEME
-- ====================================================

PRINT ' ';
PRINT '--- YENI NPC EKLEME ---';

INSERT INTO NPC
(
    name,
    type
)

VALUES
(
    N'Orc',
    N'Enemy'
);

SELECT *
FROM NPC;


-- ====================================================
-- VERİ GÜNCELLEME
-- ====================================================

PRINT ' ';
PRINT '--- NPC GUNCELLEME ---';

UPDATE NPC
SET type = N'Boss'
WHERE name = N'Orc';

SELECT *
FROM NPC
WHERE name = N'Orc';


-- ====================================================
-- VERİ SİLME
-- ====================================================

PRINT ' ';
PRINT '--- NPC SILME ---';

DELETE FROM NPC
WHERE name = N'Orc';

SELECT *
FROM NPC;


-- ====================================================
-- TRIGGER TESTİ
-- ====================================================

PRINT ' ';
PRINT '--- TRIGGER TESTİ ---';



GO
PRINT '--- ONCELIGE GORE SIRALAMA ---';

SELECT
    NPC_Name,
    Chosen_Action,
    Decision_Priority

FROM NPC_Behavior

ORDER BY Decision_Priority DESC;

PRINT '--- EN YUKSEK ONCELIKLI KARAR ---';

SELECT TOP 1
    NPC_Name,
    Chosen_Action,
    Decision_Priority

FROM NPC_Behavior

ORDER BY Decision_Priority DESC;

PRINT ' ';
PRINT '====================================================';
PRINT '             RAPORLAMA TAMAMLANDI                   ';
PRINT '====================================================';