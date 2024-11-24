
--Запрос Q1: найти все расходы всех членов указанной семьи за заданный период.
SELECT 
    U.Name, 
    SUM(E.Amount)
FROM Families F
JOIN FamilyMembers FM ON F.FamilyID = FM.FamilyID
JOIN Users U ON FM.UserID = U.UserID
JOIN Expenses E ON U.UserID = E.UserID
WHERE F.FamilyID = 3
  AND E.Date BETWEEN '2024-11-01' AND '2024-11-02'
GROUP BY U.Name;

--Запрос Q2: найти всех пользователей, у которых сделано не менее десяти записей о расходах указанной категории.
SELECT 
    U.UserID, 
    U.Name
FROM Users U
JOIN Expenses E ON U.UserID = E.UserID
JOIN Categories C ON E.CategoryID = C.CategoryID
WHERE C.Name = 'Food'
GROUP BY U.UserID, U.Name
HAVING COUNT(E.ExpenseID) >= 10;

--Запрос Q3: рассчитать баланс расходов и доходов всех пользователей на заданный момент времени.  
SELECT 
    U.Name,
    SUM(I.Amount) AS TotalIncome,
    SUM(E.Amount) AS TotalExpense,
    SUM(I.Amount) - SUM(E.Amount) AS Net
FROM Users U
LEFT JOIN Incomes I ON U.UserID = I.UserID
LEFT JOIN Expenses E ON U.UserID = E.UserID
WHERE I.Date <= '2024-11-24' AND E.Date <= '2024-11-24'
GROUP BY U.UserID, U.Name;

--Запрос Q4: для каждой семьи найти пользователя, который за последний год потратил денег больше всех в семье, и пользователя, который за последний месяц принес денег больше всех в семье.

WITH MaxExpenseByFamily AS (
    SELECT 
        F.FamilyID,
        FM.UserID,
        SUM(E.Amount) AS TotalExpense
    FROM Families F
    JOIN FamilyMembers FM ON F.FamilyID = FM.FamilyID
    JOIN Expenses E ON FM.UserID = E.UserID
    WHERE E.Date >= CURRENT_DATE - INTERVAL '1 year'
    GROUP BY F.FamilyID, FM.UserID
),
    MaxExpenseByUser AS (
        SELECT 
            FamilyID, 
            UserID, 
            MAX(TotalExpense) AS MaxExpense
        FROM MaxExpenseByFamily
        GROUP BY FamilyID
),

    MaxIncomeByFamily AS (
        SELECT 
            F.FamilyID,
            FM.UserID,
            SUM(I.Amount) AS TotalIncome
        FROM Families F
        JOIN FamilyMembers FM ON F.FamilyID = FM.FamilyID
        JOIN Incomes I ON FM.UserID = I.UserID
        WHERE I.Date >= CURRENT_DATE - INTERVAL '1 month'
        GROUP BY F.FamilyID, FM.UserID
),
    MaxIncomeByUser AS (
        SELECT 
            FamilyID, 
            UserID, 
            MAX(TotalIncome) AS MaxIncome
        FROM MaxIncomeByFamily
        GROUP BY FamilyID
)

SELECT 
    F.FamilyName,
    U1.Name AS MaxSpend,
    U2.Name AS MaxEarn
FROM Families F
LEFT JOIN MaxExpenseByUser E ON F.FamilyID = E.FamilyID
LEFT JOIN MaxIncomeByUser I ON F.FamilyID = I.FamilyID
LEFT JOIN Users U1 ON E.MaxExpenseUserID = U1.UserID
LEFT JOIN Users U2 ON I.MaxIncomeUserID = U2.UserID;
