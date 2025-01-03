-- 5.3.

-- Option 1: Dynamic CASE WHEN
-- First, get all accommodation types dynamically
DECLARE @sql NVARCHAR(MAX) = 
'SELECT 
    p.ProvinceName,';

-- Add CASE statements for each accommodation type
SELECT @sql = @sql + '
    SUM(CASE WHEN at.AccommodationType = ''' + AccommodationType + ''' THEN 1 ELSE 0 END) AS ' + QUOTENAME(AccommodationType) + ','
FROM ACCOMMODATION_TYPE;

-- Complete the query
SET @sql = @sql + '
    COUNT(*) AS TotalAccommodations
FROM 
    ACCOMMODATION a
    JOIN ACCOMMODATION_TYPE at ON a.AccommodationTypeID = at.AccommodationTypeID
    JOIN CITY_DISTRICT cd ON a.[CityDistrictID] = cd.[CityDistrictID]
    JOIN PROVINCE p ON cd.ProvinceID = p.ProvinceID
GROUP BY 
    p.ProvinceName
ORDER BY 
    TotalAccommodations DESC';

EXEC sp_executesql @sql;




-- Option 2: Pivot
DECLARE @cols NVARCHAR(MAX);
DECLARE @query NVARCHAR(MAX);
-- Step 1: Get distinct accommodation type values
WITH ProvinceValues AS (
    SELECT DISTINCT AccommodationType
    FROM ACCOMMODATION_TYPE
)
-- Step 2: Build dynamic SQL for pivot query
SELECT @cols = STRING_AGG(QUOTENAME(AccommodationType), ', ')
FROM ProvinceValues;
-- Step 3: Construct the dynamic SQL query
SET @query = '
SELECT 
    ProvinceName, 
    ' + @cols + ',
    (' + REPLACE(@cols, ', ', ' + ') + ') AS TotalAccommodations
FROM (
    SELECT ProvinceName, AccommodationType
    FROM 
    ACCOMMODATION a
    JOIN ACCOMMODATION_TYPE at ON a.AccommodationTypeID = at.AccommodationTypeID
    JOIN [CITY_DISTRICT] cd ON a.[CityDistrictID] = cd.[CityDistrictID]
    JOIN PROVINCE p ON cd.ProvinceID = p.ProvinceID
) AS SourceTable
PIVOT (
    COUNT(AccommodationType)
    FOR AccommodationType IN (' + @cols + ')
) AS PivotTable
ORDER BY TotalAccommodations DESC;';
-- Step 4: Execute the dynamic SQL
EXECUTE(@query);