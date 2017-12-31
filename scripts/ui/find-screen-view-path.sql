select distinct ssv_out.view_name,
                coalesce(ssi.viewbar_text, sssi1.string_value, ss.name) ||
                ssv_out.view_path screen_view_path
  from siebel.s_repository sr
 inner join siebel.s_buscomp sb
    on sr.row_id = sb.repository_id
 inner join siebel.s_applet sa
    on sa.buscomp_name = sb.name
   and sr.row_id = sa.repository_id
  left outer join siebel.s_applet_toggle sat
    on sa.row_id = sat.applet_id
   and sr.row_id = sat.repository_id
  left outer join siebel.s_appl_web_tmpl sawt
    on sawt.applet_id = sa.row_id
   and sawt.repository_id = sr.row_id
  left outer join siebel.s_appl_wtmpl_it sawi
    on sawi.appl_web_tmpl_id = sawt.row_id
   and sawi.repository_id = sr.row_id
  left outer join siebel.s_control sco
    on sawi.ctrl_name = sco.name
   and sco.applet_id = sa.row_id
   and sr.row_id = sco.repository_id
  left outer join siebel.s_list slst
    on slst.applet_id = sa.row_id
   and slst.repository_id = sr.row_id
  left outer join siebel.s_list_column slc
    on slc.list_id = slst.row_id
   and sr.row_id = slc.repository_id
 inner join siebel.S_VIEW_WTMPL_IT svwi
    on svwi.applet_name = sa.name
   and svwi.repository_id = sr.row_id
 inner join siebel.s_View_Web_Tmpl svwt
    on svwi.view_web_tmpl_id = svwt.row_id
   and svwt.repository_id = sr.row_id
 inner join siebel.s_view sv
    on sv.row_id = svwt.view_id
   and sv.repository_id = sr.row_id
 inner join (select ssv.screen_id,
                    ssv.view_name,
                    sys_connect_by_path(coalesce(ssvi.viewbar_text,
                                                 sssi2.string_value,
                                                 ssv.name),
                                        ' -> ') view_path
               from siebel.s_repository sr
              inner join siebel.S_SCREEN_VIEW ssv
                 on sr.row_id = ssv.repository_id
               left outer join siebel.S_SCR_VIEW_INTL ssvi
                 on ssvi.screen_view_id = ssv.row_id
                and ssvi.repository_id = sr.row_id
                and ssvi.inactive_flg <> 'Y'
                and ssvi.lang_cd = 'RUS'
               left outer join siebel.s_Sym_Str_intl sssi2
                 on sssi2.sym_str_key = ssv.viewbar_text_ref
                and sssi2.repository_id = sr.row_id
                and sssi2.inactive_flg <> 'Y'
                and sssi2.lang_cd = 'RUS'
              where ssv.inactive_flg <> 'Y'
                and sr.name = 'Siebel Repository'
              start with ssv.par_category is null
             connect by nocycle prior ssv.name = ssv.par_category
                    and prior ssv.screen_id = ssv.screen_id
                    and prior sr.name = sr.name
                    and prior coalesce(ssvi.viewbar_text,
                                       sssi2.string_value,
                                       ssv.name) <>
                         coalesce(ssvi.viewbar_text,
                                       sssi2.string_value,
                                       ssv.name)
                    and ssv.inactive_flg <> 'Y'
                    and prior ssv.inactive_flg <> 'Y') ssv_out
    on ssv_out.view_name = sv.name
 inner join siebel.s_screen ss
    on ssv_out.screen_id = ss.row_id
   and ss.repository_id = sr.row_id
  left outer join siebel.S_SCREEN_INTL ssi
    on ssi.screen_id = ss.row_id
   and ssi.repository_id = sr.row_id
   and ssi.lang_cd = 'RUS'
  left outer join siebel.s_Sym_Str_intl sssi1
    on sssi1.sym_str_key = ss.viewbar_text_ref
   and sssi1.repository_id = sr.row_id
   and sssi1.lang_cd = 'RUS'
 where sr.name = 'Siebel Repository'
   and sb.inactive_flg = 'N'
   and sa.inactive_flg = 'N'
   and svwi.inactive_flg = 'N'
   and svwt.inactive_flg = 'N'
   and sv.inactive_flg = 'N'
   and ss.inactive_flg = 'N'
   and sawt.inactive_flg = 'N'
   and sawi.inactive_flg = 'N'
   and (sa.name in ('%Applet Name Here%') or --standalone applet
       sat.applet_name in ('%Applet Name Here%')) --toggle applet
   --and sb.name in ('%Buscomp Name Here%') --buscomp filter
   --and (slc.field_name = '%Field Name Here%' or --list applet column field
        --sco.field_name = '%Field Name Here%') --form applet control field
 order by 2;
