$CMDpsm="C:\Program Files\Sisense\Prism\Psm.exe"
$ServerAddress="localhost"
$CubeName="dev_ifx_postpaid"
$CubeSQL="C:\Users\Administrator\Desktop\$CubeName.sql"

$AllTables = & $CMDpsm ecube edit tables getListOfTables serverAddress=$ServerAddress cubeName=$CubeName isCustom=false
$PSMHeader=$AllTables[0..4]
$AllTables = $AllTables | Where-Object {$PSMHeader -notcontains $_}
$CustomTables = & $CMDpsm ecube edit tables getListOfTables serverAddress=$ServerAddress cubeName=$CubeName isCustom=true
$CustomTables = $CustomTables | Where-Object {$PSMHeader -notcontains $_}
$ImportedTables = $AllTables | Where-Object {$CustomTables -notcontains $_}

"Custom fields of ElastiCube $CubeName" | Set-Content $CubeSQL

ForEach ($ImportedTable in $ImportedTables) {
	$CustomFields = & $CMDpsm ecube edit fields getListOfFields serverAddress=$serverAddress cubeName="$CubeName" tableName=$ImportedTable isCustom=true
	$CustomFields = $CustomFields | Where-Object {$PSMHeader -notcontains $_}
	ForEach ($CustomField in $CustomFields) {
		$SqlOfField = & $CMDpsm ecube edit fields getSqlOfCustomField serverAddress=$ServerAddress cubeName="$CubeName" tableName=$ImportedTable fieldName=$CustomField
		$SqlOfField = $SqlOfField | Where-Object {$PSMHeader -notcontains $_}
		$SqlOfField = $SqlOfField -replace "`t|`n|`r",""
		$SqlOfField = [string]::Join(" ", $SqlOfField)
		"$ImportedTable|$CustomField|$SqlOfField" | Add-Content $CubeSQL
	}
}

