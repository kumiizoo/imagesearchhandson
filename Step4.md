# [OSS]画像登録
###### 10min

このステップでは、Githubにある商品画像を、OSSに登録する工程を実施します。

## Notebookを起動
1. `http://<<ECSインスタンスのIPアドレス>>:8888/tree/home/jupyter/jupyter-working` にアクセスします。
1. 右上の *New* ボタンを押下し、*Python3* を選択します。
1. Notebookに名前 `uploadImages` をつけます。

## 画像登録
本ステップでは [item_data.csv](item_data.csv) を元に、OSSバケットに画像を登録します。以降、手順ごとにソースをNotebookのCellに貼っていき、*shift + Enter* をしてください。
1. 環境変数に値がセットされていることを確認します。`REGION`、`BUCKET_NAME`、`IMAGESEARCH_INSTANCE_NAME` について、[Step3](Step3.md)で設定した値が設定されていることを確認してください。
    ```
    # Checking ENV
    import os
    print('ACCESS_KEY_ID:' + os.environ['ACCESS_KEY_ID'])
    print('ACCESS_KEY_SECRET:' + os.environ['ACCESS_KEY_SECRET'])
    print('REGION:' + os.environ['REGION'])
    print('BUCKET_NAME:' + os.environ['BUCKET_NAME'])
    print('IMAGESEARCH_INSTANCE_NAME:' + os.environ['IMAGESEARCH_INSTANCE_NAME'])
    ```
1. 必要なライブラリを読み込みます。
    ```
    from aliyunsdkcore.client import AcsClient
    import oss2
    import pathlib
    import zipfile
    ```
1. 環境変数を読み込みます。
    ```
    # Setting ENV
    access_key_id = os.environ['ACCESS_KEY_ID']
    access_key_secret = os.environ['ACCESS_KEY_SECRET']
    region = os.environ['REGION']
    bucket_name = os.environ['BUCKET_NAME']
    ```
1. OSSクライアントをセットアップします。
    1. 説明
        1. `oss_endpoint` にはOSSバケットの外部ネットワーク向けエンドポイントの文字列が入っています。（例：`oss-ap-northeast-1.aliyuncs.com`）
        1. `auth` にはRAMユーザー `ImageSearchHandsOnUser` のアクセスキーとアクセスシークレットキーを元にした認証認可オブジェクトが入っています。
        1. `bucket` にはOSSバケットオブジェクトが入っています。
    1. コード
        ```
        # OSS Client
        oss_endpoint = 'oss-' + region + '.aliyuncs.com'
        auth = oss2.Auth(access_key_id, access_key_secret)
        bucket = oss2.Bucket(auth, oss_endpoint, bucket_name)
        ```
1. 画像情報をOSSバケットにアップロードします。
    1. コード
        ```
        # Uploading item data
        bucket.put_object_from_file('item_data.csv', 'item_data.csv')
        ```
    1. 実行結果例
        ```
        <oss2.models.PutObjectResult at 0x7f3b91c73c18>
        ```
1. 圧縮した画像を解凍し、画像をOSSバケットにアップロードします。720枚あるので10分程度かかります。
    1. コード
        ```
        with zipfile.ZipFile('item_image.zip') as existing_zip:
            existing_zip.extractall()

        p_temp = pathlib.Path('item_image')

        for file in list(p_temp.iterdir()):
            try:
                print(file)
                bucket.put_object_from_file(str(file), str(file))
            except Exception as e:
                print(e, 'error occurred')

        print('Uploading finish')
        ```
    1. 実行結果例
        ```
        item_image/isaw-company-7ID6oJrmePY-unsplash.jpg
        item_image/atul-vinayak-jKvwtbrxzdY-unsplash.jpg
        ...
        Uploading finish
        ```
1. （任意）アップロードした画像をOSSバケット上から確認します
    1. *ストレージとCDNメニュー* の *Object Storage Servicee* を選択します
    1. 左のメニューから *バケットリスト* を選択します
    1. `imagesearchhandson-<<氏名>>` を押下します
    1. メニューから *ファイル* を選択します
    1. `item_data.csv` と画像がアップデートされたことを確認します

## 参考
- [Alibaba Cloud公式OSS Python SDK](https://github.com/aliyun/aliyun-oss-python-sdk)
- [Alibaba Cloud公式Core Python SDK](https://github.com/aliyun/aliyun-openapi-python-sdk/tree/master/aliyun-python-sdk-core)
- [画像元 Unsplash](https://unsplash.com/)

[戻る](Step3.md) | [次へ](Step5.md)
