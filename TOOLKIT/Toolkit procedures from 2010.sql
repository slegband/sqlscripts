SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[TOOLKIT_Accounts_Interface]  
(
	@InterfaceID int, 
	@StartTime DateTime, 
	@InterfaceHistoryPKId int
) 
AS
set nocount on
	  Declare @Result as smallint
      Set @Result = 0

      DECLARE @Error_TTPKID as int
      Declare @Error_Code as int
      Declare @Error_QueryCode as varchar(200)
      Declare @ErrorVar int
      Declare @ErrorID int
      Declare @IsError int

      Declare @TotalInserted int
      Declare @TotalRecords int
      Declare @TotalUpdated int
      Declare @RowsUpdated int

      Set @TotalInserted =0
      Set @TotalRecords =0
      Set @TotalUpdated =0
      Set @RowsUpdated =0

      Declare @CurrentDt datetime
      Set @CurrentDt = GetDate()


      Set @TotalRecords = (Select count(*) from accountstemptable)

      Set @IsError = 0
Print '--Validate Locations'

      --Validate Locations
      exec @Result = usp_InterfaceValidateTableColumns @InterfaceId,@StartTime,'AccountsTempTable','Code_Locations','LocationId','Code',1,0,@InterfaceHistoryPKId

      if(@Result < 0)
      begin
      print 'Location Validation Error: ' + Convert(varchar,@Result)
      goto ValidationExitPoint
      end
PRINT '--Validate CCY1Code'
      --Validate CCY1Code
      exec @Result = usp_InterfaceValidateTableColumns @InterfaceId,@StartTime,'AccountsTempTable','Code_Currencies','CCY1Code','Code',1,0,@InterfaceHistoryPKId

      if(@Result < 0)
      begin
      print 'CCY1 Code Validation Error: ' + Convert(varchar,@Result)
      goto ValidationExitPoint
      end
PRINT '--Validate CCY2Code'
      --Validate CCY2Code
      exec @Result = usp_InterfaceValidateTableColumns @InterfaceId,@StartTime,'AccountsTempTable','Code_Currencies','CCY2Code','Code',1,0,@InterfaceHistoryPKId

      if(@Result < 0)
      begin
      print 'CCY2 Code Validation Error: ' + Convert(varchar,@Result)
      goto ValidationExitPoint
      end
PRINT '--Validate CCY3Code'

      --Validate CCY3Code
      exec @Result = usp_InterfaceValidateTableColumns @InterfaceId,@StartTime,'AccountsTempTable','Code_Currencies','CCY3Code','Code',1,0,@InterfaceHistoryPKId

      if(@Result < 0)
      begin
      print 'CCY3 Code Validation Error: ' + Convert(varchar,@Result)
      goto ValidationExitPoint
      end
PRINT ' --Validate Reconciler User Name'

      --Validate Reconciler User Name
      exec @Result = usp_InterfaceValidateTableColumns @InterfaceId,@StartTime,'AccountsTempTable','Users','ReconcilerUserName','UserName',1,0,@InterfaceHistoryPKId

      if(@Result < 0)
      begin
      print 'Reconciler User Name Validation Error: ' + Convert(varchar,@Result)
      goto ValidationExitPoint
      end
PRINT '--Validate BUReconciler User Name'
      --Validate BUReconciler User Name
      exec @Result = usp_InterfaceValidateTableColumns @InterfaceId,@StartTime,'AccountsTempTable','Users','BUReconcilerUserName','UserName',1,0,@InterfaceHistoryPKId

      if(@Result < 0)
      begin
      print 'BUReconciler User Name Validation Error: ' + Convert(varchar,@Result)
      goto ValidationExitPoint
      end

PRINT '--Validate Reconciliation Schedule'
      --Validate Reconciliation Schedule
      exec @Result = usp_InterfaceValidateTableColumns @InterfaceId,@StartTime,'AccountsTempTable','Code_ReconciliationSchedule','ReconciliationScheduleId','Code',1,0,@InterfaceHistoryPKId

      if(@Result < 0)
      begin
      print 'Reconciliation Schedule Validation Error: ' + Convert(varchar,@Result)
      goto ValidationExitPoint
      end


PRINT '--Validate Reviewer User Name'
      --Validate Reviewer User Name
      exec @Result = usp_InterfaceValidateTableColumns @InterfaceId,@StartTime,'AccountsTempTable','Users','ReviewerUserName','UserName',1,0,@InterfaceHistoryPKId

      if(@Result < 0)
      begin
      print 'Reviewer User Name Validation Error: ' + Convert(varchar,@Result)
      goto ValidationExitPoint
      end

PRINT '--Validate BUReviewer User Name'
      --Validate BUReviewer User Name
      exec @Result = usp_InterfaceValidateTableColumns @InterfaceId,@StartTime,'AccountsTempTable','Users','BUReviewerUserName','UserName',1,0,@InterfaceHistoryPKId

      if(@Result < 0)
      begin
      print 'BUReviewer User Name Validation Error: ' + Convert(varchar,@Result)
      goto ValidationExitPoint
      end

PRINT '--Validate Review Schedule'
      --Validate Review Schedule
      exec @Result = usp_InterfaceValidateTableColumns @InterfaceId,@StartTime,'AccountsTempTable','Code_ReviewSchedule','ReviewScheduleId','Code',1,0,@InterfaceHistoryPKId

      if(@Result < 0)
      begin
      print 'Review Schedule Validation Error: ' + Convert(varchar,@Result)
      goto ValidationExitPoint
      end


PRINT '--Validate Approver User Name'
      --Validate Approver User Name
      exec @Result = usp_InterfaceValidateTableColumns @InterfaceId,@StartTime,'AccountsTempTable','Users','ApproverUserName','UserName',1,0,@InterfaceHistoryPKId

      if(@Result < 0)
      begin
      print 'Approver User Name Validation Error: ' + Convert(varchar,@Result)
      goto ValidationExitPoint
      end

PRINT '--Validate BUApprover User Name'
      --Validate BUApprover User Name
      exec @Result = usp_InterfaceValidateTableColumns @InterfaceId,@StartTime,'AccountsTempTable','Users','BUApproverUserName','UserName',1,0,@InterfaceHistoryPKId

      if(@Result < 0)
      begin
      print 'BUReviewer User Name Validation Error: ' + Convert(varchar,@Result)
      goto ValidationExitPoint
      end

PRINT '-Validate Approver2 User Name'
      --Validate Approver2 User Name
      exec @Result = usp_InterfaceValidateTableColumns @InterfaceId,@StartTime,'AccountsTempTable','Users','Approver2UserName','UserName',1,0,@InterfaceHistoryPKId

      if(@Result < 0)
      begin
      print 'Approver2 User Name Validation Error: ' + Convert(varchar,@Result)
      goto ValidationExitPoint
      end

PRINT ''
      --Validate BUApprover2 User Name
      exec @Result = usp_InterfaceValidateTableColumns @InterfaceId,@StartTime,'AccountsTempTable','Users','BUApprover2UserName','UserName',1,0,@InterfaceHistoryPKId

      if(@Result < 0)
      begin
      print 'BUReviewer2 User Name Validation Error: ' + Convert(varchar,@Result)
      goto ValidationExitPoint
      end

PRINT '--Validate Approver3 User Name'
      --Validate Approver3 User Name
      exec @Result = usp_InterfaceValidateTableColumns @InterfaceId,@StartTime,'AccountsTempTable','Users','Approver3UserName','UserName',1,0,@InterfaceHistoryPKId

      if(@Result < 0)
      begin
      print 'Approver3 User Name Validation Error: ' + Convert(varchar,@Result)
      goto ValidationExitPoint
      end

PRINT '--Validate BUApprover3 User Name'
      --Validate BUApprover3 User Name
      exec @Result = usp_InterfaceValidateTableColumns @InterfaceId,@StartTime,'AccountsTempTable','Users','BUApprover3UserName','UserName',1,0,@InterfaceHistoryPKId

      if(@Result < 0)
      begin
      print 'BUReviewer3 User Name Validation Error: ' + Convert(varchar,@Result)
      goto ValidationExitPoint
      end

PRINT ''
      --Validate Approver4 User Name
      exec @Result = usp_InterfaceValidateTableColumns @InterfaceId,@StartTime,'AccountsTempTable','Users','Approver4UserName','UserName',1,0,@InterfaceHistoryPKId

      if(@Result < 0)
      begin
      print 'Approver4 User Name Validation Error: ' + Convert(varchar,@Result)
      goto ValidationExitPoint
      end

PRINT '--Validate BUApprover4 User Name'
      --Validate BUApprover4 User Name
      exec @Result = usp_InterfaceValidateTableColumns @InterfaceId,@StartTime,'AccountsTempTable','Users','BUApprover4UserName','UserName',1,0,@InterfaceHistoryPKId

      if(@Result < 0)
      begin
      print 'BUReviewer4 User Name Validation Error: ' + Convert(varchar,@Result)
      goto ValidationExitPoint
      end

PRINT '--Validate Approval Schedule'
      --Validate Approval Schedule
      exec @Result = usp_InterfaceValidateTableColumns @InterfaceId,@StartTime,'AccountsTempTable','Code_ApprovalSchedule','ApprovalScheduleId','Code',1,0,@InterfaceHistoryPKId

      if(@Result < 0)
      begin
      print 'Approval Schedule Validation Error: ' + Convert(varchar,@Result)
      goto ValidationExitPoint
      end

PRINT '--Validate Approval2 Schedule'
      --Validate Approval2 Schedule
      exec @Result = usp_InterfaceValidateTableColumns @InterfaceId,@StartTime,'AccountsTempTable','Code_ApprovalSchedule','Approval2ScheduleId','Code',1,0,@InterfaceHistoryPKId

      if(@Result < 0)
      begin
      print 'Approval2 Schedule Validation Error: ' + Convert(varchar,@Result)
      goto ValidationExitPoint
      end

PRINT '--Validate Approval3 Schedule'
      --Validate Approval3 Schedule
      exec @Result = usp_InterfaceValidateTableColumns @InterfaceId,@StartTime,'AccountsTempTable','Code_ApprovalSchedule','Approval3ScheduleId','Code',1,0,@InterfaceHistoryPKId

      if(@Result < 0)
      begin
      print 'Approval3 Schedule Validation Error: ' + Convert(varchar,@Result)
      goto ValidationExitPoint
      end

PRINT '--Validate Approval4 Schedule'
      --Validate Approval4 Schedule
      exec @Result = usp_InterfaceValidateTableColumns @InterfaceId,@StartTime,'AccountsTempTable','Code_ApprovalSchedule','Approval4ScheduleId','Code',1,0,@InterfaceHistoryPKId

      if(@Result < 0)
      begin
      print 'Approval4 Schedule Validation Error: ' + Convert(varchar,@Result)
      goto ValidationExitPoint
      end


PRINT '--Validate Reconciliation Formats'
      --Validate Reconciliation Formats
      exec @Result = usp_InterfaceValidateTableColumns @InterfaceId,@StartTime,'AccountsTempTable','Define_ReconciliationChildFormats','ReconciliationFormatName','Name',1,0,@InterfaceHistoryPKId

      if(@Result < 0)
      begin
      print 'Reconciliation Formats Validation Error: ' + Convert(varchar,@Result)
      goto ValidationExitPoint
      end

PRINT '--Validate QA Risk Rating'
      --Validate QA Risk Rating
      exec @Result = usp_InterfaceValidateTableColumns @InterfaceId,@StartTime,'AccountsTempTable','Code_QARiskRatings','QARiskRatingId','Code',1,0,@InterfaceHistoryPKId

      if(@Result < 0)
      begin
      print ' QA Risk Rating Validation Error: ' + Convert(varchar,@Result)
      goto ValidationExitPoint
      end

PRINT '--Validate QA Test Cycle'
      --Validate QA Test Cycle
      exec @Result = usp_InterfaceValidateTableColumns @InterfaceId,@StartTime,'AccountsTempTable','Code_QATestCycles','QATestCycleId','Code',1,0,@InterfaceHistoryPKId

      if(@Result < 0)
      begin
      print ' QA Test Cycle Validation Error: ' + Convert(varchar,@Result)
      goto ValidationExitPoint
      end

PRINT '--Validate Account Type'
      --Validate Account Type
      exec @Result = usp_InterfaceValidateTableColumns @InterfaceId,@StartTime,'AccountsTempTable','Code_AccountTypes','AccountTypeId','Code',1,0,@InterfaceHistoryPKId

      if(@Result < 0)
      begin
      print 'Account Type Validation Error: ' + Convert(varchar,@Result)
      goto ValidationExitPoint
      end

PRINT '--Validate CCY1 Default Rate Type'
      --Validate CCY1 Default Rate Type
      exec @Result = usp_InterfaceValidateTableColumns @InterfaceId,@StartTime,'AccountsTempTable','Code_RateTypes','CCY1DefaultRateType','Code',1,0,@InterfaceHistoryPKId

      if(@Result < 0)
      begin
      print 'CCY1 Default Rate Type: ' + Convert(varchar,@Result)
      goto ValidationExitPoint
      end

PRINT '--Validate CCY2 Default Rate Type'
      --Validate CCY2 Default Rate Type
      exec @Result = usp_InterfaceValidateTableColumns @InterfaceId,@StartTime,'AccountsTempTable','Code_RateTypes','CCY2DefaultRateType','Code',1,0,@InterfaceHistoryPKId

      if(@Result < 0)
      begin
      print 'CCY2 Default Rate Type: ' + Convert(varchar,@Result)
      goto ValidationExitPoint
      end

PRINT '--Validate CCY3 Default Rate Type'
      --Validate CCY3 Default Rate Type
      exec @Result = usp_InterfaceValidateTableColumns @InterfaceId,@StartTime,'AccountsTempTable','Code_RateTypes','CCY3DefaultRateType','Code',1,0,@InterfaceHistoryPKId

      if(@Result < 0)
      begin
      print 'CCY3 Default Rate Type: ' + Convert(varchar,@Result)
      goto ValidationExitPoint
      end

PRINT '--Validate OwnerId'
      --Validate OwnerId
      exec @Result = usp_InterfaceValidateTableColumns @InterfaceId,@StartTime,'AccountsTempTable','Code_Owners','OwnerId','Code',1,0,@InterfaceHistoryPKId

      if(@Result < 0)
      begin
      print 'OwnerId Validation Error: ' + Convert(varchar,@Result)
      goto ValidationExitPoint
      end

PRINT '--Validate ClearingStandardId'
      --Validate ClearingStandardId
      exec @Result = usp_InterfaceValidateTableColumns @InterfaceId,@StartTime,'AccountsTempTable','Code_ClearingStandards','ClearingStandardID','Code',1,0,@InterfaceHistoryPKId

      if(@Result < 0)
      begin
      print 'ClearingStandardId Validation Error: ' + Convert(varchar,@Result)
      goto ValidationExitPoint
      end
Print 'Validation complete'
Print 'Begin Tran was here.  starting update on AccountsTempTable '
--Begin Tran


      ---------------------------------------- Reconciler -----------------------------------------
      ------------------------------------------------------------------------------------------------

      Update AccountsTempTable
      Set AccountsTempTable.ReconcilerId  = Users.PKId
      From Users
      Where AccountsTempTable.ReconcilerUserName = Users.UserName

      Select @ErrorVar=@@error, @RowsUpdated=@@rowcount
      IF (@ErrorVar<>0)
      BEGIN
      Set @IsError=1
      Set @Error_Code = @ErrorVar
      Set @Error_QueryCode = 'Update AccountsTempTable Set AccountsTempTable.ReconcilerId  = Users.PKId From Users Where AccountsTempTable.ReconcilerUserName = Users.UserName'
      GOTO ExitPoint
      END


      ---------------------------------------- BU Reconciler -----------------------------------------
      ------------------------------------------------------------------------------------------------

      Update AccountsTempTable
      Set AccountsTempTable.BUReconcilerId  = Users.PKId
      From Users
      Where AccountsTempTable.BUReconcilerUserName = Users.UserName

      Select @ErrorVar=@@error, @RowsUpdated=@@rowcount
      IF (@ErrorVar<>0)
      BEGIN
      Set @IsError=1
      Set @Error_Code = @ErrorVar
      Set @Error_QueryCode = 'Update AccountsTempTable Set AccountsTempTable.BUReconcilerId  = Users.PKId From Users Where AccountsTempTable.BUReconcilerUserName = Users.UserName'
      GOTO ExitPoint
      END


      ---------------------------------------- Reviewer  -----------------------------------------
      ------------------------------------------------------------------------------------------------

      Update AccountsTempTable
      Set AccountsTempTable.ReviewerId  = Users.PKId
      From Users
      Where AccountsTempTable.ReviewerUserName = Users.UserName

      Select @ErrorVar=@@error, @RowsUpdated=@@rowcount
      IF (@ErrorVar<>0)
      BEGIN
      Set @IsError=1
      Set @Error_Code = @ErrorVar
      Set @Error_QueryCode = 'Update AccountsTempTable Set AccountsTempTable.ReviewerId  = Users.PKId From Users Where AccountsTempTable.ReviewerUserName = Users.UserName'
      GOTO ExitPoint
      END



      ---------------------------------------- BUReviewer  -----------------------------------------
      ------------------------------------------------------------------------------------------------


      Update AccountsTempTable
      Set AccountsTempTable.BUReviewerId  = Users.PKId
      From Users
      Where AccountsTempTable.BUReviewerUserName = Users.UserName

      Select @ErrorVar=@@error, @RowsUpdated=@@rowcount
      IF (@ErrorVar<>0)
      BEGIN
      Set @IsError=1
      Set @Error_Code = @ErrorVar
      Set @Error_QueryCode = 'Update AccountsTempTable Set AccountsTempTable.BUReviewerId  = Users.PKId From Users Where AccountsTempTable.BUReviewerUserName = Users.UserName'
      GOTO ExitPoint
      END


      ---------------------------------------- Approver  -----------------------------------------
      ------------------------------------------------------------------------------------------------


      Update AccountsTempTable
      Set AccountsTempTable.ApproverId  = Users.PKId
      From Users
      Where AccountsTempTable.ApproverUserName = Users.UserName

      Select @ErrorVar=@@error, @RowsUpdated=@@rowcount
      IF (@ErrorVar<>0)
      BEGIN
      Set @IsError=1
      Set @Error_Code = @ErrorVar
      Set @Error_QueryCode = 'Update AccountsTempTable Set AccountsTempTable.ApproverId  = Users.PKId From Users Where AccountsTempTable.ApproverUserName = Users.UserName'
      GOTO ExitPoint
      END

      ---------------------------------------- BUApprover  -----------------------------------------
      ------------------------------------------------------------------------------------------------

      Update AccountsTempTable
      Set AccountsTempTable.BUApproverId  = Users.PKId
      From Users
      Where AccountsTempTable.BUApproverUserName = Users.UserName

      Select @ErrorVar=@@error, @RowsUpdated=@@rowcount
      IF (@ErrorVar<>0)
      BEGIN
      Set @IsError=1
      Set @Error_Code = @ErrorVar
      Set @Error_QueryCode = 'Update AccountsTempTable Set AccountsTempTable.BUApproverId  = Users.PKId From Users Where AccountsTempTable.BUApproverUserName = Users.UserName'
      GOTO ExitPoint
      END

      ---------------------------------------- Approver2  -----------------------------------------
      ------------------------------------------------------------------------------------------------


      Update AccountsTempTable
      Set AccountsTempTable.Approver2Id  = Users.PKId
      From Users
      Where AccountsTempTable.Approver2UserName = Users.UserName

      Select @ErrorVar=@@error, @RowsUpdated=@@rowcount
      IF (@ErrorVar<>0)
      BEGIN
      Set @IsError=1
      Set @Error_Code = @ErrorVar
      Set @Error_QueryCode = 'Update AccountsTempTable Set AccountsTempTable.Approver2Id  = Users.PKId From Users Where AccountsTempTable.Approver2UserName = Users.UserName'
      GOTO ExitPoint
      END

      ---------------------------------------- BUApprover2  -----------------------------------------
      ------------------------------------------------------------------------------------------------

      Update AccountsTempTable
      Set AccountsTempTable.BUApprover2Id  = Users.PKId
      From Users
      Where AccountsTempTable.BUApprover2UserName = Users.UserName

      Select @ErrorVar=@@error, @RowsUpdated=@@rowcount
      IF (@ErrorVar<>0)
      BEGIN
      Set @IsError=1
      Set @Error_Code = @ErrorVar
      Set @Error_QueryCode = 'Update AccountsTempTable Set AccountsTempTable.BUApprover2Id  = Users.PKId From Users Where AccountsTempTable.BUApprover2UserName = Users.UserName'
      GOTO ExitPoint
      END

      ---------------------------------------- Approver3  -----------------------------------------
      ------------------------------------------------------------------------------------------------


      Update AccountsTempTable
      Set AccountsTempTable.Approver3Id  = Users.PKId
      From Users
      Where AccountsTempTable.Approver3UserName = Users.UserName

      Select @ErrorVar=@@error, @RowsUpdated=@@rowcount
      IF (@ErrorVar<>0)
      BEGIN
      Set @IsError=1
      Set @Error_Code = @ErrorVar
      Set @Error_QueryCode = 'Update AccountsTempTable Set AccountsTempTable.Approver3Id  = Users.PKId From Users Where AccountsTempTable.Approver3UserName = Users.UserName'
      GOTO ExitPoint
      END

      ---------------------------------------- BUApprover3  -----------------------------------------
      ------------------------------------------------------------------------------------------------

      Update AccountsTempTable
      Set AccountsTempTable.BUApprover3Id  = Users.PKId
      From Users
      Where AccountsTempTable.BUApprover3UserName = Users.UserName

      Select @ErrorVar=@@error, @RowsUpdated=@@rowcount
      IF (@ErrorVar<>0)
      BEGIN
      Set @IsError=1
      Set @Error_Code = @ErrorVar
      Set @Error_QueryCode = 'Update AccountsTempTable Set AccountsTempTable.BUApprover3Id  = Users.PKId From Users Where AccountsTempTable.BUApprover3UserName = Users.UserName'
      GOTO ExitPoint
      END

      ---------------------------------------- Approver4  -----------------------------------------
      ------------------------------------------------------------------------------------------------


      Update AccountsTempTable
      Set AccountsTempTable.Approver4Id  = Users.PKId
      From Users
      Where AccountsTempTable.Approver4UserName = Users.UserName

      Select @ErrorVar=@@error, @RowsUpdated=@@rowcount
      IF (@ErrorVar<>0)
      BEGIN
      Set @IsError=1
      Set @Error_Code = @ErrorVar
      Set @Error_QueryCode = 'Update AccountsTempTable Set AccountsTempTable.Approver4Id  = Users.PKId From Users Where AccountsTempTable.Approver4UserName = Users.UserName'
      GOTO ExitPoint
      END

      ---------------------------------------- BUApprover4  -----------------------------------------
      ------------------------------------------------------------------------------------------------

      Update AccountsTempTable
      Set AccountsTempTable.BUApprover4Id  = Users.PKId
      From Users
      Where AccountsTempTable.BUApprover4UserName = Users.UserName

      Select @ErrorVar=@@error, @RowsUpdated=@@rowcount
      IF (@ErrorVar<>0)
      BEGIN
      Set @IsError=1
      Set @Error_Code = @ErrorVar
      Set @Error_QueryCode = 'Update AccountsTempTable Set AccountsTempTable.BUApprover4Id  = Users.PKId From Users Where AccountsTempTable.BUApprover4UserName = Users.UserName'
      GOTO ExitPoint
      END

      ---------------------------------------- Reconciliation Format Id-------------------------------------
      ------------------------------------------------------------------------------------------------

      Update AccountsTempTable
      Set AccountsTempTable.ReconciliationFormatId  = Define_ReconciliationChildFormats.PKId
      From Define_ReconciliationChildFormats
      Where AccountsTempTable.ReconciliationFormatName = Define_ReconciliationChildFormats.Name

      Select @ErrorVar=@@error, @RowsUpdated=@@rowcount
      IF (@ErrorVar<>0)
      BEGIN
      Set @IsError=1
      Set @Error_Code = @ErrorVar
      Set @Error_QueryCode = 'Update AccountsTempTable Set AccountsTempTable.ReconciliationFormatId  = Define_ReconciliationChildFormats.PKId	From Define_ReconciliationChildFormats Where AccountsTempTable.ReconciliationFormatName = Define_ReconciliationChildFormats.Name'
      GOTO ExitPoint
      END


      ---------------------------------------- Update AccountPKId-------------------------------------
      ------------------------------------------------------------------------------------------------
      Update AccountsTempTable
      SET AccountsTempTable.AccountPKID = A.PKID
      FROM
      AccountsTempTable T
      INNER JOIN AccountSegments S ON IsNULL(T.AccountSegment1,'^')=IsNULL(S.AccountSegment1,'^')
      AND IsNULL(T.AccountSegment2,'^')=IsNULL(S.AccountSegment2,'^')
      AND IsNULL(T.AccountSegment3,'^')=IsNULL(S.AccountSegment3,'^')
      AND IsNULL(T.AccountSegment4,'^')=IsNULL(S.AccountSegment4,'^')
      AND IsNULL(T.AccountSegment5,'^')=IsNULL(S.AccountSegment5,'^')
      AND IsNULL(T.AccountSegment6,'^')=IsNULL(S.AccountSegment6,'^')
      AND IsNULL(T.AccountSegment7,'^')=IsNULL(S.AccountSegment7,'^')
      AND IsNULL(T.AccountSegment8,'^')=IsNULL(S.AccountSegment8,'^')
      AND IsNULL(T.AccountSegment9,'^')=IsNULL(S.AccountSegment9,'^')
      AND IsNULL(T.AccountSegment10,'^')=IsNULL(S.AccountSegment10,'^')
      INNER JOIN Accounts A ON S.AccountID=A.PKID
      select @ErrorVar=@@error
      IF (@ErrorVar<>0)
      BEGIN
      set @IsError=1
      set @Error_Code = @ErrorVar
      set @Error_TTPKID = 0
      set @Error_QueryCode = 'Updating AccountPKId of AccountsTempTable '
      GOTO ExitPoint
      END
