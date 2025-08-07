+++
title = "VSCodeでワークスペースごとに独自のキーボードショートカットを使う裏技"
date = 2025-08-07

[extra]
display_published = true
toc = true
author = "5q2bc"
+++



皆さんはVSCodeに独自のキーボードショートカット追加していますか?  
よく使う小技的なものや、VSCodeのタスク機能を割り当ててコマンド実行をさせている方も多いんじゃないでしょうか。  

VSCodeのキーボードショートカット作成はkeybinding.jsonを編集することで可能で、キーボードショートカットごとに発動条件を"When"で指定することができます。  
例えば
```json
	{
	"key": "ctrl+shift+j",
	"command": "workbench.action.terminal.focus",
	"when": "editorTextFocus"
	},{
	"key": "ctrl+shift+j",
	"command": "workbench.action.focusFirstEditorGroup",
	"when": "terminalFocus"
	},
```

とすることで同じctrl+shift+jのショートカットを
- エディター選択時はターミナルに移動
- ターミナル選択時はエディターに移動

として使うことができます。  
(話は逸れますが、このショートカットは個人的によく使うもので、ctrl+jのパネル表示/非表示との親和性が高いのでおすすめです)

whenの詳しい使い方については [公式の解説](https://code.visualstudio.com/api/references/when-clause-contexts)を参照してください

ですがwhenでは対応できないこんなシチュエーションに遭遇したことはありませんか?
- 同じキーボードショートカットをワークスペースごとに意味を変えたい
- 押しやすいキーの組み合わせをワークスペースごとに意味を変えて使いたい
- 特定のワークスペースだけでしか使わないキーボードショートカットがある

これらはVSCodeではワークスペースごとにkeybinding.jsonを置くことができず、whenの機能ではワークスペースを識別できないために生じます。  
そのため公式にはワークスペースごとに違ったキーボードショートカットを使うことはサポートされていないのですが、今回はこれを(あまりスマートではないが便利な)裏技で回避していきます。

# やることの概要

やることとしては至ってシンプルです。  
ワークスペースごとに定義できないのならばワークスペースごとにフラグを作成し、それを見てキーボードショートカットの有効無効を変えてやろうという作戦になります。

具体的には
1. ワークスペースの.vscode/setting.jsonのファイルでワークスペースに固有の設定値にTrueを入れる
2. keybinding.jsonの使いたいキーボードショートカットの"when"で1. で指定した設定値がTrueかどうかの確認をいれる

となります。  
一つづつ見ていきましょう。

# ワークスペースでの設定

ワークスペースの識別のために固有のフラグを作ります。

まず使いたいワークスペースを開き、VSCodeのワークスペースごとの設定情報を入れる`.vscode/setting.json`フォルダに移動します。(なければ作成してください)

次に中に次の１行を追加します。
```json
{
	"workspaceKeybindings.hogehoge_ws.enabled": true,
}
```


ここの"workspaceKeybindings.hogehoge_ws.enabled"はいま適当に考えた名前なので、VSCodeに「不明な構成設定」とか言われてグレーアウトされますが、気にしなくて良いです。  
名前もワークスペースごとにお好きなものに変えてください。

以上でワークスペース側での設定は終わりです。

# keybinding.jsonでの設定

keybinding.jsonを編集して、ショートカットがワークスペース側で作ったフラグを判定できるようにします。

具体的には下記のようにします。フラグの名前はそれぞれのワークスペースでつけたものと合わせてください。
```json
	{
	"key": "ctrl+shift+q",
	"command": "command_1",
	"when": "workspaceKeybindings.hogehoge_ws.enabled",
	},
	{
	"key": "ctrl+shift+q",
	"command": "command_2",
	"when": "workspaceKeybindings.hugahuga_ws.enabled",
	},
```

↑のようにすると、同じctrl+shift+qのショートカットでworkspaceKeybindings.hogehoge_ws.enabledがTrueにしているワークスペースではcommand_1が、workspaceKeybindings.hugahuga_ws.enabledがTrueにしているワークスペースではcommand_2が実行されます。


# おわり

以上のようにすることでワークスペースごとに独自のキーボードショートカットを使うことができます。  
ワークスペースだけで完結できないのが玉に瑕ですが、かゆいところに手が届くようになる場合もあると思いますので、参考にしてご活用ください


## 参考

https://stackoverflow.com/questions/48945319/a-keybindings-json-per-workspace-in-visual-studio-code
