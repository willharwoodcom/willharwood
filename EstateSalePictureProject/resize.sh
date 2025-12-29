# Given an image, create small and large versions
# We want to keep the total number of pixels constant
#  Small = 350 * 350 * 0.66667 ~ 82000 = S
#  Large = 900 * 900 * 0.66667 ~ 540000 = L
# Say we have an image which is 2000 by 2200, what dimensions do we use in the -resize option?
# We want the aspect ratio preserved, and we want the product to equal S
# I.e. find x, y such that
#   xy = S
#   x/y = 2000/2200 = R
# x = root RS
# y = root S/R

w=$(identify -format "%w" "$1")
h=$(identify -format "%h" "$1")
R=$(echo "scale=5;$w/$h" | bc)
S=82000
L=540000
new_w_n=$(echo "scale=0;sqrt($S*$R)/1.0" | bc)
new_h_n=$(echo "scale=0;sqrt($S/$R)" | bc)

new_w_l=$(echo "scale=0;sqrt($L*$R)/1.0" | bc)
new_h_l=$(echo "scale=0;sqrt($L/$R)" | bc)

output_n=$(echo $1 | sed 's/.*/&_n.jpg/' | sed 's/.jpg_n/_n/' | sed 's/raw\///')
output_l=$(echo $1 | sed 's/.*/&_l.jpg/' | sed 's/.jpg_l/_l/' | sed 's/raw\///')

echo convert \"$1\" -resize "$new_w_n"x"$new_h_n" \"$output_n\"
echo convert \"$output_n\" -border 1x1 -bordercolor black \"$output_n\"
echo convert \"$output_n\" -border 3x3 -bordercolor white \"$output_n\"

echo convert \"$1\" -resize "$new_w_l"x"$new_h_l" \"$output_l\"
echo convert \"$output_l\" -border 1x1 -bordercolor black \"$output_l\"
echo convert \"$output_l\" -border 3x3 -bordercolor white \"$output_l\"
