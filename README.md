# Single-script fixes for macOS issues
This is a curated assortment of Ruby scripts which act as ***informative***, ***non-destructive***, ***run-once*** solutions to various issues plaguing macOS. They have ***no dependencies*** other than a normal installation of Ruby, which comes with macOS by default.

Each script is also provided as a gist, so they can be downloaded/forked/starred/shared individually. More importantly, the gist page provides an ideal location for community discussion regarding specific problems/solutions, as well as additional information and/or resources.

##### *ORGANIZATION*
Scripts are separated into three categories, and organized by OS version.

- **Fixes**: solutions to specific problems I have run across under certain system configurations
- **Optimizations**: customizations which improve or enhance the system *(opinionated!)*
- **Homebrew**: solutions specific to Homebrew-related issues

##### *COMPATIBILITY*
Scripts are **ONLY** guaranteed to have been tested and compatible under systems as documented below (unless otherwise explicitly stated within the file).

## macOS 10.9 (*Mavericks*)
### Fixes
1. **Install Nokogiri**

    Installs the `nokogiri` gem by configuring for use with modern `libxml2`, `libxslt`, and `libiconv` libs
    
2. **`systemstats` memory leak**

    Disables the `systemstats` daemon which can cause massive memory leakage in Mavericks
    
3. **Rebuild the launch services database** *(INCOMPLETE)*

    This solves multiple problems, including:
    1. App Store apps showing as 'installed' when they aren't, preventing them from being installed.
    
4. **Disable `CrashReporter`**

    Permanently disable `CrashReporter`, which can sometimes swallow huge system resources by endlessly looping

### Optimizations
1. Remove the default Ruby executables pre-installed on macOS

### Homebrew
1. Fix issues with `oxfuse` libs

---
### TODO:
- add disclaimer
- setup gists and links
- integrate brew-fixes
- feature ideas for fixes
    - tags (i.e. `app-store`)
