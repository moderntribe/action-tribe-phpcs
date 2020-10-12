# action-tribe-phpcs

Modern Tribe's PHPCS Code Review - GitHub Action

## Dockerfile

The container in use is currently on Docker Hub as `borkweb/tribe-phpcs`. The Dockerfile for that image is defined in our [packages repo](https://github.com/moderntribe/packages).

## Usage

If you would like to add automated code sniffing to PRs on a new repository, there are a few things that must be set up first.

### Add PHPCS to `composer.json`

For PHPCS to function appropriately, it needs to be included in the repository via composer.

**Within `require-dev`, add the following:**

```
"require-dev": {
    "dealerdirect/phpcodesniffer-composer-installer": "^0.4.4",
    "wp-coding-standards/wpcs": "^2.1",
    "automattic/vipwpcs": "^2.0",
    "moderntribe/tribalscents": "dev-master",
    ...
}
```

**Within `repositories`, add the following:**

```
"repositories": {
    {
      "name": "moderntribe/TribalScents",
      "type": "github",
      "url": "https://github.com/moderntribe/TribalScents",
      "no-api": true
    }
}
```

### Create `phpcs.xml`

You'll need a `phpcs.xml` file to declare the rulesets the repository will be using. Here's an example of one that we use for our plugins:

```xml
<?xml version="1.0"?>
<ruleset name="Modern Tribe Plugin Coding Standards">
	<rule ref="TribalScents"></rule>
	<rule ref="WordPress-VIP-Go"></rule>
	<rule ref="WordPress">
		<exclude name="WordPress.Files.FileName"/>
	</rule>
	<rule ref="WordPress-Extra"></rule>
	<rule ref="WordPress-Docs"></rule>
	<rule ref="WordPress-Core"></rule>
</ruleset>
```

### Adding a GitHub Workflow

You will need a GitHub Workflow to make this magic happen. You can [read about it](https://help.github.com/en/articles/configuring-a-workflow) in the GitHub docs. You could also just copy the `.github/workflows` directory from [The Events Calendar](https://github.com/moderntribe/the-events-calendar).

#### Inputs

##### `github-bot-token`

You will need to declare a secret of `GH_BOT_TOKEN` in your repo's Settings > Secrets. The token should be a Personal Access Token (preferably for a bot account) where that bot has access to the relevant repos in the Modern Tribe organization. The Token for tr1b0t is labeled as `tr1b0t GitHub OAuth Token` in our company 1Password vault.

#### Example usage

```
- uses: moderntribe/action-tribe-phpcs@master
  with:
    github_bot_token: ${{ secrets.GH_BOT_TOKEN }}
```
