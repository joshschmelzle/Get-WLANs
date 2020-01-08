
# KNOWN ISSUES

## Execution Policy Restrictions

Script fails to run because the system policy disallows it.

```
PS E:\dev\repos\Get-WLANs> .\scan.ps1
.\scan.ps1 : File E:\dev\repos\Get-WLANs\scan.ps1 cannot be loaded because running scripts is disabled on this
system. For more information, see about_Execution_Policies at https:/go.microsoft.com/fwlink/?LinkID=135170.
At line:1 char:1
+ .\scan.ps1
+ ~~~~~~~~~~
    + CategoryInfo          : SecurityError: (:) [], PSSecurityException
    + FullyQualifiedErrorId : UnauthorizedAccess
```

To get around this, you must have admin privileges to change the execution policy. 

### Change Execution Policy to Allow Script Execution

Run powershell as Administrator.

```
# check current execution policy
> Get-ExecutionPolicy

> Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned

# verify execution policy change
> Get-ExecutionPolicy
```

### How to Revert Changes

Run powershell as Administrator.

```
> Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy restricted
```

## Scan Wait Interval is Hard Coded

This script does not use callbacks, but instead waits a set number of seconds after a scan to retrieve the scan results. This is not ideal, but should work for the most part. 
