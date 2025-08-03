sudo apt install python3.12-venv
python3 -m venv venv
source venv/bin/activate
pip install maturin
maturin new my_rust_module
cd my_rust_module
maturin build --release