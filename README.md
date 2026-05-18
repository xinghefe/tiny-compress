# tiny-compress

Windows 图片右键菜单一键压缩工具。无需安装，右键即用，支持 JPG / PNG / WebP。

## 效果

| 格式 | 工具 | 默认质量 | 典型压缩率 |
|------|------|---------|----------|
| JPG / JPEG | ImageMagick（去除 EXIF） | 75 | 40–60% |
| PNG | pngquant（有损量化） | 65–80 | 30–50% |
| WebP | ImageMagick | 自定义 | — |

## 功能

- **一键压缩**：右键图片 → 自动选最优参数 → 原地覆盖，零交互
- **自定义压缩**：交互式选择质量级别（轻度 / 标准 / 高强度）和输出格式，另存为 `原名.compressed.扩展名`

## 目录结构

```
tiny-compress/
├── bin/
│   ├── CompressImage.ps1    # 主逻辑脚本
│   ├── CompressImage.reg    # 注册表文件（注入右键菜单）
│   ├── CompressImage.bat    # 备用 BAT 入口
│   ├── magick.exe           # ImageMagick 7.1.2-12
│   └── pngquant.exe         # pngquant
```

## 安装

### 1. 修改路径

> **重要**：`.reg` 文件中的路径是硬编码的，使用前必须改成你实际的安装目录。

用文本编辑器打开 `bin\CompressImage.reg`，将所有 `D:\\app\\tiny-compress` 替换为你的实际路径，例如：

```
# 原始（示例）
"D:\\app\\tiny-compress\\bin\\CompressImage.ps1"

# 替换后（假设你放在 C:\tools\tiny-compress）
"C:\\tools\\tiny-compress\\bin\\CompressImage.ps1"
```

注意：注册表文件中路径分隔符必须用 `\\`（双反斜杠）。

### 2. 导入注册表

双击 `bin\CompressImage.reg` → 确认导入。

导入后右键任意图片即可看到菜单项。

### 3. 验证

右键一张 JPG，选「一键压缩」，文件大小应明显减小。

## 卸载

运行以下命令删除注册表项：

```powershell
Remove-Item -Path "HKCR:\SystemFileAssociations\image\shell\CompressImage" -Recurse
Remove-Item -Path "HKCR:\SystemFileAssociations\image\shell\CompressImageCustom" -Recurse
```

或在「注册表编辑器」中手动删除：

```
HKEY_CLASSES_ROOT\SystemFileAssociations\image\shell\CompressImage
HKEY_CLASSES_ROOT\SystemFileAssociations\image\shell\CompressImageCustom
```

## 质量参数参考

### 一键压缩（Auto 模式）

| 格式 | 质量值 | 说明 |
|------|-------|------|
| JPG | 75 | 去除 EXIF，原地覆盖 |
| PNG | 65–80 | pngquant 有损量化，原地覆盖 |

### 自定义压缩（Custom 模式）

| 级别 | PNG 质量 | JPG 质量 |
|------|---------|---------|
| 轻度（高质量） | 80 | 85 |
| 标准（推荐） | 70 | 75 |
| 高强度（最小体积） | 60 | 65 |

## 命令行直接调用

```powershell
# Auto 模式
powershell -File bin\CompressImage.ps1 -FilePath "C:\path\to\image.jpg" -Mode Auto

# Custom 模式（交互式）
powershell -File bin\CompressImage.ps1 -FilePath "C:\path\to\image.png" -Mode Custom
```

## 系统要求

- Windows 10 / 11
- PowerShell 5.1+（系统自带）
- 无需安装 ImageMagick 或 pngquant（已内置）

## 依赖声明

| 组件 | 版本 | 许可证 |
|------|------|-------|
| [ImageMagick](https://imagemagick.org/) | 7.1.2-12 | Apache 2.0 |
| [pngquant](https://pngquant.org/) | — | GPL v3 |

## License

MIT
