from setuptools import setup, Extension
from pybind11.setup_helpers import Pybind11Extension, build_ext

ext_modules = [
    Pybind11Extension("example", ["example.cpp"]),
]

setup(
    name="example",
    version="0.0.1",
    ext_modules=ext_modules,
    cmdclass={"build_ext": build_ext},
    package_data={"": ["example.pyi"]},
    include_package_data=True,
    zip_safe=False,
)