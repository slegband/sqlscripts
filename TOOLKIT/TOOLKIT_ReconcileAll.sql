
/*****************************************************************************************************
 *  TOOLKIT_ReconcileAll procedure:                                                                  *
 *    @RunEffDate DATETIME,                  -- Effective Date to use as for the Reconciliation      *
 *    @MinAccountPKId INT = 1,               -- This defines what acct id to start at. Default = 1   *
 *    @bulkType Varchar(4)  = 'Hist',        -- BulkReconType = Hist = Historical Reconciliation     *
 *    @PrepResult Varchar(15) = 'C',         -- Reconciler Result Status Id Default = C              *
 *    @ReviewResult Varchar(15) = 'PASS',    -- Reviewers Result = 'PASS"                            *
 *    @ApprovalResult Varchar(15) = 'PASS'   -- Approvers  Result = 'PASS"                           *
 *  PURPOSE: Automatically reconciles all accounts ready for the given date.                         *
 *  Example:																						 *
    EXEC [dbo].[Toolkit_ReconcileAll]  @RunEffDate = '2016-03-31', 
		@MinAccountPKId = 1, @bulkType = 'Hist', 
		@PrepResult  = 'C', 
		@ReviewResult  = 'PASS', @ApprovalResult = 'PASS'
 *	Note: This is a SSMS CPU intensive procedure that should be run on the server, not remotely      *
 *        FOR Large databases, you should send results to a file or you may run out of memory		 *
 *****************************************************************************************************/
IF EXISTS (SELECT OBJECT_ID('dbo.Toolkit_ReconcileAll'))
	DROP PROCEDURE dbo.Toolkit_ReconcileAll;
GO 
CREATE PROCEDURE [dbo].[ToolKit_ReconcileAll] 
( @RunEffDate DATETIME,                  -- Effective Date to use as for the Reconciliation
  @MinAccountPKId INT         = 1,       -- This defines what acct id to start at. Default = 1
  @bulkType Varchar(4)        = 'Hist',  -- BulkReconType = Hist = Historical Reconciliation 
  @PrepResult Varchar(15)     = 'C',     -- Reconciler Result Status Id Default = C
  @ReviewResult Varchar(15)   = 'PASS',  -- Reviewers Result = 'PASS"
  @ApprovalResult Varchar(15) = 'PASS'   -- Approvers  Result = 'PASS"
  )
AS

SET NOCOUNT ON 
--DECLARE  @RunEffDate DateTime = '2016-02-28'
---- select MAX(PKId) FROM accounts where NextReconEffDate = '2016-02-28'
--   DECLARE @MinAccountPKId Int = 1--163834; -- This defines what acct id to start at.
--   DECLARE @PrepResult Varchar(15) = 'C';   -- Reconciler Status Id 
--   DECLARE @bulkType Varchar(4)  = 'Hist';  -- BulkReconType = Historical Reconciliation 
--   DECLARE @ApprovalResult Varchar(15) = 'PASS';
--   DECLARE @ReviewResult Varchar(15) = 'PASS';

   DECLARE @accountID AS Int;
   DECLARE @reconcilerID AS Int;
   DECLARE @forceCarry AS Bit = 0;
   DECLARE @now AS DateTime;
   DECLARE @EffDate AS DateTime;
   DECLARE @ReconID AS Int;
   IF EXISTS ( SELECT   * FROM     sys.tables WHERE    name = 'my_bulk_recs_output' )
    DROP TABLE my_bulk_recs_output;
   CREATE TABLE my_bulk_recs_output
    ( [PkId] [INT] IDENTITY(1, 1) NOT NULL ,
      [Count] [INT] NOT NULL ,
      AccountId INT NOT NULL ,
      Info VARCHAR(999) NULL ,
      Starttime DATETIME NOT NULL
    );
   IF EXISTS ( SELECT   * FROM     sys.tables WHERE    name = 'my_bulk_recs' )
    DROP TABLE my_bulk_recs;
   CREATE TABLE [dbo].[my_bulk_recs]
      ( [PkId] [Int] IDENTITY(1, 1) NOT NULL,
        [AccountId] [Int] NOT NULL,
        [ReconcilerId] [Int] NOT NULL,
        [NextReconEffDate] [DateTime] NOT NULL
      );
/*  Get accounts to reconcile  that are not started and for the current effective date  */
PRINT 'Entering INSERT   INTO my_bulk_recs'
   INSERT   INTO my_bulk_recs
            SELECT   acct.PKId,
                     acct.ReconcilerID,
                     acct.NextReconEffDate
            FROM     dbo.Accounts acct
            WHERE    acct.PKId NOT IN ( SELECT a.PKId
                                            FROM   dbo.Accounts a
                                                   JOIN dbo.Reconciliations r ON r.AccountID = a.PKId
                                                                             AND r.EffectiveDate = a.NextReconEffDate 
												WHERE r.ReconciliationStatusID = 'C')
                     AND acct.Active = 1
                     AND ( acct.ReconciliationScheduleID IS NOT NULL
                           OR acct.ReconciliationScheduleID <> ''
                         )
                     AND acct.ReconcilerID IS NOT NULL 
					 AND acct.NextReconEffDate = @RunEffDate
                     AND acct.PKId >= @MinAccountPKId
		ORDER BY acct.PKId
   DECLARE @mycnt Int = ( SELECT MIN (PkId) FROM my_bulk_recs );
   DECLARE @total Int = ( SELECT MAX (PkId) FROM my_bulk_recs );
