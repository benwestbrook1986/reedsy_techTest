USE [Bookly_Task]
GO

CREATE TABLE analytics_result AS
(
	id integer,
	free_popup_header integer,
	download_popup_header integer,
	craft_popup_subject integer,
	marketing_popup_subject integer,
	publishing_popup_subject integer,
	author_popup_subject integer,
	discovery_popup_subject integer,
	generator_popup_subject integer,
	howto_popup_title integer,
	frequency as url_frequency integer,
	name_frequency integer,
	[views] integer,
	registrations integer,
	views_per_registration float
)


------------------------------------------------------------------


DECLARE @LocalTable TABLE
(
	[id] integer identity,
	[popup_name] [nvarchar](max) NULL,
	[blog_post_url] [nvarchar](max) NULL,
	[popup_version_start_date_popup_category] [nvarchar](max) NULL,
	[popup_header] [nvarchar](max) NULL,
	[popup_description] [nvarchar](max) NULL,
	[popup_image_url] [nvarchar](max) NULL,
	[popup_title] [nvarchar](max) NULL,
	[views] [int] NULL,
	[registrations] [int] NULL
)

INSERT INTO @LocalTable
(
	[popup_name],
	[blog_post_url],
	[popup_version_start_date_popup_category],
	[popup_header],
	[popup_description],
	[popup_image_url],
	[popup_title],
	[views],
	[registrations]
)
SELECT
	[popup_name],
	[blog_post_url],
	[popup_version_start_date_popup_category],
	[popup_header],
	[popup_description],
	[popup_image_url],
	[popup_title],
	[views],
	[registrations]
FROM
	Bookly_Task;

---------------------------------------------------------------------------------------------------------

WITH free_content AS
(
	SELECT
		id,
		popup_header,
		CASE WHEN popup_header LIKE '%FREE%' THEN 1 ELSE 0 END AS free_popup_header,
		CASE WHEN popup_header LIKE '%Download%' THEN 1 ELSE 0 END AS download_popup_header
	FROM @LocalTable
)

, view_conversion AS
(
	SELECT
		id,
		ROUND((CAST([views] AS float)/CAST(registrations AS float)),4) as view_per_conversion
	FROM @LocalTable
	WHERE registrations <> 0
)

, popup_subject AS
(
	SELECT
		id,
		popup_header,
		CASE WHEN popup_version_start_date_popup_category
			LIKE '%Perfecting your Craft%'
			THEN 1 ELSE 0 END AS craft_popup_subject,
		CASE WHEN popup_version_start_date_popup_category
			LIKE '%Book Marketing%'
			THEN 1 ELSE 0 END AS marketing_popup_subject,
		CASE WHEN popup_version_start_date_popup_category
			LIKE '%Understanding Publishing%'
			THEN 1 ELSE 0 END AS publishing_popup_subject,
		CASE WHEN popup_version_start_date_popup_category
			LIKE '%From our Authors%'
			THEN 1 ELSE 0 END AS author_popup_subject,
		CASE WHEN popup_version_start_date_popup_category
			LIKE '%discovery%'
			THEN 1 ELSE 0 END AS discovery_popup_subject,
		CASE WHEN popup_version_start_date_popup_category
			LIKE '%generator%'
			THEN 1 ELSE 0 END AS generator_popup_subject
	FROM @LocalTable
)

, popup_title AS
(
	SELECT
		id,
		popup_title,
		CASE WHEN popup_title LIKE '%How to%' THEN 1 ELSE 0 END AS howto_popup_title
	FROM @LocalTable
)

, blog_post_url AS
(
	SELECT
		blog_post_url,
		COUNT(blog_post_url) as frequency
	FROM Bookly_Task
	GROUP BY blog_post_url
)

, popup_name AS
(
	SELECT
		popup_name,
		COUNT(popup_name) as name_frequency
	FROM Bookly_Task
	GROUP BY popup_name
)

-------------------------------------------------------------------------

INSERT INTO dbo.analytics_result
	SELECT
		lt.id,
		fc.free_popup_header,
		fc.download_popup_header,
		ps.craft_popup_subject,
		ps.marketing_popup_subject,
		ps.publishing_popup_subject,
		ps.author_popup_subject,
		ps.discovery_popup_subject,
		ps.generator_popup_subject,
		pt.howto_popup_title,
		bpu.frequency as url_frequency,
		pn.name_frequency,

		lt.[views],
		lt.registrations,
		ISNULL(vc.view_per_conversion,0) as views_per_registration
		FROM @LocalTable lt
	LEFT OUTER JOIN free_content fc
	ON lt.id = fc.id
	LEFT OUTER JOIN view_conversion vc
	ON lt.id = vc.id
	LEFT OUTER JOIN popup_subject ps
	ON lt.id = ps.id
	LEFT OUTER JOIN popup_title pt
	ON lt.id = pt.id
	LEFT OUTER JOIN blog_post_url bpu
	ON lt.blog_post_url = bpu.blog_post_url
	LEFT OUTER JOIN popup_name pn
	ON lt.popup_name = pn.popup_name