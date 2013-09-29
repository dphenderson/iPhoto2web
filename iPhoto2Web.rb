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
# sqFileInfo.imageType definitions
# type=8: the original image if it is a raw data image
# type=7: key photo
# type=6: the image itself when you double clock on the thumbnail
# type=5: thumbnail
# type=1: the original if it is modified
#
# select primaryKey, datetime(photoDate + julianday('2000-01-01 00:00:00')) as photoDate, archiveFilename from SqPhotoInfo order by archiveFilename desc;
#------======-------#

# " DATETIME(e.rollDate + JULIANDAY('2000-01-01 00:00:00')) AS eventDate,"\

main_db = SQLite3::Database.new(main_f)
columns, *rows = main_db.execute2("SELECT"\
								  " e.primaryKey AS event,"\
								  " e.name AS eventName,"\
								  " e.rollDate AS eventDate,"\
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
								  " WHERE fim.imageType = 6"\
								  " ORDER BY eventDate ASC, fotoname ASC, imageType ASC")
puts columns.join '|'
rows.each do |row|
	puts row.join '|'
end
