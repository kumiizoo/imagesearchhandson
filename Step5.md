# [Image Search]画像登録
###### 15min

## Notebookを起動
1. `http://<<ECSインスタンスのIPアドレス>>:8888/tree/home/jupyter/jupyter-working` にアクセスします。
1. 右上の *New* ボタンを押下し、*Python3* を選択します。
1. Notebookに名前 `registerImages` をつけます。

## 画像登録
本ステップでは [item_data.csv](item_data.csv) を元に、Image Searchに画像を登録します。
以降、手順ごとにソースをNotebookのCellに貼っていき、*shift + Enter* をしてください。
1. 必要なライブラリを読み込みます。
    ```
    from aliyunsdkcore.client import AcsClient
    import base64
    import csv
    import time
    import oss2
    import os
    import aliyunsdkimagesearch.request.v20190325.AddImageRequest as AddImageRequest
    ```
1. 環境変数を読み込みます。
    ```
    # Setting ENV
    access_key_id = os.environ['ACCESS_KEY_ID']
    access_key_secret = os.environ['ACCESS_KEY_SECRET']
    region = os.environ['REGION']
    bucket_name = os.environ['BUCKET_NAME']
    imagesearch_instance_name = os.environ['IMAGESEARCH_INSTANCE_NAME']
    ```
1. OSSクライアントをセットアップします。
    ```
    # OSS
    oss_endpoint = 'oss-' + region + '.aliyuncs.com'
    auth = oss2.Auth(access_key_id, access_key_secret)
    bucket = oss2.Bucket(auth, oss_endpoint, bucket_name)
    ```
1. Image Searchクライアントをセットアップします。
    1. `imagesearch_endpoint` にはImage Searchのエンドポイントの文字列が入っています。（例：`imagesearch.ap-northeast-1.aliyuncs.com`）
    1. `client` にはImage Searchクライアントオブジェクトが入っています。
    ```
    # Image Search
    imagesearch_endpoint = 'imagesearch.' + region + '.aliyuncs.com'
    client = AcsClient(access_key_id, access_key_secret, region)
    ```
1. 画像登録関数 `register_images` を定義します。主な処理内容は以下の通りです。
    1. `item_data.csv` をOSSバケットからダウンロードします。
    1. `item_data.csv` を1行1カラムずつ読み込み、変数にセットします。
    1. 各変数に入っている値の例を上げます。
    |変数名|値|意味|
    |:---|:---|:---|
    |`object_path`|`item_image/015591b0-d38d-30ce-131a-fab83a13cbf3.jpg`|OSSバケット上の画像置き場|
    |`product_id`|`015591b0-d38d-30ce-131a-fab83a13cbf3`|商品ID|
    |`picture_name`|`015591b0-d38d-30ce-131a-fab83a13cbf3`|画像名|
    |`category_id`|`4`|画像カテゴリID|
    |`int_attr`|`2000`|整数型属性（価格として設定）|
    |`str_att`|`SB and 1`|文字列型属性（ブランド名として設定）|
    |`custom_content`|`"{""color"": ""0078FF""}"`|カスタムコンテンツ（カラーコードとして設定）|
    |`encoded_pic_content`|`data:image/jpeg;base64,/9j/4AAQ...`|Base64でエンコードした画像|
    1. [画像登録に必要なパラメータ](https://jp.alibabacloud.com/help/doc-detail/113679.htm)をHTTPリクエストにセットし、画像登録HTTPリクエストを送ります。
    1. 1秒間に実行可能なクエリが1クエリであるため、1秒間スリープします。
    ```
    # Registering images
    def register_images(item_data_file_name):
        try:
            csv_str = bucket.get_object(item_data_file_name).read().decode('utf-8')
            reader = csv.reader(csv_str.strip().splitlines())
            header = next(reader)

            for row in reader:

                object_path = row[0]
                product_id = row[1]
                picture_name = row[2]
                category_id = row[3]
                int_attr = row[4]
                str_att = row[5]
                custom_content = row[6]

                print('object_path:' + object_path)
                print('product_id:' + product_id)
                print('picture_name:' + picture_name)
                print('category_id:' + category_id)
                print('int_attr:' + int_attr)
                print('str_att:' + str_att)
                print('custom_content:' + custom_content)

                request = AddImageRequest.AddImageRequest()
                request.set_endpoint(imagesearch_endpoint)
                request.set_InstanceName(imagesearch_instance_name)
                request.set_ProductId(product_id)
                request.set_PicName(picture_name)
                request.set_CategoryId(category_id)
                request.set_IntAttr(int_attr)
                request.set_StrAttr(str_att)
                request.set_CustomContent(custom_content)
                encoded_pic_content = base64.b64encode(bucket.get_object(key=object_path,process='image/resize,l_512').read())
                request.set_PicContent(encoded_pic_content)

                response = client.do_action_with_exception(request)
                print(response)

                time.sleep(1)

            print('Registering finish')
        except Exception as e:
            print(e, 'error occurred')
    ```
1. 画像登録関数 `register_images` を呼びます。720枚あるので12分程度かかります。
    ```
    register_images('item_data.csv')
    ```
    1. 実行結果例
        ```
        object_path:item_image/015591b0-d38d-30ce-131a-fab83a13cbf3.jpg
        product_id:015591b0-d38d-30ce-131a-fab83a13cbf3
        picture_name:015591b0-d38d-30ce-131a-fab83a13cbf3
        category_id:4
        int_attr:2000
        str_att:SB and 1
        custom_content:{"color": "0078FF"}
        b'{"Message":"success","PicInfo":{"CategoryId":4,"Region":"95,386,517,895"},"RequestId":"F4527A98-F016-4361-8504-58F4D3A454F9","Success":true,"Code":0}'
        ...
        Registering finish
        ```
1. （任意）Image Searchに登録された画像枚数を確認します
    1. *ビックデータ* メニューの *Image Search* を選択します
    1. 左上のリージョンから、各自に指定されたリージョンを選択します
    1. 左のメニューから *商品画像検索インスタンス* を選択します
    1. `imagesearchhandson` を選択します
    1. *画像枚数* が *画像枚数のリフレッシュ* をするごとに、増加することを確認します

## 参考
- [Alibaba Cloud公式Image Search Python SDK](https://github.com/aliyun/aliyun-openapi-python-sdk/tree/master/aliyun-python-sdk-imagesearch)

[戻る](Step4.md) | [次へ](Step6.md)
