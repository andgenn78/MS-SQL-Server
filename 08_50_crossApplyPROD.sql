INSERT INTO #TMPFIXEDDRIVES
SELECT distinct(volume_mount_point),
  total_bytes/1048576/1024 as Size_in_GB,
  available_bytes/1048576/1024 as Free_in_GB
FROM sys.master_files AS f 
	CROSS APPLY
  sys.dm_os_volume_stats(f.database_id, f.file_id)
group by volume_mount_point, total_bytes/1048576,
  available_bytes/1048576 order by 1


  -- delete history
	SELECT HR.FileVersionId, HR.DataSourceId, HR.DateRemovedUtc AS LastWriteTimeUtc, hr.FileRemoveId, 
		   DFV.DateAdded
	FROM dbo.vwFileHistoryRemove HR WITH (NOLOCK)
	INNER JOIN #FileVersions DFV ON (DFV.FileVersionId = HR.FileVersionId)
	WHERE HR.FileId = @FileId
		AND HR.[FolderId] = @FolderId
	UNION ALL
	SELECT T.FileVersionId
		,DDHR.DataSourceId
		,DDHR.DateRemovedUtc AS LastWriteTimeUtc
		,DDHR.DirDeleteId
		,T.DateAdded
	FROM dbo.vwPathHistoryRemove DDHR
	CROSS APPLY (SELECT TOP 1 FileVersionId, DateAdded
			FROM #FileVersions V
			WHERE RowNum = 1
				AND DirVersionId <= DDHR.DirVersionId
			ORDER BY V.DirVersionId DESC) T 
	WHERE DDHR.[FolderId] = @FolderId
	AND DDHR.DirId = @dirId
	-- file exists when folder was removed
	AND EXISTS (SELECT 1 FROM #FileVersions V WHERE V.DirVersionId <= DDHR.DirVersionId)
	-- file was not removed separetally before folder was removed
	AND NOT EXISTS (
			SELECT 1
			FROM dbo.vwFileHistoryRemove DFHR
			WHERE DFHR.FileId = @FileId
				AND DFHR.[FolderId] = @FolderId
				AND DFHR.DirVersionId = DDHR.DirVersionId
				AND NOT EXISTS (
					SELECT 1
					FROM dbo.vwFileHistoryRestore DFHRes
					WHERE DFHRes.[FolderId] = @FolderId
						AND DFHRes.FileId = @FileId
						AND DFHRes.PreviousFileVersionId = DFHR.FileVersionId
					)
			)
	ORDER BY HR.DateRemovedUtc;
