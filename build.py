"""
Build Docker Images.
"""
import os

import compose.cli.command


def build():
    """ Build Docker Images. """
    proj = compose.cli.command.get_project('.')
    for svc in sorted(proj.get_services(), key=lambda x: x.name):
        svc.build()


if __name__ == '__main__':
    build()
