# 第一步：执行 tShark 命令以生成数据源文件 input.pcap
# 启动 tshark 命令并让它在后台运行
Start-Process -NoNewWindow -FilePath 'tshark' -ArgumentList '-i "\Device\NPF_{AEEDC85A-6D5C-4251-BEE6-2D6319DEF155}" -f "tcp port 80 or tcp port 1935" -w input.pcap'

# 下面的代码继续执行
Write-Host "tshark 已在后台运行，继续执行其他操作..."

# 引入 Windows Forms 库
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# 创建一个窗口
$form = New-Object Windows.Forms.Form
$form.Text = '一键获取推流码'
$form.Size = New-Object Drawing.Size(550, 250)  # 增大窗口宽度
$form.StartPosition = 'CenterScreen'

# 服务器标签
$serverLabel = New-Object Windows.Forms.Label
$serverLabel.Text = '服务器：'
$serverLabel.Location = New-Object Drawing.Point(10, 20)
$form.Controls.Add($serverLabel)

# 服务器文本框，宽度增加一倍
$serverTextBox = New-Object Windows.Forms.TextBox
$serverTextBox.Location = New-Object Drawing.Point(100, 20)
$serverTextBox.Size = New-Object Drawing.Size(300, 20)  # 扩展输入框宽度
$form.Controls.Add($serverTextBox)

# 推流码标签
$publishLabel = New-Object Windows.Forms.Label
$publishLabel.Text = '推流码：'
$publishLabel.Location = New-Object Drawing.Point(10, 60)
$form.Controls.Add($publishLabel)

# 推流码文本框，宽度增加一倍
$publishTextBox = New-Object Windows.Forms.TextBox
$publishTextBox.Location = New-Object Drawing.Point(100, 60)
$publishTextBox.Size = New-Object Drawing.Size(300, 20)  # 扩展输入框宽度
$form.Controls.Add($publishTextBox)

# 复制按钮（服务器文本框）
$copyServerButton = New-Object Windows.Forms.Button
$copyServerButton.Text = '复制'
$copyServerButton.Location = New-Object Drawing.Point(410, 20)  # 调整复制按钮位置
$copyServerButton.Size = New-Object Drawing.Size(100, 30)  # 调整按钮大小
$form.Controls.Add($copyServerButton)

# 复制按钮（推流码文本框）
$copyPublishButton = New-Object Windows.Forms.Button
$copyPublishButton.Text = '复制'
$copyPublishButton.Location = New-Object Drawing.Point(410, 60)  # 调整复制按钮位置
$copyPublishButton.Size = New-Object Drawing.Size(100, 30)  # 调整按钮大小
$form.Controls.Add($copyPublishButton)

# 一键生成按钮
$generateButton = New-Object Windows.Forms.Button
$generateButton.Text = '一键生成'
$generateButton.Location = New-Object Drawing.Point(150, 100)
$generateButton.Size = New-Object Drawing.Size(100, 30)
$form.Controls.Add($generateButton)

# 复制按钮点击事件：将文本框中的内容复制到剪贴板
$copyServerButton.Add_Click({
    [System.Windows.Forms.Clipboard]::SetText($serverTextBox.Text)
})

$copyPublishButton.Add_Click({
    [System.Windows.Forms.Clipboard]::SetText($publishTextBox.Text)
})

# 按钮点击事件：执行 tShark 命令并提取 swfUrl 和 FCPublish
$generateButton.Add_Click({
    # 执行指令1，提取 swfUrl 字符串
    $swfUrl = tshark -r input.pcap -Y 'frame contains \"swfUrl\"' -T json | Select-String -Pattern "swfUrl" | ForEach-Object { if ($_ -match "Property 'swfUrl' String '([^']+)'") { $matches[1] } }

    # 执行指令2，提取 FCPublish 字符串
    $fcPublish = tshark -r input.pcap -Y 'frame contains \"FCPublish\"' | ForEach-Object { if ($_ -match "FCPublish\('([^']+)'\)") { $matches[1] } }

    # 填充文本框
    $serverTextBox.Text = $swfUrl
    $publishTextBox.Text = $fcPublish
})

# 显示窗口
$form.ShowDialog()
