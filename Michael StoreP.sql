USE [mcomm_platform]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE MichaelStoreProcedure @promoid int AS
if @promoid is not NULL 
SELECT 
		u.[promoid] AS promoid,
		p.[promo_name] + ' ' + p.[promo_desc] + ' ' + p.[promo_title] AS Title, 
		count(u.[is_used]) AS Used,
		count(u.[date_participated]) As Viewed, 
		Sum(Case when u.[is_redeemed] = 0 OR u.[is_redeemed] IS NULL then 0 else 1 end) AS Redeemed ,
		CAST(CAST(Sum(Case when u.[is_redeemed] = 0 OR u.[is_redeemed] IS NULL then 0 else 1 end)as decimal(10,3))/CAST(count(u.[date_participated]) as decimal(10,3)) as decimal(10,3)) as RedemptionRatio,
		AVG(DATEDIFF(n, date_participated, date_redeemed)) AS TimeTaken 
		from  [mcomm_platform].[dbo].[web_user] AS u
		JOIN [mcomm_platform].[dbo].[web_promotion] As p 
		ON (u.[promoid] = p.[promoid]) 
		where u.[promoid] = @promoid
		GROUP BY p.[promo_name],p.[promo_desc], p.[promo_title], u.[promoid] 	
GO
