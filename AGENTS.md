# AGENTS.md — win11tweak (KYAU Labs Edition)

> AI agent instructions for GitHub Copilot (VS Code, Pro/Pro+) and any other coding agent
> operating on this repository. Read this file in full before making suggestions or edits.
> Last updated: 2026-05-24

---

## Project Overview

**win11tweak** is a set of template-based, automated scripts that debloat, strip telemetry from,
and reconfigure Windows 11 for power users. It is designed to be run immediately after a fresh
Windows 11 installation and is intentionally opinionated — it reflects the personal, privacy-first
preferences of the maintainer (@kyaulabs).

- **License**: GNU Affero General Public License v3.0 (AGPL-3.0)
- **Primary language**: PowerShell (94 %), supported by Batch (6 %)
- **Target OS**: Windows 11 — always targets the **current latest stable release**. The version
  pinned in the README header is outdated; do not treat it as the target build.
- **Entry point**: `main.cmd` (Batch) → invokes modules in `Modules/`
- **Companion repo**: [`kyaulabs/mpv-config`](https://github.com/kyaulabs/mpv-config) —
  MPV configuration files designed for use alongside this project (read-only context; do not
  modify files from that repo here)

### Directory Layout

```
win11tweak/
├── .github/                  # GitHub Actions workflows (CI)
├── Modules/                  # Standalone .ps1 scripts called by main.cmd
├── Resources/                # Static resource files (wallpapers, configs, etc.)
├── Tools/                    # Supporting tools (e.g., OpenShell.xml)
├── README_media/             # Screenshots used in README.md
├── main.cmd                  # Primary entry point — run as Administrator
├── download_av.cmd           # Downloads third-party AV (used before main run)
├── user_settings.ps1         # User-editable configuration template
└── AGENTS.md                 # This file
```

### Core Philosophy

1. **Privacy first** — any Windows feature that phones home, collects data, or enables tracking
   is disabled or removed unless the user explicitly opts in via `user_settings.ps1`.
2. **Power-user default** — the out-of-box Windows experience is stripped back to a minimal,
   clean, controllable baseline.
3. **Template-based** — configuration is driven by user-supplied variables in `user_settings.ps1`,
   not hardcoded values. Agents must respect this separation.

---

## How to Run / Test

### Prerequisites

- Windows 11 (any edition; guide targets Pro / Pro N)
- **Windows PowerShell 5.1** — all scripts target 5.1 exclusively. PowerShell 7.x (pwsh) is
  present on a configured system but is not a scripting target for this project.
- `PSScriptAnalyzer` must be installed: `Install-Module PSScriptAnalyzer -Force`

### Running the Linter (Required Before Any PR)

```powershell
# Run from the repository root — default ruleset, no custom settings file
Invoke-ScriptAnalyzer -Path . -Recurse
```

The project uses the **PSScriptAnalyzer default ruleset** with no additional configuration file.
All generated code must produce zero errors against this default ruleset.

Lint must pass (zero errors) before a PR is considered ready. The maintainer may bypass
this for emergency hotfixes directly to `master`, but this is the exception, not the norm.

### Running the Script

```cmd
:: Run from an Administrator Command Prompt
cd %USERPROFILE%\Desktop\win11tweak
main.cmd
```

> 🚧 **WARNING** NEVER run the script always suggest running it in a clean VM, running it on host system will cause unexpected consequences.

---

## Branching & Contribution Model

This project uses **Git Flow**:

| Branch | Purpose |
|---|---|
| `master` | Production / tagged releases |
| `develop` | Integration branch — all PRs target here |
| `feature/<name>-<hash>-<desc>` | Feature work (see below) |

**Feature branch naming:**

```
feature/<github-username>-<openssl rand -hex 2>-<short-hyphenated-desc>
```

Example: `feature/kyaulabs-3f9a-remove-cortana`

PRs must target `develop`, not `master`. Merges to `master` are done by the maintainer.

---

## PowerShell Coding Standards

All `.ps1` files in this repository must conform to the following standards. Copilot must apply
these when generating, editing, or reviewing PowerShell code.

### 1. Compatibility

- All scripts must target **Windows PowerShell 5.1** exclusively.
- Do not use APIs, cmdlets, or syntax introduced in PowerShell 6 or 7.
- Do not add version-guard blocks (`if ($PSVersionTable.PSVersion.Major -ge 7)`) — if a feature
  requires PS 7, it is out of scope for this project.

### 2. File Encoding

- All `.ps1` files must be saved as **UTF-8 with BOM**.
- This is required for Windows PowerShell 5.1 to correctly parse non-ASCII characters.
- Do not suggest or create `.ps1` files without BOM.

### 3. License Header

Every `.ps1` file must begin with the following AGPL-3.0 header block. Substitute the
appropriate script description on the second line:

```powershell
<#
 ▄▄▄▄ ▄▄▄▄ ▄▄▄▄▄▄▄▄▄ ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
 █ ▄▄ ▄ ▄▄ ▄ ▄▄▄▄ ▄▄ ▄    ▄▄   ▄▄▄▄ ▄▄▄▄  ▄▄▄ ▀
 █ ██ █ ██ █ ██ █ ██ █    ██   ██ █ ██ █ ██▀  █
 ■ ██▄▀ ██▄█ ██▄█ ██ █ ▀▀ ██   ██▄█ ██▄▀ ▀██▄ ■
 █ ██ █ ▄▄ █ ██ █ ██ █    ██▄▄ ██ █ ██ █  ▄██ █
 ▄ ▀▀ ▀ ▀▀▀▀ ▀▀ ▀ ▀▀▀▀    ▀▀▀▀ ▀▀ ▀ ▀▀▀▀ ▀▀▀  █
 ▀▀▀▀▀▀▀▀▀▀▀▀▀▀ ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀ ▀▀▀▀▀▀▀▀▀▀▀▀▀

 Win11Tweaks (KYAU Labs Edition)
 Copyright (C) 2026 KYAU Labs (https://kyaulabs.com)

 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU Affero General Public License as
 published by the Free Software Foundation, either version 3 of the
 License, or (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU Affero General Public License for more details.

 You should have received a copy of the GNU Affero General Public License
 along with this program.  If not, see <https://www.gnu.org/licenses/>.
#>
```

### 4. Variable Scoping

- Variables inside functions must use the `$script:` scope, consistent with `user_settings.ps1`.
- Do not use `$global:` for configuration variables. `$global:` is reserved for state that
  genuinely must persist across all scopes at runtime.

```powershell
# Correct
function Set-Configuration {
    $script:ComputerName = "WIN11TWEAK"
    $script:WorkGroupName = "KYAULABS"
}

# Wrong — do not do this
function Set-Configuration {
    $global:ComputerName = "WIN11TWEAK"
}
```

### 5. Error Handling

- Set `$ErrorActionPreference = 'Stop'` at the top of every script (after the license header)
  so that unhandled errors terminate the script rather than silently continuing.
- Wrap operations that can be expected to fail — or that are recoverable — in `try/catch` blocks.

```powershell
$ErrorActionPreference = 'Stop'

try {
    Remove-AppxPackage -Package $pkg
} catch {
    Write-Log -Level WARN -Message "Could not remove $pkg: $_"
}
```

### 6. Registry Operations

| Scenario | Preferred pattern |
|---|---|
| Key **exists** — update a value | `Set-ItemProperty` |
| Key **does not exist** — create it | `New-ItemProperty` |
| Deleting a value | `Remove-ItemProperty` |
| Never use | `reg.exe` in PowerShell scripts |

```powershell
# Update existing key
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\...' -Name 'Setting' -Value 0

# Create new key/value
New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\...' -Name 'Setting' -Value 0 `
    -PropertyType DWORD -Force
```

### 7. Console Output & Logging

A **custom logging function** exists in the project. Always use it instead of calling
`Write-Host` directly. The function wraps `Write-Host` with colored, prefixed output:

```powershell
Write-Log -Level INFO  -Message "Applying registry tweaks..."
Write-Log -Level WARN  -Message "Defender removal may break Windows Update."
Write-Log -Level ERROR -Message "Failed to remove package: $_"
```

- Do not introduce bare `Write-Host` calls in new code.
- Do not use `Write-Output` for user-facing messages — it pollutes the pipeline.
- `Write-Verbose` and `Write-Debug` are acceptable for diagnostic output that should be
  invisible during normal runs.

### 8. Module Architecture

`Modules/` contains **standalone scripts** invoked directly by `main.cmd` via `powershell.exe`
(Windows PowerShell 5.1). They are **not** PowerShell modules. Do not:

- Add `Export-ModuleMember` calls
- Use `Import-Module` to load siblings from within `Modules/`
- Assume any state from a previously-run module is available

Each script in `Modules/` must be self-contained and idempotent where possible.

---

## PSScriptAnalyzer Rules

The CI workflow (`.github/workflows/psscriptanalyzer.yml`) runs PSScriptAnalyzer on every push
and pull request targeting `develop` or `master`. The project uses the **default ruleset** with
no custom configuration file and no standing suppressions.

Copilot must ensure all generated PowerShell passes a clean default-ruleset run:

```powershell
Invoke-ScriptAnalyzer -Path . -Recurse
```

If the analyzer flags something in generated code, fix the root cause — do not add inline
suppression attributes. If a suppression is genuinely warranted, raise it with the maintainer
before adding it; suppressions are not approved unilaterally.

---

## Hard Constraints (Never Do)

The following behaviors are **never acceptable** as defaults. Copilot must not suggest them
unless they are explicitly gated behind a user-facing boolean flag in `user_settings.ps1`
**and** accompanied by a comment explaining the tradeoff.

- Re-enabling Windows telemetry, diagnostic data collection, or Activity History
- Re-enabling or installing Cortana
- Re-enabling Microsoft OneDrive auto-start or integration (unless `$script:Microsoft365 = $true`)
- Re-enabling Microsoft Edge as default handler (MSEdgeRedirect exists precisely to avoid this)
- Re-enabling Windows Defender as the default AV state (unless `$script:WinDefender = $true`)
- Adding Microsoft Account requirements or sign-in prompts
- Introducing `Invoke-Expression` with user-supplied or remote strings (security risk)
- Hardcoding personal values (Git email, GPG key, computer name, wallpaper path) — these
  belong in `user_settings.ps1` as `$script:` variables

When any of the above _must_ be suggested (e.g., because a feature flag already exists),
prefix the code with a comment:

```powershell
# 🚧 WARN: This re-enables [feature]. Only reached when $script:FeatureFlag = $true
#          in user_settings.ps1. Review before merging.
```

---

## Documentation & Comment Style

- **Code comments**: Plain text only. No emojis, no decorative symbols. Be concise.
- **README / Markdown docs**: Emoji callouts are part of the project style:
  - `🚧 WARNING` — for actions that can cause data loss or break functionality
  - `📌 NOTE` — for important but non-destructive information
  - `❗ DO NOT SKIP ❗` — for steps that are mandatory
- **Inline comments** should explain *why*, not *what* (the code shows what).
- New documentation files follow the existing README style.

---

## What Copilot Should Always Do

1. **Run (or instruct the user to run) PSScriptAnalyzer** (default ruleset, no flags) before
   marking any PS work complete. Zero errors is the bar.
2. **Write for Windows PowerShell 5.1** — never assume PS 7.x availability.
3. **Check `user_settings.ps1`** to see if a user-configurable flag already exists before
   hardcoding a behavior.
4. **Preserve idempotency** — scripts should be safe to run more than once without cumulative
   side effects where possible.
5. **Target `develop`** for all PRs, never `master` directly.
6. **Include the AGPL-3.0 header** on every new `.ps1` file.
7. **Consult `kyaulabs/mpv-config`** for context when changes touch media-playback or
   post-install configuration steps that interact with MPV.

---

## What Copilot Should Never Do

1. Suggest changes that make telemetry, tracking, or Microsoft cloud services active by default.
2. Use `reg.exe` in PowerShell scripts.
3. Call `Write-Host` directly — use `Write-Log`.
4. Create `.ps1` files without the AGPL-3.0 header.
5. Create `.ps1` files without UTF-8 BOM encoding.
6. Use `Import-Module` to load scripts from `Modules/` — they are standalone scripts, not modules.
7. Target `master` in a PR without explicit maintainer instruction.
8. Add PSScriptAnalyzer inline suppressions without maintainer approval.

---

## References

- [PSScriptAnalyzer documentation](https://github.com/PowerShell/PSScriptAnalyzer)
- [AGENTS.md format spec](https://agents.md/)
- [GitHub Copilot custom instructions (VS Code)](https://code.visualstudio.com/docs/copilot/customization/custom-instructions)
- [Git Flow branching model](https://www.gitkraken.com/learn/git/git-flow)
- [AGPL-3.0 license text](https://www.gnu.org/licenses/agpl-3.0.html)
- [CONTRIBUTING.md](./CONTRIBUTING.md)
