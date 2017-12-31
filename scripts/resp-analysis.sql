SELECT
	scr.NAME,
	NVL(scritemloc.MENU_TEXT, scritemlocref.STRING_VALUE),
  scrv.SCRN_VW_TYPE_CD,
  scrv.PAR_CATEGORY,
	v.NAME,
	NVL(scrvloc.MENU_TEXT, scrvlocref.STRING_VALUE)
FROM
	(
		SELECT
			v.NAME
		FROM
			siebel.S_RESP resp
			JOIN siebel.S_APP_VIEW_RESP respv ON respv.RESP_ID = resp.ROW_ID
			JOIN siebel.S_APP_VIEW v ON v.ROW_ID = respv.VIEW_ID
		WHERE
			resp.NAME IN ('Responsibility Name')
		GROUP BY v.NAME
	) v
	JOIN siebel.S_SCREEN_VIEW scrv ON scrv.NAME = v.NAME AND scrv.INACTIVE_FLG = 'N'
	LEFT JOIN S_SCR_VIEW_INTL scrvloc ON scrvloc.SCREEN_VIEW_ID = scrv.ROW_ID AND scrvloc.LANG_CD = 'RUS'
	LEFT JOIN S_SYM_STR_INTL scrvlocref ON scrvlocref.SYM_STR_KEY = scrv.MENU_TEXT_REF AND scrvlocref.REPOSITORY_ID = scrv.REPOSITORY_ID AND scrvlocref.LANG_CD = 'RUS'

	JOIN siebel.S_REPOSITORY rep ON rep.ROW_ID = scrv.REPOSITORY_ID
	JOIN siebel.S_SCREEN scr ON scr.ROW_ID = scrv.SCREEN_ID AND scr.INACTIVE_FLG = 'N'
	JOIN siebel.S_SCR_MENU_ITEM scritem ON scritem.SCREEN_NAME = scr.NAME AND scritem.REPOSITORY_ID = scrv.REPOSITORY_ID AND scritem.INACTIVE_FLG = 'N'
	JOIN siebel.S_APPLICATION appl ON appl.ROW_ID = scritem.APPLICATION_ID
	LEFT JOIN S_SCR_MITM_INTL scritemloc ON scritemloc.SCREEN_MENU_IT_ID = scritem.ROW_ID AND scritemloc.LANG_CD = 'RUS'
	LEFT JOIN S_SYM_STR_INTL scritemlocref ON scritemlocref.SYM_STR_KEY = TEXT_REF AND scritemlocref.REPOSITORY_ID = scrv.REPOSITORY_ID AND scritemlocref.LANG_CD = 'RUS'
WHERE
	rep.NAME = 'Siebel Repository'
	AND
	appl.NAME = 'Siebel Financial Services'
	AND
	scr.NAME = 'Accounts Screen'
	--GROUP BY scr.NAME, scritemloc.MENU_TEXT, scritemlocref.STRING_VALUE
ORDER BY scr.NAME, scrv.SCRN_VW_TYPE_CD, scrv.PAR_CATEGORY, v.NAME
