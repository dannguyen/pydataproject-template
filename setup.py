from setuptools import setup, find_packages

setup(
    name='mypkg',
    version='0.0.1',
    packages=find_packages(),
    install_requires=[
        'pytest',
        'PyYaml>=5.1',
    ]
)
