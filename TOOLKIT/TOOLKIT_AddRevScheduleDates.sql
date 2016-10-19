
/*************************************************************************
 *  Usage:                                                               *
 *		EXEC TOOLKIT_AddRevScheduleDates ScheduleID, Number, Frequency   *
 *			ScheduleID - The ScheduleID to Update                        *
 *          Number - The Number of Additional Date Sequences to Add      *
 *          Frequency - ('M','Q','Y') Monthly/Quarterly/Yearly           *
 *************************************************************************/	
CREATE PROCEDURE [dbo].[TOOLKIT_AddRevScheduleDates] 
(
	@ScheduleID Varchar(20),
	@Iterations Int,
	@Frequency Varchar(5)
)
AS
	/****************************************
	 *   Frequency Values:                  *
	 *       'M' = Monthly                  *
	 *       'Q' = Quarterly                *
	 *       'Y' = Yearly (Anually)         *
	 ****************************************/
BEGIN
	DECLARE @EffDate DateTime;
	DECLARE @DueDate DateTime;
	DECLARE @Sequence Int;
	DECLARE @Count Int = 1;

	/* Bail Out on Bad Data */
	IF ((SELECT COUNT(*) FROM Code_ReviewScheduleDates WHERE ScheduleID = @ScheduleID) < 1)
	BEGIN
		PRINT 'ScheduleID Not Found';
		RETURN;
	END;

    SELECT  @EffDate = MAX(EffDate),
            @DueDate = MAX(DueDate),
            @Sequence = MAX(Sequence)
    FROM    Code_ReviewScheduleDates
    WHERE   ScheduleID = @ScheduleID;

	WHILE (@Count <= @Iterations)
		BEGIN	
			IF ( UPPER(@Frequency) = 'M' )
			 BEGIN	
				SET @EffDate = DATEADD(MONTH, 1, @EffDate);
				SET @DueDate = DATEADD(MONTH, 1, @DueDate);
			 END;
			ELSE
			 IF ( UPPER(@Frequency) = 'Q' )
				BEGIN
				   SET @EffDate = DATEADD(MONTH, 3, @EffDate);
				   SET @DueDate = DATEADD(MONTH, 3, @DueDate);
				END;
			 ELSE
				IF ( UPPER(@Frequency) = 'Y' )
				   BEGIN
					  SET @EffDate = DATEADD(YEAR, 1, @EffDate);
					  SET @DueDate = DATEADD(YEAR, 1, @DueDate);
				   END;
				ELSE
				   BEGIN
					  PRINT '**Unrecognized Frequency**';
					  RETURN;
				   END;
			SET @Sequence = @Sequence + 1;

			INSERT INTO Code_ReviewScheduleDates 
			             (ScheduleID, Sequence, DueDate, EffDate) 
			     VALUES (@ScheduleID, @Sequence, @DueDate, @EffDate);
			SET @Count = @Count + 1;
		END;

END;
GO
