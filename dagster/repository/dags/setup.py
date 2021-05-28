import setuptools

setuptools.setup(
    name="dags",
    packages=setuptools.find_packages(exclude=["dags_tests"]),
    install_requires=[
        "dagster==0.11.9",
        "dagit==0.11.9",
        "pytest",
    ],
)
