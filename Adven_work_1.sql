use AdventureWorksLT2019

select * from [SalesLT].[Address];
select * from SalesLT.Customer;
select * from SalesLT.CustomerAddress;
select * from SalesLT.Product;
select * from SalesLT.ProductCategory;
select * from SalesLT.ProductDescription;
select * from SalesLT.ProductModel;
select * from SalesLT.ProductModelProductDescription
select * from SalesLT.SalesOrderDetail
select * from SalesLT.SalesOrderHeader

--Q1 -- see only Product table and Product cateory table
   --Display Category Name, Number of Products, Average List Price, Minimum List Price and
--Maximum List Price for each product category. Consider only products with ListPrice > 500. Display
--only categories having at least 3 such products. Sort by Average List Price descending.
-- at least means >= 3

select * from SalesLT.Product;
select * from SalesLT.ProductCategory;

select Sc.Name as Category_Name, COUNT(p.ProductID) as Number_of_product, AVG(p.ListPrice) as averagelistprice, MIN(p.ListPrice) as minimum_list_price, max(p.ListPrice) as max_list_P
from SalesLT.ProductCategory as Sc
Join SalesLT.Product as p
on Sc.ProductCategoryID = p.ProductCategoryID
where p.ListPrice > 500
group by Sc.Name
Having COUNT(p.ProductID) >= 3
order by averagelistprice desc;

--Q2
--Display Customer ID, Customer Name, Number of Orders, Total Order Amount and Average Order
--Amount. Consider only orders where TotalDue > 1000. Display only customers with at least 2 such
--orders. Sort by Total Order Amount descending.
-- order amount means TotalDue

select * from SalesLT.Customer;
select * from SalesLT.SalesOrderHeader;

select ST.CustomerID, ST.FirstName +''+ ST.LastName as Customername, COUNT(SS.SalesOrderID) as NFO, sum(SS.TotalDue) as Totalorderamount, AVG(SS.TotalDue) as Avorderamount
from SalesLT.Customer ST
join SalesLT.SalesOrderHeader SS
on ST.CustomerID = SS.CustomerID
where SS.TotalDue > 1000
Group by ST.CustomerID, ST.FirstName,ST.LastName
Having COUNT(SS.SalesOrderID) >= 2
order by Totalorderamount desc;


select * from SalesLT.SalesOrderHeader
where TotalDue > 1000

--Q3
--Display Product ID, Product Name, Product Number and List Price for products whose ListPrice is
--greater than the average ListPrice of all products. Use a single-row subquery.

select ProductID, Name as ProductName, ProductNumber, ListPrice from [SalesLT].[Product]
where ListPrice > (select AVG(ListPrice) from [SalesLT].[Product])

--Q4
--Display Customer ID, Customer Name, Number of Orders and Total Amount Spent for customers
--whose total spending is greater than the average customer spending. Use a subquery.
-- totaldue means total spending

select AVG(TotalDue) from [SalesLT].[SalesOrderHeader]

select * from SalesLT.Customer;
select * from SalesLT.SalesOrderHeader;

select FC.CustomerID, FC.FirstName +''+ FC.LastName, count(DC.SalesOrderID) as NFO, sum(DC.TotalDue) as total_spending, AVG(DC.TotalDue) as Av_cus_spenfing
from SalesLT.SalesOrderHeader DC
Join SalesLT.Customer FC 
on DC.CustomerID = FC.CustomerID
Group by FC.CustomerID, FC.FirstName,FC.LastName
Having sum(DC.TotalDue) > (select AVG(TotalDue) from [SalesLT].[SalesOrderHeader])
order by total_spending desc;

--Q5
--Using a CTE, calculate Total Quantity Sold, Number of Order Lines and Total Sales Value for each
--product. Display only products with Total Quantity Sold > 20 and Total Sales Value > 5000. Sort by
--Total Sales Value descending.
-- line Total is Totalsales value \ order Quantity is total quantity sold by sum(d.orderQTY)

select * from SalesLT.Product;
select * from SalesLT.SalesOrderDetail;

with vt as(

      select PC.ProductID, PC.Name as productName, sum(DT.OrderQty) as Total_Quantity_Sold, 
	  count(DT.SalesOrderID) as Number_of_lines, sum(DT.LineTotal) as Total_Sales_Value
	  from SalesLT.Product PC
	  Join SalesLT.SalesOrderDetail DT
	  on PC.ProductID = DT.ProductID
	  Group by PC.ProductID, PC.Name

)

select ProductID, productName, Total_Quantity_Sold, Number_of_lines, Total_Sales_Value
From vt Where Total_Quantity_Sold > 20   and Total_Sales_Value > 5000
order by Total_Sales_Value desc;

--Q6 
  --Using a CTE, calculate Total Sales Value for each product category. Display only categories whose
--Total Sales Value is greater than the average category sales. Also display Number of Distinct
--Products Sold and Total Quantity Sold



