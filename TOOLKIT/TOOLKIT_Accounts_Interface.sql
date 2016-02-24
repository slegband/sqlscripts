
CREATE PROCEDURE [dbo].[TOOLKIT_Accounts_Interface]  
(
	@InterfaceID INT, 
	@StartTime DATETIME, 
	@InterfaceHistoryPKId INT
) 
AS
SET NOCOUNT ON
	  DECLARE @Result AS SMALLINT
      SET @Result = 0

      DECLARE @Error_TTPKID AS INT
      DECLARE @Error_Code AS INT
      DECLARE @Error_QueryCode AS VARCHAR(200)
      DECLARE @ErrorVar INT
      DECLARE @ErrorID INT
      DECLARE @IsError INT

      DECLARE @TotalInserted INT
      DECLARE @TotalRecords INT
      DECLARE @TotalUpdated INT
      DECLARE @RowsUpdated INT

      SET @TotalInserted =0
      SET @TotalRecords =0
      SET @TotalUpdated =0
      SET @RowsUpdated =0

      DECLARE @CurrentDt DATETIME
      SET @CurrentDt = GETDATE()


      SET @TotalRecords = (SELECT COUNT(*) FROM AccountsTempTable)

      SET @IsError = 0
PRINT '--Validate Locations'

      --Validate Locations
      EXEC @Result = usp_InterfaceValidateTableColumns @InterfaceId,@StartTime,'AccountsTempTable','Code_Locations','LocationId','Code',1,0,@InterfaceHistoryPKId

      IF(@Result < 0)
      BEGIN
      PRINT 'Location Validation Error: ' + CONVERT(VARCHAR,@Result)
      GOTO ValidationExitPoint
      END
PRINT '--Validate CCY1Code'
      --Validate CCY1Code
      EXEC @Result = usp_InterfaceValidateTableColumns @InterfaceId,@StartTime,'AccountsTempTable','Code_Currencies','CCY1Code','Code',1,0,@InterfaceHistoryPKId

      IF(@Result < 0)
      BEGIN
      PRINT 'CCY1 Code Validation Error: ' + CONVERT(VARCHAR,@Result)
      GOTO ValidationExitPoint
      END
PRINT '--Validate CCY2Code'
      --Validate CCY2Code
      EXEC @Result = usp_InterfaceValidateTableColumns @InterfaceId,@StartTime,'AccountsTempTable','Code_Currencies','CCY2Code','Code',1,0,@InterfaceHistoryPKId

      IF(@Result < 0)
      BEGIN
      PRINT 'CCY2 Code Validation Error: ' + CONVERT(VARCHAR,@Result)
      GOTO ValidationExitPoint
      END
PRINT '--Validate CCY3Code'

      --Validate CCY3Code
      EXEC @Result = usp_InterfaceValidateTableColumns @InterfaceId,@StartTime,'AccountsTempTable','Code_Currencies','CCY3Code','Code',1,0,@InterfaceHistoryPKId

      IF(@Result < 0)
      BEGIN
      PRINT 'CCY3 Code Validation Error: ' + CONVERT(VARCHAR,@Result)
      GOTO ValidationExitPoint
      END
PRINT ' --Validate Reconciler User Name'

      --Validate Reconciler User Name
      EXEC @Result = usp_InterfaceValidateTableColumns @InterfaceId,@StartTime,'AccountsTempTable','Users','ReconcilerUserName','UserName',1,0,@InterfaceHistoryPKId

      IF(@Result < 0)
      BEGIN
      PRINT 'Reconciler User Name Validation Error: ' + CONVERT(VARCHAR,@Result)
      GOTO ValidationExitPoint
      END
PRINT '--Validate BUReconciler User Name'
      --Validate BUReconciler User Name
      EXEC @Result = usp_InterfaceValidateTableColumns @InterfaceId,@StartTime,'AccountsTempTable','Users','BUReconcilerUserName','UserName',1,0,@InterfaceHistoryPKId

      IF(@Result < 0)
      BEGIN
      PRINT 'BUReconciler User Name Validation Error: ' + CONVERT(VARCHAR,@Result)
      GOTO ValidationExitPoint
      END

PRINT '--Validate Reconciliation Schedule'
      --Validate Reconciliation Schedule
      EXEC @Result = usp_InterfaceValidateTableColumns @InterfaceId,@StartTime,'AccountsTempTable','Code_ReconciliationSchedule','ReconciliationScheduleId','Code',1,0,@InterfaceHistoryPKId

      IF(@Result < 0)
      BEGIN
      PRINT 'Reconciliation Schedule Validation Error: ' + CONVERT(VARCHAR,@Result)
      GOTO ValidationExitPoint
      END


PRINT '--Validate Reviewer User Name'
      --Validate Reviewer User Name
      EXEC @Result = usp_InterfaceValidateTableColumns @InterfaceId,@StartTime,'AccountsTempTable','Users','ReviewerUserName','UserName',1,0,@InterfaceHistoryPKId

      IF(@Result < 0)
      BEGIN
      PRINT 'Reviewer User Name Validation Error: ' + CONVERT(VARCHAR,@Result)
      GOTO ValidationExitPoint
      END

PRINT '--Validate BUReviewer User Name'
      --Validate BUReviewer User Name
      EXEC @Result = usp_InterfaceValidateTableColumns @InterfaceId,@StartTime,'AccountsTempTable','Users','BUReviewerUserName','UserName',1,0,@InterfaceHistoryPKId

      IF(@Result < 0)
      BEGIN
      PRINT 'BUReviewer User Name Validation Error: ' + CONVERT(VARCHAR,@Result)
      GOTO ValidationExitPoint
      END

PRINT '--Validate Review Schedule'
      --Validate Review Schedule
      EXEC @Result = usp_InterfaceValidateTableColumns @InterfaceId,@StartTime,'AccountsTempTable','Code_ReviewSchedule','ReviewScheduleId','Code',1,0,@InterfaceHistoryPKId

      IF(@Result < 0)
      BEGIN
      PRINT 'Review Schedule Validation Error: ' + CONVERT(VARCHAR,@Result)
      GOTO ValidationExitPoint
      END


PRINT '--Validate Approver User Name'
      --Validate Approver User Name
      EXEC @Result = usp_InterfaceValidateTableColumns @InterfaceId,@StartTime,'AccountsTempTable','Users','ApproverUserName','UserName',1,0,@InterfaceHistoryPKId

      IF(@Result < 0)
      BEGIN
      PRINT 'Approver User Name Validation Error: ' + CONVERT(VARCHAR,@Result)
      GOTO ValidationExitPoint
      END

PRINT '--Validate BUApprover User Name'
      --Validate BUApprover User Name
      EXEC @Result = usp_InterfaceValidateTableColumns @InterfaceId,@StartTime,'AccountsTempTable','Users','BUApproverUserName','UserName',1,0,@InterfaceHistoryPKId

      IF(@Result < 0)
      BEGIN
      PRINT 'BUReviewer User Name Validation Error: ' + CONVERT(VARCHAR,@Result)
      GOTO ValidationExitPoint
      END

