WITH free_popup_header AS
(
SELECT
	free_popup_header as [contain_value],
	SUM(registrations) as registrations,
	ROUND((CAST(SUM(registrations) AS FLOAT) / CAST((SELECT SUM(registrations) as total_reg FROM analytics_result) AS float)),2) as reg_pct
FROM
	analytics_result
GROUP BY
	free_popup_header
)

, download_popup_header AS
(
SELECT
	download_popup_header as [contain_value],
	SUM(registrations) as registrations,
	ROUND((CAST(SUM(registrations) AS FLOAT) / CAST((SELECT SUM(registrations) as total_reg FROM analytics_result) AS float)),2) as reg_pct
FROM
	analytics_result
GROUP BY
	download_popup_header
)


, craft_popup_subject AS
(SELECT
	craft_popup_subject as [contain_value],
	SUM(registrations) as registrations,
	ROUND((CAST(SUM(registrations) AS FLOAT) / CAST((SELECT SUM(registrations) as total_reg FROM analytics_result) AS float)),2) as reg_pct
FROM
	analytics_result
GROUP BY
	craft_popup_subject
)


, marketing_popup_subject AS
(SELECT
	marketing_popup_subject as [contain_value],
	SUM(registrations) as registrations,
	ROUND((CAST(SUM(registrations) AS FLOAT) / CAST((SELECT SUM(registrations) as total_reg FROM analytics_result) AS float)),2) as reg_pct
FROM
	analytics_result
GROUP BY
	marketing_popup_subject
)


, publishing_popup_subject AS
(SELECT
	publishing_popup_subject as [contain_value],
	SUM(registrations) as registrations,
	ROUND((CAST(SUM(registrations) AS FLOAT) / CAST((SELECT SUM(registrations) as total_reg FROM analytics_result) AS float)),2) as reg_pct
FROM
	analytics_result
GROUP BY
	publishing_popup_subject
)


, author_popup_subject AS
(SELECT
	author_popup_subject as [contain_value],
	SUM(registrations) as registrations,
	ROUND((CAST(SUM(registrations) AS FLOAT) / CAST((SELECT SUM(registrations) as total_reg FROM analytics_result) AS float)),2) as reg_pct
FROM
	analytics_result
GROUP BY
	author_popup_subject
)


, discovery_popup_subject AS
(SELECT
	discovery_popup_subject as [contain_value],
	SUM(registrations) as registrations,
	ROUND((CAST(SUM(registrations) AS FLOAT) / CAST((SELECT SUM(registrations) as total_reg FROM analytics_result) AS float)),2) as reg_pct
FROM
	analytics_result
GROUP BY
	discovery_popup_subject
)


, generator_popup_subject AS
(SELECT
	generator_popup_subject as [contain_value],
	SUM(registrations) as registrations,
	ROUND((CAST(SUM(registrations) AS FLOAT) / CAST((SELECT SUM(registrations) as total_reg FROM analytics_result) AS float)),2) as reg_pct
FROM
	analytics_result
GROUP BY
	generator_popup_subject
)


, howto_popup_title AS
(SELECT
	howto_popup_title as [contain_value],
	SUM(registrations) as registrations,
	ROUND((CAST(SUM(registrations) AS FLOAT) / CAST((SELECT SUM(registrations) as total_reg FROM analytics_result) AS float)),2) as reg_pct
FROM
	analytics_result
GROUP BY
	howto_popup_title
)

---------------------------------------------------------------------------

SELECT
	CASE WHEN v1.contain_value = 1
		THEN 'YES' ELSE 'NO'
	END AS contains_value,
	v1.registrations as free_popup_header,
	v1.reg_pct as free_popup_header_pct,
	v2.registrations as download_popup_header,
	v2.reg_pct as download_popup_header_pct,
	v3.registrations as craft_popup_subject,
	v3.reg_pct as craft_popup_subject_pct,
	v4.registrations as marketing_popup_subject,
	v4.reg_pct as marketing_popup_subject_pct,
	v5.registrations as publishing_popup_subject,
	v5.reg_pct as publishing_popup_subject_pct,
	v6.registrations as author_popup_subject,
	v6.reg_pct as author_popup_subject_pct,
	v7.registrations as discovery_popup_subject,
	v7.reg_pct as discovery_popup_subject_pct,
	v8.registrations as generator_popup_subject,
	v8.reg_pct as generator_popup_subject_pct,
	v9.registrations as howto_popup_title,
	v9.reg_pct as howto_popup_title_pct
FROM free_popup_header v1
LEFT OUTER JOIN download_popup_header v2
ON v1.contain_value = v2.contain_value
LEFT OUTER JOIN craft_popup_subject v3
ON v1.contain_value = v3.contain_value
LEFT OUTER JOIN marketing_popup_subject v4
ON v1.contain_value = v4.contain_value
LEFT OUTER JOIN publishing_popup_subject v5
ON v1.contain_value = v5.contain_value
LEFT OUTER JOIN author_popup_subject v6
ON v1.contain_value = v6.contain_value
LEFT OUTER JOIN discovery_popup_subject v7
ON v1.contain_value = v7.contain_value
LEFT OUTER JOIN generator_popup_subject v8
ON v1.contain_value = v8.contain_value
LEFT OUTER JOIN howto_popup_title v9
ON v1.contain_value = v9.contain_value

ORDER BY v1.contain_value DESC