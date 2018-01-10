#!/usr/bin/env python
"""
Build Docker Images.
"""
import os

import click
import compose.cli.command

PANDAS_VERSION = '0.21.0'
PROJECT = compose.cli.command.get_project('.')
REPO = 'amancevice/pandas'


@click.command(context_settings={'help_option_names': ['-h', '--help']})
@click.option('-a', '--alpine', help='Build on alpine', is_flag=True)
@click.option('-d', '--debian', help='Build on debian', is_flag=True)
@click.option('-j', '--jupyter', help='Build jupyter', is_flag=True)
@click.option('-s', '--slim', help='Build on debian:slim', is_flag=True)
@click.argument('VERSION', is_eager=True, nargs=-1)
def build(alpine, debian, jupyter, slim, version):
    """ Build Docker Images. """
    versions = sorted(version)
    builds = ['latest'] * debian + \
             ['alpine'] * alpine + \
             ['jupyter'] * jupyter + \
             ['slim'] * slim
    tags = []
    for build in builds:
        # Get service
        svc = PROJECT.get_service(build)

        # Build Python3 images
        for vsn in versions:
            tags += build_version(build, svc, vsn)

        if build != 'jupyter':
            # Build Python2 images
            svc.options['build']['context'] = \
                svc.options['build']['context'].replace('Python3', 'Python2')
            for vsn in version:
                tags += build_version(build, svc, vsn, 'python2')

    click.echo()
    for tag in sorted(tags):
        click.echo(click.style(tag, fg='green'))


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
        tags = ["{repo}:{base}",
                "{repo}:{vsn}-{base}",
                "{repo}:{vsn}-{python}-{base}"]
    elif python == 'python3':
        tags = ["{repo}:{vsn}-{python}-{base}"]
    else:
        tags = ["{repo}:{vsn}-{python}-{base}"]
    tags = sorted(x.format(repo=REPO, base=base, vsn=vsn, python=python)
                  for x in tags)
    for tag in tags:
        tag = tag.format(repo=REPO, base=base, vsn=vsn, python=python)
        click.echo(click.style(tag, fg='yellow'))
        svc.options['image'] = tag
        svc.build(build_args_override={'PANDAS_VERSION': vsn})
    return tags


if __name__ == '__main__':
    build()