Print ' Starting update of Accounts data though nothing was put in account table yet'
      ---------------------------------------- Update Account Fields using the AccountPKId from the TempTable-------------------------------------
      ------------------------------------------------------------------------------------------------
      Update Accounts
      Set
      Accounts.AccountName = AccountsTempTable.AccountName,
      --Accounts.DateActivated = AccountsTempTable.DateActivated,
      Accounts.[Description] = AccountsTempTable.[Description],
      Accounts.LocationId = AccountsTempTable.LocationId,
      Accounts.AccountTypeId = AccountsTempTable.AccountTypeId,
      Accounts.QARiskRatingId = AccountsTempTable.QARiskRatingId,
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
      Accounts.ReconciliationScheduleId = AccountsTempTable.ReconciliationScheduleId,
      Accounts.ReviewScheduleId = AccountsTempTable.ReviewScheduleId,
      Accounts.RequiresApproval = AccountsTempTable.RequiresApproval,
      Accounts.ApprovalScheduleId = AccountsTempTable.ApprovalScheduleId,
      Accounts.ReconcilerId = AccountsTempTable.ReconcilerId,
      Accounts.BUReconcilerId = AccountsTempTable.BUReconcilerId,
      Accounts.ReviewerId = AccountsTempTable.ReviewerId,
      Accounts.BUReviewerId = AccountsTempTable.BUReviewerId,
      Accounts.ApproverId = AccountsTempTable.ApproverId,
      Accounts.BUApproverId = AccountsTempTable.BUApproverId,
      Accounts.ReconciliationFormatId = AccountsTempTable.ReconciliationFormatId,
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
      Accounts.QATestCycleId = AccountsTempTable.QATestCycleId,
      Accounts.Active = IsNull(AccountsTempTable.Active,Accounts.Active),
      Accounts.NoChangeBulkFlg  = IsNull(AccountsTempTable.NoChangeBulkFlg ,0),
      Accounts.CCY1SplitAllowance = AccountsTempTable.CCY1SplitAllowance,
      Accounts.CCY2SplitAllowance = AccountsTempTable.CCY2SplitAllowance,
      Accounts.CCY3SplitAllowance = AccountsTempTable.CCY3SplitAllowance,
      Accounts.CCY1ManualMatchTolerance = AccountsTempTable.CCY1ManualMatchTolerance,
      Accounts.CCY2ManualMatchTolerance = AccountsTempTable.CCY2ManualMatchTolerance,
      Accounts.CCY3ManualMatchTolerance = AccountsTempTable.CCY3ManualMatchTolerance

      From Accounts
      join AccountsTempTable
      on Accounts.PKId = AccountsTempTable.AccountPKId
      and AccountPKId is not null

      Select @ErrorVar=@@error, @TotalUpdated=@@rowcount
      IF (@ErrorVar<>0)
      BEGIN
      set @IsError=1
      set @Error_Code = @ErrorVar
      set @Error_TTPKID = 0
      set @Error_QueryCode = 'Update Account Fields using the AccountPKId from the TempTable '
      GOTO ExitPoint
      END
Print 'UPDATE Account_User_Assignment based on temp table'
      ----------------Update Approval Level 2 in Account_User_Assignment---------------------------------------------
      UPDATE Account_User_Assignment
      SET
      Account_User_Assignment.UserID = ISNULL(AccountsTempTable.Approver2ID,Account_User_Assignment.UserID),
      Account_User_Assignment.BUserID = ISNULL(AccountsTempTable.BUApprover2ID,Account_User_Assignment.BUserID),
      Account_User_Assignment.ScheduleID = ISNULL(AccountsTempTable.Approval2ScheduleId,Account_User_Assignment.ScheduleID)
      FROM Account_User_Assignment
      JOIN AccountsTempTable
      ON Account_User_Assignment.AccountID = AccountsTempTable.AccountPKId AND SignOffLevel = 2 AND AccountsTempTable.AccountPKId IS NOT NULL

      Select @ErrorVar=@@error, @TotalUpdated=@@rowcount
      IF (@ErrorVar<>0)
      BEGIN
      set @IsError=1
      set @Error_Code = @ErrorVar
      set @Error_TTPKID = 0
      set @Error_QueryCode = 'Update Approval Level 2'
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

      Select @ErrorVar=@@error, @TotalUpdated=@@rowcount
      IF (@ErrorVar<>0)
      BEGIN
      set @IsError=1
      set @Error_Code = @ErrorVar
      set @Error_TTPKID = 0
      set @Error_QueryCode = 'Update Approval Level 3'
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

      Select @ErrorVar=@@error, @TotalUpdated=@@rowcount
      IF (@ErrorVar<>0)
      BEGIN
      set @IsError=1
      set @Error_Code = @ErrorVar
      set @Error_TTPKID = 0
      set @Error_QueryCode = 'Update Approval Level 4'
      GOTO ExitPoint
      END

      ---------------------------------------- Insert Accounts from AccountsTempTable  -----------------------------------------
      ------------------------------------------------------------------------------------------------
Print 'Insert Accounts from AccountsTempTable  '
      Declare @ID as int
      Declare @AccountSegment1 as varchar(50)
      Declare @AccountSegment2 as varchar(50)
      Declare @AccountSegment3 as varchar(50)
      Declare @AccountSegment4 as varchar(50)
      Declare @AccountSegment5 as varchar(50)
      Declare @AccountSegment6 as varchar(50)
      Declare @AccountSegment7 as varchar(50)
      Declare @AccountSegment8 as varchar(50)
      Declare @AccountSegment9 as varchar(50)
      Declare @AccountSegment10 as varchar(50)
      Declare @AccountName as varchar(50)
      Declare @Description as varchar(2000)
      Declare @LocationId as varchar(15)
      Declare @AccountTypeId as varchar(15)
      Declare @QARiskRatingId as varchar(15)
      Declare @ReconPolicy as varchar(2000)
      Declare @CCY1Code as char(3)
      --Declare @ReconcileCCY1 bit
      Declare @CCY1HighBalance as money
      Declare @CCY1LowBalance as money
      Declare @CCY2Code as char(3)
      --Declare @ReconcileCCY2 as bit
      Declare @CCY2HighBalance as money
      Declare @CCY2LowBalance as money
      Declare @CCY3Code as char(3)
      --Declare @ReconcileCCY3 as bit
      Declare @CCY3HighBalance as money
      Declare @CCY3LowBalance as money
      Declare @ReconciliationScheduleId as varchar(15)
      Declare @ReviewScheduleId as varchar(15)
      Declare @RequiresApproval as bit
      Declare @ApprovalScheduleId as varchar(15)
      Declare @ReconcilerId as int
      Declare @BUReconcilerId as int
      Declare @ReviewerId as int
      Declare @BUReviewerId as int
      Declare @ApproverId as int
      Declare @BUApproverId as int
      Declare @ReconciliationFormatId as int
      Declare @CCY1GenerateBalance as bit
      Declare @CCY2GenerateBalance as bit
      Declare @CCY3GenerateBalance as bit
      Declare @CCY1DefaultRateType as varchar(15)
      Declare @CCY2DefaultRateType as varchar(15)
      Declare @CCY3DefaultRateType as varchar(15)
      Declare @ExcludeFXConversion as bit
      Declare @OwnerId as varchar(15)
      Declare @ZeroBalanceBulkFlg as bit
      Declare @IsGroup as bit
      Declare @ClearingStandardId as varchar(15)
      Declare @QATestCycleId as varchar(15)
      Declare @Active as bit
      Declare @NoChangeBulkFlg as bit
      Declare @CCY1SplitAllowance as money
      Declare @CCY2SplitAllowance as money
      Declare @CCY3SplitAllowance as money
      Declare @CCY1ManualMatchTolerance as money
      Declare @CCY2ManualMatchTolerance as money
      Declare @CCY3ManualMatchTolerance as money

/**************************************************************/
/*** Cursor start    */
DECLARE @counter int = 0 
print 'DECLARE Accountx CURSOR fast_forward local FOR'
DECLARE Accountx CURSOR fast_forward local FOR
      select AccountSegment1,AccountSegment2 ,AccountSegment3,AccountSegment4,AccountSegment5,AccountSegment6,AccountSegment7
      ,AccountSegment8,AccountSegment9,AccountSegment10,AccountName,[Description],LocationId,AccountTypeId,QARiskRatingId
      ,ReconPolicy,[CCY1Code],cast(CCY1HighBalance as money),cast(CCY2LowBalance as money),[CCY2Code],cast(CCY2HighBalance as money),cast(CCY2LowBalance as money),[CCY3Code],cast(CCY3HighBalance as money)
      ,cast(CCY3LowBalance as money),ReconciliationScheduleId,ReviewScheduleId,RequiresApproval,ApprovalScheduleId,ReconcilerId,BUReconcilerId,ReviewerId,BUReviewerId
      ,ApproverId ,BUApproverId, ReconciliationFormatId,CCY1GenerateBalance,CCY2GenerateBalance,CCY3GenerateBalance,CCY1DefaultRateType,CCY2DefaultRateType,CCY3DefaultRateType,ExcludeFXConversion,OwnerId,ZeroBalanceBulkFlg,IsGroup,ClearingStandardID,QATestCycleId,IsNull(Active,1),IsNull(NoChangeBulkFlg,0)
      ,cast(CCY1SplitAllowance as money),cast(CCY2SplitAllowance as money),cast(CCY3SplitAllowance as money),cast(CCY1ManualMatchTolerance as money),cast(CCY2ManualMatchTolerance as money),cast(CCY3ManualMatchTolerance as money)
      from AccountsTempTable
      where AccountPKId is null


      OPEN Accountx

      FETCH NEXT FROM Accountx
      INTO @AccountSegment1 , @AccountSegment2 , @AccountSegment3 , @AccountSegment4 , @AccountSegment5 , @AccountSegment6 , @AccountSegment7 , @AccountSegment8
      , @AccountSegment9 , @AccountSegment10 ,@AccountName,@Description , @LocationId , @AccountTypeId , @QARiskRatingId , @ReconPolicy
      , @CCY1Code ,@CCY1HighBalance , @CCY1LowBalance , @CCY2Code , @CCY2HighBalance , @CCY2LowBalance ,@CCY3Code, @CCY3HighBalance , @CCY3LowBalance ,
      @ReconciliationScheduleId , @ReviewScheduleId, @RequiresApproval, @ApprovalScheduleId , @ReconcilerId , @BUReconcilerId , @ReviewerId ,@BUReviewerId
      , @ApproverId , @BUApproverId ,@ReconciliationFormatId,@CCY1GenerateBalance,@CCY2GenerateBalance,@CCY3GenerateBalance,@CCY1DefaultRateType,@CCY2DefaultRateType,@CCY3DefaultRateType,@ExcludeFXConversion,@OwnerId,@ZeroBalanceBulkFlg,@IsGroup,@ClearingStandardID,@QATestCycleId,@Active,@NoChangeBulkFlg
      , @CCY1SplitAllowance, @CCY2SplitAllowance, @CCY3SplitAllowance, @CCY1ManualMatchTolerance, @CCY2ManualMatchTolerance, @CCY3ManualMatchTolerance


      WHILE @@FETCH_STATUS = 0
      BEGIN
	set @counter = @counter + 1
      insert into Accounts
		  (AccountName, DateActivated, [Description] , LocationId , AccountTypeId , QARiskRatingId , ReconPolicy
		  , CCY1Code ,ReconcileCCY1 , CCY1HighBalance , CCY1LowBalance , CCY2Code , ReconcileCCY2 ,CCY2HighBalance , CCY2LowBalance ,CCY3Code, ReconcileCCY3 , CCY3HighBalance , CCY3LowBalance ,
		  ReconciliationScheduleId , ReviewScheduleId, RequiresApproval, ApprovalScheduleId , ReconcilerId , BUReconcilerId , ReviewerId ,BUReviewerId
		  , ApproverId , BUApproverId, ReconciliationFormatId,CCY1GenerateBalance,CCY2GenerateBalance,CCY3GenerateBalance,CCY1DefaultRateType,CCY2DefaultRateType,CCY3DefaultRateType,ExcludeFXConversion,OwnerId,ZeroBalanceBulkFlg,IsGroup,ClearingStandardID,QATestCycleId,Active,NoChangeBulkFlg
		  , CCY1SplitAllowance, CCY2SplitAllowance, CCY3SplitAllowance, CCY1ManualMatchTolerance, CCY2ManualMatchTolerance, CCY3ManualMatchTolerance)
		  values(@AccountName,@CurrentDt,@Description , @LocationId , @AccountTypeId , @QARiskRatingId , @ReconPolicy
		  , @CCY1Code ,@CCY1GenerateBalance , @CCY1HighBalance , @CCY1LowBalance , @CCY2Code , @CCY2GenerateBalance ,@CCY2HighBalance , @CCY2LowBalance ,@CCY3Code, @CCY3GenerateBalance , @CCY3HighBalance , @CCY3LowBalance ,
		  @ReconciliationScheduleId , @ReviewScheduleId, @RequiresApproval, @ApprovalScheduleId , @ReconcilerId , @BUReconcilerId , @ReviewerId ,@BUReviewerId
		  , @ApproverId , @BUApproverId, @ReconciliationFormatId,@CCY1GenerateBalance,@CCY2GenerateBalance,@CCY3GenerateBalance,@CCY1DefaultRateType,@CCY2DefaultRateType,@CCY3DefaultRateType,@ExcludeFXConversion,@OwnerId,@ZeroBalanceBulkFlg,@IsGroup,@ClearingStandardID,@QATestCycleId,@Active,@NoChangeBulkFlg
		  , @CCY1SplitAllowance, @CCY2SplitAllowance, @CCY3SplitAllowance, @CCY1ManualMatchTolerance, @CCY2ManualMatchTolerance, @CCY3ManualMatchTolerance)
      Select @Id = @@IDENTITY, @ErrorVar=@@error
      IF (@ErrorVar <>0 )
		  BEGIN
			  Set @IsError=1
			  Set @Error_Code = @ErrorVar
			  Set @Error_QueryCode = 'Inserting records into Account Segments from AccountsTempTable'
			  GOTO ExitPoint
		  END

      Set @TotalInserted = @TotalInserted + 1
print '    In Accountx  @counter = '  + convert(varchar,@counter) + '             PKID = ' + convert(varchar,@ID) ;
      insert into AccountSegments
		  (AccountId, AccountSegment1, AccountSegment2, AccountSegment3, AccountSegment4, AccountSegment5, AccountSegment6, AccountSegment7, AccountSegment8, AccountSegment9, AccountSegment10 )
		  values(@Id, @AccountSegment1 , @AccountSegment2 , @AccountSegment3 , @AccountSegment4 , @AccountSegment5 , @AccountSegment6 , @AccountSegment7 , @AccountSegment8 , @AccountSegment9 , @AccountSegment10)
      Select @ErrorVar=@@error
      IF (@ErrorVar <>0 )
		  BEGIN
			  Set @IsError=1
			  Set @Error_Code = @ErrorVar
			  Set @Error_QueryCode = 'Inserting records into Account Segments from AccountsTempTable'
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
		  , @ApproverId , @BUApproverId ,@ReconciliationFormatId,@CCY1GenerateBalance,@CCY2GenerateBalance,@CCY3GenerateBalance,@CCY1DefaultRateType,@CCY2DefaultRateType,@CCY3DefaultRateType,@ExcludeFXConversion,@OwnerId,@ZeroBalanceBulkFlg,@IsGroup,@ClearingStandardID,@QATestCycleId,@Active,@NoChangeBulkFlg
		  , @CCY1SplitAllowance, @CCY2SplitAllowance, @CCY3SplitAllowance, @CCY1ManualMatchTolerance, @CCY2ManualMatchTolerance, @CCY3ManualMatchTolerance
      END

      ---------------------------------- Update Account PKId in Temp Table --------------------
      -------------------------------------------------------------------------------------------------
 Print '    End of Accountx Cursor;  Updating AccountsTempTable to be the PKID in the Accounts table'
      Update AccountsTempTable
      SET AccountsTempTable.AccountPKID = A.PKID
      FROM
      AccountsTempTable T
      INNER JOIN AccountSegments S ON IsNULL(T.AccountSegment1,'^')=IsNULL(S.AccountSegment1,'^')
      AND IsNULL(T.AccountSegment2,'^')=IsNULL(S.AccountSegment2,'^')
      AND IsNULL(T.AccountSegment3,'^')=IsNULL(S.AccountSegment3,'^')
      AND IsNULL(T.AccountSegment4,'^')=IsNULL(S.AccountSegment4,'^')
      AND IsNULL(T.AccountSegment5,'^')=IsNULL(S.AccountSegment5,'^')
      AND IsNULL(T.AccountSegment6,'^')=IsNULL(S.AccountSegment6,'^')
      AND IsNULL(T.AccountSegment7,'^')=IsNULL(S.AccountSegment7,'^')
      AND IsNULL(T.AccountSegment8,'^')=IsNULL(S.AccountSegment8,'^')
      AND IsNULL(T.AccountSegment9,'^')=IsNULL(S.AccountSegment9,'^')
      AND IsNULL(T.AccountSegment10,'^')=IsNULL(S.AccountSegment10,'^')
      INNER JOIN Accounts A ON S.AccountID=A.PKID

      Select @ErrorVar=@@error, @RowsUpdated=@@rowcount
      IF (@ErrorVar<>0)
      BEGIN
      Set @IsError=1
      Set @Error_Code = @ErrorVar
      Set @Error_QueryCode = 'Error Updating AccountsTempTable, setting AccountId from the AccountSegments table'
      GOTO ExitPoint
      END

      --------------------------------------Exit Points---------------------------------------------
      ----------------------------------------------------------------------------------------------------


ValidationExitPoint:
      if(@Result < 0)
      begin
		  print 'Exiting with error code ' + Convert(varchar,@Result)
		  --INSERT INTO Interfaces_History(InterfaceID, RunDate, Result, TotalRecords, RecordsInserted, RecordsUpdated, Errors, StartTime, EndTime )
		  --values(@InterfaceID, GetDate(), 3, 0, 0, 0,1,@StartTime,GetDate())
		  exec usp_AddToInterfaceHistory @InterfaceHistoryPKId,@InterfaceID,@CurrentDt,3,0,0,0,1,@StartTime,@CurrentDt,null,null
		  if(@Error_QueryCode is not null and @Error_QueryCode != null)
		  RAISERROR (@Error_QueryCode, 16, 1)
		  else
		  RAISERROR ('Validation Error.', 16, 1)
		  return
      end

ExitPoint:
    If (@IsError=1)
		  Begin
			  Print 'would have rolledback'
		  --ROLLBACK TRAN
			  INSERT INTO Interfaces_Error(ErrorDate, TempTablePKID , ErrorCode, ErrorQueryCode, InterfaceID,InterfaceHistoryPKId) VALUES(GetDate(), IsNULL(@Error_TTPKID,0), @Error_Code, @Error_QueryCode, @InterfaceID,@InterfaceHistoryPKId )
			  set @ErrorID= IDENT_CURRENT('Interfaces_Error')
			  --INSERT INTO Interfaces_History(InterfaceID, RunDate, Result, TotalRecords, RecordsInserted, RecordsUpdated, Errors, StartTime, EndTime )
			  --values(@InterfaceID, GetDate(), 3, 0, 0, 0,1,@StartTime,GetDate())
			  exec usp_AddToInterfaceHistory @InterfaceHistoryPKId,@InterfaceID,@CurrentDt,3,0,0,0,1,@StartTime,@CurrentDt,null,null
			  if(@Error_QueryCode is not null and @Error_QueryCode != null)
			  RAISERROR (@Error_QueryCode, 16, 1)
			  else
			  RAISERROR ('Undeffined Error.', 16, 1)
			  return
		  End
	else
		  BEGIN
				Print ' ExitPoint: Commit would have happened here '
	--	  COMMIT TRAN
				SET @ErrorID =0
				SELECT @ErrorID
				--INSERT INTO Interfaces_History(InterfaceID, RunDate, Result, TotalRecords, RecordsInserted, RecordsUpdated, Errors, StartTime, EndTime )
				--values(@InterfaceID, GetDate(), 1, @TotalRecords, @TotalInserted, @TotalUpdated,0, @StartTime, GetDate())
				exec usp_AddToInterfaceHistory @InterfaceHistoryPKId,@InterfaceID,@CurrentDt,1,@TotalRecords, @TotalInserted, @TotalUpdated,0, @StartTime, @CurrentDt,null,null
		   END -- else
  CLOSE Accountx
  DEALLOCATE Accountx

      DECLARE @accID AS int
      DECLARE @app2 AS int
      DECLARE @app3 AS int
      DECLARE @app4 AS int
      DECLARE @buApp2 AS int
      DECLARE @buApp3 AS int
      DECLARE @buApp4 AS int
      DECLARE @appSched2 AS varchar(15)
      DECLARE @appSched3 AS varchar(15)
      DECLARE @appSched4 AS varchar(15)
	print ' In cursor AccountUserAssignment  '
set @counter = 0 
DECLARE AccountUserAssignment CURSOR fast_forward local FOR
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
		  Approval4ScheduleID
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
		  @BuApp4,
		  @appSched2,
		  @appSched3,
		  @appSched4

      WHILE @@FETCH_STATUS = 0
      BEGIN
		set @counter = @counter +1
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
			  @BuApp4,
			  @appSched2,
			  @appSched3,
			  @appSched4
      END  --While Cursor loop
      CLOSE AccountUserAssignment
      DEALLOCATE AccountUserAssignment
  print ' End of cursor AccountUserAssignment and end of procedure  TOOLKIT_Accounts_Interface'    

GO

/****** Object:  StoredProcedure [dbo].[TOOLKIT_AddAppScheduleDates]    Script Date: 2/5/2016 4:00:16 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*************************************************************************
 *  Usage:                                                               *
 *		EXEC TOOLKIT_AddAppScheduleDates ScheduleID, Number, Frequency   *
 *			ScheduleID - The ScheduleID to Update                        *
 *          Number - The Number of Additional Date Sequences to Add      *
 *          Frequency - ('M','Q','Y') Monthly/Quarterly/Yearly           *
 *************************************************************************/		
CREATE PROCEDURE [dbo].[TOOLKIT_AddAppScheduleDates] 
(
	@ScheduleID varchar(20),
	@Iterations int,
	@Frequency varchar(5)
)
AS
	/****************************************
	 *   Frequency Values:                  *
	 *       'M' = Monthly                  *
	 *       'Q' = Quarterly                *
	 *       'Y' = Yearly (Anually)         *
	 ****************************************/
	DECLARE @EffDate DateTime
	DECLARE @DueDate DateTime
	DECLARE @Sequence int
	DECLARE @StartEffDate DateTime
	DECLARE @StartDueDate DateTime
	DECLARE @StartSequence int
	DECLARE @Count int
	/* Bail Out on Bad Data */
	IF ((SELECT COUNT(*) FROM Code_ApprovalScheduleDates WHERE ScheduleID = @ScheduleID) < 1)
	BEGIN
		PRINT 'ScheduleID Not Found'
		RETURN
	END
	SET @Count = 1
	SELECT @StartEffDate = MAX(EffDate), @StartDueDate = MAX(DueDate), @StartSequence = MAX(Sequence) FROM Code_ApprovalScheduleDates WHERE ScheduleID = @ScheduleID
	SET @EffDate = @StartEffDate
	SET @DueDate = @StartDueDate
	SET @Sequence = @StartSequence
	WHILE (@Count <= @Iterations)
	BEGIN	
		IF (UPPER(@Frequency) = 'M')
		BEGIN	
			SET @EffDate = DATEADD(Month,1,@EffDate)
			SET @DueDate = DATEADD(Month,1,@DueDate)
		END
		ELSE IF (UPPER(@Frequency) = 'Q')
		BEGIN
			SET @EffDate = DATEADD(Month,3,@EffDate)
			SET @DueDate = DATEADD(Month,3,@DueDate)
		END
		ELSE IF (UPPER(@Frequency) = 'Y')
		BEGIN
			SET @EffDate = DATEADD(Year,1,@EffDate)
			SET @DueDate = DATEADD(Year,1,@DueDate)
		END
		ELSE
		BEGIN
			PRINT '**Unrecognized Frequency**'
			RETURN
		END
		SET @Sequence = @Sequence + 1
		INSERT INTO Code_ApprovalScheduleDates (ScheduleID, Sequence, DueDate, EffDate) VALUES (@ScheduleID, @Sequence, @DueDate, @EffDate)
		SET @Count = @Count + 1
	END

GO

/****** Object:  StoredProcedure [dbo].[TOOLKIT_AddRecScheduleDates]    Script Date: 2/5/2016 4:00:16 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*************************************************************************
 *  Usage:                                                               *
 *		EXEC TOOLKIT_AddRecScheduleDates ScheduleID, Number, Frequency   *
 *			ScheduleID - The ScheduleID to Update                        *
 *          Number - The Number of Additional Date Sequences to Add      *
 *          Frequency - ('M','Q','Y') Monthly/Quarterly/Yearly           *
 *************************************************************************/
CREATE PROCEDURE [dbo].[TOOLKIT_AddRecScheduleDates] 
(
	@ScheduleID varchar(20),
	@Iterations int,
	@Frequency varchar(5)
)
AS
	/****************************************
	 *   Frequency Values:                  *
	 *       'M' = Monthly                  *
	 *       'Q' = Quarterly                *
	 *       'Y' = Yearly (Anually)         *
	 ****************************************/
	DECLARE @EffDate DateTime
	DECLARE @DueDate DateTime
	DECLARE @Sequence int
	DECLARE @StartEffDate DateTime
	DECLARE @StartDueDate DateTime
	DECLARE @StartSequence int
	DECLARE @Count int
	/* Bail Out on Bad Data */
	IF ((SELECT COUNT(*) FROM Code_ReconciliationScheduleDates WHERE ScheduleID = @ScheduleID) < 1)
	BEGIN
		PRINT 'ScheduleID Not Found'
		RETURN
	END
	SET @Count = 1
	SELECT @StartEffDate = MAX(EffDate), @StartDueDate = MAX(DueDate), @StartSequence = MAX(Sequence) FROM Code_ReconciliationScheduleDates WHERE ScheduleID = @ScheduleID
	SET @EffDate = @StartEffDate
	SET @DueDate = @StartDueDate
	SET @Sequence = @StartSequence
	WHILE (@Count <= @Iterations)
	BEGIN
		IF (UPPER(@Frequency) = 'M')
		BEGIN	
			SET @EffDate = DATEADD(Month,1,@EffDate)
			SET @DueDate = DATEADD(Month,1,@DueDate)
		END
		ELSE IF (UPPER(@Frequency) = 'Q')
		BEGIN
			SET @EffDate = DATEADD(Month,3,@EffDate)
			SET @DueDate = DATEADD(Month,3,@DueDate)
		END
		ELSE IF (UPPER(@Frequency) = 'Y')
		BEGIN
			SET @EffDate = DATEADD(Year,1,@EffDate)
			SET @DueDate = DATEADD(Year,1,@DueDate)
		END
		ELSE
		BEGIN
			PRINT '**Unrecognized Frequency**'
			RETURN
		END
		SET @Sequence = @Sequence + 1
		INSERT INTO Code_ReconciliationScheduleDates (ScheduleID, Sequence, DueDate, EffDate) VALUES (@ScheduleID, @Sequence, @DueDate, @EffDate)
		SET @Count = @Count + 1
	END

