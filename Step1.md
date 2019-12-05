# Image Searchの構築
###### 5min

注意：アカウントをお持ちでない方は本Stepを省略してください。

## Image Search
類似画像検索エンジンサービスです。事前に画像を登録することで、画像検索時に登録した画像の情報を類似度順で返却します。登録できる画像枚数と1秒間あたりのクエリ実行可能数でスペックが決まり、スペックごとに月額サブスクリプションの料金が決まります。

![Image Search](img/imagesearch.png)

## Image Searchの構築
Image Searchの有効化兼初期購入はアカウントでしかできない(RAMユーザでは購入不可)ため、ご自身のAlibaba Cloudアカウントで構築をします。
1. Alibaba CloudコンソールにアカウントIDでログインします
1. *ビックデータ* メニューの *Image Search* を選択します
1. 左上のリージョンから、各自に指定されたリージョンを選択します
1. 左のメニューから *商品画像検索インスタンス* を選択します
1. *インスタンスの作成* ボタンを押下します
1. 次の通り入力します
    1. *リージョン* : `指定されたリージョン`
    1. *検索タイプ* : `商品画像検索`
    1. *クエリ/秒* : `1クエリ/秒`
    1. *キャパシティ* : `10万枚`
    1. *インスタンス名* : `imagesearchhandson`
    1. *購入期間* : `1ヶ月`
1. *費用* が **¥.0.00 JPY** であることを確認します。**そうでない方はお知らせください**
1. *今すぐ購入* ボタンを押下します

## Image Searchの購入画面で中国語のページに飛んでしまった方へ
リージョンごとのImage Search購入URLから直接アクセスして、購入してください。
- 中国（香港）
    - https://common-buy-intl.alibabacloud.com/imagesearch/prepay?request=%7B%22region%22:%22cn-hongkong%22,%22serviceType%22:%220%22%7D#/buy
- シンガポール
    - https://common-buy-intl.alibabacloud.com/imagesearch/prepay?request=%7B%22region%22:%22ap-southeast-1%22,%22serviceType%22:%220%22%7D#/buy
- オーストラリア（シドニー）
    - https://common-buy-intl.alibabacloud.com/imagesearch/prepay?request=%7B%22region%22:%22ap-southeast-2%22,%22serviceType%22:%220%22%7D#/buy
- 日本（東京）
    - https://common-buy-intl.alibabacloud.com/imagesearch/prepay?request=%7B%22region%22:%22ap-northeast-1%22,%22serviceType%22:%220%22%7D#/buy

## 参考
- [Image Search公式ドキュメント](https://jp.alibabacloud.com/product/imagesearch)
- [ImageSearchデモツールを作って見た](https://www.sbcloud.co.jp/entry/2019/11/13/184025)
- [Alibaba Cloud「Image Search」でオリジナル画像検索エンジンを作ろう！](https://www.sbcloud.co.jp/entry/2018/08/06/imagesearch_001/)
- [Image SearchによるECサイト向け 類似画像検索のベストプラクティス](https://www.slideshare.net/sbcloud/image-searchec)


[戻る](Step0.md) | [次へ](Step2.md)
