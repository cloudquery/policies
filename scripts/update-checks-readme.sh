#!/bin/bash

TRANSFORMATIONS_GROUPS=$(ls transformations)
for group in $TRANSFORMATIONS_GROUPS; do
    for dir in $(ls "transformations/$group"); do
		if [ ! -f "transformations/$group/$dir/Makefile" ]; then
			continue;
		fi
		echo "Updating docs for $group/$dir"
		(cd "transformations/$group/$dir" && make gen-docs)
	done
done