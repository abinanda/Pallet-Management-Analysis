create database project360;
use project360;

/* count */
select count(*) from pallet_data;
select count(*) from pallet_data where TransactionType = 'Allot';
select count(*) from pallet_data where TransactionType = 'Return';

/* MIN */
select min(QTY) as min from pallet_data where TransactionType = 'Allot' ;
select min(abs(QTY)) as min from pallet_data where TransactionType = 'Return' ;

/* MAX */
select max(QTY) as max from pallet_data where TransactionType = 'Allot' ;
select max(abs(QTY)) as max from pallet_data where TransactionType = 'Return' ;

/* MEAN */
select avg(QTY) as Mean from pallet_data where TransactionType = 'Allot' ;
select avg(abs(QTY)) as Mean from pallet_data where TransactionType = 'Return' ;

/*  MEDIAN */
SELECT QTY AS median_QTY
FROM (
    SELECT QTY, ROW_NUMBER() OVER (ORDER BY QTY) AS row_num,
           COUNT(*) OVER () AS total_count
    FROM pallet_data where TransactionType = 'Allot'
) AS median
WHERE row_num = (total_count + 1) / 2 OR row_num = (total_count + 2) / 2;   

SELECT abs(QTY) AS median_QTY
FROM (
    SELECT QTY, ROW_NUMBER() OVER (ORDER BY QTY) AS row_num,
           COUNT(*) OVER () AS total_count
    FROM pallet_data where TransactionType = 'Return'
) AS median
WHERE row_num = (total_count + 1) / 2 OR row_num = (total_count + 2) / 2;

/* Mode */
SELECT QTY AS mode_QTY
FROM (
    SELECT QTY, COUNT(*) AS frequency
    FROM pallet_data
    where TransactionType = 'Allot'
    GROUP BY QTY
    ORDER BY frequency DESC
    LIMIT 1
) AS mode;

SELECT abs(QTY) AS mode_QTY
FROM (
    SELECT QTY, COUNT(*) AS frequency
    FROM pallet_data
     where TransactionType = 'Return'
    GROUP BY QTY
    ORDER BY frequency DESC
    LIMIT 1
) AS mode;

/*  VARIANCE */
SELECT VARIANCE(QTY) AS allot_variance
FROM pallet_data where TransactionType = 'Allot';

SELECT VARIANCE(QTY) AS return_variance
FROM pallet_data where TransactionType = 'Return';

/* Standard Deviation */
SELECT STDDEV(QTY) AS allot_std
FROM pallet_data where TransactionType = 'Allot';

SELECT STDDEV(QTY) AS return_std
FROM pallet_data where TransactionType = 'Return';

/*  RANGE */
SELECT MAX(QTY) - MIN(QTY) AS allot_range
FROM pallet_data where TransactionType = 'Allot';

SELECT MAX(abs(QTY)) - MIN(abs(QTY)) AS return_range
FROM pallet_data where TransactionType = 'Return';

/* SKEWNESS */
SELECT
    (
        SUM(POWER(QTY - (SELECT AVG(QTY) FROM pallet_data where TransactionType = 'Allot'), 3)) / 
        (COUNT(*) * POWER((SELECT STDDEV(QTY) FROM pallet_data where TransactionType = 'Allot'), 3))
    ) AS allot_skewness FROM pallet_data where TransactionType = 'Allot' ;
  SELECT
    (
        SUM(-POWER(QTY - (SELECT AVG(QTY) FROM pallet_data where TransactionType = 'Return'), 3)) / 
        (COUNT(*) * POWER((SELECT STDDEV((QTY)) FROM pallet_data where TransactionType = 'Return'), 3))
    ) AS return_skewness FROM pallet_data where TransactionType = 'Return';

  /* KURTOSIS */
  
  SELECT  (
        (SUM(POWER(QTY - (SELECT AVG(QTY) FROM pallet_data where TransactionType = 'Allot'), 4)) / 
        (COUNT(*) * POWER((SELECT STDDEV(QTY) FROM pallet_data where TransactionType = 'Allot'), 4))) - 3
    ) AS allot_kurtosis  FROM pallet_data where TransactionType = 'Allot';

  SELECT  (
        (SUM(POWER(QTY - (SELECT AVG(QTY) FROM pallet_data where TransactionType = 'Return'), 4)) / 
        (COUNT(*) * POWER((SELECT STDDEV(QTY) FROM pallet_data where TransactionType = 'Return'), 4))) - 3
    ) AS allot_kurtosis  FROM pallet_data where TransactionType = 'Return';


