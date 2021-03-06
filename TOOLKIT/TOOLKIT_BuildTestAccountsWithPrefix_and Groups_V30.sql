		
/*ALTER PROCEDURE [dbo].[TOOLKIT_BuildTestAccountsWithPrefix_Modified]
(
	@AccountPrefix NVarchar(max), @NumOfAccts int, @IsItAGroup bit
)
AS
*/
/*
Any values that are constant, are set when the variable is declared.  Any values that change with each account are set in the while loop.
	Number of approvers = 3 out of 5 possible
	not defined: CCYxDefaultRateType,  Approver3 and 4
	Set to zero: CCYxSplitAllowance, CCYxManualMatchTolerance,
Acct Segments - General to Specific.   All 10 are defined.
as1=General name, could be @ReconciliationFormatName 
as2=ChildName1-x, 
as3=Group name increment after each child group.
as4-10= AccountPrefix + as# + counter
other asg names could be Number of Approvers, individual/group/child
*/
DECLARE @AccountPrefix NVarchar(50), -- Prefix for AccountSegement1 and AccountName 
	    @NumOfAccts Int,
		@IsItAGroup Bit;

SET NOCOUNT ON;
DECLARE @AcctNameNum    Int = 1;		 -- Starting number to append to AccountName
DECLARE @GroupName      NVarchar(30) = 'Part Of Group'; -- Group Name  ACCOUNT SEGEMENT 2
DECLARE @GroupNameNum		Int = 900;		 -- Starting number for Group name
DECLARE @ChildName      NVarchar(30) = 'Member'; -- Member Name  ACCOUNT SEGMENT 3
DECLARE @ChildNameNum	Int = 1;		 -- Starting number for Member name
DECLARE @NumOfChildAccts Int = 20;			-- Number of child accounts in a group
SELECT   @AccountPrefix = N'Testin',
         @NumOfAccts = 5000,
         @IsItAGroup = 0;
DECLARE @RequiresApproval Bit = 1;
DECLARE @ExcludeFXConversion Bit = 0;
DECLARE @NoChangeBulkFlg Bit = 0;
DECLARE @ReconciliationFormatName AS NVarchar(50) = 'Overlay';


DECLARE @Counter AS Int;
DECLARE @AccountSegment1 AS NVarchar(50);
DECLARE @AccountSegment2 AS NVarchar(50);
DECLARE @AccountSegment3 AS NVarchar(50);
DECLARE @AccountSegment4 AS NVarchar(50);
DECLARE @AccountSegment5 AS NVarchar(50);
DECLARE @AccountSegment6 AS NVarchar(50);
DECLARE @AccountSegment7 AS NVarchar(50);
DECLARE @AccountSegment8 AS NVarchar(50);
DECLARE @AccountSegment9 AS NVarchar(50);
DECLARE @AccountSegment10 AS NVarchar(50);
DECLARE @AccountName AS NVarchar(200);
DECLARE @Description AS NVarchar(MAX);
DECLARE @IsGroup AS Bit = @IsItAGroup;
DECLARE @LocationId AS NVarchar(15);
DECLARE @AccountTypeID AS NVarchar(15);
DECLARE @OwnerId AS NVarchar(15);
DECLARE @QARiskRatingID AS NVarchar(15);
DECLARE @QATestCycleID AS NVarchar(15);
DECLARE @ClearingStandardID AS NVarchar(15);
DECLARE @ZeroBalanceBulkFlg AS Bit = 0;
DECLARE @ReconPolicy AS NVarchar(MAX);
DECLARE @CCY1Code AS Char(3);
DECLARE @CCY1GenerateBalance AS Bit;
DECLARE @CCY1HighBalance AS Money;
DECLARE @CCY1LowBalance AS Money;
DECLARE @CCY2Code AS Char(3);
DECLARE @CCY2GenerateBalance AS Bit;
DECLARE @CCY2HighBalance AS Money;
DECLARE @CCY2LowBalance AS Money;
DECLARE @CCY3Code AS Char(3);
DECLARE @CCY3GenerateBalance AS Bit;
DECLARE @CCY3HighBalance AS Money;
DECLARE @CCY3LowBalance AS Money;
DECLARE @ReconciliationScheduleID AS NVarchar(15);
DECLARE @ReviewScheduleID AS NVarchar(15);
--DECLARE @RequiresApproval AS Bit;
DECLARE @ApprovalScheduleId  AS NVarchar(15) = 'APP1';
DECLARE @Approval2ScheduleId AS NVarchar(15) = 'APP2';
DECLARE @Approval3ScheduleId AS NVarchar(15) = NULL;
DECLARE @Approval4ScheduleId AS NVarchar(15) = NULL;
DECLARE @ReconcilerUserName AS NVarchar(50);
DECLARE @ReviewerUserName AS NVarchar(50);
DECLARE @ApproverUserName AS NVarchar(50);
DECLARE @Approver2UserName AS NVarchar(50);
DECLARE @Approver3UserName AS NVarchar(50);
DECLARE @Approver4UserName AS NVarchar(50);
DECLARE @BUReconcilerUserName AS NVarchar(50);
DECLARE @BUReviewerUserName AS NVarchar(50);
DECLARE @BUApproverUserName AS NVarchar(50);
DECLARE @BUApprover2UserName AS NVarchar(50);
DECLARE @BUApprover3UserName AS NVarchar(50) = NULL;
DECLARE @BUApprover4UserName AS NVarchar(50) = NULL;
--DECLARE @ReconciliationFormatName AS NVarchar(50);
--DECLARE @ExcludeFXConversion AS Bit;
DECLARE @Active AS Bit = 1;
DECLARE @CCY1DefaultRateType AS NVarchar(15) = NULL;
DECLARE @CCY2DefaultRateType AS NVarchar(15) = NULL;
DECLARE @CCY3DefaultRateType AS NVarchar(15) = NULL;
--DECLARE @NoChangeBulkFlg AS Bit;
DECLARE @CCY1SplitAllowance AS Money = 0;
DECLARE @CCY2SplitAllowance AS Money = 0;
DECLARE @CCY3SplitAllowance AS Money = 0;
DECLARE @CCY1ManualMatchTolerance AS Money = 0;
DECLARE @CCY2ManualMatchTolerance AS Money = 0;
DECLARE @CCY3ManualMatchTolerance AS Money = 0;
		
