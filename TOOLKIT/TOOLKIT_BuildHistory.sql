
/*****************************************************************************************************
 *  TOOLKIT_BuildHistory procedure:                                                                  *
 *      @StartEffectiveDate - Effective Date to Start Run                                            *
 *      @StopEffectiveDate - Effective Date to Stop Run                                              *
 *  PURPOSE: Automatically reconciles all accounts ready for the given date range.                   *
 *****************************************************************************************************/

CREATE PROCEDURE [dbo].[TOOLKIT_BuildHistory]  
(
	@StartEffectiveDate DATETIME, @StopEffectiveDate DATETIME
) 
AS
	DECLARE @DateCounter AS DATETIME
	SET @DateCounter = @StartEffectiveDate
	WHILE (@DateCounter <= @StopEffectiveDate)
	BEGIN
		PRINT '>> Processing Reconciliations For ' + ISNULL(CONVERT(VARCHAR(MAX),@DateCounter),'NULL')
		EXEC TOOLKIT_ReconcileAll @DateCounter
		SELECT @DateCounter = MIN(EffectiveDate) FROM EffectiveDates WHERE EffectiveDate > @DateCounter
	END

GO
