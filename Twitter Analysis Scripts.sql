 USE Tweets

SELECT * FROM TgTweets

-- We will perform some query to explore our dataset and to answer some questions.


-- Which hashtag create the most engagement (like + retweet + replies) during the period considered?


SELECT 
     hashtag, 
     SUM(retweets + likes + replies) as engagement
     FROM TgTweets
     GROUP BY hashtag
     ORDER BY engagement DESC

-- What is the average engagement for each day of the week? 
-- The hashtag #Togo63 was excluded in this query because it was used for only a few days around the independance day (27 April)

SELECT 
     hashtag, 
	 day_of_week, 
	 ROUND(AVG(retweets + likes + replies),0) as avg_engagement
     FROM TgTweets
	 WHERE hashtag != '#Togo63'
     GROUP BY hashtag, day_of_week
     ORDER BY avg_engagement DESC

-- What is the total count of each hashtag in a particular month/year? 

SELECT 
    hashtag,
    DATEPART(MONTH, date) AS month,
	DATEPART(YEAR, date) AS year,
    COUNT(*) AS hashtag_count
    FROM TgTweets   
    --WHERE hashtag IN ('#Team228', '#TgTwittos' , '#TT228', '#Togo63')
    GROUP BY hashtag, DATEPART(MONTH, date),DATEPART(YEAR, date)
    ORDER BY hashtag_count DESC
	
	-- Which time of a day of a week a particular hashtag generate the most engagement
	-- this can help to know which hashtag to use in a particular time of the day to reach the most Twittos
	-- once again as a very particular hashtag used during a special occasion, the hashtag #Togo63 was excluded in this analysis
	SELECT hashtag,
	       hour_of_day,
		   day_of_week,
	       SUM(retweets + likes + replies) as engagement
           FROM TgTweets
		   WHERE hashtag != '#Togo63'
		   GROUP BY hashtag,day_of_week,hour_of_day
		   ORDER BY engagement DESC
      
-- What is the distribution or the popularity of each hashtag by location
 -- we will first remplace each NULL value of the location column by Togo

 UPDATE TgTweets
SET location = 'Togo'
WHERE location IS NULL;

SELECT 
      hashtag,
	  location,
	  COUNT (*) AS hashtag_count
      FROM TgTweets
	  GROUP BY hashtag, location
	  ORDER BY hashtag_count DESC

-- Outside Togo, in which country the hastags are popular
-- This can give an idea of the diaspora using the hashtag and the public that can be reached by using them

SELECT 
     location,
	 COUNT (*) AS hashtag_count
	 FROM TgTweets
	 WHERE location != 'Togo'
	 GROUP BY  location
	 ORDER BY hashtag_count DESC;

-- Grouping the engagement in each day in four distincts hour group can we spot which time range on each particular day of the week
-- there is the most engagement with the hashtags to optimize the timing of posts for maximum engagement?

SELECT 
    hashtag, 
    day_of_week,
    CASE 
        WHEN DATEPART(HOUR,date) BETWEEN 0 AND 5 THEN 'Morning' 
        WHEN DATEPART(HOUR,date) BETWEEN 6 AND 11 THEN 'Mid-day' 
        WHEN DATEPART(HOUR,date) BETWEEN 12 AND 17 THEN 'Afternoon' 
        WHEN DATEPART(HOUR,date) BETWEEN 18 AND 23 THEN 'Night' 
    END AS hour_range,
    SUM(retweets + likes + replies) as engagement
    FROM TgTweets
    
GROUP BY 
    hashtag, 
    day_of_week, 
    CASE 
        WHEN DATEPART(HOUR,date) BETWEEN 0 AND 5 THEN 'Morning' 
        WHEN DATEPART(HOUR,date) BETWEEN 6 AND 11 THEN 'Mid-day' 
        WHEN DATEPART(HOUR,date) BETWEEN 12 AND 17 THEN 'Afternoon' 
        WHEN DATEPART(HOUR,date) BETWEEN 18 AND 23 THEN 'Night'  
    END
ORDER BY 
    engagement DESC 
    
	



-- This is the end of our exploratory analysis.