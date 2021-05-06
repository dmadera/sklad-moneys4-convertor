USE [S4_Agenda_PEMA]
GO

CREATE OR ALTER TRIGGER TR_Ceniky_PolozkaCeniku_AfterInsertUpdate
ON Ceniky_PolozkaCeniku
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
	UPDATE Ceniky_PolozkaCeniku SET
		SkladovaCena_UserData = StavCena.JednotkovaSkladovaCena,
		Marze_UserData = IIF(StavCena.JednotkovaSkladovaCena = 0, 0, ROUND(100/StavCena.JednotkovaSkladovaCena*(Cena.Cena-StavCena.JednotkovaSkladovaCena), 2))
	FROM Ceniky_PolozkaCeniku AS Cena 
	INNER JOIN inserted ON inserted.ID = Cena.ID
	INNER JOIN CSW_BI_StavSkladuVCenach AS StavCena ON StavCena.Artikl_ID = Cena.Artikl_ID AND StavCena.Sklad_ID = Cena.Sklad_ID

	UPDATE Ceniky_PolozkaCeniku SET
		NepodlehatSleveDokladu = IIF(Cenik.Kod = '_PRODEJ', 0, 1)
	FROM Ceniky_PolozkaCeniku AS Cena
	INNER JOIN inserted ON inserted.ID = Cena.ID
	INNER JOIN Ceniky_Cenik AS Cenik ON Cenik.ID = Cena.Cenik_ID

	UPDATE Artikly_Artikl SET
		NakupniCena_UserData = StavCena.JednotkovaSkladovaCena,
		Marze_UserData = IIF(StavCena.JednotkovaSkladovaCena = 0, 0, ROUND(100/StavCena.JednotkovaSkladovaCena*(StavCena.JednotkovaCenikovaCena-StavCena.JednotkovaSkladovaCena), 2))
	FROM Artikly_Artikl AS Artikl
	INNER JOIN inserted ON inserted.Artikl_ID = Artikl.ID
	INNER JOIN CSW_BI_StavSkladuVCenach AS StavCena ON StavCena.Artikl_ID = Artikl.ID AND StavCena.Sklad_ID = (SELECT ID FROM Sklady_Sklad WHERE Kod = 'HL')

	SET NOCOUNT OFF;
END