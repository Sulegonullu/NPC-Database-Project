USE NPC_DB;
GO


-- FUNCTION
-- =========================================

-- Eğer function daha önce oluşturulduysa sil
IF OBJECT_ID('dbo.GetNPCCount', 'FN') IS NOT NULL
    DROP FUNCTION dbo.GetNPCCount;
GO

-- Toplam NPC sayısını döndüren function oluştur
CREATE FUNCTION dbo.GetNPCCount()

-- Function int değer döndürür
RETURNS INT

-- Performans ve veri bütünlüğü için şema bağlama kullanılır
WITH SCHEMABINDING

AS
BEGIN

    -- NPC sayısını tutacak değişken
    DECLARE @count INT;

    -- NPC tablosundaki toplam kayıt sayısını hesaplar
    SELECT @count = COUNT(npc_id)
    FROM dbo.NPC;

    -- Hesaplanan değeri geri döndürür
    RETURN @count;

END;
GO