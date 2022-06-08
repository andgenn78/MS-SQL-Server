DROP TABLE IF EXISTS Company;

CREATE TABLE Company  
   (  
    HierarchyLevel hierarchyid,
    PersonName nvarchar(50) NOT NULL  
   ) ;  
  
  
CREATE UNIQUE INDEX Company_   
ON Company(HierarchyLevel); 


INSERT INTO Company  
(HierarchyLevel, PersonName)
VALUES (hierarchyid::GetRoot(), 'Andrew');

SELECT HierarchyLevel.ToString(), HierarchyLevel.GetLevel(), PersonName
FROM Company
WHERE PersonName = 'Andrew';

DECLARE @H hierarchyid;

SELECT @H = HierarchyLevel
FROM Company
WHERE PersonName = 'Andrew';

INSERT INTO Company  
(HierarchyLevel, PersonName)
VALUES (@H.GetDescendant(NULL, NULL), 'Bob');

DECLARE @H hierarchyid; 

SELECT @H = HierarchyLevel
FROM Company
WHERE PersonName = 'Bob';

INSERT INTO Company  
(HierarchyLevel, PersonName)
VALUES (@H.GetDescendant(NULL, NULL), 'Alice');

select HierarchyLevel.ToString(), PersonName
FROM Company