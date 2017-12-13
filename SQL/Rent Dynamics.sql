SELECT
id, title, parentIds, `dates.duration`, julianday(`dates.start`)-julianday('now') as StartDateDifference, 
julianday(`dates.due`)-julianday('now') as DueDateDifference

FROM
report