GO

/****** Object:  StoredProcedure [dbo].[TOOLKIT_AddRevScheduleDates]    Script Date: 2/5/2016 4:00:16 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*************************************************************************
 *  Usage:                                                               *
 *		EXEC TOOLKIT_AddRevScheduleDates ScheduleID, Number, Frequency   *
 *			ScheduleID - The ScheduleID to Update                        *
 *          Number - The Number of Additional Date Sequences to Add      *
 *          Frequency - ('M','Q','Y') Monthly/Quarterly/Yearly           *
 *************************************************************************/	
CREATE PROCEDURE [dbo].[TOOLKIT_AddRevScheduleDates] 
(
	@ScheduleID varchar(20),
	@Iterations int,
	@Frequency varchar(5)
)
AS
	/****************************************
	 *   Frequency Values:                  *
	 *       'M' = Monthly                  *
	 *       'Q' = Quarterly                *
	 *       'Y' = Yearly (Anually)         *
	 ****************************************/
	DECLARE @EffDate DateTime
	DECLARE @DueDate DateTime
	DECLARE @Sequence int
	DECLARE @StartEffDate DateTime
	DECLARE @StartDueDate DateTime
	DECLARE @StartSequence int
	DECLARE @Count int
	/* Bail Out on Bad Data */
	IF ((SELECT COUNT(*) FROM Code_ReviewScheduleDates WHERE ScheduleID = @ScheduleID) < 1)
	BEGIN
		PRINT 'ScheduleID Not Found'
		RETURN
	END
	SET @Count = 1
	SELECT @StartEffDate = MAX(EffDate), @StartDueDate = MAX(DueDate), @StartSequence = MAX(Sequence) FROM Code_ReviewScheduleDates WHERE ScheduleID = @ScheduleID
	SET @EffDate = @StartEffDate
	SET @DueDate = @StartDueDate
	SET @Sequence = @StartSequence
	WHILE (@Count <= @Iterations)
	BEGIN	
		IF (UPPER(@Frequency) = 'M')
		BEGIN	
			SET @EffDate = DATEADD(Month,1,@EffDate)
			SET @DueDate = DATEADD(Month,1,@DueDate)
		END
		ELSE IF (UPPER(@Frequency) = 'Q')
		BEGIN
			SET @EffDate = DATEADD(Month,3,@EffDate)
			SET @DueDate = DATEADD(Month,3,@DueDate)
		END
		ELSE IF (UPPER(@Frequency) = 'Y')
		BEGIN
			SET @EffDate = DATEADD(Year,1,@EffDate)
			SET @DueDate = DATEADD(Year,1,@DueDate)
		END
		ELSE
		BEGIN
			PRINT '**Unrecognized Frequency**'
			RETURN
		END
		SET @Sequence = @Sequence + 1
		INSERT INTO Code_ReviewScheduleDates (ScheduleID, Sequence, DueDate, EffDate) VALUES (@ScheduleID, @Sequence, @DueDate, @EffDate)
		SET @Count = @Count + 1
	END

GO

/****** Object:  StoredProcedure [dbo].[TOOLKIT_AssignGroups]    Script Date: 2/5/2016 4:00:16 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*****************************************************************************************
 *  TOOLKIT_AssignGroups procedure:                                                      *
 *      @ChildAccountPrefix - Child AccountSegment Prefix                                *
 *      @GroupAccount - Group AccountSegment                                             *
 *  PURPOSE: Assigns all accounts with the child prefix to the indicated group segment.  *
 *****************************************************************************************/

CREATE PROCEDURE [dbo].[TOOLKIT_AssignGroups]
(
	@ChildAccountPrefix varchar(max), @GroupAccount varchar(max)
)
AS
	DECLARE @GroupID int
	DECLARE @Now DATETIME
	SET @Now = GETDATE()
	
	IF ((SELECT COUNT(AccountID) FROM AccountSegments WHERE AccountSegment1 = @GroupAccount) = 1)
	BEGIN
		SELECT @GroupID = AccountID FROM AccountSegments WHERE AccountSegment1 = @GroupAccount
	END
	ELSE
	BEGIN
		PRINT 'Invalid Group ' + @GroupAccount
		RETURN
	END
	
	INSERT INTO Account_Grouping
	SELECT
		child.PKId AS AccountId,
		@GroupID AS GroupId,
		@Now AS DtAdded,
		NULL AS DtRemoved,
		1 AS ActiveFlg
	FROM Accounts child
	LEFT OUTER JOIN AccountSegments childSeg ON child.PKId = childSeg.AccountId
	WHERE childSeg.AccountSegment1 like @ChildAccountPrefix + '%'
	

GO

/****** Object:  StoredProcedure [dbo].[TOOLKIT_BuildBalanceHistory]    Script Date: 2/5/2016 4:00:16 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*****************************************************************************************************
 *  TOOLKIT_BuildBalanceHistory procedure:                                                           *
 *      @StartEffectiveDate - Effective Date to Start Balance Run                                    *
 *      @StopEffectiveDate - Effective Date to Stop Balance Run                                      *
 *      @ZeroBalance - 0 for Random Balances, 1 for Zero Balances                                    *
 *  PURPOSE: Automatically creates balances for the given date range.                                *
 *****************************************************************************************************/

CREATE Procedure [dbo].[TOOLKIT_BuildBalanceHistory]  
(
	@StartEffectiveDate DateTime, @StopEffectiveDate DateTime, @ZeroBalance bit
) 
AS
	DECLARE @DateCounter AS DateTime
	SET @DateCounter = @StartEffectiveDate
	WHILE (@DateCounter <= @StopEffectiveDate)
	BEGIN
		PRINT '>> Inserting Balances For ' + ISNULL(CONVERT(varchar(max),@DateCounter),'NULL')
		EXEC TOOLKIT_GenerateBalances @DateCounter,@ZeroBalance,1
		SELECT @DateCounter = MIN(EffectiveDate) FROM EffectiveDates WHERE EffectiveDate > @DateCounter
	END

GO

/****** Object:  StoredProcedure [dbo].[TOOLKIT_BuildGroups]    Script Date: 2/5/2016 4:00:16 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


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
	@NumberOfGroups int, @ChildrenPerGroup int
)
AS
	DECLARE @GrpCount int
	DECLARE @GroupSeg varchar(max)
	DECLARE @ChildSeg varchar(max)
	SET @GrpCount = 1
	SET @GroupSeg = CONVERT(varchar(max),@ChildrenPerGroup) + 'Group'
	PRINT '>> Creating ' + CONVERT(varchar(max),@NumberOfGroups) + ' Group Accounts.'
	EXEC TOOLKIT_BuildTestAccountsWithPrefix @GroupSeg,@NumberOfGroups,1
	WHILE (@GrpCount <= @NumberOfGroups)
	BEGIN
		SET @GroupSeg = CONVERT(varchar(max),@ChildrenPerGroup) + 'Group' + CONVERT(varchar(max),@GrpCount)
		SET @ChildSeg = @GroupSeg + 'Child'
		PRINT '>> Creating ' + CONVERT(varchar(max),@ChildrenPerGroup) + ' Child Accounts.'
		EXEC TOOLKIT_BuildTestAccountsWithPrefix @ChildSeg,@ChildrenPerGroup,0
		PRINT '>> Assigning ' + CONVERT(varchar(max),@ChildrenPerGroup) + ' Child Accounts.'
		EXEC TOOLKIT_AssignGroups @ChildSeg,@GroupSeg
		SET @GrpCount = @GrpCount + 1
	END

GO

/****** Object:  StoredProcedure [dbo].[TOOLKIT_BuildHistory]    Script Date: 2/5/2016 4:00:16 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*****************************************************************************************************
 *  TOOLKIT_BuildHistory procedure:                                                                  *
 *      @StartEffectiveDate - Effective Date to Start Run                                            *
 *      @StopEffectiveDate - Effective Date to Stop Run                                              *
 *  PURPOSE: Automatically reconciles all accounts ready for the given date range.                   *
 *****************************************************************************************************/

CREATE Procedure [dbo].[TOOLKIT_BuildHistory]  
(
	@StartEffectiveDate DateTime, @StopEffectiveDate DateTime
) 
AS
	DECLARE @DateCounter AS DateTime
	SET @DateCounter = @StartEffectiveDate
	WHILE (@DateCounter <= @StopEffectiveDate)
	BEGIN
		PRINT '>> Processing Reconciliations For ' + ISNULL(CONVERT(varchar(max),@DateCounter),'NULL')
		EXEC TOOLKIT_ReconcileAll @DateCounter
		SELECT @DateCounter = MIN(EffectiveDate) FROM EffectiveDates WHERE EffectiveDate > @DateCounter
	END

GO

