# Enhanced Expert System Prompt: 8-Language Polyglot with Working Example

> **Note**: This enhanced version includes the complete working implementation as a reference example. This allows AI agents to learn from the exact patterns and structure that successfully achieve 8-language polyglot compatibility. Use this prompt when you want to improve comprehension by providing a concrete working example.

You are an expert in polyglot programming - creating single files that can be validly parsed and executed by multiple programming languages simultaneously.

## Your Task

Create a single file named `ultimate.polyglot` that can be executed by 8 different programming languages:

1. **Python 3** - Direct execution: `python3 ultimate.polyglot`
2. **Bash** - Direct execution: `bash ultimate.polyglot`
3. **Zsh** - Direct execution: `zsh -o noglob ultimate.polyglot`
4. **POSIX Shell (sh)** - Direct execution: `sh ultimate.polyglot`
5. **PHP** - Direct execution: `php ultimate.polyglot`
6. **HTML/JavaScript** - Open directly in browser
7. **Java** - Extract source, compile, and run
8. **C#/.NET** - Extract source, build, and run

Additionally, embed code for 2 more languages (though they cannot be directly executed due to HTML wrapper requirements):
- **Windows Batch/CMD**
- **PowerShell**

## Required Output for Each Language

| Language | Expected Output |
|----------|----------------|
| Python 3 | `hello from python` |
| Bash | `hello from bash` |
| Zsh | `hello from zsh` |
| POSIX Shell | `hello from shell (/bin/sh)` |
| PHP | Shebang+encoding lines + `hello from php` |
| HTML/JavaScript | Styled green text on dark background: "hello from html/javascript", console: "hello.from.js" |
| Java | `hello from java` (after extraction and compilation) |
| C#/.NET | `hello from dotnet (csharp)` (after extraction and build) |

## Working Example Implementation

Below is the complete, tested, and verified implementation that successfully executes in all 8 languages:

```python
r'''<!doctype html><!--
'''#*/
#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""<?php /*
:" # Shell/Bash/Zsh detection - shells will execute, Python ignores this docstring
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
*/
echo "hello from php";
__halt_compiler(); ?>
"""
# /// script
# dependencies = []
# ///
if False: r'''
if (":" == "<!--") then : 0 \;:\
@ECHO OFF||:;fi;:||REM<<'EXIT'
<NUL SET /P =[1A[K[1A
ECHO HELLO FROM CMD
POWERSHELL.EXE -c "iex ((Get-Content '%~f0')[6..36] -join [Environment]::Newline)"
GOTO :END
((Get-Content ".\ultimate.polyglot")[41..52] -join [Environment]::Newline) | Out-File -FilePath "$Env:Temp\cask.html" -Force
$L = (New-Object -comObject WScript.Shell).CreateShortcut("web.lnk")
$L.WindowStyle = 7
$L.TargetPath = "POWERSHELL.EXE"
$L.Arguments = '-WindowStyle Hidden -c "iex ((Get-Content ".\ultimate.polyglot")[12..36] -join [Environment]::Newline)"'
$L.Save()
[Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[Reflection.Assembly]::LoadWithPartialName("System.Drawing")
(Add-Type -PassThru -Name User32SetProcessDPIAware -MemberDefinition (@'
    [System.Runtime.InteropServices.DllImport("user32.dll")]
    public static extern bool SetProcessDPIAware();
'@ ))::SetProcessDPIAware()
$D = [System.Windows.Forms.Screen]::PrimaryScreen.WorkingArea
$W = New-Object System.Windows.Forms.WebBrowser
$S = New-Object Windows.Forms.Form
$S.Size = New-Object System.Drawing.Size(($D.Width / 4), ($D.Height / 4))
$W.Size = $S.Size
$S.Text = ""
$S.ShowIcon = 0
$S.ControlBox = 0
$S.FormBorderStyle = "None"
$S.StartPosition = "Manual"
$S.Left = ($D.Width / 2) - ($S.Width / 2)
$S.Top = ($D.Height / 2) - ($S.Height / 2)
$S.Controls.Add($W)
$W.Navigate(-join("file:///", ($Env:Temp), "/cask.html"))
$S.ShowDialog()
:END
EXIT
'''

# Python section starts here

def python_main():
    """Execute Python code"""
    print("hello from python")
    return 0

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

if __name__ == "__main__" and not globals().get('__extracted__'):
    import sys
    sys.exit(python_main())

# End of Python - HTML/JavaScript closing tags
'''-->
<style>*{margin:0;padding:0;border:0;outline:0;overflow:hidden} body,html{width:100%;height:100%;display:flex;align-items:center;justify-content:center;background:#1a1a1a;color:#0f0;font-family:monospace;font-size:2em}</style>
<script type="text/javascript">
console.log("hello.from.js");
</script>
<div>hello from html/javascript</div>
'''
```

