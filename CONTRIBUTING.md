# Contributing

Contributions to the project are always welcome and encouraged, if you intend to contribute,
be sure follow the guidelines in this document.

# Code Style

To keep the code consistent, please follow the guidelines below where possible:
- Function names should use `PascalCase`
- File globals that are mutable should use `PascalCase`
- Scoped local variables and arguments should use `camelCase`
- Global constants (including file global constants) should be entirely uppercase with underscores for separation
- Global functions should be avoided, prefer local functions.
If you need a global function, put it in the `gRust` table
- `pl` should be used in place of `ply` for variables that refer to a player

If you want a reference point for how code should look in this repository,
[freelook_cl.lua](../../gamemode/core/player/freelook_cl.lua) is a good example

# Bug Fixes

If you encounter a bug, you are welcome to submit a pull request to fix it. If all is good, your pull request
will be merged.

# New Features

If you want to contribute a new feature, you should first create a feature request in the Issues tab if one
doesn't already exist. In the feature request, you can discuss with the maintainers about how the feature
can be best implemented into the core gamemode.
