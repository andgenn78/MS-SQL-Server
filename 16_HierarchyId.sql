/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [BusinessEntityID]
      ,[NationalIDNumber]
      ,[LoginID]
      ,[OrganizationNode]
      ,[OrganizationLevel]
      ,[JobTitle]
      ,[BirthDate]
      ,[MaritalStatus]
      ,[Gender]
      ,[HireDate]
      ,[SalariedFlag]
      ,[VacationHours]
      ,[SickLeaveHours]
      ,[CurrentFlag]
      ,[rowguid]
      ,[ModifiedDate]
  FROM HumanResources.Employee
   

  SELECT TOP 10 JobTitle, LoginId, OrganizationNode.ToString(), OrganizationNode.GetLevel()
  FROM HumanResources.Employee

  DECLARE @EmployeeNode HierarchyId;

  SELECT @EmployeeNode = OrganizationNode
  FROM HumanResources.Employee
  WHERE LoginId = 'adventure-works\terri0' 

  SELECT OrganizationNode.ToString(),* 
  FROM HumanResources.Employee
  WHERE OrganizationNode.GetAncestor(3) = @EmployeeNode;
