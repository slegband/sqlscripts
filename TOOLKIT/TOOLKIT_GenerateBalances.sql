
/************************************************************************************************************************************* 
 *	Procedure: TOOLKIT_GenerateBalances                                                                                              *
 *	Inputs: @ForEffDate datetime, @ZeroBalances bit, @AutoInsert bit                                                                 *
 *	Purpose: Generates balances for all accounts in the system for a given effective date.                                           *
 *	Usage: EXEC TOOLKIT_GenerateBalances EffectiveDate,ZeroBalance,AutoInsert                                                        *
 *	Example: EXEC TOOLKIT_GenerateBalances '20170130',0,0                                                                            *
 *	Input Descriptions:                                                                                                              *
 *			@ForEffDate: The effective date for which the balances should be inserted.                                               *
 *			@ZeroBalances: Indicates whether zero balances (1) or random balances (0) should be used                                 *
 *			@AutoInsert: Indicates whether the balances should be put into the database (1) or only output (0 for manual import)     *
 *************************************************************************************************************************************/

CREATE PROCEDURE [dbo].[TOOLKIT_GenerateBalances] (@ForEffDate DateTime, @ZeroBalances Bit, @AutoInsert Bit)
AS
	SET NOCOUNT ON; 
	DECLARE @CCY1EndBalance Money;
	DECLARE @CCY2EndBalance Money;
	DECLARE @CCY3EndBalance Money;
	DECLARE @Period NChar(2);
	DECLARE @Year NChar(4);
	DECLARE @EffectiveDate DateTime;

	DECLARE @AS1 NVarchar(50);
	DECLARE @AS2 NVarchar(50);
	DECLARE @AS3 NVarchar(50);
	DECLARE @AS4 NVarchar(50);
	DECLARE @AS5 NVarchar(50);
	DECLARE @AS6 NVarchar(50);
	DECLARE @AS7 NVarchar(50);
	DECLARE @AS8 NVarchar(50);
	DECLARE @AS9 NVarchar(50);
	DECLARE @AS10 NVarchar(50);

	DECLARE @AccountName NVarchar(200);
	DECLARE @CCY1Code NChar(3);
	DECLARE @CCY2Code NChar(3);
	DECLARE @CCY3Code NChar(3);

	IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BalancesTempTable]') AND type IN (N'U'))
	DROP TABLE [dbo].[GLBalancesOnlyTempTable];

	CREATE TABLE [dbo].[GLBalancesOnlyTempTable]
	(
		[PKId] [Int] IDENTITY(1,1) NOT NULL,
		AccountPKID Int,
		AccountSegment1 NVarchar(50),
		AccountSegment2 NVarchar(50),
		AccountSegment3 NVarchar(50),
		AccountSegment4 NVarchar(50),
		AccountSegment5 NVarchar(50),
		AccountSegment6 NVarchar(50),
		AccountSegment7 NVarchar(50),
		AccountSegment8 NVarchar(50),
		AccountSegment9 NVarchar(50),
		AccountSegment10 NVarchar(50),
		AccountName NVarchar(200),
		CCY1Code NChar(3),
		CCY1EndBalance Money,
		CCY2Code NChar(3),
		CCY2EndBalance Money,
		CCY3Code NChar(3),
		CCY3EndBalance Money,
		Period NChar(2),
		[Year] NChar(4),
		EffectiveDate DateTime,
		GLHistoryUpdatedFlag BIT,
		CCY1NetDebits MONEY NULL,
		CCY2NetDebits MONEY NULL,
		CCY3NetDebits MONEY NULL,
		CCY1NetCredits MONEY NULL,
		CCY2NetCredits MONEY NULL,
		CCY3NetCredits MONEY NULL,
		CCY1TransCount INT NULL,
		CCY2TransCount INT NULL,
		CCY3TransCount INT NULL
	);
		SELECT @EffectiveDate=EffectiveDate,@Period=FiscalMonth,@Year=FiscalYear FROM EffectiveDates WHERE EffectiveDate = @ForEffDate;


INSERT INTO GLBalancesOnlyTempTable 
	(	AccountSegment1, AccountSegment2,AccountSegment3,AccountSegment4,AccountSegment5,
		AccountSegment6,AccountSegment7,AccountSegment8,AccountSegment9,AccountSegment10,
		AccountName,
		CCY1Code, CCY1EndBalance,
		CCY2Code, CCY2EndBalance,
		CCY3Code, CCY3EndBalance,
		Period, [Year], EffectiveDate, GLHistoryUpdatedFlag
	)	
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
		CASE WHEN @ZeroBalances = 1 THEN 0 ELSE RAND() * 100000 END AS CCY1EndBalance,
		acc.CCY2Code,
		CASE WHEN @ZeroBalances = 1 THEN 0 ELSE RAND() * 100000 END AS CCY2EndBalance,
		acc.CCY3Code,
		CASE WHEN @ZeroBalances = 1 THEN 0 ELSE RAND() * 100000 END AS CCY3EndBalance,
		@EffectiveDate AS EffectiveDate,
		@Period AS FiscalMonth,
		@Year AS FiscalYear,
		0 AS GLHistoryUpdatedFlag
	FROM Accounts acc
	LEFT OUTER JOIN AccountSegments acs ON acc.PKId = acs.AccountId WHERE acc.IsGroup <> 1;



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

