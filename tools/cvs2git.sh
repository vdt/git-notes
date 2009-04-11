#!/bin/bash

less $0
exit

# -------- sorry, not implemented yet
#
# for now, just read this and be happy!

# FIRST: DO NOT USE THE BUILTIN 'git cvsimport'.  Problems I had using it
# include missing tags, branches grafted to the wrong place (by comparing a
# --simplify-by-decoration tree later), missing commits (which is what
# originally made me start investigating), and even missing files in the root
# of the repo, like Makefile!!

# part 1

# - download cvs2svn version 2.1 or higher from somewhere within
#   http://cvs2svn.tigris.org/cvs2git.html
#   DO NOT BE DISTRACTED BY THE MISLEADING REFERENCES TO A MYTHICAL "cvs2git"
#   COMMAND IN THAT PAGE :)

# - expand it somewhere, and cd there

# - in there, create an options file from the original, like shown in the diff
#   at the end of this file (change accordingly of course; this diff only
#   shows where you should make the changes, not what)

#   !!!!! IMPORTANT WARNING !!!!!

#   DO NOT USE the "test-data/main-cvsrepos/cvs2svn-git.options" file as a
#   starting point.  Though the intermediate files were about 3X smaller when
#   I used it, there were lots of inaccuracies w.r.t the $id type stuff, and
#   for some older tags whole files were missing, compared to the
#   corresponding CVS checkout.  The "-inline" version seems to work fine; no
#   errors on any of the 30 or so tags I checked on a project that had about 5
#   years of work in CVS.

# - run
#       ./cvs2svn --options=my.c2soptions
# - when it completes, check the 'cvs2svn-tmp' directory for a rather large
#   file called git-dump.dat

# part 2

# - make an empty directory, cd to it, git init, then run
#       cat ~-/cvs2svn-tmp/git-dump.dat        | git fast-import
# - if you used the non-inline options file, or wanted to test that as well,
#   there would be *two* files in the cvs2svn-tmp directory, and the command
#   would now be:
#       cat ~-/cvs2svn-tmp/git-{blob,dump}.dat | git fast-import

# that should do...

cat <<EOF >/dev/null
diff --git 1/test-data/main-cvsrepos/cvs2svn-git-inline.options 2/my.c2soptions.inline
index 635f9cd..a5a4018 100644
--- 1/test-data/main-cvsrepos/cvs2svn-git-inline.options
+++ 2/my.c2soptions.inline
@@ -39,7 +39,7 @@ ctx.cross_branch_commits = False
 # record the original author (for example, the creation of a branch).
 # This should be a simple (unix-style) username, but it can be
 # translated into a git-style name by the author_transforms map.
-ctx.username = 'cvs2svn'
+ctx.username = 'someone'
 
 # CVS uses unix login names as author names whereas git requires
 # author names to be of the form "foo <bar>".  The default is to set
@@ -59,7 +59,7 @@ author_transforms={
 
     # This one will be used for commits for which CVS doesn't record
     # the original author, as explained above.
-    'cvs2svn' : ('cvs2svn', 'admin@example.com'),
+    'someone' : ('someone', 'someone@my.company.com'),
     }
 
 # This is the main option that causes cvs2svn to output to git rather
@@ -115,7 +115,7 @@ run_options.add_project(
     # The path to the part of the CVS repository (*not* a CVS working
     # copy) that should be converted.  This may be a subdirectory
     # (i.e., a module) within a larger CVS repository.
-    r'test-data/main-cvsrepos',
+    r'../cvsroot/myproj',
 
     # See cvs2svn-example.options for more documention about symbol
     # transforms that can be set using this option.
EOF