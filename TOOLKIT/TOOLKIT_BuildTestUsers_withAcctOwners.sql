
/************************************************************************************************
 * INSTRUCTIONS:                                                                         	    *
 *	Make sure the database has relevant master data.                                 	        *
 *	Run this script on the database.                                                 	        *
 *	Execute the procedure:  Note: any missing parameters will use the default values   	        *
 *		EXEC TOOLKIT_BuildTestUsers @Reconcilers=10, @Reviewers=10, @Approvers=10, @Admins=10, @QA=10 *
 *			Reconcilers: The number of reconciler users to generate.	 	                    *
 *			Reviewers: The number of Reviewer users to generate.		  	                    *
 *			Approvers: The number of Approver users to generate.		      	                *
 *			Admins: The number of Admin users to generate.                        	            *
 *			QA: The number of QA users to generate.		                 	                    *
 *			@RecFirstName is the name of the user before number appended, default = 'Rec',
 *			@RevFirstName       default = 'Rev',
 *			@ApprFirstName      default = 'Appr',
 *			@AcctOwnerFirstName default = 'AcctOwner',
 *			@AdminFirstName     default = 'Admin',
 *			@QAFirstName        default = 'QA',
						                 	                                        *
 ************************************************************************************************/

CREATE PROCEDURE [dbo].[TOOLKIT_BuildTestUsers_withOwners]
(
	@Reconcilers Int = 10, 
	@Reviewers INT = 10, 
	@Approvers INT = 10, 
	@AcctOwners INT = 10, 
	@Admins INT = 10, 
	@QA Int = 1,
	@RecFirstName AS NVarchar(48) = 'Rec',
	@RevFirstName AS NVarchar(48) = 'Rev',
	@ApprFirstName AS NVarchar(48) = 'Appr',
	@AcctOwnerFirstName AS NVarchar(48) = 'AcctOwner',
	@AdminFirstName AS NVarchar(48) = 'Admin',
	@QAFirstName AS NVarchar(48) = 'QA'

)
AS
/* Declarations */
	DECLARE @Counter AS Int = 1
	DECLARE @Password AS NVarchar(50) = 'f1no+2l/41Prfwb24n9VOg=='   --'recon'
	DECLARE @DepartmentID AS NVarchar(50)
	DECLARE @LocationID AS NVarchar(50)
	DECLARE @ProgramAdminRoleID AS NVarchar(50)
	DECLARE @FirstName AS NVarchar(50)
	DECLARE @LastName AS NVarchar(50)
	DECLARE @FullName AS NVarchar(100)
	DECLARE @UserName AS NVarchar(50)
	--DECLARE @RecFirstName AS NVarchar(48) = 'Rec'
	--DECLARE @RevFirstName AS NVarchar(48) = 'Rev'
	--DECLARE @ApprFirstName AS NVarchar(48) = 'Appr'
	--DECLARE @AcctOwnerFirstName AS NVarchar(48) = 'AcctOwner'
	--DECLARE @AdminFirstName AS NVarchar(48) = 'Admin'
	--DECLARE @QAFirstName AS NVarchar(48) = 'QA'
	
/* Create Reconciler Users */
	PRINT 'Process Started'
	PRINT '>>Start: Creating ' + CAST(@Reconcilers AS NVarchar) + ' Reconcilers'
	WHILE (@Counter <= @Reconcilers)
	BEGIN
		SET @UserName = @RecFirstName + 'User' + CAST(@Counter AS NVarchar)
		SET @FirstName = @RecFirstName
		SET @LastName = 'User' + CAST(@Counter AS NVarchar)
		SET @FullName = @FirstName + ' ' + @LastName
		SET @DepartmentID = (SELECT TOP 1 Code FROM Code_Departments ORDER BY NEWID())
		SET @LocationID = (SELECT TOP 1 Code FROM Code_Locations WHERE UserFlg = 1 ORDER BY NEWID())
				
		INSERT INTO Users
			(UserName, [Password], FirstName, LastName, FullName, DepartmentID, LocationID, Role_Reconciler, Role_Reviewer, Role_Approver, Role_QA, Role_ProgramAdmin, ProgramAdminRoleID, AuthenticationType, Active, NewUser)
			VALUES 
			(@UserName, @Password, @FirstName, @LastName, @FullName, @DepartmentID, @LocationID, 1, 0, 0, 0, 0, NULL, 'Forms', 1, 0)
		SET @Counter = @Counter + 1
	END
	PRINT '>>Finished: Creating ' + CAST(@Reconcilers AS NVarchar) + ' Reconcilers'
	PRINT ''
	PRINT '>>Start: Creating ' + CAST(@Reviewers AS NVarchar) + ' Reviewers'

/* Create Reviewer Users */
	SET @Counter = 1
	WHILE (@Counter <= @Reviewers)
	BEGIN
		SET @UserName = 'RevUser' + CAST(@Counter AS NVarchar)
		SET @FirstName = 'Rev'
		SET @LastName = 'User' + CAST(@Counter AS NVarchar)
		SET @FullName = @FirstName + ' ' + @LastName
		SET @DepartmentID = (SELECT TOP 1 Code FROM Code_Departments ORDER BY NEWID())
		SET @LocationID = (SELECT TOP 1 Code FROM Code_Locations WHERE UserFlg = 1 ORDER BY NEWID())
				
		INSERT INTO Users
			(UserName, [Password], FirstName, LastName, FullName, DepartmentID, LocationID, Role_Reconciler, Role_Reviewer, Role_Approver, Role_QA, Role_ProgramAdmin, ProgramAdminRoleID, AuthenticationType, Active, NewUser)
			VALUES 
			(@UserName, @Password, @FirstName, @LastName, @FullName, @DepartmentID, @LocationID, 0, 1, 0, 0, 0, NULL, 'Forms', 1, 0)
		SET @Counter = @Counter + 1
	END
	PRINT '>>Finished: Creating ' + CAST(@Reviewers AS NVarchar) + ' Reviewers'
	PRINT ''
	PRINT '>>Start: Creating ' + CAST(@Approvers AS NVarchar) + ' Approvers'

