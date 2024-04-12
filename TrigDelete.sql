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


--------- TRIGER UPDATE --------------

create TRIGGER trg_Racun_UPDATE
ON Racun
INSTEAD OF UPDATE
AS
BEGIN
    -- Provera da li su polja primarnog ključa NULL
    IF EXISTS (
            SELECT 1
            FROM inserted
            WHERE RacunID IS NULL
              OR PredmetID IS NULL
            )
    BEGIN
        RAISERROR ('Ni jedno od polja primarnog kljuca ne sme biti NULL',12,2)
        ROLLBACK TRANSACTION;
        RETURN
    END

    -- Provera da li primarni ključ nije unikatan
    IF EXISTS (SELECT 1 FROM Racun WHERE RacunID IN (SELECT RacunID FROM inserted))

    BEGIN
        RAISERROR ('Primarni kljuc nije unikatan',12,2)
        ROLLBACK TRANSACTION;
        RETURN
    END

    -- Provera da li postoji odgovarajući red u Predmeti tabeli za strani ključ
    IF NOT EXISTS (SELECT 1 FROM Predmet WHERE PredmetID IN (SELECT PredmetID FROM inserted))
    BEGIN
        RAISERROR ('Pogresna referenca stranog kljuca PredmetID',12,2)
        ROLLBACK TRANSACTION;
        RETURN
    END

    -- Ažuriranje DEBIT tabele
    UPDATE d
    SET d.Datum = i.Datum,
        d.PredmetID = i.PredmetID,
        d.RacunID = i.RacunID,
        d.Valuta = i.Valuta,
        d.Zaduženje = i.Zaduženje
    FROM Racun d
    JOIN inserted i ON d.PredmetID = i.PredmetID

END

UPDATE Racun
SET RacunID = 11,
    PredmetID = 2,
    Datum = '2024-04-21',
    Zaduženje = 800.00,
    Valuta = 'GBP'
WHERE RacunID = 1;