PRINT '-Validate Approver2 User Name'
      --Validate Approver2 User Name
      EXEC @Result = usp_InterfaceValidateTableColumns @InterfaceId,@StartTime,'AccountsTempTable','Users','Approver2UserName','UserName',1,0,@InterfaceHistoryPKId

      IF(@Result < 0)
      BEGIN
      PRINT 'Approver2 User Name Validation Error: ' + CONVERT(VARCHAR,@Result)
      GOTO ValidationExitPoint
      END

PRINT ''
      --Validate BUApprover2 User Name
      EXEC @Result = usp_InterfaceValidateTableColumns @InterfaceId,@StartTime,'AccountsTempTable','Users','BUApprover2UserName','UserName',1,0,@InterfaceHistoryPKId

      IF(@Result < 0)
      BEGIN
      PRINT 'BUReviewer2 User Name Validation Error: ' + CONVERT(VARCHAR,@Result)
      GOTO ValidationExitPoint
      END

PRINT '--Validate Approver3 User Name'
      --Validate Approver3 User Name
      EXEC @Result = usp_InterfaceValidateTableColumns @InterfaceId,@StartTime,'AccountsTempTable','Users','Approver3UserName','UserName',1,0,@InterfaceHistoryPKId

      IF(@Result < 0)
      BEGIN
      PRINT 'Approver3 User Name Validation Error: ' + CONVERT(VARCHAR,@Result)
      GOTO ValidationExitPoint
      END

PRINT '--Validate BUApprover3 User Name'
      --Validate BUApprover3 User Name
      EXEC @Result = usp_InterfaceValidateTableColumns @InterfaceId,@StartTime,'AccountsTempTable','Users','BUApprover3UserName','UserName',1,0,@InterfaceHistoryPKId

      IF(@Result < 0)
      BEGIN
      PRINT 'BUReviewer3 User Name Validation Error: ' + CONVERT(VARCHAR,@Result)
      GOTO ValidationExitPoint
      END

PRINT ''
      --Validate Approver4 User Name
      EXEC @Result = usp_InterfaceValidateTableColumns @InterfaceId,@StartTime,'AccountsTempTable','Users','Approver4UserName','UserName',1,0,@InterfaceHistoryPKId

      IF(@Result < 0)
      BEGIN
      PRINT 'Approver4 User Name Validation Error: ' + CONVERT(VARCHAR,@Result)
      GOTO ValidationExitPoint
      END

PRINT '--Validate BUApprover4 User Name'
      --Validate BUApprover4 User Name
      EXEC @Result = usp_InterfaceValidateTableColumns @InterfaceId,@StartTime,'AccountsTempTable','Users','BUApprover4UserName','UserName',1,0,@InterfaceHistoryPKId

      IF(@Result < 0)
      BEGIN
      PRINT 'BUReviewer4 User Name Validation Error: ' + CONVERT(VARCHAR,@Result)
      GOTO ValidationExitPoint
      END

PRINT '--Validate Approval Schedule'
      --Validate Approval Schedule
      EXEC @Result = usp_InterfaceValidateTableColumns @InterfaceId,@StartTime,'AccountsTempTable','Code_ApprovalSchedule','ApprovalScheduleId','Code',1,0,@InterfaceHistoryPKId

      IF(@Result < 0)
      BEGIN
      PRINT 'Approval Schedule Validation Error: ' + CONVERT(VARCHAR,@Result)
      GOTO ValidationExitPoint
      END

PRINT '--Validate Approval2 Schedule'
      --Validate Approval2 Schedule
      EXEC @Result = usp_InterfaceValidateTableColumns @InterfaceId,@StartTime,'AccountsTempTable','Code_ApprovalSchedule','Approval2ScheduleId','Code',1,0,@InterfaceHistoryPKId

      IF(@Result < 0)
      BEGIN
      PRINT 'Approval2 Schedule Validation Error: ' + CONVERT(VARCHAR,@Result)
      GOTO ValidationExitPoint
      END

PRINT '--Validate Approval3 Schedule'
      --Validate Approval3 Schedule
      EXEC @Result = usp_InterfaceValidateTableColumns @InterfaceId,@StartTime,'AccountsTempTable','Code_ApprovalSchedule','Approval3ScheduleId','Code',1,0,@InterfaceHistoryPKId

      IF(@Result < 0)
      BEGIN
      PRINT 'Approval3 Schedule Validation Error: ' + CONVERT(VARCHAR,@Result)
      GOTO ValidationExitPoint
      END

PRINT '--Validate Approval4 Schedule'
      --Validate Approval4 Schedule
      EXEC @Result = usp_InterfaceValidateTableColumns @InterfaceId,@StartTime,'AccountsTempTable','Code_ApprovalSchedule','Approval4ScheduleId','Code',1,0,@InterfaceHistoryPKId

      IF(@Result < 0)
      BEGIN
      PRINT 'Approval4 Schedule Validation Error: ' + CONVERT(VARCHAR,@Result)
      GOTO ValidationExitPoint
      END


PRINT '--Validate Reconciliation Formats'
      --Validate Reconciliation Formats
      EXEC @Result = usp_InterfaceValidateTableColumns @InterfaceId,@StartTime,'AccountsTempTable','Define_ReconciliationChildFormats','ReconciliationFormatName','Name',1,0,@InterfaceHistoryPKId

      IF(@Result < 0)
      BEGIN
      PRINT 'Reconciliation Formats Validation Error: ' + CONVERT(VARCHAR,@Result)
      GOTO ValidationExitPoint
      END

PRINT '--Validate QA Risk Rating'
      --Validate QA Risk Rating
      EXEC @Result = usp_InterfaceValidateTableColumns @InterfaceId,@StartTime,'AccountsTempTable','Code_QARiskRatings','QARiskRatingId','Code',1,0,@InterfaceHistoryPKId

      IF(@Result < 0)
      BEGIN
      PRINT ' QA Risk Rating Validation Error: ' + CONVERT(VARCHAR,@Result)
      GOTO ValidationExitPoint
      END

PRINT '--Validate QA Test Cycle'
      --Validate QA Test Cycle
      EXEC @Result = usp_InterfaceValidateTableColumns @InterfaceId,@StartTime,'AccountsTempTable','Code_QATestCycles','QATestCycleId','Code',1,0,@InterfaceHistoryPKId

      IF(@Result < 0)
      BEGIN
      PRINT ' QA Test Cycle Validation Error: ' + CONVERT(VARCHAR,@Result)
      GOTO ValidationExitPoint
      END

PRINT '--Validate Account Type'
      --Validate Account Type
      EXEC @Result = usp_InterfaceValidateTableColumns @InterfaceId,@StartTime,'AccountsTempTable','Code_AccountTypes','AccountTypeId','Code',1,0,@InterfaceHistoryPKId

      IF(@Result < 0)
      BEGIN
      PRINT 'Account Type Validation Error: ' + CONVERT(VARCHAR,@Result)
      GOTO ValidationExitPoint
      END

PRINT '--Validate CCY1 Default Rate Type'
      --Validate CCY1 Default Rate Type
      EXEC @Result = usp_InterfaceValidateTableColumns @InterfaceId,@StartTime,'AccountsTempTable','Code_RateTypes','CCY1DefaultRateType','Code',1,0,@InterfaceHistoryPKId

      IF(@Result < 0)
      BEGIN
      PRINT 'CCY1 Default Rate Type: ' + CONVERT(VARCHAR,@Result)
      GOTO ValidationExitPoint
      END

