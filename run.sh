#/bin/bash
export PYTHONPATH="$PATHONPATH:$PWD/lib"
USE_REPORT_PORTAL=${REPORT_PORTAL_ENABLED:-0}
LISTENERS="--listener robotframework_reportportal.listener"
VAR_FILE_INCLUDES="--variablefile variables.py"
echo report portal enabled: $REPORT_PORTAL_ENABLED
if [[ $USE_REPORT_PORTAL -ne 1 ]]
   then LISTENERS=""
   VAR_FILE_INCLUDES=""
fi
# /Library/Frameworks/Python.framework/Versions/3.10/bin/python3.10-intel64 -mrobot $LISTENERS $VAR_FILE_INCLUDES $*
robot $LISTENERS $VAR_FILE_INCLUDES $*
