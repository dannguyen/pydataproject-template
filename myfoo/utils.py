"""
utils.py

put random package-wide functions here, if you're doing things as a Python package
"""

def hello():
    print('hello world')

def helpstart():
    print("""
    Run `make ALL` to see how data/myfoo.sqlite is created from
     data/collected/hello.txt and data/collected/world.txt
    """)

if __name__ == '__main__':
    helpstart()