PRINT '--Validate CCY2 Default Rate Type'
      --Validate CCY2 Default Rate Type
      EXEC @Result = usp_InterfaceValidateTableColumns @InterfaceId,@StartTime,'AccountsTempTable','Code_RateTypes','CCY2DefaultRateType','Code',1,0,@InterfaceHistoryPKId

      IF(@Result < 0)
      BEGIN
      PRINT 'CCY2 Default Rate Type: ' + CONVERT(VARCHAR,@Result)
      GOTO ValidationExitPoint
      END

PRINT '--Validate CCY3 Default Rate Type'
      --Validate CCY3 Default Rate Type
      EXEC @Result = usp_InterfaceValidateTableColumns @InterfaceId,@StartTime,'AccountsTempTable','Code_RateTypes','CCY3DefaultRateType','Code',1,0,@InterfaceHistoryPKId

      IF(@Result < 0)
      BEGIN
      PRINT 'CCY3 Default Rate Type: ' + CONVERT(VARCHAR,@Result)
      GOTO ValidationExitPoint
      END

PRINT '--Validate OwnerId'
      --Validate OwnerId
      EXEC @Result = usp_InterfaceValidateTableColumns @InterfaceId,@StartTime,'AccountsTempTable','Code_Owners','OwnerId','Code',1,0,@InterfaceHistoryPKId

      IF(@Result < 0)
      BEGIN
      PRINT 'OwnerId Validation Error: ' + CONVERT(VARCHAR,@Result)
      GOTO ValidationExitPoint
      END

PRINT '--Validate ClearingStandardId'
      --Validate ClearingStandardId
      EXEC @Result = usp_InterfaceValidateTableColumns @InterfaceId,@StartTime,'AccountsTempTable','Code_ClearingStandards','ClearingStandardID','Code',1,0,@InterfaceHistoryPKId

      IF(@Result < 0)
      BEGIN
      PRINT 'ClearingStandardId Validation Error: ' + CONVERT(VARCHAR,@Result)
      GOTO ValidationExitPoint
      END
