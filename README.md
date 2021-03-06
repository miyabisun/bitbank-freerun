# Overview

これはBitbank.ccのAPIを利用したツールになる予定の、スクリプト群です。
いい感じに出来たら公開します。

# Installation

Node.jsを利用してインストールします。

```Bash
$ node -v
v9.9.0

$ npm -v
5.6.0

# インストール
$ npm install

# 開発者用インストール
$ npm install -D
```

# Usage

現在相場が上がりそうか下がりそうかを閲覧することが可能です。  
最初は振れ幅が大きいのでベクトルが0と表示されますが、  
ある程度の履歴が溜まり次第、約定情報のログを参考にベクトルが表示されるようになります。

計算式は直近の約定は多めに比重を付けながらBuy、Sellの両軸を得点化してから、以下の計算式に当てはめます。

- Buy先行: `Math.min(Math.sqrt(buy / sell) - 1, 10)`
- Sell先行: `Math.max(-1 * (Math.sqrt(sell / buy) - 1), -10)`

1以上が続くなら相場が急上昇する可能性があり、  
逆に-1以下が続くなら逆に相場が下落する懸念があります。

また、平方根を取っているので、  
売買が拮抗している場合は2以上の数値は非常に出辛いと考えられます。  
このように約定情報を閲覧することで相場をいち早く察知することが可能かもしれません。

```Bash
$ npm run start
> bitbank-freerun@1.0.0 start /root/project/bitbank-freerun
> lsc index.ls

2018/04/19 08:57:39 0.000 { sell: '75.698', buy: '75.607' }
```

