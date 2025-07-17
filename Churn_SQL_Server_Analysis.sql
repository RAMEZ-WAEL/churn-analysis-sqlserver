
-- Query 1: Churn Rate by Country
SELECT 
    Geography,
    COUNT(CASE WHEN Exited = 1 THEN 1 END) * 100.0 / COUNT(*) AS ChurnRatePercent
FROM 
    Churn
GROUP BY 
    Geography
ORDER BY 
    ChurnRatePercent DESC;

-- Query 2: Average Balance & Salary by Activity and Churn
SELECT 
    IsActiveMember,
    Exited,
    ROUND(AVG(Balance), 2) AS AvgBalance,
    ROUND(AVG(EstimatedSalary), 2) AS AvgSalary
FROM 
    Churn
GROUP BY 
    IsActiveMember, Exited;

-- Query 3: Churn by Age Range
SELECT 
    CASE 
        WHEN Age < 30 THEN 'Under 30'
        WHEN Age BETWEEN 30 AND 50 THEN '30-50'
        ELSE 'Over 50'
    END AS AgeGroup,
    COUNT(*) AS TotalCustomers,
    COUNT(CASE WHEN Exited = 1 THEN 1 END) AS Churned,
    ROUND(COUNT(CASE WHEN Exited = 1 THEN 1 END) * 100.0 / COUNT(*), 2) AS ChurnRatePercent
FROM 
    Churn
GROUP BY 
    CASE 
        WHEN Age < 30 THEN 'Under 30'
        WHEN Age BETWEEN 30 AND 50 THEN '30-50'
        ELSE 'Over 50'
    END;

-- Query 4: Impact of Number of Products on Churn
SELECT 
    NumOfProducts,
    COUNT(*) AS TotalCustomers,
    COUNT(CASE WHEN Exited = 1 THEN 1 END) AS Churned,
    ROUND(COUNT(CASE WHEN Exited = 1 THEN 1 END) * 100.0 / COUNT(*), 2) AS ChurnRatePercent
FROM 
    Churn
GROUP BY 
    NumOfProducts
ORDER BY 
    NumOfProducts;

-- Query 5: Salary Rank by Country Using Window Function
SELECT 
    CustomerId,
    Geography,
    EstimatedSalary,
    RANK() OVER (PARTITION BY Geography ORDER BY EstimatedSalary DESC) AS SalaryRank
FROM 
    Churn;

-- Query 6: CTE for Identifying At-Risk Customers
WITH AtRisk AS (
    SELECT 
        CustomerId,
        Geography,
        Age,
        Balance,
        IsActiveMember,
        NumOfProducts,
        EstimatedSalary
    FROM 
        Churn
    WHERE 
        Age > 40 AND Balance > 100000 AND IsActiveMember = 0
)
SELECT * FROM AtRisk;
