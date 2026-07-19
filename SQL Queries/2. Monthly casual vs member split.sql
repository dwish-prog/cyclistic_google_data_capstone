SELECT
    CASE 
        WHEN GROUPING(ride_month) = 1 AND GROUPING((ride_month - 1) / 3 + 1) = 1 THEN 'Total'
        WHEN GROUPING(ride_month) = 1 THEN 'Q' + CAST((MAX(ride_month) - 1) / 3 + 1 AS VARCHAR(1)) + ' Total'
        ELSE DATENAME(MONTH, DATEADD(MONTH, ride_month, -1))
    END AS [Period],
    
    -- Raw Volumes
    SUM(CASE WHEN member_casual = 'casual' THEN 1 ELSE 0 END) AS [Casual Trips],
    SUM(CASE WHEN member_casual = 'member' THEN 1 ELSE 0 END) AS [Member Trips],
    COUNT(*) AS [Total Trips],
    
    -- Split WITHIN the Period (Horizontal Proportion)
    ROUND(SUM(CASE WHEN member_casual = 'casual' THEN 1.0 ELSE 0 END) * 100.0 / COUNT(*), 2) AS [Casual Split (%)],
    ROUND(SUM(CASE WHEN member_casual = 'member' THEN 1.0 ELSE 0 END) * 100.0 / COUNT(*), 2) AS [Member Split (%)],
    
    -- Contribution to the ANNUAL Dataset (Vertical Proportion)
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM all_trips_master), 2) AS [Annual Contribution (%)]
FROM all_trips_master
GROUP BY GROUPING SETS (
    ((ride_month - 1) / 3 + 1, ride_month), -- Individual Months
    ((ride_month - 1) / 3 + 1),             -- Quarterly Totals
    ()                                      -- Grand Total
)
ORDER BY 
    GROUPING((ride_month - 1) / 3 + 1), 
    GROUPING(ride_month),                                        
    ride_month,                                                  
    MAX(ride_month);