PRINT ' Entering Historical Reconciliation  '
PRINT 'TOTAL RECS = '+ Str(@total)
/*  Historical Reconciliation  */
   WHILE ( @mycnt < @total )
      BEGIN
         SELECT @accountID = AccountId, @reconcilerID = ReconcilerId  
		 FROM my_bulk_recs 
		 WHERE PkId = @mycnt;
         SET @now = GETDATE();

		 INSERT INTO dbo.my_bulk_recs_output
		         ( Count, AccountId, Info, Starttime )
		 VALUES  ( @mycnt, -- Count - int
		           @accountID, -- AccountId - int
		           '>>Attempting Historical Reconciliation', -- Info - varchar(999)
		           @now  -- Starttime - smalldatetime
		           ) 
         EXEC dbo.usp_AddAutoBulkReconciliation @accountID, @RunEffDate, @now, @reconcilerID, @forceCarry, @PrepResult, @bulkType;

         SET @mycnt = @mycnt + 1;
      END;
   DROP TABLE my_bulk_recs;
  -- SELECT * FROM dbo.my_bulk_recs
/*  Historical Review	  */
PRINT ' Entering ***auto_rev_history_cursor*'
      SELECT   @total = Count(*)
      FROM     dbo.Reconciliations Recon
               LEFT OUTER JOIN dbo.Accounts Acc ON Recon.AccountID = Acc.PKId
      WHERE    Recon.BulkReconciled = 1
               AND Recon.ReconciliationStatusID = @PrepResult
               AND Recon.ReviewStatusID IS NULL
               AND LOWER(Recon.BulkReconType) = @bulkType
               AND Recon.EffectiveDate = Acc.NextReviewEffDate
			   AND acc.Active = 1;
PRINT 'TOTAL REVIEWS = '+ Str(@total)
/**************auto_rev_history_cursor**********************************************************************************/
   DECLARE auto_rev_history_cursor CURSOR LOCAL FAST_FORWARD 
   FOR
      SELECT   Recon.PKId
      FROM     dbo.Reconciliations Recon
               LEFT OUTER JOIN dbo.Accounts Acc ON Recon.AccountID = Acc.PKId
      WHERE    Recon.BulkReconciled = 1
               AND Recon.ReconciliationStatusID = @PrepResult
               AND Recon.ReviewStatusID IS NULL
               AND LOWER(Recon.BulkReconType) = @bulkType
               AND Recon.EffectiveDate = Acc.NextReviewEffDate
			   AND acc.Active = 1;

   OPEN auto_rev_history_cursor;
   FETCH NEXT FROM auto_rev_history_cursor INTO @ReconID;
   WHILE @@Fetch_Status = 0
      BEGIN
         PRINT '>>Attempting Historical Review for ReconID: ' + CAST(@ReconID AS Varchar);
         EXEC dbo.usp_ReviewAutoBulkCertify @ReconID, @ReviewResult;

         FETCH NEXT FROM auto_rev_history_cursor INTO @ReconID;
      END;

   CLOSE auto_rev_history_cursor;
   DEALLOCATE auto_rev_history_cursor;
/********  auto_rev_history_cursor**********************************************************************************/

PRINT 'Entering Historical Approval'
/*  Historical Approval  */	
      SELECT   @TOTAL = Count(*)
      FROM     dbo.Reconciliations Recon
               LEFT OUTER JOIN dbo.Accounts Acc ON Recon.AccountID = Acc.PKId
      WHERE    Recon.BulkReconciled = 1
               AND Recon.ReconciliationStatusID = 'C'
               AND Recon.ReviewStatusID = 'C'
               AND Recon.ApprovalStatusID IS NULL
               AND LOWER(Recon.BulkReconType) = 'hist'
               AND Recon.RequiresApproval = 1
               AND Recon.EffectiveDate = Acc.NextApprovalEffDate;

PRINT 'TOTAL RECS = '+ Str(@total)
/*******  auto_app_history_cursor **********************************************************************************/
  DECLARE auto_app_history_cursor CURSOR LOCAL FAST_FORWARD
   FOR
      SELECT   Recon.PKId
      FROM     dbo.Reconciliations Recon
               LEFT OUTER JOIN dbo.Accounts Acc ON Recon.AccountID = Acc.PKId
      WHERE    Recon.BulkReconciled = 1
               AND Recon.ReconciliationStatusID = 'C'
               AND Recon.ReviewStatusID = 'C'
               AND Recon.ApprovalStatusID IS NULL
               AND LOWER(Recon.BulkReconType) = 'hist'
               AND Recon.RequiresApproval = 1
               AND Recon.EffectiveDate = Acc.NextApprovalEffDate;

   OPEN auto_app_history_cursor;
   FETCH NEXT FROM auto_app_history_cursor INTO @ReconID;
   WHILE @@Fetch_Status = 0
      BEGIN
         PRINT '>>Attempting Historical Approval for ReconID: ' + CAST(@ReconID AS Varchar);
         EXEC dbo.usp_ApproveAutoBulkCertify @ReconID, @ApprovalResult;

         FETCH NEXT FROM auto_app_history_cursor INTO @ReconID;
      END;

   CLOSE auto_app_history_cursor;
   DEALLOCATE auto_app_history_cursor;
/*******  auto_app_history_cursor **********************************************************************************/
GO
--COMMIT
