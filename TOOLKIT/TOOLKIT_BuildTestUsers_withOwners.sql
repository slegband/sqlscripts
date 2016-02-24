
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
	@Reconcilers INT, @Reviewers INT, @Approvers INT, @AcctOwners INT, @Admins INT, @QA INT
)
AS
	/* Declarations */
	DECLARE @UserName AS VARCHAR(50)
	DECLARE @Password AS VARCHAR(50)
	DECLARE @DepartmentID AS VARCHAR(50)
	DECLARE @LocationID AS VARCHAR(50)
	DECLARE @ProgramAdminRoleID AS VARCHAR(50)
	DECLARE @FirstName AS VARCHAR(50)
	DECLARE @LastName AS VARCHAR(50)
	DECLARE @FullName AS VARCHAR(100)
	DECLARE @Counter AS INT
	
	/* Set Statements */
	SET @Password = 'f1no+2l/41Prfwb24n9VOg=='
	SET @Counter = 1
	PRINT 'Process Started'
	PRINT ''
	/* Create Reconciler Users */
	PRINT '>>Start: Creating ' + CAST(@Reconcilers AS VARCHAR) + ' Reconcilers'
	WHILE (@Counter <= @Reconcilers)
	BEGIN
		SET @UserName = 'RecUser' + CAST(@Counter AS VARCHAR)
		SET @FirstName = 'Rec'
		SET @LastName = 'User' + CAST(@Counter AS VARCHAR)
		SET @FullName = @FirstName + ' ' + @LastName
		SET @DepartmentID = (SELECT TOP 1 Code FROM Code_Departments ORDER BY NEWID())
		SET @LocationID = (SELECT TOP 1 Code FROM Code_Locations WHERE UserFlg = 1 ORDER BY NEWID())
				
		INSERT INTO Users
			(UserName, [Password], FirstName, LastName, FullName, DepartmentID, LocationID, Role_Reconciler, Role_Reviewer, Role_Approver, Role_QA, Role_ProgramAdmin, ProgramAdminRoleID, AuthenticationType, Active, NewUser)
			VALUES 
			(@UserName, @Password, @FirstName, @LastName, @FullName, @DepartmentID, @LocationID, 1, 0, 0, 0, 0, NULL, 'Forms', 1, 0)
		SET @Counter = @Counter + 1
	END
	PRINT '>>Finished: Creating ' + CAST(@Reconcilers AS VARCHAR) + ' Reconcilers'
	PRINT ''
	PRINT '>>Start: Creating ' + CAST(@Reviewers AS VARCHAR) + ' Reviewers'
	/* Create Reviewer Users */
	SET @Counter = 1
	WHILE (@Counter <= @Reviewers)
	BEGIN
		SET @UserName = 'RevUser' + CAST(@Counter AS VARCHAR)
		SET @FirstName = 'Rev'
		SET @LastName = 'User' + CAST(@Counter AS VARCHAR)
		SET @FullName = @FirstName + ' ' + @LastName
		SET @DepartmentID = (SELECT TOP 1 Code FROM Code_Departments ORDER BY NEWID())
		SET @LocationID = (SELECT TOP 1 Code FROM Code_Locations WHERE UserFlg = 1 ORDER BY NEWID())
				
		INSERT INTO Users
			(UserName, [Password], FirstName, LastName, FullName, DepartmentID, LocationID, Role_Reconciler, Role_Reviewer, Role_Approver, Role_QA, Role_ProgramAdmin, ProgramAdminRoleID, AuthenticationType, Active, NewUser)
			VALUES 
			(@UserName, @Password, @FirstName, @LastName, @FullName, @DepartmentID, @LocationID, 0, 1, 0, 0, 0, NULL, 'Forms', 1, 0)
		SET @Counter = @Counter + 1
	END
	PRINT '>>Finished: Creating ' + CAST(@Reviewers AS VARCHAR) + ' Reviewers'
	PRINT ''
	PRINT '>>Start: Creating ' + CAST(@Approvers AS VARCHAR) + ' Approvers'
	/* Create Approver Users */
	SET @Counter = 1
	WHILE (@Counter <= @Approvers)
	BEGIN
		SET @UserName = 'ApprUser' + CAST(@Counter AS VARCHAR)
		SET @FirstName = 'Appr'
		SET @LastName = 'User' + CAST(@Counter AS VARCHAR)
		SET @FullName = @FirstName + ' ' + @LastName
		SET @DepartmentID = (SELECT TOP 1 Code FROM Code_Departments ORDER BY NEWID())
		SET @LocationID = (SELECT TOP 1 Code FROM Code_Locations WHERE UserFlg = 1 ORDER BY NEWID())
				
		INSERT INTO Users
			(UserName, [Password], FirstName, LastName, FullName, DepartmentID, LocationID, Role_Reconciler, Role_Reviewer, Role_Approver, Role_QA, Role_ProgramAdmin, ProgramAdminRoleID, AuthenticationType, Active, NewUser)
			VALUES 
			(@UserName, @Password, @FirstName, @LastName, @FullName, @DepartmentID, @LocationID, 0, 0, 1, 0, 0, NULL, 'Forms', 1, 0)
		SET @Counter = @Counter + 1
	END
	PRINT '>>Finished: Creating ' + CAST(@Approvers AS VARCHAR) + ' Approvers'
	PRINT ''
	PRINT ''
	PRINT '>>Start: Creating ' + CAST(@Approvers AS VARCHAR) + ' AcctOwners'
	/* Create Approver Users */
	SET @Counter = 1
	WHILE (@Counter <= @AcctOwners)
	BEGIN
		SET @UserName = 'AcctOwner' + CAST(@Counter AS VARCHAR)
		SET @FirstName = 'Acct'
		SET @LastName = 'Owner' + CAST(@Counter AS VARCHAR)
		SET @FullName = @FirstName + ' ' + @LastName
		SET @DepartmentID = (SELECT TOP 1 Code FROM Code_Departments ORDER BY NEWID())
		SET @LocationID = (SELECT TOP 1 Code FROM Code_Locations WHERE UserFlg = 1 ORDER BY NEWID())
				
		INSERT INTO Users
			(UserName, [Password], FirstName, LastName, FullName, DepartmentID, LocationID, Role_Reconciler, Role_Reviewer, Role_Approver, Role_QA, Role_ProgramAdmin, ProgramAdminRoleID, AuthenticationType, Active, NewUser)
			VALUES 
			(@UserName, @Password, @FirstName, @LastName, @FullName, @DepartmentID, @LocationID, 0, 0, 1, 0, 0, NULL, 'Forms', 1, 0)
		SET @Counter = @Counter + 1
	END
	PRINT '>>Finished: Creating ' + CAST(@Approvers AS VARCHAR) + ' Acct Owners'
	PRINT ''
	PRINT '>>Start: Creating ' + CAST(@Admins AS VARCHAR) + ' Administrators'
	/* Create Admin Users */
	SET @Counter = 1
	WHILE (@Counter <= @Admins)
	BEGIN
		SET @UserName = 'AdminUser' + CAST(@Counter AS VARCHAR)
		SET @FirstName = 'Admin'
		SET @LastName = 'User' + CAST(@Counter AS VARCHAR)
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
	PRINT '>>Finished: Creating ' + CAST(@Admins AS VARCHAR) + ' Administrators'
	PRINT ''
	PRINT '>>Start: Creating ' + CAST(@QA AS VARCHAR) + ' QA Users'
	/* Create QA Users */
	SET @Counter = 1
	WHILE (@Counter <= @QA)
	BEGIN
		SET @UserName = 'QAUser' + CAST(@Counter AS VARCHAR)
		SET @FirstName = 'QA'
		SET @LastName = 'User' + CAST(@Counter AS VARCHAR)
		SET @FullName = @FirstName + ' ' + @LastName
		SET @DepartmentID = (SELECT TOP 1 Code FROM Code_Departments ORDER BY NEWID())
		SET @LocationID = (SELECT TOP 1 Code FROM Code_Locations WHERE UserFlg = 1 ORDER BY NEWID())
				
		INSERT INTO Users
			(UserName, [Password], FirstName, LastName, FullName, DepartmentID, LocationID, Role_Reconciler, Role_Reviewer, Role_Approver, Role_QA, Role_ProgramAdmin, ProgramAdminRoleID, AuthenticationType, Active, NewUser)
			VALUES 
			(@UserName, @Password, @FirstName, @LastName, @FullName, @DepartmentID, @LocationID, 0, 0, 0, 1, 0, NULL, 'Forms', 1, 0)
		SET @Counter = @Counter + 1
	END	
	PRINT '>>Finished: Creating ' + CAST(@QA AS VARCHAR) + ' QA Users'
	PRINT ''
	PRINT 'Process Completed'

GO
