# skk-jisyo-nico-pixiv

## Build

```sh
./download
ruby convert.rb
```

## 生成される辞書の種類

* `SKK-JISYO.nico_pixiv`: 通常バージョン (`;`や`/`などの文字列を`(concat "...")`形式でエスケープ)
* `SKK-JISYO.nico_pixiv_omit`: `;`や`/`などの文字列を含むエントリを削除したバージョン
* `SKK-JISYO.nico_pixiv_zenkaku`: `;`や`/`などの文字列を無理矢理全角にしたバージョン

基本的に`SKK-JISYO.nico_pixiv`を使えばいいですが、AquaSKKなど`(concat "...")`形式に対応していないIMEの場合は`SKK-JISYO.nico_pixiv_omit`か`SKK-JISYO.nico_pixiv_zenkaku`を使う必要があります。
