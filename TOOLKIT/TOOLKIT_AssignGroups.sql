
/*****************************************************************************************
 *  TOOLKIT_AssignGroups procedure:                                                      *
 *      @ChildAccountPrefix - Child AccountSegment Prefix                                *
 *      @GroupAccount - Group AccountSegment                                             *
 *  PURPOSE: Assigns all accounts with the child prefix to the indicated group segment.  *
 *****************************************************************************************/

CREATE PROCEDURE [dbo].[TOOLKIT_AssignGroups]
(
	@ChildAccountPrefix Varchar(MAX), @GroupAccount Varchar(MAX)
)
AS
BEGIN
	DECLARE @GroupID Int;
	DECLARE @Now DateTime;
	SET @Now = GETDATE();
	
	IF ((SELECT COUNT(AccountId) FROM AccountSegments WHERE AccountSegment1 = @GroupAccount) = 1)
	BEGIN
        SELECT @GroupID = AccountId
        FROM   AccountSegments
        WHERE  AccountSegment1 = @GroupAccount;
	END;
	ELSE
	BEGIN
		PRINT 'Invalid Group ' + @GroupAccount;
		RETURN;
	END;
	
    INSERT  INTO Account_Grouping
            SELECT   child.PKId AS AccountId,
                     @GroupID AS GroupId,
                     @Now AS DtAdded,
                     NULL AS DtRemoved,
                     1 AS ActiveFlg
            FROM     Accounts child
                     LEFT OUTER JOIN AccountSegments childSeg ON child.PKId = childSeg.AccountId
            WHERE    childSeg.AccountSegment1 LIKE @ChildAccountPrefix + '%';
	
END;
GO
