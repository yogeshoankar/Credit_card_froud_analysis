create database froud_accident;

select * from card_holder;
select * from credit_card1;
select * from merchant;
select * from merchant_category;
select * from transaction;

alter table credit_card1
modify column card bigint;


# Q1. find the froud in top 5 month?

select monthname(date)as _month,sum(amount)as total_froud,avg(amount)as _avg_amount,count(amount) from transaction
group by _month
order by total_froud desc
limit 5;


# Q2. find in which merchant category has the detect the most froud?

select merchant_category.name,sum(transaction.amount)as sum_amount,avg(transaction.amount)as avg_amount,count(transaction.id) from merchant_category
join merchant on merchant_category.id = merchant.id_merchant_category
join transaction on merchant.id = transaction.id_merchant
group by merchant_category.name
order by sum_amount desc;

# Q3. Which merchant has the most froud?
select merchant.name,sum(amount)as total_froud,count(merchant.name) total from merchant
join transaction on transaction.id_merchant = merchant.id_merchant_category
group by merchant.name
order by total desc;

# Q4. Which card number is most fraudulent?
select card,count(card)as total from transaction
group by card
order by total desc;

# Q5. In which category, which merchant has experienced the most fraud?

with cte_1 as(select merchant_category.name as category_name,merchant.name as merchant_name,sum(transaction.amount)as total_amount,
row_number() over(partition by merchant_category.name order by sum(transaction.amount) desc)as _row_number from merchant
join merchant_category on merchant.id_merchant_category = merchant_category.id
join transaction on merchant.id = transaction.id_merchant
group by merchant_category.name,merchant.name
order by merchant_category.name,total_amount desc)

select category_name,merchant_name,total_amount from cte_1
where _row_number = 1;

# Q6 In which merchat category and with which mechant in which month has the most fraud occurred?
with cte_1 as(select merchant_category.name as category_name,merchant.name as merchant_name,sum(transaction.amount)as total_amount,monthname(transaction.date)as _month,
row_number() over(partition by merchant_category.name order by sum(transaction.amount) desc)as _row_number from merchant
join merchant_category on merchant.id_merchant_category = merchant_category.id
join transaction on merchant.id = transaction.id_merchant
group by merchant_category.name,merchant.name,_month
order by merchant_category.name,total_amount desc)

select category_name,merchant_name,_month,total_amount from cte_1
order by category_name,total_amount desc;


