workflow "Main" {
  on = "push"
  resolves = ["Test"]
}

action "Install" {
  uses = "docker://culturehq/actions-bundler:latest"
  args = "install"
}

action "Test" {
  needs = "Install"
  uses = "docker://culturehq/actions-bundler:latest"
  args = "exec rake"
}
