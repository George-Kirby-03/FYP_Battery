echo "Running notebook_server script..."

# --- Ensure the script runs from its own directory ---
cd "$(dirname "$0")" || exit 1

# --- Define venv path (parent directory) ---
PARENT_DIR="$(dirname "$PWD")"
VENV_PATH="$PARENT_DIR/python_env_temp"

# --- Check if venv exists ---
if [ ! -d "$VENV_PATH" ]; then
    echo "⚠️ No virtual environment found at $VENV_PATH. Please run venv_create.sh first."
    exit 1
fi  

# --- Activate the virtual environment ---
source "$VENV_PATH/bin/activate"    
# --- Start Jupyter Notebook ---
cd "$PARENT_DIR" || exit 1
python3 -m jupyter notebook