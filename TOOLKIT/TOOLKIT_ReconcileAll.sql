
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

