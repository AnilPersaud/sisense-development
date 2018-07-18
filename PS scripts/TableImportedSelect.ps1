$CMDpsm="C:\Program Files\Sisense\Prism\Psm.exe"
$ServerAddress="localhost"
$CubeName="dev_ifx_aanvragen"
$CubeSQL="C:\Users\Administrator\Desktop\$CubeName.select.sql"

$AllTables = & $CMDpsm ecube edit tables getListOfTables serverAddress=$ServerAddress cubeName=$CubeName isCustom=false
$PSMHeader=$AllTables[0..4]
$AllTables = $AllTables | Where-Object {$PSMHeader -notcontains $_}
$CustomTables = & $CMDpsm ecube edit tables getListOfTables serverAddress=$ServerAddress cubeName=$CubeName isCustom=true
$CustomTables = $CustomTables | Where-Object {$PSMHeader -notcontains $_}
$ImportedTables = $AllTables | Where-Object {$CustomTables -notcontains $_}

"Select statement of imported tables in ElastiCube $CubeName" | Set-Content $CubeSQL

ForEach ($ImportedTable in $ImportedTables) {
	"select * from $ImportedTable" | Add-Content $CubeSQL
}


