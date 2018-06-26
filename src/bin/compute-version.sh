#!/usr/bin/env python3
import subprocess
import re

releaseTagListResult = subprocess.run(['git', 'tag', '-l', '--points-at', 'HEAD', 'release-*'], stdout=subprocess.PIPE, universal_newlines=True)
releaseTagListString = releaseTagListResult.stdout.strip()
releaseTagList = releaseTagListString.split('\n')
releaseTag = releaseTagList[-1]

if (len(releaseTag) > 0):

    versionSearchResult = re.search('release-(.*)', releaseTag)
    version = versionSearchResult.group(1) if hasattr(versionSearchResult, 'group') else '1.0.0'

    print (version)

else:

    # If there is no release-* tag on the comment then we assume that we want to build a
    # Release candidate so we have to look for the current RC version and append the Git
    # commit hash to create a unique release candidate String
    rcTagListResult = subprocess.run(['git', 'tag', '-l', 'rc-*'], stdout=subprocess.PIPE, universal_newlines=True)
    rcTagListString = rcTagListResult.stdout.strip()
    rcTagList = rcTagListString.split('\n')
    rcTag = rcTagList[-1]

    versionSearchResult = re.search('rc-(.*)', rcTag)
    version = versionSearchResult.group(1) if hasattr(versionSearchResult, 'group') else '1.0.0'
    gitCommitResult = subprocess.run(['git', 'rev-parse', '--short', 'HEAD'], stdout=subprocess.PIPE, universal_newlines=True)
    gitCommitHash = gitCommitResult.stdout.strip();
    print (version + "-RC-" + gitCommitHash)
