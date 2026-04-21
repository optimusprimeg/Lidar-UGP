#!/bin/bash
set -euo pipefail

# Ensure the script runs with the prepared TUMTraf environment.
source /opt/conda/etc/profile.d/conda.sh
conda activate tumtraf

# ===== PATH CONFIG =====
DEVKIT_PATH="/workspaces/Lidar-UGP/tum-traffic-dataset-dev-kit-main"
DATASET_PATH="/workspaces/Lidar-UGP/a9_dataset_r02_s01"

CAMERA_ID="s110_camera_basler_south1_8mm"
LIDAR_ID="s110_lidar_ouster_south"

IMAGE_PATH="$DATASET_PATH/images/$CAMERA_ID"
POINTS_PATH="$DATASET_PATH/point_clouds/$LIDAR_ID"
LABELS_PATH="$DATASET_PATH/labels_point_clouds/$LIDAR_ID"
OUTPUT_PATH="/workspaces/Lidar-UGP/output_camera"

# ===== EXPORT =====
export PYTHONPATH="${PYTHONPATH:-}:$DEVKIT_PATH"

# ===== RUN =====
python $DEVKIT_PATH/src/visualization/visualize_image_with_3d_boxes.py \
    --camera_id $CAMERA_ID \
    --lidar_id $LIDAR_ID \
    --input_folder_path_images $IMAGE_PATH \
    --input_folder_path_point_clouds $POINTS_PATH \
    --input_folder_path_labels $LABELS_PATH \
    --viz_mode box2d,box3d,mask,track_history \
    --viz_color_mode by_category \
    --output_folder_path_visualization $OUTPUT_PATH \
    --detections_coordinate_system_origin s110_lidar_ouster_south \
    --labels_coordinate_system_origin s110_lidar_ouster_south



echo "POINTS: $POINTS_PATH"
echo "LABELS: $LABELS_PATH"