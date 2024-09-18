
select * from products;
select * from sales;

-- Q1. Retrieve all product names and their prices.
select product_name, price from products;

-- Q2. Find all sales that occurred in January 2024.
select * from sales where year(sale_Date) =2024 and month(sale_date) = 01;

-- Q3. Get the total sales quantity for each product.
with cte as (select product_id,sum(quantity) as total_quantity from sales group by product_id)
select cte.product_id, p.product_name, total_quantity from cte join products p on cte.product_id = p.product_id;

-- Q4. Get top 5 produt_name based on total sales quantity.
with cte as (select product_id,sum(quantity) as total_quantity from sales group by product_id)
select p.product_name, total_quantity from cte join products p on cte.product_id = p.product_id order by total_quantity desc limit 5;

-- Q5. Find the product with the highest price.
select product_name from products order by price desc limit 1;

-- Q6. Get the products that have not been sold.
select * from products where product_id not in (select product_id from sales);

-- Q7. Find the product with the highest sales amount.
select s.product_id,p.product_name,sum(total_amount) as highest_amount from sales s join products p on s.product_id = p.product_id group by s.product_id
order by highest_amount desc limit 1;

-- Q8. Retrieve the average price of products in each category.
select category,round(avg(price),2) as average_price from products group by category;

-- Q9. Find the product that had the most sales in terms of quantity.
select s.product_id, p.product_name,sum(quantity) total_quantity from sales s join products p on s.product_id = p.product_id group by 
product_id order by sum(quantity) desc limit 1;

-- Q10. Get the total sales made for each day in January 2024.
select sale_Date,sum(total_amount) as total_amount from sales where year(Sale_date) = 2024 and month(sale_date) = 1 group by sale_Date;

-- Q11. Find the average sales amount per product category, and only return categories with an average sales amount above $500.
select p.category,round(avg(s.total_amount),0) as average from products p join sales s on p.product_id = s.product_id 
group by p.category having avg(s.total_amount) > 500;

-- Q12. List the top 3 products with the highest total sales amount.
select p.product_name, sum(s.total_amount) as total_sales from sales s join products p on s.product_id = p.product_id group by 
p.product_name order by sum(s.total_amount) desc limit 3;

-- Q13. Retrieve the total quantity of products sold for each category.
select p.category,sum(s.quantity) as total_quantity from products p join sales s on p.product_id = s.product_id group by p.category;

-- Q14. Find the total sales amount for products where the total quantity sold is greater than 5.
with cte as(select product_id , sum(total_amount) as total from sales group by product_id having sum(quantity) >5)
select product_name, total from cte join products p on cte.product_id = p.product_id;

-- Q15. Find the cumulative total sales for each product across all transactions.
with cte as(select product_id,sale_Date,total_amount,sum(total_amount) over(partition by product_id order by sale_Date) as cumulative_sales from sales)
select p.product_name,cte.sale_Date,cte.total_amount,cte.cumulative_sales from cte join products p on cte.product_id = p.product_id;

-- Q16. Rank the products by total sales amount within each category.
with cte as(select p.product_id,p.product_name,p.category, sum(s.total_amount) as total_sales from products p join 
sales s on p.product_id =s.product_id group by p.product_id,p.product_name,p.category)
select *,dense_rank() over(partition by category order by total_sales desc) as sales_rank from cte;

-- Q17. Find top selling product_name for each category.
with cte as(select p.product_id,p.product_name,p.category, sum(s.total_amount) as total_sales from products p join 
sales s on p.product_id =s.product_id group by p.product_id,p.product_name,p.category)
select * from (select *,dense_rank() over(partition by category order by total_sales desc) as sales_rank from cte) sal where sales_rank = 1;

