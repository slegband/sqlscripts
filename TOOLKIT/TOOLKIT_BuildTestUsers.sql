
/************************************************************************************************
 * INSTRUCTIONS:                                                                         	    *
 *	Make sure the database has relevant master data.                                 	        *
 *	Run this script on the database.                                                 	        *
 *  The users names will be build from the first name, last name and a number appended to it.   *
 *  The appended number will fill with zero's to the left example: RecUser001                   *
 *	Execute the procedure:  Note: any missing parameters will use the default values   	        *
EXEC dbo.ToolKit_BuildTestUsers
   @Reconcilers = 10,           -- Reconcilers: The number of reconciler users to generate.
   @Reviewers   = 10,           -- Reviewers: The number of Reviewer users to generate.	
   @Approvers   = 10,           -- Approvers: The number of Approver users to generate.
   @AcctOwners  = 0,            -- Account Owners: The number of Admin users to generate. 
   @Admins = 10,                -- Admins: The number of Admin users to generate. 
   @QA   = 10,                  -- QA: The number of QA users to generate.	
   @RecFirstName    = N'Rec',   -- the first name of the Reconciler user, default = 'Rec'
   @RevFirstName    = N'Rev',   -- the first name of the Reviewer user,
   @ApprFirstName   = N'Appr',  -- the first name of the Approver user,
   @AcctOwnerFirstName = N'Acct',   -- the first name of the Account Owner user,
   @AdminFirstName  = N'Admin',   -- the first name of the Administrator user,
   @QAFirstName     = N'QA',    -- the first name of the QA user,
   @PostfixNumStart      = 15,       -- Starting number for the users 
   @PostfixSize     = 3         --IF 3, Max 999 users for Each type of user, if 4, then 9999
 SELECT * FROM users ORDER BY UserName; 
 *				  	                                                                            *
 ************************************************************************************************/


ALTER PROCEDURE [dbo].[ToolKit_BuildTestUsers]
(
	@Reconcilers Int = 10, 
	@Reviewers INT = 10, 
	@Approvers INT = 10, 
	@AcctOwners INT = 10, 
	@Admins INT = 10, 
	@QA Int = 10,
	@RecFirstName AS NVarchar(48) = 'Rec',
	@RevFirstName AS NVarchar(48) = 'Rev',
	@ApprFirstName AS NVarchar(48) = 'Appr',
	@AcctOwnerFirstName AS NVarchar(48) = 'Acct',
	@AdminFirstName AS NVarchar(48) = 'Admin',
	@QAFirstName AS NVarchar(48) = 'QA',
	@PostfixNumStart AS Int = 1,                  /* Starting number for the users lastname postfix */
	@PostfixSize Int = 3                     /* IF 3, Max 999 users for Each type of user.*/
)
AS
SET NOCOUNT ON 
/* Declarations */
	DECLARE @counter AS Int = @PostfixNumStart  -- Starting number for the users lastname postfix 
	DECLARE @loop AS Int = 1
	DECLARE @Password AS NVarchar(50) = 'f1no+2l/41Prfwb24n9VOg=='   --'recon'
	DECLARE @DepartmentID AS NVarchar(50)
	DECLARE @LocationID AS NVarchar(50)
	DECLARE @ProgramAdminRoleID AS NVarchar(50)
	DECLARE @FirstName AS NVarchar(50)
	DECLARE @LastName AS NVarchar(50)
	DECLARE @FullName AS NVarchar(100)
	DECLARE @UserName AS NVarchar(50)

	
/* Create Reconciler Users */
	PRINT 'Process Started'
	PRINT '>>Start: Creating ' + CAST(@Reconcilers AS NVarchar) + ' Reconcilers'
	WHILE (@loop <= @Reconcilers)
	BEGIN
		SET @FirstName = @RecFirstName
		SET @LastName = 'User' +  RIGHT('00' + CAST(@counter AS NVarchar),@PostfixSize)--CAST(@counter AS NVarchar)
		SET @FullName = @FirstName + ' ' + @LastName
		SET @UserName = @FirstName + @LastName
		SET @DepartmentID = (SELECT TOP 1 Code FROM Code_Departments ORDER BY NEWID())
		SET @LocationID = (SELECT TOP 1 Code FROM Code_Locations WHERE UserFlg = 1 ORDER BY NEWID())
		PRINT @UserName		
		INSERT INTO Users
			(UserName, [Password], FirstName, LastName, FullName, DepartmentID, LocationID, Role_Reconciler, Role_Reviewer, Role_Approver, Role_QA, Role_ProgramAdmin, ProgramAdminRoleID, AuthenticationType, Active, NewUser)
			VALUES 
			(@UserName, @Password, @FirstName, @LastName, @FullName, @DepartmentID, @LocationID, 1, 0, 0, 0, 0, NULL, 'Forms', 1, 0)
		SET @counter = @counter + 1
		SET @loop += 1;
	END
	PRINT '>>Finished: Creating ' + CAST(@Reconcilers AS NVarchar) + ' Reconcilers'
	PRINT ''
	PRINT '>>Start: Creating ' + CAST(@Reviewers AS NVarchar) + ' Reviewers'

