# Script to delete files older than one hour - run from cron
# Wednesday, November 07, 2007
#!/bin/bash
find /path/to/dir -cmin +60 -type f -maxdepth 1 -exec rm {} \;
