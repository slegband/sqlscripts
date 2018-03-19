
/************************************************************************************************************************************* 
 *	Procedure: TOOLKIT_GenerateBalances                                                                                              *
 *	Inputs: @ForEffDate datetime, @ZeroBalances bit, @AutoInsert bit                                                                 *
 *	Purpose: Generates balances for all accounts in the system for a given effective date.                                           *
 *	Usage: EXEC dbo.TOOLKIT_GenerateBalances EffectiveDate,ZeroBalance,AutoInsert                                                    *
 *	Example: EXEC dbo.TOOLKIT_GenerateBalances @ForEffDate = '2016-01-30', @ZeroBalances = 0, @AutoInsert = 0                        *
 *	Example:                                                 
 SELECT * FROM dbo.EffectiveDates                                                                        *
  truncate TABLE	dbo.Interface_LoadStatus 
  EXEC dbo.TOOLKIT_GenerateBalances @ForEffDate = '2016-03-31', @ZeroBalances = 0, @AutoInsert = 0                        
 *	Input Descriptions:                                                                                                              *
 *			@ForEffDate: The effective date for which the balances should be inserted.                                               *
 *			@ZeroBalances: Indicates whether zero balances (1) or random balances (0) should be used                                 *
 *			@AutoInsert: Indicates whether the balances should be put into the database (1) or only output (0 for manual import)     *
 *************************************************************************************************************************************/
 
CREATE PROCEDURE dbo.Toolkit_GenerateBalances
   ( @ForEffDate DateTime,
     @ZeroBalances Bit = 0,
     @AutoInsert Bit = 0
   )
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

   IF EXISTS ( SELECT   *
               FROM     sys.objects
               WHERE    object_id = OBJECT_ID(N'[dbo].[GLBalancesOnlyTempTable]')
                        AND type IN ( N'U' ) )
      DROP TABLE dbo.GLBalancesOnlyTempTable;

   CREATE TABLE dbo.GLBalancesOnlyTempTable
      ( PKId Int IDENTITY(1, 1)
                 NOT NULL,
        AccountPKId Int,
        AccountSegment1 NVarchar(50), AccountSegment2 NVarchar(50), AccountSegment3 NVarchar(50), AccountSegment4 NVarchar(50), AccountSegment5 NVarchar(50),
        AccountSegment6 NVarchar(50), AccountSegment7 NVarchar(50), AccountSegment8 NVarchar(50), AccountSegment9 NVarchar(50), AccountSegment10 NVarchar(50), AccountName NVarchar(200),
        CCY1Code NChar(3), CCY1EndBalance Money,
        CCY2Code NChar(3), CCY2EndBalance Money,
        CCY3Code NChar(3), CCY3EndBalance Money,
        Period NChar(2), Year NChar(4), EffectiveDate DateTime,
        GLHistoryUpdatedFlag Bit,
        CCY1NetDebits Money NULL, CCY2NetDebits Money NULL, CCY3NetDebits Money NULL,
        CCY1NetCredits Money NULL, CCY2NetCredits Money NULL, CCY3NetCredits Money NULL,
        CCY1TransCount Int NULL, CCY2TransCount Int NULL, CCY3TransCount Int NULL
      );
   SELECT   @EffectiveDate = EffectiveDate, 
            @Period = FiscalMonth, 
			@Year = FiscalYear
   FROM     dbo.EffectiveDates
   WHERE    EffectiveDate = @ForEffDate;

   PRINT ' Inserting new balances into dbo.SubLedgerBalancesOnlyTempTable '

   INSERT   INTO dbo.GLBalancesOnlyTempTable ( AccountSegment1, AccountSegment2, AccountSegment3, AccountSegment4, AccountSegment5, AccountSegment6,
                                               AccountSegment7, AccountSegment8, AccountSegment9, AccountSegment10, AccountName, CCY1Code, CCY1EndBalance,
                                               CCY2Code, CCY2EndBalance, CCY3Code, CCY3EndBalance, Period, Year, EffectiveDate, GLHistoryUpdatedFlag )
            SELECT   acs.AccountSegment1, acs.AccountSegment2, acs.AccountSegment3, acs.AccountSegment4, acs.AccountSegment5, acs.AccountSegment6,
                     acs.AccountSegment7, acs.AccountSegment8, acs.AccountSegment9, acs.AccountSegment10, acc.AccountName, 
					 acc.CCY1Code,
					 CASE WHEN ISNULL(acc.CCY1Code,'000') <> '000' 
						THEN CASE WHEN @ZeroBalances = 1 THEN 0
							    ELSE  ABS(CAST(NEWID() AS binary(6)) %100000) + 1 --RAND()-- * 100000
						     END 
					 ELSE NULL END AS CCY1EndBalance, 
					 acc.CCY2Code, 
					 CASE WHEN ISNULL(acc.CCY2Code,'000') <> '000' 
						THEN CASE WHEN @ZeroBalances = 1 THEN 0
							    ELSE  ABS(CAST(NEWID() AS binary(6)) %100000) + 1 --RAND()-- * 100000
						     END 
					 ELSE NULL END AS CCY2EndBalance, 
					 acc.CCY3Code, 
					 CASE WHEN ISNULL(acc.CCY3Code,'000') <> '000' 
						THEN CASE WHEN @ZeroBalances = 1 THEN 0
							    ELSE  ABS(CAST(NEWID() AS binary(6)) %100000) + 1 --RAND()-- * 100000
						     END 
					 ELSE NULL END AS CCY3EndBalance, 
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
					AND acc.IsAssigned = 1  -- Do not create for non-reconcilable accounts.


   IF ( @AutoInsert = 0
        OR @AutoInsert IS NULL
      )
      SELECT   gl.AccountSegment1, gl.AccountSegment2, gl.AccountSegment3, gl.AccountSegment4, gl.AccountSegment5, gl.AccountSegment6, gl.AccountSegment7,
               gl.AccountSegment8, gl.AccountSegment9, gl.AccountSegment10, gl.AccountName, gl.CCY1Code, gl.CCY1EndBalance, gl.CCY2Code, gl.CCY2EndBalance,
               gl.CCY3Code, gl.CCY3EndBalance, gl.Period, gl.Year, gl.EffectiveDate
      FROM     dbo.GLBalancesOnlyTempTable gl;

   ELSE
      BEGIN
		PRINT 'EXEC dbo.usp_InterfaceGLBalancesOnlyPre'
		EXEC  [dbo].[usp_InterfaceGLBalancesOnlyPre]
		PRINT 'EXEC dbo.usp_InterfaceGLBalancesOnly'
         DECLARE @Now DateTime  = GETDATE();
         DECLARE @HistID Int = (SELECT  MAX(PKId) + 1 FROM  dbo.Interfaces_History);
		
         EXEC dbo.usp_InterfaceGLBalancesOnly
            1,
            @Now,
            @HistID;
      END;

GO
