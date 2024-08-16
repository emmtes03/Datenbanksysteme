
CREATE TABLE Mitarbeiter(
        id_Mitarbeiter INT GENERATED ALWAYS AS IDENTITY,
        Vorname varchar(255) NOT NULL ,
        Nachname varchar(255) NOT NULL ,
        Geburtsdatum timestamp NOT NULL ,
        Qualifikation varchar(255) NOT NULL ,
        Tätigkeitsfeld varchar(255) NOT NULL ,
        PRIMARY KEY (id_Mitarbeiter)
        );


        CREATE TYPE Streckeneinheit AS ENUM('km', 'm'); --Enum für die Einheit erstellen
        CREATE TYPE Kraftstoffkategorie AS ENUM('Diesel', 'Benzin', 'Elektro'); --Enum für die Kraftstoffart
        CREATE TABLE Firmenfahrzeuge( -- Eigentlich ist Kennzeichen nicht eindeutig, 1 Kennzeichen kan für 2 Autos gelten
        Kennzeichen varchar(10) NOT NULL, -- a vehicle must have a license
        Kilometerstand  NUMERIC(10,0) NOT NULL ,
        Einheit  Streckeneinheit,
        Fahrzeugkategorie varchar (255),
        Kraftstoff Kraftstoffkategorie,
        --vielleicht noch sowas wie ein Datum wegen Kilometerstand?
        PRIMARY KEY (Kennzeichen),
        CHECK (Kennzeichen ~* '^[A-ZÄÖÜ]{1,3}-[A-ZÄÖÜ]{1,2}-[0-9]{1,4}$') -- entspricht ILIKE (ignoriert Groß und kleinscchreibung)
        );

        CREATE TYPE Euro_Einheit AS ENUM('€');
        CREATE  TABLE Pflegedienstkatalog(
        id_Leistung INT GENERATED ALWAYS AS IDENTITY,
        Bezeichnung varchar (255) NOT NULL ,
        Kategorie varchar (255),
        Preis numeric (7,2) NOT NULL ,-- Preis bis zum 5 Stelligen Betrag beschränkt
        Einheit Euro_Einheit,
        PRIMARY KEY (id_Leistung),
        CHECK ( Preis >= 0 ) -- keine negativen Preise
        );

        CREATE TYPE Geschlecht AS ENUM ('Mann', 'Frau', 'Divers');
        CREATE TABLE Patienten(
        id_Patient INT GENERATED ALWAYS AS IDENTITY,
        Vorname varchar (255) NOT NULL ,
        Nachname varchar (255) NOT NULL ,
        Geburtsdatum timestamp, -- kein Alter notwendig, wenn Geburtsdatum vorhanden
        Geschlecht Geschlecht NOT NULL, --constraint: Männlich, weiblich,divers
        Straße varchar (255) NOT NULL ,
        PLZ varchar(5) NOT NULL ,
        Hausnummer  varchar(3) NOT NULL ,
        Telefonnummer varchar(20),
        Hausarzt varchar(255), ---ERWEITERUNG
        Pflegegrad int, --ERWEITERUNG

        PRIMARY KEY (id_Patient),
        CHECK (PLZ ~ '^[0-9]{5}$'),
        CHECK(Hausnummer ~ '[0-9]{1,2}[a-z]{0,1}'),
        CHECK ( Telefonnummer ~ '^(?:\+?\d{1,3})?[ -]?\(?\d{1,4}\)?[ -]?\d{3,}(?:[ -]?\d{2,})?$' ),
        CHECK(Pflegegrad >= 1),
        CHECK (Pflegegrad <= 5)
        );

        CREATE TABLE Kostenträger( --Bankverbindung eventuell?
        id_Kostenträger int GENERATED ALWAYS AS IDENTITY,
        Name varchar(255),
        PLZ varchar(5),
        Straße varchar(255),
        Hausnummer varchar (3),

        PRIMARY KEY (id_Kostenträger),
        CHECK(Hausnummer ~ '[0-9]{1,2}[a-z]{0,1}'),
        CHECK (PLZ ~ '^[0-9]{5}$')
        );

        CREATE TABLE Fragebogenkatalog(
        id_Frage int GENERATED ALWAYS AS IDENTITY,
        Kategorie varchar(255),
        Beschreibung text,

        PRIMARY KEY (id_Frage)
        );

        --ERWETIERUNG
        CREATE TABLE Arbeitsschichten(
        id_Schicht int GENERATED ALWAYS AS IDENTITY,
        Bezeichnung varchar(255),
        Anfang time,
        Ende time,
        PRIMARY KEY (id_Schicht)
        );


        -- ER TYPEN
        CREATE TABLE Aufträge(
        id_Auftrag int GENERATED ALWAYS AS IDENTITY,
        id_Patient int NOT NULL ,
        Datum timestamp,

        PRIMARY KEY (id_Auftrag),
        FOREIGN KEY (id_Patient) REFERENCES Patienten(id_Patient) ON UPDATE CASCADE
        );

        CREATE TABLE Tourenpläne (
        id_Tour int GENERATED ALWAYS AS IDENTITY,
        Tourname varchar(255),
        Datum timestamp,-- eher so etwas wie ein Gültigkeitsdatum
        Strecke numeric(4,2),
        Einheit Streckeneinheit,
        Kennzeichen varchar(10),

        PRIMARY KEY (id_Tour),
        FOREIGN KEY (Kennzeichen) REFERENCES Firmenfahrzeuge(Kennzeichen),
        CHECK (Kennzeichen ~* '^[A-ZÄÖÜ]{1,3}-[A-ZÄÖÜ]{1,2}-[0-9]{1,4}$') -- entspricht ILIKE (ignoriert Groß und kleinscchreibung)
        );


        CREATE TABLE Auftragspositionen( --hier eventuell noch einen Index einfügen
        id_Auftragsposition int GENERATED ALWAYS AS IDENTITY,
        Preis numeric(7,2),
        Einheit Euro_Einheit, -- Einheit definieren
        id_Leistung int NOT NULL,
        id_Auftrag int NOT NULL,
        id_Tour int, -- Jede Auftragsposition ist einer Tour zugeordnet, kann also integriert werden und muss nich eine eigene Tabelle sein mit Tourpositionen, oder?

        PRIMARY KEY (id_Auftragsposition),
        FOREIGN KEY (id_Leistung) REFERENCES Pflegedienstkatalog,
        FOREIGN KEY (id_Auftrag) REFERENCES  Aufträge (id_Auftrag),
        FOREIGN KEY (id_Tour) REFERENCES  Tourenpläne (id_Tour)
        );




        CREATE TABLE Pflegeeinsätze (
        id_Pflegeeinsatz int GENERATED ALWAYS AS IDENTITY,
        Ankunft timestamp,
        Abfahrt timestamp, --Datum wir nicht gebraucht, wenn Timestamp verwendet wird
        Dauer time, -- eigentlich braucht man das auch nicht
        id_Auftragsposition int NOT NULL ,
        id_Mitarbeiter int NOT NULL ,

        PRIMARY KEY (id_Pflegeeinsatz),
        FOREIGN KEY (id_Auftragsposition) REFERENCES  Auftragspositionen(id_Auftragsposition) ON UPDATE CASCADE,
        FOREIGN KEY (id_Mitarbeiter) REFERENCES  mitarbeiter(id_Mitarbeiter) ON UPDATE CASCADE,
        CHECK (Abfahrt > Ankunft)
        );


        CREATE TABLE Angehörige (
        id_Angehörige int GENERATED ALWAYS AS IDENTITY,
        Vorname varchar (255),
        Nachname varchar(255),
        Telefonnummer varchar (20), --Zahlen die mit 0 anfangen, deshalb kein interger
        Straße varchar(255),
        PLZ varchar(5), -- eigentlich müsste auch hier varchar, da manche PLZ mit 0 anfangen
        Hausnummer varchar(3),
        Beziehung varchar (255),
        id_Patient int NOT NULL,

        PRIMARY KEY (id_Angehörige),
        FOREIGN KEY (id_Patient) REFERENCES Patienten(id_Patient) ON UPDATE CASCADE,-- Wenn es keinen Patienten gibt, dann auch keine Angehörigen
        CHECK (PLZ ~ '^[0-9]{5}$'),
        CHECK(Hausnummer ~ '[0-9]{1,2}[a-z]{0,1}'),
        CHECK ( Telefonnummer ~ '^(?:\+?\d{1,3})?[ -]?\(?\d{1,4}\)?[ -]?\d{3,}(?:[ -]?\d{2,})?$' )
        );


        CREATE TABLE Abrechnungen(
        id_Rechnung int GENERATED ALWAYS AS IDENTITY,
        Preis numeric(7,2), -- wegen komma stellen, Gesamtpreis
        Datum timestamp,
        id_Kostenträger int NOT NULL ,

        PRIMARY KEY (id_Rechnung),
        FOREIGN KEY (id_Kostenträger) REFERENCES Kostenträger(id_Kostenträger), --Änderung1
        CHECK ( Preis >= 0 )
        );

        -- eine extra Tabelle um den Preis festzuhalten
        CREATE TABLE Rechnungspositionen ( -- müsste Rechnungsposition sein, Änderung1
        id_Rechnungsposition int GENERATED ALWAYS AS IDENTITY, --Änderung1
        Preis numeric(7,2),
        Datum timestamp,
        id_Rechnung int NOT NULL ,
        id_Pflegeeinsatz int NOT NULL , --Änderung1 anstatt Kostenträger -> steht in id_Rechnung

        PRIMARY KEY (id_Rechnungsposition),
        FOREIGN KEY (id_Rechnung) REFERENCES Abrechnungen(id_Rechnung),
        FOREIGN KEY (id_Pflegeeinsatz) REFERENCES Pflegeeinsätze(id_Pflegeeinsatz),
        CHECK ( Preis >=0 )
        );

        --ERWEITERUNG
        CREATE TABLE Diagnosen(
        id_Patient int,
        ICD_Diagnose varchar (10),
        Gültigkeitsdatum timestamp,
        PRIMARY KEY (id_Patient, ICD_Diagnose),--Zusammengesetzter PK
        CHECK (ICD_Diagnose ~ '^[A-Z][0-9]{2}\.[0-9]{2}$') --z.B. A00.0
        );
        -- R-Typen

        --CREATE TABLE Tourpositionen (
        -- id_Tour int,
        --id_Auftragsposition int, --im Diagram steht Pflegedienst-ID warum?

        -- PRIMARY KEY (id_Tour, id_Auftragsposition),
        --  FOREIGN KEY (id_Tour) REFERENCES Tourenpläne(id_Tour),
        -- FOREIGN KEY  (id_Auftragsposition) REFERENCES Auftragspositionen(id_Auftragsposition)
        --); -- könnte man sich sparen, wenn man die Tour-ID in die Auftragsposition integriert, oder?


        CREATE TYPE Bewertung_Antwort AS ENUM ('sehr gut', 'gut', 'ok', 'schlecht', 'sehr schlecht');
        CREATE TABLE Evaluation (
        Nr_Evaluation int GENERATED ALWAYS AS IDENTITY,
        Datum timestamp,
        id_Mitarbeiter int,
        id_Patient int,
        id_Frage int NOT NULL,
        Bewertung Bewertung_Antwort, -- Auswahlmöglichkeiten

        PRIMARY KEY (Nr_Evaluation),
        FOREIGN KEY (id_Mitarbeiter) REFERENCES mitarbeiter(id_Mitarbeiter) ON UPDATE CASCADE,
        FOREIGN KEY (id_Patient) REFERENCES  Patienten(id_Patient),
        FOREIGN KEY (id_Frage) REFERENCES  Fragebogenkatalog(id_Frage) ON UPDATE CASCADE
        );

        --ERWEITERUNG
        CREATE TABLE Dokumentation(
        id_Dokumentation int,
        id_Pflegeeinsatz int,
        id_Patient int, --Eigentlich reduntant, aber die Zurückverfolgung der Pat-ID könnte sonst zu lange dauern
        id_Mitarbeiter int,
        Zeitpunkt timestamp, -- Zeitpunkt der Dokumentation
        Beschreibung text,
        -- Kein Zusammengesetzte ID, da der Zeitpunkt der Dokumentation entscheident ist
        PRIMARY KEY (id_Dokumentation),
        FOREIGN KEY (id_Pflegeeinsatz) REFERENCES  Pflegeeinsätze(id_Pflegeeinsatz),
        FOREIGN KEY (id_Patient) REFERENCES  Patienten (id_Patient),
        FOREIGN KEY (id_Mitarbeiter) REFERENCES  Mitarbeiter(id_Mitarbeiter) ON UPDATE CASCADE
        );


        --ERWEITERUNG
        CREATE TABLE Dienstplan(
        id_Mitarbeiter int,
        id_Schicht int,
        Datum date, --nur das Datum

        PRIMARY KEY (id_Mitarbeiter,id_Schicht,Datum),
        FOREIGN KEY (id_Schicht) REFERENCES Arbeitsschichten(id_Schicht),
        FOREIGN KEY (id_Mitarbeiter) REFERENCES Mitarbeiter(id_Mitarbeiter) ON UPDATE CASCADE
        );


        --TESTDATEN
        --Mitarbeiter-Tabelle
        INSERT INTO Mitarbeiter (Vorname, Nachname, Geburtsdatum, Qualifikation, Tätigkeitsfeld)
        VALUES ('Max', 'Mustermann', '1990-05-15', 'Pflegefachkraft', 'Stationäre Pflege'),
        ('Anna', 'Beispiel', '1985-09-20', 'Krankenschwester', 'Ambulante Pflege'),
        ('Felix', 'Muster', '1988-11-03', 'Altenpfleger', 'Mobile Pflege');

        INSERT INTO Mitarbeiter (Vorname, Nachname, Geburtsdatum, Qualifikation, Tätigkeitsfeld)
        VALUES
        ('Helena', 'Schmidt', '1990-07-25', 'Altenpfleger', 'Ambulante Pflege'),
        ('Julia', 'Müller', '1980-12-10', 'Krankenschwester', 'Intensivpflege'),
        ('Jan', 'Wagner', '1976-09-02', 'Pflegehelfer', 'Gerontopsychiatrie'),
        ('Sophie', 'Koch', '1995-04-20', 'Pflegedienstleitung', 'Heimleitung'),
        ('Simon', 'Hoffmann', '1988-11-18', 'Gesundheits- und Krankenpfleger', 'Onkologie');


        --Firmenfahrzeug
        INSERT INTO Firmenfahrzeuge (Kennzeichen, Kilometerstand, Einheit, Fahrzeugkategorie, Kraftstoff)
        VALUES ('ABC-XY-123', 12000, 'km', 'Kleinwagen', 'Benzin'),
        ('DEF-ZZ-456', 8500, 'km', 'Transporter', 'Diesel'),
        ('GHI-AB-789', 22000, 'km', 'Limousine', 'Elektro');

        INSERT INTO Firmenfahrzeuge (Kennzeichen, Kilometerstand, Einheit, Fahrzeugkategorie, Kraftstoff)
        VALUES
        ('ABC-YX-123', 50000, 'km', 'Kleinwagen', 'Benzin'),
        ('DEF-ZI-567', 70000, 'km', 'Kombi', 'Diesel'),
        ('DEF-MN-901', 30000, 'km', 'SUV', 'Elektro'),
        ('ABC-RS-345', 90000, 'km', 'Kleinwagen', 'Benzin'),
        ('GHI-WX-789', 60000, 'km', 'Transporter', 'Diesel'),
        ('GHI-BC-234', 40000, 'km', 'Elektroauto', 'Elektro');

        --Pflegedienstkatalog
        INSERT INTO Pflegedienstkatalog (Bezeichnung, Kategorie, Preis, Einheit)
        VALUES ('Grundpflege', 'Pflegeleistungen', 75.00, '€'),
        ('Behandlungspflege', 'Pflegeleistungen', 95.50, '€'),
        ('Hauswirtschaftliche Versorgung', 'Sonstiges', 60.00, '€');

        INSERT INTO Pflegedienstkatalog (Bezeichnung, Kategorie, Preis, Einheit)
        VALUES
        ('Kathetherwechsel', 'Medizinische Versorgung', 75.00, '€'),
        ('Insulin-Verabreichung', 'Medizinische Versorgung', 120.50, '€'),
        ('Begleitung zu Terminen', 'Soziale Betreuung', 50.00, '€'),
        ('24-Stunden-Betreuung', 'Rund-um-die-Uhr-Pflege', 250.00, '€'),
        ('Kochen', 'Sonstiges', 60.00, '€'),
        ('Urlaubsvertretung', 'Flexible Pflegeleistungen', 90.00, '€');

        --Patienten
        INSERT INTO Patienten (Vorname, Nachname, Geburtsdatum, Geschlecht, Straße, PLZ, Hausnummer, Telefonnummer, Hausarzt, Pflegegrad)
        VALUES ('Sophie', 'Schulze', '1960-09-18', 'Frau', 'Schulweg 7', '34567', '23a', '+499876543210', 'Dr. Mayer', 2),
        ('David', 'Becker', '1957-06-30', 'Mann', 'Beckerplatz 5', '56789', '9', '+498765432101', 'Dr. Schneider', 4),
        ('Lena', 'Hoffmann', '1940-12-04', 'Frau', 'Hoffmannstraße 12', '23456', '78', '+491234567890', 'Dr. Meier', 3);

        INSERT INTO Patienten (Vorname, Nachname, Geburtsdatum, Geschlecht, Straße, PLZ, Hausnummer, Telefonnummer, Hausarzt, Pflegegrad)
        VALUES
        ('Max', 'Müller', '1978-05-12', 'Mann', 'Musterstraße 1', '12345', '12', '+49123456789', 'Dr. Schmidt', 3),
        ('Anna', 'Schmidt', '1933-09-20', 'Frau', 'Hauptweg 5', '54321', '7a', '+49876543210', 'Dr. Mayer', 2),
        ('Julia', 'Weber', '1962-02-28', 'Divers', 'Am Park 12', '98765', '101', '+490987654321', 'Dr. Wagner', 4),
        ('Felix', 'Becker', '1955-12-15', 'Mann', 'Bachstraße 8', '13579', '42b', '+491234567890', 'Dr. Meier', 1),
        ('Sophie', 'Schulz', '1951-06-08', 'Frau', 'Gartenweg 3', '24680', '15', '+49987654321', 'Dr. Müller', 5),
        ('Simon', 'Hofmann', '1945-11-25', 'Mann', 'Drosselweg 7', '87654', '3', '+490987654321', 'Dr. Fischer', 3);


        --Kostenträger
        INSERT INTO Kostenträger (Name, PLZ, Straße, Hausnummer)
        VALUES ('Krankenkasse XYZ', '12345', 'Musterstraße 1', '12'),
        ('Unfallversicherung ABC', '54321', 'Beispielweg 5', '3a'),
        ('Pflegekasse DEF', '98765', 'Testgasse 8', '7');

        INSERT INTO Kostenträger (Name, PLZ, Straße, Hausnummer)
        VALUES
        ('Krankenkasse A', '12345', 'Hauptstraße 1', '5'),
        ('Versicherung B', '54321', 'Nebenweg 2', '9c'),
        ('Pflegedienst C', '98765', 'Parkweg 3', '10'),
        ('Krankenkasse D', '13579', 'Bachgasse 4', '18b'),
        ('Versicherung E', '24680', 'Gartenallee 5', '22'),
        ('Krankenkasse F', '87654', 'Drosselstraße 6', '7'),
        ('Versicherung G', '11111', 'Hauptplatz 7', '3a');


        --Fragebogenkatalog
        INSERT INTO Fragebogenkatalog (Kategorie, Beschreibung)
        VALUES ('Umgang mit Patienten', 'Wie zufrieden waren Sie mit dem Umgang Ihnen gegenüber?'),
        ('Pünktlichkeit', 'Wie zufrieden waren Sie mit der Pünktlichkeit des Personals?'),
        ('Befinden', 'Fühlen wohl fühlen Sie sich dem Personal gegenüber?');
        INSERT INTO Fragebogenkatalog (Kategorie, Beschreibung)
        VALUES
        ('Körperliche Gesundheit', 'Wie bewerten Sie Ihr derzeitiges körperliches Befinden?'),
        ('Psychische Verfassung', 'Fühlen sie sich psychisch stabil?'),
        ('Soziales Umfeld', 'Wie gut unterstützen wir Sie in Ihrem sozialen Umfeld?'),
        ('Medikamenteneinnahme', 'Wie gut unterstützen wir Sie bei der Medikamenteneinnahme'),
        ('Lebensqualität', 'Wie gut fördern wir Ihre Lebensqualität?'),
        ('Ernährung', 'Wie gut unterstützen wir Sie in Ihrer Ernährung?');


        --Arbeitsschichten
        INSERT INTO Arbeitsschichten (Bezeichnung, Anfang, Ende)
        VALUES ('Frühschicht', '08:00:00', '16:00:00'),
        ('Spätschicht', '14:00:00', '22:00:00'),
        ('Nachtschicht', '22:00:00', '06:00:00');
        INSERT INTO Arbeitsschichten (Bezeichnung, Anfang, Ende)
        VALUES ('Bereitschaftsdienst', '22:00:00', '06:00:00'),
        ('Alternative Mittagsschicht', '11:00:00', '18:00:00');

        -- Aufträge
        INSERT INTO Aufträge (id_Patient, Datum)
        VALUES (1, '2024-01-09 10:30:00'),
        (2, '2024-01-10 11:45:00'),
        (3, '2024-01-11 09:15:00');

        INSERT INTO Aufträge (id_Patient, Datum)
        VALUES (4, '2023-06-09 15:36:00'),
        (5, '2023-08-10 08:45:00'),
        (6, '2023-09-11 17:15:00'),
        (7, '2023-12-09 15:22:00'),
        (8, '2022-08-10 12:45:00'),
        (9, '2023-10-01 15:36:00');


        --- Tourpläne
        INSERT INTO Tourenpläne (Tourname, Datum, Strecke, Einheit, Kennzeichen)
        VALUES ('Tour 1', '2024-01-09 08:00:00', 90.50, 'km', 'ABC-XY-123'),
        ('Tour 2', '2024-01-10 09:30:00', 85.25, 'km', 'DEF-ZZ-456'),
        ('Tour 3', '2024-01-11 10:15:00', 71.75, 'km', 'GHI-AB-789');

        INSERT INTO Tourenpläne (Tourname, Datum, Strecke, Einheit, Kennzeichen)
        VALUES  ('Tour 4', '2023-01-09 08:00:00', 75.50, 'km', 'ABC-RS-345'),
        ('Tour 5', '2023-01-10 09:30:00', 82.29, 'km', 'DEF-ZZ-456'),
        ('Tour 6', '2023-01-11 10:15:00', 66.75, 'km', 'GHI-BC-234');;

        --Auftragsposition
        INSERT INTO Auftragspositionen (Preis, Einheit, id_Leistung, id_Auftrag, id_Tour)
        VALUES (150.00, '€', 1, 1, 1),
        (200.50, '€', 2, 1, 1),
        (180.75, '€', 3, 2, 3);

        INSERT INTO Auftragspositionen (Preis, Einheit, id_Leistung, id_Auftrag, id_Tour)
        VALUES (120.50, '€', 5, 3, 3),
        (60.00, '€', 8, 1, 1),
        (75.00, '€', 4, 2, 3);

        INSERT INTO Auftragspositionen (Preis, Einheit, id_Leistung, id_Auftrag, id_Tour)
        VALUES (150.00, '€', 1, 3, 3),
        (150.00, '€', 1, 1, 1),
        (200.00, '€', 2, 2, 3);


        --Pflegeeinsätze
        INSERT INTO Pflegeeinsätze (Ankunft, Abfahrt, Dauer, id_Auftragsposition, id_Mitarbeiter)
        VALUES
        ('2024-01-09 08:00:00', '2024-01-09 12:00:00', '04:00:00', 1, 1),
        ('2024-01-10 09:30:00', '2024-01-10 14:00:00', '04:30:00', 2, 2),
        ('2024-01-11 10:15:00', '2024-01-11 13:30:00', '03:15:00', 3, 3);
        INSERT INTO Pflegeeinsätze (Ankunft, Abfahrt, Dauer, id_Auftragsposition, id_Mitarbeiter)
        VALUES
        ('2023-05-09 08:00:00', '2023-05-09 10:15:00', '02:15:00', 4, 5),
        ('2023-07-10 09:30:00', '2023-07-10 10:00:00', '00:30:00', 6, 4),
        ('2023-12-11 10:15:00', '2023-12-11 13:30:00', '03:15:00', 3, 7);

        --Angehörige
        INSERT INTO Angehörige (Vorname, Nachname, Telefonnummer, Straße, PLZ, Hausnummer, Beziehung, id_Patient)
        VALUES
        ('Jana', 'Fischer', '0123456789', 'Seestraße 12', '56789', '12', 'Cousin', 1),
        ('Jonas', 'Müller', '9876543210', 'Bergweg 7', '98765', '7b', 'Onkel', 2),
        ('Laura', 'Schmidt', '0123456789', 'Parkstraße 3', '12345', '3', 'Schwester', 3);

        INSERT INTO Angehörige (Vorname, Nachname, Telefonnummer, Straße, PLZ, Hausnummer, Beziehung, id_Patient)
        VALUES
        ('Anna', 'Müller', '+49123456789', 'Beispielstraße 1', '12345', '5', 'Ehepartner', 1),
        ('Peter', 'Schmidt', '+49876543210', 'Musterweg 2', '54321', '9', 'Elternteil', 7),
        ('Laura', 'Wagner', '+490987654321', 'Testgasse 3', '98765', '10', 'Geschwister', 6),
        ('Max', 'Becker', '+491234567890', 'Probestraße 4', '13579', '18b', 'Freund', 5),
        ('Sophie', 'Fischer', '+49987654321', 'Musterplatz 5', '24680', '22', 'Verwandter', 4);


        --Abrechnungen
        INSERT INTO Abrechnungen (Preis, Datum, id_Kostenträger)
        VALUES
        (125.50, '2023-08-15 09:30:00', 3),
        (200.00, '2023-08-20 14:45:00', 2),
        (75.25, '2023-09-05 11:00:00', 1);

        INSERT INTO Abrechnungen (Preis, Datum, id_Kostenträger)
        VALUES
        (300.50, '2023-08-15 09:30:00', 4),
        (450.00, '2023-08-20 14:45:00', 5),
        (75.25, '2023-09-05 11:00:00', 6);

        -- Rechnungspositionen
        INSERT INTO Rechnungspositionen (Preis, Datum, id_Rechnung, id_Pflegeeinsatz)
        VALUES
        (85.75, '2023-08-15 10:00:00', 1, 3),
        (120.00, '2023-08-20 12:30:00', 2, 2),
        (50.50, '2023-09-05 09:15:00', 3, 1);
        INSERT INTO Rechnungspositionen (Preis, Datum, id_Rechnung, id_Pflegeeinsatz)
        VALUES
        (125.00, '2023-08-15 10:00:00', 4, 4),
        (180.000, '2023-08-20 12:30:00', 2, 6),
        (80.00, '2023-09-05 09:15:00', 1, 5);


        --Diagnosen
        INSERT INTO Diagnosen (id_Patient, ICD_Diagnose, Gültigkeitsdatum)
        VALUES
        (1, 'A00.14', '2023-05-10 08:00:00'),
        (2, 'B12.32', '2023-07-22 11:30:00'),
        (3, 'C45.69', '2023-06-15 09:45:00');

        INSERT INTO Diagnosen (id_Patient, ICD_Diagnose, Gültigkeitsdatum)
        VALUES
        (4, 'D56.21', '2024-08-05 14:20:00'),
        (4, 'E78.42', '2024-09-18 10:10:00'),
        (6, 'F32.92', '2023-11-30 16:45:00');


        --Evaluation
        INSERT INTO Evaluation (Datum, id_Mitarbeiter, id_Patient, id_Frage, Bewertung)
        VALUES
        ('2023-08-15 10:00:00', 1, 1, 1, 'sehr gut'),
        ('2023-08-16 09:30:00', 2, 2, 2, 'ok'),
        ('2023-08-17 11:45:00', 3, 3, 3, 'gut');

        INSERT INTO Evaluation (Datum, id_Mitarbeiter, id_Patient, id_Frage, Bewertung)
        VALUES
        ('2024-08-15 15:00:00', 5, 6, 2, 'sehr schlecht'),
        ('2022-08-16 12:30:00', 7, 8, 4, 'schlecht'),
        ('2023-08-17 16:45:00', 3, 2, 6, 'gut');


        --Dokumentation
        INSERT INTO Dokumentation (id_Dokumentation, id_Pflegeeinsatz, id_Patient, id_Mitarbeiter, Zeitpunkt, Beschreibung)
        VALUES
        (1, 1, 1, 1, '2023-08-15 10:00:00', 'Pflegeeinsatz erfolgreich abgeschlossen.'),
        (2, 3, 2, 1, '2023-08-16 09:30:00', 'Patient zeigte verbesserte Reaktion auf Medikation.'),
        (3, 3, 1, 2, '2023-08-17 11:45:00', 'Plan für weitere Pflegeeinsätze erstellt.');
        INSERT INTO Dokumentation (id_Dokumentation, id_Pflegeeinsatz, id_Patient, id_Mitarbeiter, Zeitpunkt, Beschreibung)
        VALUES
        (4, 2, 3, 2, '2023-08-18 14:20:00', 'Medikation wurde angepasst.'),
        (5, 1, 4, 3, '2023-08-19 08:45:00', 'Verbandwechsel durchgeführt.'),
        (6, 4, 5, 4, '2023-08-20 12:30:00', 'Patient für Rehabilitationsprogramm empfohlen.');


        --Dienstplan

        INSERT INTO Dienstplan (id_Mitarbeiter, id_Schicht, Datum)
        VALUES
        (1, 1, '2023-08-15'),
        (2, 2, '2023-08-16'),
        (3, 3, '2023-08-17');
        INSERT INTO Dienstplan (id_Mitarbeiter, id_Schicht, Datum)
        VALUES
        (4, 1, '2024-08-18'),
        (5, 2, '2024-08-19'),
        (6, 3, '2024-08-20');



        --SQL Statements --Fragen
        -- 1. Welche Pflegeleistung wird am häufigsten in Anspruch genommen?
        SELECT ap.id_Leistung, COUNT(ap.id_Leistung) AS Anzahl
        FROM Auftragspositionen AS ap
        GROUP BY ap.id_Leistung
        ORDER BY Anzahl DESC
        LIMIT 1;

        --2.Wie alt ist der durchschnittliche Patient?
        SELECT ROUND(AVG(EXTRACT(YEAR FROM AGE(current_timestamp, pat.Geburtsdatum))),0)
        FROM Patienten AS pat;

        --3.In welcher Kategorie werden die Mitarbeiter von Ihren Patienten besonders schlecht bewertet?
        SELECT F.Kategorie
        FROM Evaluation AS E
        JOIN Fragebogenkatalog F on E.id_Frage = F.id_Frage
        WHERE E.Bewertung = 'sehr schlecht';

        --- 4.Was ist die zeitlich längste Pflegetour diesen Jahres?
        SELECT T.Tourname, SUM(P.Abfahrt-P.Ankunft) AS Zeitraum
        FROM Auftragspositionen A
        JOIN Tourenpläne T ON T.id_Tour = A.id_Tour
        JOIN Pflegeeinsätze P ON A.id_Auftragsposition = P.id_Auftragsposition
        WHERE EXTRACT(YEAR FROM T.Datum) = 2024
        GROUP BY  T.Tourname, DATE(P.Abfahrt)
        ORDER BY Zeitraum DESC
        LIMIT 1;

        --5.Was ist die durchschnittliche Pflegedauer der ersten 3 Patienten in Stunden?
        SELECT P.id_Patient, AVG(PE.Abfahrt - PE.Ankunft) AS Durchschnittliche_Pflegezeit
        FROM Patienten AS P
        JOIN Aufträge AS A ON P.id_Patient = A.id_Patient
        JOIN Auftragspositionen AS AP ON A.id_Auftrag = AP.id_Auftrag
        JOIN Pflegeeinsätze AS PE ON AP.id_Auftragsposition = PE.id_Auftragsposition
        GROUP BY P.id_Patient
        ORDER BY P.id_Patient ASC
        LIMIT 3;

        --6. Was war die teuerste Tour dieses Jahr?
        SELECT T.id_Tour, T.Tourname, SUM(AP.Preis) AS Gesamtkosten
        FROM Tourenpläne AS T
        JOIN Auftragspositionen AS AP ON T.id_Tour = AP.id_Tour
        WHERE EXTRACT(YEAR FROM T.Datum) = 2024 -- Letztes Jahr
        GROUP BY T.id_Tour, T.Tourname
        ORDER BY Gesamtkosten DESC
        LIMIT 1;

        --7. Wie ist die Durchschnittliche Tourlänge pro Kostenträger?
        SELECT K.id_Kostenträger, AVG(T.Strecke) AS Durchschnittliche_Tourlänge_in_Kilometern
        FROM Kostenträger AS K
        JOIN Abrechnungen A on K.id_Kostenträger = A.id_Kostenträger
        JOIN Rechnungspositionen R on A.id_Rechnung = R.id_Rechnung
        JOIN Pflegeeinsätze P on R.id_Pflegeeinsatz = P.id_Pflegeeinsatz
        JOIN Auftragspositionen A2 on A2.id_Auftragsposition = P.id_Auftragsposition
        JOIN Tourenpläne T on A2.id_Tour = T.id_Tour
        GROUP BY K.id_Kostenträger
        ORDER BY K.id_Kostenträger ASC ;

        --8. Was sind die durchschnittlichen Kosten pro Pflegeleistungskategorie
        SELECT PD.Kategorie, SUM(PD.Preis) AS Gesamtkosten
        FROM Pflegedienstkatalog AS PD
        GROUP BY PD.Kategorie
        ORDER BY Gesamtkosten DESC;




