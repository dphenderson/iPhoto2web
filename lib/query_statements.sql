/*
 * This file serves as a proving ground for testing relationships between the
 * tables contained in iPhotoMain.db contained within the iPhoto(R) Library
 * package of iPhoto '09 version 8.1.4 (424).
 *
 * iPhoto is a registered trademark of Apple Inc.
 */

/* SqFileImage.imageType is one of the following
 *
 * type=8: the original image if it is a raw data image
 * type=7: key photo
 * type=6: the image itself when you double click on the thumbnail
 * type=5: thumbnail
 * type=1: the original if it is modified
 *
 * 8, 6, 5, and 1 have physical representations on disk.
 */

/*
 * Dates in iPhotoMain.db are expressed as the numer of fractional days elapsed
 * since 2000-01-01 00:00:00 local time for example a photo taken on 7 Sept
 * 2013 at 11:27:58 a.m. will be stored as 4998.47775462963 that is 4998 days
 * and about 48% of a day. 
 *
 * The easiest means of expressing the date in terms more familiar to humans is
 * to use the julianday function in sqlite3 passing 2000-01-01 00:00:00 as the
 * argument and then add the iPhoto date representation to that value and pass
 * that sum as the argument to the sqlite3 datetime function.
 *
 * The above information came from
 * <http://gskluzacek.tumblr.com/post/9111450792/more-on-iphotomain-db-iphotoaux-db-date-formats>
 */

-- photo relationship
-- information about individual photos comes from 3 tables:
-- SqPhotoInfo, SqFileImage, and SqFileInfo
SELECT pi.primaryKey AS photoID,
pi.archiveFilename AS photoName,
DATETIME(pi.photoDate + JULIANDAY('2000-01-01 00:00:00')) AS photoDate,
fim.imageType AS photoType,
fi.relativePath AS photoPath
FROM SqPhotoInfo AS pi
JOIN SqFileImage AS fim ON fim.photoKey = pi.primaryKey
JOIN SqFileInfo AS fi ON fi.primaryKey = fim.sqFileInfo
ORDER BY fim.imageType;

-- album relationship
SELECT al.name AS albumName,
al.className AS albumType,
al.repAlbumKeyForLoading AS albumUID,
pi.primaryKey AS photoID,
pi.archiveFilename AS photoName,
DATETIME(pi.photoDate + JULIANDAY('2000-01-01 00:00:00')) AS photoDate,
fim.imageType AS photoType,
fi.relativePath AS photoPath
FROM AlbumsPhotosJoin AS apj
JOIN SqAlbum AS al ON al.primaryKey = apj.sqAlbum
JOIN SqPhotoInfo AS pi on pi.primaryKey = apj.sqPhotoInfo
JOIN SqFileImage AS fim ON fim.photoKey = pi.primaryKey
JOIN SqFileInfo AS fi ON fi.primaryKey = fim.sqFileInfo
WHERE albumType = 'Album'												-- user generated albums
AND albumUID < 999000													-- Apple generated albums are >= 999000
ORDER BY albumName, apj.photosOrder;

-- keyword relationship
SELECT pi.primaryKey AS photoID,
pi.archiveFilename AS photoName,
DATETIME(pi.photoDate + JULIANDAY('2000-01-01 00:00:00')) AS photoDate,
fim.imageType AS photoType,
fi.relativePath AS photoPath,
kw.title AS keyword
FROM KeywordsPhotosJoin AS kpj
JOIN SqPhotoInfo AS pi ON pi.primaryKey = kpj.sqPhotoInfo
JOIN SqKeyword AS kw ON kw.primaryKey = kpj.sqKeyword
JOIN SqFileImage AS fim ON fim.photoKey = pi.primaryKey
JOIN SqFileInfo AS fi ON fi.primaryKey = fim.sqFileInfo;

-- event relationship
SELECT e.primaryKey AS event,
e.name AS eventName,													-- Title field in iPhoto
DATE(e.rollDate + JULIANDAY('2000-01-01 00:00:00')) AS eventDate,
e.comment AS eventDesc,													-- Description field in iPhoto
pi.primaryKey AS fotoInfo,
pi.archiveFilename AS fotoName,
DATETIME(pi.photoDate + JULIANDAY('2000-01-01 00:00:00')) AS fotoDate,
pi.caption AS caption,													-- Title field in iPhoto
pi.comments AS photoDesc,												-- Description field in iPhoto
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
ORDER BY eventDate ASC, fotOName ASC, imageType ASC;

-- dbext:profile=iphoto2web
