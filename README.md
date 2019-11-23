# pydataproject-template

**Dan's template for Python-based data-wrangling projects**

## Why? 

Because I always forget how to do this stuff, when starting new projects... :(

## How to use

Clone this repo and install `myfoo` as a local project:

```sh
$ git clone https://github.com/dannguyen/pydataproject-template.git
$ cd pydataproject-template
$ pip install -e .
$ python myfoo  # prints hello world
```

To see an example of how the [Makefile](Makefile) executes the data-processing pipeline, e.g. creating the `data/sqlized.sqlite` database from [data/stashed/hello.txt](data/stashed/hello.txt):

```sh
$ make ALL
```


To run tests:

```sh
$ pytest
```



## Examples in action

- https://github.com/storydrivendatasets/white_house_salaries


## Tree inventory

```
├── data
|   ├── data-manifest.yaml  -- lightweight log of where you got your data
|   ├── sqlized.sqlite      -- a quick database created by `make sqlize`
|   | 
│   ├── stashed             -- store your original and immutable datafiles here
│   └── wrangled            -- the end-result of wrangling, ideally csv files
|
├── myfoo                   -- python package for data processing scripts
├── scripts                 -- helper scripts, not necessarily python
└── tests                   -- tests for your python package
```


## Resources

- This [great answer to the question, *Importing modules from parent folder*](https://stackoverflow.com/a/50194143/160863), is something I always forget how to do.


