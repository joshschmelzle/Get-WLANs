Release History
===============

UNRELEASED (xxx-xx-xx)
----------------------

- TBD

0.0.4 (2020-01-07)
------------------

- Scans are now initiated on only 1 NIC. Previously, all available wireless NICs were used to initiate scans
  - Use the -interface param to specify a different one if needed
  - Use the -verbose param to see which NIC is used
- Added capability and IE size props
- Removed code that doesn't do anything
- Changed static wait time from 3 seconds to 4 seconds before requesting scan results

0.0.3 (2020-01-04)
------------------

- Second upload which forced incrementing version for uniqueness

0.0.2 (2020-01-04)
------------------

- Fix C# code file import
- Fix version numbers for manifest and PSGallery
- Add -verbose param handling

0.0.1 (2020-01-03)
------------------

First release
