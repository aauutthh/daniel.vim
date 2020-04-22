
import os
import json
Default_Flags = [
    '-Wall',
    '-Wextra',
    # '-Werror',
    '-fexceptions',
    '-DNDEBUG',
    '-std=c++17',
    '-x', 'c++',
    # '-isystem',
    # '/usr/include',
    # '-isystem',
    # '/usr/local/include',
]


Default_Flags.extend([
    "-I./.lib/linux64",
    "-I../.lib/linux64/osal_include",
])


ROOT_FLAG_FILE = ['.root', '.top']


def DirectoryOfThisScript():
    return os.path.dirname(os.path.abspath(__file__))


def RootPath(fname: str):
    base = os.path.dirname(os.path.abspath(fname))
    dirname = base
    while dirname != '/':
        flagfiles = list(filter(os.path.exists,
                                [os.path.join(dirname, d)
                                 for d in ROOT_FLAG_FILE]
                                ))
        if len(flagfiles) > 0:
            break
        dirname = os.path.dirname(dirname)
    if dirname == '/':
        return base
    else:
        return dirname


def GenFlags(dirname: str):
    flagfiles = list(filter(os.path.exists,
                            [os.path.join(dirname, d) for d in ROOT_FLAG_FILE]
                            ))
    if len(flagfiles) == 0:
        return Default_Flags
    else:
        flags = Default_Flags
        try:
            j = json.load(open(flagfiles[0]))
            flags.extend(j['flags'])
        finally:
            return flags


# This is the entry point; this function is called by ycmd to produce flags for
# a file.
def FlagsForFile(filename, **kwargs):
    rootpath = RootPath(filename)
    flags = GenFlags(rootpath)
    out = {
      'flags': flags,
      'include_paths_relative_to_dir': rootpath
    }
    print(filename, ":", out)
    print("clang++ " + " ".join(out['flags']))
    return out
