
CREATE PROCEDURE [dbo].[TOOLKIT_BuildTestAccountsWithPrefix_Modify]
(
	@AccountPrefix VARCHAR(MAX), @Amount INT, @Group BIT
)
AS
		DECLARE @Counter AS INT
		DECLARE @AccountSegment1 AS VARCHAR(50)
		DECLARE @AccountSegment2 AS VARCHAR(50)
		DECLARE @AccountSegment3 AS VARCHAR(50)
		DECLARE @AccountSegment4 AS VARCHAR(50)
		DECLARE @AccountSegment5 AS VARCHAR(50)
		DECLARE @AccountSegment6 AS VARCHAR(50)
		DECLARE @AccountSegment7 AS VARCHAR(50)
		DECLARE @AccountSegment8 AS VARCHAR(50)
		DECLARE @AccountSegment9 AS VARCHAR(50)
		DECLARE @AccountSegment10 AS VARCHAR(50)
		DECLARE @AccountName AS VARCHAR(200)
		DECLARE @Description AS VARCHAR(MAX)
		DECLARE @IsGroup AS BIT
		DECLARE @LocationId AS VARCHAR(15)
		DECLARE @AccountTypeID AS VARCHAR(15)
		DECLARE @OwnerId AS VARCHAR(15)
		DECLARE @QARiskRatingID AS VARCHAR(15)
		DECLARE @QATestCycleID AS VARCHAR(15)
		DECLARE @ClearingStandardID AS VARCHAR(15)
		DECLARE @ZeroBalanceBulkFlg AS BIT
		DECLARE @ReconPolicy AS VARCHAR(MAX)
		DECLARE @CCY1Code AS CHAR(3)
		DECLARE @CCY1GenerateBalance AS BIT
		DECLARE @CCY1HighBalance AS MONEY
		DECLARE @CCY1LowBalance AS MONEY
		DECLARE @CCY2Code AS CHAR(3)
		DECLARE @CCY2GenerateBalance AS BIT
		DECLARE @CCY2HighBalance AS MONEY
		DECLARE @CCY2LowBalance AS MONEY
		DECLARE @CCY3Code AS CHAR(3)
		DECLARE @CCY3GenerateBalance AS BIT
		DECLARE @CCY3HighBalance AS MONEY
		DECLARE @CCY3LowBalance AS MONEY
		DECLARE @ReconciliationScheduleID AS VARCHAR(15)
		DECLARE @ReviewScheduleID AS VARCHAR(15)
		DECLARE @RequiresApproval AS BIT
		DECLARE @ApprovalScheduleId AS VARCHAR(15)
		DECLARE @Approval2ScheduleId AS VARCHAR(15)
		DECLARE @Approval3ScheduleId AS VARCHAR(15)
		DECLARE @Approval4ScheduleId AS VARCHAR(15)
		DECLARE @ReconcilerUserName AS VARCHAR(50)
		DECLARE @ReviewerUserName AS VARCHAR(50)
		DECLARE @ApproverUserName AS VARCHAR(50)
		DECLARE @Approver2UserName AS VARCHAR(50)
		DECLARE @Approver3UserName AS VARCHAR(50)
		DECLARE @Approver4UserName AS VARCHAR(50)
		DECLARE @BUReconcilerUserName AS VARCHAR(50)
		DECLARE @BUReviewerUserName AS VARCHAR(50)
		DECLARE @BUApproverUserName AS VARCHAR(50)
		DECLARE @BUApprover2UserName AS VARCHAR(50)
		DECLARE @BUApprover3UserName AS VARCHAR(50)
		DECLARE @BUApprover4UserName AS VARCHAR(50)
		DECLARE @ReconciliationFormatName AS VARCHAR(50)
		DECLARE @ExcludeFXConversion AS BIT
		DECLARE @Active AS BIT
		DECLARE @CCY1DefaultRateType AS VARCHAR(15)
		DECLARE @CCY2DefaultRateType AS VARCHAR(15)
		DECLARE @CCY3DefaultRateType AS VARCHAR(15)
		DECLARE @NoChangeBulkFlg AS BIT
		DECLARE @CCY1SplitAllowance AS MONEY
		DECLARE @CCY2SplitAllowance AS MONEY
		DECLARE @CCY3SplitAllowance AS MONEY
		DECLARE @CCY1ManualMatchTolerance AS MONEY
		DECLARE @CCY2ManualMatchTolerance AS MONEY
		DECLARE @CCY3ManualMatchTolerance AS MONEY
		
		IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AccountsTempTable]') AND type IN (N'U'))
		DROP TABLE [dbo].[AccountsTempTable]

		CREATE TABLE [dbo].[AccountsTempTable]
			(
			AccountSegment1 VARCHAR(50),
			AccountSegment2 VARCHAR(50),
			AccountSegment3 VARCHAR(50),
			AccountSegment4 VARCHAR(50),
			AccountSegment5 VARCHAR(50),
			AccountSegment6 VARCHAR(50),
			AccountSegment7 VARCHAR(50),
			AccountSegment8 VARCHAR(50),
			AccountSegment9 VARCHAR(50),
			AccountSegment10 VARCHAR(50),
			AccountName VARCHAR(200),
			[Description] TEXT,
			IsGroup BIT,
			LocationId VARCHAR(15),
			AccountTypeID VARCHAR(15),
			OwnerId VARCHAR(15),
			QARiskRatingID VARCHAR(15),
			QATestCycleID VARCHAR(15),
			ClearingStandardID VARCHAR(15),
			ZeroBalanceBulkFlg BIT,
			ReconPolicy TEXT,
			CCY1Code CHAR(3),
			CCY1GenerateBalance BIT,
			CCY1HighBalance MONEY,
			CCY1LowBalance MONEY,
			CCY2Code CHAR(3),
			CCY2GenerateBalance BIT,
			CCY2HighBalance MONEY,
			CCY2LowBalance MONEY,
			CCY3Code CHAR(3),
			CCY3GenerateBalance BIT,
			CCY3HighBalance MONEY,
			CCY3LowBalance MONEY,
			ReconciliationScheduleID VARCHAR(15),
			ReviewScheduleID VARCHAR(15),
			RequiresApproval BIT,
			ApprovalScheduleId VARCHAR(15),
			Approval2ScheduleId VARCHAR(15),
			Approval3ScheduleId VARCHAR(15),
			Approval4ScheduleId VARCHAR(15),
			ReconcilerUserName VARCHAR(50),
			ReviewerUserName VARCHAR(50),
			ApproverUserName VARCHAR(50),
			Approver2UserName VARCHAR(50),
			Approver3UserName VARCHAR(50),
			Approver4UserName VARCHAR(50),
			BUReconcilerUserName VARCHAR(50),
			BUReviewerUserName VARCHAR(50),
			BUApproverUserName VARCHAR(50),
			BUApprover2UserName VARCHAR(50),
			BUApprover3UserName VARCHAR(50),
			BUApprover4UserName VARCHAR(50),
			ReconciliationFormatName VARCHAR(50),
			ExcludeFXConversion BIT,
			Active BIT,
			CCY1DefaultRateType VARCHAR(15),
			CCY2DefaultRateType VARCHAR(15),
			CCY3DefaultRateType VARCHAR(15),
			NoChangeBulkFlg BIT,
			CCY1SplitAllowance MONEY,
			CCY2SplitAllowance MONEY,
			CCY3SplitAllowance MONEY,
			CCY1ManualMatchTolerance MONEY,
			CCY2ManualMatchTolerance MONEY,
			CCY3ManualMatchTolerance MONEY,
			AccountPKId INT,
			BUReconcilerId INT,
			BUReviewerId INT,
			ApproverId INT,
			BUApproverId INT,
			Approver2ID INT,
			BUApprover2ID INT,
			Approver3ID INT,
			BUApprover3ID INT,
			Approver4ID INT,
			BUApprover4ID INT,
			ReconciliationFormatId INT,
			ReconcilerId INT,
			ReviewerId INT					
		)
		
		SET @Counter = 1
			
		WHILE (@Counter <= @Amount)
		BEGIN
			PRINT 'Creating Account ' + CAST(@Counter AS VARCHAR) + ' of ' + CAST(@Amount AS VARCHAR)
			SET @AccountSegment1 = @AccountPrefix + CAST(@Counter AS VARCHAR)
			SET @AccountSegment2 = @AccountPrefix + CAST(@Counter AS VARCHAR)
			SET @AccountSegment3 = @AccountPrefix + CAST(@Counter AS VARCHAR)
			SET @AccountSegment4 = @AccountPrefix + CAST(@Counter AS VARCHAR)
			SET @AccountSegment5 = @AccountPrefix + CAST(@Counter AS VARCHAR)
			SET @AccountSegment6 = @AccountPrefix + CAST(@Counter AS VARCHAR)
			SET @AccountSegment7 = @AccountPrefix + CAST(@Counter AS VARCHAR)
			SET @AccountSegment8 = @AccountPrefix + CAST(@Counter AS VARCHAR)
			SET @AccountSegment9 = @AccountPrefix + CAST(@Counter AS VARCHAR)
			SET @AccountSegment10 = @AccountPrefix + CAST(@Counter AS VARCHAR)
			SET @AccountName = @AccountPrefix + ' Account ' + CAST(@Counter AS VARCHAR)
			SET @Description = 'This is the description for ' + @AccountPrefix + ' Account ' + CAST(@Counter AS VARCHAR)
			SET @IsGroup = @Group
			SET @LocationId = (SELECT TOP 1 Code FROM Code_Locations ORDER BY NEWID())
			SET @AccountTypeID = (SELECT TOP 1 Code FROM Code_AccountTypes ORDER BY NEWID())
			SET @OwnerId = (SELECT TOP 1 Code FROM Code_Owners ORDER BY NEWID())
			SET @QARiskRatingID = (SELECT TOP 1 Code FROM Code_QARiskRatings ORDER BY NEWID())
			SET @QATestCycleID = (SELECT TOP 1 Code FROM Code_QATestCycles ORDER BY NEWID())
			SET @ClearingStandardID = (SELECT TOP 1 Code FROM Code_ClearingStandards ORDER BY NEWID())
			SET @ZeroBalanceBulkFlg = 0
			SET @ReconPolicy = 'This is the reconciliation policy for ' + @AccountPrefix + ' Account ' + CAST(@Counter AS VARCHAR)
			SET @CCY1Code = (SELECT TOP 1 Code FROM Code_Currencies ORDER BY NEWID())
			SET @CCY1GenerateBalance = 1
			SET @CCY1HighBalance = ROUND((RAND()*100000),2)
			SET @CCY1LowBalance = 0-ROUND((RAND()*100000),2)
			SET @CCY2Code = (SELECT TOP 1 Code FROM Code_Currencies ORDER BY NEWID())
			SET @CCY2GenerateBalance = 1
			SET @CCY2HighBalance = ROUND((RAND()*100000),2)
			SET @CCY2LowBalance = 0-ROUND((RAND()*100000),2)
			SET @CCY3Code = (SELECT TOP 1 Code FROM Code_Currencies ORDER BY NEWID())
			SET @CCY3GenerateBalance = 1
			SET @CCY3HighBalance = ROUND((RAND()*100000),2)
			SET @CCY3LowBalance = 0-ROUND((RAND()*100000),2)
			SET @ReconciliationScheduleID = (SELECT TOP 1 Code FROM Code_ReconciliationSchedule ORDER BY NEWID())
			SET @ReviewScheduleID = (SELECT TOP 1 Code FROM Code_ReviewSchedule ORDER BY NEWID())
			SET @RequiresApproval = 0
			SET @ApprovalScheduleId = 'APP1'
			SET @Approval2ScheduleId = 'APP2'
			SET @Approval3ScheduleId = 'APP3'
			SET @Approval4ScheduleId = 'APP4'
			SET @ReconcilerUserName = (SELECT TOP 1 UserName FROM Users WHERE PKId > 1952 AND Role_Reconciler=1 AND Active = 1 ORDER BY NEWID())
			SET @ReviewerUserName = (SELECT TOP 1 UserName FROM Users WHERE PKId > 1952 AND Role_Reviewer=1 AND Active = 1 AND UserName <> @ReconcilerUserName ORDER BY NEWID())
			SET @ApproverUserName = (SELECT TOP 1 UserName FROM Users WHERE UserName LIKE '%ApprUser%' AND PKId > 1952 AND Role_Approver=1 AND Active = 1 AND (UserName <> @ReconcilerUserName AND UserName <> @ReviewerUserName) ORDER BY NEWID())
			SET @Approver2UserName = (SELECT TOP 1 UserName FROM Users WHERE UserName LIKE '%AcctOwner%' AND PKId > 1952 AND Role_Approver=1 AND Active = 1 AND (UserName <> @ReconcilerUserName AND UserName <> @ReviewerUserName AND UserName <> @ApproverUserName) ORDER BY NEWID())
