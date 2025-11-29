# Ultimate Polyglot File

A single file that can be executed by 8 different programming languages and interpreters, demonstrating advanced polyglot programming techniques. All languages listed below are tested in GitHub Actions CI/CD pipeline.

## Supported Languages (GitHub Actions Tested)

1. **HTML/JavaScript** (Browser) - Opens directly in browser with styled output
2. **Python 3** (Cross-platform) - `python3 ultimate.polyglot` - Tested on versions 3.9, 3.10, 3.11, 3.12
3. **Bash** (Linux/macOS/WSL) - `bash ultimate.polyglot`
4. **Zsh** (Linux/macOS) - `zsh -o noglob ultimate.polyglot`
5. **POSIX Shell** (sh) - `sh ultimate.polyglot`
6. **PHP** (Cross-platform) - `php ultimate.polyglot` - Tested on versions 7.4, 8.0, 8.1, 8.2, 8.3
7. **Java** (Cross-platform) - Extract and compile - Tested on versions 11, 17, 21
8. **C# / .NET** (Cross-platform) - Extract and compile - Tested on versions 6.0.x, 7.0.x, 8.0.x

## Embedded Languages (Not Directly Executable)

The following languages have code embedded in the file structure but cannot be directly executed due to the HTML doctype wrapper requirement:

- **Windows Batch/CMD** - Embedded but incompatible with HTML wrapper
- **PowerShell** - Embedded but incompatible with HTML wrapper

**Note**: The HTML doctype wrapper (required for browser rendering) prevents direct Windows Batch/CMD and PowerShell execution. These languages would require a Windows-specific variant without the HTML wrapper to be directly executable.

## Quick Start

### Direct Execution

```bash
# Python
python3 ultimate.polyglot
# Output: hello from python

# Bash
bash ultimate.polyglot
# Output: hello from bash

# PHP
php ultimate.polyglot
# Output: #!/usr/bin/env python3
#         # -*- coding: utf-8 -*-
#         hello from php

# Zsh (requires noglob to prevent glob expansion)
zsh -o noglob ultimate.polyglot
# Output: hello from zsh

# POSIX Shell
sh ultimate.polyglot
# Output: hello from shell (/bin/sh)

# Browser - just open the file
# Displays styled HTML page with "hello from html/javascript"
# Console shows: hello.from.js
```

**Note on Zsh**: The `-o noglob` flag is required to prevent Zsh from treating `*` in line 1 as a glob pattern.

**Note on Windows Batch/PowerShell**: The HTML doctype wrapper on line 1 prevents direct Batch execution on Windows. These languages are embedded in the file structure but cannot be executed directly. A Windows-specific variant without the HTML wrapper would be needed for Batch/PowerShell execution.

### Compiled Languages (Extraction Required)

#### Java
```bash
python3 -c "__extracted__ = True; exec(open('ultimate.polyglot').read()); print(JAVA_SOURCE)" > Ultimate.java
javac Ultimate.java
java Ultimate
# Output: hello from java
```

#### C# / .NET
```bash
python3 -c "__extracted__ = True; exec(open('ultimate.polyglot').read()); print(CSHARP_SOURCE)" > Ultimate.cs
dotnet new console -n UltimateTest --force
cp Ultimate.cs UltimateTest/Program.cs
dotnet run --project UltimateTest
# Output: hello from dotnet (csharp)
```

### Windows

#### Batch/CMD
```cmd
REM Batch cannot execute directly due to HTML wrapper on line 1
REM The Batch code is embedded in the file but not directly executable
REM A Windows-specific variant would be needed for direct Batch execution
```

#### PowerShell
```powershell
# PowerShell code is embedded but not directly executable
# The HTML doctype wrapper prevents Windows from recognizing the file
```

## File Structure

```
Line 1:      r'''<!doctype html><!--    # HTML doctype + Python string + HTML comment
Line 2:      '''#*/                      # Close Python string
Lines 3-4:   Shebang and encoding       # #!/usr/bin/env python3
Lines 5-19:  PHP/Shell docstring        # """<?php /* ... */ echo "hello"; __halt_compiler(); ?>"""
Lines 20-23: PEP 723 + False block      # if False: r'''
Lines 24-60: Batch/PowerShell code      # Windows execution
Line 61:     '''                         # Close Python raw string
Lines 62-97: Python code                # Functions, JAVA_SOURCE, CSHARP_SOURCE, execution
Lines 99-107: HTML/JavaScript           # '''--><style>...</style><script>...</script><div>...</div>'''
```

## How It Works

The polyglot file uses multiple techniques to isolate code for different interpreters. This is the **exact working structure**:

### Architecture Overview

