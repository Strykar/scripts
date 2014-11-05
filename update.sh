#!/bin/sh
rsync -F --exclude="*mkinit*" -av --progress rsync://rsync.osuosl.org/slackware/slackware-12.2/patches/packages/ .
