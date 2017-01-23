
/************************************************************************************************************************************* 
 *	Procedure: Toolkit_GenerateSLBalances                                                                                            *
 *	Inputs: @ForEffDate datetime, @ZeroBalances bit, @AutoInsert bit                                                                 *
 *	Purpose: Generates balances for all accounts in the system for a given effective date.                                           *
 *	Usage: EXEC dbo.Toolkit_GenerateSLBalances EffectiveDate,ZeroBalance,AutoInsert                                                  *
 *	Example: EXEC dbo.Toolkit_GenerateSLBalances @ForEffDate = '2016-01-30', @ZeroBalances = 0, @AutoInsert = 0                      *
 *	Example:                                                                                                                         * 
	TRUNCATE TABLE	dbo.Interface_LoadStatus 
	EXEC dbo.Toolkit_GenerateSLBalances @ForEffDate = '2016-02-28', @ZeroBalances = 0, @AutoInsert = 1                        
 *	Input Descriptions:                                                                                                              *
 *			@ForEffDate: The effective date for which the balances should be inserted.                                               *
 *			@ZeroBalances: Indicates whether zero balances (1) or random balances (0) should be used                                 *
 *			@AutoInsert: Indicates whether the balances should be put into the database (1) or only output (0 for manual import)     *
 *************************************************************************************************************************************/
IF EXISTS (SELECT OBJECT_ID('dbo.Toolkit_GenerateSLBalances'))
	DROP PROCEDURE dbo.Toolkit_GenerateSLBalances;
GO

CREATE PROCEDURE dbo.Toolkit_GenerateSLBalances
   ( @ForEffDate DateTime,
     @ZeroBalances Bit = 0,
     @AutoInsert Bit = 0
   )
AS
   SET NOCOUNT ON; 
   DECLARE @Period NChar(2);
   DECLARE @Year NChar(4);
   DECLARE @EffectiveDate DateTime;

