# Contributing guidelines

[[_TOC_]]

## Introduction

Thank you for your interest in contributing to this project. Whether it's a bug report, new feature,
correction or additional documentation, we greatly value feedback and contributions.

Please read through this document before submitting any issues or pull requests to ensure
all the necessary information is included to effectively respond to the bug report or contribution.

## Reporting bugs and suggesting enhancements

When filing an issue, please check existing open, or recently closed, issues to make sure someone
else hasn't already reported it.

Please try to include as much information as you can using the issue form. Details like these are
incredibly useful:

- A reproducible test case or series of steps.
- Any modifications you've made relevant to the bug.
- Anything unusual about your environment or deployment.

## Contributing via pull requests

Contributions using pull requests are appreciated.

To open a pull request, please:

1. Fork the repository.
2. Modify the source; please focus on the **specific** change you are contributing.
3. Ensure local tests pass.
4. Update the documentation, if required.
5. Commit to your fork [using a clear commit messages][git-commit]. Please use [Conventional Commits][conventional-commits].
6. Open a pull request, answering any default questions in the pull request.
7. Pay attention to any automated failures reported in the pull request, and stay involved in the
   conversation.

### Contributor flow

This is a rough outline of the contributor workflow:

- Create a topic branch from where you want to base your work.
- Make commits of logical units.
- Make sure your commit messages are [in the proper format][conventional-commits]
- Push your changes to the topic branch in your fork.
- Submit a pull request. If the pull request is a work in progress, please open as draft.

### Staying in sync with upstream

When your branch gets out of sync with the `main` branch, use the following to
update:

```shell
git checkout feat/foo
git fetch -a
git pull --rebase upstream develop
git push --force-with-lease origin feat/foo
```

### Updating pull requests

If your pull request fails to pass or needs changes based on code review, you'll most likely want to
squash these changes into existing commits.

If your pull request contains a single commit or your changes are related to the most recent commit,
you can simply amend the commit.

```shell
git add .
git commit --amend
git push --force-with-lease origin feat/foo
```

If you need to squash changes into an earlier commit, you can use:

```shell
git add .
git commit --fixup <commit>
git rebase -i --autosquash develop
git push --force-with-lease origin feat/foo
```

Be sure to add a comment to the pull request indicating your new changes are ready to review.

### Formatting commit messages

Follow the conventions on [How to Write a Git Commit Message][git-commit].

Be sure to include any related issue references in the commit message.

## License

See the [LICENSE][license] file for this project's licensing.

[//]: Links
[conventional-commits]: https://www.conventionalcommits.org
[git-commit]: https://cbea.ms/git-commit
[license]: LICENSE
