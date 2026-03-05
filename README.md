# Real_Estate_Analysis_SQL
SQL project analyzing real estate data, agent performance, and property trends.
Real Estate Analysis SQL Project
📌 Project Overview

This project analyzes a real estate dataset including agents, clients, properties, listings, viewings, and deals.
The goal is to explore the data, calculate performance metrics, and generate actionable insights for a real estate business.

Key objectives:

Understand agent performance and efficiency

Analyze property pricing and popularity

Calculate conversion rates from viewings to deals

Determine revenue per agent

Identify top properties and clients

🗄 Dataset Description

The dataset contains six main tables:

Table	Description
agents	Agent details: name, experience years, etc.
clients	Client information: type (buyer/seller), contact details
properties	Property details: type, price, area, location
listings	Properties listed by agents
viewings	Records of property viewings by clients
deals	Completed transactions including agent commission
🔍 Analysis Overview

The project contains the following sections:

Data Exploration

Inspect tables and basic statistics

Check duplicates and unique values

Aggregate counts and averages for properties, listings, and viewings

Agent Performance

Deals per agent

Viewings per agent and per listing

Agent efficiency: conversion rate from viewings to deals

Agent revenue ranking

Property Analysis

Properties with completed deals

Properties above average price

Top 10 most expensive properties

Experience & Segmentation

Categorize agents as junior or senior based on experience

Count agents per category

Conversion & Revenue

Calculate conversion rate (viewings → deals)

Determine total commission per agent

📊 Key Insights

Top Agents: Some agents generate more deals per viewing, showing higher efficiency.

Property Pricing: A small subset of properties are significantly above average price, driving most agent revenue.

Conversion Rate: Overall conversion rate of viewings to deals indicates business performance efficiency.

Agent Revenue: Senior agents tend to have higher total commission, but some junior agents have high conversion rates.

💻 SQL Techniques Used

SELECT, JOIN, LEFT JOIN for table relationships

Aggregations: COUNT, AVG, MIN, MAX

Grouping: GROUP BY

Window functions: COUNT(*) OVER (PARTITION BY ...)

Common Table Expressions (CTE)

Filtering with WHERE and subqueries

Ordering with ORDER BY and limiting results with LIMIT

📈 Optional Next Steps

Add time-based analysis: monthly trends for deals and viewings

Segment clients by activity or total deal value

Visualize top properties and agent performance in Tableau / Power BI

Combine metrics into a dashboard for management insights
