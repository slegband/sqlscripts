
/*****************************************************************************************************
 *  TOOLKIT_BuildBalanceHistory procedure:                                                           *
 *      @StartEffectiveDate - Effective Date to Start Balance Run                                    *
 *      @StopEffectiveDate - Effective Date to Stop Balance Run                                      *
 *      @ZeroBalance - 0 for Random Balances, 1 for Zero Balances                                    *
 *  PURPOSE: Automatically creates balances for the given date range.                                *
 *****************************************************************************************************/

CREATE PROCEDURE [dbo].[TOOLKIT_BuildBalanceHistory]  
(
	@StartEffectiveDate DATETIME, @StopEffectiveDate DATETIME, @ZeroBalance BIT
) 
AS
	DECLARE @DateCounter AS DATETIME
	SET @DateCounter = @StartEffectiveDate
	WHILE (@DateCounter <= @StopEffectiveDate)
	BEGIN
		PRINT '>> Inserting Balances For ' + ISNULL(CONVERT(VARCHAR(MAX),@DateCounter),'NULL')
		EXEC TOOLKIT_GenerateBalances @DateCounter,@ZeroBalance,1
		SELECT @DateCounter = MIN(EffectiveDate) FROM EffectiveDates WHERE EffectiveDate > @DateCounter
	END

GO