PRINT 'Validation complete'
PRINT 'Begin Tran was here.  starting update on AccountsTempTable '
--Begin Tran


      ---------------------------------------- Reconciler -----------------------------------------
      ------------------------------------------------------------------------------------------------

      UPDATE AccountsTempTable
      SET AccountsTempTable.ReconcilerId  = Users.PKId
      FROM Users
      WHERE AccountsTempTable.ReconcilerUserName = Users.UserName

      SELECT @ErrorVar=@@error, @RowsUpdated=@@rowcount
      IF (@ErrorVar<>0)
      BEGIN
      SET @IsError=1
      SET @Error_Code = @ErrorVar
      SET @Error_QueryCode = 'Update AccountsTempTable Set AccountsTempTable.ReconcilerId  = Users.PKId From Users Where AccountsTempTable.ReconcilerUserName = Users.UserName'
      GOTO ExitPoint
      END


      ---------------------------------------- BU Reconciler -----------------------------------------
      ------------------------------------------------------------------------------------------------

      UPDATE AccountsTempTable
      SET AccountsTempTable.BUReconcilerId  = Users.PKId
      FROM Users
      WHERE AccountsTempTable.BUReconcilerUserName = Users.UserName

      SELECT @ErrorVar=@@error, @RowsUpdated=@@rowcount
      IF (@ErrorVar<>0)
      BEGIN
      SET @IsError=1
      SET @Error_Code = @ErrorVar
      SET @Error_QueryCode = 'Update AccountsTempTable Set AccountsTempTable.BUReconcilerId  = Users.PKId From Users Where AccountsTempTable.BUReconcilerUserName = Users.UserName'
      GOTO ExitPoint
      END


      ---------------------------------------- Reviewer  -----------------------------------------
      ------------------------------------------------------------------------------------------------

      UPDATE AccountsTempTable
      SET AccountsTempTable.ReviewerId  = Users.PKId
      FROM Users
      WHERE AccountsTempTable.ReviewerUserName = Users.UserName

      SELECT @ErrorVar=@@error, @RowsUpdated=@@rowcount
      IF (@ErrorVar<>0)
      BEGIN
      SET @IsError=1
      SET @Error_Code = @ErrorVar
      SET @Error_QueryCode = 'Update AccountsTempTable Set AccountsTempTable.ReviewerId  = Users.PKId From Users Where AccountsTempTable.ReviewerUserName = Users.UserName'
      GOTO ExitPoint
      END



      ---------------------------------------- BUReviewer  -----------------------------------------
      ------------------------------------------------------------------------------------------------


      UPDATE AccountsTempTable
      SET AccountsTempTable.BUReviewerId  = Users.PKId
      FROM Users
      WHERE AccountsTempTable.BUReviewerUserName = Users.UserName

      SELECT @ErrorVar=@@error, @RowsUpdated=@@rowcount
      IF (@ErrorVar<>0)
      BEGIN
      SET @IsError=1
      SET @Error_Code = @ErrorVar
      SET @Error_QueryCode = 'Update AccountsTempTable Set AccountsTempTable.BUReviewerId  = Users.PKId From Users Where AccountsTempTable.BUReviewerUserName = Users.UserName'
      GOTO ExitPoint
      END


      ---------------------------------------- Approver  -----------------------------------------
      ------------------------------------------------------------------------------------------------


      UPDATE AccountsTempTable
      SET AccountsTempTable.ApproverId  = Users.PKId
      FROM Users
      WHERE AccountsTempTable.ApproverUserName = Users.UserName

      SELECT @ErrorVar=@@error, @RowsUpdated=@@rowcount
      IF (@ErrorVar<>0)
      BEGIN
      SET @IsError=1
      SET @Error_Code = @ErrorVar
      SET @Error_QueryCode = 'Update AccountsTempTable Set AccountsTempTable.ApproverId  = Users.PKId From Users Where AccountsTempTable.ApproverUserName = Users.UserName'
      GOTO ExitPoint
      END

      ---------------------------------------- BUApprover  -----------------------------------------
      ------------------------------------------------------------------------------------------------

      UPDATE AccountsTempTable
      SET AccountsTempTable.BUApproverId  = Users.PKId
      FROM Users
      WHERE AccountsTempTable.BUApproverUserName = Users.UserName

      SELECT @ErrorVar=@@error, @RowsUpdated=@@rowcount
      IF (@ErrorVar<>0)
      BEGIN
      SET @IsError=1
      SET @Error_Code = @ErrorVar
      SET @Error_QueryCode = 'Update AccountsTempTable Set AccountsTempTable.BUApproverId  = Users.PKId From Users Where AccountsTempTable.BUApproverUserName = Users.UserName'
      GOTO ExitPoint
      END

      ---------------------------------------- Approver2  -----------------------------------------
      ------------------------------------------------------------------------------------------------


      UPDATE AccountsTempTable
      SET AccountsTempTable.Approver2ID  = Users.PKId
      FROM Users
      WHERE AccountsTempTable.Approver2UserName = Users.UserName

      SELECT @ErrorVar=@@error, @RowsUpdated=@@rowcount
      IF (@ErrorVar<>0)
      BEGIN
      SET @IsError=1
      SET @Error_Code = @ErrorVar
      SET @Error_QueryCode = 'Update AccountsTempTable Set AccountsTempTable.Approver2Id  = Users.PKId From Users Where AccountsTempTable.Approver2UserName = Users.UserName'
      GOTO ExitPoint
      END

      ---------------------------------------- BUApprover2  -----------------------------------------
      ------------------------------------------------------------------------------------------------

      UPDATE AccountsTempTable
      SET AccountsTempTable.BUApprover2ID  = Users.PKId
      FROM Users
      WHERE AccountsTempTable.BUApprover2UserName = Users.UserName

      SELECT @ErrorVar=@@error, @RowsUpdated=@@rowcount
      IF (@ErrorVar<>0)
      BEGIN
      SET @IsError=1
      SET @Error_Code = @ErrorVar
      SET @Error_QueryCode = 'Update AccountsTempTable Set AccountsTempTable.BUApprover2Id  = Users.PKId From Users Where AccountsTempTable.BUApprover2UserName = Users.UserName'
      GOTO ExitPoint
      END

      ---------------------------------------- Approver3  -----------------------------------------
      ------------------------------------------------------------------------------------------------


      UPDATE AccountsTempTable
      SET AccountsTempTable.Approver3ID  = Users.PKId
      FROM Users
      WHERE AccountsTempTable.Approver3UserName = Users.UserName

      SELECT @ErrorVar=@@error, @RowsUpdated=@@rowcount
      IF (@ErrorVar<>0)
      BEGIN
      SET @IsError=1
      SET @Error_Code = @ErrorVar
      SET @Error_QueryCode = 'Update AccountsTempTable Set AccountsTempTable.Approver3Id  = Users.PKId From Users Where AccountsTempTable.Approver3UserName = Users.UserName'
      GOTO ExitPoint
      END

      ---------------------------------------- BUApprover3  -----------------------------------------
      ------------------------------------------------------------------------------------------------

      UPDATE AccountsTempTable
      SET AccountsTempTable.BUApprover3ID  = Users.PKId
      FROM Users
      WHERE AccountsTempTable.BUApprover3UserName = Users.UserName

      SELECT @ErrorVar=@@error, @RowsUpdated=@@rowcount
      IF (@ErrorVar<>0)
      BEGIN
      SET @IsError=1
      SET @Error_Code = @ErrorVar
      SET @Error_QueryCode = 'Update AccountsTempTable Set AccountsTempTable.BUApprover3Id  = Users.PKId From Users Where AccountsTempTable.BUApprover3UserName = Users.UserName'
      GOTO ExitPoint
      END

      ---------------------------------------- Approver4  -----------------------------------------
      ------------------------------------------------------------------------------------------------


      UPDATE AccountsTempTable
      SET AccountsTempTable.Approver4ID  = Users.PKId
      FROM Users
      WHERE AccountsTempTable.Approver4UserName = Users.UserName

      SELECT @ErrorVar=@@error, @RowsUpdated=@@rowcount
      IF (@ErrorVar<>0)
      BEGIN
      SET @IsError=1
      SET @Error_Code = @ErrorVar
      SET @Error_QueryCode = 'Update AccountsTempTable Set AccountsTempTable.Approver4Id  = Users.PKId From Users Where AccountsTempTable.Approver4UserName = Users.UserName'
      GOTO ExitPoint
      END

      ---------------------------------------- BUApprover4  -----------------------------------------
      ------------------------------------------------------------------------------------------------

      UPDATE AccountsTempTable
      SET AccountsTempTable.BUApprover4ID  = Users.PKId
      FROM Users
      WHERE AccountsTempTable.BUApprover4UserName = Users.UserName

      SELECT @ErrorVar=@@error, @RowsUpdated=@@rowcount
      IF (@ErrorVar<>0)
      BEGIN
      SET @IsError=1
      SET @Error_Code = @ErrorVar
      SET @Error_QueryCode = 'Update AccountsTempTable Set AccountsTempTable.BUApprover4Id  = Users.PKId From Users Where AccountsTempTable.BUApprover4UserName = Users.UserName'
      GOTO ExitPoint
      END

      ---------------------------------------- Reconciliation Format Id-------------------------------------
      ------------------------------------------------------------------------------------------------

      UPDATE AccountsTempTable
      SET AccountsTempTable.ReconciliationFormatId  = Define_ReconciliationChildFormats.PkID
      FROM Define_ReconciliationChildFormats
      WHERE AccountsTempTable.ReconciliationFormatName = Define_ReconciliationChildFormats.Name

      SELECT @ErrorVar=@@error, @RowsUpdated=@@rowcount
      IF (@ErrorVar<>0)
      BEGIN
      SET @IsError=1
      SET @Error_Code = @ErrorVar
      SET @Error_QueryCode = 'Update AccountsTempTable Set AccountsTempTable.ReconciliationFormatId  = Define_ReconciliationChildFormats.PKId	From Define_ReconciliationChildFormats Where AccountsTempTable.ReconciliationFormatName = Define_ReconciliationChildFormats.Name'
      GOTO ExitPoint
      END


      ---------------------------------------- Update AccountPKId-------------------------------------
      ------------------------------------------------------------------------------------------------
      UPDATE AccountsTempTable
      SET AccountsTempTable.AccountPKId = A.PKId
      FROM
      AccountsTempTable T
      INNER JOIN AccountSegments S ON ISNULL(T.AccountSegment1,'^')=ISNULL(S.AccountSegment1,'^')
      AND ISNULL(T.AccountSegment2,'^')=ISNULL(S.AccountSegment2,'^')
      AND ISNULL(T.AccountSegment3,'^')=ISNULL(S.AccountSegment3,'^')
      AND ISNULL(T.AccountSegment4,'^')=ISNULL(S.AccountSegment4,'^')
      AND ISNULL(T.AccountSegment5,'^')=ISNULL(S.AccountSegment5,'^')
      AND ISNULL(T.AccountSegment6,'^')=ISNULL(S.AccountSegment6,'^')
      AND ISNULL(T.AccountSegment7,'^')=ISNULL(S.AccountSegment7,'^')
      AND ISNULL(T.AccountSegment8,'^')=ISNULL(S.AccountSegment8,'^')
      AND ISNULL(T.AccountSegment9,'^')=ISNULL(S.AccountSegment9,'^')
      AND ISNULL(T.AccountSegment10,'^')=ISNULL(S.AccountSegment10,'^')
      INNER JOIN Accounts A ON S.AccountId=A.PKId
      SELECT @ErrorVar=@@error
      IF (@ErrorVar<>0)
      BEGIN
      SET @IsError=1
      SET @Error_Code = @ErrorVar
      SET @Error_TTPKID = 0
      SET @Error_QueryCode = 'Updating AccountPKId of AccountsTempTable '
      GOTO ExitPoint
      END
