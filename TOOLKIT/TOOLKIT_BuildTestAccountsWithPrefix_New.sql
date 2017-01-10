
CREATE PROCEDURE [dbo].[TOOLKIT_BuildTestAccountsWithPrefix_Modify]
(
	@AccountPrefix VARCHAR(MAX), @Amount INT, @Group BIT
)
AS
		DECLARE @Counter AS INT
		DECLARE @ReconcilerIdMin AS Int
		DECLARE @ReviewerIdMin AS Int
		DECLARE @ApproverIdMin AS Int
		
		IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AccountsTempTable]') AND type IN (N'U'))
		DROP TABLE [dbo].[AccountsTempTable]

CREATE TABLE dbo.AccountsTempTable
   ( PKID Int IDENTITY(1, 1) NOT NULL,
     AccountPKId Int NULL,
     AccountSegment1 NVarchar(50) NULL,
     AccountSegment2 NVarchar(50) NULL,
     AccountSegment3 NVarchar(50) NULL,
     AccountSegment4 NVarchar(50) NULL,
     AccountSegment5 NVarchar(50) NULL,
     AccountSegment6 NVarchar(50) NULL,
     AccountSegment7 NVarchar(50) NULL,
     AccountSegment8 NVarchar(50) NULL,
     AccountSegment9 NVarchar(50) NULL,
     AccountSegment10 NVarchar(50) NULL,
     AccountName NVarchar(200) NULL,
     Description NVarchar(MAX) NULL,
     IsGroup Bit NULL,
     LocationId NVarchar(15) NULL,
     AccountTypeID NVarchar(15) NULL,
     OwnerId NVarchar(15) NULL,
     QARiskRatingID NVarchar(15) NULL,
     QATestCycleID NVarchar(15) NULL,
     ClearingStandardID NVarchar(15) NULL,
     ZeroBalanceBulkFlg Bit NULL,
     ReconPolicy NVarchar(MAX) NULL,
     CCY1Code NChar(3) NULL,
     CCY1GenerateBalance Bit NULL,
     CCY1HighBalance Money NULL,
     CCY1LowBalance Money NULL,
     CCY2Code NChar(3) NULL,
     CCY2GenerateBalance Bit NULL,
     CCY2HighBalance Money NULL,
     CCY2LowBalance Money NULL,
     CCY3Code NChar(3) NULL,
     CCY3GenerateBalance Bit NULL,
     CCY3HighBalance Money NULL,
     CCY3LowBalance Money NULL,
     ReconciliationScheduleId NVarchar(15) NULL,
     ReviewScheduleId NVarchar(15) NULL,
     RequiresApproval Bit NULL,
     ApprovalScheduleId NVarchar(15) NULL,
     Approval2ScheduleId NVarchar(15) NULL,
     Approval3ScheduleId NVarchar(15) NULL,
     Approval4ScheduleId NVarchar(15) NULL,
     ReconcilerUserName NVarchar(50) NULL,
     ReviewerUserName NVarchar(50) NULL,
     ApproverUserName NVarchar(50) NULL,
     Approver2UserName NVarchar(50) NULL,
     Approver3UserName NVarchar(50) NULL,
     Approver4UserName NVarchar(50) NULL,
     BUReconcilerUserName NVarchar(50) NULL,
     BUReviewerUserName NVarchar(50) NULL,
     BUApproverUserName NVarchar(50) NULL,
     BUApprover2UserName NVarchar(50) NULL,
     BUApprover3UserName NVarchar(50) NULL,
     BUApprover4UserName NVarchar(50) NULL,
     ReconciliationFormatName NVarchar(50) NULL,
     ExcludeFXConversion Bit NULL,
     Active Bit NULL,
     CCY1DefaultRateType NVarchar(15) NULL,
     CCY2DefaultRateType NVarchar(15) NULL,
     CCY3DefaultRateType NVarchar(15) NULL,
     NoChangeBulkFlg Bit NULL,
     BUReconcilerId Int NULL,
     BUReviewerId Int NULL,
     ApproverId Int NULL,
     BUApproverId Int NULL,
     Approver2ID Int NULL,
     BUApprover2ID Int NULL,
     Approver3ID Int NULL,
     BUApprover3ID Int NULL,
     Approver4ID Int NULL,
     BUApprover4ID Int NULL,
     ReconciliationFormatId Int NULL,
     ReconcilerId Int NULL,
     ReviewerId Int NULL,
     CCY1SplitAllowance Money NULL,
     CCY2SplitAllowance Money NULL,
     CCY3SplitAllowance Money NULL,
     CCY1ManualMatchTolerance Money NULL,
     CCY2ManualMatchTolerance Money NULL,
     CCY3ManualMatchTolerance Money NULL,
     CCY1VarianceAllowance Money NULL,
     CCY2VarianceAllowance Money NULL,
     CCY3VarianceAllowance Money NULL
   )
		
		SET @Counter = 1
			
		WHILE (@Counter <= @Amount)
		BEGIN
			PRINT 'Creating Account ' + CAST(@Counter AS VARCHAR) + ' of ' + CAST(@Amount AS VARCHAR)
			INSERT INTO [dbo].[AccountsTempTable]
			(
				AccountSegment1,AccountSegment2,AccountSegment3,AccountSegment4,AccountSegment5,AccountSegment6,AccountSegment7,AccountSegment8,AccountSegment9,AccountSegment10,AccountName,
				[Description],IsGroup,LocationID,AccountTypeID,OwnerId,QARiskRatingID,QATestCycleID,ClearingStandardID,ZeroBalanceBulkFlg,ReconPolicy,
				CCY1Code,CCY1GenerateBalance,CCY1HighBalance,CCY1LowBalance,
				CCY2Code,CCY2GenerateBalance,CCY2HighBalance,CCY2LowBalance,
				CCY3Code,CCY3GenerateBalance,CCY3HighBalance,CCY3LowBalance,
				ReconciliationScheduleID,ReviewScheduleID,RequiresApproval,ApprovalScheduleId,Approval2ScheduleId,Approval3ScheduleId,Approval4ScheduleId,
				ReconcilerUserName,ReviewerUserName,ApproverUserName,Approver2UserName,Approver3UserName,Approver4UserName,
				BUReconcilerUserName,BUReviewerUserName,BUApproverUserName,BUApprover2UserName,BUApprover3UserName,BUApprover4UserName,
				ReconciliationFormatName,
				ExcludeFXConversion,
				Active,
				CCY1DefaultRateType,CCY2DefaultRateType,CCY3DefaultRateType,
				NoChangeBulkFlg,
				CCY1SplitAllowance,CCY2SplitAllowance,CCY3SplitAllowance,
				CCY1ManualMatchTolerance,CCY2ManualMatchTolerance,CCY3ManualMatchTolerance
			) 
