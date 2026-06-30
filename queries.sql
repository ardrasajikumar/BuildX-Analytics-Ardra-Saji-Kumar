-- ============================================
-- BuildX Bootcamp — Part B2: SQL Business Analysis
-- Dataset: IPL Ball-by-Ball 2008–2025
-- ============================================

-- Query 1: WHERE
-- Purpose: Find all balls bowled in matches held in Mumbai during the 2024 season
SELECT match_id, batting_team, bowling_team, batter, bowler, runs_total
FROM ipl
WHERE city = 'Mumbai' AND year = 2024;


-- Query 2: GROUP BY + SUM
-- Purpose: Total runs scored by each team across all seasons
SELECT batting_team,
       SUM(runs_total) AS total_runs
FROM ipl
GROUP BY batting_team
ORDER BY total_runs DESC;


-- Query 3: ORDER BY DESC
-- Purpose: Top 10 highest individual run-scorers (batters) overall
SELECT batter,
       SUM(runs_by_batter) AS total_runs_scored
FROM ipl
GROUP BY batter
ORDER BY total_runs_scored DESC
LIMIT 10;


-- Query 4: HAVING
-- Purpose: Identify bowlers who have bowled a significant number of balls (500+)
-- and conceded a high total of runs, useful for spotting frequently used bowlers
SELECT bowler,
       COUNT(*) AS balls_bowled,
       SUM(runs_conceded_by) AS total_runs_conceded
FROM ipl
GROUP BY bowler
HAVING COUNT(*) >= 500
ORDER BY total_runs_conceded DESC;


-- Query 5: LIKE / BETWEEN
-- Purpose: Find all deliveries involving a specific player (partial name match)
-- and restrict to years between 2018 and 2022
SELECT match_id, year, batter, bowler, runs_total
FROM ipl
WHERE batter LIKE '%Kohli%'
  AND year BETWEEN 2018 AND 2022;


-- Query 6: Advanced analytical query (GROUP BY + HAVING + ORDER BY + calculated metric)
-- Purpose: Calculate bowling economy rate for bowlers with at least 500 valid balls
-- bowled, to identify the most economical (best) bowlers in the dataset
SELECT bowler,
       COUNT(*) AS balls_bowled,
       SUM(runs_conceded_by) AS runs_conceded,
       SUM(CASE WHEN wicket_kind <> 'none' THEN 1 ELSE 0 END) AS wickets_taken,
       ROUND(SUM(runs_conceded_by) * 6.0 / COUNT(*), 2) AS economy_rate
FROM ipl
WHERE valid_ball = 'True'
GROUP BY bowler
HAVING COUNT(*) >= 500
ORDER BY economy_rate ASC
LIMIT 15;