PRINT ' Starting update of Accounts data though nothing was put in account table yet'
      ---------------------------------------- Update Account Fields using the AccountPKId from the TempTable-------------------------------------
      ------------------------------------------------------------------------------------------------
      UPDATE Accounts
      SET
      Accounts.AccountName = AccountsTempTable.AccountName,
      --Accounts.DateActivated = AccountsTempTable.DateActivated,
      Accounts.[Description] = AccountsTempTable.[Description],
      Accounts.LocationID = AccountsTempTable.LocationId,
      Accounts.AccountTypeID = AccountsTempTable.AccountTypeID,
      Accounts.QARiskRatingID = AccountsTempTable.QARiskRatingID,
      Accounts.ReconPolicy = AccountsTempTable.ReconPolicy,
      Accounts.CCY1Code = AccountsTempTable.CCY1Code,
      Accounts.ReconcileCCY1 = AccountsTempTable.CCY1GenerateBalance,
      Accounts.CCY1HighBalance = AccountsTempTable.CCY1HighBalance,
      Accounts.CCY1LowBalance = AccountsTempTable.CCY1LowBalance,
      Accounts.CCY2Code = AccountsTempTable.CCY2Code,
      Accounts.ReconcileCCY2 = AccountsTempTable.CCY2GenerateBalance,
      Accounts.CCY2HighBalance = AccountsTempTable.CCY2HighBalance,
      Accounts.CCY2LowBalance = AccountsTempTable.CCY2LowBalance,
      Accounts.CCY3Code = AccountsTempTable.CCY3Code,
      Accounts.ReconcileCCY3 = AccountsTempTable.CCY3GenerateBalance,
      Accounts.CCY3HighBalance = AccountsTempTable.CCY3HighBalance,
      Accounts.CCY3LowBalance = AccountsTempTable.CCY3LowBalance,
      Accounts.ReconciliationScheduleID = AccountsTempTable.ReconciliationScheduleID,
      Accounts.ReviewScheduleID = AccountsTempTable.ReviewScheduleID,
      Accounts.RequiresApproval = AccountsTempTable.RequiresApproval,
      Accounts.ApprovalScheduleID = AccountsTempTable.ApprovalScheduleId,
      Accounts.ReconcilerID = AccountsTempTable.ReconcilerId,
      Accounts.BUReconcilerID = AccountsTempTable.BUReconcilerId,
      Accounts.ReviewerID = AccountsTempTable.ReviewerId,
      Accounts.BUReviewerID = AccountsTempTable.BUReviewerId,
      Accounts.ApproverID = AccountsTempTable.ApproverId,
      Accounts.BUApproverID = AccountsTempTable.BUApproverId,
      Accounts.ReconciliationFormatID = AccountsTempTable.ReconciliationFormatId,
      Accounts.CCY1GenerateBalance = AccountsTempTable.CCY1GenerateBalance,
      Accounts.CCY2GenerateBalance = AccountsTempTable.CCY2GenerateBalance,
      Accounts.CCY3GenerateBalance = AccountsTempTable.CCY3GenerateBalance,
      Accounts.CCY1DefaultRateType = AccountsTempTable.CCY1DefaultRateType,
      Accounts.CCY2DefaultRateType = AccountsTempTable.CCY2DefaultRateType,
      Accounts.CCY3DefaultRateType = AccountsTempTable.CCY3DefaultRateType,
      Accounts.ExcludeFXConversion = AccountsTempTable.ExcludeFXConversion,
      Accounts.OwnerId = AccountsTempTable.OwnerId,
      Accounts.ZeroBalanceBulkFlg = AccountsTempTable.ZeroBalanceBulkFlg,
      Accounts.IsGroup = AccountsTempTable.IsGroup,
      Accounts.ClearingStandardID = AccountsTempTable.ClearingStandardID,
      Accounts.QATestCycleID = AccountsTempTable.QATestCycleID,
      Accounts.Active = ISNULL(AccountsTempTable.Active,Accounts.Active),
      Accounts.NoChangeBulkFlg  = ISNULL(AccountsTempTable.NoChangeBulkFlg ,0),
      Accounts.CCY1SplitAllowance = AccountsTempTable.CCY1SplitAllowance,
      Accounts.CCY2SplitAllowance = AccountsTempTable.CCY2SplitAllowance,
      Accounts.CCY3SplitAllowance = AccountsTempTable.CCY3SplitAllowance,
      Accounts.CCY1ManualMatchTolerance = AccountsTempTable.CCY1ManualMatchTolerance,
      Accounts.CCY2ManualMatchTolerance = AccountsTempTable.CCY2ManualMatchTolerance,
      Accounts.CCY3ManualMatchTolerance = AccountsTempTable.CCY3ManualMatchTolerance

      FROM Accounts
      JOIN AccountsTempTable
      ON Accounts.PKId = AccountsTempTable.AccountPKId
      AND AccountPKId IS NOT NULL

      SELECT @ErrorVar=@@error, @TotalUpdated=@@rowcount
      IF (@ErrorVar<>0)
      BEGIN
      SET @IsError=1
      SET @Error_Code = @ErrorVar
      SET @Error_TTPKID = 0
      SET @Error_QueryCode = 'Update Account Fields using the AccountPKId from the TempTable '
      GOTO ExitPoint
      END
PRINT 'UPDATE Account_User_Assignment based on temp table'
      ----------------Update Approval Level 2 in Account_User_Assignment---------------------------------------------
      UPDATE Account_User_Assignment
      SET
      Account_User_Assignment.UserID = ISNULL(AccountsTempTable.Approver2ID,Account_User_Assignment.UserID),
      Account_User_Assignment.BUserID = ISNULL(AccountsTempTable.BUApprover2ID,Account_User_Assignment.BUserID),
      Account_User_Assignment.ScheduleID = ISNULL(AccountsTempTable.Approval2ScheduleId,Account_User_Assignment.ScheduleID)
      FROM Account_User_Assignment
      JOIN AccountsTempTable
      ON Account_User_Assignment.AccountID = AccountsTempTable.AccountPKId AND SignOffLevel = 2 AND AccountsTempTable.AccountPKId IS NOT NULL

      SELECT @ErrorVar=@@error, @TotalUpdated=@@rowcount
      IF (@ErrorVar<>0)
      BEGIN
      SET @IsError=1
      SET @Error_Code = @ErrorVar
      SET @Error_TTPKID = 0
      SET @Error_QueryCode = 'Update Approval Level 2'
      GOTO ExitPoint
      END

      ----------------Update Approval Level 3 in Account_User_Assignment---------------------------------------------
      UPDATE Account_User_Assignment
      SET
      Account_User_Assignment.UserID = ISNULL(AccountsTempTable.Approver3ID,Account_User_Assignment.UserID),
      Account_User_Assignment.BUserID = ISNULL(AccountsTempTable.BUApprover3ID,Account_User_Assignment.BUserID),
      Account_User_Assignment.ScheduleID = ISNULL(AccountsTempTable.Approval3ScheduleId,Account_User_Assignment.ScheduleID)
      FROM Account_User_Assignment
      JOIN AccountsTempTable
      ON Account_User_Assignment.AccountID = AccountsTempTable.AccountPKId AND SignOffLevel = 3 AND AccountsTempTable.AccountPKId IS NOT NULL

      SELECT @ErrorVar=@@error, @TotalUpdated=@@rowcount
      IF (@ErrorVar<>0)
      BEGIN
      SET @IsError=1
      SET @Error_Code = @ErrorVar
      SET @Error_TTPKID = 0
      SET @Error_QueryCode = 'Update Approval Level 3'
      GOTO ExitPoint
      END

      ----------------Update Approval Level 4 in Account_User_Assignment---------------------------------------------
      UPDATE Account_User_Assignment
      SET
      Account_User_Assignment.UserID = ISNULL(AccountsTempTable.Approver4ID,Account_User_Assignment.UserID),
      Account_User_Assignment.BUserID = ISNULL(AccountsTempTable.BUApprover4ID,Account_User_Assignment.BUserID),
      Account_User_Assignment.ScheduleID = ISNULL(AccountsTempTable.Approval4ScheduleId,Account_User_Assignment.ScheduleID)
      FROM Account_User_Assignment
      JOIN AccountsTempTable
      ON Account_User_Assignment.AccountID = AccountsTempTable.AccountPKId AND SignOffLevel = 4 AND AccountsTempTable.AccountPKId IS NOT NULL

      SELECT @ErrorVar=@@error, @TotalUpdated=@@rowcount
      IF (@ErrorVar<>0)
      BEGIN
      SET @IsError=1
      SET @Error_Code = @ErrorVar
      SET @Error_TTPKID = 0
      SET @Error_QueryCode = 'Update Approval Level 4'
      GOTO ExitPoint
      END

      ---------------------------------------- Insert Accounts from AccountsTempTable  -----------------------------------------
      ------------------------------------------------------------------------------------------------
