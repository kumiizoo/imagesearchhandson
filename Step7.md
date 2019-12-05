# OSSに画像登録
###### 10min

## Notebookを起動
1. `http://<<IPアドレス(インターネット)>>:8888/tree/home/jupyter/jupyter-working` にアクセスします
1. 右上の *New* ボタンを押下し、*Python3* を選択します
1. Notebookに名前 `uploadImages` をつけます
    1. 注意：アカウントをお持ちでない方はNotebookに名前 `uploadImages-任意の文字列` をつけてください

## 画像登録
以降、手順ごとにソースをNotebookのCellに貼っていき、*shift + Enter* をしてください。
1. 必要なライブラリを読み込みます
    ```
    from aliyunsdkcore.client import AcsClient
    import oss2
    import os
    import pathlib
    import pprint
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
1. 画像をアップロードします
    ```
    with zipfile.ZipFile('item_image.zip') as existing_zip:
        existing_zip.extractall()
    p_temp = pathlib.Path('item_image')
    pprint.pprint(list(p_temp.iterdir()))
    for file in list(p_temp.iterdir()):
        try:
            bucket.put_object_from_file(str(file), str(file))
        except Exception as e:
            print(e, 'error occurred')
    ```
    1. 実行結果例
        ```
        [PosixPath('item_images/36b3147a-2323-309c-1a8d-fe401b060a98.jpg'),
         PosixPath('item_images/43229f01-3c41-6c12-3e46-f10512829783.jpg'),
         PosixPath('item_images/b9ecf850-cf1b-3ae2-9ae4-c9446c9f8db2.jpg'),
         PosixPath('item_images/4202d137-cf32-ae98-de80-f1d515440713.jpg'),
         PosixPath('item_images/f2b45adc-4023-009a-6068-dbd57678f2f2.jpg'),
        ```

## 参考
- [Alibaba Cloud公式OSS Python SDK](https://github.com/aliyun/aliyun-oss-python-sdk)
- [Alibaba Cloud公式Core Python SDK](https://github.com/aliyun/aliyun-openapi-python-sdk/tree/master/aliyun-python-sdk-core)
- [画像元 Unsplash](https://unsplash.com/)

[戻る](Step6.md) | [次へ](Step8.md)
