		
/*ALTER PROCEDURE [dbo].[TOOLKIT_BuildTestAccountsWithPrefix_Modified]
(
	@AccountPrefix varchar(max), @NumOfAccts int, @IsItAGroup bit
)
AS
*/
SET NOCOUNT ON;
DECLARE @AccountPrefix Varchar(50), -- Prefix for AccountSegement1 and AccountName 
	    @NumOfAccts Int,
		@IsItAGroup Bit;
DECLARE @AcctNameNum    Int = 1;		 -- Starting number to append to AccountName
DECLARE @GroupName      Varchar(30) = 'ItsAGroupName'; -- Group Name  ACCOUNT SEGEMENT 2
DECLARE @GroupNameNum		Int = 900;		 -- Starting number for Group name
DECLARE @ChildName      Varchar(30) = 'ItsAChildName'; -- Member Name  ACCOUNT SEGMENT 3
DECLARE @ChildNameNum	Int = 1;		 -- Starting number for Member name

SELECT   @AccountPrefix = N'Testin',
         @NumOfAccts = 30,
         @IsItAGroup = 0;
DECLARE @Counter AS Int;
DECLARE @AccountSegment1 AS Varchar(50);
DECLARE @AccountSegment2 AS Varchar(50);
DECLARE @AccountSegment3 AS Varchar(50);
DECLARE @AccountSegment4 AS Varchar(50);
DECLARE @AccountSegment5 AS Varchar(50);
DECLARE @AccountSegment6 AS Varchar(50);
DECLARE @AccountSegment7 AS Varchar(50);
DECLARE @AccountSegment8 AS Varchar(50);
DECLARE @AccountSegment9 AS Varchar(50);
DECLARE @AccountSegment10 AS Varchar(50);
DECLARE @AccountName AS Varchar(200);
DECLARE @Description AS Varchar(MAX);
DECLARE @IsGroup AS Bit;
DECLARE @LocationId AS Varchar(15);
DECLARE @AccountTypeID AS Varchar(15);
DECLARE @OwnerId AS Varchar(15);
DECLARE @QARiskRatingID AS Varchar(15);
DECLARE @QATestCycleID AS Varchar(15);
DECLARE @ClearingStandardID AS Varchar(15);
DECLARE @ZeroBalanceBulkFlg AS Bit;
DECLARE @ReconPolicy AS Varchar(MAX);
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
DECLARE @ReconciliationScheduleID AS Varchar(15);
DECLARE @ReviewScheduleID AS Varchar(15);
DECLARE @RequiresApproval AS Bit;
DECLARE @ApprovalScheduleId AS Varchar(15);
DECLARE @Approval2ScheduleId AS Varchar(15);
DECLARE @Approval3ScheduleId AS Varchar(15);
DECLARE @Approval4ScheduleId AS Varchar(15);
DECLARE @ReconcilerUserName AS Varchar(50);
DECLARE @ReviewerUserName AS Varchar(50);
DECLARE @ApproverUserName AS Varchar(50);
DECLARE @Approver2UserName AS Varchar(50);
DECLARE @Approver3UserName AS Varchar(50);
DECLARE @Approver4UserName AS Varchar(50);
DECLARE @BUReconcilerUserName AS Varchar(50);
DECLARE @BUReviewerUserName AS Varchar(50);
DECLARE @BUApproverUserName AS Varchar(50);
DECLARE @BUApprover2UserName AS Varchar(50);
DECLARE @BUApprover3UserName AS Varchar(50);
DECLARE @BUApprover4UserName AS Varchar(50);
DECLARE @ReconciliationFormatName AS Varchar(50);
DECLARE @ExcludeFXConversion AS Bit;
DECLARE @Active AS Bit;
DECLARE @CCY1DefaultRateType AS Varchar(15);
DECLARE @CCY2DefaultRateType AS Varchar(15);
DECLARE @CCY3DefaultRateType AS Varchar(15);
DECLARE @NoChangeBulkFlg AS Bit;
DECLARE @CCY1SplitAllowance AS Money;
DECLARE @CCY2SplitAllowance AS Money;
DECLARE @CCY3SplitAllowance AS Money;
DECLARE @CCY1ManualMatchTolerance AS Money;
DECLARE @CCY2ManualMatchTolerance AS Money;
DECLARE @CCY3ManualMatchTolerance AS Money;
		