PRINT 'Insert Accounts from AccountsTempTable  '
      DECLARE @ID AS INT
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
      DECLARE @AccountName AS VARCHAR(50)
      DECLARE @Description AS VARCHAR(2000)
      DECLARE @LocationId AS VARCHAR(15)
      DECLARE @AccountTypeId AS VARCHAR(15)
      DECLARE @QARiskRatingId AS VARCHAR(15)
      DECLARE @ReconPolicy AS VARCHAR(2000)
      DECLARE @CCY1Code AS CHAR(3)
      --Declare @ReconcileCCY1 bit
      DECLARE @CCY1HighBalance AS MONEY
      DECLARE @CCY1LowBalance AS MONEY
      DECLARE @CCY2Code AS CHAR(3)
      --Declare @ReconcileCCY2 as bit
      DECLARE @CCY2HighBalance AS MONEY
      DECLARE @CCY2LowBalance AS MONEY
      DECLARE @CCY3Code AS CHAR(3)
      --Declare @ReconcileCCY3 as bit
      DECLARE @CCY3HighBalance AS MONEY
      DECLARE @CCY3LowBalance AS MONEY
      DECLARE @ReconciliationScheduleId AS VARCHAR(15)
      DECLARE @ReviewScheduleId AS VARCHAR(15)
      DECLARE @RequiresApproval AS BIT
      DECLARE @ApprovalScheduleId AS VARCHAR(15)
      DECLARE @ReconcilerId AS INT
      DECLARE @BUReconcilerId AS INT
      DECLARE @ReviewerId AS INT
      DECLARE @BUReviewerId AS INT
      DECLARE @ApproverId AS INT
      DECLARE @BUApproverId AS INT
      DECLARE @ReconciliationFormatId AS INT
      DECLARE @CCY1GenerateBalance AS BIT
      DECLARE @CCY2GenerateBalance AS BIT
      DECLARE @CCY3GenerateBalance AS BIT
      DECLARE @CCY1DefaultRateType AS VARCHAR(15)
      DECLARE @CCY2DefaultRateType AS VARCHAR(15)
      DECLARE @CCY3DefaultRateType AS VARCHAR(15)
      DECLARE @ExcludeFXConversion AS BIT
      DECLARE @OwnerId AS VARCHAR(15)
      DECLARE @ZeroBalanceBulkFlg AS BIT
      DECLARE @IsGroup AS BIT
      DECLARE @ClearingStandardId AS VARCHAR(15)
      DECLARE @QATestCycleId AS VARCHAR(15)
      DECLARE @Active AS BIT
      DECLARE @NoChangeBulkFlg AS BIT
      DECLARE @CCY1SplitAllowance AS MONEY
      DECLARE @CCY2SplitAllowance AS MONEY
      DECLARE @CCY3SplitAllowance AS MONEY
      DECLARE @CCY1ManualMatchTolerance AS MONEY
      DECLARE @CCY2ManualMatchTolerance AS MONEY
      DECLARE @CCY3ManualMatchTolerance AS MONEY