IF EXISTS ( SELECT   * FROM     sys.objects WHERE    object_id = OBJECT_ID(N'[dbo].[AccountsTempTable]') AND type IN ( N'U' ) )
   DROP TABLE dbo.AccountsTempTable;

CREATE TABLE [dbo].[AccountsTempTable](
	[PKID] [int] IDENTITY(1,1) NOT NULL,
	[AccountPKId] [int] NULL,
	[AccountSegment1] [nvarchar](50) NULL,
	[AccountSegment2] [nvarchar](50) NULL,
	[AccountSegment3] [nvarchar](50) NULL,
	[AccountSegment4] [nvarchar](50) NULL,
	[AccountSegment5] [nvarchar](50) NULL,
	[AccountSegment6] [nvarchar](50) NULL,
	[AccountSegment7] [nvarchar](50) NULL,
	[AccountSegment8] [nvarchar](50) NULL,
	[AccountSegment9] [nvarchar](50) NULL,
	[AccountSegment10] [nvarchar](50) NULL,
	[AccountName] [nvarchar](200) NULL,
	[Description] [nvarchar](max) NULL,
	[IsGroup] [bit] NULL,
	[LocationId] [nvarchar](15) NULL,
	[AccountTypeID] [nvarchar](15) NULL,
	[OwnerId] [nvarchar](15) NULL,
	[QARiskRatingID] [nvarchar](15) NULL,
	[QATestCycleID] [nvarchar](15) NULL,
	[ClearingStandardID] [nvarchar](15) NULL,
	[ZeroBalanceBulkFlg] [bit] NULL,
	[ReconPolicy] [nvarchar](max) NULL,
	[CCY1Code] [nchar](3) NULL,
	[CCY1GenerateBalance] [bit] NULL,
	[CCY1HighBalance] [money] NULL,
	[CCY1LowBalance] [money] NULL,
	[CCY2Code] [nchar](3) NULL,
	[CCY2GenerateBalance] [bit] NULL,
	[CCY2HighBalance] [money] NULL,
	[CCY2LowBalance] [money] NULL,
	[CCY3Code] [nchar](3) NULL,
	[CCY3GenerateBalance] [bit] NULL,
	[CCY3HighBalance] [money] NULL,
	[CCY3LowBalance] [money] NULL,
	[ReconciliationScheduleId] [nvarchar](15) NULL,
	[ReviewScheduleId] [nvarchar](15) NULL,
	[RequiresApproval] [bit] NULL,
	[ApprovalScheduleId] [nvarchar](15) NULL,
	[Approval2ScheduleId] [nvarchar](15) NULL,
	[Approval3ScheduleId] [nvarchar](15) NULL,
	[Approval4ScheduleId] [nvarchar](15) NULL,
	[ReconcilerUserName] [nvarchar](50) NULL,
	[ReviewerUserName] [nvarchar](50) NULL,
	[ApproverUserName] [nvarchar](50) NULL,
	[Approver2UserName] [nvarchar](50) NULL,
	[Approver3UserName] [nvarchar](50) NULL,
	[Approver4UserName] [nvarchar](50) NULL,
	[BUReconcilerUserName] [nvarchar](50) NULL,
	[BUReviewerUserName] [nvarchar](50) NULL,
	[BUApproverUserName] [nvarchar](50) NULL,
	[BUApprover2UserName] [nvarchar](50) NULL,
	[BUApprover3UserName] [nvarchar](50) NULL,
	[BUApprover4UserName] [nvarchar](50) NULL,
	[ReconciliationFormatName] [nvarchar](50) NULL,
	[ExcludeFXConversion] [bit] NULL,
	[Active] [bit] NULL,
	[CCY1DefaultRateType] [nvarchar](15) NULL,
	[CCY2DefaultRateType] [nvarchar](15) NULL,
	[CCY3DefaultRateType] [nvarchar](15) NULL,
	[NoChangeBulkFlg] [bit] NULL,
	[BUReconcilerId] [int] NULL,
	[BUReviewerId] [int] NULL,
	[ApproverId] [int] NULL,
	[BUApproverId] [int] NULL,
	[Approver2ID] [int] NULL,
	[BUApprover2ID] [int] NULL,
	[Approver3ID] [int] NULL,
	[BUApprover3ID] [int] NULL,
	[Approver4ID] [int] NULL,
	[BUApprover4ID] [int] NULL,
	[ReconciliationFormatId] [int] NULL,
	[ReconcilerId] [int] NULL,
	[ReviewerId] [int] NULL,
	[CCY1SplitAllowance] [money] NULL,
	[CCY2SplitAllowance] [money] NULL,
	[CCY3SplitAllowance] [money] NULL,
	[CCY1ManualMatchTolerance] [money] NULL,
	[CCY2ManualMatchTolerance] [money] NULL,
	[CCY3ManualMatchTolerance] [money] NULL,
	[CCY1VarianceAllowance] [money] NULL,
	[CCY2VarianceAllowance] [money] NULL,
	[CCY3VarianceAllowance] [money] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO


		
SET @Counter = 1;
			
WHILE ( @Counter <= @NumOfAccts )
   BEGIN
      PRINT 'Creating '+ CASE @IsItAGroup WHEN 0 THEN 'Individual ' ELSE 'Group ' END  +'Account ' + CAST(@Counter AS NVarchar) + ' of ' + CAST(@NumOfAccts AS NVarchar);
      SET @AccountSegment1 = @AccountPrefix + CAST(@GroupNameNum AS NVarchar);
      SET @AccountSegment2 = @GroupName + CAST( @GroupNameNum AS NVarchar);
      SET @AccountSegment3 = @ChildName + CAST( @GroupNameNum AS NVarchar) +'_'+ CAST(@ChildNameNum AS NVarchar);
      SET @AccountSegment4 = @AccountPrefix + '4'+CAST(@ChildNameNum AS NVarchar);
      SET @AccountSegment5 = @AccountPrefix + '5'+CAST(@Counter AS NVarchar);
      SET @AccountSegment6 = @AccountPrefix + '6'+CAST(@Counter AS NVarchar);
      SET @AccountSegment7 = @AccountPrefix + '7'+CAST(@Counter AS NVarchar);
      SET @AccountSegment8 = @AccountPrefix + '8'+CAST(@Counter AS NVarchar);
      SET @AccountSegment9 = @AccountPrefix + '9'+CAST(@Counter AS NVarchar);
      SET @AccountSegment10 = @AccountPrefix + '10'+CAST(@Counter AS NVarchar);
      SET @AccountName = @AccountPrefix + ' Account ' + CAST(@Counter AS NVarchar);
      SET @Description = 'This is the description for ' + @AccountPrefix + ' Account ' + CAST(@Counter AS NVarchar);
--      SET @IsGroup = @IsItAGroup;
      SET @LocationId = ( SELECT TOP 1 Code
                          FROM   dbo.Code_Locations
                          ORDER BY NEWID()
                        );
      SET @AccountTypeID = ( SELECT TOP 1 Code
                             FROM   dbo.Code_AccountTypes
                             ORDER BY NEWID()
                           );
      SET @OwnerId = ( SELECT TOP 1 Code
                       FROM   dbo.Code_Owners
                       ORDER BY NEWID()
                     );
      SET @QARiskRatingID = ( SELECT TOP 1 Code
                              FROM     dbo.Code_QARiskRatings
                              ORDER BY NEWID()
                            );
      SET @QATestCycleID = ( SELECT TOP 1 Code
                             FROM   dbo.Code_QATestCycles
                             ORDER BY NEWID()
                           );
      SET @ClearingStandardID = ( SELECT TOP 1 Code
                                  FROM    dbo.Code_ClearingStandards
                                  ORDER BY NEWID()
                                );
--      SET @ZeroBalanceBulkFlg = 0;
      SET @ReconPolicy = 'This is the reconciliation policy for ' + @AccountPrefix + ' Account ' + CAST(@Counter AS NVarchar);
      SET @CCY1Code = 'USD'
				--( SELECT TOP 1 Code
    --                FROM     dbo.Code_Currencies
    --                ORDER BY NEWID()
    --                );
      SET @CCY1GenerateBalance = 1;
      SET @CCY1HighBalance = ROUND(( RAND() * 100000 ), 2);
      SET @CCY1LowBalance = 0 - ROUND(( RAND() * 100000 ), 2);
      SET @CCY2Code = ( SELECT TOP 1 Code
                        FROM     dbo.Code_Currencies
                        ORDER BY NEWID()
                      );
      SET @CCY2GenerateBalance = 1;
      SET @CCY2HighBalance = ROUND(( RAND() * 100000 ), 2);
      SET @CCY2LowBalance = 0 - ROUND(( RAND() * 100000 ), 2);
      SET @CCY3Code = ( SELECT TOP 1 Code
                        FROM     dbo.Code_Currencies
                        ORDER BY NEWID()
                      );
      SET @CCY3GenerateBalance = 1;
      SET @CCY3HighBalance = ROUND(( RAND() * 100000 ), 2);
      SET @CCY3LowBalance = 0 - ROUND(( RAND() * 100000 ), 2);
      SET @ReconciliationScheduleID = 'Rec'--( SELECT TOP 1 Code
                                      --  FROM    dbo.Code_ReconciliationSchedule
                                      --  ORDER BY NEWID()
                                      --);
      SET @ReviewScheduleID = 'Rev'--( SELECT TOP 1 Code
                              --  FROM   dbo.Code_ReviewSchedule
                              --  ORDER BY NEWID()
                              --);
      --SET @RequiresApproval = @RequireApproval;
      --SET @ApprovalScheduleId = 'APP1';
      --SET @Approval2ScheduleId = 'APP2';
      --SET @Approval3ScheduleId = 'APP3';
      --SET @Approval4ScheduleId = 'APP4';
      SET @ReconcilerUserName = ( SELECT TOP 1 UserName
                                  FROM    dbo.Users
                                  WHERE   PKId > 5
                                          AND Role_Reconciler = 1
                                          AND Active = 1
                                  ORDER BY NEWID()
                                );
      SET @ReviewerUserName = ( SELECT TOP 1 UserName
                                FROM   dbo.Users
                                WHERE  PKId > 5
                                       AND Role_Reviewer = 1
                                       AND Active = 1
                                       AND UserName <> @ReconcilerUserName
                                ORDER BY NEWID()
                              );
      SET @ApproverUserName = ( SELECT TOP 1 UserName
                                FROM   dbo.Users
                                WHERE  UserName LIKE '%ApprUser%'
                                       AND PKId > 5
                                       AND Role_Approver = 1
                                       AND Active = 1
                                       AND UserName NOT IN (@ReconcilerUserName, @ReviewerUserName)
                                ORDER BY NEWID()
                              );
      SET @Approver2UserName = ( SELECT TOP 1 UserName
                                 FROM     dbo.Users
                                 WHERE    UserName LIKE '%AcctOwner%'
                                          AND PKId > 5
                                          AND Role_Approver = 1
                                          AND Active = 1
                                          AND UserName NOT IN (@ReconcilerUserName, @ReviewerUserName, @ApproverUserName)
                                 ORDER BY NEWID()
                               );
	  SET @Approver3UserName  = NULL;-- (SELECT TOP 1 UserName FROM Users WHERE Role_Approver=1 AND Active = 1 AND (UserName <> @ReconcilerUserName AND UserName <> @ReviewerUserName AND UserName <> @ApproverUserName AND UserName <> @Approver2UserName) ORDER BY NEWID())
	  SET @Approver4UserName  = NULL;--(SELECT TOP 1 UserName FROM Users WHERE Role_Approver=1 AND Active = 1 AND (UserName <> @ReconcilerUserName AND UserName <> @ReviewerUserName AND UserName <> @ApproverUserName AND UserName <> @Approver2UserName AND UserName <> @Approver3UserName) ORDER BY NEWID())
      SET @BUReconcilerUserName = ( SELECT TOP 1 UserName
                                  FROM    dbo.Users
                                  WHERE   PKId > 5
                                          AND Role_Reconciler = 1
                                          AND Active = 1
										  AND UserName <> @ReconcilerUserName
                                  ORDER BY NEWID()
                                );
      SET @BUReviewerUserName = ( SELECT TOP 1 UserName
                                FROM   dbo.Users
                                WHERE  PKId > 5
                                       AND Role_Reviewer = 1
                                       AND Active = 1
                                       AND UserName NOT IN ( @ReconcilerUserName,@ReviewerUserName)
                                ORDER BY NEWID()
                              );
      SET @BUApproverUserName = ( SELECT TOP 1 UserName
                                FROM   dbo.Users
                                WHERE  UserName LIKE '%ApprUser%'
                                       AND PKId > 5
                                       AND Role_Approver = 1
                                       AND Active = 1
                                       AND UserName NOT IN ( @ReconcilerUserName, @ReviewerUserName, @ApproverUserName)
                                ORDER BY NEWID()
                              );
      SET @BUApprover2UserName = ( SELECT TOP 1 UserName
                                 FROM     dbo.Users
                                 WHERE    UserName LIKE '%AcctOwner%'
                                          AND PKId > 5
                                          AND Role_Approver = 1
                                          AND Active = 1
                                          AND  UserName NOT IN ( @ReconcilerUserName, @ReviewerUserName, @ApproverUserName, @Approver2UserName)
                                 ORDER BY NEWID()
                               );
      --SET @BUApprover3UserName = NULL;
      --SET @BUApprover4UserName = NULL;
      --SET @ReconciliationFormatName = 'Overlay';
      --SET @ExcludeFXConversion = @ExcludeFXConversionvalue;
      --SET @Active = 1;
      --SET @CCY1DefaultRateType = NULL;
      --SET @CCY2DefaultRateType = NULL;
      --SET @CCY3DefaultRateType = NULL;
      --SET @NoChangeBulkFlg = @NoChangeBulkFlgValue;
      --SET @CCY1SplitAllowance = 0;
      --SET @CCY2SplitAllowance = 0;
      --SET @CCY3SplitAllowance = 0;
      --SET @CCY1ManualMatchTolerance = 0;
      --SET @CCY2ManualMatchTolerance = 0;
      --SET @CCY3ManualMatchTolerance = 0;


      INSERT INTO dbo.AccountsTempTable
         (   AccountSegment1, AccountSegment2, AccountSegment3, AccountSegment4, AccountSegment5, AccountSegment6, AccountSegment7, AccountSegment8, AccountSegment9, AccountSegment10,
			 AccountName, [Description], IsGroup, LocationId, AccountTypeID, OwnerId, QARiskRatingID, QATestCycleID, ClearingStandardID, ZeroBalanceBulkFlg, ReconPolicy,
			 CCY1Code, CCY1GenerateBalance, CCY1HighBalance, CCY1LowBalance,
			 CCY2Code, CCY2GenerateBalance, CCY2HighBalance, CCY2LowBalance,
			 CCY3Code, CCY3GenerateBalance, CCY3HighBalance, CCY3LowBalance,
			 ReconciliationScheduleId, ReviewScheduleId, RequiresApproval, ApprovalScheduleId, Approval2ScheduleId, Approval3ScheduleId, Approval4ScheduleId,
			 ReconcilerUserName, ReviewerUserName, ApproverUserName, Approver2UserName, Approver3UserName, Approver4UserName, 
			 BUReconcilerUserName, BUReviewerUserName, BUApproverUserName, BUApprover2UserName, BUApprover3UserName, BUApprover4UserName,
			 ReconciliationFormatName, ExcludeFXConversion, Active,
			 CCY1DefaultRateType, CCY2DefaultRateType, CCY3DefaultRateType, NoChangeBulkFlg,
			 CCY1SplitAllowance, CCY2SplitAllowance, CCY3SplitAllowance,
			 CCY1ManualMatchTolerance, CCY2ManualMatchTolerance, CCY3ManualMatchTolerance			   )
      VALUES   ( @AccountSegment1, @AccountSegment2, @AccountSegment3, @AccountSegment4, @AccountSegment5, @AccountSegment6, @AccountSegment7, @AccountSegment8, @AccountSegment9, @AccountSegment10,
				 @AccountName, @Description, @IsGroup, @LocationId, @AccountTypeID, @OwnerId, @QARiskRatingID, @QATestCycleID, @ClearingStandardID, @ZeroBalanceBulkFlg, @ReconPolicy,
				 @CCY1Code, @CCY1GenerateBalance, @CCY1HighBalance, @CCY1LowBalance,
				 @CCY2Code, @CCY2GenerateBalance, @CCY2HighBalance, @CCY2LowBalance,
				 @CCY3Code, @CCY3GenerateBalance, @CCY3HighBalance, @CCY3LowBalance,
				 @ReconciliationScheduleID, @ReviewScheduleID, @RequiresApproval, @ApprovalScheduleId, @Approval2ScheduleId, @Approval3ScheduleId, @Approval4ScheduleId,
				 @ReconcilerUserName,@ReviewerUserName, @ApproverUserName, @Approver2UserName, @Approver3UserName, @Approver4UserName,
				 @BUReconcilerUserName, @BUReviewerUserName, @BUApproverUserName, @BUApprover2UserName, @BUApprover3UserName, @BUApprover4UserName,
				 @ReconciliationFormatName, @ExcludeFXConversion, @Active,
				 @CCY1DefaultRateType, @CCY2DefaultRateType, @CCY3DefaultRateType, @NoChangeBulkFlg,
				 @CCY1SplitAllowance, @CCY2SplitAllowance, @CCY3SplitAllowance,
				 @CCY1ManualMatchTolerance, @CCY2ManualMatchTolerance, @CCY3ManualMatchTolerance
			   );
      SET @Counter = @Counter + 1;
	  IF  @ChildNameNum = @NumOfChildAccts
		BEGIN
			SET @ChildNameNum = 1;
			SET @GroupNameNum = @GroupNameNum + 1;
		END
        ELSE 
		SET @ChildNameNum = @ChildNameNum + 1;
   END;
		DECLARE @HistID int;
		DECLARE @Now DateTime = GETDATE();

		SELECT @HistID = MAX(PKID) + 1 FROM Interfaces_History;
/* Insert into Accounts tables */
--		EXEC TOOLKIT_Accounts_Interface 1,@Now,@HistID;

SELECT * FROM dbo.AccountsTempTable;

IF EXISTS ( SELECT   * FROM     sys.objects WHERE    object_id = OBJECT_ID(N'[dbo].[AccountGroupsTempTable]') AND type IN ( N'U' ) )
	DROP TABLE [dbo].[AccountGroupsTempTable]
GO

CREATE TABLE [dbo].[AccountGroupsTempTable](
	[PKID] [int] IDENTITY(1,1) NOT NULL,	[AccountID] [int] NULL,
	[ChildAccountSegment1] [nvarchar](50) NULL, [ChildAccountSegment2] [nvarchar](50) NULL, [ChildAccountSegment3] [nvarchar](50) NULL, [ChildAccountSegment4] [nvarchar](50) NULL, [ChildAccountSegment5] [nvarchar](50) NULL,
 	[ChildAccountSegment6] [nvarchar](50) NULL, [ChildAccountSegment7] [nvarchar](50) NULL, [ChildAccountSegment8] [nvarchar](50) NULL, [ChildAccountSegment9] [nvarchar](50) NULL, [ChildAccountSegment10] [nvarchar](50) NULL,
 	[GroupAccountSegment1] [nvarchar](50) NULL, [GroupAccountSegment2] [nvarchar](50) NULL, [GroupAccountSegment3] [nvarchar](50) NULL,[GroupAccountSegment4] [nvarchar](50) NULL, [GroupAccountSegment5] [nvarchar](50) NULL,
 	[GroupAccountSegment6] [nvarchar](50) NULL, [GroupAccountSegment7] [nvarchar](50) NULL, [GroupAccountSegment8] [nvarchar](50) NULL, [GroupAccountSegment9] [nvarchar](50) NULL, [GroupAccountSegment10] [nvarchar](50) NULL,
 	[ActionType] [nvarchar](10) NULL, [GroupID] [int] NULL, [IsGroup] [bit] NULL
) ON [PRIMARY]

GO

