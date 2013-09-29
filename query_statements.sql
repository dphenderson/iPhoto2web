/*
 * This file serves as a proving ground for testing relationships between the
 * tables contained in iPhotoMain.db contained within the iPhoto(R) Library
 * package of iPhoto '09 version 8.1.4 (424).
 *
 * iPhoto is a registered trademark of Apple Inc.
 */

-- keyword relationship
SELECT pi.archiveFilename AS fotoName,
kw.title AS keyword
FROM KeywordsPhotosJoin AS kpj
JOIN SqPhotoInfo AS pi ON pi.primaryKey=kpj.sqPhotoInfo
JOIN SqKeyword AS kw ON kw.primaryKey=kpj.sqKeyword;

-- event relationship
SELECT e.primaryKey AS event,
e.name AS eventName,
DATE(e.rollDate + JULIANDAY('2000-01-01 00:00:00')) AS eventDate,
pi.primaryKey AS fotoInfo,
pi.archiveFilename AS fotoName,
DATETIME(pi.photoDate + JULIANDAY('2000-01-01 00:00:00')) AS fotoDate,
fim.primaryKey AS fileImage,
fi.primaryKey AS fileInfo,
fim.imageType AS imageType,
fi.format AS format,
fi.relativePath AS relPath
FROM SqEvent AS e
JOIN SqPhotoInfo AS pi ON pi.event = e.primaryKey
JOIN SqFileImage AS fim ON fim.photoKey = pi.primaryKey
JOIN SqFileInfo AS fi ON fim.sqFileInfo = fi.primaryKey
WHERE fim.imageType = 6
ORDER BY eventDate ASC, fotoname ASC, imageType ASC

-- dbext:profile=tati