/**************************************************************/
/*** Cursor start    */
DECLARE @counter INT = 0 
PRINT 'DECLARE Accountx CURSOR fast_forward local FOR'
DECLARE Accountx CURSOR FAST_FORWARD LOCAL FOR
      SELECT AccountSegment1,AccountSegment2 ,AccountSegment3,AccountSegment4,AccountSegment5,AccountSegment6,AccountSegment7
      ,AccountSegment8,AccountSegment9,AccountSegment10,AccountName,[Description],LocationId,AccountTypeID,QARiskRatingID
      ,ReconPolicy,[CCY1Code],CAST(CCY1HighBalance AS MONEY),CAST(CCY2LowBalance AS MONEY),[CCY2Code],CAST(CCY2HighBalance AS MONEY),CAST(CCY2LowBalance AS MONEY),[CCY3Code],CAST(CCY3HighBalance AS MONEY)
      ,CAST(CCY3LowBalance AS MONEY),ReconciliationScheduleID,ReviewScheduleID,RequiresApproval,ApprovalScheduleId,ReconcilerId,BUReconcilerId,ReviewerId,BUReviewerId
      ,ApproverId ,BUApproverId, ReconciliationFormatId,CCY1GenerateBalance,CCY2GenerateBalance,CCY3GenerateBalance,CCY1DefaultRateType,CCY2DefaultRateType,CCY3DefaultRateType,ExcludeFXConversion,OwnerId,ZeroBalanceBulkFlg,IsGroup,ClearingStandardID,QATestCycleID,ISNULL(Active,1),ISNULL(NoChangeBulkFlg,0)
      ,CAST(CCY1SplitAllowance AS MONEY),CAST(CCY2SplitAllowance AS MONEY),CAST(CCY3SplitAllowance AS MONEY),CAST(CCY1ManualMatchTolerance AS MONEY),CAST(CCY2ManualMatchTolerance AS MONEY),CAST(CCY3ManualMatchTolerance AS MONEY)
      FROM AccountsTempTable
      WHERE AccountPKId IS NULL


      OPEN Accountx

      FETCH NEXT FROM Accountx
      INTO @AccountSegment1 , @AccountSegment2 , @AccountSegment3 , @AccountSegment4 , @AccountSegment5 , @AccountSegment6 , @AccountSegment7 , @AccountSegment8
      , @AccountSegment9 , @AccountSegment10 ,@AccountName,@Description , @LocationId , @AccountTypeId , @QARiskRatingId , @ReconPolicy
      , @CCY1Code ,@CCY1HighBalance , @CCY1LowBalance , @CCY2Code , @CCY2HighBalance , @CCY2LowBalance ,@CCY3Code, @CCY3HighBalance , @CCY3LowBalance ,
      @ReconciliationScheduleId , @ReviewScheduleId, @RequiresApproval, @ApprovalScheduleId , @ReconcilerId , @BUReconcilerId , @ReviewerId ,@BUReviewerId
      , @ApproverId , @BUApproverId ,@ReconciliationFormatId,@CCY1GenerateBalance,@CCY2GenerateBalance,@CCY3GenerateBalance,@CCY1DefaultRateType,@CCY2DefaultRateType,@CCY3DefaultRateType,@ExcludeFXConversion,@OwnerId,@ZeroBalanceBulkFlg,@IsGroup,@ClearingStandardId,@QATestCycleId,@Active,@NoChangeBulkFlg
      , @CCY1SplitAllowance, @CCY2SplitAllowance, @CCY3SplitAllowance, @CCY1ManualMatchTolerance, @CCY2ManualMatchTolerance, @CCY3ManualMatchTolerance


      WHILE @@FETCH_STATUS = 0
      BEGIN
	SET @counter = @counter + 1
      INSERT INTO Accounts
		  (AccountName, DateActivated, [Description] , LocationID , AccountTypeID , QARiskRatingID , ReconPolicy
		  , CCY1Code ,ReconcileCCY1 , CCY1HighBalance , CCY1LowBalance , CCY2Code , ReconcileCCY2 ,CCY2HighBalance , CCY2LowBalance ,CCY3Code, ReconcileCCY3 , CCY3HighBalance , CCY3LowBalance ,
		  ReconciliationScheduleID , ReviewScheduleID, RequiresApproval, ApprovalScheduleID , ReconcilerID , BUReconcilerID , ReviewerID ,BUReviewerID
		  , ApproverID , BUApproverID, ReconciliationFormatID,CCY1GenerateBalance,CCY2GenerateBalance,CCY3GenerateBalance,CCY1DefaultRateType,CCY2DefaultRateType,CCY3DefaultRateType,ExcludeFXConversion,OwnerId,ZeroBalanceBulkFlg,IsGroup,ClearingStandardID,QATestCycleID,Active,NoChangeBulkFlg
		  , CCY1SplitAllowance, CCY2SplitAllowance, CCY3SplitAllowance, CCY1ManualMatchTolerance, CCY2ManualMatchTolerance, CCY3ManualMatchTolerance)
		  VALUES(@AccountName,@CurrentDt,@Description , @LocationId , @AccountTypeId , @QARiskRatingId , @ReconPolicy
		  , @CCY1Code ,@CCY1GenerateBalance , @CCY1HighBalance , @CCY1LowBalance , @CCY2Code , @CCY2GenerateBalance ,@CCY2HighBalance , @CCY2LowBalance ,@CCY3Code, @CCY3GenerateBalance , @CCY3HighBalance , @CCY3LowBalance ,
		  @ReconciliationScheduleId , @ReviewScheduleId, @RequiresApproval, @ApprovalScheduleId , @ReconcilerId , @BUReconcilerId , @ReviewerId ,@BUReviewerId
		  , @ApproverId , @BUApproverId, @ReconciliationFormatId,@CCY1GenerateBalance,@CCY2GenerateBalance,@CCY3GenerateBalance,@CCY1DefaultRateType,@CCY2DefaultRateType,@CCY3DefaultRateType,@ExcludeFXConversion,@OwnerId,@ZeroBalanceBulkFlg,@IsGroup,@ClearingStandardId,@QATestCycleId,@Active,@NoChangeBulkFlg
		  , @CCY1SplitAllowance, @CCY2SplitAllowance, @CCY3SplitAllowance, @CCY1ManualMatchTolerance, @CCY2ManualMatchTolerance, @CCY3ManualMatchTolerance)
      SELECT @ID = @@IDENTITY, @ErrorVar=@@error
      IF (@ErrorVar <>0 )
		  BEGIN
			  SET @IsError=1
			  SET @Error_Code = @ErrorVar
			  SET @Error_QueryCode = 'Inserting records into Account Segments from AccountsTempTable'
			  GOTO ExitPoint
		  END

      SET @TotalInserted = @TotalInserted + 1
PRINT '    In Accountx  @counter = '  + CONVERT(VARCHAR,@counter) + '             PKID = ' + CONVERT(VARCHAR,@ID) ;
      INSERT INTO AccountSegments
		  (AccountId, AccountSegment1, AccountSegment2, AccountSegment3, AccountSegment4, AccountSegment5, AccountSegment6, AccountSegment7, AccountSegment8, AccountSegment9, AccountSegment10 )
		  VALUES(@ID, @AccountSegment1 , @AccountSegment2 , @AccountSegment3 , @AccountSegment4 , @AccountSegment5 , @AccountSegment6 , @AccountSegment7 , @AccountSegment8 , @AccountSegment9 , @AccountSegment10)
      SELECT @ErrorVar=@@error
      IF (@ErrorVar <>0 )
		  BEGIN
			  SET @IsError=1
			  SET @Error_Code = @ErrorVar
			  SET @Error_QueryCode = 'Inserting records into Account Segments from AccountsTempTable'
			  GOTO ExitPoint
		  END
				--If @counter > 999
				--Begin
				--	Commit;
				--	Set @counter = 0;
				--	Print ' Commited 999 rows of Accountx work '
				--End
		 
	
      FETCH NEXT FROM Accountx
		  INTO @AccountSegment1 , @AccountSegment2 , @AccountSegment3 , @AccountSegment4 , @AccountSegment5 , @AccountSegment6 , @AccountSegment7 , @AccountSegment8
		  , @AccountSegment9 , @AccountSegment10 ,@AccountName,@Description , @LocationId , @AccountTypeId , @QARiskRatingId , @ReconPolicy
		  , @CCY1Code ,@CCY1HighBalance , @CCY1LowBalance , @CCY2Code , @CCY2HighBalance , @CCY2LowBalance ,@CCY3Code, @CCY3HighBalance , @CCY3LowBalance ,
		  @ReconciliationScheduleId , @ReviewScheduleId, @RequiresApproval, @ApprovalScheduleId , @ReconcilerId , @BUReconcilerId , @ReviewerId ,@BUReviewerId
		  , @ApproverId , @BUApproverId ,@ReconciliationFormatId,@CCY1GenerateBalance,@CCY2GenerateBalance,@CCY3GenerateBalance,@CCY1DefaultRateType,@CCY2DefaultRateType,@CCY3DefaultRateType,@ExcludeFXConversion,@OwnerId,@ZeroBalanceBulkFlg,@IsGroup,@ClearingStandardId,@QATestCycleId,@Active,@NoChangeBulkFlg
		  , @CCY1SplitAllowance, @CCY2SplitAllowance, @CCY3SplitAllowance, @CCY1ManualMatchTolerance, @CCY2ManualMatchTolerance, @CCY3ManualMatchTolerance
      END

      ---------------------------------- Update Account PKId in Temp Table --------------------
      -------------------------------------------------------------------------------------------------
 PRINT '    End of Accountx Cursor;  Updating AccountsTempTable to be the PKID in the Accounts table'
      UPDATE AccountsTempTable
      SET AccountsTempTable.AccountPKId = A.PKId
      FROM
      AccountsTempTable T
      INNER JOIN AccountSegments S ON ISNULL(T.AccountSegment1,'^')=ISNULL(S.AccountSegment1,'^')
      AND ISNULL(T.AccountSegment2,'^')=ISNULL(S.AccountSegment2,'^')
      AND ISNULL(T.AccountSegment3,'^')=ISNULL(S.AccountSegment3,'^')
      AND ISNULL(T.AccountSegment4,'^')=ISNULL(S.AccountSegment4,'^')
      AND ISNULL(T.AccountSegment5,'^')=ISNULL(S.AccountSegment5,'^')
      AND ISNULL(T.AccountSegment6,'^')=ISNULL(S.AccountSegment6,'^')
      AND ISNULL(T.AccountSegment7,'^')=ISNULL(S.AccountSegment7,'^')
      AND ISNULL(T.AccountSegment8,'^')=ISNULL(S.AccountSegment8,'^')
      AND ISNULL(T.AccountSegment9,'^')=ISNULL(S.AccountSegment9,'^')
      AND ISNULL(T.AccountSegment10,'^')=ISNULL(S.AccountSegment10,'^')
      INNER JOIN Accounts A ON S.AccountId=A.PKId

      SELECT @ErrorVar=@@error, @RowsUpdated=@@rowcount
      IF (@ErrorVar<>0)
      BEGIN
      SET @IsError=1
      SET @Error_Code = @ErrorVar
      SET @Error_QueryCode = 'Error Updating AccountsTempTable, setting AccountId from the AccountSegments table'
      GOTO ExitPoint
      END

      --------------------------------------Exit Points---------------------------------------------
      ----------------------------------------------------------------------------------------------------


