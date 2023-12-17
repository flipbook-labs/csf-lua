set -e

UPSTREAM_REPO=ComponentDriven/csf
REPO_DIR_NAME=$(basename $UPSTREAM_REPO)

echo "info: Cloning git repos..."
git clone https://github.com/Roblox/js-to-lua
git clone https://github.com/$UPSTREAM_REPO

echo "info: Building js-to-lua"
cd js-to-lua
npm install
npm run build:prod

runner=$(realpath dist/apps/convert-js-to-lua/main.js)

cd ..

echo "info: Path to js-to-lua: $runner"

echo "info: Converting $UPSTREAM_REPO to Luau..."
node $runner --input $REPO_DIR_NAME/**/*.ts --output .

echo "info: Successfully converted"

echo "info: Cleaning up git repos..."
rm -rf js-to-lua
rm -rf $REPO_DIR_NAME

echo "info: All done :)"