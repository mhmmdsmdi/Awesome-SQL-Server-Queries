SELECT * FROM
(
SELECT
    t.name AS TableName,
    s.name AS SchemaName,
    p.rows AS [RowCount], 
    FORMAT(p.rows, 'N0') AS [HRowCount], 
    FORMAT(SUM(a.used_pages) * 8, 'N0') AS HUsedSpaceKB,
    SUM(a.used_pages) * 8 AS UsedSpaceKB,
    FORMAT(CAST(ROUND(((SUM(a.used_pages) * 8) / 1024.00), 2) AS NUMERIC(36, 2)), 'N2') AS HUsedSpaceMB,
    CAST(ROUND(((SUM(a.used_pages) * 8) / 1024.00), 2) AS NUMERIC(36, 2)) AS UsedSpaceMB,
    FORMAT(CAST(ROUND(((SUM(a.used_pages) * 8) / 1024.00 / 1024.00), 2) AS NUMERIC(36, 2)), 'N2') AS HUsedSpaceGB,
    CAST(ROUND(((SUM(a.used_pages) * 8) / 1024.00 / 1024.00), 2) AS NUMERIC(36, 2)) AS UsedSpaceGB,
    FORMAT((SUM(a.total_pages) - SUM(a.used_pages)) * 8, 'N0') AS HUnusedSpaceKB,
    (SUM(a.total_pages) - SUM(a.used_pages)) * 8 AS UnusedSpaceKB,
    FORMAT(CAST(ROUND(((SUM(a.total_pages) - SUM(a.used_pages)) * 8) / 1024.00, 2) AS NUMERIC(36, 2)), 'N2') AS HUnusedSpaceMB,
    CAST(ROUND(((SUM(a.total_pages) - SUM(a.used_pages)) * 8) / 1024.00, 2) AS NUMERIC(36, 2)) AS UnusedSpaceMB,
    FORMAT(CAST(ROUND(((SUM(a.total_pages) - SUM(a.used_pages)) * 8) / 1024.00 / 1024.00, 2) AS NUMERIC(36, 2)), 'N2') AS HUnusedSpaceGB,
    CAST(ROUND(((SUM(a.total_pages) - SUM(a.used_pages)) * 8) / 1024.00 / 1024.00, 2) AS NUMERIC(36, 2)) AS UnusedSpaceGB,
	FORMAT(SUM(a.total_pages) * 8, 'N0') AS HTotalSpaceKB, 
    SUM(a.total_pages) * 8 AS TotalSpaceKB, 
    FORMAT(CAST(ROUND(((SUM(a.total_pages) * 8) / 1024.00), 2) AS NUMERIC(36, 2)), 'N2') AS HTotalSpaceMB,
    CAST(ROUND(((SUM(a.total_pages) * 8) / 1024.00), 2) AS NUMERIC(36, 2)) AS TotalSpaceMB,
    FORMAT(CAST(ROUND(((SUM(a.total_pages) * 8) / 1024.00 / 1024.00), 2) AS NUMERIC(36, 2)), 'N2') AS HTotalSpaceGB,
    CAST(ROUND(((SUM(a.total_pages) * 8) / 1024.00 / 1024.00), 2) AS NUMERIC(36, 2)) AS TotalSpaceGB
FROM
  sys.tables t
  INNER JOIN sys.indexes i ON t.object_id = i.object_id
  INNER JOIN sys.partitions p ON i.object_id = p.object_id 
  AND i.index_id = p.index_id
  INNER JOIN sys.allocation_units a ON p.partition_id = a.container_id
  LEFT OUTER JOIN sys.schemas s ON t.schema_id = s.schema_id 
WHERE
  t.name NOT LIKE 'dt%' 
  AND t.is_ms_shipped = 0 
  AND i.object_id > 255 
GROUP BY
  t.name,
  s.name,
  p.rows
) AS [Inofrmation]
-- FOR JSON AUTO;