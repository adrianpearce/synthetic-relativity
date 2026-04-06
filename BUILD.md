
# Build

quarto render --profile slides

quarto render --profile book

Scripts:
./batch_decktape.sh <optional argument of which file to process>
./batch_decktape-parallel.sh <optional argument of which file to process>
./build.sh  <optional argument of file, e.g. introduction, which only runs Decktape on that introduction.html slides file>
./build-only.sh - does not invoke decktape

quarto publish --profile book gh-pages --no-prompt

I run quarto in WSL (Ubuntu) under Window11 and have both the Ubuntu verion and Windows version of quarto installed.

The online book includes pdf slides, which are made using decktape called from that script batch_decktape.sh. Note that decktape only works properly in Ubuntu so I pass HOME directly the WSL home page, e.g.

Note: It is safe to ignore rhte "Page error: Cannot read properties of underined (reading 'Config')" error (not sure what is causing this at present)

HOME=/home/adria PUPPETEER_CACHE_DIR=/home/adria/.cache/puppeteer decktape reveal "file:///home/adria/slides/mcts.html" /mnt/c/Users/adria/OneDrive\ -\ The\ University\ of\ Melbourne/Documents/teaching/COMP90054/reinforcement-learning/slides/pdfs/mcts.html

## Previewing 

quarto preview mdp.qmd --profile slides

For interactively editing and writing the slides/book, this launches a browser which updates in realtime to edits to e.g. the mdp.qmd file.

## Figures:

pdflatex <filename>.tex

<or>

latex <filename>.tex 

e.g.
dvisvgm --no-fonts -p1- -o ./mdp-%p.svg figures_mdp.dvi

I create figures interactively using e.g. latexmk, then create dvi just using latex, then convert each page of the dvi file to an svg file, which scales nicely in quarto:

For multi-progression PDFs made in Latex with e.g. \pause, use this:

pdflatex *.tex
pdfcrop
pdf2svg *.pdf *.svg all
Then edit eacy *.svg and remove "fill.*100%" lines if you wish image to be transparent.

## Other (video processing not contained in this repo)

ffmpeg -i /mnt/c/Users/adria/Videos/file.mp4 -filter:v "setpts=0.94*PTS" -filter:a "atempo=1.063829787" /mnt/c/Users/adria/Videos/file_fast.mp4
