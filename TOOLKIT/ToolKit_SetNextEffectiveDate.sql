
/*****************************************************************************************************
 *  TOOLKIT_SetEffectiveDate procedure:                                                              *
 *      @StartEffectiveDate - Effective Date to Set                                                  *
 *  PURPOSE: Initializes New accounts NextDates to the given date.                                    *
 *  Example																							 *
    EXEC [dbo].[TOOLKIT_SetNextEffectiveDate] '2016-03-31'
 *																									 *
 *****************************************************************************************************/

CREATE Procedure [dbo].[ToolKit_SetNextEffectiveDate]  
(	@StartEffectiveDate DateTime
) 
AS
BEGIN
SET NOCOUNT ON  
	IF (@StartEffectiveDate IS NULL)
		BEGIN
			PRINT '>> No EffectiveDate Given'
			SET @StartEffectiveDate = GETDATE()
		END

	EXEC dbo.usp_ResetNextDates 'AccountSegments.AccountSegment1',@StartEffectiveDate,''

END;
GO

