
/*****************************************************************************************************
 *  TOOLKIT_BuildBalanceHistory procedure:                                                           *
 *      @StartEffectiveDate - Effective Date to Start Balance Run                                    *
 *      @StopEffectiveDate - Effective Date to Stop Balance Run                                      *
 *      @ZeroBalance - 0 for Random Balances, 1 for Zero Balances                                    *
 *  PURPOSE: Automatically creates balances for the given date range.                                *
 *****************************************************************************************************/

CREATE PROCEDURE [dbo].[TOOLKIT_BuildBalanceHistory]
   ( @StartEffectiveDate DateTime,
     @StopEffectiveDate DateTime,
     @ZeroBalance Bit
   )
AS
   BEGIN 

      DECLARE @DateCounter AS DateTime;
      SET @DateCounter = @StartEffectiveDate;
      WHILE ( @DateCounter <= @StopEffectiveDate )
         BEGIN
            PRINT '>> Inserting Balances For ' + ISNULL(CONVERT(Varchar(MAX), @DateCounter), 'NULL');
            EXEC TOOLKIT_GenerateBalances @DateCounter, @ZeroBalance, 1;
 
            SELECT   @DateCounter = MIN(EffectiveDate)
            FROM     EffectiveDates
            WHERE    EffectiveDate > @DateCounter;
         END;

   END;

GO

