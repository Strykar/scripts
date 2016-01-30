#!/bin/sh
#Script to rsync Slackware security updates and check their signatures
#rsync -F --exclude="*mkinit*" -av --progress rsync://rsync.osuosl.org/slackware/slackware-12.2/patches/packages/ .
#rsync -F --exclude="*mkinit*" --exclude='linux-3.10.17-2' -av --progress rsync://rsync.osuosl.org/slackware/slackware64-14.1/patches/packages/ .

UPDIR=/tmp/updates

/usr/bin/rsync -F --exclude-from '$UPDIR/exclude.txt' -avh rsync://rsync.osuosl.org/slackware/slackware64-14.1/patches/packages/ $UPDIR

printf '%s\n' 'RSYNC COMPLETE! VERIFYING GPG SIGNATURES NOW PLS WAIT...'
if ! /usr/bin/gpg --verify-files $UPDIR/*.asc > /dev/null 2>&1; then
printf '%s\n\n' 'OYE! SOME FILES FAILED VERIFICATION, REVIEW GPG VERIFICATION BY HAND.' >&2
else
printf '%s\n\n' '.....GOOD SIGNATURES FROM <security@slackware.com>!' >&2
exit 1
fi
