# git-pusher

> Automatically add, commit and push changes to a remote repository.

A simple Bash script that wraps the standard `git add . && git commit && git push` workflow into a single command. It supports custom project paths, commit messages, and branch targets. If no commit message is provided, one is generated automatically using random words fetched from an API.

---

## Usage

```bash
./git-pusher.sh [options]
```

### Options

| Flag | Description | Default |
|------|-------------|---------|
| `-p <project_path>` | Path to the project directory | Current directory |
| `-m <commit_message>` | Commit message | Random words (see below) |
| `-b <branch>` | Target branch to push to | `main` |
| `-h` | Show help dialog | |

### Examples

```bash
# Push current directory to main with a custom message
./git-pusher.sh -m "fix: update config"

# Push a specific project to a specific branch
./git-pusher.sh -p ~/projects/myapp -m "feat: add login page" -b dev

# Let the script generate a random commit message
./git-pusher.sh -p ~/projects/myapp
```

---

## Random Commit Messages

If no `-m` flag is provided, the script fetches a random set of words from the [Random Word API](https://random-word-api.herokuapp.com) and uses them as the commit message. The number of words is randomly chosen between 1 and 10.

---

## Dependencies

Make sure the following are installed and available in your `PATH`:

- [`git`](https://git-scm.com/)
- [`curl`](https://curl.se/)
- [`jq`](https://jqlang.github.io/jq/)
- `shuf` (part of GNU coreutils)

---

## License

This project is licensed under the [MIT License](LICENSE).
