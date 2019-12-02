# VPCの構築

## Virtual Private Cloud(VPC)
Alibaba Cloud上の仮想的なネットワーク空間です。VPC内にサーバーやデータベースを構築します。アカウントごとにVPCを構築することができ、他のサービスを使用して他のアカウントのVPCに接続することもできます。

![VPC](img/vpc.png)

## VPCの構築
1. *ネットワークサービス* メニューの *Virtual Private Cloud* を選択します
1. 左上のリージョンから指定されたリージョンを選択します
1. 左のメニューから *VPCs* を選択します
1. *VPC の作成* ボタンを押下します
1. 次の通り入力します
  * VPC
    * *名前* : `vpc-imagesearchhandson`
    * *IPv4 CIDR ブロック* : `10.0.0.0/8`
  * VSwitch
    * *名前* : `vswitch-imagesearchhandson`
    * *ゾーン*
      * *中国（香港）* : `Hong Kong Zone B`
      * *シンガポール* : `Singapore Zone A`
      * *オーストラリア（シドニー）* : `Sydney Zone A`
      * *日本（東京）* : `Tokyo Zone A`
    * *IPv4 CIDR ブロック* : `10.0.0.0/24`
1. *OK* ボタンを押下します
1. *完了* ボタンを押下します

## 参考
- [VPC公式ドキュメント](https://jp.alibabacloud.com/product/vpc)

[戻る](Step1.md) | [次へ](Step3.md)
