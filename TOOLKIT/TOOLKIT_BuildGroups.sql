
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
	@NumberOfGroups Int, @ChildrenPerGroup Int
)
AS
	DECLARE @GrpCount Int = 1
	DECLARE @GroupSeg Varchar(MAX)
	DECLARE @ChildSeg Varchar(MAX)
	SET @GroupSeg = CONVERT(Varchar(MAX),@ChildrenPerGroup) + 'Group'

	PRINT '>> Creating ' + CONVERT(Varchar(MAX),@NumberOfGroups) + ' Group Accounts.'
	EXEC dbo.TOOLKIT_BuildTestAccountsWithPrefix @GroupSeg,@NumberOfGroups,1

	WHILE (@GrpCount <= @NumberOfGroups)
	BEGIN
		SET @GroupSeg = CONVERT(Varchar(MAX),@ChildrenPerGroup) + 'Group' + CONVERT(Varchar(MAX),@GrpCount)
		SET @ChildSeg = @GroupSeg + 'Child'

		PRINT '>> Creating ' + CONVERT(Varchar(MAX),@ChildrenPerGroup) + ' Child Accounts.'
		EXEC dbo.TOOLKIT_BuildTestAccountsWithPrefix @ChildSeg,@ChildrenPerGroup,0

		PRINT '>> Assigning ' + CONVERT(Varchar(MAX),@ChildrenPerGroup) + ' Child Accounts.'
		EXEC dbo.TOOLKIT_AssignGroups @ChildSeg,@GroupSeg
		SET @GrpCount = @GrpCount + 1
	END

GO

