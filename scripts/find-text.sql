declare
  p_text_to_search varchar2(255) := '%' || '&p_text_to_search' || '%';
  l_txt            varchar2(255) := '&p_text_to_search';
  p_object_name    varchar2(255) := nvl('&p_object_name', '%');
  p_print_context  boolean := case nvl('&p_print_context', 'N')
                                when 'N' then
                                 false
                                when 'Y' then
                                 true
                                else
                                 false
                              end;

  p_repository siebel.s_repository.name%type := 'Siebel Repository';

  l_output_header varchar2(600);
  l_lng           varchar2(32000);

  function getlong(p_tname in varchar2,
                   p_cname in varchar2,
                   p_rowid in rowid) return varchar2 as
    l_cursor   integer default dbms_sql.open_cursor;
    l_long_val varchar2(32000);
    l_long_len number;
  begin
    dbms_sql.parse(l_cursor,
                   'select ' || p_cname || ' from siebel.' || p_tname ||
                   ' where rowid = :x',
                   dbms_sql.native);
    dbms_sql.bind_variable(l_cursor, ':x', p_rowid);
    dbms_sql.define_column_long(l_cursor, 1);
    l_long_len := dbms_sql.execute(l_cursor);
    if (dbms_sql.fetch_rows(l_cursor) > 0) then
      dbms_sql.column_value_long(c            => l_cursor,
                                 position     => 1,
                                 length       => 32000,
                                 offset       => 0,
                                 value        => l_long_val,
                                 value_length => l_long_len);
    end if;
    dbms_sql.close_cursor(l_cursor);
    return l_long_val;
  end getlong;

  procedure printlines(p_long in varchar2) as
    l_occurrence number;
    l_str        varchar2(32000);
  begin
    l_occurrence := 1;
    while instr(p_long, l_txt, 1, l_occurrence) <> 0 loop
      l_str := replace(regexp_substr(p_long,
                                     '^.*' || l_txt || '.*$',
                                     1,
                                     l_occurrence,
                                     'm'),
                       chr(9),
                       '    ');
      if l_str is not null then
        dbms_output.put_line('  | ' || l_str);
        dbms_output.put_line('   ' || rpad(' ', instr(l_str, l_txt), ' ') ||
                             rpad('^', length(l_txt), '^'));
      end if;
      l_occurrence := l_occurrence + 1;
    end loop;
  end printlines;

