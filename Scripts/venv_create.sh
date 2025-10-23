echo "Running install script..."
# Ensure the script runs from its own directory 
cd "$(dirname "$0")" || exit 1

PARENT_DIR="$(dirname "$PWD")"
VENV_PATH="$PARENT_DIR/python_env_temp"


if [ -d "$VENV_PATH" ]; then
    echo ""
    read -p "A virtual environment already exists at $VENV_PATH. Recreate (R) or Update packages (U)? [R/U] " CHOICE
    case "$CHOICE" in
        [Rr]* )
            echo "Recreating environment..."
            rm -rf "$VENV_PATH"
            python3 -m venv "$VENV_PATH"
            echo "New environment created."
            ;;
        [Uu]* )
            echo "Updating packages in existing environment..."
            ;;
        * )
            echo "Invalid choice. Exiting."
            exit 1
            ;;
    esac
else
    echo "Creating new environment..."
    python3 -m venv "$VENV_PATH"
fi

source "$VENV_PATH/bin/activate"


python -m pip install --upgrade pip
echo $(pwd)
ls -la

if [ -f "./requirements.txt" ]; then
    echo "Installing requirements..."
    pip install -U -r requirements.txt
else
    echo "No requirements.txt found — skipping dependency installation."
fi

echo ""
echo "Virtual environment setup complete at $VENV_PATH"


