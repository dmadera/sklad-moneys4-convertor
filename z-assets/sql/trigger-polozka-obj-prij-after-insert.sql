USE [S4_Agenda_PEMA]
GO

CREATE OR ALTER TRIGGER AktualizujPolozkyObjednavkyPrijate
ON Objednavky_PolozkaObjednavkyPrijate
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
	
	/* marze, nakupni cena do polozky */
	UPDATE Objednavky_PolozkaObjednavkyPrijate SET
		Marze_UserData = IIF(Zasoba.HistorickaCena = 0, 0, ROUND(100/Zasoba.HistorickaCena*(Pol.JednCena-Zasoba.HistorickaCena), 2)),
		NakupniCena_UserData = Zasoba.HistorickaCena
	FROM Objednavky_PolozkaObjednavkyPrijate AS Pol
	INNER JOIN inserted ON inserted.ID = Pol.ID
	INNER JOIN Obchod_ObsahPolozkySArtiklem AS Obsah ON Obsah.ID = Pol.ObsahPolozky_ID
	INNER JOIN Sklady_Zasoba AS Zasoba ON Zasoba.ID = Obsah.Zasoba_ID

	SET NOCOUNT OFF;
END