create database insurance;
use insurance;
set sql_safe_updates=0;

-- INSURANCE ANALYTICS

-- KPIs
-- 1. No.of.Invoice by Account Executives,income class
select Account_Executive, income_class,year(str_to_date(invoice_date,'%d-%m-%Y')) as invoice_year,
count(Account_Exe_ID) No_of_Invoice from invoice 
group by Account_Executive,income_class,invoice_year
order by No_of_invoice desc;


-- 2 No.of.Meetings by Account Executives
select Account_Executive,year(str_to_date(meeting_date,'%d-%m-%Y')) as meeting_year,
count(*) No_of_meetings from meetings
group by Account_Executive,meeting_year
order by No_of_meetings desc;

-- 3 STAGE BY REVENUE
select stage,concat(round(sum(revenue_amount)/1000000,2),"M") as Total_Revenue_amount from opportunity
group by stage
order by Total_revenue_amount desc;

-- 4 Total Opportunities
select count(*) as Total_Opportunities from opportunity;

-- 5 Total Open Opportunities
select count(*) as Total_Open_Opportunities from opportunity
where stage in ('Qualify Opportunity','Propose Solution');


-- 6 TOP 5 OPPORTUNITIES BY REVENUE
select opportunity_name as Top_5_Opportunities from opportunity
order by revenue_amount desc
limit 5;

-- 7 TOTAL CUSTOMERS
select count(distinct client_name) Total_customers from invoice;

-- 8 TOTAL REVENUE
select concat(round(sum(revenue_amount)/1000000,2),"M") Total_Revenue from opportunity;

-- 9 Total Premium 
select concat(round(sum(premium_amount)/1000000,2),"M") as Total_Premium from opportunity;

-- TOTAL POLICIES
select COUNT(*) as Total_Policies from brokerage;

-- YEARLY MEETING COUNT
SELECT YEAR(str_to_date(trim(meeting_Date), '%d-%m-%Y')) as Meeting_year,count(*) AS Total_Meetings
FROM meetings group by Meeting_Year;


-- TARGET
select concat(round(sum(new_budget)/1000000,2),"M") as New_Target from ind_bdgt;

select concat(round(sum(Renewal_budget)/1000000,2),"M") as Renewal_Target from ind_bdgt;

select concat(round(sum(cross_sell_budget)/1000000,2),"M") as Cross_sell_Target from ind_bdgt;

-- INVOICE FOR NEW,RENEWAL AND CROSS SELL
select income_class,concat(round(sum(amount)/1000000,2),"M") as Invoice from invoice group by income_class;



-- NEW ACHIEVED, RENEWAL ACHIEVED & CROSS SELL ACHIEVED

SELECT 
    b.income_class,
    CONCAT(ROUND(
    COALESCE(b.total_brokerage, 0) +
    COALESCE(f.total_fees, 0),2), "M") AS achieved
FROM 
(
    SELECT income_class,
    round(sum(amount)/1000000,2) AS total_brokerage
    FROM brokerage
    GROUP BY income_class
) b
LEFT JOIN
(
    SELECT income_class,
           round(sum(amount)/1000000,2) AS total_fees
    FROM fees
    GROUP BY income_class
) f
ON b.income_class = f.income_class where f.income_class is not null;
