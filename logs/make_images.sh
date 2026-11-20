#!/usr/bin/env bash
# 그림을 Codex로 한 장씩 차례대로 만드는 스크립트. 각 호출 기록은 logs/_log_이름.txt
cd "$(dirname "$0")/.." || exit 1
STYLE="Soft 3D clay toy render, rounded friendly shapes, gentle studio lighting, smooth matte surfaces, warm cheerful children's educational game style, hanji cream, royal red, jade green-blue and gold accents. Absolutely no text, no letters, no characters, no watermark."
ICON="Single subject centered, whole subject visible with generous margin. Solid pure green background #00FF00, perfectly flat and uniform, no floor, no cast shadow on the background. Do not use bright pure green on the subject."
SCENE="Wide landscape 3:2 scene whose edges fade softly into a very pale off-white background."

gen(){ # $1=이름 $2=icon|scene $3=설명
  local name="$1" kind="$2" desc="$3" out tail
  if [ "$kind" = icon ]; then out="assets/$name-raw.png"; tail="$ICON"; else out="assets/$name.png"; tail="$SCENE"; fi
  [ -s "$out" ] && { echo "skip $name"; return; }
  local before; before=$(ls -t ~/.codex/generated_images/*/*.png ~/.codex/generated_images/*.png 2>/dev/null | head -1)
  codex exec -s workspace-write --skip-git-repo-check \
    "내장 image_gen 도구(gpt-image-2)로 이미지 1장을 생성해 ./$out 로 저장. 프롬프트: $desc $STYLE $tail" \
    < /dev/null > "logs/_log_$name.txt" 2>&1
  if [ ! -s "$out" ]; then
    local latest; latest=$(ls -t ~/.codex/generated_images/*/*.png ~/.codex/generated_images/*.png 2>/dev/null | head -1)
    if [ -n "$latest" ] && [ "$latest" != "$before" ]; then cp "$latest" "$out"; echo "copied $name from generated_images"; fi
  fi
  [ -s "$out" ] && echo "ok $name" || echo "FAIL $name"
}

gen title scene "A bright Joseon-era royal research workshop courtyard inside a palace, with scientific instruments: a bronze armillary sphere, a sundial bowl on a stone pedestal, a rain gauge, and a wooden water clock pavilion, curious children in hanbok looking around, mountains behind."
gen palace scene "A grand closed Joseon royal palace gate with red pillars, colorful dancheong painted eaves and a curved tiled roof, the big wooden doors shut with a large round brass lock, stone steps in front."
gen palaceopen scene "The same grand Joseon royal palace gate with red pillars and colorful dancheong eaves, both doors wide open with warm golden light shining out, flower petals and small stars floating in the air."
gen m1 scene "Joseon-era farmers planting rice seedlings in a flooded green paddy field in spring, an elderly experienced farmer explaining to a young official who is writing notes in a book, mountains and a thatched village behind."
gen m2 scene "A Joseon-era town square with a bronze bowl-shaped sundial on a stone pedestal, villagers and children gathering around to read the time from the shadow, a wooden water clock pavilion in the background."
gen m3 scene "A Joseon palace courtyard on a rainy day, a bronze rain gauge cylinder on a carved stone stand collecting rain, an official in a blue robe measuring the water with a ruler, a bronze armillary sphere under a small roof nearby."
gen m4 scene "A warm Joseon hanok room where a kind king in a red royal robe watches smiling commoners, a farmer, a woman and a child, happily learning to write simple shapes with brushes on paper at low desks."
gen m5 scene "A busy Joseon print workshop where craftsmen arrange small metal type pieces in a frame and print many stitched books, stacks of new books piled up, a woman reading a cookbook happily at the side."
gen nongsa icon "An old Korean stitched-bound farming book with a hanji cover and red thread binding, with a small bundle of golden rice stalks lying across it, blank cover."
gen angbu icon "A traditional Korean bronze bowl-shaped sundial (angbuilgu) on a small stone pedestal, a thin pointer gnomon casting a shadow inside the bowl, fine engraved lines, no writing."
gen jagyeok icon "A traditional Korean automatic water clock (jagyeongnu): tall bronze and ceramic water vessels arranged in steps on a wooden frame, with a small wooden figure holding a drumstick beside a drum, gong and bell."
gen cheugugi icon "A traditional Korean bronze rain gauge (cheugugi): a simple bronze cylinder sitting on a carved granite stone stand, with a small wooden ruler beside it."
gen honcheon icon "A traditional Korean bronze armillary sphere (honcheonui): interlocking metal rings around a small globe, mounted on a carved wooden stand with dragon legs."
gen hunmin icon "An old Korean stitched-bound book opened to show large simple geometric brush strokes like circles, squares and lines (no real letters), hanji paper, red thread binding, with a calligraphy brush beside it."
gen gabinja icon "A small wooden tray holding many tiny bronze metal type pieces arranged in neat rows, with a few loose pieces and an ink brush beside it, no readable letters."
gen award icon "A rolled-up royal yellow silk scroll certificate with red wooden rollers tied with a red tassel, with a small golden medal ribbon, celebratory."
echo DONE
