
# Closure Library

This fork of Closure Library is *actively* maintained by the Clojure team and the community.

# Historical note

Google stopped contributing to Closure Library on August 2024. While various reasons are
given, the growing burden of maintaining this project for outside consumers probably weighed
heavily on the decision.

Please see [#1214](https://github.com/google/closure-library/issues/1214) for
more details.

[Previous version of this README can be found here.](https://github.com/google/closure-library/blob/a99c1558bb4cdd342fb36bbf3b9296d61b852c33/README.md)

---

## About this fork (`teehemkay/closure-library`)

This is a downstream-of-Clojure fork of
[clojure/closure-library](https://github.com/clojure/closure-library).
Its purpose is to carry built API docs on the `gh-pages` branch for
consumption by the [Dash docset](https://github.com/tmk/goog-docset).

**Source changes belong upstream.** Open issues and pull requests
against `clojure/closure-library`; this fork's `master` follows that
upstream and adds only the doc-build scaffolding under `scripts/ci/`.

**Refreshing `gh-pages`:**

```
git fetch upstream
git merge --ff-only upstream/master
git push origin master

git worktree add ../closure-library-gh-pages gh-pages
export GH_PAGES=$(realpath ../closure-library-gh-pages)
./scripts/ci/build-docs.sh
./scripts/ci/smoke-docs.sh "$GH_PAGES"
cd "$GH_PAGES" && git push origin gh-pages
```

See `scripts/ci/dossier_readme.md` for toolchain notes.
