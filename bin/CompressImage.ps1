param(
    [string]$FilePath,
    [string]$Mode = "Auto"
)

if (-not (Test-Path $FilePath)) {
    Write-Host "File not found: $FilePath"
    exit 1
}

$extension = [System.IO.Path]::GetExtension($FilePath).ToLower()
$directory = [System.IO.Path]::GetDirectoryName($FilePath)
$nameWithoutExt = [System.IO.Path]::GetFileNameWithoutExtension($FilePath)

if ($Mode -eq "Auto") {
    if ($extension -eq ".jpg" -or $extension -eq ".jpeg") {
        magick mogrify -strip -quality 75 $FilePath
        Write-Host "Compressed JPG in place: $FilePath"
    } elseif ($extension -eq ".png") {
        $pngquantPath = Join-Path $PSScriptRoot "pngquant.exe"
        & $pngquantPath --quality 65-80 --ext .png --force $FilePath
        Write-Host "Compressed PNG in place: $FilePath"
    } else {
        Write-Host "Unsupported file type: $extension"
        exit 1
    }
} elseif ($Mode -eq "Custom") {
    $qualityChoice = Read-Host @"
请选择压缩质量级别:
1) 轻度压缩(高质量)
2) 标准压缩(推荐)
3) 高强度压缩(更小体积)
输入 1/2/3，回车默认 2:
"@

    switch ($qualityChoice) {
        "1" {
            if ($extension -eq ".png") { $quality = 80 } else { $quality = 85 }
        }
        "3" {
            if ($extension -eq ".png") { $quality = 60 } else { $quality = 65 }
        }
        default {
            if ($extension -eq ".png") { $quality = 70 } else { $quality = 75 }
        }
    }

    $formatChoice = Read-Host @"
请选择输出格式:
1) 保留原格式
2) JPG
3) PNG
4) WebP
输入 1/2/3/4，回车默认 1:
"@

    switch ($formatChoice) {
        "2" { $targetExtension = ".jpg" }
        "3" { $targetExtension = ".png" }
        "4" { $targetExtension = ".webp" }
        default { $targetExtension = $extension }
    }

    $outputPath = [System.IO.Path]::Combine($directory, $nameWithoutExt + ".compressed" + $targetExtension)

    magick $FilePath -strip -quality $quality $outputPath
    Write-Host "Custom compressed to $outputPath"
} else {
    Write-Host "Unknown mode: $Mode"
    exit 1
}
