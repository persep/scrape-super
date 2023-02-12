reduce [inputs] as $s ([input]; . + $s) |
map(
	{
		id,
		ean,
		brand,
		url: .share_url,
		name: .display_name,
		description: .packaging,
		category: "\(.categories[0].name) > \(.categories[0].categories[0].name)"
	}
)