/****** Object:  StoredProcedure [dbo].[TOOLKIT_BuildTestAccounts]    Script Date: 2/5/2016 4:00:16 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[TOOLKIT_BuildTestAccounts]
(
	@Amount int, @autoInsert bit
)
AS
		DECLARE @Counter AS int
		DECLARE @AccountSegment1 AS varchar(50)
		DECLARE @AccountSegment2 AS varchar(50)
		DECLARE @AccountSegment3 AS varchar(50)
		DECLARE @AccountSegment4 AS varchar(50)
		DECLARE @AccountSegment5 AS varchar(50)
		DECLARE @AccountSegment6 AS varchar(50)
		DECLARE @AccountSegment7 AS varchar(50)
		DECLARE @AccountSegment8 AS varchar(50)
		DECLARE @AccountSegment9 AS varchar(50)
		DECLARE @AccountSegment10 AS varchar(50)
		DECLARE @AccountName AS varchar(200)
		DECLARE @Description AS varchar(max)
		DECLARE @IsGroup AS bit
		DECLARE @LocationId AS varchar(15)
		DECLARE @AccountTypeID AS varchar(15)
		DECLARE @OwnerId AS varchar(15)
		DECLARE @QARiskRatingID AS varchar(15)
		DECLARE @QATestCycleID AS varchar(15)
		DECLARE @ClearingStandardID AS varchar(15)
		DECLARE @ZeroBalanceBulkFlg AS bit
		DECLARE @ReconPolicy AS varchar(max)
		DECLARE @CCY1Code AS char(3)
		DECLARE @CCY1GenerateBalance AS bit
		DECLARE @CCY1HighBalance AS money
		DECLARE @CCY1LowBalance AS money
		DECLARE @CCY2Code AS char(3)
		DECLARE @CCY2GenerateBalance AS bit
		DECLARE @CCY2HighBalance AS money
		DECLARE @CCY2LowBalance AS money
		DECLARE @CCY3Code AS char(3)
		DECLARE @CCY3GenerateBalance AS bit
		DECLARE @CCY3HighBalance AS money
		DECLARE @CCY3LowBalance AS money
		DECLARE @ReconciliationScheduleID AS varchar(15)
		DECLARE @ReviewScheduleID AS varchar(15)
		DECLARE @RequiresApproval AS bit
		DECLARE @ApprovalScheduleId AS varchar(15)
		DECLARE @Approval2ScheduleId AS varchar(15)
		DECLARE @Approval3ScheduleId AS varchar(15)
		DECLARE @Approval4ScheduleId AS varchar(15)
		DECLARE @ReconcilerUserName AS varchar(50)
		DECLARE @ReviewerUserName AS varchar(50)
		DECLARE @ApproverUserName AS varchar(50)
		DECLARE @Approver2UserName AS varchar(50)
		DECLARE @Approver3UserName AS varchar(50)
		DECLARE @Approver4UserName AS varchar(50)
		DECLARE @BUReconcilerUserName AS varchar(50)
		DECLARE @BUReviewerUserName AS varchar(50)
		DECLARE @BUApproverUserName AS varchar(50)
		DECLARE @BUApprover2UserName AS varchar(50)
		DECLARE @BUApprover3UserName AS varchar(50)
		DECLARE @BUApprover4UserName AS varchar(50)
		DECLARE @ReconciliationFormatName AS varchar(50)
		DECLARE @ExcludeFXConversion AS bit
		DECLARE @Active AS bit
		DECLARE @CCY1DefaultRateType AS varchar(15)
		DECLARE @CCY2DefaultRateType AS varchar(15)
		DECLARE @CCY3DefaultRateType AS varchar(15)
		DECLARE @NoChangeBulkFlg AS bit
		DECLARE @CCY1SplitAllowance AS money
		DECLARE @CCY2SplitAllowance AS money
		DECLARE @CCY3SplitAllowance AS money
		DECLARE @CCY1ManualMatchTolerance AS money
		DECLARE @CCY2ManualMatchTolerance AS money
		DECLARE @CCY3ManualMatchTolerance AS money
	IF (@autoInsert = 0)
	BEGIN
 		CREATE TABLE #Accounts
		(
			AccountSegment1 varchar(50),
			AccountSegment2 varchar(50),
			AccountSegment3 varchar(50),
			AccountSegment4 varchar(50),
			AccountSegment5 varchar(50),
			AccountSegment6 varchar(50),
			AccountSegment7 varchar(50),
			AccountSegment8 varchar(50),
			AccountSegment9 varchar(50),
			AccountSegment10 varchar(50),
			AccountName varchar(200),
			[Description] text,
			IsGroup bit,
			LocationId varchar(15),
			AccountTypeID varchar(15),
			OwnerId varchar(15),
			QARiskRatingID varchar(15),
			QATestCycleID varchar(15),
			ClearingStandardID varchar(15),
			ZeroBalanceBulkFlg bit,
			ReconPolicy text,
			CCY1Code char(3),
			CCY1GenerateBalance bit,
			CCY1HighBalance money,
			CCY1LowBalance money,
			CCY2Code char(3),
			CCY2GenerateBalance bit,
			CCY2HighBalance money,
			CCY2LowBalance money,
			CCY3Code char(3),
			CCY3GenerateBalance bit,
			CCY3HighBalance money,
			CCY3LowBalance money,
			ReconciliationScheduleID varchar(15),
			ReviewScheduleID varchar(15),
			RequiresApproval bit,
			ApprovalScheduleId varchar(15),
			Approval2ScheduleId varchar(15),
			Approval3ScheduleId varchar(15),
			Approval4ScheduleId varchar(15),
			ReconcilerUserName varchar(50),
			ReviewerUserName varchar(50),
			ApproverUserName varchar(50),
			Approver2UserName varchar(50),
			Approver3UserName varchar(50),
			Approver4UserName varchar(50),
			BUReconcilerUserName varchar(50),
			BUReviewerUserName varchar(50),
			BUApproverUserName varchar(50),
			BUApprover2UserName varchar(50),
			BUApprover3UserName varchar(50),
			BUApprover4UserName varchar(50),
			ReconciliationFormatName varchar(50),
			ExcludeFXConversion bit,
			Active bit,
			CCY1DefaultRateType varchar(15),
			CCY2DefaultRateType varchar(15),
			CCY3DefaultRateType varchar(15),
			NoChangeBulkFlg bit,
			CCY1SplitAllowance money,
			CCY2SplitAllowance money,
			CCY3SplitAllowance money,
			CCY1ManualMatchTolerance money,
			CCY2ManualMatchTolerance money,
			CCY3ManualMatchTolerance money				
		)
		
		SET @Counter = 1
			
		WHILE (@Counter <= @Amount)
		BEGIN
			SET @AccountSegment1 = 'TEST' + CAST(@Counter as varchar)
			SET @AccountSegment2 = 'TEST' + CAST(@Counter as varchar)
			SET @AccountSegment3 = 'TEST' + CAST(@Counter as varchar)
			SET @AccountSegment4 = 'TEST' + CAST(@Counter as varchar)
			SET @AccountSegment5 = 'TEST' + CAST(@Counter as varchar)
			SET @AccountSegment6 = 'TEST' + CAST(@Counter as varchar)
			SET @AccountSegment7 = 'TEST' + CAST(@Counter as varchar)
			SET @AccountSegment8 = 'TEST' + CAST(@Counter as varchar)
			SET @AccountSegment9 = 'TEST' + CAST(@Counter as varchar)
			SET @AccountSegment10 = 'TEST' + CAST(@Counter as varchar)
			SET @AccountName = 'Test Account ' + CAST(@Counter as varchar)
			SET @Description = 'This is the description for Test Account ' + CAST(@Counter as varchar)
			SET @IsGroup = 0
			SET @LocationId = (SELECT TOP 1 Code FROM Code_Locations ORDER BY NEWID())
			SET @AccountTypeID = (SELECT TOP 1 Code FROM Code_AccountTypes ORDER BY NEWID())
			SET @OwnerId = (SELECT TOP 1 Code FROM Code_Owners ORDER BY NEWID())
			SET @QARiskRatingID = (SELECT TOP 1 Code FROM Code_QARiskRatings ORDER BY NEWID())
			SET @QATestCycleID = (SELECT TOP 1 Code FROM Code_QATestCycles ORDER BY NEWID())
			SET @ClearingStandardID = (SELECT TOP 1 Code FROM Code_ClearingStandards ORDER BY NEWID())
			SET @ZeroBalanceBulkFlg = 0
			SET @ReconPolicy = 'This is the reconciliation policy for Test Account ' + CAST(@Counter as varchar)
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
			SET @ReconcilerUserName = (SELECT TOP 1 UserName FROM Users WHERE Role_Reconciler=1 AND Active = 1 ORDER BY NEWID())
			SET @ReviewerUserName = (SELECT TOP 1 UserName FROM Users WHERE Role_Reviewer=1 AND Active = 1 AND UserName <> @ReconcilerUserName ORDER BY NEWID())
			SET @ApproverUserName = (SELECT TOP 1 UserName FROM Users WHERE Role_Approver=1 AND Active = 1 AND (UserName <> @ReconcilerUserName AND UserName <> @ReviewerUserName) ORDER BY NEWID())
			SET @Approver2UserName = (SELECT TOP 1 UserName FROM Users WHERE Role_Approver=1 AND Active = 1 AND (UserName <> @ReconcilerUserName AND UserName <> @ReviewerUserName AND UserName <> @ApproverUserName) ORDER BY NEWID())
			SET @Approver3UserName = (SELECT TOP 1 UserName FROM Users WHERE Role_Approver=1 AND Active = 1 AND (UserName <> @ReconcilerUserName AND UserName <> @ReviewerUserName AND UserName <> @ApproverUserName AND UserName <> @Approver2UserName) ORDER BY NEWID())
			SET @Approver4UserName = (SELECT TOP 1 UserName FROM Users WHERE Role_Approver=1 AND Active = 1 AND (UserName <> @ReconcilerUserName AND UserName <> @ReviewerUserName AND UserName <> @ApproverUserName AND UserName <> @Approver2UserName AND UserName <> @Approver3UserName) ORDER BY NEWID())
			SET @BUReconcilerUserName = NULL
			SET @BUReviewerUserName = NULL
			SET @BUApproverUserName = NULL
			SET @BUApprover2UserName = NULL
			SET @BUApprover3UserName = NULL
			SET @BUApprover4UserName = NULL
			SET @ReconciliationFormatName = (SELECT TOP 1 Name FROM Define_ReconciliationChildFormats ORDER BY NEWID())
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


			INSERT INTO #Accounts
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
		SELECT * FROM #Accounts
	END
	ELSE
	BEGIN
	
		IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AccountsTempTable]') AND type in (N'U'))
		DROP TABLE [dbo].[AccountsTempTable]

		CREATE TABLE [dbo].[AccountsTempTable]
			(
			AccountSegment1 varchar(50),
			AccountSegment2 varchar(50),
			AccountSegment3 varchar(50),
			AccountSegment4 varchar(50),
			AccountSegment5 varchar(50),
			AccountSegment6 varchar(50),
			AccountSegment7 varchar(50),
			AccountSegment8 varchar(50),
			AccountSegment9 varchar(50),
			AccountSegment10 varchar(50),
			AccountName varchar(200),
			[Description] text,
			IsGroup bit,
			LocationId varchar(15),
			AccountTypeID varchar(15),
			OwnerId varchar(15),
			QARiskRatingID varchar(15),
			QATestCycleID varchar(15),
			ClearingStandardID varchar(15),
			ZeroBalanceBulkFlg bit,
			ReconPolicy text,
			CCY1Code char(3),
			CCY1GenerateBalance bit,
			CCY1HighBalance money,
			CCY1LowBalance money,
			CCY2Code char(3),
			CCY2GenerateBalance bit,
			CCY2HighBalance money,
			CCY2LowBalance money,
			CCY3Code char(3),
			CCY3GenerateBalance bit,
			CCY3HighBalance money,
			CCY3LowBalance money,
			ReconciliationScheduleID varchar(15),
			ReviewScheduleID varchar(15),
			RequiresApproval bit,
			ApprovalScheduleId varchar(15),
			Approval2ScheduleId varchar(15),
			Approval3ScheduleId varchar(15),
			Approval4ScheduleId varchar(15),
			ReconcilerUserName varchar(50),
			ReviewerUserName varchar(50),
			ApproverUserName varchar(50),
			Approver2UserName varchar(50),
			Approver3UserName varchar(50),
			Approver4UserName varchar(50),
			BUReconcilerUserName varchar(50),
			BUReviewerUserName varchar(50),
			BUApproverUserName varchar(50),
			BUApprover2UserName varchar(50),
			BUApprover3UserName varchar(50),
			BUApprover4UserName varchar(50),
			ReconciliationFormatName varchar(50),
			ExcludeFXConversion bit,
			Active bit,
			CCY1DefaultRateType varchar(15),
			CCY2DefaultRateType varchar(15),
			CCY3DefaultRateType varchar(15),
			NoChangeBulkFlg bit,
			CCY1SplitAllowance money,
			CCY2SplitAllowance money,
			CCY3SplitAllowance money,
			CCY1ManualMatchTolerance money,
			CCY2ManualMatchTolerance money,
			CCY3ManualMatchTolerance money,
			AccountPKId int,
			BUReconcilerId int,
			BUReviewerId int,
			ApproverId int,
			BUApproverId int,
			Approver2ID int,
			BUApprover2ID int,
			Approver3ID int,
			BUApprover3ID int,
			Approver4ID int,
			BUApprover4ID int,
			ReconciliationFormatId int,
			ReconcilerId int,
			ReviewerId int					
		)
		
		SET @Counter = 1
			
		WHILE (@Counter <= @Amount)
		BEGIN
			PRINT 'Creating Account ' + CAST(@Counter as varchar) + ' of ' + CAST(@Amount as varchar)
			SET @AccountSegment1 = 'TEST' + CAST(@Counter as varchar)
			SET @AccountSegment2 = 'TEST' + CAST(@Counter as varchar)
			SET @AccountSegment3 = 'TEST' + CAST(@Counter as varchar)
			SET @AccountSegment4 = 'TEST' + CAST(@Counter as varchar)
			SET @AccountSegment5 = 'TEST' + CAST(@Counter as varchar)
			SET @AccountSegment6 = 'TEST' + CAST(@Counter as varchar)
			SET @AccountSegment7 = 'TEST' + CAST(@Counter as varchar)
			SET @AccountSegment8 = 'TEST' + CAST(@Counter as varchar)
			SET @AccountSegment9 = 'TEST' + CAST(@Counter as varchar)
			SET @AccountSegment10 = 'TEST' + CAST(@Counter as varchar)
			SET @AccountName = 'Test Account ' + CAST(@Counter as varchar)
			SET @Description = 'This is the description for Test Account ' + CAST(@Counter as varchar)
			SET @IsGroup = 0
			SET @LocationId = (SELECT TOP 1 Code FROM Code_Locations ORDER BY NEWID())
			SET @AccountTypeID = (SELECT TOP 1 Code FROM Code_AccountTypes ORDER BY NEWID())
			SET @OwnerId = (SELECT TOP 1 Code FROM Code_Owners ORDER BY NEWID())
			SET @QARiskRatingID = (SELECT TOP 1 Code FROM Code_QARiskRatings ORDER BY NEWID())
			SET @QATestCycleID = (SELECT TOP 1 Code FROM Code_QATestCycles ORDER BY NEWID())
			SET @ClearingStandardID = (SELECT TOP 1 Code FROM Code_ClearingStandards ORDER BY NEWID())
			SET @ZeroBalanceBulkFlg = 0
			SET @ReconPolicy = 'This is the reconciliation policy for Test Account ' + CAST(@Counter as varchar)
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
			SET @ReconcilerUserName = (SELECT TOP 1 UserName FROM Users WHERE Role_Reconciler=1 AND Active = 1 ORDER BY NEWID())
			SET @ReviewerUserName = (SELECT TOP 1 UserName FROM Users WHERE Role_Reviewer=1 AND Active = 1 AND UserName <> @ReconcilerUserName ORDER BY NEWID())
			SET @ApproverUserName = (SELECT TOP 1 UserName FROM Users WHERE Role_Approver=1 AND Active = 1 AND (UserName <> @ReconcilerUserName AND UserName <> @ReviewerUserName) ORDER BY NEWID())
			SET @Approver2UserName = (SELECT TOP 1 UserName FROM Users WHERE Role_Approver=1 AND Active = 1 AND (UserName <> @ReconcilerUserName AND UserName <> @ReviewerUserName AND UserName <> @ApproverUserName) ORDER BY NEWID())
			SET @Approver3UserName = (SELECT TOP 1 UserName FROM Users WHERE Role_Approver=1 AND Active = 1 AND (UserName <> @ReconcilerUserName AND UserName <> @ReviewerUserName AND UserName <> @ApproverUserName AND UserName <> @Approver2UserName) ORDER BY NEWID())
			SET @Approver4UserName = (SELECT TOP 1 UserName FROM Users WHERE Role_Approver=1 AND Active = 1 AND (UserName <> @ReconcilerUserName AND UserName <> @ReviewerUserName AND UserName <> @ApproverUserName AND UserName <> @Approver2UserName AND UserName <> @Approver3UserName) ORDER BY NEWID())
			SET @BUReconcilerUserName = NULL
			SET @BUReviewerUserName = NULL
			SET @BUApproverUserName = NULL
			SET @BUApprover2UserName = NULL
			SET @BUApprover3UserName = NULL
			SET @BUApprover4UserName = NULL
			SET @ReconciliationFormatName = (SELECT TOP 1 Name FROM Define_ReconciliationChildFormats ORDER BY NEWID())
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
		DECLARE @HistID int
		DECLARE @Now DateTime
		SET @Now = getdate()
		SELECT @HistID = MAX(PKID) + 1 FROM Interfaces_History
		EXEC TOOLKIT_Accounts_Interface 1,@Now,@HistID
	END
		

GO

/****** Object:  StoredProcedure [dbo].[TOOLKIT_BuildTestAccountsWithPrefix]    Script Date: 2/5/2016 4:00:16 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[TOOLKIT_BuildTestAccountsWithPrefix]
(
	@AccountPrefix varchar(max), @Amount int, @Group bit
)
AS
		DECLARE @Counter AS int
		DECLARE @AccountSegment1 AS varchar(50)
		DECLARE @AccountSegment2 AS varchar(50)
		DECLARE @AccountSegment3 AS varchar(50)
		DECLARE @AccountSegment4 AS varchar(50)
		DECLARE @AccountSegment5 AS varchar(50)
		DECLARE @AccountSegment6 AS varchar(50)
		DECLARE @AccountSegment7 AS varchar(50)
		DECLARE @AccountSegment8 AS varchar(50)
		DECLARE @AccountSegment9 AS varchar(50)
		DECLARE @AccountSegment10 AS varchar(50)
		DECLARE @AccountName AS varchar(200)
		DECLARE @Description AS varchar(max)
		DECLARE @IsGroup AS bit
		DECLARE @LocationId AS varchar(15)
		DECLARE @AccountTypeID AS varchar(15)
		DECLARE @OwnerId AS varchar(15)
		DECLARE @QARiskRatingID AS varchar(15)
		DECLARE @QATestCycleID AS varchar(15)
		DECLARE @ClearingStandardID AS varchar(15)
		DECLARE @ZeroBalanceBulkFlg AS bit
		DECLARE @ReconPolicy AS varchar(max)
		DECLARE @CCY1Code AS char(3)
		DECLARE @CCY1GenerateBalance AS bit
		DECLARE @CCY1HighBalance AS money
		DECLARE @CCY1LowBalance AS money
		DECLARE @CCY2Code AS char(3)
		DECLARE @CCY2GenerateBalance AS bit
		DECLARE @CCY2HighBalance AS money
		DECLARE @CCY2LowBalance AS money
		DECLARE @CCY3Code AS char(3)
		DECLARE @CCY3GenerateBalance AS bit
		DECLARE @CCY3HighBalance AS money
		DECLARE @CCY3LowBalance AS money
		DECLARE @ReconciliationScheduleID AS varchar(15)
		DECLARE @ReviewScheduleID AS varchar(15)
		DECLARE @RequiresApproval AS bit
		DECLARE @ApprovalScheduleId AS varchar(15)
		DECLARE @Approval2ScheduleId AS varchar(15)
		DECLARE @Approval3ScheduleId AS varchar(15)
		DECLARE @Approval4ScheduleId AS varchar(15)
		DECLARE @ReconcilerUserName AS varchar(50)
		DECLARE @ReviewerUserName AS varchar(50)
		DECLARE @ApproverUserName AS varchar(50)
		DECLARE @Approver2UserName AS varchar(50)
		DECLARE @Approver3UserName AS varchar(50)
		DECLARE @Approver4UserName AS varchar(50)
		DECLARE @BUReconcilerUserName AS varchar(50)
		DECLARE @BUReviewerUserName AS varchar(50)
		DECLARE @BUApproverUserName AS varchar(50)
		DECLARE @BUApprover2UserName AS varchar(50)
		DECLARE @BUApprover3UserName AS varchar(50)
		DECLARE @BUApprover4UserName AS varchar(50)
		DECLARE @ReconciliationFormatName AS varchar(50)
		DECLARE @ExcludeFXConversion AS bit
		DECLARE @Active AS bit
		DECLARE @CCY1DefaultRateType AS varchar(15)
		DECLARE @CCY2DefaultRateType AS varchar(15)
		DECLARE @CCY3DefaultRateType AS varchar(15)
		DECLARE @NoChangeBulkFlg AS bit
		DECLARE @CCY1SplitAllowance AS money
		DECLARE @CCY2SplitAllowance AS money
		DECLARE @CCY3SplitAllowance AS money
		DECLARE @CCY1ManualMatchTolerance AS money
		DECLARE @CCY2ManualMatchTolerance AS money
		DECLARE @CCY3ManualMatchTolerance AS money
		
		IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AccountsTempTable]') AND type in (N'U'))
		DROP TABLE [dbo].[AccountsTempTable]

		CREATE TABLE [dbo].[AccountsTempTable]
			(
			AccountSegment1 varchar(50),
			AccountSegment2 varchar(50),
			AccountSegment3 varchar(50),
			AccountSegment4 varchar(50),
			AccountSegment5 varchar(50),
			AccountSegment6 varchar(50),
			AccountSegment7 varchar(50),
			AccountSegment8 varchar(50),
			AccountSegment9 varchar(50),
			AccountSegment10 varchar(50),
			AccountName varchar(200),
			[Description] text,
			IsGroup bit,
			LocationId varchar(15),
			AccountTypeID varchar(15),
			OwnerId varchar(15),
			QARiskRatingID varchar(15),
			QATestCycleID varchar(15),
			ClearingStandardID varchar(15),
			ZeroBalanceBulkFlg bit,
			ReconPolicy text,
			CCY1Code char(3),
			CCY1GenerateBalance bit,
			CCY1HighBalance money,
			CCY1LowBalance money,
			CCY2Code char(3),
			CCY2GenerateBalance bit,
			CCY2HighBalance money,
			CCY2LowBalance money,
			CCY3Code char(3),
			CCY3GenerateBalance bit,
			CCY3HighBalance money,
			CCY3LowBalance money,
			ReconciliationScheduleID varchar(15),
			ReviewScheduleID varchar(15),
			RequiresApproval bit,
			ApprovalScheduleId varchar(15),
			Approval2ScheduleId varchar(15),
			Approval3ScheduleId varchar(15),
			Approval4ScheduleId varchar(15),
			ReconcilerUserName varchar(50),
			ReviewerUserName varchar(50),
			ApproverUserName varchar(50),
			Approver2UserName varchar(50),
			Approver3UserName varchar(50),
			Approver4UserName varchar(50),
			BUReconcilerUserName varchar(50),
			BUReviewerUserName varchar(50),
			BUApproverUserName varchar(50),
			BUApprover2UserName varchar(50),
			BUApprover3UserName varchar(50),
			BUApprover4UserName varchar(50),
			ReconciliationFormatName varchar(50),
			ExcludeFXConversion bit,
			Active bit,
			CCY1DefaultRateType varchar(15),
			CCY2DefaultRateType varchar(15),
			CCY3DefaultRateType varchar(15),
			NoChangeBulkFlg bit,
			CCY1SplitAllowance money,
			CCY2SplitAllowance money,
			CCY3SplitAllowance money,
			CCY1ManualMatchTolerance money,
			CCY2ManualMatchTolerance money,
			CCY3ManualMatchTolerance money,
			AccountPKId int,
			BUReconcilerId int,
			BUReviewerId int,
			ApproverId int,
			BUApproverId int,
			Approver2ID int,
			BUApprover2ID int,
			Approver3ID int,
			BUApprover3ID int,
			Approver4ID int,
			BUApprover4ID int,
			ReconciliationFormatId int,
			ReconcilerId int,
			ReviewerId int					
		)
		
		SET @Counter = 1
			
		WHILE (@Counter <= @Amount)
		BEGIN
			PRINT 'Creating Account ' + CAST(@Counter as varchar) + ' of ' + CAST(@Amount as varchar)
			SET @AccountSegment1 = @AccountPrefix + CAST(@Counter as varchar)
			SET @AccountSegment2 = @AccountPrefix + CAST(@Counter as varchar)
			SET @AccountSegment3 = @AccountPrefix + CAST(@Counter as varchar)
			SET @AccountSegment4 = @AccountPrefix + CAST(@Counter as varchar)
			SET @AccountSegment5 = @AccountPrefix + CAST(@Counter as varchar)
			SET @AccountSegment6 = @AccountPrefix + CAST(@Counter as varchar)
			SET @AccountSegment7 = @AccountPrefix + CAST(@Counter as varchar)
			SET @AccountSegment8 = @AccountPrefix + CAST(@Counter as varchar)
			SET @AccountSegment9 = @AccountPrefix + CAST(@Counter as varchar)
			SET @AccountSegment10 = @AccountPrefix + CAST(@Counter as varchar)
			SET @AccountName = @AccountPrefix + ' Account ' + CAST(@Counter as varchar)
			SET @Description = 'This is the description for ' + @AccountPrefix + ' Account ' + CAST(@Counter as varchar)
			SET @IsGroup = @Group
			SET @LocationId = (SELECT TOP 1 Code FROM Code_Locations ORDER BY NEWID())
			SET @AccountTypeID = (SELECT TOP 1 Code FROM Code_AccountTypes ORDER BY NEWID())
			SET @OwnerId = (SELECT TOP 1 Code FROM Code_Owners ORDER BY NEWID())
			SET @QARiskRatingID = (SELECT TOP 1 Code FROM Code_QARiskRatings ORDER BY NEWID())
			SET @QATestCycleID = (SELECT TOP 1 Code FROM Code_QATestCycles ORDER BY NEWID())
			SET @ClearingStandardID = (SELECT TOP 1 Code FROM Code_ClearingStandards ORDER BY NEWID())
			SET @ZeroBalanceBulkFlg = 0
			SET @ReconPolicy = 'This is the reconciliation policy for ' + @AccountPrefix + ' Account ' + CAST(@Counter as varchar)
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
			SET @ReconcilerUserName = (SELECT TOP 1 UserName FROM Users WHERE Role_Reconciler=1 AND Active = 1 ORDER BY NEWID())
			SET @ReviewerUserName = (SELECT TOP 1 UserName FROM Users WHERE Role_Reviewer=1 AND Active = 1 AND UserName <> @ReconcilerUserName ORDER BY NEWID())
			SET @ApproverUserName = (SELECT TOP 1 UserName FROM Users WHERE Role_Approver=1 AND Active = 1 AND (UserName <> @ReconcilerUserName AND UserName <> @ReviewerUserName) ORDER BY NEWID())
			SET @Approver2UserName = (SELECT TOP 1 UserName FROM Users WHERE Role_Approver=1 AND Active = 1 AND (UserName <> @ReconcilerUserName AND UserName <> @ReviewerUserName AND UserName <> @ApproverUserName) ORDER BY NEWID())
			SET @Approver3UserName = (SELECT TOP 1 UserName FROM Users WHERE Role_Approver=1 AND Active = 1 AND (UserName <> @ReconcilerUserName AND UserName <> @ReviewerUserName AND UserName <> @ApproverUserName AND UserName <> @Approver2UserName) ORDER BY NEWID())
			SET @Approver4UserName = (SELECT TOP 1 UserName FROM Users WHERE Role_Approver=1 AND Active = 1 AND (UserName <> @ReconcilerUserName AND UserName <> @ReviewerUserName AND UserName <> @ApproverUserName AND UserName <> @Approver2UserName AND UserName <> @Approver3UserName) ORDER BY NEWID())
			SET @BUReconcilerUserName = NULL
			SET @BUReviewerUserName = NULL
			SET @BUApproverUserName = NULL
			SET @BUApprover2UserName = NULL
			SET @BUApprover3UserName = NULL
			SET @BUApprover4UserName = NULL
			SET @ReconciliationFormatName = (SELECT TOP 1 Name FROM Define_ReconciliationChildFormats ORDER BY NEWID())
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
		DECLARE @HistID int
		DECLARE @Now DateTime
		SET @Now = getdate()
		SELECT @HistID = MAX(PKID) + 1 FROM Interfaces_History
		EXEC TOOLKIT_Accounts_Interface 1,@Now,@HistID
	

GO

/****** Object:  StoredProcedure [dbo].[TOOLKIT_BuildTestAccountsWithPrefix_Modify]    Script Date: 2/5/2016 4:00:16 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[TOOLKIT_BuildTestAccountsWithPrefix_Modify]
(
	@AccountPrefix varchar(max), @Amount int, @Group bit
)
AS
		DECLARE @Counter AS int
		DECLARE @AccountSegment1 AS varchar(50)
		DECLARE @AccountSegment2 AS varchar(50)
		DECLARE @AccountSegment3 AS varchar(50)
		DECLARE @AccountSegment4 AS varchar(50)
		DECLARE @AccountSegment5 AS varchar(50)
		DECLARE @AccountSegment6 AS varchar(50)
		DECLARE @AccountSegment7 AS varchar(50)
		DECLARE @AccountSegment8 AS varchar(50)
		DECLARE @AccountSegment9 AS varchar(50)
		DECLARE @AccountSegment10 AS varchar(50)
		DECLARE @AccountName AS varchar(200)
		DECLARE @Description AS varchar(max)
		DECLARE @IsGroup AS bit
		DECLARE @LocationId AS varchar(15)
		DECLARE @AccountTypeID AS varchar(15)
		DECLARE @OwnerId AS varchar(15)
		DECLARE @QARiskRatingID AS varchar(15)
		DECLARE @QATestCycleID AS varchar(15)
		DECLARE @ClearingStandardID AS varchar(15)
		DECLARE @ZeroBalanceBulkFlg AS bit
		DECLARE @ReconPolicy AS varchar(max)
		DECLARE @CCY1Code AS char(3)
		DECLARE @CCY1GenerateBalance AS bit
		DECLARE @CCY1HighBalance AS money
		DECLARE @CCY1LowBalance AS money
		DECLARE @CCY2Code AS char(3)
		DECLARE @CCY2GenerateBalance AS bit
		DECLARE @CCY2HighBalance AS money
		DECLARE @CCY2LowBalance AS money
		DECLARE @CCY3Code AS char(3)
		DECLARE @CCY3GenerateBalance AS bit
		DECLARE @CCY3HighBalance AS money
		DECLARE @CCY3LowBalance AS money
		DECLARE @ReconciliationScheduleID AS varchar(15)
		DECLARE @ReviewScheduleID AS varchar(15)
		DECLARE @RequiresApproval AS bit
		DECLARE @ApprovalScheduleId AS varchar(15)
		DECLARE @Approval2ScheduleId AS varchar(15)
		DECLARE @Approval3ScheduleId AS varchar(15)
		DECLARE @Approval4ScheduleId AS varchar(15)
		DECLARE @ReconcilerUserName AS varchar(50)
		DECLARE @ReviewerUserName AS varchar(50)
		DECLARE @ApproverUserName AS varchar(50)
		DECLARE @Approver2UserName AS varchar(50)
		DECLARE @Approver3UserName AS varchar(50)
		DECLARE @Approver4UserName AS varchar(50)
		DECLARE @BUReconcilerUserName AS varchar(50)
		DECLARE @BUReviewerUserName AS varchar(50)
		DECLARE @BUApproverUserName AS varchar(50)
		DECLARE @BUApprover2UserName AS varchar(50)
		DECLARE @BUApprover3UserName AS varchar(50)
		DECLARE @BUApprover4UserName AS varchar(50)
		DECLARE @ReconciliationFormatName AS varchar(50)
		DECLARE @ExcludeFXConversion AS bit
		DECLARE @Active AS bit
		DECLARE @CCY1DefaultRateType AS varchar(15)
		DECLARE @CCY2DefaultRateType AS varchar(15)
		DECLARE @CCY3DefaultRateType AS varchar(15)
		DECLARE @NoChangeBulkFlg AS bit
		DECLARE @CCY1SplitAllowance AS money
		DECLARE @CCY2SplitAllowance AS money
		DECLARE @CCY3SplitAllowance AS money
		DECLARE @CCY1ManualMatchTolerance AS money
		DECLARE @CCY2ManualMatchTolerance AS money
		DECLARE @CCY3ManualMatchTolerance AS money
		
		IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AccountsTempTable]') AND type in (N'U'))
		DROP TABLE [dbo].[AccountsTempTable]

		CREATE TABLE [dbo].[AccountsTempTable]
			(
			AccountSegment1 varchar(50),
			AccountSegment2 varchar(50),
			AccountSegment3 varchar(50),
			AccountSegment4 varchar(50),
			AccountSegment5 varchar(50),
			AccountSegment6 varchar(50),
			AccountSegment7 varchar(50),
			AccountSegment8 varchar(50),
			AccountSegment9 varchar(50),
			AccountSegment10 varchar(50),
			AccountName varchar(200),
			[Description] text,
			IsGroup bit,
			LocationId varchar(15),
			AccountTypeID varchar(15),
			OwnerId varchar(15),
			QARiskRatingID varchar(15),
			QATestCycleID varchar(15),
			ClearingStandardID varchar(15),
			ZeroBalanceBulkFlg bit,
			ReconPolicy text,
			CCY1Code char(3),
			CCY1GenerateBalance bit,
			CCY1HighBalance money,
			CCY1LowBalance money,
			CCY2Code char(3),
			CCY2GenerateBalance bit,
			CCY2HighBalance money,
			CCY2LowBalance money,
			CCY3Code char(3),
			CCY3GenerateBalance bit,
			CCY3HighBalance money,
			CCY3LowBalance money,
			ReconciliationScheduleID varchar(15),
			ReviewScheduleID varchar(15),
			RequiresApproval bit,
			ApprovalScheduleId varchar(15),
			Approval2ScheduleId varchar(15),
			Approval3ScheduleId varchar(15),
			Approval4ScheduleId varchar(15),
			ReconcilerUserName varchar(50),
			ReviewerUserName varchar(50),
			ApproverUserName varchar(50),
			Approver2UserName varchar(50),
			Approver3UserName varchar(50),
			Approver4UserName varchar(50),
			BUReconcilerUserName varchar(50),
			BUReviewerUserName varchar(50),
			BUApproverUserName varchar(50),
			BUApprover2UserName varchar(50),
			BUApprover3UserName varchar(50),
			BUApprover4UserName varchar(50),
			ReconciliationFormatName varchar(50),
			ExcludeFXConversion bit,
			Active bit,
			CCY1DefaultRateType varchar(15),
			CCY2DefaultRateType varchar(15),
			CCY3DefaultRateType varchar(15),
			NoChangeBulkFlg bit,
			CCY1SplitAllowance money,
			CCY2SplitAllowance money,
			CCY3SplitAllowance money,
			CCY1ManualMatchTolerance money,
			CCY2ManualMatchTolerance money,
			CCY3ManualMatchTolerance money,
			AccountPKId int,
			BUReconcilerId int,
			BUReviewerId int,
			ApproverId int,
			BUApproverId int,
			Approver2ID int,
			BUApprover2ID int,
			Approver3ID int,
			BUApprover3ID int,
			Approver4ID int,
			BUApprover4ID int,
			ReconciliationFormatId int,
			ReconcilerId int,
			ReviewerId int					
		)
		
		SET @Counter = 1
			
		WHILE (@Counter <= @Amount)
		BEGIN
			PRINT 'Creating Account ' + CAST(@Counter as varchar) + ' of ' + CAST(@Amount as varchar)
			SET @AccountSegment1 = @AccountPrefix + CAST(@Counter as varchar)
			SET @AccountSegment2 = @AccountPrefix + CAST(@Counter as varchar)
			SET @AccountSegment3 = @AccountPrefix + CAST(@Counter as varchar)
			SET @AccountSegment4 = @AccountPrefix + CAST(@Counter as varchar)
			SET @AccountSegment5 = @AccountPrefix + CAST(@Counter as varchar)
			SET @AccountSegment6 = @AccountPrefix + CAST(@Counter as varchar)
			SET @AccountSegment7 = @AccountPrefix + CAST(@Counter as varchar)
			SET @AccountSegment8 = @AccountPrefix + CAST(@Counter as varchar)
			SET @AccountSegment9 = @AccountPrefix + CAST(@Counter as varchar)
			SET @AccountSegment10 = @AccountPrefix + CAST(@Counter as varchar)
			SET @AccountName = @AccountPrefix + ' Account ' + CAST(@Counter as varchar)
			SET @Description = 'This is the description for ' + @AccountPrefix + ' Account ' + CAST(@Counter as varchar)
			SET @IsGroup = @Group
			SET @LocationId = (SELECT TOP 1 Code FROM Code_Locations ORDER BY NEWID())
			SET @AccountTypeID = (SELECT TOP 1 Code FROM Code_AccountTypes ORDER BY NEWID())
			SET @OwnerId = (SELECT TOP 1 Code FROM Code_Owners ORDER BY NEWID())
			SET @QARiskRatingID = (SELECT TOP 1 Code FROM Code_QARiskRatings ORDER BY NEWID())
			SET @QATestCycleID = (SELECT TOP 1 Code FROM Code_QATestCycles ORDER BY NEWID())
			SET @ClearingStandardID = (SELECT TOP 1 Code FROM Code_ClearingStandards ORDER BY NEWID())
			SET @ZeroBalanceBulkFlg = 0
			SET @ReconPolicy = 'This is the reconciliation policy for ' + @AccountPrefix + ' Account ' + CAST(@Counter as varchar)
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
			SET @ReconcilerUserName = (SELECT TOP 1 UserName FROM Users WHERE pkid > 1952 and Role_Reconciler=1 AND Active = 1 ORDER BY NEWID())
			SET @ReviewerUserName = (SELECT TOP 1 UserName FROM Users WHERE pkid > 1952 and Role_Reviewer=1 AND Active = 1 AND UserName <> @ReconcilerUserName ORDER BY NEWID())
			SET @ApproverUserName = (SELECT TOP 1 UserName FROM Users WHERE username like '%ApprUser%' and pkid > 1952 and Role_Approver=1 AND Active = 1 AND (UserName <> @ReconcilerUserName AND UserName <> @ReviewerUserName) ORDER BY NEWID())
			SET @Approver2UserName = (SELECT TOP 1 UserName FROM Users WHERE username like '%AcctOwner%' and pkid > 1952 and Role_Approver=1 AND Active = 1 AND (UserName <> @ReconcilerUserName AND UserName <> @ReviewerUserName AND UserName <> @ApproverUserName) ORDER BY NEWID())
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
		DECLARE @HistID int
		DECLARE @Now DateTime
		SET @Now = getdate()
		SELECT @HistID = MAX(PKID) + 1 FROM Interfaces_History
		EXEC TOOLKIT_Accounts_Interface 1,@Now,@HistID
	

GO

/****** Object:  StoredProcedure [dbo].[TOOLKIT_BuildTestUsers]    Script Date: 2/5/2016 4:00:16 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/************************************************************************************************
 * INSTRUCTIONS:                                                                         	    *
 *	Make sure the database has relevant master data.                                 	        *
 *	Run this script on the database.                                                 	        *
 *	Execute the procedure:                                                           	        *
 *		EXEC TOOLKIT_BuildTestUsers Reconcilers, Reviewers, Approvers, Admins, QA               *
 *			Reconcilers: The number of reconciler users to generate.	 	                    *
 *			Reviewers: The number of Reviewer users to generate.		  	                    *
 *			Approvers: The number of Approver users to generate.		      	                *
 *			Admins: The number of Admin users to generate.                        	            *
 *			QA: The number of QA users to generate.		                 	                    *
 *									                 	                                        *
 ************************************************************************************************/