ValidationExitPoint:
      IF(@Result < 0)
      BEGIN
		  PRINT 'Exiting with error code ' + CONVERT(VARCHAR,@Result)
		  --INSERT INTO Interfaces_History(InterfaceID, RunDate, Result, TotalRecords, RecordsInserted, RecordsUpdated, Errors, StartTime, EndTime )
		  --values(@InterfaceID, GetDate(), 3, 0, 0, 0,1,@StartTime,GetDate())
		  EXEC usp_AddToInterfaceHistory @InterfaceHistoryPKId,@InterfaceID,@CurrentDt,3,0,0,0,1,@StartTime,@CurrentDt,NULL,NULL
		  IF(@Error_QueryCode IS NOT NULL AND @Error_QueryCode != NULL)
		  RAISERROR (@Error_QueryCode, 16, 1)
		  ELSE
		  RAISERROR ('Validation Error.', 16, 1)
		  RETURN
      END

ExitPoint:
    IF (@IsError=1)
		  BEGIN
			  PRINT 'would have rolledback'
		  --ROLLBACK TRAN
			  INSERT INTO Interfaces_Error(ErrorDate, TempTablePKID , ErrorCode, ErrorQueryCode, InterfaceID,InterfaceHistoryPKId) VALUES(GETDATE(), ISNULL(@Error_TTPKID,0), @Error_Code, @Error_QueryCode, @InterfaceID,@InterfaceHistoryPKId )
			  SET @ErrorID= IDENT_CURRENT('Interfaces_Error')
			  --INSERT INTO Interfaces_History(InterfaceID, RunDate, Result, TotalRecords, RecordsInserted, RecordsUpdated, Errors, StartTime, EndTime )
			  --values(@InterfaceID, GetDate(), 3, 0, 0, 0,1,@StartTime,GetDate())
			  EXEC usp_AddToInterfaceHistory @InterfaceHistoryPKId,@InterfaceID,@CurrentDt,3,0,0,0,1,@StartTime,@CurrentDt,NULL,NULL
			  IF(@Error_QueryCode IS NOT NULL AND @Error_QueryCode != NULL)
			  RAISERROR (@Error_QueryCode, 16, 1)
			  ELSE
			  RAISERROR ('Undeffined Error.', 16, 1)
			  RETURN
		  END
	ELSE
		  BEGIN
				PRINT ' ExitPoint: Commit would have happened here '
	--	  COMMIT TRAN
				SET @ErrorID =0
				SELECT @ErrorID
				--INSERT INTO Interfaces_History(InterfaceID, RunDate, Result, TotalRecords, RecordsInserted, RecordsUpdated, Errors, StartTime, EndTime )
				--values(@InterfaceID, GetDate(), 1, @TotalRecords, @TotalInserted, @TotalUpdated,0, @StartTime, GetDate())
				EXEC usp_AddToInterfaceHistory @InterfaceHistoryPKId,@InterfaceID,@CurrentDt,1,@TotalRecords, @TotalInserted, @TotalUpdated,0, @StartTime, @CurrentDt,NULL,NULL
		   END -- else
  CLOSE Accountx
  DEALLOCATE Accountx

      DECLARE @accID AS INT
      DECLARE @app2 AS INT
      DECLARE @app3 AS INT
      DECLARE @app4 AS INT
      DECLARE @buApp2 AS INT
      DECLARE @buApp3 AS INT
      DECLARE @buApp4 AS INT
      DECLARE @appSched2 AS VARCHAR(15)
      DECLARE @appSched3 AS VARCHAR(15)
      DECLARE @appSched4 AS VARCHAR(15)
	PRINT ' In cursor AccountUserAssignment  '
SET @counter = 0 
DECLARE AccountUserAssignment CURSOR FAST_FORWARD LOCAL FOR
      SELECT
		  AccountPKId,
		  Approver2ID,
		  Approver3ID,
		  Approver4ID,
		  BUApprover2ID,
		  BUApprover3ID,
		  BUApprover4ID,
		  Approval2ScheduleId,
		  Approval3ScheduleId,
		  Approval4ScheduleId
      FROM AccountsTempTable
      WHERE AccountPKId IS NOT NULL

      OPEN AccountUserAssignment

      FETCH NEXT FROM AccountUserAssignment      INTO
		  @accID,
		  @app2,
		  @app3,
		  @app4,
		  @buApp2,
		  @buApp3,
		  @buApp4,
		  @appSched2,
		  @appSched3,
		  @appSched4

      WHILE @@FETCH_STATUS = 0
      BEGIN
		SET @counter = @counter +1
--	print ' In cursor AccountUserAssignment    @counter = '  + convert(varchar,@counter)
		IF (@app2 IS NOT NULL)
		BEGIN
			IF((SELECT COUNT(PKID) FROM Account_User_Assignment WHERE AccountID = @accID AND SignOffLevel = 2) = 0)
				INSERT INTO Account_User_Assignment (UserID,BUserID,SignOffLevel,ScheduleID,AccountID) VALUES(@app2,@buApp2,2,@appSched2,@accID)
		END
		IF (@app3 IS NOT NULL)
		BEGIN
			IF((SELECT COUNT(PKID) FROM Account_User_Assignment WHERE AccountID = @accID AND SignOffLevel = 3) = 0)
				INSERT INTO Account_User_Assignment (UserID,BUserID,SignOffLevel,ScheduleID,AccountID) VALUES(@app3,@buApp3,3,@appSched3,@accID)
		END
		IF (@app4 IS NOT NULL)
		BEGIN
			IF((SELECT COUNT(PKID) FROM Account_User_Assignment WHERE AccountID = @accID AND SignOffLevel = 4) = 0)
				INSERT INTO Account_User_Assignment (UserID,BUserID,SignOffLevel,ScheduleID,AccountID) VALUES(@app4,@buApp4,4,@appSched4,@accID)
        END

			
		FETCH NEXT FROM AccountUserAssignment		  INTO
			  @accID,
			  @app2,
			  @app3,
			  @app4,
			  @buApp2,
			  @buApp3,
			  @buApp4,
			  @appSched2,
			  @appSched3,
			  @appSched4
      END  --While Cursor loop
      CLOSE AccountUserAssignment
      DEALLOCATE AccountUserAssignment
  PRINT ' End of cursor AccountUserAssignment and end of procedure  TOOLKIT_Accounts_Interface'    

GO

