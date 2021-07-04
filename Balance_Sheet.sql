DROP PROCEDURE `balance_sheet_kdrallos2020`;
 -- Dropping the balance sheet procedure in case it already exists 


DELIMITER $$
	CREATE PROCEDURE `balance_sheet_kdrallos2020`(varCalendarYear YEAR) -- Creating the procedure 
    BEGIN
    
	SELECT statement_section AS Line_Item, ROUND(SUM(credit),2) AS Credit, ROUND(SUM(debit),2) AS Debit, FORMAT(SUM(jeli.debit) - SUM(jeli.credit), 2) AS Balance
		FROM journal_entry_line_item AS jeli
			INNER JOIN account ac ON ac.account_id = jeli.account_id
			INNER JOIN statement_section st ON st.statement_section_id = ac.balance_sheet_section_id
			INNER JOIN journal_entry je ON je.journal_entry_id = jeli.journal_entry_id
		WHERE st.statement_section_id IN (61, 62, 63, 64, 65, 66, 67)
		AND je.cancelled = 0
		AND je.debit_credit_balanced = 1    
		AND YEAR(je.entry_date) <= varCalendarYear
		GROUP BY st.statement_section
		ORDER BY FIELD(st.statement_section, 'CURRENT ASSETS', 'FIXED ASSETS', 'CURRENT LIABILITIES', 'EQUITY'); 
        
        END $$
        DELIMITER ;

CALL balance_sheet_kdrallos(2019); ## Change the year in order to get the desired output