CREATE PROCEDURE [dbo].[TOOLKIT_BuildTestUsers]
(
	@Reconcilers int, @Reviewers int, @Approvers int, @Admins int, @QA int
)
AS
	/* Declarations */
	DECLARE @UserName AS varchar(50)
	DECLARE @Password AS varchar(50)
	DECLARE @DepartmentID AS varchar(50)
	DECLARE @LocationID AS varchar(50)
	DECLARE @ProgramAdminRoleID AS varchar(50)
	DECLARE @FirstName AS varchar(50)
	DECLARE @LastName AS varchar(50)
	DECLARE @FullName AS varchar(100)
	DECLARE @Counter AS int
	
	/* Set Statements */
	SET @Password = 'f1no+2l/41Prfwb24n9VOg=='
	SET @Counter = 1
	PRINT 'Process Started'
	PRINT ''
	/* Create Reconciler Users */
	PRINT '>>Start: Creating ' + CAST(@Reconcilers AS varchar) + ' Reconcilers'
	WHILE (@Counter <= @Reconcilers)
	BEGIN
		SET @UserName = 'ReconUser' + CAST(@Counter AS varchar)
		SET @FirstName = 'Recon'
		SET @LastName = 'User' + CAST(@Counter AS varchar)
		SET @FullName = @FirstName + ' ' + @LastName
		SET @DepartmentID = (SELECT TOP 1 Code FROM Code_Departments ORDER BY NEWID())
		SET @LocationID = (SELECT TOP 1 Code FROM Code_Locations WHERE UserFlg = 1 ORDER BY NEWID())
				
		INSERT INTO Users
			(UserName, [Password], FirstName, LastName, FullName, DepartmentID, LocationID, Role_Reconciler, Role_Reviewer, Role_Approver, Role_QA, Role_ProgramAdmin, ProgramAdminRoleID, AuthenticationType, Active, NewUser)
			VALUES 
			(@UserName, @Password, @FirstName, @LastName, @FullName, @DepartmentID, @LocationID, 1, 0, 0, 0, 0, NULL, 'Forms', 1, 0)
		SET @Counter = @Counter + 1
	END
	PRINT '>>Finished: Creating ' + CAST(@Reconcilers AS varchar) + ' Reconcilers'
	PRINT ''
	PRINT '>>Start: Creating ' + CAST(@Reviewers AS varchar) + ' Reviewers'
	/* Create Reviewer Users */
	SET @Counter = 1
	WHILE (@Counter <= @Reviewers)
	BEGIN
		SET @UserName = 'ReviewUser' + CAST(@Counter AS varchar)
		SET @FirstName = 'Review'
		SET @LastName = 'User' + CAST(@Counter AS varchar)
		SET @FullName = @FirstName + ' ' + @LastName
		SET @DepartmentID = (SELECT TOP 1 Code FROM Code_Departments ORDER BY NEWID())
		SET @LocationID = (SELECT TOP 1 Code FROM Code_Locations WHERE UserFlg = 1 ORDER BY NEWID())
				
		INSERT INTO Users
			(UserName, [Password], FirstName, LastName, FullName, DepartmentID, LocationID, Role_Reconciler, Role_Reviewer, Role_Approver, Role_QA, Role_ProgramAdmin, ProgramAdminRoleID, AuthenticationType, Active, NewUser)
			VALUES 
			(@UserName, @Password, @FirstName, @LastName, @FullName, @DepartmentID, @LocationID, 0, 1, 0, 0, 0, NULL, 'Forms', 1, 0)
		SET @Counter = @Counter + 1
	END
	PRINT '>>Finished: Creating ' + CAST(@Reviewers AS varchar) + ' Reviewers'
	PRINT ''
	PRINT '>>Start: Creating ' + CAST(@Approvers AS varchar) + ' Approvers'
	/* Create Approver Users */
	SET @Counter = 1
	WHILE (@Counter <= @Approvers)
	BEGIN
		SET @UserName = 'ApproveUser' + CAST(@Counter AS varchar)
		SET @FirstName = 'Approve'
		SET @LastName = 'User' + CAST(@Counter AS varchar)
		SET @FullName = @FirstName + ' ' + @LastName
		SET @DepartmentID = (SELECT TOP 1 Code FROM Code_Departments ORDER BY NEWID())
		SET @LocationID = (SELECT TOP 1 Code FROM Code_Locations WHERE UserFlg = 1 ORDER BY NEWID())
				
		INSERT INTO Users
			(UserName, [Password], FirstName, LastName, FullName, DepartmentID, LocationID, Role_Reconciler, Role_Reviewer, Role_Approver, Role_QA, Role_ProgramAdmin, ProgramAdminRoleID, AuthenticationType, Active, NewUser)
			VALUES 
			(@UserName, @Password, @FirstName, @LastName, @FullName, @DepartmentID, @LocationID, 0, 0, 1, 0, 0, NULL, 'Forms', 1, 0)
		SET @Counter = @Counter + 1
	END
	PRINT '>>Finished: Creating ' + CAST(@Approvers AS varchar) + ' Approvers'
	PRINT ''
	PRINT '>>Start: Creating ' + CAST(@Admins AS varchar) + ' Administrators'
	/* Create Admin Users */
	SET @Counter = 1
	WHILE (@Counter <= @Admins)
	BEGIN
		SET @UserName = 'AdminUser' + CAST(@Counter AS varchar)
		SET @FirstName = 'Admin'
		SET @LastName = 'User' + CAST(@Counter AS varchar)
		SET @FullName = @FirstName + ' ' + @LastName
		SET @DepartmentID = (SELECT TOP 1 Code FROM Code_Departments ORDER BY NEWID())
		SET @LocationID = (SELECT TOP 1 Code FROM Code_Locations WHERE UserFlg = 1 ORDER BY NEWID())
		SET @ProgramAdminRoleID = (SELECT TOP 1 Code FROM UserRoles ORDER BY NEWID())
				
		INSERT INTO Users
			(UserName, [Password], FirstName, LastName, FullName, DepartmentID, LocationID, Role_Reconciler, Role_Reviewer, Role_Approver, Role_QA, Role_ProgramAdmin, ProgramAdminRoleID, AuthenticationType, Active, NewUser)
			VALUES 
			(@UserName, @Password, @FirstName, @LastName, @FullName, @DepartmentID, @LocationID, 0, 0, 0, 0, 1, @ProgramAdminRoleID, 'Forms', 1, 0)
		SET @Counter = @Counter + 1
	END
	PRINT '>>Finished: Creating ' + CAST(@Admins AS varchar) + ' Administrators'
	PRINT ''
	PRINT '>>Start: Creating ' + CAST(@QA AS varchar) + ' QA Users'
	/* Create QA Users */
	SET @Counter = 1
	WHILE (@Counter <= @QA)
	BEGIN
		SET @UserName = 'QAUser' + CAST(@Counter AS varchar)
		SET @FirstName = 'QA'
		SET @LastName = 'User' + CAST(@Counter AS varchar)
		SET @FullName = @FirstName + ' ' + @LastName
		SET @DepartmentID = (SELECT TOP 1 Code FROM Code_Departments ORDER BY NEWID())
		SET @LocationID = (SELECT TOP 1 Code FROM Code_Locations WHERE UserFlg = 1 ORDER BY NEWID())
				
		INSERT INTO Users
			(UserName, [Password], FirstName, LastName, FullName, DepartmentID, LocationID, Role_Reconciler, Role_Reviewer, Role_Approver, Role_QA, Role_ProgramAdmin, ProgramAdminRoleID, AuthenticationType, Active, NewUser)
			VALUES 
			(@UserName, @Password, @FirstName, @LastName, @FullName, @DepartmentID, @LocationID, 0, 0, 0, 1, 0, NULL, 'Forms', 1, 0)
		SET @Counter = @Counter + 1
	END	
	PRINT '>>Finished: Creating ' + CAST(@QA AS varchar) + ' QA Users'
	PRINT ''
	PRINT 'Process Completed'

GO

/****** Object:  StoredProcedure [dbo].[TOOLKIT_BuildTestUsers_withOwners]    Script Date: 2/5/2016 4:00:16 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/************************************************************************************************
 * INSTRUCTIONS:                                                                         	    *
 *	Make sure the database has relevant master data.                                 	        *
 *	Run this script on the database.                                                 	        *
 *	Execute the procedure:                                                           	        *
 *		EXEC TOOLKIT_BuildTestUsers Reconcilers, Reviewers, Approvers, Admins, QA               *
 *			Reconcilers: The number of reconciler users to generate.	 	                    *
 *			Reviewers: The number of Reviewer users to generate.		  	                    *
 *			Approvers: The number of Approver users to generate.		      	                *
 *			Admins: The number of Admin users to generate.                        	            *
 *			QA: The number of QA users to generate.		                 	                    *
 *									                 	                                        *
 ************************************************************************************************/

CREATE PROCEDURE [dbo].[TOOLKIT_BuildTestUsers_withOwners]
(
	@Reconcilers int, @Reviewers int, @Approvers int, @AcctOwners int, @Admins int, @QA int
)
AS
	/* Declarations */
	DECLARE @UserName AS varchar(50)
	DECLARE @Password AS varchar(50)
	DECLARE @DepartmentID AS varchar(50)
	DECLARE @LocationID AS varchar(50)
	DECLARE @ProgramAdminRoleID AS varchar(50)
	DECLARE @FirstName AS varchar(50)
	DECLARE @LastName AS varchar(50)
	DECLARE @FullName AS varchar(100)
	DECLARE @Counter AS int
	
	/* Set Statements */
	SET @Password = 'f1no+2l/41Prfwb24n9VOg=='
	SET @Counter = 1
	PRINT 'Process Started'
	PRINT ''
	/* Create Reconciler Users */
	PRINT '>>Start: Creating ' + CAST(@Reconcilers AS varchar) + ' Reconcilers'
	WHILE (@Counter <= @Reconcilers)
	BEGIN
		SET @UserName = 'RecUser' + CAST(@Counter AS varchar)
		SET @FirstName = 'Rec'
		SET @LastName = 'User' + CAST(@Counter AS varchar)
		SET @FullName = @FirstName + ' ' + @LastName
		SET @DepartmentID = (SELECT TOP 1 Code FROM Code_Departments ORDER BY NEWID())
		SET @LocationID = (SELECT TOP 1 Code FROM Code_Locations WHERE UserFlg = 1 ORDER BY NEWID())
				
		INSERT INTO Users
			(UserName, [Password], FirstName, LastName, FullName, DepartmentID, LocationID, Role_Reconciler, Role_Reviewer, Role_Approver, Role_QA, Role_ProgramAdmin, ProgramAdminRoleID, AuthenticationType, Active, NewUser)
			VALUES 
			(@UserName, @Password, @FirstName, @LastName, @FullName, @DepartmentID, @LocationID, 1, 0, 0, 0, 0, NULL, 'Forms', 1, 0)
		SET @Counter = @Counter + 1
	END
	PRINT '>>Finished: Creating ' + CAST(@Reconcilers AS varchar) + ' Reconcilers'
	PRINT ''
	PRINT '>>Start: Creating ' + CAST(@Reviewers AS varchar) + ' Reviewers'
	/* Create Reviewer Users */
	SET @Counter = 1
	WHILE (@Counter <= @Reviewers)
	BEGIN
		SET @UserName = 'RevUser' + CAST(@Counter AS varchar)
		SET @FirstName = 'Rev'
		SET @LastName = 'User' + CAST(@Counter AS varchar)
		SET @FullName = @FirstName + ' ' + @LastName
		SET @DepartmentID = (SELECT TOP 1 Code FROM Code_Departments ORDER BY NEWID())
		SET @LocationID = (SELECT TOP 1 Code FROM Code_Locations WHERE UserFlg = 1 ORDER BY NEWID())
				
		INSERT INTO Users
			(UserName, [Password], FirstName, LastName, FullName, DepartmentID, LocationID, Role_Reconciler, Role_Reviewer, Role_Approver, Role_QA, Role_ProgramAdmin, ProgramAdminRoleID, AuthenticationType, Active, NewUser)
			VALUES 
			(@UserName, @Password, @FirstName, @LastName, @FullName, @DepartmentID, @LocationID, 0, 1, 0, 0, 0, NULL, 'Forms', 1, 0)
		SET @Counter = @Counter + 1
	END
	PRINT '>>Finished: Creating ' + CAST(@Reviewers AS varchar) + ' Reviewers'
	PRINT ''
	PRINT '>>Start: Creating ' + CAST(@Approvers AS varchar) + ' Approvers'
	/* Create Approver Users */
	SET @Counter = 1
	WHILE (@Counter <= @Approvers)
	BEGIN
		SET @UserName = 'ApprUser' + CAST(@Counter AS varchar)
		SET @FirstName = 'Appr'
		SET @LastName = 'User' + CAST(@Counter AS varchar)
		SET @FullName = @FirstName + ' ' + @LastName
		SET @DepartmentID = (SELECT TOP 1 Code FROM Code_Departments ORDER BY NEWID())
		SET @LocationID = (SELECT TOP 1 Code FROM Code_Locations WHERE UserFlg = 1 ORDER BY NEWID())
				
		INSERT INTO Users
			(UserName, [Password], FirstName, LastName, FullName, DepartmentID, LocationID, Role_Reconciler, Role_Reviewer, Role_Approver, Role_QA, Role_ProgramAdmin, ProgramAdminRoleID, AuthenticationType, Active, NewUser)
			VALUES 
			(@UserName, @Password, @FirstName, @LastName, @FullName, @DepartmentID, @LocationID, 0, 0, 1, 0, 0, NULL, 'Forms', 1, 0)
		SET @Counter = @Counter + 1
	END
	PRINT '>>Finished: Creating ' + CAST(@Approvers AS varchar) + ' Approvers'
	PRINT ''
	PRINT ''
	PRINT '>>Start: Creating ' + CAST(@Approvers AS varchar) + ' AcctOwners'
	/* Create Approver Users */
	SET @Counter = 1
	WHILE (@Counter <= @AcctOwners)
	BEGIN
		SET @UserName = 'AcctOwner' + CAST(@Counter AS varchar)
		SET @FirstName = 'Acct'
		SET @LastName = 'Owner' + CAST(@Counter AS varchar)
		SET @FullName = @FirstName + ' ' + @LastName
		SET @DepartmentID = (SELECT TOP 1 Code FROM Code_Departments ORDER BY NEWID())
		SET @LocationID = (SELECT TOP 1 Code FROM Code_Locations WHERE UserFlg = 1 ORDER BY NEWID())
				
		INSERT INTO Users
			(UserName, [Password], FirstName, LastName, FullName, DepartmentID, LocationID, Role_Reconciler, Role_Reviewer, Role_Approver, Role_QA, Role_ProgramAdmin, ProgramAdminRoleID, AuthenticationType, Active, NewUser)
			VALUES 
			(@UserName, @Password, @FirstName, @LastName, @FullName, @DepartmentID, @LocationID, 0, 0, 1, 0, 0, NULL, 'Forms', 1, 0)
		SET @Counter = @Counter + 1
	END
	PRINT '>>Finished: Creating ' + CAST(@Approvers AS varchar) + ' Acct Owners'
	PRINT ''
	PRINT '>>Start: Creating ' + CAST(@Admins AS varchar) + ' Administrators'
	/* Create Admin Users */
	SET @Counter = 1
	WHILE (@Counter <= @Admins)
	BEGIN
		SET @UserName = 'AdminUser' + CAST(@Counter AS varchar)
		SET @FirstName = 'Admin'
		SET @LastName = 'User' + CAST(@Counter AS varchar)
		SET @FullName = @FirstName + ' ' + @LastName
		SET @DepartmentID = (SELECT TOP 1 Code FROM Code_Departments ORDER BY NEWID())
		SET @LocationID = (SELECT TOP 1 Code FROM Code_Locations WHERE UserFlg = 1 ORDER BY NEWID())
		SET @ProgramAdminRoleID = (SELECT TOP 1 Code FROM UserRoles ORDER BY NEWID())
				
		INSERT INTO Users
			(UserName, [Password], FirstName, LastName, FullName, DepartmentID, LocationID, Role_Reconciler, Role_Reviewer, Role_Approver, Role_QA, Role_ProgramAdmin, ProgramAdminRoleID, AuthenticationType, Active, NewUser)
			VALUES 
			(@UserName, @Password, @FirstName, @LastName, @FullName, @DepartmentID, @LocationID, 0, 0, 0, 0, 1, @ProgramAdminRoleID, 'Forms', 1, 0)
		SET @Counter = @Counter + 1
	END
	PRINT '>>Finished: Creating ' + CAST(@Admins AS varchar) + ' Administrators'
	PRINT ''
	PRINT '>>Start: Creating ' + CAST(@QA AS varchar) + ' QA Users'
	/* Create QA Users */
	SET @Counter = 1
	WHILE (@Counter <= @QA)
	BEGIN
		SET @UserName = 'QAUser' + CAST(@Counter AS varchar)
		SET @FirstName = 'QA'
		SET @LastName = 'User' + CAST(@Counter AS varchar)
		SET @FullName = @FirstName + ' ' + @LastName
		SET @DepartmentID = (SELECT TOP 1 Code FROM Code_Departments ORDER BY NEWID())
		SET @LocationID = (SELECT TOP 1 Code FROM Code_Locations WHERE UserFlg = 1 ORDER BY NEWID())
				
		INSERT INTO Users
			(UserName, [Password], FirstName, LastName, FullName, DepartmentID, LocationID, Role_Reconciler, Role_Reviewer, Role_Approver, Role_QA, Role_ProgramAdmin, ProgramAdminRoleID, AuthenticationType, Active, NewUser)
			VALUES 
			(@UserName, @Password, @FirstName, @LastName, @FullName, @DepartmentID, @LocationID, 0, 0, 0, 1, 0, NULL, 'Forms', 1, 0)
		SET @Counter = @Counter + 1
	END	
	PRINT '>>Finished: Creating ' + CAST(@QA AS varchar) + ' QA Users'
	PRINT ''
	PRINT 'Process Completed'

GO

/****** Object:  StoredProcedure [dbo].[TOOLKIT_GenerateBalances]    Script Date: 2/5/2016 4:00:16 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/************************************************************************************************************************************* 
 *	Procedure: TOOLKIT_GenerateBalances                                                                                              *
 *	Inputs: @ForEffDate datetime, @ZeroBalances bit, @AutoInsert bit                                                                 *
 *	Purpose: Generates balances for all accounts in the system for a given effective date.                                           *
 *	Usage: EXEC TOOLKIT_GenerateBalances EffectiveDate,ZeroBalance,AutoInsert                                                        *
 *	Example: EXEC TOOLKIT_GenerateBalances '20090930',1,1                                                                            *
 *	Input Descriptions:                                                                                                              *
 *			@ForEffDate: The effective date for which the balances should be inserted.                                               *
 *			@ZeroBalances: Indicates whether zero balances (1) or random balances (0) should be used                                 *
 *			@AutoInsert: Indicates whether the balances should be put into the database (1) or only output (0 for manual import)     *
 *************************************************************************************************************************************/

CREATE PROCEDURE [dbo].[TOOLKIT_GenerateBalances] (@ForEffDate datetime, @ZeroBalances bit, @AutoInsert bit)
AS
	DECLARE @CCY1EndBalance money
	DECLARE @CCY2EndBalance money
	DECLARE @CCY3EndBalance money
	DECLARE @Period char(2)
	DECLARE @Year char(4)
	DECLARE @EffectiveDate datetime

	DECLARE @AS1 varchar(50)
	DECLARE @AS2 varchar(50)
	DECLARE @AS3 varchar(50)
	DECLARE @AS4 varchar(50)
	DECLARE @AS5 varchar(50)
	DECLARE @AS6 varchar(50)
	DECLARE @AS7 varchar(50)
	DECLARE @AS8 varchar(50)
	DECLARE @AS9 varchar(50)
	DECLARE @AS10 varchar(50)

	DECLARE @AccountName varchar(200)
	DECLARE @CCY1Code char(3)
	DECLARE @CCY2Code char(3)
	DECLARE @CCY3Code char(3)

	IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BalancesTempTable]') AND type in (N'U'))
	DROP TABLE [dbo].[BalancesTempTable]

	CREATE TABLE [dbo].[BalancesTempTable]
	(
		[PKId] [int] IDENTITY(1,1) NOT NULL,
		AccountPKID int,
		AccountSegment1 varchar(50),
		AccountSegment2 varchar(50),
		AccountSegment3 varchar(50),
		AccountSegment4 varchar(50),
		AccountSegment5 varchar(50),
		AccountSegment6 varchar(50),
		AccountSegment7 varchar(50),
		AccountSegment8 varchar(50),
		AccountSegment9 varchar(50),
		AccountSegment10 varchar(50),
		AccountName varchar(200),
		CCY1Code char(3),
		CCY1EndBalance money,
		CCY2Code char(3),
		CCY2EndBalance money,
		CCY3Code char(3),
		CCY3EndBalance money,
		Period char(2),
		[Year] char(4),
		EffectiveDate datetime,
		GLHistoryUpdatedFlag bit
	)

	DECLARE BALANCES CURSOR
	FOR
	SELECT 
		acs.AccountSegment1,
		acs.AccountSegment2,
		acs.AccountSegment3,
		acs.AccountSegment4,
		acs.AccountSegment5,
		acs.AccountSegment6,
		acs.AccountSegment7,
		acs.AccountSegment8,
		acs.AccountSegment9,
		acs.AccountSegment10,
		acc.AccountName,
		acc.CCY1Code,
		acc.CCY2Code,
		acc.CCY3Code
	FROM Accounts acc
	LEFT OUTER JOIN AccountSegments acs ON acc.PKID = acs.AccountID WHERE acc.IsGroup <> 1

	OPEN BALANCES

	FETCH NEXT FROM BALANCES INTO @AS1,@AS2,@AS3,@AS4,@AS5,@AS6,@AS7,@AS8,@AS9,@AS10,@AccountName,@CCY1Code,@CCY2Code,@CCY3Code

	WHILE (@@FETCH_STATUS <> -1)
	BEGIN
		IF (@ZeroBalances = 1)
		BEGIN
			SET @CCY1EndBalance = 0
			SET @CCY2EndBalance = 0
			SET @CCY3EndBalance = 0
		END
		ELSE
		BEGIN
			SET @CCY1EndBalance = RAND() * 100000
			SET @CCY2EndBalance = RAND() * 100000
			SET @CCY3EndBalance = RAND() * 100000
		END
		
		SELECT @EffectiveDate=EffectiveDate,@Period=FiscalMonth,@Year=FiscalYear FROM EffectiveDates WHERE EffectiveDate = @ForEffDate
		
		INSERT INTO BalancesTempTable 
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
			CCY1Code,
			CCY1EndBalance,
			CCY2Code,
			CCY2EndBalance,
			CCY3Code,
			CCY3EndBalance,
			Period,
			[Year],
			EffectiveDate
		)
		VALUES
		(
			@AS1,
			@AS2,
			@AS3,
			@AS4,
			@AS5,
			@AS6,
			@AS7,
			@AS8,
			@AS9,
			@AS10,
			@AccountName,
			@CCY1Code,
			@CCY1EndBalance,
			@CCY2Code,
			@CCY2EndBalance,
			@CCY3Code,
			@CCY3EndBalance,
			@Period,
			@Year,
			@EffectiveDate
		)
		

		FETCH NEXT FROM BALANCES INTO @AS1,@AS2,@AS3,@AS4,@AS5,@AS6,@AS7,@AS8,@AS9,@AS10,@AccountName,@CCY1Code,@CCY2Code,@CCY3Code
	END

	CLOSE BALANCES
	DEALLOCATE BALANCES
	IF (@AutoInsert = 0 OR @AutoInsert IS NULL)
		SELECT AccountSegment1,AccountSegment2,AccountSegment3,AccountSegment4,AccountSegment5,AccountSegment6,AccountSegment7,AccountSegment8,AccountSegment9,AccountSegment10,AccountName,CCY1Code,CCY1EndBalance,CCY2Code,CCY2EndBalance,CCY3Code,CCY3EndBalance,Period,[Year],EffectiveDate FROM BalancesTempTable
	ELSE
	BEGIN
		DECLARE @HistID int
		DECLARE @Now DateTime
		SET @Now = getdate()
		SELECT @HistID = MAX(PKID) + 1 FROM Interfaces_History
		EXEC TOOLKIT_GLHistory_Import 1,@Now,@HistID
	END

GO