IF EXISTS ( SELECT   * FROM     sys.objects WHERE    object_id = OBJECT_ID(N'[dbo].[AccountsTempTable]') AND type IN ( N'U' ) )
   DROP TABLE dbo.AccountsTempTable;

CREATE TABLE [dbo].[AccountsTempTable]
   ( AccountSegment1 Varchar(50),
     AccountSegment2 Varchar(50),
     AccountSegment3 Varchar(50),
     AccountSegment4 Varchar(50),
     AccountSegment5 Varchar(50),
     AccountSegment6 Varchar(50),
     AccountSegment7 Varchar(50),
     AccountSegment8 Varchar(50),
     AccountSegment9 Varchar(50),
     AccountSegment10 Varchar(50),
     AccountName Varchar(200),
     [Description] Text,
     IsGroup Bit,
     LocationId Varchar(15),
     AccountTypeID Varchar(15),
     OwnerId Varchar(15),
     QARiskRatingID Varchar(15),
     QATestCycleID Varchar(15),
     ClearingStandardID Varchar(15),
     ZeroBalanceBulkFlg Bit,
     ReconPolicy Text,
     CCY1Code Char(3),
     CCY1GenerateBalance Bit,
     CCY1HighBalance Money,
     CCY1LowBalance Money,
     CCY2Code Char(3),
     CCY2GenerateBalance Bit,
     CCY2HighBalance Money,
     CCY2LowBalance Money,
     CCY3Code Char(3),
     CCY3GenerateBalance Bit,
     CCY3HighBalance Money,
     CCY3LowBalance Money,
     ReconciliationScheduleId Varchar(15),
     ReviewScheduleId Varchar(15),
     RequiresApproval Bit,
     ApprovalScheduleId Varchar(15),
     Approval2ScheduleId Varchar(15),
     Approval3ScheduleId Varchar(15),
     Approval4ScheduleId Varchar(15),
     ReconcilerUserName Varchar(50),
     ReviewerUserName Varchar(50),
     ApproverUserName Varchar(50),
     Approver2UserName Varchar(50),
     Approver3UserName Varchar(50),
     Approver4UserName Varchar(50),
     BUReconcilerUserName Varchar(50),
     BUReviewerUserName Varchar(50),
     BUApproverUserName Varchar(50),
     BUApprover2UserName Varchar(50),
     BUApprover3UserName Varchar(50),
     BUApprover4UserName Varchar(50),
     ReconciliationFormatName Varchar(50),
     ExcludeFXConversion Bit,
     Active Bit,
     CCY1DefaultRateType Varchar(15),
     CCY2DefaultRateType Varchar(15),
     CCY3DefaultRateType Varchar(15),
     NoChangeBulkFlg Bit,
     CCY1SplitAllowance Money,
     CCY2SplitAllowance Money,
     CCY3SplitAllowance Money,
     CCY1ManualMatchTolerance Money,
     CCY2ManualMatchTolerance Money,
     CCY3ManualMatchTolerance Money,
     AccountPKId Int,
     BUReconcilerId Int,
     BUReviewerId Int,
     ApproverId Int,
     BUApproverId Int,
     Approver2ID Int,
     BUApprover2ID Int,
     Approver3ID Int,
     BUApprover3ID Int,
     Approver4ID Int,
     BUApprover4ID Int,
     ReconciliationFormatId Int,
     ReconcilerId Int,
     ReviewerId Int
   );
		
SET @Counter = 1;
			
