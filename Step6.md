# Jupyter Notebookの構築
###### 20min

注意：アカウントをお持ちでない方は本Stepを省略してください。

## Jupyter Notebook
PythonをGUIベースでインタラクティブに実行することができるオープンソースソフトウェアです。
機会学習や画像認識の処理を検証する際によく使用されます。本ハンズオンでは、ECSサーバー上にJupyter Notebookを構築し、Jupyter NotebookからImage Searchに対して画像登録・検索・削除を行います。

## Jupyter Notebookの構築
1. *仮想サーバー* メニューの *Elastic Compute Service* を選択します
1. 左上のリージョンから指定されたリージョンを選択します
1. 左のメニューから *インスタンス* を選択します
1. `ecs-imagesearchhandson` の *IPアドレス(インターネット)* をメモします
1. 左上の *Cloud Shell* アイコンボタンを押下します（下記参照）
    1. Cloud Shellのアイコン
        ![Cloud Shell](img/cloudshell.png)
1. *ストレージスペース* に関するモーダルの *スキップ* を選択
1. 次を入力し、ECSサーバーにログインします
    ```
    ssh root@<<IPアドレス(インターネット)>>
    Are you sure you want to continue connecting (yes/no)? >> yes
    root@<<IPアドレス(インターネット)>>'s password: >> <<Step5で指定したパスワード>>
    ```
1. 次を入力し、Jupyter Notebookを起動させるDockerとGitをインストールします。`-` に囲われた内容は実行結果抜粋です。
    ```
    yum -y update
    ----------
    Complete!
    ----------
    yum install -y yum-utils device-mapper-persistent-data lvm2
    ----------
    Complete!
    ----------
    yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
    ---------------------------------------------
    repo saved to /etc/yum.repos.d/docker-ce.repo
    ---------------------------------------------
    yum install -y docker-ce docker-ce-cli containerd.io
    ----------
    Complete!
    ----------
    systemctl start docker
    systemctl enable docker
    ---------------------------------------------------------------------------------------------------------------------------
    Created symlink from /etc/systemd/system/multi-user.target.wants/docker.service to /usr/lib/systemd/system/docker.service.
    ---------------------------------------------------------------------------------------------------------------------------
    docker --version
    --------------------------------------
    Docker version 19.03.5, build 633a0ea
    --------------------------------------
    yum install -y git
    ----------
    Complete!
    ----------
    ```
1. 次を入力し、Jupyter NotebookのDockerイメージをプルします
    ```
    git clone https://github.com/kanzai935/imagesearchhandson.git
    cd imagesearchhandson/
    ```
1. 次を入力し、環境変数ファイルを編集します
    ```
    vi env
    i
    ```
1. 次を入力し、環境変数をセットアップします。リージョンの英語表記は[Step0](Step0.md)を参照してください。
    ```
    ACCESS_KEY_ID=Step2で作成したImageSearchHandsOnUserのアクセスキー
    ACCESS_KEY_SECRET=Step2で作成したImageSearchHandsOnUserのシークレットキー
    REGION=指定されたリージョンの英語表記
    BUCKET_NAME=Step3で作成したOSSバケット名
    IMAGESEARCH_INSTANCE_NAME=Step1で作成したImage Searchインスタンス名
    ```
    **注意：[Step1](Step1.md)でImage Searchを購入しなかった方は `IMAGESEARCH_INSTANCE_NAME` を次の通り記載してください。**
    ```
    IMAGESEARCH_INSTANCE_NAME=imagesearchhandson
    ```
1. 次を入力し、環境変数ファイルを保存します
    ```
    :wq
    ```
1. 次を入力し、Jupyter NotebookのDockerイメージをビルドします
    ```
    docker image build -t notebook .
    ```
    1. 実行結果例
        ```
        Successfully built 3c9cbc7b6585
        Successfully tagged notebook:latest
        ```
1. 次を入力し、Jupyter NotebookのDockerコンテナを起動します
    ```
    docker run -v /root/imagesearchhandson:/home/jupyter/jupyter-working --env-file=env -d -p 8888:8888 -u root notebook
    ```
    1. 実行結果例
        ```
        a4e71f6edb5f6636af87225b9015345c537f602367ad5372f62e94371dc61672
        ```
1. 次を入力し、Jupyter NotebookのDockerコンテナが起動していることを確認し、`CONTAINER ID`をメモします
    ```
    docker ps -a
    ```
    1. 実行結果例
        ```
        CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                    NAMES
        fe781b36f571        notebook            "/bin/sh -c 'jupyter…"   9 seconds ago       Up 8 seconds        0.0.0.0:8888->8888/tcp   silly_gould
        ```
1. 次を入力し、Jupyter Notebookのtokenをメモします
    ```
    docker logs <<CONTAINER ID>>
    ```
    1. 実行結果例
        ```
        Copy/paste this URL into your browser when you connect for the first time, to login with a token:
          http://0.0.0.0:8888/?token=de2f660bc6dc0f11a0966d7639ba065028e4a9ba6b1060b8
        ```
1. 次を入力し、Cloud Shellからログアウトします
    ```
    exit
    ```
1. ブラウザから `http://<<IPアドレス(インターネット)>>:8888` にアクセスし、メモした `token` を記入してログインします
1. `home/jupyter/jupter-working` ディレクトリに移動します

## 参考
- [Cloud Shell公式ドキュメント](https://jp.alibabacloud.com/help/doc-detail/90395.htm)
- [Alibaba CloudのCloud Shellでは何ができるか](https://www.sbcloud.co.jp/entry/2019/01/08/cloudshell/)


[戻る](Step5.md) | [次へ](Step7.md)
