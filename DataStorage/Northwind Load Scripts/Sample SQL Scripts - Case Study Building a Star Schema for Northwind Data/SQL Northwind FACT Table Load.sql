USE Northwind;

/* Load FACT Table */

CREATE TABLE fact_sales (
             customer_ident INT NOT NULL,  
             product_ident INT NOT NULL,  
             employee_ident INT NOT NULL,  
             supplier_ident INT NOT NULL,  
             DateKey INT NOT NULL, 
             gross_sale_value SMALLMONEY NOT NULL, 
             discount_sale_value SMALLMONEY NOT NULL);
			 
INSERT INTO [dbo].[fact_sales]
        (customer_ident
        ,product_ident
        ,employee_ident
        ,supplier_ident
        ,DateKey
        ,gross_sale_value
        ,discount_sale_value
		)
SELECT 	
		 d_cust.customer_ident 
        ,d_prod.product_ident
        ,d_emp.employee_ident
        ,d_supp.supplier_ident
        ,d_date.DateKey
		,CONVERT(money,(odb.UnitPrice*odb.Quantity))  AS gross_sale_value
		,CONVERT(money,(odb.UnitPrice*odb.Quantity*(1-odb.Discount)/100))*100 AS discount_sale_value
		
			
From (

SELECT  
				 c.CustomerId
				,p.ProductName
				,e.EmployeeID
				,s.SupplierID 
				,o.OrderDate
				,od.UnitPrice
				,od.Quantity
				,od.Discount
		from suppliers s
			
			join products p				on s.supplierid		= p.supplierid		
			join [order details] od		on p.productid		= od.productid
			join [orders] o				on o.orderid		= od.orderid
			join customers c			on c.customerid		= o.customerid
			join employees e            on o.employeeid     =e.employeeid

 )
as odb
        join dim_customer d_cust 	    on d_cust.customer_id		= odb.CustomerId
		join dim_product d_prod         on d_prod.product_name       = odb.ProductName
		join dim_employee d_emp         on d_emp.employee_id        = odb.EmployeeID
        join dim_supplier d_supp 	    on d_supp.supplier_id		= odb.SupplierID
		join DimDate d_date             on  d_date.Date		         = odb.OrderDate;			  

