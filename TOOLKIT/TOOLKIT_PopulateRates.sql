
/**********************************************************************************************************************************
 *  TOOLKIT_PopulateRates procedure:                                                                                              *
 *	PURPOSE: Creates 1 to 1 symetric random values for rates.                                                                     *
 *           This means that if USD -> CAD = X then CAD -> USD = 1/X                                                              *
 *  INSTRUCTIONS:                                                                                                                 *
 *       1.) If you are running FX conversion you will need rates                                                                 *
 *           a.) Run this proc (Warning, putting too many currencies in the system may cause this procedure to take a long time)  *
 *       2.) If you are not using FX conversion, you can ignore this procedure                                                    *
 **********************************************************************************************************************************/

CREATE PROCEDURE [dbo].[TOOLKIT_PopulateRates]
AS
	/* Delete Existing Rates */
	DELETE FROM dbo.RateDetails

	/* If no rate types exist, make at least one for processing. */
	IF ((SELECT COUNT(*) FROM dbo.Code_RateTypes) = 0)
        INSERT INTO dbo.Code_RateTypes
               ( [Code], [Name], [Description] )
        VALUES ( 'RATE1', 'Rate 1', 'Rate Type 1' );

	/*  Create entries for every possible combinations of currency codes for every effective date (without self conversions) */
	/*  Run this statement to determine how many rate types will be created for the system */
	/*	SELECT ((SELECT COUNT(*) FROM dbo.Code_Currencies) * (SELECT COUNT(*) FROM dbo.Code_Currencies) * (SELECT COUNT(*) FROM dbo.Code_RateTypes) * (SELECT COUNT(*) FROM dbo.EffectiveDates))*/

	INSERT INTO dbo.RateDetails
	SELECT 
		ef.EffectiveDate AS Date,
		CCYFrom.Code AS CCY1Code, 
		CCYTo.Code AS CCY2Code,
		0 AS Rate, 
		crt.Code AS RateTypeId 
	FROM dbo.Code_Currencies CCYFrom
		CROSS JOIN dbo.Code_Currencies CCYTo
		CROSS JOIN dbo.Code_RateTypes crt
		CROSS JOIN dbo.EffectiveDates ef
	WHERE CCYFrom.Code <> CCYTo.Code


	/************************************************************************************
	 * Go through and update rates to a random value, but when encountering an opposite *
	 * conversion that has already been updated, apply the inverse rate for symmetry.   *
	 ************************************************************************************/
    DECLARE @Date AS DateTime;
    DECLARE @CCYFrom AS Varchar(3);
    DECLARE @CCYTo AS Varchar(3);
    DECLARE @Rate AS Float;
    DECLARE @RateTypeId AS Varchar(15);
    DECLARE @OppositeRate AS Float;
    DECLARE @NewRate AS Float;

    DECLARE RateCursor CURSOR
    FOR
      SELECT   Date,
               CCY1Code,
               CCY2Code,
               Rate,
               RateTypeId
      FROM     dbo.RateDetails;

    OPEN RateCursor;
    FETCH NEXT FROM RateCursor INTO @Date, @CCYFrom, @CCYTo, @Rate, @RateTypeId;
    WHILE ( @@FETCH_STATUS <> -1 )
      BEGIN
         SET @NewRate = RAND();
         SELECT   @OppositeRate = Rate
         FROM     dbo.RateDetails
         WHERE    Date = @Date
                  AND RateTypeId = @RateTypeId
                  AND CCY1Code = @CCYTo
                  AND CCY2Code = @CCYFrom;
         IF ( @OppositeRate = 0 )
            UPDATE   dbo.RateDetails
            SET      Rate = @NewRate
            WHERE    Date = @Date
                     AND RateTypeId = @RateTypeId
                     AND CCY1Code = @CCYFrom
                     AND CCY2Code = @CCYTo;
         ELSE
            UPDATE   dbo.RateDetails
            SET      Rate = 1 / @OppositeRate
            WHERE    Date = @Date
                     AND RateTypeId = @RateTypeId
                     AND CCY1Code = @CCYFrom
                     AND CCY2Code = @CCYTo;

         FETCH NEXT FROM RateCursor INTO @Date, @CCYFrom, @CCYTo, @Rate, @RateTypeId;
      END;
    CLOSE RateCursor;
    DEALLOCATE RateCursor;

GO