```
Lines 1-2:   Python shebang and encoding
Lines 3-18:  PHP/Shell/Python docstring wrapper
  Line 3:    """<?php /* - Opens docstring, starts PHP, opens PHP comment
  Line 4:    :" - Shell colon command (no-op)
  Lines 5-14: Shell detection (Bash/Zsh/sh) with exit guards
  Line 15:   */ - Closes PHP comment
  Lines 16-17: PHP code execution
  Line 18:   ?> - Closes PHP tag
Line 19:     """ - Closes Python docstring
Lines 20-22: PEP 723 script metadata
Line 23:     if False: r''' - Opens Python false block with raw string
Lines 24-55: Batch/PowerShell code (Windows)
Line 56:     ''' - Closes Python raw string
Lines 58-121: Pure Python section with embedded Java/C#/HTML/JS sources
```

### Key Techniques

#### 1. PHP Docstring Wrapper (Lines 3-18)
```python
"""<?php /*
:" # Shell detection
if [ -n "$BASH_VERSION" ]; then
    echo "hello from bash"
    exit 0
fi
*/ 
echo "hello from php\n";
__halt_compiler();
?>
"""
```

**How it works:**
- **Python**: Sees `"""` opening docstring, treats lines 3-18 as ignored string
- **PHP**: Sees `<?php` on line 3, enters PHP mode, sees `/*` comment hiding lines 4-14
- **PHP**: Executes lines 16-17 (actual PHP code), stops at `__halt_compiler()`
- **Shell**: Sees `"""` then `:` command (no-op) on line 4, executes if statement, exits at line 7/9/11

**Critical details:**
- `<?php` must be on line 3 to prevent PHP from outputting lines 1-2 as plain text
- `__halt_compiler()` stops PHP from parsing Batch/PowerShell code
- Shell colon `:` on line 4 is a built-in no-op that allows shells to continue

#### 2. Python False Block with Raw String (Lines 20-56)
```python
# /// script
# dependencies = []
# ///
if False: r'''
# Batch/PowerShell code here
'''
```

**How it works:**
- `if False:` means Python never executes this block
- `r'''` is raw string - no escape sequence processing
- Batch/PowerShell code safely wrapped without Python parsing it

#### 3. Shell Exit Guards (Lines 5-14)
```bash
if [ -n "$BASH_VERSION" ]; then
    echo "hello from bash"
    exit 0
elif [ -n "$ZSH_VERSION" ]; then
    echo "hello from zsh"
    exit 0
elif [ -n "$SHELL" ]; then
    echo "hello from shell ($SHELL)"
    exit 0
fi
```

**How it works:**
- Each shell checks its version variable and exits immediately
- Other parsers (Python, PHP) see this code but never execute it:
  - **Python**: Code is inside docstring (lines 3-18)
  - **PHP**: Code is inside comment block `/* */`

#### 4. Embedded Source Strings (Python Section)
```python
JAVA_SOURCE = '''public class Ultimate {
    public static void main(String[] args) {
        System.out.println("hello from java");
    }
}'''

CSHARP_SOURCE = '''using System;
class Ultimate {
    static void Main(string[] args) {
        Console.WriteLine("hello from dotnet (csharp)");
    }
}'''
```

**How it works:**
- Java and C# code stored as Python string variables
- Extraction command reads Python file, executes it with `__extracted__` flag, prints the variable
- The `__extracted__ = True` flag prevents `python_main()` from running during extraction
- Prevents parser conflicts by keeping compiled language code as data

## Step-by-Step Execution Flow

### When you run `python3 ultimate.polyglot`:
1. Python reads shebang (line 1)
2. Python reads encoding (line 2)
3. Python sees docstring opening `"""` (line 3), treats lines 3-18 as string, ignores content
4. Python sees docstring closing `"""` (line 19)
5. Python reads script metadata (lines 20-22)
6. Python sees `if False:` (line 23), skips entire block (lines 23-56)
7. Python executes actual code (lines 58+): defines functions, variables, runs `python_main()`
8. Output: `hello from python`

### When you run `bash ultimate.polyglot`:
1. Bash ignores shebang as comment (line 1)
2. Bash ignores encoding line (line 2)  
3. Bash sees `"""<?php /*` (line 3) - tries to execute `"""`, command not found but continues
4. Bash sees `:"` (line 4) - executes `:` (built-in no-op command)
5. Bash sees `if [ -n "$BASH_VERSION" ]` (line 5) - condition is true
6. Bash executes `echo "hello from bash"` (line 6)
7. Bash executes `exit 0` (line 7) - **exits here, never reaches Python code**
8. Output: `hello from bash`

