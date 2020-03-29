-- SELECT Full_Name, Publication_Title, Publisher, Year_Published
-- FROM (Publications INNER JOIN Has_Authored
-- ON Publications.Publication_Title = Has_Authored.Publication_Title) 
-- INNER JOIN Lab_Members
-- ON Has_Authored.unique_Id = Lab_Members.unique_Id
-- WHERE Year_Published BETWEEN 2017 AND 2020;

SELECT Full_Name, Publication_Title, Publisher, Year_Published
FROM Publications NATURAL JOIN Has_Authored NATURAL JOIN Lab_Members
WHERE Year_Published BETWEEN 2017 AND 2020;

SELECT Full_Name, Publication_Title, Publisher, Year_Published
FROM Publications NATURAL JOIN Has_Authored NATURAL JOIN Lab_Members
WHERE Topic LIKE ('%Javascript%');

SELECT  Full_Name, Category, COUNT(Publication_Title) AS Publications
FROM Publications NATURAL JOIN Has_Authored NATURAL JOIN Lab_Members
WHERE Year_Published BETWEEN 2017 AND 2020
GROUP BY unique_Id, Category;

WITH Publications_Number(Counts) AS 
    (SELECT COUNT(Publication_Title)
    FROM Publications NATURAL JOIN Has_Authored NATURAL JOIN Lab_Members
    WHERE Year_Published > 2015 AND Member_Type = 'Dep_Member'
    GROUP BY unique_Id),
Max_Publications(Value) AS
    (SELECT MAX(Counts) FROM Publications_Number)
SELECT Full_Name, Value FROM Publications NATURAL JOIN Has_Authored NATURAL JOIN Lab_Members, Max_Publications
WHERE Member_Type = 'Dep_Member'
GROUP BY unique_Id HAVING COUNT(Publication_Title) = Value;

SELECT  Full_Name, Publication_Title
FROM Publications NATURAL JOIN Has_Authored NATURAL JOIN Lab_Members
WHERE Member_Type = 'Graduate' AND Year_Published BETWEEN 2017 AND 2020 
ORDER BY Publication_Title;

SELECT  Full_Name, Year_Published, COUNT(Publication_Title) AS Publications
FROM Publications NATURAL JOIN Has_Authored NATURAL JOIN Lab_Members
GROUP BY Year_Published, unique_Id
HAVING COUNT(Publication_Title) >= 3;

SELECT  Full_Name, SUM(Budget) AS Total_Budget
FROM Research_Projects NATURAL JOIN Has_Supervised NATURAL JOIN Lab_Members
WHERE Member_Type = 'Dep_Member' AND (Start_Date >= '2017-01-01' AND End_Date <= '2020-12-12')
GROUP BY unique_Id
ORDER BY SUM(Budget) DESC;

SELECT  Full_Name, Title, Semester_Offered
FROM Classes NATURAL JOIN Teaches NATURAL JOIN Lab_Members
WHERE Member_Type IN ('Dep_Member','Graduate')
ORDER BY Semester_Offered;

SELECT Project_Title, Start_Date, End_Date
FROM Research_Projects NATURAL JOIN Has_Supervised NATURAL JOIN Lab_Members
WHERE Full_Name = 'Domnica Nusom';

SELECT * FROM Lab_Members
WHERE Full_Name = 'Spense Camarero';