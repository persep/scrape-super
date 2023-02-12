def slugify:
  explode | 
  map( 	#downcase
 		if 65 <= . and . <= 90 then . + 32  
  	   	#spaces
  	   	elif . == 32 then 95
  	   	#,
  	   	elif . == 44 then empty 
  	   	#á
  	   	elif . == 225 then 97
  	   	#é
  	   	elif . == 233 then 101
  	   	#í
		elif . == 237 then 105
		#ó
		elif . == 243 then 111
		#ú
		elif . == 250 then 117
		#ñ
		elif . == 241 then 110
  	   	else . 
  	   	end ) |
  implode;

def roundit: .*100.0|round/100.0;

reduce [inputs] as $s ([input]; . + $s) |
map(
    .name as $category | 
    .categories[].products[] | 
    (if .price_instructions.selling_method == 1 then 
    	((.price_instructions.reference_price|tonumber) * 
        .price_instructions.min_bunch_amount)|roundit|tostring
    else 
    	.price_instructions.unit_price
    end) as $price| 
		{
    	  	url: .share_url,	
	      	category: "\(.categories[0].name)_\($category)" | slugify,
	  	    name: .display_name,
    	  	description: .packaging,
	    	price: $price,
	    	iva: .price_instructions.iva,
    		reference_price: .price_instructions.reference_price,
    		reference_unit: .price_instructions.reference_format | ascii_downcase,
    		date: now | strftime("%Y-%m-%d"),
    		id
		}
) | # equivalent to sort_by | unique_by https://jqplay.org/s/DC9_EcnmCsr
[group_by(.id)[] | sort_by(.category)[0]] 
