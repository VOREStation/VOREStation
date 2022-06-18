if ! hash python; then
    echo "python is not installed"
    exit 1
fi

ver=$(python -V 2>&1 | sed 's/.* \([0-9]\).\([0-9]\).*/\1\2/')
if [ "$ver" -lt "34" ]; then
    echo "This script requires python 3.1 or greater"
    exit 1
fi

python scripts/rotate_map.py