# LinkedIn 日文版

LinkedIn は本文の長文も読まれる場なので、ある程度しっかり書く。改行多め、絵文字なし、技術者向けの落ち着いた語り口。

---

## 投稿本文

```
Webサイトに「自分専用の小さなカスタマイズ」を貼り付けたい——そんな欲求のために、Rust + Tauri v2 でデスクトップブラウザを作りました。Pouchという名前で、MITライセンスで公開しています。

github.com/leaker/pouch

きっかけは、ごく日常的な不満でした。

毎日使うWebサイトを独立したデスクトップアプリのように開く習慣があるのですが、サイトごとに「ここをちょっとだけ変えたい」という箇所が必ずあります。邪魔なポップアップ、小さすぎるフォント、毎回畳まれている領域、欲しいキーボードショートカット。ユーザースクリプトを書けば一発で解決できる類の話です。

しかし、ユーザースクリプト系拡張機能（Tampermonkey 等）は最近の Manifest V3 化以降、ユーザーが開発者モードを手動で有効化し「ユーザースクリプトを許可」する設定をしなければ動かない仕様になっています。自分一人で使う分にはともかく、技術に詳しくない知人に勧めるとなると、その導入手順だけで本来の改善より重い負担になります。

そこで Pouch を作りました。やることは2つだけです。

1. 任意のURLを独立したデスクトップウィンドウとして開く
   TOMLの設定ファイルに1行追加するだけ。Cookieもoriginもサイトそのものなので、ログイン状態やセッションは通常のブラウザと完全に同じです。複数ウィンドウを開いてもストレージは共有されます。

2. そのウィンドウに自分の JavaScript を注入する
   inject/ フォルダに .js ファイルを置き、Tampermonkey 形式の @match ヘッダーを書くだけ。document_start のタイミング、つまりページ自身のスクリプトが走り出す前に実行されます。各スクリプトは独立した try/catch で囲まれており、ひとつのエラーが他に波及しません。ブラウザ拡張は一切不要、開発者モードもいりません。

設定はすべて1つの TOML ファイルに集約されています。startup_urls にウィンドウとして開きたい URL を並べ、ignore_urls にアナリティクスや三方 CDN のような Pouch の処理を通したくない URL を指定する。それだけです。

インストールは macOS なら Homebrew、Windows なら Scoop で完結します。

  brew install --cask leaker/tap/pouch
  scoop bucket add leaker https://github.com/leaker/scoop-bucket && scoop install pouch

リポジトリはこちらです：
github.com/leaker/pouch

「あのサイトのあそこだけ自分用に直したい」という気持ちに心当たりのある方は、ぜひ試してみてください。フィードバックや Issue は歓迎です。

#Rust #Tauri #OpenSource #WebDevelopment #DesktopApp
```

---

## 投稿時のメモ

- LinkedIn 投稿画面: https://www.linkedin.com/feed/ から「Start a post」
- 改行は通常の Enter で OK
- 記号 # はハッシュタグ化される
- 文字数制限は 3000 字。上記は ~1500 字程度