/* Create Reviewer Users */
	SET @counter = @PostfixNumStart
	SET @loop = 1;
	WHILE (@loop <= @Reviewers)
	BEGIN
		SET @FirstName = @RevFirstName
		SET @LastName = 'User' +  RIGHT('00' + CAST(@counter AS NVarchar),@PostfixSize)--		SET @LastName = 'User' + CAST(@counter AS NVarchar)
		SET @FullName = @FirstName + ' ' + @LastName
		SET @UserName = @FirstName + @LastName
		SET @DepartmentID = (SELECT TOP 1 Code FROM Code_Departments ORDER BY NEWID())
		SET @LocationID = (SELECT TOP 1 Code FROM Code_Locations WHERE UserFlg = 1 ORDER BY NEWID())
		PRINT @UserName		
				
		INSERT INTO Users
			(UserName, [Password], FirstName, LastName, FullName, DepartmentID, LocationID, Role_Reconciler, Role_Reviewer, Role_Approver, Role_QA, Role_ProgramAdmin, ProgramAdminRoleID, AuthenticationType, Active, NewUser)
			VALUES 
			(@UserName, @Password, @FirstName, @LastName, @FullName, @DepartmentID, @LocationID, 0, 1, 0, 0, 0, NULL, 'Forms', 1, 0)
		SET @counter = @counter + 1
		SET @loop += 1;
	END
	PRINT '>>Finished: Creating ' + CAST(@Reviewers AS NVarchar) + ' Reviewers'
	PRINT ''
	PRINT '>>Start: Creating ' + CAST(@Approvers AS NVarchar) + ' Approvers'

/* Create Approver Users */
	SET @counter = @PostfixNumStart;	
	SET @loop = 1;
	WHILE (@loop <= @Approvers)
	BEGIN
		SET @FirstName = @ApprFirstName
		SET @LastName = 'User' +  RIGHT('00' + CAST(@counter AS NVarchar),@PostfixSize)--
		SET @FullName = @FirstName + ' ' + @LastName
		SET @UserName = @FirstName + @LastName  --		SET @UserName = 'ApprUser' + CAST(@counter AS NVarchar)
		SET @DepartmentID = (SELECT TOP 1 Code FROM Code_Departments ORDER BY NEWID())
		SET @LocationID = (SELECT TOP 1 Code FROM Code_Locations WHERE UserFlg = 1 ORDER BY NEWID())
		PRINT @UserName		
				
		INSERT INTO Users
			(UserName, [Password], FirstName, LastName, FullName, DepartmentID, LocationID, Role_Reconciler, Role_Reviewer, Role_Approver, Role_QA, Role_ProgramAdmin, ProgramAdminRoleID, AuthenticationType, Active, NewUser)
			VALUES 
			(@UserName, @Password, @FirstName, @LastName, @FullName, @DepartmentID, @LocationID, 0, 0, 1, 0, 0, NULL, 'Forms', 1, 0)
		SET @counter = @counter + 1
		SET @loop += 1;
	END
	PRINT '>>Finished: Creating ' + CAST(@Approvers AS NVarchar) + ' Approvers'
	PRINT ''
	PRINT ''
	PRINT '>>Start: Creating ' + CAST(@Approvers AS NVarchar) + ' AcctOwners'

