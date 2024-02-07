SET SHOWPLAN_TEXT On;
SET STATISTICS PROFILE On
DECLARE @AdvokatID INT;
SET @AdvokatID = 2;

-- Prikazivanje zarade za određenog advokata po godinama, mesecima i valuti
SELECT
    YEAR(R.Datum) AS Godina,
    MONTH(R.Datum) AS Mesec,
    R.Zaduženje AS Zarada,
    R.Valuta,
    S.Status AS Status
FROM
    Racun R
JOIN
    Stavke_predmeta SP ON R.RacunID = SP.RacunID
JOIN
    Advokat A ON SP.AdvokatID = A.AdvokatID
JOIN
    Status S ON A.StatusID = S.StatusID
WHERE
    A.AdvokatID = @AdvokatID
ORDER BY
    Godina, Mesec;


	-- Dodavanje indeksa na kolonu RacunID u tabeli Racun
CREATE INDEX idx_Racun_RacunID ON Racun (RacunID);

-- Dodavanje indeksa na kolonu AdvokatID u tabeli Stavke_predmeta
CREATE INDEX idx_Stavke_predmeta_AdvokatID ON Stavke_predmeta (AdvokatID);

-- Dodavanje indeksa na kolonu StatusID u tabeli Status
CREATE INDEX idx_Status_StatusID ON Status (StatusID);

-- Dodavanje indeksa na kolonu Datum u tabeli Racun
CREATE INDEX idx_Racun_Datum ON Racun (Datum);

