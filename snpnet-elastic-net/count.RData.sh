#!/bin/bash
set -beEuo pipefail

find $(readlink -f data) -name "*RData" | rev | awk -v FS='/' '{print $3}' | rev | uniq -c | sort -nr