/****** Object:  StoredProcedure [dbo].[TOOLKIT_GenerateBalances_updated]    Script Date: 2/5/2016 4:00:16 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [dbo].[TOOLKIT_GenerateBalances_updated] (@ForEffDate datetime, @ZeroBalances bit, @AutoInsert bit)
AS
	DECLARE @CCY1EndBalance money
	DECLARE @CCY2EndBalance money
	DECLARE @CCY3EndBalance money
	DECLARE @Period char(2)
	DECLARE @Year char(4)
	DECLARE @EffectiveDate datetime

	DECLARE @AS1 varchar(50)
	DECLARE @AS2 varchar(50)
	DECLARE @AS3 varchar(50)
	DECLARE @AS4 varchar(50)
	DECLARE @AS5 varchar(50)
	DECLARE @AS6 varchar(50)
	DECLARE @AS7 varchar(50)
	DECLARE @AS8 varchar(50)
	DECLARE @AS9 varchar(50)
	DECLARE @AS10 varchar(50)

	DECLARE @AccountName varchar(200)
	DECLARE @CCY1Code char(3)
	DECLARE @CCY2Code char(3)
	DECLARE @CCY3Code char(3)

	IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BalancesTempTable]') AND type in (N'U'))
	DROP TABLE [dbo].[BalancesTempTable]

	CREATE TABLE [dbo].[BalancesTempTable]
	(
		[PKId] [int] IDENTITY(1,1) NOT NULL,
		AccountPKID int,
		AccountSegment1 varchar(50),
		AccountSegment2 varchar(50),
		AccountSegment3 varchar(50),
		AccountSegment4 varchar(50),
		AccountSegment5 varchar(50),
		AccountSegment6 varchar(50),
		AccountSegment7 varchar(50),
		AccountSegment8 varchar(50),
		AccountSegment9 varchar(50),
		AccountSegment10 varchar(50),
		AccountName varchar(200),
		CCY1Code char(3),
		CCY1EndBalance money,
		CCY2Code char(3),
		CCY2EndBalance money,
		CCY3Code char(3),
		CCY3EndBalance money,
		Period char(2),
		[Year] char(4),
		EffectiveDate datetime,
		GLHistoryUpdatedFlag bit
	)

	DECLARE BALANCES CURSOR
	FOR
	SELECT 
		acs.AccountSegment1,
		acs.AccountSegment2,
		acs.AccountSegment3,
		acs.AccountSegment4,
		acs.AccountSegment5,
		acs.AccountSegment6,
		acs.AccountSegment7,
		acs.AccountSegment8,
		acs.AccountSegment9,
		acs.AccountSegment10,
		acc.AccountName,
		acc.CCY1Code,
		acc.CCY2Code,
		acc.CCY3Code
	FROM Accounts acc
	LEFT OUTER JOIN AccountSegments acs ON acc.PKID = acs.AccountID
	where acc.pkid > 700500

	OPEN BALANCES

	FETCH NEXT FROM BALANCES INTO @AS1,@AS2,@AS3,@AS4,@AS5,@AS6,@AS7,@AS8,@AS9,@AS10,@AccountName,@CCY1Code,@CCY2Code,@CCY3Code

	WHILE (@@FETCH_STATUS <> -1)
	BEGIN
		IF ((select ReconciliationFormatID from Accounts where accountname = @accountname) = 3)
		BEGIN
			SET @CCY1EndBalance = 0
			SET @CCY2EndBalance = 0
			SET @CCY3EndBalance = 0
		END
		ELSE
		BEGIN
			SET @CCY1EndBalance = RAND() * 100000
			SET @CCY2EndBalance = RAND() * 100000
			SET @CCY3EndBalance = RAND() * 100000
		END
		
		SELECT @EffectiveDate=EffectiveDate,@Period=FiscalMonth,@Year=FiscalYear FROM EffectiveDates WHERE EffectiveDate = @ForEffDate
		
		INSERT INTO BalancesTempTable 
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
			CCY1Code,
			CCY1EndBalance,
			CCY2Code,
			CCY2EndBalance,
			CCY3Code,
			CCY3EndBalance,
			Period,
			[Year],
			EffectiveDate
		)
		VALUES
		(
			@AS1,
			@AS2,
			@AS3,
			@AS4,
			@AS5,
			@AS6,
			@AS7,
			@AS8,
			@AS9,
			@AS10,
			@AccountName,
			@CCY1Code,
			@CCY1EndBalance,
			@CCY2Code,
			@CCY2EndBalance,
			@CCY3Code,
			@CCY3EndBalance,
			@Period,
			@Year,
			@EffectiveDate
		)
		

		FETCH NEXT FROM BALANCES INTO @AS1,@AS2,@AS3,@AS4,@AS5,@AS6,@AS7,@AS8,@AS9,@AS10,@AccountName,@CCY1Code,@CCY2Code,@CCY3Code
	END

	CLOSE BALANCES
	DEALLOCATE BALANCES
	IF (@AutoInsert = 0 OR @AutoInsert IS NULL)
		SELECT AccountSegment1,AccountSegment2,AccountSegment3,AccountSegment4,AccountSegment5,AccountSegment6,AccountSegment7,AccountSegment8,AccountSegment9,AccountSegment10,AccountName,CCY1Code,CCY1EndBalance,CCY2Code,CCY2EndBalance,CCY3Code,CCY3EndBalance,Period,[Year],EffectiveDate FROM BalancesTempTable
	ELSE
	BEGIN
		DECLARE @HistID int
		DECLARE @Now DateTime
		SET @Now = getdate()
		SELECT @HistID = MAX(PKID) + 1 FROM Interfaces_History
		EXEC TOOLKIT_GLHistory_Import 1,@Now,@HistID
	END




GO

/****** Object:  StoredProcedure [dbo].[TOOLKIT_GLHistory_Import]    Script Date: 2/5/2016 4:00:16 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[TOOLKIT_GLHistory_Import]
(@InterfaceID int, @StartTime datetime, @InterfaceHistoryPKId int)
AS
		Declare @Result as smallint
		Set @Result = 0
		Declare @CurrentDt datetime
		Set @CurrentDt = GetDate()
	
		--Validate CCY 1Code
		exec @Result = usp_InterfaceValidateTableColumns @InterfaceId,@StartTime,'BalancesTempTable','Code_Currencies','CCY1Code','Code',1,0,@InterfaceHistoryPKId
	
		if(@Result < 0)
		begin
			print 'CCY1 Code Validation Error: ' + Convert(varchar,@Result)
			goto ValidationExitPoint
		end
	
		--Validate CCY2 Code
		exec @Result = usp_InterfaceValidateTableColumns @InterfaceId,@StartTime,'BalancesTempTable','Code_Currencies','CCY2Code','Code',1,0,@InterfaceHistoryPKId
	
		if(@Result < 0)
		begin
			print 'CCY2 Code Validation Error: ' + Convert(varchar,@Result)
			goto ValidationExitPoint
		end
	
		--Validate CCY3 Code
		exec @Result = usp_InterfaceValidateTableColumns @InterfaceId,@StartTime,'BalancesTempTable','Code_Currencies','CCY3Code','Code',1,0,@InterfaceHistoryPKId
	
		if(@Result < 0)
		begin
			print 'CCY3 Code Validation Error: ' + Convert(varchar,@Result)
			goto ValidationExitPoint
		end
	
		--Start Transaction
		Begin TRAN
		
		--Declare variables
		
	
		Declare @TempTableRowCount as int
		
		Declare @TotalRecs as int 
		Declare @TotalInserted as int
		Declare @TotalUpdated as int
		set @TotalRecs  =0 
		set @TotalInserted =0 
		set @TotalUpdated = 0
		
	--	--These declarion for handling Errors
		Declare @Error_TTPKID as int
		Declare @Error_Code as int
		Declare @Error_QueryCode as varchar(200)
		Declare @ErrorVar int
	    Declare @IsError as bit
	--	
	--	--Declared to handle count and error in certain areas.
		
		Declare @RowCountVar int
		Declare @EndTime datetime	
		
		print 'Beginning Checking for existance of records in the temp table: ' + Convert(varchar,getDate())
		SELECT @TempTableRowCount = COUNT(*) FROM BalancesTempTable
		SELECT @ErrorVar = @@ERROR	
		IF (@ErrorVar<>0)
			BEGIN
				set @IsError=1
				set @Error_Code = @ErrorVar
				set @Error_TTPKID = 0
				set @Error_QueryCode = ' Checking for records in the temp table '
				GOTO ExitPoint
			END
		IF(@TempTableRowCount<=0 )	-- No rows in the temp table
		BEGIN
			set @IsError=1
			set @Error_Code = @ErrorVar
			set @Error_TTPKID = 0
			set @Error_QueryCode = 'There are no records in BalancesTempTable.'
			GOTO ExitPoint
		END
		print 'Finished Checking for existance of records in the temp table: ' + Convert(varchar,getDate())
	
		print 'Beginning Reset BalanceUpdate Flag: ' + Convert(varchar,getDate())
		UPDATE GLHistory SET BalanceChange=0 where BalanceChange=1
		SELECT @ErrorVar = @@ERROR	
		IF (@ErrorVar<>0)	-- Error executing sql
			BEGIN
				set @IsError=1
				set @Error_Code = @ErrorVar
				set @Error_TTPKID = 0
				set @Error_QueryCode = 'Resetting BalanceUpdate Flag '
				GOTO ExitPoint
			END
		print 'Finished Reset BalanceUpdate Flag: ' + Convert(varchar,getDate())
	
		print 'Beginning Reset PendingBalanceUpdate Flag: ' + Convert(varchar,getDate())
		UPDATE Reconciliations SET PendingBalanceUpdate=0 where PendingBalanceUpdate=1
		SELECT @ErrorVar = @@ERROR	
		IF (@ErrorVar<>0)	-- Error executing sql
			BEGIN
				set @IsError=1
				set @Error_Code = @ErrorVar
				set @Error_TTPKID = 0
				set @Error_QueryCode = 'Resetting PendingBalanceUpdate Flag '
				GOTO ExitPoint
			END
		print 'Finished Reset PendingBalanceUpdate Flag: ' + Convert(varchar,getDate())
	
		print 'Beginning Reset Update Flag: ' + Convert(varchar,getDate())
		UPDATE BalancesTempTable SET GLHistoryUpdatedFlag = 0
		SELECT @ErrorVar = @@ERROR	
		IF (@ErrorVar<>0)	-- Error executing sql
			BEGIN
				set @IsError=1
				set @Error_Code = @ErrorVar
				set @Error_TTPKID = 0
				set @Error_QueryCode = 'Resetting Update Flag '
				GOTO ExitPoint
			END
		print 'Finished Reset Update Flag: ' + Convert(varchar,getDate())
		
		print 'Beginning Updating Effective Dates: ' + Convert(varchar,getDate())
		UPDATE BalancesTempTable 
			SET BalancesTempTable.EffectiveDate=E.EffectiveDate
				FROM BalancesTempTable T 
			INNER JOIN EffectiveDates E ON right('00' + convert(varchar(2),CAST(E.FiscalMonth as int)),2)=right('00' + convert(varchar(2),CAST(T.Period as int)),2) AND E.FiscalYear=T.[YEAR] 
		SELECT @ErrorVar = @@ERROR, @RowCountVar = @@ROWCOUNT	
		IF (@ErrorVar<>0)	-- Error executing sql
			BEGIN
				set @IsError=1
				set @Error_Code = @ErrorVar
				set @Error_TTPKID = 0
				set @Error_QueryCode = 'Updating EffectiveDate of Temp Table '
				GOTO ExitPoint
			END
		IF(@RowCountVar=0)	-- Zero effective dates updated
			BEGIN
				set @IsError=1
				set @Error_Code = @ErrorVar
				set @Error_TTPKID = 0
				set @Error_QueryCode = '0 records are updated for Effective Dates'
				GOTO ExitPoint
			END
		IF(@RowCountVar<>@TempTableRowCount)	-- Rows in the temp table don't match the number of effective date rows updated
			BEGIN
				set @IsError=1
				set @Error_Code = @ErrorVar
				set @Error_TTPKID = 0
				set @Error_QueryCode = str(@RowCountVar) + ' Out of ' + str(@TempTableRowCount) + ' Records are updated for Effective Dates'
				GOTO ExitPoint
			END		
		print 'Finished Updating Effective Dates: ' + Convert(varchar,getDate())		
		
		print 'Beginning Setting AccountPKId: ' + Convert(varchar,getDate())
		Update BalancesTempTable 
			SET BalancesTempTable.AccountPKID = A.PKID	
			FROM 
			    BalancesTempTable T 
				INNER JOIN AccountSegments S ON IsNULL(T.AccountSegment1,'^')=IsNULL(S.AccountSegment1,'^') 
							AND IsNULL(T.AccountSegment2,'^')=IsNULL(S.AccountSegment2,'^')
							AND IsNULL(T.AccountSegment3,'^')=IsNULL(S.AccountSegment3,'^')
							AND IsNULL(T.AccountSegment4,'^')=IsNULL(S.AccountSegment4,'^')
							AND IsNULL(T.AccountSegment5,'^')=IsNULL(S.AccountSegment5,'^')
							AND IsNULL(T.AccountSegment6,'^')=IsNULL(S.AccountSegment6,'^')
							AND IsNULL(T.AccountSegment7,'^')=IsNULL(S.AccountSegment7,'^')
							AND IsNULL(T.AccountSegment8,'^')=IsNULL(S.AccountSegment8,'^')
							AND IsNULL(T.AccountSegment9,'^')=IsNULL(S.AccountSegment9,'^')
							AND IsNULL(T.AccountSegment10,'^')=IsNULL(S.AccountSegment10,'^')
				INNER JOIN Accounts A ON S.AccountID=A.PKID
		select @ErrorVar=@@error
		IF (@ErrorVar<>0)
			BEGIN
				set @IsError=1
				set @Error_Code = @ErrorVar
				set @Error_TTPKID = 0
				set @Error_QueryCode = 'Updating AccountPKId of BalancesTempTable '
				GOTO ExitPoint
			END
		print 'Finished Setting AccountPKId: ' + Convert(varchar,getDate())
		
		print 'Beginning Updating Accounts Name, LastDateImported: ' + Convert(varchar,getDate())
		UPDATE Accounts 
			SET Accounts.AccountName=BalancesTempTable.ACCOUNTNAME, 
			    DateLastImported=@CurrentDt
			FROM BalancesTempTable 
		join  Accounts on Accounts.PKID = BalancesTempTable.AccountPKID
		select @ErrorVar=@@error 
		IF(@ErrorVar <>0 )
		BEGIN
			set @IsError=1
			set @Error_Code = @ErrorVar
			set @Error_TTPKID = 0
			set @Error_QueryCode = 'Updating AccountName,DateLastImported of Accounts '
			GOTO ExitPoint
		END
		print 'Finished Updating Accounts Name, LastDateImported: ' + Convert(varchar,getDate())
	
		print 'Beginning Insert into Account and AccountSegments table: ' + Convert(varchar,getDate())
		Declare @AccountPKId int
		Declare @AccountSegment1 varchar(50)
		Declare @AccountSegment2 varchar(50)
		Declare @AccountSegment3 varchar(50)
		Declare @AccountSegment4 varchar(50)
		Declare @AccountSegment5 varchar(50)
		Declare @AccountSegment6 varchar(50)
		Declare @AccountSegment7 varchar(50)
		Declare @AccountSegment8 varchar(50)
		Declare @AccountSegment9 varchar(50)
		Declare @AccountSegment10 varchar(100)
		Declare @AccountName varchar(200)
		Declare BalancesTempTable_NewAccounts Cursor FOR
		SELECT Distinct
			AccountSegment1,
			AccountSegment2,
			AccountSegment3,
			AccountSegment4,
			AccountSegment5,
			AccountSegment6,
			AccountSegment7,
			AccountSegment8,
			AccountSegment9,
			AccountSegment10
		FROM BalancesTempTable
		WHERE AccountPKId is null
	
		Open BalancesTempTable_NewAccounts
		Fetch BalancesTempTable_NewAccounts INTO 
		@AccountSegment1, 
		@AccountSegment2,
		@AccountSegment3,
		@AccountSegment4,
		@AccountSegment5,
		@AccountSegment6,
		@AccountSegment7,
		@AccountSegment8,
		@AccountSegment9,
		@AccountSegment10
	
		WHILE @@Fetch_STATUS = 0 
		BEGIN
			Insert into Accounts(DateLastImported,DateActivated)
				VALUES(GetDate(),GetDate())
			select @ErrorVar=@@error
			IF (@ErrorVar<>0)
			BEGIN
				set @IsError=1
				set @Error_Code = @ErrorVar
				set @Error_TTPKID = 0
				set @Error_QueryCode = 'Inserting new record in Accounts '
				GOTO ExitPoint
			END
			set @AccountPKID = IDENT_CURRENT('Accounts') 
			
			INSERT INTO AccountSegments(AccountId,AccountSegment1,AccountSegment2,AccountSegment3,AccountSegment4,AccountSegment5,AccountSegment6,AccountSegment7,AccountSegment8,AccountSegment9,AccountSegment10)
				    VALUES(@AccountPKID, @AccountSegment1,@AccountSegment2,@AccountSegment3,@AccountSegment4,@AccountSegment5,@AccountSegment6,@AccountSegment7,@AccountSegment8,@AccountSegment9,@AccountSegment10)
			select @ErrorVar=@@error
			IF (@ErrorVar<>0)
			BEGIN
				set @IsError=1
				set @Error_Code = @ErrorVar
				set @Error_TTPKID = 0
				set @Error_QueryCode = 'Inserting new record in AccountSegments '
				GOTO ExitPoint
			END
			Update BalancesTempTable 
			SET BalancesTempTable.AccountPKID = @AccountPKID
			Where
			    IsNULL(AccountSegment1,'^')=IsNULL(@AccountSegment1,'^') and 
				IsNULL(AccountSegment2,'^')=IsNULL(@AccountSegment2,'^') and
				IsNULL(AccountSegment3,'^')=IsNULL(@AccountSegment3,'^') and 
				IsNULL(AccountSegment4,'^')=IsNULL(@AccountSegment4,'^') and
				IsNULL(AccountSegment5,'^')=IsNULL(@AccountSegment5,'^') and 
				IsNULL(AccountSegment6,'^')=IsNULL(@AccountSegment6,'^') and 
				IsNULL(AccountSegment7,'^')=IsNULL(@AccountSegment7,'^') and
				IsNULL(AccountSegment8,'^')=IsNULL(@AccountSegment8,'^') and 
				IsNULL(AccountSegment9,'^')=IsNULL(@AccountSegment9,'^') and 
				IsNULL(AccountSegment10,'^')=IsNULL(@AccountSegment10,'^')
			IF (@ErrorVar<>0)
			BEGIN
				set @IsError=1
				set @Error_Code = @ErrorVar
				set @Error_TTPKID = 0
				set @Error_QueryCode = ' Updating BalancesTempTable with new AccountPKId  '
				GOTO ExitPoint
			END
			
			UPDATE Accounts 
				SET Accounts.AccountName = BalancesTempTable.AccountName,
				    Accounts.CCY1Code = BalancesTempTable.CCY1Code,
				    Accounts.CCY2Code = BalancesTempTable.CCY2Code,
				    Accounts.CCY3Code = BalancesTempTable.CCY3Code
			from Accounts
			join BalancesTempTable 
					on Accounts.PKId=BalancesTempTable.AccountPKID
			where BalancesTempTable.PKId = (Select Min(PKId) from BalancesTempTable where BalancesTempTable.AccountPKID = @AccountPKID)
			
			IF (@ErrorVar<>0)
			BEGIN
				set @IsError=1
				set @Error_Code = @ErrorVar
				set @Error_TTPKID = 0
				set @Error_QueryCode = ' Updating AccountName and CCYCodes with new AccountPKId  '
				GOTO ExitPoint
			END				
				
	
			Fetch BalancesTempTable_NewAccounts INTO 
			@AccountSegment1, 
			@AccountSegment2,
			@AccountSegment3,
			@AccountSegment4,
			@AccountSegment5,
			@AccountSegment6,
			@AccountSegment7,
			@AccountSegment8,
			@AccountSegment9,
			@AccountSegment10
		END
	
		Close BalancesTempTable_NewAccounts
		DEALLOCATE BalancesTempTable_NewAccounts
		print 'Finished Insert into Account and AccountSegments table: ' + Convert(varchar,getDate())
		
		print 'Beginning Set Update Flag: ' + Convert(varchar,getDate())	
		UPDATE BalancesTempTable 
			SET 	GLHistoryUpdatedFlag = 1	
				FROM BalancesTempTable  
					join  GLHistory on GLHistory.AccountID=BalancesTempTable.AccountPKID AND GLHistory.EffectiveDate=BalancesTempTable.EffectiveDate
					AND IsNULL(GLHistory.CCY1Code,'0')=IsNULL(BalancesTempTable.CCY1Code,'0')
					AND IsNULL(GLHistory.CCY2Code,'0')=IsNULL(BalancesTempTable.CCY2Code,'0')
					AND IsNULL(GLHistory.CCY3Code,'0')=IsNULL(BalancesTempTable.CCY3Code,'0')
		select @ErrorVar=@@error
		if(@ErrorVar <>0 )
		Begin
			set @IsError=1
			set @Error_Code = @ErrorVar
			set @Error_TTPKID = 0
			set @Error_QueryCode = 'Setting Update Flag '
			GOTO ExitPoint
		end
		print 'Finished Set Update Flag: ' + Convert(varchar,getDate())
		
		print 'Beginning Set Total Updated Count: ' + Convert(varchar,getDate())	
		Select @TotalUpdated=Count(GLHistoryUpdatedFlag)	
				FROM BalancesTempTable  
					where GLHistoryUpdatedFlag=1
		select @ErrorVar=@@error
		if(@ErrorVar <>0 )
		Begin
			set @IsError=1
			set @Error_Code = @ErrorVar
			set @Error_TTPKID = 0
			set @Error_QueryCode = 'Setting Total Updated Count '
			GOTO ExitPoint
		end
		print 'Finished Set Update Flag: ' + Convert(varchar,getDate())
	
		print 'Beginning Updating GLHistory: ' + Convert(varchar,getDate())	
		UPDATE GLHistory 
		SET 	GLHistory.EffectiveDate=BalancesTempTable.EffectiveDate, 
				GLHistory.FiscalMonth=BalancesTempTable.PERIOD,
				GLHistory.FiscalYear=BalancesTempTable.Year,
				GLHistory.CCY1Code=BalancesTempTable.CCY1Code,
				GLHistory.CCY1GLEndBalance=BalancesTempTable.CCY1EndBalance,
				GLHistory.CCY2Code=BalancesTempTable.CCY2Code,
				GLHistory.CCY2GLEndBalance=BalancesTempTable.CCY2EndBalance,			
				GLHistory.CCY3Code=BalancesTempTable.CCY3Code,
				GLHistory.CCY3GLEndBalance=BalancesTempTable.CCY3EndBalance,
				GLHistory.BalanceChange = 1
		FROM GLHistory  
		join BalancesTempTable on GLHistory.AccountID=BalancesTempTable.AccountPKID AND GLHistory.EffectiveDate=BalancesTempTable.EffectiveDate
			AND IsNULL(GLHistory.CCY1Code,'0')=IsNULL(BalancesTempTable.CCY1Code,'0')
			AND IsNULL(GLHistory.CCY2Code,'0')=IsNULL(BalancesTempTable.CCY2Code,'0')
			AND IsNULL(GLHistory.CCY3Code,'0')=IsNULL(BalancesTempTable.CCY3Code,'0')
		where IsNull(GLHistory.CCY1GLEndBalance,0) <> BalancesTempTable.CCY1EndBalance
				or IsNull(GLHistory.CCY2GLEndBalance,0) <> BalancesTempTable.CCY2EndBalance
				or IsNull(GLHistory.CCY3GLEndBalance,0) <> BalancesTempTable.CCY3EndBalance
		select @ErrorVar=@@error
		if(@ErrorVar<>0 )
      Begin
      set @IsError=1
      set @Error_Code = @ErrorVar
      set @Error_TTPKID = 0
      set @Error_QueryCode = ' Updating GLHistory table '
      GOTO ExitPoint
      end
      print 'Finished Updating GLHistory: ' + Convert(varchar,getDate())

      print 'Beginning Updating GLHistory Related Records: ' + Convert(varchar,getDate())
      Update GLHistory
      set BalanceChange = 1
      From GLHistory
      join (select AccountId,EffectiveDate from GLHistory where BalanceChange = 1) as BalanceChange
      on GLHistory.AccountId = BalanceChange.AccountId
      and GLHistory.EffectiveDate = BalanceChange.EffectiveDate
      select @ErrorVar=@@error
      if(@ErrorVar<>0 )
      Begin
      set @IsError=1
      set @Error_Code = @ErrorVar
      set @Error_TTPKID = 0
      set @Error_QueryCode = ' Updating GLHistory table for related records '
      GOTO ExitPoint
      end
      print 'Finished Updating GLHistory Related Records: ' + Convert(varchar,getDate())

      print 'Beginning Insert into GLHistory: ' + Convert(varchar,getDate())
      INSERT INTO GLHistory(AccountID, EffectiveDate,CCY1Code,CCY1GLEndBalance,
      CCY2Code,CCY2GLEndBalance,
      CCY3Code,CCY3GLEndBalance,FiscalMonth,FiscalYear,BalanceChange
      )
      (Select AccountPKID, EffectiveDate,
      CCY1Code, CCY1EndBalance,
      CCY2Code, CCY2EndBalance,
      CCY3Code, CCY3EndBalance,
      Period, Year, 1
      from BalancesTempTable
      where GLHistoryUpdatedFlag = 0)
      select @ErrorVar=@@error,@TotalInserted=@@RowCount
      if(@ErrorVar<>0 )
		Begin
			set @IsError=1
			set @Error_Code = @ErrorVar
			set @Error_TTPKID = 0
			set @Error_QueryCode = 'Inserting new record in GLHistory '
			GOTO ExitPoint
		end	
		print 'Finished Insert into GLHistory: ' + Convert(varchar,getDate())
	
		print 'Beginning Updating Reconciliation_Balances for CCY1Code for accounts reconcilied individually: ' + Convert(varchar,getDate())
		Update Reconciliations_Balances set CCY1GLEndBalance = Balances.SumCCY1GLEndBalance,CCY1GLActivity=Balances.SumCCY1GLEndBalance-IsNull(CCY1GLBegBalance,0)
		From Reconciliations_Balances
		 join (
			SELECT GLHistory.AccountId, GLHistory.CCY1Code, GLHistory.EffectiveDate, Reconciliations.PKId AS RecId,SUM(IsNULL(GLHistory.CCY1GLEndBalance,0)) as SumCCY1GLEndBalance  
			FROM GLHistory 
			join Reconciliations
				on GLHistory.AccountId = Reconciliations.AccountId
					and GLHistory.EffectiveDate = Reconciliations.EffectiveDate
			where GLHistory.BalanceChange=1
			group by 
				GLHistory.AccountId, GLHistory.CCY1Code, GLHistory.EffectiveDate, Reconciliations.PKId ) as Balances
		on Reconciliations_Balances.ReconciliationID = Balances.RecId and Reconciliations_Balances.CCY1Code = Balances.CCY1Code
		select @ErrorVar=@@error
		if(@ErrorVar<>0)
		Begin
			set @IsError=1
			set @Error_Code = @ErrorVar
			set @Error_TTPKID = 0
			set @Error_QueryCode = 'Updating CCY1 records in Reconciliation_Balances for accounts reconcilied individually '
			GOTO ExitPoint
		end
		print 'Finished Updating Reconciliation_Balances for CCY1Code for accounts reconcilied individually: ' + Convert(varchar,getDate())
	
		print 'Beginning Updating Reconciliation_Balances for CCY2Code for accounts reconcilied individually: ' + Convert(varchar,getDate())
		Update Reconciliations_Balances set CCY2GLEndBalance = Balances.SumCCY2GLEndBalance,CCY2GLActivity=Balances.SumCCY2GLEndBalance-IsNull(CCY2GLBegBalance,0)
		From Reconciliations_Balances
		 join (
			SELECT GLHistory.AccountId, GLHistory.CCY2Code, GLHistory.EffectiveDate, Reconciliations.PKId AS RecId,SUM(IsNULL(GLHistory.CCY2GLEndBalance,0)) as SumCCY2GLEndBalance  
			FROM GLHistory 
			join Reconciliations
				on GLHistory.AccountId = Reconciliations.AccountId
					and GLHistory.EffectiveDate = Reconciliations.EffectiveDate
			where GLHistory.BalanceChange=1
			group by 
				GLHistory.AccountId, GLHistory.CCY2Code, GLHistory.EffectiveDate, Reconciliations.PKId ) as Balances
		on Reconciliations_Balances.ReconciliationID = Balances.RecId and Reconciliations_Balances.CCY2Code = Balances.CCY2Code
		select @ErrorVar=@@error
		if(@ErrorVar<>0)
		Begin
			set @IsError=1
			set @Error_Code = @ErrorVar
			set @Error_TTPKID = 0
			set @Error_QueryCode = 'Updating CCY2 records in Reconciliation_Balances for accounts reconcilied individually '
			GOTO ExitPoint
		end
		print 'Finished Updating Reconciliation_Balances for CCY2Code for accounts reconcilied individually: ' + Convert(varchar,getDate())
	
		print 'Beginning Updating Reconciliation_Balances for CCY3Code for accounts reconcilied individually: ' + Convert(varchar,getDate())
		Update Reconciliations_Balances set CCY3GLEndBalance = Balances.SumCCY3GLEndBalance,CCY3GLActivity=Balances.SumCCY3GLEndBalance-IsNull(CCY3GLBegBalance,0)
		From Reconciliations_Balances
		 join (
			SELECT GLHistory.AccountId, GLHistory.CCY3Code, GLHistory.EffectiveDate, Reconciliations.PKId AS RecId,SUM(IsNULL(GLHistory.CCY3GLEndBalance,0)) as SumCCY3GLEndBalance  
			FROM GLHistory 
			join Reconciliations
				on GLHistory.AccountId = Reconciliations.AccountId
					and GLHistory.EffectiveDate = Reconciliations.EffectiveDate
			where GLHistory.BalanceChange=1
			group by 
				GLHistory.AccountId, GLHistory.CCY3Code, GLHistory.EffectiveDate, Reconciliations.PKId ) as Balances
		on Reconciliations_Balances.ReconciliationID = Balances.RecId and Reconciliations_Balances.CCY3Code = Balances.CCY3Code
		select @ErrorVar=@@error
		if(@ErrorVar<>0)
		Begin
			set @IsError=1
			set @Error_Code = @ErrorVar
			set @Error_TTPKID = 0
			set @Error_QueryCode = 'Updating CCY3 records in Reconciliation_Balances for accounts reconcilied individually'
			GOTO ExitPoint
		end
		print 'Finished Updating Reconciliation_Balances for CCY3Code for accounts reconcilied individually: ' + Convert(varchar,getDate())	
		
		print 'Beginning Insert new Reconciliation Balance (CCY1Code) for accounts reconcilied individually: ' + Convert(varchar,getDate())
		Insert into Reconciliations_Balances (ReconciliationID,CCY1Code,CCY1GLEndBalance,CCY1GLActivity)
		SELECT Reconciliations.PKId AS RecId, GLHistory.CCY1Code, SUM(IsNULL(GLHistory.CCY1GLEndBalance,0)), SUM(IsNULL(GLHistory.CCY1GLEndBalance,0))
			FROM GLHistory 
				join Reconciliations
					on GLHistory.AccountId = Reconciliations.AccountId
					and GLHistory.EffectiveDate = Reconciliations.EffectiveDate
					where GLHistory.BalanceChange=1 and (Select Count(Reconciliations_Balances.PKId) from Reconciliations_Balances 
															where Reconciliations_Balances.ReconciliationId = Reconciliations.PKId and																											
															Reconciliations_Balances.CCY1Code = GLHistory.CCY1Code)=0 and GLHistory.CCY1Code is not null and Reconciliations.CCY1GenerateBalance = 1
			group by 
				GLHistory.AccountId, GLHistory.CCY1Code, GLHistory.EffectiveDate, Reconciliations.PKId
		select @ErrorVar=@@error
		if(@ErrorVar<>0)
		Begin
			set @IsError=1
			set @Error_Code = @ErrorVar
			set @Error_TTPKID = 0
			set @Error_QueryCode = 'Insert new Reconciliation Balance (CCY1Code) for accounts reconcilied individually '
			GOTO ExitPoint
		end
		print 'Finished Insert new Reconciliation Balance (CCY1Code) for accounts reconcilied individually: ' + Convert(varchar,getDate())
	
		print 'Beginning Insert new Reconciliation Balance (CCY2Code) for accounts reconcilied individually: ' + Convert(varchar,getDate())
		Insert into Reconciliations_Balances (ReconciliationID,CCY2Code,CCY2GLEndBalance,CCY2GLActivity)
		SELECT Reconciliations.PKId AS RecId, GLHistory.CCY2Code, SUM(IsNULL(GLHistory.CCY2GLEndBalance,0)), SUM(IsNULL(GLHistory.CCY2GLEndBalance,0))
			FROM GLHistory 
				join Reconciliations
					on GLHistory.AccountId = Reconciliations.AccountId
					and GLHistory.EffectiveDate = Reconciliations.EffectiveDate
					where GLHistory.BalanceChange=1 and (Select Count(Reconciliations_Balances.PKId) from Reconciliations_Balances 
															where Reconciliations_Balances.ReconciliationId = Reconciliations.PKId and																											
															Reconciliations_Balances.CCY2Code = GLHistory.CCY2Code)=0 and GLHistory.CCY2Code is not null and Reconciliations.CCY2GenerateBalance = 1
			group by 
				GLHistory.AccountId, GLHistory.CCY2Code, GLHistory.EffectiveDate, Reconciliations.PKId
		select @ErrorVar=@@error
		if(@ErrorVar<>0)
		Begin
			set @IsError=1
			set @Error_Code = @ErrorVar
			set @Error_TTPKID = 0
			set @Error_QueryCode = 'Insert new Reconciliation Balance (CCY2Code) for accounts reconcilied individually '
			GOTO ExitPoint
		end
		print 'Finished Insert new Reconciliation Balance (CCY2Code) for accounts reconcilied individually: ' + Convert(varchar,getDate())
	
		print 'Beginning Insert new Reconciliation Balance (CCY3Code) for accounts reconcilied individually: ' + Convert(varchar,getDate())
		Insert into Reconciliations_Balances (ReconciliationID,CCY3Code,CCY3GLEndBalance,CCY3GLActivity)
		SELECT Reconciliations.PKId AS RecId, GLHistory.CCY3Code, SUM(IsNULL(GLHistory.CCY3GLEndBalance,0)), SUM(IsNULL(GLHistory.CCY3GLEndBalance,0))
			FROM GLHistory 
				join Reconciliations
					on GLHistory.AccountId = Reconciliations.AccountId
					and GLHistory.EffectiveDate = Reconciliations.EffectiveDate
					where GLHistory.BalanceChange=1 and (Select Count(Reconciliations_Balances.PKId) from Reconciliations_Balances 
															where Reconciliations_Balances.ReconciliationId = Reconciliations.PKId and																											
															Reconciliations_Balances.CCY3Code = GLHistory.CCY3Code)=0 and GLHistory.CCY3Code is not null and Reconciliations.CCY3GenerateBalance = 1
			group by 
				GLHistory.AccountId, GLHistory.CCY3Code, GLHistory.EffectiveDate, Reconciliations.PKId
		select @ErrorVar=@@error
		if(@ErrorVar<>0)
		Begin
			set @IsError=1
			set @Error_Code = @ErrorVar
			set @Error_TTPKID = 0
			set @Error_QueryCode = 'Insert new Reconciliation Balance (CCY3Code) for accounts reconcilied individually '
			GOTO ExitPoint
		end
		print 'Finished Insert new Reconciliation Balance (CCY3Code) for accounts reconcilied individually: ' + Convert(varchar,getDate())
		
		print 'Beginning Updating PendingBalanceUpdate for reconciliations with a balance change and reconcilied individually: ' + Convert(varchar,getDate())
		Update Reconciliations set PendingBalanceUpdate=1
		where PKId in (
			Select Reconciliations.PKId from Reconciliations
			join GLHistory on Reconciliations.AccountId = GLHIstory.AccountId
								and Reconciliations.EffectiveDate = GLHIstory.EffectiveDate
			where GLHistory.BalanceChange=1)
		select @ErrorVar=@@error
		if(@ErrorVar<>0)
		Begin
			set @IsError=1
			set @Error_Code = @ErrorVar
			set @Error_TTPKID = 0
			set @Error_QueryCode = 'Updating PendingBalanceUpdate for reconciliations with a balance change '
			GOTO ExitPoint
		end
		print 'Finished Updating PendingBalanceUpdate for reconciliations with a balance change and reconcilied individually: ' + Convert(varchar,getDate())
	
	--Group Logic
		print 'Beginning Updating PendingBalanceUpdate for reconciliations with a balance change and reconcilied as a group: ' + Convert(varchar,getDate())
		Update Reconciliations Set PendingBalanceUpdate=1
		where PKId in (
			Select RecGroupMembers.RecId from GLHistory
			join 
			(select Reconciliations.PKId as RecId,Reconciliations.AccountId as ParentAccount,		Reconciliations.EffectiveDate,Reconciliations_groupMembers.AccountId as ChildAccount
			from Reconciliations
				join Reconciliations_groupMembers
				on Reconciliations_groupMembers.ReconciliationId = Reconciliations.PKId) as	RecGroupMembers
			on GLHistory.EffectiveDate = RecGroupMembers.EffectiveDate
			and GLHistory.AccountId = RecGroupMembers.ChildAccount
	where GLHistory.BalanceChange=1)
		select @ErrorVar=@@error
		if(@ErrorVar<>0)
		Begin
			set @IsError=1
			set @Error_Code = @ErrorVar
			set @Error_TTPKID = 0
			set @Error_QueryCode = 'Updating PendingBalanceUpdate for reconciliations with a balance change '
			GOTO ExitPoint
		end
		print 'Finished Updating PendingBalanceUpdate for reconciliations with a balance change and reconcilied as a group: ' + Convert(varchar,getDate())
	
		print 'Beginning Updating Reconciliation_Balances for CCY1Code for accounts reconcilied at the group level: ' + Convert(varchar,getDate())
		Update Reconciliations_Balances set CCY1GLEndBalance = Balances.SumCCY1GLEndBalance,CCY1GLActivity=Balances.SumCCY1GLEndBalance-IsNull(CCY1GLBegBalance,0)
		From Reconciliations_Balances
		 join (
			Select Reconciliations.PKId as RecId, GLHistory.CCY1Code, SUM(IsNULL(GLHistory.CCY1GLEndBalance,0)) as SumCCY1GLEndBalance
			from Reconciliations
			join Accounts 
				on Reconciliations.AccountId = Accounts.PKId
			join Reconciliations_groupMembers on Reconciliations.PKId = Reconciliations_groupMembers.ReconciliationId
			join GLHistory on Reconciliations.EffectiveDate = GLHistory.EffectiveDate
						   and GLHistory.AccountId = Reconciliations_groupMembers.AccountId
			where PendingBalanceUpdate=1 and Accounts.IsGroup=1 and GLHistory.CCY1Code is not null
			group by Reconciliations.PKId,GLHistory.CCY1Code) as Balances
	on Reconciliations_Balances.ReconciliationID = Balances.RecId and Reconciliations_Balances.CCY1Code = Balances.CCY1Code
		select @ErrorVar=@@error
		if(@ErrorVar<>0)
		Begin
			set @IsError=1
			set @Error_Code = @ErrorVar
			set @Error_TTPKID = 0
			set @Error_QueryCode = 'Updating CCY1 records in Reconciliation_Balances for accounts reconcilied at the group level '
			GOTO ExitPoint
		end
		print 'Finished Updating Reconciliation_Balances for CCY1Code for accounts reconcilied at the group level: ' + Convert(varchar,getDate())
		
	
		print 'Beginning Updating Reconciliation_Balances for CCY2Code for accounts reconcilied at the group level: ' + Convert(varchar,getDate())
		Update Reconciliations_Balances set CCY2GLEndBalance = Balances.SumCCY2GLEndBalance,CCY2GLActivity=Balances.SumCCY2GLEndBalance-IsNull(CCY2GLBegBalance,0)
		From Reconciliations_Balances
		 join (
			Select Reconciliations.PKId as RecId, GLHistory.CCY2Code, SUM(IsNULL(GLHistory.CCY2GLEndBalance,0)) as SumCCY2GLEndBalance
			from Reconciliations
			join Accounts 
				on Reconciliations.AccountId = Accounts.PKId
			join Reconciliations_groupMembers on Reconciliations.PKId = Reconciliations_groupMembers.ReconciliationId
			join GLHistory on Reconciliations.EffectiveDate = GLHistory.EffectiveDate
						   and GLHistory.AccountId = Reconciliations_groupMembers.AccountId
			where PendingBalanceUpdate=1 and Accounts.IsGroup=1 and GLHistory.CCY2Code is not null
			group by Reconciliations.PKId,GLHistory.CCY2Code) as Balances
	on Reconciliations_Balances.ReconciliationID = Balances.RecId and Reconciliations_Balances.CCY2Code = Balances.CCY2Code
		select @ErrorVar=@@error
		if(@ErrorVar<>0)
		Begin
			set @IsError=1
			set @Error_Code = @ErrorVar
			set @Error_TTPKID = 0
			set @Error_QueryCode = 'Updating CCY2 records in Reconciliation_Balances for accounts reconcilied at the group level '
			GOTO ExitPoint
		end
		print 'Finished Updating Reconciliation_Balances for CCY2Code for accounts reconcilied at the group level: ' + Convert(varchar,getDate()) 
	
		print 'Beginning Updating Reconciliation_Balances for CCY3Code for accounts reconcilied at the group level: ' + Convert(varchar,getDate())
		Update Reconciliations_Balances set CCY3GLEndBalance = Balances.SumCCY3GLEndBalance,CCY3GLActivity=Balances.SumCCY3GLEndBalance-IsNull(CCY3GLBegBalance,0)
		From Reconciliations_Balances
		 join (
			Select Reconciliations.PKId as RecId, GLHistory.CCY3Code, SUM(IsNULL(GLHistory.CCY3GLEndBalance,0)) as SumCCY3GLEndBalance
			from Reconciliations
			join Accounts 
				on Reconciliations.AccountId = Accounts.PKId
			join Reconciliations_groupMembers on Reconciliations.PKId = Reconciliations_groupMembers.ReconciliationId
			join GLHistory on Reconciliations.EffectiveDate = GLHistory.EffectiveDate
						   and GLHistory.AccountId = Reconciliations_groupMembers.AccountId
			where PendingBalanceUpdate=1 and Accounts.IsGroup=1 and GLHistory.CCY3Code is not null
			group by Reconciliations.PKId,GLHistory.CCY3Code) as Balances
	on Reconciliations_Balances.ReconciliationID = Balances.RecId and Reconciliations_Balances.CCY3Code = Balances.CCY3Code
		select @ErrorVar=@@error
		if(@ErrorVar<>0)
		Begin
			set @IsError=1
			set @Error_Code = @ErrorVar
			set @Error_TTPKID = 0
			set @Error_QueryCode = 'Updating CCY3 records in Reconciliation_Balances for accounts reconcilied at the group level '
			GOTO ExitPoint
		end
		print 'Finished Updating Reconciliation_Balances for CCY3Code for accounts reconcilied at the group level: ' + Convert(varchar,getDate())
	
		print 'Beginning Insert Reconciliation_Balances for CCY1Code for accounts reconcilied at the group level: ' + Convert(varchar,getDate())
		Insert into Reconciliations_Balances (ReconciliationID,CCY1Code,CCY1GLEndBalance,CCY1GLActivity)
			Select Reconciliations.PKId as RecId, GLHistory.CCY1Code, SUM(IsNULL(GLHistory.CCY1GLEndBalance,0)), SUM(IsNULL(GLHistory.CCY1GLEndBalance,0))
			from Reconciliations
			join Accounts 
				on Reconciliations.AccountId = Accounts.PKId
			join Reconciliations_groupMembers on Reconciliations.PKId = Reconciliations_groupMembers.ReconciliationId
			join GLHistory on Reconciliations.EffectiveDate = GLHistory.EffectiveDate
						   and GLHistory.AccountId = Reconciliations_groupMembers.AccountId
			where PendingBalanceUpdate=1 and Accounts.IsGroup=1 and GLHistory.CCY1Code is not null and (Select Count(Reconciliations_Balances.PKId) from Reconciliations_Balances 
															where Reconciliations_Balances.ReconciliationId = Reconciliations.PKId and																											
															Reconciliations_Balances.CCY1Code = GLHistory.CCY1Code)=0 and GLHistory.CCY1Code is not null and Reconciliations.CCY1GenerateBalance = 1
			group by Reconciliations.PKId,GLHistory.CCY1Code
		select @ErrorVar=@@error
		if(@ErrorVar<>0)
		Begin
			set @IsError=1
			set @Error_Code = @ErrorVar
			set @Error_TTPKID = 0
			set @Error_QueryCode = 'Insert CCY1 records in Reconciliation_Balances for accounts reconcilied at the group level '
			GOTO ExitPoint
		end
		print 'Finished Insert Reconciliation_Balances for CCY1Code for accounts reconcilied at the group level: ' + Convert(varchar,getDate())
	
		print 'Beginning Insert Reconciliation_Balances for CCY2Code for accounts reconcilied at the group level: ' + Convert(varchar,getDate())
		Insert into Reconciliations_Balances (ReconciliationID,CCY2Code,CCY2GLEndBalance,CCY2GLActivity)
			Select Reconciliations.PKId as RecId, GLHistory.CCY2Code, SUM(IsNULL(GLHistory.CCY2GLEndBalance,0)), SUM(IsNULL(GLHistory.CCY2GLEndBalance,0))
			from Reconciliations
			join Accounts 
				on Reconciliations.AccountId = Accounts.PKId
			join Reconciliations_groupMembers on Reconciliations.PKId = Reconciliations_groupMembers.ReconciliationId
			join GLHistory on Reconciliations.EffectiveDate = GLHistory.EffectiveDate
						   and GLHistory.AccountId = Reconciliations_groupMembers.AccountId
			where PendingBalanceUpdate=1 and Accounts.IsGroup=1 and GLHistory.CCY2Code is not null and (Select Count(Reconciliations_Balances.PKId) from Reconciliations_Balances 
															where Reconciliations_Balances.ReconciliationId = Reconciliations.PKId and																											
															Reconciliations_Balances.CCY2Code = GLHistory.CCY2Code)=0 and GLHistory.CCY2Code is not null and Reconciliations.CCY2GenerateBalance = 1
			group by Reconciliations.PKId,GLHistory.CCY2Code
		select @ErrorVar=@@error
		if(@ErrorVar<>0)
		Begin
			set @IsError=1
			set @Error_Code = @ErrorVar
			set @Error_TTPKID = 0
			set @Error_QueryCode = 'Insert CCY2 records in Reconciliation_Balances for accounts reconcilied at the group level '
			GOTO ExitPoint
		end
		print 'Finished Insert Reconciliation_Balances for CCY2Code for accounts reconcilied at the group level: ' + Convert(varchar,getDate())
	
		print 'Beginning Insert Reconciliation_Balances for CCY3Code for accounts reconcilied at the group level: ' + Convert(varchar,getDate())
		Insert into Reconciliations_Balances (ReconciliationID,CCY3Code,CCY3GLEndBalance,CCY3GLActivity)
			Select Reconciliations.PKId as RecId, GLHistory.CCY3Code, SUM(IsNULL(GLHistory.CCY3GLEndBalance,0)), SUM(IsNULL(GLHistory.CCY3GLEndBalance,0))
			from Reconciliations
			join Accounts 
				on Reconciliations.AccountId = Accounts.PKId
			join Reconciliations_groupMembers on Reconciliations.PKId = Reconciliations_groupMembers.ReconciliationId
			join GLHistory on Reconciliations.EffectiveDate = GLHistory.EffectiveDate
						   and GLHistory.AccountId = Reconciliations_groupMembers.AccountId
			where PendingBalanceUpdate=1 and Accounts.IsGroup=1 and GLHistory.CCY3Code is not null and (Select Count(Reconciliations_Balances.PKId) from Reconciliations_Balances 
															where Reconciliations_Balances.ReconciliationId = Reconciliations.PKId and																											
															Reconciliations_Balances.CCY3Code = GLHistory.CCY3Code)=0 and GLHistory.CCY3Code is not null and Reconciliations.CCY3GenerateBalance = 1 
			group by Reconciliations.PKId,GLHistory.CCY3Code
		select @ErrorVar=@@error
		if(@ErrorVar<>0)
		Begin
			set @IsError=1
			set @Error_Code = @ErrorVar
			set @Error_TTPKID = 0
			set @Error_QueryCode = 'Insert CCY3 records in Reconciliation_Balances for accounts reconcilied at the group level '
			GOTO ExitPoint
		end
		print 'Finished Insert Reconciliation_Balances for CCY3Code for accounts reconcilied at the group level: ' + Convert(varchar,getDate())
	
		---***************************************************Reconciliation History Balance Update Event *******************************************************---
		print 'Beginning Insert Reconciliations_History for completed reconciliation: ' + Convert(varchar,getDate())
		INSERT INTO Reconciliations_History (ReconciliationID, StatusDate, UserID, Type, StatusDetails)
						(SELECT PKID, getdate(), null, 'BU', dbo.fnGetApprovalStatusForInterfaceService(PKID) + dbo.fnGetReviewStatusForInterfaceService(PKID) + dbo.fnGetReconStatusForInterfaceService(PKID) 
						FROM Reconciliations 
						WHERE PendingBalanceUpdate=1 AND ReconciliationStatusID='C')
			select @ErrorVar=@@error
			IF (@ErrorVar<>0)
			BEGIN
				
				set @IsError=1
				set @Error_Code = @ErrorVar
				set @Error_TTPKID='0'
				set @Error_QueryCode = 'Inserting new records into Reconciliations_History for completed reconciliation'
				GOTO ExitPoint
				
			END
			print 'Finished Insert Reconciliations_History for completed reconciliation: ' + Convert(varchar,getDate())
		
			print 'Beginning updating ReviewStatusID = PRC of Reconciliations: ' + Convert(varchar,getDate())
			UPDATE Reconciliations SET ReviewStatusID='PRC' WHERE PendingBalanceUpdate =1 AND ReviewStatusID is not null and ReviewStatusId <> 'R' and ReconciliationStatusID='C'
			select @ErrorVar=@@error
			IF (@ErrorVar<>0)
			BEGIN
				set @IsError=1
				set @Error_Code = @ErrorVar
				set @Error_TTPKID='0'
				set @Error_QueryCode = 'Updating ReviewStatusID = PRC of Reconciliations '
				GOTO ExitPoint
			END
			print 'Finished updating ReviewStatusID = PRC of Reconciliations: ' + Convert(varchar,getDate())
		
			print 'Beginning updating ApprovalStatusID = PRC of Reconciliations: ' + Convert(varchar,getDate())
			UPDATE Reconciliations SET ApprovalStatusID='PRC' WHERE PendingBalanceUpdate =1 AND ApprovalStatusID is not null and ApprovalStatusId <> 'R' and ReconciliationStatusID='C'
			select @ErrorVar=@@error
			IF (@ErrorVar<>0)
			BEGIN
				set @IsError=1
				set @Error_Code = @ErrorVar
				set @Error_TTPKID='0'
				set @Error_QueryCode = 'Updating ApprovalStatusID = PRC of Reconciliations '
				GOTO ExitPoint
			END
			print 'Finished updating ApprovalStatusID = PRC of Reconciliations: ' + Convert(varchar,getDate())
		
			print 'Beginning Updating ReconcilerID=null, DateReviewed=null, ReviewerID=null, DateApproved=null, ApproverID=null of Reconciliations , ReconciliationStatusID=PM, PendingBalanceUpdate=0: ' + Convert(varchar,getDate())
			UPDATE Reconciliations SET DateReconciled= null, 
				ReconcilerID=null, 
				DateReviewed=null, 
				ReviewerID=null,
				DateApproved=null,
				ApproverID=null,
				ReconciliationStatusID='PM',
				PendingBalanceUpdate =0
			WHERE PendingBalanceUpdate =1 and ReconciliationStatusID='C'
			select @ErrorVar=@@error
			IF (@ErrorVar<>0)
			BEGIN
				set @IsError=1
				set @Error_Code = @ErrorVar
				set @Error_TTPKID='0'
				set @Error_QueryCode = 'Updating ReconcilerID=null, DateReviewed=null, ReviewerID=null, DateApproved=null, ApproverID=null of Reconciliations , ReconciliationStatusID=PM, PendingBalanceUpdate =0'
				GOTO ExitPoint
			END	
			print 'Finished Updating ReconcilerID=null, DateReviewed=null, ReviewerID=null, DateApproved=null, ApproverID=null of Reconciliations , ReconciliationStatusID=PM, PendingBalanceUpdate=0: ' + Convert(varchar,getDate())
		
			print 'Beginning Inserting new records into Reconciliations_History for non-completed reconciliation' + Convert(varchar,getDate())
			INSERT INTO Reconciliations_History (ReconciliationID, StatusDate, UserID, Type, StatusDetails)
						(SELECT PKID, getdate(), null, 'BU', 'Balance Updated' FROM Reconciliations WHERE PendingBalanceUpdate=1 AND ReconciliationStatusID<>'C')
			select @ErrorVar=@@error
			IF (@ErrorVar<>0)
			BEGIN
				set @IsError=1
				set @Error_Code = @ErrorVar
				set @Error_TTPKID='0'
				set @Error_QueryCode = 'Inserting new records into Reconciliations_History for non-completed reconciliation '
				GOTO ExitPoint
			END
			print 'Finished Inserting new records into Reconciliations_History for non-completed reconciliation' + Convert(varchar,getDate())
			
			print 'Beginning Recalc Balances' + Convert(varchar,getDate())
				Declare @ReconciliationId int
				Declare ReconciliationCursor cursor FOR
					select PKId from Reconciliations where PendingBalanceUpdate=1
				OPEN ReconciliationCursor 
				FETCH NEXT FROM ReconciliationCursor INTO @ReconciliationId
				WHILE @@Fetch_Status = 0
				begin
					exec usp_UpdateUnexplainedDiff @ReconciliationId
					FETCH NEXT FROM ReconciliationCursor INTO @ReconciliationId
				end
				
				CLOSE ReconciliationCursor				
				DEALLOCATE ReconciliationCursor
			print 'Finished Recalc Balances' + Convert(varchar,getDate())
		
			print 'Beginning Updating PendingBalanceUpdate =0 of Reconciliations' + Convert(varchar,getDate())
			UPDATE Reconciliations SET PendingBalanceUpdate=0 WHERE PendingBalanceUpdate=1
			--IF ANY ERROR OCCURED
			select @ErrorVar=@@error
			IF (@ErrorVar<>0)
			BEGIN
				set @IsError=1
				set @Error_Code = @ErrorVar
				set @Error_TTPKID='0'
				set @Error_QueryCode = 'Updating PendingBalanceUpdate =0 of Reconciliations '
				GOTO ExitPoint
			END
			print 'Updating PendingBalanceUpdate =0 of Reconciliations' + Convert(varchar,getDate())
			
			print 'Beginning Reset BalanceUpdate Flag: ' + Convert(varchar,getDate())
			UPDATE GLHistory SET BalanceChange=0 where BalanceChange=1
			SELECT @ErrorVar = @@ERROR	
			IF (@ErrorVar<>0)	-- Error executing sql
			BEGIN
				set @IsError=1
				set @Error_Code = @ErrorVar
				set @Error_TTPKID = 0
				set @Error_QueryCode = 'Resetting BalanceUpdate Flag '
				GOTO ExitPoint
			END
			print 'Finished Reset BalanceUpdate Flag: ' + Convert(varchar,getDate())
		
		
		
		
		---******************************************************************************************************************************************************---
		
		ValidationExitPoint:
			if(@Result<0)
			begin
				print 'Exiting with error code: ' + Convert(varchar,@Result)
				exec usp_AddToInterfaceHistory @InterfaceHistoryPKId,@InterfaceID,@CurrentDt,3,0,0,0,1,@StartTime,@CurrentDt,null,null
				if(@Error_QueryCode is not null)
					RAISERROR (@Error_QueryCode, 16, 1)
				else
					RAISERROR ('Validation Error.', 16, 1)
				return
			end
		
		ExitPoint:
		if (@IsError=1)
			BEGIN
				Print 'rolledback'
				--Create Interface Error TAble
				--I changed the Error table name 'EventManagementNotes_Error' to 'InterfaceService_Error' to keep consistency
				ROLLBACK TRAN
			 	if not exists (select * from dbo.sysobjects where id = object_id(N'[InterfaceService_Error]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
			 		CREATE TABLE [dbo].[InterfaceService_Error](PKID int IDENTITY(1,1), ErrorDate DateTime, TempTablePKID varchar(100), ErrorCode int, ErrorQueryCode varchar(500),InterfaceID int) 
				INSERT INTO Interfaces_Error(ErrorDate, TempTablePKID , ErrorCode, ErrorQueryCode, InterfaceID,InterfaceHistoryPKId) VALUES(GetDate(), IsNULL(@Error_TTPKID,0), @Error_Code, @Error_QueryCode, @InterfaceID,@InterfaceHistoryPKId )
				--all inserted and updated records have been rollback so all of these variable should be zero
				set @TotalRecs =0
				set @TotalInserted = 0
				set @TotalUpdated = 0
				Set @EndTime = GetDate()
				exec usp_AddToInterfaceHistory @InterfaceHistoryPKId,@InterfaceID,@CurrentDt,3,@TotalRecs, @TotalInserted, @TotalUpdated,0, @StartTime,@EndTime,null,null
				if(@Error_QueryCode is not null and @Error_QueryCode != null)
					RAISERROR (@Error_QueryCode, 16, 1)
				else
					RAISERROR ('Undeffined Error', 16, 1)
			END
		else
		BEGIN
			COMMIT TRAN
			SET @TotalRecs = @TotalInserted + @TotalUpdated
			Set @EndTime = GetDate()
			exec usp_AddToInterfaceHistory @InterfaceHistoryPKId,@InterfaceID,@CurrentDt,1,@TotalRecs, @TotalInserted, @TotalUpdated,0, @StartTime,@EndTime,null,null
		END

GO

/****** Object:  StoredProcedure [dbo].[TOOLKIT_PopulateAll]    Script Date: 2/5/2016 4:00:16 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*****************************************************************************************************
 *  TOOLKIT_PopulateAll procedure:                                                                   *
 *  PURPOSE: Generic procedure to run the other toolkit procedures in order to build a database.     *
 *  INSTRUCTIONS:                                                                                    *
 *       1.) Modify the procedure to fit your data needs.                                            *
 *       2.) Run the procedure to build the database.                                                *
 *****************************************************************************************************/

