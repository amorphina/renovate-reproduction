# Discussion 30295

First, read the [Renovate minimal reproduction instructions](https://github.com/renovatebot/renovate/blob/main/docs/development/minimal-reproductions.md).

## Current behavior

We have a terraform code with the following:

```hcl
resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "oci://gitlab.example.com:5000/group/subgroup"
  chart            = "my-chart"
  create_namespace = true
  namespace        = "argocd"
  skip_crds        = false
  version          = "2.0.0"
  values = [
    file("${path.module}/config/argocd/values.yaml")
  ]
  set {
    name  = "argo-cd.configs.repositories.gitops.username"
    value = var.argocd_git_username
  }
  set {
    name  = "argo-cd.configs.repositories.gitops.password"
    value = sensitive(var.argocd_git_password)
  }
  set {
    name  = "app_config.targetRevision"
    value = var.app_config_targetrevision
  }
  set {
    name  = "argo-cd.configs.repositories.gitops.url"
    value = var.argocd_git_url
  }

  lifecycle {
    ignore_changes = [
      values,
      version,
      chart,
      repository,
    ]

  }

}
```

Whenever renovate checks for updates of the above helm chart it malforms the URL from oci://gitlab.example.com:5000/group/subgroup to gitlab.example.com://5000/group/subgroup/project

## Expected behavior

URLs to match the above provided OCI.

## Link to the Renovate issue or Discussion

https://github.com/renovatebot/renovate/discussions/30295

## Env variables

```bash
export RENOVATE_CONFIG_FILE=renovate.json
export RENOVATE_TOKEN=XXXXXX
export RENOVATE_PLATFORM=github
```

## Config

```json
{
  "$schema": "https://docs.renovatebot.com/renovate-schema.json",
  "repositories": ["amorphina/renovate-reproduction"],
  "extends": [
    "config:recommended",
    ":semanticCommits"
  ],
  "labels": [
    "renovate",
    "{{{datasource}}}",
    "{{{updateType}}}"
  ],
  "configMigration": true,
  "packageRules": [
    {
      "matchDatasources": [
        "pypi"
      ],
      "matchUpdateTypes": [
        "minor",
        "patch"
      ],
      "groupName": "Pypi dependencies Minor and Patch"
    },
    {
      "matchDatasources": [
        "npm"
      ],
      "matchUpdateTypes": [
        "minor",
        "patch"
      ],
      "groupName": "NPM dependencies Minor and Patch"
    },
    {
      "matchDatasources": [
        "repology"
      ],
      "matchUpdateTypes": [
        "minor",
        "patch"
      ],
      "groupName": "Repology dependencies Minor and Patch"
    }
  ]
}
```

## Renovate command

```bash
renovate --fork-processing=enabled
```

## Logs

```log
ubuntu@adc348421c84:/mnt$ renovate --fork-processing=enabled
DEBUG: Using RE2 regex engine
DEBUG: Parsing configs
DEBUG: Checking for config file in renovate.json
DEBUG: Converting GITHUB_COM_TOKEN into a global host rule
DEBUG: File config
       "config": {
         "$schema": "https://docs.renovatebot.com/renovate-schema.json",
         "repositories": ["amorphina/renovate-reproduction"],
         "extends": ["config:recommended", ":semanticCommits"],
         "labels": ["renovate", "{{{datasource}}}", "{{{updateType}}}"],
         "configMigration": true,
         "packageRules": [
           {
             "matchDatasources": ["pypi"],
             "matchUpdateTypes": ["minor", "patch"],
             "groupName": "Pypi dependencies Minor and Patch"
           },
           {
             "matchDatasources": ["npm"],
             "matchUpdateTypes": ["minor", "patch"],
             "groupName": "NPM dependencies Minor and Patch"
           },
           {
             "matchDatasources": ["repology"],
             "matchUpdateTypes": ["minor", "patch"],
             "groupName": "Repology dependencies Minor and Patch"
           }
         ]
       }
DEBUG: CLI config
       "config": {"forkProcessing": "enabled"}
DEBUG: Env config
       "config": {
         "hostRules": [
           {"hostType": "github", "matchHost": "github.com", "token": "***********"}
         ],
         "platform": "github",
         "token": "***********"
       }
DEBUG: Combined config
       "config": {
         "$schema": "https://docs.renovatebot.com/renovate-schema.json",
         "repositories": ["amorphina/renovate-reproduction"],
         "extends": ["config:recommended", ":semanticCommits"],
         "labels": ["renovate", "{{{datasource}}}", "{{{updateType}}}"],
         "configMigration": true,
         "packageRules": [
           {
             "matchDatasources": ["pypi"],
             "matchUpdateTypes": ["minor", "patch"],
             "groupName": "Pypi dependencies Minor and Patch"
           },
           {
             "matchDatasources": ["npm"],
             "matchUpdateTypes": ["minor", "patch"],
             "groupName": "NPM dependencies Minor and Patch"
           },
           {
             "matchDatasources": ["repology"],
             "matchUpdateTypes": ["minor", "patch"],
             "groupName": "Repology dependencies Minor and Patch"
           }
         ],
         "hostRules": [
           {"hostType": "github", "matchHost": "github.com", "token": "***********"}
         ],
         "platform": "github",
         "token": "***********",
         "forkProcessing": "enabled"
       }
DEBUG: Enabling forkProcessing while in non-autodiscover mode
DEBUG: Found valid git version: 2.45.2
DEBUG: Setting global hostRules
DEBUG: Adding token authentication for github.com (hostType=github) to hostRules
DEBUG: Using default github endpoint: https://api.github.com/
DEBUG: hostRules: authentication already set for api.github.com
DEBUG: Platform config
       "platformConfig": {
         "hostType": "github",
         "endpoint": "https://api.github.com/",
         "isGHApp": false,
         "isGhe": false,
         "userDetails": {"username": "amorphina", "name": "A S", "id": 7421511},
         "userEmail": "redacted@gmail.com"
       },
       "renovateUsername": "amorphina"
DEBUG: Using platform gitAuthor: A S <redacted@gmail.com>
DEBUG: Adding token authentication for api.github.com (hostType=github) to hostRules
DEBUG: Using baseDir: /tmp/renovate
DEBUG: Using cacheDir: /tmp/renovate/cache
DEBUG: Using containerbaseDir: /tmp/renovate/cache/containerbase
DEBUG: Initializing Renovate internal cache into /tmp/renovate/cache/renovate/renovate-cache-v1
DEBUG: Commits limit = null
DEBUG: Setting global hostRules
DEBUG: Adding token authentication for github.com (hostType=github) to hostRules
DEBUG: Adding token authentication for api.github.com (hostType=github) to hostRules
DEBUG: validatePresets()
DEBUG: Reinitializing hostRules for repo
DEBUG: Clearing hostRules
DEBUG: Adding token authentication for github.com (hostType=github) to hostRules
DEBUG: Adding token authentication for api.github.com (hostType=github) to hostRules
 INFO: Repository started (repository=amorphina/renovate-reproduction)
       "renovateVersion": "37.429.1"
DEBUG: Using localDir: /tmp/renovate/repos/github/amorphina/renovate-reproduction (repository=amorphina/renovate-reproduction)
DEBUG: PackageFiles.clear() - Package files deleted (repository=amorphina/renovate-reproduction)
DEBUG: initRepo("amorphina/renovate-reproduction") (repository=amorphina/renovate-reproduction)
DEBUG: hostRules: authentication already set for api.github.com (repository=amorphina/renovate-reproduction)
DEBUG: amorphina/renovate-reproduction default branch = main (repository=amorphina/renovate-reproduction)
DEBUG: Using personal access token for git init (repository=amorphina/renovate-reproduction)
DEBUG: Resetting npmrc (repository=amorphina/renovate-reproduction)
DEBUG: Resetting npmrc (repository=amorphina/renovate-reproduction)
DEBUG: checkOnboarding() (repository=amorphina/renovate-reproduction)
DEBUG: isOnboarded() (repository=amorphina/renovate-reproduction)
DEBUG: findPr(renovate/configure, Configure Renovate, !open) (repository=amorphina/renovate-reproduction)
DEBUG: http cache: saving https://api.github.com/repos/amorphina/renovate-reproduction/pulls?per_page=100&state=all&sort=updated&direction=desc&page=1 (etag="321015250c1dee19a3c9d7205e13c9046df7985b5b7d6ba602d2730d516af496", lastModified=undefined) (repository=amorphina/renovate-reproduction)
DEBUG: getPrList success (repository=amorphina/renovate-reproduction)
       "pullsTotal": 0,
       "requestsTotal": 1,
       "apiQuotaAffected": true
DEBUG: findPr(renovate/configure, chore: Configure Renovate, !open) (repository=amorphina/renovate-reproduction)
DEBUG: findFile(renovate.json) (repository=amorphina/renovate-reproduction)
DEBUG: Initializing git repository into /tmp/renovate/repos/github/amorphina/renovate-reproduction (repository=amorphina/renovate-reproduction)
DEBUG: Performing blobless clone (repository=amorphina/renovate-reproduction)
DEBUG: git clone completed (repository=amorphina/renovate-reproduction)
       "durationMs": 760
DEBUG: latest repository commit (repository=amorphina/renovate-reproduction)
       "latestCommit": {
         "hash": "01ada4f4a2440cc08961a2861fa06cc3327f0389",
         "date": "2024-07-24T09:47:38+02:00",
         "message": "fix: added main.tf",
         "refs": "HEAD -> main, origin/main, origin/HEAD",
         "body": "",
         "author_name": "Atanas Stoyanov",
         "author_email": "atanas.stoyanov@diva-e.com"
       }
DEBUG: Config file exists, fileName: renovate.json (repository=amorphina/renovate-reproduction)
 INFO: Cannot ensure issue because issues are disabled in this repository (repository=amorphina/renovate-reproduction)
DEBUG: Repo is onboarded (repository=amorphina/renovate-reproduction)
DEBUG: Found renovate.json config file (repository=amorphina/renovate-reproduction)
DEBUG: Repository config (repository=amorphina/renovate-reproduction)
       "fileName": "renovate.json",
       "config": {
         "$schema": "https://docs.renovatebot.com/renovate-schema.json",
         "extends": ["config:recommended", ":semanticCommits"],
         "labels": ["renovate", "{{{datasource}}}", "{{{updateType}}}"],
         "configMigration": true,
         "packageRules": [
           {
             "matchDatasources": ["pypi"],
             "matchUpdateTypes": ["minor", "patch"],
             "groupName": "Pypi dependencies Minor and Patch"
           },
           {
             "matchDatasources": ["npm"],
             "matchUpdateTypes": ["minor", "patch"],
             "groupName": "NPM dependencies Minor and Patch"
           },
           {
             "matchDatasources": ["repology"],
             "matchUpdateTypes": ["minor", "patch"],
             "groupName": "Repology dependencies Minor and Patch"
           }
         ]
       }
DEBUG: migrateAndValidate() (repository=amorphina/renovate-reproduction)
DEBUG: No config migration necessary (repository=amorphina/renovate-reproduction)
DEBUG: Setting hostRules from config (repository=amorphina/renovate-reproduction)
DEBUG: Found repo ignorePaths (repository=amorphina/renovate-reproduction)
       "ignorePaths": [
         "**/node_modules/**",
         "**/bower_components/**",
         "**/vendor/**",
         "**/examples/**",
         "**/__tests__/**",
         "**/test/**",
         "**/tests/**",
         "**/__fixtures__/**"
       ]
DEBUG: No vulnerability alerts enabled for repo (repository=amorphina/renovate-reproduction)
DEBUG: No vulnerability alerts found (repository=amorphina/renovate-reproduction)
DEBUG: findIssue(Dependency Dashboard) (repository=amorphina/renovate-reproduction)
DEBUG: No baseBranches (repository=amorphina/renovate-reproduction)
DEBUG: extract() (repository=amorphina/renovate-reproduction)
DEBUG: Setting current branch to main (repository=amorphina/renovate-reproduction)
DEBUG: latest commit (repository=amorphina/renovate-reproduction)
       "branchName": "main",
       "latestCommitDate": "2024-07-24T09:47:38+02:00"
DEBUG: Using file match: (^|/)tasks/[^/]+\.ya?ml$ for manager ansible (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: (^|/)(galaxy|requirements)(\.ansible)?\.ya?ml$ for manager ansible-galaxy (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: (^|/)\.tool-versions$ for manager asdf (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: azure.*pipelines?.*\.ya?ml$ for manager azure-pipelines (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: (^|/)batect(-bundle)?\.ya?ml$ for manager batect (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: (^|/)batect$ for manager batect-wrapper (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: (^|/)WORKSPACE(|\.bazel|\.bzlmod)$ for manager bazel (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: \.bzl$ for manager bazel (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: (^|/)MODULE\.bazel$ for manager bazel-module (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: (^|/)\.bazelversion$ for manager bazelisk (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: \.bicep$ for manager bicep (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: (^|/)\.?bitbucket-pipelines\.ya?ml$ for manager bitbucket-pipelines (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: buildkite\.ya?ml for manager buildkite (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: \.buildkite/.+\.ya?ml$ for manager buildkite (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: (^|/)bun\.lockb$ for manager bun (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: (^|/)Gemfile$ for manager bundler (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: \.cake$ for manager cake (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: (^|/)Cargo\.toml$ for manager cargo (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: (^|/)\.circleci/.+\.ya?ml$ for manager circleci (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: (^|/)cloudbuild\.ya?ml for manager cloudbuild (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: (^|/)Podfile$ for manager cocoapods (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: (^|/)([\w-]*)composer\.json$ for manager composer (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: (^|/)conanfile\.(txt|py)$ for manager conan (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: (^|/)cpanfile$ for manager cpanfile (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: (^|/)(?:deps|bb)\.edn$ for manager deps-edn (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: ^.devcontainer/devcontainer.json$ for manager devcontainer (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: ^.devcontainer.json$ for manager devcontainer (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: (^|/)(?:docker-)?compose[^/]*\.ya?ml$ for manager docker-compose (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: (^|/|\.)([Dd]ocker|[Cc]ontainer)file$ for manager dockerfile (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: (^|/)([Dd]ocker|[Cc]ontainer)file[^/]*$ for manager dockerfile (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: (^|/)\.drone\.yml$ for manager droneci (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: (^|/)fleet\.ya?ml for manager fleet (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: (?:^|/)gotk-components\.ya?ml$ for manager flux (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: (^|/)\.fvm/fvm_config\.json$ for manager fvm (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: (^|/)\.fvmrc$ for manager fvm (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: (^|/)\.gitmodules$ for manager git-submodules (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: (^|/)(workflow-templates|\.(?:github|gitea|forgejo)/(?:workflows|actions))/.+\.ya?ml$ for manager github-actions (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: (^|/)action\.ya?ml$ for manager github-actions (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: \.gitlab-ci\.ya?ml$ for manager gitlabci (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: \.gitlab-ci\.ya?ml$ for manager gitlabci-include (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: (^|/)go\.mod$ for manager gomod (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: \.gradle(\.kts)?$ for manager gradle (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: (^|/)gradle\.properties$ for manager gradle (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: (^|/)gradle/.+\.toml$ for manager gradle (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: (^|/)buildSrc/.+\.kt$ for manager gradle (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: \.versions\.toml$ for manager gradle (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: (^|/)versions.props$ for manager gradle (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: (^|/)versions.lock$ for manager gradle (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: (^|/)gradle/wrapper/gradle-wrapper\.properties$ for manager gradle-wrapper (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: (^|/)requirements\.ya?ml$ for manager helm-requirements (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: (^|/)values\.ya?ml$ for manager helm-values (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: (^|/)helmfile\.ya?ml(?:\.gotmpl)?$ for manager helmfile (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: (^|/)Chart\.ya?ml$ for manager helmv3 (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: (^|/)bin/hermit$ for manager hermit (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: ^Formula/[^/]+[.]rb$ for manager homebrew (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: \.html?$ for manager html (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: (^|/)plugins\.(txt|ya?ml)$ for manager jenkins (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: (^|/)jsonnetfile\.json$ for manager jsonnet-bundler (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: ^.+\.main\.kts$ for manager kotlin-script (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: (^|/)kustomization\.ya?ml$ for manager kustomize (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: (^|/)project\.clj$ for manager leiningen (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: (^|/|\.)pom\.xml$ for manager maven (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: ^(((\.mvn)|(\.m2))/)?settings\.xml$ for manager maven (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: (^|/)\.mvn/extensions\.xml$ for manager maven (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: (^|\/).mvn/wrapper/maven-wrapper.properties$ for manager maven-wrapper (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: (^|/)package\.js$ for manager meteor (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: (^|/)Mintfile$ for manager mint (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: (^|/)\.mise\.toml$ for manager mise (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: (^|/)mix\.exs$ for manager mix (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: (^|/)flake\.nix$ for manager nix (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: (^|/)\.node-version$ for manager nodenv (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: (^|/)package\.json$ for manager npm (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: \.(?:cs|fs|vb)proj$ for manager nuget (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: \.(?:props|targets)$ for manager nuget (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: (^|/)dotnet-tools\.json$ for manager nuget (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: (^|/)global\.json$ for manager nuget (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: (^|/)\.nvmrc$ for manager nvm (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: (^|/)src/main/features/.+\.json$ for manager osgi (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: (^|/)pyproject\.toml$ for manager pep621 (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: (^|/)[\w-]*requirements([-.]\w+)?\.(txt|pip)$ for manager pip_requirements (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: (^|/)setup\.py$ for manager pip_setup (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: (^|/)Pipfile$ for manager pipenv (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: (^|/)pyproject\.toml$ for manager poetry (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: (^|/)\.pre-commit-config\.ya?ml$ for manager pre-commit (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: (^|/)pubspec\.ya?ml$ for manager pub (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: (^|/)Puppetfile$ for manager puppet (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: (^|/)\.python-version$ for manager pyenv (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: (^|/)\.ruby-version$ for manager ruby-version (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: (^|/)runtime.txt$ for manager runtime-version (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: \.sbt$ for manager sbt (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: project/[^/]*\.scala$ for manager sbt (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: project/build\.properties$ for manager sbt (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: (^|/)repositories$ for manager sbt (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: (^|/)\.scalafmt.conf$ for manager scalafmt (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: (^|/)setup\.cfg$ for manager setup-cfg (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: (^|/)Package\.swift for manager swift (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: \.tf$ for manager terraform (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: (^|/)\.terraform-version$ for manager terraform-version (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: (^|/)terragrunt\.hcl$ for manager terragrunt (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: (^|/)\.terragrunt-version$ for manager terragrunt-version (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: \.tflint\.hcl$ for manager tflint-plugin (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: ^\.travis\.ya?ml$ for manager travis (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: (^|/)\.vela\.ya?ml$ for manager velaci (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: (^|/)vendir\.yml$ for manager vendir (repository=amorphina/renovate-reproduction)
DEBUG: Using file match: ^\.woodpecker(?:/[^/]+)?\.ya?ml$ for manager woodpecker (repository=amorphina/renovate-reproduction)
DEBUG: Matched 1 file(s) for manager terraform: main.tf (repository=amorphina/renovate-reproduction)
DEBUG: manager extract durations (ms) (repository=amorphina/renovate-reproduction)
       "managers": {"terraform": 20}
DEBUG: Found terraform package files (repository=amorphina/renovate-reproduction)
DEBUG: Found 1 package file(s) (repository=amorphina/renovate-reproduction)
 INFO: Dependency extraction complete (repository=amorphina/renovate-reproduction, baseBranch=main)
       "stats": {
         "managers": {"terraform": {"fileCount": 1, "depCount": 1}},
         "total": {"fileCount": 1, "depCount": 1}
       }
DEBUG: Failed to look up docker package gitlab.example.com://5000/group/subgroup/my-chart (repository=amorphina/renovate-reproduction, packageFile=main.tf, dependency=gitlab.example.com://5000/group/subgroup/my-chart)
DEBUG: PackageFiles.add() - Package file saved for base branch (repository=amorphina/renovate-reproduction, baseBranch=main)
DEBUG: Package releases lookups complete (repository=amorphina/renovate-reproduction, baseBranch=main)
DEBUG: branchifyUpgrades (repository=amorphina/renovate-reproduction)
DEBUG: 0 flattened updates found:  (repository=amorphina/renovate-reproduction)
DEBUG: Returning 0 branch(es) (repository=amorphina/renovate-reproduction)
DEBUG: config.repoIsOnboarded=true (repository=amorphina/renovate-reproduction)
DEBUG: packageFiles with updates (repository=amorphina/renovate-reproduction, baseBranch=main)
       "config": {
         "terraform": [
           {
             "deps": [
               {
                 "currentValue": "2.0.0",
                 "depType": "helm_release",
                 "depName": "my-chart",
                 "datasource": "docker",
                 "packageName": "gitlab.example.com://5000/group/subgroup/my-chart",
                 "updates": [],
                 "versioning": "docker",
                 "warnings": [
                   {
                     "topic": "gitlab.example.com://5000/group/subgroup/my-chart",
                     "message": "Failed to look up docker package gitlab.example.com://5000/group/subgroup/my-chart"
                   }
                 ]
               }
             ],
             "packageFile": "main.tf"
           }
         ]
       }
DEBUG: processRepo() (repository=amorphina/renovate-reproduction)
DEBUG: Processing 0 branches:  (repository=amorphina/renovate-reproduction)
DEBUG: Calculating hourly PRs remaining (repository=amorphina/renovate-reproduction)
DEBUG: currentHourStart=2024-07-24T08:00:00.000+00:00 (repository=amorphina/renovate-reproduction)
DEBUG: PR hourly limit remaining: 2 (repository=amorphina/renovate-reproduction)
DEBUG: Calculating prConcurrentLimit (10) (repository=amorphina/renovate-reproduction)
DEBUG: 0 PRs are currently open (repository=amorphina/renovate-reproduction)
DEBUG: PR concurrent limit remaining: 10 (repository=amorphina/renovate-reproduction)
DEBUG: Calculated maximum PRs remaining this run: 2 (repository=amorphina/renovate-reproduction)
DEBUG: PullRequests limit = 2 (repository=amorphina/renovate-reproduction)
DEBUG: Calculating hourly PRs remaining (repository=amorphina/renovate-reproduction)
DEBUG: currentHourStart=2024-07-24T08:00:00.000+00:00 (repository=amorphina/renovate-reproduction)
DEBUG: PR hourly limit remaining: 2 (repository=amorphina/renovate-reproduction)
DEBUG: Calculating branchConcurrentLimit (10) (repository=amorphina/renovate-reproduction)
DEBUG: 0 already existing branches found:  (repository=amorphina/renovate-reproduction)
DEBUG: Branch concurrent limit remaining: 10 (repository=amorphina/renovate-reproduction)
DEBUG: Calculated maximum branches remaining this run: 2 (repository=amorphina/renovate-reproduction)
DEBUG: Branches limit = 2 (repository=amorphina/renovate-reproduction)
DEBUG: ensureDependencyDashboard() (repository=amorphina/renovate-reproduction)
DEBUG: Ensuring Dependency Dashboard (repository=amorphina/renovate-reproduction)
DEBUG: Checking packageFiles for deprecated packages (repository=amorphina/renovate-reproduction)
       "packageFiles": {
         "terraform": [
           {
             "deps": [
               {
                 "currentValue": "2.0.0",
                 "depType": "helm_release",
                 "depName": "my-chart",
                 "datasource": "docker",
                 "packageName": "gitlab.example.com://5000/group/subgroup/my-chart",
                 "updates": [],
                 "versioning": "docker",
                 "warnings": [
                   {
                     "topic": "gitlab.example.com://5000/group/subgroup/my-chart",
                     "message": "Failed to look up docker package gitlab.example.com://5000/group/subgroup/my-chart"
                   }
                 ]
               }
             ],
             "packageFile": "main.tf"
           }
         ]
       }
 WARN: Package lookup failures (repository=amorphina/renovate-reproduction)
       "warnings": [
         "Failed to look up docker package gitlab.example.com://5000/group/subgroup/my-chart"
       ],
       "files": ["main.tf"]
DEBUG: ensureIssue(Dependency Dashboard) (repository=amorphina/renovate-reproduction)
 INFO: Cannot ensure issue because issues are disabled in this repository (repository=amorphina/renovate-reproduction)
DEBUG: validateReconfigureBranch() (repository=amorphina/renovate-reproduction)
DEBUG: No reconfigure branch found (repository=amorphina/renovate-reproduction)
DEBUG: http cache: saving https://api.github.com/repos/amorphina/renovate-reproduction/contents/renovate.json (etag=W/"8a2b9c66b3bb42e67006895c87e5d1e3852b3432", lastModified=Wed, 24 Jul 2024 07:47:38 GMT) (repository=amorphina/renovate-reproduction)
DEBUG: checkConfigMigrationBranch() (repository=amorphina/renovate-reproduction)
DEBUG: checkConfigMigrationBranch() Config does not need migration (repository=amorphina/renovate-reproduction)
DEBUG: Removing any stale branches (repository=amorphina/renovate-reproduction)
DEBUG: config.repoIsOnboarded=true (repository=amorphina/renovate-reproduction)
DEBUG: No renovate branches found (repository=amorphina/renovate-reproduction)
 INFO: Cannot ensure issue because issues are disabled in this repository (repository=amorphina/renovate-reproduction)
 INFO: Cannot ensure issue because issues are disabled in this repository (repository=amorphina/renovate-reproduction)
DEBUG: PackageFiles.clear() - Package files deleted (repository=amorphina/renovate-reproduction)
DEBUG: Branch summary (repository=amorphina/renovate-reproduction)
       "cacheModified": undefined,
       "baseBranches": [{"branchName": "main", "sha": "01ada4f4a2440cc08961a2861fa06cc3327f0389"}],
       "branches": [],
       "defaultBranch": "main",
       "inactiveBranches": []
DEBUG: Renovate repository PR statistics (repository=amorphina/renovate-reproduction)
       "stats": {"total": 0, "open": 0, "closed": 0, "merged": 0}
DEBUG: Repository result: done, status: onboarded, enabled: true, onboarded: true (repository=amorphina/renovate-reproduction)
DEBUG: repository problems (repository=amorphina/renovate-reproduction)
       "repoProblems": ["WARN: Package lookup failures"]
DEBUG: Repository timing splits (milliseconds) (repository=amorphina/renovate-reproduction)
       "splits": {"init": 3360, "extract": 457, "lookup": 61, "onboarding": 1, "update": 11},
       "total": 4448
DEBUG: Package cache statistics (repository=amorphina/renovate-reproduction)
       "get": {"count": 1, "avgMs": 12, "medianMs": 12, "maxMs": 12, "totalMs": 12},
       "set": {"count": 0, "avgMs": 0, "medianMs": 0, "maxMs": 0, "totalMs": 0}
DEBUG: HTTP statistics (repository=amorphina/renovate-reproduction)
       "urls": {
         "https://api.github.com/graphql": {"POST": {"200": 1}},
         "https://api.github.com/repos/amorphina/renovate-reproduction/contents/renovate.json": {
           "GET": {"200": 1}
         },
         "https://api.github.com/repos/amorphina/renovate-reproduction/pulls": {
           "GET": {"200": 1}
         }
       },
       "hosts": {
         "api.github.com": {
           "count": 3,
           "reqAvgMs": 252,
           "reqMedianMs": 229,
           "reqMaxMs": 349,
           "queueAvgMs": 0,
           "queueMedianMs": 0,
           "queueMaxMs": 0
         }
       },
       "requests": 3
DEBUG: HTTP cache statistics (repository=amorphina/renovate-reproduction)
       "https://api.github.com": {
         "/repos/amorphina/renovate-reproduction/contents/renovate.json": {
           "hit": 0,
           "miss": 1
         },
         "/repos/amorphina/renovate-reproduction/pulls": {"hit": 0, "miss": 1}
       }
DEBUG: Lookup statistics (repository=amorphina/renovate-reproduction)
       "docker": {"count": 1, "avgMs": 21, "medianMs": 21, "maxMs": 21, "totalMs": 21}
DEBUG: dns cache (repository=amorphina/renovate-reproduction)
       "hosts": []
 INFO: Repository finished (repository=amorphina/renovate-reproduction)
       "cloned": true,
       "durationMs": 4448
DEBUG: Checking file package cache for expired items
DEBUG: Deleted 0 of 63 file cached entries in 131ms
```