SELECT   @AccountPrefix + CAST(@Counter AS Varchar) AS AccountSegment1,
         @AccountPrefix + CAST(@Counter AS Varchar) AS AccountSegment2,
         @AccountPrefix + CAST(@Counter AS Varchar) AS AccountSegment3,
         @AccountPrefix + CAST(@Counter AS Varchar) AS AccountSegment4,
         @AccountPrefix + CAST(@Counter AS Varchar) AS AccountSegment5,
         @AccountPrefix + CAST(@Counter AS Varchar) AS AccountSegment6,
         @AccountPrefix + CAST(@Counter AS Varchar) AS AccountSegment7,
         @AccountPrefix + CAST(@Counter AS Varchar) AS AccountSegment8,
         @AccountPrefix + CAST(@Counter AS Varchar) AS AccountSegment9,
         @AccountPrefix + CAST(@Counter AS Varchar) AS AccountSegment10,
         @AccountPrefix + ' Account ' + CAST(@Counter AS Varchar) AS AccountName,
         'This is the description for ' + @AccountPrefix + ' Account ' + CAST(@Counter AS Varchar) AS Description,
         @Group AS IsGroup,
         ( SELECT TOP 1
                  Code
           FROM   dbo.Code_Locations
           ORDER BY NEWID()
         ) AS LocationId,
         ( SELECT TOP 1
                  Code
           FROM   dbo.Code_AccountTypes
           ORDER BY NEWID()
         ) AS AccountTypeID,
         ( SELECT TOP 1
                  Code
           FROM   dbo.Code_Owners
           ORDER BY NEWID()
         ) AS OwnerId,
         ( SELECT TOP 1
                  Code
           FROM   dbo.Code_QARiskRatings
           ORDER BY NEWID()
         ) AS QARiskRatingID,
         ( SELECT TOP 1
                  Code
           FROM   dbo.Code_QATestCycles
           ORDER BY NEWID()
         ) AS QATestCycleID,
         ( SELECT TOP 1
                  Code
           FROM   dbo.Code_ClearingStandards
           ORDER BY NEWID()
         ) AS ClearingStandardID,
         0 AS ZeroBalanceBulkFlg,
         'This is the reconciliation policy for ' + @AccountPrefix + ' Account ' + CAST(@Counter AS Varchar) AS ReconPolicy,
         ( SELECT TOP 1
                  Code
           FROM   dbo.Code_Currencies
           ORDER BY NEWID()
         ) AS CCY1Code,
         1 AS CCY1GenerateBalance,
         ROUND(( RAND() * 100000 ), 2) AS CCY1HighBalance,
         0 - ROUND(( RAND() * 100000 ), 2) AS CCY1LowBalance,
         ( SELECT TOP 1
                  Code
           FROM   dbo.Code_Currencies
           ORDER BY NEWID()
         ) AS CCY2Code,
         1 AS CCY2GenerateBalance,
         ROUND(( RAND() * 100000 ), 2) AS CCY2HighBalance,
         0 - ROUND(( RAND() * 100000 ), 2) AS CCY2LowBalance,
         ( SELECT TOP 1
                  Code
           FROM   dbo.Code_Currencies
           ORDER BY NEWID()
         ) AS CCY3Code,
         1 AS CCY3GenerateBalance,
         ROUND(( RAND() * 100000 ), 2) AS CCY3HighBalance,
         0 - ROUND(( RAND() * 100000 ), 2) AS CCY3LowBalance,
         ( SELECT TOP 1
                  Code
           FROM   dbo.Code_ReconciliationSchedule
           ORDER BY NEWID()
         ) AS ReconciliationScheduleID,
         ( SELECT TOP 1
                  Code
           FROM   dbo.Code_ReviewSchedule
           ORDER BY NEWID()
         ) AS ReviewScheduleID,
         0 AS RequiresApproval,
         ApprovalScheduleId  = 'APP1',
         Approval2ScheduleId = 'APP2',
         Approval3ScheduleId = 'APP3',
         Approval4ScheduleId = 'APP4',
         ReconcilerUserName = ( SELECT TOP 1
                                       UserName
                                FROM   dbo.Users
                                WHERE  PKId > @ReconcilerIdMin
                                       AND Role_Reconciler = 1
                                       AND Active = 1
                                ORDER BY NEWID()
                              ),
         ReviewerUserName = ( SELECT TOP 1
                                       UserName
                              FROM     dbo.Users
                              WHERE    PKId > @ReviewerIdMin
                                       AND Role_Reviewer = 1
                                       AND Active = 1
                                       AND UserName <> @ReconcilerUserName
                              ORDER BY NEWID()
                            ),
         ApproverUserName = ( SELECT TOP 1
                                       UserName
                              FROM     dbo.Users
                              WHERE    UserName LIKE '%ApprUser%'
                                       AND PKId > @ApproverIdMin
                                       AND Role_Approver = 1
                                       AND Active = 1
                                       AND ( UserName <> @ReconcilerUserName
                                             AND UserName <> @ReviewerUserName
                                           )
                              ORDER BY NEWID()
                            ),
         Approver2UserName = ( SELECT TOP 1
                                       UserName
                               FROM    dbo.Users
                               WHERE   UserName LIKE '%AcctOwner%'
                                       AND PKId > @ApproverIdMin
                                       AND Role_Approver = 1
                                       AND Active = 1
                                       AND ( UserName <> @ReconcilerUserName
                                             AND UserName <> @ReviewerUserName
                                             AND UserName <> @ApproverUserName
                                           )
                               ORDER BY NEWID()
                             ),
