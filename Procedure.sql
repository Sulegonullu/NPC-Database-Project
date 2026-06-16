USE NPC_DB;
GO

-- 
-- PROCEDURE
-- =========================================

-- Eğer prosedür daha önce oluşturulduysa sil
IF OBJECT_ID('GetNPCs', 'P') IS NOT NULL
    DROP PROCEDURE GetNPCs;
GO

-- NPC listeleme prosedürü oluştur
CREATE PROCEDURE GetNPCs

    -- Dışarıdan NPC türü parametresi alabilir
    -- Örnek: Boss, Enemy, Ally
    @NPCType NVARCHAR(20) = NULL

AS
BEGIN

    -- Gereksiz sistem mesajlarını kapatır
    -- Daha temiz çıktı ve performans sağlar
    SET NOCOUNT ON;

    -- NPC bilgileri listelenir
    -- Parametre boşsa tüm NPC'ler gelir
    -- Parametre doluysa sadece ilgili tür listelenir
    SELECT
        npc_id,
        name,
        type

    FROM NPC

    WHERE (@NPCType IS NULL OR type = @NPCType);

END;
GO