select * from SalesLT.Product;
select * from SalesLT.SalesOrderDetail;
select * from SalesLT.ProductCategory;

with CT as (
     select Pu.ProductCategoryID, Pu.Name as categoriename, count(Distinct sf.ProductID) as Number_product_sold, sum(sf.OrderQty) as Total_Quantity_Sold,
	 Sum(sf.LineTotal) as Total_Sales_Value from SalesLT.ProductCategory as Pu
	 Join SalesLT.Product as jk
	 on Pu.ProductCategoryID = jk.ProductCategoryID
	 Join SalesLT.SalesOrderDetail as sf
	 on jk.ProductID = sf.ProductID
	 Group by Pu.ProductCategoryID, Pu.Name
)

select categoriename,Number_product_sold,Total_Quantity_Sold,Total_Sales_Value from CT
where Total_Sales_Value > (select AVG(Total_Sales_Value) from CT) order by Total_Sales_Value desc; 

--Q7
--alculate Total Spending for each customer and assign ROW_NUMBER(), RANK() and
--DENSE_RANK() based on Total Spending in descending order. Use a CTE.
-- TotalDue means Total Spending

select * from SalesLT.Customer;
select * from SalesLT.SalesOrderHeader;

with nt as(
     select VT.CustomerID, VT.FirstName+''+VT.LastName as customername, sum(SN.TotalDue) as Total_Spending from SalesLT.Customer as VT
	 join SalesLT.SalesOrderHeader as SN
	 on VT.CustomerID = SN.CustomerID
	 Group by VT.CustomerID, VT.FirstName,VT.LastName

	 
)

select CustomerID,customername,Total_Spending, Row_number() over (order by Total_Spending desc) as Rownum,
       Rank() over (order by Total_Spending desc) as F_rank, Dense_Rank() over (order by Total_Spending desc) as Dens_rank from nt
	   order by Total_Spending desc;

--Q8
--Rank products within each category based on ListPrice using DENSE_RANK(). Display only the top
--3 price ranks from each category. Use a CTE.

select * from SalesLT.Product;
select * from SalesLT.ProductCategory;

with bn as (
  select FV.Name as Categoryname, PT.ProductID, PT.Name as ProductName,PT.ListPrice,
  DENSE_RANK() over (partition by FV.ProductCategoryID order by PT.ListPrice desc ) as Price_rank
  from SalesLT.Product as PT
  Join SalesLT.ProductCategory as FV
  on PT.ProductCategoryID = FV.ProductCategoryID

) 

select Categoryname,ProductID,ProductName,ListPrice from bn where Price_rank <= 3
order by Categoryname,Price_rank;

--Q9
--Find the highest-value order for each customer using ROW_NUMBER(). Partition by Customer and
--order by TotalDue descending. If two orders have the same TotalDue, consider the latest
--OrderDate.

select * from SalesLT.SalesOrderHeader

with BN as (
       select CustomerID,TotalDue,SalesorderID,OrderDate, ROW_NUMBER() over (partition by CustomerID order by TotalDue desc, OrderDate desc) as Row_no
	   from SalesLT.SalesOrderHeader
)

select CustomerID,TotalDue,SalesorderID,OrderDate from BN where Row_no = 1 order by CustomerID;

--Q10
--prepare a sales performance report for each product category showing Number of Orders, Number
--of Products Sold, Total Quantity Sold, Total Sales Value, Average Sales Per Order and Sales Rank.
--Consider only orders where TotalDue > 1000. Display only categories whose Total Sales Value is
--greater than the average category sales. Use CTEs, a subquery and DENSE_RANK().

select * from SalesLT.Product;
select * from SalesLT.ProductCategory;
select * from SalesLT.SalesOrderDetail;
select * from SalesLT.SalesOrderHeader;

with vb as (
        select dc.ProductCategoryID, dc.Name as categoryname, COUNT(distinct vb.SalesOrderID) as Number_of_Orders, count(distinct Sz.ProductID) as Number_of_Products_Sold,
		sum(Sz.OrderQty) as Total_Quantity_Sold, sum(Sz.LineTotal) as Total_Sales_Value, avg(Sz.LineTotal) as Average_Sales
		from SalesLT.ProductCategory dc Join SalesLT.Product bn on dc.ProductCategoryID = bn.ProductCategoryID
		join SalesLT.SalesOrderDetail Sz on bn.ProductID = Sz.ProductID Join SalesLT.SalesOrderHeader vb on Sz.SalesOrderID = vb.SalesOrderID
		where TotalDue > 1000
		Group by dc.ProductCategoryID,dc.Name
)

select categoryname,Number_of_Orders,Number_of_Products_Sold,Total_Quantity_Sold,Total_Sales_Value,Average_Sales, dense_rank() over (order by Total_Sales_Value desc) as Salesrank from vb
where Total_Sales_Value > (select avg(Total_Sales_Value) from vb) order by Salesrank


