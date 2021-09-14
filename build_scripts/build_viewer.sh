#!/bin/bash
cd tools/viewer
npm run build
build=$(realpath build)
cat >build/start.sh <<EOF
#!/bin/bash
cd $build
{ sleep 1; python -m webbrowser http://localhost:8000; } &
python3 -m http.server
EOF
chmod +x build/start.sh