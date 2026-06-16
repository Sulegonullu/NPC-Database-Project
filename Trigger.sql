USE NPC_DB;
GO

 
-- TRIGGER
-- ------------------------------------------------

-- Aynı kararın tekrar eklenmesini engelleyen trigger
ALTER TRIGGER trg_PreventDuplicateDecision
ON Decisions
INSTEAD OF INSERT
AS
BEGIN
 -- Gereksiz sistem mesajlarını kapatır
    SET NOCOUNT ON;
-- Aynı karar sistemde var mı kontrol edilir
    IF EXISTS
    (
    SELECT 1
        FROM Decisions d

        INNER JOIN inserted i
            ON d.npc_id = i.npc_id
           AND d.state_id = i.state_id
           AND d.action_id = i.action_id
           AND d.condition_id = i.condition_id
    )

    BEGIN
  -- Aynı kayıt varsa hata mesajı verir
        RAISERROR
        (
            N'HATA: Bu karar zaten sistemde mevcut!',
            16,
            1
        );

    END

    ELSE

    BEGIN

        -- Kayıt benzersiz ise tabloya eklenir
        INSERT INTO Decisions
        (
            npc_id,
            state_id,
            action_id,
            condition_id,
            priority
        )

        SELECT
            npc_id,
            state_id,
            action_id,
            condition_id,
            priority

        FROM inserted;

    END

END;
GO