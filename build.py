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
BASES = [x.name for x in PROJECT.get_services() if x.name != 'latest']


@click.command(context_settings={'help_option_names': ['-h', '--help']})
@click.argument('VERSION',
                default=[PANDAS_VERSION],
                is_eager=True)
@click.option('-b', '--build',
              callback=lambda x, y, z: set(('latest',) + z),
              default=['latest'],
              help="Additional base(s) to build",
              multiple=True,
              type=click.Choice(BASES))
def build(version, build):
    """ Build Docker Images. """
    version.sort()
    tags = []
    for key in build:
        # Get service
        svc = PROJECT.get_service(key)

        # Build Python3 images
        for vsn in version:
            tags += build_version(key, svc, vsn)

        if key != 'jupyter':
            # Build Python2 images
            svc.options['build']['context'] = \
                svc.options['build']['context'].replace('Python3', 'Python2')
            for vsn in version:
                tags += build_version(key, svc, vsn, 'python2')

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
