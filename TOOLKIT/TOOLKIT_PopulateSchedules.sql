
/****************************************************************************
 *  TOOLKIT_PopulateSchedules procedure:                                    *
 *	PURPOSE: Creates one of each schedule type with montly values.          *
 *  INSTRUCTIONS:                                                           *
 *       1.) Modify as Necessary                                            *
 *       2.) Run to Create Rec, Rev, and App 1-5 Schedules                  *
 ****************************************************************************/
CREATE PROCEDURE [dbo].[TOOLKIT_PopulateSchedules] (@StartEffDate datetime, @Years int)
AS
	IF (@StartEffDate IS NULL)
		SET @StartEffDate = GetDate()
	--SELECT * FROM Code_ReconciliationSchedule
	--SELECT * FROM Code_ReconciliationScheduleDates
	INSERT INTO Code_ReconciliationSchedule (Code,Name,[Description],CoreType) VALUES ('REC1','REC1','REC1','RT')
	INSERT INTO Code_ReconciliationScheduleDates (ScheduleID, Sequence, DueDate, EffDate) VALUES ('REC1',1,DateAdd(Day,5,@StartEffDate),@StartEffDate)
	
	--SELECT * FROM Code_ReviewSchedule
	--SELECT * FROM Code_ReviewScheduleDates
	INSERT INTO Code_ReviewSchedule (Code,Name,[Description],CoreType) VALUES ('REV1','REV1','REV1','RT')
	INSERT INTO Code_ReviewScheduleDates (ScheduleID, Sequence, DueDate, EffDate) VALUES ('REV1',1,DateAdd(Day,6,@StartEffDate),@StartEffDate)

	--SELECT * FROM code_ApprovalSchedule
	--SELECT * FROM code_ApprovalScheduleDates
	INSERT INTO code_ApprovalSchedule (Code,Name,[Description],CoreType) VALUES ('APP1','APP1','APP1','RT')
	INSERT INTO code_ApprovalScheduleDates (ScheduleID, Sequence, DueDate, EffDate) VALUES ('APP1',1,DateAdd(Day,7,@StartEffDate),@StartEffDate)
	INSERT INTO code_ApprovalSchedule (Code,Name,[Description],CoreType) VALUES ('APP2','APP2','APP2','RT')
	INSERT INTO code_ApprovalScheduleDates (ScheduleID, Sequence, DueDate, EffDate) VALUES ('APP2',1,DateAdd(Day,8,@StartEffDate),@StartEffDate)
	INSERT INTO code_ApprovalSchedule (Code,Name,[Description],CoreType) VALUES ('APP3','APP3','APP3','RT')
	INSERT INTO code_ApprovalScheduleDates (ScheduleID, Sequence, DueDate, EffDate) VALUES ('APP3',1,DateAdd(Day,9,@StartEffDate),@StartEffDate)
	INSERT INTO code_ApprovalSchedule (Code,Name,[Description],CoreType) VALUES ('APP4','APP4','APP4','RT')
	INSERT INTO code_ApprovalScheduleDates (ScheduleID, Sequence, DueDate, EffDate) VALUES ('APP4',1,DateAdd(Day,10,@StartEffDate),@StartEffDate)
	INSERT INTO code_ApprovalSchedule (Code,Name,[Description],CoreType) VALUES ('APP5','APP5','APP5','RT')
	INSERT INTO code_ApprovalScheduleDates (ScheduleID, Sequence, DueDate, EffDate) VALUES ('APP5',1,DateAdd(Day,11,@StartEffDate),@StartEffDate)

	DECLARE @Cycles int
	SET @Cycles = @Years * 12

	EXEC TOOLKIT_AddRecScheduleDates 'REC1',@Cycles,M
	EXEC TOOLKIT_AddRevScheduleDates 'REV1',@Cycles,M
	EXEC TOOLKIT_AddAppScheduleDates 'APP1',@Cycles,M
	EXEC TOOLKIT_AddAppScheduleDates 'APP2',@Cycles,M
	EXEC TOOLKIT_AddAppScheduleDates 'APP3',@Cycles,M
	EXEC TOOLKIT_AddAppScheduleDates 'APP4',@Cycles,M
	EXEC TOOLKIT_AddAppScheduleDates 'APP5',@Cycles,M

	INSERT INTO EffectiveDates
	SELECT 
		EffDate AS EffectiveDate, 
		DATEPART(Month,EffDate) AS FiscalMonth, 
		DATEPART(Year,EffDate) AS FiscalYear, 
		'M' AS ReportingPeriod 
	FROM Code_ReconciliationScheduleDates WHERE ScheduleID='REC1' AND EffDate > (SELECT ISNULL(MAX(EffectiveDate),'19000101') FROM EffectiveDates)

GO
