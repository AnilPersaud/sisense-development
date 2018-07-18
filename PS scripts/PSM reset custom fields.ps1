$CMDpsm="C:\Program Files\Sisense\Prism\Psm.exe"
$ServerAddress="localhost"
$CubeName="dev_ifx_aanvragen"
$CubeSQL="C:\Users\Administrator\Desktop\$CubeName.custom.sql"

$AllTables = & $CMDpsm ecube edit tables getListOfTables serverAddress=$ServerAddress cubeName=$CubeName isCustom=false
$PSMHeader=$AllTables[0..4]
$AllTables = $AllTables | Where-Object {$PSMHeader -notcontains $_}
$CustomTables = & $CMDpsm ecube edit tables getListOfTables serverAddress=$ServerAddress cubeName=$CubeName isCustom=true
$CustomTables = $CustomTables | Where-Object {$PSMHeader -notcontains $_}
$ImportedTables = $AllTables | Where-Object {$CustomTables -notcontains $_}

$AllDefaultCustomSQL = Get-Content $CubeSQL

ForEach ($ImportedTable in $ImportedTables) {
	if ($ImportedTable -ne "informix.ifx_users") {Continue}
	$TableDefaultCustomSQL = $AllDefaultCustomSQL | Select-String -Pattern "^$ImportedTable"
	$TableDefaultCustomSQL = $TableDefaultCustomSQL -replace "`t|`n|`r",""
	$TableCustomFields = & $CMDpsm ecube edit fields getListOfFields serverAddress=$serverAddress cubeName="$CubeName" tableName=$ImportedTable isCustom=true
	$TableCustomFields = $TableCustomFields | Where-Object {$PSMHeader -notcontains $_}
	$TableCustomSQL = {@()}.Invoke()
	ForEach ($CustomField in $TableCustomFields) {
		$SqlOfField = & $CMDpsm ecube edit fields getSqlOfCustomField serverAddress=$ServerAddress cubeName="$CubeName" tableName=$ImportedTable fieldName=$CustomField
		$SqlOfField = $SqlOfField | Where-Object {$PSMHeader -notcontains $_}
		$SqlOfField = $SqlOfField -replace "`t|`n|`r",""
		$SqlOfField = [string]::Join(" ", $SqlOfField)
		$TableCustomSQL.Add("$ImportedTable|$CustomField|$SqlOfField")
	}
<# 	"REMOVE custom field"
	$TableCustomSQL | Where-Object {$TableDefaultCustomSQL -notcontains $_} #>
	"ADD custom field"
	ForEach ($CustomSQL in $TableDefaultCustomSQL | Where-Object {$TableCustomSQL -notcontains $_}) {
		$CustomSQL
		$filler = $CustomSQL.Split("|")
		$fieldName = $filler[1]
		$SQLExpression = $filler[2]
		& $CMDpsm ecube edit fields addCustomField serverAddress=$serverAddress cubeName="$cubeName" tableName="$ImportedTable" fieldName="$fieldName" sqlExpression="$SQLExpression"
	}
}