alter table pallet_data drop column SrNo;

/* Count Duplicate Records */
SELECT count(*)
FROM (
  SELECT Date, CustName, City, Region, State, ProductCode, TransactionType, Qty, WHName,
  ROW_NUMBER() OVER (
    PARTITION BY Date, CustName, City, Region, State, ProductCode, TransactionType, Qty, WHName
    ORDER BY Date
  ) AS row_no
  FROM pallet_data
) x
WHERE x.row_no > 1;

/* Count Distinct CustName */
select count(distinct CustNAme) from pallet_data;

/* Count Distinct City */
select count(distinct City) from pallet_data;

/* Count Distinct State */
select count(distinct State) from pallet_data;

/* Count Distinct WHNAme */
select count(distinct WHNAME) from pallet_data;

/* Count Distinct ProductCode */
select count(distinct ProductCode) from pallet_data;

/* replacing mistyped city names */
Select  State , City , sum(QTY) from pallet_data where City like 'A%' or 'a%' group by   State , City order by  State , City ;
UPDATE pallet_data
SET City = REPLACE(City, 'Ananthapur', 'Anantapur')
WHERE State='Bihar' and City = 'Ananthapur';

UPDATE pallet_data
SET City = REPLACE(City, 'Ambah', 'Ambad')
WHERE State='Maharashtra' and City = 'Ambah';
UPDATE pallet_data
SET City = REPLACE(City, 'Auranagabad', 'Aurangabad')
WHERE State='Maharashtra' and City = 'Auranagabad';

Select  State , City , sum(QTY) from pallet_data where City like 'B%' or 'b%' group by   State , City order by  State , City ;
UPDATE pallet_data
SET City = REPLACE(City, 'Banglore', 'Bangalore')
WHERE State='Karnataka' and City = 'Banglore';
UPDATE pallet_data
SET City = REPLACE(City, 'Bhuvneshwara', 'Bhubaneswar')
WHERE State='Odisha' and City = 'Bhuvneshwara';
UPDATE pallet_data
SET City = REPLACE(City, 'Barielly', 'Bareilly')
WHERE State='Uttar Pradesh' and City = 'Barielly';
UPDATE pallet_data
SET City = REPLACE(City, 'Bulandshahr', 'Bulandshahar')
WHERE State='Uttar Pradesh' and City = 'Bulandshahr';
UPDATE pallet_data
SET City = REPLACE(City, 'Bardhman', 'Bardhaman')
WHERE State='West Bengal' and City = 'Bardhman';

Select  State , City , sum(QTY) from pallet_data where City like 'C%' or 'c%' group by   State , City order by  State , City ;
UPDATE pallet_data
SET State = REPLACE(State, 'Karnataka', 'Tamil Nadu')
WHERE City='Chennai' and State = 'Karnataka';

UPDATE pallet_data
SET City = REPLACE(City, 'Chikballapur', 'Chikkaballapur')
WHERE State='Karnataka' and City = 'Chikballapur';

UPDATE pallet_data
SET City = REPLACE(City, 'Chikkaballapura', 'Chikkaballapur')
WHERE State='Karnataka' and City = 'Chikkaballapura';

UPDATE pallet_data
SET City = REPLACE(City, 'Cuttack', 'Cuttak')
WHERE State='Odisha' and City = 'Cuttack';