/* Create Approver Users */
	SET @counter = @PostfixNumStart;	
	SET @loop = 1;
	WHILE (@loop <= @AcctOwners)
	BEGIN
		SET @FirstName = @AcctOwnerFirstName
		SET @LastName = 'Owner' +  RIGHT('00' + CAST(@counter AS NVarchar),@PostfixSize)--		SET @LastName = 'Owner' + CAST(@counter AS NVarchar)
		SET @FullName = @FirstName + ' ' + @LastName
		SET @UserName = @FirstName + @LastName
		SET @DepartmentID = (SELECT TOP 1 Code FROM Code_Departments ORDER BY NEWID())
		SET @LocationID = (SELECT TOP 1 Code FROM Code_Locations WHERE UserFlg = 1 ORDER BY NEWID())
		PRINT @UserName		
				
		INSERT INTO Users
			(UserName, [Password], FirstName, LastName, FullName, DepartmentID, LocationID, Role_Reconciler, Role_Reviewer, Role_Approver, Role_QA, Role_ProgramAdmin, ProgramAdminRoleID, AuthenticationType, Active, NewUser)
			VALUES 
			(@UserName, @Password, @FirstName, @LastName, @FullName, @DepartmentID, @LocationID, 0, 0, 1, 0, 0, NULL, 'Forms', 1, 0)
		SET @counter = @counter + 1
		SET @loop += 1;
	END
	PRINT '>>Finished: Creating ' + CAST(@Approvers AS NVarchar) + ' Acct Owners'
	PRINT ''
	PRINT '>>Start: Creating ' + CAST(@Admins AS NVarchar) + ' Administrators'

/* Create Admin Users */
	SET @counter = @PostfixNumStart;	
	SET @loop = 1;
	WHILE (@loop <= @Admins)
	BEGIN
		SET @FirstName = @AdminFirstName
		SET @LastName = 'User' +  RIGHT('00' + CAST(@counter AS NVarchar),@PostfixSize)--		SET @LastName = 'User' + CAST(@counter AS NVarchar)
		SET @FullName = @FirstName + ' ' + @LastName
		SET @UserName = @FirstName + @LastName
		SET @DepartmentID = (SELECT TOP 1 Code FROM Code_Departments ORDER BY NEWID())
		SET @LocationID = (SELECT TOP 1 Code FROM Code_Locations WHERE UserFlg = 1 ORDER BY NEWID())
		SET @ProgramAdminRoleID = (SELECT TOP 1 Code FROM UserRoles ORDER BY NEWID())
		PRINT @UserName		
				
		INSERT INTO Users
			(UserName, [Password], FirstName, LastName, FullName, DepartmentID, LocationID, Role_Reconciler, Role_Reviewer, Role_Approver, Role_QA, Role_ProgramAdmin, ProgramAdminRoleID, AuthenticationType, Active, NewUser)
			VALUES 
			(@UserName, @Password, @FirstName, @LastName, @FullName, @DepartmentID, @LocationID, 0, 0, 0, 0, 1, @ProgramAdminRoleID, 'Forms', 1, 0)
		SET @counter = @counter + 1
		SET @loop += 1;
	END
	PRINT '>>Finished: Creating ' + CAST(@Admins AS NVarchar) + ' Administrators'
	PRINT ''
	PRINT '>>Start: Creating ' + CAST(@QA AS NVarchar) + ' QA Users'

/* Create QA Users */
	SET @counter = @PostfixNumStart;	
	SET @loop = 1;
	WHILE (@loop <= @QA)
	BEGIN
		SET @FirstName = @QAFirstName
		SET @LastName = 'User' + RIGHT('00' + CAST(@counter AS NVarchar),@PostfixSize)-- +CAST(@counter AS NVarchar)
		SET @FullName = @FirstName + ' ' + @LastName
		SET @UserName = @FirstName + @LastName --'QAUser' + CAST(@counter AS NVarchar)
		SET @DepartmentID = (SELECT TOP 1 Code FROM Code_Departments ORDER BY NEWID())
		SET @LocationID = (SELECT TOP 1 Code FROM Code_Locations WHERE UserFlg = 1 ORDER BY NEWID())
		PRINT @UserName		
				
		INSERT INTO Users
			(UserName, [Password], FirstName, LastName, FullName, DepartmentID, LocationID, Role_Reconciler, Role_Reviewer, Role_Approver, Role_QA, Role_ProgramAdmin, ProgramAdminRoleID, AuthenticationType, Active, NewUser)
			VALUES 
			(@UserName, @Password, @FirstName, @LastName, @FullName, @DepartmentID, @LocationID, 0, 0, 0, 1, 0, NULL, 'Forms', 1, 0)
		SET @counter = @counter + 1
		SET @loop += 1;
	END	
	PRINT '>>Finished: Creating ' + CAST(@QA AS NVarchar) + ' QA Users'
	PRINT ''
	PRINT 'Process Completed'

GO
