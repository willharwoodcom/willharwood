#!/bin/bash
#set -e

if [ "$1" == "all" ]; then
  # Small and large images
  rm *_l.jpg *_n.jpg

  ls raw | xargs -I {} resize.sh "{}"
  
elif [ "$1" != "site" ]; then
    echo "bash convert.sh all|site"
    exit 1
fi


# Simple pages, 1.html to n.html
total=0
for file in *_l.jpg; do
    total=$(expr "$total" + 1)
done
echo "$total images"

n=0
prev=$(expr "$total" - 1)
for file in *_l.jpg; do
    next=$(expr "$n" + 1)
if [ "$next" == "$total" ]; then
    next=0
fi
    cat <<EOF > $n.html
<html>
  <head>
    <title>
EOF
    cat title.txt >> $n.html
    
    cat <<EOF >> $n.html
 </title>
    <style>
      body {
        background-color: lightgrey;
      }
      img {
        max-width: 100vw;   /* Limit width to viewport width */
        max-height: 90vh;  /* Limit height to viewport height */
        width: auto;        /* Maintain aspect ratio */
        height: auto;       /* Maintain aspect ratio */
        display: block;
      }
    </style>
  </head>
  <body>
    <center>
      <a href="$prev.html">Previous</a> ~ <a href="index.html">Index</a> ~ <a href="$next.html">Next</a>
      <br><a href="$next.html"><img src="$file"/></a>
    </center>
  </body>
</html>
EOF

prev=$n
n=$(expr "$n" + 1)
done


# Index
cat <<EOF > index.html
<html>
  <head>
    <title>
EOF

cat title.txt >> index.html

cat <<EOF >> index.html
 </title>
    <style>
      body {
        background-color: lightgrey;
      }
      .imgbox {
        margin: 20px;
        display: inline;
      }
      .text {
        width: 900px;
      }
      .pictures {
      }
    </style>
  </head>
  <body>
   <div class="text">
    <h1> 
EOF
cat title.txt >> index.html

cat <<EOF >> index.html
</h1>
    <p>
EOF

cat description.txt >> index.html

cat <<EOF >> index.html
    </p>
    </div>
    <div class="pictures">
EOF

i=0
n=0
for file in *_n.jpg; do
cat <<EOF >> index.html
      <div class="imgbox"> <a href="$n.html"><img src="$file"/></a> </div>
EOF

  n=$(expr "$n" + 1)
done

cat <<EOF >> index.html
     </div>
  </body>
</html>
EOF

# git
git add *_n.jpg
git add *_l.jpg
git add *.html
git add *.txt
git add ../scripts/convert.sh

git commit -m "next"
