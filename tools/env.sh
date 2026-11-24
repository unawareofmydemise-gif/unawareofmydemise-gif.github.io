# Ortak ortam değişkenleri: yazılımsal GPU (lavapipe/llvmpipe) ile render.
# Diğer betikler bunu "source" eder.
export VK_ICD_FILENAMES=/opt/lavapipe/lvp_icd.json
unset VK_DRIVER_FILES
export LP_NUM_THREADS="${LP_NUM_THREADS:-0}"
export UOMD_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
