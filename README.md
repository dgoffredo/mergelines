mergelines
==========
Merge lines from a directory of sorted text files.

Why
---
They told me to.

What
----
`mergelines` is a shell script that, given an input directory and an output
file, merges all of the nonempty lines from files in the input directory into
the output file.  The nonempty lines in the input files must be sorted within
each input file.

For example,
```console
$ ./mergelines test/breathing/ output
$ cat output
harrison
lennon
mccartney
starr
zfoo
```

If any of the input files has lines out of order, a diagnostic is printed to
standard error and `mergelines` returns a nonzero status code.

How
---
### Build
```console
$ make
```

### Dependencies
`makelines` requires GNU `make` and `cat` to build.  `makelines` requires the
following utilities to run once built:

- `make`
- `mktemp`
- GNU `sed`
- GNU `sort`
- `cat`
- `rm`
- POSIX-compatible `/bin/sh`

More
----
### Complexity Analysis of the Algorithm
`mergelines` works by pre-processing each input file individually into a
temporary file and then doing a unique merge of those temporary files into
the output file.

Not counting the size of the resulting output file, `mergelines` uses storage
at most equal to the total size of the input, as a (de-empty-lined)
temporary file is produced for each file in the input directory.  This is not
optimal, but also is not necessarily terrible since the file system is used
for (potentially large) not-in-memory storage.

Each input file first has empty lines removed from it; this runs in linear
time.  Each file is then checked to see whether it's sorted; this also runs in
linear time.  Finally, the sorted files are merged into the output; this also
runs in linear time.  Thus, the time complexity of the algorithm is linear.

### Ways to Improve the Current Implementation
The linear space requirement of `mergelines` is unfortunate, and it means that:

1. `mergelines` can't be used for input that nearly fills the disk.
2. `mergelines` can't be used "online" to process arbitrary amounts of data.

Additionally, if the number of files in the input directory is greater than
either of:

1. the number of command line arguments the shell can pass to a process
2. the number of file descriptors the current user can have open

then `mergelines` will fail.

I can imagine an alternative, more complicated, implementation that
incrementally checks the sortedness of each input file while simultaneously
skipping empty lines and merging the resulting lines into the output.  If the
number of input files is truly large, the implementation could even use a pool
of file handles to ensure that not too many files are open at once.

This would require memory proportional to the number of files in the
directory, which can be very large but is likely better than requiring
storage equal to the total input size.  This algorithm would also work
"online," e.g. if the input files were named pipes producing arbitrarily large
input.

On an unrelated note, when an input file is not sorted, the diagnostic message
printed by `mergelines` leaks implementation details (GNU `make` garbage),
which is ugly.  Better would be to intercept this output and use it to
produce a minimal diagnostic message independent of the underlying
implementation.

Finally, the use of shell scripts and GNU `make` to solve a problem is, in my
opinion, inadvisable for software at scale.  I just couldn't resist the
temptation to use command line tools (`sort`, `sed`, `make`) to solve this
problem in what seemed like a natural way.