WHILE ( @Counter <= @NumOfAccts )
   BEGIN
      PRINT 'Creating '+ CASE @IsItAGroup WHEN 0 THEN 'Individual ' ELSE 'Group ' END  +'Account ' + CAST(@Counter AS Varchar) + ' of ' + CAST(@NumOfAccts AS Varchar);
      SET @AccountSegment1 = @AccountPrefix + CAST(@Counter AS Varchar);
      SET @AccountSegment2 = @GroupName + CAST( @GroupNameNum AS Varchar);
      SET @AccountSegment3 = @ChildName + CAST(@ChildNameNum AS Varchar);
      SET @AccountSegment4 = @AccountPrefix + '4'+CAST(@Counter AS Varchar);
      SET @AccountSegment5 = @AccountPrefix + '5'+CAST(@Counter AS Varchar);
      SET @AccountSegment6 = @AccountPrefix + '6'+CAST(@Counter AS Varchar);
      SET @AccountSegment7 = @AccountPrefix + '7'+CAST(@Counter AS Varchar);
      SET @AccountSegment8 = @AccountPrefix + '8'+CAST(@Counter AS Varchar);
      SET @AccountSegment9 = @AccountPrefix + '9'+CAST(@Counter AS Varchar);
      SET @AccountSegment10 = @AccountPrefix + '10'+CAST(@Counter AS Varchar);
      SET @AccountName = @AccountPrefix + ' Account ' + CAST(@Counter AS Varchar);
      SET @Description = 'This is the description for ' + @AccountPrefix + ' Account ' + CAST(@Counter AS Varchar);
      SET @IsGroup = @IsItAGroup;
      SET @LocationId = ( SELECT TOP 1
                                 Code
                          FROM   dbo.Code_Locations
                          ORDER BY NEWID()
                        );
      SET @AccountTypeID = ( SELECT TOP 1
                                    Code
                             FROM   dbo.Code_AccountTypes
                             ORDER BY NEWID()
                           );
      SET @OwnerId = ( SELECT TOP 1
                              Code
                       FROM   dbo.Code_Owners
                       ORDER BY NEWID()
                     );
      SET @QARiskRatingID = ( SELECT TOP 1
                                       Code
                              FROM     dbo.Code_QARiskRatings
                              ORDER BY NEWID()
                            );
      SET @QATestCycleID = ( SELECT TOP 1
                                    Code
                             FROM   dbo.Code_QATestCycles
                             ORDER BY NEWID()
                           );
      SET @ClearingStandardID = ( SELECT TOP 1
                                          Code
                                  FROM    dbo.Code_ClearingStandards
                                  ORDER BY NEWID()
                                );
      SET @ZeroBalanceBulkFlg = 0;
      SET @ReconPolicy = 'This is the reconciliation policy for ' + @AccountPrefix + ' Account ' + CAST(@Counter AS Varchar);
      SET @CCY1Code = ( SELECT TOP 1
                                 Code
                        FROM     dbo.Code_Currencies
                        ORDER BY NEWID()
                      );
      SET @CCY1GenerateBalance = 1;
      SET @CCY1HighBalance = ROUND(( RAND() * 100000 ), 2);
      SET @CCY1LowBalance = 0 - ROUND(( RAND() * 100000 ), 2);
      SET @CCY2Code = ( SELECT TOP 1
                                 Code
                        FROM     dbo.Code_Currencies
                        ORDER BY NEWID()
                      );
      SET @CCY2GenerateBalance = 1;
      SET @CCY2HighBalance = ROUND(( RAND() * 100000 ), 2);
      SET @CCY2LowBalance = 0 - ROUND(( RAND() * 100000 ), 2);
      SET @CCY3Code = ( SELECT TOP 1
                                 Code
                        FROM     dbo.Code_Currencies
                        ORDER BY NEWID()
                      );
      SET @CCY3GenerateBalance = 1;
      SET @CCY3HighBalance = ROUND(( RAND() * 100000 ), 2);
      SET @CCY3LowBalance = 0 - ROUND(( RAND() * 100000 ), 2);
      SET @ReconciliationScheduleID = ( SELECT TOP 1
                                                Code
                                        FROM    dbo.Code_ReconciliationSchedule
                                        ORDER BY NEWID()
                                      );
      SET @ReviewScheduleID = ( SELECT TOP 1
                                       Code
                                FROM   dbo.Code_ReviewSchedule
                                ORDER BY NEWID()
                              );
      SET @RequiresApproval = 0;
      SET @ApprovalScheduleId = 'APP1';
      SET @Approval2ScheduleId = 'APP2';
      SET @Approval3ScheduleId = 'APP3';
      SET @Approval4ScheduleId = 'APP4';
      SET @ReconcilerUserName = ( SELECT TOP 1
                                          UserName
                                  FROM    dbo.Users
                                  WHERE   PKId > 5
                                          AND Role_Reconciler = 1
                                          AND Active = 1
                                  ORDER BY NEWID()
                                );
      SET @ReviewerUserName = ( SELECT TOP 1
                                       UserName
                                FROM   dbo.Users
                                WHERE  PKId > 5
                                       AND Role_Reviewer = 1
                                       AND Active = 1
                                       AND UserName <> @ReconcilerUserName
                                ORDER BY NEWID()
                              );
      SET @ApproverUserName = ( SELECT TOP 1
                                       UserName
                                FROM   dbo.Users
                                WHERE  UserName LIKE '%ApprUser%'
                                       AND PKId > 5
                                       AND Role_Approver = 1
                                       AND Active = 1
                                       AND ( UserName <> @ReconcilerUserName
                                             AND UserName <> @ReviewerUserName
                                           )
                                ORDER BY NEWID()
                              );
      SET @Approver2UserName = ( SELECT TOP 1
                                          UserName
                                 FROM     dbo.Users
                                 WHERE    UserName LIKE '%AcctOwner%'
                                          AND PKId > 5
                                          AND Role_Approver = 1
                                          AND Active = 1
                                          AND ( UserName <> @ReconcilerUserName
                                                AND UserName <> @ReviewerUserName
                                                AND UserName <> @ApproverUserName
                                              )
                                 ORDER BY NEWID()
                               );
	  SET @Approver3UserName  = NULL;-- (SELECT TOP 1 UserName FROM Users WHERE Role_Approver=1 AND Active = 1 AND (UserName <> @ReconcilerUserName AND UserName <> @ReviewerUserName AND UserName <> @ApproverUserName AND UserName <> @Approver2UserName) ORDER BY NEWID())
	  SET @Approver4UserName  = NULL;--(SELECT TOP 1 UserName FROM Users WHERE Role_Approver=1 AND Active = 1 AND (UserName <> @ReconcilerUserName AND UserName <> @ReviewerUserName AND UserName <> @ApproverUserName AND UserName <> @Approver2UserName AND UserName <> @Approver3UserName) ORDER BY NEWID())
      SET @BUReconcilerUserName = NULL;
      SET @BUReviewerUserName = NULL;
      SET @BUApproverUserName = NULL;
      SET @BUApprover2UserName = NULL;
      SET @BUApprover3UserName = NULL;
      SET @BUApprover4UserName = NULL;
      SET @ReconciliationFormatName = 'Overlay';
      SET @ExcludeFXConversion = 0;
      SET @Active = 1;
      SET @CCY1DefaultRateType = NULL;
      SET @CCY2DefaultRateType = NULL;
      SET @CCY3DefaultRateType = NULL;
      SET @NoChangeBulkFlg = 0;
      SET @CCY1SplitAllowance = 0;
      SET @CCY2SplitAllowance = 0;
      SET @CCY3SplitAllowance = 0;
      SET @CCY1ManualMatchTolerance = 0;
      SET @CCY2ManualMatchTolerance = 0;
      SET @CCY3ManualMatchTolerance = 0;


      INSERT   INTO dbo.AccountsTempTable
               ( AccountSegment1,
                 AccountSegment2,
                 AccountSegment3,
                 AccountSegment4,
                 AccountSegment5,
                 AccountSegment6,
                 AccountSegment7,
                 AccountSegment8,
                 AccountSegment9,
                 AccountSegment10,
                 AccountName,
                 [Description],
                 IsGroup,
                 LocationId,
                 AccountTypeID,
                 OwnerId,
                 QARiskRatingID,
                 QATestCycleID,
                 ClearingStandardID,
                 ZeroBalanceBulkFlg,
                 ReconPolicy,
                 CCY1Code,
                 CCY1GenerateBalance,
                 CCY1HighBalance,
                 CCY1LowBalance,
                 CCY2Code,
                 CCY2GenerateBalance,
                 CCY2HighBalance,
                 CCY2LowBalance,
                 CCY3Code,
                 CCY3GenerateBalance,
                 CCY3HighBalance,
                 CCY3LowBalance,
                 ReconciliationScheduleId,
                 ReviewScheduleId,
                 RequiresApproval,
                 ApprovalScheduleId,
                 Approval2ScheduleId,
                 Approval3ScheduleId,
                 Approval4ScheduleId,
                 ReconcilerUserName,
                 ReviewerUserName,
                 ApproverUserName,
                 Approver2UserName,
                 Approver3UserName,
                 Approver4UserName,
                 BUReconcilerUserName,
                 BUReviewerUserName,
                 BUApproverUserName,
                 BUApprover2UserName,
                 BUApprover3UserName,
                 BUApprover4UserName,
                 ReconciliationFormatName,
                 ExcludeFXConversion,
                 Active,
                 CCY1DefaultRateType,
                 CCY2DefaultRateType,
                 CCY3DefaultRateType,
                 NoChangeBulkFlg,
                 CCY1SplitAllowance,
                 CCY2SplitAllowance,
                 CCY3SplitAllowance,
                 CCY1ManualMatchTolerance,
                 CCY2ManualMatchTolerance,
                 CCY3ManualMatchTolerance
			   )
      VALUES   ( @AccountSegment1,
                 @AccountSegment2,
                 @AccountSegment3,
                 @AccountSegment4,
                 @AccountSegment5,
                 @AccountSegment6,
                 @AccountSegment7,
                 @AccountSegment8,
                 @AccountSegment9,
                 @AccountSegment10,
                 @AccountName,
                 @Description,
                 @IsGroup,
                 @LocationId,
                 @AccountTypeID,
                 @OwnerId,
                 @QARiskRatingID,
                 @QATestCycleID,
                 @ClearingStandardID,
                 @ZeroBalanceBulkFlg,
                 @ReconPolicy,
                 @CCY1Code,
                 @CCY1GenerateBalance,
                 @CCY1HighBalance,
                 @CCY1LowBalance,
                 @CCY2Code,
                 @CCY2GenerateBalance,
                 @CCY2HighBalance,
                 @CCY2LowBalance,
                 @CCY3Code,
                 @CCY3GenerateBalance,
                 @CCY3HighBalance,
                 @CCY3LowBalance,
                 @ReconciliationScheduleID,
                 @ReviewScheduleID,
                 @RequiresApproval,
                 @ApprovalScheduleId,
                 @Approval2ScheduleId,
                 @Approval3ScheduleId,
                 @Approval4ScheduleId,
                 @ReconcilerUserName,
                 @ReviewerUserName,
                 @ApproverUserName,
                 @Approver2UserName,
                 @Approver3UserName,
                 @Approver4UserName,
                 @BUReconcilerUserName,
                 @BUReviewerUserName,
                 @BUApproverUserName,
                 @BUApprover2UserName,
                 @BUApprover3UserName,
                 @BUApprover4UserName,
                 @ReconciliationFormatName,
                 @ExcludeFXConversion,
                 @Active,
                 @CCY1DefaultRateType,
                 @CCY2DefaultRateType,
                 @CCY3DefaultRateType,
                 @NoChangeBulkFlg,
                 @CCY1SplitAllowance,
                 @CCY2SplitAllowance,
                 @CCY3SplitAllowance,
                 @CCY1ManualMatchTolerance,
                 @CCY2ManualMatchTolerance,
                 @CCY3ManualMatchTolerance
			   );
      SET @Counter = @Counter + 1;
	  SET @ChildNameNum = @ChildNameNum + 1;
	  SET @GroupNameNum =  @GroupNameNum + 1;
   END;
		DECLARE @HistID int
		DECLARE @Now DateTime = GETDATE()

		SELECT @HistID = MAX(PKID) + 1 FROM Interfaces_History
/* Insert into Accounts tables */
--		EXEC TOOLKIT_Accounts_Interface 1,@Now,@HistID

SELECT * FROM dbo.AccountsTempTable;
