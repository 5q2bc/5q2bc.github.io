#!/usr/bin/env bash
# content/blog/raw 以下のmdファイルを正規化し、content/blog/にコピーするスクリプト
# - コードブロックの "```lang:filename" を "```lang" に変換
# - 1つ目のセクションタイトル (# タイトル) をタイトルとしてfrontmatterに追加し、該当行を削除
# - dateはファイルの最終更新日
# - frontmatterを生成し、extra.display_published = true を追加
# - ディレクトリ構造を維持してコピー

RAW_DIR="$(dirname "$0")/../content/blog/raw"
OUT_DIR="$(dirname "$0")/../content/blog"

process_file() {
  src="$1"
  relpath="${src#$RAW_DIR/}"
  dest="$OUT_DIR/${relpath}"
  mkdir -p "$(dirname "$dest")"

  # ファイルの最終更新日を取得
  mod_date=$(date -r "$src" +%Y-%m-%d)

    # ファイル名（拡張子除く）をタイトルとして抽出
    filename=$(basename "$src")
    title="${filename%.*}"

  # frontmatter生成
  echo '+++' > "$dest"
  echo "title = \"$title\"" >> "$dest"
  echo "date = $mod_date" >> "$dest"
  echo '' >> "$dest"
  echo '[extra]' >> "$dest"
  echo 'display_published = true' >> "$dest"
  echo 'toc = true' >> "$dest"
  echo 'author = "5q2bc"' >> "$dest"
  echo '+++' >> "$dest"
  echo '' >> "$dest"

  # 本文生成: 1つ目の # タイトル行を削除し、コードブロックのlang:filenameをlangに置換
  awk 'BEGIN{skip=0} {if(skip==0 && $0 ~ /^# /){skip=1; next} print}' "$src" | \
    sed -E 's/^```([a-zA-Z0-9_+-]+):[a-zA-Z0-9_.-]+/```\1/g' >> "$dest"
  rm -f "$src"
}

# 引数でファイルが指定されていれば、そのファイルだけ処理する
if [ $# -gt 0 ]; then
  for file in "$@"; do
    # ワークフローから渡されるパスは raw ディレクトリからの相対パスなので、RAW_DIRを付与する
    process_file "${RAW_DIR}/${file}"
  done
# 引数がなければ、従来通り全ファイルを処理する
else
  find "$RAW_DIR" -type f -name '*.md' | while read -r src; do
    process_file "$src"
  done
fi
