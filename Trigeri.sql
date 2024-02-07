use Master2
go

-----------------
-----------------
-- TRIGER ADVOKAT --
-----------------
-----------------
CREATE TRIGGER trg_Advokat_Ins2
ON Advokat
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted WHERE StatusID IS NULL)
    BEGIN
        RAISERROR ('StatusID ne može biti NULL.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN
    END

    IF NOT EXISTS (SELECT 1 FROM Status WHERE StatusID IN (SELECT StatusID FROM inserted))
    BEGIN
        RAISERROR ('Referenca na Status_ID nije validna.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN
    END

    -- Umetanje redova ako su sve provere uspešne
    INSERT INTO Advokat (StatusID, Prezime_i_ime, KucniTel, MobilniTel)
    SELECT StatusID, Prezime_i_ime, KucniTel, MobilniTel
    FROM inserted;
END;

insert into Advokat(StatusID,Prezime_i_ime,KucniTel,MobilniTel)
values(7,'AAAAAA','11111111','1111111'),
(8,'AAAAAA','11111111','1111111')


CREATE TRIGGER trg_StavkePredmeta_Ins
ON stavke_predmeta
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted WHERE AdvokatID IS NULL)
    BEGIN
        RAISERROR ('AdvkoatID ne može biti NULL.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN
    END

	  IF EXISTS (SELECT 1 FROM inserted WHERE PredmetID IS NULL)
    BEGIN
        RAISERROR ('PredmetID ne može biti NULL.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN
    END

	  IF EXISTS (SELECT 1 FROM inserted WHERE RacunID IS NULL)
    BEGIN
        RAISERROR ('RacunID ne može biti NULL.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN
    END

    IF NOT EXISTS (SELECT 1 FROM Advokat WHERE AdvokatID IN (SELECT AdvokatID FROM inserted))
    BEGIN
        RAISERROR ('Referenca na AdvokatID nije validna.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN
    END

	   IF NOT EXISTS (SELECT 1 FROM Predmet WHERE PredmetID IN (SELECT PredmetID FROM inserted))
    BEGIN
        RAISERROR ('Referenca na PredmetID nije validna.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN
    END

	   IF NOT EXISTS (SELECT 1 FROM Racun WHERE RacunID IN (SELECT RacunID FROM inserted))
    BEGIN
        RAISERROR ('Referenca na RacunID nije validna.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN
    END

    -- Umetanje redova ako su sve provere uspešne
    INSERT INTO Stavke_predmeta(AdvokatID,PredmetID,RacunID,Datum,Opis,UkupnoVreme)
    SELECT AdvokatID,PredmetID,RacunID,Datum,Opis,UkupnoVreme
    FROM inserted;
END;


insert into Stavke_predmeta(AdvokatID,PredmetID,RacunID,Datum,Opis,UkupnoVreme)
values(null,1,2,'02-03-2024','aaaaa','aaaaa')


-----------------
-----------------
-- TRIGER TROSKOVI --
-----------------
-----------------


create trigger Troskovi_Insert
on Troskovi
INSTEAD OF INSERT
AS
BEGIN

	if EXISTS (select 1 from inserted where RacunID IS NULL)
	BEGIN
		RAISERROR ('RacunID ne može biti null',16,1);
		ROLLBACK TRANSACTION;
		RETURN
	end

	if NOT EXISTS (select 1 from Racun where RacunID in (select RacunID from inserted))
	BEGIN
		RAISERROR ('Referenca RacunID nije validna',16,1);
		ROLLBACK TRANSACTION;
		RETURN
	end

		if EXISTS (select 1 from inserted where PredmetID IS NULL)
	BEGIN
		RAISERROR ('PredmetID ne može biti null',16,1);
		ROLLBACK TRANSACTION;
		RETURN
	end

	if NOT EXISTS (select 1 from Predmet where PredmetID in (select PredmetID from inserted))
	BEGIN
		RAISERROR ('Referenca PredmetID nije validna',16,1);
		ROLLBACK TRANSACTION;
		RETURN
	end

	insert into Troskovi(PredmetID,RacunID,Opis,Vrednost,Datum)
	select  PredmetID,RacunID,Opis,Vrednost,Datum from inserted;
	end


	insert into Troskovi(PredmetID,RacunID,Opis,Vrednost,Datum)
	values (23,1,'Opis',123123,GETDATE())



SELECT SUM(r.Zaduženje) as Ukupno, 
       YEAR(r.Datum) as Godina, 
       MONTH(r.Datum) as Mesec, 
       a.Prezime_i_ime
FROM Advokat a 
INNER JOIN Predmet p ON a.AdvokatID = p.AdvokatID
INNER JOIN Racun r ON r.PredmetID = p.PredmetID
where a.AdvokatID=1
GROUP BY MONTH(r.Datum), YEAR(r.Datum) , a.Prezime_i_ime;

-- Dodavanje dodatnih računa za advokata sa ID 1
INSERT INTO Racun (PredmetID, Datum, Zaduženje,Valuta)
VALUES 
(2, '2024-01-28', 1800.00,'EUR'),
(3, '2024-01-28', 2200.00,'EUR'),
(1, '2024-01-29', 2500.00,'EUR'),
(3, '2024-01-30', 1900.00,'EUR'),
(2, '2024-01-31', 2100.00,'EUR'),
(1, '2024-02-01', 3000.00,'EUR'),
(1, '2024-02-02', 2700.00,'EUR'),
(2, '2024-02-03', 1850.00,'EUR'),
(3, '2024-02-04', 2400.00,'EUR'),
(1, '2024-02-05', 2800.00,'EUR');

select Predmet.PredmetID,Stavke_predmeta.StavkePredmetaID from Predmet inner join Stavke_predmeta on Predmet.PredmetID= Stavke_predmeta.PredmetID inner join Advokat on Advokat.AdvokatID=Stavke_predmeta.AdvokatID
where Advokat.AdvokatID=1

select * from Racun where PredmetID=1

CREATE INDEX IX_Predmet_AdvokatID ON Predmet (AdvokatID);
CREATE INDEX IX_Racun_PredmetID ON Racun (PredmetID);
