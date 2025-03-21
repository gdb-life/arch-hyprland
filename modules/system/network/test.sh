
dir="$HOME/.openvpn"

if [ ! -d "$dir" ]; then
    echo "not dir"
    exit 1
fi

for file in "$dir"/*; do
    if [ -f "$file" ]; then
        echo "$file"
    fi
done
