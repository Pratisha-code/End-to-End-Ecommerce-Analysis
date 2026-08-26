select * from customers;
select * from products;
select * from orders;

select count(*) from customers; #2988
select count(*) from products; #50 
select count(*) from orders;   #14750

#blanks check
select distinct delivery_days from orders order by delivery_days;
select count(*) from orders where delivery_days is null;
select count(*) from orders where delivery_days ='';
select count(*) from orders where delivery_days = 0;
  
 #blank check (for review rating column) 
select distinct review_rating from orders order by review_rating;
select count(*) from orders where review_rating ='' or review_rating is null;

#fill blanks with average
select round(avg(review_rating),2) from orders where review_rating is not null and review_rating != 0; #calculating the avg first
#put the avg
 set @avg_Rating= (select round(avg(review_rating),2) from orders  where  review_rating is not null and review_rating != 0 );
 
   set sql_safe_updates=0;
   
 update orders
 set review_rating =round( @avg_Rating,1)
 where review_rating is null or  review_rating = 0;
 
 #after running verify
 select count(*) from orders where review_rating is null and review_rating = 0;
 
 # Date format (for orders table)
 select order_date from orders limit 5; #yy-mm-dd
 
 #for all info about orders
 describe orders;
 
 update orders
 set order_date=str_to_date(order_date,'%Y-%m-%d');
 
 alter table orders modify order_date date;
 
  #Date format(For customers table)
   describe customers;
   
   update customers
   set signup_date=str_to_date(signup_date,'%Y-%m-%d');
   
   alter table customers modify signup_date date;
   
select * from orders;
select * from customers;
select * from products;





