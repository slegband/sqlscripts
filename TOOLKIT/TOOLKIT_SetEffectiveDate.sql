
/*****************************************************************************************************
 *  TOOLKIT_SetEffectiveDate procedure:                                                              *
 *      @StartEffectiveDate - Effective Date to Set                                                  *
 *  PURPOSE: Initializes the account NextDates to the given date.                                    *
 *****************************************************************************************************/

CREATE Procedure [dbo].[TOOLKIT_SetEffectiveDate]  
(
	@StartEffectiveDate DateTime
) 
AS
BEGIN
	IF (@StartEffectiveDate IS NULL)
	BEGIN
		PRINT '>> No EffectiveDate Given'
		SET @StartEffectiveDate = GETDATE()
	END
	EXEC usp_ResetNextDates 'AccountSegments.AccountSegment1',@StartEffectiveDate,''

END;
GO

