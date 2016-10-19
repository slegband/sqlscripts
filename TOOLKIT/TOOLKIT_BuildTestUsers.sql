
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
	@Reconcilers Int, @Reviewers Int, @Approvers Int, @Admins Int, @QA Int
)
AS
BEGIN
	/* Declarations */
	DECLARE @UserName AS Varchar(50);
	DECLARE @Password AS Varchar(50) = 'f1no+2l/41Prfwb24n9VOg==';;
	DECLARE @DepartmentID AS Varchar(50);
	DECLARE @LocationID AS Varchar(50);
	DECLARE @ProgramAdminRoleID AS Varchar(50);
	DECLARE @FirstName AS Varchar(50);
	DECLARE @LastName AS Varchar(50);
	DECLARE @FullName AS Varchar(100);
	DECLARE @Counter AS Int = 1;
	
	PRINT 'Process Started';
	PRINT '';

/* Create Reconciler Users */
	PRINT '>>Start: Creating ' + CAST(@Reconcilers AS Varchar) + ' Reconcilers';
	WHILE (@Counter <= @Reconcilers)
	BEGIN
		SET @UserName = 'ReconUser' + CAST(@Counter AS Varchar);
		SET @FirstName = 'Recon';
		SET @LastName = 'User' + CAST(@Counter AS Varchar);
		SET @FullName = @FirstName + ' ' + @LastName;
		SET @DepartmentID = (SELECT TOP 1 Code FROM Code_Departments ORDER BY NEWID());
		SET @LocationID = (SELECT TOP 1 Code FROM Code_Locations WHERE UserFlg = 1 ORDER BY NEWID());
				
		INSERT INTO Users
			(UserName, [Password], FirstName, LastName, FullName, DepartmentID, LocationID, Role_Reconciler, Role_Reviewer, Role_Approver, Role_QA, Role_ProgramAdmin, ProgramAdminRoleID, AuthenticationType, Active, NewUser)
			VALUES 
			(@UserName, @Password, @FirstName, @LastName, @FullName, @DepartmentID, @LocationID, 1, 0, 0, 0, 0, NULL, 'Forms', 1, 0);
		SET @Counter = @Counter + 1;
	END;
	PRINT '>>Finished: Creating ' + CAST(@Reconcilers AS Varchar) + ' Reconcilers';
	PRINT '';
	PRINT '>>Start: Creating ' + CAST(@Reviewers AS Varchar) + ' Reviewers';

/* Create Reviewer Users */
	SET @Counter = 1;
	WHILE (@Counter <= @Reviewers)
	BEGIN
		SET @UserName = 'ReviewUser' + CAST(@Counter AS Varchar);
		SET @FirstName = 'Review';
		SET @LastName = 'User' + CAST(@Counter AS Varchar);
		SET @FullName = @FirstName + ' ' + @LastName;
		SET @DepartmentID = (SELECT TOP 1 Code FROM Code_Departments ORDER BY NEWID());
		SET @LocationID = (SELECT TOP 1 Code FROM Code_Locations WHERE UserFlg = 1 ORDER BY NEWID());
				
		INSERT INTO Users
			(UserName, [Password], FirstName, LastName, FullName, DepartmentID, LocationID, Role_Reconciler, Role_Reviewer, Role_Approver, Role_QA, Role_ProgramAdmin, ProgramAdminRoleID, AuthenticationType, Active, NewUser)
			VALUES 
			(@UserName, @Password, @FirstName, @LastName, @FullName, @DepartmentID, @LocationID, 0, 1, 0, 0, 0, NULL, 'Forms', 1, 0);
		SET @Counter = @Counter + 1;
	END;
	PRINT '>>Finished: Creating ' + CAST(@Reviewers AS Varchar) + ' Reviewers';
	PRINT '';
	PRINT '>>Start: Creating ' + CAST(@Approvers AS Varchar) + ' Approvers';

