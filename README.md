# Ploomber CI

Make sure your Data Science pipeline is reproducible by automatically running it each time you push to your repository.


## How it works

On each push, Ploomber CI will do the following:

1. Fetch your code in a clean Docker container
2. Install dependencies using a conda `environment.yml` or `requirements.txt`
3. Run your pipeline using a `pipeline.yaml` file


## `pipeline.yaml`

This file tells Ploomber CI how to run your pipeline, here's an example:

```yaml
# each element is a task to run
- class: NotebookRunner
  name: load
  # which notebook to execute
  source: load.ipynb
  # generated files: nb is the executed notebook (with outputs),
  # data is a csv data file
  product:
    nb: output/load.ipynb
    data: output/data.csv

- class: NotebookRunner
  name: clean
  source: clean.ipynb
  product:
    nb: output/clean.ipynb
    data: output/clean.csv
  # specify dependencies: run load first, then clean
  upstream: load

- class: NotebookRunner
  name: plot
  source: plot.ipynb
  product: output/plot.ipynb
  # you can specify multiple dependencies
  upstream: [clean]
```

Output from one task is passed to the next one by injecting a cell with parameters at runtime. Pipeline execution and parameter resolution is powered by our package [Ploomber](https://github.com/ploomber/ploomber). To know how parameters are passed between notebooks, [click here](https://ploomber.readthedocs.io/en/stable/guide/param-resolution.html#Parameter-resolution-in-NotebookRunner).


Note: You have to make sure that any folder used for output already exists, you can include a `prepare.sh` script in your repo to ensure this:

```bash
# prepare.sh
mkdir output/
```

## Github Action

Ploomber CI works as a [Github Action](https://github.com/features/actions), to activate it, include the following file in `.github/workflows/main.yaml`:

```yaml
# this tells Github to run this on every push
on: push

jobs:
  test-pipeline:
    runs-on: ubuntu-latest
    name: Test pipeline
    steps:
    - uses: actions/checkout@v2
    - uses: ploomber/ci@v1.0
```


## Example

[Check out this example pipeline](https://github.com/ploomber/projects/tree/master/spec), you can see the result from each commit by [clicking here](https://github.com/ploomber/projects/actions?query=workflow%3Aci).



## Running locally

If you want to run your pipeline locally, first install [Ploomber](https://github.com/ploomber/ploomber):

```bash
pip install "ploomber[all]"
```


Then run:

```bash
python -m ploomber.entry pipeline.yaml --action build
```

Or to start an interactive session:

```bash
ipython -i -m ploomber.entry pipeline.yaml -- --action status
```

When using the interactive mode, You can use Ploomber's debugging tools to fix errorsr in your pipeline. [Click here to know more](https://ploomber.readthedocs.io/en/stable/guide/debugging.html#Debugging-NotebookRunner-tasks).


## Questions?

[We're here to help, click here to ask us anything.](https://github.com/ploomber/ci/issues/new)