# OpenROAD Build Issue Report & Resolution Log

| Date |System| Project                                                    |
|---|---|---|
| 3-June-2025  | Ubuntu 22.04.5 LTS, 3.8 GiB RAM | OpenROAD-flow-scripts — local build using `./build_openroad.sh --local` |


## Summary

The attempt to build OpenROAD locally encountered several critical errors due to memory limitations and permission issues. The main blocker was insufficient memory (RAM + swap), leading to process termination during compilation. With proper resource management and permission adjustments, the build was completed successfully.


## Chronology of Issues Faced

### 1. Permission Denied on Dependency File

**Error:**
```
./tools/OpenROAD/etc/DependencyInstaller.sh: line 968: openroad_deps_prefixes.txt: Permission denied
```

**Solution:**

Manually changed permissions to allow access:

```
chmod 777 openroad_deps_prefixes.txt
```
This granted full read/write/execute permissions to the file, resolving the issue.

### 2. Compilation Terminated - Killed Signal

**Error:**

```
g++: fatal error: Killed signal terminated program cc1plus
compilation terminated.
gmake: *** [Makefile:146: all] Error 2
```

**Cause:**

This was due to an out-of-memory (OOM) condition. The cc1plus compiler process was terminated by the Linux OOM-killer due to insufficient available RAM and swap.

### 3. Swap Space Exhausted

**3.1 System Output from `free -h`:**

```
Mem:           3.8Gi       3.7Gi        47Mi
Swap:          5.0Gi       5.0Gi          0B
```

**3.2 Initial attempt to increase swap failed:**
```
sudo fallocate -l 4G /swapfile
fallocate: fallocate failed: Text file busy
```
This happened because the swapfile was in use and needed to be turned off before resizing.


## Steps Taken to Resolve

### Step 1: Clean Previous Build

```
./build_openroad.sh --local --clean
```
This cleared the previous build artifacts to avoid contamination or misconfiguration.

### Step 2: Increase Swap Memory

**2.1 Turn off and delete the old swap file:**
```
sudo swapoff /swapfile
sudo rm /swapfile
```

**2.2 Create a new larger swap file (12 GiB):**

```
sudo dd if=/dev/zero of=/swapfile bs=1G count=12 status=progress
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
```

**2.3 Verify new swap space:**
```
free -h
```

## Step 3: Limit Parallel Compilation to Reduce Memory Usage

**3.1 Instead of building with multiple jobs, restrict the build to use only one thread:**

```
export MAKEFLAGS="-j1"
./build_openroad.sh --local
```
This significantly lowered the memory footprint of the compiler and prevented termination.

**3.2 Monitor memory during build:**

Keep another terminal open:

```
watch -n 2 free -h
```

## Recommendations

| Area        | Recommendation                              |
| ----------- | ------------------------------------------- |
| Low RAM     | Allocate at least 12–16 GiB swap space      |
| Permissions | Use `chmod 777` or `sudo chown` when needed |
| Compilation | Use `MAKEFLAGS="-j1"` for low-RAM systems   |
| Monitoring  | Run `watch free -h` to monitor memory usage |
| Errors      | Clean build regularly with `--clean`        |

