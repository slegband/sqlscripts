/*  Use usp_Interface_ImportGlBalancesOnly  instead of this one*/
CREATE PROCEDURE [dbo].[TOOLKIT_GLHistory_Import]
(@InterfaceID INT, @StartTime DATETIME, @InterfaceHistoryPKId INT)
AS
		DECLARE @Result AS SMALLINT
		SET @Result = 0
		DECLARE @CurrentDt DATETIME
		SET @CurrentDt = GETDATE()
	
		--Validate CCY 1Code
		EXEC @Result = usp_InterfaceValidateTableColumns @InterfaceId,@StartTime,'BalancesTempTable','Code_Currencies','CCY1Code','Code',1,0,@InterfaceHistoryPKId
	
		IF(@Result < 0)
		BEGIN
			PRINT 'CCY1 Code Validation Error: ' + CONVERT(VARCHAR,@Result)
			GOTO ValidationExitPoint
		END
	
		--Validate CCY2 Code
		EXEC @Result = usp_InterfaceValidateTableColumns @InterfaceId,@StartTime,'BalancesTempTable','Code_Currencies','CCY2Code','Code',1,0,@InterfaceHistoryPKId
	
		IF(@Result < 0)
		BEGIN
			PRINT 'CCY2 Code Validation Error: ' + CONVERT(VARCHAR,@Result)
			GOTO ValidationExitPoint
		END
	
		--Validate CCY3 Code
		EXEC @Result = usp_InterfaceValidateTableColumns @InterfaceId,@StartTime,'BalancesTempTable','Code_Currencies','CCY3Code','Code',1,0,@InterfaceHistoryPKId
	
		IF(@Result < 0)
		BEGIN
			PRINT 'CCY3 Code Validation Error: ' + CONVERT(VARCHAR,@Result)
			GOTO ValidationExitPoint
		END
	
		--Start Transaction
		BEGIN TRAN
		
		--Declare variables
		
	
		DECLARE @TempTableRowCount AS INT
		
		DECLARE @TotalRecs AS INT 
		DECLARE @TotalInserted AS INT
		DECLARE @TotalUpdated AS INT
		SET @TotalRecs  =0 
		SET @TotalInserted =0 
		SET @TotalUpdated = 0
		
	--	--These declarion for handling Errors
		DECLARE @Error_TTPKID AS INT
		DECLARE @Error_Code AS INT
		DECLARE @Error_QueryCode AS VARCHAR(200)
		DECLARE @ErrorVar INT
	    DECLARE @IsError AS BIT
	--	
	--	--Declared to handle count and error in certain areas.
		
		DECLARE @RowCountVar INT
		DECLARE @EndTime DATETIME	
		
		PRINT 'Beginning Checking for existance of records in the temp table: ' + CONVERT(VARCHAR,GETDATE())
		SELECT @TempTableRowCount = COUNT(*) FROM BalancesTempTable
		SELECT @ErrorVar = @@ERROR	
		IF (@ErrorVar<>0)
			BEGIN
				SET @IsError=1
				SET @Error_Code = @ErrorVar
				SET @Error_TTPKID = 0
				SET @Error_QueryCode = ' Checking for records in the temp table '
				GOTO ExitPoint
			END
		IF(@TempTableRowCount<=0 )	-- No rows in the temp table
		BEGIN
			SET @IsError=1
			SET @Error_Code = @ErrorVar
			SET @Error_TTPKID = 0
			SET @Error_QueryCode = 'There are no records in BalancesTempTable.'
			GOTO ExitPoint
		END
		PRINT 'Finished Checking for existance of records in the temp table: ' + CONVERT(VARCHAR,GETDATE())
	
		PRINT 'Beginning Reset BalanceUpdate Flag: ' + CONVERT(VARCHAR,GETDATE())
		UPDATE GLHistory SET BalanceChange=0 WHERE BalanceChange=1
		SELECT @ErrorVar = @@ERROR	
		IF (@ErrorVar<>0)	-- Error executing sql
			BEGIN
				SET @IsError=1
				SET @Error_Code = @ErrorVar
				SET @Error_TTPKID = 0
				SET @Error_QueryCode = 'Resetting BalanceUpdate Flag '
				GOTO ExitPoint
			END
		PRINT 'Finished Reset BalanceUpdate Flag: ' + CONVERT(VARCHAR,GETDATE())
	
		PRINT 'Beginning Reset PendingBalanceUpdate Flag: ' + CONVERT(VARCHAR,GETDATE())
		UPDATE Reconciliations SET PendingBalanceUpdate=0 WHERE PendingBalanceUpdate=1
		SELECT @ErrorVar = @@ERROR	
		IF (@ErrorVar<>0)	-- Error executing sql
			BEGIN
				SET @IsError=1
				SET @Error_Code = @ErrorVar
				SET @Error_TTPKID = 0
				SET @Error_QueryCode = 'Resetting PendingBalanceUpdate Flag '
				GOTO ExitPoint
			END
		PRINT 'Finished Reset PendingBalanceUpdate Flag: ' + CONVERT(VARCHAR,GETDATE())
	
		PRINT 'Beginning Reset Update Flag: ' + CONVERT(VARCHAR,GETDATE())
		UPDATE BalancesTempTable SET GLHistoryUpdatedFlag = 0
		SELECT @ErrorVar = @@ERROR	
		IF (@ErrorVar<>0)	-- Error executing sql
			BEGIN
				SET @IsError=1
				SET @Error_Code = @ErrorVar
				SET @Error_TTPKID = 0
				SET @Error_QueryCode = 'Resetting Update Flag '
				GOTO ExitPoint
			END
		PRINT 'Finished Reset Update Flag: ' + CONVERT(VARCHAR,GETDATE())
		
		PRINT 'Beginning Updating Effective Dates: ' + CONVERT(VARCHAR,GETDATE())
		UPDATE BalancesTempTable 
			SET BalancesTempTable.EffectiveDate=E.EffectiveDate
				FROM BalancesTempTable T 
			INNER JOIN EffectiveDates E ON RIGHT('00' + CONVERT(VARCHAR(2),CAST(E.FiscalMonth AS INT)),2)=RIGHT('00' + CONVERT(VARCHAR(2),CAST(T.Period AS INT)),2) AND E.FiscalYear=T.[Year] 
		SELECT @ErrorVar = @@ERROR, @RowCountVar = @@ROWCOUNT	
		IF (@ErrorVar<>0)	-- Error executing sql
			BEGIN
				SET @IsError=1
				SET @Error_Code = @ErrorVar
				SET @Error_TTPKID = 0
				SET @Error_QueryCode = 'Updating EffectiveDate of Temp Table '
				GOTO ExitPoint
			END
		IF(@RowCountVar=0)	-- Zero effective dates updated
			BEGIN
				SET @IsError=1
				SET @Error_Code = @ErrorVar
				SET @Error_TTPKID = 0
				SET @Error_QueryCode = '0 records are updated for Effective Dates'
				GOTO ExitPoint
			END
		IF(@RowCountVar<>@TempTableRowCount)	-- Rows in the temp table don't match the number of effective date rows updated
			BEGIN
				SET @IsError=1
				SET @Error_Code = @ErrorVar
				SET @Error_TTPKID = 0
				SET @Error_QueryCode = STR(@RowCountVar) + ' Out of ' + STR(@TempTableRowCount) + ' Records are updated for Effective Dates'
				GOTO ExitPoint
			END		
		PRINT 'Finished Updating Effective Dates: ' + CONVERT(VARCHAR,GETDATE())		
		
		PRINT 'Beginning Setting AccountPKId: ' + CONVERT(VARCHAR,GETDATE())
		UPDATE BalancesTempTable 
			SET BalancesTempTable.AccountPKID = A.PKId	
			FROM 
			    BalancesTempTable T 
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
				SET @Error_QueryCode = 'Updating AccountPKId of BalancesTempTable '
				GOTO ExitPoint
			END
		PRINT 'Finished Setting AccountPKId: ' + CONVERT(VARCHAR,GETDATE())
		
		PRINT 'Beginning Updating Accounts Name, LastDateImported: ' + CONVERT(VARCHAR,GETDATE())
		UPDATE Accounts 
			SET Accounts.AccountName=BalancesTempTable.AccountName, 
			    DateLastImported=@CurrentDt
			FROM BalancesTempTable 
		JOIN  Accounts ON Accounts.PKId = BalancesTempTable.AccountPKID
		SELECT @ErrorVar=@@error 
		IF(@ErrorVar <>0 )
		BEGIN
			SET @IsError=1
			SET @Error_Code = @ErrorVar
			SET @Error_TTPKID = 0
			SET @Error_QueryCode = 'Updating AccountName,DateLastImported of Accounts '
			GOTO ExitPoint
		END
		PRINT 'Finished Updating Accounts Name, LastDateImported: ' + CONVERT(VARCHAR,GETDATE())
	
		PRINT 'Beginning Insert into Account and AccountSegments table: ' + CONVERT(VARCHAR,GETDATE())
		DECLARE @AccountPKId INT
		DECLARE @AccountSegment1 VARCHAR(50)
		DECLARE @AccountSegment2 VARCHAR(50)
		DECLARE @AccountSegment3 VARCHAR(50)
		DECLARE @AccountSegment4 VARCHAR(50)
		DECLARE @AccountSegment5 VARCHAR(50)
		DECLARE @AccountSegment6 VARCHAR(50)
		DECLARE @AccountSegment7 VARCHAR(50)
		DECLARE @AccountSegment8 VARCHAR(50)
		DECLARE @AccountSegment9 VARCHAR(50)
		DECLARE @AccountSegment10 VARCHAR(100)
		DECLARE @AccountName VARCHAR(200)
		DECLARE BalancesTempTable_NewAccounts CURSOR FOR
		SELECT DISTINCT
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
		WHERE AccountPKID IS NULL
	
		OPEN BalancesTempTable_NewAccounts
		FETCH BalancesTempTable_NewAccounts INTO 
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
			INSERT INTO Accounts(DateLastImported,DateActivated)
				VALUES(GETDATE(),GETDATE())
			SELECT @ErrorVar=@@error
			IF (@ErrorVar<>0)
			BEGIN
				SET @IsError=1
				SET @Error_Code = @ErrorVar
				SET @Error_TTPKID = 0
				SET @Error_QueryCode = 'Inserting new record in Accounts '
				GOTO ExitPoint
			END
			SET @AccountPKId = IDENT_CURRENT('Accounts') 
			
			INSERT INTO AccountSegments(AccountId,AccountSegment1,AccountSegment2,AccountSegment3,AccountSegment4,AccountSegment5,AccountSegment6,AccountSegment7,AccountSegment8,AccountSegment9,AccountSegment10)
				    VALUES(@AccountPKId, @AccountSegment1,@AccountSegment2,@AccountSegment3,@AccountSegment4,@AccountSegment5,@AccountSegment6,@AccountSegment7,@AccountSegment8,@AccountSegment9,@AccountSegment10)
			SELECT @ErrorVar=@@error
			IF (@ErrorVar<>0)
			BEGIN
				SET @IsError=1
				SET @Error_Code = @ErrorVar
				SET @Error_TTPKID = 0
				SET @Error_QueryCode = 'Inserting new record in AccountSegments '
				GOTO ExitPoint
			END
			UPDATE BalancesTempTable 
			SET BalancesTempTable.AccountPKID = @AccountPKId
			WHERE
			    ISNULL(AccountSegment1,'^')=ISNULL(@AccountSegment1,'^') AND 
				ISNULL(AccountSegment2,'^')=ISNULL(@AccountSegment2,'^') AND
				ISNULL(AccountSegment3,'^')=ISNULL(@AccountSegment3,'^') AND 
				ISNULL(AccountSegment4,'^')=ISNULL(@AccountSegment4,'^') AND
				ISNULL(AccountSegment5,'^')=ISNULL(@AccountSegment5,'^') AND 
				ISNULL(AccountSegment6,'^')=ISNULL(@AccountSegment6,'^') AND 
				ISNULL(AccountSegment7,'^')=ISNULL(@AccountSegment7,'^') AND
				ISNULL(AccountSegment8,'^')=ISNULL(@AccountSegment8,'^') AND 
				ISNULL(AccountSegment9,'^')=ISNULL(@AccountSegment9,'^') AND 
				ISNULL(AccountSegment10,'^')=ISNULL(@AccountSegment10,'^')
			IF (@ErrorVar<>0)
			BEGIN
				SET @IsError=1
				SET @Error_Code = @ErrorVar
				SET @Error_TTPKID = 0
				SET @Error_QueryCode = ' Updating BalancesTempTable with new AccountPKId  '
				GOTO ExitPoint
			END
			
			UPDATE Accounts 
				SET Accounts.AccountName = BalancesTempTable.AccountName,
				    Accounts.CCY1Code = BalancesTempTable.CCY1Code,
				    Accounts.CCY2Code = BalancesTempTable.CCY2Code,
				    Accounts.CCY3Code = BalancesTempTable.CCY3Code
			FROM Accounts
			JOIN BalancesTempTable 
					ON Accounts.PKId=BalancesTempTable.AccountPKID
			WHERE BalancesTempTable.PKId = (SELECT MIN(PKId) FROM BalancesTempTable WHERE BalancesTempTable.AccountPKID = @AccountPKId)
			
			IF (@ErrorVar<>0)
			BEGIN
				SET @IsError=1
				SET @Error_Code = @ErrorVar
				SET @Error_TTPKID = 0
				SET @Error_QueryCode = ' Updating AccountName and CCYCodes with new AccountPKId  '
				GOTO ExitPoint
			END				
				
	
			FETCH BalancesTempTable_NewAccounts INTO 
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
	
		CLOSE BalancesTempTable_NewAccounts
		DEALLOCATE BalancesTempTable_NewAccounts
		PRINT 'Finished Insert into Account and AccountSegments table: ' + CONVERT(VARCHAR,GETDATE())
		
		PRINT 'Beginning Set Update Flag: ' + CONVERT(VARCHAR,GETDATE())	
		UPDATE BalancesTempTable 
			SET 	GLHistoryUpdatedFlag = 1	
				FROM BalancesTempTable  
					JOIN  GLHistory ON GLHistory.AccountID=BalancesTempTable.AccountPKID AND GLHistory.EffectiveDate=BalancesTempTable.EffectiveDate
					AND ISNULL(GLHistory.CCY1Code,'0')=ISNULL(BalancesTempTable.CCY1Code,'0')
					AND ISNULL(GLHistory.CCY2Code,'0')=ISNULL(BalancesTempTable.CCY2Code,'0')
					AND ISNULL(GLHistory.CCY3Code,'0')=ISNULL(BalancesTempTable.CCY3Code,'0')
		SELECT @ErrorVar=@@error
		IF(@ErrorVar <>0 )
		BEGIN
			SET @IsError=1
			SET @Error_Code = @ErrorVar
			SET @Error_TTPKID = 0
			SET @Error_QueryCode = 'Setting Update Flag '
			GOTO ExitPoint
		END
		PRINT 'Finished Set Update Flag: ' + CONVERT(VARCHAR,GETDATE())
		
		PRINT 'Beginning Set Total Updated Count: ' + CONVERT(VARCHAR,GETDATE())	
		SELECT @TotalUpdated=COUNT(GLHistoryUpdatedFlag)	
				FROM BalancesTempTable  
					WHERE GLHistoryUpdatedFlag=1
		SELECT @ErrorVar=@@error
		IF(@ErrorVar <>0 )
		BEGIN
			SET @IsError=1
			SET @Error_Code = @ErrorVar
			SET @Error_TTPKID = 0
			SET @Error_QueryCode = 'Setting Total Updated Count '
			GOTO ExitPoint
		END
		PRINT 'Finished Set Update Flag: ' + CONVERT(VARCHAR,GETDATE())
	
		PRINT 'Beginning Updating GLHistory: ' + CONVERT(VARCHAR,GETDATE())	
		UPDATE GLHistory 
		SET 	GLHistory.EffectiveDate=BalancesTempTable.EffectiveDate, 
				GLHistory.FiscalMonth=BalancesTempTable.Period,
				GLHistory.FiscalYear=BalancesTempTable.Year,
				GLHistory.CCY1Code=BalancesTempTable.CCY1Code,
				GLHistory.CCY1GLEndBalance=BalancesTempTable.CCY1EndBalance,
				GLHistory.CCY2Code=BalancesTempTable.CCY2Code,
				GLHistory.CCY2GLEndBalance=BalancesTempTable.CCY2EndBalance,			
				GLHistory.CCY3Code=BalancesTempTable.CCY3Code,
				GLHistory.CCY3GLEndBalance=BalancesTempTable.CCY3EndBalance,
				GLHistory.BalanceChange = 1
		FROM GLHistory  
		JOIN BalancesTempTable ON GLHistory.AccountID=BalancesTempTable.AccountPKID AND GLHistory.EffectiveDate=BalancesTempTable.EffectiveDate
			AND ISNULL(GLHistory.CCY1Code,'0')=ISNULL(BalancesTempTable.CCY1Code,'0')
			AND ISNULL(GLHistory.CCY2Code,'0')=ISNULL(BalancesTempTable.CCY2Code,'0')
			AND ISNULL(GLHistory.CCY3Code,'0')=ISNULL(BalancesTempTable.CCY3Code,'0')
		WHERE ISNULL(GLHistory.CCY1GLEndBalance,0) <> BalancesTempTable.CCY1EndBalance
				OR ISNULL(GLHistory.CCY2GLEndBalance,0) <> BalancesTempTable.CCY2EndBalance
				OR ISNULL(GLHistory.CCY3GLEndBalance,0) <> BalancesTempTable.CCY3EndBalance
		SELECT @ErrorVar=@@error
		IF(@ErrorVar<>0 )
      BEGIN
      SET @IsError=1
      SET @Error_Code = @ErrorVar
      SET @Error_TTPKID = 0
      SET @Error_QueryCode = ' Updating GLHistory table '
      GOTO ExitPoint
      END
      PRINT 'Finished Updating GLHistory: ' + CONVERT(VARCHAR,GETDATE())

      PRINT 'Beginning Updating GLHistory Related Records: ' + CONVERT(VARCHAR,GETDATE())
      UPDATE GLHistory
      SET BalanceChange = 1
      FROM GLHistory
      JOIN (SELECT AccountID,EffectiveDate FROM GLHistory WHERE BalanceChange = 1) AS BalanceChange
      ON GLHistory.AccountID = BalanceChange.AccountID
      AND GLHistory.EffectiveDate = BalanceChange.EffectiveDate
      SELECT @ErrorVar=@@error
      IF(@ErrorVar<>0 )
      BEGIN
      SET @IsError=1
      SET @Error_Code = @ErrorVar
      SET @Error_TTPKID = 0
      SET @Error_QueryCode = ' Updating GLHistory table for related records '
      GOTO ExitPoint
      END
      PRINT 'Finished Updating GLHistory Related Records: ' + CONVERT(VARCHAR,GETDATE())

      PRINT 'Beginning Insert into GLHistory: ' + CONVERT(VARCHAR,GETDATE())
      INSERT INTO GLHistory(AccountID, EffectiveDate,CCY1Code,CCY1GLEndBalance,
      CCY2Code,CCY2GLEndBalance,
      CCY3Code,CCY3GLEndBalance,FiscalMonth,FiscalYear,BalanceChange
      )
      (SELECT AccountPKID, EffectiveDate,
      CCY1Code, CCY1EndBalance,
      CCY2Code, CCY2EndBalance,
      CCY3Code, CCY3EndBalance,
      Period, Year, 1
      FROM BalancesTempTable
      WHERE GLHistoryUpdatedFlag = 0)
      SELECT @ErrorVar=@@error,@TotalInserted=@@RowCount
      IF(@ErrorVar<>0 )
		BEGIN
			SET @IsError=1
			SET @Error_Code = @ErrorVar
			SET @Error_TTPKID = 0
			SET @Error_QueryCode = 'Inserting new record in GLHistory '
			GOTO ExitPoint
		END	
		PRINT 'Finished Insert into GLHistory: ' + CONVERT(VARCHAR,GETDATE())
	
		PRINT 'Beginning Updating Reconciliation_Balances for CCY1Code for accounts reconcilied individually: ' + CONVERT(VARCHAR,GETDATE())
		UPDATE Reconciliations_Balances SET CCY1GLEndBalance = Balances.SumCCY1GLEndBalance,CCY1GLActivity=Balances.SumCCY1GLEndBalance-ISNULL(CCY1GLBegBalance,0)
		FROM Reconciliations_Balances
		 JOIN (
			SELECT GLHistory.AccountID, GLHistory.CCY1Code, GLHistory.EffectiveDate, Reconciliations.PKId AS RecId,SUM(ISNULL(GLHistory.CCY1GLEndBalance,0)) AS SumCCY1GLEndBalance  
			FROM GLHistory 
			JOIN Reconciliations
				ON GLHistory.AccountID = Reconciliations.AccountID
					AND GLHistory.EffectiveDate = Reconciliations.EffectiveDate
			WHERE GLHistory.BalanceChange=1
			GROUP BY 
				GLHistory.AccountID, GLHistory.CCY1Code, GLHistory.EffectiveDate, Reconciliations.PKId ) AS Balances
		ON Reconciliations_Balances.ReconciliationID = Balances.RecId AND Reconciliations_Balances.CCY1Code = Balances.CCY1Code
		SELECT @ErrorVar=@@error
		IF(@ErrorVar<>0)
		BEGIN
			SET @IsError=1
			SET @Error_Code = @ErrorVar
			SET @Error_TTPKID = 0
			SET @Error_QueryCode = 'Updating CCY1 records in Reconciliation_Balances for accounts reconcilied individually '
			GOTO ExitPoint
		END
		PRINT 'Finished Updating Reconciliation_Balances for CCY1Code for accounts reconcilied individually: ' + CONVERT(VARCHAR,GETDATE())
	
		PRINT 'Beginning Updating Reconciliation_Balances for CCY2Code for accounts reconcilied individually: ' + CONVERT(VARCHAR,GETDATE())
		UPDATE Reconciliations_Balances SET CCY2GLEndBalance = Balances.SumCCY2GLEndBalance,CCY2GLActivity=Balances.SumCCY2GLEndBalance-ISNULL(CCY2GLBegBalance,0)
		FROM Reconciliations_Balances
		 JOIN (
			SELECT GLHistory.AccountID, GLHistory.CCY2Code, GLHistory.EffectiveDate, Reconciliations.PKId AS RecId,SUM(ISNULL(GLHistory.CCY2GLEndBalance,0)) AS SumCCY2GLEndBalance  
			FROM GLHistory 
			JOIN Reconciliations
				ON GLHistory.AccountID = Reconciliations.AccountID
					AND GLHistory.EffectiveDate = Reconciliations.EffectiveDate
			WHERE GLHistory.BalanceChange=1
			GROUP BY 
				GLHistory.AccountID, GLHistory.CCY2Code, GLHistory.EffectiveDate, Reconciliations.PKId ) AS Balances
		ON Reconciliations_Balances.ReconciliationID = Balances.RecId AND Reconciliations_Balances.CCY2Code = Balances.CCY2Code
		SELECT @ErrorVar=@@error
		IF(@ErrorVar<>0)
		BEGIN
			SET @IsError=1
			SET @Error_Code = @ErrorVar
			SET @Error_TTPKID = 0
			SET @Error_QueryCode = 'Updating CCY2 records in Reconciliation_Balances for accounts reconcilied individually '
			GOTO ExitPoint
		END
		PRINT 'Finished Updating Reconciliation_Balances for CCY2Code for accounts reconcilied individually: ' + CONVERT(VARCHAR,GETDATE())
	
		PRINT 'Beginning Updating Reconciliation_Balances for CCY3Code for accounts reconcilied individually: ' + CONVERT(VARCHAR,GETDATE())
		UPDATE Reconciliations_Balances SET CCY3GLEndBalance = Balances.SumCCY3GLEndBalance,CCY3GLActivity=Balances.SumCCY3GLEndBalance-ISNULL(CCY3GLBegBalance,0)
		FROM Reconciliations_Balances
		 JOIN (
			SELECT GLHistory.AccountID, GLHistory.CCY3Code, GLHistory.EffectiveDate, Reconciliations.PKId AS RecId,SUM(ISNULL(GLHistory.CCY3GLEndBalance,0)) AS SumCCY3GLEndBalance  
			FROM GLHistory 
			JOIN Reconciliations
				ON GLHistory.AccountID = Reconciliations.AccountID
					AND GLHistory.EffectiveDate = Reconciliations.EffectiveDate
			WHERE GLHistory.BalanceChange=1
			GROUP BY 
				GLHistory.AccountID, GLHistory.CCY3Code, GLHistory.EffectiveDate, Reconciliations.PKId ) AS Balances
		ON Reconciliations_Balances.ReconciliationID = Balances.RecId AND Reconciliations_Balances.CCY3Code = Balances.CCY3Code
		SELECT @ErrorVar=@@error
		IF(@ErrorVar<>0)
		BEGIN
			SET @IsError=1
			SET @Error_Code = @ErrorVar
			SET @Error_TTPKID = 0
			SET @Error_QueryCode = 'Updating CCY3 records in Reconciliation_Balances for accounts reconcilied individually'
			GOTO ExitPoint
		END
		PRINT 'Finished Updating Reconciliation_Balances for CCY3Code for accounts reconcilied individually: ' + CONVERT(VARCHAR,GETDATE())	
		
		PRINT 'Beginning Insert new Reconciliation Balance (CCY1Code) for accounts reconcilied individually: ' + CONVERT(VARCHAR,GETDATE())
		INSERT INTO Reconciliations_Balances (ReconciliationID,CCY1Code,CCY1GLEndBalance,CCY1GLActivity)
		SELECT Reconciliations.PKId AS RecId, GLHistory.CCY1Code, SUM(ISNULL(GLHistory.CCY1GLEndBalance,0)), SUM(ISNULL(GLHistory.CCY1GLEndBalance,0))
			FROM GLHistory 
				JOIN Reconciliations
					ON GLHistory.AccountID = Reconciliations.AccountID
					AND GLHistory.EffectiveDate = Reconciliations.EffectiveDate
					WHERE GLHistory.BalanceChange=1 AND (SELECT COUNT(Reconciliations_Balances.PKId) FROM Reconciliations_Balances 
															WHERE Reconciliations_Balances.ReconciliationID = Reconciliations.PKId AND																											
															Reconciliations_Balances.CCY1Code = GLHistory.CCY1Code)=0 AND GLHistory.CCY1Code IS NOT NULL AND Reconciliations.CCY1GenerateBalance = 1
			GROUP BY 
				GLHistory.AccountID, GLHistory.CCY1Code, GLHistory.EffectiveDate, Reconciliations.PKId
		SELECT @ErrorVar=@@error
		IF(@ErrorVar<>0)
		BEGIN
			SET @IsError=1
			SET @Error_Code = @ErrorVar
			SET @Error_TTPKID = 0
			SET @Error_QueryCode = 'Insert new Reconciliation Balance (CCY1Code) for accounts reconcilied individually '
			GOTO ExitPoint
		END
		PRINT 'Finished Insert new Reconciliation Balance (CCY1Code) for accounts reconcilied individually: ' + CONVERT(VARCHAR,GETDATE())
	
		PRINT 'Beginning Insert new Reconciliation Balance (CCY2Code) for accounts reconcilied individually: ' + CONVERT(VARCHAR,GETDATE())
		INSERT INTO Reconciliations_Balances (ReconciliationID,CCY2Code,CCY2GLEndBalance,CCY2GLActivity)
		SELECT Reconciliations.PKId AS RecId, GLHistory.CCY2Code, SUM(ISNULL(GLHistory.CCY2GLEndBalance,0)), SUM(ISNULL(GLHistory.CCY2GLEndBalance,0))
			FROM GLHistory 
				JOIN Reconciliations
					ON GLHistory.AccountID = Reconciliations.AccountID
					AND GLHistory.EffectiveDate = Reconciliations.EffectiveDate
					WHERE GLHistory.BalanceChange=1 AND (SELECT COUNT(Reconciliations_Balances.PKId) FROM Reconciliations_Balances 
															WHERE Reconciliations_Balances.ReconciliationID = Reconciliations.PKId AND																											
															Reconciliations_Balances.CCY2Code = GLHistory.CCY2Code)=0 AND GLHistory.CCY2Code IS NOT NULL AND Reconciliations.CCY2GenerateBalance = 1
			GROUP BY 
				GLHistory.AccountID, GLHistory.CCY2Code, GLHistory.EffectiveDate, Reconciliations.PKId
		SELECT @ErrorVar=@@error
		IF(@ErrorVar<>0)
		BEGIN
			SET @IsError=1
			SET @Error_Code = @ErrorVar
			SET @Error_TTPKID = 0
			SET @Error_QueryCode = 'Insert new Reconciliation Balance (CCY2Code) for accounts reconcilied individually '
			GOTO ExitPoint
		END
		PRINT 'Finished Insert new Reconciliation Balance (CCY2Code) for accounts reconcilied individually: ' + CONVERT(VARCHAR,GETDATE())
	
		PRINT 'Beginning Insert new Reconciliation Balance (CCY3Code) for accounts reconcilied individually: ' + CONVERT(VARCHAR,GETDATE())
		INSERT INTO Reconciliations_Balances (ReconciliationID,CCY3Code,CCY3GLEndBalance,CCY3GLActivity)
		SELECT Reconciliations.PKId AS RecId, GLHistory.CCY3Code, SUM(ISNULL(GLHistory.CCY3GLEndBalance,0)), SUM(ISNULL(GLHistory.CCY3GLEndBalance,0))
			FROM GLHistory 
				JOIN Reconciliations
					ON GLHistory.AccountID = Reconciliations.AccountID
					AND GLHistory.EffectiveDate = Reconciliations.EffectiveDate
					WHERE GLHistory.BalanceChange=1 AND (SELECT COUNT(Reconciliations_Balances.PKId) FROM Reconciliations_Balances 
															WHERE Reconciliations_Balances.ReconciliationID = Reconciliations.PKId AND																											
															Reconciliations_Balances.CCY3Code = GLHistory.CCY3Code)=0 AND GLHistory.CCY3Code IS NOT NULL AND Reconciliations.CCY3GenerateBalance = 1
			GROUP BY 
				GLHistory.AccountID, GLHistory.CCY3Code, GLHistory.EffectiveDate, Reconciliations.PKId
		SELECT @ErrorVar=@@error
		IF(@ErrorVar<>0)
		BEGIN
			SET @IsError=1
			SET @Error_Code = @ErrorVar
			SET @Error_TTPKID = 0
			SET @Error_QueryCode = 'Insert new Reconciliation Balance (CCY3Code) for accounts reconcilied individually '
			GOTO ExitPoint
		END
		PRINT 'Finished Insert new Reconciliation Balance (CCY3Code) for accounts reconcilied individually: ' + CONVERT(VARCHAR,GETDATE())
		
		PRINT 'Beginning Updating PendingBalanceUpdate for reconciliations with a balance change and reconcilied individually: ' + CONVERT(VARCHAR,GETDATE())
		UPDATE Reconciliations SET PendingBalanceUpdate=1
		WHERE PKId IN (
			SELECT Reconciliations.PKId FROM Reconciliations
			JOIN GLHistory ON Reconciliations.AccountID = GLHistory.AccountID
								AND Reconciliations.EffectiveDate = GLHistory.EffectiveDate
			WHERE GLHistory.BalanceChange=1)
		SELECT @ErrorVar=@@error
		IF(@ErrorVar<>0)
		BEGIN
			SET @IsError=1
			SET @Error_Code = @ErrorVar
			SET @Error_TTPKID = 0
			SET @Error_QueryCode = 'Updating PendingBalanceUpdate for reconciliations with a balance change '
			GOTO ExitPoint
		END
		PRINT 'Finished Updating PendingBalanceUpdate for reconciliations with a balance change and reconcilied individually: ' + CONVERT(VARCHAR,GETDATE())
	
	--Group Logic
		PRINT 'Beginning Updating PendingBalanceUpdate for reconciliations with a balance change and reconcilied as a group: ' + CONVERT(VARCHAR,GETDATE())
		UPDATE Reconciliations SET PendingBalanceUpdate=1
		WHERE PKId IN (
			SELECT RecGroupMembers.RecId FROM GLHistory
			JOIN 
			(SELECT Reconciliations.PKId AS RecId,Reconciliations.AccountID AS ParentAccount,		Reconciliations.EffectiveDate,Reconciliations_groupMembers.AccountId AS ChildAccount
			FROM Reconciliations
				JOIN Reconciliations_groupMembers
				ON Reconciliations_groupMembers.ReconciliationId = Reconciliations.PKId) AS	RecGroupMembers
			ON GLHistory.EffectiveDate = RecGroupMembers.EffectiveDate
			AND GLHistory.AccountID = RecGroupMembers.ChildAccount
	WHERE GLHistory.BalanceChange=1)
		SELECT @ErrorVar=@@error
		IF(@ErrorVar<>0)
		BEGIN
			SET @IsError=1
			SET @Error_Code = @ErrorVar
			SET @Error_TTPKID = 0
			SET @Error_QueryCode = 'Updating PendingBalanceUpdate for reconciliations with a balance change '
			GOTO ExitPoint
		END
		PRINT 'Finished Updating PendingBalanceUpdate for reconciliations with a balance change and reconcilied as a group: ' + CONVERT(VARCHAR,GETDATE())
	
		PRINT 'Beginning Updating Reconciliation_Balances for CCY1Code for accounts reconcilied at the group level: ' + CONVERT(VARCHAR,GETDATE())
		UPDATE Reconciliations_Balances SET CCY1GLEndBalance = Balances.SumCCY1GLEndBalance,CCY1GLActivity=Balances.SumCCY1GLEndBalance-ISNULL(CCY1GLBegBalance,0)
		FROM Reconciliations_Balances
		 JOIN (
			SELECT Reconciliations.PKId AS RecId, GLHistory.CCY1Code, SUM(ISNULL(GLHistory.CCY1GLEndBalance,0)) AS SumCCY1GLEndBalance
			FROM Reconciliations
			JOIN Accounts 
				ON Reconciliations.AccountID = Accounts.PKId
			JOIN Reconciliations_groupMembers ON Reconciliations.PKId = Reconciliations_groupMembers.ReconciliationId
			JOIN GLHistory ON Reconciliations.EffectiveDate = GLHistory.EffectiveDate
						   AND GLHistory.AccountID = Reconciliations_groupMembers.AccountId
			WHERE PendingBalanceUpdate=1 AND Accounts.IsGroup=1 AND GLHistory.CCY1Code IS NOT NULL
			GROUP BY Reconciliations.PKId,GLHistory.CCY1Code) AS Balances
	ON Reconciliations_Balances.ReconciliationID = Balances.RecId AND Reconciliations_Balances.CCY1Code = Balances.CCY1Code
		SELECT @ErrorVar=@@error
		IF(@ErrorVar<>0)
		BEGIN
			SET @IsError=1
			SET @Error_Code = @ErrorVar
			SET @Error_TTPKID = 0
			SET @Error_QueryCode = 'Updating CCY1 records in Reconciliation_Balances for accounts reconcilied at the group level '
			GOTO ExitPoint
		END
		PRINT 'Finished Updating Reconciliation_Balances for CCY1Code for accounts reconcilied at the group level: ' + CONVERT(VARCHAR,GETDATE())
		
	
		PRINT 'Beginning Updating Reconciliation_Balances for CCY2Code for accounts reconcilied at the group level: ' + CONVERT(VARCHAR,GETDATE())
		UPDATE Reconciliations_Balances SET CCY2GLEndBalance = Balances.SumCCY2GLEndBalance,CCY2GLActivity=Balances.SumCCY2GLEndBalance-ISNULL(CCY2GLBegBalance,0)
		FROM Reconciliations_Balances
		 JOIN (
			SELECT Reconciliations.PKId AS RecId, GLHistory.CCY2Code, SUM(ISNULL(GLHistory.CCY2GLEndBalance,0)) AS SumCCY2GLEndBalance
			FROM Reconciliations
			JOIN Accounts 
				ON Reconciliations.AccountID = Accounts.PKId
			JOIN Reconciliations_groupMembers ON Reconciliations.PKId = Reconciliations_groupMembers.ReconciliationId
			JOIN GLHistory ON Reconciliations.EffectiveDate = GLHistory.EffectiveDate
						   AND GLHistory.AccountID = Reconciliations_groupMembers.AccountId
			WHERE PendingBalanceUpdate=1 AND Accounts.IsGroup=1 AND GLHistory.CCY2Code IS NOT NULL
			GROUP BY Reconciliations.PKId,GLHistory.CCY2Code) AS Balances
	ON Reconciliations_Balances.ReconciliationID = Balances.RecId AND Reconciliations_Balances.CCY2Code = Balances.CCY2Code
		SELECT @ErrorVar=@@error
		IF(@ErrorVar<>0)
		BEGIN
			SET @IsError=1
			SET @Error_Code = @ErrorVar
			SET @Error_TTPKID = 0
			SET @Error_QueryCode = 'Updating CCY2 records in Reconciliation_Balances for accounts reconcilied at the group level '
			GOTO ExitPoint
		END
		PRINT 'Finished Updating Reconciliation_Balances for CCY2Code for accounts reconcilied at the group level: ' + CONVERT(VARCHAR,GETDATE()) 
	
		PRINT 'Beginning Updating Reconciliation_Balances for CCY3Code for accounts reconcilied at the group level: ' + CONVERT(VARCHAR,GETDATE())
		UPDATE Reconciliations_Balances SET CCY3GLEndBalance = Balances.SumCCY3GLEndBalance,CCY3GLActivity=Balances.SumCCY3GLEndBalance-ISNULL(CCY3GLBegBalance,0)
		FROM Reconciliations_Balances
		 JOIN (
			SELECT Reconciliations.PKId AS RecId, GLHistory.CCY3Code, SUM(ISNULL(GLHistory.CCY3GLEndBalance,0)) AS SumCCY3GLEndBalance
			FROM Reconciliations
			JOIN Accounts 
				ON Reconciliations.AccountID = Accounts.PKId
			JOIN Reconciliations_groupMembers ON Reconciliations.PKId = Reconciliations_groupMembers.ReconciliationId
			JOIN GLHistory ON Reconciliations.EffectiveDate = GLHistory.EffectiveDate
						   AND GLHistory.AccountID = Reconciliations_groupMembers.AccountId
			WHERE PendingBalanceUpdate=1 AND Accounts.IsGroup=1 AND GLHistory.CCY3Code IS NOT NULL
			GROUP BY Reconciliations.PKId,GLHistory.CCY3Code) AS Balances
	ON Reconciliations_Balances.ReconciliationID = Balances.RecId AND Reconciliations_Balances.CCY3Code = Balances.CCY3Code
		SELECT @ErrorVar=@@error
		IF(@ErrorVar<>0)
		BEGIN
			SET @IsError=1
			SET @Error_Code = @ErrorVar
			SET @Error_TTPKID = 0
			SET @Error_QueryCode = 'Updating CCY3 records in Reconciliation_Balances for accounts reconcilied at the group level '
			GOTO ExitPoint
		END
		PRINT 'Finished Updating Reconciliation_Balances for CCY3Code for accounts reconcilied at the group level: ' + CONVERT(VARCHAR,GETDATE())
	
		PRINT 'Beginning Insert Reconciliation_Balances for CCY1Code for accounts reconcilied at the group level: ' + CONVERT(VARCHAR,GETDATE())
		INSERT INTO Reconciliations_Balances (ReconciliationID,CCY1Code,CCY1GLEndBalance,CCY1GLActivity)
			SELECT Reconciliations.PKId AS RecId, GLHistory.CCY1Code, SUM(ISNULL(GLHistory.CCY1GLEndBalance,0)), SUM(ISNULL(GLHistory.CCY1GLEndBalance,0))
			FROM Reconciliations
			JOIN Accounts 
				ON Reconciliations.AccountID = Accounts.PKId
			JOIN Reconciliations_groupMembers ON Reconciliations.PKId = Reconciliations_groupMembers.ReconciliationId
			JOIN GLHistory ON Reconciliations.EffectiveDate = GLHistory.EffectiveDate
						   AND GLHistory.AccountID = Reconciliations_groupMembers.AccountId
			WHERE PendingBalanceUpdate=1 AND Accounts.IsGroup=1 AND GLHistory.CCY1Code IS NOT NULL AND (SELECT COUNT(Reconciliations_Balances.PKId) FROM Reconciliations_Balances 
															WHERE Reconciliations_Balances.ReconciliationID = Reconciliations.PKId AND																											
															Reconciliations_Balances.CCY1Code = GLHistory.CCY1Code)=0 AND GLHistory.CCY1Code IS NOT NULL AND Reconciliations.CCY1GenerateBalance = 1
			GROUP BY Reconciliations.PKId,GLHistory.CCY1Code
		SELECT @ErrorVar=@@error
		IF(@ErrorVar<>0)
		BEGIN
			SET @IsError=1
			SET @Error_Code = @ErrorVar
			SET @Error_TTPKID = 0
			SET @Error_QueryCode = 'Insert CCY1 records in Reconciliation_Balances for accounts reconcilied at the group level '
			GOTO ExitPoint
		END
		PRINT 'Finished Insert Reconciliation_Balances for CCY1Code for accounts reconcilied at the group level: ' + CONVERT(VARCHAR,GETDATE())
	
		PRINT 'Beginning Insert Reconciliation_Balances for CCY2Code for accounts reconcilied at the group level: ' + CONVERT(VARCHAR,GETDATE())
		INSERT INTO Reconciliations_Balances (ReconciliationID,CCY2Code,CCY2GLEndBalance,CCY2GLActivity)
			SELECT Reconciliations.PKId AS RecId, GLHistory.CCY2Code, SUM(ISNULL(GLHistory.CCY2GLEndBalance,0)), SUM(ISNULL(GLHistory.CCY2GLEndBalance,0))
			FROM Reconciliations
			JOIN Accounts 
				ON Reconciliations.AccountID = Accounts.PKId
			JOIN Reconciliations_groupMembers ON Reconciliations.PKId = Reconciliations_groupMembers.ReconciliationId
			JOIN GLHistory ON Reconciliations.EffectiveDate = GLHistory.EffectiveDate
						   AND GLHistory.AccountID = Reconciliations_groupMembers.AccountId
			WHERE PendingBalanceUpdate=1 AND Accounts.IsGroup=1 AND GLHistory.CCY2Code IS NOT NULL AND (SELECT COUNT(Reconciliations_Balances.PKId) FROM Reconciliations_Balances 
															WHERE Reconciliations_Balances.ReconciliationID = Reconciliations.PKId AND																											
															Reconciliations_Balances.CCY2Code = GLHistory.CCY2Code)=0 AND GLHistory.CCY2Code IS NOT NULL AND Reconciliations.CCY2GenerateBalance = 1
			GROUP BY Reconciliations.PKId,GLHistory.CCY2Code
		SELECT @ErrorVar=@@error
		IF(@ErrorVar<>0)
		BEGIN
			SET @IsError=1
			SET @Error_Code = @ErrorVar
			SET @Error_TTPKID = 0
			SET @Error_QueryCode = 'Insert CCY2 records in Reconciliation_Balances for accounts reconcilied at the group level '
			GOTO ExitPoint
		END
		PRINT 'Finished Insert Reconciliation_Balances for CCY2Code for accounts reconcilied at the group level: ' + CONVERT(VARCHAR,GETDATE())
	
		PRINT 'Beginning Insert Reconciliation_Balances for CCY3Code for accounts reconcilied at the group level: ' + CONVERT(VARCHAR,GETDATE())
		INSERT INTO Reconciliations_Balances (ReconciliationID,CCY3Code,CCY3GLEndBalance,CCY3GLActivity)
			SELECT Reconciliations.PKId AS RecId, GLHistory.CCY3Code, SUM(ISNULL(GLHistory.CCY3GLEndBalance,0)), SUM(ISNULL(GLHistory.CCY3GLEndBalance,0))
			FROM Reconciliations
			JOIN Accounts 
				ON Reconciliations.AccountID = Accounts.PKId
			JOIN Reconciliations_groupMembers ON Reconciliations.PKId = Reconciliations_groupMembers.ReconciliationId
			JOIN GLHistory ON Reconciliations.EffectiveDate = GLHistory.EffectiveDate
						   AND GLHistory.AccountID = Reconciliations_groupMembers.AccountId
			WHERE PendingBalanceUpdate=1 AND Accounts.IsGroup=1 AND GLHistory.CCY3Code IS NOT NULL AND (SELECT COUNT(Reconciliations_Balances.PKId) FROM Reconciliations_Balances 
															WHERE Reconciliations_Balances.ReconciliationID = Reconciliations.PKId AND																											
															Reconciliations_Balances.CCY3Code = GLHistory.CCY3Code)=0 AND GLHistory.CCY3Code IS NOT NULL AND Reconciliations.CCY3GenerateBalance = 1 
			GROUP BY Reconciliations.PKId,GLHistory.CCY3Code
		SELECT @ErrorVar=@@error
		IF(@ErrorVar<>0)
		BEGIN
			SET @IsError=1
			SET @Error_Code = @ErrorVar
			SET @Error_TTPKID = 0
			SET @Error_QueryCode = 'Insert CCY3 records in Reconciliation_Balances for accounts reconcilied at the group level '
			GOTO ExitPoint
		END
		PRINT 'Finished Insert Reconciliation_Balances for CCY3Code for accounts reconcilied at the group level: ' + CONVERT(VARCHAR,GETDATE())
	
		---***************************************************Reconciliation History Balance Update Event *******************************************************---
		PRINT 'Beginning Insert Reconciliations_History for completed reconciliation: ' + CONVERT(VARCHAR,GETDATE())
		INSERT INTO Reconciliations_History (ReconciliationID, StatusDate, UserID, Type, StatusDetails)
						(SELECT PKId, GETDATE(), NULL, 'BU', dbo.fnGetApprovalStatusForInterfaceService(PKId) + dbo.fnGetReviewStatusForInterfaceService(PKId) + dbo.fnGetReconStatusForInterfaceService(PKId) 
						FROM Reconciliations 
						WHERE PendingBalanceUpdate=1 AND ReconciliationStatusID='C')
			SELECT @ErrorVar=@@error
			IF (@ErrorVar<>0)
			BEGIN
				
				SET @IsError=1
				SET @Error_Code = @ErrorVar
				SET @Error_TTPKID='0'
				SET @Error_QueryCode = 'Inserting new records into Reconciliations_History for completed reconciliation'
				GOTO ExitPoint
				
			END
			PRINT 'Finished Insert Reconciliations_History for completed reconciliation: ' + CONVERT(VARCHAR,GETDATE())
		
			PRINT 'Beginning updating ReviewStatusID = PRC of Reconciliations: ' + CONVERT(VARCHAR,GETDATE())
			UPDATE Reconciliations SET ReviewStatusID='PRC' WHERE PendingBalanceUpdate =1 AND ReviewStatusID IS NOT NULL AND ReviewStatusID <> 'R' AND ReconciliationStatusID='C'
			SELECT @ErrorVar=@@error
			IF (@ErrorVar<>0)
			BEGIN
				SET @IsError=1
				SET @Error_Code = @ErrorVar
				SET @Error_TTPKID='0'
				SET @Error_QueryCode = 'Updating ReviewStatusID = PRC of Reconciliations '
				GOTO ExitPoint
			END
			PRINT 'Finished updating ReviewStatusID = PRC of Reconciliations: ' + CONVERT(VARCHAR,GETDATE())
		
			PRINT 'Beginning updating ApprovalStatusID = PRC of Reconciliations: ' + CONVERT(VARCHAR,GETDATE())
			UPDATE Reconciliations SET ApprovalStatusID='PRC' WHERE PendingBalanceUpdate =1 AND ApprovalStatusID IS NOT NULL AND ApprovalStatusID <> 'R' AND ReconciliationStatusID='C'
			SELECT @ErrorVar=@@error
			IF (@ErrorVar<>0)
			BEGIN
				SET @IsError=1
				SET @Error_Code = @ErrorVar
				SET @Error_TTPKID='0'
				SET @Error_QueryCode = 'Updating ApprovalStatusID = PRC of Reconciliations '
				GOTO ExitPoint
			END
			PRINT 'Finished updating ApprovalStatusID = PRC of Reconciliations: ' + CONVERT(VARCHAR,GETDATE())
		
			PRINT 'Beginning Updating ReconcilerID=null, DateReviewed=null, ReviewerID=null, DateApproved=null, ApproverID=null of Reconciliations , ReconciliationStatusID=PM, PendingBalanceUpdate=0: ' + CONVERT(VARCHAR,GETDATE())
			UPDATE Reconciliations SET DateReconciled= NULL, 
				ReconcilerID=NULL, 
				DateReviewed=NULL, 
				ReviewerID=NULL,
				DateApproved=NULL,
				ApproverID=NULL,
				ReconciliationStatusID='PM',
				PendingBalanceUpdate =0
			WHERE PendingBalanceUpdate =1 AND ReconciliationStatusID='C'
			SELECT @ErrorVar=@@error
			IF (@ErrorVar<>0)
			BEGIN
				SET @IsError=1
				SET @Error_Code = @ErrorVar
				SET @Error_TTPKID='0'
				SET @Error_QueryCode = 'Updating ReconcilerID=null, DateReviewed=null, ReviewerID=null, DateApproved=null, ApproverID=null of Reconciliations , ReconciliationStatusID=PM, PendingBalanceUpdate =0'
				GOTO ExitPoint
			END	
			PRINT 'Finished Updating ReconcilerID=null, DateReviewed=null, ReviewerID=null, DateApproved=null, ApproverID=null of Reconciliations , ReconciliationStatusID=PM, PendingBalanceUpdate=0: ' + CONVERT(VARCHAR,GETDATE())
		
			PRINT 'Beginning Inserting new records into Reconciliations_History for non-completed reconciliation' + CONVERT(VARCHAR,GETDATE())
			INSERT INTO Reconciliations_History (ReconciliationID, StatusDate, UserID, Type, StatusDetails)
						(SELECT PKId, GETDATE(), NULL, 'BU', 'Balance Updated' FROM Reconciliations WHERE PendingBalanceUpdate=1 AND ReconciliationStatusID<>'C')
			SELECT @ErrorVar=@@error
			IF (@ErrorVar<>0)
			BEGIN
				SET @IsError=1
				SET @Error_Code = @ErrorVar
				SET @Error_TTPKID='0'
				SET @Error_QueryCode = 'Inserting new records into Reconciliations_History for non-completed reconciliation '
				GOTO ExitPoint
			END
			PRINT 'Finished Inserting new records into Reconciliations_History for non-completed reconciliation' + CONVERT(VARCHAR,GETDATE())
			
			PRINT 'Beginning Recalc Balances' + CONVERT(VARCHAR,GETDATE())
				DECLARE @ReconciliationId INT
				DECLARE ReconciliationCursor CURSOR FOR
					SELECT PKId FROM Reconciliations WHERE PendingBalanceUpdate=1
				OPEN ReconciliationCursor 
				FETCH NEXT FROM ReconciliationCursor INTO @ReconciliationId
				WHILE @@Fetch_Status = 0
				BEGIN
					EXEC usp_UpdateUnexplainedDiff @ReconciliationId
					FETCH NEXT FROM ReconciliationCursor INTO @ReconciliationId
				END
				
				CLOSE ReconciliationCursor				
				DEALLOCATE ReconciliationCursor
			PRINT 'Finished Recalc Balances' + CONVERT(VARCHAR,GETDATE())
		
			PRINT 'Beginning Updating PendingBalanceUpdate =0 of Reconciliations' + CONVERT(VARCHAR,GETDATE())
			UPDATE Reconciliations SET PendingBalanceUpdate=0 WHERE PendingBalanceUpdate=1
			--IF ANY ERROR OCCURED
			SELECT @ErrorVar=@@error
			IF (@ErrorVar<>0)
			BEGIN
				SET @IsError=1
				SET @Error_Code = @ErrorVar
				SET @Error_TTPKID='0'
				SET @Error_QueryCode = 'Updating PendingBalanceUpdate =0 of Reconciliations '
				GOTO ExitPoint
			END
			PRINT 'Updating PendingBalanceUpdate =0 of Reconciliations' + CONVERT(VARCHAR,GETDATE())
			
			PRINT 'Beginning Reset BalanceUpdate Flag: ' + CONVERT(VARCHAR,GETDATE())
			UPDATE GLHistory SET BalanceChange=0 WHERE BalanceChange=1
			SELECT @ErrorVar = @@ERROR	
			IF (@ErrorVar<>0)	-- Error executing sql
			BEGIN
				SET @IsError=1
				SET @Error_Code = @ErrorVar
				SET @Error_TTPKID = 0
				SET @Error_QueryCode = 'Resetting BalanceUpdate Flag '
				GOTO ExitPoint
			END
			PRINT 'Finished Reset BalanceUpdate Flag: ' + CONVERT(VARCHAR,GETDATE())
		
		
		
		
		---******************************************************************************************************************************************************---
		
		ValidationExitPoint:
			IF(@Result<0)
			BEGIN
				PRINT 'Exiting with error code: ' + CONVERT(VARCHAR,@Result)
				EXEC usp_AddToInterfaceHistory @InterfaceHistoryPKId,@InterfaceID,@CurrentDt,3,0,0,0,1,@StartTime,@CurrentDt,NULL,NULL
				IF(@Error_QueryCode IS NOT NULL)
					RAISERROR (@Error_QueryCode, 16, 1)
				ELSE
					RAISERROR ('Validation Error.', 16, 1)
				RETURN
			END
		
		ExitPoint:
		IF (@IsError=1)
			BEGIN
				PRINT 'rolledback'
				--Create Interface Error TAble
				--I changed the Error table name 'EventManagementNotes_Error' to 'InterfaceService_Error' to keep consistency
				ROLLBACK TRAN
			 	IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[InterfaceService_Error]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
			 		CREATE TABLE [dbo].[InterfaceService_Error](PKID INT IDENTITY(1,1), ErrorDate DATETIME, TempTablePKID VARCHAR(100), ErrorCode INT, ErrorQueryCode VARCHAR(500),InterfaceID INT) 
				INSERT INTO Interfaces_Error(ErrorDate, TempTablePKID , ErrorCode, ErrorQueryCode, InterfaceID,InterfaceHistoryPKId) VALUES(GETDATE(), ISNULL(@Error_TTPKID,0), @Error_Code, @Error_QueryCode, @InterfaceID,@InterfaceHistoryPKId )
				--all inserted and updated records have been rollback so all of these variable should be zero
				SET @TotalRecs =0
				SET @TotalInserted = 0
				SET @TotalUpdated = 0
				SET @EndTime = GETDATE()
				EXEC usp_AddToInterfaceHistory @InterfaceHistoryPKId,@InterfaceID,@CurrentDt,3,@TotalRecs, @TotalInserted, @TotalUpdated,0, @StartTime,@EndTime,NULL,NULL
				IF(@Error_QueryCode IS NOT NULL AND @Error_QueryCode != NULL)
					RAISERROR (@Error_QueryCode, 16, 1)
				ELSE
					RAISERROR ('Undeffined Error', 16, 1)
			END
		ELSE
		BEGIN
			COMMIT TRAN
			SET @TotalRecs = @TotalInserted + @TotalUpdated
			SET @EndTime = GETDATE()
			EXEC usp_AddToInterfaceHistory @InterfaceHistoryPKId,@InterfaceID,@CurrentDt,1,@TotalRecs, @TotalInserted, @TotalUpdated,0, @StartTime,@EndTime,NULL,NULL
		END

GO

