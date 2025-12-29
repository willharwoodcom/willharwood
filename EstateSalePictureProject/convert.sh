#!/bin/bash

if [ "$1" == "all" ]; then
  # Small and large images
  rm *.jpg

  ls raw | sed 's/.*/convert "raw\/&" -resize 350x350 -border 1x1 -bordercolor white -border 3x3 -bordercolor black "&_n.jpg"/' | sed 's/.jpg_n/_n/' | sh

  ls raw | sed 's/.*/convert "raw\/&" -resize 900x900 -border 1x1 -bordercolor white -border 3x3 -bordercolor black "&_l.jpg"/' | sed 's/.jpg_l/_l/' | sh
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
prev=total
for file in *_l.jpg; do
    next=$(expr "$n" + 1)
if [ "$next" == "$total" ]; then
    next=0
fi
    cat <<EOF > $n.html
<html>
  <head>
    <title> Estate Sale Picture Project (c) Will Harwood </title>
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
      <a href="$next.html"><img src="$file"/></a>
      <br><a href="$prev.html">Previous</a> ~ <a href="index.html">Index</a> ~ <a href="next.html">Next</a>
    </center>
  </body>
</html>
EOF

prev=n
n=$(expr "$n" + 1)
done


# Index
cat <<EOF > index.html
<html>
  <head>
    <title> Estate Sale Picture Project (c) Will Harwood </title>
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
    <h1> The estate sale picture project </h1>
    <p>
      Our Bay Area and beyond hobby, visiting estate sales.
      An American thing (I don't think I ever heard of one in the UK): when a person dies and leaves their house unlived in, and if their family don't want the trouble of sorting through their decades of accumulation (or if there are no close family who care; or if it's all too much and anyway the valuable part is this Bay Area real estate, purchased for \$35K in 1979 that's now worth \$1.1M, or \$2M after new white goods, off-white interior paint, luxury countertops, and gray exterior paint have been done, and the more egregious cracks in walls and basement patched), well, there are a number of local mom-and-pops who will go through it all, price the valuable parts, arrange it (perhaps sweetening the sale with more items from their lockup or store), then open it up for one or two weekends, 10am to 2pm, and take 1/3 of whatever they can sell. (Check out e.g. https://estatesales.org for estate sales local to you!) 
    </p>
    <p>
      Some are happy, portraits of lives well lived. (An apartment overlooking Delores Park, husband and wife anthropologists. We bought their chaise longue.) In others, you can see the decade where it became too much to keep things well; when clothes were no longer bought; when whatever was there would make do. Patterns emerge: you can make a good guess whether the husband died first (only female clothes and shoes; tools remain in the garage, vastly arranged), or the wife (he won't dispose of her clothes; never again will the house be really clean). Whether they had children and when they were born (80s Disney on VHS; 90s Disney on DVDs). It's rare to find fine watches or cameras or other things easily claimed by the family -- good <i>china</i> is the exception here. There is so much china in estate sales. 
    </p>
    <p>
      My rule of thumb: a good estate sale is one in which there are good books, and no one ever has just a few good books. Either it's hundreds or nothing. I've never bought clothes there, which are very common. Who <i>does</i> buy clothes at estate sales? Students. They can't get enough of 70s and 80s fashion.
    </p>
    <p>
      I've written enough. It is my partner who plans to write the book on estate sales. This is my ongoing picture project.
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
