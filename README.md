# Idea

- Iwashiのリスペクト
- Parallel Dual Stack Programing

# How to run
```
ruby yatsume.rb -- examples/io-test.yatsume
```

# State
```
StackK: [] : Integer Stack
StackD: [] : Integer Stack
```

# Program
Operandの列

# Operand
```
{OpK}
{OpD}
```

## Op
|命令|名前|処理|
|-----|-----|----|
||NOP|何もしない|
|怖くなったので帰りました|POP|pop|
|嫌な気分になりました|PUSHZ|push 0|
|蛙が鳴いたので急ぎました|DUP|先頭を複製|
|走ってたら転びました|SWAP|先頭2つを交換|

## OpK
Opに加えて，

|命令|名前|処理|
|-----|-----|----|
|いつも行く公園に通ったことのない道があった|GETC|標準入力から1文字をpush|
|草だらけで整備もされず山奥に続いてた|DUPS|StackDをpopしてその回数だけDUP|
|暇だったので通ってみました|PUTC|popして文字として表示|
|数分ほど歩いていると見たことのないトンネルがあった|GETN|標準入力から数字をpush|
|仕方ないので入りました|PUTN|popして数字として表示|
|壁を見ると穴が開いていたので指をつっこんだらちょん切れた|POPS|StackDの先頭を破棄してその回数POP|
|友達に話したら一緒に行くことになりました|PUSHS|StackDをpopしてそれをpush|
|トンネルまで続く道にパイロンが立っていた|PUSHLAB|ランダマイズされた現在のプログラムカウンタをpush|
|通行止めを無視して行きました|TAKES|StackDをpopして先頭から数えてn番目をpush|
|トンネルの前に着きました|PUSHN|-1をpush|
|入ってみると中は暖かく変な臭いが立ち込めていた|REVS|StackDをpopして先頭から数えてn要素を順番反転|
|床の大きな穴に気がつかず落ちて体が溶けました|POPTS|StackDをpopしてその数をpopするまでpopし続ける|

## OpD
Opに加えて，

|命令|名前|処理|
|-----|-----|----|
|初めて聞いた話だった|NEQ|StackKとStackDをpopして，結果が異なれば1をpush，さもなくば0|
|付き添いで行くことになった|ADD|StackKとStackDをpopして，足してpush|
怖かったけどその道は行ったことが無かった|LT|StackKとStackDをpopして，Dのほうが小さければ1をpush，さもなくば0|
|横にはビックリマークだけの標識があった|MUL|StackKとStackDをpopして，掛けてpush|
|床の穴から助けようとして穴を覗いたら溶けていた|JNZLAB|StackKとStackDをpopして，Dのほうが0でなければ，プログラムカウンタをKにする。|

# Examples

code:
```
いつも行く公園に通ったことのない道があった

数分ほど歩いていると見たことのないトンネルがあった

仕方ないので入りました

暇だったので通ってみました

```

```
stdin: G1234
stdout: 1234G
```

