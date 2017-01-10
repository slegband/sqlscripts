SELECT ReconciliationScheduleID, NextReconEffDate, ReviewScheduleID, NextReviewEffDate, NextApprovalEffDate FROM accounts --1386928 row(s) affected)
SELECT COUNT(active) FROM accounts WHERE active =1 

SELECT * FROM dbo.Code_ReconciliationScheduleDates
SELECT * FROM dbo.Code_ApprovalScheduleDates
WHERE Sequence >91
SELECT * FROM dbo.Code_ApprovalScheduleDates
WHERE Sequence >91
UPDATE dbo.Code_ApprovalScheduleDates SET EffDate = '2016-01-30' WHERE Sequence = 93  
UPDATE dbo.Code_ApprovalScheduleDates SET EffDate = '2016-03-30' WHERE Sequence = 95  
UPDATE dbo.Code_ApprovalScheduleDates SET EffDate = '2016-04-30' WHERE Sequence = 96
UPDATE dbo.Code_ApprovalScheduleDates SET EffDate = '2016-05-30' WHERE Sequence = 97
UPDATE dbo.Code_ApprovalScheduleDates SET EffDate = '2016-06-30' WHERE Sequence = 98
UPDATE dbo.Code_ApprovalScheduleDates SET EffDate = '2016-07-30' WHERE Sequence = 99
UPDATE dbo.Code_ApprovalScheduleDates SET EffDate = '2016-08-30' WHERE Sequence = 100
UPDATE dbo.Code_ApprovalScheduleDates SET EffDate = '2016-09-30' WHERE Sequence = 101
UPDATE dbo.Code_ApprovalScheduleDates SET EffDate = '2016-10-30' WHERE Sequence = 102
UPDATE dbo.Code_ApprovalScheduleDates SET EffDate = '2016-11-30' WHERE Sequence = 103
UPDATE dbo.Code_ApprovalScheduleDates SET EffDate = '2016-12-30' WHERE Sequence = 104
UPDATE dbo.Code_ApprovalScheduleDates SET EffDate = '2017-01-30' WHERE Sequence = 105
UPDATE dbo.Code_ApprovalScheduleDates SET EffDate = '2017-02-28' WHERE Sequence = 106
UPDATE dbo.Code_ApprovalScheduleDates SET EffDate = '2017-03-30' WHERE Sequence = 107
UPDATE dbo.Code_ApprovalScheduleDates SET EffDate = '2017-04-30' WHERE Sequence = 108
UPDATE dbo.Code_ApprovalScheduleDates SET EffDate = '2017-05-30' WHERE Sequence = 109
UPDATE dbo.Code_ApprovalScheduleDates SET EffDate = '2017-06-30' WHERE Sequence = 110
UPDATE dbo.Code_ApprovalScheduleDates SET EffDate = '2017-07-30' WHERE Sequence = 111
UPDATE dbo.Code_ApprovalScheduleDates SET EffDate = '2017-08-30' WHERE Sequence = 112
UPDATE dbo.Code_ApprovalScheduleDates SET EffDate = '2017-09-30' WHERE Sequence = 113
UPDATE dbo.Code_ApprovalScheduleDates SET EffDate = '2017-10-30' WHERE Sequence = 114
UPDATE dbo.Code_ApprovalScheduleDates SET EffDate = '2017-11-30' WHERE Sequence = 115
UPDATE dbo.Code_ApprovalScheduleDates SET EffDate = '2017-12-30' WHERE Sequence = 116


UPDATE accounts 
SET NextReconEffDate =  '2016-02-28 00:00:00.000',
	NextReviewEffDate = '2016-02-28 00:00:00.000',
	NextApprovalEffDate = '2016-02-28 00:00:00.000',
	NextReconDueDate = '2016-02-04 00:00:00.000',
	NextReviewDueDate = '2016-02-06 00:00:00.000',
	NextApprovalDueDate = '2016-03-06 00:00:00.000'
