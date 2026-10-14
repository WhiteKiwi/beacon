# CI verification

Hosted Ubuntu server CI exposes static checks, unit tests, core HTTP component
contracts and the build as named sequential steps. Jest runs with one worker in
normal and focused HTTP suites. No browser, database server or production token is
started by this gate.

The existing `test:e2e` command actually builds an isolated Nest application with
a mocked LocationsService and synthetic authentication inputs. It protects real
router/guard/validation composition, unauthorized-request concealment and the
review endpoint's no-storage boundary. These small hermetic HTTP contracts belong
in CI because unit mocks alone cannot prove module wiring. The workflow names
them as component contracts instead of implying full device/service E2E coverage.

Actual device/browser/production integration runs locally for relevant PR changes.
Record commit, environment, commands, scope, results and untested boundaries in
the PR body/comment. Further integration/race/E2E enters CI only when protected
failure, smaller-test limitations, per-PR automation need and stable isolated cost
justify the minimum scope. Do not add manual Actions as the default substitute.
Diagnose setup, slow tests, build and runner wait before parallelism. iOS/release
acceptance remains separate from the server source gate.
