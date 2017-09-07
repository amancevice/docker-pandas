#!/usr/bin/env python
"""
Build Docker Images.
"""
import os

import click
import compose.cli.command

PANDAS_VERSION = '0.20.3'
PROJECT = compose.cli.command.get_project('.')
REPO = 'amancevice/pandas'
BASES = [x.name for x in PROJECT.get_services()]


def jupyter_check(ctx, param, value):
    if ctx.params['base'] == 'jupyter' and len(value) > 1:
        raise click.BadParameter('Cannot build jupyter with multiple versions')
    elif ctx.params['base'] == 'jupyter' and value[0] != PANDAS_VERSION:
        raise click.BadParameter('Cannot build jupyter with --version option')
    return value


@click.command(context_settings={'help_option_names': ['-h', '--help']})
@click.argument('BASE',
                default='latest',
                is_eager=True,
                type=click.Choice(BASES))
@click.option('-v', '--version',
              callback=jupyter_check,
              default=[PANDAS_VERSION],
              help='Pandas version',
              multiple=True)
def build(base, version):
    """ Build Docker Images. """
    # Get service
    svc = PROJECT.get_service(base)

    # Build Python3 images
    [build_version(base, svc, x) for x in sorted(version)]

    if base != 'jupyter':
        # Build Python2 images
        svc.options['build']['context'] = \
            svc.options['build']['context'].replace('Python3', 'Python2')
        [build_version(base, svc, x, 'python2') for x in sorted(version)]


def build_version(base, svc, vsn, python='python3'):
    if base == 'jupyter':
        tags = ["{repo}:{base}"]
    elif base == 'latest' and python == 'python3' and vsn == PANDAS_VERSION:
        tags = ["{repo}:{base}", "{repo}:{vsn}", "{repo}:{vsn}-{python}"]
    elif base == 'latest' and python == 'python3':
        tags = ["{repo}:{vsn}", "{repo}:{vsn}-{python}"]
    elif base == 'latest' and python != 'python3':
        tags = ["{repo}:{vsn}-{python}"]
    elif python == 'python3' and vsn == PANDAS_VERSION:
        tags = ["{repo}:{base}", "{repo}:{vsn}-{python}-{base}"]
    elif python == 'python3':
        tags = ["{repo}:{vsn}-{python}-{base}"]
    else:
        tags = ["{repo}:{vsn}-{python}-{base}"]
    tags = \
        [x.format(repo=REPO, base=base, vsn=vsn, python=python) for x in tags]
    for tag in sorted(tags):
        tag = tag.format(repo=REPO, base=base, vsn=vsn, python=python)
        click.echo(click.style(tag, fg='green'))
        svc.options['image'] = tag
        svc.build(build_args_override={'PANDAS_VERSION': vsn})


if __name__ == '__main__':
    build()