Select  State , City , sum(QTY) from pallet_data where City like 'D%' or 'd%' group by   State , City order by  State , City ;
UPDATE pallet_data
SET City = REPLACE(City, 'Dera Bassi', 'Derabassi')
WHERE State='Punjab' and City = 'Dera Bassi';

Select  State , City , sum(QTY) from pallet_data where City like 'E%' or 'e%' group by   State , City order by  State , City ;
UPDATE pallet_data
SET City = REPLACE(City, 'Ernakulum', 'Ernakulam')
WHERE State='Kerala' and City = 'Ernakulum';

Select  State , City , sum(QTY) from pallet_data where City like 'F%' or 'f%' group by   State , City order by  State , City ;
UPDATE pallet_data
SET City = REPLACE(City, 'Fariadabad', 'Faridabad')
WHERE State='Haryana' and City = 'Fariadabad';
UPDATE pallet_data
SET City = REPLACE(City, 'Farrukhnagar', 'Farukh Nagar')
WHERE State='Haryana' and City = 'Farrukhnagar';
UPDATE pallet_data
SET City = REPLACE(City, 'Fatehgarh', 'Fatehgarh Sahib')
WHERE State='Punjab' and City = 'Fatehgarh';

Select  State , City , sum(QTY) from pallet_data where City like 'H%' or 'h%' group by   State , City order by  State , City ;
UPDATE pallet_data
SET City = REPLACE(City, 'Hissar', 'Hisar')
WHERE State='Haryana' and City = 'Hissar';
UPDATE pallet_data
SET City = REPLACE(City, 'Harihara', 'Harihar')
WHERE State='Karnataka' and City = 'Harihara';
UPDATE pallet_data
SET City = REPLACE(City, 'Hubballi', 'Hubli')
WHERE State='Karnataka' and City = 'Hubballi';
Select  State , City , sum(QTY) from pallet_data where City like 'K%' or 'k%' group by   State , City order by  State , City ;
UPDATE pallet_data
SET City = REPLACE(City, 'Khorda', 'Khordha')
WHERE State='Odisha' and City = 'Khorda';
UPDATE pallet_data
SET City = REPLACE(City, 'Khurda', 'Khordha')
WHERE State='Odisha' and City = 'Khurda';
UPDATE pallet_data
SET City = REPLACE(City, 'Kancheepuram', 'Kanchipuram')
WHERE State='Tamil Nadu' and City = 'Kancheepuram';
UPDATE pallet_data
SET City = REPLACE(City, 'Kangayem', 'Kangeyam')
WHERE State='Tamil Nadu' and City = 'Kangayem';
Select  State , City , sum(QTY) from pallet_data where City like 'M%' or 'm%' group by   State , City order by  State , City ;
UPDATE pallet_data
SET City = REPLACE(City, 'Mahesana', 'Mehsana')
WHERE State='Gujarat' and City = 'Mahesana';
Select  State , City , sum(QTY) from pallet_data where City like 'R%' or 'r%' group by   State , City order by  State , City ;
UPDATE pallet_data
SET City = REPLACE(City, 'Rajamahendravaram', 'Rajahmundry')
WHERE State='Andhra Pradesh' and City = 'Rajamahendravaram';
UPDATE pallet_data
SET City = REPLACE(City, 'Rangareddy', 'Ranga Reddy')
WHERE State='Telangana' and City = 'Rangareddy';
Select  State , City , sum(QTY) from pallet_data where City like 'T%' or 't%' group by   State , City order by  State , City ;
UPDATE pallet_data
SET City = REPLACE(City, 'Trivandrum', 'Thiruvananthapuram')
WHERE State='Kerala' and City = 'Trivandrum';
Select  State , City , sum(QTY) from pallet_data where City like 'V%' or 'v%' group by   State , City order by  State , City ;
UPDATE pallet_data
SET City = REPLACE(City, 'Vijaywada', 'Vijayawada')
WHERE State='Andhra Pradesh' and City = 'Vijaywada';
UPDATE pallet_data
SET City = REPLACE(City, 'Vishakhapatnam', 'Visakhapatnam')
WHERE State='Andhra Pradesh' and City = 'Vishakhapatnam';
UPDATE pallet_data
SET City = REPLACE(City, 'Villupuram', 'Viluppuram')
WHERE State='Tamil Nadu' and City = 'Villupuram';

