# Security policy

Supported releases receive security fixes on the latest minor line.

Please do not open public issues for vulnerabilities. Report them privately through GitHub Security Advisories for this repository. Include reproduction steps and impact, but never include production credentials, access tokens, personal data, or private API responses.

The API requires a Bearer API key. Never commit it or embed it in a distributed client when secrecy matters; use a trusted backend proxy. Applications are responsible for upgrading dependencies and avoiding logging keys or sensitive content.
