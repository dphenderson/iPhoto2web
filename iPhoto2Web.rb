#!/usr/bin/env ruby
#
# This program made possible with help from prior research on the iPhoto database from the following web pages —
# 	http://gskluzacek.tumblr.com/post/9111450792/more-on-iphotomain-db-iphotoaux-db-date-formats
# 	http://gskluzacek.tumblr.com/post/9080035545/iphotomain-db-table-relationships
# 	http://gskluzacek.tumblr.com/post/243137142/finding-the-original-photo-file-in-the-iphoto-library
# 	http://gskluzacek.tumblr.com/post/232335632/date-format-used-in-iphotomain-db-database
# 	http://punctuatednoise.wordpress.com/2011/06/08/hacking-mac-iphoto-sql-database/
# 	http://punctuatednoise.wordpress.com/2011/06/19/hacking-mac-iphoto-structure-revisit/
# — as well as independent investigation of the database.

require 'sqlite3'
require "optparse"

# set :path and :name to the default path to and name of the iPhoto Library
options = {:path => File.join(Dir.home, 'Pictures'), :name => 'iPhoto Library'}

OptionParser.new do |opts|

	prog_name = File.basename($PROGRAM_NAME)

	opts.banner = "#{prog_name} opens and queries the iPhoto Library.\n\nUsage: #{prog_name} [options]"

	opts.on( "-v", "--[no-]verbose", "Run verbosely.") do |v|
		options[:verbose] = v
	end

	opts.on("-p", "--path PATH", "Path to iPhoto Library being opened, default: #{options[:path]}.") do |p|
		options[:path] = p
	end

	opts.on("-n", "--name NAME", "Name of iPhoto Libray being opened, default: #{options[:name]}.") do |n|
		options[:name] = n
	end
end.parse!

main_f = File.join(options[:path], options[:name], 'iPhotoMain.db')

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

if File.exists?(main_f)
	main_db = SQLite3::Database.new(main_f)
	columns, *rows = main_db.execute2("SELECT"\
									  " e.primaryKey AS event,"\
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
									  " JOIN SqFileInfo AS fi ON fim.sqFileInfo = fi.primaryKey")
	puts columns.join '|'
	rows.each do |row|
		puts row.join '|'
	end
end
