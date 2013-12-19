#!/usr/bin/env ruby
#
# This program made possible with help from prior research on the iPhoto(R) ‘09 version 8.1.2 (424) database from the following web pages —
# 	http://gskluzacek.tumblr.com/post/9111450792/more-on-iphotomain-db-iphotoaux-db-date-formats
# 	http://gskluzacek.tumblr.com/post/9080035545/iphotomain-db-table-relationships
# 	http://gskluzacek.tumblr.com/post/243137142/finding-the-original-photo-file-in-the-iphoto-library
# 	http://gskluzacek.tumblr.com/post/232335632/date-format-used-in-iphotomain-db-database
# 	http://punctuatednoise.wordpress.com/2011/06/08/hacking-mac-iphoto-sql-database/
# 	http://punctuatednoise.wordpress.com/2011/06/19/hacking-mac-iphoto-structure-revisit/
# — as well as independent investigation of the database.
#
# iPhoto is a registered trademark of Apple Inc.
#

require 'sqlite3'
require "optparse"

# set :path to the default path to the iPhoto Library
options = {:path => File.join(Dir.home, 'Pictures'), :by_event => true, :by_date => true}

OptionParser.new do |opts|

	prog_name = File.basename($PROGRAM_NAME)

	opts.banner = "#{prog_name} opens and queries the iPhoto Library.\n\n"\
		"Usage: #{prog_name} [options] [file]"

	opts.on( "-a", "--album [AlbumName]", String, "Create layout from user albums or a named album.") do |name|
		options[:by_album] = true
		options[:by_event] = false
		options[:album_name] = name || ''
	end

	opts.on( "-D", "--Date", String,
	         "Create layout from an event date") do |date|
		options[:the_date] = date || ''
	end

	opts.on( "-E", "--event-name [EventName]", String,
	         "Create layout from events (default) or a named event.") do |name|
		options[:the_name] = name || ''
	end

	opts.on("-p", "--path PATH", "Path to iPhoto Library being opened, default: #{options[:path]}.") do |p|
		options[:path] = p
	end

	opts.on( "-v", "--[no-]verbose", "Run verbosely.") do |v|
		options[:verbose] = v
	end
end.parse!

p options

lib_name = ARGV[0] || 'iPhoto Library'	# Set lib_name to default name of iPhoto Library

main_f = File.join(options[:path], lib_name, 'iPhotoMain.db')

abort("#{main_f} doesn't exist.") unless File.exists?(main_f)
#------======-------#
# SqFileImage.imageType definitions
#
# type=8: the original image if it is a raw data image
# type=7: key photo
# type=6: the image itself when you double clock on the thumbnail
# type=5: thumbnail
# type=1: the original if it is modified
#
# SqFileInfo.format definitions
#
#  862351904	=>	3FR
#  943870035	=>	psd
# 1195984486	=>	gif
# 1246769696	=>	jp2
# 1246774599	=>	jpg
# 1346978644	=>	pict
# 1347307366	=>	png
# 1414088262	=>	tiff
# 1634891552	=>	ARW
# 1668428320	=>	CR2
# 1668445984	=>	CRW
# 1684238880	=>	DCR
# 1684956960	=>	DNG
# 1701996064	=>	ERF
# 1836020512	=>	MOS
# 1836218144	=>	MRW
# 1852139040	=>	NEF
# 1852995360	=>	NRW
# 1869768224	=>	ORF
# 1885693472	=>	PEF
# 1918985760	=>	RAF
# 1918990112	=>	RAW
# 1920414240	=>	RW2
# 1936863776	=>	SR2
#
# Dates for SqEvent and SqPhotoInfo are stored as the real number difference
# between the photo's date and midnight 1 January 2000. The dates can be
# retrieved using:
# DATETIME(stored_number + julianday('2000-01-01 00:00:00'))
#
#------======-------#

main_db = SQLite3::Database.new(main_f)
columns, *rows = main_db.execute2("SELECT"\
								  " e.primaryKey AS event,"\
								  " e.name AS eventName,"\
								  " DATETIME(e.rollDate + JULIANDAY('2000-01-01 00:00:00')) AS eventDate,"\
								  " pi.primaryKey AS fotoInfo,"\
								  " pi.archiveFilename AS fotoName,"\
								  " DATETIME(pi.photoDate + JULIANDAY('2000-01-01 00:00:00')) AS fotoDate,"\
								  " fim.primaryKey AS fileImage,"\
								  " fi.primaryKey AS fileInfo,"\
								  " fim.imageType AS imageType,"\
								  " fi.format AS format,"\
								  " fi.relativePath AS relPath"\
								  " FROM"\
								  " SqEvent AS e"\
								  " JOIN SqPhotoInfo AS pi ON pi.event = e.primaryKey"\
								  " JOIN SqFileImage AS fim ON fim.photoKey = pi.primaryKey"\
								  " JOIN SqFileInfo AS fi ON fim.sqFileInfo = fi.primaryKey"\
								  " WHERE fim.imageType = 8 OR fim.imageType = 6"\
								  " ORDER BY imageType ASC, fotoname ASC")
puts columns.join '|'
rows.each do |row|
	puts row.join '|'
end
