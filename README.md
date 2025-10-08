# Website

### Dependencies

- built with ghc 9.4.7
- `cabal` (for hakyll)
- `latexmk` (for resume)
- `agda` (for literate agda posts)

### Building

```make posts```

- Generate processed Agda posts

```make files/resume.pdf```

- Generate resume / cv

```make drafts.html```

- Generate list of drafts

```make site```

- Build whole site

### Running

```make watch```

- Run site locally (`localhost:8000`)

### Deploying

```make deploy```

- Pushes to `site` (deploy branch)
