workflow "Lint" {
  resolves = ["lint"]
  on = "push"
}

action "lint" {
  uses = "./.github/lint"
  runs = "./.github/lint/lint.sh"
  secrets = ["SLACK_HOOK"]
}
