## 合约说明
### TestNFT721合约 0x2F7e423eE727aBe5988A92c83722461CbB
用于调试
### 写入接口 setBaseURI
设置NFT链接的网关
### 参数 
    uri     NFT的网关地址，拼接tokenId作为NFT的链接，string类型
### 返回   
    无
<br>

### 写入接口 safeMint
铸造NFT
### 参数 
    account     铸造给谁，address类型  
    tokenId     NFT的唯一id，uint256类型  
### 返回   
    无
<br>

### 写入接口 createDrop
创建一批空投，批次从1自增
### 参数 
    info        一批空投的描述，主要用于前端展示，string类型  
    merkleRoot  这批空投的merkleRoot，string类型  
### 返回   
    无
<br>

### 写入接口 claim
用户来领取NFT空投
### 参数 
    dropId      要领取的空投的批次Id，uint256类型 
    tokenId     要领取的NFT的tokenId，uint256类型 
    proof       默克尔树的证明，string数组
### 返回   
    无
<br>

### 读取接口 tokenURI
查询某个NFT的http链接
### 参数 
    tokenId     NFT的tokenId，uint256类型 
### 返回 
    uri     NFT的http链接，string类型
<br>

### 读取接口 ownerOf
查询某个NFT的持有人是谁
### 参数 
    tokenId     NFT的tokenId，uint256类型 
### 返回 
    account     NFT的拥有者，address类型
<br>

### 读取接口 balanceOf
查询某个用户名下有多少个NFT
### 参数 
    account     NFT的拥有者，address类型
### 返回 
    balance     该用户拥有多少个NFT
<br>
