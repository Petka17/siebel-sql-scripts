DELETE FROM S_LIST_COLUMN WHERE ROW_ID IN (
SELECT
--  col.NAME,
  col.ROW_ID
FROM
  S_LIST_COLUMN col
  JOIN S_LIST lst ON lst.ROW_ID = col.LIST_ID
  JOIN S_APPLET applet ON applet.ROW_ID = lst.APPLET_ID
  JOIN S_APPL_WEB_TMPL templ ON templ.APPLET_ID = lst.APPLET_ID
  LEFT JOIN S_APPL_WTMPL_IT item ON item.APPL_WEB_TMPL_ID = templ.ROW_ID AND item.CTRL_NAME = col.NAME
WHERE
  applet.NAME = 'SIS Account List Applet'
  AND templ.NAME = 'Edit List'
  AND item.ROW_ID IS NULL
 )
  
  
