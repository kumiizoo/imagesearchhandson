# Image Searchに画像削除

## Notebookを起動
1. `http://<<IPアドレス(インターネット)>>:8888/tree/home/jupyter/jupyter-working` にアクセスします
1. 右上の *New* ボタンを押下し、*Python3* を選択します
1. Notebookに名前 `deleteImages` をつけます

## 画像削除
以降、手順ごとにソースをNotebookのCellに貼っていき、*shift + Enter* をしてください。
1. 必要なライブラリを読み込みます
```
from aliyunsdkcore.client import AcsClient
import csv
import time
import oss2
import os
import aliyunsdkimagesearch.request.v20190325.DeleteImageRequest as DeleteImageRequest
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
item_data_file_name = 'item_data.csv'
```
1. Image Searchクライアントをセットアップします
```
# Image Search
imagesearch_endpoint = 'imagesearch.' + region + '.aliyuncs.com'
client = AcsClient(access_key_id, access_key_secret, region)
```
1. 画像削除をします
```
# Deleting images
try:
    csv_str = bucket.get_object(item_data_file_name).read().decode('utf-8')
    reader = csv.reader(csv_str.strip().splitlines())
    header = next(reader)

    for row in reader:
        product_id = row[1]
        picture_name = row[2]
        print('product_id:' + product_id)
        print('picture_name:' + picture_name)

        request = DeleteImageRequest.DeleteImageRequest()
        request.set_endpoint(imagesearch_endpoint)
        request.set_InstanceName(imagesearch_instance_name)
        request.set_ProductId(product_id)
        request.set_PicName(picture_name)
        response = client.do_action_with_exception(request)
        print(response)
        time.sleep(1)
except Exception as e:
    print(e, 'error occurred')
```
  * 実行結果例
```
product_id:015591b0-d38d-30ce-131a-fab83a13cbf3
picture_name:015591b0-d38d-30ce-131a-fab83a13cbf3
b'{"Message":"success","RequestId":"9A7F8BAB-F3D1-44C3-B3D5-3BE76C30F03D","Success":true,"Code":0}'
```


[戻る](Step9.md) | [次へ](Step11.md)
