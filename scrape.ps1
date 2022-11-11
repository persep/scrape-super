$ProgressPreference = "SilentlyContinue"

$data_dir = "data"
$tmp_dir = "tmp"

if(!(Test-Path $data_dir)) {
     Write-Host "Creating data folder"
     New-Item -Path "." -Name $data_dir -ItemType "directory" > $null
}

Write-Host "Creating temporary folder"
New-Item -Path "." -Name $tmp_dir -ItemType "directory" > $null

$url = "https://tienda.mercadona.es/api/categories/?lang=es&wh=alc1"

Write-Host -NoNewline "Downloading main categories: "
try {
     $main_categories = Invoke-RestMethod -Method Get -Uri $url
     Write-Host "OK" -ForegroundColor Green
} catch {
     Write-Host $_ -ForegroundColor red
     exit 1
}

$n = 1

foreach($results in $main_categories.results) {
     foreach($category in $results.categories) {
          $id = $category.id
          $name = $category.name

     	$file = "$tmp_dir/mercadona-categories-$id.json"
          $url = "https://tienda.mercadona.es/api/categories/$id/?lang=es&wh=alc1"

          Write-Host "$n. $name ($id)"
          
          try {
               Invoke-RestMethod -Method Get -Uri $url -OutFile $file
          } catch {
               Write-Host $_ -ForegroundColor red
               exit 1
    	}
    	Start-Sleep -Seconds 6
    	$n++
    }
}

Write-Host "Success Downloading" -ForegroundColor Green

$today = Get-Date -Format "yyyy-MM-dd"
$new_file = "$today-products.json"

Write-Host "Joining JSONs to $data_dir/$new_file"
jq -n -f scrape.jq (Get-Item $tmp_dir/*.json) > $data_dir/$new_file

$n_products = $(jq -r "length" $data_dir/$new_file)

Write-Host "Deleting temporary folder"
Remove-Item -Recurse $tmp_dir

Write-Host "Finished downloading $n_products products on $today" -ForegroundColor Green

exit 0