/* Create Approver Users */
	SET @Counter = 1
	WHILE (@Counter <= @Approvers)
	BEGIN
		SET @UserName = 'ApprUser' + CAST(@Counter AS NVarchar)
		SET @FirstName = 'Appr'
		SET @LastName = 'User' + CAST(@Counter AS NVarchar)
		SET @FullName = @FirstName + ' ' + @LastName
		SET @DepartmentID = (SELECT TOP 1 Code FROM Code_Departments ORDER BY NEWID())
		SET @LocationID = (SELECT TOP 1 Code FROM Code_Locations WHERE UserFlg = 1 ORDER BY NEWID())
				
		INSERT INTO Users
			(UserName, [Password], FirstName, LastName, FullName, DepartmentID, LocationID, Role_Reconciler, Role_Reviewer, Role_Approver, Role_QA, Role_ProgramAdmin, ProgramAdminRoleID, AuthenticationType, Active, NewUser)
			VALUES 
			(@UserName, @Password, @FirstName, @LastName, @FullName, @DepartmentID, @LocationID, 0, 0, 1, 0, 0, NULL, 'Forms', 1, 0)
		SET @Counter = @Counter + 1
	END
	PRINT '>>Finished: Creating ' + CAST(@Approvers AS NVarchar) + ' Approvers'
	PRINT ''
	PRINT ''
	PRINT '>>Start: Creating ' + CAST(@Approvers AS NVarchar) + ' AcctOwners'

/* Create Approver Users */
	SET @Counter = 1
	WHILE (@Counter <= @AcctOwners)
	BEGIN
		SET @UserName = 'AcctOwner' + CAST(@Counter AS NVarchar)
		SET @FirstName = 'Acct'
		SET @LastName = 'Owner' + CAST(@Counter AS NVarchar)
		SET @FullName = @FirstName + ' ' + @LastName
		SET @DepartmentID = (SELECT TOP 1 Code FROM Code_Departments ORDER BY NEWID())
		SET @LocationID = (SELECT TOP 1 Code FROM Code_Locations WHERE UserFlg = 1 ORDER BY NEWID())
				
		INSERT INTO Users
			(UserName, [Password], FirstName, LastName, FullName, DepartmentID, LocationID, Role_Reconciler, Role_Reviewer, Role_Approver, Role_QA, Role_ProgramAdmin, ProgramAdminRoleID, AuthenticationType, Active, NewUser)
			VALUES 
			(@UserName, @Password, @FirstName, @LastName, @FullName, @DepartmentID, @LocationID, 0, 0, 1, 0, 0, NULL, 'Forms', 1, 0)
		SET @Counter = @Counter + 1
	END
	PRINT '>>Finished: Creating ' + CAST(@Approvers AS NVarchar) + ' Acct Owners'
	PRINT ''
	PRINT '>>Start: Creating ' + CAST(@Admins AS NVarchar) + ' Administrators'

/* Create Admin Users */
	SET @Counter = 1
	WHILE (@Counter <= @Admins)
	BEGIN
		SET @UserName = 'AdminUser' + CAST(@Counter AS NVarchar)
		SET @FirstName = 'Admin'
		SET @LastName = 'User' + CAST(@Counter AS NVarchar)
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
	PRINT '>>Finished: Creating ' + CAST(@Admins AS NVarchar) + ' Administrators'
	PRINT ''
	PRINT '>>Start: Creating ' + CAST(@QA AS NVarchar) + ' QA Users'

/* Create QA Users */
	SET @Counter = 1
	WHILE (@Counter <= @QA)
	BEGIN
		SET @UserName = 'QAUser' + CAST(@Counter AS NVarchar)
		SET @FirstName = 'QA'
		SET @LastName = 'User' + CAST(@Counter AS NVarchar)
		SET @FullName = @FirstName + ' ' + @LastName
		SET @DepartmentID = (SELECT TOP 1 Code FROM Code_Departments ORDER BY NEWID())
		SET @LocationID = (SELECT TOP 1 Code FROM Code_Locations WHERE UserFlg = 1 ORDER BY NEWID())
				
		INSERT INTO Users
			(UserName, [Password], FirstName, LastName, FullName, DepartmentID, LocationID, Role_Reconciler, Role_Reviewer, Role_Approver, Role_QA, Role_ProgramAdmin, ProgramAdminRoleID, AuthenticationType, Active, NewUser)
			VALUES 
			(@UserName, @Password, @FirstName, @LastName, @FullName, @DepartmentID, @LocationID, 0, 0, 0, 1, 0, NULL, 'Forms', 1, 0)
		SET @Counter = @Counter + 1
	END	
	PRINT '>>Finished: Creating ' + CAST(@QA AS NVarchar) + ' QA Users'
	PRINT ''
	PRINT 'Process Completed'

GO
