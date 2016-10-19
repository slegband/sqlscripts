
/*****************************************************************************************************
 *  TOOLKIT_ReconcileAll procedure:                                                                  *
 *      @RunEffDate - Effective Date to Run                                                          *
 *  PURPOSE: Automatically reconciles all accounts ready for the given date.                         *
 *****************************************************************************************************/

CREATE PROCEDURE [dbo].[TOOLKIT_ReconcileAll] ( @RunEffDate DateTime )
AS
   DECLARE @MinAccountPKId Int = 700500; -- When old account already exist in the system, This defines what acct id to start at.
   DECLARE @PrepResult Varchar(15) = 'C';   -- Reconciler Status Id 
   DECLARE @bulkType Varchar(4)  = 'Hist';  -- BulkReconType = Historical Reconciliation 
   DECLARE @ApprovalResult Varchar(15) = 'PASS';
   DECLARE @ReviewResult Varchar(15) = 'PASS';

   DECLARE @accountID AS Int;
   DECLARE @reconcilerID AS Int;
   DECLARE @forceCarry AS Bit = 0;
   DECLARE @now AS DateTime;
   DECLARE @EffDate AS DateTime;
   DECLARE @ReconID AS Int;

   CREATE TABLE [dbo].[my_bulk_recs]
      ( [PkId] [Int] IDENTITY(1, 1) NOT NULL,
        [AccountId] [Int] NOT NULL,
        [ReconcilerId] [Int] NOT NULL,
        [NextReconEffDate] [DateTime] NOT NULL
      );
/*  Get accounts to reconcile  that are not started and for the current effective date  */
   INSERT   INTO my_bulk_recs
            SELECT   PKId,
                     ReconcilerID,
                     NextReconEffDate
            FROM     dbo.Accounts
            WHERE    PKId NOT IN ( SELECT a.PKId
                                            FROM   dbo.Accounts a
                                                   JOIN dbo.Reconciliations r ON r.AccountID = a.PKId
                                                                             AND r.EffectiveDate = a.NextReconEffDate )
                     AND Active = 1
                     AND ( ReconciliationScheduleID IS NOT NULL
                           OR ReconciliationScheduleID <> ''
                         )
                     AND NextReconEffDate = @RunEffDate
                     AND PKId >= @MinAccountPKId;

   DECLARE @mycnt Int = ( SELECT MIN (PkId) FROM my_bulk_recs );
   DECLARE @total Int = ( SELECT MAX (PkId) FROM my_bulk_recs );

/*  Historical Reconciliation  */
   WHILE ( @mycnt < @total )
      BEGIN
         SET @accountID = ( SELECT AccountId FROM my_bulk_recs WHERE PkId = @mycnt );
         SET @reconcilerID = ( SELECT ReconcilerId FROM my_bulk_recs WHERE PkId = @mycnt );
         SET @now = GETDATE();

         PRINT '>>Attempting Historical Reconciliation for ' + CAST(@accountID AS Varchar);
         EXEC dbo.usp_AddAutoBulkReconciliation @accountID, @RunEffDate, @now, @reconcilerID, @forceCarry, @PrepResult, @bulkType;

         SET @mycnt = @mycnt + 1;
--		FETCH NEXT FROM auto_rec_history_cursor INTO @accountID, @reconcilerID, @EffDate
      END;
   DROP TABLE my_bulk_recs;

/*  Historical Review	  */
   DECLARE auto_rev_history_cursor CURSOR
   FOR
      SELECT   Recon.PKId
      FROM     dbo.Reconciliations Recon
               LEFT OUTER JOIN dbo.Accounts Acc ON Recon.AccountID = Acc.PKId
      WHERE    Recon.BulkReconciled = 1
               AND Recon.ReconciliationStatusID = @PrepResult
               AND Recon.ReviewStatusID IS NULL
               AND LOWER(Recon.BulkReconType) = @bulkType
               AND Recon.EffectiveDate = Acc.NextReviewEffDate;

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

/*  Historical Approval  */	
   DECLARE auto_app_history_cursor CURSOR
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


GO
