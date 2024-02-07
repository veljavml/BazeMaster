
create database Master2
go
use Master2
go

create table Status
(
StatusID int not null identity(1,1),
Status nvarchar(20)
)

alter table Status
add constraint PK_Status primary key (StatusID)

create table Advokat
(
AdvokatID int not null identity(1,1),
StatusID int not null,
Prezime_i_ime nvarchar(40) not null,
KucniTel nvarchar (15) not null,
MobilniTel nvarchar (15) not null,
)

alter table Advokat
add constraint PK_Advokat primary key (AdvokatID)

create table Klijent
(

KlijentID int not null identity(1,1),
NazivKlijenta nvarchar (15) not null,
Adresa nvarchar (15) not null,
Adresa_placanja nvarchar (15) not null,
Nacin_placanja nvarchar (15) not null,
)

alter table Klijent
add constraint PK_Klijent primary key (KlijentID)

create table Predmet
(

PredmetID int not null identity(1,1),
AdvokatID int not null,
KlijentID int not null,
Naziv nvarchar (15) not null,
Sifra nvarchar (15) not null,
Datum_Otvaranja date not null,
)

alter table Predmet
add constraint PK_Predmet primary key (PredmetID)

create table Racun
(
RacunID int not null identity(1,1),
PredmetID int not null,
Datum date not null,
Zaduženje decimal not null,
Valuta nvarchar(20) not null
)

alter table Racun
add constraint PK_Racun primary key (RacunID)

create table Stavke_predmeta
(
StavkePredmetaID int not null identity(1,1),
AdvokatID int not null,
PredmetID int not null,
RacunID int not null,
Datum date not null,
Opis nvarchar(100) not null,
UkupnoVreme nvarchar(10) not null,
)

alter table Stavke_predmeta
add constraint PK_StavkePredmeta primary key (StavkePredmetaID)



create table Troskovi
(
TroskoviID int not null identity(1,1),
PredmetID int,
RacunID int,
Opis nvarchar(30) not null,
Vrednost decimal not null,
Datum date not null
)

alter table Troskovi
add constraint PK_Troskovi primary key (TroskoviID)

-- Strani ključevi -- 

--Advokat -- 
alter table Advokat
add constraint FK_Advokat_Status foreign key (StatusID) references Status(StatusID)

-- Predmet -- 

alter table Predmet
add constraint FK_Predmet_Advokat foreign key (AdvokatID) references Advokat(AdvokatID)

alter table Predmet
add constraint FK_Predmet_Klijent foreign key (KlijentID) references Klijent(KlijentID)

-- Racun -- 

alter table Racun
add constraint FK_Racun_Predmet foreign key (PredmetID) references Predmet(PredmetID)

-- Troskovi --

alter table Troskovi
add constraint FK_Troskovi_Racun foreign key (RacunID) references Racun(RacunID)

alter table Troskovi
add constraint FK_Troskovi_Premdet foreign key (PredmetID) references Predmet(PredmetID)

-- Stavke predeta --

alter table Stavke_predmeta
add constraint FK_Stavke_predmeta_racun foreign key (RacunID) references Racun(RacunID)

alter table Stavke_predmeta
add constraint FK_Stavke_predmeta_predmet foreign key (PredmetID) references Predmet(PredmetID)

alter table Stavke_predmeta
add constraint FK_Stavke_predmeta_advokat foreign key (AdvokatID) references Advokat(AdvokatID)


-- Podaci --

-- Dodavanje nasumičnih podataka u Status tabelu
INSERT INTO Status (Status)
VALUES ('Active'), ('Inactive'), ('Pending'), ('Closed'), ('On Hold');

-- Dodavanje nasumičnih podataka u Advokat tabelu
INSERT INTO Advokat (StatusID, Prezime_i_ime, KucniTel, MobilniTel)
VALUES 
(1, 'Markovic Marko', '011123456', '0647890123'),
(2, 'Petrovic Jovana', '021654321', '0639876543'),
(1, 'Ivanovic Ana', '031987654', '0601234567')
-- Dodajte još podataka po potrebi...

-- Dodavanje nasumičnih podataka u Klijent tabelu
INSERT INTO Klijent (NazivKlijenta, Adresa, Adresa_placanja, Nacin_placanja)
VALUES 
('Firma A', 'Adresa 1', 'Adresa Placa', 'Gotovina'),
('Firma B', 'Adresa 2', 'Adresa Plac', 'Transakcija'),
('Firma C', 'Adresa 3', 'Adresa Placa', 'Ček')
-- Dodajte još podataka po potrebi...

select * from Klijent
select * from Advokat
-- Dodavanje nasumičnih podataka u Predmet tabeludfokškšgoskš
INSERT INTO Predmet (AdvokatID, KlijentID, Naziv, Sifra, Datum_Otvaranja)
VALUES 
(1, 1, 'Predmet 1', 'SIF123', '2024-01-01'),
(2, 2, 'Predmet 2', 'SIF456', '2024-02-01'),
(3, 3, 'Predmet 3', 'SIF789', '2024-03-01')
-- Dodajte još podataka po potrebi...


select * from Predmet
-- Dodavanje nasumičnih podataka u Racun tabelu
INSERT INTO Racun (PredmetID, Datum, Zaduženje,Valuta)
VALUES 
(1, '2024-01-15', 1500.00,'RSD'),
(2, '2024-02-15', 2000.00,'EUR'),
(3, '2024-03-15', 1000.00,'USD')
-- Dodajte još podataka po potrebi...

select * from Predmet
-- Dodavanje nasumičnih podataka u Stavke_predmeta tabelu
INSERT INTO Stavke_predmeta (AdvokatID, PredmetID, RacunID, Datum, Opis, UkupnoVreme)
VALUES 
(1, 1, 1, '2024-01-20', 'Stavka 1', '10h'),
(2, 2, 2, '2024-02-20', 'Stavka 2', '8h'),
(3, 3, 3, '2024-03-20', 'Stavka 3', '12h')
-- Dodajte još podataka po potrebi...

select * from Racun


-- Dodavanje nasumičnih podataka u Troskovi tabelu
INSERT INTO Troskovi (PredmetID, RacunID, Opis, Vrednost, Datum)
VALUES 
(1, 1, 'Trošak 1', 500.00, '2024-01-25'),
(2, 2, 'Trošak 2', 300.00, '2024-02-25'),
(3, 3, 'Trošak 3', 700.00, '2024-03-25')
-- Dodajte još podataka po potrebi...



