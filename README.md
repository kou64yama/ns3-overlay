ns3-overlay
===========

これは Gentoo に ns-3 を簡単にインストールするための Portage オーバーレイです．
直接リポジトリをダウンロードして PORTDIR_OVERLAY に指定してもいいですが，layman を利用すると便利です．

layman のインストール
---------------------

Git を使用するので，まずは USE フラグを変更しましょう．`nano -w /etc/portage/package.use` などとして，

    app-portage/layman git

の 1 行を追加します．そして，layman をインストールしましょう．

    emerge -av app-portage/layman

USE フラグに git が指定されていることを確認したら，__y__ を押してインストールを開始します．
エラーなく終了すれば layman のインストールは完了です．

layman の設定
-------------

layman の設定ファイルは `/etc/layman/layman.cfg` にあります．
layman のリポジトリは，このファイルの

    overlays  : http://www.gentoo.org/proj/en/overlays/repositories.xml

で指定された XML ファイルに書かれています．ここには複数のファイルを指定することも出来ます．これを

    overlays  : http://www.gentoo.org/proj/en/overlays/repositories.xml
                https://raw.github.com/kou64yama/ns3-overlay/master/repositories.xml

と変更すれば，このリポジトリを使用できるようになるはずです．

    layman --fetch
    layman --add ns3-overlay

として，リポジトリを追加します．
あとは

    emerge -av ns

として ns-3 をインストールするだけです．