CREATE PROCEDURE [dbo].[TOOLKIT_PopulateAll]
AS
	--Build variable for today's date. May not be used.
	DECLARE @Now datetime
	SET @Now = GetDate()
	
	/* If you are using a blank database, you will need to put in some master date first. If master data already exists, you can comment this call. */
	PRINT '**Populating: Master Data**'
	EXEC TOOLKIT_PopulateMasterData
	
	/* If you are using a blank database, you will need schedules for accounts and recs. If you have schedules already, you can comment this call. */
	/* --> Modify the parameters as necessary to give the first schedule day and the number of years forward from that day to create. */
	PRINT '**Populating: Schedules**'
	EXEC TOOLKIT_PopulateSchedules '20080131',3
	
	/* If you are using a blank database, you will need users for accounts and recs. If you have users already, you can comment this call. */
	/* --> Modify the parameters as necessary to give the number of: Reconcilers, Reviewers, Approvers, Admins, and QA */
	PRINT '**Populating: Users**'
	EXEC TOOLKIT_BuildTestUsers 10,10,10,0,10
	
	/* The following section is for populating accounts. */
	PRINT '**Populating: Accounts**'
	EXEC TOOLKIT_BuildTestAccountsWithPrefix 'TestAccount',3000,0
	EXEC TOOLKIT_BuildGroups 100,10
	EXEC TOOLKIT_BuildGroups 10,200
	
	/* Populate FX Rates if Necessary. */
	PRINT '**Populating: Rates**'
	EXEC TOOLKIT_PopulateRates
	
	/* Set the Starting Date */
	PRINT '**Resetting Next Dates**'
	EXEC TOOLKIT_SetEffectiveDate '20080128'
	
	/* The following section is for populating balances */
	PRINT '**Generating Balances**'
	EXEC TOOLKIT_BuildBalanceHistory '20080128','20100128'
	
	/* The following section is for automatically generating reconciliations */
	PRINT '**Generating Reconciliations**'
	EXEC TOOLKIT_BuildHistory '20080128','20100128'

