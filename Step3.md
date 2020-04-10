# インフラ構築
###### 20min

## Resource Orchestration Service(ROS)
Alibaba Cloudのサービスを自動構築するサービスです。テンプレートに沿って構築するサービスとリソース名を記載します。冪等性が考慮されているため、テンプレート更新後も実行することができ、更新内容がリソースに反映されます。

![ROS](img/ros.png)

## 構築するサービス
#### Virtual Private Cloud(VPC)
Alibaba Cloud上の仮想的なネットワーク空間です。VPC内にサーバーやデータベースを構築します。アカウントごとにVPCを構築することができ、他のサービスを使用して他のアカウントのVPCに接続することもできます。
#### Object Storage Service(OSS)
Alibaba Cloud上の仮想的なストレージサービスです。バケットと呼ばれる領域に、オブジェクトと呼ばれる画像・動画・ファイル等をアップロード、ダウンロードすることができます。バケットのデフォルトの公開範囲は外部非公開で、権限を持ったRAMユーザーやRAMロールでしかオブジェクトにアクセスができません。オブジェクトごとに有効期限付きの署名付きURLを発行すると、権限を持たないユーザーもオブジェクトにアクセスができます。バケット名はAlibaba Cloud全てでユニークである必要があります。月額でオブジェクトのアップロード総量とOSS APIの呼び出し回数に応じて課金がされます。
#### Elastic Compute Service(ECS)
Alibaba Cloud上の仮想的なサーバーです。CPU・メモリ・ディスク・通信速度等のスペックを自由に選択できます。スペックに比例した1時間ごとの従量課金と月額サブスクリプション料金体系があります。
###### セキュリティグループ
ECSインスタンスに設定できるファイアウォールサービスです。特定のIPやネットワークからの受信を許可・拒否することと特定のIPやネットワークへの送信を許可・拒否させることができます。 Webアプリのインフラ構成として、外部からの443ポートへの通信を許可するWebサーバーと、Webサーバーからの通信のみを許可するWebアプリサーバーと、Webアプリサーバーからの通信のみを許可するデータベースサーバーの構成が良く取られます。本ハンズオンではスムーズにImage Searchを使用してもらうために、外部からの22ポートと8888ポートを通信を許可するセキュリティグループを設定します。
###### Jupyter Notebook
PythonをGUIベースでインタラクティブに実行することができるオープンソースソフトウェアです。 機会学習や画像認識の処理を検証する際によく使用されます。本ハンズオンでは、ECSインスタンス上にJupyter Notebookを構築し、Jupyter NotebookからImage Searchに対して画像登録・検索・削除を行います。

#### RAM
[Step2](Step2.md)を参照してください。

## インフラ構築
1. *仮想サーバーサービス* メニューの *Resource Orchestration Service* を選択します
1. 左上のリージョンから指定されたリージョンを選択します
1. 左のメニューから *スタック* を選択します
1. *スタック の作成* ボタンを押下します
1. *既存のテンプレートを選択してください* ボタンを押下します
1. 次の通り入力します
    1. *テンプレートのインポート方法* : `テンプレート内容の入力`
    1. *テンプレート内容* : `YAML`
    1. *内容欄* : `ImageSearch-handson_ROS_yaml.txtをコピーして貼ります`
1. *次へ* ボタンを押下します
1. 次の通り入力します
    1. *スタック名* : `stack-imagesearchhandson`
    1. *RamAdminUserPassword* : `任意の文字列`
    1. *Region* : `指定されたリージョン`
    1. *Zone* : `指定されたリージョンのゾーン`
    1. *ImageSearchInstanceName* : `imagesearchhandson`
    1. *ECS Instance Type* : `ecs.t5-lc1m1.small`
    1. *RootPassword* : `任意の文字列`
    1. *OSSBucketName* : `imagesearchhandson-<<氏名>>`
1. *スタックの作成* ボタンを押下します
1. 次の通り入力します
1. `stack-imagesearchhandson` のステータスが *成功* になっていることを確認します
1. `stack-imagesearchhandson` を押下します
1. *outputs* タブを選択し、ECSインスタンスのIPアドレスをメモします
1. 画面右上の 公式サイト の右隣にある *Cloud Shell* アイコンボタンを押下します
1. ストレージスペース に関するモーダルの *スキップ* を選択
1. 次を入力し、ECSインスタンスにログインします
    ```
    ssh root@<<ECSインスタンスのIPアドレス>>
    Are you sure you want to continue connecting (yes/no)? >> yes
    root@<<ECSインスタンスのIPアドレス>>'s password: >> <<RootPasswordに設定した文字列>>
    ```
1. 次を入力し、Jupyter Notebookのtokenをメモします
    ```
    less /root/userdata-result.txt
    ```
1. 次を入力し、Cloud Shellからログアウトします
    ```
    exit
    ```
1. ブラウザから `http://<<ECSインスタンスのIPアドレス>>:8888` にアクセスし、メモした token を記入して、Jupyter Notebookにログインします
1. `home/jupyter/jupter-working` ディレクトリに移動します

## 参考
- [ROS公式ドキュメント](https://jp.alibabacloud.com/product/ros)
- [VPC公式ドキュメント](https://jp.alibabacloud.com/product/vpc)
- [OSS公式ドキュメント](https://jp.alibabacloud.com/product/oss)
- [ECS公式ドキュメント](https://jp.alibabacloud.com/product/ecs)


[戻る](Step2.md) | [次へ](Step4.md)
