
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
