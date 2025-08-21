# For style minimal
printf "%s%*s\n" "$FZF_INFO" "$((FZF_COLUMNS - FZF_PREVIEW_COLUMNS - 8 - ${#FZF_INFO}))" "$FZF_POS"
