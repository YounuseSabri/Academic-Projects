-- Diabetes Risk Analysis CLEANING
-- Goal: Clean health data and identify patterns linked to diabetes outcomes



WITH cleaned_data AS (
    SELECT
        Pregnancies,
        NULLIF(Glucose, 0) AS Glucose,
        NULLIF(BloodPressure, 0) AS BloodPressure,
        NULLIF(SkinThickness, 0) AS SkinThickness,
        NULLIF(Insulin, 0) AS Insulin,
        NULLIF(BMI, 0) AS BMI,
        DiabetesPedigreeFunction,
        Age,
        Outcome,

  
  
 -- Selecting Data that we are using and cleaning, Glucose, BloodPressure, SkinThickness, Insulin and BMI can not logically equal 0
 -- Cleaning data where the improbable "0" will be entered as missing replaced with "NULL"
  
  
  
        CASE
            WHEN Age < 30 THEN 'Under 30'
            WHEN Age BETWEEN 30 AND 44 THEN '30-44'
            WHEN Age BETWEEN 45 AND 59 THEN '45-59'
            ELSE '60+'
        END AS Age_Group,
  
  
  
-- Creating a age group through feature engineering in order to distinguish through categories
  
  
  
        CASE
            WHEN BMI < 18.5 THEN 'Underweight'
            WHEN BMI BETWEEN 18.5 AND 24.9 THEN 'Normal'
            WHEN BMI BETWEEN 25 AND 29.9 THEN 'Overweight'
            ELSE 'Obese'
        END AS BMI_Category,
  
  
  
-- Createing a BMI Category where we can have a categorical variable through classes

  
  
        CASE
            WHEN Glucose >= 140 THEN 'High Glucose'
            WHEN Glucose BETWEEN 100 AND 139 THEN 'Moderate Glucose'
            ELSE 'Normal Glucose'
        END AS Glucose_Category
    FROM diabetes_csv
)



-- Created different Categorical Variables, Glucose was created as the third, this will help the model



SELECT
    Age_Group,
    BMI_Category,
    Glucose_Category,
    COUNT(*) AS Total_Patients,
    SUM(CASE WHEN Outcome = 1 THEN 1 ELSE 0 END) AS Diabetes_Cases,
    
    
    
-- Grouping together our final results and visualizing how many diabetic patients we have for the groups we created
-- Creating new column

    
    
    ROUND(
        100.0 * SUM(CASE WHEN Outcome = 1 THEN 1 ELSE 0 END) / COUNT(*),
        2      
    ) AS Diabetes_Rate_Percent,
    
    
    
-- Rounding to the second decimal place, checking diabete cases vs our dataset
-- Creating new column
    
    
    
    ROUND(AVG(Glucose), 2) AS Avg_Glucose,
    ROUND(AVG(BMI), 2) AS Avg_BMI,
    ROUND(AVG(BloodPressure), 2) AS Avg_BloodPressure
FROM cleaned_data



-- Finding average of Glucose, BMI and BloodPressure



GROUP BY
    Age_Group,
    BMI_Category,
    Glucose_Category
ORDER BY
    Diabetes_Rate_Percent DESC;
    

-- Finally finishing the project by grouping the three categories and analyzing the different groups
-- Sort through an order sequence of percentage rate of Diabetes