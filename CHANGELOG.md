# 1.0.0

- On disk savable added.
- Some apis improves.
- Bug fixes.

# 1.0.4

- License changed from GPL3 to MIT.
- Fix: pub.dev images load problem.
- Improve: trying to increase pub point.

# 1.1.0

- dependsOnAsync.

# 1.1.1

- isCalculating option on dependsOnAsync.

# 1.3.1

- bugfix: prevent updating holden when other calculate is running.
- caching.
- caching expire time.
- add document to readme.

# 1.4.0

- debounce feature added.

# 1.4.2

- performance improve

# 2.0.0

- `watch()` function deprecated.
- `liveWidget()` is new way to make reactive widget.
- `StateLessWidget` now can be used with Telescope.
- Huge performance improvement be removing callbacks from callback list on `Widget.dispose()`

# 2.0.1

- fix: silent error on callback calls
- fix: random id generation (shift operation not gonna work on web)
- fix: better hashCode functions in docs and examples
