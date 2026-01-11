#!/bin/bash

if [ "$1" == "all" ]; then
  # Small and large images
  rm *_l.jpg *_n.jpg

  ls raw | xargs -I {} ./resize.sh "{}"
  
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
    <title> A roll of HP5+ on Albany Bulb, Jan 2026 (c) Will Harwood </title>
    <style>
      body {
        background-color: lightgrey;
      }
      img {
        margin: 10px;
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
    <title> A roll of HP5+ on Albany Bulb, Jan 2026 (c) Will Harwood  </title>
    <style>
      body {
        background-color: lightgrey;
      }
      img {
        margin: 10px;
      }
    </style>
  </head>
  <body>
   <center>
   <table>
     <tr>
     <td colspan=3 style="width:900px">
    <h1> A roll of HP5+ on Albany Bulb, Jan 2026 </h1>
    <p>
      Nikon F3, 100mm Nikkor, HP5+ developed in DD-X. A single roll shot in the gloaming.
    </p>
    </td>
    </tr>
    <tr>
EOF

i=0
n=0
for file in *_n.jpg; do
cat <<EOF >> index.html
          <td>
            <a href="$n.html"><img src="$file"/></a>
          </td>
EOF
  i=$(expr "$i" + 1)
  if [ "$i" == "3" ]; then
      i=0
cat <<EOF >> index.html
          </tr>
          <tr>
EOF
  fi

  n=$(expr "$n" + 1)
done

cat <<EOF >> index.html
       </tr>
     </table>
   </center>
  </body>
</html>
EOF

# git
git add *_n.jpg
git add *_l.jpg
git add *.html
git add convert.sh

git commit -m "next"
