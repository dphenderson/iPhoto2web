# iPhoto2Web

The intent of this program is to create a directory structure of images,
thumbnails, and html pages by reading the iPhoto® Library's sqlite3 database.
Rather than copying the images and thumbnails from the iPhoto Library,
iPhoto2Web creates symlinks to the actual files referenced in the iPhoto Libray
database.

This program made possible with help from prior research on the iPhoto ‘09
version 8.1.2 (424) database from the following web pages:

*    [http://gskluzacek.tumblr.com/post/9111450792/more-on-iphotomain-db-iphotoaux-db-date-formats](http://gskluzacek.tumblr.com/post/9111450792/more-on-iphotomain-db-iphotoaux-db-date-formats)
*    [http://gskluzacek.tumblr.com/post/9080035545/iphotomain-db-table-relationships](http://gskluzacek.tumblr.com/post/9080035545/iphotomain-db-table-relationships)
*    [http://gskluzacek.tumblr.com/post/243137142/finding-the-original-photo-file-in-the-iphoto-library](http://gskluzacek.tumblr.com/post/243137142/finding-the-original-photo-file-in-the-iphoto-library)
*    [http://gskluzacek.tumblr.com/post/232335632/date-format-used-in-iphotomain-db-database](http://gskluzacek.tumblr.com/post/232335632/date-format-used-in-iphotomain-db-database)
*    [http://punctuatednoise.wordpress.com/2011/06/08/hacking-mac-iphoto-sql-database/](http://punctuatednoise.wordpress.com/2011/06/08/hacking-mac-iphoto-sql-database/)
*    [http://punctuatednoise.wordpress.com/2011/06/19/hacking-mac-iphoto-structure-revisit/](http://punctuatednoise.wordpress.com/2011/06/19/hacking-mac-iphoto-structure-revisit/)

as well as independent investigation of the database.

SqFileImage.imageType definitions

*    imageType = 8: the original image if it is a raw data image
*    imageType = 7: key photo
*    imageType = 6: the image itself when you double clock on the thumbnail
*    imageType = 5: thumbnail
*    imageType = 1: the original if it is modified

SqFileInfo.format definitions

*    format = 862351904	=>	3FR
*    format = 943870035	=>	psd
*    format =1195984486	=>	gif
*    format =1246769696	=>	jp2
*    format =1246774599	=>	jpg
*    format =1346978644	=>	pict
*    format =1347307366	=>	png
*    format =1414088262	=>	tiff
*    format =1634891552	=>	ARW
*    format =1668428320	=>	CR2
*    format =1668445984	=>	CRW
*    format =1684238880	=>	DCR
*    format =1684956960	=>	DNG
*    format =1701996064	=>	ERF
*    format =1836020512	=>	MOS
*    format =1836218144	=>	MRW
*    format =1852139040	=>	NEF
*    format =1852995360	=>	NRW
*    format =1869768224	=>	ORF
*    format =1885693472	=>	PEF
*    format =1918985760	=>	RAF
*    format =1918990112	=>	RAW
*    format =1920414240	=>	RW2
*    format =1936863776	=>	SR2

Dates for SqEvent.rollDate and SqPhotoInfo.photoDate are stored as the real
number difference between the date and midnight 1 January 2000. The dates can
be retrieved using:
`DATETIME(stored_number + julianday('2000-01-01 00:00:00'))`

**NOTE:** Currently, this program is only useful with iPhoto ‘09 (version 8.1.2 (424)) as
the structure and items within the library package often change between
versions.

iPhoto is a registered trademark of Apple Inc.

