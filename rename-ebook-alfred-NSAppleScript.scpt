property supported_doc_list : {"pdf", "mobi", "chm", "epub"}
on alfred_script(query)

try


tell application "Finder"
	
	set selected_files to (get selection)
	
	set file_count to count selected_files
	if file_count = 0 then
		return "Please select one file!"
	end if
	if file_count > 1 then
		return "Only support one file selected!"
	end if
	
	repeat with the_file in selected_files
		set nameExtension to name extension of the_file
		if nameExtension is in supported_doc_list then
			-- Get file path for rename
			set file_full_path to POSIX path of (the_file as text)
		else
			return "Invalid Ebook Type: " & nameExtension
		end if
	end repeat
end tell

tell application "System Events"
	--set alfred_input to " Test Book Name,  123123"
	set alfred_input to query
	set bookInfoArray to my theSplit(alfred_input, ",")
	
	set newBookName to ""
	repeat with partBookInfo in bookInfoArray
		set partBookInfoRemoveBlank to do shell script "echo '" & partBookInfo & "' | awk '{$1=$1};1' "
		set partBookInfoRemoveBlank to do shell script "echo '" & partBookInfoRemoveBlank & "' | sed 's/ /./g' "
		set newBookName to newBookName & "[" & partBookInfoRemoveBlank & "]"
	end repeat
	
	log newBookName
	set name of file file_full_path to newBookName & "." & nameExtension
	return "File Renamed Successfully"
	
end tell


on error errStr number errorNumber
	return errStr
end try


end alfred_script

on theSplit(someText, theDelimiter)
	-- save delimiters to restore old settings
	set oldDelimiters to AppleScript's text item delimiters
	-- set delimiters to delimiter to be used
	set AppleScript's text item delimiters to theDelimiter
	-- create the array
	set theArray to every text item of someText
	-- restore the old setting
	set AppleScript's text item delimiters to oldDelimiters
	-- return the result
	return theArray
end theSplit