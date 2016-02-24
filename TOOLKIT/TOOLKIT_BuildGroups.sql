
/*****************************************************************************************************
 *  TOOLKIT_BuildGroups procedure:                                                                   *
 *      @NumberOfGroups - Number of Group Accounts to Create                                         *
 *      @ChildrenPerGroup - Number of Child Accounts per Group                                       *
 *  PURPOSE: Automatically uses the previous procedures to create a given number of group accounts   *
 *           with the given amount of children for each. The account designators are unique on the   *
 *           numbers given, so cluster your groups accordingly (rather than running this twice for   *
 *           1 group of 100 children, run it once for 2 groups of 100 children.                      *
 *****************************************************************************************************/

CREATE PROCEDURE [dbo].[TOOLKIT_BuildGroups]
(
	@NumberOfGroups INT, @ChildrenPerGroup INT
)
AS
	DECLARE @GrpCount INT
	DECLARE @GroupSeg VARCHAR(MAX)
	DECLARE @ChildSeg VARCHAR(MAX)
	SET @GrpCount = 1
	SET @GroupSeg = CONVERT(VARCHAR(MAX),@ChildrenPerGroup) + 'Group'
	PRINT '>> Creating ' + CONVERT(VARCHAR(MAX),@NumberOfGroups) + ' Group Accounts.'
	EXEC TOOLKIT_BuildTestAccountsWithPrefix @GroupSeg,@NumberOfGroups,1
	WHILE (@GrpCount <= @NumberOfGroups)
	BEGIN
		SET @GroupSeg = CONVERT(VARCHAR(MAX),@ChildrenPerGroup) + 'Group' + CONVERT(VARCHAR(MAX),@GrpCount)
		SET @ChildSeg = @GroupSeg + 'Child'
		PRINT '>> Creating ' + CONVERT(VARCHAR(MAX),@ChildrenPerGroup) + ' Child Accounts.'
		EXEC TOOLKIT_BuildTestAccountsWithPrefix @ChildSeg,@ChildrenPerGroup,0
		PRINT '>> Assigning ' + CONVERT(VARCHAR(MAX),@ChildrenPerGroup) + ' Child Accounts.'
		EXEC TOOLKIT_AssignGroups @ChildSeg,@GroupSeg
		SET @GrpCount = @GrpCount + 1
	END

GO

