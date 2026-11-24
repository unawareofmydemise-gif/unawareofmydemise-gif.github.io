# Ortak ortam değişkenleri: yazılımsal GPU (lavapipe/llvmpipe) ile render.
# Diğer betikler bunu "source" eder.
export VK_ICD_FILENAMES=/opt/lavapipe/lvp_icd.json
unset VK_DRIVER_FILES
export LP_NUM_THREADS="${LP_NUM_THREADS:-0}"
export UOMD_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# Mesa (lavapipe/llvmpipe) shader önbelleği kalıcı olsun: tekrar eden render'lar hızlanır.
export MESA_SHADER_CACHE_DIR="${MESA_SHADER_CACHE_DIR:-/var/cache/uomd-mesa}"
export MESA_SHADER_CACHE_MAX_SIZE=1G
mkdir -p "$MESA_SHADER_CACHE_DIR" 2>/dev/null || true
