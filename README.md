# JetBrains IDE 激活工具  <img src="https://resources.jetbrains.com.cn/storage/products/company/brand/logos/jetbrains.svg" width="200" alt="JetBrains logo.">

这是一个用于激活 JetBrains 系列 IDE 的批处理工具脚本。

## 功能介绍

此脚本可以帮助您完成以下操作：

1. 检查 Java 环境是否存在并显示版本
2. 生成激活密钥
3. 修改 JetBrains IDE 的配置文件以应用激活
4. 支持处理快捷方式和直接的可执行文件路径

## 支持的 IDE

- <img src="https://resources.jetbrains.com.cn/storage/products/company/brand/logos/CLion_icon.svg" width="30" alt="CLion logo.">CLion
- <img src="https://resources.jetbrains.com.cn/storage/products/company/brand/logos/DataGrip_icon.svg" width="30" alt="CLion logo.">DataGrip
- <img src="https://resources.jetbrains.com.cn/storage/products/company/brand/logos/DataSpell_icon.svg" width="30" alt="CLion logo.">DataSpell
- <img src="https://resources.jetbrains.com.cn/storage/products/company/brand/logos/GoLand_icon.svg" width="30" alt="CLion logo.">GoLand
- <img src="https://resources.jetbrains.com.cn/storage/products/company/brand/logos/IntelliJ_IDEA_icon.svg" width="30" alt="CLion logo.">IntelliJ IDEA
- <img src="https://resources.jetbrains.com.cn/storage/products/company/brand/logos/PhpStorm_icon.svg" width="30" alt="CLion logo.">PhpStorm
- <img src="https://resources.jetbrains.com.cn/storage/products/company/brand/logos/PyCharm_icon.svg" width="30" alt="CLion logo.">PyCharm
- <img src="https://resources.jetbrains.com.cn/storage/products/company/brand/logos/Rider_icon.svg" width="30" alt="CLion logo.">Rider
- <img src="https://resources.jetbrains.com.cn/storage/products/company/brand/logos/RubyMine_icon.svg" width="30" alt="CLion logo.">RubyMine
- <img src="https://resources.jetbrains.com.cn/storage/products/company/brand/logos/RustRover_icon.svg" width="30" alt="CLion logo.">RustRover
- <img src="https://resources.jetbrains.com.cn/storage/products/company/brand/logos/WebStorm_icon.svg" width="30" alt="CLion logo.">WebStorm

## 使用方法

1. 确保您的系统已安装 Java 环境并配置了环境变量
2. 将此脚本与 `sniarbtej-2024.2.8.jar` 文件放在同一目录下
3. 双击运行脚本或在命令行中执行
4. 按照提示输入 License ID 和 User Name
5. 输入 JetBrains IDE 可执行文件或快捷方式的完整路径
6. 脚本会自动修改配置文件并完成激活

## 工作流程

### 步骤零：检查环境

脚本首先检查是否已经修补过环境（是否存在 key.txt 文件）。如果已修补，会询问是否需要重新修补。

### 步骤一：检查 Java 环境

检查系统中是否安装了 Java 并显示版本信息。如果未安装 Java 或未配置环境变量，脚本会提示您安装并配置。

### 步骤二：生成激活密钥

要求您输入 License ID 和 User Name，然后使用这些信息生成激活密钥并保存到 key.txt 文件中。

### 步骤三：检查密钥生成结果

检查 key.txt 文件是否成功生成且不为空。如果生成失败，可能是因为输入的值包含特殊符号，脚本会提示您重新输入。

### 步骤四：处理 IDE 配置文件

1. 要求您输入 IDE 可执行文件或快捷方式的完整路径
2. 如果输入的是快捷方式，脚本会解析其指向的实际文件
3. 检查文件是否是支持的 JetBrains IDE
4. 备份原始的 vmoptions 文件
5. 根据 IDE 类型生成新的 vmoptions 文件，添加激活参数
6. 使用 PowerShell 以 UTF-8 编码保存文件，确保中文路径正常显示

## 注意事项

- 脚本需要管理员权限才能修改某些目录下的文件
- 确保 Java 环境已正确安装并配置
- 脚本会自动备份原始配置文件（添加 .bak 后缀），以便需要时恢复
- 生成的配置文件使用 UTF-8 编码，确保中文路径正常显示

## 技术细节

- 使用 VBScript 解析快捷方式文件
- 使用 PowerShell 以 UTF-8 编码写入文件 
- 根据不同的 IDE 类型生成不同的配置内容
- 自动处理路径中的引号和特殊字符

## 免责声明

此脚本仅用于学习和研究目的。请尊重软件版权，支持正版软件。

