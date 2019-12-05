# Image Searchに追加で画像登録
###### 15min

## Notebookを起動
1. `http://<<IPアドレス(インターネット)>>:8888/tree/home/jupyter/jupyter-working` にアクセスします
1. 右上の *New* ボタンを押下し、*Python3* を選択します
1. Notebookに名前 `registerImagesPlus` をつけます
    1. 注意：アカウントをお持ちでない方はNotebookに名前 `registerImagesPlus-任意の文字列` をつけてください

## 追加画像登録
以降、手順ごとにソースをNotebookのCellに貼っていき、*shift + Enter* をしてください。
1. 必要なライブラリを読み込みます
    ```
    from IPython.display import display
    from ipywidgets import interact
    from aliyunsdkcore.client import AcsClient
    from PIL import Image
    from io import BytesIO
    import ipywidgets as widgets
    import base64
    import os
    import oss2
    import fileupload
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
    oss_endpoint = 'oss-' + region + '.aliyuncs.com'
    auth = oss2.Auth(access_key_id, access_key_secret)
    bucket = oss2.Bucket(auth, oss_endpoint, bucket_name)
    ```
1. Image Searchクライアントをセットアップします
    ```
    # Image Search
    imagesearch_endpoint = 'imagesearch.' + region + '.aliyuncs.com'
    client = AcsClient(access_key_id, access_key_secret, region)
    ```
    **注意：自信のアカウントを持ち、[Step1](Step1.md)でImage Searchを購入しなかった方は以下を実行してください。**
    ```
    # Image Search
    alternative_region = 'ap-southeast-2'
    alternative_access_key_id = '紙でお渡しします'
    alternative_access_key_secret = '紙でお渡しします'
    imagesearch_endpoint = 'imagesearch.' + alternative_region + '.aliyuncs.com'
    client = AcsClient(alternative_access_key_id, alternative_access_key_secret, alternative_region)
    ```
1. 画像アップロードフォームを作ります。実行後、フォームが表示されるので画像を１枚アップロードしてください。アップロード後の再実行は不要です。アップロード後は画像が表示されます。
    ```
    # Uploding Image
    original_image = ''
    image_name = ''
    def _on_upload(change):
        global image_name
        global original_image

        b = change['owner']
        image_name = b.filename
        image = Image.open(BytesIO(b.data))

        w, h = image.size
        if w > h:
            w = 512
            h = int(round(image.height * w / image.width))
            original_image = image.resize((w, h))
        else:
            h = 512
            w = int(round(image.width * h / image.height))
            original_image = image.resize((w, h))
        display(original_image)
    uploader = fileupload.FileUploadWidget()
    display(uploader)
    uploader.observe(_on_upload, names='data')
    ```
1. 画像をトリミングします。実行後、左上を原点とした *x1, y1* と右下を原点とした *x2, y2* のつまみ4つと画像が表示されるので好きにトリミングしてください。トリミング後の再実行は不要です。
    ```
    # Cropping Image
    cropped_image = ''
    @interact(x1=(0, original_image.width, 1), y1=(0, original_image.height, 1), x2=(0, original_image.width, 1), y2=(0, original_image.height, 1))
    def _crop(x1=0, y1=0, x2=original_image.width, y2=original_image.height):
        global original_image
        global cropped_image

        cropped_image = original_image.crop((x1, y1, x2, y2))
        display(cropped_image)
    ```
1. 画像にカテゴリを付与します。実行後、プルダウンが表示されるので好きに調節してください。調節後の再実行は不要です。
    ```
    # Selecting Category
    category_id = -1
    def select_category_id(Category):
        global category_id
        category_id = Category
    interact(select_category_id, Category=widgets.Dropdown[('Tops', 0), ('Dresses', 1), ('Bottoms', 2), ('Bags', 3), ('Shoes', 4), ('Accessories', 5), ('Snacks', 6), ('Makeup', 7), ('Bottle drinks', 8), ('Furniture', 9), ('Toys', 20), ('Underwears', 21), ('Digital devices', 22), ('Others', 88888888)]);
    ```    
1. 画像に文字列属性（文字列属性をブランド名として定義）を付与します。実行後、プルダウンが表示されるので好きに調節してください。調節後の再実行は不要です。
    ```
    # Selecting Brand
    str_attr = ''
    def select_str_attr(Brand):
        global str_attr
        str_attr = Brand
    interact(select_str_attr, Brand=['', 'SB and 1', 'sb and 11', 'sb and sbc', 'sbc', 'SBC']);
    ```
1. 画像に数値属性（数値属性を値段とし定義）を付与します。実行後、つまみが表示されるので好きに調節してください。調節後の再実行は不要です。
    ```
    # Selecting Price
    int_attr = 0
    def select_int_attr(Price):
        global int_attr
        int_attr = Price
        low_price, high_price = int_attr
        print('¥' + str(low_price) + ' ~ ' + '¥' + str(high_price))
    interact(select_int_attr, Price=widgets.IntRangeSlider(min=0, max=5000, step=1000, value=[0,5000]));
    ```
1. 画像登録を定義します。実行後に *register* ボタンが表示されるので押下してください。OSSへの画像登録とImage Searchに画像登録リクエストを送ります。
    ```
    api_result = ''
    def _on_button_clicked(change):
        global api_result

        try:
            # Sending request to OSS
            buf = BytesIO()
            cropped_image.save(buf, format='jpeg')    
            bucket.put_object(image_name, buf.getvalue())

            # Sending request to Image Search
            # image       
            encoded_pic_content = base64.b64encode(buf.getvalue())

            # sending request
            request = AddImageRequest.AddImageRequest()
            request.set_endpoint(imagesearch_endpoint)
            request.set_InstanceName(imagesearch_instance_name)
            request.set_ProductId(image_name)
            request.set_PicName(image_name)
            if category_id != -1:
              request.set_CategoryId(category_id)
            request.set_IntAttr(int_attr)
            if str_att != '':
              request.set_StrAttr(str_att)
            request.set_PicContent(encoded_pic_content)
            response = client.do_action_with_exception(request)
            api_result = response
            print('API Response:')
            print(api_result)

        except Exception as e:
            print(e, 'error occurred')        
    button = widgets.Button(description="register")
    display(button)
    button.on_click(_on_button_clicked)
    ```
1. Image Searchのレスポンスを整形して、レスポンス結果をまとめます
    ```
    # ETL
    dict_data = json.loads(api_result)
    x1, x2, y1, y2 = [int(t) for t in dict_data['PicInfo']['Region'].split(',')]
    print('Result:')
    print(x1, y1, x2, y2)
    display(cropped_image.crop((x1, y1, x2, y2)))
    ```


[目次へ](README.md)