### When you run `php ultimate.polyglot`:
1. PHP sees shebang (line 1) - no `<?php` yet, would output as text BUT...
2. PHP sees encoding (line 2) - no `<?php` yet, would output as text BUT...
3. PHP sees `"""<?php /*` (line 3) - **starts PHP mode here**, opens comment `/*`
4. PHP reads lines 4-14 as comment content (ignored)
5. PHP sees `*/` (line 15) - closes comment
6. PHP executes `echo "hello from php\n";` (line 16)
7. PHP executes `__halt_compiler();` (line 17) - **stops parsing, ignores rest of file**
8. Output: `hello from php` (clean, no extra output)

### When you run `zsh ultimate.polyglot`:
1-5. Same as Bash
6. Zsh sees `elif [ -n "$ZSH_VERSION" ]` (line 8) - condition is true
7. Zsh executes `echo "hello from zsh"` (line 9)
8. Zsh executes `exit 0` (line 10) - **exits here**
9. Output: `hello from zsh`

## Testing Locally

Run the included test script:

```bash
./test-local.sh
```

This tests Python, Bash, PHP, and Java extraction locally.

## GitHub Actions CI/CD

The repository includes GitHub Actions workflows that automatically test all 11 languages:

- **Test Matrix**: Tests each language across multiple versions
- **Cross-Platform**: Tests on Ubuntu, macOS, and Windows
- **Integration**: Runs all languages in sequence to ensure compatibility

See `.github/workflows/test-polyglot.yml` for the full test suite.

## Requirements

- **Unix-like OS**: Linux, macOS, or WSL for shell scripts
- **Windows**: For Batch/CMD and PowerShell (GUI features)
- **Python 3**: Any version 3.7+
- **PHP**: Version 7.4+ (CLI mode)
- **Java**: JDK 11+ with `javac` and `java`
- **.NET**: SDK 6.0+ with `dotnet` command
- **Browser**: Any modern browser for HTML/JS

## Common Issues

### Bash: "<?php /*: No such file or directory"
This error is harmless. Bash tries to execute `<?php /*` as a command, fails, but continues execution and outputs correctly.

### PHP: Extra output before "hello from php"
Fixed in current version by placing `<?php` on line 3 inside the docstring and using `__halt_compiler()` to stop parsing.

### Java Extraction: Gets "hello from python"
Fixed by adding guard: `if __name__ == "__main__" and not globals().get('__extracted__'):`

## Contributing

See [COPILOT_LOG.md](COPILOT_LOG.md) for the full development history and [PROMPT.md](PROMPT.md) for the expert system prompt used to create this polyglot.

## Credits

