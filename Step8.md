# Image Searchに画像登録
###### 15min

## Notebookを起動
1. `http://<<IPアドレス(インターネット)>>:8888/tree/home/jupyter/jupyter-working` にアクセスします
1. 右上の *New* ボタンを押下し、*Python3* を選択します
1. Notebookに名前 `registerImages` をつけます
    1. 注意：アカウントをお持ちでない方はNotebookに名前 `registerImages-任意の文字列` をつけてください

## 画像登録
以降、手順ごとにソースをNotebookのCellに貼っていき、*shift + Enter* をしてください。
1. 必要なライブラリを読み込みます
    ```
    from aliyunsdkcore.client import AcsClient
    import base64
    import csv
    import time
    import oss2
    import os
    import aliyunsdkimagesearch.request.v20190325.AddImageRequest as AddImageRequest
    ```
1. 環境変数を読み込みます
    ```
    # Setting ENV
    access_key_id = os.environ['ACCESS_KEY_ID']
    access_key_secret = os.environ['ACCESS_KEY_SECRET']
    region = os.environ['REGION']
    bucket_name = os.environ['BUCKET_NAME']
    imagesearch_instance_name = os.environ['IMAGESEARCH_INSTANCE_NAME']
    ```
1. OSSクライアントをセットアップします
    ```
    # OSS
    oss_endpoint = 'oss-' + region + '-internal.aliyuncs.com'
    auth = oss2.Auth(access_key_id, access_key_secret)
    bucket = oss2.Bucket(auth, oss_endpoint, bucket_name)
    ```
1. Image Searchクライアントをセットアップします
    ```
    # Image Search
    imagesearch_endpoint = 'imagesearch.' + region + '.aliyuncs.com'
    client = AcsClient(access_key_id, access_key_secret, region)

    ```
1. 画像登録関数を定義します
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
                encoded_pic_content = base64.b64encode(bucket.get_object(key=object_path,process='image/resize,l_1024').read())
                request.set_PicContent(encoded_pic_content)
                response = client.do_action_with_exception(request)
                print(response)
                time.sleep(1)

        except Exception as e:
            print(e, 'error occurred')
    ```
1. 画像情報ファイルを元に画像登録をします
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
        ```

## 参考
- [Alibaba Cloud公式Image Search Python SDK](https://github.com/aliyun/aliyun-openapi-python-sdk/tree/master/aliyun-python-sdk-imagesearch)


[戻る](Step7.md) | [次へ](Step9.md)
