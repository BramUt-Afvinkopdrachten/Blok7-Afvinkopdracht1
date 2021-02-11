#!/bin/bash
summary_url="ftp://ftp.ncbi.nlm.nih.gov/pub/clinvar/tab_delimited/variant_summary.txt.gz"
md5_url="ftp://ftp.ncbi.nlm.nih.gov/pub/clinvar/tab_delimited/variant_summary.txt.gz.md5"
summary_file="variant_summary.txt"
zip_file="variant_summary.txt.gz"
md5_file="variant_summary.txt.gz.md5"

check_md5() {
	new_md5=$(cat $md5_file | grep -o '.*\s')
	summary_md5=$(md5sum $zip_file | grep -o '.*\s')
	echo $new_md5
	echo $summary_md5
	if [ $new_md5 == $summary_md5 ]; then
		echo "Match"
		# 0 = true
		return 0
	else
		echo "MD5 mismatch"
		# 1 = false
		return 1
	fi
}
	
	
download_summary () {
	echo "Downloading summary..."
	if wget -qO $zip_file $summary_url; then
		echo "File downloaded"
		
	else
    	echo "Something went wrong"
	fi	
}

download_md5 () {
	echo "Downloading md5..."
	if wget -qO $md5_file $md5_url; then
		echo "md5 downloaded"
	else
		echo "Something went wrong"
	fi
}

unzip_summary() {
	echo "Decompressing summary file..."
	gunzip -k $zip_file
}


if test -f $zip_file; then
	echo "Summary file found."
	download_md5
else
	echo "No summary file found."
	download_summary
	download_md5
fi

if ! check_md5; then
	download_summary
	if check_md5; then
		unzip_summary
		echo "Java script..."
	else
		echo "MD5 sum still doesn't match :("
	fi
else
	unzip_summary
	echo "Java script..."
fi

	



