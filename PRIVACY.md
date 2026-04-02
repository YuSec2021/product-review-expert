# Privacy Policy

Last updated: 2026-04-02

## Overview

`product-review-expert` is a Claude Code plugin for structured product review. This plugin is designed to review product requirements, workflows, and interaction designs locally within Claude Code.

This plugin does not provide a hosted service and does not operate a remote backend.

## Data Collection

This plugin does not intentionally collect personal data from users.

The plugin does not:

- require user account registration
- request API keys or OAuth credentials
- send prompts, documents, or repository content to third-party APIs operated by the plugin author
- collect analytics, usage telemetry, or advertising identifiers

## How Data Is Processed

The plugin works through local Claude Code plugin components, including skills, one agent, and one local hook.

The bundled local hook may write a timestamped diagnostic log entry to the plugin data directory:

- `${CLAUDE_PLUGIN_DATA}`

This local log is used only for plugin diagnostics and execution tracing. It is not transmitted by the plugin to the author or to any third-party service.

## Network Access

`product-review-expert` does not include external API calls, remote telemetry, or plugin-managed network requests.

If Claude Code itself, GitHub, or other user-installed tooling performs network activity, that behavior is outside the scope of this plugin’s own data practices.

## Data Sharing

The plugin author does not receive user content through this plugin.

This plugin does not sell, share, rent, or broker user data.

## Data Retention

The plugin does not maintain a remote database or server-side storage.

Any local diagnostic files created by the plugin remain on the user’s machine until deleted by the user or removed as part of Claude Code plugin data cleanup.

## Security

Because this plugin does not operate a remote service and does not request secrets, its data-handling surface area is limited to local execution inside Claude Code and optional local diagnostic logging.

## Third-Party Services

This plugin repository is hosted on GitHub:

- Repository: https://github.com/YuSec2021/product-review-expert

GitHub may process access logs, repository traffic, or related metadata under GitHub’s own policies when users visit the repository. Those practices are governed by GitHub, not by this plugin.

## Changes To This Policy

This privacy policy may be updated if the plugin’s behavior changes. Material privacy-related changes should be reflected in this file and in the project changelog where appropriate.

## Contact

For questions about this privacy policy or the plugin, contact:

- Author: YuSec2021
- Repository: https://github.com/YuSec2021/product-review-expert
- Email: gubeiting163@163.com