/* Count Distinct City */
select count(distinct City) from pallet_data;

/* create a table exclusing duplicates */
CREATE TABLE pallet_processed AS
SELECT *
FROM pallet_data
WHERE 1 = 0;

INSERT INTO pallet_processed SELECT Date, CustName, City, Region, State, ProductCode, TransactionType, Qty, WHName from
    (SELECT Date, CustName, City, Region, State, ProductCode, TransactionType, Qty, WHName,
           ROW_NUMBER() OVER (
               PARTITION BY Date, CustName, City, Region, State, ProductCode, TransactionType, Qty, WHName
               ORDER BY Date) AS row_num
    FROM pallet_data
)As cte
WHERE row_num <2;

/* outlier count Gaussian */
WITH stats AS (
  SELECT AVG(abs(qty)) AS mean, stddev(qty) AS stdev
  FROM pallet_processed where TransactionType='Allot'
),
z_scores AS (
  SELECT abs(qty), (abs(qty) - mean) / stdev AS z_score
  FROM pallet_processed , stats
)
SELECT count(*)
FROM z_scores
WHERE ABS(z_score) > 3;

WITH stats AS (
  SELECT AVG(abs(qty)) AS mean, stddev(qty) AS stdev
  FROM pallet_processed where TransactionType='Return'
),
z_scores AS (
  SELECT abs(qty), (abs(qty) - mean) / stdev AS z_score
  FROM pallet_processed , stats
)
SELECT count(*)
FROM z_scores
WHERE ABS(z_score) > 3;

/* dint do any outlier treatment beacuse of no sign of too extreme and could be valid data points */

/* count */
select count(*) from pallet_processed;
select count(*) from pallet_processed where TransactionType = 'Allot';
select count(*) from pallet_processed where TransactionType = 'Return';

/* MIN */
select min(QTY) as min from pallet_processed where TransactionType = 'Allot' ;
select min(abs(QTY)) as min from pallet_processed where TransactionType = 'Return' ;

/* MAX */
select max(QTY) as max from pallet_processed where TransactionType = 'Allot' ;
select max(abs(QTY)) as max from pallet_processed where TransactionType = 'Return' ;

/* MEAN */
select avg(QTY) as Mean from pallet_processed where TransactionType = 'Allot' ;
select avg(abs(QTY)) as Mean from pallet_processed where TransactionType = 'Return' ;

/*  MEDIAN */
SELECT QTY AS median_QTY
FROM (
    SELECT QTY, ROW_NUMBER() OVER (ORDER BY QTY) AS row_num,
           COUNT(*) OVER () AS total_count
    FROM pallet_processed where TransactionType = 'Allot'
) AS median
WHERE row_num = (total_count + 1) / 2 OR row_num = (total_count + 2) / 2;   

SELECT abs(QTY) AS median_QTY
FROM (
    SELECT QTY, ROW_NUMBER() OVER (ORDER BY QTY) AS row_num,
           COUNT(*) OVER () AS total_count
    FROM pallet_processed where TransactionType = 'Return'
) AS median
WHERE row_num = (total_count + 1) / 2 OR row_num = (total_count + 2) / 2;

/* Mode */
SELECT QTY AS mode_QTY
FROM (
    SELECT QTY, COUNT(*) AS frequency
    FROM pallet_processed
    where TransactionType = 'Allot'
    GROUP BY QTY
    ORDER BY frequency DESC
    LIMIT 1
) AS mode;

SELECT abs(QTY) AS mode_QTY
FROM (
    SELECT QTY, COUNT(*) AS frequency
    FROM pallet_processed
     where TransactionType = 'Return'
    GROUP BY QTY
    ORDER BY frequency DESC
    LIMIT 1
) AS mode;

