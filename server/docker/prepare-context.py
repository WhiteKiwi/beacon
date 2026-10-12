#!/usr/bin/env python3
"""Prepare a credential-free runtime context outside the shared Docker VM."""
import argparse
from pathlib import Path
import shutil
import subprocess

parser = argparse.ArgumentParser()
parser.add_argument('destination', type=Path)
args = parser.parse_args()
root = Path(__file__).resolve().parents[1]
destination = args.destination
if not destination.is_absolute() or destination.exists():
    raise SystemExit('A fresh absolute context directory is required')
destination.mkdir(mode=0o700)
for name in ('package.json', 'pnpm-lock.yaml'):
    shutil.copyfile(root / name, destination / name)
subprocess.run(['pnpm', 'install', '--prod', '--frozen-lockfile', '--ignore-scripts',
                '--network-concurrency=2', '--child-concurrency=1'],
               cwd=destination, check=True)
shutil.copytree(root / 'dist', destination / 'dist', symlinks=True)
for name in ('Dockerfile', 'healthcheck.cjs'):
    shutil.copyfile(root / 'docker' / name, destination / name)
(destination / 'pnpm-lock.yaml').unlink()
for path in destination.rglob('*'):
    if path.is_symlink():
        try:
            path.resolve(strict=True).relative_to(destination)
        except (ValueError, FileNotFoundError):
            raise SystemExit('A dependency link escapes the runtime context')
    if path.suffix == '.node':
        raise SystemExit('Native dependencies require separate Linux qualification')
print('Credential-free JavaScript runtime context prepared')
