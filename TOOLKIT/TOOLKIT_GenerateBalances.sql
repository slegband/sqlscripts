
/************************************************************************************************************************************* 
 *	Procedure: TOOLKIT_GenerateBalances                                                                                              *
 *	Inputs: @ForEffDate datetime, @ZeroBalances bit, @AutoInsert bit                                                                 *
 *	Purpose: Generates balances for all accounts in the system for a given effective date.                                           *
 *	Usage: EXEC TOOLKIT_GenerateBalances EffectiveDate,ZeroBalance,AutoInsert                                                        *
 *	Example: EXEC TOOLKIT_GenerateBalances '20090930',1,1                                                                            *
 *	Input Descriptions:                                                                                                              *
 *			@ForEffDate: The effective date for which the balances should be inserted.                                               *
 *			@ZeroBalances: Indicates whether zero balances (1) or random balances (0) should be used                                 *
 *			@AutoInsert: Indicates whether the balances should be put into the database (1) or only output (0 for manual import)     *
 *************************************************************************************************************************************/

CREATE PROCEDURE [dbo].[TOOLKIT_GenerateBalances] (@ForEffDate DateTime, @ZeroBalances Bit, @AutoInsert Bit)
AS
	DECLARE @CCY1EndBalance Money;
	DECLARE @CCY2EndBalance Money;
	DECLARE @CCY3EndBalance Money;
	DECLARE @Period Char(2);
	DECLARE @Year Char(4);
	DECLARE @EffectiveDate DateTime;

	DECLARE @AS1 Varchar(50);
	DECLARE @AS2 Varchar(50);
	DECLARE @AS3 Varchar(50);
	DECLARE @AS4 Varchar(50);
	DECLARE @AS5 Varchar(50);
	DECLARE @AS6 Varchar(50);
	DECLARE @AS7 Varchar(50);
	DECLARE @AS8 Varchar(50);
	DECLARE @AS9 Varchar(50);
	DECLARE @AS10 Varchar(50);

	DECLARE @AccountName Varchar(200);
	DECLARE @CCY1Code Char(3);
	DECLARE @CCY2Code Char(3);
	DECLARE @CCY3Code Char(3);

	IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BalancesTempTable]') AND type IN (N'U'))
	DROP TABLE [dbo].[BalancesTempTable];

	CREATE TABLE [dbo].[BalancesTempTable]
	(
		[PKId] [Int] IDENTITY(1,1) NOT NULL,
		AccountPKID Int,
		AccountSegment1 Varchar(50),
		AccountSegment2 Varchar(50),
		AccountSegment3 Varchar(50),
		AccountSegment4 Varchar(50),
		AccountSegment5 Varchar(50),
		AccountSegment6 Varchar(50),
		AccountSegment7 Varchar(50),
		AccountSegment8 Varchar(50),
		AccountSegment9 Varchar(50),
		AccountSegment10 Varchar(50),
		AccountName Varchar(200),
		CCY1Code Char(3),
		CCY1EndBalance Money,
		CCY2Code Char(3),
		CCY2EndBalance Money,
		CCY3Code Char(3),
		CCY3EndBalance Money,
		Period Char(2),
		[Year] Char(4),
		EffectiveDate DateTime,
		GLHistoryUpdatedFlag Bit
	);

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
	LEFT OUTER JOIN AccountSegments acs ON acc.PKId = acs.AccountId WHERE acc.IsGroup <> 1;

	OPEN BALANCES;

	FETCH NEXT FROM BALANCES INTO @AS1,@AS2,@AS3,@AS4,@AS5,@AS6,@AS7,@AS8,@AS9,@AS10,@AccountName,@CCY1Code,@CCY2Code,@CCY3Code;

	WHILE (@@FETCH_STATUS <> -1)
	BEGIN
		IF (@ZeroBalances = 1)
		BEGIN
			SET @CCY1EndBalance = 0;
			SET @CCY2EndBalance = 0;
			SET @CCY3EndBalance = 0;
		END;
		ELSE
		BEGIN
			SET @CCY1EndBalance = RAND() * 100000;
			SET @CCY2EndBalance = RAND() * 100000;
			SET @CCY3EndBalance = RAND() * 100000;
		END;
		
		SELECT @EffectiveDate=EffectiveDate,@Period=FiscalMonth,@Year=FiscalYear FROM EffectiveDates WHERE EffectiveDate = @ForEffDate;
		
		INSERT INTO BalancesTempTable 
		(	AccountSegment1,
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
		(	@AS1,
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
		);
		
		FETCH NEXT FROM BALANCES INTO @AS1,@AS2,@AS3,@AS4,@AS5,@AS6,@AS7,@AS8,@AS9,@AS10,@AccountName,@CCY1Code,@CCY2Code,@CCY3Code;
	END;

	CLOSE BALANCES;
	DEALLOCATE BALANCES;

    IF ( @AutoInsert = 0
         OR @AutoInsert IS NULL
       )
      SELECT   AccountSegment1,
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
      FROM     BalancesTempTable;

	ELSE
		BEGIN
			DECLARE @HistID Int;
			DECLARE @Now DateTime  = GETDATE();

			SELECT @HistID = MAX(PKId) + 1 FROM Interfaces_History;

			EXEC TOOLKIT_GLHistory_Import 1,@Now,@HistID;
		END;

GO