/*  VARIANCE */
SELECT VARIANCE(QTY) AS allot_variance
FROM pallet_processed where TransactionType = 'Allot';

SELECT VARIANCE(QTY) AS return_variance
FROM pallet_processed where TransactionType = 'Return';

/* Standard Deviation */
SELECT STDDEV(QTY) AS allot_std
FROM pallet_processed where TransactionType = 'Allot';

SELECT STDDEV(QTY) AS return_std
FROM pallet_processed where TransactionType = 'Return';

/*  RANGE */
SELECT MAX(QTY) - MIN(QTY) AS allot_range
FROM pallet_processed where TransactionType = 'Allot';

SELECT MAX(abs(QTY)) - MIN(abs(QTY)) AS return_range
FROM pallet_processed where TransactionType = 'Return';

/* SKEWNESS */
SELECT
    (
        SUM(POWER(QTY - (SELECT AVG(QTY) FROM pallet_processed where TransactionType = 'Allot'), 3)) / 
        (COUNT(*) * POWER((SELECT STDDEV(QTY) FROM pallet_processed where TransactionType = 'Allot'), 3))
    ) AS allot_skewness FROM pallet_processed where TransactionType = 'Allot' ;
  SELECT
    (
        SUM(-POWER(QTY - (SELECT AVG(QTY) FROM pallet_processed where TransactionType = 'Return'), 3)) / 
        (COUNT(*) * POWER((SELECT STDDEV(QTY) FROM pallet_processed where TransactionType = 'Return'), 3))
    ) AS return_skewness FROM pallet_processed where TransactionType = 'Return';

  /* KURTOSIS */
  
  SELECT  (
        (SUM(POWER(QTY - (SELECT AVG(QTY) FROM pallet_processed where TransactionType = 'Allot'), 4)) / 
        (COUNT(*) * POWER((SELECT STDDEV(QTY) FROM pallet_processed where TransactionType = 'Allot'), 4))) - 3
    ) AS allot_kurtosis  FROM pallet_processed where TransactionType = 'Allot';

  SELECT  (
        (SUM(POWER(QTY - (SELECT AVG(QTY) FROM pallet_processed where TransactionType = 'Return'), 4)) / 
        (COUNT(*) * POWER((SELECT STDDEV(QTY) FROM pallet_processed where TransactionType = 'Return'), 4))) - 3
    ) AS return_kurtosis  FROM pallet_processed where TransactionType = 'Return';


/* Count Duplicate Records */
SELECT count(*)
FROM (
  SELECT Date, CustName, City, Region, State, ProductCode, TransactionType, Qty, WHName,
  ROW_NUMBER() OVER (
    PARTITION BY Date, CustName, City, Region, State, ProductCode, TransactionType, Qty, WHName
    ORDER BY Date
  ) AS row_no
  FROM pallet_processed
) x
WHERE x.row_no > 1;

/* Count Distinct CustName */
select count(distinct CustNAme) from pallet_processed;

/* Count Distinct City */
select count(distinct City) from pallet_processed;

/* Count Distinct State */
select count(distinct State) from pallet_processed;

/* Count Distinct WHNAme */
select count(distinct WHNAME) from pallet_processed;

/* Count Distinct ProductCode */
select count(distinct ProductCode) from pallet_processed;

/* sum of allots greater than 200 median */
select sum(QTY) as allots_greaterthan_median from pallet_processed where QTY>200 and TransactionType='Allot';
/* sum of Returns greater than 154 median */
select sum(abs(QTY)) as returns_greaterthan_median from pallet_processed where abs(QTY)>154 and TransactionType='Return';

/* sum of allots less than 200 median  */
select sum(QTY) as allots_lessthan_median from pallet_processed where QTY<200 and TransactionType='Allot';
/* sum of returns less than 154 median */
select sum(abs(QTY)) as returns_lessthan_median from pallet_processed where abs(QTY)<154 and TransactionType='Return';

