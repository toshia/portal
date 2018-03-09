**実験的なプラグインなので色々トラブルが発生してフィードバックをください。**

# Portal

Worldを、より快適に。

## なんこれ

mikutterに、Spellの対応状況によって自動的にWorldを切り替える仮想的なWorldを追加します。

普段の投稿などはMastodonに行い、tootに対するリプライなども当然Mastodonで行うけれど、ツイートに対してリプライするのはTwitterにする、といった使い方ができます。

mikutterで複数のWorldを使い分けていると、間違って別のSNSに投稿してしまうといったことがしばしばありますが、使い方が合えば絶大な効果を発揮します。

## 要件

mikutter 3.6.5 以降を使ってください。それ以前だと、mikutter側の不具合の影響で動作しません。

## インストール方法

以下のコマンドを実行した後、mikutterを起動します。

```sh
mkdir -p ~/.mikutter/plugin/; git clone https://github.com/toshia/portal.git ~/.mikutter/plugin/portal
```

## 使い方

1. 設定画面の「アカウント管理」をクリックします。または画面左上のアカウントアイコンをクリックすると出てくる「Worldを追加」をクリックします。
1. Worldの種類として「Portal」を選択します。
   ![World追加画面](https://raw.githubusercontent.com/toshia/portal/image/01.png)
1. Portalの設定画面です。
   ![対象となるWorldを選択](https://raw.githubusercontent.com/toshia/portal/image/02.png)
   - Portalはアカウントの一種として取り扱われるので、好きな名前を決めてください。
   - Primary Worldは一番優先されるWorldです。
   - Secondary Worldは、Primary Worldにが対応していない機能を呼び出そうとした時に利用されるWorldです（フォールバック先）。
1. OKボタンを押すと何も表示されてない画面が出てきますが、もう一度OKを押してください（雑）
1. 左上のアイコンをクリックすると出てくるアカウント一覧の一番下に、先程追加した名前のPortalがアカウントとして表示されていると思うので、選択してください。
1. 以後、アカウントとしてポータルを選択しておくと、次節の **挙動** のような振る舞いをするようになります。

## 挙動

以下、開発時に使った、Primary WorldがMastodon、Secondary WorldがTwitterという構成を例に説明します。

投稿、お気に入りといった、Worldが関係する操作をする時、Portalがカレントワールドとして選ばれていると、 **使い方** の節で設定した **Primary World** を選んでいるときと同じような動きをします。

任意の文章を投稿するとMastodonにTootしますし、tootをお気に入りに追加したりメンションすることもできます。一方で、ツイートにリプライしようとすると、コンテキストメニューには現れませんし、ショートカットキーも反応しません。これは、MastodonでTwitterにリプライすることはできないからです。

そういった場合、Portalは自動的に **Secondary World** で同じことをできないか試して、可能なら行います。今回の例の場合、Secondary WorldはTwitterアカウントなので、TwitterからTwitterへのリプライは可能なので、こちらが選ばれます。