- Original polyglot inspiration: [alganet.dev](https://alganet.dev)
- Extended to 11 languages by: kinncj
- AI Assistant: Claude Sonnet 4.5

## License

See LICENSE file for details.
The technique exploits differences in comment syntax and conditional directives across different parsers:

### The Core Technique

```makefile
# --- POLYGLOT MAGIC BEGINS ---
# \
! ifndef 0 # \
! include "build-aux/nmake.mk" # \
!include "$(MAKEDIR)/build-aux/patterns.mk" # \
! else
include build-aux/gnu.mk
include build-aux/rules.mk
# \
!endif
# --- POLYGLOT MAGIC ENDS ---
```

### Parser Behavior

| Parser | What It Sees |
|--------|--------------|
| **GNU Make** | `# \` continues comment to next line, sees `!else` branch |
| **NMake** | `! ifndef 0` is FALSE (0 is always defined), includes `nmake.mk` |

### Why `!ifndef 0` Works

```
NMake Logic:
- 0 is a built-in constant (always defined)
- !ifndef 0 = "if 0 is NOT defined" = FALSE
- NMake executes the ! include lines
- Skips to ! endif (never sees !else)

GNU Make Logic:
- # \ makes the entire next line a comment
- Never evaluates ! ifndef at all
- Sees !else as a regular line
- Reads the include statements after !else
```

## Triple Polyglot Examples

### Example 1: GNU Make + NMake + CMake

This version adds CMake detection to the standard dual-polyglot pattern:

```makefile
#!/usr/bin/env -S make -f
# SPDX-FileCopyrightText: 2025 Triple Polyglot Demo
# SPDX-License-Identifier: BSD-3-Clause

# Common definitions
default: all
BUILD_DIR = build/$(TARGET)
PH7_DEFINES = -DPH7_ENABLE_MATH_FUNC -DPH7_ENABLE_THREADS
PHL_BIN = $(BUILD_DIR)/phl$(BIN_SUFFIX)
COVERAGE_BIN = $(BUILD_DIR)/coverage/phl-coverage$(BIN_SUFFIX)

# Object files
OBJECTS = \
	$(BUILD_DIR)/src/ph7/api$(OBJ_SUFFIX) \
	$(BUILD_DIR)/src/ph7/builtin$(OBJ_SUFFIX) \
	$(BUILD_DIR)/src/ph7/compile$(OBJ_SUFFIX) \
	$(BUILD_DIR)/src/ph7/constant$(OBJ_SUFFIX) \
	$(BUILD_DIR)/src/ph7/hashmap$(OBJ_SUFFIX) \
	$(BUILD_DIR)/src/ph7/lex$(OBJ_SUFFIX) \
	$(BUILD_DIR)/src/sx/sxmutex$(OBJ_SUFFIX) \
	$(BUILD_DIR)/src/sx/sxstr$(OBJ_SUFFIX) \
	$(BUILD_DIR)/src/sx/sxmem$(OBJ_SUFFIX) \
	$(BUILD_DIR)/src/sx/sxds$(OBJ_SUFFIX) \
	$(BUILD_DIR)/src/sx/sxutils$(OBJ_SUFFIX) \
	$(BUILD_DIR)/src/sx/sxlib$(OBJ_SUFFIX) \
	$(BUILD_DIR)/src/sx/sxfmt$(OBJ_SUFFIX) \
	$(BUILD_DIR)/src/sx/sxhash$(OBJ_SUFFIX) \
	$(BUILD_DIR)/src/ph7/memobj$(OBJ_SUFFIX) \
	$(BUILD_DIR)/src/ph7/oo$(OBJ_SUFFIX) \
	$(BUILD_DIR)/src/ph7/parse$(OBJ_SUFFIX) \
	$(BUILD_DIR)/src/ph7/vfs$(OBJ_SUFFIX) \
	$(BUILD_DIR)/src/ph7/vm$(OBJ_SUFFIX) \
	$(BUILD_DIR)/src/phl/phl$(OBJ_SUFFIX)

# Test and Coverage Logic
TEST_PHL_CMD = "$(PHL_BIN)" "tests/phpt. php" --target-dir tests
TEST_PHP_CMD = "$(PHP_BIN)" "tests/phpt. php" --target-dir tests
COVERAGE_PHL_CMD = "$(COVERAGE_BIN)" "tests/phpt.php" \
	--target-dir tests --output-format dot

# --- TRIPLE POLYGLOT MAGIC BEGINS ---
# \
! ifndef 0 # \
! include "build-aux/nmake.mk" # \
!include "$(MAKEDIR)/build-aux/patterns.mk" # \
! else
# CMake detection: if CMAKE_CURRENT_SOURCE_DIR is defined, we're in CMake
ifdef CMAKE_CURRENT_SOURCE_DIR
$(info Detected CMake - delegating to CMakeLists.txt)
include build-aux/cmake-bridge.mk
else
# Standard GNU Make
include build-aux/gnu.mk
include build-aux/rules.mk
endif
# \
!endif
# --- TRIPLE POLYGLOT MAGIC ENDS ---

all: . ALWAYS $(PHL_BIN)
build: .ALWAYS $(PHL_BIN)
clean: .ALWAYS $(BUILD_DIR)-clean
test: .ALWAYS $(BUILD_DIR)-test
test-compat: .ALWAYS $(BUILD_DIR)-test-compat
coverage: .ALWAYS $(BUILD_DIR)/coverage/coverage. info
coverage-html: .ALWAYS $(BUILD_DIR)/coverage/html
. ALWAYS:

$(BUILD_DIR)-test: $(PHL_BIN)
	@"$(PHL_BIN)" --version
	$(TEST_PHL_CMD)

$(BUILD_DIR)-test-compat: $(PHL_BIN)
	@"$(PHL_BIN)" --version
	@$(TEST_PHL_CMD) --output-format dot
	@"$(PHP_BIN)" --version
	@$(TEST_PHP_CMD) --output-format dot
```

### Example 2: Bash + GNU Make + NMake

This version is executable as a Bash script and as a Makefile:

```makefile
#!/usr/bin/env -S make -f
# /* 2>/dev/null
# SPDX-FileCopyrightText: 2025 Triple Polyglot Demo
# SPDX-License-Identifier: BSD-3-Clause
: <<'MAKEFILE_END'
# */

#==========================================
# BASH SCRIPT MODE
#==========================================
echo "Running as Bash script"
echo "Detected: $(uname -s)"

# If running as bash, offer to run make
if [ -n "$BASH_VERSION" ]; then
    echo "This file is also a Makefile"
    echo ""
    echo "Usage:"
    echo "  make all          # Build project"
    echo "  make test         # Run tests"
    echo "  make clean        # Clean build"
    echo ""
    echo "Or on Windows:"
    echo "  nmake all"
    
    # Optionally auto-run make
    read -p "Run 'make all' now? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        exec make -f "$0" all
    fi
    exit 0
fi

# /* This comment closes the bash heredoc
MAKEFILE_END
# */

#==========================================
# MAKEFILE MODE
#==========================================

# Common definitions
default: all
BUILD_DIR = build/$(TARGET)
PHL_BIN = $(BUILD_DIR)/phl$(BIN_SUFFIX)

OBJECTS = \
	$(BUILD_DIR)/src/ph7/api$(OBJ_SUFFIX) \
	$(BUILD_DIR)/src/ph7/vm$(OBJ_SUFFIX) \
	$(BUILD_DIR)/src/phl/phl$(OBJ_SUFFIX)

# --- TRIPLE POLYGLOT MAGIC BEGINS ---
# \
! ifndef 0 # \
! include "build-aux/nmake.mk" # \
!else
include build-aux/gnu. mk
include build-aux/rules.mk
# \
!endif
# --- TRIPLE POLYGLOT MAGIC ENDS ---

all: .ALWAYS $(PHL_BIN)
	@echo "Build complete: $(PHL_BIN)"

clean: .ALWAYS
	@echo "Cleaning $(BUILD_DIR)..."
	@rm -rf $(BUILD_DIR)

test: .ALWAYS $(PHL_BIN)
	@echo "Running tests..."
	@"$(PHL_BIN)" tests/phpt.php --target-dir tests

. ALWAYS:

# /* End of polyglot file */
```

### Example 3: Python + Bash + Make + NMake

Executable as Python, Bash, GNU Make, or NMake:

```python
#!/usr/bin/env python3
# /* 2>/dev/null
''':'
# Bash section
if [ -n "$BASH_VERSION" ]; then
    echo "Running as Bash - delegating to make"
    exec make -f "$0" "$@"
fi
exit 1
'''; """
# SPDX-FileCopyrightText: 2025 Quadruple Polyglot Demo
# SPDX-License-Identifier: BSD-3-Clause

#==========================================
# PYTHON MODE
#==========================================

import sys
import os
import subprocess
from pathlib import Path

def build_project():
    print("Running as Python script")
    print(f"Python version: {sys.version}")
    
    # Detect platform
    platform = sys.platform
    print(f"Platform: {platform}")
    
    if platform == "win32":
        print("\nDelegating to nmake...")
        result = subprocess.run(["nmake", "/f", __file__], 
                              capture_output=False)
    else:
        print("\nDelegating to make...")
        result = subprocess.run(["make", "-f", __file__], 
                              capture_output=False)
    
    return result.returncode

def clean_project():
    print("Cleaning build artifacts...")
    build_dir = Path("build")
    if build_dir.exists():
        import shutil
        shutil.rmtree(build_dir)
        print("Clean complete")
    else:
        print("Nothing to clean")

def main():
    import argparse
    parser = argparse.ArgumentParser(
        description="Build script (also works as Makefile)")
    parser.add_argument("target", nargs="?", default="all",
                       help="Build target (all, clean, test)")
    args = parser.parse_args()
    
    if args.target == "clean":
        return clean_project()
    else:
        return build_project()

if __name__ == "__main__":
    sys.exit(main() or 0)

# */ This ends the Python docstring and starts Makefile mode
# """

#==========================================
# MAKEFILE MODE
#==========================================

default: all
BUILD_DIR = build/$(TARGET)
PHL_BIN = $(BUILD_DIR)/phl$(BIN_SUFFIX)

OBJECTS = \
	$(BUILD_DIR)/src/ph7/api$(OBJ_SUFFIX) \
	$(BUILD_DIR)/src/ph7/vm$(OBJ_SUFFIX) \
	$(BUILD_DIR)/src/phl/phl$(OBJ_SUFFIX)

# --- TRIPLE POLYGLOT MAGIC BEGINS ---
# \
!ifndef 0 # \
!include "build-aux/nmake.mk" # \
!else
include build-aux/gnu.mk
include build-aux/rules.mk
# \
!endif
# --- TRIPLE POLYGLOT MAGIC ENDS ---

all: .ALWAYS $(PHL_BIN)
	@echo "Built via Make/NMake"

clean: . ALWAYS
	@rm -rf $(BUILD_DIR)

test: .ALWAYS $(PHL_BIN)
	@"$(PHL_BIN)" tests/phpt.php

.ALWAYS:

. PHONY: all clean test

# End of polyglot file
```

## Execution Flow

### Triple Polyglot Flow Diagram

```
┌─────────────────────────────────────────┐
│    User executes file                   │
│    ./Makefile  or  make  or  nmake      │
└────────────┬────────────────────────────┘
             │
             ▼
      ┌──────────────┐
      │ File Opened  │
      └──────┬───────┘
             │
    ┌────────┴────────────┬──────────────┐
    │                     │              │
    ▼                     ▼              ▼
┌─────────┐      ┌──────────┐    ┌───────────┐
│ Bash    │      │ Python   │    │   Make    │
│ Detects │      │ Detects  │    │  Parser   │
│ Shebang │      │ Shebang  │    │  Reads    │
└────┬────┘      └────┬─────┘    └─────┬─────┘
     │                │                 │
     │                │        ┌────────┴────────┐
     │                │        │                 │
     │                │        ▼                 ▼
     │                │   ┌─────────┐      ┌──────────┐
     │                │   │GNU Make │      │  NMake   │
     │                │   │ # \ =   │      │ ! ifndef  │
     │                │   │ comment │      │ 0 = FALSE│
     │                │   └────┬────┘      └────┬─────┘
     │                │        │                │
     │                │        ▼                ▼
     │                │   include          ! include
     │                │   gnu.mk           nmake.mk
     │                │        │                │
     └────────────────┴────────┴────────────────┘
                      │
                      ▼
              ┌──────────────┐
              │ Build Starts │
              └──────────────┘
```

### Detailed Parsing Flow

```makefile
# Line 1: Shebang (ignored by Make, used by shell)
#!/usr/bin/env -S make -f

# Line 2-4: Multi-line comment trick
# /* 2>/dev/null          ← Make: comment, Bash: redirect stderr
''':'                     ← Make: comment, Python: empty string in heredoc
# Bash section           ← Make: comment, Bash: executes

# Later: Close Python docstring
# */                     ← Closes C-style comment for Make
# """                    ← Closes Python docstring

# Polyglot section:
# \                      ← GNU Make: continue comment
! ifndef 0 # \            ← GNU Make: still comment, NMake: evaluate
!include "nmake.mk" # \  ← GNU Make: still comment, NMake: execute
!else                    ← GNU Make: sees this, NMake: skipped
include gnu.mk           ← GNU Make: execute, NMake: never reached
```

## Usage Examples

### As GNU Make (Linux/macOS)

```bash
# Direct execution
make all
make test
make clean

# Explicit file specification
make -f Makefile all

# With variables
make all BUILD_DIR=custom/path

# Parallel builds
make -j4 all
```

### As NMake (Windows)

```cmd
REM Direct execution
nmake all
nmake test
nmake clean

REM Explicit file specification
nmake /f Makefile all

REM With variables
nmake all BUILD_DIR=custom\path

REM Show commands without execution
nmake /n all
```

### As Bash Script

```bash
# Make executable
chmod +x Makefile

# Run as script
./Makefile

# Or explicitly
bash Makefile
```

### As Python Script

```bash
# Make executable
chmod +x build. py

# Run as script
./build.py all

# Or explicitly
python3 build.py all
python3 build.py clean
python3 build.py test
```

### As CMake

```bash
# Configure
cmake -S . -B build

# Build
cmake --build build

# Test
ctest --test-dir build

# Clean
cmake --build build --target clean
```

## Platform-Specific Files

### build-aux/gnu.mk

```makefile
# GNU Make specific configuration (Linux/macOS)
# SPDX-FileCopyrightText: 2025 Demo
# SPDX-License-Identifier: BSD-3-Clause

# Platform identification
TARGET = linux
PLATFORM = unix

# File extensions
BIN_SUFFIX =
OBJ_SUFFIX = . o
LIB_SUFFIX = .a
DLL_SUFFIX = .so

# Compiler toolchain
CC = gcc
CXX = g++
AR = ar
LD = ld

# Compiler flags
CFLAGS = -Wall -Wextra -O2 -fPIC $(PH7_DEFINES)
CXXFLAGS = -Wall -Wextra -O2 -fPIC -std=c++17
LDFLAGS = -lpthread -lm

# Commands
RM = rm -f
RMDIR = rm -rf
MKDIR = mkdir -p
ECHO = echo
CP = cp
MV = mv

# Test configuration
PHP_BIN = php
```

### build-aux/nmake.mk

```makefile
# NMake specific configuration (Windows)
# SPDX-FileCopyrightText: 2025 Demo
# SPDX-License-Identifier: BSD-3-Clause

# Platform identification
TARGET = windows
PLATFORM = win32

# File extensions
BIN_SUFFIX = . exe
OBJ_SUFFIX = .obj
LIB_SUFFIX = .lib
DLL_SUFFIX = .dll

# Compiler toolchain
CC = cl. exe
CXX = cl. exe
AR = lib.exe
LD = link.exe

# Compiler flags
CFLAGS = /W4 /O2 /MD /nologo $(PH7_DEFINES)
CXXFLAGS = /W4 /O2 /MD /std:c++17 /EHsc /nologo
LDFLAGS = /nologo

# Commands
RM = del /Q
RMDIR = rmdir /S /Q
MKDIR = mkdir
ECHO = echo
CP = copy /Y
MV = move /Y

# Test configuration
PHP_BIN = php. exe
```

### build-aux/rules.mk

```makefile
# GNU Make pattern rules
# SPDX-FileCopyrightText: 2025 Demo
# SPDX-License-Identifier: BSD-3-Clause

# Compile C source to object file
$(BUILD_DIR)/%. o: src/%. c
	@$(MKDIR) $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

# Compile C++ source to object file
$(BUILD_DIR)/%.o: src/%.cpp
	@$(MKDIR) $(dir $@)
	$(CXX) $(CXXFLAGS) -c $< -o $@

# Link executable
$(PHL_BIN): $(OBJECTS)
	@$(MKDIR) $(dir $@)
	$(CC) $(OBJECTS) $(LDFLAGS) -o $@

# Clean rule
$(BUILD_DIR)-clean:
	@$(ECHO) "Cleaning $(BUILD_DIR)..."
	@$(RMDIR) $(BUILD_DIR) 2>/dev/null || true

. PHONY: $(BUILD_DIR)-clean
```

### build-aux/patterns.mk

```makefile
# NMake inference rules
# SPDX-FileCopyrightText: 2025 Demo
# SPDX-License-Identifier: BSD-3-Clause

# Compile C source to object file
{src}. c{$(BUILD_DIR)}.obj:
	@if not exist $(BUILD_DIR) $(MKDIR) $(BUILD_DIR)
	$(CC) $(CFLAGS) /c $< /Fo$@

# Compile C++ source to object file
{src}.cpp{$(BUILD_DIR)}.obj:
	@if not exist $(BUILD_DIR) $(MKDIR) $(BUILD_DIR)
	$(CXX) $(CXXFLAGS) /c $< /Fo$@

# Link executable
$(PHL_BIN): $(OBJECTS)
	@if not exist $(BUILD_DIR) $(MKDIR) $(BUILD_DIR)
	$(LD) $(OBJECTS) $(LDFLAGS) /OUT:$@

# Clean rule
$(BUILD_DIR)-clean:
	@$(ECHO) Cleaning $(BUILD_DIR)... 
	@if exist $(BUILD_DIR) $(RMDIR) $(BUILD_DIR)
```

### build-aux/cmake-bridge.mk

```makefile
# CMake bridge for Make compatibility
# SPDX-FileCopyrightText: 2025 Demo
# SPDX-License-Identifier: BSD-3-Clause

# When CMAKE_CURRENT_SOURCE_DIR is set, we're in CMake mode
# This file provides Make-compatible variables for CMake

ifdef CMAKE_CURRENT_SOURCE_DIR

# CMake provides these automatically
BUILD_DIR := $(CMAKE_BINARY_DIR)
TARGET := cmake

# Use CMake's configuration
BIN_SUFFIX := $(CMAKE_EXECUTABLE_SUFFIX)
OBJ_SUFFIX := $(CMAKE_C_OUTPUT_EXTENSION)

# Override build commands to use CMake
$(PHL_BIN):
	@echo "Building via CMake..."
	@cmake --build $(CMAKE_BINARY_DIR)

$(BUILD_DIR)-clean:
	@echo "Cleaning via CMake..."
	@cmake --build $(CMAKE_BINARY_DIR) --target clean

$(BUILD_DIR)-test:
	@echo "Testing via CMake..."
	@ctest --test-dir $(CMAKE_BINARY_DIR)

endif
```

## Monorepo Example

Project structure:

```
my-project/
├── Makefile                      # Triple polyglot entry point
├── build-aux/
│   ├── gnu.mk
│   ├── nmake.mk
│   ├── rules.mk
│   └── patterns.mk
├── infra/
│   ├── terraform/
│   │   └── main.tf
│   └── kubernetes/
│       └── deployment. yaml
├── my-project-backend/
│   ├── MyProject. Backend. csproj
│   └── Program.cs
├── my-project-service/
│   ├── MyProject.Service.csproj
│   └── Service.cs
└── my-project-ui/
    ├── package.json
    ├── vite.config.ts
    └── src/
        └── App.tsx
```

### Monorepo Makefile

```makefile
#!/usr/bin/env -S make -f
# SPDX-FileCopyrightText: 2025 Demo
# SPDX-License-Identifier: MIT

# Common definitions
default: all
BUILD_DIR = build/$(TARGET)
VERSION = 1.0.0

SERVICES = backend service ui

# --- TRIPLE POLYGLOT MAGIC BEGINS ---
# \
! ifndef 0 # \
! include "build-aux/nmake.mk" # \
!else
include build-aux/gnu. mk
# \
!endif
# --- TRIPLE POLYGLOT MAGIC ENDS ---

all: . ALWAYS build-all
clean: .ALWAYS clean-all
test: .ALWAYS test-all
deploy: .ALWAYS deploy-all

.ALWAYS:

# Build targets
build-all: build-backend build-service build-ui
	@$(ECHO) "All services built"

build-backend: . ALWAYS
	@$(ECHO) "Building backend..."
	@$(DOTNET) build my-project-backend/MyProject. Backend.csproj

build-service: .ALWAYS
	@$(ECHO) "Building service..."
	@$(DOTNET) build my-project-service/MyProject.Service.csproj

build-ui: . ALWAYS
	@$(ECHO) "Building UI..."
	@$(NPM) run build --prefix my-project-ui

# Test targets
test-all: test-backend test-service test-ui
	@$(ECHO) "All tests passed"

test-backend: . ALWAYS
	@$(ECHO) "Testing backend..."
	@$(DOTNET) test my-project-backend/MyProject.Backend. Tests. csproj

test-service: .ALWAYS
	@$(ECHO) "Testing service..."
	@$(DOTNET) test my-project-service/MyProject. Service.Tests.csproj

test-ui: .ALWAYS
	@$(ECHO) "Testing UI..."
	@$(NPM) test --prefix my-project-ui

# Clean targets
clean-all: clean-backend clean-service clean-ui
	@$(ECHO) "All cleaned"

clean-backend: . ALWAYS
	@$(ECHO) "Cleaning backend..."
	@$(DOTNET) clean my-project-backend/MyProject.Backend.csproj

clean-service: .ALWAYS
	@$(ECHO) "Cleaning service..."
	@$(DOTNET) clean my-project-service/MyProject.Service.csproj

clean-ui: .ALWAYS
	@$(ECHO) "Cleaning UI..."
	@$(RMDIR) my-project-ui/dist
	@$(RMDIR) my-project-ui/node_modules

# Deploy targets
deploy-all: deploy-infra deploy-services
	@$(ECHO) "Deployment complete"

deploy-infra: .ALWAYS
	@$(ECHO) "Deploying infrastructure..."
	@$(TERRAFORM) apply -chdir=infra/terraform -auto-approve
	@$(KUBECTL) apply -f infra/kubernetes/

deploy-services: build-all
	@$(ECHO) "Deploying services..."
	@$(DOCKER) build -t my-project-backend:$(VERSION) my-project-backend
	@$(DOCKER) build -t my-project-service:$(VERSION) my-project-service
	@$(DOCKER) build -t my-project-ui:$(VERSION) my-project-ui
	@$(DOCKER) push my-project-backend:$(VERSION)
	@$(DOCKER) push my-project-service:$(VERSION)
	@$(DOCKER) push my-project-ui:$(VERSION)

. PHONY: all clean test deploy build-all clean-all test-all deploy-all
. PHONY: build-backend build-service build-ui
.PHONY: test-backend test-service test-ui
.PHONY: clean-backend clean-service clean-ui
. PHONY: deploy-infra deploy-services
```

### Monorepo Platform Files

**build-aux/gnu.mk** for monorepo:

```makefile
# GNU Make configuration for monorepo
TARGET = linux

# . NET
DOTNET = dotnet

# Node/NPM
NPM = npm
NODE = node

# Infrastructure tools
TERRAFORM = terraform
KUBECTL = kubectl
DOCKER = docker

# Utilities
ECHO = echo
RM = rm -f
RMDIR = rm -rf
MKDIR = mkdir -p
```

**build-aux/nmake.mk** for monorepo:

```makefile
# NMake configuration for monorepo
TARGET = windows

# .NET
DOTNET = dotnet. exe

# Node/NPM
NPM = npm.cmd
NODE = node.exe

# Infrastructure tools
TERRAFORM = terraform.exe
KUBECTL = kubectl.exe
DOCKER = docker. exe

# Utilities
ECHO = echo
RM = del /Q
RMDIR = rmdir /S /Q
MKDIR = mkdir
```

## References

- [GNU Make Manual](https://www.gnu.org/software/make/manual/)
- [NMake Reference](https://docs.microsoft.com/en-us/cpp/build/reference/nmake-reference)
- [CMake Documentation](https://cmake.org/documentation/)
- [Original PH7 Polyglot Makefile](https://gist.github.com/alganet/9eec864a2caa44ef1f9ca2e188b87a45)
- [Polyglot Programming on Wikipedia](https://en.wikipedia.org/wiki/Polyglot_(computing))

## License

```
SPDX-FileCopyrightText: 2025 Demo Authors
SPDX-License-Identifier: BSD-3-Clause OR MIT
```

## Credits

Inspired by Alexandre Gomes Gaigalas (@alganet)'s polyglot Makefile demonstrations.