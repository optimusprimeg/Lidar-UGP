#!/bin/bash
set -euo pipefail

# Ensure the script runs with the prepared TUMTraf environment.
source /opt/conda/etc/profile.d/conda.sh
conda activate tumtraf

export OPEN3D_CPU_RENDERING=true
export LIBGL_ALWAYS_SOFTWARE=1
export DISPLAY=
export PYOPENGL_PLATFORM=egl
export LD_LIBRARY_PATH="/opt/conda/envs/tumtraf/lib:${LD_LIBRARY_PATH:-}"


# ===== PATH CONFIG =====
DEVKIT_PATH="/workspaces/Lidar-UGP/tum-traffic-dataset-dev-kit-main"
DATASET_PATH="/workspaces/Lidar-UGP/a9_dataset_r02_s01"

LIDAR_FOLDER="s110_lidar_ouster_north"

POINTS_PATH="$DATASET_PATH/point_clouds/$LIDAR_FOLDER"
LABELS_PATH="$DATASET_PATH/labels_point_clouds/$LIDAR_FOLDER"
OUTPUT_PATH="/workspaces/Lidar-UGP/output"

# ===== EXPORT =====
export PYTHONPATH="${PYTHONPATH:-}:$DEVKIT_PATH"

# ===== PREFLIGHT =====
# Probe Open3D offscreen renderer first so we fail clearly instead of crashing mid-run.
if ! python - <<'PY'
import sys
import open3d as o3d

renderer = o3d.visualization.rendering.OffscreenRenderer(16, 16)
_ = renderer.render_to_image()
print("Open3D offscreen probe passed")
PY
then
    echo "Open3D offscreen renderer is unavailable in this container runtime."
    echo "No output images were written because rendering could not start."
    echo "Try running with desktop OpenGL/GPU support, or use a machine with a real display."
    exit 1
fi

# ===== RUN =====
python $DEVKIT_PATH/src/visualization/visualize_point_cloud_with_3d_boxes.py \
    --input_folder_path_point_clouds $POINTS_PATH \
    --input_folder_path_labels $LABELS_PATH \
    --save_visualization_results \
    --output_folder_path_visualization_results $OUTPUT_PATH



echo "POINTS: $POINTS_PATH"
echo "LABELS: $LABELS_PATH"