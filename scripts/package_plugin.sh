#!/usr/bin/env bash
# Build product-review-expert.plugin from plugins/product-review-expert/
# and keep plugin/marketplace versions in sync.
#
# Usage:
#   bash scripts/package_plugin.sh
#   bash scripts/package_plugin.sh --bump patch
#   bash scripts/package_plugin.sh --bump minor
#   bash scripts/package_plugin.sh --bump major
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
PLUGIN_NAME="product-review-expert"
PLUGIN_SRC="$PROJECT_ROOT/plugins/$PLUGIN_NAME"
PLUGIN_JSON="$PLUGIN_SRC/.claude-plugin/plugin.json"
MARKET_JSON="$PROJECT_ROOT/.claude-plugin/marketplace.json"
OUTPUT="$PROJECT_ROOT/$PLUGIN_NAME.plugin"

BUMP=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --bump) BUMP="${2:-}"; shift 2 ;;
    *) echo "Unknown argument: $1"; exit 1 ;;
  esac
done

if [[ -n "$BUMP" ]]; then
  python3 - "$PLUGIN_JSON" "$MARKET_JSON" "$PLUGIN_NAME" "$BUMP" << 'PY'
import json, pathlib, re, sys

plugin_json = pathlib.Path(sys.argv[1])
market_json = pathlib.Path(sys.argv[2])
plugin_name = sys.argv[3]
bump = sys.argv[4]

if bump not in ("major", "minor", "patch"):
    raise SystemExit(f"invalid bump: {bump}")

def bump_semver(version: str, kind: str) -> str:
    match = re.fullmatch(r"(\d+)\.(\d+)\.(\d+)", version)
    if not match:
        raise SystemExit(f"invalid semver: {version}")
    major, minor, patch = map(int, match.groups())
    if kind == "major":
        major += 1
        minor = 0
        patch = 0
    elif kind == "minor":
        minor += 1
        patch = 0
    else:
        patch += 1
    return f"{major}.{minor}.{patch}"

plugin_data = json.loads(plugin_json.read_text())
old_version = plugin_data.get("version", "0.0.0")
new_version = bump_semver(old_version, bump)
plugin_data["version"] = new_version
plugin_json.write_text(json.dumps(plugin_data, indent=2, ensure_ascii=False) + "\n")

market_data = json.loads(market_json.read_text())
market_data.setdefault("metadata", {})["version"] = new_version
for plugin in market_data.get("plugins", []):
    if plugin.get("name") == plugin_name:
        plugin["version"] = new_version
market_json.write_text(json.dumps(market_data, indent=2, ensure_ascii=False) + "\n")

print(f"Version bumped: {old_version} -> {new_version}")
PY
fi

python3 - "$PLUGIN_JSON" "$MARKET_JSON" "$PLUGIN_NAME" << 'PY'
import json, pathlib, re, sys

plugin_json = pathlib.Path(sys.argv[1])
market_json = pathlib.Path(sys.argv[2])
plugin_name = sys.argv[3]
plugin_root = plugin_json.parent.parent
errors = []

if not market_json.exists():
    errors.append(".claude-plugin/marketplace.json missing")

plugin_data = json.loads(plugin_json.read_text())
if plugin_data.get("name") != plugin_name:
    errors.append(f"plugin.json name must be {plugin_name}")
if not re.fullmatch(r"[a-z0-9-]+", plugin_data.get("name", "")):
    errors.append("plugin name must be kebab-case")

skills_dir = plugin_root / "skills"
if not skills_dir.exists():
    errors.append("skills/ directory missing")
else:
    for skill in skills_dir.iterdir():
        if skill.is_dir() and not (skill / "SKILL.md").exists():
            errors.append(f"skills/{skill.name}/SKILL.md missing")

agents_dir = plugin_root / "agents"
if agents_dir.exists() and not list(agents_dir.glob("*.md")):
    errors.append("agents/ has no .md files")

market_data = json.loads(market_json.read_text())
market_plugins = {entry.get("name"): entry for entry in market_data.get("plugins", [])}
entry = market_plugins.get(plugin_name)
if not entry:
    errors.append(f"marketplace entry missing for {plugin_name}")
elif entry.get("version") != plugin_data.get("version"):
    errors.append(
        f"marketplace version {entry.get('version')} does not match plugin version {plugin_data.get('version')}"
    )

if errors:
    print("VALIDATION ERRORS:")
    for error in errors:
        print(" -", error)
    sys.exit(1)

skills = [path.name for path in sorted(skills_dir.iterdir()) if path.is_dir()]
agents = [path.name for path in sorted(agents_dir.glob("*.md"))] if agents_dir.exists() else []
print(f"Validation: PASS ({plugin_name} v{plugin_data.get('version')})")
print(f"  skills: {skills}")
print(f"  agents: {agents}")
PY

TMP_ZIP="/tmp/$PLUGIN_NAME.plugin"
rm -f "$TMP_ZIP"
(cd "$PLUGIN_SRC" && zip -r "$TMP_ZIP" . -x "*.DS_Store" -x "__pycache__/*" -q)
cp "$TMP_ZIP" "$OUTPUT"

SIZE="$(du -sh "$OUTPUT" | cut -f1)"
VERSION="$(python3 -c "import json; print(json.load(open('$PLUGIN_JSON'))['version'])")"
echo "Built: $OUTPUT ($SIZE, v$VERSION)"
echo ""
echo "To distribute via marketplace repo:"
echo "  git add -A && git commit -m 'release: v$VERSION' && git tag v$VERSION && git push --tags"