IF @AutoInsert = 1  -- This table will be re-loaded.
	BEGIN
	   PRINT 'Re-creating SubLedgerBalancesOnlyTempTable'
	   IF EXISTS ( SELECT   * FROM     sys.objects  WHERE    object_id = OBJECT_ID(N'[dbo].[SubLedgerBalancesOnlyTempTable]') AND type IN ( N'U' ) )
		  DROP TABLE dbo.SubLedgerBalancesOnlyTempTable;

	   CREATE TABLE dbo.SubLedgerBalancesOnlyTempTable
		  ( PKId Int IDENTITY(1, 1) NOT NULL,
			AccountPKId Int,
			AccountSegment1 NVarchar(50), AccountSegment2 NVarchar(50), AccountSegment3 NVarchar(50), AccountSegment4 NVarchar(50), AccountSegment5 NVarchar(50),
			AccountSegment6 NVarchar(50), AccountSegment7 NVarchar(50), AccountSegment8 NVarchar(50), AccountSegment9 NVarchar(50), AccountSegment10 NVarchar(50), AccountName NVarchar(200),
			CCY1Code NChar(3), CCY1SubLedBalance Money,
			CCY2Code NChar(3), CCY2SubLedBalance Money,
			CCY3Code NChar(3), CCY3SubLedBalance Money,
			Period NChar(2), Year NChar(4), EffectiveDate DateTime,
			GLHistoryUpdatedFlag Bit
		  );
	END;

   SELECT   @EffectiveDate = EffectiveDate, 
            @Period = FiscalMonth, 
			@Year = FiscalYear
   FROM     dbo.EffectiveDates
   WHERE    EffectiveDate = @ForEffDate;

   PRINT 'Inserting new balances into dbo.SubLedgerBalancesOnlyTempTable '
   INSERT INTO dbo.SubLedgerBalancesOnlyTempTable ( AccountSegment1, AccountSegment2, AccountSegment3, AccountSegment4, AccountSegment5, AccountSegment6,
                                               AccountSegment7, AccountSegment8, AccountSegment9, AccountSegment10, AccountName, CCY1Code, CCY1SubLedBalance,
                                               CCY2Code, CCY2SubLedBalance, CCY3Code, CCY3SubLedBalance, Period, Year, EffectiveDate, GLHistoryUpdatedFlag )
            SELECT   acs.AccountSegment1, acs.AccountSegment2, acs.AccountSegment3, acs.AccountSegment4, acs.AccountSegment5, acs.AccountSegment6,
                     acs.AccountSegment7, acs.AccountSegment8, acs.AccountSegment9, acs.AccountSegment10, acc.AccountName, 
					 acc.CCY1Code,
					 CASE WHEN ISNULL(acc.CCY1Code,'000') <> '000' 
						THEN CASE WHEN @ZeroBalances = 1 THEN 0
							    ELSE  ABS(CAST(NEWID() AS binary(6)) %100000) + 1 --RAND()-- * 100000
						     END 
					 ELSE NULL END AS CCY1SubLedBalance, 
					 acc.CCY2Code, 
					 CASE WHEN ISNULL(acc.CCY2Code,'000') <> '000' 
						THEN CASE WHEN @ZeroBalances = 1 THEN 0
							    ELSE  ABS(CAST(NEWID() AS binary(6)) %100000) + 1 --RAND()-- * 100000
						     END 
					 ELSE NULL END AS CCY2SubLedBalance, 
					 acc.CCY3Code, 
					 CASE WHEN ISNULL(acc.CCY3Code,'000') <> '000' 
						THEN CASE WHEN @ZeroBalances = 1 THEN 0
							    ELSE  ABS(CAST(NEWID() AS binary(6)) %100000) + 1 --RAND()-- * 100000
						     END 
					 ELSE NULL END AS CCY3SubLedBalance, 
					 @Period AS FiscalMonth, @Year AS FiscalYear, @EffectiveDate AS EffectiveDate, 0 AS GLHistoryUpdatedFlag
            FROM     dbo.Accounts acc
                     LEFT OUTER JOIN dbo.AccountSegments acs
                        ON acc.PKId = acs.AccountId
            WHERE    acc.IsGroup <> 1
					 AND (   ISNULL(acc.CCY1Code,'000') <> '000' 
					      OR ISNULL(acc.CCY2Code,'000') <> '000' 
						  OR ISNULL(acc.CCY3Code,'000') <> '000' 
					     )
					AND (acs.AccountSegment1 IS NOT NULL
						 OR acs.AccountSegment2 IS NOT NULL
						 OR acs.AccountSegment3 IS NOT NULL
						 OR acs.AccountSegment4 IS NOT NULL
						 OR acs.AccountSegment5 IS NOT NULL
						 OR acs.AccountSegment6 IS NOT NULL
						 OR acs.AccountSegment7 IS NOT NULL
						 OR acs.AccountSegment8 IS NOT NULL
						 OR acs.AccountSegment9 IS NOT NULL
 						 OR acs.AccountSegment10 IS NOT NULL
					    )
					AND acc.Active = 1  -- Do not create for non-reconcilable accounts.

   IF ( @AutoInsert = 0
        OR @AutoInsert IS NULL
      )
      SELECT   gl.AccountSegment1, gl.AccountSegment2, gl.AccountSegment3, gl.AccountSegment4, gl.AccountSegment5, gl.AccountSegment6, gl.AccountSegment7,
               gl.AccountSegment8, gl.AccountSegment9, gl.AccountSegment10, gl.AccountName, gl.CCY1Code, gl.CCY1SubLedBalance, gl.CCY2Code, gl.CCY2SubLedBalance,
               gl.CCY3Code, gl.CCY3SubLedBalance, gl.Period, gl.Year, gl.EffectiveDate
      FROM     dbo.SubLedgerBalancesOnlyTempTable gl;

   ELSE
      BEGIN
		PRINT 'Adding Indexes.  Running dbo.usp_InterfaceSLBalancesOnly_PRE '
		EXEC [dbo].[usp_InterfaceSLBalancesOnlyPre]

         DECLARE @Now DateTime  = GETDATE();
         DECLARE @HistID Int = (SELECT  MAX(PKId) + 1 FROM  dbo.Interfaces_History);
		
 		 PRINT 'Processing items.  Running dbo.usp_InterfaceSLBalancesOnly '
         EXEC [dbo].[usp_InterfaceSLBalancesOnly]  
            @InterfaceID = 1, 
            @StartTime = @now,
            @InterfaceHistoryPKId = @HistID
			;
      END;

GO