/* number of allots greater than 200 median */
select count(QTY) as allots_greaterthan_median from pallet_processed where QTY>200 and TransactionType='Allot';
/* number of Returns greater than 154 median */
select count(abs(QTY)) as returns_greaterthan_median from pallet_processed where abs(QTY)>154 and TransactionType='Return';

/* number of allots less than 200 median  */
select count(QTY) as allots_lessthan_median from pallet_processed where QTY<200 and TransactionType='Allot';
/* number of returns less than 154 median */
select count(abs(QTY)) as returns_lessthan_median from pallet_processed where abs(QTY)<154 and TransactionType='Return';

/* count below Q1 */
SELECT COUNT(*) * 0.25 FROM pallet_processed WHERE TransactionType = 'Allot';
SELECT Qty
FROM pallet_processed
WHERE TransactionType = 'Allot'
ORDER BY Qty
LIMIT 1 OFFSET 8962;

SELECT 
  COUNT(QTY) AS CountBelowQ1
FROM pallet_processed
WHERE TransactionType = 'Allot' -- Adjust the filter as needed
  AND Qty < 120;

SELECT COUNT(*) * 0.25 FROM pallet_processed WHERE TransactionType = 'Return';
SELECT abs(Qty)
FROM pallet_processed
WHERE TransactionType = 'Return'
ORDER BY Qty
LIMIT 1 OFFSET 7044;

SELECT 
  COUNT(QTY) AS CountBelowQ1
FROM pallet_processed
WHERE TransactionType = 'Return' -- Adjust the filter as needed
  AND Qty < 240;


/* count over Q3 */
SELECT COUNT(*) * 0.75 FROM pallet_processed WHERE TransactionType = 'Allot';
SELECT Qty
FROM pallet_processed
WHERE TransactionType = 'Allot'
ORDER BY Qty
LIMIT 1 OFFSET 26886;

SELECT 
  COUNT(QTY) AS CountoverQ3
FROM pallet_processed
WHERE TransactionType = 'Allot' -- Adjust the filter as needed
  AND Qty > 270;

SELECT COUNT(*) * 0.75 FROM pallet_processed WHERE TransactionType = 'Return';
SELECT abs(Qty)
FROM pallet_processed
WHERE TransactionType = 'Return'
ORDER BY Qty
LIMIT 1 OFFSET 21132;

SELECT 
  COUNT(QTY) AS CountoverQ3
FROM pallet_processed
WHERE TransactionType = 'Return' -- Adjust the filter as needed
  AND Qty > 78;


/* Top customer by allot quantity */
SELECT
    CustName,
    SUM(QTY) AS TotalAllotQuantity
FROM
    pallet_processed
WHERE
    TransactionType = 'Allot'
GROUP BY
    CustName
ORDER BY
    TotalAllotQuantity DESC
LIMIT 1;
/* Top customer by allot quantity */
SELECT
    CustName,
    SUM(QTY) AS TotalAllotQuantity
FROM
    pallet_processed
WHERE
    TransactionType = 'Allot'
GROUP BY
    CustName
ORDER BY
    TotalAllotQuantity DESC
LIMIT 1;
/* Top customer by Return quantity */
SELECT
    CustName,
    SUM(abs(QTY)) AS TotalReturnQuantity
FROM
    pallet_processed
WHERE
    TransactionType = 'Return'
GROUP BY
    CustName
ORDER BY
    TotalReturnQuantity DESC
LIMIT 1;

/* region wise contribution percent */
SELECT
    Region,
    SUM(QTY) AS TotalAllotQuantity,
    SUM(QTY) / (SELECT SUM(QTY) FROM pallet_processed WHERE TransactionType = 'Allot') * 100 AS PercentageContribution
FROM
    pallet_processed
WHERE
    TransactionType = 'Allot'
GROUP BY
    Region
ORDER BY
    PercentageContribution DESC;
