-- =====================================================
-- REAL ESTATE ANALYSIS PROJECT
-- SQL Portfolio Project
-- Author: Aigerim Djynysalieva
-- =====================================================
-- Description:
-- This project analyzes a real estate dataset including agents, clients,
-- properties, listings, viewings, and deals. The analysis covers:
-- - Data exploration
-- - Agent performance
-- - Property analysis
-- - Conversion rates and revenue metrics
-- =====================================================

-- ====================================
-- 1. DATA EXPLORATION
-- ====================================

-- ==== AGENTS ====
-- View all agents
SELECT * 
FROM agents;

-- Check for duplicate agents
SELECT full_name, COUNT(*) AS duplicate_count
FROM agents
GROUP BY full_name
HAVING COUNT(*) > 1;

-- Unique agent names
SELECT DISTINCT full_name
FROM agents
ORDER BY full_name DESC;

-- ==== CLIENTS ====
-- View all clients
SELECT * 
FROM clients;

-- Number of sellers
SELECT COUNT(client_id) AS seller_amount
FROM clients
WHERE client_type = 'seller';

-- ==== DEALS ====
-- View all deals
SELECT *
FROM deals;

-- ==== LISTINGS ====
-- Total number of listings
SELECT COUNT(*) AS total_listings
FROM listings;

-- Listings count by status
SELECT status, COUNT(*) AS listings_per_status
FROM listings
GROUP BY status;

-- ==== PROPERTIES ====
-- Total number of properties
SELECT COUNT(*) AS total_properties
FROM properties;

-- Property price statistics
SELECT 
    AVG(price) AS avg_price,
    MIN(price) AS min_price,
    MAX(price) AS max_price
FROM properties;

-- Property area statistics
SELECT 
    AVG(area) AS avg_area,
    MIN(area) AS min_area,
    MAX(area) AS max_area
FROM properties;

-- Count of properties by type
SELECT type, COUNT(*) AS count_per_type
FROM properties
GROUP BY type
ORDER BY count_per_type DESC;

-- ==== VIEWINGS ====
-- Total number of viewings
SELECT COUNT(*) AS total_viewings
FROM viewings;

-- Average viewings per listing
SELECT AVG(viewings_per_listing) AS avg_viewings_per_listing
FROM (
    SELECT listing_id, COUNT(*) AS viewings_per_listing
    FROM viewings
    GROUP BY listing_id
) AS subquery;

-- Top 10 agents by viewings
SELECT agent_id, COUNT(*) AS total_viewings
FROM viewings
GROUP BY agent_id
ORDER BY total_viewings DESC
LIMIT 10;

-- ====================================
-- 2. DEALS & VIEWINGS PER AGENT
-- ====================================

-- Deals per agent
SELECT a.full_name, COUNT(d.deal_id) AS deals_amount
FROM agents a
JOIN listings l ON a.agent_id = l.agent_id
LEFT JOIN deals d ON l.listing_id = d.listing_id
GROUP BY a.full_name
ORDER BY deals_amount DESC;

-- Viewings per agent
SELECT a.agent_id, COUNT(v.viewing_id) AS viewing_total
FROM agents a
JOIN viewings v ON a.agent_id = v.agent_id
GROUP BY a.agent_id
ORDER BY viewing_total DESC;

-- ====================================
-- 3. VIEWINGS PER LISTING
-- ====================================
SELECT l.listing_id, COUNT(v.viewing_id) AS viewings_amount
FROM listings l
LEFT JOIN viewings v ON l.listing_id = v.listing_id
GROUP BY l.listing_id
ORDER BY viewings_amount DESC;

-- ====================================
-- 4. AGENT PERFORMANCE METRICS
-- ====================================
-- Combining deals and viewings to calculate efficiency
SELECT a.full_name, 
       COUNT(DISTINCT v.viewing_id) AS viewing_total,
       COUNT(DISTINCT d.deal_id) AS deal_total,
       ROUND(COUNT(DISTINCT d.deal_id)::decimal / NULLIF(COUNT(DISTINCT v.viewing_id),0),2) AS conversion_rate
FROM agents a
LEFT JOIN viewings v ON a.agent_id = v.agent_id
LEFT JOIN listings l ON a.agent_id = l.agent_id
LEFT JOIN deals d ON l.listing_id = d.listing_id
GROUP BY a.full_name
ORDER BY conversion_rate DESC;

-- ====================================
-- 5. PROPERTIES WITH COMPLETED DEALS
-- ====================================
SELECT *
FROM properties
WHERE property_id IN (
    SELECT l.property_id
    FROM listings l
    JOIN deals d ON l.listing_id = d.listing_id
);

-- ====================================
-- 6. PROPERTIES ABOVE AVERAGE PRICE
-- ====================================
WITH avg_price_cte AS (
    SELECT AVG(price) AS avg_price
    FROM properties
)
SELECT a.full_name AS agent_name, p.property_id, p.price
FROM agents a
JOIN viewings v ON v.agent_id = a.agent_id
JOIN listings l ON l.listing_id = v.listing_id
JOIN properties p ON l.property_id = p.property_id
WHERE p.price > (SELECT avg_price FROM avg_price_cte)
ORDER BY p.price DESC;

-- ====================================
-- 7. TOP 10 MOST EXPENSIVE PROPERTIES
-- ====================================
SELECT *
FROM properties
ORDER BY price DESC
LIMIT 10;

-- ====================================
-- 8. AGENT EXPERIENCE CATEGORY
-- ====================================
SELECT agent_id, full_name,
       CASE
           WHEN experience_years >= 10 THEN 'senior'
           ELSE 'junior'
       END AS category,
       COUNT(*) OVER (
           PARTITION BY
           CASE
               WHEN experience_years >= 10 THEN 'senior'
               ELSE 'junior'
           END
       ) AS category_count
FROM agents;

-- ====================================
-- 9. CONVERSION RATE
-- ====================================
-- Percentage of viewings that became deals
SELECT
    COUNT(DISTINCT v.viewing_id) AS total_viewings,
    COUNT(DISTINCT d.deal_id) AS total_deals,
    ROUND(COUNT(DISTINCT d.deal_id)::decimal / NULLIF(COUNT(DISTINCT v.viewing_id),0),2) AS conversion_rate
FROM viewings v
LEFT JOIN deals d ON v.listing_id = d.listing_id;

-- ====================================
-- 10. AGENT REVENUE
-- ====================================
SELECT a.full_name, 
       SUM(d.agent_commission) AS total_commission
FROM agents a
JOIN listings l ON a.agent_id = l.agent_id
JOIN deals d ON l.listing_id = d.listing_id
GROUP BY a.full_name
ORDER BY total_commission DESC;