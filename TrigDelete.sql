-- DELETE ZA TABELU RACUN ----

create TRIGGER trg_Racun_delete
ON Racun
INSTEAD OF DELETE
AS
BEGIN
    

	IF EXISTS (SELECT 1 FROM Troskovi WHERE RacunID IN (SELECT RacunID FROM deleted))
    BEGIN
        -- If related records exist, raise an error and rollback the transaction
        RAISERROR ('Ne mozemo obrisati ovaj racun jer postoje troskovi vezani za njega.', 16, 1)
        ROLLBACK TRANSACTION;
        RETURN;
    END

    -- If no related records exist, proceed with the delete operation
    DELETE FROM Racun
    WHERE RacunID IN (SELECT RacunID FROM deleted);
END;



-- PROVERE ZA TABELU RACUN ----
delete from Racun
where RacunID=3

delete from Troskovi
where RacunID=3

select * from Troskovi

-- DELETE ZA TABELU PREDMET ----
--------------------------------
create TRIGGER trg_Predmet_delete
ON Predmet
INSTEAD OF DELETE
AS
BEGIN
    

	IF EXISTS (SELECT 1 FROM Stavke_predmeta WHERE PredmetID IN (SELECT PredmetID FROM deleted))
    BEGIN
        -- If related records exist, raise an error and rollback the transaction
        RAISERROR ('Ne mozemo obrisati ovaj predmet jer postoje stavke predmeta vezane za njega.', 16, 1)
        ROLLBACK TRANSACTION;
        RETURN;
    END

    -- If no related records exist, proceed with the delete operation
    DELETE FROM Predmet
    WHERE PredmetID IN (SELECT PredmetID FROM deleted);
END;

-- PROVERE ZA TABELU PREDMET ----
--------------------------------

select * from Stavke_predmeta

delete from Stavke_predmeta where PredmetID=1

delete from Predmet where PredmetID=1
