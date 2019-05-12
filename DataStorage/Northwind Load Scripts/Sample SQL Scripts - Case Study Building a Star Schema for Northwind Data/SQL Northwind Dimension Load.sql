USE Northwind;

/* Supplier Dimension */

CREATE TABLE dbo.dim_supplier(   
             supplier_ident INT IDENTITY(1, 1),
			 supplier_id INT NOT NULL,   
             supplier_name VARCHAR(255) NOT NULL,  
			 supplier_city VARCHAR (255) NULL,  
			 country VARCHAR(255) NULL );

INSERT dim_supplier (    
             supplier_id ,  
			 supplier_name ,   
			 supplier_city ,   
			 country )
SELECT       supplierid,  
             companyname,   
			 city,   
			 country 
FROM suppliers; 



/* Product Dimension */

CREATE TABLE dbo.dim_product ( 
             product_ident INT IDENTITY(1, 1),   
			 product_id INT NOT NULL,   
			 product_name VARCHAR(255) NOT NULL, 
			 discontinued BIT NOT NULL ); 

INSERT dim_product (  
             product_id,  
			 product_name,   
			 discontinued) 
SELECT       productid,   
             productname,   
			 discontinued 
FROM products; 



/* Customer Dimension */

CREATE TABLE dbo.dim_customer (
             customer_ident INT IDENTITY(1, 1),
			 customer_id VARCHAR(20) NOT NULL,   
			 customer_name VARCHAR(255) NOT NULL,  
			 customer_city VARCHAR(255) NULL,  
			 customer_country VARCHAR(255) NULL );

INSERT       dim_customer (
             customer_id,   
			 customer_name,  
			 customer_city,   
			 customer_country) 
SELECT       customerid,  
             companyname,   
			 city,   
			 country 
FROM customers; 


/* Employee Dimension */

CREATE TABLE dbo.dim_employee (
             employee_ident INT IDENTITY(1, 1),
			 employee_id INT NOT NULL,  
			 employee_name VARCHAR(85) NOT NULL,  
			 employee_city VARCHAR(255) NULL,   
			 employee_country VARCHAR(255) NULL ); 

INSERT dim_employee (
             employee_id,  
			 employee_name,    
			 employee_city,    
			 employee_country) 
SELECT       employeeid, 
             TItleOfCourtesy + ' ' + FirstName + ' ' + LastName AS employee_name, 
			 city,    
			 country 
FROM employees; 

