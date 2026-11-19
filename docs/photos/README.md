# 이 폴더는 자동 생성됩니다

여기 있는 `.jpg` 는 `make-photos.sh` 가 `photos-src/` 의 원본을 줄여서 만든 것입니다.
직접 고치지 말고 **원본을 `photos-src/` 에 넣고** 아래를 돌리세요.

```bash
./make-photos.sh   # photos-src/ → docs/photos/ 변환
./build.sh         # invitation.html → docs/index.html
git add . && git commit -m "사진 교체" && git push
```

## 원본 파일 이름 규칙 (`photos-src/`)

| 원본            | 쓰이는 곳                    | 만들어지는 크기 |
|-----------------|------------------------------|-----------------|
| `cover.JPG`     | 표지                         | 1200×1600 (3:4) |
| `01.JPG` ~ `NN.JPG` | 갤러리 (번호 순서대로)   | 900×1350 (2:3)  |

갤러리는 장수 제한이 없습니다. 원본을 더 넣고 `make-photos.sh` 를 돌리면 되는데,
`invitation.html` 의 갤러리 `<figure>` 목록과 총 장수 표시도 같이 늘려야 합니다.

- 원본은 긴 변 2000px 이상이면 충분합니다 (지금은 7008px 원본을 줄여 쓰는 중)
- 갤러리는 **세로 2:3 으로 원본 비율 그대로** 들어갑니다. 잘리지 않습니다
- 표지만 3:4 로 위아래를 조금 잘라냅니다
- `photos-src/` 는 저장소에 올라가지 않습니다 (용량이 커서 `.gitignore` 처리)
