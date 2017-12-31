SELECT *
  FROM (SELECT owner,
               object_name,
               object_type,
               table_name,
               ROUND(bytes) / 1024 / 1024 AS ALLOCATED_MB,
               ROUND(space_used) / 1024 / 1024 AS USED_MB,
               tablespace_name,
               extents,
               initial_extent,
               ROUND(Sum(bytes / 1024 / 1024)
                     OVER(PARTITION BY owner, table_name)) AS TOTAL_ALLOCATED_MB,
               ROUND(Sum(space_used / 1024 / 1024)
                     OVER(PARTITION BY owner, table_name)) AS TOTAL_USED_MB
          FROM (
                -- Tables
                SELECT owner,
                        segment_name AS object_name,
                        'TABLE' AS object_type,
                        segment_name AS table_name,
                        bytes,
                        tablespace_name,
                        extents,
                        initial_extent,
                        space_used
                  FROM dba_segments,
                        table(dbms_space.object_space_usage_tbf(owner,
                                                                segment_name,
                                                                segment_type,
                                                                null,
                                                                partition_name))
                 WHERE segment_type IN
                       ('TABLE', 'TABLE PARTITION', 'TABLE SUBPARTITION')
                   and owner not in ('SYS', 'SYSTEM', 'SYSMAN')
                   and bytes > 10 * 1024 * 1024
                UNION ALL
                -- Indexes
                SELECT i.owner,
                        i.index_name AS object_name,
                        'INDEX' AS object_type,
                        i.table_name,
                        s.bytes,
                        s.tablespace_name,
                        s.extents,
                        s.initial_extent,
                        u.space_used
                  FROM dba_indexes i,
                        dba_segments s,
                        table(dbms_space.object_space_usage_tbf(s.owner,
                                                                s.segment_name,
                                                                s.segment_type,
                                                                null,
                                                                s.partition_name)) u
                 WHERE s.segment_name = i.index_name
                   AND s.owner = i.owner
                   AND s.segment_type IN
                       ('INDEX', 'INDEX PARTITION', 'INDEX SUBPARTITION')
                   and s.owner not in ('SYS', 'SYSTEM', 'SYSMAN')
                   and s.bytes > 10 * 1024 * 1024
                -- LOB Segments
                UNION ALL
                SELECT l.owner,
                        l.column_name AS object_name,
                        'LOB_COLUMN' AS object_type,
                        l.table_name,
                        s.bytes,
                        s.tablespace_name,
                        s.extents,
                        s.initial_extent,
                        u.space_used
                  FROM dba_lobs l,
                        dba_segments s,
                        table(dbms_space.object_space_usage_tbf(s.owner,
                                                                s.segment_name,
                                                                'LOB',
                                                                null)) u
                 WHERE s.segment_name = l.segment_name
                   AND s.owner = l.owner
                   AND s.segment_type = 'LOBSEGMENT'
                   and s.owner not in ('SYS', 'SYSTEM', 'SYSMAN')
                   and s.bytes > 10 * 1024 * 1024
                -- LOB Indexes
                UNION ALL
                SELECT l.owner,
                        l.column_name AS object_name,
                        'LOB_INDEX' AS object_type,
                        l.table_name,
                        s.bytes,
                        s.tablespace_name,
                        s.extents,
                        s.initial_extent,
                        u.space_used
                  FROM dba_lobs l,
                        dba_segments s,
                        table(dbms_space.object_space_usage_tbf(s.owner,
                                                                s.segment_name,
                                                                'INDEX',
                                                                null)) u
                 WHERE s.segment_name = l.index_name
                   AND s.owner = l.owner
                   AND s.segment_type = 'LOBINDEX'
                   and s.owner not in ('SYS', 'SYSTEM', 'SYSMAN')
                   and s.bytes > 10 * 1024 * 1024))
 WHERE TOTAL_ALLOCATED_MB > 10
 ORDER BY TOTAL_USED_MB DESC, owner ASC, table_name ASC, USED_MB DESC;