begin
  l_output_header := 'Search "' || p_text_to_search || '" in "' ||
                     p_object_name || '"';
  dbms_output.put_line(l_output_header);
  dbms_output.put_line('Context Output: ' || case p_print_context when true then 'ON' when
                       false then 'OFF' else 'UNDEFINED' end);
  dbms_output.put_line(rpad('=', length(l_output_header), '='));

  --Application Script
  for c in (select ap.name appl, aps.name method, aps.script, aps.rowid
              from siebel.s_application ap
             inner join siebel.s_appl_script aps
                on ap.row_id = aps.application_id
             inner join siebel.s_repository rep
                on ap.repository_id = rep.row_id
               and aps.repository_id = rep.row_id
             where rep.name = p_repository
               and ap.name like p_object_name
             order by 1, 2) loop
    l_lng := getlong(p_tname => 's_appl_script',
                     p_cname => 'script',
                     p_rowid => c.rowid);
    if l_lng like p_text_to_search then
      dbms_output.put_line('Application: ' || c.appl || ', Method: ' ||
                           c.method);
      if p_print_context then
        printlines(p_long => l_lng);
      end if;
    end if;
  end loop;
  --Applet Script
  for c in (select ap.name applet, aps.name method, aps.script, aps.rowid
              from siebel.s_applet ap
             inner join siebel.s_appl_webscrpt aps
                on ap.row_id = aps.applet_id
             inner join siebel.s_repository rep
                on ap.repository_id = rep.row_id
               and aps.repository_id = rep.row_id
             where rep.name = p_repository
               and ap.name like p_object_name
             order by 1, 2) loop
    l_lng := getlong(p_tname => 's_appl_webscrpt',
                     p_cname => 'script',
                     p_rowid => c.rowid);
    if l_lng like p_text_to_search then
      dbms_output.put_line('Applet: ' || c.applet || ', Method: ' ||
                           c.method);
      if p_print_context then
        printlines(p_long => l_lng);
      end if;
    end if;
  end loop;
  --Applet User Property
  for c in (select ap.name applet, up.name user_prop, up.value
              from siebel.s_applet ap
             inner join siebel.s_applet_uprop up
                on ap.row_id = up.applet_id
             inner join siebel.s_repository rep
                on ap.repository_id = rep.row_id
               and up.repository_id = rep.row_id
             where rep.name = p_repository
               and ap.name like p_object_name
               and up.value like p_text_to_search
             order by 1, 2) loop
    dbms_output.put_line('Applet: ' || c.applet || ', User Property: ' ||
                         c.user_prop);
    if p_print_context then
      printlines(p_long => c.value);
    end if;
  end loop;
  --BC Script
  for c in (select bc.name buscomp, bcs.name method, bcs.script, bcs.rowid
              from siebel.s_buscomp bc
             inner join siebel.s_buscomp_script bcs
                on bc.row_id = bcs.buscomp_id
             inner join siebel.s_repository rep
                on bc.repository_id = rep.row_id
               and bcs.repository_id = rep.row_id
             where rep.name = p_repository
               and bc.name like p_object_name
             order by 1, 2) loop
    l_lng := getlong(p_tname => 's_buscomp_script',
                     p_cname => 'script',
                     p_rowid => c.rowid);
    if l_lng like p_text_to_search then
      dbms_output.put_line('BC: ' || c.buscomp || ', Method: ' || c.method);
      if p_print_context then
        printlines(p_long => l_lng);
      end if;
    end if;
  end loop;
  --BC Calculated Field
  for c in (select bc.name buscomp, fld.name field, fld.calcval
              from siebel.s_buscomp bc
             inner join siebel.s_field fld
                on bc.row_id = fld.buscomp_id
             inner join siebel.s_repository rep
                on bc.repository_id = rep.row_id
               and fld.repository_id = rep.row_id
             where rep.name = p_repository
               and bc.name like p_object_name
               and fld.calcval like p_text_to_search
             order by 1, 2) loop
    dbms_output.put_line('BC: ' || c.buscomp || ', Calculated Field: ' ||
                         c.field);
    if p_print_context then
      printlines(p_long => c.calcval);
    end if;
  end loop;
  --BC User Property
  for c in (select bc.name buscomp, up.name user_prop, up.value
              from siebel.s_buscomp bc
             inner join siebel.s_buscomp_uprop up
                on bc.row_id = up.buscomp_id
             inner join siebel.s_repository rep
                on bc.repository_id = rep.row_id
               and up.repository_id = rep.row_id
             where rep.name = p_repository
               and bc.name like p_object_name
               and up.value like p_text_to_search
             order by 1, 2) loop
    dbms_output.put_line('BC: ' || c.buscomp || ', User Property: ' ||
                         c.user_prop);
    if p_print_context then
      printlines(p_long => c.value);
    end if;
  end loop;
  --BS Script
  for c in (select sv.name service, sc.name method, sc.script, sc.rowid
              from siebel.s_service_scrpt sc
             inner join siebel.s_service sv
                on sc.service_id = sv.row_id
             inner join siebel.s_repository rep
                on sv.repository_id = rep.row_id
               and sc.repository_id = rep.row_id
             where rep.name = p_repository
               and sv.name like p_object_name
             order by 1, 2) loop
    l_lng := getlong(p_tname => 's_service_scrpt',
                     p_cname => 'script',
                     p_rowid => c.rowid);
    if l_lng like p_text_to_search then
      dbms_output.put_line('BS: ' || c.service || ', Method: ' || c.method);
      if p_print_context then
        printlines(p_long => l_lng);
      end if;
    end if;
  end loop;
  --RT BS Script
  for c in (select sv.name service, sc.name method, sc.script, sc.rowid
              from siebel.s_rt_svc_scrpt sc
             inner join siebel.s_rt_svc sv
                on sc.rt_svc_id = sv.row_id
             where sv.name like p_object_name
             order by 1, 2) loop
    l_lng := getlong(p_tname => 's_rt_svc_scrpt',
                     p_cname => 'script',
                     p_rowid => c.rowid);
    if l_lng like p_text_to_search then
      dbms_output.put_line('RT BS: ' || c.service || ', Method: ' ||
                           c.method);
      if p_print_context then
        printlines(p_long => l_lng);
      end if;
    end if;
  end loop;
  --Smartscript Script
  for c in (select ss.name sscript, sc.name method, sc.script, sc.rowid
              from siebel.s_cs_path_scpt sc
             inner join siebel.s_cs_path ss
                on sc.path_id = ss.row_id
             where ss.name like p_object_name
             order by 1, 2) loop
    l_lng := getlong(p_tname => 's_cs_path_scpt',
                     p_cname => 'script',
                     p_rowid => c.rowid);
    if l_lng like p_text_to_search then
      dbms_output.put_line('SmartScript: ' || c.sscript || ', Method: ' ||
                           c.method);
      if p_print_context then
        printlines(p_long => l_lng);
      end if;
    end if;
  end loop;
  --Smartscript Question
  for c in (select ss_1.name  sscript,
                   qu_1.name  question,
                   scr.name   method,
                   scr.script,
                   scr.rowid
              from (select distinct ss.row_id ss_id, pg.row_id page_id
                      from siebel.s_cs_page pg
                      left outer join siebel.s_cs_edge p_ed
                        on pg.row_id = p_ed.next_page_id
                      left outer join siebel.s_cs_path ss
                        on ss.row_id = p_ed.path_id
                        or ss.start_page_id = pg.row_id) v1
             inner join (select distinct q_pg.row_id page_id,
                                        qu.row_id   quest_id
                          from siebel.s_cs_quest qu
                          left outer join siebel.s_cs_edge q_ed
                            on qu.row_id = q_ed.next_quest_id
                          left outer join siebel.s_cs_page q_pg
                            on q_pg.start_quest_id = qu.row_id
                           and q_ed.next_quest_id is null
                            or q_ed.page_id = q_pg.row_id) v2
                on v1.page_id = v2.page_id
             inner join siebel.s_cs_path ss_1
                on ss_1.row_id = v1.ss_id
             inner join siebel.s_cs_quest qu_1
                on qu_1.row_id = v2.quest_id
             inner join siebel.s_cs_quest_scpt scr
                on qu_1.row_id = scr.quest_id
             where ss_1.name like p_object_name
                or qu_1.name like p_object_name
             order by 1, 2, 3) loop
    l_lng := getlong(p_tname => 's_cs_quest_scpt',
                     p_cname => 'script',
                     p_rowid => c.rowid);
    if l_lng like p_text_to_search then
      dbms_output.put_line('SmartScript: ' || c.sscript || ', Question: ' ||
                           c.question || ', Method: ' || c.method);
      if p_print_context then
        printlines(p_long => l_lng);
      end if;
    end if;
  end loop;
  --RTE Action
  for c in (select scas.name action_set, sca.name action
              from siebel.s_ct_action sca
             inner join siebel.s_ct_action_set scas
                on sca.ct_actn_set_id = scas.row_id
             where (sca.set_attr like p_text_to_search or
                   sca.svc_name like p_text_to_search or
                   sca.svc_method_name like p_text_to_search or
                   sca.svc_context like p_text_to_search or
                   sca.method_name like p_text_to_search or
                   sca.method_context like p_text_to_search)
               and (scas.name like p_object_name or
                   sca.name like p_object_name)
             order by 1, 2) loop
    dbms_output.put_line('RTE Action Set: ' || c.action_set ||
                         ', Action: ' || c.action);
  end loop;
  --RTE Event
  for c in (select sce.obj_name,
                   sce.evt_name,
                   nvl2(sce.evt_sub_name,
                        ', Sub-Event: ' || sce.evt_sub_name,
                        '') evt_sub_name,
                   sce.evt_seq_num,
                   sce.actn_cond_expr
              from siebel.s_ct_event sce
             where sce.actn_cond_expr like p_text_to_search
               and sce.obj_name like p_object_name
             order by 1, 2, 3) loop
    dbms_output.put_line('RTE Event - Object: ' || c.obj_name || ' (' ||
                         c.evt_seq_num || '), Event: ' || c.evt_name ||
                         c.evt_sub_name);
    if p_print_context then
      printlines(p_long => c.actn_cond_expr);
    end if;
  end loop;
  --DVM Message and Expressions
  for c in (select svrs.name ruleset_name, svr.name rule_name
              from siebel.s_valdn_rl_set svrs
              left outer join siebel.s_valdn_rule svr
                on svr.rule_set_id = svrs.row_id
              left outer join siebel.s_iss_valdn_msg sivn
                on sivn.row_id = svr.valdn_msg_id
              left outer join siebel.s_iss_vmsg_lang sivl
                on sivl.par_row_id = sivn.row_id
             where svrs.status_cd = 'Active'
               and (svrs.cond_expr like p_text_to_search or
                   svr.rule_expr like p_text_to_search or
                   svr.err_msg_txt like p_text_to_search or
                   sivn.msg_text like p_text_to_search or
                   sivl.msg_text like p_text_to_search)
               and (svrs.name like p_object_name or
                   svr.name like p_object_name)
             order by 1, 2) loop
    dbms_output.put_line('DVM Ruleset: ' || c.ruleset_name || ', Rule: ' ||
                         c.rule_name);
  end loop;
  --WF Process Step and Step Branch Criteria
  for c in (select swp.proc_name wf_name,
                   sws.name      step_name,
                   swsb.name     branch_name
              from siebel.s_wfr_proc swp
             inner join siebel.S_WFR_STP sws
                on sws.process_id = swp.row_id
             inner join siebel.s_repository rep
                on swp.repository_id = rep.row_id
               and sws.repository_id = rep.row_id
              left outer join siebel.s_wfr_stp_arg swsa
                on swsa.step_id = sws.row_id
               and swsa.repository_id = rep.row_id
              left outer join siebel.s_wfr_stp_brnch swsb
                on swsb.step_id = sws.row_id
               and swsb.repository_id = rep.row_id
             where rep.name = p_repository
               and swp.status_cd = 'COMPLETED'
               and (sws.name like p_text_to_search or
                   sws.action_buscomp like p_text_to_search or
                   sws.method_name like p_text_to_search or
                   sws.service_name like p_text_to_search or
                   sws.subprocess_name like p_text_to_search or
                   sws.comments like p_text_to_search or
                   swsa.name like p_text_to_search or
                   swsa.buscomp_name like p_text_to_search or
                   swsa.buscomp_fld_name like p_text_to_search or
                   swsa.comments like p_text_to_search or
                   swsa.buscomp_fld_name like p_text_to_search or
                   swsa.proc_prop_name like p_text_to_search or
                   swsa.val like p_text_to_search or
                   swsb.expr like p_text_to_search)
               and (swp.proc_name like p_object_name or
                   sws.name like p_object_name)) loop
    dbms_output.put_line('WF Process: ' || c.wf_name ||
                         (case when c.step_name is null then '' else
                          ', Step: ' || c.step_name end) ||
                         (case when c.branch_name is null then '' else
                          ', Branch: ' || c.branch_name end));
  end loop;
  --EAI Data Map
  for c in (select mp.name mp_name, null cmp_name, null fld_name
              from siebel.S_INT_OBJMAP mp
             where mp.comments like p_text_to_search
               and mp.name like p_object_name
            union all
            select mp.name, cmp.name, null
              from siebel.S_INT_OBJMAP mp
             inner join siebel.S_INT_COMPMAP cmp
                on mp.row_id = cmp.int_obj_map_id
             where (cmp.comments like p_text_to_search or
                   cmp.dst_post_cond like p_text_to_search or
                   cmp.src_pre_cond like p_text_to_search or
                   cmp.src_srchspec like p_text_to_search)
               and mp.name like p_object_name
            union all
            select mp.name, cmp.name, fld.dst_int_fld_name
              from siebel.S_INT_OBJMAP mp
             inner join siebel.S_INT_COMPMAP cmp
                on mp.row_id = cmp.int_obj_map_id
             inner join siebel.S_INT_FLDMAP fld
                on cmp.row_id = fld.int_comp_map_id
             where (fld.comments like p_text_to_search or
                   fld.src_expr like p_text_to_search)
               and mp.name like p_object_name) loop
    dbms_output.put_line('EAI Data Map: ' || c.mp_name ||
                         (case when c.cmp_name is null then '' else
                          ', Data Map Component: ' || c.cmp_name end) ||
                         (case when c.fld_name is null then '' else
                          ', Data Map Field: ' || c.fld_name end));
  end loop;
end;
