#!/usr/bin/env bash
# invitation.html(아티팩트용 조각)을 단독으로 열리는 docs/index.html 로 감싼다.
# 청첩장 내용을 고쳤으면 ./build.sh 로 다시 만든 뒤 git push.
set -euo pipefail
cd "$(dirname "$0")"

SRC=invitation.html
OUT=docs/index.html
URL="https://lhbbbb.github.io/wedding/"
mkdir -p docs

# 소스를 </style> 기준으로 head 쪽과 body 쪽으로 가른다.
split_line=$(grep -n '^</style>$' "$SRC" | head -1 | cut -d: -f1)

{
  cat <<HEAD
<!doctype html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
<meta name="robots" content="noindex, nofollow, noarchive">
<meta name="description" content="김민준 · 이서연 결혼합니다. 2027년 4월 10일 토요일 낮 12시 30분, 그랜드컨벤션 3층 그랜드홀.">
<meta name="theme-color" content="#eceee8" media="(prefers-color-scheme: light)">
<meta name="theme-color" content="#19201d" media="(prefers-color-scheme: dark)">
<meta property="og:type" content="website">
<meta property="og:site_name" content="모바일 청첩장">
<meta property="og:title" content="김민준 · 이서연 결혼합니다">
<meta property="og:description" content="2027년 4월 10일 토요일 낮 12시 30분 · 그랜드컨벤션 3층 그랜드홀">
<meta property="og:url" content="${URL}">
<meta name="twitter:card" content="summary_large_image">
<style>
  /* 아티팩트 뷰어가 넣어 주던 기본값을 단독 문서에서도 동일하게 */
  :root {
    color-scheme: light;
    padding-top: env(safe-area-inset-top, 0px);
    padding-bottom: env(safe-area-inset-bottom, 0px);
  }
  body { margin: 0; font: 14px system-ui, sans-serif; }
  img { max-width: 100%; }
  [hidden] { display: none !important; }
</style>
HEAD
  sed -n "1,${split_line}p" "$SRC"
  echo '</head>'
  echo '<body>'
  sed -n "$((split_line + 1)),\$p" "$SRC"
  echo '</body>'
  echo '</html>'
} > "$OUT"

echo "wrote $OUT ($(wc -c < "$OUT") bytes)"
