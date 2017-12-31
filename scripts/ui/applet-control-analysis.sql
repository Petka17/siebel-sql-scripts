SELECT DISTINCT
  item.ctrl_name--,  item.NAME, item.EXPR, item.ITEM_NUM, item2.EXPR
FROM
  S_APPL_WTMPL_IT item
  JOIN S_APPL_WEB_TMPL templ ON templ.ROW_ID = item.APPL_WEB_TMPL_ID
  JOIN S_APPLET applet ON applet.ROW_ID = templ.APPLET_ID
  LEFT JOIN S_APPL_WTMPL_IT item2 ON item2.APPL_WEB_TMPL_ID = item.APPL_WEB_TMPL_ID AND item2.ITEM_NUM = item.ITEM_NUM AND item2.ROW_ID <> item.ROW_ID
WHERE
  applet.NAME = 'User Profile Behavior Applet'
  AND templ.NAME = 'Edit'
--  AND item.EXPR NOT IN ('Siebel Financial Services', 'NOT Siebel Financial Services')
--  AND item.EXPR IS NULL AND item2.EXPR IN ('Siebel Financial Services', 'NOT Siebel Financial Services')
--  AND item.EXPR = 'NOT Siebel Financial Services'
--  AND item2.ITEM_NUM IS NOT NULL
