#!/bin/bash

data=$(wget --no-check-certificate -O - https://www.ynetnews.com/category/3082 2>/dev/null)
articles=$(echo "$data" | grep -oP "https://www.ynetnews.com/article/[0-9a-zA-Z]{9}" | sort -u)
num_links="$(echo "$articles" | wc -l)"

function name_count() {
	local link="$1"
	local num_netan=$(wget --no-check-certificate -O - $link 2>/dev/null | grep -oP "Netanyahu" | wc -w)
	local num_gantz=$(wget --no-check-certificate -O - $link 2>/dev/null | grep -oP "Gantz" | wc -w)
	echo "$num_netan $num_gantz"
}

for ((link=1; link<(( $num_links+1 )); ++link)); do
	link_of_article=$(echo "${articles[@]}" | awk -v line="$link" 'NR == line')
	result=$(name_count "$link_of_article")
	num_netan=$(echo "$result" | cut -d " " -f 1)
	num_gantz=$(echo "$result" | cut -d " " -f 2)
	if (( $num_netan+$num_gantz==0 ))
	then
		echo "$link_of_article, -"
	else
		echo "$link_of_article, Netanyahu, $num_netan, Gantz, $num_gantz"
	fi
done