GO

/****** Object:  StoredProcedure [dbo].[TOOLKIT_PopulateMasterData]    Script Date: 2/5/2016 4:00:16 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/**************************************************************************************
 *  TOOLKIT_PopulateMasterData procedure:                                             *
 *	PURPOSE: Creates some generic master data in the system.                          *
 *  INSTRUCTIONS:                                                                     *
 *       1.) If you are using a blank database, you will need master data.            *
 *           a.) Modify as Necessary                                                  *
 *           b.) Run the Procedure Prior to Accounts/Users                            *
 *       2.) If you are using a populated database, you may not need to run this.     *
 **************************************************************************************/

CREATE PROCEDURE [dbo].[TOOLKIT_PopulateMasterData]
AS
	--ACCOUNT TYPES
	--SELECT * FROM Code_AccountTypes
	INSERT INTO Code_AccountTypes ([Code],[Name],[Description],DebitBalance,CoreType) VALUES ('DEBIT','Debit Acct','Debit Account Type',1,'RT')
	INSERT INTO Code_AccountTypes ([Code],[Name],[Description],DebitBalance,CoreType) VALUES ('CREDIT','Credit Acct','Credit Account Type',0,'RT')

	--RECONCILIATION RESULTS
	--SELECT * FROM Code_ReconciliationResults
	INSERT INTO Code_ReconciliationResults ([Code],[Name],[Description],Pass,CoreType) VALUES ('PASS','Pass','Pass',1,'RT')
	INSERT INTO Code_ReconciliationResults ([Code],[Name],[Description],Pass,CoreType) VALUES ('FAIL','Fail','Fail',0,'RT')

	--REVIEW RESULTS
	--SELECT * FROM Code_ReviewResults
	INSERT INTO Code_ReviewResults ([Code],[Name],[Description],Pass,CoreType) VALUES ('PASS','Pass','Pass',1,'RT')
	INSERT INTO Code_ReviewResults ([Code],[Name],[Description],Pass,CoreType) VALUES ('FAIL','Fail','Fail',0,'RT')

	--APPROVAL RESULTS
	--SELECT * FROM Code_ApprovalResults
	INSERT INTO Code_ApprovalResults ([Code],[Name],[Description],Pass,CoreType) VALUES ('PASS','Pass','Pass',1,'RT')
	INSERT INTO Code_ApprovalResults ([Code],[Name],[Description],Pass,CoreType) VALUES ('FAIL','Fail','Fail',0,'RT')

	--CLEARING STANDARDS
	--SELECT * FROM Code_ClearingStandards
	INSERT INTO Code_ClearingStandards ([Code],[Name],[description]) VALUES ('Standard1','Standard 1','Standard 1')
	INSERT INTO Code_ClearingStandards ([Code],[Name],[description]) VALUES ('Standard2','Standard 2','Standard 2')

	--CURRENCIES
	--SELECT * FROM Code_Currencies
	INSERT INTO Code_Currencies ([Code],[Name],[Description]) VALUES ('AUD','AUD','Australia, Dollars')
	INSERT INTO Code_Currencies ([Code],[Name],[Description]) VALUES ('CAD','CAD','Canada, Dollars')
	INSERT INTO Code_Currencies ([Code],[Name],[Description]) VALUES ('GBP','GBP','United Kingdom, Pounds')
	INSERT INTO Code_Currencies ([Code],[Name],[Description]) VALUES ('MXN','MXN','Mexico, Pesos')
	INSERT INTO Code_Currencies ([Code],[Name],[Description]) VALUES ('MYR','MYR','Malaysia, Ringgits')
	INSERT INTO Code_Currencies ([Code],[Name],[Description]) VALUES ('USD','USD','United States of America, Dollars')
	INSERT INTO Code_Currencies ([Code],[Name],[Description]) VALUES ('BRL','BRL','Brazil, Brazil Real')
	INSERT INTO Code_Currencies ([Code],[Name],[Description]) VALUES ('EUR','EUR','Euro Member Countries, Euro')
	

	--DEPARTMENTS
	--SELECT * FROM Code_Departments
	INSERT INTO Code_Departments ([Code],[Name],[Description]) VALUES ('NAR','North American Region','North American Region')
	INSERT INTO Code_Departments ([Code],[Name],[Description]) VALUES ('LAR','Latin American Region','Latin American Region')
	INSERT INTO Code_Departments ([Code],[Name],[Description]) VALUES ('EMEA','East, Middle East, and Asian Region','East, Middle East, and Asian Region')

	--FILE CLASSIFICATIONS
	--SELECT * FROM Code_FileClassifications
	INSERT INTO Code_FileClassifications ([Code],[Name],[Description],[CoreType]) VALUES ('R','Reconciliation','Reconciliation','RT')
	INSERT INTO Code_FileClassifications ([Code],[Name],[Description],[CoreType]) VALUES ('S','Support','Support','RT')

	--LOCATIONS
	--SELECT * FROM Code_Locations
	INSERT INTO Code_Locations ([Code],[Name],[Description],DocPath,FunctionalCCY,UserFlg,AccountFlg) VALUES ('US','United States','United States','C:\','USD',1,1)
	INSERT INTO Code_Locations ([Code],[Name],[Description],DocPath,FunctionalCCY,UserFlg,AccountFlg) VALUES ('MX','Mexico','Mexico','C:\','MXN',1,1)
	INSERT INTO Code_Locations ([Code],[Name],[Description],DocPath,FunctionalCCY,UserFlg,AccountFlg) VALUES ('BR','Brazil','Brazil','C:\','BRL',1,1)
	INSERT INTO Code_Locations ([Code],[Name],[Description],DocPath,FunctionalCCY,UserFlg,AccountFlg) VALUES ('CA','Canada','Canada','C:\','CAD',1,1)
	INSERT INTO Code_Locations ([Code],[Name],[Description],DocPath,FunctionalCCY,UserFlg,AccountFlg) VALUES ('GB','United Kingdom','United Kingdom','C:\','GBP',1,1)
	INSERT INTO Code_Locations ([Code],[Name],[Description],DocPath,FunctionalCCY,UserFlg,AccountFlg) VALUES ('FR','France','France','C:\','EUR',1,1)
	INSERT INTO Code_Locations ([Code],[Name],[Description],DocPath,FunctionalCCY,UserFlg,AccountFlg) VALUES ('MY','Malaysia','Malaysia','C:\','MYR',1,1)

	--OWNERS
	--SELECT * FROM Code_Owners
	INSERT INTO Code_Owners ([Code],[Name],[Description]) VALUES ('USB','United States Branch','United States Branch')
	INSERT INTO Code_Owners ([Code],[Name],[Description]) VALUES ('MXB','Mexico Branch','Mexico Branch')
	INSERT INTO Code_Owners ([Code],[Name],[Description]) VALUES ('EAB','East Asian Branch','East Asian Branch')
	INSERT INTO Code_Owners ([Code],[Name],[Description]) VALUES ('EUB','European Branch','European Branch')

	--QA RESULTS
	--SELECT * FROM Code_QAResults
	INSERT INTO Code_QAResults ([Code],[Name],[Description],[CoreType]) VALUES ('PASS','Pass','Pass','RT')
	INSERT INTO Code_QAResults ([Code],[Name],[Description],[CoreType]) VALUES ('FAIL','Fail','Fail','RT')

	--QA RISK RATINGS
	--SELECT * FROM Code_QARiskRatings
	INSERT INTO Code_QARiskRatings ([Code],[Name],[Description],[CoreType]) VALUES ('HIGH','High','High','RT')
	INSERT INTO Code_QARiskRatings ([Code],[Name],[Description],[CoreType]) VALUES ('LOW','Low','Low','RT')
	INSERT INTO Code_QARiskRatings ([Code],[Name],[Description],[CoreType]) VALUES ('MEDIUM','Medium','Medium','RT')

	--QA TEST CYCLES
	--SELECT * FROM Code_QATestCycles
	INSERT INTO Code_QATestCycles ([Code],[Name],[Description],[CoreType]) VALUES ('MONTHLY','Monthly','Monthly','RT')
	INSERT INTO Code_QATestCycles ([Code],[Name],[Description],[CoreType]) VALUES ('QUARTERLY','Quarterly','Quarterly','RT')
	INSERT INTO Code_QATestCycles ([Code],[Name],[Description],[CoreType]) VALUES ('ANUALLY','Anually','Anually','RT')

GO

/****** Object:  StoredProcedure [dbo].[TOOLKIT_PopulateRates]    Script Date: 2/5/2016 4:00:16 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/**********************************************************************************************************************************
 *  TOOLKIT_PopulateRates procedure:                                                                                              *
 *	PURPOSE: Creates 1 to 1 symetric random values for rates.                                                                     *
 *           This means that if USD -> CAD = X then CAD -> USD = 1/X                                                              *
 *  INSTRUCTIONS:                                                                                                                 *
 *       1.) If you are running FX conversion you will need rates                                                                 *
 *           a.) Run this proc (Warning, putting too many currencies in the system may cause this procedure to take a long time)  *
 *       2.) If you are not using FX conversion, you can ignore this procedure                                                    *
 **********************************************************************************************************************************/

CREATE PROCEDURE [dbo].[TOOLKIT_PopulateRates]
AS
	/* Delete Existing Rates */
	DELETE FROM RateDetails

	/* If no rate types exist, make at least one for processing. */
	IF ((SELECT COUNT(*) FROM Code_RateTypes) = 0)
		INSERT INTO Code_RateTypes ([Code],[Name],[Description]) VALUES ('RATE1','Rate 1','Rate Type 1')

	/* Create entries for every possible combinations of currency codes for every effective date (without self conversions) */
	INSERT INTO RateDetails
	SELECT 
		ef.EffectiveDate AS Date,
		CCYFrom.Code AS CCY1Code, 
		CCYTo.Code AS CCY2Code,
		0 AS Rate, 
		crt.Code AS RateTypeId 
	FROM Code_Currencies CCYFrom
		CROSS JOIN Code_Currencies CCYTo
		CROSS JOIN Code_RateTypes crt
		CROSS JOIN EffectiveDates ef
	WHERE CCYFrom.Code <> CCYTo.Code


	/************************************************************************************
	 * Go through and update rates to a random value, but when encountering an opposite *
	 * conversion that has already been updated, apply the inverse rate for symmetry.   *
	 ************************************************************************************/

	DECLARE RateCursor CURSOR
	FOR
	SELECT Date,CCY1Code,CCY2Code,Rate,RateTypeId FROM RateDetails

	OPEN RateCursor
	DECLARE @Date AS datetime
	DECLARE @CCYFrom AS varchar(3)
	DECLARE @CCYTo AS varchar(3)
	DECLARE @Rate AS float
	DECLARE @RateTypeId AS varchar(15)

	FETCH NEXT FROM RateCursor INTO @Date, @CCYFrom, @CCYTo, @Rate, @RateTypeId
	WHILE (@@FETCH_STATUS <> -1)
	BEGIN
		DECLARE @OppositeRate AS float
		DECLARE @NewRate AS float
		SET @NewRate = RAND()
		SELECT @OppositeRate = Rate FROM RateDetails WHERE Date = @Date AND RateTypeId = @RateTypeId AND CCY1Code = @CCYTo AND CCY2Code = @CCYFrom
		IF (@OppositeRate = 0)
			UPDATE RateDetails SET Rate=@NewRate WHERE Date = @Date AND RateTypeId = @RateTypeId AND CCY1Code = @CCYFrom AND CCY2Code = @CCYTo
		ELSE
			UPDATE RateDetails SET Rate=1/@OppositeRate WHERE Date = @Date AND RateTypeId = @RateTypeId AND CCY1Code = @CCYFrom AND CCY2Code = @CCYTo

		FETCH NEXT FROM RateCursor INTO @Date, @CCYFrom, @CCYTo, @Rate, @RateTypeId
	END
	CLOSE RateCursor
	DEALLOCATE RateCursor

GO

/****** Object:  StoredProcedure [dbo].[TOOLKIT_PopulateSchedules]    Script Date: 2/5/2016 4:00:16 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


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

/****** Object:  StoredProcedure [dbo].[TOOLKIT_ReconcileAll]    Script Date: 2/5/2016 4:00:16 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




/*****************************************************************************************************
 *  TOOLKIT_ReconcileAll procedure:                                                                  *
 *      @RunEffDate - Effective Date to Run                                                          *
 *  PURPOSE: Automatically reconciles all accounts ready for the given date.                         *
 *****************************************************************************************************/

CREATE PROCEDURE [dbo].[TOOLKIT_ReconcileAll]
(
	@RunEffDate datetime
)
AS
	DECLARE @accountID AS int
	DECLARE @reconcilerID AS int
	DECLARE @forceCarry AS bit
	DECLARE @now as DateTime
	DECLARE @EffDate as DateTime
	DECLARE @ReconID AS int
	set @forcecarry = 0
--	DECLARE auto_rec_history_cursor CURSOR
--	FOR
CREATE TABLE [dbo].[my_bulk_recs](
	[PkId] [int] IDENTITY(1,1) NOT NULL,
	[AccountId] [int] NOT NULL,
	[ReconcilerId] [int] NOT NULL,
	[NextReconEffDate] [datetime] NOT NULL)

		insert into my_bulk_recs
		SELECT Accounts.PkId, Accounts.ReconcilerID,  Accounts.NextReconEffDate
		FROM Accounts
--			INNER JOIN Define_ReconciliationChildFormats CF ON Accounts.ReconciliationFormatID=CF.PkID
--			LEFT OUTER JOIN AccountSegments ON Accounts.PKId=AccountSegments.AccountId 
		WHERE 
			Accounts.PKId not in( select a.PKId from accounts a join reconciliations r on r.accountid = a.PKId and r.effectivedate = a.nextreconeffdate)
			AND Accounts.active=1
			AND (ReconciliationScheduleID is not null OR ReconciliationScheduleID<>'')
			AND Accounts.NextReconEffDate = @RunEffDate
			AND Accounts.PKID > 700500

--	OPEN auto_rec_history_cursor
--	FETCH NEXT FROM auto_rec_history_cursor INTO @accountID, @reconcilerID,  @EffDate
--	WHILE @@Fetch_Status = 0
declare @mycnt int
declare @total int
set @total = (select max(pkid) from my_bulk_recs)
set @mycnt = (select min(pkid) from my_bulk_recs)
while (@mycnt < @total)

	BEGIN
		DECLARE @PrepResult varchar(15)
		SET @PrepResult = 'C'
		DECLARE @bulkType varchar(4)
		set @accountid = (select accountid from my_bulk_recs where pkid = @mycnt)
		set @reconcilerid = (select reconcilerid from my_bulk_recs where pkid = @mycnt)
		SET @bulkType = 'hist'
		PRINT '>>Attempting Historical Reconciliation for ' + Cast(@accountID as varchar)
		SET @now = getdate();
		EXEC usp_AddAutoBulkReconciliation @accountID, @RunEffDate, @now, @reconcilerID, @forceCarry, @PrepResult, @bulkType
		set @mycnt = @mycnt + 1
--		FETCH NEXT FROM auto_rec_history_cursor INTO @accountID, @reconcilerID, @EffDate
	END
drop table my_bulk_recs

--	CLOSE auto_rec_history_cursor
--	DEALLOCATE auto_rec_history_cursor
	
	DECLARE auto_rev_history_cursor CURSOR
	FOR
		SELECT Recon.PKID FROM Reconciliations Recon
		LEFT OUTER JOIN Accounts Acc ON Recon.AccountID=Acc.PKID
		WHERE
			BulkReconciled=1 AND
			ReconciliationStatusID = 'C' AND
			ReviewStatusID is NULL AND
			LOWER(BulkReconType) = 'hist' AND
			Recon.EffectiveDate = Acc.NextReviewEffDate

	OPEN auto_rev_history_cursor
	FETCH NEXT FROM auto_rev_history_cursor INTO @reconID
	WHILE @@Fetch_Status = 0
	BEGIN
		DECLARE @ReviewResult varchar(15)
		SET @ReviewResult= 'PASS'
		PRINT '>>Attempting Historical Review for ReconID: ' + Cast(@reconID as varchar)
		EXEC usp_ReviewAutoBulkCertify @reconID, @ReviewResult

		FETCH NEXT FROM auto_rev_history_cursor INTO @reconID
	END

	CLOSE auto_rev_history_cursor
	DEALLOCATE auto_rev_history_cursor
	
	DECLARE auto_app_history_cursor CURSOR
	FOR
		SELECT Recon.PKID FROM Reconciliations Recon
		LEFT OUTER JOIN Accounts Acc ON Recon.AccountID=Acc.PKID
		WHERE
			Recon.BulkReconciled=1 AND
			ReconciliationStatusID = 'C' AND
			ReviewStatusID = 'C' AND
			Recon.ApprovalStatusID is NULL AND
			LOWER(BulkReconType) = 'hist' AND
			Recon.RequiresApproval = 1 AND
			Recon.EffectiveDate = Acc.NextApprovalEffDate

	OPEN auto_app_history_cursor
	FETCH NEXT FROM auto_app_history_cursor INTO @reconID
	WHILE @@Fetch_Status = 0
	BEGIN
		DECLARE @ApprovalResult varchar(15)
		SET @ApprovalResult= 'PASS'
		PRINT '>>Attempting Historical Approval for ReconID: ' + Cast(@reconID as varchar)
		EXEC usp_ApproveAutoBulkCertify @reconID, @ApprovalResult

		FETCH NEXT FROM auto_app_history_cursor INTO @reconID
	END

	CLOSE auto_app_history_cursor
	DEALLOCATE auto_app_history_cursor



GO

/****** Object:  StoredProcedure [dbo].[TOOLKIT_ReconcileAll_orig]    Script Date: 2/5/2016 4:00:16 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



/*****************************************************************************************************
 *  TOOLKIT_ReconcileAll procedure:                                                                  *
 *      @RunEffDate - Effective Date to Run                                                          *
 *  PURPOSE: Automatically reconciles all accounts ready for the given date.                         *
 *****************************************************************************************************/

Create PROCEDURE [dbo].[TOOLKIT_ReconcileAll_orig]
(
	@RunEffDate datetime
)
AS
	DECLARE @accountID AS int
	DECLARE @reconcilerID AS int
	DECLARE @forceCarry AS bit
	DECLARE @now as DateTime
	DECLARE @EffDate as DateTime
	DECLARE @ReconID AS int
	DECLARE auto_rec_history_cursor CURSOR
	FOR
		SELECT DISTINCT Accounts.PkId, Accounts.ReconcilerID, CF.ForceCarryoverOpenRI, Accounts.NextReconEffDate
		FROM Accounts
			INNER JOIN Define_ReconciliationChildFormats CF ON Accounts.ReconciliationFormatID=CF.PkID
			LEFT OUTER JOIN AccountSegments ON Accounts.PKId=AccountSegments.AccountId 
		WHERE 
			Accounts.PKId not in( select a.PKId from accounts a join reconciliations r on r.accountid = a.PKId and r.effectivedate = a.nextreconeffdate)
			AND Accounts.active=1
			AND (ReconciliationScheduleID is not null OR ReconciliationScheduleID<>'')
			AND Accounts.NextReconEffDate = @RunEffDate
			AND Accounts.PKID > 157000

	OPEN auto_rec_history_cursor
	FETCH NEXT FROM auto_rec_history_cursor INTO @accountID, @reconcilerID, @forceCarry, @EffDate
	WHILE @@Fetch_Status = 0
	BEGIN
		DECLARE @PrepResult varchar(15)
		SET @PrepResult = 'C'
		DECLARE @bulkType varchar(4)
		SET @bulkType = 'hist'
		PRINT '>>Attempting Historical Reconciliation for ' + Cast(@accountID as varchar)
		SET @now = getdate();
		EXEC usp_AddAutoBulkReconciliation @accountID, @EffDate, @now, @reconcilerID, @forceCarry, @PrepResult, @bulkType

		FETCH NEXT FROM auto_rec_history_cursor INTO @accountID, @reconcilerID, @forceCarry, @EffDate
	END

	CLOSE auto_rec_history_cursor
	DEALLOCATE auto_rec_history_cursor
	
	DECLARE auto_rev_history_cursor CURSOR
	FOR
		SELECT Recon.PKID FROM Reconciliations Recon
		LEFT OUTER JOIN Accounts Acc ON Recon.AccountID=Acc.PKID
		WHERE
			BulkReconciled=1 AND
			ReconciliationStatusID = 'C' AND
			ReviewStatusID is NULL AND
			LOWER(BulkReconType) = 'hist' AND
			Recon.EffectiveDate = Acc.NextReviewEffDate

	OPEN auto_rev_history_cursor
	FETCH NEXT FROM auto_rev_history_cursor INTO @reconID
	WHILE @@Fetch_Status = 0
	BEGIN
		DECLARE @ReviewResult varchar(15)
		SET @ReviewResult= 'PASS'
		PRINT '>>Attempting Historical Review for ReconID: ' + Cast(@reconID as varchar)
		EXEC usp_ReviewAutoBulkCertify @reconID, @ReviewResult

		FETCH NEXT FROM auto_rev_history_cursor INTO @reconID
	END

	CLOSE auto_rev_history_cursor
	DEALLOCATE auto_rev_history_cursor
	
	DECLARE auto_app_history_cursor CURSOR
	FOR
		SELECT Recon.PKID FROM Reconciliations Recon
		LEFT OUTER JOIN Accounts Acc ON Recon.AccountID=Acc.PKID
		WHERE
			Recon.BulkReconciled=1 AND
			ReconciliationStatusID = 'C' AND
			ReviewStatusID = 'C' AND
			Recon.ApprovalStatusID is NULL AND
			LOWER(BulkReconType) = 'hist' AND
			Recon.RequiresApproval = 1 AND
			Recon.EffectiveDate = Acc.NextApprovalEffDate

	OPEN auto_app_history_cursor
	FETCH NEXT FROM auto_app_history_cursor INTO @reconID
	WHILE @@Fetch_Status = 0
	BEGIN
		DECLARE @ApprovalResult varchar(15)
		SET @ApprovalResult= 'PASS'
		PRINT '>>Attempting Historical Approval for ReconID: ' + Cast(@reconID as varchar)
		EXEC usp_ApproveAutoBulkCertify @reconID, @ApprovalResult

		FETCH NEXT FROM auto_app_history_cursor INTO @reconID
	END

	CLOSE auto_app_history_cursor
	DEALLOCATE auto_app_history_cursor


GO

/****** Object:  StoredProcedure [dbo].[TOOLKIT_SetEffectiveDate]    Script Date: 2/5/2016 4:00:16 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*****************************************************************************************************
 *  TOOLKIT_SetEffectiveDate procedure:                                                              *
 *      @StartEffectiveDate - Effective Date to Set                                                  *
 *  PURPOSE: Initializes the account NextDates to the given date.                                    *
 *****************************************************************************************************/

CREATE Procedure [dbo].[TOOLKIT_SetEffectiveDate]  
(
	@StartEffectiveDate DateTime
) 
AS
	IF (@StartEffectiveDate IS NULL)
	BEGIN
		PRINT '>> No EffectiveDate Given'
		SET @StartEffectiveDate = GETDATE()
	END
	EXEC usp_ResetNextDates 'AccountSegments.AccountSegment1',@StartEffectiveDate,''

GO


