
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

