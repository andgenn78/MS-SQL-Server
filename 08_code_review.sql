SELECT T.FolderId,
		   T.FileVersionId,
		   T.FileId		
	FROM dbo.vwFolderHistoryRemove FHR
	CROSS APPLY (SELECT TOP 1 FileVersionId, FileId, FolderId, DirId
			FROM #FileVersions V
			WHERE RowNum = 1
				AND DirVersionId <= FHR.DirVersionId
			ORDER BY V.DirVersionId DESC) T 
	WHERE FHR.[FolderId] = T.FolderId
	AND FHR.DirId = T.DirId
	AND EXISTS (SELECT 1 FROM #FileVersions V WHERE V.DirVersionId <= FHR.DirVersionId)
	AND NOT EXISTS (
			SELECT 1
			FROM dbo.vwFileHistoryRemove DFHR
			WHERE DFHR.FileId = T.FileId
				AND DFHR.[FolderId] = T.FolderId
				AND DFHR.DirVersionId = FHR.DirVersionId
				AND NOT EXISTS (
					SELECT 1
					FROM dbo.vwFileHistoryRestore DFHRes
					WHERE DFHRes.[FolderId] = T.FolderId
						AND DFHRes.FileId = T.FileId
						AND DFHRes.PreviousFileVersionId = DFHR.FileVersionId
					)
			)