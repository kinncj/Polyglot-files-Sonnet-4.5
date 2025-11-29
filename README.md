# Ultimate Polyglot File Demo

A single file that can be executed by 8 different programming languages and interpreters, demonstrating advanced polyglot programming techniques.

## Supported Languages

1. **HTML/JavaScript** (Browser) - Opens directly in browser with styled output
2. **Python 3** (Cross-platform) - `python3 ultimate.polyglot`
3. **Bash** (Linux/macOS/WSL) - `bash ultimate.polyglot`
4. **Zsh** (Linux/macOS) - `zsh -o noglob ultimate.polyglot`
5. **POSIX Shell** (sh) - `sh ultimate.polyglot`
6. **PHP** (Cross-platform) - `php ultimate.polyglot`
7. **Java** (Cross-platform) - Extract and compile
8. **C# / .NET** (Cross-platform) - Extract and compile

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

## Credits

- Original polyglot inspiration: [alganet.dev](https://alganet.dev)
- Extended to 8 languages by: kinncj
- AI Assistant: Claude Sonnet 4.5

## License

MIT