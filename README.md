# action-tribe-phpcs
Modern Tribe's PHPCS Code Review - GitHub Action

## Inputs

### `github-bot-token`

You will need to declare a secret of `GH_BOT_TOKEN` in your repo's Settings > Secrets. The token should be a Personal Access Token (preferably for a bot account) where that bot has access to the relevant repos in the Modern Tribe organization. The Token for tr1b0t is labeled as `tr1b0t GitHub OAuth Token` in our company 1Password vault.

## Example usage

```
- uses: borkweb/action-tribe-phpcs@master
  with:
    github_bot_token: ${{ secrets.GH_BOT_TOKEN }}
```