/* Create Approver Users */
	SET @Counter = 1;
	WHILE (@Counter <= @Approvers)
	BEGIN
		SET @UserName = 'ApproveUser' + CAST(@Counter AS Varchar);
		SET @FirstName = 'Approve';
		SET @LastName = 'User' + CAST(@Counter AS Varchar);
		SET @FullName = @FirstName + ' ' + @LastName;
		SET @DepartmentID = (SELECT TOP 1 Code FROM Code_Departments ORDER BY NEWID());
		SET @LocationID = (SELECT TOP 1 Code FROM Code_Locations WHERE UserFlg = 1 ORDER BY NEWID());
				
		INSERT INTO Users
			(UserName, [Password], FirstName, LastName, FullName, DepartmentID, LocationID, Role_Reconciler, Role_Reviewer, Role_Approver, Role_QA, Role_ProgramAdmin, ProgramAdminRoleID, AuthenticationType, Active, NewUser)
			VALUES 
			(@UserName, @Password, @FirstName, @LastName, @FullName, @DepartmentID, @LocationID, 0, 0, 1, 0, 0, NULL, 'Forms', 1, 0);
		SET @Counter = @Counter + 1;
	END;
	PRINT '>>Finished: Creating ' + CAST(@Approvers AS Varchar) + ' Approvers';
	PRINT '';
	PRINT '>>Start: Creating ' + CAST(@Admins AS Varchar) + ' Administrators';

/* Create Admin Users */
	SET @Counter = 1;
	WHILE (@Counter <= @Admins)
	BEGIN
		SET @UserName = 'AdminUser' + CAST(@Counter AS Varchar);
		SET @FirstName = 'Admin';
		SET @LastName = 'User' + CAST(@Counter AS Varchar);
		SET @FullName = @FirstName + ' ' + @LastName;
		SET @DepartmentID = (SELECT TOP 1 Code FROM Code_Departments ORDER BY NEWID());
		SET @LocationID = (SELECT TOP 1 Code FROM Code_Locations WHERE UserFlg = 1 ORDER BY NEWID());
		SET @ProgramAdminRoleID = (SELECT TOP 1 Code FROM UserRoles ORDER BY NEWID());
				
		INSERT INTO Users
			(UserName, [Password], FirstName, LastName, FullName, DepartmentID, LocationID, Role_Reconciler, Role_Reviewer, Role_Approver, Role_QA, Role_ProgramAdmin, ProgramAdminRoleID, AuthenticationType, Active, NewUser)
			VALUES 
			(@UserName, @Password, @FirstName, @LastName, @FullName, @DepartmentID, @LocationID, 0, 0, 0, 0, 1, @ProgramAdminRoleID, 'Forms', 1, 0);
		SET @Counter = @Counter + 1;
	END;
	PRINT '>>Finished: Creating ' + CAST(@Admins AS Varchar) + ' Administrators';
	PRINT '';
	PRINT '>>Start: Creating ' + CAST(@QA AS Varchar) + ' QA Users';

/* Create QA Users */
	SET @Counter = 1;
	WHILE (@Counter <= @QA)
	BEGIN
		SET @UserName = 'QAUser' + CAST(@Counter AS Varchar);
		SET @FirstName = 'QA';
		SET @LastName = 'User' + CAST(@Counter AS Varchar);
		SET @FullName = @FirstName + ' ' + @LastName;
		SET @DepartmentID = (SELECT TOP 1 Code FROM Code_Departments ORDER BY NEWID());
		SET @LocationID = (SELECT TOP 1 Code FROM Code_Locations WHERE UserFlg = 1 ORDER BY NEWID());
				
		INSERT INTO Users
			(UserName, [Password], FirstName, LastName, FullName, DepartmentID, LocationID, Role_Reconciler, Role_Reviewer, Role_Approver, Role_QA, Role_ProgramAdmin, ProgramAdminRoleID, AuthenticationType, Active, NewUser)
			VALUES 
			(@UserName, @Password, @FirstName, @LastName, @FullName, @DepartmentID, @LocationID, 0, 0, 0, 1, 0, NULL, 'Forms', 1, 0);
		SET @Counter = @Counter + 1;
	END;	
	PRINT '>>Finished: Creating ' + CAST(@QA AS Varchar) + ' QA Users';
	PRINT '';
	PRINT 'Process Completed';

END;
GO

