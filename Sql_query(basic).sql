----USED LAYOFF DATASET AND PERFORMED SOME BASIC SQL QUERIES---
----------------------------------------------------------------------------------------------------
  --Select Clause--

	Select * from dbo.layoff_data;
--------------------------------------------------------------------------------------------------
  --DISTINCT CLAUSE
	Select distinct [location] from layoff_data;

  --OR
	Select count(distinct [location]) as count_of_location from layoff_data;

  --OR
	select count(*) from layoff_data --Number of all rows
-------------------------------------------------------------------------------------------------------
  --Where clause
	select * from layoff_data where country='india'
----------------------------------------------------------------------------------------------------
  -- And ,Or, Not
  
	select *from layoff_data where [location]='Bengaluru' and Country='India'
	select *from layoff_data where [location]='Bengaluru' or Country='India'
	select *from layoff_data where not [location]='Bengaluru' and  Country='India'
-----------------------------------------------------------------------------------------------------
  --Order By Clause

	Select * from layoff_data order by Funds_Raised desc;
---------------------------------------------------------------------------------------------------
  --Order By with Where Claues

	Select * from layoff_data 
	where Laid_off_count is not null
	order by Laid_off_Count Asc,[Percentage] Desc
---------------------------------------------------------------------------------------------------
  --Selecting only null values in selected cloumn

	select [company], [industry],Laid_off_Count from Layoff_data where Laid_off_Count is Null
--------------------------------------------------------------------------------------------------
  --Update Clause 

	begin transaction
	update layoff_data set Industry ='Social' where Company='Jimdo'
	Commit transaction (--for permanent chnage in  original data)
---------------------------------------------------------------------------------------------
  --Delete\Truncate(Empty to the whole table)

	begin transaction 
	delete from layoff_data where Industry='Social'
	commit transaction
-------------------------------------------------------------------------------------------
  --Min ,Max ,Avg ,Sum
	Select max(Laid_Off_Count) as maximum from layoff_data
	Select min(Percentage) as minimum from layoff_data
	Select Avg(Funds_Raised) as Avarage from layoff_data
	Select sum(Laid_Off_Count) as total from layoff_data
---------------------------------------------------------------------------------------
  --Like Oparator

	select * from layoff_data 
	where Location like 'B%u'
	order by Laid_Off_Count asc
-----------------------------------------------------------------------------------
  --In Clause

	Select * from layoff_data 
	where Location in ('London') And Industry in ('Energy')
--------------------------------------------------------------------------------------------------
  --Between Clause

	 Select * from layoff_data
	 where Laid_Off_Count between 50 and 250
	 And Industry in ('Healthcare')
---------------------------------------------------------------------------------------------
  --Joins

	--(We usually perform joins in two table or more than two tables and 
	--  also we can perform in single table)

	Select l1.Company,l1.Industry,l2.Location,l2.Laid_Off_Count from layoff_data l1
	inner join layoff_data l2
	on l1.Funds_Raised=l2.Funds_Raised
	where l2.Laid_Off_Count > 7500
--------------------------------------------------------------------------------------------------
  --Inner Join 

	--(Returns matched  records from  both records.)
	Select l1.Company,l1.Country,l1.Funds_Raised,l2.Source,l2.Laid_Off_Count 
	from layoff_data l1 
	inner join 
	layoff_data l2
	on l1.Company=l2.Company
	where l1.Company in ('ola','shopify')
	order by Company asc
---------------------------------------------------------------------------------------

  --Left Join 

	--(Returns all records from left and matched records from right  table)

	Select l1.Company,l1.Country,l1.Funds_Raised,l2.Source,l2.Laid_Off_Count 
	from layoff_data l1 
	left join 
	layoff_data l2
	on l1.Company=l2.Company
	where l2.Laid_Off_Count=1000
	order by Funds_Raised Asc
---------------------------------------------------------------------------------------
  --Right Join

	--(Returns all the records from right table and matched records from left)

	Select l1.Company,l1.Country,l1.Funds_Raised,l2.Source,l2.Laid_Off_Count
	from layoff_data l1 
	right join 
	layoff_data l2
	on l1.Company=l2.Company
	where l2.Funds_Raised between 1000 and 1500 and l2.Company='trax'
	order by Country Asc
-------------------------------------------------------------------------------------------
  --Full join

	--(Returns all the records from left and right both. )

	Select l1.Company,l2.Source,l2.Laid_Off_Count,l1.Country,l1.Funds_Raised
	from layoff_data l1 
	full outer join 
	layoff_data l2
	on l1.Company=l2.Company
	where l2.Funds_Raised > 1500 and l2.Country='india'
	order by Company Asc
-------------------------------------------------------------------------------
  --Union (Select only distinct values)--Union all ( Allowes duplicate values)

	Select Country,Location,Industry,Funds_Raised, Date from layoff_data
		where Country like 'A%'
		and 
		Date in('2022-06-27' , '2020-05-04')
	union
	Select Country,Location,Industry,Funds_Raised,Date  from layoff_data
		where Location in ('Bengaluru','Shenzen')
		And
		Funds_Raised >1600
-------------------------------------------------------------------
  --Group by Clause

	select Company,
		SUM(Laid_Off_Count) as total_laid_off,
		AVG(Percentage) as avg_percentage,
		MAX(Funds_Raised) as max_raised_fund
	from layoff_data
		where Funds_Raised is not null  
		group by Location, Company
		order by max_raised_fund Desc
----------------------------------------------------------------------
   --HAVING CLAUSE

	Select Company, location, 
		Sum(Laid_Off_Count) as Total
	from layoff_data
		where Laid_Off_Count> 1500
		group by location,Company
		having  Sum(Laid_Off_Count) >2000
		order by Location desc
---------------------------------------------------------------------
	select Company,
		SUM(Laid_Off_Count) as total_laid_off,
		AVG(Percentage) as avg_percentage,
		MAX(Funds_Raised) as max_raised_fund
	from layoff_data
		where Funds_Raised is not null  
		group by Company
		having MAX(Funds_Raised)>9900
		order by max_raised_fund Desc
------------------------------------------------------------------------
  --Case Statement

	Select Company,Location,Laid_Off_Count
		,case 
		when  Laid_Off_Count<=1000 then 'More than 500 Employees fired'
		when Laid_Off_Count > 1000 then 'More than 1000 employees fired'
		End as case_statement
	from layoff_data
	where Laid_Off_Count >500  and Laid_Off_Count< 1500
	order by Laid_Off_Count desc