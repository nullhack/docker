import setuptools

setuptools.setup(
    name="dags",
    packages=setuptools.find_packages(exclude=["dags_tests"]),
    install_requires=[
        "dagster==1.10.16",
        "dagit==0.11.9",
        "pytest",
    ],
)
