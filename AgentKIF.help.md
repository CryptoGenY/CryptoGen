**AgentKIF
 ```
        _                    _   _  _____ _____ 
       / \   __ _  ___ _ __ | |_| |/ /_ _|  ___|
      / _ \ / _` |/ _ \ '_ \| __| ' / | || |_   
     / ___ \ (_) |  __/ | | | |_| . \ | ||  _|  
    /_/   \_\__, |\___|_| |_|\__|_|\_\___|_|    
            |___/    

```
Another utility that keeps ids worked!

AgentKif is a utility for performing various operations such as credential management, safe operations, compression, cryptography, blockchain transactions.
A monitoring status is possible
## Usage
AgentKif does not use prefixed parameters
```
hlp         Full help    agentkif hlp [cal|sfe|chy|bin|sus]
cls         clean        Clear screen
cal         credential   Credentials operations 
sfe         safe         Safe operations
con         Compression  Compression operations
chy         cryptography Ciphering operations
bin         blockchain   transaction records operations
sus         status       Send a monitoring status
kll         kill         Terminate 'agentkif' process
```

### Displaying Help
To display help information, run the following command:
```
AgentKif            [help|hlp]              partial help
AgentKif hlp        [cal|sfe|chy|bin|sus]   detailed cmd help
```
### Chaining agentkif commands in a script
```
        -       -       -       chy     bin
        -       -       con     chy     bin
        cal     sfe     -       -       bin
        cal     sfe     -       chy     bin
        cal     sfe     con     chy     bin
        cal     sfe     con     chy     -
        cal     sfe     con     -       -
        cal     sfe     -       -       -
        cal     -       -       -       -
```
```
can send debug      sus
must be used alone  cls,kll
```
### Credentials Operations
Formating inputs :
```
 TenantId       12345678-9abc-def0-1234-56789abcdef0 | mytenantname.onmicrosoft.com
 SubscriptionId 12345678-9abc-def0-1234-56789abcdef0
 UserOrSP       User | SP
 ClientId       12345678-9abc-def0-1234-56789abcdef0
 Username       myuser@mytenant.ext
 Password       MyP@ssword
```
CRUD operations Syntaxe :
```
 agentkif cal c "drive:\folder\id.cred" "tenantname.oncloud.net" "12345678-9abc-def0-1234-56789abcdef0" User "12345678-9abc-def0-1234-56789abcdef0" "myuser@mytenant.ext" "MyP@ssword"
 agentkif cal r "drive:\folder\id.cred"
 agentkif cal u "drive:\folder\id.cred" ValueToReplace NewValue
 agentkif cal d "drive:\folder\id.cred"
```
### Safe Operations
```
  agentkif sfe c JsonFullpath
  agentkif sfe r SafeFullpath SafePassword
  agentkif sfe u SafeFullpath SafePassword
  agentkif sfe d SafeFullpath SafePassword
```
 The term 'update' is employed to rotate the password regularly for security purposes.
 The safe is a automatically created with .safe extension with the jsonfile directory.
### Compression Operations (folder only)
```
  agentkif con c folderFullPath destinationFileFullPath
  agentkif con r fullpathCompressedFile
  agentkif con u fullpathCompressedFile destinationFolderPath (original folder will be generated)
  agentkif con d fullpathCompressedFile
```
### Cryptography Operations
```
  agentkif chy c FileFullpath
  agentkif chy r EncryptedFileFullpath EncryptedFilePassword
  agentkif chy u EncryptedFileFullpath EncryptedFilePassword
  agentkif chy d FileFullpath EncryptedFilePassword
```
### Blockchain Operations

Offline transactions in the context of blockchain usually involve creating a transaction without being connected to the internet or the broader blockchain network. Here are the steps involved in an offline blockchain transaction:

1. [TC] Transaction Creation:
   - Offline Environment: The transaction is created in an offline environment, ensuring that the transaction details are not transmitted over the internet.

2. [TD] Transaction Details:
   - Sender and Receiver Information: The necessary details, 'sender Machine ID', 'reciever Machine ID', 'volume', are included in the transaction.

3. [DS] Digital Signature:
   - Offline Signing: The sender uses their private key to generate a digital signature for the transaction offline, providing proof of ownership and authenticity.

4. [TDS] Transaction Data Storage:
   - Secure Storage: The signed transaction data is stored securely, either on a hardware wallet or another offline storage medium.

5. [OT] Offline Transmission:
   - Physical Medium: The signed transaction data can be physically transported or transmitted through a secure channel to a device connected to the internet.

6. [OB] signed transaction data Broadcasting :
   - Broadcast signed transaction data (file.transac)

7. [TV] Transaction Verification:
   - Validation by Nodes: Network nodes validate the transaction using the digital signature and ensure that the sender's public key corresponds to the private key used for signing.

8. [CM] Consensus Mechanism:
   - Validation Process: The transaction goes through the standard consensus mechanism, where nodes agree on the legitimacy of the transaction and compete to add it to the blockchain.

9. [BC] Block Confirmation:
   - Block Confirmation: The transaction is confirmed and added to a block, which is then added to the blockchain.

A. [LU] Ledger Update:
    - Updating Ledger: The blockchain's distributed ledger is updated to reflect the new transaction, showing the transfer of data from the sender to the recipient.

B. [FI] Finality:
    - Irreversibility: As with online transactions, offline transactions become irreversible once added to the blockchain.

It's crucial to handle the offline transmission and storage of the transaction data securely to prevent tampering or unauthorized access. The offline signing process is a key security feature in this context.
Additionally, the specifics may vary depending on the blockchain platform and its supported features.

Delete Operation supress the transaction and data files after extracting the files.
Update operation is not implemented yet
```
agentkif bin c recieverMachineID FileToSendFullpath
AgentKif bin r senderMachineID FileRecievedFullpath.transac key FileRecievedFullpath.data key
AgentKif bin u 
AgentKif bin d senderMachineID FileRecievedFullpath.transac key FileRecievedFullpath.data key
```
'mid' operation retrieve the machine id
```
agentkif bin mid
```
### Monitoring Status

Generate a monitoring output for monitoring systems
```
AgentKif sus [ok|warning|error] [Optional comment]
```
