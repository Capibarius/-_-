--Задание 1. Реляционная модель
CREATE TABLE Users (
    UserID SERIAL PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(255) UNIQUE NOT NULL,
    RegistrationDate DATE NOT NULL DEFAULT CURRENT_DATE
);

CREATE TABLE Families (
    FamilyID SERIAL PRIMARY KEY,
    FamilyName VARCHAR(100) NOT NULL,
    CreationDate DATE NOT NULL DEFAULT CURRENT_DATE
);

CREATE TABLE Categories (
    CategoryID SERIAL PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Type CHAR(1) NOT NULL  -- i, e
);

CREATE TABLE Incomes (
    IncomeID SERIAL PRIMARY KEY,
    UserID INT NOT NULL,
    CategoryID INT NOT NULL,
    Amount NUMERIC(10, 2) NOT NULL,
    Date DATE NOT NULL,
    Source VARCHAR(255),
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);

CREATE TABLE Expenses (
    ExpenseID SERIAL PRIMARY KEY,
    UserID INT NOT NULL,
    CategoryID INT NOT NULL,
    Amount NUMERIC(10, 2) NOT NULL,
    Date DATE NOT NULL,
    Description TEXT,
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);

CREATE TABLE Budgets (
    BudgetID SERIAL PRIMARY KEY,
    UserID INT NOT NULL,
    Amount NUMERIC(10, 2) NOT NULL CHECK (Amount > 0),
    Period VARCHAR(50) NOT NULL,
    Status VARCHAR(20) NOT NULL DEFAULT 'In Progress',
    CreationDate DATE NOT NULL DEFAULT CURRENT_DATE,
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);
--Таблицы для связей
CREATE TABLE FamilyMembers (
    FamilyID INT NOT NULL,
    UserID INT NOT NULL,
    PRIMARY KEY (FamilyID, UserID),
    FOREIGN KEY (FamilyID) REFERENCES Families(FamilyID),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

CREATE TABLE BudgetCategories (
    BudgetID INT NOT NULL,
    CategoryID INT NOT NULL,
    PRIMARY KEY (BudgetID, CategoryID),
    FOREIGN KEY (BudgetID) REFERENCES Budgets(BudgetID),
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);

--Задание 2. Документная модель

--Запрос Q1: найти все расходы всех членов указанной семьи за заданный период.
{
    "FamilyID": "1",
    "FamilyName": "Kit",
    "Period": {
        "StartDate": "2024-11-01",
        "EndDate": "2024-11-03"
    },
    "Expenses": [
        {
            "ExpenseID": "1",
            "UserID": "10",
            "UserName": "Sasha",
            "Category": "Food",
            "Amount": 1500.00,
            "Date": "2024-11-01",
            "Description": "Groceries"
        },
        {
            "ExpenseID": "2",
            "UserID": "11",
            "UserName": "Olia",
            "Category": "Utilities",
            "Amount": 8000.00,
            "Date": "2024-11-02",
            "Description": "Electricity bill"
        }
    ]
}

--Запрос Q2: найти всех пользователей, у которых сделано не менее десяти записей о расходах указанной категории.
{
    "Category": "Food",
    "Users": [
        {
            "UserID": "10",
            "UserName": "Sasha",
            "ExpenseCount": 12,
            "TotalAmount": 1500.00
        },
        {
            "UserID": "12",
            "UserName": "Olia",
            "ExpenseCount": 11,
            "TotalAmount": 900.00
        }
    ]
}


--Запрос Q3: рассчитать баланс расходов и доходов всех пользователей на заданный момент времени.
{
    "UserID": "10",
    "UserName": "Sasha",
    "BalanceDate": "2024-11-15",
    "Balance": {
        "Income": 5000.00,
        "Expense": 3500.00,
        "Net": 1500.00
    }
}




--Задание 3. Модель «ключ-значение»

--Запрос Q1: найти все расходы всех членов указанной семьи за заданный период.
family:{FamilyID}:expenses:{YearMonth}
--Запрос Q2: найти всех пользователей, у которых сделано не менее десяти записей о расходах указанной категории.
category:{CategoryID}:users
--Запрос Q3: рассчитать баланс расходов и доходов всех пользователей на заданный момент времени.
user:{UserID}:balance:{Date}
