DELETE FROM S_CONTROL WHERE ROW_ID IN (
SELECT
  --ctrl.NAME,
  ctrl.ROW_ID
FROM
  S_CONTROL ctrl
  JOIN S_APPLET applet ON applet.ROW_ID = ctrl.APPLET_ID
  JOIN S_REPOSITORY repo ON repo.ROW_ID = applet.REPOSITORY_ID 
  JOIN S_APPL_WEB_TMPL templ ON templ.APPLET_ID = ctrl.APPLET_ID
  LEFT JOIN S_APPL_WTMPL_IT item ON item.APPL_WEB_TMPL_ID = templ.ROW_ID AND item.CTRL_NAME = ctrl.NAME
WHERE
  applet.NAME = 'SIS Account List Applet'
  AND templ.NAME = 'Edit List'
  AND item.ROW_ID IS NULL
  AND ctrl.NAME <> 'List'
  AND repo.NAME = 'Siebel Repository'
 )
  
  
