# smartthings_overprivilege_dataset
Dataset for SmartThings over-privileged applications.

This repository contains datasets for SmartThings apps. We used these datasets for detection of occurrences of privilege escalation (over-privilege) in SmartThings apps.

The datasets are divided into two folders: 1- A benchmark we created by injecting over-privilege vulnerabilities in SmartThings apps. 2- Publicly available datasets from SmartThings community, forums, marketplace and a dataset from researchers that developed HoMonit (system for monitoring smart home apps).

In this research, we refer to over-privilege in SmartThings according to three cases: 1- The first case of over-privilege is caused by coarse SmartApp-SmartDevice Binding. 2- The second case is caused semantically when the app requests resources not mentioned in the app's description. 3- The third case is caused semantically by coarse-Grained Capabilities.

For each case of over-privilege, we provide benign and malicious datasets in our benchmark for testing the efficiency of our software analysis tool.

The tools executables are provided and have been tested on a Mac computer. Use the following commands when running the executables:

For "Static analysis - Case 1":
./static_case_1.x ${filename}

For "Static/Semantic analysis - Cases 1, 2 & 3":

./static_semantic_cases123.x ./test.txt --filename ${filename}

For "Static/Semantic analysis - Cases 2 & 3":

./static_semantic_cases23.x ./test.txt --filename ${filename}

(create an empty text file and name it test.txt to use it in the commands)