--Approver3UserName = (SELECT TOP 1 UserName FROM Users WHERE Role_Approver=1 AND Active = 1 AND (UserName <> @ReconcilerUserName AND UserName <> @ReviewerUserName AND UserName <> @ApproverUserName AND UserName <> @Approver2UserName) ORDER BY NEWID()),
--Approver4UserName = (SELECT TOP 1 UserName FROM Users WHERE Role_Approver=1 AND Active = 1 AND (UserName <> @ReconcilerUserName AND UserName <> @ReviewerUserName AND UserName <> @ApproverUserName AND UserName <> @Approver2UserName AND UserName <> @Approver3UserName) ORDER BY NEWID()),
         BUReconcilerUserName = NULL,
         BUReviewerUserName = NULL,
         BUApproverUserName = NULL,
         BUApprover2UserName = NULL,
         BUApprover3UserName = NULL,
         BUApprover4UserName = NULL,
         ReconciliationFormatName = 'Overlay',
         ExcludeFXConversion = 0,
         Active = 1,
         CCY1DefaultRateType = NULL,
         CCY2DefaultRateType = NULL,
         CCY3DefaultRateType = NULL,
         NoChangeBulkFlg = 0,
         CCY1SplitAllowance = 0,
         CCY2SplitAllowance = 0,
         CCY3SplitAllowance = 0,
         CCY1ManualMatchTolerance = 0,
         CCY2ManualMatchTolerance = 0,
         CCY3ManualMatchTolerance = 0;			

			SET @Counter = @Counter + 1
		END

		DECLARE @HistID INT
		DECLARE @Now DATETIME
		SET @Now = GETDATE()
		SELECT @HistID = MAX(PKId) + 1 FROM Interfaces_History

		EXEC dbo.usp_InterfaceAccounts
		   @InterfaceID = 1, 
		   @StartTime = @Now,
		   @InterfaceHistoryPKId = @HistID


GO

