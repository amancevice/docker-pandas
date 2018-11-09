"""
Build Docker Images.
"""
import os

import click
import compose.cli.command
import docker

DOCKER = docker.APIClient()
LATEST_VERSION = '0.23.4'
REPO = 'amancevice/pandas'


@click.command(context_settings={'help_option_names': ['-h', '--help']})
@click.option('-v', '--version', help='Pandas version', multiple=True)
def build(version):
    """ Build Docker Images. """
    tags = []
    for pandas_version in version:
        env = {'PANDAS_VERSION': pandas_version}
        project = compose.cli.command.get_project('.', environment=env)
        project.build(build_args=env)
        vtags = [x.image_name for x in project.services]
        tags.extend(vtags)

        if pandas_version == LATEST_VERSION:
            for tag in vtags:
                if '-' in tag:
                    newtag = tag.replace(f'{LATEST_VERSION}-', '')
                else:
                    newtag = tag.replace(LATEST_VERSION, 'latest')
                DOCKER.tag(tag, newtag)
                tags.append(newtag)

    click.echo()
    for tag in tags:
        click.echo(click.style(tag, fg='green'))
    click.echo()


if __name__ == '__main__':
    build()
