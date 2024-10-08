# ESPN Sports Core API v3 Validation

## Introduction
This suite builds upon the suite created in the [smokechecks repo][1]. While still encompassing the '200' status checks, it also validates that the fields delivered from the API are of the right type. Additional assertions can now be built upon this framework to further enhance the coverage. 


## Dependencies:
This test suite has only a few dependencies which would already be installed if the [Robot Quickstart][4] document was followed previously. 

### Robot Framework Library
[Robot Framework][2] is our selected platform to be utilized for test development.
```commandline 
pip install robotframework-requests
```

### Robot Framework Requests Library
[Robot Framework Requests][3] is a keyword library wrapper around the popular python requests library.
```commandline 
pip install robotframework-requests
```

## Usage
Similar to how the smokechecks were run, this suite can be executed from the project root by running the robot command. The difference, however, is that there are now libraries being included. The path to the libs folder either needs to be exported to your python path or, as shown below, can be included via the `--pythonpath` option at run time.

### Structure:
All test cases are stored in the `testsuite/` folder and all python-based classes can be found within the `lib/` directory. The `lib/validators/` directory is where custom validators will be stored. 
```text
espn-sports-core-validation/
├─ README.md
├─ rp.info                           (Reference for commands that can be used within run.sh to manipulate RP reporting)
├─ run.sh                            (Used to execute suite with RP hooks)
├─ variables.py                      (Settings file for RP integration - DO NOT COMMIT CHANGES!)
├─ docs/                            
│  ├─ *.html                         (Documentation for keywords and test suites)
├─ lib/
│  ├─ __init__.py
│  ├─ schemas/
│  │  ├─ __init__.py
│  │  ├─ common.py                   (Holds custom field type definitions)
│  │  ├─ SportsSchema.py             (Defines Schema details for validation)
│  ├─ validators/
│  │  ├─ __init__.py
│  │  ├─ ESPNSportsCoreValidator.py  (Python-based Core Validation Keywords & Logic)
├─ resource/
│  │  ├─ *.robot                     (Custom Robot-based Keywords, global variables and other resources)
├─ testsuite/
│  ├─ basic-validation-example.robot (Sample suite with basic details to get a user started.)
│  ├─ *.robot                        (Test definition. e.g.: football-tests.robot, baseball-tests.robot)

```


### Execution:
Basic local execution for testing and development purposes:
```commandline
# Launch testsuite from repo base dir with included python path:
robot --pythonpath $PWD testsuite/basic-validation-example.robot
```
To run with integrated ReportPortal reporting:
1) Ensure [variables.py][5] has been updated to include your RP information
2) Export the RP reporting enablement flag: `export REPORT_PORTAL_ENABLED=1`
3) Kick off execution via run.sh
```commandline
# Basic execution via run.sh:
./run.sh testsuite/basic-validation-example.robot

# Robot arguments can be passed the same was as before
./run.sh -i TAG -v VariableName:VariableValue testsuite/basic-validation-example.robot
```

### Doc Generation:
To generate the doc, for .py files and .robot files (Files which do not have testcases). 
For such type of files we have use libdoc. If we have tests under the .robot file then we have to go with testdoc
```commandline
# Basic command to generate a lib doc for .py and .robot files
python -m robot.libdoc <doc_generation_file_path_of_tests> <output_file_path/docName.html>

Ex: python -m robot.libdoc .\lib\validators\SoccerValidator.py .\libDocs\validators\SoccerValidator.html

# Basic command to generate a test doc for .robot files (which contains testcases)
python -m robot.testdoc <doc_generation_file_path_of_tests> <output_file_path/docName.html>

Ex: python -m robot.testdoc testsuite/alpine-skiing-tests.robot	libDocs/tests/alpine-skiing-tests.html
```
**_For more details-_**

Robot Framework Libdoc - https://robotframework.org/robotframework/2.1.2/tools/libdoc.html

Robot Framework TestDoc - https://robotframework.org/robotframework/2.1.2/tools/testdoc.html

## Known Issues

- lib/schemas/common.py
  - **TODO**: UID needs better validation than existing 
  - **TODO**: TimeOut needs better validation due to int vs dict between sports



[1]: https://gitlab.disney.com/roxas-api/espn-sports-core-smokecheck
[2]: https://pypi.org/project/robotframework/
[3]: https://pypi.org/project/robotframework-requests/
[4]: https://confluence.disney.com/pages/viewpage.action?spaceKey=CD&title=Robot+Framework+Quickstart
[5]: https://gitlab.disney.com/roxas-api/espn-sports-core-validation/-/blob/main/variables.py