SELECT
    Region,
    SUM(abs(QTY)) AS TotalAllotQuantity,
    SUM(abs(QTY)) / (SELECT SUM(abs(QTY)) FROM pallet_processed WHERE TransactionType = 'Return') * 100 AS PercentageContribution
FROM
    pallet_processed
WHERE
    TransactionType = 'Return'
GROUP BY
    Region
ORDER BY
    PercentageContribution DESC;
/* top state by contribution */
SELECT
    State,
    SUM(QTY) AS TotalAllotQuantity
FROM
    pallet_processed
WHERE
    TransactionType = 'Allot'
GROUP BY
    State
ORDER BY
    TotalAllotQuantity DESC
LIMIT 1;

/* top state by contribution */
SELECT
    State,
    SUM(abs(QTY)) AS TotalreturnQuantity
FROM
    pallet_processed
WHERE
    TransactionType = 'Return'
GROUP BY
    State
ORDER BY
    TotalreturnQuantity DESC
LIMIT 1;


/* top state by contribution */
SELECT
    State,
    SUM(QTY) AS TotalAllotQuantity
FROM
    pallet_processed
WHERE
    TransactionType = 'Allot'
GROUP BY
    State
ORDER BY
    TotalAllotQuantity asc
LIMIT 1;
/* top state by contribution */
SELECT
    State,
    SUM(abs(QTY)) AS TotalreturnQuantity
FROM
    pallet_processed
WHERE
    TransactionType = 'Return'
GROUP BY
    State
ORDER BY
    TotalreturnQuantity asc
LIMIT 1;

/* most and least utilized warehouses */
SELECT
    WHName,
    COUNT(*) AS TransactionCount
FROM
    pallet_processed
WHERE
    TransactionType = 'Allot'
GROUP BY
    WHName
ORDER BY
    TransactionCount DESC
limit 1;
SELECT
    WHName,
    COUNT(*) AS TransactionCount
FROM
    pallet_processed
WHERE
    TransactionType = 'Return'
GROUP BY
    WHName
ORDER BY
    TransactionCount DESC
limit 1;
SELECT
    WHName,
    COUNT(*) AS TransactionCount
FROM
    pallet_processed
WHERE
    TransactionType = 'Allot'
GROUP BY
    WHName
ORDER BY
    TransactionCount asc
limit 1;
SELECT
    WHName,
    COUNT(*) AS TransactionCount
FROM
    pallet_processed
WHERE
    TransactionType = 'Return'
GROUP BY
    WHName
ORDER BY
    TransactionCount asc
limit 1;

/* most contributed product */
SELECT
    ProductCode,
    (COUNT(*) * 100 / (SELECT COUNT(*) FROM pallet_processed WHERE TransactionType = 'Allot')) AS Percentage
FROM
    pallet_processed
WHERE
    TransactionType = 'Allot'
GROUP BY
    ProductCode
ORDER BY
    Percentage DESC
LIMIT 1;

SELECT
    ProductCode,
    (COUNT(*) * 100 / (SELECT COUNT(*) FROM pallet_processed WHERE TransactionType = 'Return')) AS Percentage
FROM
    pallet_processed
WHERE
    TransactionType = 'Return'
GROUP BY
    ProductCode
ORDER BY
    Percentage DESC
LIMIT 1;

SELECT
    ProductCode,
    (COUNT(*) * 100 / (SELECT COUNT(*) FROM pallet_processed WHERE TransactionType = 'Allot')) AS Percentage
FROM
    pallet_processed
WHERE
    TransactionType = 'Allot'
GROUP BY
    ProductCode
ORDER BY
    Percentage asc
LIMIT 1;

SELECT
    ProductCode,
    (COUNT(*) * 100 / (SELECT COUNT(*) FROM pallet_processed WHERE TransactionType = 'Return')) AS Percentage
FROM
    pallet_processed
WHERE
    TransactionType = 'Return'
GROUP BY
    ProductCode
ORDER BY
    Percentage asc
LIMIT 1;

select *  from processed_pallet where TransactionType = 'Return' ;