## CryptoGen

download the core setup program from powershell
```
$urx  ="https://github.com/CryptoGenY/CryptoGen/blob/main/install-CryptoGen.ps1"
$psx = "install-CryptoGen.ps1"
Invoke-WebRequest -Uri $urx -OutFile $psx
```

# AgentKIF

* AgentKIF allows for the transfer of offline data using a blockchain transaction file and a separate data file, both of which can be copied independently.
```mermaid
graph LR
    A((Sender)) -- Transaction File --> B(Path A)
    A -- Data File --> C(Path B)
    B -- Transaction File --> D((Reciever))
    C -- Data File --> D
```
* Setup on windows
&emsp;https://github.com/CryptoGenY/CryptoGen/tree/main/AgentKIF.setup.md

* Help
&emsp;https://github.com/CryptoGenY/CryptoGen/tree/main/AgentKIF.help.md
  


