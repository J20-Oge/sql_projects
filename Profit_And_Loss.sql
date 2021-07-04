USE H_Accounting; -- Using The accounting database 


DROP PROCEDURE `p_&_l_kdrallos2020`; -- Dropping procedure in case it already exists


 
DELIMITER $$
	CREATE PROCEDURE `p_&_l_kdrallos2020` (VarCalendarYear YEAR) -- Creating a new procedure for profit and loss
    BEGIN 
SELECT 'REVENUE' AS 'Line Entry', @revenue := ROUND(SUM(jeli.credit),2) AS Total, YEAR(je.entry_date) AS entry_year
FROM journal_entry_line_item AS jeli
INNER JOIN account AS ac ON ac.account_id = jeli.account_id
INNER JOIN journal_entry AS je ON je.journal_entry_id = jeli.journal_entry_id
WHERE profit_loss_section_id = 68
AND YEAR(je.entry_date) = varCalendarYear
GROUP BY entry_year

UNION

SELECT 'COST OF GOODS AND SERVICES', @cogs := ROUND(SUM(jeli.debit),2), YEAR(je.entry_date) AS entry_year
FROM journal_entry_line_item AS jeli 
INNER JOIN account AS ac ON ac.account_id = jeli.account_id
INNER JOIN journal_entry AS je ON je.journal_entry_id = jeli.journal_entry_id
WHERE profit_loss_section_id = 74
AND YEAR(je.entry_date) = varCalendarYear
GROUP BY entry_year

UNION

SELECT 'RETURNS, REFUNDS, DISCOUNTS', @rrd := ROUND(SUM(jeli.debit),2), YEAR(je.entry_date) AS entry_year
FROM journal_entry_line_item AS jeli 
INNER JOIN account AS ac ON ac.account_id = jeli.account_id
INNER JOIN journal_entry AS je ON je.journal_entry_id = jeli.journal_entry_id
WHERE profit_loss_section_id = 69
AND YEAR(je.entry_date) = varCalendarYear
GROUP BY entry_year

UNION

SELECT 'ADMINISTRATIVE EXPENSES', @ae := ROUND(SUM(jeli.debit),2), YEAR(je.entry_date) AS entry_year
FROM journal_entry_line_item AS jeli 
INNER JOIN account AS ac ON ac.account_id = jeli.account_id
INNER JOIN journal_entry AS je ON je.journal_entry_id = jeli.journal_entry_id
WHERE profit_loss_section_id = 75
AND YEAR(je.entry_date) = varCalendarYear
GROUP BY entry_year

UNION

SELECT 'SELLING EXPENSES', @se := ROUND(SUM(jeli.debit),2), YEAR(je.entry_date) AS entry_year
FROM journal_entry_line_item AS jeli 
INNER JOIN account AS ac ON ac.account_id = jeli.account_id
INNER JOIN journal_entry AS je ON je.journal_entry_id = jeli.journal_entry_id
WHERE profit_loss_section_id = 76
AND YEAR(je.entry_date) = varCalendarYear
GROUP BY entry_year

UNION

SELECT 'OTHER EXPENSES', @oe := ROUND(SUM(jeli.debit),2), YEAR(je.entry_date) AS entry_year
FROM journal_entry_line_item AS jeli 
INNER JOIN account AS ac ON ac.account_id = jeli.account_id
INNER JOIN journal_entry AS je ON je.journal_entry_id = jeli.journal_entry_id
WHERE profit_loss_section_id = 77
AND YEAR(je.entry_date) = varCalendarYear
GROUP BY entry_year

UNION

SELECT 'OTHER INCOME', @oi := ROUND(SUM(jeli.credit),2), YEAR(je.entry_date) AS entry_year
FROM journal_entry_line_item AS jeli 
INNER JOIN account AS ac ON ac.account_id = jeli.account_id
INNER JOIN journal_entry AS je ON je.journal_entry_id = jeli.journal_entry_id
WHERE profit_loss_section_id = 78
AND YEAR(je.entry_date) = varCalendarYear
GROUP BY entry_year

UNION

SELECT 'INCOME TAX', @it :=ROUND(SUM(jeli.debit),2), YEAR(je.entry_date) AS entry_year
FROM journal_entry_line_item AS jeli 
INNER JOIN account AS ac ON ac.account_id = jeli.account_id
INNER JOIN journal_entry AS je ON je.journal_entry_id = jeli.journal_entry_id
WHERE profit_loss_section_id = 79
AND YEAR(je.entry_date) = varCalendarYear
GROUP BY entry_year

UNION

SELECT 'OTHER TAX', @ot := ROUND(SUM(jeli.debit),2), YEAR(je.entry_date) AS entry_year
FROM journal_entry_line_item AS jeli 
INNER JOIN account AS ac ON ac.account_id = jeli.account_id
INNER JOIN journal_entry AS je ON je.journal_entry_id = jeli.journal_entry_id
WHERE profit_loss_section_id = 80
AND YEAR(je.entry_date) = varCalendarYear
GROUP BY entry_year 

UNION ALL 

SELECT 'NET PROFIT', ROUND(IFNULL(@revenue,0) - IFNULL(@cogs,0)- IFNULL(@rrd,0) - IFNULL(@ae,0) - IFNULL(@se,0) 
- IFNULL(@oe,0) + IFNULL(@oi,0)), varCalendarYear
-- ONLY for the year 2016, the "-IFNULL(@it,0)" which is the variable for income tax
-- must be inculded in the SELECT statement in order to get the correct calculation.
 
-- When we included it for the years 2017,18 and 19, the NET PROFIT had the wrong output.

ORDER BY FIELD('REVENUE', 'COST OF GOODS AND SERVICES', 'RETURNS, REFUNDS, DISCOUNTS','ADMINISTRATIVE EXPENSES',
'SELLING EXPENSES', 'OTHER EXPENSES','OTHER INCOME','INCOME TAX','OTHER TAX');

    END $$ 
        DELIMITER 
        
CALL`p_&_l_kdrallos2020`(2019); ## Change the Year in order to get the desired outcome


