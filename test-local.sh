#!/bin/bash
set -e

echo "Testing Ultimate Polyglot locally..."
echo ""

echo "=== Testing Python ==="
python3 ultimate.polyglot
echo ""

echo "=== Testing Bash ==="
bash ultimate.polyglot
echo ""

echo "=== Testing PHP ==="
if command -v php &> /dev/null; then
    php ultimate.polyglot
else
    echo "PHP not installed, skipping"
fi
echo ""

echo "=== Testing Java Extraction ==="
if command -v javac &> /dev/null; then
    python3 -c "__extracted__ = True; exec(open('ultimate.polyglot').read()); print(JAVA_SOURCE)" > Ultimate.java
    javac Ultimate.java
    java Ultimate
    rm -f Ultimate.java Ultimate.class
else
    echo "Java not installed, skipping"
fi
echo ""

echo "=== All local tests completed! ==="
