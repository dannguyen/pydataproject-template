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

To see an example of how the [Makefile](Makefile) executes the data-processing pipeline, e.g. creating the `data/myfoo.sqlite` database from [data/collected/hello.txt](data/collected/hello.txt):

```sh
$ make ALL
```


To run tests:

```sh
$ pytest
```


## Stages of data work


### collect

the raw, original data. In its original form, including disparate file formats and across multiple files:

[data/collected/hello.txt](data/collected/hello.txt):

```
name    birthday    city
Hopper, Grace   12/9/1906   NYC
Kernighan, Brian    1/1/1942    Toronto
Apple, Tim  11/1/1960   Mobile
```


[data/collected/world.txt](data/collected/world.txt):


```
name    birthday    city
Cage, Nicolas   1/7/1964    Long Beach
Weaver, Sigourney   10/8/1949   Manhattan
```


### fuse

This step gathers all the original data files and:

- converts the file formats, e.g. getting CSV out of PDF, XLS, HTML, etc.
- concatenates the data into a single file, when the original data was split across multiple files (e.g. by year)

Very little to no cleaning is done, with the exception of cleaning up header names and changing column order.

```sh
$ make fuse
```

- calls [scripts/fuse.py](scripts/fuse.py)

Which converts and concatenates the 2 collected tab-delimited files into a single CSV:

[data/fused/helloworld.csv](data/fused/helloworld.csv)

```
source,full_name,birthdate,birthplace
hello,"Hopper, Grace",12/9/1906,NYC
hello,"Kernighan, Brian",1/1/1942,Toronto
hello,"Apple, Tim",11/1/1960,Mobile
world,"Cage, Nicolas",1/7/1964,Long Beach
world,"Weaver, Sigourney",10/8/1949,Manhattan

```


A `source` column is added to keep track of where each data record came from (e.g. either the `hello` or the `world` file). Existing columns are renamed, e.g. `name` to `full_name`, `birthday` to `birthdate`, and `city` to `birthplace`. But otherwise, the actual content of the data is untouched. 

Think of the **fuse** step as doing the least amount of work and data alteration to deliver the most convenient, easy-to-understand files for the person doing the next phase of **wrangling**.


### wrangle

Wrangle is a catch-all term for data transformation, cleaning, filtering, tidying, and reconciling, i.e. when the data becomes all but impossible to revert to its original "collected" form. Which is *fine* – this kind of irreversible work is needed with real-world data, which wasn't collected or structured to accommodate whatever interesting and bespoke analysis and project you have in mind. 


Running the `make wrangle` step simply executes the [scripts/wrangle.py](scripts/wrangle.py) file. Which reads from [data/fused/helloworld.csv](data/fused/helloworld.csv) and produces [data/wrangled/helloworld.csv](data/wrangled/helloworld.csv):


```
source,last_name,first_name,current_age,birthdate,birthplace
hello,Apple,Tim,59,1960-11-01,Mobile
world,Cage,Nicolas,55,1964-01-07,Long Beach
hello,Hopper,Grace,112,1906-12-09,NYC
hello,Kernighan,Brian,77,1942-01-01,Toronto
world,Weaver,Sigourney,70,1949-10-08,Manhattan
```


Because the example data is pretty trivial, there aren't any irreversible steps. But you can see that the data itself has been transformed and augmented far beyond what the **fuse** step did:

- `full_name` column was parsed and split into `last_name` and `first_name`
- `birthdate` column was reformatted from `M/D/YYYY` to iso8601's `yyyy-mm-dd`
- `current_age` column is derived from `birthdate`


### sqlize

I find SQL to be one of the fastest and most convenient ways to explore newly organized data (e.g. tabular data, via fused and wrangled), especially with the ubiquity of SQLite.

In this template repo I've included a shell script, [scripts/sqlize.sh](scripts/sqlize.sh), that reads the CSVs from data/fused and data/wrangled and, from each CSV, creates a quick and dumb table (i.e. every field is just plain text), e.g. `fused_helloworld` and `wrangled_helloworld`, and throws it in a file, [data/myfoo.sqlite](data/myfoo.sqlite)

Oftentimes, with a very complicated data set, the wrangling process is a lot of trial and error. I find writing SQL queries to do sanity checks and aggregations more efficient than R and pandas, generally, but everyone has differing opinions and tolerances of SQL :)

Run `make sqlize` to build [data/myfoo.sqlite](data/myfoo.sqlite). Or, run the data work from the start with `make ALL`
 



## Examples in action

- https://github.com/storydrivendatasets/white_house_salaries


## Tree inventory

```
├── data
|   ├── myfoo.sqlite      -- a quick database created by `make sqlize`
|   | 
│   ├── collected             -- store your original and immutable datafiles here
│   └── wrangled            -- the end-result of wrangling, ideally csv files
|
├── data-manifest.yaml      -- lightweight log of where you got your data
|
├── myfoo                   -- python package for data processing scripts
├── scripts                 -- helper scripts, not necessarily python
└── tests                   -- tests for your python package
```


## Resources

- This [great answer to the question, *Importing modules from parent folder*](https://stackoverflow.com/a/50194143/160863), is something I always forget how to do.