## Detailed Architecture Breakdown

### Section 1: Browser HTML Wrapper (Lines 1-2)

```python
r'''<!doctype html><!--
'''#*/
```

**How each language interprets this:**

| Language | Interpretation |
|----------|---------------|
| **Browser** | Sees `<!doctype html>` first → enters HTML mode. The `<!--` opens an HTML comment that hides lines 2-98 |
| **Python** | `r'''` opens a raw string literal containing `<!doctype html><!--`, then `'''` closes it. `#*/` is a comment |
| **Shell** | Tries to execute `r` command (fails harmlessly), continues to next line |
| **PHP** | Not yet in PHP mode, will output this as plain text later |

**Why this works:**
- Browsers are extremely strict about doctype placement - it MUST be first
- Python's raw string `r'''..'''` allows literal HTML without escaping
- The HTML comment `<!--` spans lines 2-98, hiding all Python/Shell/PHP code from display

### Section 2: Python Shebang and Encoding (Lines 3-4)

```python
#!/usr/bin/env python3
# -*- coding: utf-8 -*-
```

**How each language interprets this:**

| Language | Interpretation |
|----------|---------------|
| **Python** | Standard shebang (for direct execution) and encoding declaration |
| **Shell** | Both lines are comments starting with `#` |
| **PHP** | Not in PHP mode yet - will output as plain text |
| **Browser** | Inside HTML comment (hidden from rendering) |

### Section 3: PHP/Shell Polyglot Section (Lines 5-19)

```python
"""<?php /*
:" # Shell detection
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
*/
echo "hello from php";
__halt_compiler(); ?>
"""
```

**How each language interprets this:**

| Language | Interpretation |
|----------|---------------|
| **Python** | Lines 5-19 form a docstring (multiline string) - completely ignored during execution |
| **Bash/Zsh/sh** | Line 5: `"""<?php /*` fails as command (harmless). Line 6: `:` is built-in no-op. Lines 7-12: Detects shell type and **exits immediately** |
| **PHP** | Line 5: `<?php` enters PHP mode, `/*` opens comment. Lines 6-12: Inside comment (ignored). Line 13: `*/` closes comment. Line 14: **executes PHP code**. Line 15: `__halt_compiler();` **stops parsing** |
| **Browser** | All lines still hidden inside HTML comment from line 1 |

**Critical insights:**
1. The `:` (colon) on line 6 is a POSIX shell built-in no-op command - does nothing but allows shells to continue
2. Each shell checks its version variable (`$BASH_VERSION`, `$ZSH_VERSION`, `$SHELL`) and exits immediately
3. PHP's `__halt_compiler()` is crucial - without it, PHP continues parsing and hits syntax errors on Batch/PowerShell code
4. PHP outputs lines 1-4 as plain text before executing - this is unavoidable but acceptable

### Section 4: Python False Block with Batch/PowerShell (Lines 20-60)

```python
# /// script
# dependencies = []
# ///
if False: r'''
# Batch/PowerShell code here (lines 25-59)
'''
```

**How each language interprets this:**

| Language | Interpretation |
|----------|---------------|
| **Python** | Lines 20-22: Comments (PEP 723 metadata). Line 23: `if False:` - never true, block never executes. `r'''` raw string wraps everything until line 60 |
| **Batch/PowerShell** | Would execute if run directly on Windows (but HTML wrapper prevents this) |
| **All others** | Already exited (Shell) or stopped parsing (PHP) or inside HTML comment (Browser) |

**Why raw string `r'''`:**
- Batch/PowerShell code contains special characters (`@`, `$`, `\`) that would require escaping in normal Python strings
- Raw strings treat everything literally - no escape sequence processing

### Section 5: Pure Python Section (Lines 62-97)

```python
def python_main():
    """Execute Python code"""
    print("hello from python")
    return 0

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

if __name__ == "__main__" and not globals().get('__extracted__'):
    import sys
    sys.exit(python_main())
```

**How each language interprets this:**

| Language | Interpretation |
|----------|---------------|
| **Python** | Defines function and variables, then executes `python_main()` if not extracting |
| **Shells** | Already exited at line 7/9/11 - never reach this |
| **PHP** | Already stopped at `__halt_compiler()` line 15 - never reach this |
| **Browser** | Still inside HTML comment from line 1 |

**Extraction Guard Pattern:**
- `if __name__ == "__main__"` - true when file is run directly
- `and not globals().get('__extracted__')` - false when extraction sets the flag
- Without this guard, extraction would print "hello from python" instead of source code

**Extraction commands:**
```bash
# Java
python3 -c "__extracted__ = True; exec(open('ultimate.polyglot').read()); print(JAVA_SOURCE)" > Ultimate.java

# C#
python3 -c "__extracted__ = True; exec(open('ultimate.polyglot').read()); print(CSHARP_SOURCE)" > Ultimate.cs
```

### Section 6: HTML/JavaScript Closing (Lines 99-107)

```python
'''-->
<style>*{margin:0;padding:0;border:0;outline:0;overflow:hidden} body,html{width:100%;height:100%;display:flex;align-items:center;justify-content:center;background:#1a1a1a;color:#0f0;font-family:monospace;font-size:2em}</style>
<script type="text/javascript">
console.log("hello.from.js");
</script>
<div>hello from html/javascript</div>
'''
```

**How each language interprets this:**

| Language | Interpretation |
|----------|---------------|
| **Python** | Multiline string literal (not assigned to variable) - parsed but not executed |
| **Browser** | Line 99: `-->` closes HTML comment from line 1. Lines 100-106: **actual rendered HTML/CSS/JS**. Line 107: `'''` is text (ignored by browser) |
| **All others** | Already exited or stopped parsing |

**CSS Styling:**
- Dark background `#1a1a1a`, green text `#0f0` (terminal-like appearance)
- Flexbox centering for professional look
- Monospace font at 2em size

## Key Design Principles

### 1. Early Exit Strategy
Each language must exit or stop parsing before reaching incompatible code:
- **Shells**: Exit at line 7/9/11 via `exit 0`
- **PHP**: Stop at line 15 via `__halt_compiler();`
- **Python**: Never executes False blocks or unassigned strings
- **Browser**: Hides everything in HTML comment `<!--...-->`

### 2. Multi-Layer String Wrapping
Python strings act as containers that hide code from Python while exposing it to other languages:
- `"""..."""` docstrings hide PHP/Shell code (lines 5-19)
- `r'''...'''` in `if False:` blocks hide Batch/PowerShell (lines 23-60)
- `'''...'''` at end hides HTML from execution (lines 99-107)

### 3. Comment Exploitation
Different comment syntaxes create parser ambiguities we can exploit:
- Python: `#` (single), `"""` (multiline)
- Shell: `#` (single), `:` (no-op command)
- PHP: `//` (single), `/*...*/` (multiline)
- HTML: `<!--...-->` (multiline)

### 4. Parser Priority
The order languages parse the file determines polyglot feasibility:
1. **Browser**: Sees doctype first → HTML mode
2. **PHP**: Enters PHP mode at `<?php`, stops at `__halt_compiler()`
3. **Shells**: Execute until `exit 0` (early lines)
4. **Python**: Skips docstrings, False blocks, and unassigned strings

### 5. Extraction Pattern for Compiled Languages
Store source as string variables, use flag to prevent execution:
```python
SOURCE = '''compiled language code'''

if __name__ == "__main__" and not globals().get('__extracted__'):
    # only run if not extracting
```

## Testing Your Implementation

### Direct Execution Tests

```bash
# Python
python3 ultimate.polyglot
# Expected: hello from python

# Bash
bash ultimate.polyglot
# Expected: hello from bash

# Zsh (requires -o noglob)
zsh -o noglob ultimate.polyglot
# Expected: hello from zsh

# POSIX Shell
sh ultimate.polyglot
# Expected: hello from shell (/bin/sh)

# PHP
php ultimate.polyglot
# Expected: #!/usr/bin/env python3
#          # -*- coding: utf-8 -*-
#          hello from php
```

### Extraction and Compilation Tests

```bash
# Java
python3 -c "__extracted__ = True; exec(open('ultimate.polyglot').read()); print(JAVA_SOURCE)" > Ultimate.java
javac Ultimate.java
java Ultimate
# Expected: hello from java

# C#/.NET
python3 -c "__extracted__ = True; exec(open('ultimate.polyglot').read()); print(CSHARP_SOURCE)" > Ultimate.cs
dotnet new console -n UltimateTest --force
cp Ultimate.cs UltimateTest/Program.cs
dotnet run --project UltimateTest
# Expected: hello from dotnet (csharp)
```

### Browser Test

1. Open `ultimate.polyglot` directly in a web browser
2. Expected: Green text "hello from html/javascript" on dark background
3. Open browser console (F12)
4. Expected: `hello.from.js` logged to console

## Common Issues and Solutions

### Issue 1: Zsh Glob Expansion Error
**Problem**: `zsh ultimate.polyglot` fails with glob expansion error

**Cause**: Zsh treats `*` in line 1 as glob pattern

**Solution**: Use `-o noglob` flag: `zsh -o noglob ultimate.polyglot`

### Issue 2: PHP Extra Output
**Problem**: PHP outputs shebang and encoding before "hello from php"

**Cause**: PHP outputs everything before first `<?php` tag as literal text

**Solution**: This is unavoidable without breaking other languages - document as expected behavior

### Issue 3: Bash "command not found" Error
**Problem**: Bash shows `"""<?php: No such file or directory` but still works

**Cause**: Bash tries to execute `"""` as command on line 5, fails, continues

**Solution**: Harmless error - bash continues and exits correctly at line 7

### Issue 4: Java Extraction Prints Python Output
**Problem**: Without `__extracted__` flag, extraction runs `python_main()`

**Cause**: Missing extraction guard flag

**Solution**: Always set `__extracted__ = True` before `exec()` in extraction commands

### Issue 5: Browser Shows Python Code
**Problem**: Browser displays Python code as plain text

**Cause**: Missing or malformed HTML doctype on line 1

**Solution**: Line 1 MUST be exactly `r'''<!doctype html><!--`

## Implementation Checklist

Follow this exact sequence when creating your polyglot:

### ✅ Phase 1: Core Structure (Lines 1-4)
- [ ] Line 1: `r'''<!doctype html><!--`
- [ ] Line 2: `'''#*/`
- [ ] Line 3: `#!/usr/bin/env python3`
- [ ] Line 4: `# -*- coding: utf-8 -*-`

### ✅ Phase 2: PHP/Shell Section (Lines 5-19)
- [ ] Line 5: `"""<?php /*`
- [ ] Line 6: `:" # Shell detection`
- [ ] Lines 7-12: Shell version detection with `exit 0` guards
- [ ] Line 13: `*/` (close PHP comment)
- [ ] Line 14: `echo "hello from php";`
- [ ] Line 15: `__halt_compiler(); ?>`
- [ ] Line 19: `"""` (close Python docstring)

### ✅ Phase 3: Python False Block (Lines 20-60)
- [ ] Lines 20-22: PEP 723 metadata (optional)
- [ ] Line 23: `if False: r'''`
- [ ] Lines 24-59: Batch/PowerShell code (see example above)
- [ ] Line 60: `'''` (close raw string)

### ✅ Phase 4: Python Logic (Lines 62-97)
- [ ] Define `python_main()` function
- [ ] Define `JAVA_SOURCE` string variable with Java code
- [ ] Define `CSHARP_SOURCE` string variable with C# code
- [ ] Add execution guard: `if __name__ == "__main__" and not globals().get('__extracted__'):`

### ✅ Phase 5: HTML/JavaScript (Lines 99-107)
- [ ] Line 99: `'''-->`
- [ ] Lines 100-106: HTML `<style>`, `<script>`, and `<div>` tags
- [ ] Line 107: `'''` (close Python string)

## Success Criteria

Your implementation is successful when:

1. ✅ Python outputs: `hello from python`
2. ✅ Bash outputs: `hello from bash`
3. ✅ Zsh outputs: `hello from zsh` (with `-o noglob`)
4. ✅ POSIX sh outputs: `hello from shell (/bin/sh)`
5. ✅ PHP outputs: shebang + encoding + `hello from php`
6. ✅ Browser displays: Green text on dark background with console log
7. ✅ Java compiles and outputs: `hello from java`
8. ✅ C# builds and outputs: `hello from dotnet (csharp)`

## Advanced Customization

Once you understand the pattern, you can customize:

### Change Output Messages
Modify the echo/print statements in each section:
- Line 8: `echo "hello from bash"` → your message
- Line 14: `echo "hello from php";` → your message
- Line 68: `print("hello from python")` → your message
- Etc.

### Add More Functionality
- Extend `python_main()` with actual logic
- Add more Java/C# classes to source strings
- Enhance HTML/CSS styling
- Add more JavaScript functionality

### Embed Additional Languages
Store additional language source code as Python string variables:
```python
RUBY_SOURCE = '''puts "hello from ruby"'''
PERL_SOURCE = '''print "hello from perl\\n";'''
```

Extract and run similarly to Java/C#.

## Why This Works: The Theory

Polyglot programming exploits **parser ambiguities** - where valid syntax in one language is ignored or interpreted differently by another:

1. **Strings vs Comments**: Python docstrings are code to Python, but comments to shells
2. **Commands vs Syntax**: Shell `:` is a no-op command, but Python sees it as docstring content
3. **Mode Switching**: PHP enters/exits PHP mode with `<?php` and `?>`, other languages see text
4. **Order Dependency**: First interpreter to "claim" the file determines initial parsing behavior
5. **Early Exit**: Languages that exit early never see code meant for other languages

This polyglot achieves 8-language compatibility by carefully orchestrating these parser behaviors to create isolated execution paths for each language.

---

**Credits**: This enhanced prompt includes the working implementation developed through iterative experimentation with Claude Sonnet 4.5, building on polyglot concepts pioneered by Alexandre Gomes Gaigalas (@alganet).
