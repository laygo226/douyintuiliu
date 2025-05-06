# douyintuiliu
基于软件Wireshark一键获取抖音直播助手开播后的推流码

1.Wireshark软件需要自行下载并且在系统的环境变量path内添加Wireshark安装根目录实现tshark可以执行
Wireshark下载地址:  https://www.wireshark.org/download.html

2.获取抖音推流码.ps1文件内的第三行指令中的网卡需要改成自己的网卡信息
Start-Process -NoNewWindow -FilePath 'tshark' -ArgumentList '-i "<\Device\NPF_{AEEDC85A-6D5C-4251-BEE6-2D6319DEF155}>" -f "tcp port 80 or tcp port 1935" -w input.pcap'
    自己网卡信息可以通过    tshark -D   来列出

3.最后可以将ps1文件打包成exe执行
    通过以下命令从 PowerShell Gallery 安装 PS2EXE 模块：Install-Module -Name ps2exe(管理员身份运行powershell)
    在安装好 PS2EXE 后，使用以下命令将 PowerShell 脚本转换为 .exe 文件：
        ps2exe .\your_script.ps1 .\your_program.exe
    
    如果PS2EXE安装错误，检查策略
        1.右键点击 PowerShell 快捷方式，选择 “以管理员身份运行”。
        2.在管理员 PowerShell 中输入以下命令，查看当前的执行策略：Get-ExecutionPolicy，可能返回的是 Restricted 或 AllSigned，这意味着脚本的执行受到了限制。
        3.修改执行策略，输入以下命令来更改执行策略：Set-ExecutionPolicy RemoteSigned -Scope CurrentUser 或者 Set-ExecutionPolicy Unrestricted -Scope CurrentUser
            RemoteSigned 允许运行本地脚本，但要求远程脚本（从互联网下载的）必须是签名的
            Unrestricted 允许运行所有脚本，不论来源
        4.确认执行策略更改:Get-ExecutionPolicy
            如果返回 RemoteSigned 或 Unrestricted，说明设置已生效。
        5.重新导入 PS2EXE 模块:Install-Module -Name ps2exe
