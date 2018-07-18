$CMDpsm="C:\Program Files\Sisense\Prism\Psm.exe"
$ServerAddress="localhost"

$CubeName1 = Read-Host -Prompt 'Name of cube to sync'
$CubeName2 = Read-Host -Prompt 'Name of cube to sync with'
$Table2Sync = Read-Host -Prompt 'Name of table to sync'
$IgnorePreSufCommon = Read-Host -Prompt 'Ignore prefix .informix or suffix .txt for common tables (y|n) default(n)'
$IgnorePreSufLookup = Read-Host -Prompt 'Ignore prefix .informix or suffix .txt for lookup tables (y|n) default(n)'
$IgnorePreSufCommon = $IgnorePreSufCommon.ToLower()
$IgnorePreSufLookup = $IgnorePreSufLookup.ToLower()

$AllTablesCube1 = & $CMDpsm ecube edit tables getListOfTables serverAddress=$ServerAddress cubeName=$CubeName1 isCustom=false
$PSMHeader=$AllTablesCube1[0..4]
$AllTablesCube1 = $AllTablesCube1 | Where-Object {$PSMHeader -notcontains $_}
$CustomTablesCube1 = & $CMDpsm ecube edit tables getListOfTables serverAddress=$ServerAddress cubeName=$CubeName1 isCustom=true
$CustomTablesCube1 = $CustomTablesCube1 | Where-Object {$PSMHeader -notcontains $_}
$CommonTablesCube1 = $AllTablesCube1 | Where-Object {$CustomTablesCube1 -notcontains $_}

$AllTablesCube2 = & $CMDpsm ecube edit tables getListOfTables serverAddress=$ServerAddress cubeName=$CubeName2 isCustom=false
$AllTablesCube2 = $AllTablesCube2 | Where-Object {$PSMHeader -notcontains $_}
$CustomTablesCube2 = & $CMDpsm ecube edit tables getListOfTables serverAddress=$ServerAddress cubeName=$CubeName2 isCustom=true
$CustomTablesCube2 = $CustomTablesCube2 | Where-Object {$PSMHeader -notcontains $_}
$CommonTablesCube2 = $AllTablesCube2 | Where-Object {$CustomTablesCube2 -notcontains $_}

$TableNotInCube2 = $AllTablesCube2 | Where-Object {$AllTablesCube1 -notcontains $_}

if ($TableNotInCube2.Length -gt 0) {
	"Tables from $CubeName2 NOT in $CubeName1"
	$TableNotInCube2
}

$CommonTables = $AllTablesCube2 | Where-Object {$AllTablesCube1 -contains $_}
if ($IgnorePreSufCommon.Equals('y')) {
	$Tables1 = $CommonTablesCube1 -replace "informix.|.txt",""
	$Tables2 = $CommonTablesCube2 -replace "informix.|.txt",""
	$CommonTables = $Tables2 | Where-Object {$Tables1 -contains $_}
}
if ($CommonTables.Length -eq 0) {
	return "No common tables between $CubeName1 and $CubeName2"
}

ForEach ($CommonTable in $CommonTables) {
	if ($Table2Sync -and $CommonTable -ne $Table2Sync) {continue}
	"Verifying columns of table $CommonTable"
	$CommonTable1 = $CommonTable
	$CommonTable2 = $CommonTable
	if ($IgnorePreSufCommon.Equals('y')) {
		$CommonTable1 = [string]::Concat($CommonTable, ".txt")
		$CommonTable1 = $AllTablesCube1 -ceq $CommonTable1
		if (!$CommonTable1) {
			$CommonTable1 = [string]::Concat("informix.", $CommonTable)
			$CommonTable1 = $AllTablesCube1 -ceq $CommonTable1
		}
		$CommonTable2 = [string]::Concat($CommonTable, ".txt")
		$CommonTable2 = $AllTablesCube2 -ceq $CommonTable2
		if (!$CommonTable2) {
			$CommonTable2 = [string]::Concat("informix.", $CommonTable)
			$CommonTable2 = $AllTablesCube2 -ceq $CommonTable2
		}
	}
	$ColumnsCube1 = & $CMDpsm ecube edit fields getListOfFields serverAddress=$serverAddress cubeName="$CubeName1" tableName=$CommonTable1 isCustom=false
	$ColumnsCube1 = $ColumnsCube1 | Where-Object {$PSMHeader -notcontains $_}
	$ColumnsCube2 = & $CMDpsm ecube edit fields getListOfFields serverAddress=$serverAddress cubeName="$CubeName2" tableName=$CommonTable2 isCustom=false
	$ColumnsCube2 = $ColumnsCube2 | Where-Object {$PSMHeader -notcontains $_}
	$ColumnsNotInCube2 = $ColumnsCube2 | Where-Object {$ColumnsCube1 -notcontains $_}
	$ColumnsNotInCube1 = $ColumnsCube1 | Where-Object {$ColumnsCube2 -notcontains $_}
	ForEach ($ColumnNotInCube2 in $ColumnsNotInCube2) {
		"Add missing column $ColumnNotInCube2"
		$TypeOfField = & $CMDpsm ecube edit fields getDataTypeOfField serverAddress=$ServerAddress cubeName="$CubeName2" tableName=$CommonTable2 fieldName=$ColumnNotInCube2
		$TypeOfField = $TypeOfField | Where-Object {$PSMHeader -notcontains $_}
		$SqlOfField = & $CMDpsm ecube edit fields getSqlOfCustomField serverAddress=$ServerAddress cubeName="$CubeName2" tableName=$CommonTable2 fieldName=$ColumnNotInCube2
		$SqlOfField = $SqlOfField | Where-Object {$PSMHeader -notcontains $_}
		$SqlOfField = $SqlOfField -replace "`t|`n|`r",""
		$SqlOfField = [string]::Join(" ", $SqlOfField)
		if ($IgnorePreSufLookup.Equals('y') -and $SqlOfField.Contains('Lookup') -and $SqlOfField.Contains('informix.')) {
			$SqlOfField2 = $SqlOfField -replace "Lookup|\(|\)|\[|\]",""
			$lookupTable = $SqlOfField2.Split(',')[0]
			$newLookupTable = $lookupTable.Split('.')[1]
			$lookupTable = [string]::Concat("informix.", $newLookupTable)
			$newLookupTable = [string]::Concat($newLookupTable, '.txt')
			$SqlOfField = $SqlOfField -replace $lookupTable, $newLookupTable
		}
		$SqlOfField
		& $CMDpsm ecube edit fields addCustomField serverAddress=$serverAddress cubeName="$CubeName1" tableName="$CommonTable1" fieldName="$ColumnNotInCube2" fieldType="$TypeOfField" sqlExpression="$SqlOfField"
	}
}