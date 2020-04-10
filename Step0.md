# インフラ構成
###### 5min

## インフラ構成図
本ハンズオンでは、Alibaba Cloud日本サイト上に、Image Search、画像検索を行うアプリのECSサーバー、画像置き場のOSSを構築します。

Image Searchは類似する画像の情報（類似度、画像ファイル名、メタデータ）を保持するサービスであるため、類似画像をユーザーに表示させる場合、画像を保存する場所が必要となります。一般的な画像アプリは、画像枚数が多くなることを前提に、アプリサーバーの負荷軽減と冗長性を考慮して、アプリサーバーとは別の場所に画像を保存をします。今回はストレージサービスであるOSSを使用します。

Image Searchに集中してもらうため、構築は全てブラウザ上から行います。Image Search構築と管理者権限を持つRAMユーザー作成以外はROSによる自動構築をします。[Step1](Step1.md)から[Step3](Step3.md)までがインフラ構築となります。

![インフラ構成図](img/ali-infra.png)


## リージョン
ネットワークのレイテンシーを短縮するために世界各地に展開されている物理的な場所 (データセンターの集合) です。本ハンズオンでは複数のリージョンに分散してインフラ構築をしてもらいます。使用するリージョンは次の通りです。事前にお配りした色付きの付箋に沿って、リージョンを選択してください。

| リージョン名 | 英語表記 | 付箋の色 |
|:-----:|:------------:|:------------:|
| 中国（香港） | cn-hongkong | ピンク色 |
| シンガポール | ap-southeast-1 | 黄色 |
| オーストラリア（シドニー） | ap-southeast-2 | 緑色 |
| 日本（東京） | ap-northeast-1 | 青色 |

## 参考
- [【初心者向け】AlibabaCloud入門 ークラウドはじめの一歩](https://www.slideshare.net/sbcloud/alibabacloud)
- [Alibaba Cloudセキュリティベストプラクティス](https://www.slideshare.net/sbcloud/alibaba-cloud)
- [Alibaba Cloudアイコン集](https://www.alibabacloud.com/help/doc-detail/67830.htm)
- [Alibaba Cloudリージョンとゾーン](https://jp.alibabacloud.com/help/doc-detail/40654.htm)

[戻る](README.md) | [次へ](Step1.md)
