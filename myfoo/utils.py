"""
utils.py

put random package-wide functions here, if you're doing things as a Python package
"""

def hello():
    print('hello world')

def helpstart():
    print("""
    Run `make ALL` to see how data/sqlized.sqlite is created from
     data/stashed/hello.txt
    """)

if __name__ == '__main__':
    helpstart()
