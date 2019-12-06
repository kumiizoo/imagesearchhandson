# OSSに画像登録
###### 10min

## Notebookを起動
1. `http://<<IPアドレス(インターネット)>>:8888/tree/home/jupyter/jupyter-working` にアクセスします
1. 右上の *New* ボタンを押下し、*Python3* を選択します
1. Notebookに名前 `uploadImages` をつけます
    1. 注意：アカウントをお持ちでない方はNotebookに名前 `uploadImages-任意の文字列` をつけてください

## 画像登録
以降、手順ごとにソースをNotebookのCellに貼っていき、*shift + Enter* をしてください。
1. 環境変数に正しい値がセットされていることを確認します。値が合っていることを確認してください。
    ```
    # Checking ENV
    import os
    print('ACCESS_KEY_ID:' + os.environ['ACCESS_KEY_ID'])
    print('ACCESS_KEY_SECRET:' + os.environ['ACCESS_KEY_SECRET'])
    print('REGION:' + os.environ['REGION'])
    print('BUCKET_NAME:' + os.environ['BUCKET_NAME'])
    print('IMAGESEARCH_INSTANCE_NAME:' + os.environ['IMAGESEARCH_INSTANCE_NAME'])
    ```
1. 必要なライブラリを読み込みます
    ```
    from aliyunsdkcore.client import AcsClient
    import oss2
    import os
    import pathlib
    import zipfile
    ```
1. 環境変数を読み込みます
    ```
    # Setting ENV
    access_key_id = os.environ['ACCESS_KEY_ID']
    access_key_secret = os.environ['ACCESS_KEY_SECRET']
    region = os.environ['REGION']
    bucket_name = os.environ['BUCKET_NAME']
    ```
1. OSSクライアントをセットアップします
    ```
    # OSS
    oss_endpoint = 'oss-' + region + '.aliyuncs.com'
    auth = oss2.Auth(access_key_id, access_key_secret)
    bucket = oss2.Bucket(auth, oss_endpoint, bucket_name)
    ```
1. 画像情報をアップロードします
    ```
    # Uploading item data
    bucket.put_object_from_file('item_data.csv', 'item_data.csv')
    ```
    1. 実行結果例
        ```
        <oss2.models.PutObjectResult at 0x7f3b91c73c18>
        ```
1. 画像をアップロードします。720枚あるのでやや時間がかかります。
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

## 参考
- [Alibaba Cloud公式OSS Python SDK](https://github.com/aliyun/aliyun-oss-python-sdk)
- [Alibaba Cloud公式Core Python SDK](https://github.com/aliyun/aliyun-openapi-python-sdk/tree/master/aliyun-python-sdk-core)
- [画像元 Unsplash](https://unsplash.com/)

[戻る](Step6.md) | [次へ](Step8.md)
