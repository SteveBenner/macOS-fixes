# Single-script fixes for macOS issues
This is a library of Ruby scripts curated specifically to act as ***informative***, ***non-destructive***, ***run-once*** solutions to some common issues plaguing macOS. They have ***no dependencies*** other than a normal installation of Ruby, which comes with macOS by default.

Each script is provided as its own gist so they can be downloaded/forked/starred/shared individually. More importantly, the gist page provides an ideal location for community discussion regarding specific problems/solutions, as well as additional information and/or resources.

---
### macOS 10.9 - *Mavericks*

1. **Install Nokogiri**

    Installs the `nokogiri` gem by configuring for use with modern `libxml2`, `libxslt`, and `libiconv` libs
    
2. **`systemstats` memory leak**

    Disables the `systemstats` daemon which can cause massive memory leakage in Mavericks
    
3. **Rebuild the launch services database** *(INCOMPLETE!)*

    This solves multiple problems, including:
    1. App Store apps showing as 'installed' when they aren't, preventing them from being installed.
    
4. **Disable `CrashReporter`**

    Permanently disable `CrashReporter`, which can sometimes swallow huge system resources by endlessly looping


---
### TODO:
- add disclaimer
- setup gists
- integrate brew-fixes
- feature ideas for fixes
    - tags (i.e. `app-store`)
