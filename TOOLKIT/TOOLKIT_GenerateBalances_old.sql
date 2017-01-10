
CREATE PROCEDURE [dbo].[TOOLKIT_GenerateBalances_updated] (@ForEffDate DATETIME, @ZeroBalances BIT, @AutoInsert BIT)
AS
	DECLARE @CCY1EndBalance MONEY
	DECLARE @CCY2EndBalance MONEY
	DECLARE @CCY3EndBalance MONEY
	DECLARE @Period CHAR(2)
	DECLARE @Year CHAR(4)
	DECLARE @EffectiveDate DATETIME

	DECLARE @AS1 VARCHAR(50)
	DECLARE @AS2 VARCHAR(50)
	DECLARE @AS3 VARCHAR(50)
	DECLARE @AS4 VARCHAR(50)
	DECLARE @AS5 VARCHAR(50)
	DECLARE @AS6 VARCHAR(50)
	DECLARE @AS7 VARCHAR(50)
	DECLARE @AS8 VARCHAR(50)
	DECLARE @AS9 VARCHAR(50)
	DECLARE @AS10 VARCHAR(50)

	DECLARE @AccountName VARCHAR(200)
	DECLARE @CCY1Code CHAR(3)
	DECLARE @CCY2Code CHAR(3)
	DECLARE @CCY3Code CHAR(3)

	IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BalancesTempTable]') AND type IN (N'U'))
	DROP TABLE [dbo].[BalancesTempTable]

	CREATE TABLE [dbo].[BalancesTempTable]
	(
		[PKId] [INT] IDENTITY(1,1) NOT NULL,
		AccountPKID INT,
		AccountSegment1 VARCHAR(50),
		AccountSegment2 VARCHAR(50),
		AccountSegment3 VARCHAR(50),
		AccountSegment4 VARCHAR(50),
		AccountSegment5 VARCHAR(50),
		AccountSegment6 VARCHAR(50),
		AccountSegment7 VARCHAR(50),
		AccountSegment8 VARCHAR(50),
		AccountSegment9 VARCHAR(50),
		AccountSegment10 VARCHAR(50),
		AccountName VARCHAR(200),
		CCY1Code CHAR(3),
		CCY1EndBalance MONEY,
		CCY2Code CHAR(3),
		CCY2EndBalance MONEY,
		CCY3Code CHAR(3),
		CCY3EndBalance MONEY,
		Period CHAR(2),
		[Year] CHAR(4),
		EffectiveDate DATETIME,
		GLHistoryUpdatedFlag BIT
	)

	DECLARE BALANCES CURSOR
	FOR
	SELECT 
		acs.AccountSegment1,
		acs.AccountSegment2,
		acs.AccountSegment3,
		acs.AccountSegment4,
		acs.AccountSegment5,
		acs.AccountSegment6,
		acs.AccountSegment7,
		acs.AccountSegment8,
		acs.AccountSegment9,
		acs.AccountSegment10,
		acc.AccountName,
		acc.CCY1Code,
		acc.CCY2Code,
		acc.CCY3Code
	FROM Accounts acc
	LEFT OUTER JOIN AccountSegments acs ON acc.PKId = acs.AccountId
	WHERE acc.PKId > 700500

	OPEN BALANCES

	FETCH NEXT FROM BALANCES INTO @AS1,@AS2,@AS3,@AS4,@AS5,@AS6,@AS7,@AS8,@AS9,@AS10,@AccountName,@CCY1Code,@CCY2Code,@CCY3Code

	WHILE (@@FETCH_STATUS <> -1)
	BEGIN
		IF ((SELECT ReconciliationFormatID FROM Accounts WHERE AccountName = @AccountName) = 3)
		BEGIN
			SET @CCY1EndBalance = 0
			SET @CCY2EndBalance = 0
			SET @CCY3EndBalance = 0
		END
		ELSE
		BEGIN
			SET @CCY1EndBalance = RAND() * 100000
			SET @CCY2EndBalance = RAND() * 100000
			SET @CCY3EndBalance = RAND() * 100000
		END
		
		SELECT @EffectiveDate=EffectiveDate,@Period=FiscalMonth,@Year=FiscalYear FROM EffectiveDates WHERE EffectiveDate = @ForEffDate
		
		INSERT INTO BalancesTempTable 
		(
			AccountSegment1,
			AccountSegment2,
			AccountSegment3,
			AccountSegment4,
			AccountSegment5,
			AccountSegment6,
			AccountSegment7,
			AccountSegment8,
			AccountSegment9,
			AccountSegment10,
			AccountName,
			CCY1Code,
			CCY1EndBalance,
			CCY2Code,
			CCY2EndBalance,
			CCY3Code,
			CCY3EndBalance,
			Period,
			[Year],
			EffectiveDate
		)
		VALUES
		(
			@AS1,
			@AS2,
			@AS3,
			@AS4,
			@AS5,
			@AS6,
			@AS7,
			@AS8,
			@AS9,
			@AS10,
			@AccountName,
			@CCY1Code,
			@CCY1EndBalance,
			@CCY2Code,
			@CCY2EndBalance,
			@CCY3Code,
			@CCY3EndBalance,
			@Period,
			@Year,
			@EffectiveDate
		)
		

		FETCH NEXT FROM BALANCES INTO @AS1,@AS2,@AS3,@AS4,@AS5,@AS6,@AS7,@AS8,@AS9,@AS10,@AccountName,@CCY1Code,@CCY2Code,@CCY3Code
	END

	CLOSE BALANCES
	DEALLOCATE BALANCES
	IF (@AutoInsert = 0 OR @AutoInsert IS NULL)
		SELECT AccountSegment1,AccountSegment2,AccountSegment3,AccountSegment4,AccountSegment5,AccountSegment6,AccountSegment7,AccountSegment8,AccountSegment9,AccountSegment10,AccountName,CCY1Code,CCY1EndBalance,CCY2Code,CCY2EndBalance,CCY3Code,CCY3EndBalance,Period,[Year],EffectiveDate FROM BalancesTempTable
	ELSE
	BEGIN
		DECLARE @HistID INT
		DECLARE @Now DATETIME
		SET @Now = GETDATE()
		SELECT @HistID = MAX(PKId) + 1 FROM Interfaces_History
		EXEC TOOLKIT_GLHistory_Import 1,@Now,@HistID
	END




GO