--			SET @Approver3UserName = (SELECT TOP 1 UserName FROM Users WHERE Role_Approver=1 AND Active = 1 AND (UserName <> @ReconcilerUserName AND UserName <> @ReviewerUserName AND UserName <> @ApproverUserName AND UserName <> @Approver2UserName) ORDER BY NEWID())
--			SET @Approver4UserName = (SELECT TOP 1 UserName FROM Users WHERE Role_Approver=1 AND Active = 1 AND (UserName <> @ReconcilerUserName AND UserName <> @ReviewerUserName AND UserName <> @ApproverUserName AND UserName <> @Approver2UserName AND UserName <> @Approver3UserName) ORDER BY NEWID())
			SET @BUReconcilerUserName = NULL
			SET @BUReviewerUserName = NULL
			SET @BUApproverUserName = NULL
			SET @BUApprover2UserName = NULL
			SET @BUApprover3UserName = NULL
			SET @BUApprover4UserName = NULL
			SET @ReconciliationFormatName = 'Overlay'
			SET @ExcludeFXConversion = 0
			SET @Active = 1
			SET @CCY1DefaultRateType = NULL
			SET @CCY2DefaultRateType = NULL
			SET @CCY3DefaultRateType = NULL
			SET @NoChangeBulkFlg = 0
			SET @CCY1SplitAllowance = 0
			SET @CCY2SplitAllowance = 0
			SET @CCY3SplitAllowance = 0
			SET @CCY1ManualMatchTolerance = 0
			SET @CCY2ManualMatchTolerance = 0
			SET @CCY3ManualMatchTolerance = 0


			INSERT INTO [dbo].[AccountsTempTable]
			(
				AccountSegment1,
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
				LocationID,
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
				ReconciliationScheduleID,
				ReviewScheduleID,
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
			) VALUES (
				@AccountSegment1,
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
			)
			SET @Counter = @Counter + 1
		END
		DECLARE @HistID INT
		DECLARE @Now DATETIME
		SET @Now = GETDATE()
		SELECT @HistID = MAX(PKId) + 1 FROM Interfaces_History
		EXEC TOOLKIT_Accounts_Interface 1,@Now,@HistID
	

GO

