#######################################################
# Jpeg 画像方向を正位置にする
#######################################################
function SetNormalPositionExif( $JpegFile ){

	# 拡張子チェック
	$FileName = Split-Path $JpegFile -Leaf
	if( (($FileName -split "\.")[1] -ne "jpg" ) -and (($FileName -split "\.")[1] -ne "jpeg" )){
		return
	}

	# フルパスにする
	$JpegFileFullName = Convert-Path $JpegFile -ErrorAction SilentlyContinue
	if( $JpegFileFullName -eq $null ){
		echo "$JpegFile not convert full path."
		return
	}

	# 存在確認
	if( -not ( Test-Path $JpegFileFullName )){
		echo "$JpegFile not found"
		return
	}

	# テンポラリファイル名
	$TempFile = $JpegFileFullName + ".tmp"

	# アセンブリロード
	Add-Type -AssemblyName System.Drawing

	# Jpeg 読み込み
	$bmp = New-Object System.Drawing.Bitmap($JpegFileFullName)

	# Exif を処理
	$Index = $bmp.PropertyItems.Length
	for ( $i = 0; $i -lt $Index; $i++ ){
		$Item = $bmp.PropertyItems[$i]
		$ID = $Item.Id

		# 回線方向を正位置にする
		if( $id -eq 274 ){
			$Item.Value[0] = 1
			$bmp.SetPropertyItem($Item)
		}
	}

	# ファイル出力
	$bmp.Save($TempFile, [System.Drawing.Imaging.ImageFormat]::Jpeg )
	$bmp.Dispose()

	# オリジナルとテンポラリファイルを入れ替える
	$Org_Path = Split-Path -Path $JpegFileFullName
	$Org_FileName = Split-Path -Leaf $JpegFileFullName
	$New_FileName = $Org_FileName.Split(".")[0] + "-ORG." + $Org_FileName.Split(".")[1]
	ren $JpegFileFullName $New_FileName
	ren $TempFile $JpegFileFullName
}
