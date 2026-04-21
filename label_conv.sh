#!/bin/bash
set -euo pipefail
#!/bin/bash

# ===== PATH CONFIG =====
DEVKIT_PATH="/workspaces/Lidar-UGP/tum-traffic-dataset-dev-kit-main"
DATASET_PATH="/workspaces/Lidar-UGP/a9_dataset_r02_s01"

OUTPUT_LABEL_PATH="/workspaces/Lidar-UGP/kitti_labels"

# ===== EXPORT =====
export PYTHONPATH=$PYTHONPATH:$DEVKIT_PATH

# ===== RUN =====
python $DEVKIT_PATH/src/label_conversion/conversion_openlabel_to_kitti.py \
    --root-dir $DATASET_PATH \
    --out-dir $OUTPUT_LABEL_PATH \
    --file-name-format num